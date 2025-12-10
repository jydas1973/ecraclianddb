Rem
Rem upgrade181300.sql
Rem
Rem Copyright (c) 2017, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      upgrade181300.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade181300.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    brsudars    01/16/18 - Add cluster_id to ecs_rack_slots table
Rem    brsudars    12/14/17 - Add multi-vm changes. Also added changes from [srtata] bug 27166380: add cnsenabled column in ecs_racks
Rem    nkedlaya    12/07/17 - 18.1.3.0.0 ecra schema upgrade script
Rem    nkedlaya    12/07/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


--BEGIN Bug 26751817 : compose cluster for GEN1, HIGGS
drop table ecs_generation_types cascade constraints;
create table ecs_generation_types
(   name       varchar2(256) not null,
    CONSTRAINT ecs_generation_types_pk PRIMARY KEY (name)
);

insert into ecs_generation_types values('BMC');
insert into ecs_generation_types values('GEN1');
insert into ecs_generation_types values('AD');
insert into ecs_generation_types values('EXACM');
commit;

alter table ecs_ib_fabrics add (
    last_used_cib_ip_octet_1     number default 1 not null,
    last_used_cib_ip_octet_2     number default 132 not null,
    last_used_cib_ip_octet_3     number default 168 not null,
    last_used_cib_ip_octet_4     number default 192 not null,
    last_used_stib_ip_octet_1     number default 1 not null,
    last_used_stib_ip_octet_2     number default 136 not null,
    last_used_stib_ip_octet_3     number default 168 not null,
    last_used_stib_ip_octet_4     number default 192 not null,
    CONSTRAINT ecs_ib_fabrics_cib_range_ck CHECK
      (last_used_cib_ip_octet_2 between 132 and 135
       and last_used_cib_ip_octet_1 between 0 and 254
       and last_used_cib_ip_octet_3 = 168 
       and last_used_cib_ip_octet_4 = 192),
    CONSTRAINT ecs_ib_fabrics_stib_range_ck CHECK
      (last_used_stib_ip_octet_2 between 136 and 143
       and last_used_stib_ip_octet_1 between 0 and 254
       and last_used_stib_ip_octet_3 = 168 
       and last_used_stib_ip_octet_4 = 192)
);

alter table ecs_hw_cabinets rename column node_list to cluster_size_constraint;
alter table ecs_hw_cabinets add (
    generation_type         varchar2(256)     default 'BMC' not null,
    CONSTRAINT ecs_hw_cabinets_usg_typ_fk 
      FOREIGN KEY (generation_type)
      REFERENCES ecs_generation_types(name) deferrable initially deferred
);
create index ecs_hw_cabinets_usg_typ_fkidx 
  on ecs_hw_cabinets(generation_type);

drop table ecs_hw_cabinet_alerts cascade constraints;
create table ecs_hw_cabinet_alerts
( cabinet_id    number         not null,
  alert_type    varchar2(50)   default 'CELL' not null,
  --
  server_name   varchar2(4000) not null,
  server_port   number         not null,
  auth_n_encrypt_mode varchar2(256),
  --
  protocol      varchar2(50)   default 'SMTP' not null,
  --
  from_address  clob,
  to_address    clob,
  from_text     varchar2(4000),
  --
  community     varchar2(256),
  CONSTRAINT ecs_hw_cabinet_alerts_pk 
    PRIMARY KEY (cabinet_id, alert_type, protocol),
  CONSTRAINT ecs_hw_cab_alrts_cid_fk FOREIGN KEY (cabinet_id)
    REFERENCES ecs_hw_cabinets(id) deferrable initially deferred,
  CONSTRAINT ecs_hw_cabinet_alerts_type_ck 
      CHECK (alert_type in ('CELL', 'COMPUTE', 'IBSW', 'PDU', 
                            'ETHERSW', 'SPINESW')),
  CONSTRAINT ecs_hw_cabinet_alerts_prtcl_ck 
      CHECK (protocol in ('SMTP', 'SNMP')),
  CONSTRAINT ecs_hw_cabinet_alrt_frm_to_ck
      CHECK (( protocol = 'SMTP' 
              and from_address is not null
              and to_address   is not null
            )
            or
            ( protocol = 'SNMP'
              and from_address is null
              and to_address   is null
            )) 
);

alter table ecs_hw_nodes add (
    ib1_hostname              varchar2(256),
    ib1_ip                    varchar2(256),
    ib1_domain_name           varchar2(256),
    ib1_netmask               varchar2(256),
    ib2_hostname              varchar2(256),
    ib2_ip                    varchar2(256),
    ib2_domain_name           varchar2(256),
    ib2_netmask               varchar2(256),
    higgs_bond0_ip            varchar2(256), 
    higgs_bond0_hostname      varchar2(256), 
    higgs_bond0_netmask       varchar2(256),
    higgs_bond0_gateway       varchar2(256),
    CONSTRAINT ck_ecs_hw_nodes_ib_info CHECK
    (( node_type in ('CELL', 'COMPUTE')
       and ib1_hostname    is not null
       and ib1_ip          is not null
       and ib1_domain_name is not null
       and ib1_netmask     is not null
       and ib2_hostname    is not null
       and ib2_ip          is not null
       and ib2_domain_name is not null
       and ib2_netmask     is not null
     )
     or
     ( node_type in ('IBSW', 'SPINESW', 'PDU', 'ETHERSW')
       and ib1_hostname    is  null
       and ib1_ip          is  null
       and ib1_domain_name is  null
       and ib1_netmask     is  null
       and ib2_hostname    is  null
       and ib2_ip          is  null
       and ib2_domain_name is  null
       and ib2_netmask     is  null
     )
    )
);

alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_node_type;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_ilom_ip;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_ilom_hostname;

alter table ecs_hw_nodes add CONSTRAINT ck_ecs_hw_nodes_node_type 
      CHECK (node_type in ('CELL', 'COMPUTE', 'IBSW', 
                           'SPINESW', 'PDU', 'ETHERSW'));
    
alter table ecs_hw_nodes add CONSTRAINT ck_ecs_hw_nodes_ilom_ip CHECK
    (( /* if not null, node type should be 'CELL', 'COMPUTE' */
          oracle_ilom_ip is not null
      and node_type in ('CELL', 'COMPUTE')
    )
    or
    ( /* if null node type should be ''IBSW', 'PDU', 'ETHERSW' */
          oracle_ilom_ip is null
      and node_type in ('IBSW', 'SPINESW', 'PDU', 'ETHERSW')
    ));

alter table ecs_hw_nodes add CONSTRAINT ck_ecs_hw_nodes_ilom_hostname CHECK
    (( /* if not null, node type should be 'CELL', 'COMPUTE' */
          oracle_ilom_hostname is not null
      and node_type in ('CELL', 'COMPUTE')
    )
    or
    ( /* if null node type should be ''IBSW', 'PDU', 'ETHERSW' */
          oracle_ilom_hostname is null
      and node_type in ('IBSW', 'SPINESW', 'PDU', 'ETHERSW')
    ));

alter table ecs_vcns add (
  generation_type            varchar2(256)  not null,
  CONSTRAINT ecs_vcns_vcn_typ_fk 
      FOREIGN KEY (generation_type)
      REFERENCES ecs_generation_types(name) deferrable initially deferred
);
create index ecs_vcns_vcn_typ_fk_idx on ecs_vcns(generation_type);

alter table ecs_domus modify (db_client_mac null);
alter table ecs_domus modify (db_backup_mac null);
alter table ecs_domus rename column admin_nat_ip to admin_ip;
alter table ecs_domus rename column admin_nat_host_name to admin_host_name;
alter table ecs_domus add(  admin_netmask      varchar2(256),
  admin_domianname   varchar2(512),
  admin_vlan_tag     number,
  admin_gateway      varchar2(256),
  admin_network_type varchar2(256) default 'NAT' not null,
  --
  gateway_adapter  varchar(50) default 'CLIENT' not null,
  hostname_adapter varchar(50) default 'CLIENT' not null,
  --
  db_client_ip         varchar2(256), 
  db_client_host_name  varchar2(512),
  db_client_netmask    varchar2(256),
  db_client_domianname varchar2(512),
  db_client_vlan_tag   number,
  db_client_gateway    varchar2(256),
  --
  db_client_master_interface  varchar2(256),
  db_client_slave_interface_1 varchar2(256),
  db_client_slave_interface_2 varchar2(256),
  --
  db_client_vip            varchar2(256), 
  db_client_vip_host_name  varchar2(512),
  db_client_vip_netmask    varchar2(256),
  db_client_vip_domianname varchar2(512),
  db_client_vip_vlan_tag   number,
  db_client_vip_gateway    varchar2(256),
  --
  db_backup_ip         varchar2(256), 
  db_backup_host_name  varchar2(512),
  db_backup_netmask    varchar2(256),
  db_backup_domianname varchar2(512),
  db_backup_vlan_tag   number,
  db_backup_gateway    varchar2(256),
  --
  db_backup_master_interface  varchar2(256),
  db_backup_slave_interface_1 varchar2(256),
  db_backup_slave_interface_2 varchar2(256),
  --
  compute_ib1_ip         varchar2(256),
  compute_ib1_host_name  varchar2(256),
  compute_ib1_netmask    varchar2(256),
  compute_ib1_domianname varchar2(512),
  compute_ib1_gateway    varchar2(256),
  --
  compute_ib2_ip         varchar2(256),
  compute_ib2_host_name  varchar2(256),
  compute_ib2_netmask    varchar2(256),
  compute_ib2_domianname varchar2(512),
  compute_ib2_gateway    varchar2(256),
  --
  storage_ib1_ip         varchar2(256),
  storage_ib1_host_name  varchar2(256),
  storage_ib1_netmask    varchar2(256),
  storage_ib1_domianname varchar2(512),
  storage_ib1_gateway    varchar2(256),
  --
  storage_ib2_ip         varchar2(256),
  storage_ib2_host_name  varchar2(256),
  storage_ib2_netmask    varchar2(256),
  storage_ib2_domianname varchar2(512),
  storage_ib2_gateway    varchar2(256),
  --
  vm_size_name          varchar2(32),
  CONSTRAINT ecs_domus_adm_nettype_ck CHECK
     (admin_network_type in ('NAT', 'NON-NAT')),
  CONSTRAINT ecs_domus_gtwy_adptr CHECK
     (gateway_adapter in ('ADMIN', 'CLIENT', 'BACKUP')),
  CONSTRAINT ecs_domus_hostname_adptr CHECK
     (hostname_adapter in ('ADMIN', 'CLIENT', 'BACKUP')),
  CONSTRAINT ecs_domus_admin_ck CHECK
    (( /* for BMC :if admin_network_type is NAT, admin_host_name cannot be null */
          admin_network_type = 'NAT'
      and db_client_mac   is not null
      and db_backup_mac   is not null
     ) 
     or
     ( /* for all others db_client_mac, db_backup_mac are null */
          admin_network_type = 'NON-NAT'
    )) 
);

drop table ecs_vm_sizes;
create table ecs_vm_sizes
( hw_model   varchar2(128) not null,
  size_name  varchar2(32)  default 'Large' not null,
  cpu_count  number        not null,
  memory_size varchar2(64) not null,
  disk_size varchar2(64)   not null,
  CONSTRAINT ecs_vm_sizes_pk PRIMARY KEY (hw_model, size_name),
  CONSTRAINT ecs_vm_sizes_name_ck CHECK
    (size_name in ('Large', 'Medium', 'Small'))
);

insert into ecs_vm_sizes values ('X6-2','Large', 16,'64Gb', '60Gb');
insert into ecs_vm_sizes values ('X6-2','Medium',8, '32Gb', '40Gb');
insert into ecs_vm_sizes values ('X6-2','Small', 4, '16Gb', '20Gb');
insert into ecs_vm_sizes values ('X7-2','Large', 16,'64Gb', '60Gb');
insert into ecs_vm_sizes values ('X7-2','Medium',8, '32Gb', '40Gb');
insert into ecs_vm_sizes values ('X7-2','Small', 4, '16Gb', '20Gb');
commit;

drop table ecs_clusters cascade constraints;
create table ecs_clusters
( ecs_racks_name    varchar2(100)  not null,
  scan_name         varchar2(4000) not null,
  scan_port         number         not null,
  scan_ip1          varchar2(256)  not null,
  scan_ip2          varchar2(256)  ,
  scan_ip3          varchar2(256) ,
  scan_netmask      varchar2(256),
  scan_gateway      varchar2(256),
  scan_domainname   varchar2(512),
  scan_vlan_tag     number,
  --
  gi_basedir     varchar2(4000) not null,
  gi_clustername varchar2(8)    not null,
  gi_homeloc     varchar2(4000) not null,
  gi_version     varchar2(256)  not null,
  inventory_loc  varchar2(4000) not null,
  patchlist      clob,
  --
  ntp_ip1        varchar2(256) not null,
  ntp_ip2        varchar2(256),
  ntp_ip3        varchar2(256),
  --
  dns_ip1        varchar2(256) not null,
  dns_ip2        varchar2(256),
  dns_ip3        varchar2(256),
  --
  timezone       varchar2(64),
  CONSTRAINT ecs_clusters_rakname_pk PRIMARY KEY (ecs_racks_name),
  CONSTRAINT ecs_clusters_rakname_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);

drop table ecs_cluster_diskgroups cascade constraints;
create table ecs_cluster_diskgroups
( ecs_racks_name   varchar2(100) not null,
  disk_group_name  varchar2(256) not null,
  disk_group_type  varchar2(256) default 'DATA' not null,
  disk_group_size  varchar2(128) not null,
  disk_group_redundancy varchar2(128) default 'HIGH' not null,
  CONSTRAINT ecs_clusters_dskgrp_pk 
    PRIMARY KEY (ecs_racks_name, disk_group_name),
  CONSTRAINT ecs_cls_dskgrp_rknm_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred,
  CONSTRAINT ecs_cls_dskgrp_type_ck CHECK 
    (disk_group_type in ('DATA', 'RECO', 'REDO')),
  CONSTRAINT ecs_cls_dskgrp_reduncy_ck CHECK
    (disk_group_redundancy in ('HIGH', 'NORMAL', 'EXTERNAL'))
);
create index ecs_cls_dskgrp_rknm_fk_idx 
  on ecs_cluster_diskgroups(ecs_racks_name);

drop table ecs_database_homes cascade constraints;
create table ecs_database_homes
( ecs_racks_name  varchar2(100) not null,
  basedir         varchar2(256) not null,
  db_home_name    varchar2(256) not null,
  db_home_loc     varchar2(4000) not null,
  invloc          varchar2(4000) not null,
  db_version      varchar2(256) not null,
  db_lang         varchar2(128) not null,
  patchlist       clob,
  CONSTRAINT ecs_database_homes_pk PRIMARY KEY (ecs_racks_name, db_home_name),
  CONSTRAINT ecs_db_homes_rknm_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);
create index ecs_db_homes_rknm_fk_idx
  on ecs_database_homes(ecs_racks_name);

drop table ecs_databases cascade constraints;
create table ecs_databases 
( ecs_racks_name  varchar2(100) not null,
  db_home_name     varchar2(256) not null,
  db_name_or_sid   varchar2(256) not null,
  db_lang          varchar2(256) not null,
  db_version       varchar2(256) not null,
  db_charset       varchar2(256) not null,
  cdb_or_pdb       varchar2(256) default 'CDB' not null,
  db_blocksize     number,
  db_template      varchar2(256) default 'OLTP' not null ,
  CONSTRAINT ecs_database_pk PRIMARY KEY 
     (ecs_racks_name, db_home_name, db_name_or_sid),
  CONSTRAINT ecs_db_rakname_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred,
  CONSTRAINT ecs_db_home_fk FOREIGN KEY (ecs_racks_name, db_home_name)
    REFERENCES ecs_database_homes(ecs_racks_name, db_home_name) 
    deferrable initially deferred,
  CONSTRAINT ecs_databases_type_ck CHECK
     (cdb_or_pdb in ('CDB', 'PDB')),
  CONSTRAINT ecs_databases_template_ck CHECK
     (db_template in ('OLTP', 'DSS'))
);
create index ecs_db_rakname_fk_idx on ecs_databases(ecs_racks_name);
create index ecs_db_home_fk_idx on ecs_databases(ecs_racks_name, db_home_name);

--END Bug 26751817 : compose cluster for GEN1, HIGGS

-- Begin multi-vm changes

-- Create ecs_rack_slots table
create table ecs_rack_slots (
    rack_name        varchar2(256),
    exadata_id       varchar2(512) not null,
    cluster_id       varchar2(256),
    details          CLOB not null,
    source           varchar2(256) not null, -- OPS, HIGGS
    CONSTRAINT pk_rack_slots_rack_name
        PRIMARY KEY (rack_name),
    CONSTRAINT fk_rack_slots_exadata_id
        FOREIGN KEY (exadata_id)
        REFERENCES ecs_exadata(exadata_id) NOVALIDATE,
    CONSTRAINT chk_rack_slots_source
       CHECK (source in ('OPS', 'HIGGS'))
);

create table ecs_exaservice(
  id varchar2(4000) not null, -- Caller defined service id
  exadata_id varchar2(512) not null, -- Internal Exadata container for ecs_racks
  name varchar2(256) not null, -- Customer defined serice name
  racksize varchar2(64) not null, -- QUARTER, HALF etc.
  model varchar2(64) not null, -- the hardware model
  base_cores number not null, -- minimum cores
  additional_cores number not null, -- additional cores the customer may purchase
  burst_cores number not null, -- burst cores
  memorygb number not null, -- Each cluster is allocated a part of it
  storagetb number not null, -- Each cluster is allocated a part of it.
  purchasetype varchar2(64) not null, -- subscription, metered etc.
  payload_archive CLOB not null, -- archive the request payload
  CONSTRAINT pk_exaservice_id PRIMARY KEY (id),
  CONSTRAINT fk_exadata_id FOREIGN KEY (exadata_id) REFERENCES ecs_exadata(exadata_id)
);

create table ecs_cluster_shapes (
      model               varchar2(100) not null,
      racksize            varchar2(100) not null,
      shape               varchar2(100) not null,  -- Multi-vm shapes. SMALL, MEDIUM, LARGE, WHOLE
      numCoresPerNode   number        not null, -- total number of cores per node for a given shape
      gbMemPerNode     number        not null,  -- total memory per node for a given shape
      tbStoragePerCluster number        not null,  -- total disk space per cluster for a given shape
      gbOhSize            number        not null,  -- the Oracle home size on local disk partition
      -- disable clushapes_size_model_fkey for now as model and racksize can be ALL to support default shapes
      -- validate against ecs_hardware in code
      --CONSTRAINT clushapes_size_model_fkey FOREIGN KEY (model, racksize)
      --REFERENCES ecs_hardware(model, racksize) not deferrable,
      CONSTRAINT ecs_cluster_shapes_ck CHECK (SHAPE in ('SMALL', 'MEDIUM', 'LARGE', 'WHOLE')),
      CONSTRAINT cluster_shapes_pk PRIMARY KEY (model, racksize, shape)
);

truncate table ecs_hardware;

alter table ecs_hardware
    add (tbStorage number not null);

alter table pods
    add (exaservice_id varchar2(4000) null);


alter table ecs_exaunitdetails
    add (gb_storage NUMBER);

alter table ecs_exaunitdetails
    add (gb_ohsize NUMBER);

-- X4-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X4-2', 'QUARTER', 8,  22, 240, 42);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X4-2', 'HALF',    8,  22, 240, 42);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X4-2', 'FULL',    8,  22, 240, 42);

-- X5-2
-- No eighth rack for X5-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X5-2', 'QUARTER', 8,  34, 240, 42);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X5-2', 'HALF',   14,  34, 240, 84);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X5-2', 'FULL',   14,  34, 240, 168);
-- X6-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X6-2', 'EIGHTH',   8, 34, 240, 42);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X6-2', 'QUARTER', 11, 42, 720, 84);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X6-2', 'HALF',    11, 42, 720, 168);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X6-2', 'FULL',    11, 42, 720, 336);
-- adding x7 hardware support
-- tbStorage from http://www.oracle.com/technetwork/database/exadata/exadata-x7-2-ds-3908482.pdf
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'EIGHTH',   8, 34, 240, 53);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'QUARTER', 11, 46, 720, 107);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'HALF',    11, 46, 720, 250);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'FULL',    11, 46, 720, 499);

-- cluster shapes
-- Have presets that are fixed per shape and is same for all racksizes and models
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'SMALL', 4, 30, 3, 60);
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'MEDIUM', 8, 60, 8, 60);
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'LARGE', 16, 120, 20, 60);
-- The default WHOLE value will be fetched from ecs_hardware table

-- The max duration in mins that a exaservice sync operation can be in progress
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_EXASERVICE_LOCK_TIME_MINS', 'EXASERVICE', '10');

-- End multi-vm changes

-- Begin changes from srtata - bug 27166380: add cnsenabled column in ecs_racks
alter table ecs_racks modify disabled default 0;
-- update existing rows with NULL value in disabled column 
update ecs_racks set disabled=0 where disabled IS NULL;
alter table ecs_racks add (cnsenabled NUMBER(1) default 1);
-- End changes from srtata - bug 27166380: add cnsenabled column in ecs_racks

commit;
exit;
