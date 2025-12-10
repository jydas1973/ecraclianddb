create or replace package body ecra is
--
--
-- ecra_pkg.pls
--
-- Copyright (c) 2002, 2025, Oracle and/or its affiliates.
--
--    NAME
--      ecra_pkg.pls - ECRA PL/SQL package body
--
--    DESCRIPTION
--      Hosts many of the PL/SQL functions to manipulate ECRA db tables
--
--    NOTES
--
--    MODIFIED   (MM/DD/YY)
--    zpallare    11/20/25 - Bug 38635603 - EXADBX - Rack ports not working if
--                           admin info is present
--    bhpati      09/04/25 - Bug 36497037 - delete/purge cluster not putting
--                           the respective cells in free state and there is a
--                           rack entry in ecs_racks_name_list
--    caborbon    07/16/25 - ENH 38194675 - Adding Delete statement in delete
--                           cabinet to remove exascale ip pool data
--    essharm     10/22/24 - Bug 37191850 - ECRA PACKAGE CONTAINS COMPILATION
--                           ERRORS
--    rgmurali    08/20/24 - ER 36970851 - Make state handle ids continuous
--    essharm     07/10/24 - Enh 36383801 - HEARTBEAT TRASACTION TO PROACTIVELY
--                           IDENTIFY ISSUES WITH REGION LEVEL RESOURCE
--    kukrakes    01/23/24 - Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA
--                           OPERATIONS FAILING POST PARTITIONING AND ARCHIVING
--                           OF TABLES
--    rgmurali    06/17/23 - ER 35495109 - Automatic unlock on timeout
--    rgmurali    11/09/22 - Bug 34784596 - Placement plan details fix
--    aadavalo    07/19/22 - Enh 34395687 - Change order by clause of
--                           ecs_get_cluster_info
--    rgmurali    01/10/22 - Enh 33739958 - Exacompute minor fixes
--    rgmurali    12/09/21 - ER 33509397 - Chaine state store support
--    byyang      07/29/21 - bug 32932746. scheduledjob add column
--    vmallu      02/18/21 - Bug 32498935 - Delete cabinet failing
--    llmartin    01/04/21 - Enh 32266764 - Update rackports query to get
--                           reserved nodes
--    rgmurali    09/04/20 - ER 31556233 - Put the rack in NEW after compose cluster
--    llmartin    07/21/20 - Bug 31637926 - Rack ports returning incorrect
--                           number of ports
--    vmallu      06/05/20 - Enh 31170751 - COMPOSE CLUSTER TO SUPPORT 
--                           MONITORING BOND
--    vmallu      05/01/20 - BUG 31241682 - ROCE/KVM. AFTER INFO PATCHING, XML
--                           CONTAINS ORIGINAL HOSTNAME IN PRIV NETWORKS.
--    vmallu      04/27/20 - Enh 31171279 - CREATE SECURE FABRIC ENABLED QR AND
--                           HR COMPOSE CLUSTER TEMPLATES FOR ROCE/X8M
--    vmallu      03/24/20 - Enh 31062324 - COMPOSE CLUSTER HW NODES TABLE 
--                           SHOULD CONTAIN ACTUAL RACK NAME
--    vmallu      03/09/20 - Enh 30680917 - SUPPORT DIFFERENT SHAPES IN THE 
--                           SAME CABINET
--    vmallu      05/31/19 - bug 29631598: ATP COMPOSE CLUSTER SUPPORT FOR
--                           CAPACITY CONSOLIDATION.
--    vmallu      05/06/19 - bug 29706888: fix 29625763 compose cluster changes
--    sachikuk    01/16/19 - Bug - 29196255 : Racks monitoring job for ATP pre
--                           prov scheduler
--    mpedapro    01/09/19 - bug 28971555: fix ecs_update_cavium
--    byyang      12/10/18 - Bug 28827692. Handle rackname update for diag
--    byyang      10/05/18 - ER 28731684. Scheduler support for one-off job
--    srtata      05/15/18 - bug 27727580: x7 support debug stmts
--    srtata      04/30/18 - bug 27927643: insert dom0s into ecs_racks
--    srtata      04/25/18 - bug 27697345: change dbms_output for sabre
--    mmsharif    12/20/17 - 27300875 - COMPOSE CLUSTER: CLIENT JSON NEEDS TO
--                           HAVE DISKGROUP IDENTIFIER
--    nkedlaya    12/18/17 - Bug 27283671 - IMPORT FLAT FILE WRONGFULLY ASSIGNS
--                           SAME SET OF IB IPS FOR CLUSTER AND STORAGE
--    nkedlaya    12/06/17 - bug 27216587 - COMPOSE CLUSTER: ADD HIGGS SUPPORT
--    nkedlaya    10/16/17 - bug 26751817 - compose_cluster for GEN1, HIGGS AND
--                           EXACM
--    nkedlaya    09/22/17 - bug 26578577 - Get rid off the exit statement in
--                           the end
--    nkedlaya    09/21/17 - bug 26578577 - CABINETS_N_CLUSTERS_UTIL.PY FAILS
--                           TO COMPOSE CLUSTER PROPERLY
--    nkedlaya    04/28/17 - Bug 25974480 : GEN2 ABILITY TO PICK A CABINET IN
--                           COMPOSE CLUSTER
--    nkedlaya    04/24/17 - Bug 25946435 - delete cabinet feature in bmc
--    nkedlaya    04/21/17 - bug 25933778 - allow cabinet level subnet id in
--                           the bmc
--    nkedlaya    04/14/17 - Bug 25896745 - gen2 cluster info json has
--                           extranious space chars in some keys leading to
--                           failur
--    nkedlaya    04/12/17 - Bug 25883898 - gen2 ecra compose cluster should
--                           use its own node sequence
--    nkedlaya    04/11/17 - bug 25878886: all values in ecs_racks.status are
--                           upper case
--    nkedlaya    04/08/17 - include dom0_oracle_name in the INDEX_BY_CAVIMUS
--                           query
--    nkedlaya    04/06/17 - bug 25839624 : fix mac data mismatch between flat
--                           file loader and cavium ports
--    nkedlaya    03/29/17 - bug 25802231 : ecs_racks.name column update
--                           returns ora-02292
--    nkedlaya    03/28/17 - purging of the clusters
--    nkedlaya    03/26/17 - support for multiple domus on the same node
--    nkedlaya    03/22/17 - ecs_compose_cluster_begin json sholud return the
--                           cluster_size as the input cluster_size
--    nkedlaya    03/20/17 - handle NAT IP from the flat file loaders
--    nkedlaya    03/18/17 - honor the node counts in the
--                           cluster_node_constraint during
--                           compose_cluster_begin
--    nkedlaya    03/14/17 - bug 25712702 : FUNCATIONALITY TO QUERY THE
--                           AVAILABLE CAPACITY
--    nkedlaya    03/11/17 - bug 25703206 : implement compose cluster functions
--    nkedlaya    03/02/17 - Created
--

  -- ecs_hw_nodes.node_state constants
  gc_hw_node_state_free constant varchar2(20) := 'FREE';
  gc_hw_node_state_composing constant varchar2(20) := 'COMPOSING';
  gc_hw_node_state_allocated constant varchar2(20) := 'ALLOCATED';

  -- ecs_racks.status constants
  gc_ecs_racks_status_new   constant varchar2(20) := 'NEW';
  gc_ecs_racks_status_composing constant varchar2(20) := 'COMPOSING';
  gc_ecs_racks_status_ready constant varchar2(20) := 'READY';
  gc_ecs_racks_status_deleted constant varchar2(20) := 'DELETED';
  gc_ecs_racks_status_provisoned constant varchar2(20) := 'PROVISONED';

  -- ecs_hw_nodes.node_type constants
  gc_hw_node_type_compute  constant varchar2(20) := 'COMPUTE';
  gc_hw_node_type_storage  constant varchar2(20) := 'CELL';
  gc_hw_node_type_ibsw     constant varchar2(20) := 'IBSW';
  gc_hw_node_type_rocesw   constant varchar2(20) := 'ROCESW';
  gc_hw_node_type_spinesw  constant varchar2(20) := 'SPINESW';
  gc_hw_node_type_pdu      constant varchar2(20) := 'PDU';
  gc_hw_node_type_ethsw    constant varchar2(20) := 'ETHERSW';

  -- ecs_hw_nodes.cluster_size_constraint constants
  gc_hw_node_cluster_sz_elastic constant varchar2(20) := 'other';

  -- etherface types
  gc_eface_db_client constant varchar2(20) := 'DB_CLIENT';
  gc_eface_db_backup constant varchar2(20) := 'DB_BACKUP';
  gc_eface_orcl_admin constant varchar2(20) := 'ORACLE_ADMIN';
  gc_eface_customer_admin constant varchar2(20) := 'CUSTOMER_ADMIN';

  -- map of custer_size mnemonics(ecs_hw_nodes.cluster_size_constraint) 
  -- to ecs_racks.racksize
  type t_cluster_size_hash is table of varchar2(256) index by varchar2(256);
  gv_cluster_size_hash t_cluster_size_hash;

  -- global variable to diable ecs_racks.name update trigger
  gv_ecs_racks_upd_trig_state varchar2(30);
  gc_ecs_racks_upd_trig_enable constant varchar2(30) := 'ENABLE';
  gc_ecs_racks_upd_trig_disable constant varchar2(30) := 'DISABLE';

  -- JSON keys
  gc_jkey_dom0_oracle_name constant varchar2(64) := '"dom0_oracle_name"';
  gc_jkey_domu_oracle_name constant varchar2(64) := '"domu_oracle_name"';
  gc_jkey_cavium_id constant varchar2(64)        := '"cavium_id"';
  gc_jkey_mac constant varchar2(64)              := '"mac"';
  gc_jkey_hw_node_id constant varchar2(64)       := '"hw_node_id"';
  gc_jkey_etherface constant varchar2(64)        := '"etherface"';
  gc_jkey_etherface_type constant varchar2(64)   := '"etherface_type"';
  gc_jkey_rackname constant varchar2(64)         := '"rackname"';
  gc_jkey_ports constant varchar2(64)            := '"ports"';
  gc_jkey_availability_domain varchar2(64)       := '"availability_domain"';
  gc_jkey_cluster_name   varchar2(64)            := '"cluster_name"';
  gc_jkey_cabinet_name   varchar2(64)            := '"cabinet_name"';

  -- 
  -- alert related constants
  --
  gc_cab_alert_protocol_smtp constant varchar2(16) := 'SMTP';
  gc_cab_alert_protocol_snmp constant varchar2(16) := 'SNMP';

  --
  -- type exceptions
  --
  x_not_enough_values exception;
  pragma exception_init (x_not_enough_values, -20901);
  xn_not_enough_values constant number := -20901;
  xm_not_enough_values constant varchar2(512) :=
    'Input error. Not enough values in';

  x_no_such_orcl_hostname exception;
  pragma exception_init (x_no_such_orcl_hostname, -20902);
  xn_no_such_orcl_hostname constant number := -20902;
  xm_no_such_orcl_hostname constant varchar2(512) :=
    'No such Oracle hostname exist for the hardware nodes';

  x_not_enough_cells exception;
  pragma exception_init (x_not_enough_cells, -20903);
  xn_not_enough_cells constant number := -20903;
  xm_not_enough_cells constant varchar2(256) := 
    'Not enough cell nodes to carve a cluster';

  x_not_enough_computes exception;
  pragma exception_init (x_not_enough_computes, -20904);
  xn_not_enough_computes constant number := -20904;
  xm_not_enough_computes constant varchar2(256) := 
    'Not enough compute nodes to carve a cluster';

  x_no_such_cluster exception;
  pragma exception_init (x_no_such_cluster, -20905);
  xn_no_such_cluster constant number := -20905;
  xm_no_such_cluster constant varchar2(512) := 
    'No such cluster exists';
  
  x_clu_config_mismatch exception;
  pragma exception_init (x_clu_config_mismatch, -20906);
  xn_clu_config_mismatch constant number := -20906;
  xm_clu_config_mismatch constant varchar2(512) :=
    'Cluster configuration do not match with node count constraints';

  x_no_such_vcn exception;
  pragma exception_init (x_no_such_vcn, -20907);
  xn_no_such_vcn constant number := -20907;
  xm_no_such_vcn constant varchar2(512) :=
    'VCN not found in the given AD';

  x_clu_under_purge exception;
  pragma exception_init (x_clu_under_purge, -20908);
  xn_clu_under_purge constant number := -20908;
  xm_clu_under_purge constant varchar2(512) :=
    'Cluster is under purging schedule';

  x_clu_exists exception;
  pragma exception_init (x_clu_exists, -20909);
  xn_clu_exists constant number := -20909;
  xm_clu_exists constant varchar2(512) :=
    'Cluster already exists';

  x_node_not_in_cluster exception;
  pragma exception_init (x_node_not_in_cluster, -20910);
  xn_node_not_in_cluster constant number := -20910;
  xm_node_not_in_cluster constant varchar2(512) :=
    'No such node belongs to the cluster';

  x_cluster_not_on_cabinet exception;
  pragma exception_init (x_cluster_not_on_cabinet, -20911);
  xn_cluster_not_on_cabinet constant number := -20911;
  xm_cluster_not_on_cabinet constant varchar2(512) :=
    'Cluster not on the cabinet';

  x_cluster_not_composing exception;
  pragma exception_init (x_cluster_not_composing, -20912);
  xn_cluster_not_composing constant number := -20912;
  xm_cluster_not_composing constant varchar2(512) :=
    'Cluster is not in COMPOSING state';

  x_no_cabinet exception;
  pragma exception_init (x_no_cabinet, -20913);
  xn_no_cabinet constant number := -20912;
  xm_no_cabinet constant varchar2(512) :=
    'No such cabinet';

  x_no_ibfabric exception;
  pragma exception_init (x_no_ibfabric, -20914);
  xn_no_ibfabric constant number := -20912;
  xm_no_ibfabric constant varchar2(512) :=
    'No such IB Fabric';

  x_bogus_data exception;
  pragma exception_init (x_bogus_data, -20999);
  xn_bogus_data constant number := -20999;
  xm_bogus_data constant varchar2(512) := 'Bogus data';

  --
  -- @Private
  --
  function split_str
  ( p_string        in varchar2
  , p_delimiter     in varchar2
  ) return dbms_sql.varchar2_table is
    l_bigstr    varchar2(30000);
    l_smlstr    varchar2(30000);
    l_idx       pls_integer;
    l_array_idx pls_integer := 0;
    l_string_coll dbms_sql.varchar2_table;
  begin
    --
    -- parse the input line to extract path info
    --
    l_bigstr := p_string;
    loop
      exit when l_bigstr is null;
      l_idx := instr( l_bigstr, p_delimiter);
      if l_idx = 0 then
        l_smlstr:= l_bigstr;
      else
        l_smlstr:= substr( l_bigstr, 1, l_idx - 1 );
        l_bigstr:= substr( l_bigstr, l_idx + 1 );
      end if;
      if l_smlstr is not null then
        l_array_idx := l_array_idx + 1;
        l_string_coll(l_array_idx) := l_smlstr;
      end if;
      exit when l_idx = 0;
    end loop;
    return l_string_coll;
  end split_str;

  --
  -- @private
  -- 
  function generate_mac
  return varchar2 is
  begin
    --borrowed from https://www.centos.org/docs/5/html/5.2/Virtualization/sect-Virtualization-Tips_and_tricks-Generating_a_new_unique_MAC_address.html
    return '00:16:3e:'
           ||to_char(round(dbms_random.value(0, 127)), 'FM0x')
           ||':'
           ||to_char(round(dbms_random.value(0,255)), 'FM0x')
           ||':'
           ||to_char(round(dbms_random.value(0,255)),'FM0x');
  end generate_mac;

  --
  -- @private
  --
  function generate_host_name
  ( p_cabinet_name in varchar2
  , p_product      in varchar2
  , p_node_type    in varchar2
  , p_node_order   in varchar2
  , p_domu_number  in varchar2 default null
  ) return varchar2 is
  begin
    --
    -- various hostname conventions are gotten from
    -- https://confluence.oraclecorp.com/confluence/display/DBCSGEN2/Naming+Convention
    --
    if (p_domu_number is null) then
      return    lower(p_cabinet_name)
             || lower(p_product)
             || lower(p_node_type)
             || to_char(p_node_order, 'FM09');
    else
      return    lower(p_cabinet_name)
             || lower(p_product)
             || lower(p_node_type)
             || to_char(p_node_order, 'FM09')
             || to_char(p_domu_number, 'FM09');
    end if;
  end;

  --
  -- @Private
  -- 
  function generate_ecs_racks_name
  ( p_cabinet_name in varchar2
  , p_cluster_hw_id in number
  ) return varchar2 is
  begin
    return lower(p_cabinet_name)||'_cluster_name_'||
           p_cluster_hw_id;
  end generate_ecs_racks_name;

  --
  -- @Private: generate the BMC ecs_racks_name accroding
  --           to the BMC naming conventions
  -- 
  function generate_bmc_ecs_racks_name
  ( p_temp_ecs_racks_name in varchar2
  ) return varchar2 is 
    l_cab_id   ecs_hw_cabinets.id%type;
    l_cab_info ecs_hw_cabinets%rowtype;
    l_ecs_racks_name ecs_racks.name%type := null;
    l_hw_node_id ecs_hw_nodes.id%type := null;
    l_domu_count pls_integer := 1;
  begin
    dbms_output.put_line('generate_bmc_ecs_racks_name {ENTER');

    for node_rec in (
      select min(ehn.cabinet_id) cab_id, 
             min(node_type_order_bottom_up) min_node, 
             max(node_type_order_bottom_up) max_node, 
             min(ehn.node_type) node_type,
             min(ehn.id) hw_id
      from ecs_hw_nodes ehn
      where regexp_like(ecs_racks_name_list, ','||
                        p_temp_ecs_racks_name||',', 'i')
      and   ehn.node_type in (gc_hw_node_type_compute, 
                              gc_hw_node_type_storage)
      group  by ehn.node_type) loop

      begin
        select * into l_cab_info
        from   ecs_hw_cabinets
        where  id = node_rec.cab_id;
      exception
        when no_data_found then
          dbms_output.put_line('generate_bmc_ecs_racks_name: no cabinet '||
                               'hosts the cluster '||p_temp_ecs_racks_name);
          return null;
      end;
   
      if (node_rec.node_type = gc_hw_node_type_compute) then
        l_ecs_racks_name := 'd0-'
                            ||trim(to_char(node_rec.min_node,'09'))
                            ||'-'
                            ||trim(to_char(node_rec.max_node,'09'))
                            ||l_ecs_racks_name;
      elsif (node_rec.node_type = gc_hw_node_type_storage) then
        l_ecs_racks_name := l_ecs_racks_name||'-cl-'
                            ||trim(to_char(node_rec.min_node,'09'))
                            ||'-'
                            ||trim(to_char(node_rec.max_node,'09'));
      end if;

      l_hw_node_id := node_rec.hw_id;

    end loop;

    l_ecs_racks_name := lower(l_cab_info.name)||lower(l_cab_info.product)
                        ||'-'||l_ecs_racks_name;

    select count(hw_node_id) into l_domu_count
    from   ecs_domus 
    where  hw_node_id = l_hw_node_id;
    
    if (l_domu_count = 0) then
      l_domu_count := l_domu_count + 1;
    end if;
   
    l_ecs_racks_name := l_ecs_racks_name||'-clu'
                        ||trim(to_char(l_domu_count,'09'));

    dbms_output.put_line('generate_bmc_ecs_racks_name EXIT}');

    return l_ecs_racks_name;
  end generate_bmc_ecs_racks_name;
  

  --
  -- @Private forward declaration
  -- 
  procedure ecs_gen_cluster_admin_info
  ( p_ecs_racks_name in     varchar2
  , p_node_constraint     in varchar2 default null
  , r_admin_info     in out t_cluster_info_record
  );

  --
  -- @Private. given a cluster name, get the cabinet's
  --  genaration type
  --
  function ecs_get_cab_generation_type
  ( p_ecs_racks_name  in varchar2
  ) return ecs_hw_cabinets.generation_type%type is
    l_cab_generation_type ecs_hw_cabinets.generation_type%type := null;
    l_cab_id              ecs_hw_nodes.cabinet_id%type;
  begin
    dbms_output.put_line('ecs_get_cab_generation_type {ENTER');
    begin
      select ehn.cabinet_id into l_cab_id
      from   ecs_hw_nodes ehn, ecs_domus ed
      where  ed.hw_node_id = ehn.id
      and    ed.ecs_racks_name = p_ecs_racks_name
      and    rownum < 2;
    exception
      when no_data_found then
        dbms_output.put_line('ecs_get_cab_generation_type: no such cluster '||
                             p_ecs_racks_name);
        return l_cab_generation_type;
    end;

    begin
      select generation_type into l_cab_generation_type
      from   ecs_hw_cabinets
      where  id = l_cab_id;
    exception
      when no_data_found then
        dbms_output.put_line('ecs_get_cab_generation_type: no cabinet '||
                             'hosts the cluster '||p_ecs_racks_name);
        return l_cab_generation_type;
    end;

    dbms_output.put_line('ecs_get_cab_generation_type EXIT}');    
    return l_cab_generation_type;
  end ecs_get_cab_generation_type;

  --
  -- @Private
  -- Helper function for ecs_compose_cluster_begin to pick the
  -- the right cabinet to carve out the cluster
  --
  function ecs_cc_pick_cabinet
  ( p_node_constraint     in varchar2 default null, 
    p_model               in varchar2 default null,
    p_avail_domin         in varchar2 default null,
    p_shared_cluster_name in varchar2 default null,
    p_cabinet_name        in varchar2 default null,
    r_cabinet_info        out ecs_hw_cabinets%rowtype,
    r_sharing_or_not      out pls_integer
  ) return pls_integer is
    l_cabinet_id   ecs_hw_cabinets.id%type;        
    l_cell_count    number;
    l_compute_count number;
    l_node_constraint_regex varchar2(256);
  begin
    dbms_output.put_line('ecs_cc_pick_cabinet {ENTER');
    --
    -- Pick the right cabinet where we want to carve out the cluster.
    -- How: If user provided the cabinet, pick that cabinet
    --      If user specified shared clustername, use the cabinet where
    --      that cluster exists.
    --      Else, find the first available cabinet that suits the requirement.
    --      All the while stick to the given availability_domain
    -- 
    l_cell_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)cell',1,1,'i',1);
    l_compute_count:= REGEXP_SUBSTR(p_node_constraint, '(\d+)comp',1,1,'i',1) ;
    l_node_constraint_regex := '^'||l_cell_count||'cell'||l_compute_count||'comp';

    if (p_cabinet_name is not null and p_shared_cluster_name is not null) then
      -- shared cluster should be on the given cabinet name. else, error
      select * into r_cabinet_info
      from  ecs_hw_cabinets
      where name = p_cabinet_name
      and   availability_domain = p_avail_domin;

      select cabinet_id into l_cabinet_id
      from   ecs_hw_nodes 
      where  regexp_like(ecs_racks_name_list, ','||
                         p_shared_cluster_name||',', 'i')
      and    rownum < 2;

      if (l_cabinet_id != r_cabinet_info.id) then
          raise_application_error(xn_cluster_not_on_cabinet, 
            xm_cluster_not_on_cabinet||' ('||p_shared_cluster_name||
            ' '|| p_cabinet_name||')');
      end if;
      r_sharing_or_not := 1;
    elsif (p_cabinet_name is not null and p_shared_cluster_name is null) then
      select * into r_cabinet_info
      from  ecs_hw_cabinets
      where name = p_cabinet_name 
      and   availability_domain = p_avail_domin;
      r_sharing_or_not := 0;
    elsif (p_cabinet_name is null and p_shared_cluster_name is not null) then
      select cabinet_id into l_cabinet_id
      from   ecs_hw_nodes 
      where  regexp_like(ecs_racks_name_list, ','||
                         p_shared_cluster_name||',', 'i')
      and    rownum < 2;

      select * into r_cabinet_info
      from  ecs_hw_cabinets
      where id = l_cabinet_id
      and   availability_domain = p_avail_domin;
      r_sharing_or_not := 1;
    else
      select cabid into l_cabinet_id
      from (
        select min(cabinet_id) cabid
        from ecs_hw_nodes ehn, ecs_hw_cabinets ehc
        where  node_type = gc_hw_node_type_storage
        and  node_state = gc_hw_node_state_free
        and  ehc.id = ehn.cabinet_id
        and  ehc.availability_domain = p_avail_domin
        group by ehn.cabinet_id, ehn.node_type 
        having count(node_type) >= l_cell_count
        UNION
        select min(ehn.cabinet_id) cabid
        from ecs_hw_nodes ehn, ecs_hw_cabinets ehc
        where  ehn.node_type = gc_hw_node_type_compute
        and  ehn.node_state = gc_hw_node_state_free
        and  ehc.id = ehn.cabinet_id
        and  ehc.availability_domain = p_avail_domin
        group by ehn.cabinet_id, ehn.node_type 
        having count(node_type) >= l_compute_count
      ) where rownum < 2;

      select * into r_cabinet_info
      from  ecs_hw_cabinets
      where id = l_cabinet_id;

      r_sharing_or_not := 0;
      dbms_output.put_line('No cabinet, No shared cluster name. Composing cluster'
                           ||' on '||r_cabinet_info.name);
    end if;
     
    dbms_output.put_line('ecs_cc_pick_cabinet EXIT}');
    return gc_ok;
  end ecs_cc_pick_cabinet;

  -- 
  -- @Public
  -- Begin a compose cluster action
  --
  function ecs_compose_cluster_begin 
  ( p_node_constraint     in varchar2, 
    p_model               in varchar2,
    p_avail_domin         in varchar2,
    p_how_many            in number default 1,
    p_shared_cluster_name in varchar2 default null,
    p_cabinet_name        in varchar2 default null
  ) return ecs_json_coll pipelined
  is
    pragma AUTONOMOUS_TRANSACTION;
    l_cell_count    number;
    l_compute_count number;
    l_ibsw_count    number;
    l_rocesw_count  number;
    l_pdu_count     number;
    l_ethsw_count   number;
    l_cabinet_id    ecs_hw_cabinets.id%type;
    l_ib_fabric_id  ecs_ib_fabrics.id%type;
    l_sw_type       ecs_ib_fabrics.sw_type%type;
    l_cluster_hw_id number := ecs_hw_nodes_seq_clu_hw_id.nextval;
    l_vcn_id        ecs_vcns.id%type := null;
    l_vcn_subnet    ecs_vcns.subnet_id%type := null;
    l_cab_subnet    ecs_hw_cabinets.subnet_id%type := null;
    l_vcn_subnet_array dbms_sql.varchar2_table;
    l_dns_array        dbms_sql.varchar2_table;
    l_ntp_array        dbms_sql.varchar2_table;
    l_gateway_array    dbms_sql.varchar2_table;
    l_node_type_coll   dbms_sql.varchar2_table;

    l_storage_pkey ecs_ib_pkeys_used.pkey%type;    
    l_row             clob;

    l_hw_node_id_coll dbms_sql.number_table;
    l_hw_node_id      ecs_hw_nodes.id%type;
    l_tdomus_info     ecs_temp_domus%rowtype;
    l_cabinet_info    ecs_hw_cabinets%rowtype;

    l_idx             pls_integer;
    l_idx1            pls_integer;
    l_ecs_racks_name  ecs_racks.name%type;
    l_node_constraint_regex varchar2(256);
    l_is_under_purge  number;    
    l_domu_count      number := 0;
    l_node_type       ecs_hw_nodes.node_type%type;
    l_bottom_up_order ecs_hw_nodes.node_type_order_bottom_up%type;
    l_db_client_mac   ecs_domus.db_client_mac%type;
    l_db_backup_mac   ecs_domus.db_backup_mac%type;
    l_admin_nat_host_name ecs_domus.admin_host_name%type;

    l_share_cabinet   pls_integer := 0;
    l_rc   pls_integer := gc_ok;

    l_cluster_admin_info  t_cluster_info_record;
    l_ib_domain           varchar2(64) := 'localdomain';
    l_stib_ip_1           varchar2(256) := null;
    l_stib_ip_netmask_1   varchar2(256) := null;
    l_stib_host_name_1    varchar2(256) := null;
    l_stib_ip_2           varchar2(256) := null;
    l_stib_ip_netmask_2   varchar2(256) := null;
    l_stib_host_name_2    varchar2(256) := null;
    l_cib_ip_1           varchar2(256) := null;
    l_cib_ip_netmask_1   varchar2(256) := null;
    l_cib_host_name_1    varchar2(256) := null;
    l_cib_ip_2           varchar2(256) := null;
    l_cib_ip_netmask_2   varchar2(256) := null;
    l_cib_host_name_2    varchar2(256) := null;

    type t_generic_crsr is ref cursor;
    lc_carve_comp_crsr t_generic_crsr;
    lc_carve_cell_crsr t_generic_crsr;
    dom0_names VARCHAR2(512) := null; -- bug27927643
  begin

    dbms_output.put_line('ecs_compose_cluster_begin {ENTER');
    dbms_output.put_line('p_node_constraint = '||p_node_constraint);

    l_cell_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)cell',1,1,'i',1);
    l_compute_count:= REGEXP_SUBSTR(p_node_constraint, '(\d+)comp',1,1,'i',1) ;
    l_ibsw_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)ibsw',1,1,'i',1) ;
    l_rocesw_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)rocesw',1,1,'i',1) ;
    l_pdu_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)pdu',1,1,'i',1);
    l_ethsw_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)ethsw',1,1,'i',1);
    l_node_constraint_regex := '^'||l_cell_count||'cell'||l_compute_count||'comp';
  
    dbms_output.put_line(l_cell_count ||' '||l_compute_count||' '||
                         l_ibsw_count ||' '||l_rocesw_count ||' '||
                         l_pdu_count||' '|| l_ethsw_count||' '||
                         l_cluster_hw_id||' '|| l_node_constraint_regex);
    dbms_output.put_line('p_cabinet_name = '||p_cabinet_name||
                         ' p_shared_cluster_name = '||p_shared_cluster_name);

    -- pick a right cabinet
    l_rc := ecs_cc_pick_cabinet
    ( p_node_constraint, p_model, p_avail_domin, p_shared_cluster_name, 
      p_cabinet_name, l_cabinet_info , l_share_cabinet);

    -- select the ib_fabric_id
    select ib_fabric_id into l_ib_fabric_id
    from ecs_hw_nodes
    where cabinet_id = l_cabinet_info.id and rownum<2;

    -- check the sw_type from ecs_ib_fabrics to find if it's rocesw or ibsw
    select sw_type into l_sw_type
    from ecs_ib_fabrics
    where id = l_ib_fabric_id;

    if (l_cabinet_info.generation_type = 'BMC') then
      l_ecs_racks_name := generate_ecs_racks_name
        (l_cabinet_info.name, l_cluster_hw_id);
    else
      -- if the cabinet is not BMC, get the cluster name from
      -- ecs_domus. Because flat file loader already have put
      -- that data in.
      begin
        if (l_share_cabinet = 0) then
          select name into l_ecs_racks_name
          from (select er.name 
                from  ecs_domus ed, ecs_racks er, ecs_hw_nodes ehn
                where er.name       = ed.ecs_racks_name
                and   ed.hw_node_id = ehn.id
                and   ehn.node_type = gc_hw_node_type_compute
                and   er.status     = gc_ecs_racks_status_new
                and   ehn.cabinet_id = l_cabinet_info.id
                and   ehn.node_state = gc_hw_node_state_allocated
                order by ehn.node_type_order_bottom_up asc, er.name)
          where   rownum < 2;
        else
          -- select hw_node_id into l_hw_node_id
          -- from   ecs_domus
          -- where  ecs_racks_name = p_shared_cluster_name
          -- and    rownum < 2;

          -- for clu_rec in 
          -- ( select ecs_racks_name from ecs_racks where hw_node_id = l_hw_node_id
          --   order by ecs_racks_name
          -- ) loop
          --   l_ecs_racks_name := null;
          --   begin
          --     select name into l_ecs_racks_name
          --     from   ecs_racks
          --     where  name = clu_rec.ecs_racks_name
          --     and    status = gc_ecs_racks_status_new;
          --     exit;
          --   exception
          --     when no_data_found then
          --       null;
          --   end;
          -- end loop;

          select ecs_racks_name into l_ecs_racks_name
          from (
                select ecs_racks_name
                from   ecs_domus, ecs_racks
                where  hw_node_id = (select hw_node_id
                                     from ecs_domus
                                     where ecs_racks_name = p_shared_cluster_name
                                     and rownum < 2)
                and  name            = ecs_racks_name
                and  status          = gc_ecs_racks_status_new
                order by ecs_racks_name)
          where rownum < 2;
        end if;
      exception
        when no_data_found then
          raise_application_error(xn_not_enough_computes, 
            xm_not_enough_computes||' from cabinet '||l_cabinet_info.name);
      end;
    end if;
    dbms_output.put_line('ecs_racks_name = '||l_ecs_racks_name ||
                         ' cabinet_name = '||l_cabinet_info.name);

    if (l_share_cabinet = 0) then
      begin
        -- First pick the CELL rows while setting state to FORMING  
        if (l_cabinet_info.generation_type = 'BMC') then
          for rec in (select id, rownum from
                       (select id from ecs_hw_nodes ehn
                        where ehn.cabinet_id = l_cabinet_info.id
                        and   node_type = gc_hw_node_type_storage
                        and   node_state = gc_hw_node_state_free
                        order by ehn.location_rackunit asc)
                      where rownum <= l_cell_count) loop
  
            update ecs_hw_nodes ehn 
            set node_state = gc_hw_node_state_composing, 
                ecs_racks_name_list = ecs_racks_name_list||','||
                                      l_ecs_racks_name||','
            where  ehn.cabinet_id    = l_cabinet_info.id
            and    ehn.id = rec.id;
  
            l_hw_node_id_coll(rec.id) := rec.id;
  
            dbms_output.put_line('inserting STORAGE data');  
          end loop;
        else
          for rec in (select id, rownum from
                       (select id from ecs_hw_nodes ehn
                        where ehn.cabinet_id = l_cabinet_info.id
                        and   node_type = gc_hw_node_type_storage
                        -- and   node_state = gc_hw_node_state_free
                        and regexp_like(ecs_racks_name_list, ','||
                                        l_ecs_racks_name||',', 'i')
                        order by ehn.location_rackunit asc)
                      where rownum <= l_cell_count) loop
  
            update ecs_hw_nodes ehn 
            set node_state = gc_hw_node_state_composing, 
                ecs_racks_name_list = ecs_racks_name_list||','||
                                      l_ecs_racks_name||','
            where  ehn.cabinet_id    = l_cabinet_info.id
            and    ehn.id = rec.id;
  
            l_hw_node_id_coll(rec.id) := rec.id;
  
            dbms_output.put_line('inserting STORAGE data');  
          end loop;
        end if;
        dbms_output.put_line('inserted STORAGE data');  
  
        -- check if we got enough cells, if not, revert back and error out
        if (l_hw_node_id_coll.count >= 0 and 
            l_hw_node_id_coll.count < l_cell_count) then
          raise_application_error(xn_not_enough_cells, 
                xm_not_enough_cells||' from cabinet '||l_cabinet_info.name);
        end if;
    
        -- Second pick the COMPUTE rows while setting state to FORMING  
        if (l_cabinet_info.generation_type != 'BMC') then
          for rec in (select id, oracle_hostname, node_type_order_bottom_up 
                      from
                       (select id, oracle_hostname, node_type_order_bottom_up
                        from   ecs_hw_nodes ehn
                        where ehn.cabinet_id = l_cabinet_info.id
                        and   node_type = gc_hw_node_type_compute
                        and regexp_like(ecs_racks_name_list, ','||
                                        l_ecs_racks_name||',', 'i')
                        -- and   node_state = gc_hw_node_state_free
                        order by ehn.location_rackunit asc) 
                      where rownum <= l_compute_count) loop
      
            update ecs_hw_nodes ehn 
            set node_state = gc_hw_node_state_composing , 
                ecs_racks_name_list = ecs_racks_name_list||','||
                                      l_ecs_racks_name||','
            where ehn.cabinet_id = l_cabinet_info.id
            and   ehn.id = rec.id;
  
            l_hw_node_id_coll(rec.id) := rec.id;
            dom0_names := dom0_names || rec.oracle_hostname;
  
            dbms_output.put_line('inserting COMP data for non-BMC');  
          end loop;
        else
          for rec in (select id, oracle_hostname, node_type_order_bottom_up 
                      from
                       (select id, oracle_hostname, node_type_order_bottom_up
                        from   ecs_hw_nodes ehn
                        where ehn.cabinet_id = l_cabinet_info.id
                        and   node_type = gc_hw_node_type_compute
                        and   node_state = gc_hw_node_state_free
                        order by ehn.location_rackunit asc) 
                      where rownum <= l_compute_count) loop
      
            update ecs_hw_nodes ehn 
            set node_state = gc_hw_node_state_composing , 
                ecs_racks_name_list = ecs_racks_name_list||','||
                                      l_ecs_racks_name||','
            where ehn.cabinet_id = l_cabinet_info.id
            and   ehn.id = rec.id;
  
            l_hw_node_id_coll(rec.id) := rec.id;
            dom0_names := dom0_names || rec.oracle_hostname;
  
            dbms_output.put_line('inserting COMP data for BMC');  
  
            -- create ecs_domus entries for BMC
            -- if ecs_temp_domus entry exists, take everything from there
            -- Because there is a possibility of the data uploaded by flat file
            -- else, create our own
            begin
              dbms_output.put_line('looking for rec.id = ' || rec.id);  
              select * into l_tdomus_info 
              from ecs_temp_domus where hw_node_id = rec.id;
              dbms_output.put_line('l_tdomus_info.admin_nat_ip = ' ||
                l_tdomus_info.admin_nat_ip);
              insert into ecs_domus 
              (ecs_racks_name, hw_node_id, admin_ip, admin_host_name,
               db_client_mac, db_backup_mac 
              )
              values
              (l_ecs_racks_name, rec.id, l_tdomus_info.admin_nat_ip, 
               l_tdomus_info.admin_nat_host_name, l_tdomus_info.db_client_mac,
               l_tdomus_info.db_backup_mac
              ) 
              returning admin_host_name into l_admin_nat_host_name;
            exception
              when no_data_found then
                dbms_output.put_line('No data found for ecs_domus');  
                l_db_client_mac := generate_mac();
                l_db_backup_mac := generate_mac();
                l_admin_nat_host_name := generate_host_name
                  (l_cabinet_info.name, l_cabinet_info.product
                  , 'du', rec.node_type_order_bottom_up, 1);
                insert into ecs_domus
                (ecs_racks_name, hw_node_id, admin_ip, admin_host_name
                ,db_client_mac, db_backup_mac
                )
                values
                (l_ecs_racks_name, rec.id, null, 
                 l_admin_nat_host_name, l_db_client_mac,
                 l_db_backup_mac
                );
            end;
            dbms_output.put_line('Updating domus with IB info');
            -- fill up the IB info
            ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                     gc_storage_ib, l_stib_ip_1,
                                     l_stib_ip_netmask_1);
            ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                     gc_storage_ib, l_stib_ip_2,
                                     l_stib_ip_netmask_2);

            ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                     gc_compute_ib, l_cib_ip_1,
                                     l_cib_ip_netmask_1);
            ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                     gc_compute_ib, l_cib_ip_2,
                                     l_cib_ip_netmask_2);
            dbms_output.put_line(l_cabinet_info.name||' stib = '||
                                 l_stib_ip_1 || ' '||l_stib_ip_2||chr(10)||
                                 'clib = '||l_cib_ip_1||' '||l_cib_ip_2);

                l_cib_host_name_1  := l_admin_nat_host_name;
                l_cib_host_name_2  := l_admin_nat_host_name;
                l_stib_host_name_1 := l_admin_nat_host_name;
                l_stib_host_name_2 := l_admin_nat_host_name;


            if (l_sw_type = gc_hw_node_type_ibsw ) then
                l_cib_host_name_1  := l_admin_nat_host_name||'-clib0';
                l_cib_host_name_2  := l_admin_nat_host_name||'-clib1';
                l_stib_host_name_1 := l_admin_nat_host_name||'-stib0';
                l_stib_host_name_2 := l_admin_nat_host_name||'-stib1';
            elsif (l_sw_type = gc_hw_node_type_rocesw ) then
                l_cib_host_name_1  := l_admin_nat_host_name||'-clre0';
                l_cib_host_name_2  := l_admin_nat_host_name||'-clre1';
                l_stib_host_name_1 := l_admin_nat_host_name||'-stre0';
                l_stib_host_name_2 := l_admin_nat_host_name||'-stre1';
            end if;
            
            update ecs_domus set
               compute_ib1_ip = l_cib_ip_1,
               compute_ib1_host_name  = l_cib_host_name_1,
               compute_ib1_netmask    = l_cib_ip_netmask_1,
               compute_ib1_domianname = l_ib_domain,
               compute_ib2_ip = l_cib_ip_2,
               compute_ib2_host_name  = l_cib_host_name_2,
               compute_ib2_netmask    = l_cib_ip_netmask_2,
               compute_ib2_domianname = l_ib_domain,
               storage_ib1_ip = l_stib_ip_1,
               storage_ib1_host_name  = l_stib_host_name_1, 
               storage_ib1_netmask    = l_stib_ip_netmask_1,
               storage_ib1_domianname = l_ib_domain,
               storage_ib2_ip = l_stib_ip_2,
               storage_ib2_host_name  = l_stib_host_name_2, 
               storage_ib2_netmask    = l_stib_ip_netmask_2,
               storage_ib2_domianname = l_ib_domain
            where  ecs_racks_name = l_ecs_racks_name
            and    hw_node_id     = rec.id;
          end loop;
        end if;
        dbms_output.put_line('inserted COMP data');  
    
        -- check if we got enough computes, if not, revert back and error out
        if (l_hw_node_id_coll.count >= 0 and
            l_hw_node_id_coll.count < l_cell_count + l_compute_count) then
          raise_application_error(xn_not_enough_computes, 
                xm_not_enough_computes||' from cabinet '||l_cabinet_info.name);
        end if;
    
        -- Rest of the rows
        for rec in (select * from   ecs_hw_nodes ehn
                    where ehn.cabinet_id = l_cabinet_info.id
                    and   (rownum <= l_ibsw_count
                    or    rownum <= l_rocesw_count) 
                    and   (node_type = gc_hw_node_type_ibsw
                    or    node_type = gc_hw_node_type_rocesw)
                    order by ehn.node_type_order_bottom_up asc) loop

          update ecs_hw_nodes ehn 
          set node_state = gc_hw_node_state_composing , 
              ecs_racks_name_list = ecs_racks_name_list||','||
                                    l_ecs_racks_name||','
          where ehn.cabinet_id = l_cabinet_info.id
          and   ehn.id = rec.id;

          l_hw_node_id_coll(rec.id) := rec.id;

          dbms_output.put_line('inserting IBSW data');  
        end loop;
        dbms_output.put_line('inserted IBSW data');  
      end;  
    else
      -- get the node info of the cluster which we are going to share
      dbms_output.put_line('Sharing cluster');

      select id, node_type 
      bulk collect into l_hw_node_id_coll, l_node_type_coll
      from   ecs_hw_nodes 
      where  cabinet_id = l_cabinet_info.id
      and    regexp_like(ecs_racks_name_list, ','||p_shared_cluster_name||',')
      and    node_type != gc_hw_node_type_pdu
      order  by node_type, node_type_order_bottom_up;

      if (l_hw_node_id_coll.count = 0 ) then
        raise_application_error(xn_no_such_cluster, 
                                xm_no_such_cluster||' '||p_shared_cluster_name);
      elsif(l_hw_node_id_coll.count < 
            l_cell_count + l_compute_count) then
        raise_application_error(xn_clu_config_mismatch, 
          xm_clu_config_mismatch||' for cluser_name = '||p_shared_cluster_name||
          ' node_constraint = '||p_node_constraint);      
      end if;

      l_idx := l_hw_node_id_coll.first;
      while (l_idx is not null) loop
        update ecs_hw_nodes 
        set ecs_racks_name_list = ecs_racks_name_list||','||
                                  l_ecs_racks_name||','
        where id = l_hw_node_id_coll(l_idx)
        returning node_type, node_type_order_bottom_up 
        into l_node_type, l_bottom_up_order;

        -- create ecs_domus entry for the computes for BMC cabinet
        if (l_cabinet_info.generation_type = 'BMC' and
            l_node_type = gc_hw_node_type_compute) then
          select count(hw_node_id) into l_domu_count
          from ecs_domus 
          where hw_node_id = l_hw_node_id_coll(l_idx);

          -- for shared cluster we generate MAC for db_client_mac and
          -- db_backup_mac. 
          l_db_client_mac := generate_mac();
          l_db_backup_mac := generate_mac();
          l_admin_nat_host_name := 
            generate_host_name (l_cabinet_info.name, l_cabinet_info.product,
                              'du', l_bottom_up_order, l_domu_count+1);
          ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                   gc_storage_ib, l_stib_ip_1,
                                   l_stib_ip_netmask_1);
          ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                   gc_storage_ib, l_stib_ip_2,
                                   l_stib_ip_netmask_2);

          ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                   gc_compute_ib, l_cib_ip_1,
                                   l_cib_ip_netmask_1);
          ecs_get_next_ib_ip_info (l_cabinet_info.name, null, 
                                   gc_compute_ib, l_cib_ip_2,
                                   l_cib_ip_netmask_2);
          l_cib_host_name_1  := l_admin_nat_host_name;
          l_cib_host_name_2  := l_admin_nat_host_name;
          l_stib_host_name_1 := l_admin_nat_host_name;
          l_stib_host_name_2 := l_admin_nat_host_name;

          if (l_sw_type = gc_hw_node_type_ibsw ) then
              l_cib_host_name_1  := l_admin_nat_host_name||'-clib0';
              l_cib_host_name_2  := l_admin_nat_host_name||'-clib1';
              l_stib_host_name_1 := l_admin_nat_host_name||'-stib0';
              l_stib_host_name_2 := l_admin_nat_host_name||'-stib1';
          elsif (l_sw_type = gc_hw_node_type_rocesw ) then
              l_cib_host_name_1  := l_admin_nat_host_name||'-clre0';
              l_cib_host_name_2  := l_admin_nat_host_name||'-clre1';
              l_stib_host_name_1 := l_admin_nat_host_name||'-stre0';
              l_stib_host_name_2 := l_admin_nat_host_name||'-stre1';
          end if;

          insert into ecs_domus
          (ecs_racks_name, hw_node_id, admin_ip, admin_host_name,
           db_client_mac, db_backup_mac,
           compute_ib1_ip, compute_ib1_host_name, 
           compute_ib1_netmask, compute_ib1_domianname, 
           compute_ib2_ip, compute_ib2_host_name, 
           compute_ib2_netmask, compute_ib2_domianname,
           storage_ib1_ip, storage_ib1_host_name,
           storage_ib1_netmask , storage_ib1_domianname,
           storage_ib2_ip, storage_ib2_host_name,
           storage_ib2_netmask, storage_ib2_domianname
          )
          values
          (l_ecs_racks_name, l_hw_node_id_coll(l_idx), null, 
           l_admin_nat_host_name, l_db_client_mac,
           l_db_backup_mac,
           l_cib_ip_1,
           l_cib_host_name_1,
           l_cib_ip_netmask_1, l_ib_domain,
           l_cib_ip_2,
           l_cib_host_name_2,
           l_cib_ip_netmask_2, l_ib_domain,
           l_stib_ip_1,
           l_stib_host_name_1,
           l_stib_ip_netmask_1, l_ib_domain,
           l_stib_ip_2,
           l_stib_host_name_2,
           l_stib_ip_netmask_2, l_ib_domain
          );
        end if;
        l_idx := l_hw_node_id_coll.next(l_idx);
      end loop;

      dbms_output.put_line('Sharing cluster end');
    end if;

    -- gather the subnet_id info. 
    begin
      select id, subnet_id into l_vcn_id, l_vcn_subnet
      from ecs_vcns where availability_domain = p_avail_domin;
    exception
      when no_data_found then
        raise_application_error(xn_no_such_vcn, 
          xm_no_such_vcn|| ' '||p_avail_domin);      
    end;
    dbms_output.put_line('Got vnc for '||p_avail_domin);

    -- check of we have cabinet level subnet_id. if there, use it
    if (l_cabinet_info.subnet_id is not null) then
      l_vcn_subnet := l_cabinet_info.subnet_id;
    end if;

    -- insert a row for the cluster into ecs_oracle_admin_subnets
    insert into ecs_oracle_admin_subnets
    values (l_vcn_id, l_vcn_subnet, l_ecs_racks_name, default);

    -- insert a row into ecs_racks for BMC only
    if (l_cabinet_info.generation_type = 'BMC') then
      insert into ecs_racks
      (dom0, domu, name, status, racksize, model, cabinet_id
      ) 
      values 
      (dom0_names, l_ecs_racks_name||'_pk', l_ecs_racks_name, 
       gc_ecs_racks_status_composing,
       gv_cluster_size_hash(l_cell_count||l_compute_count), p_model,
       l_cabinet_info.id
      );
    else
      update ecs_racks set status = gc_ecs_racks_status_composing
      where  name = l_ecs_racks_name;
    end if;


    -- insert into ecs_ib_pkeys_used, one for compute and one for storage
    l_idx := l_hw_node_id_coll.first;
    select ib_fabric_id into l_ib_fabric_id
    from   ecs_hw_nodes
    where  id = l_hw_node_id_coll(l_idx);

    if (l_sw_type = 'IBSW' ) then

      dbms_output.put_line('Inserting COMPUTE pkey  for '||l_ecs_racks_name);
  
      insert into ecs_ib_pkeys_used
      values (l_ib_fabric_id, 
              lower(trim(to_char(ecs_ib_compute_pkeys_seq_id.nextval,'XXXX'))),
              l_ecs_racks_name, gc_hw_node_type_compute, default);
  
      -- Storage keys are shared between clusters running on 
      -- the same set of computes
      if (p_shared_cluster_name is null) then
        l_storage_pkey := 
          lower(trim(to_char(ecs_ib_storage_pkeys_seq_id.nextval,'XXXX')));
  
        dbms_output.put_line('Inserting STORAGE pkey='||l_storage_pkey||
                             ' for '||l_ecs_racks_name);
  
        insert into ecs_ib_pkeys_used
        values (l_ib_fabric_id, l_storage_pkey,
                l_ecs_racks_name, 'STORAGE', default);
      else
        dbms_output.put_line('Inserting STORAGE pkey='||l_storage_pkey||
                             ' for '||l_ecs_racks_name);
  
        select pkey into l_storage_pkey
        from ecs_ib_pkeys_used
        where ecs_racks_name = p_shared_cluster_name
        and   pkey_use = 'STORAGE';
  
        insert into ecs_ib_pkeys_used
        values (l_ib_fabric_id, l_storage_pkey,
                l_ecs_racks_name, 'STORAGE', default);
      end if;
    end if;
    -- At this point cluster formation is done.
    commit;
   
    -- Now return the data to the caller 

    ecs_gen_cluster_admin_info(l_ecs_racks_name, p_node_constraint, l_cluster_admin_info);
    pipe row(l_cluster_admin_info.value);
    goto func_end; 

    <<func_end>>
    dbms_output.put_line('ecs_compose_cluster_begin EXIT}');
  exception
    when others then 
      rollback;

      l_row := '{'||chr(10)||'"action" : "ecs_compose_cluster_begin",'||chr(10)
             ||'"status" : "fail",'||chr(10)
             ||'"reason" : "'||SQLERRM||'"'||chr(10)
             ||'}';
      pipe row(l_row);
  end ecs_compose_cluster_begin;

  --
  -- @Public
  -- End a compose cluster action
  --
  function ecs_compose_cluster_end
  ( p_node_constraint     in varchar2
  , p_old_ecs_racks_name  in varchar2 -- cluster name given by the ecs_compose_cluster_begin
  , p_new_ecs_racks_name  in varchar2 -- actual/final cluster name
  , p_admin_hostname_list in varchar2 default null
  , p_admin_ip_list       in varchar2 default null
  , p_db_client_mac_list  in varchar2 default null
  , p_db_backup_mac_list  in varchar2 default null
  , p_action              in varchar2 default gc_commit -- Can be 'COMMIT' or 'ROLLBACK'
  ) return ecs_json_coll pipelined is
    pragma AUTONOMOUS_TRANSACTION;
    l_compute_count number;
    l_domu_count    number;

    l_hw_node_info    ecs_hw_nodes%rowtype;
    l_idx             pls_integer;
    l_row             clob;
    l_admin_hostname_coll dbms_sql.varchar2_table;
    l_admin_ip_coll       dbms_sql.varchar2_table;
    l_db_backup_mac_coll  dbms_sql.varchar2_table;
    l_db_client_mac_coll  dbms_sql.varchar2_table;
    l_ecs_racks_name      ecs_racks.name%type;
    l_new_ecs_racks_name      ecs_racks.name%type;
    l_existing_cluster    number;
    l_to_be_purged        number;
    l_mac_idx_skip        pls_integer := 2;
    l_cab_generation_type ecs_hw_cabinets.generation_type%type;
  begin

    dbms_output.put_line('ecs_compose_cluster_end {ENTER');

    l_cab_generation_type := ecs_get_cab_generation_type
    (p_old_ecs_racks_name);

    -- Common check. old cluster name should be in COMPOSING state
    begin
      select name into l_ecs_racks_name
      from   ecs_racks
      where  name   = p_old_ecs_racks_name
      and    status = gc_ecs_racks_status_composing;
    exception
      when no_data_found then
        raise_application_error(xn_cluster_not_composing, 
          xm_cluster_not_composing||' '||p_old_ecs_racks_name);
    end;

    -- Common check. new cluster shoud not be in purge schedule
    select count(ecs_racks_name) into l_to_be_purged
    from   ecs_clusters_purge_queue
    where  ecs_racks_name = p_new_ecs_racks_name;

    if (l_to_be_purged > 0) then
      raise_application_error(xn_clu_under_purge,
          xm_clu_under_purge||' '||p_new_ecs_racks_name);
    end if;

    if (l_cab_generation_type = 'BMC') then
      -- generate the cluster name according to the standards
      l_new_ecs_racks_name := generate_bmc_ecs_racks_name(p_old_ecs_racks_name);
      -- Check if the given cluster name already exists
      select count(name) into l_existing_cluster
      from   ecs_racks
      where  name = l_new_ecs_racks_name
      and    status != gc_ecs_racks_status_deleted;
  
      if (l_existing_cluster > 0) then
        raise_application_error(xn_clu_exists, 
                                xm_clu_exists||' '||l_new_ecs_racks_name);
      end if;
    else 
      l_new_ecs_racks_name := p_new_ecs_racks_name;
    end if;

    if (p_action = gc_commit) then
      -- Commit the compose cluster action
      -- lock rows from ecs_racks
      gv_ecs_racks_upd_trig_state := gc_ecs_racks_upd_trig_disable;
      select name into l_ecs_racks_name
      from ecs_racks
      where name = p_old_ecs_racks_name
      for update;

      if (l_cab_generation_type = 'BMC') then
        l_compute_count := 
          REGEXP_SUBSTR(p_node_constraint, '(\d+)comp',1,1,'i',1);
        l_admin_hostname_coll := split_str(p_admin_hostname_list, ',');
        l_admin_ip_coll   := split_str(p_admin_ip_list, ',');
        l_db_backup_mac_coll  := split_str(p_db_backup_mac_list, ',');
        l_db_client_mac_coll  := split_str(p_db_client_mac_list, ',');
    
        if (l_compute_count != l_admin_hostname_coll.count) then
          raise_application_error(xn_not_enough_values, 
            xm_not_enough_values|| ' p_admin_hostname_coll');
        end if;
    
        if (l_compute_count !=l_admin_ip_coll.count) then
          raise_application_error(xn_not_enough_values, 
            xm_not_enough_values|| ' p_admin_nat_ip_list');
        end if;
  
        if (l_db_client_mac_coll.count = 0 or
            mod(l_db_client_mac_coll.count, l_compute_count) != 0 or
            l_db_client_mac_coll.count != l_compute_count * 2) then
          raise_application_error(xn_not_enough_values, 
            xm_not_enough_values|| ' p_db_client_mac_list');
        end if;
  
        if (l_db_backup_mac_coll.count = 0 or
            mod(l_db_backup_mac_coll.count, l_compute_count) != 0 or
            l_db_backup_mac_coll.count != l_compute_count * 2 ) then
          raise_application_error(xn_not_enough_values, 
            xm_not_enough_values|| ' p_db_backup_mac_list');
        end if;
  
        -- update the ecs_ib_pkeys_used
        update ecs_ib_pkeys_used set ecs_racks_name = l_new_ecs_racks_name
        where ecs_racks_name = p_old_ecs_racks_name;
        dbms_output.put_line('updated ecs_ib_pkeys_used');
  
        -- insert to ecs_domus. depending on the cluster size
        for i in 1..l_compute_count loop
          -- check if the given oracle_hostname really belongs to some hw_node
          begin
            select * into l_hw_node_info
            from ecs_hw_nodes
            where oracle_hostname = l_admin_hostname_coll(i)
            and regexp_like(ecs_racks_name_list, ','||
                            p_old_ecs_racks_name||',', 'i');
          exception
            when no_data_found then
              raise_application_error(xn_node_not_in_cluster,
                xm_node_not_in_cluster||' '''||p_old_ecs_racks_name||'('||
                l_admin_hostname_coll(i)||')''');
          end;
  
          -- select * into l_cabinet_info
          -- from ecs_hw_cabinets
          -- where id = l_hw_node_info.cabinet_id;
  
          update ecs_domus 
          set admin_ip = l_admin_ip_coll(i),
              db_client_mac = 
                l_db_client_mac_coll((i*l_mac_idx_skip)-(l_mac_idx_skip-1)),
              db_backup_mac = 
                l_db_backup_mac_coll((i*l_mac_idx_skip)-(l_mac_idx_skip-1)),
              ecs_racks_name = l_new_ecs_racks_name
          where  hw_node_id = l_hw_node_info.id
          and    ecs_racks_name = p_old_ecs_racks_name;
  
          dbms_output.put_line('updated ecs_domus = '||
                               l_admin_hostname_coll(i));
  
        end loop;
        
        -- update ecs_oracle_admin_subnets
        update ecs_oracle_admin_subnets 
        set ecs_racks_name = l_new_ecs_racks_name
        where ecs_racks_name = p_old_ecs_racks_name;
        dbms_output.put_line('updated ecs_oracle_admin_subnets');  
  
        -- in the end update ecs_racks
        update ecs_racks er 
        set er.name = l_new_ecs_racks_name,
            er.status = gc_ecs_racks_status_new
        where  er.name = p_old_ecs_racks_name;
        dbms_output.put_line('updated ecs_racks');  
      else
        update ecs_racks er 
        set er.status = gc_ecs_racks_status_ready
        where  er.name = p_old_ecs_racks_name;
        dbms_output.put_line('updated ecs_racks');  
      
      end if; 

      -- Common info updates between all generation types
      update ecs_racks er 
      set er.name = l_new_ecs_racks_name,
          er.status = gc_ecs_racks_status_new
      where  er.name = p_old_ecs_racks_name;

      -- update ecs_hw_nodes
      update ecs_hw_nodes set node_state = gc_hw_node_state_allocated,
        ecs_racks_name_list = 
           regexp_replace(ecs_racks_name_list, 
                         ','|| p_old_ecs_racks_name||',',
                         ','||l_new_ecs_racks_name||',',1,0,'i')
      where regexp_like(ecs_racks_name_list, ','||
                        p_old_ecs_racks_name||',', 'i');

      dbms_output.put_line('updated ecs_hw_nodes');  

    else
      -- Rollback the compose cluster action    
      -- delete from ecs_ib_pkeys_used
      delete from ecs_ib_pkeys_used 
      where ecs_racks_name = p_old_ecs_racks_name;

      -- update ecs_hw_nodes and make the nodes free
      select * into l_hw_node_info
      from ecs_hw_nodes
      where regexp_like(ecs_racks_name_list, ','||
                          p_old_ecs_racks_name||',', 'i')
      and rownum < 2;

      select count(*) into l_domu_count
      from ecs_domus
      where hw_node_id = l_hw_node_info.id;

      if (l_domu_count = 1) then
        -- last DOMU, if removed the hw node is free
        update ecs_hw_nodes set node_state = gc_hw_node_state_free,
               ecs_racks_name_list = null
        where regexp_like(ecs_racks_name_list, ','||
                          p_old_ecs_racks_name||',', 'i');
      else
        update ecs_hw_nodes 
        set ecs_racks_name_list = regexp_replace(ecs_racks_name_list, ','||
                                    p_old_ecs_racks_name||',', null,1,0,'i')
        where regexp_like(ecs_racks_name_list, ','||
                          p_old_ecs_racks_name||',', 'i');
      end if;

      if (l_cab_generation_type = 'BMC') then
        -- delete entry ecs_oracle_admin_subnets
        delete from ecs_oracle_admin_subnets
        where  ecs_racks_name = p_old_ecs_racks_name;
  
        -- delete from ecs_domus
        delete from ecs_domus
        where ecs_racks_name = p_old_ecs_racks_name;
  
        -- delete entry from ecs_racks
        delete from ecs_racks er 
        where  er.name = p_old_ecs_racks_name;
      else
        update ecs_racks er
        set    er.status = gc_ecs_racks_status_new
        where  er.name = p_old_ecs_racks_name;
      end if;
  
    end if;
    commit;

    gv_ecs_racks_upd_trig_state := gc_ecs_racks_upd_trig_enable;

    l_row :=   
       '{ '||chr(10)
     ||'  "cluster_size": "'||p_node_constraint||'",'||chr(10)
     ||'  "old_ecs_racks_name": "'||p_old_ecs_racks_name||'",'||chr(10)
     ||'  "new_ecs_racks_name": "'||l_new_ecs_racks_name||'",'||chr(10)
     ||'  "action": "'||p_action||'",'||chr(10)
     ||'  "status": "success"'||chr(10)
     ||'}';

    dbms_output.put_line('ecs_compose_cluster_END EXIT}');
    pipe row(l_row);
  exception
    when others then 
      rollback;
      l_row :=   
         '{ '||chr(10)
       ||'  "cluster_size": "'||p_node_constraint||'",'||chr(10)
       ||'  "old_ecs_racks_name": "'||p_old_ecs_racks_name||'",'||chr(10)
       ||'  "new_ecs_racks_name": "'||l_new_ecs_racks_name||'",'||chr(10)
       ||'  "action": "'||p_action||'",'||chr(10)
       ||'  "status": "fail",'||chr(10)
       ||'  "reason": "'||SQLERRM||'"'||chr(10)
       ||'}';
  
    pipe row(l_row);
  
  end ecs_compose_cluster_end;


  -- 
  -- @Private function to get the cabinet alerts info
  --
  function ecs_gen_cabinet_alerts_info
  ( p_cabinet_id  in ecs_hw_cabinet_alerts.cabinet_id%type
  ) return clob is
    l_alerts            clob := null;
    l_idx               pls_integer := 0;
  begin
    dbms_output.put_line('ecs_gen_cabinet_alerts_info {ENTER');

    for alert_rec in 
    (select * from ecs_hw_cabinet_alerts where cabinet_id = p_cabinet_id)
    loop
      l_idx := l_idx + 1;
      if (alert_rec.protocol = gc_cab_alert_protocol_smtp) then
        if (l_idx > 1) then
          l_alerts := l_alerts||',';
        end if;
        l_alerts := l_alerts||
          '{ "alertType": "'||lower(alert_rec.alert_type)||'",'||
            '"clusterSMTPAddress": ["'||regexp_replace(alert_rec.to_address, ',',
                                       '","',1,0,'i')||'"]'||','||
            '"clusterSMTPFrom": "'||alert_rec.from_address||'",'||
            '"clusterSMTPPort": '||alert_rec.server_port||','||
            '"clusterSMTPServer": "'||alert_rec.server_name||'",'||
            '"clusterSMTPTxtFrom": "'||alert_rec.from_text||'",'||
            '"protocol": "smtp",'||
            '"clusterSMTPUseSsl": ';
         if (alert_rec.auth_n_encrypt_mode is null) then
           l_alerts := l_alerts||'"FALSE"}';
         else
           l_alerts := l_alerts||'"TRUE"}';
         end if;
      else
        if (l_idx > 1) then
          l_alerts := l_alerts||',';
        end if;
        l_alerts := l_alerts||
          '{ "alertType": "'||lower(alert_rec.alert_type)||'",'||
            '"clusterSNMPServer": "'||alert_rec.server_name||'",'||
            '"clusterSNMPPort": '||alert_rec.server_port||','||
            '"clusterSNMPCommunity": "'||alert_rec.community||'",'||
            '"protocol": "smtp"}';
      end if;
    end loop;
    if (l_idx > 0) then
      l_alerts := '['||l_alerts||']';
    end if;
    dbms_output.put_line('ecs_gen_cabinet_alerts_info EXIT}');
    return l_alerts;
  end ecs_gen_cabinet_alerts_info;

  -- 
  -- @private function to get domu nat_ip, nat_hostname,
  --  caviums, macs, etherfaces and etherface types.
  --
  function ecs_gen_nat_n_cavium_info
  ( p_ecs_racks_name  in varchar2
  , p_node_info       in ecs_domus%rowtype
  ) return clob is
    l_idx1             pls_integer := 0;
    l_macs             varchar2(4000);
    l_cavimus          varchar2(4000);
    l_etherfaces       varchar2(4000);
    l_etherface_types  varchar2(4000);
    l_node             clob := null;
    l_hw_node_info     ecs_hw_nodes%rowtype;
    l_cab_info         ecs_hw_cabinets%rowtype;
    l_subnet_array     dbms_sql.varchar2_table;

  begin
    dbms_output.put_line('ecs_gen_nat_n_cavium_info {ENTER');
    select * into l_hw_node_info
    from ecs_hw_nodes
    where  id = p_node_info.hw_node_id;

    select * into l_cab_info
    from   ecs_hw_cabinets
    where  id = l_hw_node_info.cabinet_id;

    l_subnet_array := split_str(l_cab_info.subnet_id, '|');

    if (p_node_info.admin_network_type = 'NAT') then
      l_node := '"nat_hostname_pick_": "'||p_node_info.admin_host_name ||'",'
              ||'"nat_ip_pick_": "'||p_node_info.admin_ip||'",'
              ||'"nat_netmask": "'||l_subnet_array(1)||'",'
              ||'"nat_domainname": "'||l_cab_info.domainname ||'"';
    end if;

    if (ecs_get_cab_generation_type(p_ecs_racks_name) = 'BMC') then
      -- get the nat ip, db_client_mac and db_backup_mac data
      l_idx1 := 1;
      l_cavimus := '[';
      l_macs    := '[';
      l_etherfaces := '[';
      l_etherface_types := '[';

      for cvm_rec in
      ( select * from ecs_caviums 
        where  hw_node_id     = p_node_info.hw_node_id
        and    etherface_type = gc_eface_db_client
        order by etherface
      ) loop
        
        if (l_idx1 = 1) then
          l_idx1 := l_idx1 + 1;
          l_cavimus := l_cavimus||'"'||cvm_rec.cavium_id||'"';
          l_macs    := l_macs||'"'||p_node_info.db_client_mac||'"';
          l_etherfaces := l_etherfaces||'"'||cvm_rec.etherface||'"';
          l_etherface_types := l_etherface_types||'"'
                               ||cvm_rec.etherface_type||'"';
        else
          l_cavimus := l_cavimus ||', "'||cvm_rec.cavium_id||'"';
          l_macs := l_macs ||', "'||p_node_info.db_client_mac||'"';
          l_etherfaces := l_etherfaces ||', "'||cvm_rec.etherface||'"';
          l_etherface_types := l_etherface_types ||', "'||
                               cvm_rec.etherface_type||'"';
        end if;
      end loop;
  
      for cvm_rec in
      ( select * from ecs_caviums 
        where  hw_node_id = p_node_info.hw_node_id
        and    etherface_type = gc_eface_db_backup
        order by etherface
      ) loop
          l_cavimus := l_cavimus ||', "'||cvm_rec.cavium_id||'"';
          l_macs := l_macs ||', "'||p_node_info.db_backup_mac||'"';
          l_etherfaces := l_etherfaces ||', "'||cvm_rec.etherface||'"';
          l_etherface_types := l_etherface_types ||', "'||
                               cvm_rec.etherface_type||'"';
      end loop;
  
      l_cavimus         := l_cavimus ||']';
      l_macs            := l_macs ||']';
      l_etherfaces      := l_etherfaces ||']';
      l_etherface_types := l_etherface_types ||']';

      l_node := l_node
        ||',"caviums": '||l_cavimus||','
        ||'"etherfaces": '||l_etherfaces||','||chr(10)
        ||'"etherface_types": '||l_etherface_types||','
        ||'"macs_pick_": '||l_macs;

    end if;

    dbms_output.put_line('ecs_gen_nat_n_cavium_info EXIT}');
    return l_node;
  end ecs_gen_nat_n_cavium_info;

  --
  -- @Private function to get the cluster node admin info
  -- 
  function ecs_gen_one_node_admin_info
  ( p_ecs_racks_name  in varchar2
  , p_cabinet_info    in ecs_hw_cabinets%rowtype
  , p_node_info       in ecs_hw_nodes%rowtype
  , p_node_sequence   in pls_integer
  ) return clob is 
    l_node clob;
    l_subnet_array     dbms_sql.varchar2_table;
    l_dns_array        dbms_sql.varchar2_table;
    l_ntp_array        dbms_sql.varchar2_table;
    l_gateway_array    dbms_sql.varchar2_table;
    l_pkey             varchar2(36);
    l_domu_info        ecs_domus%rowtype;
  
    l_idx1             pls_integer := 0;
    l_macs             varchar2(4000);
    l_cavimus          varchar2(4000);
    l_etherfaces       varchar2(4000);
    l_etherface_types  varchar2(4000);
  begin
    dbms_output.put_line('ecs_gen_one_node_admin_info {ENTER');
    l_subnet_array := split_str(p_cabinet_info.subnet_id, '|');
    l_dns_array := split_str(l_subnet_array(2), ':');
    l_dns_array := split_str(l_dns_array(2), ',');
    l_ntp_array := split_str(l_subnet_array(3), ':');
    l_ntp_array := split_str(l_ntp_array(2), ',');
    l_gateway_array := split_str(l_subnet_array(4), ':');

    dbms_output.put_line('l_subnet_array.count = '||
                         l_subnet_array.count);
    dbms_output.put_line('l_dns_array.count = '||l_dns_array.count);
    dbms_output.put_line('l_ntp_array.count = '||l_ntp_array.count);
    dbms_output.put_line('l_gateway_array.count = '||l_gateway_array.count);

    l_node := '{'
      ||'"node_sequence": '||p_node_sequence ||','
      ||'"node_type": "'||p_node_info.node_type||'",'
      ||'"node_model": "'||p_node_info.node_model||'",'
      ||'"oracle_ip": "'||p_node_info.oracle_ip||'",'
      ||'"oracle_hostname_pick_": "'||p_node_info.oracle_hostname ||'",'
      ||'"oracle_netmask": "'||l_subnet_array(1)||'",'
      ||'"oracle_gateway": "'||l_gateway_array(2)||'",'
      ||'"oracle_domain": "'||p_cabinet_info.domainname||'",'
      ||'"oracle_dns": [ ';
    for i in l_dns_array.first..l_dns_array.last loop
      if (i = l_dns_array.first) then
         l_node := l_node ||' "'||l_dns_array(i)||'"';
      else
         l_node := l_node ||', "'||l_dns_array(i)||'"';
      end if;
    end loop;
    dbms_output.put_line('DNS entries done');
    l_node := l_node||'],'
      ||'"oracle_ntp": [ ';
    for i in l_ntp_array.first..l_ntp_array.last loop
      if (i = l_ntp_array.first) then
        l_node := l_node ||' "'||l_ntp_array(i)||'"';
      else
        l_node := l_node ||', "'||l_ntp_array(i)||'"';
      end if;
    end loop;
    dbms_output.put_line('NTP entries done');
    l_node := l_node||'],'
      ||'"cabinet_id": '||p_cabinet_info.id||','
      ||'"cabinet_name": "'||p_cabinet_info.name||'"';

    -- IBSW, SPINESW, PDU, ETHSW  are done here
    if (p_node_info.node_type = gc_hw_node_type_ibsw or
        p_node_info.node_type = gc_hw_node_type_pdu  or
        p_node_info.node_type = gc_hw_node_type_ethsw or
        p_node_info.node_type = gc_hw_node_type_spinesw) then
      goto func_end;
    end if;
    l_node := l_node||','||chr(10)
      ||'"ilom_hostname": "'||p_node_info.oracle_ilom_hostname||'",'
      ||'"ilom_ip": "'||p_node_info.oracle_ilom_ip||'",'
      ||'"ilom_domain": "'||p_cabinet_info.domainname||'",'
      ||'"ilom_gateway": "'||l_gateway_array(2)||'",'
      ||'"ilom_netmask": "'||l_subnet_array(1)||'",'
      ||'"ilom_dns": [ ';
    for i in l_dns_array.first..l_dns_array.last loop
      if (i = l_dns_array.first) then
        l_node := l_node ||' "'||l_dns_array(i)||'"';
      else
        l_node := l_node ||', "'||l_dns_array(i)||'"';
      end if;
    end loop;
    l_node := l_node||'],'
      ||'"ilom_ntp": [ ';
    for i in l_ntp_array.first..l_ntp_array.last loop
      if (i = l_ntp_array.first) then
         l_node := l_node ||' "'||l_ntp_array(i)||'"';
      else
         l_node := l_node ||', "'||l_ntp_array(i)||'"';
      end if;
    end loop;
    l_node := l_node||']';
    dbms_output.put_line('ILOM entries done');

    -- Get storage pkey
    begin
      select pkey into l_pkey 
      from   ecs_ib_pkeys_used
      where  ecs_racks_name = p_ecs_racks_name
      and    pkey_use = 'STORAGE';
    exception
      when no_data_found then
        l_pkey := null;
        dbms_output.put_line('STORAGE PKEY entries not found');
    end;

    l_node := l_node||','
      ||'"storage_pkey": "0x' ||l_pkey ||'"';

    dbms_output.put_line('STORAGE PKEY entries done');

    -- ib network info
    l_node := l_node||',"priv1": {'
      ||'"domainname": "'||p_node_info.ib1_domain_name||'",'
      ||'"hostname": "'||p_node_info.ib1_hostname||'",'
      ||'"ip": "'||p_node_info.ib1_ip||'",'
      ||'"netmask": "'||p_node_info.ib1_netmask||'"},"priv2": {'
      ||'"domainname": "'||p_node_info.ib2_domain_name||'",'
      ||'"hostname": "'||p_node_info.ib2_hostname||'",'
      ||'"ip": "'||p_node_info.ib2_ip||'",'
      ||'"netmask": "'||p_node_info.ib2_netmask||'"}';
    
    -- CELL are done here
    if (p_node_info.node_type = gc_hw_node_type_storage) then
      goto func_end;
    end if;

    -- Get compute pkey
    begin
      select pkey into l_pkey 
      from   ecs_ib_pkeys_used
      where  ecs_racks_name = p_ecs_racks_name
      and    pkey_use = 'COMPUTE';
    exception
      when no_data_found then
        l_pkey := null;
        dbms_output.put_line('COMPUTE PKEY entries not found');
    end;

    l_node := l_node
      ||',"compute_pkey": "0x' || l_pkey||'"';
    dbms_output.put_line('COMPUTE PKEY entries done');

    -- For BMC or X7 the NAT_IP, NAT_HOSTNAME info are moved to
    -- the client JSON
    -- For BMC the cavimums, macs, etherfaces and etherface types are
    -- moved to the client JSON
    <<func_end>>

    l_node := l_node ||'}';  
    dbms_output.put_line('ecs_gen_one_node_admin_info EXIT}');
    return l_node;
  end ecs_gen_one_node_admin_info;

  --
  -- @Private function to get the cluster nodes admin info
  -- 
  function ecs_gen_nodes_admin_info
  ( p_ecs_racks_name  in varchar2
  , p_cabinet_info    in ecs_hw_cabinets%rowtype
  ) return clob is
    l_nodes clob;
    l_one_node clob;
    l_idx   pls_integer := 0;
    l_node_type_coll dbms_sql.varchar2_table;
  begin
    dbms_output.put_line('ecs_gen_nodes_admin_info {ENTER');

    l_node_type_coll(1) := gc_hw_node_type_storage;
    l_node_type_coll(2) := gc_hw_node_type_compute;
    
    l_nodes := '[';

    <<each_node_type>>
    for node_type in l_node_type_coll.first..l_node_type_coll.last loop
      <<each_node>>
      for node_rec in 
      ( select * from ecs_hw_nodes ehn
        where  ehn.cabinet_id = p_cabinet_info.id
        and    regexp_like(ecs_racks_name_list, ','|| p_ecs_racks_name||',', 'i')
        and    ehn.node_type = l_node_type_coll(node_type)
        order by ehn.node_type_order_bottom_up
      ) loop
        l_idx := l_idx + 1;
        if (l_idx > 1) then
          l_nodes := l_nodes||',';
        end if;

        dbms_output.put_line('ecs_gen_nodes_admin_info: node_seq = '||l_idx);
        l_one_node := ecs_gen_one_node_admin_info
        ( p_ecs_racks_name  => p_ecs_racks_name
        , p_cabinet_info    => p_cabinet_info
        , p_node_info       => node_rec
        , p_node_sequence   => l_idx
        );

        l_nodes := l_nodes || l_one_node;
      end loop each_node;
    end loop each_node_type;


    l_node_type_coll(1) := gc_hw_node_type_ibsw;
    l_node_type_coll(2) := gc_hw_node_type_spinesw;
    l_node_type_coll(3) := gc_hw_node_type_pdu;
    -- l_node_type_coll(4) := gc_hw_node_type_ethsw;
    <<each_node_type>>
    for node_type in l_node_type_coll.first..l_node_type_coll.last loop
      <<each_node>>
      for node_rec in 
      ( select * from ecs_hw_nodes ehn
        where  ehn.cabinet_id = p_cabinet_info.id
        and    ehn.node_type = l_node_type_coll(node_type)
        order by ehn.node_type_order_bottom_up
      ) loop
        l_idx := l_idx + 1;
        if (l_idx > 1) then
          l_nodes := l_nodes||',';
        end if;

        dbms_output.put_line('ecs_gen_nodes_admin_info: node_seq = '||l_idx);
        l_one_node := ecs_gen_one_node_admin_info
        ( p_ecs_racks_name  => p_ecs_racks_name
        , p_cabinet_info    => p_cabinet_info
        , p_node_info       => node_rec
        , p_node_sequence   => l_idx
        );

        l_nodes := l_nodes || l_one_node;
      end loop each_node;
    end loop each_node_type;

    l_nodes := l_nodes||']';   
    dbms_output.put_line('ecs_gen_nodes_admin_info EXIT}');
    return l_nodes;
  end ecs_gen_nodes_admin_info;

  --
  -- @Private procedure to get the cluster's xml type
  -- 
  function ecs_get_cluster_xml_type
  ( p_ecs_racks_name in     varchar2
  ) return varchar2 is
    l_cab_info ecs_hw_cabinets%rowtype;
    l_cab_id   ecs_hw_nodes.cabinet_id%type;
    l_cluster_xml_type varchar2(64) := null; 
    l_model_array       dbms_sql.varchar2_table;
  begin
    dbms_output.put_line('ecs_get_cluster_xml_type {ENTER');
    begin
      select ehn.cabinet_id into l_cab_id
      from   ecs_hw_nodes ehn, ecs_domus ed
      where  ed.hw_node_id = ehn.id
      and    ed.ecs_racks_name = p_ecs_racks_name
      and    rownum < 2;
    exception
      when no_data_found then
        dbms_output.put_line('ecs_get_cluster_xml_type: no such cluster '||
                             p_ecs_racks_name);
        return l_cluster_xml_type;
    end;

    begin
      select * into l_cab_info
      from   ecs_hw_cabinets
      where  id = l_cab_id;
    exception
      when no_data_found then
        dbms_output.put_line('ecs_get_cluster_xml_type: no cabinet '||
                             'hosts the cluster '||p_ecs_racks_name);
        return l_cluster_xml_type;
    end;

    l_model_array := split_str(l_cab_info.model,'-');

    l_cluster_xml_type := 'public';

    if (l_cab_info.generation_type = 'BMC') then
       l_cluster_xml_type := l_cluster_xml_type||'_vcn_'||
                               lower(l_model_array(1));
    else
       l_cluster_xml_type := l_cluster_xml_type||'_classic_'||
                               lower(l_model_array(1));
    end if;
    dbms_output.put_line('ecs_get_cluster_xml_type EXIT}');    
    return l_cluster_xml_type;

  end ecs_get_cluster_xml_type;

  --
  -- @Private procedure to get the cluster admin info
  -- 
  procedure ecs_gen_cluster_admin_info
  ( p_ecs_racks_name in     varchar2
  , p_node_constraint     in varchar2 default null
  , r_admin_info     in out t_cluster_info_record
  ) is
    l_cabinet_id        ecs_hw_cabinets.id%type;
    l_cabinet_info      ecs_hw_cabinets%rowtype;
    l_alerts            clob;
    l_nodes             clob;
  begin
    dbms_output.put_line('ecs_gen_cluster_admin_info {ENTER');
    -- Get the cabinet info
    begin
      select ehn.cabinet_id into l_cabinet_id
      from   ecs_hw_nodes ehn, ecs_domus edu
      where  ehn.id = edu.hw_node_id
      and    edu.ecs_racks_name = p_ecs_racks_name
      and    rownum < 2;
    exception 
      when no_data_found then
        dbms_output.put_line('ecs_gen_cluster_admin_info: no such cluster');
    end;

    begin
      select * into l_cabinet_info
      from   ecs_hw_cabinets ehc
      where  ehc.id = l_cabinet_id;
    exception
      when no_data_found then
        dbms_output.put_line('ecs_gen_cluster_admin_info: no such cabinet');
    end;
      
    -- build the cluster admin info json
    r_admin_info.key := gc_cluster_info_key_admin;

    -- 1. alerts
    l_alerts := ecs_gen_cabinet_alerts_info(l_cabinet_info.id);

    -- 2. nodes
    l_nodes := ecs_gen_nodes_admin_info(p_ecs_racks_name, l_cabinet_info);

    -- 3. rest of the stuff
    r_admin_info.value := '{'
      ||'"clusters": [{'
      ||    '"cluster_size": "'||p_node_constraint||'",'
      ||    '"customer_name": "'||p_ecs_racks_name||'",'
      ||    '"nodes": '||l_nodes||','
      ||    '"temporary_ecs_rack_name_pick_": "'||p_ecs_racks_name||'",'
      ||    '"xml_type": "'||ecs_get_cluster_xml_type(p_ecs_racks_name)||'",'
      ||    '"oracle_admin_subnet": "'||l_cabinet_info.subnet_id||'",'
      ||    '"oracle_admin_vcnid": "'||l_cabinet_info.subnet_id||'",'
      ||    '"availability_domain": "'||l_cabinet_info.availability_domain||'",'
      ||    '"product": "'||l_cabinet_info.product||'"';
    if (l_alerts is not null) then
      r_admin_info.value := r_admin_info.value
        ||    ',"alerts":'||l_alerts;
    end if;
    r_admin_info.value := r_admin_info.value
      ||    ',"time_zone": "'||l_cabinet_info.time_zone||'"}]}';

    dbms_output.put_line('ecs_gen_cluster_admin_info EXIT}');

    return;
  end ecs_gen_cluster_admin_info;

  function ecs_gen_clu_1_node_clnt_info
  ( p_ecs_racks_name in varchar2
  , p_node_info      in ecs_domus%rowtype
  ) return clob is 
    l_node clob;
    l_storage_pkey ecs_ib_pkeys_used.pkey%type;
    l_compute_pkey ecs_ib_pkeys_used.pkey%type;
    l_dom0_hostname ecs_hw_nodes.oracle_hostname%type;
    l_nat_n_cavium  clob := null;
  begin
    dbms_output.put_line('ecs_gen_clu_1_node_clnt_info {ENTER');

    -- Get storage pkey
    begin
      select pkey into l_storage_pkey 
      from   ecs_ib_pkeys_used
      where  ecs_racks_name = p_ecs_racks_name
      and    pkey_use = 'STORAGE';
    exception 
      when no_data_found then
      l_storage_pkey := null;
    end;
    -- Get compute pkey
    begin
      select pkey into l_compute_pkey 
      from   ecs_ib_pkeys_used
      where  ecs_racks_name = p_ecs_racks_name
      and    pkey_use = 'COMPUTE';
    exception
      when no_data_found then
      l_compute_pkey := null;
    end;
    -- get dom0_hostname
    select oracle_hostname into l_dom0_hostname
    from   ecs_hw_nodes
    where  id = p_node_info.hw_node_id;

    l_node := '{';

    --1. client admin info
    l_node := l_node
      ||'"oracle_hostname_pick_": "'||l_dom0_hostname||'"';
    if (p_node_info.admin_network_type != 'NAT' and 
        p_node_info.admin_host_name is not null) then
      l_node := l_node
        ||',"admin": {'
        ||           '"domainname": "'||p_node_info.admin_domianname||'",'
        ||           '"gateway": "'||p_node_info.admin_gateway||'",'
        ||           '"hostname": "'||p_node_info.admin_host_name||'",'
        ||           '"ip": "'||p_node_info.admin_ip||'",';
      if (p_node_info.admin_vlan_tag is not null and 
          p_node_info.admin_vlan_tag != 0) then
        l_node := l_node
          ||           '"vlanid": "'||p_node_info.admin_vlan_tag||'",';
      end if;
      l_node := l_node
        ||           '"netmask": "'||p_node_info.admin_netmask||'"}';
    end if;
    --2. client db_backup info
    if (p_node_info.db_backup_host_name is not null) then
      l_node := l_node
        ||',"backup": {'
        ||           '"domainname": "'||p_node_info.db_backup_domianname||'",'
        ||           '"gateway": "'||p_node_info.db_backup_gateway||'",'
        ||           '"hostname": "'||p_node_info.db_backup_host_name||'",'
        ||           '"ip": "'||p_node_info.db_backup_ip||'",'
        ||           '"master": "'||p_node_info.db_backup_master_interface||'",'
        ||           '"netmask": "'||p_node_info.db_backup_netmask||'",';
      if (p_node_info.db_backup_vlan_tag is not null and
          p_node_info.db_backup_vlan_tag != 0) then
        l_node := l_node
          ||           '"vlanid": "'||p_node_info.db_backup_vlan_tag||'",';
      end if;
      l_node := l_node
        ||           '"slave": ["'||p_node_info.db_backup_slave_interface_1||'","'
                               ||p_node_info.db_backup_slave_interface_2||'"]}';
    end if;

    --3. client db_client info
    if (p_node_info.db_client_host_name is not null) then
      l_node := l_node
        ||',"client": {'
        ||           '"domainname": "'||p_node_info.db_client_domianname||'",'
        ||           '"gateway": "'||p_node_info.db_client_gateway||'",'
        ||           '"hostname": "'||p_node_info.db_client_host_name||'",'
        ||           '"ip": "'||p_node_info.db_client_ip||'",'
        ||           '"master": "'||p_node_info.db_client_master_interface||'",'
        ||           '"netmask": "'||p_node_info.db_client_netmask||'",';
      if (p_node_info.db_client_vlan_tag is not null and
          p_node_info.db_client_vlan_tag != 0) then
        l_node := l_node
          ||           '"vlanid": "'||p_node_info.db_client_vlan_tag||'",';
      end if;
      l_node := l_node
        ||           '"slave": ["'||p_node_info.db_client_slave_interface_1||'","'
                                 ||p_node_info.db_client_slave_interface_2||'"]}';
    end if;

    --4. client compute ib1 info
    l_node := l_node
      ||',"clusterpriv1": {'
      ||           '"domainname": "'||p_node_info.compute_ib1_domianname||'",';
    if (p_node_info.compute_ib1_gateway is not null) then
      l_node := l_node
      ||           '"gateway": "'||p_node_info.compute_ib1_gateway||'",';
    end if;
    l_node := l_node
      ||           '"hostname": "'||p_node_info.compute_ib1_host_name||'",'
      ||           '"ip": "'||p_node_info.compute_ib1_ip||'",'
      ||           '"netmask": "'||p_node_info.compute_ib1_netmask||'"},'
    --5. client compute ib2 info
      ||'"clusterpriv2": {'
      ||           '"domainname": "'||p_node_info.compute_ib2_domianname||'",';
    if (p_node_info.compute_ib2_gateway is not null) then
      l_node := l_node
      ||           '"gateway": "'||p_node_info.compute_ib2_gateway||'",';
    end if;
    l_node := l_node
      ||           '"hostname": "'||p_node_info.compute_ib2_host_name||'",'
      ||           '"ip": "'||p_node_info.compute_ib2_ip||'",'
      ||           '"netmask": "'||p_node_info.compute_ib2_netmask||'"},'
    --6. client storage ib1 info
      ||'"priv1": {'
      ||           '"domainname": "'||p_node_info.storage_ib1_domianname||'",';
    if (p_node_info.storage_ib1_gateway is not null) then
      l_node := l_node
      ||           '"gateway": "'||p_node_info.storage_ib1_gateway||'",';
    end if;
    l_node := l_node
      ||           '"hostname": "'||p_node_info.storage_ib1_host_name||'",'
      ||           '"ip": "'||p_node_info.storage_ib1_ip||'",'
      ||           '"netmask": "'||p_node_info.storage_ib1_netmask||'"},'
    --7. client storage ib2 info
      ||'"priv2": {'
      ||           '"domainname": "'||p_node_info.storage_ib2_domianname||'",';
    if (p_node_info.storage_ib2_gateway is not null) then
      l_node := l_node
      ||           '"gateway": "'||p_node_info.storage_ib2_gateway||'",';
    end if;
    l_node := l_node
      ||           '"hostname": "'||p_node_info.storage_ib2_host_name||'",'
      ||           '"ip": "'||p_node_info.storage_ib2_ip||'",'
      ||           '"netmask": "'||p_node_info.storage_ib2_netmask||'"},'
    --8. compute and storage pkeys
      ||'"compute_pkey": "0x' || l_compute_pkey||'",'
      ||'"storage_pkey": "0x' || l_storage_pkey||'",'
    --9. various gateway adapters
      ||'"gatewayadapter": "'||lower(p_node_info.gateway_adapter)||'",'
      ||'"hostnameadapter": "'||lower(p_node_info.hostname_adapter)||'"';
    --10. vip info
    if (p_node_info.db_client_vip_host_name is not null) then
      l_node := l_node
        ||',"vip": {'
        ||         '"domainname": "'||p_node_info.db_client_vip_domianname||'",'
        ||         '"ip": "'||p_node_info.db_client_vip||'",'
        ||         '"name": "'||p_node_info.db_client_vip_host_name||'"}';
    end if;
    --11. VM size info
    if (p_node_info.vm_size_name is not null) then
      l_node := l_node
        ||',"vmsizename": "'||p_node_info.vm_size_name||'"';
    end if;

    --12. NAT IP, HOSTNAME for BMC + GEN1 and CAVIUM for BMC
    l_nat_n_cavium := ecs_gen_nat_n_cavium_info
    ( p_ecs_racks_name, p_node_info);

    if (l_nat_n_cavium is not null) then
      l_node := l_node||','||l_nat_n_cavium;
    end if;

    l_node := l_node||'}';
    dbms_output.put_line('ecs_gen_clu_1_node_clnt_info EXIT}');
    
    return l_node;
  end ecs_gen_clu_1_node_clnt_info;
  --
  -- @Private procedure to get the cluster nodes' client info
  -- 
  function ecs_gen_clu_nodes_clnt_info
  ( p_ecs_racks_name in varchar2
  ) return clob is
    l_nodes    clob := null;
    l_one_node clob;
    l_idx      pls_integer := 0;
  begin 
    dbms_output.put_line('ecs_gen_clu_nodes_clnt_info {ENTER');

    for node_rec in
    ( select * from ecs_domus where ecs_racks_name = p_ecs_racks_name ) loop
      l_idx := l_idx + 1;
      if (l_idx > 1) then
        l_nodes := l_nodes||',';
      end if;

      l_one_node := ecs_gen_clu_1_node_clnt_info
      ( p_ecs_racks_name => p_ecs_racks_name
      , p_node_info      => node_rec
      );

      l_nodes := l_nodes || l_one_node;
    end loop;

    if (l_idx > 0) then
      l_nodes := '[' || l_nodes || ']';
    end if;

    dbms_output.put_line('ecs_gen_clu_nodes_clnt_info EXIT}');
    return l_nodes;
  end ecs_gen_clu_nodes_clnt_info;

  --
  -- @Private procedure to get the cluster disk group info
  -- 
  function ecs_gen_clu_dsk_grp_info
  (p_ecs_racks_name in varchar2
  ) return clob is
    l_dg clob := null;
    l_idx pls_integer := 0;
  begin
    dbms_output.put_line('ecs_gen_clu_dsk_grp_info {ENTER');
    for dg_rec in 
    (select * from ecs_cluster_diskgroups 
     where ecs_racks_name = p_ecs_racks_name) loop
      l_idx := l_idx + 1;
      if (l_idx > 1) then
        l_dg := l_dg||',';
      end if;
      l_dg := l_dg||'{'
        ||'"diskgroupname": "'||dg_rec.disk_group_name||'",'
        ||'"redundancy": "'||dg_rec.disk_group_redundancy||'",'
        ||'"diskgrouptype": "'||dg_rec.disk_group_type||'",'
        ||'"diskgroupsize": "'||dg_rec.disk_group_size||'"}';
    end loop;

    if (l_idx > 0) then
      l_dg := '['||l_dg||']';
    end if;
    dbms_output.put_line('ecs_gen_clu_dsk_grp_info EXIT}');
    return l_dg;
  end ecs_gen_clu_dsk_grp_info;

  --
  -- @Private procedure to get the cluster gi info
  -- 
  function ecs_gen_cluster_gi_info
  ( p_ecs_racks_name in varchar2
  ) return clob is
    l_gi clob := '{}';
    l_idx pls_integer := 0;
    l_gi_info ecs_clusters%rowtype;
  begin
    dbms_output.put_line('ecs_gen_cluster_gi_info {ENTER');
    select * into l_gi_info 
    from ecs_clusters
    where ecs_racks_name = p_ecs_racks_name;

    l_gi := '{'
      ||      '"basedir": "'||l_gi_info.gi_basedir||'",'
      ||      '"clustername": "'||l_gi_info.gi_clustername||'",'
      ||      '"gihomeloc": "'||l_gi_info.gi_homeloc||'",'
      ||      '"giversion": "'||l_gi_info.gi_version||'",'
      ||      '"invloc": "'||l_gi_info.inventory_loc||'",'
      ||      '"patchlist": ["'||regexp_replace(l_gi_info.patchlist, 
                                   ',', '","',1,0,'i')||'"]}';

    dbms_output.put_line('ecs_gen_cluster_gi_info EXIT}');

    return l_gi;

  exception
    when no_data_found then
      return null;
  end ecs_gen_cluster_gi_info;

  --
  -- @Private procedure to get the cluster ntp and dns info
  -- 
  function ecs_gen_cluster_ntp_n_dns_info
  ( p_ecs_racks_name in varchar2
  ) return clob is
    l_gi clob := '{}';
    l_idx pls_integer := 0;
    l_gi_info ecs_clusters%rowtype;
  begin
    dbms_output.put_line('ecs_gen_cluster_ntp_n_dns_info {ENTER');
    select * into l_gi_info 
    from ecs_clusters
    where ecs_racks_name = p_ecs_racks_name;

    l_gi := '{'
      ||      '"ntp": ["'||l_gi_info.ntp_ip1||'"';
    if (l_gi_info.ntp_ip2 is not null) then
      l_gi := l_gi||',"'||l_gi_info.ntp_ip2||'"';
    end if;
    if (l_gi_info.ntp_ip3 is not null) then
      l_gi := l_gi||',"'||l_gi_info.ntp_ip3||'"';
    end if;

    l_gi := l_gi||'],'
      ||      '"dns": ["'||l_gi_info.dns_ip1||'"';
    if (l_gi_info.dns_ip2 is not null) then
      l_gi := l_gi||',"'||l_gi_info.dns_ip2||'"';
    end if;
    if (l_gi_info.dns_ip3 is not null) then
      l_gi := l_gi||',"'||l_gi_info.dns_ip3||'"';
    end if;

    l_gi := l_gi||']}';
    dbms_output.put_line('ecs_gen_cluster_ntp_n_dns_info EXIT}');

    return l_gi;
  exception
    when no_data_found then
      return null;
  end ecs_gen_cluster_ntp_n_dns_info;

  --
  -- @Private procedure to get the cluster scan info
  -- 
  function ecs_gen_cluster_scan_info
  ( p_ecs_racks_name in varchar2
  ) return clob is
    l_gi clob := '[]';
    l_idx pls_integer := 0;
    l_gi_info ecs_clusters%rowtype;
  begin
    dbms_output.put_line('ecs_gen_cluster_scan_info {ENTER');
    select * into l_gi_info 
    from ecs_clusters
    where ecs_racks_name = p_ecs_racks_name;

    l_gi := '[{'
      ||       '"hostname": "'||l_gi_info.scan_name||'.'
                              ||l_gi_info.scan_domainname||'",'
      ||       '"ips": ["'||l_gi_info.scan_ip1||'"';

    if (l_gi_info.scan_ip2 is not null) then
      l_gi := l_gi||',"'||l_gi_info.scan_ip2||'"';
    end if;
    if (l_gi_info.scan_ip3 is not null) then
      l_gi := l_gi||',"'||l_gi_info.scan_ip3||'"';
    end if;
   
    l_gi := l_gi||'],'
      ||         '"port": '||l_gi_info.scan_port||'}]';

    dbms_output.put_line('ecs_gen_cluster_scan_info EXIT}');

    return l_gi;
  exception
    when no_data_found then
      return null;

  end ecs_gen_cluster_scan_info;
  

  --
  -- @Private procedure to get the cluster vm size def
  -- 
  function ecs_gen_cluster_vmsize_def
  ( p_ecs_racks_name in varchar2
  ) return clob is
    l_vmdef clob := null;
    l_idx pls_integer := 0;
    l_hw_node_id ecs_hw_nodes.id%type;
    l_hw_node_model ecs_hw_nodes.node_model%type;
  begin
    dbms_output.put_line('ecs_gen_cluster_vmsize_def {ENTER');
    select hw_node_id into l_hw_node_id
    from   ecs_domus
    where  ecs_racks_name = p_ecs_racks_name
    and    rownum < 2;

    select node_model into l_hw_node_model
    from   ecs_hw_nodes
    where  id = l_hw_node_id;
   
    for vmsz_rec in 
    ( select * from ecs_vm_sizes where hw_model = l_hw_node_model) loop
      l_idx := l_idx + 1;
      if (l_idx > 1) then
        l_vmdef := l_vmdef||',';
      end if;
      l_vmdef := l_vmdef
        ||'"'||vmsz_rec.size_name||'": {'
        ||                   '"DiskSize": "'||vmsz_rec.disk_size||'",'
        ||                   '"MemSize": "'||vmsz_rec.memory_size||'",'
        ||                   '"cpuCount": "'||vmsz_rec.cpu_count||'"}';

    end loop;
    if (l_idx > 0) then
      l_vmdef := '{' || l_vmdef || '}';
    end if;
    dbms_output.put_line('ecs_gen_cluster_vmsize_def EXIT}');
    return l_vmdef;
  exception
    when no_data_found then
      return null;
  end ecs_gen_cluster_vmsize_def;


  --
  -- @Private procedure to get the cluster db homes and databases
  -- 
  function ecs_gen_cluster_dbhomes_n_db
  ( p_ecs_racks_name in varchar2
  ) return clob is
    l_db clob := null;
    l_idx pls_integer := 0;
    l_idx1 pls_integer := 0;
  begin
    dbms_output.put_line('ecs_gen_cluster_dbhomes_n_db {ENTER');

    for dbh_rec in 
    ( select * from ecs_database_homes where ecs_racks_name = p_ecs_racks_name) 
    loop
      l_idx := l_idx + 1;
      if (l_idx > 1) then
        l_db := l_db||',';
      end if;

      l_db := l_db||'{'
        || '"basedir": "'||dbh_rec.basedir||'",'
        || '"dbhomeloc": "'||dbh_rec.db_home_loc||'",'
        || '"dblang": "'||dbh_rec.db_lang||'",'
        || '"dbversion": "'||dbh_rec.db_version||'",'
        || '"invloc": "'||dbh_rec.invloc||'",'
        || '"patchlist": ["'||regexp_replace(dbh_rec.patchlist, 
                                   ',', '","',1,0,'i')||'"],'
        || '"databases": [';
      l_idx1 := 0;
      for db_rec in 
      (select * from ecs_databases 
       where ecs_racks_name = p_ecs_racks_name
       and   db_home_name = dbh_rec.db_home_name) loop
        l_idx1 := l_idx1 + 1;
        if (l_idx1 > 1) then
          l_db := l_db||',';
        end if;
        l_db := l_db||'{'
          ||'"dbtype": "'||lower(db_rec.cdb_or_pdb)||'",'
          ||'"dbname": "'||db_rec.db_name_or_sid||'",'
          ||'"dbtemplate": "'||db_rec.db_template||'",'
          ||'"blocksize": "'||db_rec.db_blocksize||'",'
          ||'"charset": "'||db_rec.db_charset||'",'
          ||'"dblang": "'||db_rec.db_lang||'"}';
      end loop;
      l_db := l_db||']}';
    end loop;

    if (l_idx > 0) then
      l_db := '['||l_db||']';
    end if;
    dbms_output.put_line('ecs_gen_cluster_dbhomes_n_db EXIT}');

    return l_db;
  end ecs_gen_cluster_dbhomes_n_db;
  
  --
  -- @Private procedure to get the cluster client info
  -- 
  procedure  ecs_gen_cluster_client_info
  ( p_ecs_racks_name in varchar2
  , r_client_info    in out t_cluster_info_record
  ) is 
    l_nodes clob;
    l_disk_groups clob;
    l_gi_cluster clob;
    l_ntp_n_dns  clob;
    l_scans      clob;
    l_vmsize_def clob;
    l_db_homes_n_db   clob;
    l_clusters   clob := null;
    l_timezone        ecs_clusters.timezone%type;
    l_ecs_racks_name  ecs_racks.name%type;
    l_cab_generation_type ecs_hw_cabinets.generation_type%type;
  begin
    dbms_output.put_line('ecs_gen_cluster_client_info {ENTER');

    -- check if the given cluster exists or not
    select name into l_ecs_racks_name
    from ecs_racks
    where name = p_ecs_racks_name;

    --1. nodes info
    l_nodes := ecs_gen_clu_nodes_clnt_info(p_ecs_racks_name);

    --2. diskgroups info
    l_disk_groups := ecs_gen_clu_dsk_grp_info(p_ecs_racks_name);

    --3. gi cluster info
    l_gi_cluster := ecs_gen_cluster_gi_info(p_ecs_racks_name);

    --4. ntp and dns info
    l_ntp_n_dns := ecs_gen_cluster_ntp_n_dns_info(p_ecs_racks_name);

    --5. scans info
    l_scans := ecs_gen_cluster_scan_info(p_ecs_racks_name);

    --6. vmsizes def
    l_vmsize_def := ecs_gen_cluster_vmsize_def(p_ecs_racks_name);

    --7. database homes and databases using those homes 
    l_db_homes_n_db := ecs_gen_cluster_dbhomes_n_db(p_ecs_racks_name);

    --8. Get the cluster timezone
    begin
      select timezone into l_timezone
      from   ecs_clusters
      where  ecs_racks_name = p_ecs_racks_name;
    exception
      when no_data_found then
         l_timezone := 'UTC';
    end;

    l_cab_generation_type := ecs_get_cab_generation_type
    ( p_ecs_racks_name );

    --9. Put together all of them.
    r_client_info.key := gc_cluster_info_key_client;
    r_client_info.value := '{'
      ||'"customer_name": "'||p_ecs_racks_name||'",'
      ||'"temporary_ecs_rack_name_pick_": "'||p_ecs_racks_name||'",'
      ||'"xml_type": "'||ecs_get_cluster_xml_type(p_ecs_racks_name)||'"';

    if (l_cab_generation_type = 'AD' or l_cab_generation_type = 'HIGGS') then
      r_client_info.value := r_client_info.value
        ||',"enable_higgs": "True"';
    end if;

    if (l_gi_cluster is not null) then
      r_client_info.value := r_client_info.value
        ||',"cluster": '||l_gi_cluster;
    end if;
    if (l_db_homes_n_db is not null) then
      r_client_info.value := r_client_info.value
        ||',"databasehomes": '||l_db_homes_n_db;
    end if;

    if (l_disk_groups is not null) then
      l_clusters := '"diskgroups": '||l_disk_groups;
    end if;
    if (l_ntp_n_dns is not null) then
      if (l_clusters is not null) then
        l_clusters := l_clusters
          ||     ',"network_services": '||l_ntp_n_dns;
      else
        l_clusters := '"network_services": '||l_ntp_n_dns;
      end if;
    end if;
    if (l_nodes is not null) then
      if (l_clusters is not null) then
        l_clusters := l_clusters
          ||     ',"nodes": '||l_nodes;
      else
        l_clusters := '"nodes": '||l_nodes;
      end if;
    end if;
    if (l_scans is not null) then
      if (l_clusters is not null) then
        l_clusters := l_clusters
          ||    ',"scans": '||l_scans;
      else
        l_clusters := '"scans": '||l_scans;
      end if;
    end if;
    if (l_timezone is not null) then
      if (l_clusters is not null) then
        l_clusters := l_clusters
          ||     ',"timezone": "'||l_timezone||'"';
      else 
        l_clusters := '"timezone": "'||l_timezone||'"';
      end if;
    end if;

    if (l_vmsize_def is not null) then
      if (l_clusters is not null) then
        l_clusters := l_clusters
          ||     ',"vmsizes_def": '||l_vmsize_def;
      else
        l_clusters := '"vmsizes_def": '||l_vmsize_def;
      end if;
    end if;

    if (l_clusters is not null) then
      l_clusters := '{' ||l_clusters ||'}';
      r_client_info.value := r_client_info.value
        ||',"customer_network": '||l_clusters;
    end if;

    r_client_info.value := r_client_info.value|| '}';

    dbms_output.put_line('ecs_gen_cluster_client_info EXIT}');
  exception
    when no_data_found then
      r_client_info.key := null;
      r_client_info.value := null;
  end ecs_gen_cluster_client_info;

  
  --
  -- @Private procedure to get the cluster caviums info
  --  This is only applicabe to BMC (OCI)
  -- 
  procedure ecs_gen_cluster_cavimum_info
  ( p_ecs_racks_name  in varchar2
  , r_cavimum_info    in out t_cluster_info_record
  ) is
    l_cab_generation_type ecs_hw_cabinets.generation_type%type;
    l_idx pls_integer := 0;
  begin
    dbms_output.put_line('ecs_gen_cluster_cavium_info {ENTER');

    r_cavimum_info.key := null;
    r_cavimum_info.value := null;

    l_cab_generation_type := ecs_get_cab_generation_type
    ( p_ecs_racks_name );

    -- No need to proceed if it is not BMC cabinet
    if (l_cab_generation_type != 'BMC') then
       return;
    end if;
    
    -- build cavium details
    <<each_domu_rec>>
    for domu_rec in 
    ( select ed.hw_node_id, ed.db_client_mac, ed.db_backup_mac, 
             ed.admin_ip,   ed.admin_host_name,
             ehn.oracle_hostname
      from   ecs_domus ed, ecs_hw_nodes ehn
      where  ed.hw_node_id = ehn.id
      and    ed.ecs_racks_name = p_ecs_racks_name
      and    ehn.node_state in ('ALLOCATED', 'RESERVED')
      order by ehn.oracle_hostname 
    ) loop
      <<each_cav_rec>>
      for cav_rec in 
      ( select cavium_id, etherface, etherface_type
        from   ecs_caviums
        where  hw_node_id = domu_rec.hw_node_id
        and (etherface_type = 'DB_CLIENT' OR etherface_type = 'DB_BACKUP')
        order by etherface
      ) loop
        l_idx := l_idx + 1;
        if (l_idx > 1) then
          r_cavimum_info.value := r_cavimum_info.value ||',';
        end if;
        r_cavimum_info.value := r_cavimum_info.value ||'{'
          ||gc_jkey_cavium_id||': "'||cav_rec.cavium_id||'",'
          ||gc_jkey_hw_node_id||': '||domu_rec.hw_node_id||','
          ||gc_jkey_domu_oracle_name||': "'||domu_rec.admin_host_name||'",'
          ||gc_jkey_dom0_oracle_name||': "'||domu_rec.oracle_hostname||'",';
        if (cav_rec.etherface_type = 'DB_CLIENT') then
          r_cavimum_info.value := r_cavimum_info.value
            ||gc_jkey_mac||': "'||domu_rec.db_client_mac||'",'
            ||gc_jkey_etherface||': "'||cav_rec.etherface||'",'
            ||gc_jkey_etherface_type||': "client"';
        elsif (cav_rec.etherface_type = 'DB_BACKUP') then
          r_cavimum_info.value := r_cavimum_info.value
            ||gc_jkey_mac||': "'||domu_rec.db_backup_mac||'",'
            ||gc_jkey_etherface||': "'||cav_rec.etherface||'",'
            ||gc_jkey_etherface_type||': "backup"';
        end if;
        r_cavimum_info.value := r_cavimum_info.value ||'}';
          
      end loop each_cav_rec;
    end loop each_domu_rec;

    if (r_cavimum_info.value is not null) then
      r_cavimum_info.key := gc_cluster_info_key_cavium;
      r_cavimum_info.value := '{'
        ||'"rackname": "'||p_ecs_racks_name||'",'
        ||'"ports": ['||r_cavimum_info.value||']}';
    end if;
    dbms_output.put_line('ecs_gen_cluster_cavium_info EXIT}');
  end ecs_gen_cluster_cavimum_info;
  --
  -- @Private
  -- Get cluster info. Main function that does all the work
  -- It is going to return various records. They are
  -- a. cluster admin info
  --    Depending on the generation type, it will either return
  --    Caviums or generic info
  -- b. cluster customer info
  -- c. dbmc_xml
  function ecs_get_cluster_info_int
  ( p_ecs_racks_name in varchar2 
  , p_node_constraint     in varchar2 default null
  , r_info_coll      out t_cluster_info_coll
  ) return pls_integer is
    l_rc pls_integer := gc_ok;
    l_admin_info        t_cluster_info_record;
    l_client_info       t_cluster_info_record; 
    l_cavimum_info      t_cluster_info_record; 
    l_info_coll         t_cluster_info_coll := t_cluster_info_coll();
  begin
    dbms_output.put_line('ecs_get_cluster_info_int {ENTER'); 

    -- build admin net info
    ecs_gen_cluster_admin_info(p_ecs_racks_name, p_node_constraint, l_admin_info);
    dbms_output.put_line('admin_info done');
    l_info_coll.extend();
    l_info_coll(1) := l_admin_info;
    --dbms_output.put_line('admin_info = '||l_admin_info.value);     

    -- build client net info
    dbms_output.put_line('client info start');
    ecs_gen_cluster_client_info(p_ecs_racks_name, l_client_info);
    dbms_output.put_line('client info end');
    l_info_coll.extend();
    l_info_coll(2) := l_client_info;
    --dbms_output.put_line('client_info = '||l_client_info.value);

    -- build cavium info (for BMC only)
    dbms_output.put_line('cavium info start');
    ecs_gen_cluster_cavimum_info(p_ecs_racks_name, l_cavimum_info);
    dbms_output.put_line('cavium info end');
    if (l_cavimum_info.key is not null) then
      l_info_coll.extend();
      l_info_coll(3) := l_cavimum_info;
    end if;

    r_info_coll := l_info_coll;

    dbms_output.put_line('ecs_get_cluster_info_int EXIT}');
    return l_rc;
  exception 
    when others then
      dbms_output.put_line('ecs_get_cluster_info_int ERR ' ||SQLERRM);
      return gc_error;
  end ecs_get_cluster_info_int;

  --
  -- @Public
  -- Get cluster info
  --
  function ecs_get_cluster_info
  ( p_ecs_racks_name in varchar2 
  ) return t_cluster_info_coll pipelined is
    l_cluster_info_coll t_cluster_info_coll;
    l_rc pls_integer := gc_ok;
    l_idx pls_integer := 0;
  begin
    dbms_output.put_line('ecs_get_cluster_info {ENTER'); 

    l_rc := ecs_get_cluster_info_int
    ( p_ecs_racks_name => p_ecs_racks_name
    , r_info_coll      => l_cluster_info_coll
    );
    dbms_output.put_line('ecs_get_cluster_info: rc = '||l_rc);
    dbms_output.put_line('ecs_get_cluster_info: rowcount = '
                         ||l_cluster_info_coll.count);

    if (l_cluster_info_coll is not null and
        l_cluster_info_coll.count > 0) then
      l_idx := l_cluster_info_coll.first;
      while(l_idx is not null) loop
        pipe row(l_cluster_info_coll(l_idx));
        l_idx := l_cluster_info_coll.next(l_idx);
      end loop;
    end if;

    dbms_output.put_line('ecs_get_cluster_info EXIT}');
  exception 
      when others then
      dbms_output.put_line('ecs_get_cluster_info ERR ' ||SQLERRM);
  end ecs_get_cluster_info;

  --
  -- @Public
  -- Get cluster info
  --
  function ecs_get_cluster_info
  ( p_ecs_racks_name  in varchar2
  , p_what_to_get   in varchar2 default gc_to_get_all 
  ) return ecs_json_coll pipelined is
    l_ecs_racks_name ecs_racks.name%type;
    type t_domu_info is record
    ( hw_node_id           ecs_domus.hw_node_id%type
    , vcn_id               ecs_oracle_admin_subnets.vcn_id%type
    , oracle_admin_subnet  ecs_oracle_admin_subnets.subnet_id%type
    , oracle_admin_hostname  ecs_hw_nodes.oracle_hostname%type
    , admin_nat_ip         ecs_domus.admin_ip%type
    , admin_nat_host_name  ecs_domus.admin_host_name%type
    , db_client_mac        ecs_domus.db_client_mac%type
    , db_client_first_eth   ecs_caviums.etherface%type
    , db_client_first_eth_cavium  ecs_caviums.cavium_id%type
    , db_client_first_eth_mac     ecs_caviums.mac%type
    , db_client_second_eth        ecs_caviums.etherface%type
    , db_client_second_eth_cavium ecs_caviums.cavium_id%type
    , db_client_second_eth_mac    ecs_caviums.mac%type
    , db_backup_mac        ecs_domus.db_backup_mac%type
    , db_backup_first_eth   ecs_caviums.etherface%type
    , db_backup_first_eth_cavium ecs_caviums.cavium_id%type
    , db_backup_first_eth_mac    ecs_caviums.mac%type
    , db_backup_second_eth        ecs_caviums.etherface%type
    , db_backup_second_eth_cavium ecs_caviums.cavium_id%type
    , db_backup_second_eth_mac    ecs_caviums.mac%type
    );
    type t_domu_info_coll  is table of t_domu_info index by pls_integer;
    
    l_domu_info_coll t_domu_info_coll;
    l_current_domu_hw_node_id number := null;
    l_row clob;
    l_idx pls_integer;
  begin
    -- Verify if the given p_ecs_racks_name exists
    select name into l_ecs_racks_name
    from ecs_racks where name = p_ecs_racks_name;

    -- Get the hw_node_id(s)
    for domu_rec in 
    ( select ed.hw_node_id, ed.admin_ip, ed.admin_host_name,
       ed.db_client_mac, ed.db_backup_mac,
       ecvm.cavium_id, ecvm.etherface, ecvm.mac, ecvm.etherface_type,
       eoas.subnet_id, eoas.vcn_id,
       ehn.oracle_hostname
      from ecs_domus ed, ecs_hw_nodes ehn, ecs_caviums ecvm,
           ecs_oracle_admin_subnets eoas
      where ed.ecs_racks_name = p_ecs_racks_name
      and ed.hw_node_id = ehn.id
      and ed.hw_node_id = ecvm.hw_node_id
      and eoas.ecs_racks_name = ed.ecs_racks_name
      order by ehn.oracle_hostname, ecvm.etherface_type, ecvm.etherface
    ) loop
      if (not l_domu_info_coll.exists(domu_rec.hw_node_id)) then
        l_domu_info_coll(domu_rec.hw_node_id).hw_node_id := domu_rec.hw_node_id;
        l_domu_info_coll(domu_rec.hw_node_id).vcn_id     := domu_rec.vcn_id;
        l_domu_info_coll(domu_rec.hw_node_id).admin_nat_ip := domu_rec.admin_ip;
        l_domu_info_coll(domu_rec.hw_node_id).oracle_admin_subnet := domu_rec.subnet_id;
        l_domu_info_coll(domu_rec.hw_node_id).admin_nat_host_name := 
           domu_rec.admin_host_name;
        l_domu_info_coll(domu_rec.hw_node_id).oracle_admin_hostname := 
           domu_rec.oracle_hostname;
        -- l_domu_info_coll(domu_rec.hw_node_id).admin_mac := domu_rec.admin_mac;
      end if;

      if (domu_rec.etherface_type = 'DB_CLIENT') then
        l_domu_info_coll(domu_rec.hw_node_id).db_client_mac := domu_rec.db_client_mac;
        if (l_domu_info_coll(domu_rec.hw_node_id).db_client_first_eth is null) then
          l_domu_info_coll(domu_rec.hw_node_id).db_client_first_eth := domu_rec.etherface;
          l_domu_info_coll(domu_rec.hw_node_id).db_client_first_eth_cavium := 
             domu_rec.cavium_id;        
          l_domu_info_coll(domu_rec.hw_node_id).db_client_first_eth_mac := domu_rec.mac;
        elsif (l_domu_info_coll(domu_rec.hw_node_id).db_client_second_eth is null) then
          l_domu_info_coll(domu_rec.hw_node_id).db_client_second_eth := domu_rec.etherface;
          l_domu_info_coll(domu_rec.hw_node_id).db_client_second_eth_cavium := 
             domu_rec.cavium_id;        
          l_domu_info_coll(domu_rec.hw_node_id).db_client_second_eth_mac := domu_rec.mac;
        end if;
      elsif (domu_rec.etherface_type = 'DB_BACKUP') then
        l_domu_info_coll(domu_rec.hw_node_id).db_backup_mac := domu_rec.db_backup_mac;
        if (l_domu_info_coll(domu_rec.hw_node_id).db_backup_first_eth is null) then
          l_domu_info_coll(domu_rec.hw_node_id).db_backup_first_eth := domu_rec.etherface;
          l_domu_info_coll(domu_rec.hw_node_id).db_backup_first_eth_cavium := 
             domu_rec.cavium_id;        
          l_domu_info_coll(domu_rec.hw_node_id).db_backup_first_eth_mac := domu_rec.mac;
        elsif (l_domu_info_coll(domu_rec.hw_node_id).db_backup_second_eth is null) then
          l_domu_info_coll(domu_rec.hw_node_id).db_backup_second_eth := domu_rec.etherface;
          l_domu_info_coll(domu_rec.hw_node_id).db_backup_second_eth_cavium := 
             domu_rec.cavium_id;        
          l_domu_info_coll(domu_rec.hw_node_id).db_backup_second_eth_mac := domu_rec.mac;
        end if;
      elsif (domu_rec.etherface_type = 'ORACLE_ADMIN') then
        null;
      elsif (domu_rec.etherface_type = 'CUSTOMER_ADMIN') then
        null;
      else
        null;
      end if;
    end loop;


    if (p_what_to_get = gc_to_get_all or 
        p_what_to_get = gc_to_get_caviums or
        p_what_to_get = gc_to_get_orcl_admin or 
        p_what_to_get = gc_to_get_client_admin) then
      l_idx := l_domu_info_coll.first;
      if (l_idx is not null) then
        l_row := '{ "cluster_name" : "'||p_ecs_racks_name||'",'||chr(10);
        l_row := l_row || '  "domus" : ['||chr(10);
      end if;
      while (l_idx is not null) loop
        l_row := l_row || '  {'||chr(10)||
          '  "id" : '||l_domu_info_coll(l_idx).hw_node_id||','||chr(10);
        if (p_what_to_get = gc_to_get_all or 
            p_what_to_get = gc_to_get_orcl_admin) then        
          l_row := l_row ||
            '  "vcn_id" : "'||l_domu_info_coll(l_idx).vcn_id||'",'||chr(10)||
            '  "oracle_admin_subnet" : "'||l_domu_info_coll(l_idx).oracle_admin_subnet||
               '",'||chr(10)||
            '  "oracle_admin_hostname" : "'||l_domu_info_coll(l_idx).oracle_admin_hostname||
               '",'||chr(10)||
            '  "admin_nat_ip" : "'||l_domu_info_coll(l_idx).admin_nat_ip||'",'||chr(10)||
            '  "admin_nat_host_name" : "'||l_domu_info_coll(l_idx).admin_nat_host_name||
               '"';
           if (p_what_to_get = gc_to_get_all) then
             l_row := l_row ||','||chr(10);
           else 
             l_row := l_row ||chr(10);
           end if;
        end if;
        if (p_what_to_get = gc_to_get_all or 
            p_what_to_get = gc_to_get_caviums) then
            l_row := l_row ||
              '  "db_client_first_eth_mac" : "'||
                 l_domu_info_coll(l_idx).db_client_mac||'",'||chr(10)||
              '  "db_client_first_eth" : "'||l_domu_info_coll(l_idx).db_client_first_eth||
                 '",'||chr(10)||
              '  "db_client_first_eth_cavium" : "'||
                 l_domu_info_coll(l_idx).db_client_first_eth_cavium||'",'||chr(10)||
              '  "db_client_second_eth_mac" : "'||
                 l_domu_info_coll(l_idx).db_client_mac||'",'||chr(10)||
              '  "db_client_second_eth" : "'||
                 l_domu_info_coll(l_idx).db_client_second_eth||'",'||chr(10)||
              '  "db_client_second_eth_cavium" : "'||
                 l_domu_info_coll(l_idx).db_client_second_eth_cavium||'",'||chr(10)||
              '  "db_backup_first_eth_mac" : "'||
                 l_domu_info_coll(l_idx).db_backup_mac||'",'||chr(10)||
              '  "db_backup_first_eth" : "'||
                  l_domu_info_coll(l_idx).db_backup_first_eth||'",'||chr(10)||
              '  "db_backup_first_eth_cavium" : "'||
                  l_domu_info_coll(l_idx).db_backup_first_eth_cavium||'",'||chr(10)||
              '  "db_backup_second_eth_mac" : "'||
                  l_domu_info_coll(l_idx).db_backup_mac||'",'||chr(10)||
              '  "db_backup_second_eth" : "'||
                  l_domu_info_coll(l_idx).db_backup_second_eth||'",'||chr(10)||
              '  "db_backup_second_eth_cavium" : "'||
                  l_domu_info_coll(l_idx).db_backup_second_eth_cavium||'"'||chr(10);
         end if;        
        l_idx := l_domu_info_coll.next(l_idx);
        if (l_idx is not null) then
          l_row := l_row || '  },'||chr(10);
        else 
          l_row := l_row || '  }]'||chr(10);
        end if;
      end loop;    
      if (length(l_row) > 0) then
        l_row := l_row || '}';
      end if;
      pipe row (l_row);
    elsif (p_what_to_get = gc_to_get_indx_by_cavimums) then
      l_idx := l_domu_info_coll.first;
      if (l_idx is not null) then
        l_row := '{ '||gc_jkey_rackname||': "'||p_ecs_racks_name||'",'||chr(10);
        l_row := l_row || '  '||gc_jkey_ports||': ['||chr(10);
      end if;
      while (l_idx is not null) loop
        l_row := l_row ||'  {'||chr(10)||
           '  '||gc_jkey_cavium_id||': "'||
           l_domu_info_coll(l_idx).db_client_first_eth_cavium||'",'||chr(10)||
           '  '||gc_jkey_mac||': "'||
           l_domu_info_coll(l_idx).db_client_mac||'",'||chr(10)||
           '  '||gc_jkey_etherface||': "'||
           l_domu_info_coll(l_idx).db_client_first_eth||'",'||chr(10)||
           '  '||gc_jkey_hw_node_id||': '||
           l_domu_info_coll(l_idx).hw_node_id||','||chr(10)||
           '  '||gc_jkey_domu_oracle_name||': "'||
           l_domu_info_coll(l_idx).admin_nat_host_name||'",'||chr(10)||
           '  '||gc_jkey_dom0_oracle_name||': "'||
           l_domu_info_coll(l_idx).oracle_admin_hostname||'",'||chr(10)||
           '  '||gc_jkey_etherface_type||': "client"},'||chr(10)||'  {'||
           '  '||gc_jkey_cavium_id||': "'||
           l_domu_info_coll(l_idx).db_client_second_eth_cavium||'",'||chr(10)||
           '  '||gc_jkey_mac||': "'||
           l_domu_info_coll(l_idx).db_client_mac||'",'||chr(10)||
           '  '||gc_jkey_etherface||': "'||
           l_domu_info_coll(l_idx).db_client_second_eth||'",'||chr(10)||
           '  '||gc_jkey_hw_node_id||': '||
           l_domu_info_coll(l_idx).hw_node_id||','||chr(10)||
           '  '||gc_jkey_domu_oracle_name||': "'||
           l_domu_info_coll(l_idx).admin_nat_host_name||'",'||chr(10)||
           '  '||gc_jkey_dom0_oracle_name||': "'||
           l_domu_info_coll(l_idx).oracle_admin_hostname||'",'||chr(10)||
           '  '||gc_jkey_etherface_type||': "client"},'||chr(10)||'  {'||
           '  '||gc_jkey_cavium_id||': "'||
           l_domu_info_coll(l_idx).db_backup_first_eth_cavium||'",'||chr(10)||
           '  '||gc_jkey_mac||': "'||
           l_domu_info_coll(l_idx).db_backup_mac||'",'||chr(10)||
           '  '||gc_jkey_etherface||': "'||
           l_domu_info_coll(l_idx).db_backup_first_eth||'",'||chr(10)||
           '  '||gc_jkey_hw_node_id||': '||
           l_domu_info_coll(l_idx).hw_node_id||','||chr(10)||
           '  '||gc_jkey_domu_oracle_name||': "'||
           l_domu_info_coll(l_idx).admin_nat_host_name||'",'||chr(10)||
           '  '||gc_jkey_dom0_oracle_name||': "'||
           l_domu_info_coll(l_idx).oracle_admin_hostname||'",'||chr(10)||
           '  '||gc_jkey_etherface_type||':  "backup"},'||chr(10)||'  {'||
           '  '||gc_jkey_cavium_id||': "'||
           l_domu_info_coll(l_idx).db_backup_second_eth_cavium||'",'||chr(10)||
           '  '||gc_jkey_mac||': "'||
           l_domu_info_coll(l_idx).db_backup_mac||'",'||chr(10)||
           '  '||gc_jkey_etherface||': "'||
           l_domu_info_coll(l_idx).db_backup_second_eth||'",'||chr(10)||
           '  '||gc_jkey_hw_node_id||': '||
           l_domu_info_coll(l_idx).hw_node_id||','||chr(10)||
           '  '||gc_jkey_domu_oracle_name||': "'||
           l_domu_info_coll(l_idx).admin_nat_host_name||'",'||chr(10)||
           '  '||gc_jkey_dom0_oracle_name||': "'||
           l_domu_info_coll(l_idx).oracle_admin_hostname||'",'||chr(10)||
           '  '||gc_jkey_etherface_type||': "backup"';

        l_idx := l_domu_info_coll.next(l_idx);
        if (l_idx is not null) then
          l_row := l_row || '},'||chr(10);
        else 
          l_row := l_row || '}]'||chr(10);
        end if;
      end loop;    
      if (length(l_row) > 0) then
        l_row := l_row || '}';
      end if;
      pipe row (l_row);
    end if;
  end ecs_get_cluster_info;


  --
  -- @Public
  --
  function ecs_get_available_capacity
  ( p_node_constraint varchar2 default null
  , p_node_model      varchar2 default null
  , p_avail_domin     varchar2 default null
  ) return ecs_json_coll pipelined
  is
    l_input_cell_count    number := 0;
    l_input_compute_count number := 0;
    l_current_model       varchar2(256) := null; 
    l_current_size        varchar2(256) := null;
    l_current_ad          varchar2(256) := null;
    l_compute_count       number;
    l_cell_count          number;
    l_row clob;
    l_idx pls_integer := 0;
    l_ad_sql             clob;
    l_clu_size_info      clob;
    l_elastic_clu_info   clob;
    l_ad_cursor          SYS_REFCURSOR;
  begin

    if (p_avail_domin is not null) then
      l_ad_sql := 'select distinct availability_domain '||
                  'from ecs_hw_cabinets '||
                  'where availability_domain = '||p_avail_domin;
    else
      l_ad_sql := 'select distinct availability_domain '||
                  'from ecs_hw_cabinets ';
    end if;
    if (p_node_constraint is not null) then
      l_input_cell_count := 
        regexp_substr(p_node_constraint, '(\d+)cell',1,1,'i',1);
    end if;
    if (p_node_model is not null) then
      l_input_compute_count:= 
        regexp_substr(p_node_constraint, '(\d+)comp',1,1,'i',1) ;
    end if;

    l_row := '{'
           ||'"availability_domains": '
           ||'{';

    for ad_rec in (select distinct availability_domain from ecs_hw_cabinets) loop
      if (l_current_ad is null) then
        l_current_ad := ad_rec.availability_domain;
        l_row := l_row ||' "'||ad_rec.availability_domain||'" :';
      elsif (l_current_ad != ad_rec.availability_domain) then
        l_row := l_row ||',"'||ad_rec.availability_domain||'" :';
        l_current_ad := ad_rec.availability_domain;
      else
        l_row := l_row ||',';
      end if;
      l_current_size := null;
      l_clu_size_info := empty_clob();
      -- Get the cookie cutter cluster size counts
      for avail_rec in 
      ( select ehn.cluster_size_constraint, count(ehn.id) node_count, 
               ehn.node_model
        from ecs_hw_nodes ehn, ecs_hw_cabinets ec
        where ehn.node_type  = gc_hw_node_type_compute
        and   ehn.node_state = gc_hw_node_state_free
        and   ehn.cluster_size_constraint != gc_hw_node_cluster_sz_elastic
        and   ec.id                  = ehn.cabinet_id
        and   ec.availability_domain = ad_rec.availability_domain
        group by ehn.cluster_size_constraint, ehn.node_model
        order by ehn.cluster_size_constraint
      ) loop
        l_compute_count := regexp_substr(avail_rec.cluster_size_constraint, 
                                         '(\d+)comp',1,1,'i',1) ;
        if (l_current_size is null) then 
          l_clu_size_info := l_clu_size_info
            ||'"' ||avail_rec.cluster_size_constraint||'": [';
          l_current_size := avail_rec.cluster_size_constraint;
        elsif (l_current_size != avail_rec.cluster_size_constraint) then
          l_clu_size_info := l_clu_size_info||'],'
            ||'"'||avail_rec.cluster_size_constraint||'": [';
          l_current_size := avail_rec.cluster_size_constraint;
        else
          l_clu_size_info := l_clu_size_info||',';
        end if;
  
        l_clu_size_info := l_clu_size_info
                      ||'{"model": "' ||avail_rec.node_model||'",'
                      ||'"count": '||avail_rec.node_count/l_compute_count||'}';
      end loop;

      -- end of cookie cutters
      if (l_current_size is not null) then
        l_row := l_row ||'{'
                       ||'"cluster_sizes":{'||l_clu_size_info;
      end if;
  
      -- get the elastic cluster details
  
      l_current_model := null;
      l_elastic_clu_info := empty_clob();
      for elastic_rec in 
      ( select ehn.cluster_size_constraint, count(ehn.id) node_count, 
               ehn.node_model, ehn.node_type
        from ecs_hw_nodes ehn, ecs_hw_cabinets ec
        where (ehn.node_type = gc_hw_node_type_compute or 
               ehn.node_type = gc_hw_node_type_storage)
        and ehn.node_state   = gc_hw_node_state_free
        and ehn.cluster_size_constraint = gc_hw_node_cluster_sz_elastic
        and ec.id                  = ehn.cabinet_id
        and ec.availability_domain = ad_rec.availability_domain
        group by ehn.cluster_size_constraint,   ehn.node_type, ehn.node_model
        order by ehn.node_model
      ) loop
        if (l_current_model is null) then 
          l_current_model := elastic_rec.node_model;
          l_elastic_clu_info := l_elastic_clu_info
            ||'{ "model": "'||elastic_rec.node_model||'",';
        elsif (l_current_model != elastic_rec.node_model) then
          l_elastic_clu_info := l_elastic_clu_info||'},'
            ||'{"model": "'||elastic_rec.node_model||'",';
          l_current_model := elastic_rec.node_model;
        else
          l_elastic_clu_info := l_elastic_clu_info||',';
        end if;
        l_elastic_clu_info := l_elastic_clu_info
          ||'"'||lower(elastic_rec.node_type)||'_count" : '
          ||elastic_rec.node_count;
      end loop;
      -- l_current_model := 'a';  
      -- l_elastic_clu_info := '{"model": "X6-2", "count":2';
      if (l_current_model is not null) then
        -- end of Elastic members
        l_row := l_row||'],"Elastic":['||l_elastic_clu_info||'}';
      end if;
      l_row := l_row||']';
      l_row := l_row||'}'; --end of cluster_sizes
      l_row := l_row||'}'; --end of AD
  
    end loop;

    l_row := l_row||'}';
    l_row := l_row||'}';
    pipe row(l_row);
  end ecs_get_available_capacity;


  -- 
  -- @Public
  -- ecs_purge_cluster
  --
  function ecs_purge_cluster
  ( p_ecs_racks_name in varchar2 )
  return ecs_json_coll pipelined
  is
    pragma AUTONOMOUS_TRANSACTION;
    l_ecs_racks_name ecs_racks.name%type;
    l_hw_node_usage_count pls_integer;
    l_row clob;
    l_cab_generation_type ecs_hw_cabinets.generation_type%type;
    l_domu_name ecs_racks.domu%type;
    l_actual_domu_name ecs_racks.domu%type;
  begin
    l_cab_generation_type := ecs_get_cab_generation_type
    ( p_ecs_racks_name );

    -- block other delete cluster for the same cluster    
    select ecs_racks_name into l_ecs_racks_name
    from ecs_clusters_purge_queue
    where ecs_racks_name = p_ecs_racks_name
    for update;

    dbms_output.put_line('Got ecs_racks_name');

    -- check if the cluster is in deleted state
    select name into l_ecs_racks_name
    from ecs_racks
    where name = p_ecs_racks_name
    and   status = gc_ecs_racks_status_deleted
    for update;

    -- delete from ecs_ib_pkeys_used
    delete from ecs_ib_pkeys_used 
    where ecs_racks_name = p_ecs_racks_name;
    dbms_output.put_line('deleted ecs_ib_pkeys_used');

    -- delete entry from ecs_clusters_purge_queue
    delete from ecs_clusters_purge_queue 
    where  ecs_racks_name = p_ecs_racks_name;
    dbms_output.put_line('deleted ecs_racks');

    -- delete entry ecs_oracle_admin_subnets
    begin
      delete from ecs_oracle_admin_subnets
      where  ecs_racks_name = p_ecs_racks_name;
      dbms_output.put_line('deleted ecs_oracle_admin_subnets');
    exception
      when no_data_found then
        dbms_output.put_line('no entries in ecs_oracle_admin_subnets');
    end;
    -- update ecs_hw_nodes and ecs_domus and make the nodes free
    -- need to handle the multiple DOMUs in the same hw_node_id
    for doum_rec in 
    ( select * from ecs_domus
      where  ecs_racks_name = p_ecs_racks_name
    ) loop
      dbms_output.put_line('Processing hw_node_id = '||doum_rec.hw_node_id);
      -- see if the hw_node_id is shared between clusters
      select count(hw_node_id) into l_hw_node_usage_count
      from   ecs_domus
      where  hw_node_id = doum_rec.hw_node_id;

      if (l_hw_node_usage_count = 1) then
        -- there is only one cluster is using it and that is the one
        -- being deleted. After that the node is free. So set it to free
        update ecs_hw_nodes set node_state = gc_hw_node_state_free,
               ecs_racks_name_list = null
        where  id = doum_rec.hw_node_id;
        dbms_output.put_line('upated hw_node_id = '||doum_rec.hw_node_id);
      elsif (l_hw_node_usage_count = 0) then
        raise_application_error(xn_bogus_data,
          xm_bogus_data|| ' Cluster '''||p_ecs_racks_name||
          ''' is not hosted on any nodes');
      end if;
    end loop;

    -- Get the domu name
    select domu into l_domu_name from ecs_racks where name=p_ecs_racks_name;
    select regexp_replace(domu, '_pk', '',1, 1, 'i') into l_actual_domu_name
    from ecs_racks where name=p_ecs_racks_name;
    dbms_output.put_line('actual_ecs_racks_name = ' || l_actual_domu_name);

      update ecs_hw_nodes set node_state = gc_hw_node_state_free,
             ecs_racks_name_list = regexp_replace(ecs_racks_name_list, '(^|,)'||
                                    l_actual_domu_name||'(,|$)|(^|,)'||p_ecs_racks_name||'(,|$)', null,1,1,'i')
      where regexp_like(ecs_racks_name_list, '(^|,)'||
                         l_actual_domu_name||'(,|$)|(^|,)'||p_ecs_racks_name||'(,|$)', 'i');

    if (l_cab_generation_type = 'BMC') then
      delete from ecs_domus
      where  ecs_racks_name = p_ecs_racks_name;
      dbms_output.put_line('deleted ecs_domus');

      delete from ecs_cores
      where  rackname = p_ecs_racks_name;
      dbms_output.put_line('deleted ecs_cores');

      delete from ecs_racks
      where  name = p_ecs_racks_name;
    else
      begin
        delete from ecs_clusters
        where  ecs_racks_name = p_ecs_racks_name;
        delete from ecs_database_homes
        where  ecs_racks_name = p_ecs_racks_name;
        delete from ecs_databases
        where  ecs_racks_name = p_ecs_racks_name;
        delete from ecs_cluster_diskgroups
        where  ecs_racks_name = p_ecs_racks_name;
      exception
        when no_data_found then
          dbms_output.put_line('No records in ecs_clusters, '||
                               'ecs_database_homes, ecs_databases'); 
      end;
      update ecs_racks
      set    status = gc_ecs_racks_status_new
      where  name = p_ecs_racks_name;
    end if;

    -- make it permanent           
    commit;

    l_row :=   
       '{ '||chr(10)
     ||'  "ecs_racks_name": "'||p_ecs_racks_name||'",'||chr(10)
     ||'  "action": "purge",'||chr(10)
     ||'  "status": "success"'||chr(10)
     ||'}';

    pipe row(l_row);
  exception
    when others then
      rollback;
      l_row :=   
         '{ '||chr(10)
       ||'  "ecs_racks_name": "'||p_ecs_racks_name||'",'||chr(10)
       ||'  "action": "purge",'||chr(10)
       ||'  "status": "fail",'||chr(10)
       ||'  "reason": "'||SQLERRM||'"'||chr(10)
       ||'}';
  
      pipe row(l_row);

  end ecs_purge_cluster;

  --
  -- @Public
  -- ecs_delete_cluster
  --

  function ecs_delete_cluster
  ( p_ecs_racks_name in varchar2 )
  return ecs_json_coll pipelined
  is
    pragma AUTONOMOUS_TRANSACTION;
    l_ecs_racks_name ecs_racks.name%type;
    l_xml            ecs_racks.xml%type;
    l_purge_time     timestamp;
    l_row            clob;
  begin
    
    -- block other delete cluster for the same cluster    
    select name,xml into l_ecs_racks_name, l_xml
    from ecs_racks
    where name = p_ecs_racks_name
    and   status != gc_ecs_racks_status_deleted
    for update;

    dbms_output.put_line('Got ecs_racks_name');
         
    -- get the default purge time
    begin
      select systimestamp + (value/(24*60*60)) into l_purge_time
      from ecs_properties
      where name = 'CLUSTER_PURGE_DEFAULT_TIME'
      and   type = 'CLUSTER_LIFE_CYCLE';  
    exception
      when no_data_found then
        l_purge_time := systimestamp + 7;
    end; 

    -- move the data into the ecs_clusters_purge_queue
    insert into ecs_clusters_purge_queue
    values (p_ecs_racks_name, l_xml, systimestamp, l_purge_time, default);

    -- delete the ecs_racks entry
    update ecs_racks set status = gc_ecs_racks_status_deleted
    where name = p_ecs_racks_name;

    commit;

    l_row :=   
       '{ '||chr(10)
     ||'  "ecs_racks_name": "'||p_ecs_racks_name||'",'||chr(10)
     ||'  "action": "delete",'||chr(10)
     ||'  "purge_date": "'|| to_char(l_purge_time, 'DD-MM-YYYY HH24:MI:SS')
     ||'",'||chr(10)
     ||'  "status": "success"'||chr(10)
     ||'}';

    pipe row(l_row);

  exception
    when others then
      rollback;  
      l_row :=   
         '{ '||chr(10)
       ||'  "ecs_racks_name": "'||p_ecs_racks_name||'",'||chr(10)
       ||'  "action": "delete",'||chr(10)
       ||'  "status": "fail",'||chr(10)
       ||'  "reason": "'||SQLERRM||'"'||chr(10)
       ||'}';
  
      pipe row(l_row);
  
  end ecs_delete_cluster;

  --
  -- @Public
  -- ecs_undo_delete_cluster
  --
  function ecs_undo_delete_cluster
  ( p_ecs_racks_name in varchar2 )
  return ecs_json_coll pipelined
  is
    pragma AUTONOMOUS_TRANSACTION;
    l_ecs_racks_name ecs_racks.name%type;
    l_row  clob;
  begin
    -- block other delete cluster for the same cluster    
    select name into l_ecs_racks_name
    from ecs_racks
    where name = p_ecs_racks_name
    and   status = gc_ecs_racks_status_deleted
    for update;

    dbms_output.put_line('Got ecs_racks_name');
         
    -- check if the cluster is still in the purge queue
    select ecs_racks_name into l_ecs_racks_name
    from ecs_clusters_purge_queue
    where ecs_racks_name = p_ecs_racks_name
    for update;

    -- move the data into the ecs_clusters_purge_queue
    delete from ecs_clusters_purge_queue
    where ecs_racks_name =  p_ecs_racks_name;

    -- bring back the cluster
    update ecs_racks set status = gc_ecs_racks_status_ready
    where name = p_ecs_racks_name;

    commit;

    l_row :=   
       '{ '||chr(10)
     ||'  "ecs_racks_name": "'||p_ecs_racks_name||'",'||chr(10)
     ||'  "action": "undo_delete",'||chr(10)
     ||'  "status": "success"'||chr(10)
     ||'}';

    pipe row(l_row);

  exception
    when others then
      rollback;  
      l_row :=   
         '{ '||chr(10)
       ||'  "ecs_racks_name": "'||p_ecs_racks_name||'",'||chr(10)
       ||'  "action": "undo_delete",'||chr(10)
       ||'  "status": "fail",'||chr(10)
       ||'  "reason": "'||SQLERRM||'"'||chr(10)
       ||'}';
  
      pipe row(l_row);
 
  end ecs_undo_delete_cluster;

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
  ) return pls_integer
  is 
    l_rc pls_integer := gc_ok;
  begin
    if (gv_ecs_racks_upd_trig_state = 
        gc_ecs_racks_upd_trig_disable) then
      dbms_output.put_line('trigger disabled');
      return gc_ok;
    end if;

    -- update the ecs_ib_pkeys_used
    update ecs_ib_pkeys_used
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update the ecs_oracle_admin_subnets
    update ecs_oracle_admin_subnets
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update the ecs_domus
    update ecs_domus
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update the ecs_hw_nodes    
    update ecs_hw_nodes 
    set ecs_racks_name_list = regexp_replace(ecs_racks_name_list, ','||
                                    p_old_ecs_racks_name||',', 
                                    p_new_ecs_racks_name,1,0,'i')
    where regexp_like(ecs_racks_name_list, ','||
                          p_old_ecs_racks_name||',', 'i');

    -- update ecs_clusters_purge_queue
    update ecs_clusters_purge_queue
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update ecs_clusters
    update ecs_clusters
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update ecs_cluster_diskgroups
    update ecs_cluster_diskgroups
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update ecs_database_homes
    update ecs_database_homes
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update ecs_databases
    update ecs_databases
    set ecs_racks_name = p_new_ecs_racks_name
    where  ecs_racks_name = p_old_ecs_racks_name;

    -- update ecs_diag_rackxml_monitor
    update ecs_diag_rackxml_monitor
    set rack_name = p_new_ecs_racks_name
    where  rack_name = p_old_ecs_racks_name;
   
    -- update ecs_diag_rack_info
    update ecs_diag_rack_info
    set rack_name = p_new_ecs_racks_name
    where  rack_name = p_old_ecs_racks_name;
   
    -- update ecs_diag_fault
    update ecs_diag_fault
    set cluster_name = p_new_ecs_racks_name
    where  cluster_name = p_old_ecs_racks_name;
   
    -- update ecs_diag_request
    update ecs_diag_request
    set target = replace(target, p_old_ecs_racks_name, p_new_ecs_racks_name)
    where  target like '%' || p_old_ecs_racks_name || '%';
   
    return l_rc;
  exception
    when others then
      l_rc := gc_error;
      return l_rc;
  end ecs_update_cluster_name;

  -- 
  -- @Public
  --
  function ecs_list_clusters
  ( p_avail_domin in varchar2 default null 
  , p_cabinet_name in varchar2 default null 
  ) return ecs_json_coll pipelined 
  is
    l_row clob;
    l_sql clob;
    l_cursor integer;
    l_rows_processed integer;
    l_ignore integer;
    l_grp_n_order_by varchar2(512);
    l_cluster_name ecs_racks.name%type;
    l_avail_domin  ecs_hw_cabinets.availability_domain%type;
    l_cabinet_name ecs_hw_cabinets.name%type;
    i              pls_integer := 1;
  begin
    l_grp_n_order_by := 'GROUP BY EHC.AVAILABILITY_DOMAIN, EHC.NAME, 
                         ED.ECS_RACKS_NAME';

    l_sql := 'SELECT EHC.NAME, ED.ECS_RACKS_NAME, EHC.AVAILABILITY_DOMAIN
              FROM ECS_HW_NODES EHN, ECS_HW_CABINETS EHC, ECS_DOMUS ED,
                   ECS_RACKS ER
              WHERE EHN.CABINET_ID = EHC.ID
              AND   ED.HW_NODE_ID = EHN.ID
              AND   ER.NAME = ED.ECS_RACKS_NAME';

    if (p_avail_domin is not null) then
      l_sql := l_sql || ' AND EHC.AVAILABILITY_DOMAIN = :AD';
    end if;

    if (p_cabinet_name is not null) then
      l_sql := l_sql ||' AND EHC.NAME = :CABNAME';
    end if;
   
    l_sql := l_sql||' '||l_grp_n_order_by;

    dbms_output.put_line('sql ='||l_sql);

    -- prase the SQL
    l_cursor := dbms_sql.open_cursor;
    dbms_sql.parse(l_cursor, l_sql, dbms_sql.native);

    -- bind
    if (p_avail_domin is not null) then
      dbms_sql.bind_variable(l_cursor, ':AD', p_avail_domin);
    end if;

    if (p_cabinet_name is not null) then
      dbms_sql.bind_variable(l_cursor, ':CABNAME', p_cabinet_name);
    end if;

    --define
    dbms_sql.define_column(l_cursor, 1, l_cabinet_name, 256);
    dbms_sql.define_column(l_cursor, 2, l_cluster_name, 256);
    dbms_sql.define_column(l_cursor, 3, l_avail_domin, 256);
    
    -- execute
    l_ignore := dbms_sql.execute(l_cursor);
    -- The return value for dbms_sql.execute() for SELECT type of sql is undefined.
    -- Return value of the above needs to be ignored for this reason.
    l_rows_processed := 0;

    -- fetch
    loop
      if (dbms_sql.fetch_rows(l_cursor) > 0) then
        l_rows_processed := l_rows_processed + 1;
        dbms_sql.column_value(l_cursor, 1, l_cabinet_name);
        dbms_sql.column_value(l_cursor, 2, l_cluster_name);
        dbms_sql.column_value(l_cursor, 3, l_avail_domin);

        dbms_output.put_line(l_avail_domin||' '||l_cabinet_name||' '||l_cluster_name);
        if (i = 1) then
          i := i + 1;
        else
          l_row := l_row||',';
        end if;
        l_row := l_row||
                 '{'||gc_jkey_availability_domain||': "'||l_avail_domin||'",'||
                      gc_jkey_cluster_name||': "'||l_cluster_name||'",'||
                      gc_jkey_cabinet_name||': "'||l_cabinet_name||'"}';
      else
        exit;
      end if;
    end loop;
    dbms_sql.close_cursor(l_cursor); 

    if (l_rows_processed > 0) then
      l_row := '{"clusters": ['||l_row||']}';
      pipe row(l_row);    
    end if;
  exception
    when others then 
      dbms_sql.close_cursor(l_cursor); 
  end ecs_list_clusters;

  --
  -- @ Public
  --
  function ecs_delete_cabinet
  ( p_cabinet_name  in varchar2
  ) return ecs_json_coll pipelined 
  is
    pragma AUTONOMOUS_TRANSACTION;
    l_row clob;
    l_trow clob;
    l_cabinet_id ecs_hw_cabinets.name%type;
    l_ib_fabric_id ecs_ib_fabrics.id%type;
    i pls_integer := 1;
  begin
    select id into l_cabinet_id
    from ecs_hw_cabinets 
    where name = p_cabinet_name;

    select ib_fabric_id into l_ib_fabric_id
    from ecs_hw_nodes 
    where cabinet_id = l_cabinet_id
    and rownum < 2;

    --
    -- Find all the clusters hosted on the given cabinet
    --
    for clu_in_cab_rec in
    (SELECT MIN(EHC.ID) ID, EHC.NAME, ED.ECS_RACKS_NAME, EHC.AVAILABILITY_DOMAIN
     FROM ECS_HW_NODES EHN, ECS_HW_CABINETS EHC, ECS_DOMUS ED,
          ECS_RACKS ER
     WHERE EHN.CABINET_ID = EHC.ID
     AND   ED.HW_NODE_ID = EHN.ID
     AND   ER.NAME = ED.ECS_RACKS_NAME 
     AND EHC.NAME = p_cabinet_name
     GROUP BY EHC.AVAILABILITY_DOMAIN, EHC.NAME, ED.ECS_RACKS_NAME)
    loop
      -- delete them one by one
      select column_value into l_trow
      from   table(ecra.ecs_delete_cluster(clu_in_cab_rec.ecs_racks_name));
      if (i = 1) then
        l_row := l_trow;
        i := i + 1;
      else
        l_row := l_row||','||l_trow;
      end if;
      select column_value into l_trow
      from   table(ecra.ecs_purge_cluster(clu_in_cab_rec.ecs_racks_name));
      l_trow := null;

      -- delete from ecs_domus if not BMC
      if ('BMC' != 
          ecs_get_cab_generation_type (clu_in_cab_rec.ecs_racks_name)) then
        begin
          delete from ecs_domus
          where  ecs_racks_name = clu_in_cab_rec.ecs_racks_name;
          delete from ecs_racks
          where  name = clu_in_cab_rec.ecs_racks_name;
        exception
          when no_data_found then
            dbms_output.put_line('No ecs_domus, ecs_racks_ records');
        end;
      end if;
    end loop;    

    -- delete from ecs_caviums and ecs_temp_domus
    for hw_node_rec in 
    (select id from ecs_hw_nodes where cabinet_id = l_cabinet_id) loop
      begin
        delete from ecs_caviums
        where  hw_node_id = hw_node_rec.id; 
        dbms_output.put_line('Deleting ecs_caviums');
        delete from ecs_temp_domus
        where hw_node_id = hw_node_rec.id;
        dbms_output.put_line('Deleting ecs_temp_domus');
        delete from ecs_bonding
        where hw_node_id = hw_node_rec.id;
        dbms_output.put_line('Deleting ecs_bonding');
      exception
        when no_data_found then
          dbms_output.put_line('No ecs_caviums records');
      end;
    end loop;

    -- delete the records from ecs_hw_nodes;
    delete from ecs_hw_nodes 
    where  cabinet_id = l_cabinet_id;
    dbms_output.put_line('Deleting ecs_hw_nodes');

    -- delete from ecs_hw_cabinet_alerts
    delete from ecs_hw_cabinet_alerts
    where  cabinet_id = l_cabinet_id;

    -- delete from ecs_hw_cabinets
    delete from ecs_hw_cabinets
    where  id = l_cabinet_id;
    dbms_output.put_line('Deleting ecs_hw_cabinets');

    -- delete from ecs_ib_fabrics
    delete from ecs_ib_fabrics
    where  id = l_ib_fabric_id;
    dbms_output.put_line('Deleting ecs_ib_fabrics');

    -- delete from ecs_exascale_ip_pool
    delete from ecs_exascale_ip_pool
    where cabinet_name = p_cabinet_name;
    dbms_output.put_line('Deleting ecs_exascale_ip_pool');

    commit;
    l_row := '{"action" : "delete_cabinet", "clusters_deleted" : ['||l_row||']}';
    pipe row(l_row);
  exception
    when others then
      dbms_output.put_line('ecs_delete_cabinet '||SQLERRM);
      rollback;
  end ecs_delete_cabinet;

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
  ) is
    pragma AUTONOMOUS_TRANSACTION;
    l_ib_fabric_id  ecs_ib_fabrics.id%type := null;
    l_ib_ib_addrss  ecs_ib_fabrics%rowtype;
    l_ib_ip         varchar2(256);
    l_ib_ip_count   pls_integer;
  begin
    dbms_output.put_line('ecs_get_next_ib_ip_info {ENTER');   
    r_ip_address := null;
    r_subnet_mask := null;
    --1. get the IB fabric ID   
    if (p_ib_fabric_id is not null) then
      l_ib_fabric_id := p_ib_fabric_id;
    elsif (p_cabinet_name is not null) then
      begin
        select ib_fabric_id into l_ib_fabric_id
        from ecs_hw_cabinets ec, ecs_hw_nodes ehn
        where ec.name = p_cabinet_name
        and   ehn.cabinet_id = ec.id
        and   rownum < 2;
      exception
        when no_data_found then
          raise_application_error(xn_no_cabinet, 
            xm_no_cabinet||' ('|| p_cabinet_name||')');
          return;
      end;
    end if;

    if (l_ib_fabric_id is null) then 
      raise_application_error(xn_no_ibfabric, xm_no_ibfabric);
      return;
    end if;

    --2. Get the next IP address in the given ib_type and in
    --   the given ib fabric
    select * into l_ib_ib_addrss
    from ecs_ib_fabrics
    where  id = l_ib_fabric_id;

    if (p_ib_type = gc_compute_ib) then
      l_ib_ib_addrss.last_used_cib_ip_octet_1 :=
        l_ib_ib_addrss.last_used_cib_ip_octet_1 + 1;

      -- roll over if we reached the limit
      if (l_ib_ib_addrss.last_used_cib_ip_octet_1 = 255) then
        l_ib_ib_addrss.last_used_cib_ip_octet_1 := 1;
        l_ib_ib_addrss.last_used_cib_ip_octet_2 :=
          l_ib_ib_addrss.last_used_cib_ip_octet_2 + 1;
      end if;

      if (l_ib_ib_addrss.last_used_cib_ip_octet_2 = 136) then
        l_ib_ib_addrss.last_used_cib_ip_octet_2 := 132;     
      end if;
      
      update ecs_ib_fabrics
      set    last_used_cib_ip_octet_1 = l_ib_ib_addrss.last_used_cib_ip_octet_1,
             last_used_cib_ip_octet_2 = l_ib_ib_addrss.last_used_cib_ip_octet_2
      where  id = l_ib_fabric_id;
      r_subnet_mask := '255.255.252.0';
      if (l_ib_ib_addrss.sw_type = gc_hw_node_type_rocesw) then
        r_subnet_mask := '255.255.254.0';
      end if;
      r_ip_address := l_ib_ib_addrss.last_used_cib_ip_octet_4 ||'.'
               || l_ib_ib_addrss.last_used_cib_ip_octet_3 ||'.'
               || l_ib_ib_addrss.last_used_cib_ip_octet_2 ||'.'
               || l_ib_ib_addrss.last_used_cib_ip_octet_1;
    else
      l_ib_ib_addrss.last_used_stib_ip_octet_1 :=
        l_ib_ib_addrss.last_used_stib_ip_octet_1 + 1;

      -- roll over if we reached the limit
      if (l_ib_ib_addrss.last_used_stib_ip_octet_1 = 255) then
        l_ib_ib_addrss.last_used_stib_ip_octet_1 := 1;
        l_ib_ib_addrss.last_used_stib_ip_octet_2 :=
          l_ib_ib_addrss.last_used_stib_ip_octet_2 + 1;
      end if;

      if (l_ib_ib_addrss.last_used_stib_ip_octet_2 = 144) then
        l_ib_ib_addrss.last_used_stib_ip_octet_2 := 136;     
      end if;

      update ecs_ib_fabrics
      set  last_used_stib_ip_octet_1 = l_ib_ib_addrss.last_used_stib_ip_octet_1,
           last_used_stib_ip_octet_2 = l_ib_ib_addrss.last_used_stib_ip_octet_2
      where  id = l_ib_fabric_id;
      r_subnet_mask := '255.255.248.0';
      if (l_ib_ib_addrss.sw_type = gc_hw_node_type_rocesw) then
        r_subnet_mask := '255.255.254.0';
      end if;
      r_ip_address := l_ib_ib_addrss.last_used_stib_ip_octet_4 ||'.'
               || l_ib_ib_addrss.last_used_stib_ip_octet_3 ||'.'
               || l_ib_ib_addrss.last_used_stib_ip_octet_2 ||'.'
               || l_ib_ib_addrss.last_used_stib_ip_octet_1;
    end if;

    --3. check if the IP is an existing one
    -- BIG TODO
    commit;
    dbms_output.put_line(p_ib_type||' ip = '||r_ip_address||
                                    ' netmask = '||r_subnet_mask);
    dbms_output.put_line('ecs_get_next_ib_ip_info EXIT}');
    return;
  exception
    when others then
      dbms_output.put_line('cib = '||
                           l_ib_ib_addrss.last_used_cib_ip_octet_1 ||' '||
                           l_ib_ib_addrss.last_used_cib_ip_octet_2);

      dbms_output.put_line('stib = '||
                           l_ib_ib_addrss.last_used_stib_ip_octet_1 ||' '||
                           l_ib_ib_addrss.last_used_stib_ip_octet_2);

      dbms_output.put_line('ecs_get_next_ib_ip_info ERROR : '
                           ||SQLERRM||' EXIT}');
      rollback;
      return;
  end ecs_get_next_ib_ip_info;

  --
  -- @ Public
  --
  function ecs_update_cavium
  ( p_old_cav in varchar2
  , p_new_cav in varchar2
  ) return pls_integer
  is
  pragma AUTONOMOUS_TRANSACTION;
  l_hw_node_id ecs_caviums.hw_node_id%type;

  begin
    -- select the hw_node_id
    SELECT DISTINCT hw_node_id INTO l_hw_node_id FROM ecs_caviums 
    WHERE cavium_id = p_old_cav;
    -- update xml
    UPDATE ecs_racks SET xml=regexp_replace(xml, p_old_cav, p_new_cav) 
    WHERE name IN 
    (SELECT ecs_racks_name FROM ecs_domus WHERE ecs_domus.hw_node_id = l_hw_node_id);
    -- update update_xml column
    UPDATE ecs_racks SET updated_xml=regexp_replace(updated_xml, p_old_cav, p_new_cav)
    WHERE name IN
    (SELECT ecs_racks_name FROM ecs_domus WHERE ecs_domus.hw_node_id = l_hw_node_id);

    -- update the cavium
    UPDATE ecs_caviums SET cavium_id=p_new_cav WHERE cavium_id = p_old_cav;
    commit;
    return gc_ok;
  exception
    when no_data_found then
      dbms_output.put_line('ecs_update_cavium '||SQLERRM);
      rollback;
      return gc_error;
  end ecs_update_cavium;



  -- @ Public
  -- Move finished one-off job to ecs_scheduledjob_history table.
  -- Implemented as a PL/SQL to support atomic operation of
  -- insert and delete.
  -- type and status are given as conditions for later use.
  procedure ecs_archive_scheduledjob
  ( p_job_id in number
  , p_type in varchar2
  , p_status in varchar2
  ) is
  begin
    insert into ecs_scheduledjob_history (
        id, job_class, job_cmd, job_params, start_time,
        end_time, last_update_by, target_server, type, 
        planned_start, timeout, exit_status, result, job_group_id, start_time_ts)
      select id, job_class, job_cmd, job_params, last_update,
        systimestamp, last_update_by, target_server, type, 
        planned_start, timeout, '', null, job_group_id, current_timestamp
      from ecs_scheduledjob
      where id=p_job_id and type=p_type and status=p_status;

    delete from ecs_scheduledjob where id=p_job_id and type=p_type and status=p_status;
  end ecs_archive_scheduledjob;

  -- @ Public
  -- Enh 36383801
  procedure proc_ecs_lse_logging
  ( i_OneView_RequestTime in timestamp
  , i_CP_RequestTime in timestamp
  , i_ECRA_RequestTime in timestamp
  , i_ECRADB_RequestTime in timestamp
  , o_ECRADB_ResponseTime out timestamp
  , o_ECRADB_ERRMSG out varchar2
  ) is
  v_ENABLE_LSE_LOG_VALUE varchar2(50);
  v_ECRADB_TS timestamp;
  v_code NUMBER;
  v_errm VARCHAR2(64);
  begin
    SELECT VALUE INTO v_ENABLE_LSE_LOG_VALUE FROM ECS_PROPERTIES WHERE NAME='ENABLE_LSE_LOG';
    IF (v_ENABLE_LSE_LOG_VALUE = 'TRUE') THEN
      SELECT systimestamp INTO v_ECRADB_TS FROM DUAL;
      INSERT INTO ECS_LSE_LOG(oneview_requesttime,cp_requesttime,ecra_requesttime,ecradb_requesttime,ecradb_responsetime) VALUES(i_OneView_RequestTime,i_CP_RequestTime,i_ECRA_RequestTime,i_ECRADB_RequestTime,v_ECRADB_TS);
      o_ECRADB_ResponseTime := v_ECRADB_TS;
      o_ECRADB_ERRMSG:='0';
      commit;
    END IF;
    EXCEPTION WHEN OTHERS THEN
      v_code := SQLCODE;
      v_errm := SUBSTR(SQLERRM, 1 , 64);
      o_ECRADB_ERRMSG := 'Error code ' || v_code || ': ' || v_errm;
      SELECT systimestamp into o_ECRADB_ResponseTime FROM DUAL;
      ROLLBACK;
  END proc_ecs_lse_logging;
  

  -- @ Public
  -- If now row exists, insert a new one
  -- If row exists and current - max(last_ts) > ecra_heartbeat_timeout, 
  -- create a new row
  -- If row exists and current - max(last_ts) < ecra_heartbeat_timeout, 
  -- update the last row
  procedure ecs_update_ecra_heartbeat
  ( p_ecra_server in varchar2
  ) is
    l_rows      number := 0;
    l_diff      number := 0;
    l_timeout   number := 0;
    l_id        number := 0;
  begin
    select count(*) into l_rows
    from ecs_ecra_heartbeat
    where ecra_server = p_ecra_server;

    if (l_rows = 0) then
      insert into ecs_ecra_heartbeat (ecra_server, start_ts, last_ts)
        values (p_ecra_server, sysdate, sysdate);
    else
      select id, (extract(day from (sysdate - last_ts))*24*60*60 + 
              extract(hour from (sysdate - last_ts))*60*60 + 
              extract(minute from (sysdate - last_ts))*60 + 
              extract(second from (sysdate - last_ts)))
        into l_id, l_diff
      from ecs_ecra_heartbeat
      where last_ts in (
        select max(last_ts)
        from ecs_ecra_heartbeat
        where ecra_server = p_ecra_server
        ) and ecra_server = p_ecra_server;

      select to_number(value, 999999) into l_timeout
      from ecs_properties
      where name = 'ECRA_HEARTBEAT_TIMEOUT';
      
      if (l_diff > l_timeout) then
        insert into ecs_ecra_heartbeat (ecra_server, start_ts, last_ts)
          values (p_ecra_server, sysdate, sysdate);
      else
        update ecs_ecra_heartbeat 
        set last_ts = sysdate
        where id = l_id;
      end if;
    end if;
  end ecs_update_ecra_heartbeat;



begin
  -- init the gv_cluster_size_hash
  gv_cluster_size_hash('32')  := 'quarter'; -- 3cell2comp
  gv_cluster_size_hash('64')  := 'half';    -- 6cell4comp
  gv_cluster_size_hash('128') := 'full';    -- 12cell8comp
  gv_cluster_size_hash('2416') := 'double';    -- 24cell16comp
  gv_cluster_size_hash('999') := 'elastic'; -- anycellanycomp

  gv_ecs_racks_upd_trig_state := gc_ecs_racks_upd_trig_enable;
end ecra;
/

CREATE OR REPLACE PACKAGE state_mgmt
    AS
    PROCEDURE state_lock(
                o_return       OUT number,
                o_lock_handle  OUT state_lock_data.lock_handle%TYPE,
                o_state_handle OUT state_lock_data.state_handle%TYPE);
    PROCEDURE state_insert_unlock(
                o_return       OUT number,
                o_state_handle OUT state_lock_data.state_handle%TYPE,
                r_lock_handle  IN  state_lock_data.lock_handle%TYPE,
                r_state_handle IN  state_lock_data.state_handle%TYPE,
                r_state_data   IN  CLOB
                );
    PROCEDURE state_unlock(
                o_return         OUT number,
                o_state_handle   OUT state_lock_data.state_handle%TYPE,
                r_lock_handle    IN  state_lock_data.lock_handle%TYPE,
                r_state_handle   IN  state_lock_data.state_handle%TYPE
                );
    PROCEDURE state_query(
                o_return       OUT number,
                o_state_data   OUT CLOB,
                i_state_handle IN  state_lock_data.state_handle%TYPE
                );
END state_mgmt;
/

CREATE OR REPLACE PACKAGE BODY state_mgmt AS
    PROCEDURE state_lock(o_return       OUT number,
                         o_lock_handle  OUT state_lock_data.lock_handle%TYPE,
                         o_state_handle OUT state_lock_data.state_handle%TYPE)
    IS
        cur_lock_handle  state_lock_data.lock_handle%TYPE;
        cur_state_handle state_lock_data.state_handle%TYPE;
        row_locked EXCEPTION;
        PRAGMA EXCEPTION_INIT(row_locked, -54); -- OER(54) - locked row
    BEGIN
        o_return := 1;
        -- Select the only row in the state lock data in update mode.
        SELECT lock_handle, state_handle
            INTO cur_lock_handle, cur_state_handle
        FROM state_lock_data
        WHERE rownum = 1
            AND lock_state = 'FREE'
        FOR UPDATE NOWAIT;
         
        -- Lock is free, bump the generation count and set the status
        o_lock_handle  := cur_lock_handle + 1;
        o_state_handle := cur_state_handle;
         
        -- Update to locked state
        UPDATE state_lock_data
        SET lock_handle = o_lock_handle,
            lock_state = 'LOCKED'
        WHERE rownum = 1
            AND lock_state = 'FREE';
         
        -- Successfully locked the state, commit to release the row lock.
        COMMIT;
         
        EXCEPTION
            WHEN no_data_found THEN
                o_lock_handle := 0;
                o_return  := 0;
            WHEN row_locked THEN
                o_lock_handle := 0;
                o_return  := 2;
    END state_lock;

    PROCEDURE state_insert_unlock(
                o_return         OUT number,
                o_state_handle   OUT state_lock_data.state_handle%TYPE,
                r_lock_handle    IN  state_lock_data.lock_handle%TYPE,
                r_state_handle   IN  state_lock_data.state_handle%TYPE,
                r_state_data IN  CLOB
                )
    IS
        cur_lock_handle  state_lock_data.lock_handle%TYPE;
        cur_state_handle state_lock_data.state_handle%TYPE;
        row_locked EXCEPTION;
        PRAGMA EXCEPTION_INIT(row_locked, -54); -- OER(54) - locked row
    BEGIN
        o_return := 1;
        -- Select the only row in the state lock data in update mode. It should
        -- match the caller's generation count and state information
        SELECT lock_handle, state_handle
            INTO cur_lock_handle, cur_state_handle
        FROM state_lock_data
        WHERE rownum = 1
            AND lock_state = 'LOCKED'
            AND state_handle = r_state_handle
            AND lock_handle = r_lock_handle
        FOR UPDATE NOWAIT;
         
        cur_lock_handle := cur_lock_handle + 1;
         
        -- TODO - generate proper state id
        o_state_handle := cur_state_handle + 1;
         
        -- Insert new state
        INSERT INTO state_store (STATE_HANDLE, STATE_DATA)
            VALUES(o_state_handle, r_state_data);
         
        -- Update to free state
        UPDATE state_lock_data
        SET lock_handle = cur_lock_handle,
            state_handle = o_state_handle,
            lock_state = 'FREE'
        WHERE rownum = 1
            AND lock_state = 'LOCKED';
             
        COMMIT;
             
        EXCEPTION
            WHEN no_data_found THEN
                o_state_handle := 0;
                o_return   := 0;
            WHEN row_locked THEN
                o_state_handle := 0;
                o_return   := 2;
                 
    END state_insert_unlock;

    PROCEDURE state_unlock(
                o_return         OUT number,
                o_state_handle   OUT state_lock_data.state_handle%TYPE,
                r_lock_handle    IN  state_lock_data.lock_handle%TYPE,
                r_state_handle   IN  state_lock_data.state_handle%TYPE
                )
    IS
        cur_lock_handle  state_lock_data.lock_handle%TYPE;
        cur_state_handle state_lock_data.state_handle%TYPE;
        row_locked EXCEPTION;
        PRAGMA EXCEPTION_INIT(row_locked, -54); -- OER(54) - locked row
    BEGIN
        o_return := 1;
        -- Select the only row in the state lock data in update mode. It should
        -- match the caller's generation count and state information
        SELECT lock_handle, state_handle
            INTO cur_lock_handle, cur_state_handle
        FROM state_lock_data
        WHERE rownum = 1
            AND lock_state = 'LOCKED'
            AND state_handle = r_state_handle
            AND lock_handle = r_lock_handle
        FOR UPDATE NOWAIT;
         
        cur_lock_handle := cur_lock_handle + 1;
        o_state_handle := r_state_handle;
         
        -- Update to free state
        UPDATE state_lock_data
        SET lock_handle = cur_lock_handle,
            state_handle = r_state_handle,
            lock_state = 'FREE'
        WHERE rownum = 1
            AND lock_state = 'LOCKED';
             
        COMMIT;
             
        EXCEPTION
            WHEN row_locked THEN
                o_state_handle := 0;
                o_return   := 0;
                 
    END state_unlock;
     
    PROCEDURE state_query(
                o_return        OUT number,
                o_state_data    OUT CLOB,
                i_state_handle  IN  state_lock_data.state_handle%TYPE
                )
    IS
    BEGIN
        SELECT state_data
            INTO o_state_data
        FROM state_store
        WHERE state_handle = i_state_handle;
         
        o_return := 1;
         
        EXCEPTION
            WHEN no_data_found THEN
                o_return := 0;
    END state_query;
     
END state_mgmt;
/


show errors;

