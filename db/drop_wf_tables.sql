Rem
Rem drop_wf_tables.sql
Rem
Rem Copyright (c) 2017, 2019, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drop_wf_tables.sql
Rem
Rem    DESCRIPTION
Rem      Drops all the workflow schema sequences, indexes and tables.
Rem
Rem    NOTES
Rem      Only DROP TABLE, INDEX, SEQUENCE DDLs are allowed here in this file
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: exacom/commons-workflow-infra/src/main/db/drop_wf_tables.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    panmishr    09/05/19 - Integrate workflow infra with janitor
Rem    aabharti    08/20/19 - Bug 30157612 - Added task operation table
Rem    sachikuk    03/28/19 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Don't exit on errors, try to do as much cleanup as possible
whenever sqlerror continue;

PROMPT Dropping table wf_task_sm_error
drop table wf_task_sm_error cascade constraints;

PROMPT Dropping table wf_state_machine_error
drop table wf_state_machine_error cascade constraints;

PROMPT Dropping table wf_traversal
drop table wf_traversal cascade constraints;

PROMPT Dropping table wf_task_operation
drop table wf_task_operation cascade constraints;

PROMPT Dropping table wf_task
drop table wf_task cascade constraints;

PROMPT Dropping table wf_active_task_sm_mapping
drop table wf_active_task_sm_mapping cascade constraints;

PROMPT Dropping table wf_task_state_machine
drop table wf_task_state_machine cascade constraints;

PROMPT Dropping table wf_state_machine
drop table wf_state_machine cascade constraints;

PROMPT Dropping table wf_server
drop table wf_server cascade constraints;

PROMPT Dropping table wf_property
drop table wf_property cascade constraints;

whenever sqlerror exit FAILURE;
