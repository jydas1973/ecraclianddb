create or replace package ecra is
--
--
-- ecra_pkg.pls
--
-- Copyright (c) 2002, 2024, Oracle and/or its affiliates. 
--
--    NAME
--      ecra_pkg.pls - ECRA PL/SQL package
--
--    DESCRIPTION
--      Hosts many of the PL/SQL functions to manipulate ECRA db tables
--
--    NOTES
--
--    MODIFIED   (MM/DD/YY)
--    essharm     08/15/24 - 36383801 - HEARTBEAT TRASACTION TO PROACTIVELY
--                           IDENTIFY ISSUES WITH REGION LEVEL RESOURCES
--    byyang      08/03/21 - bug 32932746. create ecs_update_heartbeat
--    byyang      10/05/18 - ER 28731684. Scheduler support for one-off job.
--    nkedlaya    11/20/17 - new function to get the next IB ip address for a
--                           given fabric
--    nkedlaya    10/16/17 - bug 26751817 - compose_cluster for GEN1, HIGGS AND
--                           EXACM
--    nkedlaya    09/22/17 - bug 26578577 - Get rid off the exit statement in
--                           the end
--    nkedlaya    04/28/17 - Bug 25974480 : GEN2 ABILITY TO PICK A CABINET IN
--                           COMPOSE CLUSTER
--    nkedlaya    04/24/17 - Bug 25946435 - delete cabinet feature in bmc
--    nkedlaya    04/06/17 - bug 25839624 : fix mac data mismatch between flat
--                           file loader and cavium ports
--    nkedlaya    03/29/17 - bug 25802231 : ecs_racks.name column update
--                           returns ora-02292
--    nkedlaya    03/28/17 - purging of the clusters
--    nkedlaya    03/26/17 - support for multiple domus on the same node
--    nkedlaya    03/14/17 - bug 25712702 : funcationality to query the
--                           available capacity
--    nkedlaya    03/10/17 - bug 25703206 : compose cluster operations
--    nkedlaya    03/02/17 - Created
--
  -- actions
  gc_commit   constant varchar2(20) := 'COMMIT';
  gc_rollback constant varchar2(20) := 'ROLLBACK';

  -- return status constants
  gc_ok      constant number := 0;
  gc_error   constant number := 1;
  gc_warning constant number := 2;

  -- Record type to pipe JSON rows
  type ecs_json_coll is table of clob;

  -- Record type for cluster information
  type t_cluster_info_record is record
  ( key   varchar2(256)
  , value clob 
  );

  type t_cluster_info_coll is table of t_cluster_info_record;

  -- Cluster info keys
  gc_cluster_info_key_all      constant varchar2(20) := 'ALL';
  gc_cluster_info_key_admin    constant varchar2(20) := 'ADMIN';
  gc_cluster_info_key_client   constant varchar2(20) := 'CLIENT';
  gc_cluster_info_key_cavium   constant varchar2(20) := 'CAVIUM';

  -- IB IP types
  gc_storage_ib  constant varchar2(20) := 'STORAGE_IP';  
  gc_compute_ib  constant varchar2(20) := 'COMPUTE_IP';  
  --
  -- Cluster APIs
  --
  -- 
  -- @Public
  -- Begin a compose cluster action
  --
  function ecs_compose_cluster_begin
  ( p_node_constraint in varchar2,
    p_model           in varchar2,
    p_avail_domin     in varchar2,
    p_how_many        in number default 1,
    p_shared_cluster_name in varchar2 default null,
    p_cabinet_name    in varchar2 default null
  ) return ecs_json_coll pipelined;

  --
  -- @Public
  -- End a compose cluster action
  --
  function ecs_compose_cluster_end
  ( p_node_constraint     in varchar2
  , p_old_ecs_racks_name  in varchar2 -- cluster name given by the ecs_compose_cluster_begin
  , p_new_ecs_racks_name  in varchar2 -- actual/final cluster name
  , p_admin_hostname_list in varchar2 default null
  , p_admin_ip_list   in varchar2     default null
  , p_db_client_mac_list  in varchar2 default null
  , p_db_backup_mac_list  in varchar2 default null
  , p_action              in varchar2 default gc_commit -- Can be 'COMMIT' or 'ROLLBACK'
  ) return ecs_json_coll pipelined;
  
  --
  -- @Public
  -- Get cluster info
  -- Two overloaded functions for the purpose of backward
  -- compatibility
  --
  gc_to_get_all constant varchar2(20)              := 'ALL';
  gc_to_get_caviums constant varchar2(20)          := 'CAVIUMS';
  gc_to_get_orcl_admin constant varchar2(32)       := 'ORCL_ADMIN';
  gc_to_get_client_admin constant varchar2(32)     := 'CLIENT_ADMIN';
  gc_to_get_indx_by_cavimums constant varchar2(32) := 'INDEX_BY_CAVIUMS';

  -- function ecs_get_cluster_info
  -- ( p_ecs_racks_name in varchar2 
  -- , p_what_to_get  in varchar2 default gc_to_get_all 
  --   -- allowed values are gc_to_get_* constants
  -- ) return ecs_json_coll pipelined;

  function ecs_get_cluster_info
  ( p_ecs_racks_name in varchar2 
  ) return t_cluster_info_coll pipelined;
  
  --
  -- @Public
  --
  function ecs_get_available_capacity
  ( p_node_constraint varchar2 default null
  , p_node_model      varchar2 default null
  , p_avail_domin     varchar2 default null
  ) return ecs_json_coll pipelined;

  -- 
  -- @Public
  --
  function ecs_purge_cluster
  ( p_ecs_racks_name in varchar2 )
  return ecs_json_coll pipelined;

  -- 
  -- @Public
  --
  function ecs_delete_cluster
  ( p_ecs_racks_name in varchar2 )
  return ecs_json_coll pipelined;

  -- 
  -- @Public
  --
  function ecs_undo_delete_cluster
  ( p_ecs_racks_name in varchar2 )
  return ecs_json_coll pipelined;

  -- 
  -- @Public
  --
  function ecs_list_clusters
  ( p_avail_domin in varchar2 default null 
  , p_cabinet_name in varchar2 default null 
  ) return ecs_json_coll pipelined;
  
  --
  -- @Public
  -- Change the name of a cluster. This call is there purely to support the
  -- naked UPDATE against the ecs_racks.name. See bug 25802231 for details.
  -- Idea here is to make a PL/SQL function which is going to be called
  -- in the ON UPDATE trigger on the ecs_racks table. That way upper layer
  -- code need not be changed and will remain backward compatible.
  --
  function ecs_update_cluster_name
  ( p_old_ecs_racks_name  in varchar2
  , p_new_ecs_racks_name  in varchar2
  ) return pls_integer;

  --
  -- Cabinet APIs
  --

  --
  -- @ Public
  --
  function ecs_delete_cabinet
  ( p_cabinet_name  in varchar2
  ) return ecs_json_coll pipelined;

  --
  -- @ Public 
  -- Get the next available IB IP info like ip address, subnet mask
  -- Also make sure that the IP do not collide with any existing IPs
  -- in the IB Fabric.
  --
  procedure ecs_get_next_ib_ip_info
  ( p_cabinet_name  in varchar2 default null
  , p_ib_fabric_id  in number   default null
  , p_ib_type       in varchar2 default gc_storage_ib
  , r_ip_address    out varchar2
  , r_subnet_mask   out varchar2
  ) ;

  --
  -- @Public
  -- Update the cavium id and the generated XML with supplied cavium id
  -- 
  function ecs_update_cavium
  ( p_old_cav in varchar2
  , p_new_cav in varchar2
  ) return pls_integer;


  --
  -- Scheduler APIs
  --

  -- @ Public
  -- Move finished one-off job to ecs_scheduledjob_history table.
  -- Implemented as a PL/SQL to support atomic operation of
  -- insert and delete.
  --
  procedure ecs_archive_scheduledjob
  ( p_job_id in number
  , p_type in varchar2
  , p_status in varchar2
  ) ;
  
  --
  -- ECRA LSE APIs
  --
  -- @ Public
  procedure proc_ecs_lse_logging
  ( i_OneView_RequestTime in timestamp
  , i_CP_RequestTime in timestamp
  , i_ECRA_RequestTime in timestamp
  , i_ECRADB_RequestTime in timestamp
  , o_ECRADB_ResponseTime out timestamp
  , o_ECRADB_ERRMSG out varchar2
  );


  --
  -- EcraHeartbeat APIs
  --

  -- @ Public
  -- If now row exists, insert a new one
  -- If row exists and current - max(last_ts) > ecra_heartbeat_timeout, 
  -- create a new row
  -- If row exists and current - max(last_ts) < ecra_heartbeat_timeout, 
  -- update the last row
  --
  procedure ecs_update_ecra_heartbeat
  ( p_ecra_server in varchar2
  ) ;

end ecra;
/
show errors;
