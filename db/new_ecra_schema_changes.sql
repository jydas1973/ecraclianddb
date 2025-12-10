Rem $Header: ecs/ecra/db/new_ecra_schema_changes.sql /main/385 2025/09/22 06:06:51 jiacpeng Exp $
Rem
Rem $Header: ecs/ecra/db/new_ecra_schema_changes.sql /main/385 2025/09/22 06:06:51 jiacpeng Exp $
Rem
Rem new_ecra_schema_changes.sql
Rem Copyright (c) 2023, 2025, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      new_ecra_schema_changes.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This file contains all DDL statements after editioning views are created
Rem      Reference : https://confluence.oraclecorp.com/confluence/x/Y5rVSAE
Rem                  Section: Do's and Don'ts in EBR enabled ECRA schema
Rem    NOTES
Rem      1. Alter session and set new EBR
Rem      2. After DDL statements, recreate the editioning views, Refer to the following example
Rem       ALTER table WF_STATE_TABLE ADD COLUMN TEST_COLUMN;
Rem       CREATE OR REPLACE EDITIONING VIEW WF_STATE AS
Rem          SELECT
Rem                WF_UUID,
Rem                WF_NAME,
Rem                REQUEST_PAYLOAD,
Rem                CURRENT_STATE,
Rem                TEST_COLUMN
Rem            FROM
Rem                WF_STATE_TABLE;
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jiacpeng    09/17/25 - exacs-159317: add topology pagination
Rem    zpallare    08/19/25 - Enh 38327429 - EXACS ECRA - Make x11m model
Rem                           default for base system in fresh install
Rem    jiacpeng    08/17/25 - EXACS-158502: Add Topology Heap Safety Property
Rem    jreyesm     08/11/25 - E.R 38296814. Increase max mvm clusters to 50
Rem    luperalt    07/21/25 - Bug 38173167 - Added property to rotate dbcs
Rem                           agent user passswords
Rem    luperalt    07/04/25 - Bug 38115115 - Added delete on cascade constraint
Rem                           to ecs_oci_console_connection_table
Rem    pverma      07/24/25 - BUG 38231970 - Address length issue with
Rem                           USER_STEP_NAME in WF_TASKS_USER_MESSAGES_TABLE
Rem                           and clean up redundant SQLs
Rem    jzandate    07/22/25 - Bug 38200385 - remove duplication insert after
Rem                           update happens
Rem    pverma      07/17/25 - BUG 38202766 : Add task weights for remaining
Rem                           WFs. Add user msgs for all WFs
Rem    pverma      07/17/25 - Bug 38200926 : Set RESERVE_TYPE to default value
Rem                           if NULL in ecs_exaservice_reserved_alloc
Rem    pverma      07/09/25 - BUG 38171600: Add _table suffix for
Rem                           wf_tasks_weights
Rem    pverma      07/09/25 - BUG 38135459 - Resize jsonpayload column of
Rem                           ecs_scheduled_ondemand_exec
Rem    pverma      07/01/25 - BUG 38049105 : Add column 'operation' to table
Rem                           WF_TASKS_WEIGHTS
Rem    mpedapro    06/20/25 - Enh::38097735 create index on inventory tables to
Rem                           improve query performance
Rem    jvaldovi    06/19/25 - Enh 37985641 - Exacs Ecra - Ecra To Configure
Rem                           Dbaas Tools Name Rpm Basd On Cloud Vendor
Rem    luperalt    06/18/25 - Bug 38026082 added IP to
Rem                           ecs_oci_console_connection table
Rem    pverma      06/09/25 - BUG 38040253 - Fix issue with inserts into
Rem                           WF_TASKS_USER_MESSAGES
Rem    pverma      05/21/25 - BUG 37876735 - Change PK for
Rem                           ECS_EXASERVICE_RESERVED_ALLOC_TABLE
Rem    luperalt    05/28/25 - Bug 38006666 Reverted txn 37990270
Rem    luperalt    05/26/25 - Bug 37990270 - Added X11M-EF cell model
Rem    illamas     05/15/25 - Bug 37724767 - Fix duplication nathostnames
Rem                           active/active
Rem    caborbon    04/30/25 - ENH 37799591 - Fixing Bug in insert query for
Rem                           LIMIT_PER_CABINET_EXTRALARGE_X11M property
Rem    rgmurali    04/30/25 - Enh 37837172 - Change the range for extended
Rem                           clusterid
Rem    pverma      04/01/25 - Seed records for few WF weights
Rem    zpallare    04/22/25 - Enh 37811586 - EXACC EF - Add yaml and support
Rem                           change for ef during infra creation and scale up
Rem    nitishgu    04/17/25 - bug 37822390 : ECRA ROLLING
Rem                           UPGRADE:'EXTENDED_CLUSTER_ID' PROPERTY CHANGED
Rem                           AFTER UPGRADE
Rem    kukrakes    04/16/25 - Bug 37836265 - EXADB-XS ECRA: INCREASE COLUMN
Rem                           SIZE FOR VOLUME_NAME IN ECS_VOLUMES TABLE
Rem    jzandate    04/02/25 - Enh 37675147 - Adding brancher for
Rem                           ImageBaseProvisioning
Rem    jyotdas     04/01/25 - Enh 37500460 - free node from qfab as a launch
Rem                           node for clusterless patching
Rem    illamas     04/01/25 - Enh 37746640 - 19c changes
Rem    illamas     03/24/25 - Enh 37740901 - 19c support for exadbxs
Rem    jzandate    03/24/25 - Enh 37692741 - Adding property to use 6x9 for
Rem                           exacompute
Rem    bshenoy     03/21/25 - X11M support for Elastic Reservation
Rem    jzandate    03/18/25 - Enh 37525577 - Adding CONFIGURED_FEATURES to site
Rem                           groups
Rem    bshenoy     03/13/25 - EXACS-143285 - QFAB support for X11M & ABS
Rem    ybansod     03/10/25 - Enh 34558104 - PROVIDE API FOR ECRA RESOURCE BLACKOUT
Rem    gvalderr    03/06/25 - Enh 37557512 - setting ECRA_STORAGE_DEST to db by
Rem                           default
Rem    seha        02/27/25 - Bug 37634831 - Add table ecs_compliance_rpm_info
Rem    pverma      02/25/25 - Progress Details feature related changes
Rem    gvalderr    02/24/25 - Enh 37503396 - Enable auto undo/retry mechanism
Rem                           for vault-access creation workflow
Rem    jzandate    02/24/25 - Enh 37598887 - Adding new property for exacloud
Rem    illamas     02/18/25 - Enh 37598057 - BaseDB support
Rem    bshenoy     02/17/25 - Bug 36847297: Convert infra activation flow to be
Rem                           WF based
Rem    zpallare    02/13/25 - Bug 37583640 - EXACS: Delete two storage
Rem                           servers fails: error:oeda-2006: diskgroup sprc1
Rem                           requires at least 5 storage nodes
Rem    hcheon      02/10/25 - 37379447 whitelist infra for fault injection test
Rem    sdevasek    01/30/25 - Enh 37300474 - ECRA API AND DB CHANGES FOR LAUNCH
Rem                           NODE REGISTRATION ENDPOINT TO TAKE LAUNCHNODETYPE
Rem    illamas     01/30/25 - Enh 37508426 - Store more values in CS exacompute
Rem    jyotdas     01/29/25 - Enh 37267618 - Expose Ecra api to return
Rem                           registered versions for image series in exacs
Rem    mpedapro    01/27/25 - Enh::35594127 Enable dns and ntp changes for nw
Rem                           reconfiguration feature
Rem    abysebas    01/27/25 - Enh 37497061 - SKIP RESIZEDGSIZES STEPS
Rem                           CONDITIONALLY FROM ADD CELL FLOW
Rem    illamas     01/21/25 - Enh 37326852 FS exadbxs
Rem    luperalt    01/15/25 - Bug 37482170 - Added alter tables for
Rem                           ecs_oci_console_history
Rem    jvaldovi    01/15/25 - Enh 37477523 - Exacs Sitegroup - Include Mtu
Rem                           Config Per Site Group
Rem    bshenoy     01/09/25 - Bug 37379576 : Improve xml save logic for
Rem                           exascale clusters
Rem    zpallare    01/08/25 - Bug 37459422 - EXACS ECRA - Update zldra to zrcv
Rem                           in cross platform table for x11m
Rem    aypaul      12/11/24 - ER-37026081 add insert startement for new
Rem                           property.
Rem    jzandate    11/29/24 - Enh 36979503 - Saving systemvault into ecra
Rem                           archive
Rem    zpallare    11/28/24 - Enh 36754344 - EXACS Compatibility - create new
Rem                           apis for compatibility matrix and algorithm for
Rem                           locking
Rem    illamas     11/25/24 - Enh 37312529 - Support exadata 25.1
Rem    essharm     11/21/24 - Bug 37249099 - FEDRAMP ENHANCEMENT: ECRA TO HAVE
Rem                           MECHANISM TO ROTATE ITS LISTENER CERTIFICATE
Rem    illamas     11/21/24 - Enh 37115247 - enable CUSTOM_GI
Rem    jvaldovi    11/19/24 - Enh 37045660 - Remove Dependency Of
Rem                           Restricted_Sitegroup In Cabinets_N_Cluster_Util
Rem    zpallare    11/08/24 - Enh 37260372 - EXACS X11M - Update x11m cell
Rem                           definitions by removing xrmem cc/cs
Rem    josedelg    11/07/24 - Enh 35677516 - Increase timeout for ongoing ops
Rem    zpallare    11/04/24 - Enh 37243715 - ECRA X11M - ECRA Should disable
Rem                           delete bonding for non eht0 nodes only
Rem    zpallare    11/04/24 - Bug 37241137 - 2441 : Create infra failing due to
Rem                           missing property
Rem    zpallare    10/30/24 - Bug 37231258 - EXACS:X11M:Remove oeda_codename
Rem                           values for some models
Rem    jzandate    10/29/24 - Bug 37218478 - Fix Trigger for stacks with older
Rem                           version
Rem    zpallare    10/28/24 - Bug 37208679 - EXACS X11M - ZDLRA Flow should be
Rem                           also working for x11m-xrmen cells
Rem    llmartin    10/25/24 - Enh 37193905 - Encrypt PUBLIC_KEY column in
Rem                           ECS_DOMUKEYSINFO table
Rem    zpallare    10/23/24 - Enh 37155618 - EXACC X11M - Implement new oeda
Rem                           types for compute/cell ecra -> oxpa
Rem    caborbon    10/23/24 - ENH 37208776 - Adding new cp codename for model
Rem                           subtypes
Rem    luperalt    10/22/24 - Bug 37202795 Fixed maxracks for X11 for exacc
Rem    zpallare    10/21/24 - Enh 37197440 - Add a way to force celltype and
Rem                           computetype during infra creation
Rem    caborbon    10/21/24 - ENH 37179993 - Adding new oeda codename field
Rem                           in ecs_platform_info to store the modelsubtype name for OEDA
Rem    zpallare    10/20/24 - Enh 37102594 - EXACS X11M - Update base system
Rem                           regular flow to take X11M-X(base) cells on
Rem                           algorithm
Rem    jzandate    10/18/24 - Enh 37159566 - Adding vmbackup history
Rem    jvaldovi    10/17/24 - Enh 37181642 - Add Cloud_Provider_Az And
Rem                           Cloud_Provider_Building To Site Groups Table In
Rem                           Ecra
Rem    zpallare    10/16/24 - Enh 37176101 - EXACS X11M - Validate zrcv flow
Rem                           for x-z models to only pick x11m-z models
Rem    pverma      10/15/24 - Add VAULT_ECRA_ID column to
Rem    pverma      10/15/24 - Add VAULT_ECRA_ID column to
Rem                           ecs_exascale_vaults_table
Rem    llmartin    10/15/24 - Enh 37150594 - Allow different exadata version
Rem                           during CEI creation
Rem    gvalderr    10/14/24 - Enh 37127579 - Adding property for max size of
Rem                           customer domain name
Rem    caborbon    10/13/24 - ENH 37154198 - Inserting EF Cell information in
Rem                           ecs_hardware
Rem    zpallare    10/09/24 - Enh 37025371 - EXACC X11M Support for compute
Rem                           standard/large and extra large
Rem    pverma      10/08/24 - Add ASMSS to ECS_OCI_EXA_INFO
Rem    hcheon      10/08/24 - 36061279 Scheduler changes for active/active 2c
Rem    rgmurali    10/07/24 - Enh 37144818 - isPlacementDisabled support in system-vault
Rem    gvalderr    10/07/24 - Enh 37126647 - Removing the -2 form the X11M
Rem                           models
Rem    jzandate    10/04/24 - Enh 36906964 - Automating secure erase
Rem                           certificate upload to oss
Rem    pverma2     10/03/24 - Bug 37129159 - Add EXACLOUD_XML column to ecs_oci_clu_xmls_table
Rem    gvalderr    10/03/24 - Enh 37128995 - Make filesystem feature enabled by
Rem                           default
Rem    jzandate    10/03/24 - Enh 37132615 - leaving vmbackupscheduler enabled
Rem                           state as is
Rem    caborbon    10/02/24 - ENH 37102944 - Adding new cluster size constraint
Rem                           needed for X11M generation in ecs_hw_nodes
Rem    kukrakes    09/30/24 - Bug 37117708 - LISTALIASES API AFTER SUCCESSFUL
Rem                           MOUNT IS NOT WORKING [EXACOMCP-3476]
Rem    pverma      09/27/24 - Add column attach_candidate to ecs_oci_clu_xmls
Rem    caborbon    09/26/24 - Bug 37108140 - UPDATE DESCRIPTION TO REMOVE -2 ON
Rem                           ELASTIC X11M HARDWARE DEFINITION
Rem    zpallare    09/26/24 - Bug 37107444 - EXACS:24.4.1:CEI creation failing
Rem                           at elasticshapeceicapacity:ora-00904:
Rem                           x9m_elastic_reservation_for_high_util_qfabs:
Rem                           invalid identifier
Rem    jyotdas     09/25/24 - ER 37089701 - ECRA Exacloud integration to
Rem                           enhance infrapatching operation to run on a
Rem                           single thread
Rem    nitishgu    09/25/24 - BUG 37093574: ATPEXACLOUDJSONCREATION FAILING^CN
Rem                           ECRA WITH UNABLE TO RETRIEVE THE VLAN RECORDS
Rem                           ERROR
Rem    nitishgu    09/25/24 - BUG 37093574: ATPEXACLOUDJSONCREATION FAILING^CN
Rem    zpallare    09/23/24 - Enh 36922155 - EXACS X11M - Base system support
Rem    llmartin    09/23/24 - Enh 37081824 - Add property to skip add/delete
Rem                           storage precheck
Rem    caborbon    09/21/24 - ENH 37029692 - Updating the constraints values
Rem                           for cell & computes subtypes in ecs_ceidetails
Rem    caborbon    09/20/24 - Bug 37085769 - Removing CABINET_MODEL fields form
Rem                           ecs_ceidetails view creation
Rem    nitishgu    09/20/24 - BUG: 37071966 Remove Bit vector for EXTENDED
Rem                           CLUSTER ID
Rem    llmartin    09/19/24 - Bug 37076412 - Add default values to ecs_domus
Rem    caborbon    09/18/24 - ENH 37071580 - Adding nee fields to
Rem                           ecs_ceidetails for node subtype
Rem    anudatta    09/18/24 - 37052085 - NEW API FOR ECRA_ACTIVE ACTIVE FLAG and ECRA_INFRA_SETUP flag
Rem    essharm     09/17/24 - Bug 37070289 - RENAME ATTRIBUTE NEWDEV TO
Rem                           DEVELOPER
Rem    gvalderr    09/13/24 - Enh 37050952 - Changing default values of certain
Rem                           properties for deocmposing
Rem    nitishgu    09/05/24 - BUG 36991882 - ECRA TO SUPPORT EXTENDED CLUSTER
Rem                           VLAN
Rem    pverma      09/03/24 - Backfill empty bonding modes
Rem    illamas     08/30/24 - Enh 36918015 - Mark nathostname in ecs_domus and
Rem                           generate a new one for vm move
Rem    gvalderr    08/28/24 - Enh 37001368 - hange the TARGET_URI field sized
Rem    ybansod     08/27/24 - Bug 36916251 - HAVE SEPARATE ENTRIES FOR SECRETS
Rem                           DUE TO VARCHAR2 LIMIT IN ECS_SECRETVAULTINFO
Rem                           TABLE
Rem    caborbon    08/26/24 - ENH 36908403 - Adding X11M-2 to the elastic
Rem                           platform info table
Rem    zpallare    08/21/24 - Enh 34972266 - EXACS Compatibility - create new
Rem                           tables to support compatibility on operations
Rem    rgmurali    08/20/24 - ER 36970851 - Make state handle ids continuous
Rem    luperalt    08/20/24 - Bug 36965316 Drop constraint fk_exascale_id
Rem    caborbon    08/20/24 - ENH 36955594 - Adding new property to control FS
Rem                           Encryption Feature on ADBD Provisionings
Rem    caborbon    08/20/24 - Bug 36969730 - Adding back property
Rem                           DOMU_OS_VERSION_OVERRIDING_ATP for Early Adopter
Rem                           Feature in ATP
Rem    luperalt    08/13/24 - Bug 36942514 - Fixed create ecs_exascale_nw table
Rem    caborbon    08/12/24 - ENH 36931770 - Adding new field in ecs_hardware
Rem                           for ecpu feature on X11
Rem    jzandate    08/07/24 - Enh 36904134 - Saving results for secure erase wf
Rem    gvalderr    08/06/24 - Enh 36908332 - Adding required records for X11
Rem    llmartin    08/05/24 - Enh 36908696 - Preprov, configurable GI
Rem    cgarud      08/05/24 - EXACS-136976 - Fix QFAB reservation defaults and
Rem                           change column names
Rem    jzandate    07/31/24 - Enh 36902645 - Changing property
Rem                           REMOVE_KEYS_AFTER_PROVISIONING to disabled
Rem    jvaldovi    07/26/24 - Enh 36858584 - Ecra: Multicloud: Add Site Group
Rem                           Data To Ecra
Rem    abyayada    07/19/24 - 36842063 : Configurable min storage for clu
Rem                           creation
Rem    luperalt    07/16/24 - Bug 36848233 Fixed alter for ECS_HW_CABINET table
Rem    essharm     07/10/24 - Enh 36383801 - HEARTBEAT TRASACTION TO
Rem                           PROACTIVELY IDENTIFY ISSUES WITH REGION LEVEL
Rem                           RESOURCE
Rem    luperalt    07/03/24 - Bug 36754210 Added vnic id column to
Rem                           ecs_hw_cabinets
Rem    abysebas    07/03/24 - Bug 36800736 - IPV6 - DUAL STACK SUPPORT FOR
Rem                           CLIENT AND BACKUP
Rem    illamas     07/01/24 - Enh 36770879 - Reducing vm size for exacompute
Rem                           post ga phase1
Rem    jzandate    07/01/24 - Enh 36197323 - Adding new columns for network
Rem                           type and support status
Rem    llmartin    06/27/24 - XbranchMerge llmartin_bug-36742283 from
Rem                           st_ecs_23.4.1.2.6
Rem    essharm     06/26/24 - Enh 36755078 - Add Col to Support for
Rem                           NEWDEV/REGULAR CLUSTER TYPE
Rem    caborbon    06/24/24 - Enh 36754615 - Adding property for FS Encryption
Rem                           by region
Rem    luperalt    06/13/24 - Bug 36603885 Added exascale table
Rem    abysebas    06/13/24 - BUG 36708304 - ECRA IPV6 FLOW - UPDATE YAML AND
Rem    sdevasek    06/12/24 - Bug 36696921 - UPDATE ERROR_MSG COL TO HAVE 4000
Rem                           LENGTH IN ECS_EXA_APPLIED_PATCHES_TABLE TO CATER
Rem                           MADDERROR ERROR MESG SUGGESTION STRING
Rem    seha        06/10/24 - Enh 36496297 - Add table ecs_compliance_rpm_info
Rem    rgmurali    06/07/24 - Enh 36710874 - Seed data in state_lock_data
Rem    pverma      06/05/24 - Add missing columns to views for new ones in
Rem                           Exascale data model updates
Rem    luperalt    05/31/24 - Bug 36390109 Fixed alter table for new column
Rem                           last_password_rotation
Rem    pverma      05/28/24 - Add properties for XS Vault details sync
Rem    caborbon    05/27/24 - ENH 36659169 - Adding new property to force
Rem    caborbon    05/27/24 - ENH 36659169 - Adding new property to force
Rem                           EarlyAdopter version in all new CEI
Rem    illamas     05/24/24 - Enh 36224070 - Snapshot table
Rem    gvalderr    05/24/24 - Enh 36334590 - Adding column ECS_HW_CABINET to
Rem                           determine if a cabinet is dedicated or shared
Rem    zpallare    05/24/24 - Enh 36628793 - ECRA EXACS - Add property
Rem                           description column for new properties
Rem    illamas     05/24/24 - Bug 36656481 - Exacompute change tmp from 3G to
Rem                           10G
Rem    jzandate    05/23/24 - Enh 36637427 - Updating properties for domu image
Rem                           version override
Rem    caborbon    05/22/24 - Bug 36641332 - Adding new Property for ATP Early
Rem                           Adopter Feature
Rem    jzandate    05/21/24 - Enh 36642660 - Adding BASE for BaseSystem in
Rem                           exadata matrix catalog
Rem    pverma      05/20/24 - Exascale related changes
Rem    jzandate    05/17/24 - Bug 36630289 - Adding new property to control
Rem                           EXACS and ATP image_version separately
Rem    kukrakes    05/13/24 - Bug 36606128 - EXACC GEN2 PARTITIONING OF TABLE
Rem                           ECS_SCHEDULEDJOB_HISTORY_TABLE FAILED
Rem    gvalderr    05/09/24 - Enh 36602015 - Adding EXACS_IGNORABLE_MOUNTPOINTS
Rem                           property
Rem    jyotdas     05/08/24 - Enh 36506201 - infrapatching tool to update
Rem                           exasplice version on ecs_hw_nodes table
Rem    gvalderr    05/07/24 - Enh 36592196 - Set FILESYSTEM_FEATURE property
Rem                           enabled for fresh installs
Rem    jreyesm     05/07/24 - Bug 36592675. Incorrect default on
Rem                           restrited_sitegroup
Rem    illamas     05/07/24 - Enh 36588086 - Adjust grid for atp
Rem    caborbon    05/03/24 - Bug 36576562 - Adding new field to cloudvnuma
Rem                           table for early adopter feature
Rem    abysebas    05/03/24 - Bug 36580546 - EXACS IPV6 MISSING BACKUP ENTRIES
Rem    jzandate    05/02/24 - Adding insert for new exadata image version to
Rem                           exa ver matrix
Rem    jzandate    04/30/24 - Enh 36564221 - Adding property to limit beta
Rem                           exadata image versions
Rem    pverma      04/25/24 - Insert property FleetVmStatusSyncJob
Rem    gvalderr    04/22/24 - Enh 36494348 - adding extra columns for keys on
Rem                           system_vault_table
Rem    jzandate    04/20/24 - Bug 36534927 - Adding property to override
Rem                           image_version on CS when using GI 23 and null
Rem                           image version
Rem    rgmurali    04/18/24 - Bug 36437100 - ExaDB-XS scale sanitycheck changes
Rem    illamas     04/18/24 - Enh 36529231 - Ocpu to ecpu ratio
Rem    cgarud      04/17/24 - EXACS-125310 - QFAB blocking for highly utilized
Rem                           fabrics
Rem    rgmurali    04/14/24 - Bug 36505331 - e2e maintenance fix for exadb-xs
Rem    abysebas    04/12/24 - Enh 36495315 - ECRA IPV6 SUPPORT - PROVISIONING
Rem                           FLOW
Rem    jzandate    04/12/24 - Bug 36452908 - Disabling installation trigger and enabling new ebr trigger
Rem    llmartin    04/10/24 - Enh 36340464 - Active-active, ip rules for
Rem                           multiple ECRAs
Rem    zpallare    04/09/24 - Bug 36218977 - EXACS: Validate resources using
Rem                           views instead of json node_wise_allocations
Rem    llmartin    04/08/24 - Bug 36488210 - Change SERVERNAME_INIT_VALIDATION
Rem                           default value
Rem    zpallare    04/03/24 - Bug 36308005 - EXACS: Fresh provisioning with 23c
Rem                           gi has 19cgi configured post provisioning
Rem    emekala     04/02/24 - ENH 35804535 - EXACS: Cleanup of logs and
Rem                           patchpayloads on the Management Host (launch
Rem                           node) for EXACS
Rem    jiacpeng    03/29/24 - exacs-129303: change VMCLUSER_NAMES to
Rem                           VARCHAR2(4000) to support 64 vms per compute
Rem    gvalderr    03/27/24 - Enh 36449520 - Adding adbdmvm filesystem template
Rem                           sizes
Rem    illamas     03/26/24 - Bug 36390893 - Removing constraint of 900G for
Rem                           exacompute racks
Rem    gvalderr    03/25/24 - Enh 36361990 - Adding X8M Elastic OH size rules
Rem    jzandate    03/21/24 - Enh 36405281 - Adding new column to hold image
Rem                           version and code to update it for a given cluster
Rem    gvalderr    03/14/24 - Enh 36405883 - Making property ECRA_STORAGE_DEST
Rem                           be db by default
Rem    zpallare    03/13/24 - Bug 36369842 - Update exacloud retry count value
Rem    essharm     03/12/24 - Bug 36390589 - EXACC:SLA:WAVE2:BB: BREACH DID NOT
Rem                           REFLEX ON THE REPORT
Rem    illamas     03/11/24 - Enh 36380665 - Change node state for vm move
Rem    jzandate    03/05/24 - Bug 36370137 - Change default value for vm gold
Rem                           backup retry timeout
Rem    jzandate    03/05/24 - Bug 36340175 - Update last_Update for vmbackupjob
Rem                           on every upgrade or update db
Rem    llmartin    03/04/24 - Enh 35878687 - Ecra instance validation
Rem    gvalderr    03/04/24 - Enh 36361990 - Changing total storage size for
Rem    oespinos    03/03/24 - Bug 36353998 - Ecra DB schema different between
Rem                           between prod and dev
Rem    jzandate    03/01/24 - Bug 36344989 - Adding property to wait between
Rem                           batches
Rem    gvalderr    02/23/24 - Enh 36330149 - Adding filesystem migration
Rem                           complete property
Rem    jyotdas     02/21/24 - Bug 36228424 - ECRA infra patch registration to
Rem                           support rack model
Rem    zpallare    02/20/24 - Enh 36034772 - EXACS: Keep records of deleted
Rem                           clusters in ecra
Rem    gvalderr    02/16/24 - Enh 36268211 - Changing BASE_SYSTEM_MODELS
Rem                           default value
Rem    luperalt    02/13/24 - Bug 36293266 Added ecs_oci_console_connection
Rem                           table definition
Rem    zpallare    02/09/24 - Enh 36212504 - ECRA ANALYTICS - Make sure old
Rem                           records are being removed from ecs_analytics
Rem    illamas     02/06/24 - Enh 36268622 - Decreasing GI for exacompute
Rem    seha        02/02/24 - Enh 35695712 Send CM metrics to T2
Rem    gvalderr    01/29/24 - Enh 36214478 - Correcting filesystem template
Rem                           values
Rem    kukrakes    01/29/24 - Bug 36236832 - EXACS ECRA -
Rem                           ECS_SCHEDULEDJOB_HISTORY THIS VIEW THE ID
Rem    jzandate    01/25/24 - Enh 36096298 - Adding deconfigure flag for create
Rem                           service execution
Rem    luperalt    01/25/24 - Bug 36206167 Fixed Real domain for OC5
Rem    gvalderr    01/24/24 - Enh 36222099 - Changing size limit on OHomeRUles
Rem    zpallare    01/22/24 - Enh 36165741 - EXACS: After termination of cei,
Rem                           elastic shape nodes needs to be patched to latest
Rem                           exadata version
Rem    caborbon    01/22/24 - Bug 36207227 - Removing updates on ecs_properties
Rem                           for VM backup
Rem    kukrakes    01/22/24 - Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA
Rem                           OPERATIONS FAILING POST PARTITIONING AND
Rem                           ARCHIVING OF TABLES
Rem    llmartin    01/16/24 - Bug 36165477 - Add parallel preprovisioning
Rem    gvalderr    01/10/24 - Enh 36174560 - modifying the exacc filesystem
Rem                           templates
Rem    pverma      01/09/24 - Add support NODE_RECOVERY_SOP_FROM_BACKUP
Rem                           property
Rem    jzandate    01/08/24 - Bug 36156767 - Changing interval to 7 days for
Rem                           vmbackup job
Rem    bshenoy     01/08/24 - Bug 36160728 - Add rack serial number columm for ecs_oci_exa_info
Rem    illamas     01/03/24 - Enh 36148326 - Change GCV from 32G to 2G
Rem    ddelgadi    01/03/24 - Bug 36117880 - Fix for CHOOSE_NONBONDED_X6 property
Rem    gvalderr    01/03/24 - Enh 36117657 - Correcting order of instructions
Rem                           for ecs_elastic_platform_info
Rem    jyotdas     12/22/23 - Bug 36024518 - QMR failing for HA check when vm
Rem                           cluster was stopped by customer before patching
Rem    anudatta    12/21/23 - Bug 36080194 - Active active Phase 2A , enable autoretry
Rem    piyushsi    12/20/23 - Enh 35878651 - Active-Active Changes for cookie info
Rem    gvalderr    12/19/23 - Enh 36078029_1 - Adding filesystem mountpoints
Rem                           values for exaccmvm ib
Rem    jiacpeng    12/16/23 - add topology property
Rem    cgarud      12/14/23 - 36086852 - UNDO EXACS-114176 CHANGES - Causes
Rem                           compose cluster failure due to change in default
Rem                           node_state from FREE to UNDER_INGESTION
Rem    gvalderr    12/12/23 - Enh 36090848 - Changing handling of
Rem                           ECRA_STORAGE_DEST property
Rem    jzandate    12/11/23 - Enh 36096298 - Adding new property for preprov VM
Rem                           GI Deconfigure
Rem    kukrakes    12/11/23 - Enhancement Request 36070977 - ECRA APPLICATION
Rem                           CHANGES TO IMPLEMENT PARTITIONING IN ECRA SCHEMA
Rem    llmartin    12/07/23 - Bug 36023027 - Fix zone lenght
Rem    jvaldovi    12/06/23 - Enh 35914352 - ECRA INDIGO - MODIFY CAPACITY
Rem                           ALGORITHMS FOR SITE GROUP
Rem    hcheon      11/29/23 - 35572548 Created indexes for wf_uuid
Rem    zpallare    11/28/23 - Enh 35774761 - ECRA - Disabling trigger for
Rem                           exa_ver_matrix
Rem    llmartin    11/24/23 - Bug 36000274 - Move jobs to Active server
Rem    bshenoy     11/23/23 - Fedramp support
Rem    illamas     11/23/23 - Bug 36038143 - Adding missing X8-2 model to
Rem                           catalog ol7/ol8
Rem    jreyesm     11/23/23 - Enh 35999428. Add file system config.
Rem    caborbon    11/21/23 - Bug 35990354 - Adding new field to save the
Rem                           custom linux uid/gid value
Rem    ddelgadi    11/14/23 - Enh 35756274 - Modify ECS_AD_LOCATIONS
Rem    luperalt    11/03/23 - Bug 35951076 Added FS_ENCRYPTION property
Rem    jzandate    11/03/23 - Bug 15969374 - use the same trust store for auth
Rem                           provider methods
Rem    caborbon    11/01/23 - Bug 33779609 - Adding new field 'env' for
Rem                           ecs_hardware and a new view named
Rem                           ecs_hardware_filtered
Rem    gvalderr    10/30/23 - Enh 35950877- add property to know if use 184 or
Rem                           443 overhead
Rem    illamas     10/27/23 - Catalog support more than one exaversion
Rem    abysebas    10/26/23 - Bug 35947696 - PORTING 35931983 TO ECS MAIN
Rem                           (AVOID DROP COLUMNS IN EBR ENABLED SCHEMA
Rem                           (NEW_ECRA_SCHEMA_CHANGES.SQL))
Rem    abysebas    10/26/23 - Bug 35947696 - PORTING 35931983 TO ECS MAIN
Rem    jyotdas     10/25/23 - Abort ecra wf when infra patching has failed
Rem    caborbon    10/25/23 - Bug 35938508 - Modifying ecs_hw_nodes ->
Rem                           model_subtype to have a default on null value
Rem    zpallare    10/25/23 - Enh 35823610 - Adding rackname column to
Rem                           ecs_oci_vnics
Rem    jreyesm     10/23/23 - Bug 35933697. Reallocated monitoring_compartment_ocid
Rem    gvalderr    10/19/23 - Enh 35945349 - Changing minimum values for boot
Rem                           and reserved ad adding exacs svm template
Rem    caborbon    10/18/23 - Bug 35792183 - Adding properties to control the
Rem                           limits for Model Subtypess
Rem    illamas     10/17/23 - Enh 35920336 - Modify size for system
Rem    jiacpeng    10/17/23 - fix typo for table ecs_sla_server_records
Rem    gvalderr    10/16/23 - Enh 35870618 - Adding num_servers column to
Rem                           ecs_elastic_platform_info table
Rem    gvalderr    10/16/23 - Enh 35909909 - Adding an delete and reinserting
Rem                           approach for platform_info items
Rem    caborbon    10/10/23 - Bug 35873033 - Fixing duplicate queries to insert
Rem                           X10 information in ecs_hardware
Rem    jvaldovi    10/10/23 - Enh 35892155 - Ecra Indigo - Create Backfilling
Rem                           Apis To Populate Indigo Data
Rem    gvalderr    10/09/23 - Enh 35875930 - Changing exacc filesystem name for
Rem                           grid_home
Rem    jzandate    10/05/23 - Bug 35880434 - Change default vmbackup job state
Rem    piyushsi    10/05/23 - BUG 35862125 Updating totalcores and memory
Rem    caborbon    10/04/23 - Bug 35859903 - Adding FAULT_DOMAIN property
Rem    jzandate    10/02/23 - Bug 35857986 - Adding missing drop constraint to
Rem    jzandate    10/02/23 - Bug 35857986 - Adding missing drop constraint to
Rem                           ecs_zones table used for prepreov dns
Rem    rgmurali    09/29/23 - ER 35829025 - Free node patching support for ExaDB-XS 
Rem    caborbon    09/29/23 - Bug 35859903 - adding update statement to avoid
Rem                           FD null in ecs_hw_cabinets
Rem    jbrigido    09/27/23 - Bug 35852382 Changing wrong values
Rem    jzandate    10/03/23 - Enh 35769747 - Adding gold vm backup status
Rem    jzandate    10/02/23 - Enh 35769747 - Adding properties for gold vm
Rem                           backup
Rem    gvalderr    09/26/23 - Enh 35842708 - Adding template fields for minimum
Rem    oespinos    09/22/23 - 35827954 - Adding hosts_involved column to
Rem                           ecs_sla_breach_reason
Rem    abyayada    09/22/23 - Bug 35830731 - Remove Redundant attr
Rem                           OCI_REHOME_STATUS from network object
Rem    jzandate    09/21/23 - Bug 35828776 - Fix missing statements from ebr
Rem    llmartin    09/08/23 - Bug 35747355 -Preprov, set correct rack state
Rem                           after delete service
Rem    llmartin    09/13/23 - Bug 35805426 - insert EXACS_PREPROV property
Rem    jzandate    09/11/23 - Bug 35777412 - Updating ADBD to ATP for
Rem                           EXA_VER_MATRIX
Rem    illamas     09/12/23 - Bug 35792160 - Fix X9M-2 ecs_hardware values
Rem    gvalderr    09/11/23 - Enh 35789663 - Deleteing constraint
Rem                           fk_console_exocid from ecs_oci_console_connection
Rem                           table
Rem    gvalderr    09/08/23 - Bug 35790776 - Changing Alter table
Rem                           systemvaultaccess placement to respect creating
Rem                           table
Rem    ddelgadi    09/06/23 - Bug 35773184 - primary key ecs_exadata_formation
Rem    oespinos    09/04/23 - Bug 35756904 - ExaCC SLA schema changes
Rem    jreyesm     09/01/23 - Bug 35582806. disabled vmbackup property.
Rem    ddelgadi    09/01/23 - Bug 35768652 - EBR Fixes
Rem    jreyesm     08/31/23 - Bug 35582806. Enable BASESYSTEM_USE_BONDING_INPUT
Rem                           by default.
Rem    gvalderr    08/31/23 - Adding trustcertificates column to system vault
Rem                           access table
Rem    ddelgadi    08/31/23 - Bug 35765610 - Solve defect for BLOB type
Rem    pverma      08/30/23 - Add new state REQUIRES_RECOVERY to ecs_hw_nodes
Rem                           constraint
Rem    hcheon      08/30/23 - 35197827 Use OCI instance metadata v2
Rem    jzandate    08/24/23 - Bug 35743292 - Adding ecra property for oci auth
Rem                           path
Rem    ddelgadi    08/25/23 - Bug 35743318 - query fixes
Rem    essharm     08/23/23 - Bug 35729575 - REMOVE SWITCHES METRICS FOR SLA
Rem                           SLO
Rem    llmartin    08/18/23 - Bug 35719992 - Fix ecs_oci_subnets constrain
Rem    jzandate    08/17/23 - Bug 35698870 - Toggle vmboss su config with ecra
Rem                           property
Rem    gvalderr    08/16/23 - Adding update statement for ECRA STORAGE property
Rem    ddelgadi    08/15/23 - Bug 35689915 - Adding missing create table to ebr
Rem    jzandate    08/11/23 - Bug 35696911 - Adding missing create table to ebr
Rem    gvalderr    08/10/23 - Bug 35697655 - Adding all ecs_gold_specs required
Rem                           records
Rem    kukrakes    08/10/23 - BUG 35649220 - USER PASSWORD IN ECRA-NG NEEDS TO
Rem                           BE SALTED, IT IS HASHED USING SHA-256
Rem    jzandate    08/08/23 - Bug 35668830 - Changing job name and config
Rem                           metadata
Rem    pverma      08/07/23 - Add DELETED state in ECS_DOMUS to support soft
Rem                           delete
Rem    illamas     08/04/23 - Enh 35677356 - New columns for GI support
Rem    jzandate    08/04/23 - Enh 35651071 - Add property to delete ecra db
Rem    seha        08/03/23 - Enh 34546732 - Add EcLogScanner retry count
Rem    jiacpeng    07/18/23 - Redesign SLA feature to support vm cluster level
Rem                           SLA
Rem    caborbon    08/03/23 - Bug 35672672 - Fixing X10M-2 Catalog in
Rem                           ecs_hardware
Rem    kukrakes    08/03/23 - Bug 35670473 - FIX ALL SQL DIFFS BETWEEN
Rem                           ECS_MAIN_LINUX.X64_230802.1131 VS
Rem                           ECS_22.2.1.4.0_LINUX.X64_230728.0130 AND ADD TO
Rem                           NEW_ECRA_SCHEMA_CHANGES.SQL
Rem    aadavalo    08/03/23 - Bug 35669413 - Gold backup enabled by default in
Rem                           EBR, should be disabled
Rem    caborbon    08/01/23 - Bug 35664097 - setting X9M_FOR_LARGE property as
Rem                           ENABLED by default
Rem    kukrakes    08/01/23 - Bug 35661849 - EXACS:23.4.1:DROP1:ECRA ROLLING
Rem                           UPGRADE FROM ECS 22.2.1 TO 23.4.1:FAILING AT
Rem                           REGISTERUPGRADE:DEFAULT ERROR HANDLER: UNHANDLED
Rem                           EXCEPTION ENCOUNTERED.
Rem    gvalderr    07/26/23 - Modyfying elastic stepwise addition properties
Rem                           update statement.
Rem    essharm     07/25/23 - Bug 34710874 - ADD ECRA JOB TO GET SLA/SLO METRIC
Rem    abyayada    07/24/23 - 35617302 - ADD SUPPORT FOR CREATE READ ONLY PAR
Rem                           URL
Rem    llmartin    07/21/23 - Enh 35624372 - Create CEI_SKIP_SERASE property
Rem    jzandate    07/21/23 - Enh 35602217 - Adding properties for image
Rem                           version overrides for domu provision, only for
Rem                           adbd
Rem    essharm     07/18/23 - ADD TABLES FOR SLA/SLO FOR NEW APIS
Rem    jzandate    07/17/23 - Enh 35592332 - ECRA PREPROV - INCLUDE INSTANCE
Rem                           TYPE ON ECS_COMPUTE_INSTANCES
Rem    caborbon    07/14/23 - Bug 35567246 - Adding property to
Rem                           enabled/disabled X9M-2 Large
Rem    hcheon      07/10/23 - 34764008 Added LUMBERJACK_INFO
Rem    aadavalo    06/28/23 - Enh 35543208 - Add vmbackup status tracker
Rem    aadavalo    07/07/23 - Enh 35435491 - update reshape cluster to support
Rem                           filesystem resize
Rem    chandapr    07/06/23 - Bug 35422532 Add new table for exacc log
Rem                           monitoring
Rem    abysebas    07/05/23 - Bug 35428896 - ECRANG - DROP3 WITH ACTIVE-ACTIVE
Rem                           FAILS WHILE UPGRADING
Rem    caborbon    06/29/23 - Bug 35547722 - Fixing view issue in
Rem                           ecs_v_mvm_computes
Rem    gvalderr    06/22/23 - Modifying EXACLOUD_CS_SKIP_SWVERSION_CHECK
Rem                           property value
Rem    rmavilla    06/21/23 - EXACS-114176 PARTIAL RACK INGESTION:THE DEFAULT
Rem                           NODE_STATE POST ADD CABINET FOR THE CLUSTERLESS
Rem                           NODES IS 'FREE' INSTEAD OF 'UNDER_INGESTION'
Rem    rgmurali    06/19/23 - ER 35516416 - Add support for flex shapes
Rem    jzandate    06/13/23 - Bug 35402924 - Adding new tables for exadata 23
Rem                           compatibility matrix
Rem    ddelgadi    06/14/24 - Fix view ECS_EXAUNITDETAILS
Rem    rgmurali    06/17/23 - ER 35495109 - Automatic unlock on timeout
Rem    gvalderr    06/15/23 - Adding Filesystem_max property
Rem    caborbon    06/13/23 - Bug 35490871 - Adding model_subtype entry in
Rem                           ecs_hw_nodes view
Rem    caborbon    06/12/23 - Bug 35417101 - Adding support for X9M-2 Large -
Rem                           2TB
Rem    jzandate    06/08/23 - Bug 35402914 - Adding new column osver
Rem    jreyesm     06/02/23 - E.R 35446340. tenancy memory setting
Rem    abyayada    06/01/23 - Bug 35432526 - MAKE THE SQL CHANGES EBR
Rem                           COMPATIBLE IN TRANSACTION
Rem                           HTTPS://ORAREVIEW.US.ORACLE.COM/126730528
Rem                           ABYAYADA_BUG-34988256 (ECRA: CREATE INFRA API
Rem                           REQUEST SPECIAL ATTRIBUTE FOR RACK MIGRATION)
Rem    illamas     06/01/23 - Enh 35388181 - Adding more ONSR regions
Rem    jzandate    05/31/23 - Enh 35425757 - Adding compartment override by
Rem                           user input
Rem    illamas     05/30/23 - Enh 35403355 - SystemVaultInformation
Rem    hcheon      05/25/23 - 35414915 ECRA json logging
Rem    gvalderr    05/25/23 - Adding elastic stepwise addition properties
Rem    llmartin    05/26/23 - Enh 35403512 - Preprov, create bonded
Rem                           configuration
Rem    gvalderr    05/25/23 - Adding elastic stepwise addition properties
Rem    caborbon    05/19/23 - Bug 35370235 - Adding support for X10M-2
Rem                           ExtraLarge computes
Rem    llmartin    05/17/23 - Enh 35048274 - Preprov, launch vm cluster
Rem    gvalderr    05/12/23 - Adding changes to sshkeys_table
Rem    aadavalo    05/10/23 - EXACS-104356 - Add gold VM backup support for ecra
Rem    gvalderr    05/15/23 - Changing ECRA_STORAGE_DEST value to db
Rem    rgmurali    05/11/23 - ER 35384012 - Change stateid to string
Rem    jiacpeng    05/09/23 - add table to enable SLA by tenancy
Rem    illamas     05/02/23 - Enh 35268795 - Store nodeOcid and initiator
Rem    gvalderr    05/08/23 - Adding new column for nodes and cabinets table
Rem    illamas     05/06/23 - Enh 35268841 - Exacompute templates
Rem    ddelgadi    05/02/23 - Bug 35219691 Adding ecs_properties
Rem    caborbon    04/28/23 - Bug 35177584 - Adding support for X10M-2 Large
Rem                           Modesl
Rem    ririgoye    04/28/23 - Enh 35318144 - ECRA - PREPROV, ADD COLUMN TO
Rem                           DISABLE JOB
Rem    llmartin    04/28/23 - Bug 35332477 - Attach compute, fix multiple
Rem                           formation records
Rem    ybansod     04/26/23 - Enh 35201663 - Create table for system vault
Rem                           access
Rem    jyotdas     04/25/23 - ENH 35306446 - Make ECRA schema EBR compliant
Rem                           for Enh 35026545
Rem    ybansod     04/24/23 - Enh 35200493 - Add new table
Rem                           ecs_system_vault_table
Rem    aadavalo    04/17/23 - EBR SCHEMA CHANGES NOT IN PROPER FORMAT FOR
Rem                           ACTIVE ACTIVE
Rem    aadavalo    04/13/23 - Enh 35132786 - vm backup support for dom0 sending
Rem    aadavalo    03/30/23 - Enh 35182144 - Adding cron_schedule column to
Rem                           scheduled jobs
Rem    rgmurali    03/06/23 - ER 35080784 - Idempotency support for placement
Rem    rmavilla    03/03/23 - EXACS-91468 ALLOW ECRA TO IMPORT A PARTIALLY
Rem                           INGESTED CABINET
Rem    kukrakes    01/11/23 - ENH 34921831 - ECRA UPGRADE AND EBR FLOW
Rem                           (INCLUDES DEPLOYER , APPLICATION AND DATABASE
Rem                           CHANGES)
Rem    kukrakes    01/11/23 - Created
Rem

whenever sqlerror continue;
PROMPT Alter session and set new edition &1
ALTER SESSION SET EDITION = &1;

PROMPT Applying schema changes

--creating ecs_compute_instances_table
PROMPT creating table ecs_compute_instances_table
create table ecs_compute_instances_table (
    OCID VARCHAR2(256) NOT NULL,
    CAVIUMID VARCHAR2(256),
    RACKNAME VARCHAR2(256),
    HOSTNAMELABEL VARCHAR2(256),
    AVAILABILITYDOMAIN VARCHAR2(64),
    SHAPE VARCHAR2(64),
    COMPUTE_TYPE VARCHAR2(32) NOT NULL,
    CONSTRAINT pk_compute_instances
        PRIMARY KEY (OCID),
    CONSTRAINT fk_ecsracks_computeinstance
        FOREIGN KEY(RACKNAME)
            REFERENCES ECS_RACKS_TABLE(NAME)
);

-- create ecs_oci_subnets_table
PROMPT creating table ecs_oci_subnets_table
create table ecs_oci_subnets_table (
    OCID VARCHAR2(256) NOT NULL,
    VCNOCID VARCHAR2(256),
    NAME VARCHAR2(256),
    CIDRBLOCK VARCHAR2(64),
    SUBNETTYPE VARCHAR2(64),
    AVAILABILITYDOMAIN VARCHAR2(64),
    DOMAIN VARCHAR2(256),
    CONSTRAINT pk_oci_subnets
        PRIMARY KEY (OCID),
    CONSTRAINT fk_atpclientvcn_ocisubnet
        FOREIGN KEY(VCNOCID)
            REFERENCES ECS_ATPCLIENT_VCN_TABLE(VCN_ID)
);

PROMPT Enh 33509359 Creating ecs_exacompute_entity_table
create table ecs_exacompute_entity_table
(
    rack_name      varchar2(256) not null,
    cluster_id     varchar2(256) not null,
    cluster_name   varchar2(256) not null,
    atp            clob,
    cells          varchar2(256),
    cluster_vault  varchar2(256),
    dom0_bonding   varchar2(8),
    exaunit_allocations clob,
    grid_version   varchar2(8) not null,
    service_type    varchar2(16) not null,
    storage_type    varchar2(16) not null,
    CONSTRAINT exacompute_entity_pk PRIMARY KEY(rack_name)
);

PROMPT creating table ecs_oci_vnics_table
create table ecs_oci_vnics_table (
    OCID VARCHAR2(256) NOT NULL,
    INSTANCEOCID VARCHAR2(256),
    SUBNETOCID VARCHAR2(256),
    HOSTNAMELABEL VARCHAR2(256),
    PRIMARYIP VARCHAR2(64),
    VLANTAG VARCHAR2(256),
    ATTACHMENTID VARCHAR2(256),
    MACADDRESS VARCHAR2(16),
    ISPRIMARY NUMBER(1,0),
    CONSTRAINT pk_oci_vnics
        PRIMARY KEY (OCID),
    CONSTRAINT fk_computeinstance_ocivnic 
        FOREIGN KEY(INSTANCEOCID)
            REFERENCES ECS_COMPUTE_INSTANCES_TABLE(OCID),
    CONSTRAINT fk_ocisubnet_ocivnic 
        FOREIGN KEY(SUBNETOCID)
            REFERENCES ECS_OCI_SUBNETS_TABLE(OCID)
);

PROMPT Enh 32347095 - ecs_gold_specs_table
CREATE TABLE ecs_gold_specs_table(
    exaunit_id              number,
    type                    varchar2(32),
    target_machine          varchar2(8),
    target_machine_name     varchar2(512),
    network_communication   varchar2(4),
    validation_type         varchar2(32),
    name                    varchar2(512),
    expected                varchar2(64),
    current_value           varchar2(512),
    command                 varchar2(512),
    arguments               varchar2(512),
    expected_return_code    varchar2(4),
    current_return_code     varchar2(4),
    result                  varchar2(8),
    mandatory               varchar2(8),
    model                   varchar2(16),
    CONSTRAINT ecs_gold_specs
        PRIMARY KEY (exaunit_id,type,target_machine,network_communication,validation_type,name,target_machine_name,model),
    CONSTRAINT chk_type
        CHECK (type IN ('exacs', 'adbd','adbs')),
    CONSTRAINT chk_target_machine
        CHECK (target_machine IN ('domU', 'dom0','cell')),
    CONSTRAINT chk_network_communication
        CHECK (network_communication IN ('ib', 'kvm')),
    CONSTRAINT chk_validation_type
        CHECK (validation_type IN ('filesystem', 'command')),
    CONSTRAINT chk_mandatory
        CHECK (mandatory IN ('true','false'))
);

--Bug 36293266 - SERIAL CONSOLE CREATION FAILED ON ECRA 
PROMPT creating table ecs_oci_console_connection_table
create table ecs_oci_console_connection_table (
    ID NUMBER NOT NULL,
    VMHOSTNAME VARCHAR2(512) NOT NULL,
    EXAUNITID NUMBER NOT NULL,
    PORT NUMBER NOT NULL,
    DOM0 VARCHAR2(512) NOT NULL,
    EXA_OCID varchar2(512),
    CREATED_AT timestamp default systimestamp,
    CONSTRAINT pk_console_connection
        PRIMARY KEY (ID),
    CONSTRAINT fk_console_exaunit
        FOREIGN KEY(EXAUNITID)
            REFERENCES ECS_EXAUNITDETAILS_TABLE(EXAUNIT_ID),
    CONSTRAINT fk_console_exocid
        FOREIGN KEY(EXA_OCID)
            REFERENCES ECS_EXADATA_TABLE(exadata_id)
);
create sequence ecs_oci_console_conn_id_seq;

create or replace trigger ecs_oci_console_conn_id_seq
before insert on ecs_oci_console_connection_table 
for each row
begin
  select ecs_oci_console_conn_id_seq.nextval
  into :new.id
  from dual;
end;
/

--Enh 34972266 - EXACS Compatibility - create new tables to support compatibility on operations
PROMPT Creating table ecs_operations_compatibility_table
create table ecs_operations_compatibility_table (
    operation varchar2(50) not null,
    compatibleoperation varchar2(50) not null,
    env varchar2(20) DEFAULT ON NULL 'bm' NOT NULL,
    CONSTRAINT ecs_operations_compatibility_pk PRIMARY KEY (operation, compatibleoperation, env)
);

--Enh 37267618 - Expose ECRA api to return registered versions for image series in exacs
PROMPT Creating table ecs_exadata_patch_version_series_table
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

PROMPT Recreating editioning views on table ecs_exadata_patch_version_series_table
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

-- ENH 37071580 - Adding new fieds to keep node subtype at Infra Level
ALTER TABLE ecs_ceidetails_table ADD compute_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;
ALTER TABLE ecs_ceidetails_table ADD cell_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;

ALTER TABLE ecs_ceidetails_table DROP CONSTRAINT
  ck_ecs_ceidetails_compute_subtype;

ALTER TABLE ecs_ceidetails_table ADD
      CONSTRAINT ck_ecs_ceidetails_compute_subtype
        CHECK (compute_subtype in
             ('BASE',
              'STANDARD',
              'LARGE',
              'EXTRALARGE'));

ALTER TABLE ecs_ceidetails_table DROP CONSTRAINT
  ck_ecs_ceidetails_cell_subtype;

ALTER TABLE ecs_ceidetails_table ADD
      CONSTRAINT ck_ecs_ceidetails_cell_subtype
        CHECK (cell_subtype in
             ('BASE',
              'X-Z',
              'Z',
              'STANDARD',
              'EF'));

-- Add ingestion_status column to ecs_hw_nodes_table table
PROMPT Altering table ecs_hw_nodes_table
alter table ecs_hw_nodes_table
    add (ingestion_status varchar2(64) DEFAULT 'INGESTION_IN_PROGRESS' CHECK (ingestion_status in ('INGESTION_IN_PROGRESS', 'INGESTION_SUCCESS', 'INGESTION_HW_FAILURE', 'INGESTION_SW_FAILURE', 'INGESTION_FAILURE')));

-- Add availability column to ecs_hw_cabinets_table table
PROMPT Altering table ecs_hw_cabinets_table
alter table ecs_hw_cabinets_table add (compute_availability number DEFAULT 0);
alter table ecs_hw_cabinets_table add (cell_availability number DEFAULT 0);
ALTER TABLE ecs_hw_cabinets_table add (eth0 varchar2(1) default 'Y' not null);
-- Modify status column values of ecs_hw_nodes_table tables
ALTER TABLE ecs_hw_nodes_table MODIFY node_state DEFAULT 'UNDER_INGESTION';
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

-- Enh 37102944 - Modifying cluster size contraint in ecs_hw_nodes
alter table ecs_hw_nodes_table drop constraint ck_ecs_hw_nodes_clu_size;
ALTER TABLE ecs_hw_nodes_table add
      CONSTRAINT ck_ecs_hw_nodes_clu_size
        CHECK (cluster_size_constraint in
             ('12cell8comp3ibsw2pdu1ethsw',
              '12cell8comp2ibsw2pdu1ethsw',
              '12cell8comp3rocesw2pdu1ethsw',
              '12cell8comp2rocesw2pdu1ethsw',
              '6cell4comp3ibsw2pdu1ethsw',
              '6cell4comp2ibsw2pdu1ethsw',
              '6cell4comp3rocesw2pdu1ethsw',
              '6cell4comp2rocesw2pdu1ethsw',
              '3cell2comp3ibsw2pdu1ethsw',
              '3cell2comp2ibsw2pdu1ethsw',
              '3cell2comp3rocesw2pdu1ethsw',
              '3cell2comp2rocesw2pdu1ethsw',
              'half_3cell2comp3ibsw2pdu1ethsw',
              'half_3cell2comp2ibsw2pdu1ethsw',
              '24cell16comp6ibsw4pdu2ethsw',
              '15cell2rocesw2pdu1ethsw',
              '18comp2rocesw2pdu1ethsw',
              '14comp2rocesw2pdu1ethsw',
              '12comp2rocesw2pdu1ethsw',
              '9cell6comp2rocesw2pdu1ethsw',
              'other'));

-- Adding subtype column to ecs_hw_nodes_table 
ALTER TABLE ecs_hw_nodes_table RENAME COLUMN subtype to model_subtype;
--ALTER TABLE ecs_hw_nodes_table MODIFY (model_subtype varchar(64) default 'STANDARD');
--ALTER TABLE ecs_hw_nodes_table MODIFY (model_subtype varchar(64) NOT NULL);
ALTER TABLE ecs_hw_nodes_table MODIFY (model_subtype DEFAULT NULL);
ALTER TABLE ecs_hw_nodes_table MODIFY (model_subtype varchar2(64) DEFAULT ON NULL 'STANDARD' NOT NULL);
ALTER TABLE ecs_hw_nodes_table add (model_subtype varchar2(64) DEFAULT ON NULL 'STANDARD' NOT NULL);

-- Enh 35304498 - ADD STATUS_COMMENT COLUMN TO CABINET AND NODES TABLES  
PROMPT Altering table ecs_hw_nodes_table
ALTER TABLE ecs_hw_nodes_table ADD status_comment VARCHAR2(4000);

PROMPT Altering table ecs_hw_cabinets_table
ALTER TABLE ecs_hw_cabinets_table ADD status_comment VARCHAR2(4000);

-- Enh 35892155 - Ecra Indigo - Create Backfilling Apis To Populate Indigo Data
ALTER TABLE ECS_HW_CABINETS_TABLE ADD (SITEGROUP varchar2(256));
ALTER TABLE ECS_HW_CABINETS_TABLE ADD (RESTRICTED_SITEGROUP varchar2(64));
ALTER TABLE ECS_HW_CABINETS_TABLE MODIFY  RESTRICTED_SITEGROUP   DEFAULT 'N';
UPDATE ECS_HW_CABINETS_TABLE SET RESTRICTED_SITEGROUP = 'N' WHERE RESTRICTED_SITEGROUP IS NULL;

-- Enh 36165741 - EXACS: After termination of cei, elastic shape nodes needs to be patched to latest exadata version
ALTER TABLE ECS_HW_CABINETS_TABLE
ADD (auto_maintenance varchar2(64) DEFAULT ON NULL 'Y' NOT NULL);

-- Enh 36334590 - Adding column ECS_HW_CABINET to determine if a cabinet is dedicated or shared 
ALTER TABLE ECS_HW_CABINETS_TABLE ADD ( OPSTATE varchar2(128) DEFAULT ON NULL 'DEDICATED' NOT NULL);
ALTER TABLE ECS_HW_CABINETS_TABLE DROP CONSTRAINT ck_ecs_hw_cabinets_opstate;
ALTER TABLE ECS_HW_CABINETS_TABLE add CONSTRAINT ck_ecs_hw_cabinets_opstate
      CHECK (OPSTATE in ('SHARED', 'DEDICATED'));

-- Add nodeId and initiatorId to ecs_hw_cabinets_table table
ALTER TABLE ecs_hw_nodes_table add (node_ocid varchar2(128));
ALTER TABLE ecs_hw_nodes_table add (initiator_id varchar2(128));
alter table ecs_hw_nodes_table add maintenance_domain_id number default -1;
ALTER TABLE ecs_hw_nodes_table add (servicetype varchar2(64) default 'exacs');
ALTER TABLE ecs_hw_nodes_table ADD (
    localbackupenabled CHAR(1) DEFAULT 'Y' NOT NULL,
    ossbackupenabled CHAR(1) DEFAULT 'Y' NOT NULL
);
ALTER TABLE ecs_hw_nodes_table add (exasplice_version varchar2(128));

-- altering table ecs_exadata_vcompute_node_table
ALTER TABLE ecs_exadata_vcompute_node_table ADD (vm_state varchar2(50) DEFAULT NULL);
ALTER TABLE ecs_exadata_vcompute_node_table ADD last_vm_state_change_time TIMESTAMP;

PROMPT Altering table ecs_atpadminidentity for adding private_key_content column
ALTER TABLE ecs_atpadminidentity_table ADD private_key_content varchar2(4000);

PROMPT Altering table state_store_table
alter table state_store_table add (plan clob);
alter table state_store_table add (state_id varchar2(4000));
alter table state_store_table add constraint state_store_unique_stateid UNIQUE (state_id);

PROMPT Altering table state_lock_data_table
alter table state_lock_data_table add (lock_acquired_time varchar2(128));   

PROMPT Altering table ecs_scheduledjob_table
alter table ECS_SCHEDULEDJOB_TABLE add (cron_schedule varchar2(64));

PROMPT Altering table ecs_zones_table
ALTER TABLE ecs_zones_table MODIFY username varchar2(256) NULL;
ALTER TABLE ecs_zones_table MODIFY passwd NULL;
ALTER TABLE ecs_zones_table ADD subnetocid varchar2(256);
ALTER TABLE ecs_zones_table DROP CONSTRAINT ecs_zones_location_ck;

PROMPT Altering table ecs_oci_console_connection_table
ALTER TABLE ecs_oci_console_connection_table DROP CONSTRAINT FK_CONSOLE_EXOCID;

--creating ecs_wf_auto_retry_action_rule_table
PROMPT creating table ecs_wf_auto_retry_action_rule_table
create table ecs_wf_auto_retry_action_rule_table (
    wfname VARCHAR2(256) NOT NULL,
    taskname VARCHAR2(256),
    errorcode VARCHAR2(256),
    action VARCHAR2(256),
    CONSTRAINT wf_actionrule_pk PRIMARY KEY(wfname, taskname, errorcode)
);

CREATE OR REPLACE EDITIONING VIEW ecs_wf_auto_retry_action_rule AS
SELECT
        wfname,
        taskname,
        errorcode,
        action
FROM ecs_wf_auto_retry_action_rule_table;


-- Enh 35592332 - ECRA PREPROV - INCLUDE INSTANCE TYPE ON ECS_COMPUTE_INSTANCES
PROMPT Altering table ecs_compute_instances_table
ALTER TABLE ecs_compute_instances_table ADD computetype VARCHAR2(32) DEFAULT 'PREPROV' NOT NULL;
ALTER TABLE ecs_compute_instances_table ADD CONSTRAINT ck_ecs_comp_inst_type
      CHECK (computetype in ('CLIENT', 'ADMIN', 'PREPROV'));

PROMPT Altering table ECS_EXASERVICE_TABLE
ALTER TABLE ECS_EXASERVICE_TABLE ADD STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE_TABLE ADD AVAILABLE_STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE_TABLE ADD VMSTORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE_TABLE ADD AVAILABLE_VMSTORAGEXSGB NUMBER DEFAULT 0;

PROMPT Altering table ECS_EXASERVICE_ALLOCATIONS_TABLE
ALTER TABLE ECS_EXASERVICE_ALLOCATIONS_TABLE ADD STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE_ALLOCATIONS_TABLE ADD VMSTORAGEXSGB NUMBER DEFAULT 0;

-- Enh 35435491 - UPDATE RESHAPE CLUSTER TO SUPPORT FILESYSTEM RESIZE
PROMPT Altering table ECS_EXASERVICE_RESERVED_ALLOC_TABLE
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE ADD FILESYSTEMSGB NUMBER;
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE ADD REQUEST_ID varchar2(128);

ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE ADD STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE ADD VMSTORAGEXSGB NUMBER DEFAULT 0;

PROMPT Altering table ecs_oci_subnets_table
ALTER TABLE ecs_oci_subnets_table DROP CONSTRAINT ck_ecs_oci_subnets_type;
ALTER TABLE ecs_oci_subnets_table ADD  CONSTRAINT ck_ecs_oci_subnets_type
      CHECK (subnettype in ('CLIENT', 'ADMIN', 'BACKUP'));

-- change for ecs_oci_vnics_table
PROMPT Altering table ecs_oci_vnics
ALTER TABLE ecs_oci_vnics_table MODIFY MACADDRESS VARCHAR2(26);
ALTER TABLE ecs_oci_vnics_table ADD (RACKNAME varchar2(256));

-- Bug 36023027 - Preprov, change zone lenght in ECS_ZONES_TABLE
PROMPT Altering table ECS_ZONES_TABLE
ALTER TABLE ecs_zones_table MODIFY ZONE VARCHAR2(256);

PROMPT Altering tables for ecs_rocefabric_table
alter table ecs_rocefabric_table add total_duration number;
alter table ecs_rocefabric_table add notification_duration number;
alter table ecs_rocefabric_table add total_mds number;
alter table ecs_rocefabric_table add current_md_id number;
alter table ecs_rocefabric_table add extended_vlan_start number default 4097;
alter table ecs_rocefabric_table add extended_vlan_end number default 59456;

--Enh EXACS-125310 - QFAB reservation for capacity expansion
alter table ecs_rocefabric_table add X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric_table add X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric_table add X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric_table add X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
-- QFAB level default is ENABLED, but the feature is only enabled if AD level switch in ecs_properties <model>_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS is also set to ENABLED 
alter table ecs_rocefabric_table add X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS varchar2(10) default 'ENABLED';
alter table ecs_rocefabric_table add CONSTRAINT override_capacity_constr_x8m CHECK (X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS in ('ENABLED', 'DISABLED'));
alter table ecs_rocefabric_table add X9M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS varchar2(10) default 'ENABLED';
alter table ecs_rocefabric_table add CONSTRAINT override_capacity_constr_x9m CHECK (X9M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS in ('ENABLED', 'DISABLED'));

ALTER TABLE ECS_ROCEFABRIC_TABLE MODIFY EXTENDED_VLAN_START DEFAULT 6000;
ALTER TABLE ECS_ROCEFABRIC_TABLE MODIFY EXTENDED_VLAN_END DEFAULT 58000;

ALTER TABLE ecs_atpclient_vcn_table ADD compartmentocid varchar2(256);
ALTER TABLE ecs_atpclient_vcn_table ADD cidrblock varchar2(64);

PROMPT Altering table ecs_customvip_table
ALTER TABLE ecs_customvip_table ADD ipocid varchar2(256);
ALTER TABLE ecs_customvip_table ADD vnicocid varchar2(256);
ALTER TABLE ecs_customvip_table ADD zoneocid varchar2(256);
ALTER TABLE ecs_customvip_table ADD iptype varchar2(64) DEFAULT 'CUSTOMVIP' NOT NULL;
ALTER TABLE ecs_customvip_table ADD customipv6 varchar2(64);
ALTER TABLE ecs_customvip_table ADD ipv6ocid varchar2(256);

PROMPT Altering table ecs_hardware_table
alter table ecs_hardware_table add (tbStorage number not null);
ALTER TABLE ecs_hardware_table add (env varchar2(20) DEFAULT ON NULL 'bm' NOT NULL);
alter table ecs_hardware_table drop constraint HARDWARE_PK;
alter table ecs_hardware_table add CONSTRAINT "HARDWARE_PK" PRIMARY KEY ("MODEL", "RACKSIZE", "ENV");
alter table ecs_hardware_table add (ecpufactor number null);

PROMPT Altering table ecs_oh_space_rule_table;
ALTER TABLE ecs_oh_space_rule_table add (env varchar2(20) DEFAULT ON NULL 'bm' NOT NULL);
ALTER TABLE ecs_oh_space_rule_table drop constraint OH_SPACE_RULE_PK;
ALTER TABLE ecs_oh_space_rule_table add CONSTRAINT "OH_SPACE_RULE_PK" PRIMARY KEY ("MODEL", "RACKSIZE", "PHYSICALSPACEINGB","ENV");

PROMPT Altering table ecs_gold_specs_table
ALTER TABLE ecs_gold_specs_table DROP CONSTRAINT chk_type;
ALTER TABLE ecs_gold_specs_table
    ADD CONSTRAINT chk_type
        CHECK (type IN ('exacs', 'adbd','adbs','exacsmvm','exacsminspec','exacsmvmminspec','adbdmvm','fa','exacsexacompute','exacc','exaccadbd','exaccmvm','exaccadbdmvm','exacsexacompute19c','exacomputebasedb'));
alter table ecs_gold_specs_table modify type VARCHAR2(32);
alter table ecs_gold_specs_table modify expected varchar2(2048);
alter table ecs_gold_specs_table modify current_value varchar2(2048);
alter table ecs_gold_specs_table add mutable varchar2(16) default 'false';

-- Enh 36228424 - ECRA infra patch registration supports rack model
PROMPT Altering tables ecs_exadata_patch_versions_table
alter table ecs_exadata_patch_versions_table drop constraint pk_exadata_patch_versions;
ALTER TABLE ecs_exadata_patch_versions_table ADD (rack_model varchar2(100) DEFAULT 'NOMODEL' NOT NULL);
alter table ecs_exadata_patch_versions_table add constraint pk_exadata_patch_versions primary key (service_type ,patch_type,target_type, rack_model );

-- Enh 35870618 - EXACS ELASTIC - ADD QUANTITY OF SERVERS PER MODEL IN ECRA METADATA
PROMPT Altering table ecs_elastic_platform_info_table
ALTER TABLE ecs_elastic_platform_info_table ADD maxComputes NUMBER DEFAULT 1 NOT NULL;
ALTER TABLE ecs_elastic_platform_info_table ADD maxCells NUMBER DEFAULT 1 NOT NULL;

-- Enh 36197323 - ECRA CAN PROVIDE LOCATION OF ILOM ON SUBSTRATE OR OVERLAY FOR ALL SUPPORTED SHAPES
ALTER TABLE ecs_elastic_platform_info_table ADD ilomtype varchar2(64);
ALTER TABLE ecs_elastic_platform_info_table ADD support_status varchar2(64);

-- Enh 36922155 - EXACS X11M - Base system support
ALTER TABLE ecs_elastic_platform_info_table ADD (feature varchar2(64) DEFAULT 'CROSS_PLATFORM' NOT NULL);
ALTER TABLE ecs_elastic_platform_info_table ADD (hw_type varchar2(64) DEFAULT 'ALL' NOT NULL);
ALTER TABLE ecs_elastic_platform_info_table drop constraint pk_ecs_elastic_platform_info;
ALTER TABLE ecs_elastic_platform_info_table add constraint pk_ecs_elastic_platform_info primary key (model,feature,hw_type);

-- Enh 37179993 - EXACS X11M - Adding the codename that exacloud needs for each model/subtype 
ALTER TABLE ecs_elastic_platform_info_table ADD (oeda_codename varchar2(64));  

--Enh 36628793 - ECRA EXACS - Add property description column for new properties
PROMT Altering table ecs_properties_table
ALTER TABLE ecs_properties_table ADD description varchar2(512);

-- ALTER only if col size is not 255
PROMPT Altering ecs_rotation_schedule
DECLARE
    scol_len  USER_TAB_COLS.DATA_LENGTH%TYPE;
    vcol_len  USER_TAB_COLS.DATA_LENGTH%TYPE;
BEGIN
    SELECT DATA_LENGTH INTO scol_len FROM USER_TAB_COLS WHERE LOWER(column_name) = 'secret_name' AND LOWER(table_name) = 'ecs_rotation_schedule_table';
    SELECT DATA_LENGTH INTO vcol_len FROM USER_TAB_COLS WHERE LOWER(column_name) = 'vault_name' AND LOWER(table_name) = 'ecs_rotation_schedule_table';
    IF (scol_len != 255) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ecs_rotation_schedule_table modify secret_name varchar2(255)';
        COMMIT;
    END IF;
    IF (vcol_len != 255) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ecs_rotation_schedule_table modify vault_name varchar2(255)';
        COMMIT;
    END IF;
END;
/

CREATE OR REPLACE EDITIONING VIEW ecs_oci_subnets AS
SELECT
        OCID,
        VCNOCID,
        NAME,
        CIDRBLOCK,
        SUBNETTYPE,
        AVAILABILITYDOMAIN,
        DOMAIN
FROM ecs_oci_subnets_table;

PROMPT Recreating editioning views on table ecs_oh_space_rule_table
CREATE OR REPLACE EDITIONING VIEW ecs_oh_space_rule AS
SELECT
    MODEL,
    RACKSIZE,
    PHYSICALSPACEINGB,
    USEABLEOHSPACEINGB,
    MAX_OHSIZE_PER_NODE,
    ENV
FROM
    ecs_oh_space_rule_table;

CREATE OR REPLACE EDITIONABLE VIEW ecs_oh_space_rule_filtered AS
SELECT
    MODEL,
    RACKSIZE,
    PHYSICALSPACEINGB,
    USEABLEOHSPACEINGB,
    MAX_OHSIZE_PER_NODE,
    ENV
FROM
    ecs_oh_space_rule_table
WHERE 
    ENV = (SELECT NVL((SELECT VALUE FROM ECS_PROPERTIES WHERE NAME = 'ECRA_ENV' 
      AND ROWNUM = 1),'bm') FROM DUAL);

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
    ENV
FROM
    ecs_hardware_table;

PROMPT Recreating editioning views on table ecs_rocefabric_table
CREATE OR REPLACE EDITIONING VIEW ecs_rocefabric AS
SELECT
    fabric_name,
    fabric_type,
    total_duration,
    notification_duration,
    total_mds,
    current_md_id,
    X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD,
    X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD,
    X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD,
    X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD,
    X9M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS,
    X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS,
    extended_vlan_start,
    extended_vlan_end
FROM ecs_rocefabric_table;

PROMPT Recreating editioning views on table ecs_compute_instances_table 
CREATE OR REPLACE EDITIONING VIEW ECS_COMPUTE_INSTANCES AS
    SELECT
        OCID,
        CAVIUMID,
        RACKNAME,
        HOSTNAMELABEL,
        AVAILABILITYDOMAIN,
        SHAPE,
        COMPUTETYPE
    FROM
        ECS_COMPUTE_INSTANCES_TABLE;

PROMPT Recreating editioning views on table ECS_EXASERVICE_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_EXASERVICE AS
    SELECT
        ID,
        EXADATA_ID,
        RACKSIZE,
        MODEL,
        BASE_CORES,
        ADDITIONAL_CORES,
        BURST_CORES,
        MEMORYGB,
        STORAGEGB,
        NAME,
        PURCHASETYPE,
        PAYLOAD_ARCHIVE,
        TOTAL_OHSTORAGEGB,
        AVAIL_OHSTORAGEGB,
        IAAS,
        SUSPEND_ON_CREATE,
        SERVICE_STATUS,
        STORAGEXSGB,
        AVAILABLE_STORAGEXSGB,
        VMSTORAGEXSGB,
       AVAILABLE_VMSTORAGEXSGB
    FROM
        ECS_EXASERVICE_TABLE;

PROMPT Recreating editioning views on table ECS_EXASERVICE_ALLOCATIONS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_EXASERVICE_ALLOCATIONS AS
    SELECT
        EXASERVICE_ID,
        METERED_CORES,
        MEMORYGB,
        USABLE_OHSTORAGEGB,
        STORAGEGB,
        NODE_WISE_ALLOCATIONS,
        STORAGEXSGB,
        VMSTORAGEXSGB
    FROM
        ECS_EXASERVICE_ALLOCATIONS_TABLE;

PROMPT Recreating editioning views on table ECS_EXASERVICE_RESERVED_ALLOC_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_EXASERVICE_RESERVED_ALLOC AS
    SELECT
        RACKNAME,
        EXASERVICE_ID,
        METERED_CORES,
        MEMORYGB,
        USABLE_OHSTORAGEGB,
        STORAGEGB,
        RESERVE_TYPE,
        REQUEST_ID,
        NODE_WISE_ALLOCATIONS,
        FILESYSTEMSGB,
        STORAGEXSGB,
        VMSTORAGEXSGB
    FROM
        ECS_EXASERVICE_RESERVED_ALLOC_TABLE;

PROMPT Recreating editioning views on table ECS_INFRA_RESOURCEPRINCIPAL_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_INFRA_RESOURCEPRINCIPAL AS
    SELECT
        EXAOCID,
        UUID,
        RESOURCEPRINCIPAL
    FROM
        ECS_INFRA_RESOURCEPRINCIPAL_TABLE;

PROMPT Recreating editioning views on table ECS_CEIDETAILS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_CEIDETAILS AS
    SELECT
	CEIOCID,
	RACKNAME,
	INITIAL_NODES,
	COMPUTE_SUBTYPE,
	CELL_SUBTYPE,
	RACKNAME_GENERATED,
	FSM_STATE,
	PROVISIONTYPE,
	VM_REF_COUNT,
	STORAGE_VLAN,
	MULTIVM,
	MODEL,
	TENANCYNAME,
	TENANCYOCID     
    FROM
        ECS_CEIDETAILS_TABLE;

PROMPT Updating values for ecs_properties_table
UPDATE ecs_properties_table SET value='X9M-2,X10M-2,X11M' WHERE name='PURE_ELASTIC_MODELS';


-- EXACS-104356 - Add CreateGoldImageBackup support
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_OSS_BACKUP', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_LOCAL_BACKUP', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_GOLD_BACKUP', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_BACKUP_SUCONFIG_TENANCY_OCID', 'ECRA', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_BACKUP_WAITTIME_BATCHES', 'ECRA', '120');
INSERT INTO ecs_properties (name, type, value) VALUES ('STATE_STORE_TIMEOUT', 'ECRA', '300000');

-- Fedramp
INSERT INTO ecs_properties_table (name, type, value) VALUES ('CPS_CERT_ROTATE_PATH', 'FEATURE', '/tmp/cert');

INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OBSERVER_FLEXSHAPE_CORES', 'ATP', '8.0');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OBSERVER_FLEXSHAPE_MEMORY', 'ATP', '128.0');

-- Bug 35567246 - Adding property to handle 2TB memory in X9M-2 (aka X9M-2L)
INSERT INTO ecs_properties (name, type, value) VALUES ('LARGE_FOR_X9M','KVMROCE','ENABLED');

-- Property to control whether to abort infrapatching workflows on Failure
INSERT INTO ecs_properties (name, type, value) VALUES ('ABORT_INFRAPATCH_WORKFLOWS_ON_FAILURE', 'PATCHING', 'ENABLED');
-- Property to control triggering of single request infrapatching
INSERT INTO ecs_properties (name, type, value) VALUES ('SINGLE_REQUEST_INFRAPATCH_OPERATION', 'PATCHING', 'DISABLED');

-- Enh 36576562 - Adding property to define the max SW version to use in CEI
INSERT INTO ecs_properties (name, type, value) VALUES ('INFRA_DEFAULT_MAX_VERSION', 'EXADATA', 'DISABLED');

-- Enh 36564221 - Adding property for Exadata Early Adopter Version
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_EARLY_ADOPTER_VERSION', 'EXADATA', 'DISABLED');

-- Enh 36641332 - Adding property for Exadata ATP Early Adopter Version
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_ATP_EARLY_ADOPTER_VERSION', 'EXADATA', '24.1');

-- Bug 36969730 - Adding back the property to content the override version for ATP Early Adopter Feature
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_OS_VERSION_OVERRIDING_ATP', 'FEATURE', '');

-- Bug 36969730 Early Adopter related properties to be update with description and FEATURE as type value
UPDATE ecs_properties_table set type='FEATURE', description='Property to set exact version that domU needs for ATP cluster if Early Adopter is enabled for ATP and its version match with the version of the Infrastructure' where NAME='DOMU_OS_VERSION_OVERRIDING_ATP';
UPDATE ecs_properties_table set type='FEATURE', description='Defines the Exadata SW version to be consider as Early Adopter Version for EXACS provisionings (Example 24.1), use DISABLED to turn this feature off' where NAME = 'EXADATA_EARLY_ADOPTER_VERSION';
UPDATE ecs_properties_table set type='FEATURE', description='Defines the Exadata SW version to be consider as Early Adopter Version for ATP/ADBD provisionings (Example 24.1), use DISABLED to turn this feature off' where NAME = 'EXADATA_ATP_EARLY_ADOPTER_VERSION';
UPDATE ecs_properties_table set type='FEATURE', description='Defines if this Region should ONLY use nodes with SW Version = EARLY ADOPTER, use ENABLED/DISABLED as values' where NAME = 'EXADATA_EARLY_ADOPTER_VERSION_FORCE';
UPDATE ecs_properties_table set type='FEATURE', description='Defines a Maximum version from Exadata SW that the nodes can have for new Infrastructure' where NAME = 'INFRA_DEFAULT_MAX_VERSION';

-- Enh 36659169 - Adding property to force the use of nodes with Early Adopter version
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_EARLY_ADOPTER_VERSION_FORCE', 'EXADATA', 'DISABLED');

-- Enh 36754615 - Adding property to force the use of FS Encryption to all provisionings
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('FS_ENCRYPTION_FOR_ALL','FEATURE','DISABLED','Property to force FS Encryption by region');

-- Enh 36955594 -  Adding property to control if FS Encryption is allowed or not for ATP provisionings
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('FS_ENCRYPTION_FOR_ATP','FEATURE','DISABLED','Property to Allow/Avoid FS Encryption in ATP clusters');

-- EXACS-125310 - QFAB reservation for expansion in highly utilized QFABs
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X8M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X8M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X9M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X9M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS', 'ELASTIC', 'DISABLED', 'Enable/Disable QFAB reservation of X8M nodes for elastic expansion once the utilization goes above threshold');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X9M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS', 'ELASTIC', 'DISABLED', 'Enable/Disable QFAB reservation of X9M nodes for elastic expansion once the utilization goes above threshold');

-- EXACS-138437 Ecra to support extended cluster vlan
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('EXTENDED_CLUSTER_ID', 'ECRA', 'DISABLED', 'Enable/Disable extended cluster id for vlan allocation');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('EXTENDED_CLUSTER_ID_MIN_SW_VER', 'ECRA', '24.1.0', 'Minimum software version supporting extended cluster id, first three numbers');

CREATE OR REPLACE PACKAGE state_mgmt
    AS
    PROCEDURE state_lock(
                o_return       OUT number,
                o_lock_handle  OUT state_lock_data.lock_handle%TYPE,
                o_state_handle OUT state_lock_data.state_handle%TYPE);
    PROCEDURE state_insert_unlock(
                o_return       OUT number,
                o_state_handle OUT state_lock_data.state_handle%TYPE,
                r_lock_handle  IN  state_lock_data.lock_handle%TYPE,
                r_state_handle IN  state_lock_data.state_handle%TYPE,
                r_state_data   IN  CLOB
                );
    PROCEDURE state_unlock(
                o_return         OUT number,
                o_state_handle   OUT state_lock_data.state_handle%TYPE,
                r_lock_handle    IN  state_lock_data.lock_handle%TYPE,
                r_state_handle   IN  state_lock_data.state_handle%TYPE
                );
    PROCEDURE state_query(
                o_return       OUT number,
                o_state_data   OUT CLOB,
                i_state_handle IN  state_lock_data.state_handle%TYPE
                );
END state_mgmt;
/

CREATE OR REPLACE PACKAGE BODY state_mgmt AS
    PROCEDURE state_lock(o_return       OUT number,
                         o_lock_handle  OUT state_lock_data.lock_handle%TYPE,
                         o_state_handle OUT state_lock_data.state_handle%TYPE)
    IS
        cur_lock_handle  state_lock_data.lock_handle%TYPE;
        cur_state_handle state_lock_data.state_handle%TYPE;
        row_locked EXCEPTION;
        PRAGMA EXCEPTION_INIT(row_locked, -54); -- OER(54) - locked row
    BEGIN
        o_return := 1;
        -- Select the only row in the state lock data in update mode.
        SELECT lock_handle, state_handle
            INTO cur_lock_handle, cur_state_handle
        FROM state_lock_data
        WHERE rownum = 1
            AND lock_state = 'FREE'
        FOR UPDATE NOWAIT;
         
        -- Lock is free, bump the generation count and set the status
        o_lock_handle  := cur_lock_handle + 1;
        o_state_handle := cur_state_handle;
         
        -- Update to locked state
        UPDATE state_lock_data
        SET lock_handle = o_lock_handle,
            lock_state = 'LOCKED'
        WHERE rownum = 1
            AND lock_state = 'FREE';
         
        -- Successfully locked the state, commit to release the row lock.
        COMMIT;
         
        EXCEPTION
            WHEN no_data_found THEN
                o_lock_handle := 0;
                o_return  := 0;
            WHEN row_locked THEN
                o_lock_handle := 0;
                o_return  := 2;
    END state_lock;

    PROCEDURE state_insert_unlock(
                o_return         OUT number,
                o_state_handle   OUT state_lock_data.state_handle%TYPE,
                r_lock_handle    IN  state_lock_data.lock_handle%TYPE,
                r_state_handle   IN  state_lock_data.state_handle%TYPE,
                r_state_data IN  CLOB
                )
    IS
        cur_lock_handle  state_lock_data.lock_handle%TYPE;
        cur_state_handle state_lock_data.state_handle%TYPE;
        row_locked EXCEPTION;
        PRAGMA EXCEPTION_INIT(row_locked, -54); -- OER(54) - locked row
    BEGIN
        o_return := 1;
        -- Select the only row in the state lock data in update mode. It should
        -- match the caller's generation count and state information
        SELECT lock_handle, state_handle
            INTO cur_lock_handle, cur_state_handle
        FROM state_lock_data
        WHERE rownum = 1
            AND lock_state = 'LOCKED'
            AND state_handle = r_state_handle
            AND lock_handle = r_lock_handle
        FOR UPDATE NOWAIT;
         
        cur_lock_handle := cur_lock_handle + 1;
         
        -- TODO - generate proper state id
        o_state_handle := cur_state_handle + 1;
         
        -- Insert new state
        INSERT INTO state_store (STATE_HANDLE, STATE_DATA)
            VALUES(o_state_handle, r_state_data);
         
        -- Update to free state
        UPDATE state_lock_data
        SET lock_handle = cur_lock_handle,
            state_handle = o_state_handle,
            lock_state = 'FREE'
        WHERE rownum = 1
            AND lock_state = 'LOCKED';
             
        COMMIT;
             
        EXCEPTION
            WHEN no_data_found THEN
                o_state_handle := 0;
                o_return   := 0;
            WHEN row_locked THEN
                o_state_handle := 0;
                o_return   := 2;
                 
    END state_insert_unlock;

    PROCEDURE state_unlock(
                o_return         OUT number,
                o_state_handle   OUT state_lock_data.state_handle%TYPE,
                r_lock_handle    IN  state_lock_data.lock_handle%TYPE,
                r_state_handle   IN  state_lock_data.state_handle%TYPE
                )
    IS
        cur_lock_handle  state_lock_data.lock_handle%TYPE;
        cur_state_handle state_lock_data.state_handle%TYPE;
        row_locked EXCEPTION;
        PRAGMA EXCEPTION_INIT(row_locked, -54); -- OER(54) - locked row
    BEGIN
        o_return := 1;
        -- Select the only row in the state lock data in update mode. It should
        -- match the caller's generation count and state information
        SELECT lock_handle, state_handle
            INTO cur_lock_handle, cur_state_handle
        FROM state_lock_data
        WHERE rownum = 1
            AND lock_state = 'LOCKED'
            AND state_handle = r_state_handle
            AND lock_handle = r_lock_handle
        FOR UPDATE NOWAIT;
         
        cur_lock_handle := cur_lock_handle + 1;
        o_state_handle := r_state_handle;
         
        -- Update to free state
        UPDATE state_lock_data
        SET lock_handle = cur_lock_handle,
            state_handle = r_state_handle,
            lock_state = 'FREE'
        WHERE rownum = 1
            AND lock_state = 'LOCKED';
             
        COMMIT;
             
        EXCEPTION
            WHEN row_locked THEN
                o_state_handle := 0;
                o_return   := 0;
                 
    END state_unlock;
     
    PROCEDURE state_query(
                o_return        OUT number,
                o_state_data    OUT CLOB,
                i_state_handle  IN  state_lock_data.state_handle%TYPE
                )
    IS
    BEGIN
        SELECT state_data
            INTO o_state_data
        FROM state_store
        WHERE state_handle = i_state_handle;
         
        o_return := 1;
         
        EXCEPTION
            WHEN no_data_found THEN
                o_return := 0;
    END state_query;
     
END state_mgmt;
/

PROMPT Altering table ecs_kvmvlanpool_table
alter table ecs_kvmvlanpool_table drop constraint ecs_kvmvlanpool_vlantype_ck;
alter table ecs_kvmvlanpool_table add constraint ecs_kvmvlanpool_vlantype_ck CHECK (VLANTYPE in ('COMPUTE', 'STORAGE', 'RESERVED', 'EXASCALE', 'LEFT FOR EXPANSION', 'UNAVAILABLE', 'OCI_RESERVED', 'ARISTA_INTERNAL', 'PREPROV', 'ANY'));
ALTER TABLE ecs_cloudvnuma_tenancy_table add (memoryconfig varchar2(128) default 'STANDARD');
-- Enh 36576562 - Adding Early Adopter feature:
ALTER TABLE ecs_cloudvnuma_tenancy_table add (early_adopter varchar2(1) DEFAULT ON NULL 'N');
-- Enh 35990354 - Adding custom linux uid/gid feature
ALTER TABLE ecs_cloudvnuma_tenancy_table ADD (CUSTOM_UID_GID varchar2(512));
-- Enh 37497061 - SKIP RESIZEDGSIZES STEPS CONDITIONALLY FROM ADD CELL FLOW
ALTER TABLE ecs_cloudvnuma_tenancy_table add (skipresizedg varchar2(32) default 'no');

PROMPT Altering table ecs_cores_table
ALTER TABLE ecs_cores_table ADD (
    backupstatus CLOB
);
ALTER TABLE ecs_cores_table ADD (goldbackupstatus varchar2(64) default 'NotInstalled');

-- Enh 35756274 - Rename ecs_ad_locations to ecs_sitegroups
ALTER TABLE ECS_AD_LOCATIONS_TABLE rename column COMPUTE_ZONE to BUILDING;
ALTER TABLE ECS_AD_LOCATIONS_TABLE ADD NAME varchar2(256);
ALTER TABLE ECS_AD_LOCATIONS_TABLE ADD (RESTRICTED varchar2(64));
ALTER TABLE ECS_AD_LOCATIONS_TABLE DROP constraint FK_ECRA_INFOID_AD;
ALTER TABLE ECS_AD_LOCATIONS_TABLE RENAME TO ECS_SITEGROUPS_TABLE;
-- Enh 36858584 - Ecra: Multicloud: Add Site Group Data To Ecra
ALTER TABLE ECS_SITEGROUPS_TABLE ADD CLOUD_VENDOR varchar2(256)  DEFAULT 'OCI' NOT NULL;
ALTER TABLE ECS_SITEGROUPS_TABLE ADD CLOUD_PROVIDER_REGION varchar2(256) DEFAULT 'OCI' NOT NULL;
ALTER TABLE ecs_sitegroups_table drop constraint AD_PK;
ALTER TABLE ecs_sitegroups_table ADD CONSTRAINT "ECS_SITEGROUPS_PK" PRIMARY KEY ("NAME"); 
ALTER TABLE ECS_SITEGROUPS_TABLE ADD CLOUD_PROVIDER_AZ  varchar2(256);
ALTER TABLE ECS_SITEGROUPS_TABLE ADD CLOUD_PROVIDER_BUILDING varchar2(256);
-- Enh 37477523 - Exacs Sitegroup - Include Mtu Config Per Site Group
ALTER TABLE ECS_SITEGROUPS_TABLE ADD MTU number DEFAULT 9000;
ALTER TABLE ECS_SITEGROUPS_TABLE ADD FAR_CHILD_SITE varchar2(32) DEFAULT 'N';
ALTER TABLE ECS_SITEGROUPS_TABLE ADD OVERLAY_BRIDGE_USED varchar2(32) DEFAULT 'N';
-- Enh 37985641 - Exacs Ecra - Ecra To Configure Dbaas Tools Name Rpm Basd On Cloud Vendor
ALTER TABLE ECS_SITEGROUPS_TABLE ADD DBAASTOOLSRPM varchar2(100) DEFAULT 'dbaastools_exa_main.rpm';
ALTER TABLE ECS_SITEGROUPS_TABLE ADD DBAASTOOLSRPM_CHECKSUM varchar2(100);


-- Enh 37525577 - Adding CONFIGURED_FEATURES to site groups
PROMPT Adding CONFIGURED_FEATURES to site groups
ALTER TABLE ECS_SITEGROUPS_TABLE ADD (CONFIGURED_FEATURES varchar2(1024));

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

PROMPT Recreating editioning views on table ECS_CORES_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_CORES AS
    SELECT
        SERVICE,
        HOSTNAME,
        SUBSCOCPUS,
        METEROCPUS,
        BURSTOCPUS,
        RACKNAME,
        DOM0,
        BACKUPTIMESTAMP,
        BACKUPSTATUS,
        GOLDBACKUPSTATUS
    FROM
        ECS_CORES_TABLE;

PROMPT Recreating editioning views on table ECS_ATPADMINIDENTITY_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_ATPADMINIDENTITY AS
    SELECT
        TENANCY_OCID,
        REGION,
        COMPARTMENT_OCID,
        USER_OCID,
        FINGERPRINT,
        PRIVATE_KEY_PATH,
        PASSPHRASE,
        LOADBALANCER_OCID,
        DOMAIN,
        CERT_PATH,
        PRIVATE_KEY_CONTENT
    FROM
        ECS_ATPADMINIDENTITY_TABLE;

PROMPT Recreating editioning views on table ECS_HW_NODES_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_HW_NODES AS
    SELECT
        ID,
        CABINET_ID,
        IB_FABRIC_ID,
        ECS_RACKS_NAME_LIST,
        NODE_TYPE,
        NODE_MODEL,
        SW_VERSION,
        EXASPLICE_VERSION,
        DATE_MODIFIED,
        ORACLE_IP,
        ORACLE_HOSTNAME,
        ORACLE_ILOM_IP,
        ORACLE_ILOM_HOSTNAME,
        LOCATION_RACKUNIT,
        NODE_TYPE_ORDER_BOTTOM_UP,
        CLUSTER_SIZE_CONSTRAINT,
        NODE_STATE,
        IB1_HOSTNAME,
        IB1_IP,
        IB1_DOMAIN_NAME,
        IB1_NETMASK,
        IB2_HOSTNAME,
        IB2_IP,
        IB2_DOMAIN_NAME,
        IB2_NETMASK,
        HIGGS_BOND0_IP,
        HIGGS_BOND0_HOSTNAME,
        HIGGS_BOND0_NETMASK,
        HIGGS_BOND0_GATEWAY,
        DOM0_BONDING,
        MVMBONDING,
        CLUSTERTAG,
        CEIOCID,
        SERVICETYPE,
        NODE_OCID,
        INITIATOR_ID,
        ADMIN_MAC,
        NODE_SERIAL_NUMBER,
        MAINTENANCE_DOMAIN_ID,
        MODEL_SUBTYPE,
        INGESTION_STATUS,
        STATUS_COMMENT,
        LOCALBACKUPENABLED,
        OSSBACKUPENABLED
    FROM
        ECS_HW_NODES_TABLE;

--Enh 36754210 - ECRA: BACKFILL VNIC FOR THE EXISTING CABINETS
ALTER TABLE ECS_HW_CABINETS_TABLE ADD ADMIN_ACTIVE_VNIC varchar2(256) default NULL;
ALTER TABLE ECS_HW_CABINETS_TABLE ADD ADMIN_STANDBY_VNIC varchar2(256) default NULL;
ALTER TABLE ECS_HW_CABINETS_TABLE ADD SUBNET_OCID varchar2(256) default NULL;

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


PROMPT Recreating editioning views on table STATE_STORE_TABLE
CREATE OR REPLACE EDITIONING VIEW STATE_STORE AS
    SELECT
        STATE_HANDLE,
        STATE_DATA,
        PLAN,
        STATE_ID
    FROM
        STATE_STORE_TABLE;

PROMPT Recreating editioning views on table STATE_LOCK_DATA_TABLE
CREATE OR REPLACE EDITIONING VIEW STATE_LOCK_DATA AS
    SELECT
        LOCK_STATE,
        LOCK_HANDLE,
        STATE_HANDLE,
        LOCK_ACQUIRED_TIME
    FROM
        STATE_LOCK_DATA_TABLE;

PROMPT Recreating editioning views on table ECS_SCHEDULEDJOB_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_SCHEDULEDJOB AS
    SELECT
        ID,
        JOB_CLASS,
        JOB_CMD,
        JOB_PARAMS,
        ENABLED,
        INTERVAL,
        LAST_UPDATE,
        LAST_UPDATE_BY,
        STATUS,
        TARGET_SERVER,
        TYPE,
        PLANNED_START,
        TIMEOUT,
        JOB_GROUP_ID,
        CURRENT_TARGET_SERVER,
        CRON_SCHEDULE
    FROM
        ECS_SCHEDULEDJOB_TABLE;

PROMPT Recreating editioning views on table ECS_ZONES_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_ZONES AS
    SELECT
        REGION,
        DC,
        ZONE,
        LOCATION,
        URI,
        BKUPURI,
        USERNAME,
        PASSWD,
        ENCRYPTIONKEY,
        SALT,
        IV,
        SUBNETOCID
    FROM
        ECS_ZONES_TABLE;

PROMPT Recreating editioning views on table ECS_ATPCLIENT_VCN_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_ATPCLIENT_VCN AS
    SELECT
        VCN_ID,
        VCN_INDEX,
        SUBNET_COUNT,
        VCN_FSM,
        COMPARTMENTOCID,
        CIDRBLOCK
    FROM
        ECS_ATPCLIENT_VCN_TABLE;

PROMPT Recreating editioning views on table ECS_CUSTOMVIP_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_CUSTOMVIP AS
    SELECT
        RACKNAME,
        CUSTOMIP,
        HOSTNAME,
        DOMAINNAME,
        NODENAME,
        INTERFACETYPE,
        STANDBY_VNIC_MAC,
        MAC,
        IPOCID,
        VNICOCID,
        ZONEOCID,
        IPTYPE,
        CUSTOMIPV6,
        IPV6OCID
    FROM
        ECS_CUSTOMVIP_TABLE;

PROMPT Recreating editioning views on table ECS_PROPERTIES_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_PROPERTIES AS
    SELECT
        NAME,
        TYPE,
        VALUE,
        DESCRIPTION
    FROM
        ECS_PROPERTIES_TABLE;

PROMPT Altering table ecs_oci_console_connection_table added IP column
ALTER TABLE ecs_oci_console_connection_table ADD IP varchar2(20);

PROMPT Recreating editioning views on table ecs_oci_console_connection_table
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

INSERT INTO ecs_properties_table (name, type, value) VALUES ('BASE_SYSTEM_MODELS', 'EXACS', 'X8M-2,X9M-2');

-- Enh 35421067 - EXACS MVM - ENABLE PARALLEL CELL/COMPUTE BEHAVIOR BY DEFAULT IN DROP4 
INSERT INTO ecs_properties_table (name, type, value) values ('ELASTIC_CELL_STEPWISE_ADDITION', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties_table (name, type, value) values ('ELASTIC_COMPUTE_STEPWISE_ADDITION', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties_table (name, type, value) values ('ELASTIC_CELL_MVM_STEPWISE_ADDITION', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties_table (name, type, value, description) values ('BLUE_GREEN_DEPLOYMENT', 'FEATURE', 'DISABLED', 'Property for blue-green deployment changes');
INSERT INTO ecs_properties_table (name, type, value, description) values ('BLUE_GREEN_BACKEND_PREFERENCE', 'FEATURE', 'PASSIVE', 'Property for default backendsets for add node');
INSERT INTO ecs_properties_table (name, type, value, description) values ('ECRA_ACTIVE_ACTIVE', 'FEATURE', 'DISABLED', 'Property for active active ECRA  deployment changes');
INSERT INTO ecs_properties_table (name, type, value, description) values ('ECRA_INFRA_SETUP', 'FEATURE', 'ACTIVE_ACTIVE', 'Property for  ECRA infra setup   deployment type');
UPDATE ecs_properties_table SET value='ENABLED' WHERE name='ELASTIC_CELL_STEPWISE_ADDITION';
UPDATE ecs_properties_table SET value='ENABLED' WHERE name='ELASTIC_COMPUTE_STEPWISE_ADDITION';
UPDATE ecs_properties_table SET value='ENABLED' WHERE name='ELASTIC_CELL_MVM_STEPWISE_ADDITION';

-- Enh 37197440 - Add a way to force celltype and computetype during infra creation
INSERT INTO ecs_properties_table (name, type, value, description) values ('OVERRIDE_CELLTYPE_CEI_CREATION', 'FEATURE', '', 'Property to force the specified celltype during infra creation flow');
INSERT INTO ecs_properties_table (name, type, value, description) values ('OVERRIDE_COMPUTETYPE_CEI_CREATION', 'FEATURE', '', 'Property to force the specified computetype during infra creation flow');

-- Workflow Property Update
insert into wf_property_table (name, type, value) values('WF_FAILOVER_JANITOR_JOBS_ALLOWED', 'WFJANITOR', 'TRUE');
update wf_property set value='30' where name='WF_INMEMORY_DATA_IN_DAYS';

-- Property to sent to exacloud to validate or not exadataimage version
-- Enh 35523781 - SYSTEM IMAGE VERSION CHECK FAILED: ENABLE EXACLOUD_CS_SKIP_SWVERSION_CHECK PROPERTY 
INSERT INTO ecs_properties_table (name, type, value) values ('EXACLOUD_CS_SKIP_SWVERSION_CHECK', 'MVM', 'ENABLED');
UPDATE ecs_properties_table SET value='ENABLED' WHERE name='EXACLOUD_CS_SKIP_SWVERSION_CHECK';

-- Filesystem mount size
INSERT INTO ecs_properties_table (name, type, value) VALUES ('FILESYSTEM_MAX', 'FEATURE', '900');
-- Filesystem back compatibility with 443 overhead
INSERT INTO ecs_properties_table (name, type, value) VALUES ('FILESYSTEM_FEATURE', 'FEATURE', 'ENABLED');
--Enh 36330149 - Adding filesystem migration complete property
INSERT INTO ecs_properties_table (name, type, value) VALUES ('FS_MIGRATION_COMPLETE', 'FEATURE', 'false');
--Enh 36602015 - Adding filesystem ignorable mountpoins for CP
INSERT INTO ecs_properties_table (name, type, value) VALUES ('EXACS_IGNORABLE_MOUNTPOINTS', 'FILESYSTEM', 'swap,reserved');

INSERT INTO ecs_properties_table (name, type, value) VALUES ('CEI_SKIP_SERASE','FEATURE', 'false');

PROMPT Inserting ECRA_STORAGE_DEST db value on table ECS_PROPERTIES_TABLE
INSERT INTO ecs_properties_table (name, type, value) VALUES ('ECRA_STORAGE_DEST', 'FEATURE', 'db');
-- Enh 37557512 - Setting ECRA_STORAGE_DEST value to db even after upgrade
UPDATE ecs_properties_table SET value='db' WHERE name='ECRA_STORAGE_DEST';

-- Enh 36329200 - Adding default value for asm power limit
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ASM_POWER_LIMIT_DEFAULT_VALUE','FEATURE', '4', 'Default and minimum value the rebalance power can take for attach and dettach operations.');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('ASM_POWER_LIMIT_MAX_VALUE','FEATURE', '64', 'Maximum value the rebalance power can take for attach and dettach operations.');

-- Enh 37050952 - Setting new values for decomposing x8m racks
INSERT INTO ecs_properties_table (name, type, value) values ('ALLOCATE_NODES_FROM_69_CEI', 'ELASTICSHAPE', 'ENABLED');
INSERT INTO ecs_properties_table (name, type, value) values ('ROCE_ENABLE_69RACK_FOR_ELASTIC', 'KVMROCE', 'TRUE');
INSERT INTO ecs_properties_table (name, type, value) values ('ROCE_CEI_EXPANSION_ONLY_CABINETS', 'ELASTICSHAPE', 'ENABLED');
UPDATE ecs_properties_table set VALUE='ENABLED', DESCRIPTION='Property to use nodes, if enabled, from X8M-2 6:9 cabinet for elastic pool if they are not part of a fixed shape.' WHERE NAME='ALLOCATE_NODES_FROM_69_CEI';
UPDATE ecs_properties_table set VALUE='TRUE', DESCRIPTION='Property for Scale Up Infra (adding a node, compute or cell to the existing Infrastructure) to use nodes, if enabled, from X8M-2 6:9 cabinet for elastic pool if they are not part of a fixed shape.' WHERE NAME='ROCE_ENABLE_69RACK_FOR_ELASTIC';
UPDATE ecs_properties_table set VALUE='ENABLED', DESCRIPTION='Property to use only expansion cabinets and not to use 6:9 cabinets if enabled, this override ROCE_CEI_SELECTION_APPROACH' WHERE NAME='ROCE_CEI_EXPANSION_ONLY_CABINETS';

UPDATE ecs_properties_table set VALUE='50', DESCRIPTION='Max number of clusters for ExaDB-D service' WHERE NAME='EXACS_MVM_MAX_ALLOWED_RACKS';

-- Enh 37127579 - Adding property for max size of customer domain name
INSERT INTO ecs_properties_table (name, type, value, description) values ('MAX_SIZE_HOST_LENGTH', 'FEATURE', '384', 'Property to determine the max size the customer domain name can be.');


PROMPT adding columns and constraints for  ecs_atpjobsmetadata_table
ALTER TABLE ecs_atpjobsmetadata_table ADD (enabled varchar2(5) DEFAULT 'true' NOT NULL);
ALTER TABLE ecs_atpjobsmetadata_table DROP constraint chk_enabledvalues;
ALTER TABLE ecs_atpjobsmetadata_table ADD constraint chk_enabledvalues CHECK (enabled='true' OR enabled='false');
PROMPT Recreating editioning views on table ECS_ATPJOBSMETADATA_TABLE
CREATE OR REPLACE EDITIONING VIEW ecs_atpjobsmetadata AS
SELECT
    rack_status,
    job_class,
    metadata,
    job_category,
    enabled
FROM ecs_atpjobsmetadata_table;

Prompt Creating table ecs_system_vault_table
create table ecs_system_vault_table (
    vault_id         varchar2(2048) primary key,
    fabric_id        varchar2(2048),
    reference_identifier varchar2(2048),
    vault_name       varchar2(2048),
    vault_compartment_id varchar2(2048),
    lifecycle_state  varchar2(2048),
    is_system_generated  varchar2(8) check (is_system_generated in ('true','false')),
    infrastructure_type  varchar2(2048),
    extreme_flash_size_in_gbs varchar2(2048),
    high_capacity_size_in_gbs varchar2(2048),
    extreme_flash_iops   varchar2(2048),
    high_capacity_iops   varchar2(2048)
);

-- Enh 37144818 - Support for multiple system vault
ALTER TABLE ecs_system_vault_table ADD is_placement_disabled  varchar2(8) default 'false' check (is_placement_disabled in ('true','false'));

CREATE OR REPLACE EDITIONING VIEW ecs_system_vault AS
SELECT
    vault_id,
    fabric_id,
    reference_identifier,
    vault_name,
    vault_compartment_id,
    lifecycle_state,
    is_system_generated,
    infrastructure_type,
    extreme_flash_size_in_gbs,
    high_capacity_size_in_gbs,
    extreme_flash_iops,
    high_capacity_iops,
    is_placement_disabled
FROM
    ecs_system_vault_table;

PROMPT Creating table ecs_system_vault_access_table
create table ecs_system_vault_access_table (
    vault_access_id  varchar2(2048) primary key,
    node_id          varchar2(2048),
    vault_access_name   varchar2(2048),
    vault_access_type   varchar2(2048),
    vault_access_compartment_id     varchar2(2048),
    vault_id         varchar2(2048) references ecs_system_vault_table(vault_id),
    vault_reference_identifier      varchar2(2048),
    lifecycle_state  varchar2(2048),
    exa_root_address varchar2(2048),
    exa_root_username   varchar2(2048),
    public_key       varchar2(2048),
    is_system_generated varchar2(8) check (is_system_generated in ('true','false')),
    node_access_id   varchar2(2048)
);

-- Enh 35751773 - EXADBXS: TRANSITION THE SCHEMA FOR VAULT-ACCESS FROM SSHKEYS TABLE TO ECS_SYSTEM_VAULT_ACCESS  
ALTER TABLE ecs_system_vault_access_table ADD TRUST_CERTIFICATES BLOB;
ALTER TABLE ecs_system_vault_access_table ADD DRIVER_VERSION VARCHAR(2048);
-- Enh 36494348 - Adding extra columns for extra keys for a vualt
ALTER TABLE ecs_system_vault_access_table ADD public_key_2 varchar2(2048);
ALTER TABLE ecs_system_vault_access_table ADD public_key_3 varchar2(2048);

PROMPT Recreating editioning views on table ECS_SYSTEM_VAULT_ACCESS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_SYSTEM_VAULT_ACCESS AS
SELECT
    vault_access_id,
    node_id,
    vault_access_name,
    vault_access_type,
    vault_access_compartment_id,
    vault_id,
    vault_reference_identifier,
    lifecycle_state,
    exa_root_address,
    exa_root_username,
    public_key,
    public_key_2,
    public_key_3,
    is_system_generated,
    node_access_id,
    trust_certificates,
    driver_version
FROM
    ecs_system_vault_access_table;

-- Bug 36295882 --
--creating ecs_registered_infrapatch_plugins_table
PROMPT creating table ecs_registered_infrapatch_plugins_table

create table ecs_registered_infrapatch_plugins_table(
script_path_name      varchar2(512) not null,
script_alias          varchar2(128) not null,
change_request_id     varchar2(128) not null,
description           varchar2(512) not null,
plugin_type           varchar2(128) not null,
plugin_target         varchar2(128) not null,
script_order          number DEFAULT 1000,
enabled               number(1) DEFAULT 1,
reboot_node           number(1) DEFAULT 0,
fail_on_error         number(1) DEFAULT 0,
phase                 varchar2(128),
registration_time     timestamp  default systimestamp not null,
CONSTRAINT pk_registered_infrapatch_plugins PRIMARY KEY (script_alias, plugin_target, plugin_type)
);

CREATE OR REPLACE EDITIONING VIEW ecs_registered_infrapatch_plugins AS
SELECT
        script_path_name,
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
        registration_time
FROM ecs_registered_infrapatch_plugins_table;

/* NOTES:

Introducing this table to store infrapatching plugin metadata.
This table is expecting to have a max of around 20 entries and 
does not require partitioning due to its small size


*/
-- Bug 36295882 --

CREATE OR REPLACE EDITIONABLE VIEW ecs_hardware_filtered AS 
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
    ENV
FROM
    ECS_HARDWARE_TABLE
WHERE 
    ENV = (SELECT NVL((SELECT VALUE FROM ECS_PROPERTIES WHERE NAME = 'ECRA_ENV' AND ROWNUM = 1),'bm') FROM DUAL);

CREATE OR REPLACE VIEW ecs_v_mvm_computes AS
SELECT
    compute.inventory_id AS node,
    compute.aliasname AS aliasname,
    compute.hostname AS hostname,
    CASE WHEN SUM(vdomu.cores)  IS NULL THEN 0 ELSE SUM(vdomu.cores) END AS allocated_cores,
    CASE WHEN SUM(vdomu.memory) IS NULL THEN 0 ELSE SUM(vdomu.memory) END AS allocated_memory,
    CASE WHEN SUM(vdomu.oracle_home) IS NULL THEN 0 ELSE SUM(vdomu.oracle_home) END AS allocated_oh,
    hardware.maxcorespernode AS max_cores,
    hardware.memsize AS max_memory,
    oh.useableohspaceingb AS max_oh
FROM ecs_hardware_filtered hardware, ecs_hw_nodes_table nodes, ecs_exadata_compute_node_table compute
    LEFT JOIN ecs_v_mvm_domus vdomu ON compute.inventory_id = vdomu.node,
    (SELECT model, racksize, MAX(useableohspaceingb) AS useableohspaceingb FROM ecs_oh_space_rule_filtered GROUP BY model, racksize) oh
WHERE
    compute.exaservice_id IS NOT NULL
    AND hardware.model=nodes.node_model
    AND hardware.racksize= CASE WHEN nodes.model_subtype = 'STANDARD' THEN 'ELASTIC' ELSE nodes.model_subtype END
    AND oh.model = nodes.node_model
    AND oh.racksize = 'ALL'
    AND compute.inventory_id=nodes.oracle_hostname
GROUP BY compute.inventory_id,hardware.maxcorespernode, hardware.memsize, oh.useableohspaceingb, compute.aliasname, compute.hostname;

Rem    ecs_infrapatching_launch_nodes_table
Rem    Place to hold registered launch nodes for infrapatching
Rem    Used for registration of launch nodes for infrapatching

PROMPT Creating table ecs_infrapatching_launch_nodes_table
create table ecs_infrapatching_launch_nodes_table(
infra_name            varchar2(128) not null,
launch_nodes          varchar2(4000) not null,
infra_type            varchar2(128) not null,
CONSTRAINT pk_infrapatch_launch_nodes PRIMARY KEY (infra_name ,infra_type )
);

-- Enh 37300474 - ECRA DB CHANGES FOR LAUNCH NODE REGISTRATION TO TAKE LAUNCHNODE TYPE AS INPUT
ALTER TABLE ecs_infrapatching_launch_nodes_table ADD launchnode_type VARCHAR2(128);

PROMPT Recreating editioning views on table ecs_infrapatching_launch_nodes_table
CREATE OR REPLACE EDITIONING VIEW ecs_infrapatching_launch_nodes AS
SELECT
    infra_name,
    launch_nodes,
    infra_type,
    launchnode_type
FROM
    ecs_infrapatching_launch_nodes_table;

CREATE OR REPLACE EDITIONING VIEW ecs_exadata_formation AS
SELECT
    inventory_id,
    specs,
    exadata_formation_id
FROM
    ecs_exadata_formation_table;

PROMPT creating table ecs_sla_enable_tenancy_table
CREATE TABLE ecs_sla_enable_tenancy_table
(
    tenancy_ocid        VARCHAR2(2048) not null,
    CONSTRAINT pk_ecs_sla_enable_tenancy_table PRIMARY KEY (tenancy_ocid)
);

CREATE OR REPLACE EDITIONING VIEW ecs_kvmvlanpool AS
SELECT
    FABRIC_NAME,
    VLAN_ID,
    RACKNAME,
    VLANTYPE,
    USED
FROM 
    ecs_kvmvlanpool_table;

PROMPT Creating table ecs_volumes_table 
CREATE TABLE ecs_volumes_table(
    oracle_hostname varchar2(256),
    client_hostname varchar2(256),
    vault_id varchar2(512),
    volume_id varchar2(512),
    volume_type varchar2(64),
    volume_name varchar2(64),
    volume_device_path varchar2(64),
    volume_size_gb varchar2(64),
    CONSTRAINT ecs_volumes_pk
        PRIMARY KEY (oracle_hostname,client_hostname,volume_type)
);

CREATE OR REPLACE EDITIONING VIEW ecs_sla_enable_tenancy AS
SELECT
    tenancy_ocid
FROM
    ecs_sla_enable_tenancy_table;

INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_SLA_BY_TENANCY', 'SLA', 'ENABLED');

-- Enh 35328793 - Support for ExaCC OCI Rehome feature
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_REHOME_BUCKET_NAME', 'OCI_REHOME', 'exacc_oci_rehome');

PROMPT Altering table exaunit_info for adding oci_rehome_status column
ALTER TABLE exaunit_info_table ADD (exacc_rehome CHAR(1) DEFAULT 'N' CHECK (exacc_rehome in ('N', 'I', 'D')));
ALTER TABLE exaunit_info_table ADD (ecra_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info_table ADD (exacloud_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info_table ADD (oeda_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info_table ADD (dbaas_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info_table ADD (deconfigured char(1) DEFAULT 'N' CHECK (deconfigured in ('N', 'Y')));
CREATE OR REPLACE EDITIONING VIEW exaunit_info AS
            SELECT
                *
            FROM
                exaunit_info_table;

PROMPT Altering table ecs_oci_exa_info for adding oci_rehome_status column
ALTER TABLE ecs_oci_exa_info_table ADD (oci_rehome_status CHAR(1) DEFAULT 'N' CHECK (oci_rehome_status in ('N', 'I', 'D', 'O')));
PROMPT Altering table ecs_oci_exa_info for adding oci_rehome_uuid column  
ALTER TABLE ecs_oci_exa_info_table ADD oci_rehome_uuid VARCHAR2(36) DEFAULT NULL;
ALTER TABLE ecs_oci_exa_info_table ADD (event_process_time varchar2(256) default '0');
ALTER TABLE ecs_oci_exa_info_table ADD events_sent_in_heartbeat CLOB;
ALTER TABLE ecs_oci_exa_info_table ADD client_network_bondingmode varchar(24) DEFAULT 'active-backup' CHECK (client_network_bondingmode IN ('active-backup', 'lacp'));
ALTER TABLE ecs_oci_exa_info_table ADD backup_network_bondingmode varchar(24) DEFAULT 'active-backup' CHECK (backup_network_bondingmode IN ('active-backup', 'lacp'));
ALTER TABLE ecs_oci_exa_info_table ADD nw_mode_validation_report clob;
ALTER TABLE ecs_oci_exa_info_table ADD previous_status varchar2(24) CHECK (previous_status IN ('PREPARING', 'PRE_ACTIVATION', 'READY', 'RESERVED', 'ACTIVE'));
ALTER TABLE ecs_oci_exa_info_table ADD dr_network_bondingmode varchar(24) DEFAULT 'active-backup' CHECK (dr_network_bondingmode IN ('active-backup', 'lacp'));
ALTER TABLE ecs_oci_exa_info_table ADD (exception_ops varchar2(512));
ALTER TABLE ecs_oci_exa_info_table ADD (oci_rehome_uuid VARCHAR2(36));
ALTER TABLE ecs_oci_exa_info_table ADD (MONITORING_COMPARTMENT_OCID varchar2(100));
ALTER TABLE ecs_oci_exa_info_table ADD (rack_serial_number varchar2(128));
ALTER TABLE ecs_oci_exa_info_table ADD storage varchar2(6) DEFAULT 'ASM' CHECK (storage in ('ASM', 'XS'));
ALTER TABLE ecs_oci_exa_info_table ADD XS_POOL_NAME varchar2(32);

--Bug 36197980 - Added a new field to track last password rotation depareted from the cert rotation date
ALTER TABLE ECS_OCI_EXA_INFO_TABLE ADD
      (last_password_rotation timestamp);

--Bug 37146839 - PROVIDE OPTION FOR ASMSS ON EXACC INFRAS
ALTER TABLE ecs_oci_exa_info_table ADD asmss varchar2(5) DEFAULT 'FALSE' CHECK (asmss in ('TRUE', 'FALSE'));

CREATE OR REPLACE EDITIONING VIEW ecs_oci_exa_info AS
            SELECT
				tenant_ocid,
				exa_ocid,
				exa_name,
				dns,
				ntp,
				timezone,
				multivm,
				env,
				admin_nw_cidr,
				ib_nw_cidr,
				ec_keys_db,
				connectivity,
				heartbeat_count,
				heartbeat_lastupdate,
				last_rotation,
				rotation_status,
				rack_basename,
				infra_update_on_rack,
				atp,
				status,
				headendtype,
				oci_upgrade_status,
				migration_wss_status,
				compartment_ocid,
				oci_rehome_status,
				oci_rehome_uuid,
				event_process_time,
				events_sent_in_heartbeat,
				client_network_bondingmode,
				backup_network_bondingmode,
				nw_mode_validation_report,
				previous_status,
				dr_network_bondingmode,
				exception_ops,
                                MONITORING_COMPARTMENT_OCID,
                                rack_serial_number,
                                last_password_rotation,
                                storage,
                                xs_pool_name,
                                asmss
            FROM
                ecs_oci_exa_info_table;

UPDATE ecs_oci_exa_info_table SET asmss='FALSE' WHERE asmss is NULL; 

alter table ecs_oci_networks_table add SCAN_DR_NETWORK_HOSTNAME VARCHAR2(512);
alter table ecs_oci_networks_table add SCAN_DR_NETWORK_PORT VARCHAR2(64);
alter table ecs_oci_networks_table add SCAN_DR_NETWORK_IPS VARCHAR2(256);
alter table ecs_oci_networks_table add SCAN_V6IPS VARCHAR2(256);
CREATE OR REPLACE EDITIONING VIEW ecs_oci_networks AS
            SELECT
                *
            FROM
                ecs_oci_networks_table;
                

-- Enh 35328793 - EXADB-XS: ECRA API TO PROVIDE KVM HOST SSHKEY  
PROMPT Altering table sshkeys_table
ALTER TABLE sshkeys_table ADD oracle_hostname VARCHAR2(256);
ALTER TABLE sshkeys_table  ADD exaroot_url VARCHAR2(256);
ALTER TABLE sshkeys_table  ADD exaroot_username VARCHAR2(256);
ALTER TABLE sshkeys_table ADD vaultaccess VARCHAR2(256);
ALTER TABLE sshkeys_table ADD vaultid VARCHAR2(256);
ALTER TABLE sshkeys_table ADD trustcertificates BLOB;
ALTER TABLE sshkeys_table  DROP CONSTRAINT FK_SSHCLUSTER;
ALTER TABLE sshkeys_table  DROP CONSTRAINT FK_TENANTSSH;

--Enh 37025371 - EXACC X11M Support for compute standard/large and extra large
ALTER TABLE ecs_exadata_table ADD compute_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;
ALTER TABLE ecs_exadata_table ADD cell_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;

ALTER TABLE ecs_exadata_table DROP CONSTRAINT
  ck_ecs_exadata_compute_subtype;

ALTER TABLE ecs_exadata_table ADD
      CONSTRAINT ck_ecs_exadata_compute_subtype
        CHECK (compute_subtype in
             ('BASE',
              'Z',
              'STANDARD',
              'ELASTIC_LARGE',
              'ELASTIC_EXTRALARGE'));

ALTER TABLE ecs_exadata_table DROP CONSTRAINT
  ck_ecs_exadata_cell_subtype;

ALTER TABLE ecs_exadata_table ADD
      CONSTRAINT ck_ecs_exadata_cell_subtype
        CHECK (cell_subtype in
             ('BASE',
              'Z',
              'STANDARD',
              'NOXRMEM',
              'EF'));

UPDATE ecs_properties SET value = 'ENABLED' WHERE name = 'EXACS_SLA'; 
UPDATE ecs_properties SET value = 16 WHERE name = 'SLA_EXACLOUD_JOB_CONCURRENCY';

--Enh 34972266 - EXACS Compatibility - create new tables to support compatibility on operations
ALTER TABLE ecs_registries_table ADD resourceid VARCHAR2(256);


--************************************ INSERT SECTION *********************************************************
--*************************************************************************************************************

-- Enh 37675147 - Adding brancher for ImageBaseProvisioning
INSERT INTO ecs_properties (name, type, value, description)
VALUES ('FORCE_GOLD_IMAGE_PROVISIONING', 'EXACOMPUTE', 'FALSE', 'FORCE GOLD IMAGE PROVISIOING FLAG AS IT WILL REPLACE PostVMInstall, CreateUser, ExaScaleComplete for GoldComplete task in CS WF');

-- Enh 35769747 - GoldVM Backup async operation properties 
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_GOLD_BACKUP_RETRIES','ECRA', '3');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_GOLD_BACKUP_RETRY_TIMEOUT_SECONDS','ECRA', '1800');
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('reshape-cores', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('reshape-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('oci-attach-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit-attach-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit-delete-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('mvm-attach-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts_table (operation, racksize, soft_timeout, hard_timeout) VALUES ('mvm-delete-storage', 'ALL', 504 * 3600, 504 * 3600);



-- Enh 34972266 - EXACS Compatibility - create new tables to support compatibility on operations
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'reshape-storage', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'oci-attach-cell', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'exaunit-attach-cell', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'exaunit-delete-cell', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'mvm-attach-storage', 'bm');
INSERT INTO ecs_operations_compatibility_table(operation, compatibleoperation, env) VALUES('reshape-cores', 'mvm-delete-storage', 'bm');

--Enh 35388181
UPDATE ecs_properties SET value = '2,3,5,6,7,11,12' WHERE name = 'ONSR_REALMS';

--Bug 33779609 - in each update we need to reinsert the data of ECS_HARDWARE
DELETE FROM ecs_hardware;

--=====================================================--
--  ECS_HARDWARE ENTRIES FOR BM ENV (EXACS)            --
--=====================================================--
-- X4-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X4-2', 'QUARTER', 8,  22, 240, 42, 'Quarter Rack X4', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X4-2', 'HALF',    8,  22, 240, 42, 'Half Rack X4', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X4-2', 'FULL',    8,  22, 240, 42, 'Full Rack X4', 'bm');

-- X5-2
-- No eighth rack for X5-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X5-2', 'QUARTER', 8,   34, 240, 42,  'Quarter Rack X5,Quarter Rack', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X5-2', 'HALF',    14,  34, 240, 84,  'Half Rack X5,Half Rack', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X5-2', 'FULL',    14,  34, 240, 168, 'Full Rack X5,Full Rack', 'bm');

-- X6-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'EIGHTH',  8,  34, 240, 42,  'Eighth Rack,Eighth Rack X6,Base System', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'QUARTER', 11, 42, 720, 84,  'Quarter Rack X6 - Commit,Quarter Rack - Commit,Quarter Rack X6,Quarter Rack,Quarter Rack X6 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'HALF',    11, 42, 720, 168, 'Half Rack X6 - Commit,Half Rack - Commit,Half Rack X6,Half Rack,Half Rack X6 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'FULL',    11, 42, 720, 336, 'Full Rack X6 - Commit,Full Rack - Commit,Full Rack X6,Full Rack,Full Rack X6 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'DOUBLE',  11, 42, 720, 672, 'Double Rack X6 BYOL,Double Rack X6,Double Rack', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'BASE',    11, 24, 360, 72,  'OCI Base System X6', 'bm');

-- adding x7 hardware support
-- tbStorage from Exadata cloud specifications - http://www.oracle.com/technetwork/database/exadata/exacc-x7-ds-4126773.pdf. Values are rounded down.
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'EIGHTH',   		8,  22, 240, 42,  8,  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'QUARTER', 		11, 46, 720, 106, 8,  'Quarter Rack X7 Infrastructure,Quarter Rack X7 BYOL,Quarter Rack X7,Quarter Rack,Quarter Rack X7 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'HALF',    		11, 46, 720, 213, 16, 'Half Rack X7 Infrastructure,Half Rack X7 BYOL,Half Rack X7,Half Rack,Half Rack X7 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'FULL',    		11, 46, 720, 427, 16, 'Full Rack X7 Infrastructure,Full Rack X7 BYOL,Full Rack X7,Full Rack,Full Rack X7 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'BASE',    		11, 24, 360, 74,  8,  'OCI Base System X7', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage,           tags, env ) VALUES ('X7-2', 'ELASTIC',    	11, 46, 720, 427, 	  'Elastic Rack X7 Infrastructure,Elastic Rack X7 BYOL,Elastic Rack X7,Elastic Rack,Elastic Rack X7 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'ELASTIC_EIGHTH', 8,  22, 240, 42,  8,  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) 		 (select MODEL, 'DOUBLE', MINCORESPERNODE,MAXCORESPERNODE,MEMSIZE,2*TBSTORAGE,8,TAGS from ecs_hardware where MODEL='X7-2' and RACKSIZE='FULL', 'bm');

-- adding X8-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'EIGHTH',  		8,  24, 360, 74,   8,  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'QUARTER', 		11, 50, 720, 149,  8,  'Quarter Rack X8 Infrastructure,Quarter Rack X8 BYOL,Quarter Rack X8,Quarter Rack,Quarter Rack X8 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'HALF',    		11, 50, 720, 299,  16, 'Half Rack X8 Infrastructure,Half Rack X8 BYOL,Half Rack X8,Half Rack,Half Rack X8 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'FULL',    		11, 50, 720, 598,  16, 'Full Rack X8 Infrastructure,Full Rack X8 BYOL,Full Rack X8,Full Rack,Full Rack X8 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'DOUBLE',  		11, 50, 720, 1196, 8,  'Double Rack X8 Infrastructure,Double Rack X8 BYOL,Double Rack X8,Double Rack,Double Rack X8 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'BASE',    		11, 24, 360, 74,   8,  'OCI Base System X8', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'ELASTIC', 		11, 50, 720, 149,  8,  'Elastic  Rack X8 Infrastructure, Elastic Rack X8 BYOL,Elastic Rack X8,Elastic Rack,Elastic Rack X8 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage,           tags, env ) VALUES ('X8-2', 'ELASTIC_EIGHTH', 8,  24, 360, 74, 	   'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'bm');

-- adding X8M-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'EIGHTH',  		 8,  24, 328,  76,  			  8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'QUARTER', 		 11, 50, 1390, 147, 			  8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Quarter Rack X8M-2 Infrastructure,Quarter Rack X8M-2 BYOL,Quarter Rack X8M-2,Quarter Rack,Quarter Rack X8M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'HALF',    		 11, 50, 1390, 294, 			  16, '1035', 'X8M-2 Elastic Rack HC 14TB',  'Half Rack X8M-2 Infrastructure,Half Rack X8M-2 BYOL,Half Rack X8M-2,Half Rack,Half Rack X8M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'FULL',    		 11, 50, 1390, 588, 			  16, '1035', 'X8M-2 Elastic Rack HC 14TB',  'Full Rack X8M-2 Infrastructure,Full Rack X8M-2 BYOL,Full Rack X8M-2,Full Rack,Full Rack X8M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'DOUBLE',  		 11, 50, 1390, 1176,			  16, '1035', 'X8M-2 Elastic Rack HC 14TB',  'Double Rack X8M-2 Infrastructure,Double Rack X8M-2 BYOL,Double Rack X8M-2,Double Rack,Double Rack X8M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'ELASTIC', 		 11, 50, 1390, 49.89483642578125, 8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Elastic Rack X8M-2 Infrastructure,Elastic Rack X8M-2 BYOL,Elastic Rack X8M-2,Elastic Rack,Elastic Rack X8M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'ELASTIC_EIGHTH', 8,  24, 328,  76, 				  8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, 		   racktype_code, description, tags, env ) VALUES ('X8M-2', 'BASE', 			 11, 24, 360,  74, 					  '1035', 'X8M-2 Elastic  Rack HC 14TB', 'OCI Base System X8M', 'bm');

-- adding X9M-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'ELASTIC', 		11, 126, 1390, 64,   12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Elastic Rack X9M-2 Infrastructure,Elastic Rack X9M-2 BYOL,Elastic Rack X9M-2,Elastic Rack,Elastic Rack X9M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'LARGE', 	11, 126, 1860, 64,   12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Elastic Rack X9M-2 Infrastructure,Elastic Rack X9M-2 BYOL,Elastic Rack X9M-2,Elastic Rack,Elastic Rack X9M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, 									 description, tags, env ) VALUES ('X9M-2', 'BASE', 			11, 24,  360,  74,   12,  '1145', 		   'X9M-2 Elastic Rack HC 18TB', 'OCI Base System X9M', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'QUARTER',               11, 126, 1390, 192,  12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Quarter Rack X9M-2 Infrastructure,Quarter Rack X9M-2 BYOL,Quarter Rack X9M-2,Quarter Rack,Quarter Rack X9M-2 - Infrastructure - Commit', 'bm');

-- adding X10M-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'ELASTIC', 		   	11, 190, 1390, 80,   12, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Elastic Rack X10M-2 Infrastructure,Elastic Rack X10M-2 BYOL,Elastic Rack X10M-2,Elastic Rack,Elastic Rack X10M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'LARGE', 	11, 190, 2090, 80,   12, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Elastic Rack X10M-2 Infrastructure,Elastic Rack X10M-2 BYOL,Elastic Rack X10M-2,Elastic Rack,Elastic Rack X10M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'EXTRALARGE',11, 190, 2800, 80,   12, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Elastic Rack X10M-2 Infrastructure,Elastic Rack X10M-2 BYOL,Elastic Rack X10M-2,Elastic Rack,Elastic Rack X10M-2 - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, 		   racktype_code,                                    description, tags, env ) VALUES ('X10M-2', 'BASE', 				11, 24,  360,  74,  	 '1205', 		  'X10M-2 Elastic Rack HC 22TB', 'OCI Base System X10M', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'QUARTER',                      11, 190, 1390, 192,  12, '1205', 50, 100, 'X10M Elastic Rack HC 22TB',   'Quarter Rack X10M-2 Infrastructure,Quarter Rack X10M-2 BYOL,Quarter Rack X10M,Quarter Rack,Quarter Rack X10M-2 - Infrastructure - Commit', 'bm');

--adding X11M

INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'ELASTIC', 2, 190, 1390, 80,   24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'LARGE', 2, 190, 2090, 80,   24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'EXTRALARGE',2, 190, 2800, 80,   24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code,                            description, tags, ecpufactor, env )         VALUES ('X11M', 'BASE', 11, 24,  360,  74, 12,'1224',                  'X11M Elastic Rack HC 22TB', 'OCI Base System X11M', 4, 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'QUARTER', 2, 190, 1390, 192,  12, '1224', 50, 100, 'X11M Elastic Rack HC 22TB',   'Quarter Rack X11M Infrastructure,Quarter Rack X11M BYOL,Quarter Rack X11M,Quarter Rack,Quarter Rack X11M - Infrastructure - Commit', 4, 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code,                            description, tags, ecpufactor, env )         VALUES ('X11M', 'X-Z', 2, 30,  660,  49.89483642578125, 12,'1224',                  'X11M Elastic Rack HC 22TB', 'OCI Base System X11M', 4, 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X11M', 'EF', -1, -1, -1, 36, 24, '1224', 50, 100, 'X11M Elastic Rack EF 36TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 'bm');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'Z', 2, 190, 1390, 80,   24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'bm');

--=====================================================--
--  ECS_HARDWARE ENTRIES FOR OCIEXACC ENV (EXACC)      -- 
--=====================================================--

-- X4-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X4-2', 'QUARTER', 8,  22, 240, 42, 'Quarter Rack X4', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X4-2', 'HALF',    8,  22, 240, 42, 'Half Rack X4', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X4-2', 'FULL',    8,  22, 240, 42, 'Full Rack X4', 'ociexacc');


-- X5-2
-- No eighth rack for X5-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X5-2', 'QUARTER', 8,   34, 240, 42,  'Quarter Rack X5,Quarter Rack', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X5-2', 'HALF',    14,  34, 240, 84,  'Half Rack X5,Half Rack', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X5-2', 'FULL',    14,  34, 240, 168, 'Full Rack X5,Full Rack', 'ociexacc');


-- X6-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'EIGHTH',  8,  34, 240, 42,  'Eighth Rack,Eighth Rack X6,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'QUARTER', 11, 42, 720, 84,  'Quarter Rack X6 - Commit,Quarter Rack - Commit,Quarter Rack X6,Quarter Rack,Quarter Rack X6 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'HALF',    11, 42, 720, 168, 'Half Rack X6 - Commit,Half Rack - Commit,Half Rack X6,Half Rack,Half Rack X6 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'FULL',    11, 42, 720, 336, 'Full Rack X6 - Commit,Full Rack - Commit,Full Rack X6,Full Rack,Full Rack X6 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'DOUBLE',  11, 42, 720, 672, 'Double Rack X6 BYOL,Double Rack X6,Double Rack', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, tags, env ) VALUES ('X6-2', 'BASE',    11, 24, 360, 72,  'OCI Base System X6', 'ociexacc');


-- adding x7 hardware support
-- Update X7-2 tb_storage values in ecs_hardware
--   Old values were from Exadata X7-2 specifications - http://www.oracle.com/technetwork/database/exadata/exadata-x7-2-ds-3908482.pdf
--   New values are from Exadata cloud specifications - http://www.oracle.com/technetwork/database/exadata/exacc-x7-ds-4126773.pdf. Values are rounded down.
-- tbStorage from Exadata cloud specifications - http://www.oracle.com/technetwork/database/exadata/exacc-x7-ds-4126773.pdf. Values are rounded down.
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'EIGHTH',   		8,  22, 240, 42,  8,  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'QUARTER', 		11, 46, 720, 106, 8,  'Quarter Rack X7 Infrastructure,Quarter Rack X7 BYOL,Quarter Rack X7,Quarter Rack,Quarter Rack X7 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'HALF',    		11, 46, 720, 213, 16, 'Half Rack X7 Infrastructure,Half Rack X7 BYOL,Half Rack X7,Half Rack,Half Rack X7 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'FULL',    		11, 46, 720, 427, 16, 'Full Rack X7 Infrastructure,Full Rack X7 BYOL,Full Rack X7,Full Rack,Full Rack X7 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'BASE',    		11, 24, 360, 74,  8,  'OCI Base System X7', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage,           tags, env ) VALUES ('X7-2', 'ELASTIC',    	11, 46, 720, 427, 	  'Elastic Rack X7 Infrastructure,Elastic Rack X7 BYOL,Elastic Rack X7,Elastic Rack,Elastic Rack X7 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X7-2', 'ELASTIC_EIGHTH', 8,  22, 240, 42,  8,  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) 		 (select MODEL, 'DOUBLE', MINCORESPERNODE,MAXCORESPERNODE,MEMSIZE,2*TBSTORAGE,8,TAGS from ecs_hardware where MODEL='X7-2' and RACKSIZE='FULL', 'ociexacc');


-- adding X8-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'EIGHTH',  		8,  24, 360, 74,   8,  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'QUARTER', 		11, 50, 720, 149,  8,  'Quarter Rack X8 Infrastructure,Quarter Rack X8 BYOL,Quarter Rack X8,Quarter Rack,Quarter Rack X8 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'HALF',    		11, 50, 720, 299,  16, 'Half Rack X8 Infrastructure,Half Rack X8 BYOL,Half Rack X8,Half Rack,Half Rack X8 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'FULL',    		11, 50, 720, 598,  16, 'Full Rack X8 Infrastructure,Full Rack X8 BYOL,Full Rack X8,Full Rack,Full Rack X8 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'DOUBLE',  		11, 50, 720, 1196, 8,  'Double Rack X8 Infrastructure,Double Rack X8 BYOL,Double Rack X8,Double Rack,Double Rack X8 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'BASE',    		11, 24, 360, 74,   8,  'OCI Base System X8', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, tags, env ) VALUES ('X8-2', 'ELASTIC', 		11, 50, 720, 149,  8,  'Elastic  Rack X8 Infrastructure, Elastic Rack X8 BYOL,Elastic Rack X8,Elastic Rack,Elastic Rack X8 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage,           tags, env ) VALUES ('X8-2', 'ELASTIC_EIGHTH', 8,  24, 360, 74, 	   'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');


-- adding X8M-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'EIGHTH',  		 8,  24, 328,  76,  			  8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'QUARTER', 		 11, 50, 1390, 147, 			  8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Quarter Rack X8M-2 Infrastructure,Quarter Rack X8M-2 BYOL,Quarter Rack X8M-2,Quarter Rack,Quarter Rack X8M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'HALF',    		 11, 50, 1390, 294, 			  16, '1035', 'X8M-2 Elastic Rack HC 14TB',  'Half Rack X8M-2 Infrastructure,Half Rack X8M-2 BYOL,Half Rack X8M-2,Half Rack,Half Rack X8M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'FULL',    		 11, 50, 1390, 588, 			  16, '1035', 'X8M-2 Elastic Rack HC 14TB',  'Full Rack X8M-2 Infrastructure,Full Rack X8M-2 BYOL,Full Rack X8M-2,Full Rack,Full Rack X8M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'DOUBLE',  		 11, 50, 1390, 1176,			  16, '1035', 'X8M-2 Elastic Rack HC 14TB',  'Double Rack X8M-2 Infrastructure,Double Rack X8M-2 BYOL,Double Rack X8M-2,Double Rack,Double Rack X8M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'ELASTIC', 		 11, 50, 1390, 49.89483642578125, 8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Elastic Rack X8M-2 Infrastructure,Elastic Rack X8M-2 BYOL,Elastic Rack X8M-2,Elastic Rack,Elastic Rack X8M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, description, tags, env ) VALUES ('X8M-2', 'ELASTIC_EIGHTH', 8,  24, 328,  76, 				  8,  '1035', 'X8M-2 Elastic Rack HC 14TB',  'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, 		   racktype_code, description, tags, env ) VALUES ('X8M-2', 'BASE', 			 11, 24, 360,  74, 					  '1035', 'X8M-2 Elastic  Rack HC 14TB', 'OCI Base System X8M', 'ociexacc');


-- adding X9M-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'EIGHTH',   		8, 	24,  328,  76,   12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'QUARTER', 		11, 126, 1390, 192,  12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Quarter Rack X9M-2 Infrastructure,Quarter Rack X9M-2 BYOL,Quarter Rack X9M-2,Quarter Rack,Quarter Rack X9M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'ELASTIC', 		11, 126, 1390, 64,   12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Elastic Rack X9M-2 Infrastructure,Elastic Rack X9M-2 BYOL,Elastic Rack X9M-2,Elastic Rack,Elastic Rack X9M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'ELASTIC_LARGE', 	11, 126, 1860, 64,   12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Elastic Rack X9M-2 Infrastructure,Elastic Rack X9M-2 BYOL,Elastic Rack X9M-2,Elastic Rack,Elastic Rack X9M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X9M-2', 'ELASTIC_EIGHTH', 8, 	24,  328,  76,   12,  '1145', 50, 100, 'X9M-2 Elastic Rack HC 18TB', 'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, 									 description, tags, env ) VALUES ('X9M-2', 'HALF',    		11, 126, 1390, 384,  24,  '1145', 		   'X9M-2 Elastic Rack HC 18TB', 'Half Rack X9M-2 Infrastructure,Half Rack X9M-2 BYOL,Half Rack X9M-2,Half Rack,Half Rack X9M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, 									 description, tags, env ) VALUES ('X9M-2', 'FULL',    		11, 126, 1390, 768,  24,  '1145', 		   'X9M-2 Elastic Rack HC 18TB', 'Full Rack X9M-2 Infrastructure,Full Rack X9M-2 BYOL,Full Rack X9M-2,Full Rack,Full Rack X9M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, 									 description, tags, env ) VALUES ('X9M-2', 'DOUBLE',  		11, 126, 1390, 1536, 24,  '1145', 		   'X9M-2 Elastic Rack HC 18TB', 'Double Rack X9M-2 Infrastructure,Double Rack X9M-2 BYOL,Double Rack X9M-2,Double Rack,Double Rack X9M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, 									 description, tags, env ) VALUES ('X9M-2', 'BASE', 			11, 24,  360,  74,   12,  '1145', 		   'X9M-2 Elastic Rack HC 18TB', 'OCI Base System X9M', 'ociexacc');


-- adding X10M-2
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'ELASTIC_EIGHTH',   	8,  30,  660,  35.6, 12, '1205', 50, 100, 'Elastic Rack HC 22TB', 		 'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'ELASTIC', 		   	11, 190, 1390, 80,   12, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Elastic Rack X10M-2 Infrastructure,Elastic Rack X10M-2 BYOL,Elastic Rack X10M-2,Elastic Rack,Elastic Rack X10M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'ELASTIC_LARGE', 	11, 190, 2090, 80,   12, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Elastic Rack X10M-2 Infrastructure,Elastic Rack X10M-2 BYOL,Elastic Rack X10M-2,Elastic Rack,Elastic Rack X10M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'ELASTIC_EXTRALARGE',11, 190, 2800, 80,   12, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Elastic Rack X10M-2 Infrastructure,Elastic Rack X10M-2 BYOL,Elastic Rack X10M-2,Elastic Rack,Elastic Rack X10M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, 		   racktype_code,                                    description, tags, env ) VALUES ('X10M-2', 'BASE', 				11, 24,  360,  74,  	 '1205', 		  'X10M-2 Elastic Rack HC 22TB', 'OCI Base System X10M', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'EIGHTH',   			8,  24,  328,  76,   12, '1205', 50, 100,  'Elastic Rack HC 22TB',        'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'QUARTER', 			11, 190, 1390, 192,  12, '1205', 50, 100, 'X10M Elastic Rack HC 22TB',   'Quarter Rack X10M-2 Infrastructure,Quarter Rack X10M-2 BYOL,Quarter Rack X10M,Quarter Rack,Quarter Rack X10M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'HALF',    			11, 190, 1390, 384,  24, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Half Rack X10M-2 Infrastructure,Half Rack X10M-2 BYOL,Half Rack X10M,Half Rack,Half Rack X10M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'FULL',    			11, 190, 1390, 80,   24, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Full Rack X10M-2 Infrastructure,Full Rack X10M-2 BYOL,Full Rack X10M,Full Rack,Full Rack X10M-2 - Infrastructure - Commit', 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, env ) VALUES ('X10M-2', 'DOUBLE',  			11, 190, 1390, 1536, 24, '1205', 50, 100, 'X10M-2 Elastic Rack HC 22TB', 'Double Rack X10M-2 Infrastructure,Double Rack X10M-2 BYOL,Double Rack X10M-2,Double Rack,Double Rack X10M-2 - Infrastructure - Commit', 'ociexacc');

--adding X11M

INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'ELASTIC_EIGHTH', 8,  30,  660,  74, 12, '1227', 50, 100, 'Elastic Rack HC 22TB',                'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'ELASTIC', 2, 190, 1390, 80,   12, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'ELASTIC_LARGE', 2, 190, 2090, 80,   12, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'ELASTIC_EXTRALARGE',2, 190, 2800, 80,   12, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code,                            description, tags, ecpufactor, env )         VALUES ('X11M', 'BASE', 2, 30,  660,  74, 12,'1224',                  'X11M Elastic Rack HC 22TB', 'OCI Base System X11M', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'EIGHTH', 8,  24,  328,  76,   12, '1227', 50, 100,  'Elastic Rack HC 22TB',        'Eighth Rack,Base System Infrastructure,Base System BYOL,Base System', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'QUARTER', 2, 190, 1390, 192,  12, '1224', 50, 100, 'X11M Elastic Rack HC 22TB',   'Quarter Rack X11M Infrastructure,Quarter Rack X11M BYOL,Quarter Rack X11M,Quarter Rack,Quarter Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'HALF', 2, 190, 1390, 384,  24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Half Rack X11M Infrastructure,Half Rack X11M BYOL,Half Rack X11M,Half Rack,Half Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'FULL', 2, 190, 1390, 80,   24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Full Rack X11M Infrastructure,Full Rack X11M BYOL,Full Rack X11M,Full Rack,Full Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'DOUBLE', 2, 190, 1390, 1536, 24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Double Rack X11M Infrastructure,Double Rack X11M BYOL,Double Rack X11M,Double Rack,Double Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'Z', 2, 32, 768, 40,   24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'ociexacc');
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize, tbStorage, maxracks, racktype_code, gbclientnetspeed , gbrocenetspeed, description, tags, ecpufactor, env ) VALUES ('X11M', 'NOXRMEM', 2, 190, 1390, 80,   24, '1224', 50, 100, 'X11M Elastic Rack HC 22TB', 'Elastic Rack X11M Infrastructure,Elastic Rack X11M BYOL,Elastic Rack X11M,Elastic Rack,Elastic Rack X11M - Infrastructure - Commit', 4, 'ociexacc');

-- Bug 36308005 - EXACS: Fresh provisioning with 23c gi has 19cgi configured post provisioning
INSERT INTO ecs_properties_table (name, type, value) VALUES ('ATP_OVERRIDE_GRID',  'FEATURE', 'DISABLED');

-- Enh 36212504 - ECRA ANALYTICS - Make sure old records are being removed from ecs_analytics
INSERT INTO ecs_properties_table (name, type, value) VALUES ('ANALYTICS_KEEP_RECORDS_DAYS', 'ANALYTICS', '300');

INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('OPERATION_COMPATIBILITY_FEATURE',  'FEATURE', 'DISABLED', 'Property to enable/disable operations compatibility. If the property is enabled the code will use the compatibility matrix to allow parallel operations');

--=====================================================--
--             END OF ECS_HARDWARE INSERTS             -- 
--=====================================================--


--=====================================================--
--    ECS_OH_SPACE_RULE ENTRIES FOR BM ENV (EXACS)     -- 
--=====================================================--
DELETE FROM ECS_OH_SPACE_RULE;
INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('ALL', 'ALL', 1600, 500,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('ALL', 'ALL', 3600, 1100,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'HALF', 99815, 29166,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'EIGHTH', 99815, 14574,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'QUARTER', 99815, 29149,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'FULL', 99815, 29158,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'FULL', 133120, 36488,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'HALF', 133120, 36488,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'QUARTER', 133120, 36488,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'EIGHTH', 133120, 14574,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'LARGE', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ELASTIC', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ELASTIC_EIGHTH', 3100, 900, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'EXTRALARGE', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ALL', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X6-2', 'ALL', 3600, 1100,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X6-2', 'ALL', 1600, 500,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X7-2', 'ALL', 1600, 500,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X7-2', 'ALL', 3600, 1100,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X8M-2', 'ALL', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X8M-2', 'EIGHTH', 3100, 2340, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X8-2', 'ALL', 3100, 900,'','bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X9M-2', 'EIGHTH', 3100, 900, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X9M-2', 'ALL', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'LARGE', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ELASTIC', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ELASTIC_EIGHTH', 3100, 900, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'EXTRALARGE', 3100, 2243, 900,'bm');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ALL', 3100, 2243, 900,'bm');


--=====================================================--
--    ECS_OH_SPACE_RULE ENTRIES FOR OCIEXACC ENV (EXACC)     -- 
--=====================================================--
INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('ALL', 'ALL', 1600, 500,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('ALL', 'ALL', 3600, 1100,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'HALF', 99815, 29166,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'EIGHTH', 99815, 14574,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'QUARTER', 99815, 29149,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X6-2', 'FULL', 99815, 29158,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'FULL', 133120, 36488,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'HALF', 133120, 36488,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'QUARTER', 133120, 36488,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('CELL-X7-2', 'EIGHTH', 133120, 14574,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ELASTIC_LARGE', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ELASTIC', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ELASTIC_EIGHTH', 3100, 900, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ELASTIC_EXTRALARGE', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X10M-2', 'ALL', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X6-2', 'ALL', 3600, 1100,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X6-2', 'ALL', 1600, 500,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X7-2', 'ALL', 1600, 500,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X7-2', 'ALL', 3600, 1100,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X8M-2', 'ALL', 7200, 2340, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X8M-2', 'ALL', 3100, 2340, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X8M-2', 'EIGHTH', 3100, 2340, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X8-2', 'ALL', 3100, 900,'','ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X9M-2', 'EIGHTH', 3100, 900, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X9M-2', 'ALL', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ELASTIC_LARGE', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ELASTIC', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ELASTIC_EIGHTH', 3100, 900, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ELASTIC_EXTRALARGE', 3100, 2243, 900,'ociexacc');

INSERT INTO ECS_OH_SPACE_RULE(MODEL, RACKSIZE, PHYSICALSPACEINGB, USEABLEOHSPACEINGB, MAX_OHSIZE_PER_NODE, ENV)
    VALUES('X11M', 'ALL', 3100, 2243, 900,'ociexacc');

--Enh 37243715 - ECRA X11M - ECRA Should disable delete bonding for non eht0 nodes only
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('DELETE_BONDING_FOR_NON_ETH0','BONDING', 'DISABLED', 'This property enable/disable delete bonding for non-eth0 nodes');

INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('MINIMUM_CELLS_FOR_SPARSE', 'ELASTIC', '5', 'The minimum ammount of cells that should remain for sparse clusters after delete storage flow');


--************************************ UPDATES SECTION *********************************************************
--*************************************************************************************************************

update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=900 where MODEL='X10M-2' and RACKSIZE='ELASTIC_EIGHTH';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='ELASTIC';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='LARGE';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='EXTRALARGE';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='ALL';

UPDATE ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 WHERE MODEL='X9M-2' AND RACKSIZE<>'EIGHTH';


UPDATE ecs_hw_nodes_table SET model_subtype = 'STANDARD' WHERE model_subtype is NULL OR model_subtype = 'STOCK';

-- Bug 36369842 - Update exacloud retry count value
UPDATE ecs_properties_table SET value='5' WHERE name='EXACLOUD_RETRY_COUNT';

-- Bug 36308005 - EXACS: Fresh provisioning with 23c gi has 19cgi configured post provisioning
UPDATE ecs_properties_table SET value='DISABLED' WHERE name='OVERRIDE_GRID';

-- Bug 36628793 - Update some properties description
UPDATE ecs_properties_table SET description='Number of retries for exacloud calls' WHERE name='EXACLOUD_RETRY_COUNT';
UPDATE ecs_properties_table SET description='Number of days to keep records in analytics table' WHERE name='ANALYTICS_KEEP_RECORDS_DAYS';
UPDATE ecs_properties_table SET description='Comma split models to be used in base system provisions. Ex: X8M-2,X9M-2,X10M-2' WHERE name='BASE_SYSTEM_MODELS';
UPDATE ecs_properties_table SET description='Property to enable/disable file system feature, if disabled, 443GB default file system will be in place for new clusters, if enabled, 184GB.',VALUE='ENABLED' WHERE name='FILESYSTEM_FEATURE';

-- Bug 37115247 -Enable CUSTOM_GI
UPDATE ecs_properties_table SET value='ENABLED' WHERE name='CUSTOM_GI'; 

--************************************ END UPDATES SECTION *********************************************************
--*************************************************************************************************************

-- Bug 37746640 - Alter ecs_volumes_table for 19c changes
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

PROMPT Creating sequence sshkeys_seq_id
create sequence sshkeys_seq_id nocache nocycle order;

create or replace trigger sshkeys_id_seq
after insert on sshkeys_table
for each row
begin
  NULL;
end;
/

create or replace trigger sshkeys_id
before insert on sshkeys_table
for each row
begin
  :new.sshid := sshkeys_seq_id.nextval;
end;
/

PROMPT Recreating editioning views on table SSHKEYS_TABLE
CREATE OR REPLACE EDITIONING VIEW SSHKEYS AS
    SELECT
        SSHID,
        TENANTID,
        CLUSTERID,
        SSHKEY,
        TYPE,
        ORACLE_HOSTNAME,
        EXAROOT_URL,
        EXAROOT_USERNAME,
	VAULTACCESS,
	VAULTID,
	TRUSTCERTIFICATES
    FROM
        SSHKEYS_TABLE;

PROMPT Adding ECS property ECRA_LOG_FORMAT and LUMBERJACK_INFO
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_LOG_FORMAT', 'ECRA', 'json');
INSERT INTO ecs_properties (name, type, value) VALUES ('LUMBERJACK_INFO', 'DIAG', 'N/A');

INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_OVERRIDES_COMPARTMENT_ID', 'OCI', 'DISABLED');
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

-- jzandate    06/08/23 - Bug 35402914 - Adding new column osver
PROMPT Altering table ecs_exaunitdetails_table for exadata 23 support
ALTER TABLE ecs_exaunitdetails_table ADD osver varchar(32) DEFAULT NULL;
alter table ecs_exaunitdetails_table ADD (notifications_enabled varchar2(5) default 'FALSE' check (notifications_enabled in ('TRUE', 'FALSE')));
alter table ecs_exaunitdetails_table ADD (autolog_enabled varchar2(5) default 'FALSE' check (autolog_enabled in ('TRUE', 'FALSE')));
alter table ecs_exaunitdetails_table ADD (monitoring_enabled varchar2(5) default 'FALSE' check (monitoring_enabled in ('TRUE', 'FALSE')));

-- changes for ecs_exaunitdetails_table
PROMPT altering table ecs_exaunitdetails_table
alter table ecs_exaunitdetails_table add (reserved_cores number default 0);
alter table ecs_exaunitdetails_table add (reserved_memory number default 0);
alter table ecs_exaunitdetails_table add (total_cores number default 0);
ALTER TABLE ecs_exaunitdetails_table ADD (adbs_enabled varchar(8) default 'FALSE' CHECK (adbs_enabled IN ('TRUE', 'FALSE')));
ALTER TABLE ecs_exaunitdetails_table ADD fsconfig varchar2(32) DEFAULT '443';
-- Enh 35990354 - Adding custom linux uid/gid feature
ALTER TABLE ecs_exaunitdetails_table ADD (CUSTOM_UID_GID varchar2(512));

ALTER TABLE ecs_exaunitdetails_table ADD storage varchar2(6) default 'ASM';
ALTER TABLE ecs_exaunitdetails_table ADD dbvault_ocid varchar2(256) default NULL;
ALTER TABLE ecs_exaunitdetails_table ADD vmvault_ocid varchar2(256) default NULL;

-- ENH 36931770 - Adding ecpu factor snapshot
ALTER TABLE ecs_exaunitdetails_table ADD (ecpufactor number NULL);

PROMPT Recreating editioning views on table ECS_GOLD_SPECS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_GOLD_SPECS AS
    SELECT
        EXAUNIT_ID,
        TYPE,
        TARGET_MACHINE,
        TARGET_MACHINE_NAME,
        NETWORK_COMMUNICATION,
        VALIDATION_TYPE,
        NAME,
        EXPECTED,
        CURRENT_VALUE,
        COMMAND,
        ARGUMENTS,
        EXPECTED_RETURN_CODE,
        CURRENT_RETURN_CODE,
        RESULT,
        MANDATORY,
        MODEL,
        MUTABLE
    FROM
        ECS_GOLD_SPECS_TABLE;

PROMPT Recreating editioning view on  table ECS_EXAUNITDETAILS_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_EXAUNITDETAILS AS
SELECT
    EXAUNIT_ID,
    POD_GUID,
    EXAUNIT_NAME,
    ENTITLEMENT_ID,
    SUBSCRIPTION_ID,
    CUSTOMER_NAME,
    CSI,
    BACKUP_DISK,
    CREATE_SPARSE,
    RACKSIZE,
    GRID_VERSION,
    INITIAL_CORES,
    GB_MEMORY,
    TB_STORAGE,
    GB_STORAGE,
    GB_OHSIZE,
    ATP,
    DOM0_BONDING,
    JUMBO_FRAMES,
    VNUMA,
    ADMIN_PASSWORD,
    RESERVED_CORES,
    RESERVED_MEMORY,
    IMAGE_VERSION,
    ISDATAPLANEENABLED,
    NOTIFICATIONS_ENABLED,
    AUTOLOG_ENABLED,
    MONITORING_ENABLED,
    ASMSS_ENABLED,
    ADBS_ENABLED,
    TOTAL_CORES,
    OSVER,
    FSCONFIG,
    CUSTOM_UID_GID,
    STORAGE,
    DBVAULT_OCID,
    VMVAULT_OCID,
    ECPUFACTOR
FROM
    ECS_EXAUNITDETAILS_TABLE;

CREATE TABLE ECS_EXA_VER_MATRIX_TABLE(
        id                                              NUMBER NOT NULL,
        os_version              varchar(100) NOT NULL, -- domu os version
        exa_version             varchar(500) NOT NULL, -- domu exadata version, supports comma separated values
        hw_model                        varchar(500) NOT NULL, -- dom0 model, supports comma separated values
        gi_version              varchar(500) NOT NULL, -- GI Version, supports comma separated values
        service_type    varchar(100) DEFAULT 'EXACS' NOT NULL, -- EXACS,ADBD, supports comma separated values
        created_at              timestamp DEFAULT systimestamp NOT NULL,
        updated_at              timestamp DEFAULT systimestamp NOT NULL,
        status        varchar(32) DEFAULT 'ENABLED' NOT NULL,
        CONSTRAINT ECS_EXA_VER_MATRIX_E_PK PRIMARY KEY(id),
        CONSTRAINT ECS_EXA_VER_MATRIX_OS_E_UNIQ UNIQUE(os_version, hw_model, exa_version, gi_version, service_type) enable,
        CONSTRAINT "CK_ECS_EXA_VER_MATRIX_STATUS_E" CHECK (status in ('ENABLED', 'DISABLED', 'EXCLUDED')) ENABLE
);
CREATE SEQUENCE ECS_EXA_VER_MAT_SEQ_ID_E nocache nocycle ORDER;

CREATE TABLE ECS_GRID_VERSION_TABLE (
    id                                          NUMBER NOT NULL,
    gi_version          varchar(100) NOT NULL, -- domu os version
    created_at          timestamp DEFAULT systimestamp NOT NULL,
    updated_at          timestamp DEFAULT systimestamp NOT NULL,
    status        varchar(32) DEFAULT 'ENABLED' NOT NULL,
    CONSTRAINT ECS_GRID_VERSION_E_PK PRIMARY KEY(id),
    CONSTRAINT "CK_ECS_GI_VER_STATUS_E" CHECK (status in ('ENABLED', 'DISABLED', 'EXCLUDED')) ENABLE
    );
CREATE SEQUENCE ECS_GI_VER_SEQ_ID_E nocache nocycle ORDER;

CREATE OR REPLACE EDITIONING VIEW ECS_EXA_VER_MATRIX AS
SELECT
    id,
    os_version,
    exa_version,
    hw_model,
    gi_version,
    service_type,
    created_at,
    updated_at,
    status
FROM ECS_EXA_VER_MATRIX_TABLE;

ALTER TABLE ECS_GRID_VERSION_TABLE add (service_type varchar2(64) default 'EXACS');
ALTER TABLE ECS_GRID_VERSION_TABLE add (image_type varchar2(64) default 'RELEASE');
ALTER TABLE ECS_GRID_VERSION_TABLE add (file_image_name varchar2(1024));
ALTER TABLE ECS_GRID_VERSION_TABLE add (checksum varchar2(1024));
ALTER TABLE ECS_GRID_VERSION_TABLE add (location_type varchar2(64));
ALTER TABLE ECS_GRID_VERSION_TABLE add (location_info varchar2(1024));

alter table ecs_grid_version_table drop constraint ecs_grid_version_pk;
alter table ecs_grid_version_table add CONSTRAINT ecs_gridversion_pk PRIMARY KEY (gi_version,service_type);
drop sequence ecs_gi_ver_seq_id;
drop trigger ecs_gi_ver_id;
drop trigger ECS_GRID_VERSION_ID;
alter table ecs_grid_version_table drop column id;


CREATE OR REPLACE EDITIONING VIEW ECS_GRID_VERSION AS
SELECT
    gi_version,
    created_at,
    updated_at,
    status,
    service_type,
    image_type,
    file_image_name,
    checksum,
    location_type,
    location_info
FROM ECS_GRID_VERSION_TABLE;

DROP TRIGGER ECS_EXA_VERS_MATRIX_ID;

CREATE OR REPLACE TRIGGER ECS_EXA_VERS_MATRIX_ID
BEFORE INSERT ON ECS_EXA_VER_MATRIX_TABLE
FOR EACH ROW
BEGIN
        :NEW.id := ECS_EXA_VER_MAT_SEQ_ID_E.nextval;
END;
/

PROMPT Creating table exacc_logmonitor_results_table
create table exacc_logmonitor_results_table
(
   id                    number not null,
   exa_ocid              varchar2(512) not null,
   updated_timestamp     timestamp,
   cps_host              varchar2(512) not null,
   service_name          varchar2(512) not null,
   error_code            varchar2(512) not null,
   error_latest_timestamp    timestamp,
   log_location          varchar2(1024),
   constraint pk_exacc_logmonitor_results
      primary key (id)
);

PROMPT Creating sequence exacc_logmonitor_results_id_seq
create sequence exacc_logmonitor_results_id_seq;

create or replace trigger exacc_logmonitor_results_id_seq
before insert on exacc_logmonitor_results_table
for each row
begin
  :new.id := exacc_logmonitor_results_id_seq.nextval;
end;
/

CREATE OR REPLACE EDITIONING VIEW exacc_logmonitor_results AS 
SELECT
   id,
   exa_ocid,
   updated_timestamp,
   cps_host,
   service_name,
   error_code,
   error_latest_timestamp,
   log_location
FROM
   exacc_logmonitor_results_table;

-- Creating ECRA-NG related tables
PROMPT creating table ecs_users_table
create table ecs_users_table
(
    id number not null,
    user_id varchar2(100) not null,
    first_name varchar2(100) not null,
    last_name varchar2(100) not null,
    password char(64) not null,
    active number(1,0), 
    role_id varchar2(100),
    created_by varchar2(100), 
    modified_by varchar2(100), 
    created_at timestamp default systimestamp, 
    deleted_at timestamp,
    updated_at timestamp, 
    CONSTRAINT USERS_PK PRIMARY KEY ("ID"),
    CONSTRAINT ECS_USERS_UNIQUE_USERID UNIQUE ("USER_ID")
);

PROMPT creating sequence ecs_users_table_seq
create sequence ecs_users_table_seq;


create or replace trigger ecs_users_table_id_seq
before insert on ecs_users_table
for each row
begin
  select ecs_users_table_seq.nextval
  into :new.id
  from dual;
end;
/

PROMPT Recreating editioning views on table ecs_users_table
CREATE OR REPLACE EDITIONING VIEW ecs_users AS
    SELECT
        id,
        user_id,
        first_name,
        last_name,
        password,
        active,
        role_id,
        created_by,
        modified_by,
        created_at,
        deleted_at,
        updated_at
    FROM
        ecs_users_table;

PROMPT creating table ecs_users_history_table
create table ecs_users_history_table
(
    id number not null,
    user_id varchar2(100) not null,
    first_name varchar2(100) not null,
    last_name varchar2(100) not null,
    password char(64) not null,
    active number(1,0),
    role_id varchar2(100),
    action varchar(20),
    created_by varchar2(100),
    modified_by varchar2(100),
    created_at timestamp,
    deleted_at timestamp,
    updated_at timestamp,
    CONSTRAINT USERS_HISTORY_PK PRIMARY KEY ("ID")
);

PROMPT creating sequence ecs_users_history_table_seq
create sequence ecs_users_history_table_seq;

create or replace trigger ecs_users_history_table_id_seq
before insert on ecs_users_history_table
for each row
begin
  select ecs_users_history_table_seq.nextval
  into :new.id
  from dual;
end;
/

PROMPT Recreating editioning views on table ecs_users_history_table
CREATE OR REPLACE EDITIONING VIEW ecs_users_history AS
    SELECT
        id,
        user_id,
        first_name,
        last_name,
        password,
        active,
        role_id,
        action,
        created_by,
        modified_by,
        created_at,
        deleted_at,
        updated_at
    FROM
        ecs_users_history_table;

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

PROMPT creating table ecs_users_locks_table
create table ecs_users_locks_table
(
    id number not null,
    user_id number not null,
    locked number(1,0),
    invalid_login_attempt number,
    lock_start_time timestamp,
    lock_update_time timestamp,
    lock_expire_time timestamp,
    CONSTRAINT USERS_LOCKS_PK PRIMARY KEY ("ID")
);

PROMPT creating sequence ecs_users_locks_table_seq
create sequence ecs_users_locks_table_seq;

create or replace trigger ecs_users_locks_table_id_seq
before insert on ecs_users_locks_table
for each row
begin
  select ecs_users_locks_table_seq.nextval
  into :new.id
  from dual;
end;
/

PROMPT Recreating editioning views on table ecs_users_locks_table
CREATE OR REPLACE EDITIONING VIEW ecs_users_locks AS
    SELECT
        id,
        user_id,
        locked,
        invalid_login_attempt,
        lock_start_time,
        lock_update_time,
        lock_expire_time
    FROM
        ecs_users_locks_table;

PROMPT creating table ecs_password_resets_table
create table ecs_password_resets_table
(
    id number not null,
    user_id number not null,
    created_at timestamp default systimestamp,
    deleted_at timestamp,
    updated_at timestamp,
    CONSTRAINT USERS_PASSWORD_RESETS PRIMARY KEY ("ID")
);

PROMPT creating sequence ecs_password_resets_seq
create sequence ecs_password_resets_seq;

PROMPT Recreating editioning views on table ecs_password_resets_table
CREATE OR REPLACE EDITIONING VIEW ecs_password_resets AS
    SELECT
        id,
        user_id,
        created_at,
        deleted_at,
        updated_at
    FROM
        ecs_password_resets_table;

PROMPT creating table ecs_users_roles_table
create table ecs_users_roles_table
(
    id number not null,
    role varchar2(32),
    created_at timestamp default systimestamp,
    deleted_at timestamp,
    updated_at timestamp,
    CONSTRAINT USERS_ROLES_PK PRIMARY KEY (id),
    CONSTRAINT UNIQUE_USERS_ROLES UNIQUE (role)
);

PROMPT Recreating editioning views on table ecs_users_roles_table
CREATE OR REPLACE EDITIONING VIEW ecs_users_roles AS
    SELECT
        id,
        role,
        created_at,
        deleted_at,
        updated_at
    FROM
        ecs_users_roles_table;

-- Enh 34394111 - Adding admin and user values for user management ecra ng
INSERT INTO ecs_users_roles (id, role) VALUES (1, 'ADMINISTRATOR');
INSERT INTO ecs_users_roles (id, role) VALUES (2, 'APPLICATION_USER');

-- Enh 34394111 - Adding default admin user
INSERT INTO ecs_users (id, user_id, first_name, last_name, password, active, role_id) VALUES (1, 'admin', 'admin', 'admin', 'afda4f4abe00a4a62227776052fffe7a73f7b6f771ecbc14820930cfbd007b73', 1, '1,2');


PROMPT creating table ecs_sla_info_table
CREATE TABLE ecs_sla_info_table
(
    sla_info_id        number(10)    not null,
    exa_ocid           varchar2(150) not null,
    vm_cluster_ocid    varchar2(118) not null,
    network_ocid       varchar2(130) not null,
    minutes_breach     number,
    month              number,
    year               number,
    CONSTRAINT pk_sla_info PRIMARY KEY(sla_info_id)
);

PROMPT Recreating editioning views on table ecs_sla_info_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_info AS
    SELECT sla_info_id, exa_ocid, vm_cluster_ocid, network_ocid, minutes_breach, month, year FROM ecs_sla_info_table;

CREATE SEQUENCE sla_info_id_seq START WITH 1;

CREATE OR REPLACE TRIGGER sla_info_id_trg
BEFORE INSERT ON ecs_sla_info_table
FOR EACH ROW

BEGIN
  SELECT sla_info_id_seq.NEXTVAL
  INTO   :new.sla_info_id
  FROM   dual;
END;
/

PROMPT creating table ecs_sla_hosts_table
CREATE TABLE ecs_sla_hosts_table
(
    sla_info_id        number(10)    not null,
    hostname           varchar2(512) not null,
    domainname         varchar2(512) not null,
    hw_type            varchar2(64) CHECK (hw_type in ('VM', 'COMPUTE','CELL')) NOT NULL,
    CONSTRAINT pk_sla_hosts_table PRIMARY KEY(sla_info_id),
    CONSTRAINT fk_sla_info_id FOREIGN KEY (sla_info_id) REFERENCES ecs_sla_info_table(sla_info_id)
);

PROMPT Recreating editioning views on table ecs_sla_hosts_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_hosts AS
    SELECT sla_info_id, hostname, domainname, hw_type FROM ecs_sla_hosts_table;


PROMPT creating table ecs_metric_type_table
CREATE TABLE ecs_metric_type_table
(
    metric_type_id          number(3)     not null,
    name                    varchar2(512) not null,
    description             varchar2(512) not null,
    sla_impact              varchar2(8) not null,
    CONSTRAINT pk_metric_type_id PRIMARY KEY(metric_type_id)
);

PROMPT Recreating editioning views on table ecs_metric_type_table
CREATE OR REPLACE EDITIONING VIEW ecs_metric_type AS
    SELECT metric_type_id, name, description, sla_impact FROM ecs_metric_type_table; 


PROMPT creating table ecs_cluster_metrics_table
CREATE TABLE ecs_cluster_metrics_table
(
    metric_cluster_id        number(10)    not null,
    exaocid                  varchar2(150) not null,
    metric_type_id           number(3) not null,
    timeutc_event            timestamp not null,
    raw_metric               blob not null,
    value                    number(10) not null,
    hw_type                  varchar2(64) CHECK (hw_type in ('VM', 'COMPUTE','CELL')) NOT NULL,
    hostname                 varchar2(512) not null,
    cellsrvStatus            varchar2(50),
    eth1_interface           varchar2(256),
    eth2_interface           varchar2(256),
    CONSTRAINT pk_metric_cluster_id  PRIMARY KEY(metric_cluster_id),
    CONSTRAINT fk_metric_type_id  FOREIGN KEY (metric_type_id) REFERENCES ecs_metric_type_table(metric_type_id),
);

PROMPT Recreating editioning views on table ecs_cluster_metrics_table
CREATE OR REPLACE EDITIONING VIEW ecs_cluster_metrics AS
    SELECT metric_cluster_id, exaocid, metric_type_id, timeutc_event, raw_metric, value, hw_type, hostname FROM ecs_cluster_metrics_table;


CREATE SEQUENCE ecs_cluster_metrics_seq START WITH 1;

CREATE OR REPLACE TRIGGER ecs_cluster_metrics_trg
BEFORE INSERT ON ecs_cluster_metrics_table
FOR EACH ROW

BEGIN
  SELECT ecs_cluster_metrics_seq.NEXTVAL
  INTO   :new.metric_cluster_id
  FROM   dual;
END;
/

PROMPT creating table ecs_sla_infra_chkpoint_table
CREATE TABLE ecs_sla_infra_chkpoint_table
(
    exa_ocid         varchar2(150) not null,
    last_check       timestamp not null,
    CONSTRAINT pk_exaocid  PRIMARY KEY(exa_ocid)
);

PROMPT Recreating editioning views on table ecs_sla_infra_chkpoint_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_infra_chkpoint AS
    SELECT exa_ocid, last_check FROM ecs_sla_infra_chkpoint_table;

PROMPT creating table ecs_sla_breach_table
CREATE TABLE ecs_sla_breach_table
(
    sla_breach_id           number(10) not null,
    metric_cluster_id       number(10) not null,
    sla_info_id             number(10) not null,
    time_event_start        timestamp not null,
    time_event_end          timestamp not null,
    breach_type             varchar2(100) CHECK (breach_type in ('availability', 'performance')) NOT NULL,
    CONSTRAINT pk_sla_breach_id  PRIMARY KEY(sla_breach_id),
    CONSTRAINT fk_metric_cluster_id  FOREIGN KEY (metric_cluster_id) REFERENCES ecs_cluster_metrics_table(metric_cluster_id),
    CONSTRAINT fk_sla_breach_info_id  FOREIGN KEY (sla_info_id) REFERENCES ecs_sla_info_table(sla_info_id)
);

-- Bug 35827954 - DROP metric_cluster_id, MODIFY time_event_end
ALTER TABLE ecs_sla_breach_table DROP CONSTRAINT fk_metric_cluster_id;
ALTER TABLE ecs_sla_breach_table DROP COLUMN metric_cluster_id;
ALTER TABLE ecs_sla_breach_table MODIFY time_event_end timestamp NULL;

PROMPT Recreating editioning views on table ecs_sla_breach_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_breach AS
    SELECT sla_breach_id, sla_info_id, time_event_start, time_event_end, breach_type FROM ecs_sla_breach_table;

CREATE SEQUENCE ecs_sla_breach_seq START WITH 1;

CREATE OR REPLACE TRIGGER ecs_sla_breach_trg
BEFORE INSERT ON ecs_sla_breach_table
FOR EACH ROW

BEGIN
  SELECT ecs_sla_breach_seq.NEXTVAL
  INTO   :new.sla_breach_id
  FROM   dual;
END;
/


PROMPT creating table ecs_sla_breach_reason_table
CREATE TABLE ecs_sla_breach_reason_table
(
    sla_breach_id         number(10) not null,
    reason                varchar2(256) not null,
    CONSTRAINT pk_sla_breach_rs_id  PRIMARY KEY(sla_breach_id),
    CONSTRAINT fk_sla_breach_rs_id  FOREIGN KEY (sla_breach_id) REFERENCES ecs_sla_breach_table(sla_breach_id)
);


-- Bug 36353998 - ECRA DB SCHEMA DIFFERENT BETWEEN PRODUCTION AND DEV
ALTER TABLE ecs_sla_info_table ADD aggregate_status VARCHAR2(32) DEFAULT 'PENDING';

ALTER TABLE ecs_sla_hosts_table DROP CONSTRAINT fk_sla_info_id;
ALTER TABLE ecs_sla_hosts_table DROP CONSTRAINT pk_sla_hosts_table;
ALTER TABLE ecs_sla_hosts_table DROP COLUMN sla_info_id;
ALTER TABLE ecs_sla_hosts_table ADD sla_host_id number(10) NOT NULL;
ALTER TABLE ecs_sla_hosts_table ADD CONSTRAINT pk_sla_hosts_table PRIMARY KEY(sla_host_id);

ALTER TABLE ecs_cluster_metrics_table DROP COLUMN cellsrvStatus;
ALTER TABLE ecs_cluster_metrics_table DROP COLUMN eth1_interface;
ALTER TABLE ecs_cluster_metrics_table DROP COLUMN eth2_interface;
ALTER TABLE ecs_cluster_metrics_table ADD monitoring_timestamp TIMESTAMP;

ALTER TABLE ecs_sla_breach_table DROP CONSTRAINT fk_sla_breach_info_id;
ALTER TABLE ecs_sla_breach_table ADD CONSTRAINT fk_sla_breach_info_id FOREIGN KEY (sla_info_id) REFERENCES ecs_sla_info_table(sla_info_id) ON DELETE CASCADE;

ALTER TABLE ecs_sla_breach_reason_table DROP COLUMN hosts_involved;
ALTER TABLE ecs_sla_breach_reason_table DROP CONSTRAINT fk_sla_breach_rs_id;
ALTER TABLE ecs_sla_breach_reason_table ADD CONSTRAINT fk_sla_breach_rs_id  FOREIGN KEY (sla_breach_id) REFERENCES ecs_sla_breach_table(sla_breach_id) ON DELETE CASCADE;


PROMPT creating table ecs_sla_info_hosts_table
CREATE TABLE ecs_sla_info_hosts_table
(
    sla_info_id        number(10)    not null,
    sla_host_id        number(10)    not null,
    CONSTRAINT fk_sla_info_hosts_sla_info_id FOREIGN KEY (sla_info_id) REFERENCES ecs_sla_info_table(sla_info_id) ON DELETE CASCADE,
    CONSTRAINT fk_sla_info_hosts_sla_host_id FOREIGN KEY (sla_host_id) REFERENCES ecs_sla_hosts_table(sla_host_id)
);

PROMPT creating table ecs_sla_breach_hosts_table
CREATE TABLE ecs_sla_breach_hosts_table
(
    sla_breach_id      number(10)    not null,
    sla_host_id        number(10)    not null,
    CONSTRAINT fk_sla_brch_hosts_sla_brch_id FOREIGN KEY (sla_breach_id) REFERENCES ecs_sla_breach_table(sla_breach_id) ON DELETE CASCADE,
    CONSTRAINT fk_sla_brch_hosts_sla_host_id FOREIGN KEY (sla_host_id) REFERENCES ecs_sla_hosts_table(sla_host_id)
);


CREATE SEQUENCE sla_host_id_seq START WITH 1;

CREATE OR REPLACE TRIGGER sla_host_id_trg
BEFORE INSERT ON ecs_sla_hosts_table
FOR EACH ROW

BEGIN
  SELECT sla_host_id_seq.NEXTVAL
  INTO   :new.sla_host_id
  FROM   dual;
END;
/


PROMPT Recreating editioning views on table ecs_sla_info_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_info AS
    SELECT
        sla_info_id,
        exa_ocid,
        vm_cluster_ocid,
        network_ocid,
        minutes_breach,
        month,
        year,
        aggregate_status
    FROM
        ecs_sla_info_table;

PROMPT Recreating editioning views on table ecs_sla_hosts_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_hosts AS
    SELECT
        sla_host_id,
        hostname,
        domainname,
        hw_type
    FROM
        ecs_sla_hosts_table;

PROMPT Recreating editioning views on table ecs_cluster_metrics_table
CREATE OR REPLACE EDITIONING VIEW ecs_cluster_metrics AS
    SELECT
        metric_cluster_id,
        exaocid,
        metric_type_id,
        timeutc_event,
        raw_metric,
        value,
        hw_type,
        hostname,
        monitoring_timestamp
    FROM
        ecs_cluster_metrics_table;

PROMPT Recreating editioning views on table ecs_sla_breach_reason_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_breach_reason AS
    SELECT
        sla_breach_id,
        reason
    FROM
        ecs_sla_breach_reason_table;

PROMPT Recreating editioning views on table ecs_sla_info_hosts_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_info_hosts AS
    SELECT
        sla_info_id,
        sla_host_id
    FROM
        ecs_sla_info_hosts_table;

PROMPT Recreating editioning views on table ecs_sla_breach_hosts_table
CREATE OR REPLACE EDITIONING VIEW ecs_sla_breach_hosts AS
    SELECT
        sla_breach_id,
        sla_host_id
    FROM
        ecs_sla_breach_hosts_table;


/* NOTES:

- ecs_sla_info_table
 Adding missing aggregate_status column

- ecs_sla_hosts_table
 Changing sla_info_id to sla_host_id
 No edition uses sla_info_id, safe to remove it

- ecs_cluster_metrics_table
 Drop unused columns and add monitoring_timestamp
 No edition uses cellsrvStatus, eth1_interface or eth2_interface, safe to remove them

- ecs_sla_breach_table
 Add ON DELETE CASCADE to fk constrain

- ecs_sla_breach_reason_table
 Drop unused column hosts_involved (not used by any edition)
 Add ON DELETE CASCADE to fk constrain

- ecs_sla_info_hosts_table
- ecs_sla_breach_hosts_table
 Create table and editioning view

*/

-- End of Bug 36353998


-- Bug 36541136 - REDUCE NUMBER OF READS FROM ECS_CLUSTER_METRICS (ADD LAST_UPTIME_METRIC_ID TO ECS_SLA_HOSTS)

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

/* NOTES:

- ecs_sla_hosts_table
 Adding last_uptime_metric_id column to keep track of last processed metric per node
 Adding index on hostname to avoid fullscan of the table

- ecs_sla_info_table
 Adding index on exaocid, vmclusterocid

- ecs_sla_breach_table
 Adding index on sla_info_id

- ecs_sla_info_hosts_table
 Adding index on sla_info_id

- ecs_sla_breach_hosts_table
 Adding index on sla_breach_id

*/

-- End of Bug 36541136

-- Bug 34538859 - Adding Metric types for exacc sla

INSERT INTO ecs_metric_type_table(metric_type_id, name, description, sla_impact) VALUES ('1', 'Exadata.InfraSwitch.Uptime', 'IB or ROCE switches uptime', 'TRUE');
INSERT INTO ecs_metric_type_table(metric_type_id, name, description, sla_impact) VALUES ('2', 'Exadata.Cell.Uptime', 'Cell uptime', 'TRUE');
INSERT INTO ecs_metric_type_table(metric_type_id, name, description, sla_impact) VALUES ('3', 'Exadata.Dom0.Uptime', 'Dom0 uptime', 'TRUE');
INSERT INTO ecs_metric_type_table(metric_type_id, name, description, sla_impact) VALUES ('4', 'Exadata.Cell.Status', 'Cell Status', 'TRUE');

INSERT INTO ecs_properties (name, type, value) VALUES ('RUNNER_TIMEOUT', 'ECRA', '10');


-- Enh 35651071
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_FILES_ONSTART_DELETE_OLDERTHAN', 'ECRA', '1Y');

-- Bug 35670473 - FIX ALL SQL DIFFS BETWEEN ECS_MAIN_LINUX.X64_230802.1131 VS ECS_22.2.1.4.0_LINUX.X64_230728.0130 AND ADD TO NEW_ECRA_SCHEMA_CHANGES.SQL 
-- creating tables
PROMPT Creating table ecs_oci_infra_last_ips_trnst_table
create table ecs_oci_infra_last_ips_trnst_table(
	exa_ocid                varchar2(512) NOT NULL,
	admin_ip                varchar2(32),
	clib                    varchar2(32), 
	stib                    varchar2(32),
	admin_cidr              varchar2(32),
	storage_cidr            varchar2(32),
	cluster_cidr            varchar2(32),
	admin_netmask           varchar2(15),
	clib_netmask            varchar2(15),
	stib_netmask            varchar2(15),
	CONSTRAINT pk_exa_ocid_last_ip_trnst PRIMARY KEY (exa_ocid)
);

CREATE OR REPLACE EDITIONING VIEW ecs_oci_infra_last_ips_trnst as
 SELECT 
	exa_ocid,
	admin_ip,
	clib,
	stib,
	admin_cidr,
	storage_cidr,
	cluster_cidr,
	admin_netmask,
	clib_netmask,
	stib_netmask
  FROM ecs_oci_infra_last_ips_trnst_table;

PROMPT Creating table ecs_infra_resourceprincipal_table
CREATE TABLE ecs_infra_resourceprincipal_table(
    exaocid                     VARCHAR2(512) NOT NULL,
    uuid                        VARCHAR2(36) NOT NULL,
    resourceprincipal           CLOB NOT NULL,
    CONSTRAINT pk_infra_resourceprincipal
        PRIMARY KEY (exaocid),
    CONSTRAINT  fk_exa_ocid_infra_resourceprincipal
        FOREIGN KEY (exaocid)
        REFERENCES  ecs_oci_exa_info_table(exa_ocid)
);

CREATE OR REPLACE EDITIONING VIEW ecs_infra_resourceprincipal AS
SELECT 
	exaocid,
	uuid,
	resourceprincipal
	FROM ecs_infra_resourceprincipal_table;

-- Enh 37508426 Alter exacompute entity table
ALTER TABLE ecs_exacompute_entity_table ADD volumes clob;
-- Enh 37740901 Alter exacompute entity table 19c support and BaseDB
ALTER TABLE ecs_exacompute_entity_table add (servicesubtype varchar2(16) default 'exadbxs' not null);
ALTER TABLE ecs_exacompute_entity_table add (clustertype varchar2(16) default 'smartstorage' not null);
ALTER TABLE ecs_exacompute_entity_table add (sourceclusterid varchar2(256) default NULL);

PROMPT Enh 33509359 Creating ecs_exacompute_entity_table
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

PROMPT creating table ecs_rotation_schedule_table
CREATE TABLE ecs_rotation_schedule_table
(
    secret_name         VARCHAR2(100) NOT NULL,
    vault_name          VARCHAR2(100) NOT NULL,
    last_rotation       TIMESTAMP NOT NULL,
    rotation_status     VARCHAR2(8) NOT NULL,
    CONSTRAINT ck_rotation_status CHECK (rotation_status in ('DONE', 'PENDING', 'FAILED')),
    CONSTRAINT pk_rotation_schedule PRIMARY KEY (secret_name, vault_name)
);

CREATE OR REPLACE EDITIONING VIEW ecs_rotation_schedule AS
SELECT
	secret_name,
	vault_name,
	last_rotation,
	rotation_status
FROM ecs_rotation_schedule_table;

PROMPT creating table ecs_cps_dyn_task_table
CREATE TABLE ecs_cps_dyn_task_table
(
    component_name         VARCHAR2(16) NOT NULL,
    tar_location           VARCHAR2(254) NOT NULL,
    ecs_series             VARCHAR2(100) NOT NULL,
    script_order           VARCHAR2(8) NOT NULL,
    CONSTRAINT pk_cps_dyn_task PRIMARY KEY (component_name, ecs_series)
);

CREATE OR REPLACE EDITIONING VIEW ecs_elastic_platform_info AS
SELECT
        MODEL,
        SUPPORTED_SHAPES,
        OEDA_CODENAME,
        MAXCOMPUTES,
        MAXCELLS,
        ILOMTYPE,
        SUPPORT_STATUS,
        FEATURE,
        HW_TYPE
FROM ecs_elastic_platform_info_table;

CREATE OR REPLACE EDITIONING VIEW ecs_cps_dyn_task AS
SELECT 
	component_name,
	tar_location,
	ecs_series,
	script_order
FROM ecs_cps_dyn_task_table;

PROMPT creating table ecs_maintenance_domains_table
create table ecs_maintenance_domains_table
(
    id      number not null,
    start_day     number,
    end_day       number,
    fabric_name   varchar2(1024 byte),
    max_cpu number,
    max_memory_in_bytes number,
    max_storageLocal_in_bytes number,
    CONSTRAINT  fk_md_ecs_rocefabric_name
        FOREIGN KEY (fabric_name)
        REFERENCES  ecs_rocefabric_table(fabric_name),
    CONSTRAINT maintenance_domains_pk PRIMARY KEY(id,fabric_name)
);

CREATE OR REPLACE EDITIONING VIEW ecs_maintenance_domains AS
SELECT
        id,
        start_day,
        end_day,
        fabric_name,
	    max_cpu,
	    max_memory_in_bytes,
	    max_storageLocal_in_bytes
FROM ecs_maintenance_domains_table;


PROMPT creating table ecs_cps_wf_details_table
create table ecs_cps_wf_details_table
(
    wf_uuid            varchar2(2048) not null,
    exa_ocid           varchar2(512) NOT NULL,
    component_name     varchar2(24) NOT NULL,
    master_host        varchar2(512),
    standby_host       varchar2(512),
    operation          varchar2(24),
    cps_version_master  varchar2(512),
    cps_version_standby varchar2(512),
    CONSTRAINT pk_cps_host_id PRIMARY KEY ( wf_uuid , exa_ocid));


CREATE OR REPLACE EDITIONING VIEW ecs_cps_wf_details AS
SELECT
        wf_uuid,
        exa_ocid,
        component_name,
        master_host,
	    standby_host,
	    operation,
	    cps_version_master,
	    cps_version_standby
FROM ecs_cps_wf_details_table;

PROMPT creating table ecs_mdcontext_table
create table ecs_mdcontext_table 
(
    name      varchar2(1024),
    model     varchar2(16),
    max_cpu   number,
    max_memory_in_bytes number,
    max_storageLocal_in_bytes number,
    CONSTRAINT  fk_mdcontext_name
        FOREIGN KEY (name)
        REFERENCES  ecs_rocefabric_table(fabric_name),
    CONSTRAINT mdcontext_pk PRIMARY KEY(name, model)
);

CREATE OR REPLACE EDITIONING VIEW ecs_mdcontext AS
SELECT
        name,
        model,
        max_cpu,
        max_memory_in_bytes,
		 max_storageLocal_in_bytes
FROM ecs_mdcontext_table;

PROMPT Recreating editioning views on table ecs_oci_vnics_table 
CREATE OR REPLACE EDITIONING VIEW ecs_oci_vnics AS
    SELECT
        OCID,
        INSTANCEOCID,
        SUBNETOCID,
        HOSTNAMELABEL,
        PRIMARYIP,
        VLANTAG,
        ATTACHMENTID,
        MACADDRESS,
        ISPRIMARY,
        RACKNAME
    FROM 
        ecs_oci_vnics_table;

-- changes for ecs_exadata_vcompute_node_table
PROMPT Recreating editioning views on table ecs_exadata_vcompute_node_table
CREATE OR REPLACE EDITIONING VIEW ecs_exadata_vcompute_node AS
    SELECT
        HOSTNAME,
        EXACOMPUTE_HOSTNAME,
        EXAUNIT_ID,
        RACK_NAME,
        HOSTNAME_CUSTOMER,
        VM_STATE,
        LAST_VM_STATE_CHANGE_TIME
    FROM
        ecs_exadata_vcompute_node_table;

-- changes for ecs_exadata_patch_versions_table
PROMPT Recreating editioning views on table ecs_exadata_patch_versions_table
CREATE OR REPLACE EDITIONING VIEW ecs_exadata_patch_versions AS
    SELECT
        service_type,
        patch_type,
        target_type,
        image_version,
        comments,
        rack_model,
        last_updated_time
    FROM
        ecs_exadata_patch_versions_table;

-- changes for ecs_domus_table
PROMPT altering table ecs_domus_table
alter table ecs_domus_table add vmid varchar2(256);
alter table ecs_domus_table add customer_client_mac varchar2(256);
alter table ecs_domus_table add customer_client_vlantag number;
alter table ecs_domus_table add customer_client_mtu number;
alter table ecs_domus_table add customer_backup_mac varchar2(256);
alter table ecs_domus_table add customer_backup_vlantag number;
alter table ecs_domus_table add customer_backup_mtu number;
alter table ecs_domus_table add cus_client_standbyvnicmac varchar2(256);
alter table ecs_domus_table add cus_backup_standbyvnicmac varchar2(256);
alter table ecs_domus_table
    add (state varchar2(64) DEFAULT 'RUNNING' CHECK (state in ('RUNNING',
                'STOPPED', 'MIGRATING', 'PATCHING', 'RESOURCE_SCALING',
                'TERMINATING', 'ERROR', 'PROVISIONING', 'DELETED')));
alter table ecs_domus_table add image_version varchar2(64);
alter table ecs_domus_table add db_client_vip_v6 varchar2(256);
alter table ecs_domus_table add db_client_vip_v6netmask varchar2(256);
alter table ecs_domus_table add db_client_ipv6 varchar2(256);
alter table ecs_domus_table add db_client_v6gateway varchar2(256);
alter table ecs_domus_table add db_client_v6netmask varchar2(256);
alter table ecs_domus_table add db_backup_ipv6 varchar2(256);
alter table ecs_domus_table add db_backup_v6gateway varchar2(256);
alter table ecs_domus_table add db_backup_v6netmask varchar2(256);

ALTER TABLE ECS_DOMUS_TABLE MODIFY GATEWAY_ADAPTER    DEFAULT 'CLIENT';
ALTER TABLE ECS_DOMUS_TABLE MODIFY HOSTNAME_ADAPTER   DEFAULT 'CLIENT';
ALTER TABLE ECS_DOMUS_TABLE MODIFY ADMIN_NETWORK_TYPE DEFAULT 'NAT';
ALTER TABLE ECS_DOMUS_TABLE MODIFY STATE              DEFAULT 'RUNNING';
ALTER TABLE ECS_DOMUS_TABLE MODIFY EXA_OCID           DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA' NOT NULL NOVALIDATE;

ALTER TABLE ECS_DOMUS_TABLE ADD CONSTRAINT ECS_DOMUS_ADM_NETTYPE_CK CHECK (admin_network_type in ('NAT', 'NON-NAT')) ENABLE;
ALTER TABLE ECS_DOMUS_TABLE ADD CONSTRAINT ECS_DOMUS_GTWY_ADPTR CHECK (gateway_adapter in ('ADMIN', 'CLIENT', 'BACKUP')) ENABLE;
ALTER TABLE ECS_DOMUS_TABLE ADD CONSTRAINT ECS_DOMUS_HOSTNAME_ADPTR CHECK (hostname_adapter in ('ADMIN', 'CLIENT', 'BACKUP')) ENABLE;
ALTER TABLE ECS_DOMUS_TABLE ADD CONSTRAINT ECS_DOMUS_ADMIN_CK CHECK (( /* for BMC :if admin_network_type is NAT, admin_host_name cannot be null */
          admin_network_type = 'NAT'
      and db_client_mac   is not null
      and db_backup_mac   is not null
     )
     or
     ( /* for all others db_client_mac, db_backup_mac are null */
       admin_network_type = 'NON-NAT'
    )) ENABLE;

ALTER TABLE ecs_domus_table ADD CONSTRAINT ecs_domus_ecs_rname_exaocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS_TABLE(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_domus_table ADD CONSTRAINT ecs_domus_hw_node_id_fk FOREIGN KEY (hw_node_id)
    REFERENCES ecs_hw_nodes_table(id) deferrable initially deferred;

DECLARE
  c_name all_constraints.constraint_name%type;
BEGIN
  SELECT constraint_name INTO c_name FROM all_constraints WHERE table_name='ECS_DOMUS_TABLE' AND search_condition_vc LIKE '%state%in%RUNNING%';
  EXECUTE immediate 'ALTER TABLE ecs_domus_table drop CONSTRAINT ' || c_name;
  EXECUTE immediate 'ALTER TABLE ecs_domus_table ADD CONSTRAINT ecs_domus_state_ck CHECK (state IN (''RUNNING'',''STOPPED'', ''MIGRATING'', ''PATCHING'', ''RESOURCE_SCALING'',''TERMINATING'', ''ERROR'', ''PROVISIONING'',''DELETED''))';
END;
/


CREATE OR REPLACE EDITIONING VIEW ecs_domus as
    SELECT
        ECS_RACKS_NAME,
        HW_NODE_ID,
        DB_CLIENT_MAC,
        DB_BACKUP_MAC,
        GATEWAY_ADAPTER,
        HOSTNAME_ADAPTER,
        ADMIN_IP,
        ADMIN_HOST_NAME,
        ADMIN_NETMASK,
        ADMIN_DOMIANNAME,
        ADMIN_VLAN_TAG,
        ADMIN_GATEWAY,
        ADMIN_NETWORK_TYPE,
        DB_CLIENT_IP,
        DB_CLIENT_HOST_NAME,
        DB_CLIENT_NETMASK,
        DB_CLIENT_DOMIANNAME,
        DB_CLIENT_VLAN_TAG,
        DB_CLIENT_GATEWAY,
        DB_CLIENT_IPV6,
        DB_CLIENT_V6NETMASK,
        DB_CLIENT_V6GATEWAY,
        DB_CLIENT_MASTER_INTERFACE,
        DB_CLIENT_SLAVE_INTERFACE_1,
        DB_CLIENT_SLAVE_INTERFACE_2,
        DB_CLIENT_VIP,
        DB_CLIENT_VIP_HOST_NAME,
        DB_CLIENT_VIP_NETMASK,
        DB_CLIENT_VIP_DOMIANNAME,
        DB_CLIENT_VIP_VLAN_TAG,
        DB_CLIENT_VIP_GATEWAY,
        DB_CLIENT_VIP_V6,
        DB_CLIENT_VIP_V6NETMASK,
        DB_CLIENT_VIP_V6GATEWAY,
        DB_BACKUP_IP,
        DB_BACKUP_HOST_NAME,
        DB_BACKUP_NETMASK,
        DB_BACKUP_DOMIANNAME,
        DB_BACKUP_VLAN_TAG,
        DB_BACKUP_GATEWAY,
        DB_BACKUP_IPV6,
        DB_BACKUP_V6NETMASK,
        DB_BACKUP_V6GATEWAY,
        DB_BACKUP_MASTER_INTERFACE,
        DB_BACKUP_SLAVE_INTERFACE_1,
        DB_BACKUP_SLAVE_INTERFACE_2,
        COMPUTE_IB1_IP,
        COMPUTE_IB1_HOST_NAME,
        COMPUTE_IB1_NETMASK,
        COMPUTE_IB1_DOMIANNAME,
        COMPUTE_IB1_GATEWAY,
        COMPUTE_IB2_IP,
        COMPUTE_IB2_HOST_NAME,
        COMPUTE_IB2_NETMASK,
        COMPUTE_IB2_DOMIANNAME,
        COMPUTE_IB2_GATEWAY,
        STORAGE_IB1_IP,
        STORAGE_IB1_HOST_NAME,
        STORAGE_IB1_NETMASK,
        STORAGE_IB1_DOMIANNAME,
        STORAGE_IB1_GATEWAY,
        STORAGE_IB2_IP,
        STORAGE_IB2_HOST_NAME,
        STORAGE_IB2_NETMASK,
        STORAGE_IB2_DOMIANNAME,
        STORAGE_IB2_GATEWAY,
        VM_SIZE_NAME,
        STATE,
        EXA_OCID,
        VMID,
        CUSTOMER_CLIENT_MAC,
        CUSTOMER_CLIENT_VLANTAG,
        CUSTOMER_CLIENT_MTU,
        CUSTOMER_BACKUP_MAC,
        CUSTOMER_BACKUP_VLANTAG,
        CUSTOMER_BACKUP_MTU,
        CUS_CLIENT_STANDBYVNICMAC,
        CUS_BACKUP_STANDBYVNICMAC,
        IMAGE_VERSION
    FROM ecs_domus_table;

-- changes for ecs_racks_table
PROMPT altering table ecs_racks_table
ALTER TABLE ecs_racks_table add cluster_status varchar(256) DEFAULT 'ACTIVE'
CONSTRAINT cluster_status_ck
CHECK (cluster_status in ('ACTIVE', 'SUSPENDED', 'VM_MOVE'));
CREATE OR REPLACE EDITIONING VIEW ecs_racks AS
SELECT * FROM ecs_racks_table;

PROMPT Altering table ecs_requests_table
alter table ecs_requests_table add (progress_percent NUMBER default 0);

PROMPT Altering table ecs_requests_table
alter table ecs_requests_table add (step_progress_details clob);

--Enh 37001368 - Changing target_uri field size
ALTER TABLE ECS_REQUESTS_TABLE MODIFY TARGET_URI VARCHAR2(512);

CREATE OR REPLACE EDITIONING VIEW ecs_requests AS
SELECT * FROM ecs_requests_table;

-- Enh 36696921 - modify error_msg column in ecs_exa_applied_patches_table
PROMPT Altering table ecs_exa_applied_patches_table (modify error_msg column length to 4000)
alter table ecs_exa_applied_patches_table modify (error_msg varchar2(4000));
CREATE OR REPLACE EDITIONING VIEW ecs_exa_applied_patches AS
	SELECT
		id,
		exa_ocid,
		exaunit_id,
		rack_name,
		cabinet_name,
		patch_type,
		target_type,
		target_fqdn,
		operation,
		current_image_version,
		start_time,
		end_time,
		status,
		attempted_version,
		error_code,
		error_msg,
		exasplice_version,
		child_uuid,
		dispatcher_uuid
	FROM ecs_exa_applied_patches_table;

-- change for ecs_kvmippool_table
alter table ecs_kvmippool_table drop constraint ecs_kvmippool_iptype_ck;
alter table ecs_kvmippool_table add constraint ecs_kvmippool_iptype_ck CHECK (IPTYPE in ('COMPUTE', 'STORAGE', 'EXASCALE', 'COMPUTE-STORAGE', 'COMPUTE-EXASCALE'));
alter table ecs_kvmippool_table add (ipblock number default 1);
CREATE OR REPLACE EDITIONING VIEW ecs_kvmippool AS
SELECT * FROM ecs_kvmippool_table;

-- change for ecs_scheduled_ondemand_exec_table
ALTER TABLE ecs_scheduled_ondemand_exec_table ADD parent_req_id VARCHAR2(64);
CREATE OR REPLACE EDITIONING VIEW ecs_scheduled_ondemand_exec AS
SELECT * FROM ecs_scheduled_ondemand_exec_table;

--change for ecs_v_mvm_domus, subsequent update need versioning for the view
CREATE OR REPLACE VIEW ecs_v_mvm_domus AS
SELECT
    vcompute.hostname AS domu,
    vcompute.exacompute_hostname as dom0,
    substr(vcompute.exacompute_hostname,0,instr(vcompute.exacompute_hostname,'.')-1) AS node,
    vcompute.exaunit_id,
    vcompute.hostname_customer,
    ecs_exadata_compute_node.exaservice_id,
    ecs_exadata_compute_node.exadata_id,
    ecs_exadata_compute_node.aliasname AS alias,
    (exaunit.initial_cores / (SELECT COUNT(*) from ecs_exadata_vcompute_node WHERE exaunit_id=vcompute.exaunit_id) ) AS cores,
    (exaunit.gb_memory / (SELECT COUNT(*) FROM ecs_exadata_vcompute_node WHERE  exaunit_id=vcompute.exaunit_id) ) AS memory,
    (exaunit.reserved_cores / (SELECT COUNT(*) FROM ecs_exadata_vcompute_node WHERE  exaunit_id=vcompute.exaunit_id) ) AS reserved_cores,
    (exaunit.reserved_memory / (SELECT COUNT(*) FROM ecs_exadata_vcompute_node WHERE  exaunit_id=vcompute.exaunit_id) ) AS reserved_memory,
    (exaunit.total_cores / (SELECT COUNT(*) FROM ecs_exadata_vcompute_node WHERE  exaunit_id=vcompute.exaunit_id) ) AS total_cores,
    (exaunit.gb_ohsize ) AS oracle_home
FROM ecs_exadata_vcompute_node vcompute
    LEFT JOIN ecs_exadata_compute_node ON substr(vcompute.exacompute_hostname,0,instr(vcompute.exacompute_hostname,'.')-1) = ecs_exadata_compute_node.inventory_id
    LEFT JOIN ecs_exaunitdetails exaunit ON vcompute.exaunit_id = exaunit.exaunit_id
ORDER BY vcompute.exaunit_id;

PROMPT Renaming table ecs_oci_cell_last_ip_cidr_table to ecs_oci_infranode_last_ips_table
RENAME ecs_oci_cell_last_ip_cidr_table TO ecs_oci_infranode_last_ips_table;

-- altering table ecs_oci_infranode_last_ips_table
alter table ecs_oci_infranode_last_ips_table ADD (admin_netmask varchar2(15));
alter table ecs_oci_infranode_last_ips_table ADD (clib_netmask varchar2(15));
alter table ecs_oci_infranode_last_ips_table ADD (stib_netmask varchar2(15));
CREATE OR REPLACE EDITIONING VIEW ecs_oci_infranode_last_ips AS
SELECT * FROM ecs_oci_infranode_last_ips_table;

-- change for ecs_oci_networknodes_table
alter table ecs_oci_networknodes_table add state varchar2(24) CONSTRAINT ecs_oci_networknodes_state
   CHECK (state in ('READY', 'AWATING_ACTIVATION', 'ACTIVATION_ERR', 'ATTACHED'));
alter table ecs_oci_networknodes_table modify IP VARCHAR2(32) null;
alter table ecs_oci_networknodes_table modify HOSTNAME VARCHAR2(512) null;
alter table ecs_oci_networknodes_table modify DOMAINNAME VARCHAR2(512) null;
alter table ecs_oci_networknodes_table add vmid varchar2(256);
alter table ecs_oci_networknodes_table add mac varchar2(256);
alter table ecs_oci_networknodes_table add standby_vnic_mac varchar2(256);
alter table ecs_oci_networknodes_table modify STATE DEFAULT 'AWATING_ACTIVATION';
CREATE OR REPLACE EDITIONING VIEW ecs_oci_networknodes AS
SELECT * FROM ecs_oci_networknodes_table;

-- change for exacc_availimages_info_table
PROMPT Altering table exacc_availimages_info_table
alter TABLE exacc_availimages_info_table ADD (dwnld_tsp varchar2(512));
update exacc_availimages_info_table SET dwnld_tsp = download_timestamp;
alter table exacc_availimages_info_table drop column download_timestamp;
alter table exacc_availimages_info_table rename column dwnld_tsp to download_timestamp;
alter TABLE exacc_availimages_info_table ADD (updt_tsp varchar2(512));
update exacc_availimages_info_table SET updt_tsp = updated_timestamp;
alter table exacc_availimages_info_table drop column updated_timestamp;
alter table exacc_availimages_info_table rename column updt_tsp to updated_timestamp;
CREATE OR REPLACE EDITIONING VIEW exacc_availimages_info AS
SELECT * FROM exacc_availimages_info_table;

--  change for exacc_cpstuner_patches_table
PROMPT Altering table exacc_cpstuner_patches_table
alter TABLE exacc_cpstuner_patches_table ADD (bugid_tmp varchar2(512));
update exacc_cpstuner_patches_table SET bugid_tmp = bug_id;
alter table exacc_cpstuner_patches_table drop column bug_id;
alter table exacc_cpstuner_patches_table rename column bugid_tmp to bug_id;
alter TABLE exacc_cpstuner_patches_table ADD (dwnld_tsp varchar2(512));
update exacc_cpstuner_patches_table SET dwnld_tsp = download_timestamp;
alter table exacc_cpstuner_patches_table drop column download_timestamp;
alter table exacc_cpstuner_patches_table rename column dwnld_tsp to download_timestamp;
alter TABLE exacc_cpstuner_patches_table ADD (exe_tsp varchar2(512));
update exacc_cpstuner_patches_table SET exe_tsp = execution_timestamp;
alter table exacc_cpstuner_patches_table drop column execution_timestamp;
alter table exacc_cpstuner_patches_table rename column exe_tsp to execution_timestamp;
alter TABLE exacc_cpstuner_patches_table ADD (updt_tsp varchar2(512));
update exacc_cpstuner_patches_table SET updt_tsp = updated_timestamp;
alter table exacc_cpstuner_patches_table drop column updated_timestamp;
alter table exacc_cpstuner_patches_table rename column updt_tsp to updated_timestamp;
CREATE OR REPLACE EDITIONING VIEW exacc_cpstuner_patches AS
SELECT * FROM exacc_cpstuner_patches_table;

--  change for exacc_sw_versions_table
PROMPT Altering table exacc_sw_versions_table
alter TABLE exacc_sw_versions_table ADD (updt_tsp varchar2(512));
update exacc_sw_versions_table SET updt_tsp = updated_timestamp;
alter table exacc_sw_versions_table drop column updated_timestamp;
alter table exacc_sw_versions_table rename column updt_tsp to updated_timestamp;
CREATE OR REPLACE EDITIONING VIEW exacc_sw_versions AS
SELECT * FROM exacc_sw_versions_table;

--  change for exacc_nodemisc_info_table
PROMPT Altering table exacc_nodemisc_info_table
alter TABLE exacc_nodemisc_info_table ADD (updt_tsp varchar2(512));
update exacc_nodemisc_info_table SET updt_tsp = updated_timestamp;
alter table exacc_nodemisc_info_table drop column updated_timestamp;
alter table exacc_nodemisc_info_table rename column updt_tsp to updated_timestamp;
CREATE OR REPLACE EDITIONING VIEW exacc_nodemisc_info AS
SELECT * FROM exacc_nodemisc_info_table;

--  change for exacc_nodeimg_versions_table
PROMPT Altering table exacc_nodeimg_versions_table
alter TABLE exacc_nodeimg_versions_table ADD (img_actdate varchar2(512));
update exacc_nodeimg_versions_table SET img_actdate = image_activation_date;
alter table exacc_nodeimg_versions_table drop column image_activation_date;
alter table exacc_nodeimg_versions_table rename column img_actdate to image_activation_date;
alter TABLE exacc_nodeimg_versions_table ADD (updt_tsp varchar2(512));
update exacc_nodeimg_versions_table SET updt_tsp = updated_timestamp;
alter table exacc_nodeimg_versions_table drop column updated_timestamp;
alter table exacc_nodeimg_versions_table rename column updt_tsp to updated_timestamp;
CREATE OR REPLACE EDITIONING VIEW exacc_nodeimg_versions AS
SELECT * FROM exacc_nodeimg_versions_table;

--  change for exacc_exaksplice_info_table
PROMPT Altering table exacc_exaksplice_info_table
alter TABLE exacc_exaksplice_info_table ADD (exspk_update varchar2(512));
update exacc_exaksplice_info_table SET exspk_update = exspl_updt_activated_date;
alter table exacc_exaksplice_info_table drop column exspl_updt_activated_date;
alter table exacc_exaksplice_info_table rename column exspk_update to exspl_updt_activated_date;
alter TABLE exacc_exaksplice_info_table ADD (updt_tsp varchar2(512));
update exacc_exaksplice_info_table SET updt_tsp = updated_timestamp;
alter table exacc_exaksplice_info_table drop column updated_timestamp;
alter table exacc_exaksplice_info_table rename column updt_tsp to updated_timestamp;
CREATE OR REPLACE EDITIONING VIEW exacc_exaksplice_info AS
SELECT * FROM exacc_exaksplice_info_table;


--  change for exacc_exception_racks_table
PROMPT Altering table exacc_exception_racks_table
alter TABLE exacc_exception_racks_table ADD (cps_tmp varchar2(512));
update exacc_exception_racks_table SET cps_tmp = cps_push;
alter table exacc_exception_racks_table drop column cps_push;
alter table exacc_exception_racks_table rename column cps_tmp to cps_push;
alter TABLE exacc_exception_racks_table ADD (updt_tsp varchar2(512));
update exacc_exception_racks_table SET updt_tsp = updated_timestamp;
alter table exacc_exception_racks_table drop column updated_timestamp;
alter table exacc_exception_racks_table rename column updt_tsp to updated_timestamp;
alter table exacc_exception_racks_table rename column RACK_SERIAL_NUMBER to exa_ocid;
CREATE OR REPLACE EDITIONING VIEW exacc_exception_racks AS
SELECT * FROM exacc_exception_racks_table;

-- change for wf_server_table
PROMPT Altering table wf_server_table
alter table wf_server_table add (hostname varchar2(128));
ALTER TABLE WF_SERVER_TABLE ADD SUBNET_CIDR VARCHAR2(64);
CREATE OR REPLACE EDITIONING VIEW wf_server AS
SELECT 
    NAME,
    STATUS,
    LAST_HEARTBEAT_UPDATE,
    HOSTNAME,
    SUBNET_CIDR
FROM wf_server_table;

-- change for ecs_sla_records_table
PROMPT Altering table ecs_sla_records_table (adding tenancy and compartment info)
ALTER TABLE ecs_sla_records_table ADD (tenancy_ocid VARCHAR2(256));
ALTER TABLE ecs_sla_records_table ADD (compartment_ocid VARCHAR2(256));
ALTER TABLE ecs_sla_records_table ADD (cei_id VARCHAR2(256));
ALTER TABLE ecs_sla_records_table ADD (tenant_name VARCHAR2(256));
CREATE OR REPLACE EDITIONING VIEW ecs_sla_records AS
SELECT * FROM ecs_sla_records_table;

create index WF_TASK_STATE_MACHINE_IDX on WF_TASK_STATE_MACHINE_TABLE("WF_UUID") nologging parallel 4 online;

--change for ecs_cps_dyn_task_table
PROMPT Altering ecs_cps_dyn_task_table
alter table ecs_cps_dyn_task_table drop constraint pk_cps_dyn_task;
alter table ecs_cps_dyn_task_table add constraint pk_cps_dyn_task PRIMARY KEY (component_name, ecs_series, script_order);
CREATE OR REPLACE EDITIONING VIEW ecs_cps_dyn_task AS
SELECT * FROM ecs_cps_dyn_task_table;

-- Enh 36334590 - Adding column ecs_hw_elastic_nodes_table to save extra information of archive nodes
ALTER TABLE ECS_HW_ELASTIC_NODES_TABLE ADD EXTRA_ARCHIVE_INFO BLOB;
--Enh 37025371 - EXACC X11M Support for compute standard/large and extra large
ALTER TABLE ECS_HW_ELASTIC_NODES_TABLE ADD (model_subtype varchar2(64) DEFAULT ON NULL 'STANDARD' NOT NULL);

-- chnage for ecs_hw_elastic_nodes_table
alter table ecs_hw_elastic_nodes_table add rack_num number(3) DEFAULT 1;
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
    MODEL_SUBTYPE
FROM ecs_hw_elastic_nodes_table;

--- Bug 37482170 - Added alter tables fro ecs_oci_console_history_table
alter table ecs_oci_console_history_table rename column REQUESTOCID to request_ocid;
alter table ecs_oci_console_history_table rename column EXAUNITID to exaunit_id;
alter table ecs_oci_console_history_table rename column VMHOSTNAME to vm_hostname;
alter table ecs_oci_console_history_table rename column OSSOBJECT to oss_object;
alter table ecs_oci_console_history_table rename column SSHPUBKEY to ssh_pubkey;
alter table ecs_oci_console_history_table rename column SYMMETRICKEY to symmetric_key;
alter table ecs_oci_console_history_table rename column MD5CKSUM to md5_cksum;

PROMPT Recreating editioning views on table ecs_oci_console_history_table
CREATE OR REPLACE EDITIONING VIEW ecs_oci_console_history AS
SELECT  
    request_ocid,
    exaunit_id,
    vm_hostname,
    status,
    oss_object,
    details,
    ssh_pubkey,
    symmetric_key,
    md5_cksum
FROM ecs_oci_console_history_table;

-- change for ecs_oci_config_bundle_details
ALTER TABLE ecs_oci_config_bundle_details_table MODIFY cipher_salt VARCHAR2(64);
CREATE OR REPLACE EDITIONING VIEW ecs_oci_config_bundle_details AS
SELECT * FROM ecs_oci_config_bundle_details_table;

--seed table sql changes
--Enh 35909909 - Delete and reinsert catalog of CrossPlatform combinations
DELETE FROM ecs_elastic_platform_info;

INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X8M-2', 'X8M-2,X9M-2,X10M-2,X11M','18', '15', 'OVERLAY', 'ACTIVE', 'CROSS_PLATFORM', 'ALL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X9M-2', 'X9M-2,X10M-2,X11M', '14', '15', 'OVERLAY', 'ACTIVE', 'CROSS_PLATFORM', 'ALL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X10M-2', 'X10M-2,X11M', '14', '15', 'OVERLAY', 'ACTIVE', 'CROSS_PLATFORM', 'ALL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M', 'X11M','14', '15', 'OVERLAY', 'ACTIVE', 'CROSS_PLATFORM', 'ALL');

-- Enh 36922155 - EXACS X11M - Base system support
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X-Z', 'X8M-2,X9M-2,X10M-2,X11M+Z','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+BASE', 'X11M','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE', 'COMPUTE');

-- Enh 37025371 - EXACC X11M Support for compute standard/large and extra large
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M', 'X11M','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'COMPUTE');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-L', 'X11M+ELASTIC_LARGE','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'COMPUTE');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-XL', 'X11M+ELASTIC_EXTRALARGE','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'COMPUTE');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-BASE', 'X11M+Z','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'COMPUTE');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M', 'X11M','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-BASE', 'X11M+Z','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-EF', 'X11M+EF','-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'CELL');

-- Enh 37154198 - Adding records to re-map the model subtypes sent by CP to match them with the ones used by ECRA 
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-HC', 'X11M+STANDARD', 'X11MHCXRMEM', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X-HC-Z', 'X11M+X-Z', 'X-Z', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-EF', 'X11M+EF', 'X11MEF', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M', 'X11M+STANDARD','-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'COMPUTE');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-XL', 'X11M+EXTRALARGE','-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'COMPUTE');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-L', 'X11M+LARGE','-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'COMPUTE');

INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X8M-2+STANDARD', 'X8M-2+STANDARD', 'X8MHC', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X9M-2+STANDARD', 'X9M-2+STANDARD', 'X9MHC', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X10M-2+STANDARD', 'X10M-2+STANDARD', 'X10MHC', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X8M-2+BASE', 'X8M-2+BASE', 'X8MHC', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X9M-2+BASE', 'X9M-2+BASE', 'X8MHC', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X10M-2+BASE', 'X10M-2+BASE', 'X8MHC', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+BASE', 'X11M+BASE', 'X8MHC', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING','CELL');

-- Enh 37176101 - EXACS X11M - Validate zrcv flow for x-z models to only pick x11m-z models
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, oeda_codename, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+ZDLRAOEDA', 'X11M+ZDLRA','X11MZHCZDLRA', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+ZRCV', 'X11M+STANDARD', '-1', '-1', 'OVERLAY', 'ACTIVE', 'SUBTYPE_MAPPING', 'CELL');

-- Enh 37102594 - EXACS X11M - Update base system regular flow to take X11M-X(base) cells on algorithm
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M', 'X11M+STANDARD','-1', '-1', 'OVERLAY', 'ACTIVE', 'BASE_SYSTEM', 'CELL');

-- Enh 37155618 - EXACC X11M - Implement new oeda types for compute/cell ecra -> oxpa
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-HC', 'X11M+X11M','-1', '-1', 'OVERLAY', 'ACTIVE', 'OXPA_MAPPING', 'CELL');
INSERT INTO ecs_elastic_platform_info (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-BASE', 'X11M+X11M-BASE','-1', '-1', 'OVERLAY', 'ACTIVE', 'OXPA_MAPPING', 'CELL');

INSERT INTO ecs_properties (name, type, value) VALUES ('SERVICE_TYPE', 'PATCHING', 'EXACS,FA,ADBD,ADBS,EXACC,PREPROD,GBU,IDCS,OMCS,TEST');
INSERT INTO ecs_properties (name, type, value) VALUES ('CHOOSE_NONBONDED_X6',  'BONDING', 'ENABLED');

INSERT INTO ecs_properties (name, type, value) VALUES ('BONDING_WORKFLOW_MODE',  'BONDING', 'ENABLED');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, job_category, metadata)
    VALUES ('NEW', 'oracle.exadata.ecra.preprovision.jobs.SetupOracleNetworkJob', 'PREPROV', 
'{
    "vcn" : {
        "cidr" : "10.0.0.0/16",
        "label" : "preprovvcn"
    },
    "subnets" : [
        {
            "type" : "client",
            "cidr" : "10.0.0.0/18"
        },
        {
            "type" : "backup",
            "cidr" : "10.0.64.0/18"
        }
    ],
    "securityRules" : {
        "ingress" : [
            {
                "protocol" : "TCP",
                "stateless" : false,
                "destinationMinPort" : -1,
                "destinationMaxPort" : -1,
                "sourceMinPort" : -1,
                "sourceMaxPort" : -1,
                "allOpen" : true
            },
            {
                "protocol" : "ICMP",
                "stateless" : false,
                "icmpCode" : -1,
                "icmpType" : -1,
                "allOpen" : true
            }
        ],
        "egress"  : [
            {
                "destination" : "0.0.0.0/0",
                "protocol" : "ALL",
                "stateless" : false,
                "destinationMinPort" : -1,
                "destinationMaxPort" : -1,
                "sourceMinPort" : -1,
                "sourceMaxPort" : -1,
                "allOpen" : true
            }
        ]
    },
    "timeout": 86400
}');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, job_category, metadata)
    VALUES ('READY', 'oracle.exadata.ecra.preprovision.jobs.GenerateInfrastructureJob', 'PREPROV',
'{
    "configurations": [
        {
            "model": "X8M-2",
            "namePrefix": "",
            "infrastructureType": "MVM",
            "quantity": 1,
            "size": {
                "computes": 2,
                "cells": 3
            },
            "clusters": [
                {
                    "type": "EXACS",
                    "quantity": 1,
                    "grid": "v19"
                }
            ]
        },
        {
            "model": "X9M-2",
            "infrastructureType": "MVM",
            "quantity": 1,
            "size": {
                "computes": 2,
                "cells": 3
            },
            "clusters": [
                {
                    "type": "EXACS",
                    "quantity": 3,
                    "grid": "v19"
                }
            ]
        }
    ],
    "timeout": 86400
}');
UPDATE ecs_atpjobsmetadata
set job_class = 'oracle.exadata.ecra.preprovision.jobs.GenerateInfrastructureJob',
metadata = '{
    "configurations": [
        {
            "model": "X8M-2",
            "namePrefix": "",
            "infrastructureType": "MVM",
            "quantity": 1,
            "size": {
                "computes": 2,
                "cells": 3
            },
            "clusters": [
                {
                    "type": "EXACS",
                    "quantity": 1,
                    "grid": "v19"
                }
            ]
        },
        {
            "model": "X9M-2",
            "infrastructureType": "MVM",
            "quantity": 1,
            "size": {
                "computes": 2,
                "cells": 3
            },
            "clusters": [
                {
                    "type": "EXACS",
                    "quantity": 3,
                    "grid": "v19"
                }
            ]
        }
    ],
    "timeout": 86400
}'
where job_class = 'oracle.exadata.ecra.preprovision.jobs.ProduceInfrastructureJob';


INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, job_category, metadata)
    VALUES ('RESERVED', 'oracle.exadata.ecra.preprovision.jobs.ConfigureDbNodesJob', 'PREPROV', 
'{
    "scan" : {
        "port" : 1521
    },
    "network_services": {
        "dns": [
            "169.254.169.254"
        ],
        "ntp": [
            "169.254.169.254"
        ]
    },
    "vlanRange":{
        "low" : 500,
        "high": 800
    },
    "postfixes" : {
        "activeVnic" : "-v-ac",
        "standbyVnic": "-v-sb",
        "activeComputeInstance" : "-c-ac",
        "standbyComputeInstance": "-c-sb",
        "scan" : "-scan",
        "vip" : "-vip"
    },
    "timeout": 86400
}');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, job_category, metadata)
    VALUES ('PREPROV_PREPARED', 'oracle.exadata.ecra.preprovision.jobs.LaunchVMClusterJob', 'PREPROV', 
'{
    "timeout": 86400
}');

-- Insert ExaCompute Patching Related Configuration Parameters
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_NUMBER_OF_NODES_TO_PATCH_PER_REQUEST', 'EXACOMPUTE', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_PATCH_OPERATION_POLLING_INTERVAL_IN_SECONDS', 'EXACOMPUTE', '300');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_MAX_CONCURRENT_PATCH_REQUESTS', 'EXACOMPUTE', '5');


-- Domu Patching Rollback and PreCheck errors which will be treated as PAGE_ONCALL. Will be empty string initially
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_PATCH_ROLLBACK_PRECHECK_PAGEONCALL_ERRORS', 'PATCHING', '');

-- Bug 35567246 - Adding property to handle 2TB memory in X9M-2 (aka X9M-2L)
INSERT INTO ecs_properties (name, type, value) VALUES ('LARGE_FOR_X9M','KVMROCE','ENABLED');


INSERT INTO ecs_properties (name, type, value) VALUES ('VM_CONCURRENT_BACKUP','FEATURE','15');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_INTERVAL_BACKUP','FEATURE','120');

-- Enh 35543208 - Add vm backup status tracker job
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.VMBackupStatusTrackerJob', 'Y', 1800, 'Init', 'RECURRENT', 'ANY');

-- dataplane key rotation schduler
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_ECRA_DATAPLANE_ROTATION_PERIOD', 'INT', '60');
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type) VALUES ('oracle.exadata.ecra.scheduler.DataPlaneKeyRotationJob', 'Y', 5184000, 'Init', 'RECURRENT');

-- Enh 34808479 - REDUCE DB QUERY BY CACHING CONSTANT VALUES
INSERT INTO ecs_scheduledjob(job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.PropertyCacheJob', 'Y', 86400, 'Init', 'RECURRENT', 'ANY');

-- Enh 35804535 - Enable InfraPatchingCleanupJob to cleanup logs generated by single node cluster patching
INSERT INTO ecs_scheduledjob(job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.InfraPatchingCleanupJob', 'Y', 86400, 'Init', 'RECURRENT', 'STANDBY');

--Bug 37249099 - FEDRAMP ENHANCEMENT: ECRA TO HAVE MECHANISM TO ROTATE ITS LISTENER CERTIFICATE
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_SSV2_CERT_PATH', 'ECRA', ''); 

INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_SCALE_SANITYCHECK_DOMUVERSION',  'EXACOMPUTE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_TEST_ENVIRONMENT',  'EXACOMPUTE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_TEST_CELLS',  'EXACOMPUTE', 'iad103712exdcl01,iad103712exdcl02,iad103712exdcl03');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXASCALE_STORAGE_VLAN',  'EXACOMPUTE', '3999');

INSERT INTO exaie_events_switches (event_name, event_switch) VALUES ('exaie_no_db_activity_event',      'OFF');
UPDATE ecs_properties SET value='CLIENT' WHERE name='CERT_ROTATION_LIST';
-- Enh 35132786 - vm backup support for dom0 sending
UPDATE ecs_properties SET value='15' WHERE name='VM_CONCURRENT_BACKUP';
UPDATE ecs_properties SET value='120' WHERE name='VM_INTERVAL_BACKUP';


PROMPT UPDATING VMBACKUP JOB FOR WEEKLY UPDATES
update ECS_SCHEDULEDJOB set INTERVAL=604800 where JOB_CLASS = 'oracle.exadata.ecra.scheduler.VMBackupJob';
UPDATE ECS_SCHEDULEDJOB 
SET LAST_UPDATE = trunc(sysdate, 'IW') - INTERVAL  '1' DAY + INTERVAL '1' HOUR 
WHERE JOB_CLASS = 'oracle.exadata.ecra.scheduler.VMBackupJob';


-- Update Service type catalog to have EXACOMPUTE also
UPDATE ecs_properties SET value='EXACS,FA,ADBD,ADBS,EXACC,PREPROD,GBU,IDCS,OMCS,TEST,EXACOMPUTE' WHERE name='SERVICE_TYPE' and type='PATCHING';

UPDATE ecs_properties SET value='2.0.0' WHERE name='MAX_DELTA_FOR_RELAXED_VERSION';


-- Infrastructure Dataplane Events (ExaIE) Settings
UPDATE exaie_events_switches SET event_switch='OFF' WHERE event_name='exaie_no_db_activity_event';

INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_REHOME_BUCKET_NAME', 'OCI_REHOME', 'exacc_oci_rehome');

-- Enh 35697655 Adding all the required inserts for ecs_gold_specs
DELETE FROM ecs_gold_specs where exaunit_id=-1;

-- EXACS
-- ib
-- filesystem
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/dev','355G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/run','355G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/sys/fs/cgroup','355G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/acfs01','1.1T','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/','50G','','','','','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/u01','150G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/u02','900G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/u02','199G','','','','','','','false','X6-2');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/u02','1.1T','','','','','','','false','X7-2');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/u02','900G','','','','','','','false','base');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','/boot','488M','','','','','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','filesystem','$GRID_HOME','50G','','','','','','','false','all');
-- commands
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','srvctl_ORA_NET_DEEP_CHECK','ORA_NET_DEEP_CHECK=10','','$GRID_HOME/bin/srvctl','getenv nodeapps -envs ORA_NET_DEEP_CHECK -viponly','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','srvctl_ORA_NET_PING_RETRIES','ORA_NET_PING_RETRIES=8','','$GRID_HOME/bin/srvctl','getenv nodeapps -envs ORA_NET_PING_RETRIES -viponly','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','srvctl_ORA_NET_PING_TIMEOUT','ORA_NET_PING_TIMEOUT=300','','$GRID_HOME/bin/srvctl','getenv nodeapps -envs ORA_NET_PING_TIMEOUT -viponly','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','cat_bondeth0','<REPLACE_0>','','/bin/cat','/sys/class/net/bondeth0/mtu','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','cat_bondeth1','<REPLACE_0>','','/bin/cat','/sys/class/net/bondeth1/mtu','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','cell','-1','ib','command','cells_iormplan_detail','auto','','cellcli','-e list iormplan detail | grep objective','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','ib','command','imageinfo_version','INFO','','/usr/local/bin/imageinfo','| /bin/grep version','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','ib','command','sestatus_selinux_dom0','INFO','','/usr/sbin/sestatus','| /bin/grep status','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','sestatus_selinux_domu','INFO','','/usr/sbin/sestatus','| /bin/grep status','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','ib','command','fips_enabled','INFO','','/bin/cat','/proc/sys/crypto/fips_enabled','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','ib','command','utils_version','INFO','','/bin/rpm','-qa | /bin/grep -i ovmutils','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','voting_disks','5 voting disk.*','','$GRID_HOME/bin/crsctl','query css votedisk | grep ''5 voting disk(s).''','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','verify_bucket','access-control-allow-methods: POST,PUT,GET,HEAD,DELETE,OPTIONS','','/bin/cat','/var/opt/oracle/cprops/cprops.ini | /bin/grep common_oss_url | /bin/cut -d "=" -f2 | /bin/xargs /usr/bin/curl -k -Is -m 10 | /bin/grep access-control-allow-methods:','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','verify_nslookup','Yes','','/bin/su grid -c ''$GRID_HOME/bin/srvctl config scan''','| /bin/grep "SCAN name:" | /bin/cut -d " " -f3 | /bin/cut -d "," -f1 | /bin/xargs nslookup | /bin/grep Name: | /bin/wc -l | /bin/xargs -n 1 -I actual /bin/test actual -gt 0 -a 3 -ge actual && /bin/echo "Yes" || /bin/echo "No"','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','verify_disk_recoc','<REPLACE_0>','','/bin/su grid -c ''$GRID_HOME/bin/asmcmd lsdg''','|  /bin/xargs -n 1 | /bin/grep RECOC','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','ib','command','verify_disk_datac','<REPLACE_0>','','/bin/su grid -c ''$GRID_HOME/bin/asmcmd lsdg''','|  /bin/xargs -n 1 | /bin/grep DATAC','0','','','true','all');

-- kvm
-- filesystem
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/dev','684G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/run','684G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/sys/fs/cgroup','684G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/acfs01','1.1T','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/','15G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/u01','250G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/u02','900G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/u02','900G','','','','','','','false','base','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/boot','509M','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','$GRID_HOME','50G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/tmp','10G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/var','10G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/var/log','30G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/home','4G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/var/log/audit','10G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','swap','16G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacs','domU','-1','kvm','filesystem','reserved','2.5G','','','','','','','true','all','false');

-- commands
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','srvctl_ORA_NET_DEEP_CHECK','ORA_NET_DEEP_CHECK=10','','$GRID_HOME/bin/srvctl','getenv nodeapps -envs ORA_NET_DEEP_CHECK -viponly','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','srvctl_ORA_NET_PING_RETRIES','ORA_NET_PING_RETRIES=8','','$GRID_HOME/bin/srvctl','getenv nodeapps -envs ORA_NET_PING_RETRIES -viponly','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','srvctl_ORA_NET_PING_TIMEOUT','ORA_NET_PING_TIMEOUT=300','','$GRID_HOME/bin/srvctl','getenv nodeapps -envs ORA_NET_PING_TIMEOUT -viponly','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','cat_bondeth0','<REPLACE_0>','','/bin/cat','/sys/class/net/bondeth0/mtu','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','cat_bondeth1','<REPLACE_0>','','/bin/cat','/sys/class/net/bondeth1/mtu','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','cell','-1','kvm','command','cells_iormplan_detail','auto','','cellcli','-e list iormplan detail | grep objective','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','kvm','command','imageinfo_version','INFO','','/usr/local/bin/imageinfo','| /bin/grep version','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','kvm','command','sestatus_selinux_dom0','INFO','','/usr/sbin/sestatus','| /bin/grep status','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','sestatus_selinux_domu','INFO','','/usr/sbin/sestatus','| /bin/grep status','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','kvm','command','fips_enabled','INFO','','/bin/cat','/proc/sys/crypto/fips_enabled','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','dom0','-1','kvm','command','utils_version','INFO','','/bin/rpm','-qa | /bin/grep -i kvmutils','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','voting_disks','5 voting disk.*','','$GRID_HOME/bin/crsctl','query css votedisk | grep ''5 voting disk(s).''','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','verify_bucket','access-control-allow-methods: POST,PUT,GET,HEAD,DELETE,OPTIONS','','/bin/cat','/var/opt/oracle/cprops/cprops.ini | /bin/grep common_oss_url | /bin/cut -d "=" -f2 | /bin/xargs /usr/bin/curl -k -Is -m 10 | /bin/grep access-control-allow-methods:','0','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','verify_nslookup','Yes','','/bin/su grid -c ''$GRID_HOME/bin/srvctl config scan''','| /bin/grep "SCAN name:" | /bin/cut -d " " -f3 | /bin/cut -d "," -f1 | /bin/xargs nslookup | /bin/grep Name: | /bin/wc -l | /bin/xargs -n 1 -I actual /bin/test actual -gt 0 -a 3 -ge actual && /bin/echo "Yes" || /bin/echo "No"','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','verify_disk_recoc','<REPLACE_0>','','/bin/su grid -c ''$GRID_HOME/bin/asmcmd lsdg''','|  /bin/xargs -n 1 | /bin/grep RECOC','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacs','domU','-1','kvm','command','verify_disk_datac','<REPLACE_0>','','/bin/su grid -c ''$GRID_HOME/bin/asmcmd lsdg''','|  /bin/xargs -n 1 | /bin/grep DATAC','0','','','true','all');

-- ADBD
--ib
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbd','domU','-1','ib','filesystem','/u02','900G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbd','domU','-1','ib','filesystem','/u02','199G','','','','','','','false','X6-2');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbd','domU','-1','ib','filesystem','/u02','1.1T','','','','','','','false','X7-2');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbd','domU','-1','ib','command','cat_bondeth1','<REPLACE_0>','','/usr/sbin/ip','netns exec mgmt cat /sys/class/net/bondeth1/mtu','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbd','domU','-1','ib','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbd','domU','-1','ib','filesystem','/u01','150G','','','','','','','true','all','true');
--kvm
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbd','domU','-1','kvm','filesystem','/u02','900G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbd','domU','-1','kvm','command','cat_bondeth1','<REPLACE_0>','','/usr/sbin/ip','netns exec mgmt cat /sys/class/net/bondeth1/mtu','0','','','true','all');


-- ADBS
--ib
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbs','cell','-1','ib','command','cells_griddisk_cachingPolicy','12','','cellcli','-e list griddisk attributes name,cachingPolicy | grep RECO | grep default | wc -l','0','','','true','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbs','domU','-1','ib','filesystem','/u02','199G','','','','','','','false','X6-2');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbs','domU','-1','ib','filesystem','/u02','1.1T','','','','','','','false','X7-2');
--kvm
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'adbs','cell','-1','kvm','command','cells_griddisk_cachingPolicy','12','','cellcli','-e list griddisk attributes name,cachingPolicy | grep RECO | grep default | wc -l','0','','','true','all');
INSERT INTO ecs_properties (name, type, value) VALUES ('VALID_RACKEXCEPTIONS', 'EXACC_INVENTORY', '["Backup_network_non-routable","Shared_client_and_backup_network","RE-RACKING","REDUCED_WHIPS","4x3m_Power_Cords","Change_backup_network","Filesystem_resize","DISABLE_CPU_COUNT_CHECK","Power_plug","1GbE","LR_TRANSCEIVERS","Patch panel or switch"]');

-- kvm mvm
-- filesystem
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','/u01','250G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','/tmp','10G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','/var','10G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','/var/log','30G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','swap','16G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','kvm','filesystem','reserved','9.5G','','','','','','','true','all','false');
--ib mvm
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','ib','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvm','domU','-1','ib','filesystem','/u01','150G','','','','','','','true','all','true');

--kvm svm minimum spec
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','$GRID_HOME','50G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/','15G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/acfs01','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/dev','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/home','4G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/run','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/sys/fs/cgroup','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/tmp','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/u02','60G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/var','5G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','swap','16G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','reserved','9G','','','','','','','true','all','false');


--kvm mvm minimum spec
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','$GRID_HOME','50G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/','15G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/acfs01','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/dev','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/home','4G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/run','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/sys/fs/cgroup','0G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/tmp','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/u02','60G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/var','5G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','swap','16G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacsmvmminspec','domU','-1','kvm','filesystem','reserved','9G','','','','','','','true','all','false');

-- adbd mvm
-- filesystem
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','/tmp','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','/var','5G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','swap','16G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','kvm','filesystem','reserved','9G','','','','','','','true','all','false');

-- ib adbdmvm
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','ib','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'adbdmvm','domU','-1','ib','filesystem','/u01','150G','','','','','','','true','all','true');

-- FA
-- ib
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'fa','domU','-1','ib','filesystem','/','50G','','','','','','','false','all');
-- kvm
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'fa','domU','-1','kvm','filesystem','/','50G','','','','','','','false','all');

-- EXACOMPUTE
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/gcv','2G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/u01','40G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/u02','60G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','$GRID_HOME','11G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/var','5G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','/tmp','10G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute','domU','-1','kvm','filesystem','system','114G','','','','','','','false','all');

-- EXACOMPUTE 19c
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute19c','domU','-1','kvm','filesystem','/u01','80G','','','','','','','false','all');

-- EXACOMPUTE BASEDB
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/opt','35G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','/var','10G','','','','','','','false','all');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacomputebasedb','domU','-1','kvm','filesystem','system','114G','','','','','','','false','all');

--EXACC SVM

INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/','15G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/var','5G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/tmp','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/home','4G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','/acfs01','560G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','$GRID_HOME','50G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','swap','16G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','kvm','filesystem','reserved','9G','','','','','','','false','all','false');

-- EXACC IB
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','ib','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','ib','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','ib','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','ib','filesystem','swap','12G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exacc','domU','-1','ib','filesystem','reserved','1G','','','','','','','false','all','false');

--EXACC ADBD
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/','15G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/var','5G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/tmp','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/home','4G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','/acfs01','560G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','$GRID_HOME','50G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','swap','16G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','kvm','filesystem','reserved','9G','','','','','','','false','all','false');

-- EXACC ADBD IB
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','ib','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','ib','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','ib','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','ib','filesystem','swap','12G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbd','domU','-1','ib','filesystem','reserved','1G','','','','','','','false','all','false');


--EXACC MVM
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/','15G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/var','5G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/tmp','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/home','4G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','/acfs01','560G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','$GRID_HOME','50G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','swap','16G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','kvm','filesystem','reserved','9G','','','','','','','false','all','false');

-- EXACC MVM IB
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','ib','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','ib','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','ib','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','ib','filesystem','swap','12G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccmvm','domU','-1','ib','filesystem','reserved','1G','','','','','','','false','all','false');

--EXACC ADBD MVM
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/','15G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/var','5G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/tmp','3G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/home','4G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/var/log','18G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/crashfiles','20G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','/acfs01','560G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','$GRID_HOME','50G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','swap','16G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','kvm','filesystem','reserved','9G','','','','','','','false','all','false');


-- EXACC ADBD MVM IB
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','ib','filesystem','/','50G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','ib','filesystem','/u01','20G','','','','','','','true','all','true');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','ib','filesystem','/boot','1G','','','','','','','true','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','ib','filesystem','swap','12G','','','','','','','false','all','false');
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model,mutable)
VALUES (-1,'exaccadbdmvm','domU','-1','ib','filesystem','reserved','1G','','','','','','','false','all','false');



-- Instance Principals
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_INSTANCE_PRINCIPALS', 'FEATURE', 'DISABLED');

--asynvc api version
INSERT INTO ecs_properties (name, type, value) VALUES ('ASYNC-API-VERSION', 'ECRA', 'v2');
COMMIT;

INSERT INTO ecs_properties (name, type, value) VALUES ('MODIFIED_PROPERTIES_FAIL_UPGRADE', 'ECRA', 'ENABLED');
--network reconfigure properties.
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE', 'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE_NW_TYPES', 'EXACC_NETWORK', 'backup');
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE_NW_OPERATIONS', 'EXACC_NETWORK', 'cidr_update,vlan_update');
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE_NW_SERVICES', 'EXACC_NETWORK', NULL);

UPDATE ecs_properties SET value='ENABLED' WHERE name='BASESYSTEM_USE_BONDING_INPUT';

-- Enh-34009623
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_DATAPLANE_BUCKET_NAME', 'ECRA', 'bucket_dataplane_log_upload'); 

-- Bug 34458050: Add support for V1 api along with V2 api for CPS SW upgrade
INSERT INTO ecs_properties (name, type, value) VALUES ('CPSSW_UPGRADE_VERSION', 'EXACLOUD', 'V2');

-- Bug 35069021: Add support for V1 api along with V2 api for CPS OS upgrade
INSERT INTO ecs_properties (name, type, value) VALUES ('CPSOS_UPGRADE_VERSION', 'EXACLOUD', 'V2');

-- Bug 35677516: Increase timeout for ongoing operations
INSERT INTO ecs_properties (name, type, value) VALUES ('SWITCHOVER_MAX_WAIT_INTERVAL', 'ECRA', '80');

--Bug 34712586: Support DRCC-Include realm domains as a part of ocpsSetup json
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_INSTANCE_IAASINFO_URL', 'EXACLOUD', 'http://169.254.169.254/opc/v2/iaasInfo'); 


-- Enh 34394111 - Adding admin and user values for user management ecra ng
INSERT INTO ecs_users_roles (id, role) VALUES (1, 'ADMINISTRATOR');
INSERT INTO ecs_users_roles (id, role) VALUES (2, 'APPLICATION_USER');

-- Enh 34394111 - Adding default admin user
INSERT INTO ecs_users (id, user_id, first_name, last_name, password, active, role_id) VALUES (1, 'admin', 'admin', 'admin', 'afda4f4abe00a4a62227776052fffe7a73f7b6f771ecbc14820930cfbd007b73', 1, '1,2');

INSERT INTO ecs_properties (name, type, value) VALUES ('RUNNER_TIMEOUT', 'ECRA', '10');

-- Enh 34792757 - Serial Console feature properties
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_HISTORY_CONSOLES_CC', 'ECRA', '10000');
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_HISTORY_CONSOLES', 'ECRA', '100');
INSERT INTO ecs_properties (name, type, value) VALUES ('CONSOLE_HISTORY_OSS_NAMESPACE', 'ECRA', 'FILLED_BY_ECRA');
INSERT INTO ecs_properties (name, type, value) VALUES ('CONSOLE_HISTORY_OSS_BUCKETNAME', 'ECRA', 'vm_history_console');



-- Bug 35414915 - json logging
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_LOG_FORMAT', 'ECRA', 'json');

INSERT INTO ecs_properties (name, type, value) VALUES ('TLS_CA_BUNDLE_PATH', 'VMCONSOLE', '');

--Enh 35064034
--Enh 35388181  
UPDATE ecs_properties SET value = '2,3,5,6,7,11,12' WHERE name = 'ONSR_REALMS';

INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_FS_MOUNTPOINT_SIZE', 'ECRA', '900');

INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_ACTIVE_ACTIVE_SPLIT_MODE', 'FEATURE', 'DISABLED');
-- Enh 35602217 - CREATE PROPERTY GENERAL AND PER TENANT FOR DOMU OS VERSION
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_IMAGE_OVERRIDE_FOR_GI23', 'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_BODY_DETAILS_PARSE', 'FEATURE', 'ENABLED');

PROMPT Inserting new properties for DOMU FINAL OVERRIDE ON PROVISIONING
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_VERSION_OVERRIDE_EXACS', 'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, TYPE, value) VALUES ('DOMU_VERSION_OVERRIDE_ATP', 'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_FINAL_VERSION_OVERRIDING_ATP', 'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_FINAL_VERSION_OVERRIDING_EXACS', 'FEATURE', '');

PROMPT Removing old DOMU override properties
DELETE FROM ecs_properties where name = 'DOMU_OS_VERSION_OVERRIDE';
DELETE FROM ecs_properties where name = 'DOMU_OS_VERSION_OVERRIDING_EXACS';

--Enh 34764008 - Will be initialized by LogSearchUrlGenerator.java at runtime
INSERT INTO ecs_properties (name, type, value) VALUES ('LUMBERJACK_INFO', 'DIAG', 'N/A');

-- Bug 34538859 - Adding Metric types for exacc sla
INSERT INTO ecs_metric_type(metric_type_id, name, description, sla_impact) VALUES ('2', 'Exadata.Cell.Uptime', 'Cell uptime', 'TRUE');
INSERT INTO ecs_metric_type(metric_type_id, name, description, sla_impact) VALUES ('3', 'Exadata.Dom0.Uptime', 'Dom0 uptime', 'TRUE');
INSERT INTO ecs_metric_type(metric_type_id, name, description, sla_impact) VALUES ('4', 'Exadata.Cell.Status', 'Cell Status', 'TRUE');

INSERT INTO ecs_properties (name, type, value) VALUES ('STATE_STORE_TIMEOUT', 'ECRA', '300000');

INSERT INTO ecs_properties(name, type, value) VALUES ('OCI_EXACC_ECRA_SLA_FREQUENCY_MINS', 'INT', '60');
INSERT INTO ecs_scheduledjob(job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.ECRASlaSloMetricJob', 'Y', '3600', 'Init', 'RECURRENT', 'STANDBY');
INSERT INTO ecs_properties(name, type, value) VALUES ('OCI_EXACC_EXAMON_TENANT_OCID', 'EXACC', null);

-- Bug 35649220 - USER PASSWORD IN ECRA-NG NEEDS TO BE SALTED, IT IS HASHED USING SHA-256
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_NG_SALT', 'ECRA', '');

-- Bug 35743292 - Adding ecra property for oci auth path
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_R1_AUTH_URL_COMPLEMENT', 'PREPROV', 'DISABLED');

-- Bug 15969374 - use the same trust store for auth provider methods
INSERT INTO ecs_properties (name, type, value) VALUES ('R1_OCI_TRUSTSTORE_PATH', 'PREPROV', '/home/oracle/.oci/trustv2.jks');


-- Bug 35698870 - Toggle vmboss su config with ecra property, INSTANCE_PRINCIPALS AND USER_PRINCIPALS
INSERT INTO ecs_properties (name, type, value) VALUES ('VMBOSS_AUTH_TYPE', 'FEATURE', 'INSTANCE_PRINCIPALS');

-- Bug 35197827 - Use OCI instance metadata v2
UPDATE ecs_properties SET value = 'http://169.254.169.254/opc/v2/instance/' WHERE name = 'OCI_INSTANCE_METADATA_URL';

-- Bug 36080194 - Active active Phase 2A , enable autoretry
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_TASK_FAILURE_AUTORETRY',  'FEATURE', 'ENABLED');

-- OCI Preprovisioning
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACS_PREPROV', 'PREPROVISION', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_SCHEDULER_INTERVAL_SECONDS', 'PREPROVISION', '600');
INSERT INTO ecs_properties (name, type, value) VALUES ('DELETE_PREPROV_RESOURCES_ON_DS', 'PREPROVISON', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_JOBS_TARGET_SERVER', 'PREPROVISION', 'PRIMARY');
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_PARALLEL', 'PREPROVISION','DISABLED');

-- BUG 36096298 - Adding property for VM Deconfigure for preprov
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_DECONFIG_WORKFLOW', 'PREPROV', 'create-service-wfd');

-- AutoUndoRetry WF Retry Rules
-- AutoUndoRetry Rule for Provisioning
INSERT INTO ecs_wf_auto_retry_action_rule_table (wfname, taskname, errorcode, action) VALUES ('create-service-wfd', 'all', 'all', 'AutoUndoAndRetry');
-- AutoUndoRetry Rule for Reshape Workflow
INSERT INTO ecs_wf_auto_retry_action_rule_table (wfname, taskname, errorcode, action) VALUES ('reshape-service-wfd', 'all', 'all', 'AutoUndoAndRetry'); 
-- AutoUndoRetry Rule for VM Move
INSERT INTO ecs_wf_auto_retry_action_rule_table (wfname, taskname, errorcode, action) VALUES ('vm-move-wfd', 'all', 'all', 'AutoUndoAndRetry');
-- AutoUndoRetry Rule for Delete Service
INSERT INTO ecs_wf_auto_retry_action_rule_table (wfname, taskname, errorcode, action) VALUES ('delete-service-wfd', 'all', 'all', 'AutoUndoAndRetry');
-- AutoUndoRetry Rule for Vault Access Creation 
INSERT INTO ecs_wf_auto_retry_action_rule_table (wfname, taskname, errorcode, action) VALUES ('exacompute-vaultaccessupdate-wfd', 'all', 'all', 'AutoUndoAndRetry');


--- Bug 34546732 ExaCC diagnostic log scanner to run in parallel
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACD_ECLOGSCANNER_RETRY_COUNT', 'EXACC', '2');

-- Bug 35677356 - Custom GI support
INSERT INTO ecs_properties (name, type, value) VALUES ('CUSTOM_GI','FEATURE', 'DISABLED');

-- Bug 35792183 - Model Subtype Limits for X10M-2 and X9M-2
INSERT INTO ecs_properties_table (name, type, value) VALUES ('LIMIT_PER_CABINET_EXTRALARGE_X10M', 'ELASTIC', '5');
INSERT INTO ecs_properties_table (name, type, value) VALUES ('LIMIT_PER_CABINET_LARGE_X10M', 'ELASTIC', '-1');
INSERT INTO ecs_properties_table (name, type, value) VALUES ('LIMIT_PER_CABINET_LARGE_X9M', 'ELASTIC', '5');

-- Enh 36908403 - Model Subtype Limits for X11M
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('LIMIT_PER_CABINET_EXTRALARGE_X11M', 'ELASTIC', '5', 'This defines the max nodes with ExtraLarge configuration that each cabinet can have, a -1 means no limit');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('LIMIT_PER_CABINET_LARGE_X11M', 'ELASTIC', '-1', 'This defines the max nodes with Large configuration that each cabinet can have, a -1 means no limit');

INSERT INTO ecs_properties_table (name, type, value) VALUES ('EXACOMPUTE_DEFAULT_CURRENTMDID',  'EXACOMPUTE', '15');
-- Bug 35859903 - Adding FAULT_DOMAIN property
INSERT INTO ecs_properties (name, type, value) VALUES ('FAULT_DOMAIN', 'FEATURE', 'DISABLED');

INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_HOST', 'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_PORT', 'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_AUTH_USER',  'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_AUTH_PASSWD',  'FEATURE', '');

PROMPT Inserting matrix records
-- Bug 35402924 - Adding values to compatibility matrix table
-- Bug 35777412 - Updating ADBD to ATP for EXA_VER_MATRIX
--Delete catalog of ol7/ol8
ALTER TRIGGER ECS_EXA_VER_MAT_ID DISABLE;

DELETE FROM ECS_EXA_VER_MATRIX;

INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol8', '23.1', 'BASE,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,21,19', 'EXACS', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol7', '22.1', 'BASE,X9M-2,X8M-2,X8-2,X7-2', '21,19', 'EXACS,ATP', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol8', '24.1', 'BASE,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,19', 'EXACS', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
    ('ol8', '25.1', 'BASE,X11M,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,19', 'EXACS', 'ENABLED');

--Bug 35923119 - Multiple exaversion in catalog
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_EXAVERSION_CATALOG','ELASTIC', '10');

-- Bug 35951076 - FS Encryption flag for EXACC
INSERT INTO ecs_properties (name, type, value) VALUES ('FS_ENCRYPTION','ECRA', 'DISABLED');

-- Bug 35695712 Send CM metrics to T2 
INSERT INTO ecs_properties (name, type, value) VALUES ('SEND_CM_TO_T2', 'COMPLIANCE', 'ENABLED');

COMMIT;
-- SLA server(compute/storage) records table to support vm cluster level SLA
PROMPT creating table ecs_sla_server_records_table 
CREATE TABLE ecs_sla_server_records_table 
(
    hostname            VARCHAR2(256) not null,
    measure_time        TIMESTAMP not null,
    server_type         VARCHAR2(10) not null,
    compute_status      NUMBER,
    network_status      NUMBER,
    storage_status      NUMBER,
    vmcluster_names     VARCHAR2(512),
    CONSTRAINT pk_ecs_sla_server_records PRIMARY KEY (hostname, measure_time)
);
CREATE INDEX ecs_sla_server_records_idx
    ON ecs_sla_server_records_table(measure_time);
CREATE OR REPLACE EDITIONING VIEW ecs_sla_server_records AS 
SELECT
    hostname,
    measure_time,
    server_type,
    compute_status,
    network_status,
    storage_status,
    vmcluster_names
FROM
    ecs_sla_server_records_table;
-- exacs-129303: change VMCLUSER_NAMES to VARCHAR2(4000) to support 64 vms per compute
ALTER TABLE ecs_sla_server_records_table MODIFY VMCLUSTER_NAMES VARCHAR2(4000);

-- Bug 35859903 - Removing null values for Fault Domain columns
UPDATE ecs_hw_cabinets SET FAULT_DOMAIN = 'NULL' WHERE FAULT_DOMAIN IS NULL;

-- Enh 35572548 - json log request id backfill performance
PROMPT Altering table ecs_requests_table (creating index on wf_uuid)
CREATE INDEX ecs_requests_wf_uuid_idx ON ecs_requests_table(wf_uuid) NOLOGGING PARALLEL 4 ONLINE;
ALTER INDEX ecs_requests_wf_uuid_idx NOPARALLEL;

-- Bug 36050851 - fixed orphan workflows for async_calls
PROMPT Altering table async_calls_table
ALTER TABLE async_calls_table ADD wf_uuid VARCHAR2(36);
CREATE INDEX async_calls_wf_uuid_idx ON async_calls_table(wf_uuid);
CREATE OR REPLACE EDITIONING VIEW async_calls AS
SELECT * FROM async_calls_table;

-- Enh 35990354 - Adding custom linux uid/gid feature
INSERT INTO ecs_properties (name, type, value) VALUES ('CUSTOM_UID_GID', 'FEATURE', 'DISABLED');

-- Enh 36070977 - ECRA APPLICATION CHANGES TO IMPLEMENT PARTITIONING IN ECRA SCHEMA  
ALTER TABLE ASYNC_CALLS_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW ASYNC_CALLS AS
SELECT
    UUID,
    TYPE,
    RESOURCE_ID,
    ERRORS,
    TARGET_URI,
    END_TIME,
    START_TIME,
    STATUS,
    RID,
    LAST_HEARTBEAT_UPDATE,
    TARGET_SYSTEM,
    TARGET_ID,
    ECRA_SERVER,
    DETAILS,
    WF_UUID,
    START_TIME_TS
FROM
    ASYNC_CALLS_TABLE;

-- ExaCS Topology                                                                                   
INSERT INTO ecs_properties (name, type, value) VALUES ('TOPOLOGY_OSS_NAMESPACE', 'TOPOLOGY', 'exadata');
INSERT INTO ecs_properties (name, type, value) VALUES ('TOPOLOGY_HEAP_SAFETY_FACTOR', 'TOPOLOGY', '3.0');
INSERT INTO ecs_properties (name, type, value) VALUES ('TOPOLOGY_PAGINATION_MAX_RACK_COUNT', 'TOPOLOGY', '200');

-- Node Recovery SOP recover from backup
INSERT INTO ecs_properties (name, type, value) VALUES ('NODE_RECOVERY_SOP_FROM_BACKUP', 'SOP', 'true');
                 
INSERT INTO ecs_properties (name, type, value) VALUES ('SERVERNAME_INIT_VALIDATION', 'ECRA', 'DISABLED');

-- Enh 36390893 - Change limit oh for exacompute 
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_OH_GB_PER_NODE_EXACOMPUTE',  'EXACOMPUTE', '2000');
 
-- Enh 36340464 - Active-active, ip rules for multiple ECRAs. Expected values CIDR,HOSTNAME
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_SERVERS_INFO_FORMAT', 'ECRA', 'CIDR');
                                                                                  

-- Enh 36529231 - Change limit oh for ocpu to ecpu ratio 
INSERT INTO ecs_properties (name, type, value) VALUES ('OCPU_ECPU_RATIO','FEATURE', '4'); 
 
-- EBug 36742283 - Add extra server information for routing rules
INSERT INTO ecs_properties (name, type, value) VALUES ('EXTRA_NATWHITELIST_ENTRIES','ECRA', '');
-- Bug 36545094 - Introduce VM status sync job
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACC_VMSTATUS_SYNC','EXACC', 'ENABLED');

-- Enh 36627653 - Add properties for XS Vault details sync scheduler
INSERT INTO ecs_properties (name, type, value) VALUES ('JOB_COUNT_FOR_VAULTS_SYNC','ECRA', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('XSVAULT_DETAILS_UPDATE_TIMEOUT_SECONDS','ECRA', '600');

-- Enh 36842063 - Add minimum storage available req for clu creation
INSERT INTO ecs_properties (name, type, value) VALUES ('MIN_STORAGEGB_FOR_CLU_CREATION','ECRA', '2048');

-- Enh 36902645 - Changing property REMOVE_KEYS_AFTER_PROVISIONING to disabled
INSERT INTO ecs_properties (name, type, value) VALUES ('REMOVE_KEYS_AFTER_PROVISIONING', 'FEATURE', 'DISABLED');

-- Enh 37081824 - Add property to skip add delete storage precheck
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('SKIP_ATTACHSTORAGE_PRECHECK', 'FEATURE', 'DISABLED', 'Skip the precheck task in the ExaCS/ADBS attach storage workflows');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('SKIP_DELETESTORAGE_PRECHECK', 'FEATURE', 'DISABLED', 'Skip the precheck task in the DELETE_ELASTIC_CELL_WFD workflow');

-- Enh 36061279 - Scheduler changes for active-active 2c (blue-green)
INSERT into ecs_properties (name, type, value, description) VALUES
    ('SCHEDULER_ANY_JOB_TARGET_SERVERS', 'ECRA', 'STANDBY', 'Specifies which target servers can run the ANY jobs. Allowed values are: ALL, STANDBY, comma-separated list of server names (e.g. EcraServer1,EcraServer2)');
INSERT into ecs_properties (name, type, value, description) VALUES
    ('SCHEDULER_ANY_JOB_FAILOVER_TIME_SECONDS', 'ECRA', '120', 'When all SCHEDULER_ANY_JOB_TARGET_SERVERS are down, remaining servers will run ANY jobs after this timeout.');
INSERT into ecs_properties (name, type, value, description) VALUES
    ('SCHEDULER_MAX_SERVER_COUNT', 'ECRA', '5', 'DiagnosisScheduleGroup_PUT API will create this number of jobs for the jobs with ALL target server');
UPDATE ecs_scheduledjob SET target_server='ANY' WHERE job_class='oracle.exadata.ecra.scheduler.VMBackupStatusTrackerJob' and target_server='STANDBY';
UPDATE ecs_scheduledjob SET current_target_server='ANY' WHERE job_class='oracle.exadata.ecra.scheduler.VMBackupStatusTrackerJob' and current_target_server='STANDBY';
UPDATE ecs_scheduledjob SET target_server='ANY' WHERE job_class='oracle.exadata.ecra.scheduler.ECRASlaSloMetricJob' and target_server='STANDBY';
UPDATE ecs_scheduledjob SET current_target_server='ANY' WHERE job_class='oracle.exadata.ecra.scheduler.ECRASlaSloMetricJob' and current_target_server='STANDBY';
UPDATE ecs_scheduledjob SET target_server='ANY' WHERE job_class='oracle.exadata.ecra.scheduler.InfraPatchingCleanupJob' and target_server='STANDBY';
UPDATE ecs_scheduledjob SET current_target_server='ANY' WHERE job_class='oracle.exadata.ecra.scheduler.InfraPatchingCleanupJob' and current_target_server='STANDBY';

-- Enh 36906964 - Automating secure erase certificate upload to oss
INSERT INTO ecs_properties (name, type, value, description) VALUES ('SECURE_ERASE_OCI_BUCKET_NAME', 'FEATURE', 'DISABLED', 'Bucket name used to store certificates of secure erase operation');

INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('CEI_SKIP_SWVERSION_CHECK', 'FEATURE', 'DISABLED', 'Skip the sw_version check during CEI creation');

-- Enh 37159566 - Adding vmbackup history
INSERT INTO ecs_properties (name, type, value, description) VALUES ('VM_SCHEDULER_MAX_RETRIES', 'ECRA', '6', 'Sets the maximum retries that the scheduler uses to fail a backup');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('VM_SCHEDULER_MAX_RETRY_HOURS', 'ECRA', '12', 'Sets the maximum hours that the scheduler uses to fail a backup');

-- Enh 36710874 - Seed data in state_lock_data
MERGE INTO state_lock_data
USING
    (SELECT 1 "one" FROM dual)
ON
    (state_lock_data.LOCK_STATE='FREE' or state_lock_data.LOCK_STATE='LOCKED')
WHEN NOT matched THEN
INSERT (LOCK_STATE, LOCK_HANDLE, STATE_HANDLE, LOCK_ACQUIRED_TIME)
VALUES ('FREE', 1, 0, '');

COMMIT;  

-- creating ecs_lb_cookie_info_table and view
PROMPT creating table ecs_lb_cookie_info_table
create table ecs_lb_cookie_info_table
(
    status_uuid            varchar2(2048) not null,
    exacloud_hostname      varchar2(512) not null,
    lb_cookie              varchar2(2048),
    operation              varchar2(256),
    server_name            varchar2(256),
    start_time             timestamp,
    end_time             timestamp,
    CONSTRAINT pk_lb_cookie_id PRIMARY KEY ( status_uuid , exacloud_hostname)
);


CREATE OR REPLACE EDITIONING VIEW ecs_lb_cookie_info AS
SELECT
    status_uuid,
    exacloud_hostname,
    lb_cookie,
    operation,
    server_name,
    start_time,
    end_time
FROM
    ecs_lb_cookie_info_table;

-- Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA OPERATIONS FAILING POST PARTITIONING AND ARCHIVING OF TABLES
ALTER TABLE WF_TASK_STATE_MACHINE_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW WF_TASK_STATE_MACHINE AS
SELECT
  TASK_GROUP_ID,
  WF_UUID,
  NODE_NAME,
  CURRENT_STATE,
  INPUT,
  START_TIME,
  END_TIME,
  START_TIME_TS
FROM
  WF_TASK_STATE_MACHINE_TABLE;

ALTER TABLE WF_STATE_MACHINE_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW WF_STATE_MACHINE AS
SELECT
  WF_UUID,
  WF_NAME,
  REQUEST_PAYLOAD,
  CURRENT_STATE,
  SERVER_NAME,
  START_TIME,
  END_TIME,
  VERSION,
  START_TIME_TS
FROM
  WF_STATE_MACHINE_TABLE;

ALTER TABLE WF_TASK_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW WF_TASK AS
SELECT
  TASK_GROUP_ID,
  TASK_NAME,
  WF_UUID,
  OPERATION_ID,
  CURRENT_STATE,
  OUTPUT,
  START_TIME,
  END_TIME,
  RUN_MODE,
  START_TIME_TS
FROM
  WF_TASK_TABLE;

ALTER TABLE WF_TASK_OPERATION_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW WF_TASK_OPERATION AS
SELECT
  TASK_GROUP_ID,
  TASK_NAME,
  OPERATION_ID,
  SEQUENCE_NO,
  WF_UUID,
  OPERATION_NAME,
  OPERATION_CURRENT_STATE,
  START_TIME,
  END_TIME,
  START_TIME_TS
FROM
  WF_TASK_OPERATION_TABLE;

ALTER TABLE WF_TRAVERSAL_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW WF_TRAVERSAL AS SELECT WF_UUID, SEQ_NO, PATH_ELEMENT, ELEMENT_TYPE, TASK_GROUP_ID, START_TIME_TS FROM WF_TRAVERSAL_TABLE;

ALTER TABLE WF_ACTIVE_TASK_SM_MAPPING_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW WF_ACTIVE_TASK_SM_MAPPING AS SELECT WF_UUID, TASK_GROUP_ID, START_TIME_TS FROM WF_ACTIVE_TASK_SM_MAPPING_TABLE;

ALTER TABLE ECS_IDEMTOKENS_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW ECS_IDEMTOKENS AS SELECT ID, TYPE, CREATED, RESOURCES, RESPONSE, START_TIME_TS FROM ECS_IDEMTOKENS_TABLE;

ALTER TABLE ECS_SCHEDULEDJOB_HISTORY_TABLE ADD START_TIME_TS TIMESTAMP(6);
CREATE OR REPLACE EDITIONING VIEW ECS_SCHEDULEDJOB_HISTORY AS
SELECT
  ID,
  JOB_CLASS,
  JOB_CMD,
  JOB_PARAMS,
  START_TIME,
  END_TIME,
  LAST_UPDATE_BY,
  TARGET_SERVER,
  TYPE,
  PLANNED_START,
  TIMEOUT,
  EXIT_STATUS,
  RESULT,
  JOB_GROUP_ID,
  CURRENT_TARGET_SERVER,
  START_TIME_TS
FROM
  ECS_SCHEDULEDJOB_HISTORY_TABLE;

-- Enh 36206167
UPDATE ecs_atpociendpointurl SET realmdomain='oraclecloud5.com' where realm='OC5';

-- Bug 35933745
UPDATE ECS_OCI_EXA_INFO SET client_network_bondingmode='active-backup' WHERE client_network_bondingmode IS NULL;
UPDATE ECS_OCI_EXA_INFO SET backup_network_bondingmode='active-backup' WHERE backup_network_bondingmode IS NULL;
UPDATE ECS_OCI_EXA_INFO SET dr_network_bondingmode='active-backup' WHERE dr_network_bondingmode IS NULL;

-- Enh 36034772 - EXACS: Keep records of deleted clusters in ecra  
PROMPT Altering table ecs_analytics_table
ALTER TABLE ecs_analytics_table add (clusterocid varchar2(512));

-- Enh 36904134 - Saving results for secure erase wf
ALTER TABLE ECS_ANALYTICS_TABLE ADD DATA BLOB default NULL;

CREATE OR REPLACE EDITIONING VIEW ECS_ANALYTICS AS
SELECT
  CUSTOMERNAME,
  EXAUNITID,
  ID,
  CEIOCID,
  OPERATION,
  IDEMTOKEN,
  STATUS,
  RACKNAME,
  END_TIME,
  START_TIME_TS,
  START_TIME,
  PAYLOAD,
  CLUSTEROCID,
  DATA
FROM
  ECS_ANALYTICS_TABLE;

-- -- creating ecs_exaservice_iorm_resources_table and view
PROMPT creating table ecs_exaservice_iorm_resources_table
create table ecs_exaservice_iorm_resources_table
(
    exa_ocid                 varchar2(512) not null,
    exaunit_id              number not null,
    flash_cache_min_sum     varchar2(256),
    flash_cache_size_sum    varchar2(256),
    flash_cache_limit_sum   varchar2(256),
    flash_cache_size        varchar2(256),
    pmem_cache_min_sum      varchar2(256),
    pmem_cache_size_sum     varchar2(256),
    pmem_cache_limit_sum    varchar2(256),
    xrmem_cache_min_sum      varchar2(256),
    xrmem_cache_size_sum     varchar2(256),
    xrmem_cache_limit_sum    varchar2(256),
    pmem_cache_size         varchar2(256),
    valid                   NUMBER(1,0) DEFAULT 1 NOT NULL,
    CONSTRAINT pk_exa_iorm_res_ocid PRIMARY KEY (exa_ocid, exaunit_id)
);

CREATE OR REPLACE EDITIONING VIEW ecs_exaservice_iorm_resources AS
SELECT
    exa_ocid,
    exaunit_id,
    flash_cache_min_sum,
    flash_cache_size_sum,
    flash_cache_limit_sum,
    flash_cache_size,
    pmem_cache_min_sum,
    pmem_cache_size_sum,
    pmem_cache_limit_sum,
    xrmem_cache_min_sum,
    xrmem_cache_size_sum,
    xrmem_cache_limit_sum,
    pmem_cache_size,
    valid
FROM
    ecs_exaservice_iorm_resources_table;

-- Enh 36496297 - Send ClamAV metrics to T2
PROMPT Creating table ecs_compliance_rpm_info_table
create table ecs_compliance_rpm_info_table (
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

-- -- creating ecs_exascale_vaults_table
PROMPT creating table ecs_exascale_vaults_table
create table ecs_exascale_vaults_table
(
    vault_ocid              varchar2(256) not null,
    infra_ocid              varchar2(256) not null,
    vault_reference_id      varchar2(128),
    name                    varchar2(64),
    size_gb                 number,
    used_gb                 number,
    type                    varchar2(6),
    CONSTRAINT pk_xs_vaults_ocid PRIMARY KEY (vault_ocid),
    CONSTRAINT chk_xsvault_type
      CHECK (type in ('DB', 'VM'))
);

PROMPT creating view ecs_exascale_vaults
CREATE OR REPLACE EDITIONING VIEW ecs_exascale_vaults AS
SELECT
    vault_ocid,
    infra_ocid,
    vault_reference_id,
    name,
    size_gb,
    used_gb,
    type
FROM
    ecs_exascale_vaults_table;

PROMPT creating table ecs_exadata_compute_node_table
ALTER TABLE ECS_EXADATA_COMPUTE_NODE_TABLE ADD VMVAULT_REFERENCEID VARCHAR2(256);

PROMPT creating view ecs_exadata_compute_node
CREATE OR REPLACE EDITIONING VIEW ecs_exadata_compute_node AS
SELECT
    hostname,
    aliasname,
    allocated_purchased_cores,
    allocated_burst_cores,
    memory_gb,
    local_storage_gb,
    avail_local_storage_gb,
    exaservice_id,
    exadata_id,
    inventory_id,
    total_cores,
    vmvault_referenceid
FROM ecs_exadata_compute_node_table;

create table ecs_exascale_nw_table (
	infra_ocid varchar2(512) not null,
	ip varchar2(15),
	subnet varchar2(20),
	netmask varchar2(20),
	vlanid number(4),
	domain varchar2(512),
	hostname varchar2(512),
	port number(4),
      CONSTRAINT ecs_exascale_nw_pk PRIMARY KEY(infra_ocid),
      CONSTRAINT fk_exascale_id FOREIGN KEY (infra_ocid)
      REFERENCES ecs_exadata_table(exadata_id)
      ON DELETE CASCADE
);

CREATE OR REPLACE EDITIONING VIEW ecs_exascale_nw AS
SELECT
	infra_ocid,
        ip,
        subnet,
        netmask,
        vlanid,
        domain,
        hostname,
        port
FROM ecs_exascale_nw_table;

alter table ecs_exascale_nw_table drop constraint fk_exascale_id;

PROMPT Creating table database_heartbeat_task_table
create table database_heartbeat_task_table (
    server_name              varchar2(256),
    last_heartbeat_update    timestamp not null,
    status                   varchar2(128),
    constraint pk_db_health primary key(server_name)
);

CREATE OR REPLACE EDITIONING VIEW database_heartbeat_task AS
SELECT
    server_name,
    last_heartbeat_update,
    status
FROM
    database_heartbeat_task_table;

PROMPT creating table ecs_snapshots_table
CREATE TABLE ecs_snapshots_table(
    snapshotid varchar2(512),
    snapshotdisplayname varchar2(512),
    vmname varchar2(512),
    compartmentid varchar2(512),
    vminstanceid varchar2(512),
    vminstancegroupid varchar2(64),
    devicename varchar2(64),
    alias varchar2(32),
    volume varchar2(16),
    lvm varchar2(512),
    snapshottype varchar2(32) DEFAULT 'CUSTOMER',
    CONSTRAINT ecs_snapshots_pk
        PRIMARY KEY (snapshotid)
);

-- bug 37117708
PROMPT Altering table ECS_SNAPSHOTS_TABLE
alter table ECS_SNAPSHOTS_TABLE modify VMINSTANCEGROUPID VARCHAR2(256);

CREATE OR REPLACE EDITIONING VIEW ecs_snapshots AS
SELECT
    snapshotid,
    snapshotdisplayname,
    vmname,
    compartmentid,
    vminstanceid,
    vminstancegroupid,
    devicename,
    alias,
    volume,
    lvm,
    snapshottype
FROM
    ecs_snapshots_table;

PROMPT Creating VMBACKUPHISTORY table and view
CREATE TABLE ECS_VMBACKUPHISTORY_TABLE (
    ID VARCHAR2(36) not null,
    REQUEST_ID VARCHAR2(36),
    BACKUP_TRIGGER_TIME VARCHAR2(50 BYTE) NOT NULL, 
    BACKUP_COMPLETE_TIME VARCHAR2(50 BYTE), 
    TARGET_TYPE VARCHAR2(256 BYTE) NOT NULL, 
    TARGET_ID VARCHAR2(256 BYTE) NOT NULL, 
    RACKNAME VARCHAR2(256 BYTE), 
    VM_GOLD_BACKUP VARCHAR2(256 BYTE) NOT NULL, 
    VM_OSS_BACKUP VARCHAR2(256 BYTE) NOT NULL, 
    BACKUP_TYPE VARCHAR2(256 BYTE) NOT NULL, 
    TRACKER_LAST_UPDATE VARCHAR2(50 BYTE), 
    TRACKER_RETRY_COUNT NUMBER, 
    STATUS VARCHAR2(256 BYTE) NOT NULL, 
    WF_UUID VARCHAR2(256 BYTE), 
    ECRA_SERVER VARCHAR2(256 BYTE) NOT NULL, 
    CREATED_AT TIMESTAMP DEFAULT systimestamp, 
    UPDATED_AT TIMESTAMP, 
    ERROR_UUID VARCHAR2(36 BYTE)
);

CREATE OR REPLACE EDITIONING VIEW ecs_vmbackuphistory as
select 
    ID,
    REQUEST_ID,
    BACKUP_TRIGGER_TIME, 
    BACKUP_COMPLETE_TIME, 
    TARGET_TYPE, 
    TARGET_ID, 
    RACKNAME, 
    VM_GOLD_BACKUP, 
    VM_OSS_BACKUP, 
    BACKUP_TYPE, 
    TRACKER_LAST_UPDATE, 
    TRACKER_RETRY_COUNT, 
    STATUS, 
    WF_UUID, 
    ECRA_SERVER, 
    CREATED_AT, 
    UPDATED_AT, 
    ERROR_UUID
FROM 
    ecs_vmbackuphistory_table;

create or replace trigger ecs_vmbackuphistory_updated_at
before update on ECS_VMBACKUPHISTORY
for each row
begin
  :new.UPDATED_AT := systimestamp;
end;
/



--Enh 36755078
PROMPT Altering table ecs_exaunitdetails
ALTER TABLE ecs_exaunitdetails_table DROP COLUMN vmclustertype;
ALTER TABLE ecs_exaunitdetails_table ADD vmclustertype VARCHAR2(64) DEFAULT 'regular' CONSTRAINT cluster_type_chk CHECK (vmclustertype in ('regular', 'developer')));

CREATE OR REPLACE EDITIONING VIEW ecs_exaunitdetails AS SELECT * FROM ecs_exaunitdetails_table;

PROMPT creating table ecs_lse_log_table
CREATE TABLE ecs_lse_log_table
(
    lse_id number(10) not null,
    oneview_requesttime timestamp not null,
    cp_requesttime timestamp not null,
    ecra_requesttime timestamp not null,
    ecradb_requesttime timestamp not null,
    ecradb_responsetime timestamp not null,
    CONSTRAINT pk_lse_id PRIMARY KEY (lse_id)
);

PROMPT Recreating editioning views on table ecs_lse_log_table
CREATE OR REPLACE EDITIONING VIEW ecs_lse_log AS
    SELECT lse_id, oneview_requesttime, cp_requesttime, ecra_requesttime, ecradb_requesttime, ecradb_responsetime FROM ecs_lse_log_table;

CREATE SEQUENCE lse_id_seq START WITH 1;

CREATE OR REPLACE TRIGGER lse_id_trg
BEFORE INSERT ON ecs_lse_log_table
FOR EACH ROW

BEGIN
  SELECT lse_id_seq.NEXTVAL
  INTO   :new.lse_id
  FROM   dual;
END;
/


PROMPT Altering table ecs_exaunitdetails_table
ALTER TABLE ecs_oci_clu_xmls_table ADD (attach_candidate VARCHAR2(3) DEFAULT 'NO' CHECK (attach_candidate in ('YES', 'NO')));

CREATE OR REPLACE EDITIONING VIEW ecs_oci_clu_xmls AS SELECT * FROM ecs_oci_clu_xmls_table;

-- Bug 36916251 - HAVE SEPARATE ENTRIES FOR SECRETS DUE TO VARCHAR2 LIMIT IN ECS_SECRETVAULTINFO TABLE

PROMPT Creating table ecs_secretvaultinfo_table
create table ecs_secretvaultinfo_table (
    region           varchar2(512),
    compartment_ocid varchar2(2048),
    vault_id         varchar2(2048),
    vault_name       varchar2(2048),
    secrets          varchar2(4000),
    constraint pk_ecs_secretvaultinfo
        primary key (region)
);

CREATE OR REPLACE EDITIONING VIEW ecs_secretvaultinfo AS
SELECT
    region,
    compartment_ocid,
    vault_id,
    vault_name,
    secrets
FROM
    ecs_secretvaultinfo_table;

PROMPT Creating table ecs_vaultsecrets_table
create table ecs_vaultsecrets_table (
    secret_id        varchar2(2048),
    region           varchar2(512),
    secret_name      varchar2(2048),
    constraint pk_ecs_vaultsecrets
        primary key (secret_id),
    constraint fk_secretvaultinfo_vaultsecrets
        foreign key (region) references ecs_secretvaultinfo_table(region)
);

CREATE OR REPLACE EDITIONING VIEW ecs_vaultsecrets AS
SELECT
    secret_id,
    region,
    secret_name
FROM
    ecs_vaultsecrets_table;

-- Enh 36979503 - Adding new ecra archive table
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

-- Enh 37326852 - Add FS exacompute support
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_SYSTEM_VOLUME_GB', 'EXACOMPUTE', '114');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_MAX_SIZE_VM_GB', 'EXACOMPUTE', '1100');

-- Enh 37598887 - New exacloud property for wait time
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXACLOUD_DEFAULT_BASE_WAIT_TIME_PER_CYCLE_MILLIS', 'ECRA', '1000', 'Total wait time in milliseconds to be added to exponential backoff for exacloud calls used in between wait cycles');

-- Enh 37692741 - Adding property to use 6x9 for exacompute
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXACOMPUTE_USE_69_TO_FETCH_CABINETS', 'EXACOMPUTE', 'ENABLED', 'Enable to look for computes in 6x9 cabinets for exacompute');


-- Bug 36606128 - EXACC GEN2 PARTITIONING OF TABLE ECS_SCHEDULEDJOB_HISTORY_TABLE FAILED  

PROMPT Altering table ecs_oci_clu_xmls_table
ALTER TABLE ecs_oci_clu_xmls_table ADD exacloud_xml CLOB;
ALTER TABLE ecs_oci_clu_xmls_table ADD (attach_candidate VARCHAR2(3) DEFAULT 'NO' CHECK (attach_candidate in ('YES', 'NO')));

CREATE OR REPLACE EDITIONING VIEW ecs_oci_clu_xmls AS SELECT * FROM ecs_oci_clu_xmls_table;

PROMPT Altering table ecs_exascale_vaults_table
ALTER TABLE ecs_exascale_vaults_table ADD VAULT_ECRA_ID varchar2(24);
CREATE OR REPLACE EDITIONING VIEW ecs_exascale_vaults AS SELECT * from ecs_exascale_vaults_table;

--Enh 37025371 - EXACC X11M Support for compute standard/large and extra large
PROMPT Recreating editioning views on table ECS_EXADATA_TABLE
CREATE OR REPLACE EDITIONING VIEW ECS_EXADATA AS
    SELECT
       EXADATA_ID,
       EXADATA_SIZE,
       MODEL,
       SERVICE_ID,
       STATUS,
       TMPL_XML,
       COMPUTE_SUBTYPE,
       CELL_SUBTYPE
    FROM
        ECS_EXADATA_TABLE;


PROMPT Altering table ecs_oci_clu_xmls_table
ALTER TABLE ecs_oci_clu_xmls_table ADD updated_xml_exascale CLOB;

CREATE OR REPLACE EDITIONING VIEW ecs_oci_clu_xmls AS SELECT * FROM ecs_oci_clu_xmls_table;

PROMPT add INFRA_ACTIVATION_WF property
INSERT INTO ecs_properties (name, type, value) VALUES ('INFRA_ACTIVATION_WF', 'EXACC', 'false');

alter table ECS_DOMUKEYSINFO_TABLE modify(PUBLIC_KEY ENCRYPT NO SALT);

--Enh 34972266 - EXACS Compatibility - create new tables to support compatibility on operations
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

-- Enh 37541029 - Add feature flag for fault injection
PROMPT Adding ecs property ENABLE_FAULT_INJECTION
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_FAULT_INJECTION', 'FAULT_INJECTION', 'FALSE');

-- Enh 37379447 - Create table for the infra where the fault injection is allowed
PROMPT Creating ecs_fault_injection_infra
CREATE TABLE ecs_fault_injection_infra_table (
    infra_ocid        VARCHAR2(256) PRIMARY KEY,
    CONSTRAINT fk_infra_ocid FOREIGN KEY(infra_ocid) REFERENCES ecs_ceidetails_table(ceiocid) ON DELETE CASCADE
);
CREATE OR REPLACE EDITIONING VIEW ecs_fault_injection_infra AS
SELECT infra_ocid FROM ecs_fault_injection_infra_table;

-- Enh 35594127 - Enable dns and ntp changes for nw reconfiguration feature
UPDATE ecs_properties SET value='dns,ntp' WHERE name='NETWORK_RECONFIGURE_NW_SERVICES';

--ER EXACS-143284: QFAB support for X11M

-- X11M support
alter table ecs_rocefabric_table add X11M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric_table add X11M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
-- QFAB level default is ENABLED, but the feature is only enabled if AD level switch in ecs_properties <model>_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS is also set to ENABLED 
alter table ecs_rocefabric_table add X11M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS varchar2(10) default 'ENABLED';
alter table ecs_rocefabric_table add CONSTRAINT override_capacity_constr_x11m CHECK (X11M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS in ('ENABLED', 'DISABLED'));

PROMPT Recreating editioning views on table ecs_rocefabric_table
CREATE OR REPLACE EDITIONING VIEW ecs_rocefabric AS
SELECT * FROM ecs_rocefabric_table;


PROMPT create table ecs_fabric_elastic_reserve_thresholds_table
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

-- EXACS-143284 - QFAB reservation for expansion in highly utilized QFABs support for X11M
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_LARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_EXTRALARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_NOXRMEM_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_EF_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
-- ABSOLUTE threshold
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_LARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_EXTRALARGE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_COMPUTE_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_STANDARD_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_NOXRMEM_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_CELL_EF_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(absolute) utilization above which X11M-CELL nodes in the QFAB will be reserved for elastic expansion only');

-- Should we have X11M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS only at model level ? or include model_types?
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X11M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS', 'ELASTIC', 'DISABLED', 'Enable/Disable QFAB reservation of X11M nodes for elastic expansion once the utilization goes above threshold');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1 , 'Threshold(abs) utilization above which X8M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(abs) utilization above which X8M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(abs) utilization above which X9M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties_table (name, type, value, description) VALUES ('X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD_ABS', 'INGESTION', -1, 'Threshold(abs) utilization above which X9M-CELL nodes in the QFAB will be reserved for elastic expansion only');


-- Enh 37542317 - Progress Details in ecra response: DB schema and ecra entity changes
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

MERGE INTO ecs_registries
USING
    (SELECT 1 "one" FROM dual) 
ON
    (ecs_registries.RACK_ID= 'exacompute' and ecs_registries.request_id='89ab2335-144d-4d89-8f13-21ea34f89c55' and ecs_registries.operation='nathostnameselection') 
WHEN NOT matched THEN
INSERT (rack_id, request_id, operation)
VALUES ('exacompute', '89ab2335-144d-4d89-8f13-21ea34f89c55', 'nathostnameselection');

--Enh 34558104 - PROVIDE API FOR ECRA RESOURCE BLACKOUT
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
    PARENT_ID
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

PROMPT Modifying VOLUME_NAME column width to 128  on table ECS_VOLUMES_TABLE
ALTER TABLE ECS_VOLUMES_TABLE MODIFY VOLUME_NAME varchar2(128);


INSERT INTO ecs_elastic_platform_info_table (model, supported_shapes, maxComputes, maxCells, ilomtype, support_status, feature, hw_type) VALUES ('X11M+X11M-EF', 'X11M+EF', '-1', '-1', 'OVERLAY', 'ACTIVE', 'ELASTIC_SUBTYPE_CC', 'CELL');

PROMPT Altering table ECS_EXASERVICE_RESERVED_ALLOC_TABLE
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE MODIFY(RESERVE_TYPE VARCHAR2(64) DEFAULT 'all_operations');
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE DROP CONSTRAINT PK_ECS_RACKNAME_RES_ALLOC;
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC_TABLE ADD CONSTRAINT PK_ECS_RACKNAME_RES_ALLOC PRIMARY KEY (RACKNAME, RESERVE_TYPE);

-- Enh 37542314 - ECRA Progress Update
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

ALTER TABLE wf_tasks_weights_table ADD operation VARCHAR2(128);
CREATE OR REPLACE EDITIONING VIEW WF_TASKS_WEIGHTS as select * from WF_TASKS_WEIGHTS_TABLE;

-- Enh 38097735 -- Improve query time of inventory tables by creating indexes. 
CREATE INDEX EXACC_CPSTUNER_PATCHES_EXAOCID_IDX on EXACC_CPSTUNER_PATCHES_TABLE(EXA_OCID);
CREATE INDEX EXACC_CPSTUNER_PATCHES_BUDID_IDX on EXACC_CPSTUNER_PATCHES_TABLE(BUG_ID);
CREATE INDEX EXACC_AVAILIMAGES_INFO_EXAOCID_IDX on EXACC_AVAILIMAGES_INFO_TABLE(EXA_OCID);
CREATE INDEX EXACC_AVAILIMAGES_INFO_BASEURI_IDX on EXACC_AVAILIMAGES_INFO_TABLE(BASE_URI);
CREATE INDEX EXACC_NODEIMG_VERSIONS_EXAOCID_IDX on EXACC_NODEIMG_VERSIONS_TABLE(EXA_OCID);
CREATE INDEX EXACC_NODEIMG_VERSIONS_NODE_IDX on EXACC_NODEIMG_VERSIONS_TABLE(NODE_NAME);

-- BUG 38135459 -- NODERECOVERY STUCK WITH SOP 15|ORA-12899: VALUE TOO LARGE FOR COLUMN
ALTER TABLE ecs_scheduled_ondemand_exec_table ADD jsonpayloadclob CLOB;
CREATE OR REPLACE EDITIONING VIEW ecs_scheduled_ondemand_exec AS SELECT * FROM ecs_scheduled_ondemand_exec_table;

-- BUG 38200926 -- Set RESERVE_TYPE to default value if NULL in ecs_exaservice_reserved_alloc 
UPDATE ecs_exaservice_reserved_alloc_table SET reserve_type='all_operations' WHERE reserve_type IS NULL;

-- BUG 38202766 -- ADD USER MESSAGES FOR MISSING WFS AND TASKS FOR PROGRESS UPDATE
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

-- BUG 38173167 --  DBCS WALLETS GET OUT OF SYNC DURING THE ROTATION 
INSERT INTO ecs_properties (name, type, value, description) VALUES ('SCHEDULE_DBCS_PASSWORD_ROTATION', 'ECRA', 'ENABLED', 'Enable the schedule password rotation for the dbcs users, every 90 days');

-- BUG 38200926 -- Set RESERVE_TYPE to default value if NULL in ecs_exaservice_reserved_alloc 
UPDATE ecs_exaservice_reserved_alloc_table SET reserve_type='all_operations' WHERE reserve_type IS NULL;
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

UPDATE ecs_properties_table SET value='X8M-2,X9M-2,X11M' WHERE name='BASE_SYSTEM_MODELS';

PROMPT Altering ecs_oci_console_connection_table dropping constraint fk_console_exaunit to add delete cascade constraint
ALTER TABLE ecs_oci_console_connection_table DROP CONSTRAINT fk_console_exaunit;

PROMPT Altering ecs_oci_console_connection_table adding fk_console_exaunit to add delete cascade constraint
ALTER TABLE ecs_oci_console_connection_table
ADD CONSTRAINT fk_console_exaunit
FOREIGN KEY (EXAUNITID)
REFERENCES ECS_EXAUNITDETAILS_TABLE(EXAUNIT_ID)
ON DELETE CASCADE;

PROMPT Create and compile PL/SQL packages
@@compile_plsql

COMMIT;     
