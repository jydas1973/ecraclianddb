Rem
Rem $Header: ecs/ecra/db/alter_wf_tables.sql /main/7 2024/05/13 16:18:52 llmartin Exp $
Rem
Rem alter_wf_tables.sql
Rem
Rem Copyright (c) 2019, 2024, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      alter_wf_tables.sql
Rem
Rem    DESCRIPTION
Rem      All modifications to existing workflow schema tables, indexes and sequences
Rem      should be done through this script.
Rem
Rem    NOTES
Rem      Following are big NO NO in this file
Rem      1. No DDL should start with CREATE.
Rem      2. No DDLs other than ALTER TABLE or ALTER INDEX allowed.
Rem      3. No DDL should start with DROP.
Rem      4. No DMLs like INSERT, DELETE, UPDATE are allowed.
Rem
Rem      Following things are allowed
Rem      1. alter table/index add
Rem      2. alter table/index drop
Rem      3. alter table/index modify
Rem      4. alter table/index rename
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: exacom/commons-workflow-infra/src/main/db/alter_wf_tables.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    llmartin    04/10/24 - Enh 36340464 - Active-active, ip rules for
Rem                           multiple ECRAs
Rem    kukrakes    01/22/24 - Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA
Rem                           OPERATIONS FAILING POST PARTITIONING AND
Rem                           ARCHIVING OF TABLES
Rem    kukrakes    12/06/23 - Enh 36070977 - ECRA APPLICATION CHANGES TO
Rem                           IMPLEMENT PARTITIONING IN ECRA SCHEMA
Rem    piyushsi    12/17/20 - BUG 31889623 - Version column in wf_state_machine to support wfVersioning
Rem    panmishr    04/30/20 - BUG 31233099 - ROLLING UPGRADE:ECS 20.1.1:ON
Rem                           GOING EXACS PROVISIONING FAILING POST ROLLING
Rem                           UPGRADE AT ESTP_CREATE_VM
Rem    panmishr    09/05/19 - Integrate worklfow infra with janitor.
Rem    aabharti    08/05/19 - Created
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

PROMPT Altering table wf_state_machine, adding column server_name
alter table wf_state_machine add server_name varchar2(256);

PROMPT Altering table wf_task, adding column operation_id
alter table wf_task add operation_id varchar2(2048);

PROMPT Altering table wf_task, adding column run_mode
alter table wf_task add run_mode varchar2(256) default 'regular';

PROMPT Altering table wf_state_machine, adding column version
alter table wf_state_machine add version varchar2(256) default 'v1';

PROMPT Altering table wf_server, adding subnet_cidr
ALTER TABLE WF_SERVER ADD SUBNET_CIDR VARCHAR2(64);

-- Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA OPERATIONS FAILING POST PARTITIONING AND ARCHIVING OF TABLES
ALTER TABLE WF_TASK_STATE_MACHINE ADD START_TIME_TS TIMESTAMP(6);
ALTER TABLE WF_STATE_MACHINE ADD START_TIME_TS TIMESTAMP(6);
ALTER TABLE WF_TASK ADD START_TIME_TS TIMESTAMP(6);
ALTER TABLE WF_TASK_OPERATION ADD START_TIME_TS TIMESTAMP(6);
ALTER TABLE WF_TRAVERSAL ADD START_TIME_TS TIMESTAMP(6);
ALTER TABLE WF_ACTIVE_TASK_SM_MAPPING ADD START_TIME_TS TIMESTAMP(6);

whenever sqlerror exit FAILURE;
