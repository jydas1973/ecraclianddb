Rem
Rem $Header: ecs/ecra/db/upgrade1544.sql /main/4 2024/04/10 09:12:42 abysebas Exp $
Rem
Rem upgrade1544.sql
Rem
Rem Copyright (c) 2015, 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      upgrade1544.sql - this is a database schema upgrade sql script for 15.4.4
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1544.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    abysebas    04/03/24 - Bug 36474761 - REMOVE SQLSESSSTART.SQL AND
Rem                           SQLSESSSEND.SQL REFERENCES FROM .SQL FILES
Rem    angfigue    10/27/15 - Adding upgrade of async_calls√
Rem    yifding     10/19/15 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

drop table hardware_info;
create table hardware_info (
      model            varchar2(100) not null,
      minCoresPerNode  number        not null,
      maxCoresPerNode  number        not null,
      CONSTRAINT hardware_pk PRIMARY KEY (model)
);

commit;

INSERT INTO hardware_info (model, minCoresPerNode, maxCoresPerNode)
VALUES ('X4-2', 9, 22);
INSERT INTO hardware_info (model, minCoresPerNode, maxCoresPerNode)
VALUES ('X5-2', 14, 34);

alter table async_calls 
    add RID VARCHAR(50);

commit;

exit;

