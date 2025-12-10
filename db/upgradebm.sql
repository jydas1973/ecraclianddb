Rem
Rem
Rem upgrade1725.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1725.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      Adds GEN2 tables
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1725.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nkedlaya    11/09/17 - Bug 26751817 : compose cluster for GEN1, HIGGS
Rem                           and EXACM
Rem    aschital    04/29/17 - Bug 25977510

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- set name column to be not null
ALTER TABLE ecs_racks MODIFY (name VARCHAR2(256) NOT NULL);

-- add opstate column to rack table
ALTER TABLE ecs_racks ADD opstate VARCHAR2(128) DEFAULT 'ONLINE' NOT NULL;

-- add constraint
ALTER TABLE ecs_racks ADD CONSTRAINT ecs_racks_opstate_ck 
  CHECK (opstate in ('ONLINE', 'OFFLINE', 'OPTEST', 'PATCH'));

COMMIT;

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
  hostname_adapter varchar(50) default 'ADMIN' not null,
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

EXIT;
