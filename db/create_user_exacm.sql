Rem &1 = tablespace name
Rem &2 = username
Rem &3 = password
Rem
Rem $Header: ecs/ecra/db/create_user_exacm.sql /main/1 2017/06/22 08:12:02 hhhernan Exp $
Rem
Rem create_user.sql
Rem
Rem Copyright (c) 2015, 2017, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      create_user_exacm.sql - Create DB user for ExaCM (AMOS)
Rem
Rem    DESCRIPTION
Rem      Forked version for ExaCM 1.2 (AMOS, ECS 17.2.6, OCM 17.2.3)
Rem
Rem    NOTES
Rem      To be used in Oracle PDB 12.1 
Rem      the table space data file should be stored in ASM
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
Rem    hhhernan    06/21/17 - Create user for exacm amos
Rem    hhhernan    01/06/17 - bug 25354257 - tablespace location
Rem    angfigue    04/27/15 - Tablespace command update
Rem    angfigue    02/16/15 - Creating the configuration for the database
Rem    angfigue    02/16/15 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


DROP USER &2 CASCADE;

DROP TABLESPACE &1 INCLUDING CONTENTS AND DATAFILES;


CREATE  TABLESPACE  &1 DATAFILE 
   SIZE 10M
   AUTOEXTEND ON;

CREATE USER &2
   IDENTIFIED BY &3
   DEFAULT TABLESPACE &1;

GRANT DBA, RESOURCE, CONNECT TO &2;


quit;
