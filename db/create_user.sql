Rem &1 = service name
Rem &2 = tablespace name
Rem &3 = username
Rem &4 = password
Rem $5 = tablespace file (full path)
Rem
Rem $Header: ecs/ecra/db/create_user.sql /main/11 2024/11/13 11:25:25 dtalla Exp $
Rem
Rem create_user.sql
Rem
Rem Copyright (c) 2015, 2024, Oracle and/or its affiliates.
Rem All rights reserved.
Rem
Rem    NAME
Rem      create_user.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: dbaas/opc/exadata/ecra/db/create_user.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    ybansod     08/08/24 - Bug 36793073 - Enhance logging for tablespace
Rem                           creation
Rem    abysebas    04/03/24 - Bug 36474761 - REMOVE SQLSESSSTART.SQL AND
Rem                           SQLSESSSEND.SQL REFERENCES FROM .SQL FILES
Rem    aanverma    07/10/17 - Bug #25661103: ECRA db encryption
Rem    hhhernan    01/06/17 - bug 25354257 - tablespace location
Rem    angfigue    04/27/15 - [B[A[D[D[D[D[Dtablespace command update
Rem    angfigue    02/16/15 - Creating the configuration for the database
Rem    angfigue    02/16/15 - Created
Rem

SET SERVEROUTPUT ON
SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

ALTER SYSTEM SET SERVICE_NAMES='&1';

whenever sqlerror exit FAILURE;

-- First try creating encrypted tablespace, if throws exception, try creating
-- non-encrypted one. This way it won't break the production environment if
-- they have not configured wallet for encrypted tablespace creation.
DECLARE
  sql_stmt VARCHAR2(1024);
  dbf      VARCHAR2(256);
  tblspcnm VARCHAR2(128);
BEGIN
  tblspcnm := '&2';
  dbf := '&5';
  sql_stmt := 'CREATE BIGFILE TABLESPACE ' || tblspcnm ||
   ' DATAFILE ''' || dbf || '''' ||
   ' SIZE 10M AUTOEXTEND ON ' ||
   ' ENCRYPTION USING ''AES256''' ||
   ' DEFAULT STORAGE(ENCRYPT)';
  dbms_output.put_line(sql_stmt);
  EXECUTE IMMEDIATE sql_stmt;
EXCEPTION
  WHEN OTHERS THEN
   BEGIN
    sql_stmt := 'CREATE BIGFILE TABLESPACE ' || tblspcnm ||
     ' DATAFILE ''' || dbf || '''' ||
     ' SIZE 10M AUTOEXTEND ON';
    dbms_output.put_line(sql_stmt);
    EXECUTE IMMEDIATE sql_stmt;
   EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating tablespace - '
                                         || tblspcnm
                                         || ': '
                                         || sqlerrm);
   END;
END;
/

CREATE USER &3
   IDENTIFIED BY &4
   DEFAULT TABLESPACE &2;

GRANT DBA, RESOURCE, CONNECT TO &3;
ALTER USER &3 ENABLE EDITIONS;

quit;
/
