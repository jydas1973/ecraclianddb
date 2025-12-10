Rem
Rem $Header: ecs/ecra/db/upgrade1723.sql /main/14 2017/05/11 13:41:58 nkedlaya Exp $
Rem
Rem upgrade1723.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1723.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1723.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nkedlaya    05/01/17 - 25962382 - compose cluster takes optional cabinet
Rem                           name
Rem    nkedlaya    04/26/17 - 25946435 - DELETE CABINET FEATURE IN BMC
Rem    nkedlaya    04/21/17 - bug 25933778 - allow cabinet level subnet id in
Rem                           the bmc
Rem    nkedlaya    04/14/17 - Bug 25896745 - gen2 cluster info json has
Rem                           extranious space chars in some keys leading to
Rem                           failur
Rem    nkedlaya    04/12/17 - Bug 25883898 - gen2 ecra compose cluster should
Rem                           use its own node sequence
Rem    nkedlaya    04/11/17 - bug 25878886: all values in ecs_racks.status are
Rem                           upper case
Rem    nkedlaya    04/06/17 - bug 25839624 : fix mac data mismatch between flat
Rem                           file loader and cavium ports
Rem    nkedlaya    03/29/17 - 25802231 - ECS_RACKS.NAME COLUMN UPDATE RETURNS
Rem                           ORA-02292
Rem    brsudars    03/25/17 - No SDI changes
Rem    xihzhang    03/14/17 - Bug 25614977 ECRA upgrade hang
Rem    xihzhang    03/10/17 - Bug 25704598 BM: enhance idemtoken
Rem    xihzhang    03/01/17 - Bug 25654608 BM: enhance reserveCapacity
Rem    xihzhang    02/21/17 - Bug 25619867 BM: implement reserveCapacity
Rem    xihzhang    02/21/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

create table ecs_idemtokens (
    id         varchar2(128) not null,
    type       varchar2(256),
    created    varchar2(128)  not null,
    resources  varchar2(4000),
    CONSTRAINT token_id PRIMARY KEY (id)
);

create table ecs_zones (
  region             varchar2(100),
  dc                 varchar2(100),     -- data center
  zone               varchar2(100), 
  location           varchar2(30) default 'LOCAL' not null, -- REMOTE, LOCAL
  uri                varchar2(512),
  bkupuri            varchar2(512),
  username           varchar2(256) not null,
  passwd             BLOB not null,
  CONSTRAINT ecs_zones_location_ck CHECK (LOCATION in ('REMOTE', 'LOCAL')),
  CONSTRAINT uri_unique UNIQUE(URI) enable,
  CONSTRAINT bkupuri_unique UNIQUE(BKUPURI) enable,
  CONSTRAINT zone_pk  PRIMARY KEY (zone)
);

alter table pods
    add cloud varchar2(32) default 'Gen1' null;

-- specifies the idemtoken expiration time
INSERT INTO ecs_properties (name, type, value) VALUES ('IDEMTOKEN_EXPIRATION_TIME', 'IDEMTOKEN', '86400000');

commit;


Rem -- Gen2 tables begin ---
create sequence ecs_hw_cabinets_seq_id nocache nocycle order;
create table ecs_hw_cabinets(
    id                  number            not null,
    name                varchar2(256)     not null,
    availability_domain varchar2(256)     not null,
    cage_id             varchar2(256)     not null,
    model               varchar2(512)     not null,
    node_list           varchar2(512)     not null,
    time_zone           varchar2(256)     not null, 
    domainname          varchar2(512)     not null,
    subnet_id           varcahr2(4000)    not null,
    product             varchar2(256)     not null,
    CONSTRAINT ecs_hw_cabinets_pk PRIMARY KEY (id),
    CONSTRAINT ecs_hw_cabinets_name UNIQUE (name)
);

create or replace trigger ecs_hw_cabinets_id
before insert on ecs_hw_cabinets
for each row
begin
  :new.id := ecs_hw_cabinets_seq_id.nextval;
end;
/

create sequence ecs_ib_fabrics_seq_id nocache nocycle order;
create table ecs_ib_fabrics(
    id  number                   not null,
    fabric_sha512 varchar2(1024) not null,
    list_of_ibsw  clob           not null,
    CONSTRAINT ecs_ib_fabrics_pk PRIMARY KEY (id)
);

create or replace trigger ecs_ib_fabrics_id
before insert on ecs_ib_fabrics
for each row
begin
  :new.id := ecs_ib_fabrics_seq_id.nextval;
end;
/


create sequence ecs_hw_nodes_seq_id nocache nocycle order;
create sequence ecs_hw_nodes_seq_clu_hw_id nocache nocycle order;
create table ecs_hw_nodes(
    id                        number        not null,
    cabinet_id                number        not null,
    ib_fabric_id              number        not null,
    ecs_racks_name_list       varchar2(4000),
    node_type                 varchar2(256) not null,
    node_model                varchar2(256) not null, 
    sw_version                varchar2(256) not null,
    date_modified timestamp   default systimestamp not null,
    oracle_ip                 varchar2(256) not null,
    oracle_hostname           varchar2(256) not null,
    oracle_ilom_ip            varchar2(256),
    oracle_ilom_hostname      varchar2(256),
    location_rackunit         number(3)     not null,
    node_type_order_bottom_up number(3)     not null, 
    cluster_size_constraint   varchar2(256),
    node_state                varchar2(32) default 'FREE' not null,
    CONSTRAINT ecs_hw_nodes_pk PRIMARY KEY (id),
    CONSTRAINT ecs_hw_nodes_cabinet_id_fk 
      FOREIGN KEY (cabinet_id)
      REFERENCES ecs_hw_cabinets(id) deferrable initially deferred,
    CONSTRAINT ecs_hw_nodes_ib_fabric_id_fk
      FOREIGN KEY (ib_fabric_id)
      REFERENCES ecs_ib_fabrics(id) deferrable initially deferred,
    CONSTRAINT ck_ecs_hw_nodes_clu_size 
      CHECK (cluster_size_constraint in 
             ('12cell8comp3ibsw2pdu1ethsw',
              '12cell8comp2ibsw2pdu1ethsw',
              '6cell4comp3ibsw2pdu1ethsw',
              '6cell4comp2ibsw2pdu1ethsw',
              '3cell2comp3ibsw2pdu1ethsw', 
              '3cell2comp2ibsw2pdu1ethsw', 
              'half_3cell2comp3ibsw2pdu1ethsw',
              'half_3cell2comp2ibsw2pdu1ethsw',
              'other')),
    CONSTRAINT ck_ecs_hw_nodes_node_type 
      CHECK (node_type in ('CELL', 'COMPUTE', 'IBSW', 'PDU', 'ETHERSW')),
    CONSTRAINT ck_ecs_hw_nodes_node_state CHECK (node_state in ('FREE', 'COMPOSING', 'ALLOCATED', 'HW_REPAIR', 'HW_UPGRADE', 'HW_FAIL')),
    CONSTRAINT ck_ecs_hw_nodes_ilom_ip CHECK
    (( /* if not null, node type should be 'CELL', 'COMPUTE' */
          oracle_ilom_ip is not null
      and node_type in ('CELL', 'COMPUTE')
    )
    or
    ( /* if null node type should be ''IBSW', 'PDU', 'ETHERSW' */
          oracle_ilom_ip is null
      and node_type in ('IBSW', 'PDU', 'ETHERSW')
    )),
    CONSTRAINT ck_ecs_hw_nodes_ilom_hostname CHECK
    (( /* if not null, node type should be 'CELL', 'COMPUTE' */
          oracle_ilom_hostname is not null
      and node_type in ('CELL', 'COMPUTE')
    )
    or
    ( /* if null node type should be ''IBSW', 'PDU', 'ETHERSW' */
          oracle_ilom_hostname is null
      and node_type in ('IBSW', 'PDU', 'ETHERSW')
    ))
);

create or replace trigger ecs_hw_nodes_id
before insert on ecs_hw_nodes
for each row
begin
  :new.id := ecs_hw_nodes_seq_id.nextval;
end;
/


create index ecs_hd_nodes_cabnt_id_fk_idx 
  on ecs_hw_nodes(cabinet_id);
create index ecs_hw_nodes_ibfbrcid_fk_idx
  on ecs_hw_nodes(ib_fabric_id);
create index ecs_hw_nodes_ern_idx
  on ecs_hw_nodes(ecs_racks_name_list);
create index ecs_hw_nodes_ohn_idx
  on ecs_hw_nodes(oracle_hostname);


create table ecs_ib_pkeys_used
(   ib_fabric_id          number        not null,
    pkey                  varchar2(6)   not null,
    ecs_racks_name        varchar2(256) not null,
    pkey_use              varchar2(256) not null,
    CONSTRAINT ecs_ib_pkeys_used_fk FOREIGN KEY (ecs_racks_name)
      REFERENCES ecs_racks(name) deferrable initially deferred,
    CONSTRAINT ecs_ib_fabrics_id_fk FOREIGN KEY (ib_fabric_id) 
      REFERENCES ecs_ib_fabrics(id) deferrable initially deferred,
    CONSTRAINT ecs_ib_pkeys_used_ck CHECK (pkey_use in ('STORAGE', 'COMPUTE'))
);

create sequence ecs_ib_compute_pkeys_seq_id 
  start with 40960 -- 0xa000
  increment by 1
  minvalue 40960
  maxvalue 43519   -- 0xa9ff
nocache nocycle order;

create sequence ecs_ib_storage_pkeys_seq_id 
  start with 43520  -- 0xaa00
  increment by 1
  minvalue 43520
  maxvalue 45055    -- 0xafff
nocache nocycle order;

create table ecs_caviums
(   hw_node_id number         not null,
    cavium_id  varchar2(4000) not null, 
    etherface  varchar2(256)  not null,
    MAC        varchar2(256)  not null,
    etherface_type varchar2(256) not null,
    CONSTRAINT ecs_caviums_node_id_fk FOREIGN KEY (hw_node_id) 
      REFERENCES ecs_hw_nodes(id) deferrable initially deferred,
    CONSTRAINT ecs_caviums_cavium_id UNIQUE (cavium_id),
    CONSTRAINT ecs_caviums_eface_type_ck 
      CHECK (etherface_type in ('DB_CLIENT', 'DB_BACKUP', 'ORACLE_ADMIN', 'CUSTOMER_ADMIN', 'OTHER'))
);
create index ecs_caviums_node_id_fk_idx
  on ecs_caviums(hw_node_id);


create table ecs_vcns
( id                  varchar2(4000) not null,
  availability_domain varchar2(256)  not null,
  subnet_id           varchar2(4000)  not null,
  CONSTRAINT ecs_vcns_pk PRIMARY KEY (id)
);

create table ecs_oracle_admin_subnets
(   vcn_id         varchar2(4000) not null,
    subnet_id      varchar2(4000) not null,
    ecs_racks_name varchar2(256)  not null ,
    CONSTRAINT ecs_oracle_admin_subnets_fk FOREIGN KEY(vcn_id) 
      REFERENCES ecs_vcns(id) deferrable initially deferred,
    CONSTRAINT ecs_oracle_admin_subnets_fk1 FOREIGN KEY(ecs_racks_name) 
      REFERENCES ecs_racks(name) deferrable initially deferred
);
create index ecs_orcl_adm_subnets_fk_idx
  on ecs_oracle_admin_subnets(vcn_id);
create index ecs_orcl_adm_subnets_fk1_idx
  on ecs_oracle_admin_subnets(ecs_racks_name);

create table ecs_domus
( ecs_racks_name       varchar2(256) not null,
  hw_node_id           number        not null,
  admin_nat_ip         varchar2(256),  
  admin_nat_host_name  varchar2(512) not null,
  db_client_mac        varchar2(256) not null,
  db_backup_mac        varchar2(256) not null,
  CONSTRAINT ecs_domus_ecs_racks_name_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred,
  CONSTRAINT ecs_domus_hw_node_id_fk FOREIGN KEY (hw_node_id)
    REFERENCES ecs_hw_nodes(id) deferrable initially deferred
);
create index ecs_domus_ecsracksname_fk_idx on ecs_domus(ecs_racks_name);
create index ecs_domus_hw_node_id_fk_idx on ecs_domus(hw_node_id);

create table ecs_temp_domus
( hw_node_id           number        not null,
  admin_nat_ip         varchar2(256) not null,
  admin_nat_host_name  varchar2(512) not null,
  db_client_mac        varchar2(256) not null,
  db_backup_mac        varchar2(256) not null,
  CONSTRAINT ecs_tdomus_hw_node_id_pk PRIMARY KEY (hw_node_id),
  CONSTRAINT ecs_tdomus_hw_node_id_fk FOREIGN KEY (hw_node_id)
    REFERENCES ecs_hw_nodes(id) deferrable initially deferred
);


create table ecs_clusters_purge_queue
( ecs_racks_name    varchar2(100) not null,
  cluster_xml       CLOB,
  deleted_time      timestamp default systimestamp not null ,
  purge_time        timestamp default (systimestamp + 7) not null ,
  CONSTRAINT ecs_clusters_prgq_rakname_pk PRIMARY KEY (ecs_racks_name),
  CONSTRAINT ecs_clusters_prgq_rakname_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);

INSERT INTO ecs_properties (name, type, value) VALUES ('CLUSTER_PURGE_DEFAULT_TIME', 'CLUSTER_LIFE_CYCLE', (60 * 60 * 24 * 7));

commit;

Rem -- Gen2 tables end ---

Rem -- Gen2 PL/SQL package begin ---
create or replace package ecra is
  -- actions
  gc_commit   constant varchar2(20) := 'COMMIT';
  gc_rollback constant varchar2(20) := 'ROLLBACK';

  -- return status constants
  gc_ok      constant number := 0;
  gc_error   constant number := 1;
  gc_warning constant number := 2;

  -- Record type to pipe JSON rows
  type ecs_json_coll is table of clob;

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
  , p_admin_hostname_list in varchar2
  , p_admin_nat_ip_list   in varchar2
  , p_db_client_mac_list  in varchar2
  , p_db_backup_mac_list  in varchar2
  , p_action              in varchar2 default gc_commit -- Can be 'COMMIT' or 'ROLLBACK'
  ) return ecs_json_coll pipelined;
  
  --
  -- @Public
  -- Get cluster info
  --
  gc_to_get_all constant varchar2(20)              := 'ALL';
  gc_to_get_caviums constant varchar2(20)          := 'CAVIUMS';
  gc_to_get_orcl_admin constant varchar2(32)       := 'ORCL_ADMIN';
  gc_to_get_client_admin constant varchar2(32)     := 'CLIENT_ADMIN';
  gc_to_get_indx_by_cavimums constant varchar2(32) := 'INDEX_BY_CAVIUMS';

  function ecs_get_cluster_info
  ( p_ecs_racks_name in varchar2 
  , p_what_to_get  in varchar2 default gc_to_get_all 
    -- allowed values are gc_to_get_* constants
  ) return ecs_json_coll pipelined;
  
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

end ecra;
/

create or replace package body ecra is

  -- ecs_hw_nodes.node_state constants
  gc_hw_node_state_free constant varchar2(20) := 'FREE';
  gc_hw_node_state_composing constant varchar2(20) := 'COMPOSING';
  gc_hw_node_state_allocated constant varchar2(20) := 'ALLOCATED';

  -- ecs_racks.status constants
  gc_ecs_racks_status_new   constant varchar2(20) := 'NEW';
  gc_ecs_racks_status_ready constant varchar2(20) := 'READY';
  gc_ecs_racks_status_deleted constant varchar2(20) := 'DELETED';
  gc_ecs_racks_status_provisoned constant varchar2(20) := 'PROVISONED';

  -- ecs_hw_nodes.node_type constants
  gc_hw_node_type_compute  constant varchar2(20) := 'COMPUTE';
  gc_hw_node_type_storage  constant varchar2(20) := 'CELL';
  gc_hw_node_type_ibsw     constant varchar2(20) := 'IBSW';
  gc_hw_node_type_pdu      constant varchar2(20) := 'PDU';
  gc_hw_node_type_ethdw    constant varchar2(20) := 'ETHERSW';

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
    l_pdu_count     number;
    l_ethsw_count   number;
    l_cabinet_id    ecs_hw_cabinets.id%type;
    l_ib_fabric_id  ecs_ib_fabrics.id%type;
    l_cluster_hw_id number := ecs_hw_nodes_seq_clu_hw_id.nextval;
    l_vcn_id        ecs_vcns.id%type := null;
    l_vcn_subnet    ecs_vcns.subnet_id%type := null;
    l_cab_subnet    ecs_hw_cabinets.subnet_id%type := null;
    l_vcn_subnet_array dbms_sql.varchar2_table;
    l_dns_array        dbms_sql.varchar2_table;
    l_ntp_array        dbms_sql.varchar2_table;
    l_gateway_array    dbms_sql.varchar2_table;
    l_node_seq         pls_integer := 1;
    l_node_seq_coll    dbms_sql.number_table;
    -- l_cabinet_name ecs_hw_cabinets.name%type;
    -- l_product      ecs_hw_cabinets.product%type;
    l_storage_pkey ecs_ib_pkeys_used.pkey%type;    
    l_row             clob;
    l_nodes           clob;
    l_etherfaces      clob;
    l_etherface_types clob;
    l_macs            clob;
    l_cavimus         clob;

    l_hw_node_id_coll dbms_sql.number_table;
    l_hw_node_info ecs_hw_nodes%rowtype;
    l_caviums_info    ecs_caviums%rowtype;
    l_vcns_info       ecs_vcns%rowtype;
    l_domus_info      ecs_domus%rowtype;
    l_tdomus_info     ecs_temp_domus%rowtype;
    l_cabinet_info    ecs_hw_cabinets%rowtype;
    l_admin_subnet_info ecs_oracle_admin_subnets%rowtype;

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
    l_admin_nat_host_name ecs_domus.admin_nat_host_name%type;

    l_share_cabinet   pls_integer := 0;
  begin

    l_cell_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)cell',1,1,'i',1);
    l_compute_count:= REGEXP_SUBSTR(p_node_constraint, '(\d+)comp',1,1,'i',1) ;
    l_ibsw_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)ibsw',1,1,'i',1) ;
    l_pdu_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)pdu',1,1,'i',1);
    l_ethsw_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)ethsw',1,1,'i',1);
    l_node_constraint_regex := '^'||l_cell_count||'cell'||l_compute_count||'comp';
  
    dbms_output.put_line(l_cell_count ||' '||l_compute_count||' '||
                         l_ibsw_count ||' '||l_pdu_count||' '||
                         l_ethsw_count||' '||l_cluster_hw_id||' '||
                         l_node_constraint_regex);

    --
    -- Pick the right cabinet where we want to carve out the cluster.
    -- How: If user provided the cabinet, pick that cabinet
    --      If user specified shared clustername, use the cabinet where
    --      that cluster exists.
    --      Else, find the first available cabinet that suits the requirement.
    --      All the while stick to the given availability_domain
    -- 
    if (p_cabinet_name is not null and p_shared_cluster_name is not null) then
      -- shared cluster should be on the given cabinet name. else, error
      select * into l_cabinet_info
      from  ecs_hw_cabinets
      where name = p_cabinet_name
      and   availability_domain = p_avail_domin
      and   regexp_like(node_list, l_node_constraint_regex);

      select cabinet_id into l_cabinet_id
      from   ecs_hw_nodes 
      where  regexp_like(ecs_racks_name_list, ','||
                         p_shared_cluster_name||',', 'i')
      and    rownum < 2;

      if (l_cabinet_id != l_cabinet_info.id) then
          raise_application_error(xn_cluster_not_on_cabinet, 
            xm_cluster_not_on_cabinet||' ('||p_shared_cluster_name||
            ' '|| p_cabinet_name||')');
      end if;
      l_share_cabinet := 1;
    elsif (p_cabinet_name is not null and p_shared_cluster_name is null) then
      select * into l_cabinet_info
      from  ecs_hw_cabinets
      where name = p_cabinet_name 
      and   availability_domain = p_avail_domin
      and   regexp_like(node_list, l_node_constraint_regex);
      l_share_cabinet := 0;
    elsif (p_cabinet_name is null and p_shared_cluster_name is not null) then
      select cabinet_id into l_cabinet_id
      from   ecs_hw_nodes 
      where  regexp_like(ecs_racks_name_list, ','||
                         p_shared_cluster_name||',', 'i')
      and    rownum < 2;

      select * into l_cabinet_info
      from  ecs_hw_cabinets
      where id = l_cabinet_id
      and   availability_domain = p_avail_domin
      and   regexp_like(node_list, l_node_constraint_regex);
      l_share_cabinet := 1;
    else
      select cabid into l_cabinet_id
      from (
        select min(cabinet_id) cabid
        from ecs_hw_nodes ehn, ecs_hw_cabinets ehc
        where regexp_like(cluster_size_constraint, l_node_constraint_regex)
        and  node_type = gc_hw_node_type_storage
        and  node_state = gc_hw_node_state_free
        and  ehc.id = ehn.cabinet_id
        and  ehc.availability_domain = p_avail_domin
        group by ehn.cabinet_id, ehn.node_type 
        having count(node_type) >= l_cell_count
        UNION
        select min(ehn.cabinet_id) cabid
        from ecs_hw_nodes ehn, ecs_hw_cabinets ehc
        where regexp_like(ehn.cluster_size_constraint, l_node_constraint_regex)
        and  ehn.node_type = gc_hw_node_type_compute
        and  ehn.node_state = gc_hw_node_state_free
        and  ehc.id = ehn.cabinet_id
        and  ehc.availability_domain = p_avail_domin
        group by ehn.cabinet_id, ehn.node_type 
        having count(node_type) >= l_compute_count
      ) where rownum < 2;

      select * into l_cabinet_info
      from  ecs_hw_cabinets
      where id = l_cabinet_id;

      l_share_cabinet := 0;
    end if;

    l_ecs_racks_name := generate_ecs_racks_name
      (l_cabinet_info.name, l_cluster_hw_id);
    dbms_output.put_line('ecs_racks_name = '||l_ecs_racks_name);
    dbms_output.put_line('cabinet_name = '||l_cabinet_info.id);

    if (l_share_cabinet = 0) then

      begin
        -- First pick the CELL rows while setting state to FORMING  
        for rec in (select id from   ecs_hw_nodes ehn
                    where ehn.cabinet_id = l_cabinet_info.id
                    and   rownum <= l_cell_count
                    and   node_type = gc_hw_node_type_storage
                    and   node_state = gc_hw_node_state_free
                    order by ehn.location_rackunit asc) loop
    
          update ecs_hw_nodes ehn 
          set node_state = gc_hw_node_state_composing, 
              ecs_racks_name_list = ecs_racks_name_list||','||
                                    l_ecs_racks_name||','
          where  ehn.cabinet_id    = l_cabinet_info.id
          and    ehn.id = rec.id;

          l_hw_node_id_coll(rec.id) := rec.id;
          l_node_seq_coll(rec.id) := l_node_seq;
          l_node_seq := l_node_seq + 1;  

          dbms_output.put_line('inserting STORAGE data');  
        end loop;
        dbms_output.put_line('inserted STORAGE data');  
  
        -- check if we got enough cells, if not, revert back and error out
        if (l_hw_node_id_coll.count >= 0 and 
            l_hw_node_id_coll.count < l_cell_count) then
          raise_application_error(xn_not_enough_cells, 
                xm_not_enough_cells||' from cabinet '||l_cabinet_info.name);
        end if;
    
        -- Second pick the COMPUTE rows while setting state to FORMING  
        for rec in (select id, node_type_order_bottom_up 
                    from   ecs_hw_nodes ehn
                    where ehn.cabinet_id = l_cabinet_info.id
                    and   rownum <= l_compute_count
                    and   node_type = gc_hw_node_type_compute
                    and   node_state = gc_hw_node_state_free
                    order by ehn.location_rackunit asc) loop
    
          update ecs_hw_nodes ehn 
          set node_state = gc_hw_node_state_composing , 
              ecs_racks_name_list = ecs_racks_name_list||','||
                                    l_ecs_racks_name||','
          where ehn.cabinet_id = l_cabinet_info.id
          and   ehn.id = rec.id;

          l_hw_node_id_coll(rec.id) := rec.id;
          l_node_seq_coll(rec.id) := l_node_seq;
          l_node_seq := l_node_seq + 1;  

          dbms_output.put_line('inserting COMP data');  

          -- create ecs_domus entries 
          -- if ecs_temp_domus entry exists, take everything from there
          -- Because there is a possibility of the data uploaded by flat file
          -- else, create our own
          begin
            select * into l_tdomus_info 
            from ecs_temp_domus where hw_node_id = rec.id;

            insert into ecs_domus values
            (l_ecs_racks_name, rec.id, l_tdomus_info.admin_nat_ip, 
             l_tdomus_info.admin_nat_host_name, l_tdomus_info.db_client_mac,
             l_tdomus_info.db_backup_mac);
          exception
            when no_data_found then
              l_db_client_mac := generate_mac();
              l_db_backup_mac := generate_mac();
              l_admin_nat_host_name := generate_host_name
                (l_cabinet_info.name, l_cabinet_info.product
                , 'du', rec.node_type_order_bottom_up, 1);
              insert into ecs_domus values
              (l_ecs_racks_name, rec.id, null, 
               l_admin_nat_host_name, l_db_client_mac,
               l_db_backup_mac);
          end;
        end loop;
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
                    and   rownum <= l_ibsw_count
                    and   node_type = gc_hw_node_type_ibsw
                    order by ehn.node_type_order_bottom_up asc) loop

          update ecs_hw_nodes ehn 
          set node_state = gc_hw_node_state_composing , 
              ecs_racks_name_list = ecs_racks_name_list||','||
                                    l_ecs_racks_name||','
          where ehn.cabinet_id = l_cabinet_info.id
          and   ehn.id = rec.id;

          l_hw_node_id_coll(rec.id) := rec.id;
          l_node_seq_coll(rec.id) := l_node_seq;
          l_node_seq := l_node_seq + 1;  

          dbms_output.put_line('inserting IBSW data');  
        end loop;
        dbms_output.put_line('inserted IBSW data');  
      end;  
    else
      -- get the node info of the cluster which we are going to share
      dbms_output.put_line('Sharing cluster');

      select id bulk collect into l_hw_node_id_coll
      from   ecs_hw_nodes 
      where  cabinet_id = l_cabinet_info.id
      and    regexp_like(ecs_racks_name_list, ','||p_shared_cluster_name||',')
      and    node_type != gc_hw_node_type_pdu
      order  by node_type, node_type_order_bottom_up;

      for i in l_hw_node_id_coll.first..l_hw_node_id_coll.last loop
        l_node_seq_coll(i) := l_node_seq;
        l_node_seq := l_node_seq + 1;
      end loop;

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

        -- create ecs_domus entry for the computes
        if (l_node_type = gc_hw_node_type_compute) then
          select count(hw_node_id) into l_domu_count
          from ecs_domus 
          where hw_node_id = l_hw_node_id_coll(l_idx);

          l_db_client_mac := generate_mac();
          l_db_backup_mac := generate_mac();
          l_admin_nat_host_name := 
            generate_host_name (l_cabinet_info.name, l_cabinet_info.product,
                              'du', l_bottom_up_order, l_domu_count+1);
          insert into ecs_domus values
          (l_ecs_racks_name, l_hw_node_id_coll(l_idx), null, 
           l_admin_nat_host_name, l_db_client_mac,
           l_db_backup_mac);
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
    values (l_vcn_id, l_vcn_subnet, l_ecs_racks_name);

    -- insert a row into ecs_racks
    insert into ecs_racks(domu, name, status, racksize, model)
    values (l_ecs_racks_name||'_pk', l_ecs_racks_name, gc_ecs_racks_status_ready,
            gv_cluster_size_hash(l_cell_count||l_compute_count), p_model);

    -- insert into ecs_ib_pkeys_used, one for compute and one for storage
    l_idx := l_hw_node_id_coll.first;
    select ib_fabric_id into l_ib_fabric_id
    from   ecs_hw_nodes
    where  id = l_hw_node_id_coll(l_idx);

    insert into ecs_ib_pkeys_used
    values (l_ib_fabric_id, 
            lower(trim(to_char(ecs_ib_compute_pkeys_seq_id.nextval,'XXXX'))),
            l_ecs_racks_name, gc_hw_node_type_compute);

    -- Storage keys are shared between clusters running on 
    -- the same set of computes
    if (p_shared_cluster_name is null) then
      insert into ecs_ib_pkeys_used
      values (l_ib_fabric_id, 
              lower(trim(to_char(ecs_ib_storage_pkeys_seq_id.nextval,'XXXX'))),
              l_ecs_racks_name, 'STORAGE');
      l_storage_pkey := 
        lower(trim(to_char(ecs_ib_storage_pkeys_seq_id.currval,'XXXX')));
    else
      dbms_output.put_line('Inserting Shared pkey');
      select pkey into l_storage_pkey
      from ecs_ib_pkeys_used
      where ecs_racks_name = p_shared_cluster_name
      and   pkey_use = 'STORAGE';

      insert into ecs_ib_pkeys_used
      values (l_ib_fabric_id, l_storage_pkey,
              l_ecs_racks_name, 'STORAGE');
    end if;

    -- At this point cluster formation is done.
    -- Now return the data to the caller
    l_vcn_subnet_array := split_str(l_vcn_subnet, '|');
    l_vcn_subnet := l_vcn_subnet_array(1);
    l_dns_array := split_str(l_vcn_subnet_array(2), ':');
    l_dns_array := split_str(l_dns_array(2), ',');
    l_ntp_array := split_str(l_vcn_subnet_array(3), ':');
    l_ntp_array := split_str(l_ntp_array(2), ',');
    l_gateway_array := split_str(l_vcn_subnet_array(4), ':');

    -- Generate the nodes json.
    dbms_output.put_line('hw node coll count = '||l_hw_node_id_coll.count);
    dbms_output.put_line('l_vcn_subnet_array.count = '||
                         l_vcn_subnet_array.count);
    dbms_output.put_line('l_dns_array.count = '||l_dns_array.count);
    dbms_output.put_line('l_ntp_array.count = '||l_ntp_array.count);
    dbms_output.put_line('l_gateway_array.count = '||l_gateway_array.count);

    l_idx := l_hw_node_id_coll.first;

    if (l_idx is not null) then
      l_nodes := '['||chr(10);
    end if;

    while (l_idx is not null) loop
      -- Get the details from ecs_hw_nodes
      select * into l_hw_node_info
      from     ecs_hw_nodes
      where id = l_hw_node_id_coll(l_idx);

      dbms_output.put_line('Got node info for '||l_hw_node_id_coll(l_idx));

      dbms_output.put_line('Constructing node info for '||
                           l_hw_node_info.oracle_hostname||
                           ' type='||l_hw_node_info.node_type);        
      l_nodes := l_nodes ||'  {'||chr(10)
        ||'    "node_sequence": '||l_node_seq_coll(l_idx) ||','||chr(10)
        ||'    "node_type": "'||l_hw_node_info.node_type||'",'||chr(10)
        ||'    "node_model": "'||l_hw_node_info.node_model||'",'||chr(10)
        ||'    "oracle_ip": "'||l_hw_node_info.oracle_ip||'",'||chr(10)
        ||'    "oracle_hostname_pick_": "'||l_hw_node_info.oracle_hostname
        ||'",'||chr(10)
        ||'    "oracle_netmask": "'||l_vcn_subnet||'",'||chr(10)
        ||'    "oracle_gateway": "'||l_gateway_array(2)||'",'||chr(10)
        ||'    "oracle_domain": "'||l_cabinet_info.domainname||'",'||chr(10)
        ||'    "oracle_dns": [ ';
      for i in l_dns_array.first..l_dns_array.last loop
        if (i = l_dns_array.first) then
                          l_nodes := l_nodes ||' "'||l_dns_array(i)||'"';
        else
                           l_nodes := l_nodes ||', "'||l_dns_array(i)||'"';
        end if;
      end loop;
      l_nodes := l_nodes||'],'||chr(10)
        ||'    "oracle_ntp": [ ';
      for i in l_ntp_array.first..l_ntp_array.last loop
        if (i = l_ntp_array.first) then
          l_nodes := l_nodes ||' "'||l_ntp_array(i)||'"';
        else
          l_nodes := l_nodes ||', "'||l_ntp_array(i)||'"';
        end if;
      end loop;
      l_nodes := l_nodes||'],'||chr(10)
        ||'    "cabinet_id": '||l_cabinet_info.id||','||chr(10)
        ||'    "cabinet_name": "'||l_cabinet_info.name||'"';

      -- IBSW  are done here
      if (l_hw_node_info.node_type = gc_hw_node_type_ibsw) then
        goto loop_end;
      end if;

      l_nodes := l_nodes||','||chr(10)
        ||'    "ilom_hostname": "'||l_hw_node_info.oracle_ilom_hostname
        ||'",'||chr(10)
        ||'    "ilom_ip": "'||l_hw_node_info.oracle_ilom_ip||'",'||chr(10)
        ||'    "ilom_domain": "'||l_cabinet_info.domainname||'",'||chr(10)
        ||'    "ilom_gateway": "'||l_gateway_array(2)||'",'||chr(10)
        ||'    "ilom_netmask": "'||l_vcn_subnet||'",'||chr(10)
        ||'    "ilom_dns": [ ';
      for i in l_dns_array.first..l_dns_array.last loop
        if (i = l_dns_array.first) then
          l_nodes := l_nodes ||' "'||l_dns_array(i)||'"';
        else
          l_nodes := l_nodes ||', "'||l_dns_array(i)||'"';
        end if;
      end loop;
      l_nodes := l_nodes||'],'||chr(10)
        ||'    "ilom_ntp": [ ';
      for i in l_ntp_array.first..l_ntp_array.last loop
        if (i = l_ntp_array.first) then
           l_nodes := l_nodes ||' "'||l_ntp_array(i)||'"';
        else
           l_nodes := l_nodes ||', "'||l_ntp_array(i)||'"';
        end if;
      end loop;
      l_nodes := l_nodes||'],'||chr(10)
        ||'    "storage_pkey": "0x' ||l_storage_pkey ||'"';

      -- CELL are done here
      if (l_hw_node_info.node_type = gc_hw_node_type_storage) then
        goto loop_end;
      end if;

      -- get the nat ip, db_client_mac and db_backup_mac data
      dbms_output.put_line('Get domu info for nodeid '||
                           l_hw_node_id_coll(l_idx));
      select * into l_domus_info
      from   ecs_domus
      where  hw_node_id     = l_hw_node_id_coll(l_idx)
      and    ecs_racks_name = l_ecs_racks_name;
      dbms_output.put_line('Got domu info');

      l_idx1 := 1;
      for cvm_rec in
      ( select * from ecs_caviums 
        where  hw_node_id = l_hw_node_id_coll(l_idx)
        and    etherface_type = gc_eface_db_client
        order by etherface
      ) loop
        
        if (l_idx1 = 1) then
          l_idx1 := l_idx1 + 1;
          l_cavimus := '[ "'||cvm_rec.cavium_id||'"';
          l_macs    := '[ "'||l_domus_info.db_client_mac||'"';
          l_etherfaces := '[ "'||cvm_rec.etherface||'"';
          l_etherface_types := '[ "'||cvm_rec.etherface_type||'"';
        else
          l_cavimus := l_cavimus ||', "'||cvm_rec.cavium_id||'"';
          l_macs := l_macs ||', "'||l_domus_info.db_client_mac||'"';
          l_etherfaces := l_etherfaces ||', "'||cvm_rec.etherface||'"';
          l_etherface_types := l_etherface_types ||', "'||
                               cvm_rec.etherface_type||'"';
        end if;
      end loop;

      for cvm_rec in
      ( select * from ecs_caviums 
        where  hw_node_id = l_hw_node_id_coll(l_idx)
        and    etherface_type = gc_eface_db_backup
        order by etherface
      ) loop
          l_cavimus := l_cavimus ||', "'||cvm_rec.cavium_id||'"';
          l_macs := l_macs ||', "'||l_domus_info.db_backup_mac||'"';
          l_etherfaces := l_etherfaces ||', "'||cvm_rec.etherface||'"';
          l_etherface_types := l_etherface_types ||', "'||
                               cvm_rec.etherface_type||'"';
      end loop;

      l_cavimus         := l_cavimus ||' ]';
      l_macs            := l_macs ||' ]';
      l_etherfaces      := l_etherfaces ||' ]';
      l_etherface_types := l_etherface_types ||' ]';

      l_nodes := l_nodes||','||chr(10)
        ||'    "compute_pkey": "0x'
        ||lower(trim(to_char(ecs_ib_compute_pkeys_seq_id.currval,'XXXX')))
        ||'",'||chr(10)
        ||'    "caviums": '||l_cavimus||','||chr(10)
        ||'    "etherfaces": '||l_etherfaces||','||chr(10)
        ||'    "etherface_types": '||l_etherface_types||','||chr(10);

      if (l_share_cabinet = 0) then
        l_nodes := l_nodes||'    "macs_pick_": '||l_macs||','||chr(10);
      else
        l_nodes := l_nodes||'    "macs_pick_": [],'||chr(10);
      end if;

      l_nodes := l_nodes
      ||'    "nat_hostname_pick_": "'||l_domus_info.admin_nat_host_name 
      ||'",'||chr(10)
      ||'    "nat_ip_pick_": "'||l_domus_info.admin_nat_ip||'"'||chr(10);

      <<loop_end>>
      l_idx := l_hw_node_id_coll.next(l_idx);
      if (l_idx is not null) then
        l_nodes := l_nodes||chr(10)||'  },'||chr(10);
      else
        l_nodes := l_nodes||chr(10)||'  }'||chr(10)||']'||chr(10);
      end if;
      -- dbms_output.put_line('nodes = '||l_nodes);
    end loop;      

    -- build the final json
    l_row := '{'||chr(10)||'"clusters": '||chr(10)
           ||'['||chr(10)
           ||'  {'||chr(10)
           ||'    "cluster_size": "'||p_node_constraint||'",'||chr(10)
           ||'    "oracle_admin_subnet": "'||l_vcn_subnet||'",'||chr(10)
           ||'    "oracle_admin_vcnid": "'||l_vcn_id||'",'||chr(10)
           ||'    "availability_domain": "'
           ||l_cabinet_info.availability_domain||'",'||chr(10)
           ||'    "product": "'||l_cabinet_info.product||'",'||chr(10)
           ||'    "temporary_ecs_rack_name_pick_": "'
           ||l_ecs_racks_name||'",'||chr(10)
           ||'    "time_zone": "'||l_cabinet_info.time_zone||'",'||chr(10)
           ||'    "nodes": '||chr(10)
           ||'    '||l_nodes||chr(10)
           ||'  }'||chr(10)
           ||']'||chr(10)||'}';
    -- dbms_output.put_line('output = '||systimestamp||' '||l_row);
    commit;
    pipe row(l_row);
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
  , p_admin_hostname_list in varchar2
  , p_admin_nat_ip_list   in varchar2
  , p_db_client_mac_list  in varchar2
  , p_db_backup_mac_list  in varchar2
  , p_action              in varchar2 default gc_commit -- Can be 'COMMIT' or 'ROLLBACK'
  ) return ecs_json_coll pipelined is
    pragma AUTONOMOUS_TRANSACTION;
    l_compute_count number;
    l_domu_count    number;

    l_cabinet_info    ecs_hw_cabinets%rowtype;
    l_hw_node_info    ecs_hw_nodes%rowtype;
    l_idx             pls_integer;
    l_row             clob;
    l_admin_hostname_coll dbms_sql.varchar2_table;
    l_admin_nat_ip_coll   dbms_sql.varchar2_table;
    l_db_backup_mac_coll  dbms_sql.varchar2_table;
    l_db_client_mac_coll  dbms_sql.varchar2_table;
    l_ecs_racks_name      ecs_racks.name%type;
    l_existing_cluster    number;
    l_to_be_purged        number;
    l_mac_idx_skip        pls_integer := 2;
  begin

    -- Check if the given cluster name already exists
    select count(name) into l_existing_cluster
    from   ecs_racks
    where  name = p_new_ecs_racks_name
    and    status != gc_ecs_racks_status_deleted;

    if (l_existing_cluster > 0) then
      raise_application_error(xn_clu_exists, 
                              xm_clu_exists||' '||p_new_ecs_racks_name);
    end if;

    -- check if the given cluster is under purge schedule
    select count(ecs_racks_name) into l_to_be_purged
    from   ecs_clusters_purge_queue
    where  ecs_racks_name = p_new_ecs_racks_name;

    if (l_to_be_purged > 0) then
      raise_application_error(xn_clu_under_purge,
          xm_clu_under_purge||' '||p_new_ecs_racks_name);
    end if;

    if (p_action = gc_commit) then

      l_compute_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)comp',1,1,'i',1) ;
      l_admin_hostname_coll := split_str(p_admin_hostname_list, ',');
      l_admin_nat_ip_coll   := split_str(p_admin_nat_ip_list, ',');
      l_db_backup_mac_coll  := split_str(p_db_backup_mac_list, ',');
      l_db_client_mac_coll  := split_str(p_db_client_mac_list, ',');
  
      if (l_compute_count != l_admin_hostname_coll.count) then
        raise_application_error(xn_not_enough_values, 
                                xm_not_enough_values|| ' p_admin_hostname_coll');
      end if;
  
      if (l_compute_count !=l_admin_nat_ip_coll.count) then
        raise_application_error(xn_not_enough_values, 
                                xm_not_enough_values|| ' p_admin_nat_ip_list');
      end if;

      if (l_db_client_mac_coll.count = 0 or
          mod(l_db_client_mac_coll.count, l_compute_count) != 0) then
        raise_application_error(xn_not_enough_values, 
                                xm_not_enough_values|| ' p_db_client_mac_list');
      end if;

      if (l_db_backup_mac_coll.count = 0 or
          mod(l_db_backup_mac_coll.count, l_compute_count) != 0) then
        raise_application_error(xn_not_enough_values, 
                                xm_not_enough_values|| ' p_db_backup_mac_list');
      end if;

      -- Commit the compose cluster action

      -- lock rows from ecs_racks
      select name into l_ecs_racks_name
      from ecs_racks
      where name = p_old_ecs_racks_name
      for update;

      -- update the ecs_ib_pkeys_used
      update ecs_ib_pkeys_used set ecs_racks_name = p_new_ecs_racks_name
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

        select * into l_cabinet_info
        from ecs_hw_cabinets
        where id = l_hw_node_info.cabinet_id;

        update ecs_domus 
        set admin_nat_ip = l_admin_nat_ip_coll(i),
            db_client_mac = 
              l_db_client_mac_coll((i*l_mac_idx_skip)-(l_mac_idx_skip-1)),
            db_backup_mac = 
              l_db_backup_mac_coll((i*l_mac_idx_skip)-(l_mac_idx_skip-1)),
            ecs_racks_name = p_new_ecs_racks_name
        where  hw_node_id = l_hw_node_info.id
        and    ecs_racks_name = p_old_ecs_racks_name;

        dbms_output.put_line('updated ecs_domus = '||
                             l_admin_hostname_coll(i));

      end loop;
      
      -- update ecs_hw_nodes
      update ecs_hw_nodes set node_state = gc_hw_node_state_allocated,
        ecs_racks_name_list = 
           regexp_replace(ecs_racks_name_list, 
                         ','|| p_old_ecs_racks_name||',',
                         ','||p_new_ecs_racks_name||',',1,0,'i')
      where regexp_like(ecs_racks_name_list, ','||
                        p_old_ecs_racks_name||',', 'i');

      dbms_output.put_line('updated ecs_hw_nodes');  

      -- update ecs_oracle_admin_subnets
      update ecs_oracle_admin_subnets 
      set ecs_racks_name = p_new_ecs_racks_name
      where ecs_racks_name = p_old_ecs_racks_name;
      dbms_output.put_line('updated ecs_oracle_admin_subnets');  

      -- in the end update ecs_racks
      gv_ecs_racks_upd_trig_state := gc_ecs_racks_upd_trig_disable;

      update ecs_racks er 
      set er.name = p_new_ecs_racks_name,
          er.status = gc_ecs_racks_status_ready
      where  er.name = p_old_ecs_racks_name;
      dbms_output.put_line('updated ecs_racks');  
 

    else
      -- Rollback the compose cluster action    
      gv_ecs_racks_upd_trig_state := gc_ecs_racks_upd_trig_disable;
      select name into l_ecs_racks_name
      from ecs_racks
      where name = p_old_ecs_racks_name
      for update;

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

      -- delete entry ecs_oracle_admin_subnets
      delete from ecs_oracle_admin_subnets
      where  ecs_racks_name = p_old_ecs_racks_name;

      -- delete from ecs_domus
      delete from ecs_domus
      where ecs_racks_name = p_old_ecs_racks_name;

      -- delete entry from ecs_racks
      delete from ecs_racks er 
      where  er.name = p_old_ecs_racks_name;
  
    end if;
    commit;

    gv_ecs_racks_upd_trig_state := gc_ecs_racks_upd_trig_enable;

    l_row :=   
       '{ '||chr(10)
     ||'  "cluster_size": "'||p_node_constraint||'",'||chr(10)
     ||'  "old_ecs_racks_name": "'||p_old_ecs_racks_name||'",'||chr(10)
     ||'  "new_ecs_racks_name": "'||p_new_ecs_racks_name||'",'||chr(10)
     ||'  "action": "'||p_action||'",'||chr(10)
     ||'  "status": "success"'||chr(10)
     ||'}';

    pipe row(l_row);
  exception
    when others then 
      rollback;
      l_row :=   
         '{ '||chr(10)
       ||'  "cluster_size": "'||p_node_constraint||'",'||chr(10)
       ||'  "old_ecs_racks_name": "'||p_old_ecs_racks_name||'",'||chr(10)
       ||'  "new_ecs_racks_name": "'||p_new_ecs_racks_name||'",'||chr(10)
       ||'  "action": "'||p_action||'",'||chr(10)
       ||'  "status": "fail",'||chr(10)
       ||'  "reason": "'||SQLERRM||'"'||chr(10)
       ||'}';
  
    pipe row(l_row);
  
  end ecs_compose_cluster_end;

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
    , admin_nat_ip         ecs_domus.admin_nat_ip%type
    , admin_nat_host_name  ecs_domus.admin_nat_host_name%type
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
    ( select ed.hw_node_id, ed.admin_nat_ip, ed.admin_nat_host_name,
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
      order by ed.hw_node_id, ecvm.etherface_type, ecvm.etherface
    ) loop
      if (not l_domu_info_coll.exists(domu_rec.hw_node_id)) then
        l_domu_info_coll(domu_rec.hw_node_id).hw_node_id := domu_rec.hw_node_id;
        l_domu_info_coll(domu_rec.hw_node_id).vcn_id     := domu_rec.vcn_id;
        l_domu_info_coll(domu_rec.hw_node_id).admin_nat_ip := domu_rec.admin_nat_ip;
        l_domu_info_coll(domu_rec.hw_node_id).oracle_admin_subnet := domu_rec.subnet_id;
        l_domu_info_coll(domu_rec.hw_node_id).admin_nat_host_name := 
           domu_rec.admin_nat_host_name;
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
    l_nodes_sql          clob;
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
      l_input_cell_count := REGEXP_SUBSTR(p_node_constraint, '(\d+)cell',1,1,'i',1);
    end if;
    if (p_node_model is not null) then
      l_input_compute_count:= REGEXP_SUBSTR(p_node_constraint, '(\d+)comp',1,1,'i',1) ;
    end if;

    l_row := '{'||chr(10)
           ||'"availability_domains": '||chr(10)
           ||'{';

    for ad_rec in (select distinct availability_domain from ecs_hw_cabinets) loop
      if (l_current_ad is null) then
        l_current_ad := ad_rec.availability_domain;
        l_row := l_row ||' "'||ad_rec.availability_domain||'" :'||chr(10);
      elsif (l_current_ad != ad_rec.availability_domain) then
        l_row := l_row ||', '||chr(10)||'"'||ad_rec.availability_domain||'" :'||chr(10);
        l_current_ad := ad_rec.availability_domain;
      else
        l_row := l_row ||','||chr(10);
      end if;
      l_row := l_row ||'  {'||chr(10)
             ||'  "cluster_sizes": '||chr(10)
             ||'   {';
      l_current_size := null;
      -- Get the cookie cutter cluster size counts
      for avail_rec in 
      ( select ehn.cluster_size_constraint, count(ehn.id) node_count, ehn.node_model
        from ecs_hw_nodes ehn, ecs_hw_cabinets ec
        where ehn.node_type  = gc_hw_node_type_compute
        and   ehn.node_state = gc_hw_node_state_free
        and   ehn.cluster_size_constraint != gc_hw_node_cluster_sz_elastic
        and   ec.id                  = ehn.cabinet_id
        and   ec.availability_domain = ad_rec.availability_domain
        group by ehn.cluster_size_constraint, ehn.node_model
        order by ehn.cluster_size_constraint
      ) loop
        l_compute_count := REGEXP_SUBSTR(avail_rec.cluster_size_constraint, 
                                         '(\d+)comp',1,1,'i',1) ;
        l_row := l_row||chr(10);
        if (l_current_size is null) then 
          l_row := l_row||'     "'||avail_rec.cluster_size_constraint||'": {'||chr(10);
          l_current_size := avail_rec.cluster_size_constraint;
        elsif (l_current_size != avail_rec.cluster_size_constraint) then
          l_row := l_row||'          }, '||chr(10)
                        ||'     "'||avail_rec.cluster_size_constraint||'": {'||chr(10);
          l_current_size := avail_rec.cluster_size_constraint;
        else
          l_row := l_row||',';
        end if;
  
        l_row := l_row||'          { "model": "'||avail_rec.node_model||'",'
                      ||chr(10)
                      ||'          "count: '||avail_rec.node_count/l_compute_count||'}';
      end loop;
  
      if (l_current_size is not null) then
        l_row := l_row|| chr(10) ||'         },'; -- end of cookie cutters
      end if;
  
      -- get the elastic cluster details
      l_row := l_row||chr(10)||'     "Elastic": {';
  
      l_current_model := null;
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
          l_row := l_row||chr(10);
          l_current_model := elastic_rec.node_model;
          l_row := l_row||'          { "model": "'||elastic_rec.node_model||'",'||chr(10);
        elsif (l_current_model != elastic_rec.node_model) then
          l_row := l_row||'}, '||chr(10)
                        ||'          { "model": "'||elastic_rec.node_model||'",'||chr(10);
          l_current_model := elastic_rec.node_model;
        else
          l_row := l_row||','||chr(10);
        end if;
        l_row := l_row||'              "'||lower(elastic_rec.node_type)||'_count" : '
                      ||elastic_rec.node_count;
  
      end loop;
  
      if (l_current_model is not null) then
        l_row := l_row|| chr(10) ||'          }' ; -- end of Elastic members
      end if;
      l_row := l_row|| chr(10) ||'          }' ; -- end of Elastic
  
      l_row := l_row|| chr(10) ||'    }'; --end of cluster_sizes
      l_row := l_row|| chr(10) ||'  }'; --end of AD
  
    end loop;

    l_row := l_row|| chr(10) ||'}';
    l_row := l_row|| chr(10) ||'}';
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
  begin
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
    delete from ecs_oracle_admin_subnets
    where  ecs_racks_name = p_ecs_racks_name;
    dbms_output.put_line('deleted ecs_oracle_admin_subnets');

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

    if (l_hw_node_usage_count = 1) then
      update ecs_hw_nodes set node_state = gc_hw_node_state_free,
             ecs_racks_name_list = null
      where regexp_like(ecs_racks_name_list, ','||
                          p_ecs_racks_name||',', 'i');
    else
      update ecs_hw_nodes set node_state = gc_hw_node_state_free,
             ecs_racks_name_list = regexp_replace(ecs_racks_name_list, ','||
                                    p_ecs_racks_name||',', null,1,0,'i')
      where regexp_like(ecs_racks_name_list, ','||
                          p_ecs_racks_name||',', 'i');
    end if;

    delete from ecs_domus
    where  ecs_racks_name = p_ecs_racks_name;
    dbms_output.put_line('deleted ecs_domus');

    delete from ecs_racks
    where  name = p_ecs_racks_name;

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
    values (p_ecs_racks_name, l_xml, systimestamp, l_purge_time);

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
    l_rows_processed := dbms_sql.execute(l_cursor);

    -- fetch
    loop
      if (dbms_sql.fetch_rows(l_cursor) > 0) then
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
    l_row := '{"clusters": ['||l_row||']}';
    dbms_sql.close_cursor(l_cursor); 

    pipe row(l_row);    
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
    i pls_integer := 1;
  begin
    select id into l_cabinet_id
    from ecs_hw_cabinets 
    where name = p_cabinet_name;
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
    end loop;    

    -- delete from ecs_caviums and ecs_temp_domus
    for hw_node_rec in 
    (select id from ecs_hw_nodes where cabinet_id = l_cabinet_id) loop
      delete from ecs_caviums
      where  hw_node_id = hw_node_rec.id; 
      delete from ecs_temp_domus
      where hw_node_id = hw_node_rec.id;
      dbms_output.put_line('Deleting ecs_caviums');
    end loop;

    -- delete the records from ecs_hw_nodes;
    delete from ecs_hw_nodes 
    where  cabinet_id = l_cabinet_id;
    dbms_output.put_line('Deleting ecs_hw_nodes');

    -- delete from ecs_hw_cabinets
    delete from ecs_hw_cabinets
    where  id = l_cabinet_id;
    dbms_output.put_line('Deleting ecs_hw_cabinets');
    commit;
    l_row := '{"action" : "delete_cabinet", "clusters_deleted" : ['||l_row||']}';
    pipe row(l_row);
  exception
    when others then
      rollback;
  end ecs_delete_cabinet;

begin
  -- init the gv_cluster_size_hash
  gv_cluster_size_hash('32')  := 'quarter'; -- 3cell2comp
  gv_cluster_size_hash('64')  := 'half';    -- 6cell4comp
  gv_cluster_size_hash('128') := 'full';    -- 12cell8comp
  gv_cluster_size_hash('999') := 'elastic'; -- anycellanycomp

  gv_ecs_racks_upd_trig_state := gc_ecs_racks_upd_trig_enable;
end ecra;
/

Rem -- Gen2 PL/SQL package end ---

Rem -- Gen2 Table triggers begin --

--
-- BUG 25802231: ecs_racks.name column update returns ora-02292
--
create or replace trigger ecs_racks_upd_trig
before update of name 
on ecs_racks
for each row
declare
  l_rc number;
begin
  l_rc := ecra.ecs_update_cluster_name
  ( :old.name 
  , :new.name
  );
end;
/

Rem -- Gen2 Table triggers end --

exit;

