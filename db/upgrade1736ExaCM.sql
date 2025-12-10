Rem
Rem $Header: ecs/ecra/db/upgrade1736ExaCM.sql /main/8 2018/07/02 07:55:27 hgaldame Exp $
Rem
Rem upgrade1736ExaCM.sql
Rem
Rem Copyright (c) 2017, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      upgrade1736ExaCM.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1736ExaCM.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hgaldame    06/28/18 - XbranchMerge hgaldame_bug-28020620 from
Rem                           st_ecm_18.2.1.0.0
Rem    hgaldame    02/07/18 - XbranchMerge hgaldame_bug-27071543_exacm from
Rem                           st_ecs_17.3.6.0.0exacm
Rem    srtata      10/29/17 - bug 27034487: modify ecs_racks
Rem    hhhernan    10/16/17 - 26761711-EXACM UPGRADE PATH FROM 17.2.6.X TO
Rem                           17.3.6.X
Rem    byyang      10/05/17 - XbranchMerge byyang_bug-26498814 from main
Rem    angfigue    09/21/17 - to the right release branch upgrade script
Rem    srtata      09/20/17 - rfi_backport_26657194: CNS
Rem    srtata      09/18/17 - bug 26817348: add TEST_CNSURLS
Rem    srtata      09/12/17 - bug 26716205: add CNS properties
Rem    angfigue    08/10/17 - basic info for properties
Rem    angfigue    08/10/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- To refresh the hostname in the agent table
DROP TABLE AGENT ;

-- From Upgrade 17.2.5 missing in 17.2.6

ALTER TABLE ecs_racks
DROP CONSTRAINT racks_pk;

-- remove all null name in rack table
UPDATE ecs_racks SET name = domu WHERE name IS NULL;

-- set name column to be not null
ALTER TABLE ecs_racks MODIFY (name VARCHAR2(256) NOT NULL);

-- add opstate column to rack table
ALTER TABLE ecs_racks ADD opstate VARCHAR2(128) DEFAULT 'ONLINE' NOT NULL;

-- add constrain
ALTER TABLE ecs_racks ADD CONSTRAINT ecs_racks_opstate_ck CHECK (opstate in ('ONLINE', 'OFFLINE', 'OPTEST', 'PATCH'));


-- Cluster life cycle management properties
-- default time for purging a cluser after it is deleted (7 days). Can be changed.
-- Only the future deletes will get the new changed value
--
INSERT INTO ecs_properties (name, type, value) VALUES ('CLUSTER_PURGE_DEFAULT_TIME', 'CLUSTER_LIFE_CYCLE', (60 * 60 * 24 * 7));
-- EM integration for create and delete servcie monitoring
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_EMAGENT_PORT', 'EM', '21868');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_EMAGENT_HOST_NAME', 'EM', 'xyz.us.oracle.com');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_TARGET_TYPE', 'EM', 'oracle_cloud_exadata_service');
INSERT INTO ecs_properties (name, type, value) VALUES ('EM_FILE_PATH', 'EM', '/tmp');
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_EM_INTEGRATION', 'EM', 'false');
-- EM Integration for version2
INSERT INTO ecs_properties (name, type, value) VALUES ('LIFECYCLE_STATUS_SDI', 'EM', 'Production');
INSERT INTO ecs_properties (name, type, value) VALUES ('POD_ASSC_PREFIX', 'EM', 'oracle_cloud_exadata_service_sys:ExaCS ');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_TARGET_NAME_PREFIX', 'EM', 'ExaCS ');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_TARGET_NAME_SUFFIX', 'EM', '-svc');
INSERT INTO ecs_properties (name, type, value) VALUES ('DELIMITER_EM', 'EM', '|');
INSERT INTO ecs_properties (name, type, value) VALUES ('CREATE_SERVICE', 'EM', 'ADD_CLOUD_SERVICE');
INSERT INTO ecs_properties (name, type, value) VALUES ('DELETE_SERVICE', 'EM', 'DELETE_CLOUD_SERVICE');
INSERT INTO ecs_properties (name, type, value) VALUES ('CUSTOMER_NAME_SUFFIX', 'EM', ' (Metered)');

-- add remote_user to ecs_requests
ALTER TABLE ecs_requests ADD remote_user VARCHAR2(20);

-- Start Upgrade to 17.3.3 

-- for supporting temporary ssh keys
create table ecs_domukeysinfo (
    id              VARCHAR2(36) not null,
    exaunit_id      NUMBER,
    public_key      VARCHAR2(2048),
    users           VARCHAR(20) ,
    creation_time   VARCHAR2(64) not null,
    ttl             VARCHAR2(64) DEFAULT 86400,
    CONSTRAINT key_id PRIMARY KEY (id)
);

-- Specifies the HIGGs endpoint related information
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_USERNAME', 'HIGGS', 'higgs');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_URL', 'HIGGS', 'http://localhost:8513');

-- for enabling debug tracing (True/False)
INSERT INTO ecs_properties (name, type, value) VALUES ('DEBUG_EXACLOUD', 'DEBUG', 'False');

-- for configurable rack mem settings in a non shared enviroment
ALTER TABLE ecs_hardware ADD memsize number default 240 not null;
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='QUARTER';
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='HALF';
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='FULL';
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize ) VALUES ('X6-2', 'EIGHTH',   8, 34, 240);

-- for setting log level (VERBOSE, DEBUG, INFO, WARNING, ERROR, CRITICAL) in Exacloud.
INSERT INTO ecs_properties (name, type, value) VALUES ('LOG_LEVEL', 'EXACLOUD', 'INFO');

-- for domukeys endpoint
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMUKEYS_TTL', 'EXAUNIT', '86400');

-- End Upgrade to 17.3.3

-- Add UPDATED_XML column to ECS_RACKS table
ALTER TABLE ECS_RACKS ADD (UPDATED_XML CLOB);



drop table psm_properties;
drop table ecs_ords_info;
drop table ecs_scheduledjob;
drop sequence ecs_scheduledjob_id_seq;

-- Add psm_properties table
-- This table is only used for mapping by PSM registration endpoint
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
create table ecs_ords_info(
      exaunit_id       NUMBER not null,
      public_user_pass VARCHAR2(4000) not null,
      identityDomainId VARCHAR2(4000) null,
      CONSTRAINT ecs_ords_info_pk PRIMARY KEY(exaunit_id)
);

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

INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_INTEGRATION', 'CNS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('ORDS_INTEGRATION', 'ORDS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('ORDS_PASSWORD_SIZE', 'ORDS', '8');
INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_ENABLE','CNS','False');
INSERT INTO ecs_properties (name, type, value) VALUES ('TEST_CNSTOPIC','CNS','NONE');
INSERT INTO ecs_properties (name, type, value) VALUES ('TEST_CNSURLS','CNS','FALSE');

-- inital config for ecra diagnosis job (disabled by default)
INSERT INTO ecs_scheduledjob (job_class, job_cmd, job_params, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.resources.DiagnosisResource', 'collect_log', 'type=all', 'N', 3600, 'Init');

commit;

alter table ecs_racks modify disabled default 0;
-- update existing rows with NULL value in disabled column 
update ecs_racks set disabled=0 where disabled IS NULL;

alter table ecs_racks add (cnsenabled NUMBER(1) default 1);
ALTER TABLE ecs_hw_cabinets ADD subnet_id     varchar2(4000) not null;
ALTER TABLE ecs_temp_domus  ADD db_client_mac varchar2(256)  not null;
ALTER TABLE ecs_temp_domus  ADD db_backup_mac varchar2(256)  not null;

drop table patchlist;

drop sequence ibfabricibswitches_seq;
drop trigger ibfabricibswitches_bi;
drop table ibfabricibswitches;

drop sequence ibfabricclusters_seq;
drop trigger ibfabricclusters_bi;
drop table ibfabricclusters;


drop sequence ibfabriclocks_seq;
drop trigger ibfabriclocks_bi;
drop table ibfabriclocks;

commit;
EXIT;
