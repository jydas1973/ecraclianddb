Rem
Rem $Header: ecs/ecra/db/upgrade1625.sql /main/2 2016/04/27 10:02:02 yifding Exp $
Rem
Rem upgrade1625.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1625.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      drop sensitive fields in databases table
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1625.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    yifding     04/14/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

ALTER TABLE databases DROP COLUMN adminPassword;
ALTER TABLE databases DROP COLUMN sshkey;
ALTER TABLE databases DROP COLUMN cloudStorageContainer;
ALTER TABLE databases DROP COLUMN cloudStorageUsername;
ALTER TABLE databases DROP COLUMN cloudStoragePassword;

ALTER TABLE ecs_requests MODIFY RESOURCE_ID VARCHAR2(512);

drop table ecs_racks;
create table ecs_racks (
    cluid       varchar2(512),
    name        varchar2(256),
    model       varchar2(100),
    status      varchar2(100),
    racksize    varchar2(100),
    details     varchar2(4000),
    location    varchar2(256),
    xml         CLOB,
    exaunitID   number,
    CONSTRAINT racks_pk PRIMARY KEY (cluid)
);


commit;
exit;