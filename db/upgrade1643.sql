Rem
Rem $Header: ecs/ecra/db/upgrade1643.sql /main/4 2016/09/18 06:56:31 hnvenkat Exp $
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
;

drop table ecs_associations;

create table ecs_associations (
    ID             VARCHAR2(36),
    EXAUNIT_ID     NUMBER,
    SERVICE_ID     VARCHAR2(36),
    SERVICE_NAME   VARCHAR2(36),
    SERVICE_TYPE   VARCHAR2(36),
    ENDPOINTS      CLOB,
    CONSTRAINT association_pk PRIMARY KEY (id)
);


ALTER TABLE services ADD identity_domain_name VARCHAR(4000) NULL;
ALTER TABLE ecs_requests DROP COLUMN details;
ALTER TABLE ecs_requests ADD details CLOB;

ALTER TABLE ecs_exaunitdetails ADD grid_version VARCHAR2(36) DEFAULT '12.1';

ALTER TABLE databases ADD dbtype VARCHAR2(36);
UPDATE databases SET dbtype='STARTER' WHERE dbtype is null;

commit;
exit;
