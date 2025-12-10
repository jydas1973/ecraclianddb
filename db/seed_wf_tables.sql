Rem
Rem $Header: ecs/ecra/db/seed_wf_tables.sql /main/5 2024/07/16 16:30:48 piyushsi Exp $
Rem
Rem seed_wf_tables.sql
Rem
Rem Copyright (c) 2019, 2024, Oracle and/or its affiliates. 
Rem
Rem    NAME
Rem      seed_wf_tables.sql
Rem
Rem    DESCRIPTION
Rem      Bootstrapping data can be inserted or modified in this file
Rem      File has 3 section.
Rem      1. DELETEs 
Rem      2. INSERTs
Rem      3. UPDATEs
Rem      DO NOT MODIFY the above sequence of DMLs
Rem
Rem    NOTES
Rem      Following are allowed here
Rem      1. INSERT INTO <table>
Rem      2. UPDATE <table>
Rem      3. DELETE from <table>
Rem     
Rem      No DDLs are allowed in this file
Rem      There should be one single commit in the end of the file.
Rem      Do not COMMIT in the middle of the file
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: exacom/commons-workflow-infra/src/main/db/seed_wf_tables.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    panmishr    09/05/19 - Integrate workflow infra with janitor.
Rem    sachikuk    07/09/19 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Don't exit on errors
whenever sqlerror continue;

--------------------- BEGIN DELETE --------------------------------------
PROMPT Deleting data from the workflow schema tables

PROMPT Done Deleting data from the workflow schema tables
--------------------- END DELETE --------------------------------------


--------------------- BEGIN INSERT --------------------------------------
PROMPT Inserting data into the workflow schema tables

insert into wf_property(name, type, value) values('WF_JANITOR_TASK_DEFAULT_INTERVAL_SECONDS', 'WFJANITOR', 60);
insert into wf_property(name, type, value) values('WF_JANITOR_TASK_DEFAULT_INITIAL_WAIT_SECONDS', 'WFJANITOR', 0);
insert into wf_property(name, type, value) values('WF_JANITOR_THREAD_POOL_SIZE', 'WFJANITOR', 5);
insert into wf_property(name, type, value) values('WF_SERVER_FAILOVER_TIMEOUT_SECONDS', 'WFJANITOR', 7 * 24 * 60 * 60);
insert into wf_property(name, type, value) values('FINISHED_WF_TTL_SECONDS', 'WFJANITOR', 30 * 60);
insert into wf_property(name, type, value) values('RESTART_FAILEDOVER_WF', 'WFJANITOR', 'FALSE');
insert into wf_property(name, type, value) values('WF_PAUSE_ENABLED', 'WFJANITOR', 'FALSE');
insert into wf_property(name, type, value) values('WF_INMEMORY_DATA_IN_DAYS', 'WFJANITOR', 60);
insert into wf_property(name, type, value) values('WF_PAUSE_SERVER', 'WFJANITOR', ' ');
insert into wf_property(name, type, value) values('WF_FAILOVER_JANITOR_JOBS_ALLOWED', 'WFJANITOR', 'TRUE');

PROMPT Done Inserting data into the workflow schema tables
--------------------- END INSERT ----------------------------------------


--------------------- BEGIN UPDATE --------------------------------------
PROMPT Updating existing data in the workflow schema tables

PROMPT Done Updating existing data in the workflow schema tables
--------------------- END UPDATE --------------------------------------

whenever sqlerror exit FAILURE;

commit;
