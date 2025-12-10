Rem
Rem create_triggers.sql
Rem
Rem Copyright (c) 2017, 2024, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      create_triggers.sql - Create various triggers in ECRA DB
Rem
Rem    DESCRIPTION
Rem      This script is called by ecs/ecra/db/install_ecra_schema.sql
Rem      to complete the trigger creation and alteration during ecra
Rem      schema install or upgrade. For more details refer to 
Rem      ecs/ecra/db/install_ecra_schema.sql
Rem
Rem    NOTES
Rem      Only the trigger creation DDLs are allowed in this file.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/create_triggers.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jzandate    10/18/24 - Enh 37159566 - Adding vmbackup history
Rem    essharm     10/22/24 - Bug 37191850 Moving trigger name from
Rem                           create_tables.sql
Rem    jzandate    04/12/24 - Bug 36452908 - Changing trigger name so it wont collide with ebr file
Rem    illamas     09/11/23 - Enh 35677356 - GI support
Rem    jzandate    06/13/23 - Bug 35402924 - Adding new tables for exadata 23
Rem                           compatibility matrix
Rem    gvalderr    05/29/23 - Fixingambiguity for sshkeys trigger
Rem    gvalderr    05/12/23 - Adding trigger to sshkeys table
Rem    pverma      04/05/23 - Fix length of ecs_oci_console_connection_id_seq
Rem                           to 30
Rem    luperalt    03/06/23 - Bug 35145654 Created
Rem                           ecs_oci_console_connection_id_seq sequence
Rem    jiacpeng    11/08/22 - fix the bug of the LogUserManagementChanges
Rem                           trigger not getting created
Rem    aadavalo    10/05/22 - Enh 34394111 - Triggers for user management
Rem    mpedapro    10/04/21 - Enh::32864894 create triggers for exacc inventory
Rem                           tables
Rem    byyang      08/03/21 - bug 32932746. create ecs_update_heartbeat
Rem    llmartin    04/08/21 - Enh 32728201 - Get patch metadata list from ECRA
Rem    llmartin    12/02/20 - Enh 32133351 - Inventory release for elastic
Rem                           shapes
Rem    hcheon      11/09/20 - ER 32100233 Add ecs_diag_ignore_target_id_seq
Rem    josedelg    10/09/20 - ENH 31646088: Add exadata applied patched details 
Rem                           trigger ecs_exa_applied_patches_id_seq for 
Rem                           table ecs_exa_applied_patches
Rem    hcheon      07/04/20 - ER 31152543 Add ecs_diag_hw_nodes_chg_trg
Rem    sdeekshi    01/07/20 - Bug 31564449: CLEANUP NON USEFUL XIMAGES CODE
Rem    rgmurali    03/06/20 - XbranchMerge rgmurali_bug-30870817 from
Rem                           st_ecs_pt-x8m
Rem    jreyesm     03/02/20 - E.R 29247537. Remove exadata formation id gen
Rem    illamas     01/21/20 - Enh 30432286 - Save information about every
Rem                           request, and provide useful information
Rem    byyang      12/18/19 - ER 30637967. create logcol history table
Rem    rgmurali    03/03/20 - ER 30870817 - Fabric addition APIs
Rem    oespinos    01/14/20 - ENH 30765027 - COMPOSE CLUSTER ROCE/X8M SUPPORT
Rem    hcheon      07/28/19 - bug-30024961 Add configuration manager
Rem    llmartin    07/10/19 - Bug 29689196 - ATP Consolidate multiple Oracle
Rem                           Client VCNs
Rem    sachikuk    01/09/19 - Bug - 29196230 : DB schema for ATP pre
Rem                           provisioning scheduler
Rem    jungnlee    11/08/18 - Bug 28902534 add a trigger for ecs_diag_report
Rem    byyang      10/18/18 - Bug 28805415. Fix for repeated rack reg/dereg
Rem                           bug.
Rem    byyang      07/25/18 - ER 28356826. ExaCD support for MVM
Rem    llmartin    07/20/18 - Bug 28096666 - CPU oversubscription
Rem    sdeekshi    06/08/18 - Bug 28189332 : Add ecra ximages image management apis
Rem    jreyesm     05/17/18 - exadata_entity trigger
Rem    byyang      01/06/18 - ER 27943223. Add triggers for ecs diag phase 2
Rem    nkedlaya    12/02/17 - Enh 27209353 - SEAMLESS ECRA SCHEMA UPGRADE
Rem                           BETWEEN VERSIONS
Rem    nkedlaya    03/29/17 - bug 25802231 : ecs_racks.name column update
Rem                           returns ora-02292
Rem    nkedlaya    03/29/17 - various trigers in ECRA DB
Rem    nkedlaya    03/29/17 - Created
Rem

-- catch critical errors and continue script to avoid ECRA upgrade failure --
---Bug 36065214 - CONTINUE WITH CREATE TRIGGER SCRIPT WITH ERRORS FOR AVOIDING HARD FAILURE OF UPGRADES 
whenever sqlerror CONTINUE;

--
-- BUG 25802231: ecs_racks.name column update returns ora-02292
--
create or replace trigger ecs_racks_upd_trig
before update of name 
on ecs_racks
for each row
declare
  l_rc number;
begin
  l_rc := ecra.ecs_update_cluster_name
  ( :old.name 
  , :new.name
  );
end;
/


create or replace trigger pods_id
before insert on pods
for each row
begin
  select pod_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger services_id
before insert on services
for each row
begin
  select services_id_seq.nextval
  into :new.service_id
  from dual;
end;
/

create or replace trigger exaunit_info_id
before insert on exaunit_info
for each row
begin
  select exaunit_info_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_kvmippool_id 
before insert on ecs_kvmippool
for each row
begin
  select ecs_kvmippool_id_seq.nextval
  into :new.resource_id
  from dual;
end;
/

create or replace trigger resources_id
before insert on resources
for each row
begin
  select resources_id_seq.nextval
  into :new.db_instance_id
  from dual;
end;
/


create or replace trigger databases_id
before insert on databases
for each row
begin
  select databases_id_seq.nextval
  into :new.dbID
  from dual;
end;
/

create or replace trigger ecs_atpscheduledracks_trg
before insert on ecs_atpscheduledracks
for each row
begin
  select ecs_atpscheduledracks_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_atpjobgroups_trg
before insert on ecs_atpjobgroups
for each row
begin
  select ecs_atpjobgroups_id_seq.nextval
  into :new.job_group_id
  from dual;
end;
/

-- Put initial value of 'last_update' as some amount (i.e. 60 days here)
-- before current time.
-- This makes an added job to run immediately not waiting for the interval.
create or replace trigger ecs_scheduledjob_trg
before insert on ecs_scheduledjob
for each row
begin
  :new.id := ecs_scheduledjob_id_seq.nextval;
  :new.last_update := systimestamp - interval '60' day;
  :new.status := 'READY';
end;
/

-- need 'when (new.id is null)' to insert id 0 and -1 in seed_tables
create or replace trigger ecs_diag_problem_trg
before insert on ecs_diag_problem
for each row
when (new.id is null)
begin
  :new.id := ecs_diag_problem_id_seq.nextval;
end;
/

create or replace trigger ecs_diag_request_trg
before insert on ecs_diag_request
for each row
begin
  :new.id := ecs_diag_request_id_seq.nextval;
end;
/

create or replace trigger ecs_diag_fault_trg
before insert on ecs_diag_fault
for each row
begin
  :new.id := ecs_diag_fault_id_seq.nextval;
  :new.problem_id := 0;
end;
/

create or replace trigger ecs_diag_report_trg
before insert on ecs_diag_report
for each row
begin
  :new.id := ecs_diag_report_id_seq.nextval;
end;
/

create or replace trigger ecs_diag_logcol_hist_ins_trg
before insert on ecs_diag_logcol_history
for each row
begin
  :new.id := ecs_diag_logcol_history_id_seq.nextval;
  :new.request_ts := systimestamp;
  :new.status := 'STARTED';
end;
/

create or replace trigger ecs_diag_logcol_hist_upd_trg
before update on ecs_diag_logcol_history
for each row
begin
  :new.end_ts := systimestamp;
end;
/

create or replace trigger ecs_logcol_req_hist_ins_trg
before insert on ecs_diag_logcol_req_hist
for each row
begin
  :new.id := ecs_logcol_req_hist_id_seq.nextval;
  :new.request_ts := systimestamp;
end;
/

create or replace trigger ecs_diag_ignore_target_ins_trg
before insert on ecs_diag_ignore_target
for each row
begin
  :new.id := ecs_diag_ignore_target_id_seq.nextval;
end;
/

-- Begin: ER 28356826. ExaCD support for MVM
-- Begin: ER 28356826. ExaCD support for MVM
-- Monitor ecs_racks insert/update
create or replace trigger ecs_diag_rack_ins_upd_trg
after insert or update on ecs_racks
for each row
begin
  merge into ecs_diag_rackxml_monitor
    using dual
    on (rack_name = :new.name)
    when matched then
      update set status = 'init', action = 'ins_upd', updated = systimestamp
    when not matched then
      insert (rack_name, status, action, updated)
        values (:new.name, 'init', 'ins_upd', systimestamp);
end;
/

-- Monitor ecs_racks delete
create or replace trigger ecs_diag_rack_del_trg
before delete on ecs_racks
for each row
begin
  if :old.exadata_id is null then
    -- Non-MVM case

    -- Bug 28805415.
    -- A corner case bug
    --  Condition
    --   If reg/dereg for the same rack is done more than twice before LogScanner runs
    --  rackxml_monitor table
    --   1. register a rack
    --      <rack_name>, init, ins_upd, <ts1>
    --   2. deregister the rack
    --      <rack_name>:, init, del_non_mvm, <ts2>
    --   3. register a rack
    --      <rack_name>:, init, del_non_mvm, <ts2>
    --      <rack_name>, init, ins_upd, <ts3>
    --   4. deregister a rack
    --      <rack_name>:, init, del_non_mvm, <ts2>
    --      <rack_name>, init, ins_upd, <ts3>
    --        --> trg tries to update this row to <rack_name>: which is PK violation
    delete ecs_diag_rackxml_monitor where rack_name = :old.name || ':' || :old.exaunitid;

    update ecs_diag_rackxml_monitor rm
    set rack_name = :old.name || ':' || :old.exaunitid, status = 'init', action = 'del_non_mvm', updated = systimestamp
    where rm.rack_name = :old.name;
  else
    -- MVM case
    update ecs_diag_rackxml_monitor rm
    set status = 'init', action = 'del_mvm', updated = systimestamp
    where rm.rack_name = :old.name;
  end if;
end;
/

-- Monitor ecs_rack_slots insert/update
create or replace trigger ecs_diag_rack_slot_ins_upd_trg
after insert or update on ecs_rack_slots
for each row
begin
  merge into ecs_diag_rackxml_monitor
    using dual
    on (rack_name = :new.rack_name)
    when matched then
      update set status = 'init', action = 'ins_upd', updated = systimestamp
    when not matched then
      insert (rack_name, status, action, updated)
        values (:new.rack_name, 'init', 'ins_upd', systimestamp);
end;
/

-- Monitor ecs_rack_slots delete
create or replace trigger ecs_diag_rack_slot_del_trg
before delete on ecs_rack_slots
for each row
begin
  update ecs_diag_rackxml_monitor rm
  set status = 'init', action = 'del_mvm_rack_slot', updated = systimestamp
  where rm.rack_name = :old.rack_name;
end;
/

-- Monitor ecs_exadata insert/update
create or replace trigger ecs_diag_exadata_ins_upd_trg
after insert or update on ecs_exadata
for each row
begin
  merge into ecs_diag_rackxml_monitor
  using dual
  on (rack_name = :new.exadata_id || '-infra')
  when matched then
    update set status = 'init', action = 'ins_upd', updated = systimestamp
  when not matched then
    insert (rack_name, status, action, updated)
      values(:new.exadata_id || '-infra', 'init', 'ins_upd', systimestamp);
end;
/

-- Monitor ecs_exadata delete
create or replace trigger ecs_diag_exadata_del_trg
before delete on ecs_exadata
for each row
begin
  update ecs_diag_rackxml_monitor rm
  set status = 'init', action = 'del_exadata', updated = systimestamp
  where rm.rack_name = :old.exadata_id || '-infra';
end;
/
-- End: ER 28356826. ExaCD support for MVM

-- Monitor ecs_hw_nodes changes
create or replace trigger ecs_diag_hw_nodes_chg_trg
after insert or update or delete on ecs_hw_nodes
for each row
begin
  merge into ecs_diag_rackxml_monitor
  using dual
  on (rack_name = 'hw_nodes')
  when matched then
    update set status = 'init', action = 'chg', updated = systimestamp
  when not matched then
    insert (rack_name, status, action, updated)
      values('hw_nodes', 'init', 'chg', systimestamp);
end;
/

CREATE OR REPLACE TRIGGER LogUserManagementChanges
  BEFORE INSERT
        OR UPDATE
        OR DELETE
    ON ECS_USERS
    FOR EACH ROW
      DECLARE
        this_action  varchar2(10);
        created_by  varchar2(30);
        modified_by  varchar2(30);
        created_at  timestamp;
        updated_at  timestamp;
        deleted_at  timestamp;
    BEGIN
       IF INSERTING
          THEN
            this_action := 'CREATE';
            created_at := systimestamp;
            created_by  := USER;
       END IF;
       IF UPDATING
          THEN
            this_action := 'UPDATE';
            updated_at := systimestamp;
            modified_by  := USER;
       END IF;
       IF DELETING
          THEN
            this_action := 'DELETE';
            deleted_at := systimestamp;
        END IF;
		IF INSERTING OR UPDATING
		  THEN
	        INSERT
	          INTO ECS_USERS_HISTORY(
	            id,
	            first_name,
	            last_name,
	            user_id,
	            password,
	            active,
	            role_id,
	            action,
	            created_by,
	            modified_by,
	            created_at,
	            deleted_at,
	            updated_at
	          )
	          VALUES(
	            :NEW.id,
	            :NEW.first_name,
	            :NEW.last_name,
	            :NEW.user_id,
	            :NEW.password,
	            :NEW.active,
	            :NEW.role_id,
	            this_action,
	            created_by,
	            modified_by,
	            created_at,
	            deleted_at,
	            updated_at
	          );
        END IF;
        IF DELETING
		  THEN
	        INSERT
	          INTO ECS_USERS_HISTORY(
	            id,
	            first_name,
	            last_name,
	            user_id,
	            password,
	            active,
	            role_id,
	            action,
	            created_by,
	            modified_by,
	            created_at,
	            deleted_at,
	            updated_at
	          )
	          VALUES(
	            :OLD.id,
	            :OLD.first_name,
	            :OLD.last_name,
	            :OLD.user_id,
	            :OLD.password,
	            :OLD.active,
	            :OLD.role_id,
	            this_action,
	            created_by,
	            modified_by,
	            created_at,
	            deleted_at,
	            updated_at
	          );
	     END IF;
    END;
/

create or replace trigger ecs_hw_cabinets_id
before insert on ecs_hw_cabinets
for each row
begin
  :new.id := ecs_hw_cabinets_seq_id.nextval;
end;
/

create or replace trigger ecs_ib_fabrics_id
before insert on ecs_ib_fabrics
for each row
begin
  if :new.id is null then
    :new.id := ecs_ib_fabrics_seq_id.nextval;
  end if;
end;
/

create or replace trigger ecs_hw_nodes_id
before insert on ecs_hw_nodes
for each row
begin
  :new.id := ecs_hw_nodes_seq_id.nextval;
end;
/

create or replace trigger ecs_cos_pool_seq
before insert on ecs_cos_pool 
for each row
begin
  select ecs_cos_pool_seq.nextval
  into :new.pool_id
  from dual;
end;
/

create or replace trigger user_auth_id
before insert on user_auth
for each row
begin
  select user_auth_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecra_info_id
before insert on ecra_info
for each row
begin
  select ecra_info_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecra_clobs_id
before insert on ecra_clobs
for each row
begin
  select ecra_clobs_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_atpclient_vcn_seq
before insert on ECS_ATPCLIENT_VCN
for each row
begin
  select ecs_atpclient_vcn_seq.nextval
  into :new.vcn_index
  from dual;
end;
/

create or replace trigger cm_host_config_id_seq
before insert on ecs_compliance_cm_host_config
for each row
begin
  :new.id := cm_host_config_id_seq.nextval;
end;
/

create or replace trigger cm_change_log_id_seq
before insert on ecs_compliance_cm_change_log
for each row
begin
  :new.id := cm_change_log_id_seq.nextval;
end;
/

create or replace trigger ecs_analytics_id_seq
before insert on ECS_ANALYTICS
for each row
begin
  select ecs_analytics_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_exa_applied_patches_id_seq
before insert on ecs_exa_applied_patches
for each row
begin
  select ecs_exa_applied_patches_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger exadata_capacity_res_order_id
before insert on ECS_EXADATA_CAPACITY
for each row
begin
  select exadata_capacity_res_order_seq.nextval
  into :new.reserved_order
  from dual;
end;
/

create or replace trigger mdbcs_patching_start_time
before insert on ECS_MDBCS_PATCHING
for each row
begin
  :new.start_time := systimestamp;
  :new.last_update := systimestamp;
end;
/

create or replace trigger mdbcs_patching_last_update
before update on ECS_MDBCS_PATCHING
for each row
begin
  :new.last_update := systimestamp;
end;
/

create or replace trigger ecs_ecra_heartbeat_trg
before insert on ecs_ecra_heartbeat
for each row
begin
  :new.id := ecs_ecra_heartbeat_id_seq.nextval;
end;
/

create or replace trigger exacc_cpstuner_patches_id_seq
before insert on exacc_cpstuner_patches
for each row
begin
  select exacc_cpstuner_patches_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger exacc_availimages_info_id_seq
before insert on exacc_availimages_info
for each row
begin
  select exacc_availimages_info_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger exacc_sw_versions_id_seq
before insert on exacc_sw_versions
for each row
begin
  select exacc_sw_versions_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger exacc_nodeimg_versions_id_seq
before insert on exacc_nodeimg_versions
for each row
begin
  select exacc_nodeimg_versions_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger exacc_nodemisc_info_id_seq
before insert on exacc_nodemisc_info
for each row
begin
  select exacc_nodemisc_info_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger exacc_exaksplice_info_id_seq
before insert on exacc_exaksplice_info
for each row
begin
  select exacc_exaksplice_info_id_seq.nextval
  into :new.id
 from dual;
end;
/

create or replace trigger ecs_users_id_seq
before insert on ecs_users
for each row
begin
  select ecs_users_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_users_history_id_seq
before insert on ecs_users_history
for each row
begin
  select ecs_users_history_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_users_locks_id_seq
before insert on ecs_users_locks
for each row
begin
  select ecs_users_locks_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_password_resets_id_seq
before insert on ecs_password_resets
for each row
begin
  select ecs_password_resets_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger ecs_oci_console_conn_id_seq
before insert on ecs_oci_console_connection
for each row
begin
  select ecs_oci_console_conn_id_seq.nextval
  into :new.id
  from dual;
end;
/

create or replace trigger sshkeys_id_seq
after insert on sshkeys
for each row
begin
  NULL;
end;
/

create or replace trigger sshkeys_id
before insert on sshkeys
for each row
begin
  :new.sshid := sshkeys_seq_id.nextval;
end;
/

CREATE OR REPLACE TRIGGER ECS_EXA_VERS_MATRIX_ID
BEFORE INSERT ON ECS_EXA_VER_MATRIX
FOR EACH ROW
BEGIN
        :NEW.id := ECS_EXA_VER_MAT_SEQ_ID.nextval;
END;
/

CREATE OR REPLACE TRIGGER lse_id_trg
BEFORE INSERT ON ecs_lse_log
FOR EACH ROW
BEGIN
  SELECT lse_id_seq.NEXTVAL
  INTO :new.lse_id
  FROM DUAL;
END;
/


create or replace trigger ecs_vmbackuphistory_updated_at
before update on ECS_VMBACKUPHISTORY
for each row
begin
  :new.UPDATED_AT := systimestamp;
end;
/

show errors;

whenever sqlerror continue;
