Rem
Rem $Header: ecs/ecra/db/upgrade1815.sql /main/2 2024/04/10 09:12:42 abysebas Exp $
Rem
Rem upgrade1813.sql
Rem
Rem Copyright (c) 2017, 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      upgrade1813.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1813.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    abysebas    04/03/24 - Bug 36474761 - REMOVE SQLSESSSTART.SQL AND
Rem                           SQLSESSSEND.SQL REFERENCES FROM .SQL FILES
Rem    nitishgu    11/14/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

create table ecs_cluster_connectivity (
      exaunit_id     number not null,
      remote_id      varchar2(4000) not null,
      secgroup_id    number ,
      details        varchar2(4000),
      CONSTRAINT cluster_conn_pk PRIMARY KEY (exaunit_id,remote_id)
);

