Rem
Rem $Header: ecs/ecra/db/upgrade1811.sql /main/20 2017/12/19 14:55:20 rgmurali Exp $
Rem
Rem upgrade1813.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1745.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1733.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    rgmurali    12/19/17 - Bug 27284713 - Add higgs insert statements.
Rem    rgmurali    12/08/17 - XbranchMerge rgmurali_bug-27227924 from
Rem                           st_ecs_17.4.5.0.0
Rem    nkedlaya    12/07/17 - move compose cluster related changes to the
Rem                           upgrade181300.sql
Rem    brsudars    12/07/17 - Multi-vm db changes
Rem    jreyesm     12/01/17 - Bug 27208185. Missing ecs_higgscookie table.
Rem    jreyesm     11/10/17 - Bug 27090986. Higgs Bond0 new table.
Rem    nkedlaya    11/09/17 - Bug 26751817 : compose cluster for GEN1, HIGGS
Rem                           and EXACM
Rem    sgundra     11/08/17 - Bug-27063758 : Support X7 hardware
Rem    sgundra     10/26/17 - Bug 27032521 - get a list of all the datacenters
Rem    rgmurali    10/24/17 - Bug 26823575 - Add APPID support for higgs.
Rem    rgmurali    10/25/17 - Bug 27025847 Migrate 1743.sql here
Rem    jreyesm     10/20/17 - Bug 26991724. MDBCS status_detail field.
Rem    jreyesm     10/18/17 - Bug 26887484. Add timeout to Exacloud status
Rem                           call.
Rem    rgmurali    10/10/17 - Bug-26928768 - Add some more higgs properties
Rem    angfigue    10/02/17 - dbcs info for manage
Rem    rgmurali    09/18/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- 1743 updates goes here

-- Add psm_properties table 
-- This table is only used for mapping by PSM registration endpoint
drop table psm_properties;
create table psm_properties(
    exaunit_id       NUMBER not null ,
    dbname           VARCHAR2(4000) not null,
    identityDomainId VARCHAR2(4000) not null,
    PSMserviceId     VARCHAR2(4000) not null,
    idcsPort         NUMBER,
    idcsProtocol     VARCHAR2(128),
    idcsHost         VARCHAR2(500),
    clientId         VARCHAR2(4000),
    cnsInfo          VARCHAR2(4000),
    idcsTenant       VARCHAR2(2000),
    encodedString    VARCHAR2(4000),
    cloudProps       CLOB,
    CONSTRAINT psm_properties_pk PRIMARY KEY (exaunit_id,dbname)
);

-- Add ords table 
-- specific for ORDS properties independent of PSM properties 
drop table ecs_ords_info;
create table ecs_ords_info(
      exaunit_id       NUMBER not null,
      public_user_pass VARCHAR2(4000) not null,
      identityDomainId VARCHAR2(4000) null,
      CONSTRAINT ecs_ords_info_pk PRIMARY KEY(exaunit_id)
);


drop table ecs_scheduledjob;
drop sequence ecs_scheduledjob_id_seq;

-- Add ecra scheduling table
create table ecs_scheduledjob (
    id              NUMBER,
    job_class       VARCHAR2(256)   NOT NULL,
    job_cmd         VARCHAR2(4000),
    job_params      VARCHAR2(1024),
    enabled         CHAR(1) CHECK (enabled in ('Y', 'N')),
    interval        NUMBER          NOT NULL,
    last_update     TIMESTAMP,
    last_update_by  VARCHAR2(256),
    status          VARCHAR2(16),
    CONSTRAINT ecs_scheduledjob_pk PRIMARY KEY (id),
    CONSTRAINT ecs_scheduledjob_uniq UNIQUE (job_class, job_cmd, job_params)
);

create sequence ecs_scheduledjob_id_seq;

-- Put initial value of 'last_update' as some amount (i.e. 60 days here)
-- before current time.
-- This makes an added job to run immediately not waiting for the interval.
create or replace trigger ecs_scheduledjob_trg
before insert on ecs_scheduledjob
for each row
begin
  :new.id := ecs_scheduledjob_id_seq.nextval;
  :new.last_update := systimestamp - interval '60' day;
  :new.status := 'READY';
end;
/

-- inital config for ecra diagnosis job (disabled by default)
INSERT INTO ecs_scheduledjob (job_class, job_cmd, job_params, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.resources.DiagnosisResource', 'collect_log', 'type=all', 'N', 3600, 'Init');

INSERT INTO ecs_properties (name, type, value) VALUES ('ORDS_PASSWORD_SIZE', 'ORDS', '8');

-- for setting log level (VERBOSE, DEBUG, INFO, WARNING, ERROR, CRITICAL) in Exacloud.
INSERT INTO ecs_properties (name, type, value) VALUES ('LOG_LEVEL', 'EXACLOUD', 'INFO');

COMMIT;

INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_CLOUD_IPPOOL','HIGGS','/oracle/public/cloud-ippool');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_FEATURE','FEATURE','DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_ENABLE','CNS','False');
INSERT INTO ecs_properties (name, type, value) VALUES ('TEST_CNSTOPIC','CNS','NONE');
INSERT INTO ecs_properties (name, type, value) VALUES ('TEST_CNSURLS','CNS','FALSE');

-- adding x7 hardware support
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize ) VALUES ('X7-2', 'EIGHTH',   8, 34, 240);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize ) VALUES ('X7-2', 'QUARTER', 11, 46, 720);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize ) VALUES ('X7-2', 'HALF',    11, 46, 720);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize ) VALUES ('X7-2', 'FULL',    11, 46, 720);

-- create ecs_exadata table
drop table ecs_exadata;
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

-- Add exadata_id column to ecs_racks table
alter table ecs_racks
    add (exadata_id varchar2(512));

alter table ecs_racks
    add CONSTRAINT fk_rack_exadata_id
        FOREIGN KEY (exadata_id)
        REFERENCES ecs_exadata(exadata_id) NOVALIDATE;

-- Add maxracks column to ecs_hardware table to hold max racks
alter table ecs_hardware
    add (maxracks number default 8 not null);

-- Update the value of FIREWALL_RULES_PER_GROUP
update ecs_properties
 set VALUE=25
 where NAME='FIREWALL_RULES_PER_GROUP';

-- Update the value of FIREWALL_GROUPS_PER_EXAUNIT 
update ecs_properties
 set VALUE=15
 where NAME='FIREWALL_GROUPS_PER_EXAUNIT';

COMMIT;

-- 1745 updates goes here

-- create ecs_higgsresources table
drop table ecs_higgsresources;
create table ecs_higgsresources (
    exaunitID     number not null,
    clustername   varchar2(256),
    subscriptionid varchar2(50),
    resourcelist  varchar(4000),
    CONSTRAINT ecs_higgscloudip_pk PRIMARY KEY(exaunitID)
);

drop table ecs_higgscookie;
create table ecs_higgscookie (
    subscription_id   varchar2(50),
    cookie            varchar2(4000),
    path              varchar(128),
    max_age           number,
    created           varchar2(128)
);

commit;

drop table ecs_mdbcs_patching;
create table ecs_mdbcs_patching(
    crid    VARCHAR(500) not null,
    payload CLOB not null,
    status  VARCHAR(100) not null,
    status_detail CLOB,
    CONSTRAINT ecs_mdbcs_patching_pk PRIMARY KEY(crid)
);

alter table ecs_higgsresources
    add (appid varchar(512));
alter table ecs_higgsresources
    add (secret varchar(512));
alter table ecs_higgsresources
    add (adminusername varchar(256));

drop table ecs_higgspredeploy;
create table ecs_higgspredeploy (
    dom0        varchar2(1000) not null,
    bond0_ips   varchar2(1000) not null,
    bond0_mask  varchar2(50) not null,
    bond0_gw    varchar2(50) not null,
    CONSTRAINT ecs_higgs_predeploy_pk PRIMARY KEY(dom0)
); 

-- MDBCS properties for integration
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_ENABLE','MDBCS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_PATH'  ,'MDBCS', '../../../../mdbcs_home/mdbcscli');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_USER'  ,'MDBCS', 'mdbcs');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_SECRET','MDBCS', 'V2VsY29tZTEh');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_PATCH' , 'MDBCS','fleet_patch');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_CANCEL', 'MDBCS','cancel');

-- Update HIGGS properties 
UPDATE ecs_properties SET value='https://10.128.95.197/' WHERE name='HIGGS_URL';

-- Add new HIGGS properties
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_SITENAME', 'HIGGS', 'usdev2347');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_DNS_IPS', 'HIGGS', '10.128.95.200,10.128.95.201');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_API_DNS_IPS', 'HIGGS', '10.128.95.199');
DELETE FROM ecs_properties where name='BOND0_IPS' and type='HIGGS';

INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NTP_IP', 'HIGGS', '10.150.240.129');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_PSM_SERVICEIP', 'HIGGS', '10.150.240.129/32');
DELETE FROM ecs_properties WHERE name='HIGGS_NTP_SERVER';
DELETE FROM ecs_properties WHERE name='HIGGS_SERVICE_IPPOOL';

-- Higgs NoSDI support
INSERT INTO ecs_properties (name, type, value) VALUES ('DC_ID', 'NOSDI', 'US-Central');

DELETE FROM ecs_properties WHERE name = 'HIGGS_QUERY_URL';
DELETE FROM ecs_properties WHERE name = 'HIGGS_USERNAME';
DELETE FROM ecs_properties WHERE name = 'HIGGS_PASSWORD';

-- Change the resourcelist cloumn in ecs_higgsresources from varchar to CLOB
alter table ecs_higgsresources add (temp CLOB);
update ecs_higgsresources SET temp = resourcelist;
alter table ecs_higgsresources drop column RESOURCELIST;
alter table ecs_higgsresources rename column temp to RESOURCELIST;

-- create ecs_higgscloudip table
drop table ecs_higgscloudip;
create table ecs_higgscloudip (
    hostname    varchar2(500) primary key,
    cloudip     varchar2(128)
);

-- Exacloud 500 status Bug 26887484
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_ERROR_TIMEOUT','EXACLOUD', '60');

-- Create ecs_rack_slots table
create table ecs_rack_slots (
    rack_name        varchar2(256),
    exadata_id       varchar2(512) not null,
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

COMMIT;
EXIT;
