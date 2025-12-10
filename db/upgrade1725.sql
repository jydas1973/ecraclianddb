Rem
Rem $Header: ecs/ecra/db/upgrade1725.sql /main/12 2017/04/25 16:31:00 sgundra Exp $
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
Rem    sgundra     04/23/17 - Bug 25932707 - EM Integration v2
Rem    brsudars    04/19/17 - Add ecs_zonal_requests table
Rem    xihzhang    04/13/17 - Bug 25683130 BM: add opstate attribute for racks
Rem    sgundra     04/10/17 - Bug 25667474 : EM integration
Rem    nkedlaya    03/29/17 - move the contents from upgrade1725.sql to
Rem                           upgrade1723.sql
Rem    nkedlaya    03/25/17 - bug 25712702 : FUNCATIONALITY TO QUERY THE 
Rem                           AVAILABLE CAPACITY FROM ECRA DB
Rem    nkedlaya    03/13/17 - bug 25703206
Rem    nkedlaya    02/17/17 - upgrade SQL script for version 1725
Rem    nkedlaya    02/17/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

ALTER TABLE ecs_zones DROP CONSTRAINT zone_pk;
ALTER TABLE ecs_zones ADD CONSTRAINT zone_pk PRIMARY KEY (zone,location);

create table  ecs_zonal_requests (
  id                 varchar2(100) not null, --unique id from caller like TAS
  zone               varchar2(100), -- Primary key of ecs_zones to determine zone details like auth
  rackname           varchar2(256), -- The reserved rack on which create service is being done
  location           varchar2(30) default 'REMOTE' not null,
  CONSTRAINT ecs_zonal_req_zone_fkey FOREIGN KEY (zone,location)
  REFERENCES ecs_zones(zone,location) not deferrable,
  CONSTRAINT ecs_zonal_req_location_ck CHECK (LOCATION in ('REMOTE', 'LOCAL')),
  CONSTRAINT id_unique UNIQUE(ID) enable
);

ALTER TABLE ecs_racks
DROP CONSTRAINT racks_pk;

-- remove all null name in rack table
UPDATE ecs_racks SET name = domu WHERE name IS NULL;

-- add new entries to ecs_properties
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

-- set name column to be not null
ALTER TABLE ecs_racks MODIFY (name VARCHAR2(256) NOT NULL);

-- add opstate column to rack table
ALTER TABLE ecs_racks ADD opstate VARCHAR2(128) DEFAULT 'ONLINE' NOT NULL;

-- add constrain
ALTER TABLE ecs_racks ADD CONSTRAINT ecs_racks_opstate_ck CHECK (opstate in ('ONLINE', 'OFFLINE', 'OPTEST', 'PATCH'));

-- add remote_user to ecs_requests
ALTER TABLE ecs_requests ADD remote_user VARCHAR2(20);

COMMIT;
EXIT;
