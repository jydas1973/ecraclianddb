Rem
Rem create_wf_tables.sql
Rem
Rem Copyright (c) 2015, 2022, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      create_wf_tables.sql
Rem
Rem    DESCRIPTION
Rem      Creates all the workflow schema tables, indexes and sequences.
Rem
Rem    NOTES
Rem      Following are allowed in this file
Rem      1. CREATE TABLE
Rem      2. CREATE INDEX
Rem      3. CREATE SEQUENCE
Rem
Rem      Following are big NO NO in this file
Rem      1. DMLs like INSERT, UPDATE and DELETE
Rem      2. DDLs like ALTER TABLE, ALTER INDEX, DROP TABLE, DROP INDEX
Rem      3. DDLs like CREATE TRIGGER, DROP SEQUENCE
Rem      4. Transaction management statements COMMIT
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: exacom/commons-workflow-infra/src/main/db/create_wf_tables.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aadavalo    05/23/22 - Enh 34152630 - STORE IN THE DB THE HOSTNAMES OR
Rem                           IPS OF THE ECRA VMS
Rem    panmishr    04/30/20 - BUG 31233099 - ROLLING UPGRADE:ECS 20.1.1:ON
Rem                           GOING EXACS PROVISIONING FAILING POST ROLLING
Rem                           UPGRADE AT ESTP_CREATE_VM
Rem    panmishr    09/05/19 - Integrate workflow infra with janitor
Rem    aabharti    08/20/19 - Bug 30157612 - Added task operation table
Rem    sachikuk    07/09/19 - Bug 30010849 : Introduce notion of workflow
Rem                           ownership in workflow infra
Rem    aabharti    05/05/19 - Bug 30028800 - Added table for task operations
Rem    sachikuk    03/28/19 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Don't exit on already existing table errors
whenever sqlerror continue;

PROMPT Creating table wf_server
create table wf_server (
    name                     varchar2(256),
    status                   varchar2(256) not null,
    last_heartbeat_update    timestamp not null,
    hostname                 varchar2(128),
    constraint pk_wf_server primary key(name)
);

PROMPT Creating table wf_property
create table wf_property (
    name                varchar2(256) not null,
    type                varchar2(256) not null,
    value               varchar2(2048) not null,
    constraint pk_wf_property primary key(name, type)
);

PROMPT Creating table wf_state_machine
create table wf_state_machine (
    wf_uuid             varchar2(2048),
    wf_name             varchar2(2048) not null,
    request_payload     clob not null,
    current_state       varchar2(256) not null,
    server_name         varchar2(256),
    start_time          timestamp,
    end_time            timestamp,
    constraint pk_wf_state_machine 
        primary key(wf_uuid)
);

PROMPT Creating table wf_task_state_machine
create table wf_task_state_machine (
    task_group_id       varchar2(2048),
    wf_uuid             varchar2(2048),
    node_name           varchar2(2048) not null,
    current_state       varchar2(256) not null,
    input               clob not null,
    start_time          timestamp,
    end_time            timestamp,
    constraint pk_wf_task_state_machine
        primary key(task_group_id),
    constraint fk_wf_task_state_machine
        foreign key(wf_uuid)
        references wf_state_machine(wf_uuid)
        ON DELETE CASCADE
);

PROMPT Creating table wf_active_task_sm_mapping
create table wf_active_task_sm_mapping (
    wf_uuid             varchar2(2048),
    task_group_id       varchar2(2048),
    constraint pk_wf_active_task_sm_mapping
        primary key(wf_uuid),
    constraint fk_wf_uuid_tsm_mapping
        foreign key(wf_uuid)
        references wf_state_machine(wf_uuid)
        ON DELETE CASCADE,
    constraint fk_task_group_id_tsm_mapping
        foreign key(task_group_id)
        references wf_task_state_machine(task_group_id)
        ON DELETE CASCADE
);

PROMPT Creating table wf_task
create table wf_task (
    task_group_id       varchar2(2048),
    task_name           varchar2(2048) not null,
    wf_uuid             varchar2(2048),
    operation_id        varchar2(2048),
    current_state       varchar2(256) not null,
    output              clob,
    start_time          timestamp,
    end_time            timestamp,
    run_mode            varchar2(256) not null,
    constraint pk_wf_task
        primary key(task_group_id, task_name),
    constraint fk_wf_uuid_wf_task
        foreign key(wf_uuid)
        references wf_state_machine(wf_uuid)
        ON DELETE CASCADE,
    constraint fk_task_group_id_wf_task
        foreign key(task_group_id)
        references wf_task_state_machine(task_group_id)
        ON DELETE CASCADE
);

PROMPT Creating table wf_traversal
create table wf_traversal (
    wf_uuid             varchar2(2048),
    seq_no              number not null,
    path_element        varchar2(2048) not null,
    element_type        varchar2(256) not null,
    task_group_id       varchar2(2048),
    constraint pk_wf_traversal
        primary key(wf_uuid, seq_no),
    constraint fk_wf_traversal
        foreign key(wf_uuid)
        references wf_state_machine(wf_uuid)
        ON DELETE CASCADE
);

PROMPT Creating table wf_state_machine_error
create table wf_state_machine_error (
    wf_uuid             varchar2(2048),
    error               clob not null,
    constraint fk_wf_state_machine_error
        foreign key(wf_uuid)
        references wf_state_machine(wf_uuid)
        ON DELETE CASCADE
);

PROMPT Creating table wf_task_sm_error
create table wf_task_sm_error (
    task_group_id       varchar2(2048),
    error               clob not null,
    constraint fk_task_sm_error
        foreign key(task_group_id)
        references wf_task_state_machine(task_group_id)
        ON DELETE CASCADE
);

PROMPT Creating table wf_task_operation
create table wf_task_operation (
    task_group_id       varchar2(2048),
    task_name           varchar2(2048) not null,
    operation_id        varchar2(2048) not null,
    sequence_no         number not null,
    wf_uuid             varchar2(2048),
    operation_name      varchar2(2048) not null,
    operation_current_state       varchar2(256) not null,
    start_time          timestamp,
    end_time            timestamp,
    constraint pk_wf_task_operation
        primary key(operation_id),
    constraint fk_wf_task_operation
        foreign key(task_group_id, task_name)
        references wf_task(task_group_id, task_name)
        ON DELETE CASCADE
);

whenever sqlerror exit FAILURE;
