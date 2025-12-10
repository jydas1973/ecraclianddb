Rem
Rem $Header: ecs/ecra/db/upgrade1715.sql /main/1 2017/01/13 04:41:28 nitishgu Exp $
Rem
Rem upgrade1715.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1715.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1715.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nitishgu    01/11/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


ALTER TABLE ecs_dataguard add(
      dbSID         varchar2(4000) not null,
      dbUniqueName  varchar2(4000)
);

ALTER TABLE ecs_dataguard DROP CONSTRAINT dataguard_pk;
ALTER TABLE ecs_dataguard  ADD CONSTRAINT dataguard_pk PRIMARY KEY (exaunitID,dbSID);
commit;
