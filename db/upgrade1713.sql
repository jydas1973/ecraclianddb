Rem
Rem $Header: ecs/ecra/db/upgrade1713.sql /main/2 2016/12/19 23:42:50 diglesia Exp $
Rem
Rem upgrade1713.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1713.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1713.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    diglesia    12/15/16 - update min cores for x6
Rem    sergutie    12/05/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- increase association fields
ALTER TABLE ecs_associations MODIFY (
    ID VARCHAR2(128),
    SERVICE_ID VARCHAR2(128),
    SERVICE_NAME VARCHAR2(128),
    SERVICE_TYPE VARCHAR2(128));

-- update x6 min cores
UPDATE ecs_hardware SET minCoresPerNode=11 where model='X6-2';

COMMIT;
