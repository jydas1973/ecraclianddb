Rem $Header: ecs/ecra/db/upgrade_schema.sql /main/181 2025/12/04 15:57:39 luperalt Exp $
Rem
Rem upgrade_schema.sql
Rem
Rem Copyright (c) 2024, 2025, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      upgrade_schema.sql - New SQL file for schema changes
Rem
Rem    DESCRIPTION
Rem      SQL file containing a set of commands to modify the structure of a database,
Rem      including creating, altering, or dropping tables, columns, indexes, and other database objects
Rem
Rem    NOTES
Rem      upgrade_schema.sql is the flat SQL file that uses markers to separate different SQL changes.
Rem      These markers are --[[.*_START]]-- and --[[.*_END]]--. Any SQL code between these markers is considered a section.
Rem         Example:
Rem                --[[dtalla_bug_321111898_START]]--
Rem                CREATE TABLE X (ID NUMBER, DESCRIPTION VARCHAR2(10));
Rem                ALTER TABLE Y ADD COLUMN_N VARCHAR2(100);
Rem                --[[dtalla_bug_321111898_END]]--
Rem      schema upgrade module (upgrade_schema.py) applies these sections to the ECRA schema,
Rem      and records the changes in the VERSION_CONTROL_TABLE.If a section has already been applied, it is skipped.
Rem      Place your SQL statements ordered by SQL type (DDL, DML, DCL, TCL).
Rem      DDL (Data Definition Language): CREATE, ALTER, DROP, TRUNCATE, RENAME
Rem      DML (Data Manipulation Language): SELECT, INSERT, UPDATE, DELETE
Rem      DCL (Data Control Language): GRANT, REVOKE
Rem      TCL (Transaction Control Language): COMMIT, ROLLBACK, SAVEPOINT, SET TRANSACTION
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade_schema.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    luperalt    12/02/25 - Bug 38716755 - Reverted property name from
Rem                           EXACS_VM_HISTORY_CONSOLE to
Rem                           CONSOLE_HISTORY_OSS_BUCKETNAME
Rem    pvachhan    11/10/25 - Enh 38235079 - ECRA API AND DB CHANGES FOR
Rem                           CREATE SERVICE FLOW WITH SRIOV - EXACS
Rem    zpallare    11/28/25 - Enh 38391344 - EXACS ECRA - ENCHANCE INVENTORY
Rem                           RELEASE API TO KEEP NODE IN HW_FAIL STATE
Rem    abysebas    11/28/25 - Enh 38299782 - PHASE 1: FREE NODE POWER SAVING -
Rem                           HEALTH CHECK
Rem    hcheon      11/27/25 - 37891253 Fixed diagnostic.cfg LJ output
Rem    jyotdas     11/27/25 - Bug 38689885: clear
Rem                           ELU_IMAGESERIES_TO_DEPTH_MAPPING property
Rem    jyotdas     11/26/25 - Bug 38689885 - Remove
Rem                           elu_imageseries_to_depth_mapping
Rem    pverma      11/26/25 - BUG 38695963 - Fix unique constraint issue
Rem    luperalt    11/26/25 - Bug 38690474 - Increased timeout for
Rem                           FleetXsVaultDetailsSyncJob
Rem    gvalderr    11/18/25 - Bug 38629977 - Changing column of ecs_hw_nodes to
Rem                           clob
Rem    pverma      11/19/25 - BUG 38634942 - Add tasks for exascale attach cell
Rem                           WFs for progress updates
Rem    pverma      11/19/25 - BUG 38653118 - Add missing tasks of attach cell
Rem                           WFs
Rem    gvalderr    11/18/25 - Bug 38629977 - Changing column of ecs_hw_nodes to
Rem                           clob
Rem    bshenoy     11/03/25 - ER 38598427: Add suffix to clustertag & use the
Rem                           same during provisioning
Rem    abysebas    11/11/25 - Enh 38299778 - PHASE 1: FREE NODE POWER SAVING -
Rem                           CREATE/MODIFY SCHEDULE JOBS
Rem    ritikhan    11/11/25 - Enh 38137883 - FETCH STRE0 AND STRE1 IPS FROM
Rem                           EXACLOUD FOR ADD NODE OPERATION
Rem    piyushsi    11/05/25 - BUG 38485269 Live migration support for domu
Rem                           search api
Rem    sdevasek    11/07/25 - Bug 38626762 - MODIFY SCRIPT_PATH_NAME COLUMN IN 
Rem                           ECS_REGISTERED_INFRAPATCH_PLUGINS_TABLE TO ALLOW
Rem                           NULL VALUES
Rem    piyushsi    11/07/25 - BUG 38612102 ECRA FILES DATA Cleanup Interval
Rem                           CHange
Rem    kukrakes    11/04/25 - Bug 38538341 - OCI: DDL CHANGES ON PARTITION
Rem                           TABLES NOT UPDATED ON ITS STAGE,ARCHIVAL TABLES
Rem                           LEADING TO ORA-14097,ORA-14096 ERRORS ON ARCHIVAL
Rem                           OF PARTITIONS
Rem    gvalderr    10/28/25 - Enh 38588973 - Adding correction to exacompute
Rem                           golden gate filesystem template
Rem    bshenoy     10/23/25 - Bug 38571124: update x8m qfabs prop to ENABLEd if
Rem                           null
Rem    gvalderr    10/21/25 - Enh 38540951 - Adding non mutable mountpoins for
Rem                           exacompute template
Rem    atgandhi    10/24/25 - Enh 38459507 - LOG BASED SLA COLLECTION AND STORE
Rem                           DOWNTIMES IN DB
Rem    atgandhi    10/16/25 - Enh 38421350 - UPDATE PROVISIONING WORKFLOW WITH
Rem                           FETCH VOTING DISKS
Rem    kukrakes    10/16/25 - Bug 38529219 - OCI: WORKFLOWS FREQUENTLY STUCK IN
Rem                           PHX REGION - MULTIPLE SWITCH OVER DONE
Rem    ritikhan    10/14/25 - Enh 38508944 - ECRA : PROVIDE ENDPOINT TO
Rem                           START/STOP SYSLENS ON FLEET / LIST OF DOM0S
Rem    zpallare    10/13/25 - Enh 38443483 - EXADBXS - Create new rack reserve
Rem                           api for exadbxs/basedb flows
Rem    sdevasek    10/09/25 - Enh 38437139 - ECRA REGISTERED PLUGINS:IMPLEMENT
Rem                           VALIDATION OF CHECKSUM OF THE SCRIPT WITH 
Rem                           CHECKSUM VALUE PRESENT IN THE METADATA
Rem    oespinos    10/09/25 - Bug 38523603 - Delete ecs_infrapwd_audit when
Rem                           deleting ecs_oci_exa_info record
Rem    zpallare    10/02/25 - Enh 38443495 - EXADBXS - Update exacompute rack
Rem                           ports api to return admin information
Rem    zpallare    09/30/25 - Enh 37909653 - EXACS: Provisioning stuck in
Rem                           prevmchecks, ecra to add a precheck earlier in
Rem                           the flow
Rem    abyayada    09/30/25 - 38484573 - VLANID SIZE IN ECRADB SHOULD BE
Rem                           INCREASED
Rem    abyayada    09/30/25 - 38484573 - VLANID SIZE IN ECRADB SHOULD BE
Rem    kukrakes    09/26/25 - Enh 37558564 - ENABLE USER PRINCIPAL, INSTANCE
Rem                           PRINCIPAL AND SERVICE PRINCIPAL FOR
Rem                           AUTHENTICATION. REMOVE USER NAME AND PASSWORD
Rem                           BASED VALIDATION FROM ECRA.
Rem    oespinos    09/26/25 - Bug 38220438 - Mark Cells to Delete
Rem    jyotdas     09/25/25 - Enh 38467237 - ELU - Need option to register
Rem                           imageseries for all major versions like 25.1 and
Rem                           25.2
Rem    jiacpeng    09/17/25 - exacs-159317: add topology pagination
Rem    abysebas    09/16/25 - BUG 38113984 - OCI: EXACS:: CPU SCALE STUCK -
Rem                           LASTTASKLASTOPERATION NULL
Rem    bshenoy     09/19/25 - Add new resource for grid patching
Rem    aypaul      09/09/25 - ER#38190216 Add new property SELINUX_STATUS and
Rem                           backfill sql metadata
Rem    luperalt    08/29/25 - Bug 38347020 - Added sar_json to ecs_oci_exa_info
Rem    zpallare    09/04/25 - Bug 38390977 - OCI: dwcs dev :failed to complete
Rem                           infra patching operation. ecra reported error:
Rem                           adbs vault id not found in property
Rem                           [adbs_vault_id]
Rem    ritikhan    09/02/25 - Enh 38035450 - EXASCALE: ECRA TO INCLUDE ACFS
Rem                           FILE SYSTEM SIZE IN THE SYNCH CALL
Rem    caborbon    08/29/25 - ENH 38372390 - Adding new field to store in
Rem                           cabinet information if this is flex elastic rack
Rem    jvaldovi    07/31/25 - Bug 38175493 - Exacs:25.2.2.1:Tc2:Add Vm Failing
Rem                           At Cell_Connectivity Step:Exacloud : Base Domu
Rem                           Has Fs Encryption Enabled But The 'fs_Encryption'
Rem                           Flag Is Missing In The Payload
Rem    luperalt    07/15/25 - Bug 37980254 - Added xsBackupRetentionNum field
Rem                           to ecs_exaunitdetails
Rem    abysebas    04/02/25 - Enh 37765661 - PHASE 1: FREE NODE POWER SAVING -
Rem                           ECRA DB TABLES AND GET APIS
Rem    jreyesm     08/22/25 - E.R 38347884. EXACOMPUTE_MAX_ALLOWED_SLOTS
Rem                           property.
Rem    abyayada    08/21/25 - 37692082 - create service changes XS phase 2
Rem    jreyesm     08/22/25 - E.R 38347884. EXACOMPUTE_MAX_ALLOWED_SLOTS
Rem                           property.
Rem    jzandate    08/21/25 - Bug 38342591 - Fix order issue for goldspecs
Rem                           insert
Rem    abyayada    08/21/25 - 37692082 - create service changes XS phase 2
Rem    jvaldovi    07/31/25 - Bug 38175493 - Exacs:25.2.2.1:Tc2:Add Vm Failing
Rem                           At Cell_Connectivity Step:Exacloud : Base Domu
Rem                           Has Fs Encryption Enabled But The 'fs_Encryption'
Rem                           Flag Is Missing In The Payload
Rem    abysebas    04/02/25 - Enh 37765661 - PHASE 1: FREE NODE POWER SAVING -
Rem                           ECRA DB TABLES AND GET APIS
Rem    jvaldovi    07/31/25 - Bug 38175493 - Exacs:25.2.2.1:Tc2:Add Vm Failing
Rem                           At Cell_Connectivity Step:Exacloud : Base Domu
Rem                           Has Fs Encryption Enabled But The 'fs_Encryption'
Rem                           Flag Is Missing In The Payload
Rem    abysebas    04/02/25 - Enh 37765661 - PHASE 1: FREE NODE POWER SAVING -
Rem                           ECRA DB TABLES AND GET APIS
Rem    jreyesm     08/22/25 - E.R 38347884. EXACOMPUTE_MAX_ALLOWED_SLOTS
Rem                           property.
Rem    abyayada    08/21/25 - 37692082 - create service changes XS phase 2
Rem    kanmanic    08/25/25 - Add requestid to Analytics
Rem    jiacpeng    08/18/25 - EXACS-158502: Add Topology Heap Safety Property
Rem    jzandate    08/15/25 - Bug 39208112 - Updating exacompute template for
Rem                           GGS update/insert statements
Rem    pverma      08/01/25 - JIRA EXACS-156569 - Make retry count a number in
Rem                           ECS_ERROR_TABLE
Rem    zpallare    08/13/25 - Enh 36651275 - Increase number of subnets on mvm
Rem                           flat file
Rem    bshenoy     08/13/25 - Bug 38171776: Fix alter table issue with roce
Rem                           fabric
Rem    essharm     08/20/25 - Bug 37249099 - FEDRAMP ENHANCEMENT: ECRA TO HAVE
Rem                           MECHANISM TO ROTATE ITS LISTENER CERTIFICATE
Rem    zpallare    07/30/25 - Enh 38205599 - Update create service flow for cs
Rem                           to handle custom data/reco/sparse allocation
Rem    araghave    07/29/25 - Enh 38114577 - PROVIDE A MECHANISM THROUGH
Rem                           ECRACLI TO UPDATE PATCHSWITCHTYPE OPTIONS TO
Rem                           PATCH SWITCHES
Rem    rgmurali    07/28/25 - Bug 38237159 - Add VFs to ecs_hardware_table
Rem    pverma      07/24/25 - BUG 38231970 - Address length issue with
Rem                           USER_STEP_NAME in WF_TASKS_USER_MESSAGES_TABLE
Rem                           and clean up redundant SQLs
Rem    luperalt    07/21/25 - Bug 38173167 - Added property to rotate dbcs
Rem                           agent user passswords
Rem    pverma      07/17/25 - BUG 38202766 : Add task weights for remaining
Rem                           WFs. Add user msgs for all WFs
Rem    jzandate    07/17/25 - Enh 38195488 - Adding lock for exacompute volume
Rem                           operations
Rem    pverma      07/17/25 - Bug 38200926 : Set RESERVE_TYPE to default value
Rem                           if NULL in ecs_exaservice_reserved_alloc
Rem    abysebas    07/15/25 - Bug 38190953 - UPGRADE FAILURE DUE TO INCORRECT
Rem    rothakk     07/14/25 - 37901200 - UPDATE ECRA PROPERTY
Rem                           CONSOLE_HISTORY_OSS_BUCKETNAME TO DEFAULT
Rem                           EXACS_VM_HISTORY_CONSOLE IN EXACS to set it by
Rem                           default
Rem    illamas     07/10/25 - Enh 38173065 - SW volume for basedb
Rem    abyayada    07/10/25 - 38137943 - Modify async_calls target_uri size
Rem    bshenoy     07/15/25 - Bug 38173717: Correct Default values for Abs
Rem                           Threshold reservation
Rem    pverma      07/09/25 - BUG 38171600: Add _table suffix for
Rem                           wf_tasks_weights
Rem    pverma      07/09/25 - BUG 38135459 - Resize jsonpayload column of
Rem                           ecs_scheduled_ondemand_exec
Rem    luperalt    07/04/25 - Bug 38115115 - Added delete on cascade constraint
Rem                           to ecs_oci_console_connection_table
Rem    illamas     07/04/25 - Enh 38059350 - goldengate template
Rem    pverma      07/01/25 - BUG 38049105 : Add column 'operation' to table
Rem                           WF_TASKS_WEIGHTS
Rem    jvaldovi    06/19/25 - Enh 37985641 - Exacs Ecra - Ecra To Configure
Rem                           Dbaas Tools Name Rpm Basd On Cloud Vendor
Rem    bshenoy     07/04/25 - Bug 38120064: Whitelist qfab enable prop
Rem    delall      07/02/25 - Updating the view and table for state_store to
Rem                           add time_created as an optional field
Rem    pverma      07/01/25 - BUG 38049105 : Add column 'operation' to table
Rem                           WF_TASKS_WEIGHTS
Rem    hcheon      07/01/25 - 38098570 New flags for log/metric collection
Rem    zpallare    06/30/25 - Bug 38126851 - ECRA add property to control 
Rem                           passing sitegroup details to exacloud
Rem    mpedapro    06/20/25 - Enh::38097735 create index on inventory tables to
Rem                           improve query performance
Rem    luperalt    06/18/25 - Bug 38026082 added IP to
Rem                           ecs_oci_console_connection table
Rem    jzandate    06/19/25 - Enh 37990006 - Expanding storage column for
Rem    luperalt    06/18/25 - Bug 38026082 added IP to
Rem                           ecs_oci_console_connection table
Rem    delall      06/12/25 - Adding time_created in chaine state-store table
Rem    illamas     06/12/25 - Enh 38029834 - Template changes basedb
Rem    jyotdas     06/11/25 - Enh 37912226 - Identify proper targetversion for
Rem                           elu in exacs infrapatching
Rem    ritikhan    06/10/25 - Enh 38051606 - ADD ACFS_REFERENCE_ID TO ACFS
Rem                           TABLE
Rem    pverma      06/09/25 - BUG 38040253 - Fix issue with inserts into
Rem                           WF_TASKS_USER_MESSAGES
Rem    pverma      06/06/25 - Bug 38041206 - Add missing '-' to address syntax
Rem                           issue
Rem    pverma      04/01/25 - Seed records for few WF weights
Rem    caborbon    05/30/25 - BUG 38005893 - Adding WA to use cell scale up
Rem                           option when using X10M-2L and XL
Rem    ritikhan    05/30/25 - Bug 38015209 - TYPO FOR PRIMARY KEY IN ECS_ACFS_TABLE
Rem    sdevasek    05/28/25 - Enh 37677954 - NUMBER OF PATCHMGR SESSIONS ON A 
Rem                           LAUNCH NODE SHOULD BE CONFIGURABLE
Rem    pverma      05/21/25 - BUG 37876735 - Change PK for
Rem                           ECS_EXASERVICE_RESERVED_ALLOC_TABLE
Rem    luperalt    05/28/25 - Bug 38006666 Reverted txn 37990270
Rem    luperalt    05/23/25 - Bug 37990270 - Added X11M-EF cell model
Rem    ritikhan    05/22/25 - Enh 37976142 - ACFS lifecycle management changes
Rem    gvalderr    05/22/25 - Enh 37957373 - Changing the value for
Rem                           /var/log/audit for exacsexacompute template
Rem    abyayada    05/21/25 - Enh 37976144 - ECRA DB CHANGES FOR EXASCALE PHASE 2
Rem    zpallare    05/20/25 - Enh 37917049 - EXACS ECRA - Add
Rem                           concurrent_operation flag for all payloads when
Rem                           we want a concurrent operation
Rem    gvalderr    05/15/25 - Enh 34750083 - Adding column to ecs_domukeysinfo
Rem                           table for key generation endpoint
Rem    sdevasek    05/14/25 - Enh 37839098-ECRA CHANGES TO TRACK PATCHING 
Rem                           SESSIONS ON THE LAUNCH NODE
Rem    illamas     05/15/25 - Bug 37724767 - Fix duplication nathostnames
Rem                           active/active
Rem    zpallare    05/05/25 - Enh 37864848 - EXACS: ADBS: Key exchange api
Rem                           support : ecra support
Rem    jzandate    05/05/25 - Enh 37647220 - Adding code for tenant level filter for
Rem                           vmboss
Rem    rgmurali    04/30/25 - Enh 37837172 - Change the range for extended clusterid
Rem    caborbon    04/30/25 - ENH 37799591 - Adding property
Rem                           LIMIT_PER_CABINET_EXTRALARGE_X11M as old query
Rem                           did not work
Rem    antamil     04/24/25 - Enh 37333331 - ECRA DB CHANGE FOR MULTIPLE LAUNCH
Rem                           NODE SUPPORT
Rem    illamas     02/18/25 - Enh 37598057 - BaseDB support
Rem    kukrakes    04/22/25 - Bug 37855310 - NEED PAYLOAD CHANGES FOR
Rem                           XS_VOL_ATTACH, XS_VOL_DETTACH, XS_VOL_RESIZE FOR
Rem                           19C PROVISIONED CLUSTER
Rem    zpallare    04/22/25 - Enh 37811586 - EXACC EF - Add yaml and support
Rem                           change for ef during infra creation and scale up
Rem    nitishgu    04/17/25 - bug 37822390 : ECRA ROLLING
Rem                           UPGRADE:'EXTENDED_CLUSTER_ID' PROPERTY CHANGED
Rem                           AFTER UPGRADE
Rem    kukrakes    04/16/25 - Bug 37836265 - EXADB-XS ECRA: INCREASE COLUMN
Rem                           SIZE FOR VOLUME_NAME IN ECS_VOLUMES TABLE
Rem    jzandate    04/14/25 - Enh 37811733 - Adding Dbaas for exadbxs
Rem    zpallare    04/09/25 - Enh 37806655 - Add new x11m subtype hc-z
Rem    zpallare    04/03/25 - Enh 36912966 - Shared exadata racks: store
Rem                           metatada in ecra to denote capacity given to
Rem                           exascale service
Rem    jyotdas     04/01/25 - Enh 37500460 - free node from qfab as a launch
Rem                           node for clusterless patching
Rem    llmartin    04/22/25 - Enh 37641386 - Asyn rebalance property
Rem    illamas     04/01/25 - Enh 37746640 - 19c changes
Rem    jzandate    04/02/25 - Enh 37675147 - Adding brancher for
Rem                           ImageBaseProvisioning
Rem    illamas     03/24/25 - Enh 37740901 - 19c support for exadbxs
Rem    bshenoy     03/26/25 - Bug 37754673 : Fix sql issue
Rem    ybansod     03/20/25 - Enh 34558104 - PROVIDE API FOR ECRA RESOURCE
Rem                           BLACKOUT
Rem    jzandate    03/24/25 - Enh 37692741 - Adding property to use 6x9 for
Rem                           exacompute
Rem    gvalderr    03/06/25 - Enh 37557512 - setting ECRA_STORAGE_DEST to db by
Rem                           default
Rem    jzandate    03/18/25 - Enh 37525577 - Adding CONFIGURED_FEATURES to site
Rem                           groups
Rem    seha        02/27/25 - Bug 37634831 - Add table ecs_compliance_rpm_info
Rem    bshenoy     03/21/25 - X11M support for Elastic Reservation
Rem    abysebas    03/17/25 - Enh 37553125 - IPV6: BLOCK DUAL-STACK
Rem                           PROVISIONING IF THE EXADATA VERSION IS LESS THAN
Rem                           24.1.4.0.0
Rem    pverma      02/25/25 - Progress Details feature related changes
Rem    gvalderr    02/24/25 - Enh 37503396 - Enable auto undo/retry mechanism
Rem                           for vault-access creation workflow
Rem    jzandate    02/22/25 - Enh 37598887 - Adding exacloud wait time property
Rem    zpallare    02/13/25 - Bug 37583640 - EXACS: Delete two storage
Rem                           servers fails: error:oeda-2006: diskgroup sprc1
Rem                           requires at least 5 storage nodes
Rem    hcheon      02/10/25 - 37379447 whitelist infra for fault injection test
Rem    illamas     01/30/25 - Enh 37508426 - Store more values in CS exacompute
Rem    sdevasek    01/30/25 - Enh 37300474 - ECRA API AND DB CHANGES FOR LAUNCH
Rem                           NODE REGISTRATION ENDPOINT TO TAKE LAUNCHNODETYPE
Rem    jyotdas     01/29/25 - Enh 37267618 - Expose Ecra api to return
Rem                           registered versions for image series in exacs
Rem    mpedapro    01/28/25 - Enh::35594127 Enable dns and ntp changes for nw
Rem                           reconfiguration
Rem    bshenoy     02/17/25 - Bug 36847297: Convert infra activation flow to be
Rem                           WF based
Rem    abysebas    01/27/25 - Enh 37497061 - SKIP RESIZEDGSIZES STEPS
Rem                           CONDITIONALLY FROM ADD CELL FLOW
Rem    jvaldovi    01/15/25 - Enh 37477523 - Exacs Sitegroup - Include Mtu
Rem                           Config Per Site Group
Rem    bshenoy     01/24/25 - Adding entry in upgrade schema sql for version
Rem                           control
Rem    bshenoy     01/23/25 - Adding entry in upgrade schema sql for version
Rem                           control
Rem    zpallare    01/08/25 - Bug 37459422 - EXACS ECRA - Update zldra to zrcv
Rem                           in cross platform table for x11m
Rem    oespinos    12/19/24 - 36541136 - Add last_uptime_metric to ecs_sla_hosts
Rem    ybansod     12/18/24 - Bug 37403461 - POST ECRAUPGRADE ALL REQUESTS ARE
Rem                           FAILING WITH STEP_PROGRESS_DETAILS INVALID
Rem                           IDENTIFIER
Rem    josedelg    12/11/24 - Enh 35677516 - Increase timeout for ongoing ops
Rem    jvaldovi    12/10/24 - Enh 37045660 - Remove Dependency Of
Rem                           Restricted_Sitegroup In Cabinets_N_Cluster_Util
Rem    jzandate    12/09/24 - Enh 37372700 - Add missing commit
Rem    jzandate    11/29/24 - Enh 36979503 - Saving systemvault into ecra
Rem                           archive
Rem    zpallare    11/28/24 - Enh 36754344 - EXACS Compatibility - create new
Rem                           apis for compatibility matrix and algorithm for
Rem                           locking
Rem    illamas     11/25/24 - Enh 37312529 - Support exadata 25.1
Rem    zpallare    11/19/24 - Enh 34972266 - EXACS Compatibility - create new
Rem                           tables to support compatibility on operations
Rem    illamas     11/21/24 - Enh 37115247 - enable CUSTOM_GI
Rem    abysebas    11/14/24 - BUG 35848945 - UPGRADE POLLWORKFLOWTASK RUNNING
Rem                           FOR OLD WORKFLOWS
Rem    dtalla      11/04/24 - upgrade_schema.sql is the new SQL file for
Rem                           schema changes
Rem    dtalla      11/04/24 - Created
Rem

--[[illamas_bug-37115247_START]]--
UPDATE ecs_properties_table SET value='ENABLED' WHERE name='CUSTOM_GI';
commit;
--[[illamas_bug-37115247_END]]--

--[[illamas_bug-37312529_START]]--
DELETE FROM ECS_EXA_VER_MATRIX_TABLE;
INSERT INTO ECS_EXA_VER_MATRIX_TABLE (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol8', '23.1', 'BASE,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,21,19', 'EXACS', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX_TABLE (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol7', '22.1', 'BASE,X9M-2,X8M-2,X8-2,X7-2', '21,19', 'EXACS,ATP', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX_TABLE (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol8', '24.1', 'BASE,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,19', 'EXACS', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX_TABLE (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol8', '25.1', 'BASE,X11M,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,19', 'EXACS', 'ENABLED');
commit;
--[[illamas_bug-37312529_END]]--

--[[zpallare_bug-34972266_START]]--
PROMPT Creating table ecs_operations_compatibility_table
create table ecs_operations_compatibility_table (
    operation varchar2(50) not null,
    compatibleoperation varchar2(50) not null,
    env varchar2(20) DEFAULT ON NULL 'bm' NOT NULL,
    CONSTRAINT ecs_operations_compatibility_pk PRIMARY KEY (operation, compatibleoperation, env)
);
ALTER TABLE ecs_registries_table ADD resourceid VARCHAR2(256);

CREATE OR REPLACE EDITIONING VIEW ecs_registries AS
SELECT
    operation,
    rack_id,
    request_id,
    resourceid
FROM
    ecs_registries_table;

CREATE OR REPLACE EDITIONABLE VIEW ECS_OPERATIONS_COMPATIBILITY AS
SELECT
    OPERATION,
    COMPATIBLEOPERATION,
    ENV
FROM
    ECS_OPERATIONS_COMPATIBILITY_TABLE
WHERE 
    ENV = (SELECT NVL((SELECT VALUE FROM ECS_PROPERTIES_TABLE WHERE NAME = 'ECRA_ENV' 
      AND ROWNUM = 1),'bm') FROM DUAL);

INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('reshape-cores', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('reshape-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('oci-attach-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit-attach-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit-delete-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'reshape-storage', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'oci-attach-cell', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'exaunit-attach-cell', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'exaunit-delete-cell', 'bm');

INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('OPERATION_COMPATIBILITY_FEATURE',  'FEATURE', 'DISABLED', 'Property to enable/disable operations compatibility. If the property is enabled the code will use the compatibility matrix to allow parallel operations');

COMMIT;
--[[zpallare_bug-34972266_END]]--

--[[jzandate_bug_36979503_START]]--
CREATE TABLE ECS_ECRA_ARCHIVE_TABLE (
    ocid            varchar2(1024) not null,
    source_type     varchar2(256) not null,
    source_value    clob,
    payload         clob,
    analytics_id    number,
    archive_reason  varchar2(2048),
    reference_type  varchar2(256),
    reference_value varchar2(256),
    retention_days  number default 90,
    created_at      timestamp default systimestamp,
    CONSTRAINT ocid_unique UNIQUE(ocid)
);

CREATE OR REPLACE EDITIONING VIEW ECS_ECRA_ARCHIVE AS
SELECT
    ocid,
    source_type,
    source_value,
    payload,
    analytics_id,
    archive_reason,
    reference_type,
    reference_value,
    retention_days,
    created_at
FROM ECS_ECRA_ARCHIVE_TABLE;

INSERT INTO ecs_properties (name, type, value, description) VALUES ('ECRA_ARCHIVE_DEFAULT_RETENTION_DAYS', 'ECRA', '182', 'Number of days to have this metadata in the table after that it will be removed');

COMMIT;

--[[jzandate_bug_36979503_END]]--

--[[jyotdas_bug-37267618_START]]--
CREATE TABLE ecs_exadata_patch_version_series_table (
   service_type            varchar2(128) not null,
   patch_type              varchar2(128) not null,
   target_type             varchar2(128) not null,
   image_series            varchar2(128) not null,
   max_image_version       varchar2(128) not null,
   min_image_version       varchar2(128) null,
   comments                varchar2(1024) ,
   last_updated_time       timestamp default systimestamp not null,
   CONSTRAINT pk_exadata_patch_version_series PRIMARY KEY (service_type, patch_type, target_type, image_series)
);

CREATE OR REPLACE EDITIONING VIEW ecs_exadata_patch_version_series AS
SELECT
    service_type,
    patch_type,
    target_type,
    image_series,
    max_image_version,
    min_image_version,
    comments,
    last_updated_time
FROM ecs_exadata_patch_version_series_table;

--[[jyotdas_bug-37267618_END]]--


--[[jyotdas_bug-37500460_START]]--
alter table ecs_hw_nodes_table drop constraint ck_ecs_hw_nodes_node_state;
ALTER TABLE ecs_hw_nodes_table add CONSTRAINT ck_ecs_hw_nodes_node_state
      CHECK (node_state in ('FREE', 'COMPOSING', 'ALLOCATED', 'HW_REPAIR',
                            'HW_UPGRADE', 'HW_FAIL', 'RESERVED', 'ERROR', 'EXACOMP_RESERVED', 'RESERVED_MAINTENANCE', 'RESERVED_FAILURE',
                            'RESERVED_HW_FAILURE', 'FREE_FAILURE', 'FREE_MAINTENANCE','FREE_UNDER_MAINT', 'COMPOSING_UNDER_MAINT',
                            'ALLOCATED_UNDER_MAINT', 'RESERVED_UNDER_MAINT',
                            'HW_REPAIR_UNDER_MAINT', 'HW_UPGRADE_UNDER_MAINT', 'HW_FAIL_UNDER_MAINT',
                            'ERROR_UNDER_MAINT', 'EXACOMP_RESERVED_UNDER_MAINT', 'INNOTIFICATION', 'INNOTIFICATION_UNDER_MAINT',
                            'INMAINTENANCE', 'INMAINTENANCE_UNDER_MAINT', 'UNDER_INGESTION', 'INGESTION_FAILED', 'REQUIRES_RECOVERY',
                            'FREE_AUTO_MAINTENANCE','MOVING','DECOMMISSIONING','LAUNCH_NODE_FOR_PATCHING'));
--[[jyotdas_bug-37500460_END]]--

--[[josedelg_bug-35677516_START]]--
INSERT INTO ecs_properties (name, type, value) VALUES ('SWITCHOVER_MAX_WAIT_INTERVAL', 'ECRA', '80');
commit;
--[[josedelg_bug-35677516_END]]--


--[[jyotdas_bug-37912226_START]]--
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_LIVE_UPDATE', 'PATCHING', 'DISABLED');
commit;
--[[jyotdas_bug-37912226_END]]--

--[[llmartin_bug-37362062_START]]--

DECLARE
  c_name all_constraints.constraint_name%type;
BEGIN
  SELECT constraint_name INTO c_name FROM all_constraints WHERE table_name='ECS_DOMUS_TABLE' AND search_condition_vc LIKE '%state%in%RUNNING%';
  EXECUTE immediate 'ALTER TABLE ecs_domus_table drop CONSTRAINT ' || c_name;
  EXECUTE immediate 'ALTER TABLE ecs_domus_table ADD CONSTRAINT ecs_domus_state_ck CHECK (state IN (''RUNNING'',''STOPPED'', ''MIGRATING'', ''PATCHING'', ''RESOURCE_SCALING'',''TERMINATING'', ''ERROR'', ''PROVISIONING'',''DELETED''))';
END;
/

--[[llmartin_bug-37362062_END]]--

--[[zpallare_bug-36754344_START]]--
PROMPT Inserting records for operations compatibility

INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('mvm-attach-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('mvm-delete-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'mvm-attach-storage', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'mvm-delete-storage', 'bm');

COMMIT;
--[[zpallare_bug-36754344_END]]--

--[[jvaldovi_bug-37045660_START]]--
PROMPT Recreating editioning views on table ECS_HW_CABINETS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_HW_CABINETS AS
    SELECT
        ID,
        NAME,
        AVAILABILITY_DOMAIN,
        FAULT_DOMAIN,
        CAGE_ID,
        MODEL,
        CLUSTER_SIZE_CONSTRAINT,
        TIME_ZONE,
        DOMAINNAME,
        SUBNET_ID,
        PRODUCT,
        GENERATION_TYPE,
        STATUS,
        XML,
        CANONICAL_BUILDING,
        BLOCK_NUMBER,
        SERIAL_NUMBER,
        PREVIOUS_STATUS,
        LAUNCHNODE,
        MVM_DOMAINNAME,
        MVM_SUBNET_ID,
        ETH0,
        CANONICAL_ROOM,
        COMPUTE_AVAILABILITY,
        CELL_AVAILABILITY,
        STATUS_COMMENT,
        SITEGROUP,
        AUTO_MAINTENANCE,
        OPSTATE,
        ADMIN_ACTIVE_VNIC,
        ADMIN_STANDBY_VNIC,
        SUBNET_OCID
    FROM
        ECS_HW_CABINETS_TABLE;
--[[jvaldovi_bug-37045660_END]]--
--[[abysebas_bug-35848945_START]]--
INSERT INTO ecs_properties (name, type, value) VALUES ('WF_TASK_POLLING_THRESHOLD_HOURS', 'ECRA_RESILIENCE', '6');
--[[abysebas_bug-35848945_END]]--

--[[ybansod_bug-37403461_START]]--
alter table ecs_requests_table add (step_progress_details clob);
CREATE OR REPLACE EDITIONING VIEW ecs_requests AS SELECT * FROM ecs_requests_table;
--[[ybansod_bug-37403461_END]]--

--[[oespinos_bug_36541136_START]]--
ALTER TABLE ecs_sla_hosts_table ADD last_uptime_metric_id number(10);
ALTER TABLE ecs_sla_hosts_table ADD CONSTRAINT fk_sla_hosts_sla_clu_metric FOREIGN KEY(last_uptime_metric_id) REFERENCES ecs_cluster_metrics_table(metric_cluster_id);

CREATE INDEX ecs_sla_hosts_hostname_idx ON ecs_sla_hosts_table("HOSTNAME");
CREATE INDEX ecs_sla_info_exaocid_cluocid_idx ON ecs_sla_info_table("EXA_OCID", "VM_CLUSTER_OCID");
CREATE INDEX ecs_sla_breach_idx ON ecs_sla_breach_table("SLA_INFO_ID");
CREATE INDEX ecs_sla_info_hosts_idx ON ecs_sla_info_hosts_table("SLA_INFO_ID");
CREATE INDEX ecs_sla_breach_hosts_idx ON ecs_sla_breach_hosts_table("SLA_BREACH_ID");


PROMPT Recreating editioning views on table ecs_sla_hosts_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_hosts AS
    SELECT
        sla_host_id,
        hostname,
        domainname,
        hw_type,
        last_uptime_metric_id
    FROM
        ecs_sla_hosts_table;

COMMIT;
--[[oespinos_bug_36541136_END]]--

--[[zpallare_bug-37459422_START]]--
INSERT INTO ecs_elastic_platform_info_table (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+ZRCV', 'X11M+STANDARD', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
COMMIT;
--[[zpallare_bug-37459422_END]]--


--[[illamas_bug-37326852_START]]--
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_SYSTEM_VOLUME_GB', 'EXACOMPUTE', '114');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_MAX_SIZE_VM_GB', 'EXACOMPUTE', '1100');
COMMIT;
--[[illamas_bug-37326852_END]]--

--[[jvaldovi_bug-37477523_START]]--
ALTER TABLE ECS_SITEGROUPS_TABLE ADD MTU number DEFAULT 9000;
ALTER TABLE ECS_SITEGROUPS_TABLE ADD FAR_CHILD_SITE varchar2(32) DEFAULT 'N';
ALTER TABLE ECS_SITEGROUPS_TABLE ADD OVERLAY_BRIDGE_USED varchar2(32) DEFAULT 'N';


PROMPT Recreating editioning views on table ECS_SITEGROUPS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_SITEGROUPS AS
    SELECT
        REGION,
        BUILDING,
        AD,
        ECRA_INFO_ID,
        NAME,
        RESTRICTED,
        CLOUD_VENDOR,
        CLOUD_PROVIDER_REGION,
        CLOUD_PROVIDER_BUILDING,
        CLOUD_PROVIDER_AZ,
        MTU,
        FAR_CHILD_SITE,
        OVERLAY_BRIDGE_USED
    FROM
        ECS_SITEGROUPS_TABLE;

--[[jvaldovi_bug-37477523_END]]--
--[[bshenoy_bug-37379576_START]]--
PROMPT Altering table ecs_oci_clu_xmls_table
ALTER TABLE ecs_oci_clu_xmls_table ADD updated_xml_exascale CLOB;
CREATE OR REPLACE EDITIONING VIEW ecs_oci_clu_xmls AS SELECT * FROM ecs_oci_clu_xmls_table;
--[[bshenoy_bug-37379576_END]]--

--[[mpedapro_bug-35594127_START]]--
UPDATE ecs_properties SET value='dns,ntp' WHERE name='NETWORK_RECONFIGURE_NW_SERVICES';
COMMIT;
--[[mpedapro_bug-35594127_END]]--
--[[aypaul_bug-37562818_START]]--
PROMPT Inserting new ECRA property EXACLOUD_BODY_DETAILS_PA
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_BODY_DETAILS_PARSE', 'FEATURE', 'ENABLED');
COMMIT;
--[[aypaul_bug-37562818_END]]--

--[[abysebas_bug-37497061_START]]--
ALTER TABLE ecs_cloudvnuma_tenancy_table add (skipresizedg varchar2(32) default 'no');
PROMPT Recreating editioning views on table ECS_CLOUDVNUMA_TENANCY_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_CLOUDVNUMA_TENANCY AS
    SELECT
        USER_GROUP,
        TENANCY_ID,
        CLOUD_VNUMA,
        JUMBO_FRAMES,
        MEMORYCONFIG,
        CUSTOM_UID_GID,
        EARLY_ADOPTER,
        SKIPRESIZEDG
    FROM
        ECS_CLOUDVNUMA_TENANCY_TABLE;
--[[abysebas_bug-37497061_END]]--

--[[bshenoy_bug-36847297_START]]--
PROMPT add INFRA_ACTIVATION_WF property
INSERT INTO ecs_properties (name, type, value) VALUES ('INFRA_ACTIVATION_WF', 'EXACC', 'false');
COMMIT;
--[[bshenoy_bug-36847297_END]]--

--[[hcheon_bug_37541029_START]]--
PROMPT Adding ecs property ENABLE_FAULT_INJECTION
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_FAULT_INJECTION', 'FAULT_INJECTION', 'FALSE');
COMMIT;
--[[hcheon_bug_37541029_END]]--

--[[hcheon_bug_37379447_START]]--
PROMPT Creating ecs_fault_injection_infra
CREATE TABLE ecs_fault_injection_infra_table (
    infra_ocid VARCHAR2(256) PRIMARY KEY,
    CONSTRAINT fk_infra_ocid FOREIGN KEY(infra_ocid) REFERENCES ecs_ceidetails_table(ceiocid) ON DELETE CASCADE
);
CREATE OR REPLACE EDITIONING VIEW ecs_fault_injection_infra AS
    SELECT infra_ocid FROM ecs_fault_injection_infra_table;
--[[hcheon_bug_37379447_END]]--

--[[illamas_bug-37508426_START]]--
ALTER TABLE ecs_exacompute_entity_table ADD volumes clob;
CREATE OR REPLACE EDITIONING VIEW ecs_exacompute_entity AS
SELECT
       rack_name,
       cluster_id,
       cluster_name,
           atp,
           cells,
           cluster_vault,
           dom0_bonding,
           exaunit_allocations,
           grid_version,
           service_type,
           storage_type,
           volumes
FROM ecs_exacompute_entity_table;
--[[illamas_bug-37508426_END]]--

--[[zpallare_bug-37583640_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('MINIMUM_CELLS_FOR_SPARSE', 'ELASTIC', '5', 'The minimum ammount of cells that should remain for sparse clusters after delete storage flow');
COMMIT;
--[[zpallare_bug-37583640_END]]--
--[[sdevasek_bug-37300474_START]]--
ALTER TABLE ecs_infrapatching_launch_nodes_table ADD launchnode_type  VARCHAR2(128);

PROMPT Recreating editioning views on table ecs_infrapatching_launch_nodes_table
CREATE OR REPLACE EDITIONING VIEW ecs_infrapatching_launch_nodes AS
SELECT
    infra_name,
    launch_nodes,
    infra_type,
    launchnode_type
FROM
    ecs_infrapatching_launch_nodes_table;
--[[sdevasek_bug-37300474_END]]--
--[[jzandate_bug-37598887_START]]--
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXACLOUD_DEFAULT_BASE_WAIT_TIME_PER_CYCLE_MILLIS', 'ECRA', '1000', 'Total wait time in milliseconds to be added to exponential backoff for exacloud calls used in between wait cycles');
COMMIT;
--[[jzandate_bug-37598887_END]]--

--[[pverma_bug-37542317_START]]--
PROMPT Creating table WF_TASKS_WEIGHTS_TABLE 
create table WF_TASKS_WEIGHTS_TABLE (
     WF_NAME varchar2(512) NOT NULL,
     WF_TASK_NAME varchar2(256) NOT NULL,
     EXEC_MODE varchar2(8) NOT NULL,
     EXEC_SCOPE varchar2(8) NOT NULL,
     EXEC_COUNT number,
     NODE_FACTOR varchar2(1) NOT NULL,
     MEAN_EXEC_DURATION_PER_NODE NUMBER NOT NULL,
     MEAN_WEIGHT number,
     CONSTRAINT CHK_MODE
        CHECK (EXEC_MODE IN ('SYNC', 'ASYNC')),
     CONSTRAINT CHK_EXEC_SCOPE
        CHECK (EXEC_SCOPE IN ('LOCAL', 'REMOTE')),
     CONSTRAINT CHK_NODE_FACTOR
        CHECK (NODE_FACTOR IN ('Y', 'N')),
     CONSTRAINT pk_tasks_weight_table PRIMARY KEY (WF_NAME, WF_TASK_NAME)
);

PROMPT Creating editioning view on table WF_TASKS_WEIGHTS_TABLE
CREATE OR REPLACE EDITIONING VIEW WF_TASKS_WEIGHTS as select * from WF_TASKS_WEIGHTS_TABLE;

PROMPT Creating table WF_TASKS_PROGRESS_STATUS_TABLE
create table WF_TASKS_PROGRESS_STATUS_TABLE (
     REQUEST_ID varchar2(256) NOT NULL,
     REQUEST_TYPE varchar2(24) NOT NULL,
     WF_UUID varchar2(256),
     WF_NAME varchar2(512),
     WF_CURRENT_TASK varchar2(256),
     OPERATION_ID varchar2(256),
     PROGRESS_PERCENTAGE number DEFAULT 0,
     TOTAL_TASKS number DEFAULT 1,
     COMPLETED_TASKS number DEFAULT 1,
     TOTAL_WEIGHT number DEFAULT 1,
     COMPLETED_WEIGHT number DEFAULT 1,
     CURRENT_TASK_STATE varchar2(16),
     USER_ACTION varchar2(32),
     CURRENT_STEP_DETAILS clob,
     MESSAGES_STACK clob,
     MULTIPLICATION_FACTOR number DEFAULT 1,
     LAST_UPDATED timestamp,
     CONSTRAINT CHK_TASK_STATE
        CHECK (CURRENT_TASK_STATE IN ('DONE', 'FAILED', 'PROCESSING', 'PAUSED')),
     CONSTRAINT pk_wf_tasks_progress_status PRIMARY KEY (REQUEST_ID)
); 

PROMPT Creating editioning view on table WF_TASKS_PROGRESS_STATUS_TABLE
CREATE OR REPLACE EDITIONING VIEW WF_TASKS_PROGRESS_STATUS as select * from WF_TASKS_PROGRESS_STATUS_TABLE;

--[[pverma_bug-37542317_END]]--

--[[gvalderr_bug-37503396_START]]--
INSERT INTO ecs_wf_auto_retry_action_rule_table (wfname, taskname, errorcode, action) VALUES ('exacompute-vaultaccessupdate-wfd', 'all', 'all', 'AutoUndoAndRetry');
COMMIT;
--[[gvalderr_bug-37503396_END]]--

--[[bshenoy_bug-37706584_START]]--
alter table ecs_rocefabric_table add X11M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric_table add X11M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;

alter table ecs_rocefabric_table add X11M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS varchar2(10) default 'ENABLED';
alter table ecs_rocefabric_table add CONSTRAINT override_capacity_constr_x11m CHECK (X11M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS in ('ENABLED', 'DISABLED'));

PROMPT Recreating editioning views on table ecs_rocefabric_table
CREATE OR REPLACE EDITIONING VIEW ecs_rocefabric AS
SELECT * FROM ecs_rocefabric_table;

PROMPT create fabric_reservation_threshold_table
CREATE TABLE ecs_fabric_elastic_reserve_thresholds_table (
    fabric_name     varchar2(1024) not null,
    node_type       varchar2(128) not null,
    model_type      varchar2(128) not null,
    model_subtype   varchar2(128),
    threshold_pct       number,
    threshold_abs       number,
    CONSTRAINT  fk_fabric_name
        FOREIGN KEY (fabric_name)
        REFERENCES  ecs_rocefabric_table(fabric_name)
);
CREATE OR REPLACE EDITIONING VIEW ecs_fabric_elastic_reserve_thresholds AS 
    SELECT * FROM ecs_fabric_elastic_reserve_thresholds_table;

INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_LARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_EXTRALARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_NOXRMEM_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_EF_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_LARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_EXTRALARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_NOXRMEM_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_EF_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS', 'ELASTIC', 'DISABLED', 'Enable/Disable QFAB reservation of X11M nodes for elastic expansion once the utilization goes above threshold');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(abs) utilization above which X8M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(abs) utilization above which X8M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(abs) utilization above which X9M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(abs) utilization above which X9M-CELL nodes in the QFAB will be reserved for elastic expansion only');
COMMIT;
--[[bshenoy_bug-37706584_END]]--



--[[jzandate_bug-37525577_START]]--
ALTER TABLE ECS_SITEGROUPS_TABLE ADD (CONFIGURED_FEATURES varchar2(1024));
CREATE OR REPLACE EDITIONING VIEW ECS_SITEGROUPS as
SELECT
    REGION,
    BUILDING,
    AD,
    ECRA_INFO_ID,
    NAME,
    RESTRICTED,
    CLOUD_VENDOR,
    CLOUD_PROVIDER_REGION,
    CLOUD_PROVIDER_AZ,
    CLOUD_PROVIDER_BUILDING,
    MTU,
    FAR_CHILD_SITE,
    OVERLAY_BRIDGE_USED,
    CONFIGURED_FEATURES
FROM
    ECS_SITEGROUPS_TABLE;
COMMIT;
--[[jzandate_bug-37525577_END]]--
--[[seha_bug-37634831_START]]--
PROMPT Creating table ecs_compliance_rpm_info_table
CREATE TABLE ecs_compliance_rpm_info_table (
    name                VARCHAR2(50),  -- clamav.x86_64, clamav-avdefs.noarch
    version             VARCHAR2(100), -- 0.103.11-1, 4.0-3054
    yum_upload_time     TIMESTAMP,
    ecra_download_time  TIMESTAMP,
    CONSTRAINT ecs_compliance_rpm_info_pk PRIMARY KEY (name, version)
);
PROMPT Creating view ecs_compliance_rpm_info
CREATE OR REPLACE EDITIONING VIEW ecs_compliance_rpm_info AS
SELECT
    name,
    version,
    yum_upload_time,
    ecra_download_time
FROM
    ecs_compliance_rpm_info_table;
--[[seha_bug-37634831_END]]--
--[[gvalderr_bug-37557512_START]]--
UPDATE ecs_properties_table SET value='db' WHERE name='ECRA_STORAGE_DEST';
COMMIT;
--[[gvalderr_bug-37557512_END]]--
--[[jzandate_bug-37692741_START]]--
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXACOMPUTE_USE_69_TO_FETCH_CABINETS', 'EXACOMPUTE', 'ENABLED', 'Enable to look for computes in 6x9 cabinets for exacompute');
COMMIT;
--[[jzandate_bug-37692741_END]]--
--[[ybansod_bug-34558104_START]]--
PROMPT Creating table ecs_resource_blackout_table
CREATE TABLE ECS_RESOURCE_BLACKOUT_TABLE (
    ID              NUMBER GENERATED ALWAYS AS IDENTITY,
    RESOURCE_NAME   VARCHAR2(256) NOT NULL,
    RESOURCE_TYPE   VARCHAR2(256) NOT NULL,
    PARENT_ID       NUMBER,
    CLUSTER_NAME    VARCHAR2(256),
    CREATION_TIME   TIMESTAMP DEFAULT SYSTIMESTAMP,
    START_TIME      VARCHAR2(50),
    END_TIME        VARCHAR2(50),
    BLACKOUT_TYPE   VARCHAR2(256),
    STATUS          VARCHAR2(256) DEFAULT 'ENABLED' NOT NULL,
    SOURCE          VARCHAR2(256),
    COMMENTS        VARCHAR2(2048),
    AUDITING        CLOB,
    OPERATION_ALLOWED VARCHAR2(256),
    CONSTRAINT ECS_RESOURCE_BLACKOUT_PK PRIMARY KEY (ID),
    CONSTRAINT ECS_RESOURCE_BLACKOUT_STATUS_CK CHECK (STATUS in ('ENABLED', 'DISABLED', 'PENDING'))
);

PROMPT Creating editioning views on table ECS_RESOURCE_BLACKOUT_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_RESOURCE_BLACKOUT AS
SELECT
    ID,
    RESOURCE_NAME,
    RESOURCE_TYPE,
    PARENT_ID,
    CLUSTER_NAME,
    CREATION_TIME,
    START_TIME,
    END_TIME,
    BLACKOUT_TYPE,
    STATUS,
    SOURCE,
    COMMENTS,
    AUDITING,
    OPERATION_ALLOWED
FROM
    ECS_RESOURCE_BLACKOUT_TABLE;
--[[ybansod_bug-34558104_END]]--
--[[illamas_bug-37740901_START]]--
ALTER TABLE ecs_exacompute_entity_table add (servicesubtype varchar2(16) default 'exadbxs' not null);
ALTER TABLE ecs_exacompute_entity_table add (clustertype varchar2(16) default 'smartstorage' not null);
CREATE OR REPLACE EDITIONING VIEW ecs_exacompute_entity AS
SELECT
       rack_name,
       cluster_id,
       cluster_name,
           atp,
           cells,
           cluster_vault,
           dom0_bonding,
           exaunit_allocations,
           grid_version,
           service_type,
           storage_type,
           volumes,
           servicesubtype,
           clustertype
FROM ecs_exacompute_entity_table;

ALTER TABLE ecs_gold_specs_table DROP CONSTRAINT chk_type;
ALTER TABLE ecs_gold_specs_table
    ADD CONSTRAINT chk_type
        CHECK (type IN ('exacs', 'adbd','adbs','exacsmvm','exacsminspec','exacsmvmminspec','adbdmvm','fa','exacsexacompute','exacc','exaccadbd','exaccmvm','exaccadbdmvm','exacsexacompute19c'));

INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute19c','domU','-1','kvm','filesystem','/u01','80G','','','','','','','false','all');
COMMIT;
--[[illamas_bug-37740901_END]]--
--[[jzandate_bug-37675147_START]]--
INSERT INTO ecs_properties (name, type, value, description)
VALUES ('FORCE_GOLD_IMAGE_PROVISIONING', 'EXACOMPUTE', 'FALSE', 'FORCE GOLD IMAGE PROVISIOING FLAG AS IT WILL REPLACE PostVMInstall, CreateUser, ExaScaleComplete for GoldComplete task in CS WF');
COMMIT;
--[[jzandate_bug-37675147_END]]--
--[[illamas_bug-37746640_START]]--
ALTER TABLE ecs_volumes_table ADD guestdevicename varchar2(64) default NULL;
ALTER TABLE ecs_volumes_table DROP CONSTRAINT ecs_volumes_pk;
ALTER TABLE ecs_volumes_table
    ADD CONSTRAINT ecs_volumes_pk
        PRIMARY KEY (oracle_hostname,client_hostname,volume_type,volume_name);

PROMPT Recreating editioning views on table ecs_volumes_table
CREATE OR REPLACE EDITIONING VIEW ecs_volumes AS
SELECT
    oracle_hostname,
    client_hostname,
    vault_id,
    volume_id,
    volume_type,
    volume_name,
    volume_device_path,
    volume_size_gb,
    guestdevicename
FROM
  ecs_volumes_table;
--[[illamas_bug-37746640_END]]--

--[[zpallare_bug-36912966_START]]--
ALTER TABLE ecs_hw_elastic_nodes_table add (servicetype varchar2(64));
CREATE OR REPLACE EDITIONING VIEW ecs_hw_elastic_nodes AS
SELECT
    EXA_OCID,
    ECS_RACKS_NAME_LIST,
    NODE_TYPE,
    NODE_MODEL,
    DATE_MODIFIED,
    ORACLE_IP,
    ORACLE_HOSTNAME,
    ORACLE_ILOM_IP,
    ORACLE_ILOM_HOSTNAME,
    LOCATION_RACKUNIT,
    IB1_HOSTNAME,
    IB1_IP,
    IB1_DOMAIN_NAME,
    IB1_NETMASK,
    IB2_HOSTNAME,
    IB2_IP,
    IB2_DOMAIN_NAME,
    IB2_NETMASK,
    ELASTIC_STATE,
    ORACLE_GATEWAY,
    ORACLE_NETMASK,
    ORACLE_ILOM_GATEWAY,
    ORACLE_ILOM_NETMASK,
    ORACLE_ADMIN_DOMAIN_NAME,
    ORACLE_ILOM_DOMAIN_NAME,
    RACK_NUM,
    EXTRA_ARCHIVE_INFO,
    MODEL_SUBTYPE,
    SERVICETYPE
FROM ecs_hw_elastic_nodes_table;
COMMIT;
--[[zpallare_bug-36912966_END]]--

--[[zpallare_bug-37806655_START]]--
INSERT INTO ecs_elastic_platform_info_table (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-HC-Z', 'X11M+Z', 'X11MZHCZDLRA', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('FALLBACK_TO_STANDARD_FOR_ZDLRA','ZDLRA', 'ENABLED', 'This property enable/disable the retry mechanism for zdlra requests');
COMMIT;
--[[zpallare_bug-37806655_END]]--

--[[kukrakes_bug_37836265_START]]--
ALTER TABLE ECS_VOLUMES_TABLE MODIFY VOLUME_NAME varchar2(128);
--[[kukrakes_bug_37836265_END]]--
--[[jzandate_bug-37811733_START]]--
ALTER TABLE ECRA_INFO_TABLE ADD (dbaas_exadbxs_version VARCHAR2(64) DEFAULT NULL);

CREATE OR REPLACE EDITIONING VIEW ecra_info AS
SELECT ID, URI, AUTHID, DBAAS_VERSION, DBAAS_EXADBXS_VERSION, EXACLOUD_VERSION, OEDA_VERSION, LABEL, UPGRADE_TYPE,
       END_TIME, START_TIME from ECRA_INFO_TABLE;
COMMIT;
--[[jzandate_bug-37811733_END]]--

--[[kukrakes_bug_37855310_START]]--
ALTER TABLE ecs_volumes_table DROP CONSTRAINT ecs_volumes_pk;
ALTER TABLE ecs_volumes_table ADD CONSTRAINT ecs_volumes_pk PRIMARY KEY (oracle_hostname, client_hostname, volume_type, volume_name, volume_device_path);
--[[kukrakes_bug_37855310_END]]--

--[[zpallare_bug-37811586_START]]--
INSERT INTO ecs_elastic_platform_info_table (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-EF', 'X11M+EF','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'CELL');
COMMIT;
--[[zpallare_bug-37811586_END]]--
--[[antamil_bug-37333331_START]]--
ALTER TABLE ecs_infrapatching_launch_nodes_table ADD launchnode_state  VARCHAR2(128) default 'ACTIVE';
ALTER TABLE ecs_infrapatching_launch_nodes_table DROP CONSTRAINT pk_infrapatch_launch_nodes;
ALTER TABLE ecs_infrapatching_launch_nodes_table ADD CONSTRAINT pk_infrapatch_launch_nodes PRIMARY KEY (infra_name ,infra_type, launch_nodes);

PROMPT Recreating editioning views on table ecs_infrapatching_launch_nodes_table
CREATE OR REPLACE EDITIONING VIEW ecs_infrapatching_launch_nodes AS
SELECT
    infra_name,
    launch_nodes,
    infra_type,
    launchnode_type,
    launchnode_state
FROM
    ecs_infrapatching_launch_nodes_table;
--[[antamil_bug-37333331_END]]--
--[[illamas_bug-37598057_START]]--
PROMPT Altering table ecs_gold_specs_table
ALTER TABLE ecs_gold_specs_table DROP CONSTRAINT chk_type;
ALTER TABLE ecs_gold_specs_table
    ADD CONSTRAINT chk_type
        CHECK (type IN ('exacs', 'adbd','adbs','exacsmvm','exacsminspec','exacsmvmminspec','adbdmvm','fa','exacsexacompute','exacc','exaccadbd','exaccmvm','exaccadbdmvm','exacsexacompute19c','exacomputebasedb'));

INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','system','114G','','','','','','','false','all');

-- EXACOMPUTE BASEDB
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/opt','35G','','','','','','','false','all');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/var','10G','','','','','','','false','all');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','system','114G','','','','','','','false','all');
commit;
--[[illamas_bug-37598057_END]]--
--[[llmartin_bug-37641386_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('SKIP_RESIZE_IF_ONE_CLUSTER_CEI', 'KVMROCE', 'ENABLED', 'If ENABLED, the resizeDG will be skipped during cell attachement if there is only one cluster in the CEI.');
commit;
--[[llmartin_bug-37641386_END]]--
--[[rgmurali_bug-37837172_START]]--
ALTER TABLE ECS_ROCEFABRIC_TABLE MODIFY EXTENDED_VLAN_START DEFAULT 6000;
ALTER TABLE ECS_ROCEFABRIC_TABLE MODIFY EXTENDED_VLAN_END DEFAULT 58000;
commit;
--[[rgmurali_bug-37837172_END]]--



--[[caborbon_bug-37799591_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('LIMIT_PER_CABINET_EXTRALARGE_X11M', 'ELASTIC', '5', 'This defines the max nodes with ExtraLarge configuration that each cabinet can have, a -1 means no limit');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('LIMIT_PER_CABINET_LARGE_X11M', 'ELASTIC', '-1', 'This defines the max nodes with Large configuration that each cabinet can have, a -1 means no limit');
COMMIT;
--[[caborbon_bug-37799591_END]]--

--[[sdevasek_bug-37839098_START]]--
--creating ecs_external_launch_node_patching_operations_table
PROMPT creating table ecs_external_launch_node_patching_operations_table

create table ecs_external_launch_node_patching_operations_table(
request_id            varchar2(128) not null,
rack_name             varchar2(256) not null,
patch_operation       varchar2(128) not null,
launch_node           varchar2(256) not null,
exaunit_id            varchar2(64),
patchmgr_id           varchar2(128),
patchmgr_log_path     varchar2(256),
creation_time         timestamp  default systimestamp not null,
CONSTRAINT pk_launch_node_patching_operations PRIMARY KEY (request_id)
);

CREATE OR REPLACE EDITIONING VIEW ecs_external_launch_node_patching_operations AS
SELECT
        request_id,
        rack_name,
        patch_operation,        
	launch_node,
	exaunit_id,
        patchmgr_id,
        patchmgr_log_path,
        creation_time
FROM ecs_external_launch_node_patching_operations_table;

--[[sdevasek_bug-37839098_END]]--

--[[jzandate_bug-37647220_START]]--
-- Default is disabled
ALTER TABLE ECS_CLOUDVNUMA_TENANCY_TABLE ADD (CONFIGURED_FEATURES varchar2(1024));
PROMPT Recreating editioning views on table ECS_CLOUDVNUMA_TENANCY_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_CLOUDVNUMA_TENANCY AS
SELECT
    USER_GROUP,
    TENANCY_ID,
    CLOUD_VNUMA,
    JUMBO_FRAMES,
    MEMORYCONFIG,
    CUSTOM_UID_GID,
    EARLY_ADOPTER,
    SKIPRESIZEDG,
    CONFIGURED_FEATURES
FROM
    ECS_CLOUDVNUMA_TENANCY_TABLE;
--[[jzandate_bug-37647220_END]]--

--[[illamas_bug-37724767_START]]--
MERGE INTO ecs_registries
USING
    (SELECT 1 "one" FROM dual) 
ON
    (ecs_registries.RACK_ID= 'exacompute' and ecs_registries.request_id='89ab2335-144d-4d89-8f13-21ea34f89c55' and ecs_registries.operation='nathostnameselection') 
WHEN NOT matched THEN
INSERT (rack_id, request_id, operation)
VALUES ('exacompute', '89ab2335-144d-4d89-8f13-21ea34f89c55', 'nathostnameselection');
COMMIT;
--[[illamas_bug-37724767_END]]--

--[[gvalderr_bug-34750083_START]]--
PROMPT Altering table ecs_domukeysinfo
ALTER TABLE ecs_domukeysinfo_TABLE ADD (operation_id varchar2(128));

PROMPT Creating editioning view on table ecs_domukeysinfo_table
CREATE OR REPLACE EDITIONING VIEW ecs_domukeysinfo AS
SELECT
    ID,
    EXAUNIT_ID,
    PUBLIC_KEY,
    USERS,
    CREATION_TIME,
    TTL,
    DOMU,
    OPERATION_ID
FROM ecs_domukeysinfo_table;
--[[gvalderr_bug-34750083_END]]--

--[[abyayada_bug-37976144_START]]--
ALTER TABLE ecs_exascale_vaults_table DROP CONSTRAINT CHK_XSVAULT_TYPE;
ALTER TABLE ecs_exascale_vaults_table ADD CONSTRAINT CHK_XSVAULT_TYPE CHECK (TYPE IN ('DB', 'VMIMAGE', 'VMBACKUP'));
CREATE OR REPLACE EDITIONING VIEW ecs_exascale_vaults AS SELECT * FROM ecs_exascale_vaults_table;

ALTER TABLE ecs_exaunitdetails_table ADD (vmbackup_target varchar2(5) DEFAULT 'LOCAL' CHECK (vmbackup_target in ('LOCAL', 'XS')));
ALTER TABLE ecs_exaunitdetails_table ADD (vmimage_target varchar2(5) DEFAULT 'LOCAL' CHECK (vmimage_target in ('LOCAL', 'XS')));
CREATE OR REPLACE EDITIONING VIEW ecs_exaunitdetails AS SELECT * FROM ecs_exaunitdetails_table;
--[[abyayada_bug-37976144_END]]--

--[[zpallare_bug-37917049_START]]--
UPDATE ecs_properties_table SET value='ENABLED' WHERE name='OPERATION_COMPATIBILITY_FEATURE';
COMMIT;
--[[zpallare_bug-37917049_END]]--

--[[gvalderr_bug-37957373_START]]--
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/var/log/audit','2G','','','','','','','false','all');
COMMIT;
--[[gvalderr_bug-37957373_END]]--

--[[ritikhan_bug-37976142_START]]--
CREATE TABLE ECS_ACFS_TABLE (
    acfs_name VARCHAR2(256),
    acfs_ocid VARCHAR2(512) NOT NULL,
    size_gb NUMBER,
    used_gb NUMBER,
    db_vault_ocid VARCHAR2(512) NOT NULL,
    mount_path VARCHAR2(256),
    vm_cluster_ocid VARCHAR2(512),
    CONSTRAINT pk_acfs_ocid PRIMARY KEY (acfs_ocid)
);

CREATE OR REPLACE EDITIONING VIEW ECS_ACFS AS
SELECT
    acfs_name,
    acfs_ocid,
    size_gb,
    used_gb,
    db_vault_ocid,
    mount_path,
    vm_cluster_ocid
FROM
    ECS_ACFS_TABLE;
--[[ritikhan_bug-37976142_END]]--

--[[abysebas_bug-37553125_START]]--
INSERT INTO ecs_properties (name, type, value, description) VALUES ('IPV6_MIN_DOM0_IMAGE_VERSION', 'ECRA', '24.1.4.0.0', 'Minimum Exadata version supported for IPV6 dual stack provisioning');
COMMIT;
--[[abysebas_bug-37553125_END]]--

--[[jyotdas_bug-38467237_START]]--
INSERT INTO ecs_properties (name, type, value) VALUES ('ELU_IMAGESERIES_TO_DEPTH_MAPPING', 'PATCHING', '25:2');
COMMIT;
--[[jyotdas_bug-38467237_END]]--

--[[jyotdas_bug-38689885_START]]--
UPDATE ecs_properties_table SET value='' WHERE name='ELU_IMAGESERIES_TO_DEPTH_MAPPING';
commit;
--[[jyotdas_bug-38689885_END]]--

--[[delall_bug-37464154_START]]--
ALTER TABLE state_store_table ADD (time_created varchar2(50));
CREATE OR REPLACE EDITIONING VIEW state_store AS
    SELECT
        STATE_HANDLE,
        STATE_DATA,
        PLAN,
        STATE_ID,
        TIME_CREATED
    FROM
        state_store_table;
--[[delall_bug-37464154_END]]--

--[[sdevasek_bug-37677954_START]]--

-- Property to determine the maximum number of concurrent patch requests allowed on the launchnode
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_CONCURRENT_PATCH_SESSIONS_ON_LAUNCHNODE', 'PATCHING', '2');
COMMIT;

--[[sdevasek_bug-37677954_END]]--
--[[pverma_bug-37876735_START]]--
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE MODIFY(RESERVE_TYPE VARCHAR2(64) DEFAULT 'all_operations');
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE DROP CONSTRAINT PK_ECS_RACKNAME_RES_ALLOC;
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE ADD CONSTRAINT PK_ECS_RACKNAME_RES_ALLOC PRIMARY KEY (RACKNAME, RESERVE_TYPE);
--[[pverma_bug-37876735_END]]--

--[[caborbon_bug-38005893_START]]--
INSERT INTO ECS_ELASTIC_PLATFORM_INFO_TABLE (MODEL,SUPPORTED_SHAPES,MAXCOMPUTES,MAXCELLS,ILOMTYPE,SUPPORT_STATUS,FEATURE,HW_TYPE,OEDA_CODENAME)
VALUES('X10M-2L','X10M-2',-1,-1,'OVERLAY','ACTIVE','ELASTIC_SUBTYPE','CELL',NULL);
INSERT INTO ECS_ELASTIC_PLATFORM_INFO_TABLE (MODEL,SUPPORTED_SHAPES,MAXCOMPUTES,MAXCELLS,ILOMTYPE,SUPPORT_STATUS,FEATURE,HW_TYPE,OEDA_CODENAME)
VALUES('X10M-2XL','X10M-2',-1,-1,'OVERLAY','ACTIVE','ELASTIC_SUBTYPE','CELL',NULL);
INSERT INTO ECS_ELASTIC_PLATFORM_INFO_TABLE (MODEL,SUPPORTED_SHAPES,MAXCOMPUTES,MAXCELLS,ILOMTYPE,SUPPORT_STATUS,FEATURE,HW_TYPE,OEDA_CODENAME)
VALUES('X10M-2L+LARGE','X10M-2+LARGE',-1,-1,'OVERLAY','ACTIVE','ELASTIC_SUBTYPE','COMPUTE',NULL);
INSERT INTO ECS_ELASTIC_PLATFORM_INFO_TABLE (MODEL,SUPPORTED_SHAPES,MAXCOMPUTES,MAXCELLS,ILOMTYPE,SUPPORT_STATUS,FEATURE,HW_TYPE,OEDA_CODENAME)
VALUES('X10M-2XL+EXTRALARGE','X10M-2+EXTRALARGE',-1,-1,'OVERLAY','ACTIVE','ELASTIC_SUBTYPE','COMPUTE',NULL);
COMMIT;
--[[caborbon_bug-38005893_END]]--

--[[pverma_bug-37542314_START]]--
ALTER table WF_TASKS_PROGRESS_STATUS_TABLE add INPUT clob;

PROMPT Creating editioning view on table WF_TASKS_PROGRESS_STATUS_TABLE
CREATE OR REPLACE EDITIONING VIEW WF_TASKS_PROGRESS_STATUS as select * from WF_TASKS_PROGRESS_STATUS_TABLE;

PROMPT Creating table WF_TASKS_USER_MESSAGES_TABLE
create table WF_TASKS_USER_MESSAGES_TABLE (
     WF_NAME varchar2(512) NOT NULL,
     WF_TASK_NAME varchar2(256) NOT NULL,
     USER_STEP_NAME varchar2(128) NOT NULL,
     INIT_MESSAGE varchar2(1024) DEFAULT 'INITIATING',
     INTERMEDIATE_MESSAGE varchar2(1024) DEFAULT 'PROCESSING',
     SUCCESS_MESSAGE varchar2(1024) DEFAULT 'COMPLETE',
     FAILURE_MESSAGE varchar2(1024) DEFAULT 'FAILED',
     CONSTRAINT pk_tasks_usrmsgs_table PRIMARY KEY (WF_NAME, WF_TASK_NAME)
);

PROMPT Creating editioning view on table WF_TASKS_USER_MESSAGES_TABLE
CREATE OR REPLACE EDITIONING VIEW WF_TASKS_USER_MESSAGES as select * from WF_TASKS_USER_MESSAGES_TABLE;

INSERT INTO ecs_properties (name, type, value, description) VALUES ('RENDER_PROGRESS_DETAILS', 'ECRA', 'ENABLED', 'Enable to populate progress details of supported WFs in status response');

commit;
--[[pverma_bug-37542314_END]]--

--[[ritikhan_bug-38051606_START]]--
PROMPT Altering table ECS_ACFS_TABLE
ALTER TABLE ECS_ACFS_TABLE ADD (acfs_reference_id varchar2(128));

PROMPT Replacing editioning view on table ECS_ACFS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_ACFS AS
SELECT
    acfs_name,
    acfs_ocid,
    size_gb,
    used_gb,
    db_vault_ocid,
    mount_path,
    vm_cluster_ocid,
    acfs_reference_id
FROM
    ECS_ACFS_TABLE;
COMMIT;
--[[ritikhan_bug-38051606_END]]--

--[[zpallare_bug-37864848_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ADBS_VAULT_NAME', 'ADBS', '', 'The vault name where adbs secrets are stored');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ADBS_COMPARTMENT_ID', 'ADBS', '', 'The compartment id where adbs secrets are stored');
COMMIT;
--[[zpallare_bug-37864848_END]]--

--[[illamas_bug-38029834_START]]--
update ecs_gold_specs_table set expected='196G' where exaunit_id=-1 and type='exacomputebasedb' and name='system';
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
COMMIT;
--[[illamas_bug-38029834_END]]--


--[[mpedapro_bug-38097735_START]]--
CREATE INDEX EXACC_CPSTUNER_PATCHES_EXAOCID_IDX on EXACC_CPSTUNER_PATCHES_TABLE(EXA_OCID);
CREATE INDEX EXACC_CPSTUNER_PATCHES_BUDID_IDX on EXACC_CPSTUNER_PATCHES_TABLE(BUG_ID);
CREATE INDEX EXACC_AVAILIMAGES_INFO_EXAOCID_IDX on EXACC_AVAILIMAGES_INFO_TABLE(EXA_OCID);
CREATE INDEX EXACC_AVAILIMAGES_INFO_BASEURI_IDX on EXACC_AVAILIMAGES_INFO_TABLE(BASE_URI);
CREATE INDEX EXACC_NODEIMG_VERSIONS_EXAOCID_IDX on EXACC_NODEIMG_VERSIONS_TABLE(EXA_OCID);
CREATE INDEX EXACC_NODEIMG_VERSIONS_NODE_IDX on EXACC_NODEIMG_VERSIONS_TABLE(NODE_NAME);
--[[mpedapro_bug-38097735_END]]--

--[[luperalt_bug-38026082_START]]--
ALTER TABLE ecs_oci_console_connection_table ADD IP varchar2(20);

CREATE OR REPLACE EDITIONING VIEW ecs_oci_console_connection AS
    SELECT
        ID,
        VMHOSTNAME,
        EXAUNITID,
        PORT,
        IP,
        DOM0,
        EXA_OCID,
        CREATED_AT
    FROM
        ecs_oci_console_connection_table;

--[[luperalt_bug-38026082_END]]--


--[[jzandate_bug-37990006_START]]--
PROMPT Altering ECS_EXAUNITDETAILS expand STORAGE column
ALTER TABLE ECS_EXAUNITDETAILS_TABLE MODIFY (STORAGE varchar2(16));
--[[jzandate_bug-37990006_END]]--

--[[jzandate_bug-38195488_START]]--
MERGE INTO ecs_registries
USING
    (SELECT 1 "one" FROM dual)
ON
    (ecs_registries.RACK_ID= 'exacompute' and ecs_registries.request_id='6dcf27a4-a277-45af-8e96-b5ae1190ea6e'
         and ecs_registries.operation='exacompute_volume_post')
WHEN NOT matched THEN
INSERT (rack_id, request_id, operation)
VALUES ('exacompute', '6dcf27a4-a277-45af-8e96-b5ae1190ea6e', 'exacompute_volume_post');
COMMIT;
--[[jzandate_bug-38195488_END]]--

--[[piyushsi_bug-38036035_START]]--
ALTER TABLE ecs_exacompute_entity_table add (sourceclusterid varchar2(256) default NULL);
CREATE OR REPLACE EDITIONING VIEW ecs_exacompute_entity AS
SELECT
       rack_name,
       cluster_id,
       cluster_name,
           atp,
           cells,
           cluster_vault,
           dom0_bonding,
           exaunit_allocations,
           grid_version,
           service_type,
           storage_type,
           volumes,
           servicesubtype,
           clustertype,
           sourceclusterid
FROM ecs_exacompute_entity_table;
--[[piyushsi_bug-38036035_END]]--

--[[hcheon_bug-38098570_START]]--
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXADATA_LOG_COLLECTION_FROM_ECRA', 'FEATURE', 'ENABLED', 'Collect Exadata logs from ECRA (LogScanner)');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXADATA_METRIC_COLLECTION_FROM_ECRA', 'FEATURE', 'ENABLED', 'Collect Exadata metrics from ECRA (PlgMon)');
--[[hcheon_bug-38098570_END]]--

--[[luperalt_bug-38115115_START]]--
PROMPT Altering ecs_oci_console_connection_table dropping constraint fk_console_exaunit to add delete cascade constraint
ALTER TABLE ecs_oci_console_connection_table DROP CONSTRAINT fk_console_exaunit;

PROMPT Altering ecs_oci_console_connection_table adding fk_console_exaunit to add delete cascade constraint
ALTER TABLE ecs_oci_console_connection_table
ADD CONSTRAINT fk_console_exaunit
FOREIGN KEY (EXAUNITID)
REFERENCES ECS_EXAUNITDETAILS_TABLE(EXAUNIT_ID)
ON DELETE CASCADE;
--[[luperalt_bug-38115115_END]]--
--[[zpallare_bug-38126851_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('PROVIDE_SITEGROUP_DETAILS', 'ADBS', 'DISABLED', 'Property to control sending the sitegroup information to exacloud during create service and add compute for ADBS flows.');
UPDATE ecs_properties_table SET name='ADBS_VAULT_ID' where name='ADBS_VAULT_NAME';
UPDATE ecs_properties_table SET description='The vault id where adbs secrets are stored' where name='ADBS_VAULT_ID';
COMMIT;
--[[zpallare_bug-38126851_END]]--

--[[nitishgu_bug-38131639_START]]--
UPDATE ecs_properties SET value='ENABLED' WHERE name='EXTENDED_CLUSTER_ID';
COMMIT;
--[[nitishgu_bug-38131639_END]]--

--[[pverma_bug-38049105_START]]--
ALTER TABLE wf_tasks_weights_table ADD operation VARCHAR2(128);
CREATE OR REPLACE EDITIONING VIEW WF_TASKS_WEIGHTS as select * from WF_TASKS_WEIGHTS_TABLE;
--[[pverma_bug-38049105_END]]--

--[[abyayada_bug-38137943_START]]--
ALTER TABLE ASYNC_CALLS_TABLE MODIFY TARGET_URI VARCHAR2(512);
--[[abyayada_bug-38137943_END]]--

--[[jvaldovi_bug_37985641_START]]--
-- Enh 37985641 - Exacs Ecra - Ecra To Configure Dbaas Tools Name Rpm Basd On Cloud Vendor
ALTER TABLE ECS_SITEGROUPS_TABLE ADD DBAASTOOLSRPM varchar2(100) DEFAULT 'dbaastools_exa_main.rpm';
ALTER TABLE ECS_SITEGROUPS_TABLE ADD DBAASTOOLSRPM_CHECKSUM varchar2(100);

PROMPT Recreating editioning views on table ECS_SITEGROUPS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_SITEGROUPS AS
    SELECT
        REGION,
        BUILDING,
        AD,
        ECRA_INFO_ID,
        NAME,
        RESTRICTED,
        CLOUD_VENDOR,
        CLOUD_PROVIDER_REGION,
        CLOUD_PROVIDER_BUILDING,
        CLOUD_PROVIDER_AZ,
        MTU,
        FAR_CHILD_SITE,
        OVERLAY_BRIDGE_USED,
        CONFIGURED_FEATURES,
        DBAASTOOLSRPM,
        DBAASTOOLSRPM_CHECKSUM
    FROM
        ECS_SITEGROUPS_TABLE;
--[[jvaldovi_bug_37985641_END]]--

--[[rothakk_bug-37901200_START]]--
UPDATE ecs_properties_table SET name='EXACS_VM_HISTORY_CONSOLE' where name='CONSOLE_HISTORY_OSS_BUCKETNAME';
--[[rothakk_bug-37901200_END]]--

--[[pverma_bug-38135459_START]]--
ALTER TABLE ecs_scheduled_ondemand_exec_table ADD jsonpayloadclob CLOB;
CREATE OR REPLACE EDITIONING VIEW ecs_scheduled_ondemand_exec AS SELECT * FROM ecs_scheduled_ondemand_exec_table;
--[[pverma_bug-38135459_END]]--


--[[anudatta_bug-38099034_START]]--
CREATE TABLE ecs_exaunit_real_hw_data_table (
    exaunit_id NUMBER NOT NULL,
    cluster_data CLOB NOT NULL,
    rackname VARCHAR2(256),
    last_updated_time_ts TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_ecs_exaunit_real_hw_data PRIMARY KEY (exaunit_id)
);

CREATE OR REPLACE EDITIONING VIEW ecs_exaunit_real_hw_data AS
SELECT
    exaunit_id,
    cluster_data,
    rackname,
    last_updated_time_ts
FROM
    ecs_exaunit_real_hw_data_table;
COMMIT;
--[[anudatta_bug-38099034_END]]--

--[[luperalt_bug-37980254_START]]--
PROMPT Altering ECS_EXAUNITDETAILS to add xs_backup_retention_num
ALTER TABLE ECS_EXAUNITDETAILS_TABLE ADD (XS_BACKUP_RETENTION_NUM number);

CREATE OR REPLACE EDITIONING VIEW ecs_exaunitdetails AS SELECT * FROM ecs_exaunitdetails_table;
--[[luperalt_bug-37980254_END]]--

--[[llmartin_bug-37468627_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ATTACHSTORAGE_SKIPRESIZE_DEFAULT_INPUT', 'ELASTIC', 'False', 'Default value in case skipresize key is not provided in the input payload for ExaCS attach storage');
commit;
--[[llmartin_bug-37468627_END]]--

--[[illamas_bug-38059350_START]]--
PROMPT Altering table ecs_gold_specs_table
ALTER TABLE ecs_gold_specs_table DROP CONSTRAINT chk_type;
ALTER TABLE ecs_gold_specs_table
    ADD CONSTRAINT chk_type
        CHECK (type IN ('exacs', 'adbd','adbs','exacsmvm','exacsminspec','exacsmvmminspec','adbdmvm','fa','exacsexacompute','exacc','exaccadbd','exaccmvm','exaccadbdmvm','exacsexacompute19c','exacomputebasedb','exacompute'));

INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacompute','domU','-1','kvm','filesystem','system','124G','','','','','','','false','all');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacompute','domU','-1','kvm','filesystem','/var','10G','','','','','','','false','all');
commit;
--[[illamas_bug-38059350_END]]--

--[[jzandate_bug-38313336_START]]--
UPDATE ECS_GOLD_SPECS_TABLE set EXPECTED='147G' where TYPE='exacompute' 
and TARGET_MACHINE='domU' and NETWORK_COMMUNICATION ='kvm' 
and VALIDATION_TYPE='filesystem' and NAME='system' and MODEL='all';

UPDATE ECS_GOLD_SPECS_TABLE set EXPECTED='6G' where TYPE='exacompute' 
and TARGET_MACHINE='domU' and NETWORK_COMMUNICATION ='kvm' 
and VALIDATION_TYPE='filesystem' and NAME='/var' and MODEL='all';

Insert into ECS_GOLD_SPECS_TABLE (EXAUNIT_ID,TYPE,TARGET_MACHINE,TARGET_MACHINE_NAME,
NETWORK_COMMUNICATION,VALIDATION_TYPE,NAME,EXPECTED,CURRENT_VALUE,COMMAND,ARGUMENTS,
EXPECTED_RETURN_CODE,CURRENT_RETURN_CODE,RESULT,MANDATORY,MODEL,MUTABLE)
values (-1,'exacompute','domU','-1','kvm','filesystem','/tmp','4G',null,null,null,null,null,null,'false','all','false');


commit;
--[[jzandate_bug-38313336_END]]--

--[[llmartin_bug-38035533_START]]--
create table ecs_exascale_ip_pool_table (
        ocid varchar2(512) not null,
        ip varchar2(16),
        ip_state varchar2(16) DEFAULT 'AVAILABLE',
        cabinet_name varchar2(256),
      CONSTRAINT ecs_oci_ip_pool_pk PRIMARY KEY(ocid)
);

CREATE OR REPLACE EDITIONING VIEW ecs_exascale_ip_pool AS
SELECT
        ocid,
        ip,
        ip_state,
        cabinet_name
FROM ecs_exascale_ip_pool_table;

alter table ECS_EXASCALE_NW_TABLE add IP_OCID varchar2(256);

CREATE OR REPLACE EDITIONING VIEW ECS_EXASCALE_NW AS
SELECT 
INFRA_OCID,
IP,
SUBNET,
NETMASK,
VLANID,
DOMAIN,
HOSTNAME,
PORT,
IP_OCID
FROM ECS_EXASCALE_NW_TABLE;
--[[llmartin_bug-38035533_END]]--

--[[illamas_bug-38173065_START]]--
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','sw','200G','','','','','','','true','all','true');
commit;
--[[illamas_bug-38173065_END]]--

--[[luperalt_bug-38173167_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('SCHEDULE_DBCS_PASSWORD_ROTATION', 'ECRA', 'ENABLED', 'Enable the schedule password rotation for the dbcs users, every 90 days');
commit;
--[[luperalt_bug-38173167_END]]--

--[[pverma_bug-38200926_START]]--
UPDATE ecs_exaservice_reserved_alloc_table SET reserve_type='all_operations' WHERE reserve_type IS NULL;
--[[pverma_bug-38200926_END]]--

--[[pverma_bug-38202766_START]]--
DELETE FROM WF_TASKS_WEIGHTS_TABLE;

PROMPT Inserting seed weights for tasks of create cluster WF
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PostGINID', 'ASYNC', 'REMOTE', 301, 'N', 33.98, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'FetchUpdatedXmlFromExacloud', 'ASYNC', 'REMOTE', 301, 'N', 25.13, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'CreateVM', 'ASYNC', 'REMOTE', 301, 'Y', 34.1, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PostCreateService', 'SYNC', 'LOCAL', 301, 'N', 3.21, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PreVMChecks', 'ASYNC', 'REMOTE', 301, 'Y', 31.07, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'EcraMetaDataUpdate', 'SYNC', 'LOCAL', 301, 'N', 1.71, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PostGIInstall', 'SYNC', 'REMOTE', 301, 'N', 35.03, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'SecretServiceTask', 'ASYNC', 'REMOTE', 301, 'N', 25.1, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'CertificateRotationTask', 'ASYNC', 'REMOTE', 301, 'N', 4, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'OCIExaccExacloudJSONCreation', 'SYNC', 'LOCAL', 291, 'N', 31.95, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'OCIExaccATPExacloudJSONCreation', 'SYNC', 'LOCAL', 10, 'N', 1.5, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'OciTfaBucket', 'ASYNC', 'REMOTE', 10, 'N', 32.6, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'CreateUser', 'ASYNC', 'REMOTE', 301, 'N', 29.17, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PostVMInstall', 'ASYNC', 'REMOTE', 301, 'Y', 32.2, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'CreateStorage', 'ASYNC', 'REMOTE', 301, 'N', 33.05, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PreVMSetup', 'ASYNC', 'REMOTE', 301, 'Y', 32.8, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'InstallCluster', 'ASYNC', 'REMOTE', 301, 'N', 32.41, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'SyncOHSpace', 'ASYNC', 'REMOTE', 291, 'N', 0.41, 1, 'create-service');

PROMPT Inserting seed weights for tasks of delete cluster WF
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'PostGINID', 'ASYNC', 'REMOTE', 158, 'N', 30.58, 10, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'CreateVM', 'ASYNC', 'REMOTE', 158, 'Y', 35.33, 10, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'PreDeleteService', 'SYNC', 'LOCAL', 158, 'N', 0.67, 1, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'PostDeleteService', 'SYNC', 'LOCAL', 158, 'N', 1.82, 1, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'PostGIInstall', 'ASYNC', 'REMOTE', 158, 'N', 28.75, 10, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'CreateUser', 'ASYNC', 'REMOTE', 158, 'N', 32.55, 10, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'PostVMInstall', 'ASYNC', 'REMOTE', 158, 'N', 34.56, 10, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'CreateStorage', 'ASYNC', 'REMOTE', 158, 'N', 34.1, 10, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'InstallCluster', 'ASYNC', 'REMOTE', 158, 'N', 38.22, 10, 'delete-pod');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('delete-service-wfd', 'PreVMSetup', 'ASYNC', 'REMOTE', 158, 'N', 29.84, 10, 'delete-pod');


PROMPT Inserting seed weights for tasks of add/remove node WF for CC
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CreateEcJsonForCluNodelistUpdate', 'SYNC', 'LOCAL', 27, 'N', 0.94, 1, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'FetchUpdatedXmlFromECForNodelistUpdate', 'ASYNC', 'REMOTE', 27, 'N', 28.23, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPreCreateVMTask', 'ASYNC', 'REMOTE', 6, 'N', 35.8, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddCreateGuestTask', 'ASYNC', 'REMOTE', 6, 'N', 45.3, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddCreateUsersTask', 'ASYNC', 'REMOTE', 6, 'N', 20.55, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddCheckCellConnectivityTask', 'ASYNC', 'REMOTE', 6, 'N', 31.09, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddConfigCrsTask', 'ASYNC', 'REMOTE', 6, 'N', 17.59, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddRunRootTask', 'ASYNC', 'REMOTE', 6, 'N', 40.59, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostCreateVMTask', 'ASYNC', 'REMOTE', 6, 'N', 20.91, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostCluInstallTask', 'ASYNC', 'REMOTE', 6, 'N', 50.46, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostGiInstallTask', 'ASYNC', 'REMOTE', 6, 'N', 35.96, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostGiNidTask', 'ASYNC', 'REMOTE', 6, 'N', 31.65, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPreDbInstallTask', 'ASYNC', 'REMOTE', 6, 'N', 31.32, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostTask', 'ASYNC', 'REMOTE', 6, 'N', 38.21, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePreDbDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 36.24, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemoveDbDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 43.3, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostDbDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 39.66, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePreGiDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 29.93, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemoveGiDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 34.41, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostGiDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 36.97, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePreVmDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 31.96, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemoveVmDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 34.42, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostVmDeleteTask', 'ASYNC', 'REMOTE', 21, 'N', 24.47, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostTask', 'ASYNC', 'REMOTE', 21, 'N', 26.12, 10, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'RotateDBCSAgentPasswords', 'SYNC', 'LOCAL', 27, 'N', 0.76, 1, 'reshape-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'DoPostClusNodeListUpdate', 'SYNC', 'LOCAL', 27, 'N', 3.11, 1, 'reshape-service');

PROMPT Inserting seed weights for tasks of update cores WF
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-corePerNode', 'PrepareCoreReshapeInput', 'SYNC', 'LOCAL', 20, 'N', 1.07, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-corePerNode', 'ResumeOnReshape', 'ASYNC', 'REMOTE', 1, 'N', 56.25, 10, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-corePerNode', 'PostReshapeServiceTask', 'SYNC', 'LOCAL', 20, 'N', 1.21, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-corePerNode', 'CluNodesValidatePing', 'SYNC', 'REMOTE', 1, 'N', 1.66, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-corePerNode', 'InvokeExacloudForReshapeOperation', 'ASYNC', 'REMOTE', 20, 'N', 28.04, 10, 'reshape-service:update-service');

PROMPT Inserting seed weights for tasks of update memory WF
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-memoryGbPerNode', 'PrepareMemoryReshapeInput', 'SYNC', 'LOCAL', 20, 'Y', 0.21, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-memoryGbPerNode', 'PostReshapeServiceTask', 'SYNC', 'LOCAL', 20, 'Y', 0.3, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-memoryGbPerNode', 'InvokeExacloudForReshapeOperation', 'ASYNC', 'REMOTE', 20, 'Y', 25.57, 10, 'reshape-service:update-service');

PROMPT Inserting seed weights for tasks of update ASM storage WF
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-storageGb', 'PrepareStorageReshapeInput', 'SYNC', 'LOCAL', 20, 'N', 0.22, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-storageGb', 'PostReshapeServiceTask', 'SYNC', 'LOCAL', 20, 'N', 0.3, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-storageGb', 'InvokeExacloudForReshapeOperation', 'ASYNC', 'REMOTE', 20, 'N', 400, 100, 'reshape-service:update-service');

PROMPT Inserting seed weights for tasks of update oracle home WF
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-ohomeSizeGbPerNode', 'PrepareOHomeReshapeInput', 'SYNC', 'LOCAL', 20, 'Y', 0.23, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-ohomeSizeGbPerNode', 'PostReshapeServiceTask', 'SYNC', 'LOCAL', 20, 'Y', 0.36, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-ohomeSizeGbPerNode', 'InvokeExacloudForReshapeOperation', 'ASYNC', 'REMOTE', 20, 'Y', 22.28, 10, 'reshape-service:update-service');

PROMPT Inserting seed weights for tasks of update filesystems WF
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-filesystemsPerNode', 'PrepareFilesystemsReshapeInput', 'SYNC', 'LOCAL', 20, 'Y', 0.22, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-filesystemsPerNode', 'PostReshapeServiceTask', 'SYNC', 'LOCAL', 20, 'Y', 0.37, 1, 'reshape-service:update-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('reshape-service-wfd-filesystemsPerNode', 'InvokeExacloudForReshapeOperation', 'ASYNC', 'REMOTE', 20, 'Y', 25.92, 10, 'reshape-service:update-service');

PROMPT Inserting seed weights for tasks of add storage server(s) WF on CC
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'PrepareCellAdd', 'SYNC', 'LOCAL', 44, 'N', 0.25, 1, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'PreChecks', 'ASYNC', 'REMOTE', 44, 'N', 30, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'InitialRebalancing', 'ASYNC', 'REMOTE', 44, 'N', 35, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'SaveDGSizes', 'ASYNC', 'REMOTE', 44, 'N', 30, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'ConfigCell', 'ASYNC', 'REMOTE', 44, 'N', 50, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'CreateGriddisks', 'ASYNC', 'REMOTE', 44, 'N', 60, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'AddDisksToAsm', 'ASYNC', 'REMOTE', 44, 'N', 290, 50, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'WaitForRebalancing', 'ASYNC', 'REMOTE', 44, 'N', 3000, 400, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'SyncupCells', 'ASYNC', 'REMOTE', 44, 'N', 41, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'ResizeDGSizes', 'ASYNC', 'REMOTE', 44, 'N', 70, 50, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'PostAddCellCheck', 'ASYNC', 'REMOTE', 44, 'N', 34, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-wfd', 'PostAttachCellTask', 'ASYNC', 'LOCAL', 44, 'N', 2.5, 1, 'capacity_tenant_attcells');


PROMPT Inserting seed weights for tasks of add storage server(s) WF on CS
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'PrepareReshape', 'SYNC', 'LOCAL', 44, 'N', 0.25, 1, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'PreChecks', 'ASYNC', 'REMOTE', 44, 'N', 30, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'InitialRebalancing', 'ASYNC', 'REMOTE', 44, 'N', 35, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'SaveDGSizes', 'ASYNC', 'REMOTE', 44, 'N', 30, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'ConfigCell', 'ASYNC', 'REMOTE', 44, 'N', 50, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'CreateGriddisks', 'ASYNC', 'REMOTE', 44, 'N', 60, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'AddDisksToAsm', 'ASYNC', 'REMOTE', 44, 'N', 290, 50, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'WaitForRebalancing', 'ASYNC', 'REMOTE', 44, 'N', 3000, 400, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'SyncupCells', 'ASYNC', 'REMOTE', 44, 'N', 41, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'ResizeDGSizes', 'ASYNC', 'REMOTE', 44, 'N', 70, 50, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'PostAddCellCheck', 'ASYNC', 'REMOTE', 44, 'N', 34, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'CreateSpecs', 'ASYNC', 'LOCAL', 44, 'N', 5, 1, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'FetchElasticXML', 'ASYNC', 'REMOTE', 44, 'N', 15, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'SanityCheck', 'ASYNC', 'REMOTE', 44, 'N', 60, 15, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-wfd', 'UpdateMetadata', 'ASYNC', 'LOCAL', 44, 'N', 2.5, 1, 'capacity_tenant_attcells');

PROMPT Deleting existing user messages for all WFs
DELETE FROM WF_TASKS_USER_MESSAGES_TABLE;

PROMPT Altering column size for USER_STEP_NAME in WF_TASKS_USER_MESSAGES_TABLE
ALTER TABLE WF_TASKS_USER_MESSAGES_TABLE MODIFY (USER_STEP_NAME VARCHAR2(256));

PROMPT Rebuilding editioning view WF_TASKS_USER_MESSAGES from WF_TASKS_USER_MESSAGES_TABLE
CREATE OR REPLACE EDITIONING VIEW WF_TASKS_USER_MESSAGES as select * from WF_TASKS_USER_MESSAGES_TABLE;

PROMPT Inserting user messages for create service WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PostGINID', 'Creating ASM Disk groups');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'FetchUpdatedXmlFromExacloud', 'Creating the required XML configuration needed to provision the VM cluster on the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'CreateVM', 'Creating Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PostCreateService', 'Updating metadata of the VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PreVMChecks', 'Checking the health of the compute and storage servers');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'EcraMetaDataUpdate', 'Creating metadata of the VM cluster on the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PostGIInstall', 'Installing custom RPMs and hardening security');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'SecretServiceTask', 'Applying secret service rules for the VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'CertificateRotationTask', 'Rotating DBCS certificates');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'OCIExaccExacloudJSONCreation', 'Creating JSON payload for VM cluster provisioning');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'OCIExaccATPExacloudJSONCreation', 'Creating JSON payload for VM cluster provisioning');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'OciTfaBucket', 'Creating TFA bucket for the VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'CreateUser', 'Creating the service users (opc, oracle and grid) on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PostVMInstall', 'Creating NAT Iptable rules');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'CreateStorage', 'Creating the cell and grid disks for the VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PreVMSetup', 'Creating the disk images on the compute servers');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'InstallCluster', 'Installing the clusterware software on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'SyncOHSpace', 'Synchronizing the space utilization of the /u02 filesystem');


PROMPT Inserting user messages for delete service WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'PostGINID', 'Deleting ASM disk groups');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'CreateVM', 'Deleting Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'PreDeleteService', 'Creating JSON payload for VM cluster deletion');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'PostDeleteService', 'Updating metadata of the deleted VM cluster on the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'PostGIInstall', 'Uninstalling custom RPMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'CreateUser', 'Deleting the service users (opc, oracle, and grid) on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'PostVMInstall', 'Deleting the Guest VM images');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'CreateStorage', 'Deleting the grid disks for the VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'InstallCluster', 'Uninstalling the clusterware software on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('delete-service-wfd', 'PreVMSetup', 'Cleaning the backup and gold images from the compute servers');

PROMPT Inserting user messages for update nodelist WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CreateEcJsonForCluNodelistUpdate', 'Creating JSON payload for adding/deleting VM cluster nodes');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'FetchUpdatedXmlFromECForNodelistUpdate', 'Building metadata of the updated VM cluster on the Exadata cloud platform for adding/deleting VM cluster nodes');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPreCreateVMTask', 'Checking the health of the compute servers to add/remove node');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddCreateGuestTask', 'Creating Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddCreateUsersTask', 'Creating the service users (opc, oracle, and grid) on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddCheckCellConnectivityTask', 'Checking the connectivity to the storage servers');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddConfigCrsTask', 'Installing the clusterware software on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddRunRootTask', 'Initializing the clusterware software on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostCreateVMTask', 'Creating NAT Iptable rules');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostCluInstallTask', 'Installing custom RPMs ');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostGiInstallTask', 'Hardening the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostGiNidTask', 'Creating ASM disk groups for the Guest VM');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPreDbInstallTask', 'Syncing DB Home and  creating the database instance on the Guest VM ');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeAddPostTask', 'Updating metadata of the VM cluster on the Exadata cloud platform after VM node addition/deletion');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePreDbDeleteTask', 'Preparing to delete the database instance');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemoveDbDeleteTask', 'Deleting the database instance');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostDbDeleteTask', 'Cleaning up the database instance metadata on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePreGiDeleteTask', 'Preparing to uninstall the clusterware software on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemoveGiDeleteTask', 'Uninstalling the clusterware software on the Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostGiDeleteTask', 'Uninstalling custom RPMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePreVmDeleteTask', 'Preparing to delete the Guest VM');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemoveVmDeleteTask', 'Deleting Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostVmDeleteTask', 'Removing the VM cluster configuration from the compute servers');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'CluNodeRemovePostTask', 'Updating metadata of the deleted VM cluster on the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'RotateDBCSAgentPasswords', 'Rotating the DBCS agent passwords');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('update_cc_clu_nodelist_stepwise-wfd', 'DoPostClusNodeListUpdate', 'Updating metadata of the VM cluster on the Exadata cloud platform after Guest VM creation/deletion');


PROMPT Inserting user messages for update cores WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-corePerNode', 'PrepareCoreReshapeInput', 'Creating JSON payload for updating cores on the VM cluster Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-corePerNode', 'ResumeOnReshape', 'Starting the Guest VMs to resize to the new core count');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-corePerNode', 'PostReshapeServiceTask', 'Updating metadata of the VM cluster on the Exadata cloud platform to reflect the new core count');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-corePerNode', 'CluNodesValidatePing', 'Validating the status of the VM cluster Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-corePerNode', 'InvokeExacloudForReshapeOperation', 'Executing Exadata cloud process to perform the core update on the VM cluster nodes');


PROMPT Inserting user messages for update memory WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-memoryGbPerNode', 'memoryGbPerNode', 'Creating JSON payload for updating memory allocation on the VM cluster Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-memoryGbPerNode', 'PostReshapeServiceTask', 'Updating metadata of the VM cluster on the Exadata cloud platform to reflect the new memory allocation');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-memoryGbPerNode', 'InvokeExacloudForReshapeOperation', 'Executing Exadata cloud process to perform the memory update on the VM cluster nodes');

PROMPT Inserting user messages for update ASM storage WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-storageGb', 'storageGb', 'Creating JSON payload for updating ASM storage allocation on the VM cluster Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-storageGb', 'PostReshapeServiceTask', 'Updating metadata of the VM cluster on the Exadata cloud platform to reflect the new ASM storage allocation');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-storageGb', 'InvokeExacloudForReshapeOperation', 'Executing Exadata cloud process to perform the ASM storage allocation update on the VM cluster');

PROMPT Inserting user messages for update Oracle home WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-ohomeSizeGbPerNode', 'PrepareOHomeReshapeInput', 'Creating JSON payload for updating Oracle home filesystem(/u02) allocation on the VM cluster Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-ohomeSizeGbPerNode', 'PostReshapeServiceTask', 'Updating metadata of the VM cluster on the Exadata cloud platform to reflect the new Oracle home filesystem(/u02) allocation');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-ohomeSizeGbPerNode', 'InvokeExacloudForReshapeOperation', 'Executing Exadata cloud process to perform the Oracle home filesystem(/u02) allocation update on the VM cluster nodes');

PROMPT Inserting user messages for update filesystems WF
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-filesystemsPerNode', 'PrepareFilesystemsReshapeInput', 'Creating JSON payload for updating OS filesystems allocation on the VM cluster Guest VMs');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-filesystemsPerNode', 'PostReshapeServiceTask', 'Updating metadata of the VM cluster on the Exadata cloud platform to reflect the new OS filesystems allocation');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('reshape-service-wfd-filesystemsPerNode', 'InvokeExacloudForReshapeOperation', 'Executing Exadata cloud process to perform the OS filesystems allocation update on the VM cluster nodes');

PROMPT Inserting user messages for attach cell WF on CC
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'PrepareCellAdd', 'Creating JSON payload for adding storage server(s) to VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'PreChecks', 'Validating new storage server(s) for health and reachability');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'InitialRebalancing', 'Checking for ongoing diskgroup rebalance operations before initiating addition of storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'SaveDGSizes', 'Saving current sizes of VM cluster diskgroups before initiating addition of storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'ConfigCell', 'Configuring the new cell server(s) for participation in the VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'CreateGriddisks', 'Creating griddisks for each of the diskgroups of the VM cluster on new storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'AddDisksToAsm', 'Adding created griddisks to respective diskgroups in ASM');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'WaitForRebalancing', 'Waiting for rebalacing of diskgroups to complete after addition of storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'SyncupCells', 'Syncing up cell state to the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'ResizeDGSizes', 'Restoring ASM storage allocation for the VM cluster to original value');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'PostAddCellCheck', 'Validating griddisk configuration on storage server(s) after addition');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-wfd', 'PostAttachCellTask', 'Updating metadata of the Exadata infrastructure and VM cluster on the Exadata cloud platform to reflect the new storage server(s)');

PROMPT Inserting user messages for attach cell WF on CS
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'PrepareReshape', 'Creating JSON payload for adding storage server(s) to VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'PreChecks', 'Validating new storage server(s) for health and reachability');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'InitialRebalancing', 'Checking for ongoing diskgroup rebalance operations before initiating addition of storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'SaveDGSizes', 'Saving current sizes of VM cluster diskgroups before initiating addition of storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'ConfigCell', 'Configuring the new cell server(s) for participation in the VM cluster');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'CreateGriddisks', 'Creating griddisks for each of the diskgroups of the VM cluster on new storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'AddDisksToAsm', 'Adding created griddisks to respective diskgroups in ASM');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'WaitForRebalancing', 'Waiting for rebalacing of diskgroups to complete after addition of storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'SyncupCells', 'Syncing up cell state to the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'ResizeDGSizes', 'Restoring ASM storage allocation for the VM cluster to original value');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'PostAddCellCheck', 'Validating griddisk configuration on storage server(s) after addition');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'CreateSpecs', 'Creating Exadata cloud platform specification for adding storage server(s) based on model and size');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'FetchElasticXML', 'Creating Exadata XML for the VM cluster with new storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'SanityCheck', 'Checking diskgroups states before adding storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-wfd', 'UpdateMetadata', 'Updating metadata of the Exadata infrastructure and VM cluster on the Exadata cloud platform to reflect the new storage server(s)');

commit;
--[[pverma_bug-38202766_END]]--

--[[rgmurali_bug-38237159_START]]--
ALTER TABLE ecs_hardware_table ADD virtual_functions NUMBER;

UPDATE ecs_hardware_table set virtual_functions=48 where model in ('X8M-2', 'X9M-2') and racksize='ELASTIC' and env='bm';
UPDATE ecs_hardware_table set virtual_functions=80 where model = 'X11M' and racksize='ELASTIC' and env='bm';
PROMPT Recreating editioning views on table ecs_hardware_table
CREATE OR REPLACE EDITIONING VIEW ecs_hardware AS
SELECT
    MODEL,
    RACKSIZE,
    MINCORESPERNODE,
    MAXCORESPERNODE,
    MEMSIZE,
    TBSTORAGE,
    MAXRACKS,
    TAGS,
    RACKTYPE_CODE,
    DESCRIPTION,
    GBCLIENTNETSPEED,
    GBROCENETSPEED,
    ECPUFACTOR,
    ENV,
    VIRTUAL_FUNCTIONS
FROM
    ecs_hardware_table;

CREATE OR REPLACE VIEW ecs_hardware_filtered AS
SELECT
    MODEL,
    RACKSIZE,
    MINCORESPERNODE,
    MAXCORESPERNODE,
    MEMSIZE,
    TBSTORAGE,
    MAXRACKS,
    TAGS,
    RACKTYPE_CODE,
    DESCRIPTION,
    GBCLIENTNETSPEED,
    GBROCENETSPEED,
    ECPUFACTOR,
    ENV,
    VIRTUAL_FUNCTIONS
FROM
    ECS_HARDWARE
WHERE
    ENV = (SELECT NVL((SELECT VALUE FROM ECS_PROPERTIES WHERE NAME = 'ECRA_ENV' AND ROWNUM = 1),'bm') FROM DUAL);
commit;
--[[rgmurali_bug-38237159_END]]--

--[[ritikhan_bug-38239610_START]]--
PROMPT Altering table ECS_ACFS_TABLE
ALTER TABLE ECS_ACFS_TABLE ADD (mount_state varchar2(128));

PROMPT Replacing editioning view on table ECS_ACFS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_ACFS AS
SELECT
    acfs_name,
    acfs_ocid,
    size_gb,
    used_gb,
    db_vault_ocid,
    mount_path,
    vm_cluster_ocid,
    acfs_reference_id,
    mount_state
FROM
    ECS_ACFS_TABLE;
--[[ritikhan_bug-38239610_END]]--

--[[zpallare_bug-38205599_START]]--
ALTER TABLE ecs_exaunitdetails_table ADD diskgroupsallocation VARCHAR2(100);
CREATE OR REPLACE EDITIONING VIEW ecs_exaunitdetails AS SELECT * FROM ecs_exaunitdetails_table;
UPDATE ecs_exaunitdetails_table SET backup_disk='Y' WHERE LOWER(backup_disk) = 'yes';
UPDATE ecs_exaunitdetails_table SET backup_disk='Y' WHERE LOWER(backup_disk) = 'true';
UPDATE ecs_exaunitdetails_table SET diskgroupsallocation='80:20:0' WHERE LOWER(backup_disk) != 'y' AND LOWER(create_sparse) != 'true';
UPDATE ecs_exaunitdetails_table SET diskgroupsallocation='35:50:15' WHERE LOWER(backup_disk) = 'y' AND LOWER(create_sparse) = 'true';
UPDATE ecs_exaunitdetails_table SET diskgroupsallocation='60:20:20' WHERE LOWER(backup_disk) != 'y' AND LOWER(create_sparse) = 'true';
UPDATE ecs_exaunitdetails_table SET diskgroupsallocation='40:60:0' WHERE LOWER(backup_disk) = 'y' AND LOWER(create_sparse) != 'true';
COMMIT;
--[[zpallare_bug-38205599_END]]--


--[[bshenoy_bug-38171776_START]]--
ALTER TABLE ecs_rocefabric_table ADD (X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS_TMP varchar2(10));
update ecs_rocefabric_table SET X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS_TMP = X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS;
alter TABLE ecs_rocefabric_table drop column X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS;
alter TABLE ecs_rocefabric_table rename column X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS_TMP to X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS;

CREATE OR REPLACE EDITIONING VIEW ecs_rocefabric AS 
    SELECT * FROM  ecs_rocefabric_table;
commit;
--[[bshenoy_bug-38171776_END]]--

--[[zpallare_bug-36651275_START]]--
ALTER TABLE ecs_temp_domus_table ADD subnetid VARCHAR2(256);
CREATE OR REPLACE EDITIONING VIEW ecs_temp_domus AS SELECT * FROM ecs_temp_domus_table;

ALTER TABLE ecs_oci_subnets_table ADD gateway VARCHAR2(64);
ALTER TABLE ecs_oci_subnets_table ADD netmask VARCHAR2(64);
ALTER TABLE ecs_oci_subnets_table DROP CONSTRAINT ck_ecs_oci_subnets_type;
ALTER TABLE ecs_oci_subnets_table ADD  CONSTRAINT ck_ecs_oci_subnets_type
      CHECK (subnettype in ('CLIENT', 'ADMIN', 'BACKUP', 'MVM_ADMINSUBNET'));
CREATE OR REPLACE EDITIONING VIEW ecs_oci_subnets AS SELECT * FROM ecs_oci_subnets_table;
--[[zpallare_bug-36651275_END]]--


--[[bshenoy_bug-38173717_START]]--
UPDATE ecs_properties_table SET value=-1 where name='X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS';
UPDATE ecs_properties_table SET value=-1 where name='X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS';
UPDATE ecs_properties_table SET value=-1 where name='X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS';
UPDATE ecs_properties_table SET value=-1 where name='X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS';
COMMIT;
--[[bshenoy_bug-38173717_END]]--

--[[jreyesm_bug-38347884_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('EXACOMPUTE_MAX_ALLOWED_SLOTS', 'EXACOMPUTE', '63', 'Maximum number of guests allowed per dom0 for exadbxs service');
COMMIT;
--[[jreyesm_bug-38347884_END]]--

--[[jiacpeng_EXACS-158502_START]]--
INSERT INTO ecs_properties_table (name, type, value) VALUES ('TOPOLOGY_HEAP_SAFETY_FACTOR', 'TOPOLOGY', '3.0');
COMMIT;
--[[jiacpeng_EXACS-158502_END]]--

--[[jiacpeng_exacs-159317_START]]--
INSERT INTO ecs_properties_table (name, type, value) VALUES ('TOPOLOGY_PAGINATION_MAX_RACK_COUNT', 'TOPOLOGY', '200');
COMMIT;
--[[jiacpeng_exacs-159317_END]]--

--[[essharm_bug-37249099_START]]--
INSERT INTO ecs_properties_table (name, type, value) VALUES ('ECRA_SSV2_CERT_PATH', 'ECRA' , '');
COMMIT;
--[[essharm_bug-37249099_END]]--

--[[abyayada_bug-37692082_START]]--
ALTER TABLE ecs_exascale_vaults_table MODIFY TYPE VARCHAR2(8);
ALTER TABLE ecs_exascale_vaults_table MODIFY VAULT_ECRA_ID VARCHAR2(64);
CREATE OR REPLACE EDITIONING VIEW ecs_exascale_vaults AS SELECT * FROM ecs_exascale_vaults_table;
--[[abyayada_bug-37692082_END]]--
--[[piyushsi_bug-37977022_START]]--
PROMPT Creating table ecra_lb_backend_info_table
CREATE TABLE ecra_lb_backend_info_table (
    servername              VARCHAR2(100) PRIMARY KEY,
    backendsetname      VARCHAR2(100),
    backendname            VARCHAR2(100),
    backup                        VARCHAR2(10),
    drain                            VARCHAR2(10) ,
    ipaddress                   VARCHAR2(45), 
    name                          VARCHAR2(100),
    lboffline                         VARCHAR2(10) ,
    port                             NUMBER(5),
    weight                         NUMBER(5)
);  

CREATE OR REPLACE EDITIONING VIEW ecra_lb_backend_info AS
SELECT
    servername,
    backendsetname,
    backendname,
    backup,
    drain,
    ipaddress,
    name,
    lboffline,
    port,
    weight
FROM ecra_lb_backend_info_table;

INSERT INTO ecs_properties (name, type, value, description) VALUES ('CURRENT_ACTIVE_BACKEND', 'ECRA', '', 'Current Active BackendSet Infor');
COMMIT;
--[[piyushsi_bug-37977022_END]]--

--[[pverma_jira_EXACS-156569_START]]--
ALTER TABLE ECS_ERROR_TABLE ADD INT_RETRY_COUNT NUMBER;
CREATE OR REPLACE EDITIONING VIEW ECS_ERROR as select * from ECS_ERROR_TABLE;
--[[pverma_jira_EXACS-156569_END]]--

--[[abysebas_bug-37765661_START]]--
INSERT INTO ecs_properties_table (name, type, value) values ('POWER_SAVING_FREE_NODE_MODE', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties_table (name, type, value) values ('POWER_SAVING_CPU_CORE_MODE', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties_table (name, type, value) values ('FREE_NODE_THRESHOLD', 'ECRA', '80');

PROMPT Creating table ecs_power_saving_metrics_table;
CREATE TABLE ecs_power_saving_metrics_table (
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    qfab_id VARCHAR2(100) NOT NULL,
    node_name VARCHAR2(100) NOT NULL,
    total_duration_minutes NUMBER,
    avg_watts_saved NUMBER,
    powered_off_start_time TIMESTAMP,
    powered_off_end_time TIMESTAMP,
    powered_off_core_count NUMBER
);

PROMPT Creating editioning view on ecs_power_saving_metrics_table;
CREATE OR REPLACE EDITIONING VIEW ecs_power_saving_metrics AS
SELECT
    id,
    qfab_id,
    node_name,
    total_duration_minutes,
    avg_watts_saved,
    powered_off_start_time,
    powered_off_end_time,
    powered_off_core_count
FROM ecs_power_saving_metrics_table;

PROMPT Creating ecs_power_saving_config_table;
CREATE TABLE ecs_power_saving_config_table (
    qfab_id VARCHAR2(100) NOT NULL,
    feature_name VARCHAR2(100) NOT NULL,
    feature_status VARCHAR2(100),
    feature_attributes VARCHAR2(4000),
    override_freenodes_threshold NUMBER,
    override_freecellnodes_threshold NUMBER,
    override_freecomputenodes_threshold NUMBER,
    CONSTRAINT pk_ecs_power_saving PRIMARY KEY (qfab_id, feature_name)
);

PROMPT Creating editioning view on ecs_power_saving_config_table;
CREATE OR REPLACE EDITIONING VIEW ecs_power_saving_config AS
SELECT
    qfab_id,
    feature_name,
    feature_status,
    feature_attributes,
    override_freenodes_threshold,
    override_freecellnodes_threshold,
    override_freecomputenodes_threshold
FROM ecs_power_saving_config_table;

CREATE OR REPLACE VIEW ecs_node_fabric_view AS
SELECT
    n.oracle_hostname   AS node_name,
    rf.fabric_name      AS fabric_name,
    n.node_state        AS node_state,
    n.node_model        AS node_model,
    n.node_type         AS node_type
FROM
    ecs_hw_nodes n
JOIN
    ecs_ib_fabrics ibf ON n.ib_fabric_id = ibf.id
JOIN
    ecs_rocefabric rf ON ibf.fabric_name = rf.fabric_name;

commit;
--[[abysebas_bug-37765661_END]]--

--[[jvaldovi_bug-38175493_START]]--
ALTER TABLE ecs_exaunitdetails_table ADD fs_encryption_data varchar2(1024);

CREATE OR REPLACE EDITIONING VIEW ecs_exaunitdetails AS SELECT * FROM ecs_exaunitdetails_table;
--[[jvaldovi_bug-38175493_END]]--

--[[luperalt_bug-38347020_START]]--
ALTER TABLE ecs_oci_exa_info_table ADD sar_json CLOB;
CREATE OR REPLACE EDITIONING VIEW ecs_oci_exa_info as SELECT * FROM ecs_oci_exa_info_table;
--[[luperalt_bug-38347020_END]]--


--[[kanmanic_bug-38325041_START]]--
ALTER TABLE ecs_analytics_table ADD (requestid VARCHAR2(256));

CREATE OR REPLACE EDITIONING VIEW ecs_analytics AS
SELECT
    id,
    clusterocid,
    ceiocid,
    customerName,
    data,
    exaunitId,
    end_time,
    idemtoken,        
    operation,
    payload,
    requestid,
    rackName,
    start_time_ts,
    start_time,
    status
FROM
    ecs_analytics_table;

COMMIT;
--[[kanmanic_bug-38325041_END]]--


--[[caborbon_bug-38372390_START]]--
ALTER TABLE ecs_hw_cabinets_table
ADD ELASTIC_FLEX CHAR(1) DEFAULT 'N' NOT NULL;

PROMPT Creating editioning view on ecs_hw_cabinets_table;
CREATE OR REPLACE EDITIONING VIEW ecs_hw_cabinets AS
  SELECT
        ID,
        NAME,
        AVAILABILITY_DOMAIN,
        FAULT_DOMAIN,
        CAGE_ID,
        MODEL,
        CLUSTER_SIZE_CONSTRAINT,
        TIME_ZONE,
        DOMAINNAME,
        SUBNET_ID,
        PRODUCT,
        GENERATION_TYPE,
        STATUS,
        XML,
        CANONICAL_BUILDING,
        BLOCK_NUMBER,
        SERIAL_NUMBER,
        PREVIOUS_STATUS,
        LAUNCHNODE,
        MVM_DOMAINNAME,
        MVM_SUBNET_ID,
        ETH0,
        CANONICAL_ROOM,
        COMPUTE_AVAILABILITY,
        CELL_AVAILABILITY,
        STATUS_COMMENT,
        SITEGROUP,
        AUTO_MAINTENANCE,
        OPSTATE,
        ADMIN_ACTIVE_VNIC,
        ADMIN_STANDBY_VNIC,
        SUBNET_OCID,
        ELASTIC_FLEX
    FROM
        ECS_HW_CABINETS_TABLE;

COMMIT;
--[[caborbon_bug-38372390_END]]--
--[[araghave_bug-38114577_START]]--

-- Property to set the PatchSwitchType value used to perform switch patching
INSERT INTO ecs_properties (name, type, value) VALUES ('PATCH_SWITCH_TYPE', 'PATCHING', 'rocespine');
COMMIT;

--[[araghave_bug-38114577_END]]--

--[[zpallare_bug-38390977_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ADBS_INSERT_KEYS', 'ADBS', 'DISABLED', 'Property to enable/disable key insertion flow for ADBS.');
COMMIT;
--[[zpallare_bug-38390977_END]]--


--[[piyushsi_bug-38327862_START]]--
CREATE TABLE ecra_wf_recovery_catalog_table (
    starttime       VARCHAR(64)      NOT NULL,
    wfuuid          VARCHAR(64)    NOT NULL,
    lasttaskname    VARCHAR(128)   NOT NULL,
    lastoperationid VARCHAR(64),
    lasttaskstatus  VARCHAR(32),
    operation       VARCHAR(64),
    wfname          VARCHAR(128),
    servername      VARCHAR(128),
    action          VARCHAR(64),
    result          VARCHAR(256),
    status          VARCHAR(256),
    CONSTRAINT pk_ecra_wf_recovery_catalog PRIMARY KEY (starttime, wfuuid, lasttaskname)
);

PROMPT Creating editioning view on ecra_wf_recovery_catalog_table;
CREATE OR REPLACE EDITIONING VIEW ecra_wf_recovery_catalog AS
SELECT
    starttime,
    wfuuid,
    lasttaskname,
    lastoperationid,
    lasttaskstatus,
    operation,
    wfname,
    servername,
    action,
    result,
    status
FROM ecra_wf_recovery_catalog_table;
COMMIT;
--[[piyushsi_bug-38327862_END]]--

--[[aypaul_bug-38190216_START]]--
DECLARE
  v_current_selinuxstatus VARCHAR(128);
  v_selinux_status VARCHAR(128);
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM ECS_PROPERTIES_TABLE
  WHERE NAME = 'SELINUX_STATUS'
  AND TYPE = 'FEATURE';

  IF v_count = 0 THEN
    -- Insert the value into the table only if it doesn't exist. For cases where this property exist, upgrade should not alter the value.
    SELECT value
    INTO v_current_selinuxstatus
    FROM ECS_PROPERTIES_TABLE
    WHERE NAME = 'SELINUX_DOMU'
    AND TYPE = 'FEATURE';

    IF v_current_selinuxstatus = 'enforcing' THEN
      v_selinux_status := 'enforcing';
    ELSE
      v_selinux_status := 'permissive';
    END IF;
    INSERT INTO ECS_PROPERTIES_TABLE (name, type, value) values ('SELINUX_STATUS', 'FEATURE', v_selinux_status);
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO ECS_PROPERTIES_TABLE (name, type, value) values ('SELINUX_STATUS', 'FEATURE', 'permissive');
END;
/

COMMIT;
--[[aypaul_bug-38190216_END]]--

--[[llmartin_bug-38448318_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ASYNCREBALANCE_API_SKIP_RESIZE',  'FEATURE', 'ENABLED', 'If enabled, the asyncRebalance reshape-storage operation will be NO-OP for applicable clusters.');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ASYNCREBALANCE_WF_SKIP_REBALANCE',  'FEATURE', 'ENABLED', 'If enabled, rebalancing and resize related tasks will be skipped in attach-elastic-cell-wfd');
commit;
--[[llmartin_bug-38448318_END]]--

--[[abysebas_bug-38113984_START]]--
CREATE INDEX ecs_analytics_idemtoken_idx ON ecs_analytics_table(IDEMTOKEN);
CREATE INDEX ecs_analytics_starttimets_idx ON ecs_analytics_table(START_TIME_TS);
--[[abysebas_bug-38113984_END]]--

--[[abyayada_bug-38484573_START]]--
ALTER TABLE ecs_exascale_nw_table MODIFY (vlanid NUMBER);
CREATE OR REPLACE EDITIONING VIEW ecs_exascale_nw AS SELECT * FROM ecs_exascale_nw_table;
--[[abyayada_bug-38484573_END]]--

--[[zpallare_bug-37909653_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('PROVISION_HARDWARE_PRECHECKS',  'FEATURE', 'DISABLED', 'Property to enable/disable hardware prechecks during rack reserve step (PROVISION flow).');
COMMIT;
--[[zpallare_bug-37909653_END]]--

--[[sdevasek_bug-38437139_START]]--

ALTER TABLE ecs_registered_infrapatch_plugins_table ADD (
  script_name varchar2(512),
  script_bundle_hash varchar2(512)
);

CREATE OR REPLACE EDITIONING VIEW ecs_registered_infrapatch_plugins AS
SELECT
        script_name,
        script_alias,
        change_request_id,
        description,
        plugin_type,
        plugin_target,
        script_order,
        enabled,
        reboot_node,
        fail_on_error,
        phase,
	script_bundle_hash,
        registration_time
FROM ecs_registered_infrapatch_plugins_table;

--[[sdevasek_bug-38437139_END]]--

--[[zpallare_bug-38443495_START]]--
ALTER TABLE ECS_HW_CABINETS_TABLE ADD SMARTNIC_ID varchar2(32);
ALTER TABLE ECS_HW_CABINETS_TABLE ADD BACKUP_SMARTNIC_ID varchar2(32);
ALTER TABLE ECS_OCI_SUBNETS_TABLE ADD UTILIZATION number DEFAULT 0 NOT NULL;
ALTER TABLE ECS_OCI_SUBNETS_TABLE ADD ISPRIMARY varchar2(10);
CREATE OR REPLACE EDITIONING VIEW ECS_HW_CABINETS AS SELECT * FROM ECS_HW_CABINETS_TABLE;
CREATE OR REPLACE EDITIONING VIEW ECS_OCI_SUBNETS AS SELECT * FROM ECS_OCI_SUBNETS_TABLE;
--[[zpallare_bug-38443495_END]]--
--[[kukrakes_bug-37558564_START]]--
ALTER TABLE ECS_USERS_TABLE ADD SERVICE_PRINCIPALS VARCHAR2(1024);
CREATE OR REPLACE EDITIONING VIEW ECS_USERS AS
SELECT
    ID,
    USER_ID,
    FIRST_NAME,
    LAST_NAME,
    PASSWORD,
    ACTIVE,
    ROLE_ID,
    CREATED_BY,
    MODIFIED_BY,
    CREATED_AT,
    DELETED_AT,
    UPDATED_AT,
    SERVICE_PRINCIPALS
FROM ECS_USERS_TABLE;
UPDATE ECS_USERS SET SERVICE_PRINCIPALS = 'exacompute_controlplane,exacompute_controlplane_prod,database,database_preprod' where USER_ID='sdi';
UPDATE ECS_USERS SET SERVICE_PRINCIPALS = 'dbaas-ecra' where USER_ID='ops';
COMMIT;
--[[kukrakes_bug-37558564_END]]--

--[[oespinos_bug-38220142_START]]--
CREATE TABLE ecs_released_ips_table (
    exaOcid VARCHAR2(512) NOT NULL,
    ip_address VARCHAR2(16) NOT NULL,
    netmask VARCHAR2(16) NOT NULL,
    subnet VARCHAR2(20),
    network_type VARCHAR2(10) NOT NULL,
    hostname VARCHAR2(256),
    CONSTRAINT ecs_released_ips_pk PRIMARY KEY (exaOcid, ip_address)
);

CREATE OR REPLACE EDITIONING VIEW ecs_released_ips AS SELECT * FROM ecs_released_ips_table;
--[[oespinos_bug-38220142_END]]--

--[[oespinos_bug-38220438_START]]--
ALTER TABLE ecs_hw_elastic_nodes_table ADD delete_candidate CHAR(1) DEFAULT 'N';
CREATE OR REPLACE EDITIONING VIEW ecs_hw_elastic_nodes AS SELECT * FROM ecs_hw_elastic_nodes_table;
--[[oespinos_bug-38220438_END]]--

--[[bshenoy_bug-38306660_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('UPDATE_MOUNTPOINT',  'ECRA', 'DISABLED', 'Property to enable/disable mountpoint update');
ALTER TABLE ecs_exaunitdetails_table ADD grid_mountpoint VARCHAR2(128);
CREATE OR REPLACE EDITIONING VIEW ecs_exaunitdetails AS SELECT * FROM ecs_exaunitdetails_table;
COMMIT;
--[[bshenoy_bug-38306660_END]]--
--[[kukrakes_bug-38529219_START]]--
UPDATE ecs_properties SET value='2' WHERE name='EXACLOUD_RETRY_COUNT';
UPDATE ecs_properties SET value='50000' WHERE name='SOCKET_TIMEOUT_MILLIS';
COMMIT;
--[[kukrakes_bug-38529219_END]]--

--[[oespinos_bug-38523603_START]]--
ALTER TABLE ecs_infrapwd_audit_table DROP CONSTRAINT fk_exa_ocid_infrapwd_audit;
ALTER TABLE ecs_infrapwd_audit_table ADD CONSTRAINT fk_exa_ocid_infrapwd_audit
  FOREIGN KEY (exaocid) REFERENCES ecs_oci_exa_info_table(exa_ocid) ON DELETE CASCADE;
--[[oespinos_bug-38523603_END]]--

--[[zpallare_bug-38443483_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('DYNAMIC_ADMIN_IP_FLOW',  'FEATURE', 'DISABLED', 'Property to enable/disable the dynamic admin ip creation flow between CP and ECRA.');
COMMIT;
--[[zpallare_bug-38443483_END]]--

--[[atgandhi_bug-38421350_START]]--
ALTER TABLE ecs_exaunitdetails_table ADD voting_files CLOB;
CREATE OR REPLACE EDITIONING VIEW ecs_exaunitdetails AS SELECT * FROM ecs_exaunitdetails_table;
--[[atgandhi_bug-38421350_END]]--

--[[rgmurali_bug-38354518_START]]--
ALTER TABLE ecs_system_vault_table ADD exascalefabric VARCHAR2(256);
ALTER TABLE ecs_system_vault_table ADD qfd VARCHAR2(256);

CREATE OR REPLACE EDITIONING VIEW ecs_system_vault AS SELECT * FROM ecs_system_vault_table;

ALTER TABLE ecs_hw_nodes_table ADD exascalefabric VARCHAR2(256);
ALTER TABLE ecs_hw_nodes_table ADD qfd VARCHAR2(256);

CREATE OR REPLACE EDITIONING VIEW ecs_hw_nodes AS SELECT * FROM ecs_hw_nodes_table;

--[[rgmurali_bug-38354518_END]]--


--[[kaggupta_bug-38335432_START]]--
PROMPT Inserting new ECRA property STACK_IDENTIFIER 
INSERT INTO ecs_properties (name, type, value, description) 
       VALUES ('STACK_IDENTIFIER', 'ECRA', 'prod', 'Stack Indentifier value for Exacompute-CP communication'); 
COMMIT;
--[[kaggupta_bug-38335432_END]]--

--[[gvalderr_bug-38540951_START]]--
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','LVDoNotRemoveOrUse','2G','','','','','','','false','all');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','buffer','1G','','','','','','','false','all');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/boot','1G','','','','','','','false','all');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','reserved','2G','','','','','','','false','all');
UPDATE ecs_gold_specs_table SET expected = '114G' WHERE type='exacompute' AND name='system';
COMMIT;
--[[gvalderr_bug-38540951_END]]--

--[[atgandhi_bug-38459507_START]]--
ALTER TABLE ecs_sla_records_table ADD sla_version VARCHAR2(16);
CREATE OR REPLACE EDITIONING VIEW ecs_sla_records AS SELECT * FROM ecs_sla_records_table;
INSERT INTO ecs_properties_table (name, type, value) VALUES ('SLA_SERVER_MAX_TIMEOUT', 'SLA', '90');
COMMIT;
--[[atgandhi_bug-38459507_END]]--


--[[bshenoy_bug-38571124_START]]--
ALTER TABLE ecs_rocefabric_table MODIFY X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS DEFAULT 'ENABLED'; 
UPDATE ecs_rocefabric_table SET X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS = 'ENABLED' WHERE X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS IS NULL;
COMMIT;
--[[bshenoy_bug-38571124_END]]--

--[[bshenoy_bug-38598427_START]]--
ALTER TABLE ecs_hw_nodes_table ADD provisioning_intent VARCHAR2(256);
COMMIT;
--[[bshenoy_bug-38598427_END]]--


--[[hbpatel_bug-37912972_START]]--
PROMPT Inserting new ECRA property OCI_EXACC_HEALTH_API_PORT
INSERT INTO ecs_properties (name, type, value, description)
       VALUES ('OCI_EXACC_HEALTH_API_PORT', 'ECRA', '8443', 'Wss exacc health api port');
COMMIT;
--[[hbpatel_bug-37912972_END]]--
--[[kukrakes_bug-38538341_START]]--
SET SERVEROUTPUT ON
DECLARE
BEGIN
  FOR t IN (
    SELECT table_name
    FROM user_tables
    WHERE table_name IN ('ECS_REQUESTS_TABLE_STAGE', 'ECS_REQUESTS_TABLE_ARCHIVE')
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Processing table: ' || t.table_name);

    -- Step 1: Update VARCHAR2(256) columns to 512
    FOR r IN (
      SELECT column_name
      FROM user_tab_columns
      WHERE table_name = t.table_name
        AND data_type = 'VARCHAR2'
        AND data_length = 256
    ) LOOP
      BEGIN
        EXECUTE IMMEDIATE
          'ALTER TABLE ' || t.table_name || ' MODIFY ' || r.column_name || ' VARCHAR2(512)';
        DBMS_OUTPUT.PUT_LINE('Modified column: ' || r.column_name || ' → VARCHAR2(512)');
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('  :warning: Failed to modify ' || r.column_name || ': ' || SQLERRM);
      END;
    END LOOP;

    -- Step 2: Add STEP_PROGRESS_DETAILS CLOB if not exists
    DECLARE
      v_count INTEGER;
    BEGIN
      SELECT COUNT(*) INTO v_count
      FROM user_tab_columns
      WHERE table_name = t.table_name
        AND column_name = 'STEP_PROGRESS_DETAILS';

      IF v_count = 0 THEN
        EXECUTE IMMEDIATE
          'ALTER TABLE ' || t.table_name || ' ADD (STEP_PROGRESS_DETAILS CLOB)';
        DBMS_OUTPUT.PUT_LINE('Added column: STEP_PROGRESS_DETAILS (CLOB)');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Column STEP_PROGRESS_DETAILS already exists');
      END IF;
    END;
  END LOOP;
END;
/
--[[kukrakes_bug-38538341_END]]--
--[[gvalderr_bug-38588973_START]]--
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacompute','domU','-1','kvm','filesystem','/var/lib/containers','37G','','','','','','','false','all');
INSERT INTO ecs_gold_specs_table(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','reserved','2G','','','','','','','false','all');
DELETE FROM ecs_gold_specs_table WHERE type='exacsexacompute' AND name='buffer';
DELETE FROM ecs_gold_specs_table WHERE type='exacsexacompute' AND name='reserved';
UPDATE ecs_gold_specs_table SET expected = '3G' WHERE type='exacsexacompute' AND name='LVDoNotRemoveOrUse';
UPDATE ecs_gold_specs_table SET expected = '147G' WHERE type='exacompute' AND name='system';
COMMIT;
--[[gvalderr_bug-38588973_END]]--

--[[piyush_bug-38485269_START]]--
ALTER TABLE ecs_exadata_vcompute_node_table ADD (olddummynatip varchar2(128) DEFAULT NULL);
ALTER TABLE ecs_exadata_vcompute_node_table ADD (newdummynatip varchar2(128) DEFAULT NULL);
CREATE OR REPLACE EDITIONING VIEW ecs_exadata_vcompute_node as select * from ecs_exadata_vcompute_node_table;
--[[piyush_bug-38485269_END]]--

--[[sdevasek_bug-38626762_START]]--
ALTER TABLE ecs_registered_infrapatch_plugins_table MODIFY SCRIPT_PATH_NAME NULL;
--[[sdevasek_bug-38626762_END]]--

--[[piyushsi_bug-38612102_START]]--
UPDATE ecs_properties_table SET value='2M' WHERE name='ECRA_FILES_ONSTART_DELETE_OLDERTHAN';
commit;
--[[piyushsi_bug-38612102_END]]--

--[[ritikhan_bug-38137883_START]]--
ALTER TABLE ecs_hw_nodes_table ADD (STRE0_IP VARCHAR2(16));
ALTER TABLE ecs_hw_nodes_table ADD (STRE1_IP VARCHAR2(16));
CREATE OR REPLACE EDITIONING VIEW ecs_hw_nodes AS SELECT * FROM ecs_hw_nodes_table;
--[[ritikhan_bug-38137883_END]]--

--[[abysebas_bug-38299778_START]]--
--Enh 38299778 - PHASE 1: FREE NODE POWER SAVING - CREATE/MODIFY SCHEDULE JOBS 
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type, target_server, current_target_server) VALUES ('oracle.exadata.ecra.scheduler.PowerFreeNodesJob', 'Y', 86400, 'Init', 'RECURRENT', 'PRIMARY', 'PRIMARY');
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type, target_server, current_target_server) VALUES ('oracle.exadata.ecra.scheduler.PowerCpuCoresJob', 'Y', 21600, 'Init', 'RECURRENT', 'PRIMARY', 'PRIMARY');
COMMIT;
--[[abysebas_bug-38299778_END]]--

--[[hcheon_bug-38664377_START]]--
UPDATE ecs_properties SET value='rack_bondmonitor,rack_vmbackup' WHERE name='EXACD_OUTPUT_EXADATA_LOG_TO_LUMBERJACK';
COMMIT;
--[[hcheon_bug-38664377_END]]--

--[[ritikhan_bug-38508944_START]]--
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('NODE_COMPONENT_OPERATION_THREAD_POOL', 'THREAD_POOL', '10', 'Property to set the thread pool size hwnode component operations');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('NODE_COMPONENT_OPERATION_TIMEOUT_SECONDS', 'THREAD_POOL', '600000', 'Property to set timeout for an operation on a hw node component');

PROMPT Creating ecs_hw_node_component_operations_table;
CREATE TABLE ecs_hw_node_component_operations_table (
    idemtoken VARCHAR2(64) NOT NULL,
    infra_ocid VARCHAR2(256) NOT NULL,
    node_name VARCHAR2(256) NOT NULL,
    node_type VARCHAR2(32),
    component_name VARCHAR2(64) NOT NULL,
    component_operation VARCHAR2(32),
    operation_status VARCHAR2(32),
    status VARCHAR2(32),
    version VARCHAR2(64),
    operation_time TIMESTAMP,
    error VARCHAR2(4000),
    CONSTRAINT pk_ecs_hwnode_operation PRIMARY KEY (idemtoken, node_name)
);

PROMPT Creating editioning view on ecs_hw_node_component_operations_table;
CREATE OR REPLACE EDITIONING VIEW ecs_hw_node_component_operations AS
SELECT * FROM ecs_hw_node_component_operations_table;

COMMIT;
--[[ritikhan_bug-38508944_END]]--

--[[pverma_bug-38634942_START]]--
PROMPT Inserting seed weights for tasks of add storage server(s) to Exascale WF on CC
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'PrepareElasticCellCCExascalePayload', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'InvokeExacloudElasticCellExascale', 'ASYNC', 'REMOTE', 1, 'N', 30, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'FetchElasticXmlExascale', 'ASYNC', 'REMOTE', 44, 'N', 2, 2, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'SyncVaultDetailsFromExacloud', 'ASYNC', 'REMOTE', 1, 'N', 2, 2, 'capacity_tenant_attcells');

PROMPT Inserting user messages for attach cell to Exascale WF on CC
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'PrepareElasticCellCCExascalePayload', 'Creating JSON payload for adding storage server(s) to Exascale storage');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'InvokeExacloudElasticCellExascale', 'Adding new storage server(s) to Exascale storage');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'FetchElasticXmlExascale', 'Creating Exadata XML for the Exascale storage with new storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exacc-exascale-wfd', 'SyncVaultDetailsFromExacloud', 'Saving Exascale storage vaults details');

PROMPT Inserting seed weights for tasks of add storage server(s) to Exascale WF on CS
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exascale-wfd', 'PrepareElasticCellCCExascalePayload', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exascale-wfd', 'InvokeExacloudElasticCellExascale', 'ASYNC', 'REMOTE', 1, 'N', 30, 10, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exascale-wfd', 'FetchElasticXmlExascale', 'ASYNC', 'REMOTE', 44, 'N', 2, 2, 'capacity_tenant_attcells');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('attach-elastic-cell-exascale-wfd', 'SyncVaultDetailsFromExacloud', 'ASYNC', 'REMOTE', 1, 'N', 2, 2, 'capacity_tenant_attcells');

PROMPT Inserting user messages for attach cell to Exascale WF on CS
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exascale-wfd', 'PrepareElasticCellCCExascalePayload', 'Creating JSON payload for adding storage server(s) to Exascale storage');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exascale-wfd', 'InvokeExacloudElasticCellExascale', 'Adding new storage server(s) to Exascale storage');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exascale-wfd', 'FetchElasticXmlExascale', 'Creating Exadata XML for the Exascale storage with new storage server(s)');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('attach-elastic-cell-exascale-wfd', 'SyncVaultDetailsFromExacloud', 'Saving Exascale storage vaults details');

PROMPT Inserting seed weights for new tasks of create service WF on CS/CC
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'DeletePreprovClusters', 'ASYNC', 'REMOTE', 1, 'Y', 100, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'FetchCreatedComposeXml', 'SYNC', 'REMOTE', 1, 'N', 20, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'EcraMetadataUpdateElasticCompose', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'ATPExacloudJSONCreation', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'BuildXsImageVaultPayload', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'InvokeEcForXsImageVaultOperation', 'ASYNC', 'REMOTE', 1, 'N', 30, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PostXsImageVaultOperation', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'BuildXsBackupVaultPayload', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'InvokeEcForXsBackupVaultOperation', 'ASYNC', 'REMOTE', 1, 'N', 30, 10, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PostXsBackupVaultOperation', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'PostVMGoldConfig', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'RotateCertificateFedramp', 'SYNC', 'REMOTE', 1, 'N', 80, 50, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'ConfigCompute', 'ASYNC', 'REMOTE', 1, 'N', 75, 50, 'create-service');
INSERT INTO WF_TASKS_WEIGHTS_TABLE(WF_NAME, WF_TASK_NAME, EXEC_MODE, EXEC_SCOPE, EXEC_COUNT, NODE_FACTOR, MEAN_EXEC_DURATION_PER_NODE, MEAN_WEIGHT, OPERATION)
       VALUES('create-service-wfd', 'ExaScaleComplete', 'SYNC', 'LOCAL', 1, 'N', 0.25, 1, 'create-service');


PROMPT Inserting user messages for new tasks of create service WF on CS/CC
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'DeletePreprovClusters', 'Cleaning up unused files for cluster creation');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'FetchCreatedComposeXml', 'Creating the required XML configuration needed to provision the VM cluster on the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'EcraMetadataUpdateElasticCompose', 'Creating metadata of the VM cluster on the Exadata cloud platform');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'ATPExacloudJSONCreation', 'Creating JSON payload for autonomous VM cluster provisioning');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'BuildXsImageVaultPayload', 'Creating JSON payload for exascale VM image vault provisioning');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'InvokeEcForXsImageVaultOperation', 'Creating exascale VM image vault');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PostXsImageVaultOperation', 'Creating metadata of the exascale VM image vault');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'BuildXsBackupVaultPayload', 'Creating JSON payload for exascale VM image backup vault provisioning');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'InvokeEcForXsBackupVaultOperation', 'Creating exascale VM backup image vault');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PostXsBackupVaultOperation', 'Creating metadata of the exascale VM image backup vault');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'PostVMGoldConfig', 'Create VM metadata');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'RotateCertificateFedramp', 'Rotating fedramp certificates');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'ConfigCompute', 'Configuring computes for VM cluster provisioning');
INSERT INTO WF_TASKS_USER_MESSAGES_TABLE(WF_NAME, WF_TASK_NAME, USER_STEP_NAME)
       VALUES('create-service-wfd', 'ExaScaleComplete', 'Creating metadata of the exascale configuration');

commit;
--[[pverma_bug-38634942_END]]--

--[[luperalt_bug-38716755_START]]--
UPDATE ecs_properties_table SET name='CONSOLE_HISTORY_OSS_BUCKETNAME' where name='EXACS_VM_HISTORY_CONSOLE';
commit;
--[[luperalt_bug-38716755_END]]--


--[[luperalt_bug-38690474_START]]--
update ecs_properties_table set value=120 where name='XSVAULT_DETAILS_UPDATE_TIMEOUT_SECONDS';
commit;
--[[luperalt_bug-38690474_END]]--

--[[gvalderr_bug-38629977_START]]--
ALTER TABLE ECS_HW_NODES_TABLE ADD (ECS_RACKS_NAME_LIST_TMP CLOB);
UPDATE ECS_HW_NODES_TABLE SET ECS_RACKS_NAME_LIST_TMP = ECS_RACKS_NAME_LIST;
ALTER TABLE ECS_HW_NODES_TABLE DROP COLUMN ECS_RACKS_NAME_LIST;
ALTER TABLE ECS_HW_NODES_TABLE RENAME COLUMN ECS_RACKS_NAME_LIST_TMP TO ECS_RACKS_NAME_LIST;
COMMIT;
--[[gvalderr_bug-38629977_END]]--

--[[abysebas_bug-38299782_START]]--
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type, target_server, current_target_server, timeout) VALUES ('oracle.exadata.ecra.diagnosis.scanner.PoweredOffNodesSanityCheck', 'Y', 604800, 'Init', 'RECURRENT', 'PRIMARY', 'PRIMARY', 14400);
COMMIT;
--[[abysebas_bug-38299782_END]]--

--[[zpallare_bug-38391344_START]]--
alter table ecs_hw_nodes_table drop constraint ck_ecs_hw_nodes_node_state;
ALTER TABLE ecs_hw_nodes_table add CONSTRAINT ck_ecs_hw_nodes_node_state
      CHECK (node_state in ('FREE', 'COMPOSING', 'ALLOCATED', 'HW_REPAIR',
                            'HW_UPGRADE', 'HW_FAIL', 'CONFIG_FAIL', 'RESERVED', 'ERROR', 'EXACOMP_RESERVED', 'RESERVED_MAINTENANCE', 'RESERVED_FAILURE',
                            'RESERVED_HW_FAILURE', 'FREE_FAILURE', 'FREE_MAINTENANCE','FREE_UNDER_MAINT', 'COMPOSING_UNDER_MAINT',
                            'ALLOCATED_UNDER_MAINT', 'RESERVED_UNDER_MAINT',
                            'HW_REPAIR_UNDER_MAINT', 'HW_UPGRADE_UNDER_MAINT', 'HW_FAIL_UNDER_MAINT',
                            'ERROR_UNDER_MAINT', 'EXACOMP_RESERVED_UNDER_MAINT', 'INNOTIFICATION', 'INNOTIFICATION_UNDER_MAINT',
                            'INMAINTENANCE', 'INMAINTENANCE_UNDER_MAINT', 'UNDER_INGESTION', 'INGESTION_FAILED', 'REQUIRES_RECOVERY',
                            'FREE_AUTO_MAINTENANCE','MOVING','DECOMMISSIONING','LAUNCH_NODE_FOR_PATCHING'));
--[[zpallare_bug-38391344_END]]--


--[[pvachhan_bug-38574501_START]]--
ALTER TABLE ecs_domus_table ADD (
  cus_client_nwvirtualization varchar2(256) DEFAULT 'VIRTIO'
);
ALTER TABLE ecs_domus_table ADD (
  cus_backup_nwvirtualization varchar2(256) DEFAULT 'VIRTIO'
);

UPDATE ecs_domus_table SET cus_client_nwvirtualization='VIRTIO' WHERE cus_client_nwvirtualization IS NULL;
UPDATE ecs_domus_table SET cus_backup_nwvirtualization='VIRTIO' WHERE cus_backup_nwvirtualization IS NULL;
commit;

CREATE OR REPLACE EDITIONING VIEW ecs_domus AS SELECT * FROM ecs_domus_table;
--[[pvachhan_bug-38574501_END]]--
