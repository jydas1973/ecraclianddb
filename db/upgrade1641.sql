Rem
Rem $Header: ecs/ecra/db/upgrade1641.sql /main/3 2016/08/21 22:30:05 angfigue Exp $
Rem
Rem upgrade1641.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1641.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1641.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    yifding     07/21/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


drop table ecs_exaunitdetails;

create table ecs_exaunitdetails (
        exaunit_id          NUMBER,
        pod_guid            VARCHAR2(36),
        exaunit_name        VARCHAR2(16),
        entitlement_id      VARCHAR2(16),
        subscription_id     VARCHAR2(36),
        customer_name       VARCHAR2(256),
        csi                 VARCHAR2(16),
        backup_disk         VARCHAR2(16),
        create_sparse       VARCHAR2(16),
        racksize            VARCHAR2(16),
        initial_cores       NUMBER,
        gb_memory           NUMBER,
        tb_storage          NUMBER,
        CONSTRAINT exaunitdetail_pk PRIMARY KEY (exaunit_id)
);

commit;


drop table ecs_registries;

ALTER TABLE ecs_racks DROP COLUMN details;
ALTER TABLE ecs_racks ADD disabled NUMBER(1) DEFAULT 0;

-- assumption here that all the "inuse" racks are created successfully
UPDATE ecs_racks SET status='PROVISIONED' WHERE status='INUSE';
-- assumption here that all the previous create database calls were create starter db calls because the new create addi db endpoint is not released yet
UPDATE ecs_requests SET operation='create-starter-db' WHERE operation='createDatabase';
-- CLOB field to store the exacloud body that bypass the errors from dbaas tools
ALTER TABLE ecs_requests ADD BODY CLOB null;

ALTER TABLE databases ADD status VARCHAR2(36);
UPDATE databases SET status='CREATED' WHERE status is null;

create table ecs_registries (
    RACK_ID       VARCHAR2(512),
    REQUEST_ID    VARCHAR2(36),
    OPERATION     VARCHAR2(24)
);

commit;
exit;
