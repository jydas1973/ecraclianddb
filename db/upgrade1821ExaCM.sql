Rem
Rem $Header: ecs/ecra/db/upgrade1821ExaCM.sql /main/2 2018/04/18 15:24:06 hgaldame Exp $
Rem
Rem upgrade1821ExaCM.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1821ExaCM.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem     SQL script upgrade to ECS/EXACM 1821 
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1821ExaCM.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hgaldame    04/18/18 - SUPPORT 17.2.6 TO 18.2.1 UPGRADE
Rem    hgaldame    03/05/18 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


Rem
Rem ecs_clusters
Rem    Holds each real application cluster(RAC) info like scan, 
Rem    version, DNS, NTP, timezone so on
Rem

PROMPT create table ecs_clusters
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

Rem
Rem ecs_cluster_diskgroups
Rem    Every Real Application Cluster (RAC) can bave many diskgroups
Rem    and we catalog them here in this table
Rem

PROMPT create table ecs_cluster_diskgroups
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
    (disk_group_type in ('DATA', 'RECO', 'REDO','SYSTEM','DBFS', 'ACFS')),
  CONSTRAINT ecs_cls_dskgrp_reduncy_ck CHECK
    (disk_group_redundancy in ('HIGH', 'NORMAL', 'EXTERNAL'))
);
create index ecs_cls_dskgrp_rknm_fk_idx 
  on ecs_cluster_diskgroups(ecs_racks_name);


Rem
Rem ecs_cluster_shapes
Rem    

PROMPT create table ecs_cluster_shapes
create table ecs_cluster_shapes (
      model               varchar2(100) not null,
      racksize            varchar2(100) not null,
      shape               varchar2(100) not null,  -- Multi-vm shapes. SMALL, MEDIUM, LARGE, WHOLE
      numCoresPerNode     number        not null, -- total number of cores per node for a given shape
      gbMemPerNode        number        not null,  -- total memory per node for a given shape
      tbStoragePerCluster number        not null,  -- total ASM disk space per cluster for a given shape
      gbOhSize            number        not null,  -- the Oracle home size on local disk partition of a node
      -- disable clushapes_size_model_fkey for now as model and racksize can be ALL to support default shapes
      -- validate against ecs_hardware in code
      --CONSTRAINT clushapes_size_model_fkey FOREIGN KEY (model, racksize)
      --REFERENCES ecs_hardware(model, racksize) not deferrable,
      CONSTRAINT ecs_cluster_shapes_ck CHECK (SHAPE in ('SMALL', 'MEDIUM', 'LARGE', 'WHOLE')),
      CONSTRAINT cluster_shapes_pk PRIMARY KEY (model, racksize, shape)
);

Rem
Rem ecs_database_homes
Rem    With in a given Real Application Cluster (RAC) there can be 
Rem    multiple database homes.
Rem    Holds each database home  info like lang, version and so on
Rem    on a given real application cluster.
Rem

PROMPT create table ecs_database_homes
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


Rem
Rem ecs_databases
Rem    Holds each database info like lang, version and so on
Rem    on a given real application cluster
Rem    Many databases can share a database home.
Rem

PROMPT create table ecs_databases 
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


Rem
Rem  ecs_domu_dns_masqs
Rem    In AD/HIGGS dnsmasq is used to manage the domainname to dns.
Rem    This table holds that data
Rem    Primary key is the ecs_racks_name, domu admin_host_name and 
Rem    domain_name
Rem

PROMPT create table ecs_domu_dns_masqs
create table ecs_domu_dns_masqs
( ecs_racks_name       varchar2(256) not null, 
  admin_host_name      varchar2(256) not null,
  domain_name          varchar2(512) not null,
  dns_ip               varchar2(256) not null,
  CONSTRAINT ecs_domus_dnsmsq_pk PRIMARY KEY 
    (ecs_racks_name, admin_host_name, domain_name),  
  CONSTRAINT ecs_domus_dnsmsq_ecrk_name_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);

PROMPT create table ecs_exadata
create table ecs_exadata (
   exadata_id          varchar2(512),
   service_id          varchar2(4000),
   status              varchar2(128) default 'READY', -- READY, ALLOCATED
   model               varchar2(100) not null,
   exadata_size        varchar2(100) not null,
   tmpl_xml            CLOB not null,
   CONSTRAINT pk_exadata_id
       PRIMARY KEY (exadata_id),
   CONSTRAINT chk_exadata_status
       CHECK (status in ('READY', 'ALLOCATED'))
);


PROMPT create table ecs_exaservice
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

PROMPT create table ecs_generation_types
create table ecs_generation_types
(   name       varchar2(256) not null,
    CONSTRAINT ecs_generation_types_pk PRIMARY KEY (name)
);

PROMPT create table ecs_higgscloudip
create table ecs_higgscloudip (
    hostname    varchar2(500) primary key,
    cloudip     varchar2(128)
);


PROMPT create table ecs_higgsclusterid
create table ecs_higgsclusterid (
    clustername varchar2(500) primary key,
    exaunitID number not null,
    clusterid varchar2(128)
);

PROMPT create table ecs_higgsnatvips
create table ecs_higgsnatvips (
    exaunitID number not null,
    hostname    varchar2(500),
    ip     varchar2(128) not null,
    ip_type varchar(128) not null,
    CONSTRAINT ecs_higgsnatvips_pk PRIMARY KEY(exaunitID,ip,ip_type)
);


PROMPT create table ecs_higgscookie
create table ecs_higgscookie (
    subscription_id   varchar2(50),
    cookie            varchar2(4000),
    path              varchar(128),
    max_age           number,
    created           varchar2(128)
);

PROMPT create table ecs_higgspredeploy
create table ecs_higgspredeploy (
    dom0        varchar2(1000) not null,
    bond0_ips   varchar2(1000) not null,
    bond0_mask  varchar2(50) not null,
    bond0_gw    varchar2(50) not null,
    CONSTRAINT ecs_higgs_predeploy_pk PRIMARY KEY(dom0)
);

PROMPT create table ecs_higgsresources
create table ecs_higgsresources (
    exaunitID     number not null,
    clustername   varchar2(256),
    subscriptionid varchar2(50),
    domunames     CLOB,
    resourcelist  CLOB,
    appid         varchar(512),
    secret        varchar(512),
    adminusername varchar(256),
    CONSTRAINT ecs_higgscloudip_pk PRIMARY KEY(exaunitID)
);

Rem ecs_hw_cabinet_alerts
Rem   Information about the alerts where to send and how to send
Rem   This belongs at the cabinet level
Rem
Rem   cabinet_id   - Cabinet to which this alert belongs to
Rem   alert_type   - From where this alert is orginated, cell, compute, ib, pdu 
Rem                  or ethersw
Rem   protocol     - SNMP or SMTP
Rem   from_address - Senders address
Rem   to_address   - To whom it is addressed to
Rem   from_text    - From text
Rem   server_name  - server where this alert has to be sent
Rem   server_port  - server port
Rem   auth_n_encrypt_mode - SSL, TLS, SASL and so on
Rem
PROMPT create table ecs_hw_cabinet_alerts
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

create index ecs_hw_cab_alrts_cid_fk_idx 
  on ecs_hw_cabinet_alerts(cabinet_id);

Rem
Rem --- MDBCS schema structures
Rem
PROMPT create table ecs_mdbcs_patching
create table ecs_mdbcs_patching(
    crid    VARCHAR(500) not null,
    payload CLOB not null,
    status  VARCHAR(100) not null,
    status_detail CLOB,
    CONSTRAINT ecs_mdbcs_patching_pk PRIMARY KEY(crid)
);

PROMPT create table ecs_rack_slots
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

-- begin: bug 26751817
Rem
Rem  ecs_vm_sizes
Rem    Table to hold the vm size detail for various hw models.
Rem
Rem  hw_model - hw model of the node X6-2 or X7-2 and so on
Rem  size_name - Large, Medium and Small. Names that go into the OEDA XML
Rem  cpu_count - Cpus for the given size_name
Rem  memory_size - Memory for the given size_name
Rem  disk_size   - Disk for the given size_name
Rem

PROMPT create table ecs_vm_sizes
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

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails
    add (gb_storage NUMBER);
alter table ecs_exaunitdetails
    add (gb_ohsize NUMBER);

PROMPT Altering table ecs_hardware
truncate table ecs_hardware;
alter table ecs_hardware
    add (maxracks number default 8 not null);
alter table ecs_hardware
    add (tbStorage number not null);


-- Add maxracks column to ecs_hw_cabinets table to hold max racks
PROMPT Altering table ecs_hw_cabinets
alter table ecs_hw_cabinets rename column node_list to cluster_size_constraint;
alter table ecs_hw_cabinets add (
    generation_type         varchar2(256)     default 'BMC' not null,
    CONSTRAINT ecs_hw_cabinets_usg_typ_fk 
      FOREIGN KEY (generation_type)
      REFERENCES ecs_generation_types(name) deferrable initially deferred
);
create index ecs_hw_cabinets_usg_typ_fkidx 
  on ecs_hw_cabinets(generation_type);

PROMPT Altering table ecs_hw_nodes
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
    higgs_bond0_gateway       varchar2(256)
);

alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_node_type;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_ilom_ip;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_ilom_hostname;

alter table ecs_hw_nodes add CONSTRAINT ck_ecs_hw_nodes_ib_info CHECK
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
    ) enable novalidate;


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


-- Add maxracks column to ecs_ib_fabrics 
PROMPT Altering table ecs_ib_fabrics
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


PROMPT Altering table ecs_racks
-- Begin changes from srtata - bug 27166380: add cnsenabled column in ecs_racks
alter table ecs_racks modify disabled default 0;

-- Add exadata_id column to ecs_racks table
PROMPT Altering table ecs_racks
alter table ecs_racks
    add (exadata_id varchar2(512));

PROMPT Altering table ecs_racks
alter table ecs_racks
    add CONSTRAINT fk_rack_exadata_id
        FOREIGN KEY (exadata_id)
        REFERENCES ecs_exadata(exadata_id) NOVALIDATE;

PROMPT Altering table ecs_vcns
alter table ecs_vcns add (
  generation_type            varchar2(256)  default 'BMC' not null,
  CONSTRAINT ecs_vcns_vcn_typ_fk 
      FOREIGN KEY (generation_type)
      REFERENCES ecs_generation_types(name) deferrable initially deferred
);
create index ecs_vcns_vcn_typ_fk_idx on ecs_vcns(generation_type);

PROMPT Altering table pods
alter table pods
    add (exaservice_id varchar2(4000) null);

PROMPT Altering table ecs_domus
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

ALTER TABLE ecs_ib_pkeys_used
ADD CONSTRAINT ecs_ib_pkeys_used_pk PRIMARY KEY (ecs_racks_name, pkey_use);



PROMPT insert data into tables
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
-- FOR  EXACM X7-2	EIGHTH	maxCoresPerNode = 22
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'EIGHTH',   8, 22, 240, 53);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'QUARTER', 11, 46, 720, 107);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'HALF',    11, 46, 720, 250);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage ) VALUES ('X7-2', 'FULL',    11, 46, 720, 499);
-- Have presets that are fixed per shape and is same for all racksizes and models
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'SMALL', 4, 30, 3, 60);
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'MEDIUM', 8, 60, 8, 60);
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'LARGE', 16, 120, 20, 60);
commit;
insert into ecs_generation_types values('BMC');
insert into ecs_generation_types values('GEN1');
insert into ecs_generation_types values('AD');
insert into ecs_generation_types values('EXACM');
commit;
insert into ecs_vm_sizes values ('X6-2','Large', 16,'64Gb', '60Gb');
insert into ecs_vm_sizes values ('X6-2','Medium',8, '32Gb', '40Gb');
insert into ecs_vm_sizes values ('X6-2','Small', 4, '16Gb', '20Gb');
insert into ecs_vm_sizes values ('X7-2','Large', 16,'64Gb', '60Gb');
insert into ecs_vm_sizes values ('X7-2','Medium',8, '32Gb', '40Gb');
insert into ecs_vm_sizes values ('X7-2','Small', 4, '16Gb', '20Gb');
commit;

--SUPPORT UPGRADE 1726 to 1821, different values for properties, ensure creation
DELETE FROM ecs_properties WHERE name='HIGGS_USERNAME';
DELETE FROM ecs_properties WHERE name='FIREWALL_RULES_PER_GROUP';
DELETE FROM ecs_properties WHERE name='FIREWALL_GROUPS_PER_EXAUNIT';
DELETE FROM ecs_properties WHERE name='HIGGS_URL';
commit;

INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_DNS_IPS', 'HIGGS', '10.128.95.200,10.128.95.201');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_PATCH' , 'MDBCS','fleet_patch');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_USERNAME', 'HIGGS', '/root/root');
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_EXASERVICE_LOCK_TIME_MINS', 'EXASERVICE', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_CLOUD_IPPOOL', 'HIGGS', '/oracle/public/cloud-ippool');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NTP_IP', 'HIGGS', '10.150.240.129');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_PATH'  ,'MDBCS', '../../../../mdbcs_home/mdbcscli');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_USER'  ,'MDBCS', 'mdbcs');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_SECRET','MDBCS', 'V2VsY29tZTEh');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_QUERY_URL', 'HIGGS', 'https://10.128.95.197:443/');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_RULES_PER_GROUP', 'FIREWALL', '25');
INSERT INTO ecs_properties (name, type, value) VALUES ('DC_ID', 'NOSDI', 'US-Central');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_CANCEL', 'MDBCS','cancel');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_ENABLE','MDBCS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_FEATURE',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_SITENAME', 'HIGGS', 'usdev2347');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_PSM_SERVICEIP', 'HIGGS', '10.150.240.129/32');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_PASSWORD', 'HIGGS', 'fre123d');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_API_DNS_IPS', 'HIGGS', '10.128.95.199');
INSERT INTO ecs_properties (name, type, value) VALUES ('MOCKEXACLOUD', 'EXACLOUD', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_GROUPS_PER_EXAUNIT',  'FIREWALL', '15');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_URL', 'HIGGS', 'https://10.128.95.197/');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_ERROR_TIMEOUT','EXACLOUD', '60');
commit;


EXIT;
