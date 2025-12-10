Rem $Header: ecs/ecra/db/create_tables.sql /main/332 2025/10/10 19:52:41 oespinos Exp $
Rem create_tables.sql
Rem
Rem Copyright (c) 2015, 2025, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      create_tables.sql - As the name says it creates tables
Rem      and indexes and sequences
Rem
Rem    DESCRIPTION
Rem      Create all the ECRA schema tables and indexes
Rem      For more details refer to ecs/ecra/db/install_ecra_schema.sql
Rem
Rem    NOTES
Rem      Following are allowed in this file
Rem      1. CREATE TABLE
Rem      2. CREATE INDEX
Rem      3. CREATE SEQUENCE
Rem  
Rem      Following are big NO NO in this file
Rem      1. DMLs like INSERT, UPDATE and DELETE are
Rem      2. DDLs like ALTER TABLE, ALTER INDEX, DROP TABLE, DROP INDEX
Rem      3. DDLs like CREATE TRIGGER, DROP SEQUENCE
Rem      4. Transaction management statements COMMIT
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: dbaas/opc/exadata/ecra/db/create_tables.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    illamas     03/24/25 - Enh 37740901 - 19c support for exadbxs
Rem    illamas     02/04/25 - Enh 37508426 - Store more values in CS exacompute
Rem    jzandate    11/29/24 - Enh 36979503 - Saving systemvault into ecra
Rem                           archive
Rem    essharm     10/22/24 - Bug 37191850 Moving trigger name from
Rem                           create_tables.sql to create_triggers.sql
Rem    jzandate    10/18/24 - Enh 37159566 - Adding vmbackup history
Rem    nitishgu    09/20/24 - BUG: 37071966 Remove Bit vector for EXTENDED
Rem                           CLUSTER ID
Rem    nitishgu    09/05/24 - BUG 36991882 - ECRA TO SUPPORT EXTENDED CLUSTER
Rem    ybansod     08/27/24 - Bug 36916251 - HAVE SEPARATE ENTRIES FOR SECRETS
Rem                           DUE TO VARCHAR2 LIMIT IN ECS_SECRETVAULTINFO
Rem                           TABLE
Rem    zpallare    08/21/24 - Enh 34972266 - EXACS Compatibility - create new
Rem                           tables to support compatibility on operations
Rem    essharm     07/10/24 - Enh 36383801 - HEARTBEAT TRASACTION TO
Rem                           PROACTIVELY IDENTIFY ISSUES WITH REGION LEVEL
Rem                           RESOURCE
Rem    luperalt    07/10/24 - Bug 36754210 Fixed exascale_nw table
Rem    luperalt    06/13/24 - Bug 36603885 Added exascale table
Rem    seha        06/10/24 - Enh 36496297 - Add table ecs_compliance_rpm_info
Rem    illamas     05/24/24 - Enh 36224070 - Snapshot table
Rem    pverma      06/06/24 - Fix ECS_EXASCALE_VAULT definition
Rem    pverma      05/20/24 - Exascale related changes
Rem    rgmurali    03/31/24 - Bug 36455780 - Fix ecs_rocefabric table for fresh install case
Rem    essharm     03/13/24 - Bug 36390589 - EXACC:SLA:WAVE2:BB: BREACH DID NOT
Rem                           REFLEX ON THE REPORT
Rem    sdevasek    02/21/24 - ENH 336295882 - IMPLEMENT ONEOFF V2 PLUGIN 
Rem                           REGISTRATION
Rem    oespinos    10/05/23 - Bug 35838202 ADD JOIN TABLE BETWEEN SLA_BREACH AND SLA_HOSTS
Rem    jiacpeng    09/19/23 - Redesign of SLA feature
Rem    oespinos    09/11/23 - Bug 35756904 - ExaCC SLA schema changes
Rem    ddelgadi    08/25/23 - Bug 35743318 - query fixes
Rem    jzandate    06/13/23 - Bug 35402924 - Adding new tables for exadata 23
Rem                           compatibility matrix
Rem    gvalderr    06/09/23 - Adding values to constraints of ecs_gold_specs
Rem    jiacpeng    05/18/23 - Add enable SLA by tennacy
Rem    gvalderr    05/12/23 - Adding sequence to sshkeys table
Rem    illamas     05/12/23 - Enh 35268841 - Exacompute templates
Rem    ybansod     04/25/23 - Enh 35201663 - Add table ecs_system_vault_access
Rem    ybansod     04/24/23 - Enh 35200493 - Add table ecs_system_vault for
Rem                           system vault api
Rem    pverma      04/05/23 - Fix length ecs_oci_console_connection_id_seq to
Rem                           30
Rem    aadavalo    03/30/23 - Enh 35182144 - Adding cron_schedule column to
Rem                           scheduled jobs
Rem    jyotdas     03/09/23 - ENH 35026545 - Provide a way to configure an
Rem                           external launch node(s) for patching
Rem    luperalt    03/06/23 - Bug 35145654 Created ecs_oci_console_connection
Rem                           table
Rem    aadavalo    02/21/23 - Enh 35048435 - Changes in schema for preprov
Rem    pverma      12/14/22 - Serial Console History changes
Rem    illamas     11/29/22 - Bug 34773085 - Remove dbsystemid column
Rem    rgmurali    10/17/22 - ER 34325936 - MD support in ECRA
Rem    bshenoy     09/23/22 - Bug 34554346: Save CPS SW metadata regarding
Rem                           primary & secondary host
Rem    aadavalo    10/03/22 - Enh 34394111 - Adding tables for user management
Rem                           in ecra ng
Rem    sanjivku    09/05/22 - 34564275 : Added new table to store infra
Rem                           resource principal
Rem    essharm     08/26/22 - Bug-34538859 Adding tables for sla/slo apis
Rem    bshenoy     07/08/22 - Bug 34184276: Endpoint to save FS location & ecs
Rem                           series for dyn task tar
Rem    illamas     06/30/22 - Enh 34325943 - Add Maintenance domain
Rem    essharm     05/20/22 - Added ecs_rotation_schedule for bug 34165843
Rem    aadavalo    03/25/22 - Enh 33817649 - Changing pod_payload and
Rem                           pod_payload2 from varchar to clob
Rem    marislop    02/25/22 - ENH 33867580 - Add SiV parameters
Rem    hcheon      02/08/22 - 33691502 Added SLA gathering
Rem    illamas     01/26/22 - Enh 33509359 - Store and retrieve exacompute
Rem                           payload
Rem    mpedapro    12/10/21 - Bug::33637425 bug_id of exacc_cpstuner_patches
Rem                           can be list of bugs seperated by comma
Rem    rgmurali    12/09/21 - ER 33509397 - Chaine state store support
Rem    bshenoy     11/22/21 - Bug 33588245: new table for wf task retry
Rem    marislop    11/16/21 - ENH 33392447 Update parameter bucket namespace to
Rem                           mandatory in FS encryption
Rem    essharm     10/28/21 - bug 33509962 - JUNIT TESTS FAILS BECAUSE OF THE
Rem                           TRIGGER EXACC_EXAKSPLICE_INFO_ID_SEQ
Rem    llmartin    10/26/21 - Bug 33504131 - ExaCS MultiVM views not created
Rem    llmartin    09/30/21 - Enh 33415087 - handle duplicated records in
Rem                           ECS_V_MVM_COMPUTES
Rem    llmartin    08/30/21 - Enh 33055649 - AddCluster API for MVM
Rem    rgmurali    08/24/21 - ER 32256415 - Bonding custom vip support
Rem    hcheon      08/10/21 - 33090623 Added compliance_paused_hosts,
Rem                           compliance_pause_rule
Rem    byyang      08/03/21 - bug 32932746. create ecs_ecraheartbeat table
Rem    marislop    07/28/21 - ENH 32941844 New table ecs_fs_encryption
Rem    piyushsi    07/18/21 - BUG-33113808 Workflow Task Failure Retry Feature
Rem    kvimal      07/12/21 - Updating for Fleeting Patching Par url
Rem    rgmurali    05/17/21 - ER 32810345 - Support bonding migration
Rem    byyang      05/23/21 - Enh 32322406. add index on logcol history and
Rem                           async
Rem    rgmurali    05/17/21 - ER 32810345 - Support bonding migration
Rem    oespinos    05/04/21 - 32496937 - Add new tables for infra passwd
Rem                           rotation
Rem    illamas     04/30/21 - Enh 32677648 - Update se linux policy on
Rem                           provisioned clusters
Rem    jreyesm     04/28/21 - E.R 32817912. Add policy tables.
Rem    illamas     03/22/21 - Enh 32347095 - Define json config testing
Rem                           template for config check
Rem    cgarud      03/15/21 - Create exaie_events_switches table
Rem    luperalt    02/23/21 - Bug 32542772 Fixed typo constraint table
Rem                           ecs_scheduled_ondemand_exec
Rem    rgmurali    01/24/21 - ER 32133333 - Support Elastic shapes
Rem    bshenoy     01/19/21 - Bug 32287298: Create new tables to support
Rem                           Elastic storage
Rem    ttkumar     01/05/21 - Bug 30431339 rotate patchsvr certificate
Rem    llmartin    12/02/20 - Enh 32133351 - Inventory release for elastic
Rem                           shapes
Rem    hcheon      11/09/20 - ER 32100233 Add ecs_diag_ignore_target
Rem    jyotdas     10/14/20 - Enh 31684095 - Provide option to Register Exadata
Rem                           Patch Versions
Rem    illamas     10/15/20 - Enh 32003891 - Modifying attributes and methods
Rem    josedelg    09/15/20 - ENH 31646088: Add exadata applied patched details 
Rem                           table ecs_exa_applied_patches
Rem    marcoslo    09/10/20 - ER 31856863 - Add table to define vnuma values
Rem                           per tenancy
Rem    cgarud      07/27/20 - Add exaie event table exaie_events
Rem    sdeekshi    01/07/20 - Bug 31564449: CLEANUP NON USEFUL XIMAGES CODE
Rem    rgmurali    06/06/20 - ER 31446572 Use OCI realms
Rem    vmallu      06/01/20 - Enh 31170751 -COMPOSE CLUSTER TO SUPPORT 
Rem                           MONITORING BOND
Rem    kvimal      05/03/20 - updating to add entry for ECS_TFATENANTBUCKET
Rem    jreyesm     04/30/20 - Remove oci sdk table .
Rem    vmallu      04/15/20 - Bug 31132022 - add compute and storage only
Rem                           constraints
Rem    joibarra    04/02/20 - Bug 31104554 Removing foreign key
Rem                           FK_ECS_CLU_RES_ACTIVITY_LOG
Rem    aabharti    03/18/20 - ER 31000123 - API to seed admin tenancy details
Rem    hcheon      03/17/20 - 30821266 - Added ECS_DIAG_STATS table
Rem    illamas      01/17/20 -  Enh 30432286 - Save information about every
Rem                              request, and provide useful information
Rem    luperalt    03/06/20 - Bug 31002214 New table ecs_atp_nat_vip_host
Rem    rgmurali    03/06/20 - XbranchMerge rgmurali_bug-30870817 from
Rem                           st_ecs_pt-x8m
Rem    illamas      01/17/20 -  Enh 30432286 - Save information about every
Rem                              request, and provide useful information
Rem    jreyesm     02/19/20 - XbranchMerge rgmurali_bug-30802702 from
Rem                           st_ecs_pt-x8m
Rem    luperalt    01/31/20 - Added new field to the ecs_oci_vpn_cert_info
Rem                           table for new cert
Rem    joibarra    01/21/20 - 30578344 Adding and changing fields to Activity
Rem                           log table
Rem    joibarra    01/17/20 - 30578344 Adding and changing fields to Activity
Rem                           log table
Rem    luperalt    01/08/20 - Add vpn_proxy_key field to the
Rem                           ecs_oci_vpn_cert_info table
Rem    pverma      01/03/20 - Add new table for tracking OCPU activity in ExaCC
Rem    pverma      01/03/20 - Create table for recording resource allocations
Rem                           in OCI ExaCC service
Rem    byyang      12/18/19 - ER 30637967. create logcol history table
Rem    bshenoy     12/16/19 - Bug 30464487: Add new tables for component
Rem                           version support
Rem    jvaldovi    11/25/19 - Incrementing max char value for field errors in
Rem                           async_calls table
Rem    hhhernan    11/22/19 - 30582057 support CPS proxy null value
Rem    luperalt    11/20/19 - Added new field to store the CPS Nginx Key in the
Rem                           DB
Rem    hhhernan    11/04/19 - 30420823 include new ExaCC OCI certs
Rem    bshenoy     10/22/19 - test
Rem    bshenoy     10/09/19 - Bug: 30288886 list exadata target applied version
Rem    rgmurali    03/03/20 - ER 30870817 - Fabric addition APIs
Rem    oespinos    02/13/19 - ENH 30766691 - ECRA SCHEMA UPGRADE SCRIPT FOR 
Rem                           COMPOSE CLUSTER ROCE SUPPORT
Rem    rgmurali    02/13/20 - ER 30802702 - Add IP Pool support for KVM RoCE
Rem    rgmurali    01/24/19 - ER 30663489 - KVM RoCE Vlan pool management  
Rem    oespinos    01/14/20 - ENH 30765027 - COMPOSE CLUSTER ROCE/X8M SUPPORT
Rem    rgmurali    01/24/19 - ER 30663489 - KVM RoCE Vlan pool management  
Rem    bshenoy     08/14/19 - Bug 30158028: ecs_patching_version table update
Rem    pverma      08/14/19 - CA Secrets persistence/management
Rem    llmartin    08/13/19 - Enh 30109293 - ATP deprecate
Rem                           ECS_ATPRACKSIZE_SUBNET table
Rem    joseort     08/08/19 - Changing table from ecs_racks ro
Rem                           ecs_oci_exa_info.
Rem    jloubet     08/07/19 - Identity tables merge
Rem    hhhernan    08/01/19 - 30097428 Save ExaCloud keys for CC-OCI
Rem    hcheon      07/28/19 - bug-30024961 Add configuration manager
Rem    pverma      07/24/19 - Add table "ecs_cipher_keys
Rem    seha        07/23/19 - 30041007 Add tables for asset endpoint protection
Rem    jupined     07/22/19 - XbranchMerge jupined_bug-30072527_2 from
Rem                           st_ebm_19.1.1.0.0
Rem    llmartin    07/22/19 - Bug 29689196 - ATP Consolidate multiple Oracle
Rem                           Client VCNs
Rem    jloubet     07/22/19 - Adding versioning support
Rem    hhhernan    07/14/19 - XbranchMerge hhhernan_bug-30032895 from
Rem                           st_ebm_19.1.1.0.0
Rem    hhhernan    07/19/19 - 30072527 take VPN HE user and path from the DB
Rem    hhhernan    07/11/19 - 30032895 VPN HE support
Rem    jreyesm     07/10/19 - E.R 29962765. Allow customertenancy details on
Rem                           exacs
Rem    pverma      07/09/19 - New table for VPN Head-End hosts
Rem    bshenoy     07/07/19 - Bug 29833855: create patching version table
Rem    jricoir     06/19/19 - 29927854: Handle cluster reconfig for EM
Rem                           registration
Rem    ananyban    06/24/19 - Bug 29618547: Adding changes for deregistration
Rem                           for ecs_emtrackingresources
Rem    karsaxen    06/08/19 - Data modelling for vpn configuration for OCI-Exa
Rem                           changes
Rem    jricoir     05/30/19 - 29618561: N-Remote agents support
Rem    aanverma    05/14/19 - Bug #29447436: Create table ecs_wf_requests
Rem    pverma      04/25/19 - Change AdminHost to ControlPlaneServer
Rem    diegchav    04/10/19 - ER 29511222 : New table for customer tenancy
Rem                           details
Rem    pverma      04/07/19 - Data modelling for OCI-Exa changes
Rem    llmartin    04/02/19 - ENH 29538644 - OCI/EXACC Network Object API
Rem    srtata      03/15/19 - bug 29462816: add requestid to ecs_events
Rem    nkattige    02/19/19 - (29378186) Add schema changes for
Rem                           ecs_emtrackingresource table which is present in
Rem                           alter_tables.sql so that we have a full view of
Rem                           the table.
Rem    nkattige    02/15/19 - (29247147) Adding a new EM_STATE due to which the
Rem                           constaint has to be modified to accept this new
Rem                           state 'not_processing'.
Rem    sachikuk    02/04/19 - Backport sachikuk_bug-29196230 from main
Rem    jloubet     01/30/19 - XbranchMerge jloubet_bug-29279333 from
Rem                           st_ebm_19.1.1.0.0
Rem    jloubet     01/30/19 - Changing constraint issue with old table
Rem    diegchav    01/17/19 - XbranchMerge diegchav_bug-28999178 from main
Rem    diegchav    01/17/19 - XbranchMerge diegchav_bug-29062412 from main
Rem    jloubet     01/14/19 - Fixing reference for elastic
Rem    diegchav    01/11/19 - XbranchMerge diegchav_bug-28999991 from main
Rem    sachikuk    01/09/19 - Bug - 29196230 : DB schema for ATP pre
Rem                           provisioning scheduler
Rem    jreyesm     01/02/19 - XbranchMerge brsudars_bug-28943273 from main
Rem    diegchav    12/04/18 - Add table for storing ecra clobs
Rem    piyushsi    12/03/18 - XbranchMerge piyushsi_bug-28901684 from main
Rem    srtata      12/02/18 - bug 27550083: add ecs_events table
Rem    jloubet     11/27/18 - Changes for capacity tables
Rem    llmartin    11/16/18 - XbranchMerge llmartin_bug-28895194 from main
Rem    rgmurali    11/16/18 - XbranchMerge rgmurali_bug-28886901 from main
Rem    jungnlee    11/13/18 - Backport jungnlee_bug-28902534 from main
Rem    jreyesm     11/13/18 - XbranchMerge jreyesm_bug-28914269 from main
Rem    rgmurali    11/08/18 - XbranchMerge rgmurali_bug-28764057 from main
Rem    jreyesm     11/05/18 - XbranchMerge jreyesm_bug-28878547 from main
Rem    byyang      10/25/18 - Backport byyang_bug-28731684 from main
Rem    diegchav    09/18/18 - XbranchMerge diegchav_bug-28633340 from main
Rem    rgmurali    09/07/18 - XbranchMerge rgmurali_bug-28058234 from main
Rem    jreyesm     08/10/18 - XbranchMerge jreyesm_bug-28469646 from main
Rem    rgmurali    08/08/18 - XbranchMerge rgmurali_bug-28388547 from main
Rem    byyang      08/07/18 - Backport byyang_bug-28356826 from main
Rem    rgmurali    07/17/18 - XbranchMerge rgmurali_bug-28313998 from main
Rem    jungnlee    07/16/18 - Backport jungnlee_bug-28340387 from main
Rem    byyang      06/20/18 - XbranchMerge byyang_bug-28124720 from main
Rem    brsudars    11/27/18 - Add version management table for external SDKs -
Rem                           ecs_sdk_version
Rem    piyushsi    11/20/18 - ENHH 28945176 add orcl_client column in ecs_atpauthentication
Rem    llmartin    11/13/18 - Bug 28895194 - PDB metadata support
Rem    piyushsi    11/11/18 - Bug - 28901684 : Changes for storing preprovisioning
Rem                           details for an ATP rack
Rem    brsudars    11/09/18 - Add ecs_oh_space_rule to map physical space to
Rem                           actual available space for Oracle homes
Rem    jungnlee    11/08/18 - Bug 28902534 add a sequence for ecs_diag_report
Rem    jreyesm     11/02/18 - Change atp_properties column sizes
Rem    sringran    10/26/18 - ER 28691943 - ecra ximages -moving ecs_image fields to alter_tables.sql
Rem    byyang      10/03/18 - ER 28731684. Add table for scheduler one-off job.
Rem    sdeekshi    09/30/18 - Bug 28717132 - ecra ximages auto selection of latest bundle patch
Rem    diegchav    09/11/18 - ER 28633340 : Data model to support ATP whitelist
Rem    byyang      07/29/18 - ER 28356826. ExaCD support for MVM
Rem    llmartin    07/26/18 - ENH 28387777 - COS Add foreign key to
Rem    llmartin    07/20/18 - Bug 28096666 - CPU oversubscription
Rem    jungnlee    07/09/18 - Add ecs_diag_report table
Rem    rgmurali    07/07/18 - XbranchMerge rgmurali_bug-28265350 from
Rem                           st_ebm_18.2.5.1.0
Rem    rgmurali    07/07/18 - XbranchMerge rgmurali_bug-28181495 from
Rem                           st_ebm_18.2.5.1.0
Rem    rgmurali    06/19/18 - Bug 28181495 Subnet sizing for ATP
Rem    hcheon      06/19/18 - Add columns to ecs_diag
Rem    sdeekshi    06/08/18 - Bug 28189332 : Add ecra ximages image management apis
Rem    rgmurali    05/31/18 - ER 28109468 - Get ATP Network endpoint
Rem    brsudars    05/27/18 - Node subset changes
Rem    byyang      05/16/18 - Add dom0 to ecs_diag_rack_info
Rem    srtata      05/16/18 - bug 27727580: x7 support, alter ecs_caviums
Rem    srtata      04/25/18 - bug 27697345: alter ecs_hw_nodes
Rem    jreyesm     04/09/18 - Bug 27824348. Capacity Mgmt new Tables.
Rem    sgundra     03/09/18 - Bug 27671189 - ENABLE OPSTATE TO ALLOW OPS TO PROVISION INSTANCES
Rem    jreyesm     02/20/18 - Bug 27520916. NodevIps/scanvIps generation
Rem    rgmurali    01/24/18 - Bug 27417722 - Rollback higgs resources on error
Rem    byyang      01/04/18 - Add tables for ecs diag phase 2
Rem    brsudars    11/26/17 - Add property MAX_EXASERVICE_LOCK_TIME_MINS
Rem    nkedlaya    12/02/17 - Enh 27209353 - SEAMLESS ECRA SCHEMA UPGRADE
Rem                           BETWEEN VERSIONS
Rem    brsudars    11/20/17 - Add correct storage values to ecs_hardware 
Rem    jreyesm     11/10/17 - Bug 27090986. Higgs Bond0 new table.
Rem    sgundra     11/08/17 - Bug-27063758 : Support X7 hardware
Rem    srtata      11/07/17 - bug 27034487: add cnsenabled to ecs_racks
Rem    rgmurali    09/26/18 - Bug 26865447 - support cloud Ips for higgs
Rem    sachikuk    11/08/17 - Bug - 27086265 : Enhance rack slot registration
Rem    brsudars    10/30/17 - Save request in exaservice db as fields like
Rem                           order.components may be used later
Rem    sgundra     10/26/17 - Bug 27032521 - get a list of all the datacenters
Rem    rgmurali    10/24/17 - Bug 26823575 - Add APPID support for higgs.
Rem    jreyesm     10/20/17 - Bug 26991724. MDBCS status_detail new field.
Rem    brsudars    10/17/17 - Add gbOhSize to cluster_shapes table
Rem    jreyesm     10/17/17 - Bug 26887484. Add timeout in ecs_properties EXACLOUD_ERROR_TIMEOUT.
Rem    rgmurali    10/10/17 - Bug-26928768 - Add some more higgs properties
Rem    brsudars    10/08/17 - Add cluster_shapes table for multi-vm
Rem    angfigue    09/29/17 - mdbcs properties
Rem    sachikuk    09/28/17 - ecra endpoints for customer network info
Rem                           management [Bug - 26885989]
Rem    nkedlaya    09/18/17 - Bug 26751817 - BULK IMPORT OF CABINET DATA FOR
Rem                           GEN1, HIGGS AND EXACM
Rem    srtata      09/18/17 - bug 26817348: add TEST_CNSURLS
Rem    aanverma    09/14/17 - Bug #26581302: Firewall sec grp and sec rules
Rem    rgmurali    09/11/17 - Bug 26169872 - support for storing Higgs resources
Rem    srtata      09/10/17 - bug 26716205: add CNS properties
Rem    angfigue    09/10/17 - required for integration with CNS
Rem    brsudars    09/03/17 - Add ECS_EXASERVICE table
Rem    angfigue    08/24/17 - updare for mampping info
Rem    angfigue    08/21/17 - update for the ords property info
Rem    rgmurali    08/11/17 - 26169855 - Higgs Phase 1
Rem    dekuckre    08/09/17 - Bug 26003275: Add LOG_LEVEL to ecs_properties
Rem    sachikuk    08/04/17 - New rack register/deregister flows for
Rem                           multi-vm [Bug - 26574643]
Rem    hhhernan    07/24/17 - XbranchMerge hhhernan_bug-26519585 from
Rem                           st_ecs_17.2.6.0.0exacm
Rem    sgundra     07/13/17 - Add CNS and ORDS Integration options
Rem    sachikuk    06/10/17 - Getting rid of multiple duplicate rack xml
Rem                           sources [Bug - 26195118]
Rem    sgundra     06/06/17 - Bug-26222189 : domukeys endpoint
Rem    dekuckre    05/26/17 - Bug 26003269 - Add DEBUG_EXACLOUD to ecs_properties
Rem    byyang      05/24/17 - Add ecra scheduling table
Rem    rgmurali    05/23/17 - ER- 26137654 HIGGs support
Rem    hgaldame    05/11/17 - Bug 25925937 : use ecradb for conf rack memory
Rem                           settings
Rem    sgundra     04/23/17 - Bug 25932707 - EM Integration v2
Rem    nkedlaya    04/21/17 - bug 25933778 - allow cabinet level subnet id in
Rem                           the bmc
Rem    hhhernan    04/20/17 - Bub 25919923
Rem    hhhernan    07/24/17 - Bug 26519585
Rem    brsudars    04/13/17 - Add ECS_ZONAL_REQUESTS table. Will be used by
Rem                           ECRA broker to track requests
Rem    sgundra     04/07/17 - EM Integration
Rem    nkedlaya    04/05/17 - bug 25839624 : new columns to ecs_temp_domus to
Rem                           hold client/backup macs during flat file load
Rem    nkedlaya    03/28/17 - new table to handle the purging of the clusters
Rem    brsudars    03/24/17 - Add username and passwd fields to ecs_zones table
Rem    nkedlaya    03/20/17 - provison to hold the nat_ip and macs during bulk
Rem                           flat file import of cabibets
Rem    brsudars    03/10/17 - Add ecs_zones table to store list of all zonal
Rem                           ECRAs
Rem    xihzhang    03/10/17 - Bug 25704598 BM: enhance idemtoken
Rem    nkedlaya    03/10/17 - bug 25703206 : compose cluster operations
Rem    xihzhang    03/07/17 - Bug 25683130 BM: add opstate attribute for racks
Rem    nkedlaya    03/06/17 - bug 25675320 : Capture ILOM data for various
Rem                           nodes in a cabinet
Rem    xihzhang    03/01/17 - Bug 25654608 BM: enhance reserveCapacity
Rem    xihzhang    02/21/17 - Bug 25619867 BM: implement reserveCapacity
Rem    nkedlaya    02/16/17 - bug 25571245 : Gen2 schema changes to add
Rem                           cabinets
Rem    diglesia    12/15/16 - update min cores for x6
Rem    angfigue    09/06/16 - adding identity domain name to service table
Rem                           for reallocation
Rem    angfigue    08/22/16 - XbranchMerge angfigue_bug-24499044 from
Rem                           st_ecs_16.4.1.0.0
Rem    angfigue    08/21/16 - adding body information from the exacloud request
Rem                           because it is required for the dbaas tools
Rem    angfigue    05/02/16 - Bug 23108731 - C9QA: IDENTITY DOMAIN DISPLAY NAME CHANGE FAILS WHEN SDI CALL ECRA
Rem    angfigue    04/25/16 - Bug 23138830 - [ECRA-PATCHING] CLUSTER PATCHING
Rem                           THROUGH ECRA
Rem    angfigue    03/29/16 - Bug 23019573 - UPDATE MINCORES TO 8 CORES PER
Rem                           NODE
Rem    angfigue    10/27/15 - comma fix
Rem    angfigue    10/26/15 - ADDING FIELD TO ASYNC_CALLS TO IDENTIFY THE RESOURCE
Rem    sergutie    07/08/15 - DB11 compatible schema
Rem    angfigue    05/12/15 - Exacloud json .
Rem    angfigue    02/16/15 - Schema creation
Rem    angfigue    02/16/15 - Created
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


PROMPT Creating table ecs_atpterraformversion
CREATE TABLE ecs_atpterraformversion (
    ingestion_version   NUMBER NOT NULL,
    vcnid               VARCHAR2(2048) NOT NULL,
    servicejson_data    CLOB,
    ingestion_date      TIMESTAMP NOT NULL,
    CONSTRAINT ecs_atpterraformversion_pk PRIMARY KEY ( ingestion_version, vcnid)
);

PROMPT Creating table ecs_exadata
create table ecs_exadata (
   exadata_id          varchar2(512),
   service_id          varchar2(4000),
   status              varchar2(128) default 'READY', -- READY, ALLOCATED
   model               varchar2(100) not null,
   exadata_size        varchar2(100) not null,
   tmpl_xml            CLOB not null,
   CONSTRAINT pk_exadata_id
       PRIMARY KEY (exadata_id),
   CONSTRAINT chk_exadata_status
       CHECK (status in ('READY', 'ALLOCATED'))
);

PROMPT Creating table ecs_exadata_compute_node
create table ecs_exadata_compute_node (
   hostname                   varchar2(512), -- the fqdn hostname of a compute
   aliasname                  varchar2(256) not null, -- a user friendly name the end user can see
   allocated_purchased_cores  number not null, -- user allocated purchased cores for this compute
   allocated_burst_cores      number not null, -- user allocated burst cores for this compute
   memory_gb                  number not null,  -- total memory per compute. Fixed per compute as of now.
   local_storage_gb           number not null,  -- the total u02 local storage per compute
   exaservice_id              varchar2(512),
   exadata_id                 varchar2(4000) not null,
   CONSTRAINT pk_comp_hostname
       PRIMARY KEY (hostname),
   CONSTRAINT alias_uniq_per_exadata UNIQUE (exadata_id, aliasname) enable, 
   CONSTRAINT fk_compute_exadata_id FOREIGN KEY (exadata_id) 
    REFERENCES ecs_exadata(exadata_id)
);


PROMPT Creating table ecs_exaservice
create table ecs_exaservice(
  id varchar2(4000) not null, -- Caller defined service id
  exadata_id varchar2(512) not null, -- Internal Exadata container for ecs_racks
  name varchar2(256) not null, -- Customer defined serice name
  racksize varchar2(64) not null, -- QUARTER, HALF etc.
  model varchar2(64) not null, -- the hardware model
  base_cores number not null, -- minimum cores
  additional_cores number not null, -- additional cores the customer may purchase
  burst_cores number not null, -- burst cores
  memorygb number not null, -- Each cluster is allocated a part of it
  storagetb number not null, -- Each cluster is allocated a part of it.
  purchasetype varchar2(64) not null, -- subscription, metered etc.
  payload_archive CLOB not null, -- archive the request payload
  CONSTRAINT pk_exaservice_id PRIMARY KEY (id),
  CONSTRAINT fk_exadata_id FOREIGN KEY (exadata_id) 
    REFERENCES ecs_exadata(exadata_id)
);

PROMPT Creating table pods
create table pods(
    id number primary key,
    exaservice_id varchar2(4000) null, -- null for now. TODO: Change to not null post migration to multi-vm
    pod_guid varchar2(4000) not null,
    pod_size varchar2(4000) not null,
    pod_payload CLOB not null,
    pod_payload2 CLOB not null,
    multitenant varchar2(10) not null,
    tools_key   varchar(4000) not null, 
    uri varchar2(4000) not null, 
    implementation_version varchar2(50) null, 
    service_type varchar2(200) null, 
    pod_score varchar2(32) null,
    cloud varchar2(32) default 'Gen1' null, -- Gen1/Gen2/Gen1NoSDI
    -- TODO: enable fk_exaservice_id post migration of single vm code to create ecs_exaservice
    -- CONSTRAINT fk_exaservice_id FOREIGN KEY (exaservice_id) REFERENCES ecs_exaservice(id),
    CONSTRAINT pod_id UNIQUE(pod_guid) enable
);

PROMPT Creating sequence pod_id_seq
create sequence pod_id_seq;

PROMPT Creating table services
create table services(
    service_id number primary key,
    id     varchar2(4000) not null, 
    status varchar2(50) not null, 
    name   varchar2(4000) not null, 
    identity_domain_id       varchar2(4000) not null, 
    short_identity_domain_id varchar2(4000) null,
    identity_domain_name     varchar2(4000) null, 
    identity_domain_display_name varchar2(4000) null,
    s_size                   varchar2(100)  not null, 
    sizing_details           varchar2(4000) null, 
    service_type             varchar2(4000) not null, 
    trial                    varchar2(50)   not null, 
    service_specific_payload varchar2(4000) not null,
    uri                      varchar2(4000) not null, 
    ecra_pod_id              number not null,
    purchase_type            varchar2(50) null,
    CONSTRAINT service_pk UNIQUE(id) enable,
    CONSTRAINT pods_id
         FOREIGN KEY (ecra_pod_id)
         REFERENCES pods(id)
);

PROMPT Creating sequence services_id_seq
create sequence services_id_seq;


PROMPT Creating table ecs_exadata_vcompute_node
create table ecs_exadata_vcompute_node(
   hostname              varchar2(512) not null, -- the VM fqdn name
   exacompute_hostname   varchar2(512) not null, -- the physical compute on which this VM is running
   exaunit_id            number not null,        -- Assocaited pod/exaunit id
   rack_name             varchar2(256) not null, -- Associated multi-vm rack
   CONSTRAINT pk_vcomp_hostname
       PRIMARY KEY (hostname),
   CONSTRAINT fk_vcomp_exaunit_id FOREIGN KEY (exaunit_id) 
    REFERENCES pods(id),
	CONSTRAINT fk_vcomp_exacompute_hostname FOREIGN KEY (exacompute_hostname) 
    REFERENCES ecs_exadata_compute_node(hostname)
);


PROMPT Creating table exaunit_info
create table exaunit_info(
    id number primary key,
    service_id  varchar2(4000) not null,
    oedav1   BLOB not null,
    oedav2   BLOB null, 
    exacloud BLOB not null,
    name varchar2(4000) null , 
    e_size varchar2(100) null,
    state varchar2(100) not null,
    operation varchar2(10) not null, 
    CONSTRAINT xmls_pk UNIQUE(service_id) enable,
    CONSTRAINT fk_xmls_service
         FOREIGN KEY (service_id)
         REFERENCES services(id)
);

PROMPT Creating sequence exaunit_info_id_seq
create sequence exaunit_info_id_seq;

PROMPT Creating table resource
create table resources(
  db_instance_id number primary key,
  connect_string varchar2(4000),
  ons_nodes varchar2(4000),
  schema_type varchar2(4000),
  rsize varchar2(1024) not null,
  schema_name varchar2(1024) not null,
  schema_password varchar2(2048),
  schema_proxy_user varchar2(2048),
  tns_alias varchar2(2048) not null,
  tablespace_name varchar2(2048) not null,
  p_develop_url varchar2(2048),
  service_id number not null,
  constraint fk_service_id
    foreign key(service_id)
    references services(service_id)
);

PROMPT Creating sequence resources_id_seq
create sequence resources_id_seq;

PROMPT Creating table databases
create table databases (
      dbID                   number not null,
      clusterID              varchar2(4000) not null,
      exaunitID              number         not null,
      tenantID               varchar2(4000) not null,
      dbSID                  varchar2(4000) not null,
      dbVersion              varchar2(100)  not null,
      backupDest             varchar2(4000) not null,
      timezone               varchar2(50)   not null,
      status                 varchar2(36)   not null,
      dbType                 varchar2(36)   not null,
      CONSTRAINT databases_pk PRIMARY KEY (dbID)
);

PROMPT Creating sequence databases_id_seq
create sequence databases_id_seq;

PROMPT Creating table ecs_dataguard
create table ecs_dataguard (
      exaunitID     number not null,
      dbSID         varchar2(4000) not null,
      dbUniqueName  varchar2(4000),
      CONSTRAINT dataguard_pk PRIMARY KEY (exaunitID,dbSID)
);

commit;

create table ecs_cluster_connectivity (
      exaunit_id     number not null,
      remote_id      varchar2(4000) not null,
      secgroup_id    number ,
      details        varchar2(4000),
      CONSTRAINT cluster_conn_pk PRIMARY KEY (exaunit_id,remote_id)
);

PROMPT Creating table tenantinfo
create table tenantinfo (
      tenantID      varchar2(4000) not null,
      customerName  varchar2(256)  not null,
      csiNumber     varchar2(64)   not null,
      contact       varchar2(1024) not null,
      CONSTRAINT tenantinfo_pk PRIMARY KEY (tenantID)
);

PROMPT Creating table exaunits
create table exaunits (
      exaunitID number not null,
      tenantID  varchar2(4000) not null,
      exaSize      number not null,
      core      number not null,
      status    varchar2(50) not null,
      xml       varchar2(4000) not null,
      CONSTRAINT exaunits_pk PRIMARY KEY (exaunitID),
      CONSTRAINT fk_tenantinfo
          FOREIGN KEY (tenantID)
          REFERENCES tenantinfo(tenantID)
);

PROMPT Creating table clusters
create table clusters (
      clusterID      varchar2(4000) not null,
      exaunitID      number not null,
      clusterCount   number not null,
      dataRecoRatio  varchar2(4000) not null,
      CONSTRAINT clusters_pk PRIMARY KEY (clusterID),
      CONSTRAINT fk_exaunit
         FOREIGN KEY (exaunitID)
         REFERENCES exaunits(exaunitID)
);

PROMPT Creating table async_calls
create table async_calls (
        UUID            CHAR(36),
        TYPE            VARCHAR2(100),
        DETAILS         VARCHAR2(256),
        ERRORS          VARCHAR2(4000),
        TARGET_URI      VARCHAR2(256),
        END_TIME        VARCHAR2(23),
        START_TIME      VARCHAR2(23),
        STATUS          VARCHAR2(24),
        RID             VARCHAR2(50)
);

-- begin Enh 32322406
PROMPT Creating index async_calls_uuid_idx
create index async_calls_uuid_idx
  on async_calls(uuid);
-- end Enh 32322406

PROMPT Creating table sshkeys
create table sshkeys (
     sshID       number not null,
     tenantID    varchar2(4000) not null,
     clusterID   varchar2(4000) not null,
     sshkey      varchar2(4000) not null,
     type        varchar2(4000) not null,
     CONSTRAINT sshkeys_pk PRIMARY KEY (sshID),
     CONSTRAINT fk_tenantssh
         FOREIGN KEY (tenantID)
         REFERENCES tenantinfo (tenantID),
     CONSTRAINT fk_sshcluster
        FOREIGN KEY (clusterID)
        REFERENCES clusters(clusterID)
);

PROMPT Creating sequence sshkeys_seq_id
create sequence sshkeys_seq_id nocache nocycle order;

PROMPT Creating table ecs_hardware
create table ecs_hardware (
      model            varchar2(100) not null,
      racksize         varchar2(100) not null,
      minCoresPerNode  number        not null,
      maxCoresPerNode  number        not null,
      memsize          number        default 240 not null,
      tbStorage       number        not null, -- ASM storage 
      maxracks         number        default 8 not null,
      CONSTRAINT hardware_pk PRIMARY KEY (model, racksize)
);


PROMPT Creating table ecs_oh_space_rule
create table ecs_oh_space_rule (
      model                varchar2(100) not null,
      racksize             varchar2(100) not null,
      physicalSpaceInGb    number not null, -- The total physical space available on the local disk of a compute
      useableOhSpaceInGb   number not null, -- The space that can be used to create Oracle homes
      -- PK also includes physicalSpaceInGb as for a given racksize and model, the space can vary depending on number of disks on the compute.
      CONSTRAINT oh_space_rule_pk PRIMARY KEY (model, racksize, physicalSpaceInGb)
);

PROMPT Creating table ecs_cluster_shapes
create table ecs_cluster_shapes (
      model               varchar2(100) not null,
      racksize            varchar2(100) not null,
      shape               varchar2(100) not null,  -- Multi-vm shapes. SMALL, MEDIUM, LARGE, WHOLE
      numCoresPerNode     number        not null, -- total number of cores per node for a given shape
      gbMemPerNode        number        not null,  -- total memory per node for a given shape
      tbStoragePerCluster number        not null,  -- total ASM disk space per cluster for a given shape
      gbOhSize            number        not null,  -- the Oracle home size on local disk partition of a node
      -- disable clushapes_size_model_fkey for now as model and racksize can be ALL to support default shapes
      -- validate against ecs_hardware in code
      --CONSTRAINT clushapes_size_model_fkey FOREIGN KEY (model, racksize)
      --REFERENCES ecs_hardware(model, racksize) not deferrable,
      CONSTRAINT ecs_cluster_shapes_ck CHECK (SHAPE in ('SMALL', 'MEDIUM', 'LARGE', 'WHOLE')),
      CONSTRAINT cluster_shapes_pk PRIMARY KEY (model, racksize, shape)
);

PROMPT Creating table ecs_zones
create table ecs_zones (
  region             varchar2(100),
  dc                 varchar2(100),     -- data center
  zone               varchar2(100), 
  location           varchar2(30) default 'LOCAL' not null, -- REMOTE, LOCAL
  uri                varchar2(512),
  bkupuri            varchar2(512),
  username           varchar2(256),
  passwd             BLOB, 
  subnetocid         varchar2(256),
  CONSTRAINT uri_unique UNIQUE(URI) enable,
  CONSTRAINT bkupuri_unique UNIQUE(BKUPURI) enable,
  CONSTRAINT zone_pk  PRIMARY KEY (zone,location)
);

PROMPT Creating table ecs_racks
create table ecs_racks (
    dom0        varchar2(512),
    domu        varchar2(512),
    name        varchar2(256) NOT NULL,
    model       varchar2(100),
    opstate     varchar2(128) DEFAULT 'ONLINE' NOT NULL, -- ONLINE, OFFLINE, OPSTEST, PATCH
    status      varchar2(100), -- NEW, COMPOSING, READY, RESERVED, PROVISONED, ERROR, DELETED
    racksize    varchar2(100),
    details     varchar2(4000),
    location    varchar2(256) ,
    envType     varchar2(100) , 
    xml         CLOB,   -- Original rack xml
    updated_xml CLOB,   -- Updated rack xml returned by exacloud
    exaunitID   number,
    exadata_id  varchar2(512),
    disabled    number(1) DEFAULT 0,
    cnsenabled  number(1) DEFAULT 1,
    CONSTRAINT unique_name UNIQUE(name) enable,
    CONSTRAINT ecs_racks_opstate_ck CHECK (OPSTATE in ('ONLINE', 'OFFLINE', 'OPSTEST', 'PATCH')),
    CONSTRAINT fk_rack_exadata_id
        FOREIGN KEY (exadata_id)
        REFERENCES ecs_exadata(exadata_id) NOVALIDATE
);

PROMPT Creating table ecs_rack_slots
create table ecs_rack_slots (
    rack_name        varchar2(256),
    exadata_id       varchar2(512) not null,
    details          CLOB not null,
    source           varchar2(256) not null, -- OPS, HIGGS
    CONSTRAINT pk_rack_slots_rack_name
        PRIMARY KEY (rack_name),
    CONSTRAINT fk_rack_slots_exadata_id
        FOREIGN KEY (exadata_id)
        REFERENCES ecs_exadata(exadata_id) NOVALIDATE,
    CONSTRAINT chk_rack_slots_source
       CHECK (source in ('OPS', 'HIGGS'))
);

PROMPT Creating table ecs_idemtokens
create table ecs_idemtokens (
    id         varchar2(128) not null,
    type       varchar2(256),
    created    varchar2(128)  not null,
    resources  varchar2(4000),
    CONSTRAINT token_id PRIMARY KEY (id)
);

PROMPT Creating table ecs_kvmvlanpool
create table ecs_kvmvlanpool (
    fabric_id         varchar(512),
    fault_domain_id   varchar(512),
    vlan_id           varchar(512),
    rackname          varchar(512),
    vlantype          varchar(128), 
    used              number(1,0),
    CONSTRAINT ecs_kvmvlanpool_vlantype_ck CHECK (VLANTYPE in ('COMPUTE', 'STORAGE')),
    CONSTRAINT   pk_ecs_kvmvlanpool PRIMARY KEY (fabric_id, fault_domain_id, vlan_id)
);

PROMPT Creating sequence ecs_kvmippool_id_seq
create sequence ecs_kvmippool_id_seq;

PROMPT Creating table ecs_kvmippool
create table ecs_kvmippool(
    fabric_id       varchar(512),
    resource_id     varchar(512),
    ipaddress       varchar(128),
    rackname        varchar(512),
    iptype          varchar(128),
    used            number(1,0),
    CONSTRAINT      ecs_kvmippool_iptype_ck CHECK (IPTYPE in ('COMPUTE', 'STORAGE')),
    CONSTRAINT      pk_ecs_kvmippool PRIMARY KEY (fabric_id, resource_id)
);

PROMPT Creating table ecs_rocefabric
create table ecs_rocefabric(
    fabric_name       varchar(1024),
    fabric_type     varchar(512) default 'fabric910',
    CONSTRAINT pk_ecs_rocefabric PRIMARY KEY (fabric_name)
);

PROMPT Creating table ecs_elastic_ceidetails
create table ecs_elastic_ceidetails(
    ceiocid        varchar2(1024),
    rackname       varchar2(256),
    initial_nodes  CLOB,
    rackname_generated number(1,0),
    CONSTRAINT     pk_ecs_elastic_ceidetails PRIMARY KEY (ceiocid)
);

PROMPT Creating table ecs_elastic_platform_info
create table ecs_elastic_platform_info(
    model       varchar2(100),
    supported_shapes    varchar2(256),
    CONSTRAINT     pk_ecs_elastic_platform_info PRIMARY KEY (model)
);

PROMPT Creating table ecs_higgscookie
create table ecs_higgscookie (
    subscription_id   varchar2(50),
    cookie            varchar2(4000),
    path              varchar(128),
    max_age           number,
    created           varchar2(128)
);

PROMPT Creating table ecs_higgsresources
create table ecs_higgsresources (
    exaunitID     number not null,
    clustername   varchar2(256),
    subscriptionid varchar2(50),
    resourcelist  CLOB,
    domunames     CLOB,
    appid         varchar(512),
    secret        varchar(512),
    adminusername varchar(256),
    CONSTRAINT ecs_higgscloudip_pk PRIMARY KEY(exaunitID)
);

PROMPT Creating table ecs_higgscloudip
create table ecs_higgscloudip (
    hostname    varchar2(500) primary key,
    cloudip     varchar2(128)
);

PROMPT Creating table ecs_higgsnatvips
create table ecs_higgsnatvips (
    exaunitID number not null,
    hostname    varchar2(500),
    ip     varchar2(128) not null,
    ip_type varchar(128) not null,
    CONSTRAINT ecs_higgsnatvips_pk PRIMARY KEY(exaunitID,ip,ip_type)
);

PROMPT Creating table ecs_higgsclusterid
create table ecs_higgsclusterid (
    clustername varchar2(500) primary key, 
    exaunitID number not null,
    clusterid varchar2(128)
);

PROMPT Creating table ecs_higgspredeploy
create table ecs_higgspredeploy (
    dom0        varchar2(1000) not null,
    bond0_ips   varchar2(1000) not null,
    bond0_mask  varchar2(50) not null,
    bond0_gw    varchar2(50) not null,
    CONSTRAINT ecs_higgs_predeploy_pk PRIMARY KEY(dom0)
);


PROMPT Creating table ecs_atpnetworkpayload
create table ecs_atpnetworkpayload(
    dbsystem_id      varchar2(512) primary key,
    custTenantId     varchar2(2048),
    shape            varchar2(128),
    region           varchar2(512),
    ad               varchar2(512),
    rackname         varchar2(512)
);

PROMPT Creating table ecs_atpvnicinfo
create table ecs_atpvnicinfo (
    dbsystem_id   varchar2(512),
    vmname        varchar2(512),
    macaddress    varchar2(512),
    vnic_ocid     varchar2(2048),
    subnet_fdqn   varchar2(2048),
    subnet_id     varchar2(2048),
    scanip        varchar2(512),
    vnicprivateip varchar2(512),
    vnic_nodevip  varchar2(512),
    scan_hostname varchar2(512),
    vnic_hostname varchar2(512),
    vip_hostname  varchar2(512),
    service       varchar2(512) default 'atp',
    version       varchar2(512) default '0',
    CONSTRAINT ecs_atpvnicinfo_pk PRIMARY KEY (dbsystem_id, macaddress),
    CONSTRAINT ecs_atpvnicinfo_fk FOREIGN KEY (dbsystem_id)
        REFERENCES ecs_atpnetworkpayload(dbsystem_id)
);

PROMPT Creating table ecs_atpsubnetocid
create table ecs_atpsubnetocid (
    dbsystem_id   varchar2(512),
    subnet_ocid   varchar2(512),
    subnet_cidr   varchar2(512),
    CONSTRAINT ecs_atpsubnetocid_pk PRIMARY KEY (dbsystem_id),
    CONSTRAINT ecs_atpsubnetocid_fk FOREIGN KEY (dbsystem_id)
        REFERENCES ecs_atpnetworkpayload(dbsystem_id)
);

PROMPT Creating table ecs_atptenantsubnet
create table ecs_atptenantsubnet (
    dbsystem_id      varchar2(512),
    custTenantId     varchar2(2048),
    racksize         varchar2(128),
    subnetused      varchar2(128),
    CONSTRAINT pk_ecs_atptenantsubnet PRIMARY KEY (dbsystem_id, custTenantId),
    CONSTRAINT fk_ecs_atptenantsubnet
        FOREIGN KEY(dbsystem_id) 
        REFERENCES ecs_atpnetworkpayload(dbsystem_id)
);

PROMPT Creating table ecs_atpsubnetpool 
create table ecs_atpsubnetpool (
    subnetid      number primary key, 
    cidrblock     varchar2(2048),
    used          number(1,0)
);

PROMPT Creating table ecs_atpdgdslsubnetidmap
create table ecs_atpdgdslsubnetidmap(
    subnet_ocid   varchar2(512),
    dsl_ocid      varchar2(512),
    CONSTRAINT ecs_atpdgdslsubnetidmap_pk PRIMARY KEY (subnet_ocid)
);

PROMPT Creating table ecs_atpobserverdbsystem
create table ecs_atpobserverdbsystem (
    custTenantId     varchar2(2048),
    observerId       varchar2(2048),
    dbsystem_id      varchar2(2048)
);

PROMPT Creating table ecs_atpobservervmdetails
create table ecs_atpobservervmdetails (
    custTenantId     varchar2(2048),
    dbsystem_id      varchar2(2048),
    subnet_ocid      varchar2(512),
    subnetused       varchar2(128),
    sshkey           varchar2(2048),
    instance_ocid    varchar2(2048),
    status           varchar2(128),
    refcount         number default 0,
    user_data        varchar2(4000),
    CONSTRAINT ecs_atpobservervmdetails_pk PRIMARY KEY (custTenantId)
);

PROMPT Creating table ecs_atpomvcnidentity
create table ecs_atpomvcnidentity (
    tenancy_ocid     varchar2(2048) primary key,
    region           varchar2(512),
    compartment_ocid varchar2(2048),
    user_ocid        varchar2(2048),
    fingerprint      varchar2(512),
    private_key_path varchar2(512)
);

PROMPT Creating table ecs_secretvaultinfo
create table ecs_secretvaultinfo (
    region           varchar2(512) primary key,
    compartment_ocid varchar2(2048),
    vault_id         varchar2(2048),
    vault_name       varchar2(2048),
    secrets          varchar2(4000)
);

PROMPT Creating table ecs_vaultsecrets
create table ecs_vaultsecrets (
    secret_id        varchar2(2048) primary key,
    region           varchar2(512) references ecs_secretvaultinfo(region),
    secret_name      varchar2(2048)
);

PROMPT Creating table ecs_system_vault
create table ecs_system_vault (
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

PROMPT Creating table ecs_system_vault_access
create table ecs_system_vault_access (
    vault_access_id  varchar2(2048) primary key,
    node_id          varchar2(2048),
    vault_access_name   varchar2(2048),
    vault_access_type   varchar2(2048),
    vault_access_compartment_id     varchar2(2048),
    vault_id         varchar2(2048) references ecs_system_vault(vault_id),
    vault_reference_identifier      varchar2(2048),
    lifecycle_state  varchar2(2048),
    exa_root_address varchar2(2048),
    exa_root_username   varchar2(2048),
    public_key       varchar2(2048),
    is_system_generated varchar2(8) check (is_system_generated in ('true','false')),
    node_access_id   varchar2(2048)
);

PROMPT Creating table ecs_atpadminidentity
create table ecs_atpadminidentity (
    tenancy_ocid     varchar2(2048) primary key,
    region           varchar2(512),
    compartment_ocid varchar2(2048),
    user_ocid        varchar2(2048),
    fingerprint      varchar2(512),
    private_key_path varchar2(512),
    passphrase varchar2(512),
    loadbalancer_ocid varchar2(2048)
);

PROMPT Creating table ecs_atpomvcnnetwork
create table ecs_atpomvcnnetwork (
    tenancy_ocid     varchar2(2048),
    id               varchar2(2048),
    component        varchar2(512),
    cidr_block       varchar2(128),
    availability_domain_name varchar2(512),
    CONSTRAINT pk_ecs_atpomvcnnetwork PRIMARY KEY (tenancy_ocid, id),
    CONSTRAINT fk_ecs_atpomvcnnetwork
        FOREIGN KEY(tenancy_ocid) 
        REFERENCES ecs_atpomvcnidentity(tenancy_ocid)
);

PROMPT Creating table ecs_atpomvcnresource
create table ecs_atpomvcnresource (
    tenancy_ocid     varchar2(2048),
    id                varchar2(2048),
    component         varchar2(512),
    public_ip         varchar2(128),
    private_ip        varchar2(128),
    hostname          varchar2(512),
    private_key       varchar2(4000),
    CONSTRAINT pk_ecs_atpomvcnresource PRIMARY KEY (tenancy_ocid, id),
    CONSTRAINT fk_ecs_atpomvcnresource
        FOREIGN KEY(tenancy_ocid) 
        REFERENCES ecs_atpomvcnidentity(tenancy_ocid)
);

PROMPT Creating table ecs_atpwhitelistsecrules
create table ecs_atpwhitelistsecrules (
    secrule_id       number primary key,
    tenancy_ocid     varchar2(2048),
    id               varchar2(2048),
    component        varchar2(512),
    cidr_block       varchar2(128),
    port             number,
    protocol         varchar2(256) default 'TCP',
    CONSTRAINT fk_ecs_atpwhitelistsecrules
        FOREIGN KEY(tenancy_ocid, id)
	REFERENCES ecs_atpomvcnnetwork(tenancy_ocid, id)
);


PROMPT Creating table ecs_atpomvcnconfigprops
create table ecs_atpomvcnconfigprops (
    tenancy_ocid      varchar2(2048),
    property_name     varchar2(512),
    property_value    varchar2(1024),
    CONSTRAINT pk_ecs_atpomvcnconfigprops PRIMARY KEY (tenancy_ocid, property_name),
    CONSTRAINT fk_ecs_atpomvcnconfigprops
        FOREIGN KEY(tenancy_ocid) 
        REFERENCES ecs_atpomvcnidentity(tenancy_ocid)
);

PROMPT Creating table ecs_atpociendpointurl
create table ecs_atpociendpointurl (
    region      varchar2(16),
    service     varchar2(64),
    endpoint    varchar2(512),
    CONSTRAINT pk_ecs_atpociendpointurl PRIMARY KEY (region, service)
);

PROMPT Creating table ecs_ociservices
create table ecs_ociservices (
    service           varchar2(256),
    serviceidentifier varchar2(256),
    CONSTRAINT pk_ecs_ociservices PRIMARY KEY (service)
);

PROMPT Creating table ecs_atppreprovdetails
create table ecs_atppreprovdetails (
   atpuid                     varchar2(512),
   rackname                   varchar2(256) not null,
   pre_prov_dbsystem_id       varchar2(512),
   re_config_dbsystem_id      varchar2(512),
   oracle_client_tenancy_id   varchar2(2048), 
   oracle_client_vcn_id       varchar2(2048),
   oracle_client_vcn_gateway        varchar2(2048), 
   oracle_client_vcn_routerules     varchar2(2048), 
   oracle_client_vcn_security CLOB not null,
   oracle_client_subnet_id    varchar2(2048), 
   customer_tenancy_id        varchar2(2048),
   customer_subnet_id         varchar2(2048), 
   CONSTRAINT pk_ecs_atppreprovdetails PRIMARY KEY(atpuid),
   CONSTRAINT fk_rackname_preprovdetails
        FOREIGN KEY(rackname)
        REFERENCES ecs_racks(name)
);

PROMPT Creating table ecs_atpjobsmetadata
create table ecs_atpjobsmetadata (
    rack_status    varchar2(100),
    job_class      varchar2(256) not null,
    metadata       CLOB not null,
    CONSTRAINT pk_ecs_atpjobsmetadata PRIMARY KEY(rack_status)
);

PROMPT Creating table ecs_atpscheduledracks
create table ecs_atpscheduledracks (
    id             number,
    rack_name      varchar2(256),
    CONSTRAINT pk_ecs_atpscheduledracks 
         PRIMARY KEY(rack_name),
    CONSTRAINT fk_rack_name_atpscheduledracks
         FOREIGN KEY(rack_name)
         REFERENCES ecs_racks(name),
    CONSTRAINT uniq_ecs_atpscheduledracks 
         UNIQUE(id)
);

PROMPT Creating sequence ecs_atpscheduledracks_id_seq
create sequence ecs_atpscheduledracks_id_seq;

PROMPT Creating table ecs_atpjobgroups
create table ecs_atpjobgroups (
    rack_name      varchar2(256),
    job_group_id   number,
    CONSTRAINT pk_ecs_atpjobgroups
         PRIMARY KEY(rack_name),
    CONSTRAINT fk_rack_name_atpjobgroups
         FOREIGN KEY(rack_name)
         REFERENCES ecs_racks(name),
    CONSTRAINT uniq_ecs_atpjobgroups
         UNIQUE(job_group_id)
);

PROMPT Creating sequence ecs_atpjobgroups_id_seq
create sequence ecs_atpjobgroups_id_seq;

PROMPT Creating table ecs_atpcustomertenancy
create table ecs_atpcustomertenancy (
    dbsystem_id         varchar2(512) not null,
    cloud_account_id    varchar2(512),
    tenancy_name        varchar2(512),
    tenancy_ocid        varchar2(2048),
    creation_time       timestamp,
    CONSTRAINT pk_ecs_atpcustomertenancy
        PRIMARY KEY (dbsystem_id)
);

PROMPT Creating table ecs_cores
create table ecs_cores(
      service varchar2(4000) not null,
      hostname varchar2(500) not null, 
      subscocpus number not null,
      meterocpus number not null,
      burstocpus number not null,
      CONSTRAINT ecs_cores_pk PRIMARY KEY(hostname),
      CONSTRAINT cores_fk_service
         FOREIGN KEY(service)
         REFERENCES  services(id)
);


Rem --- ORDS Properties info ---
Rem --  ECRA generates the ords password based on exaunit 
Rem --  So there will be an public_user_pass per exaunit
Rem --  This password is b64 encoded stored 
Rem --  The password is already autogenerated
Rem --  so this transaction is just for stored into the DB
Rem --  Link: https://confluence.oraclecorp.com/confluence/display/EDCS/API+Ords+authentification+info 

PROMPT Creating ecs_ords_info
create table ecs_ords_info(
      exaunit_id       NUMBER not null,
      public_user_pass VARCHAR2(4000) not null,
      identityDomainId VARCHAR2(4000) null,
      CONSTRAINT ecs_ords_info_pk PRIMARY KEY(exaunit_id)
);

Rem --- MDBCS schema structures
PROMPT Creating table ecs_mdbcs_patching
create table ecs_mdbcs_patching(
    crid    VARCHAR(500) not null,
    payload CLOB not null,
    status  VARCHAR(100) not null,
    status_detail CLOB,
    CONSTRAINT ecs_mdbcs_patching_pk PRIMARY KEY(crid)
);

PROMPT Creating table ecs_subscriptions
create table ecs_subscriptions (
        exaunit_id          NUMBER,
        subscription_id     VARCHAR2(50),
        entitlement_id      VARCHAR2(50),
        customer_name       VARCHAR2(256),
        csi                 VARCHAR2(256)
);

PROMPT Creating table ecs_purchasetypes
create table ecs_purchasetypes(
    entitlement_category varchar(50) not null,
    purchase_type        varchar(50) not null,
    CONSTRAINT purchasetype_pk PRIMARY KEY (entitlement_category)
);

PROMPT Creating table ecra_files
create table ecra_files (
   ID        VARCHAR2(4000),
   CONTENT   BLOB,
   MTIME     VARCHAR2(23),
   CONSTRAINT ECRA_FILES_PK PRIMARY KEY (ID)
);

PROMPT Creating sequence ecra_clobs_id_seq
create sequence ecra_clobs_id_seq;

PROMPT Creating table ecra_clobs
create table ecra_clobs (
    id              NUMBER,
    clob_id         VARCHAR2(2048),
    type            VARCHAR2(256) NOT NULL,
    upload_time     VARCHAR2(64) NOT NULL,
    data            CLOB NOT NULL,
    CONSTRAINT ecra_clob_pk PRIMARY KEY (id)
);

PROMPT Creating table ecs_zonal_requests
create table  ecs_zonal_requests (
  id                 varchar2(100) not null, --unique id from caller like TAS
  zone               varchar2(100), -- Primary key of ecs_zones to determine zone details like auth
  rackname           varchar2(256), -- The reserved rack on which create service is being done
  location           varchar2(30) default 'REMOTE' not null,
  CONSTRAINT ecs_zonal_req_zone_fkey FOREIGN KEY (zone,location)
  REFERENCES ecs_zones(zone,location) not deferrable,
  CONSTRAINT ecs_zonal_req_location_ck CHECK (LOCATION in ('REMOTE', 'LOCAL')),
  CONSTRAINT id_unique UNIQUE(ID) enable
);

PROMPT Creating table ecs_requests
create table ecs_requests (
        ID              VARCHAR2(36) not null,
        EXAUNIT_ID      NUMBER,
        RESOURCE_ID     VARCHAR2(512),
        OPERATION       VARCHAR2(24) not null,
        STATUS          VARCHAR2(24) not null,
        STATUS_UUID     VARCHAR2(36),
        START_TIME      VARCHAR2(50),
        END_TIME        VARCHAR2(50),
        ERRORS          VARCHAR2(4000),
        TARGET_URI      VARCHAR2(256),
        DETAILS         CLOB,
        BODY            CLOB,
        REMOTE_USER     VARCHAR2(20)
);

PROMPT Creating table ecs_wf_requests
create table ecs_wf_requests (
     wf_uuid varchar2(2048) not null,
     operation_id varchar2(2048),
     task_name varchar2(2048) not null,
     exacloud_response clob,
     task_response clob,
     status_uuid varchar2(2048),
     status varchar2(24) not null,
     exa_ocid varchar2(2048),
     CONSTRAINT wf_requests_pk PRIMARY KEY (operation_id)
);

PROMPT Creating table ecs_secgroups
create table ecs_secgroups (
    SEC_ID      NUMBER not null,
    CUSTOMER_ID VARCHAR2(256) not null,
    NAME        VARCHAR2(256) not null, 
    DESCRIPTION VARCHAR2(512),
    VERSION     NUMBER not null,
    CONSTRAINT secgroups_pk PRIMARY KEY (SEC_ID, CUSTOMER_ID),
    CONSTRAINT secgroups_unique UNIQUE(NAME, CUSTOMER_ID) enable
);


PROMPT Creating table ecs_secrules
create table ecs_secrules (
    SEC_ID      NUMBER not null,
    CUSTOMER_ID VARCHAR2(256) not null,
    DIRECTION   VARCHAR2(32) not null,
    PROTO       VARCHAR2(32) not null,
    START_PORT  NUMBER,
    END_PORT    NUMBER,
    IP_SUBNET   VARCHAR2(32) not null,
    INTERFACE   VARCHAR2(32) not null
);

PROMPT Creating table ecs_seccount
create table ecs_seccount (
    CUSTOMER_ID VARCHAR2(256) not null,
    SEC_COUNT   NUMBER not null,
    CONSTRAINT sec_count_pk PRIMARY KEY (CUSTOMER_ID)
);

PROMPT Creating table ecs_exaunitsec
create table ecs_exaunitsec (
    EXAUNIT_ID  NUMBER not null,
    SEC_ID      NUMBER not null,
    CUSTOMER_ID VARCHAR2(256) not null
);

PROMPT Creating table ecs_properties
create table ecs_properties (
    NAME     VARCHAR2(256) not null,
    TYPE     VARCHAR2(256),
    VALUE    VARCHAR2(256),
    CONSTRAINT property_pk PRIMARY KEY (NAME)
);

PROMPT Creating table ecs_optimeouts
create table ecs_optimeouts (
    OPERATION     VARCHAR2(24) not null,
    RACKSIZE      VARCHAR2(24) not null,
    SOFT_TIMEOUT  number,
    HARD_TIMEOUT  number,
    CONSTRAINT optimeout_pk PRIMARY KEY (OPERATION, RACKSIZE)
);

PROMPT Creating table ecs_domukeysinfo
create table ecs_domukeysinfo (
    id              VARCHAR2(36) not null,
    exaunit_id      NUMBER,
    public_key      VARCHAR2(2048),
    users           VARCHAR(20) ,
    creation_time   VARCHAR2(64) not null,
    ttl             VARCHAR2(64) DEFAULT 86400,
    CONSTRAINT key_id PRIMARY KEY (id)
);

PROMPT Creating table ecs_exaunitdetails
create table ecs_exaunitdetails (
        exaunit_id          NUMBER,
        pod_guid            VARCHAR2(36),
        exaunit_name        VARCHAR2(16),
        entitlement_id      VARCHAR2(16),
        subscription_id     VARCHAR2(36),
        customer_name       VARCHAR2(256),
        csi                 VARCHAR2(16),
        backup_disk         VARCHAR2(16),
        create_sparse       VARCHAR2(16),
        racksize            VARCHAR2(16),
        grid_version        VARCHAR2(36) DEFAULT '12.1',
        initial_cores       NUMBER,
        gb_memory           NUMBER,
        tb_storage          NUMBER, -- Not used by exacloud. Why was this added ? TODO: Remove if not used.
        gb_storage          NUMBER, -- Multi-vm ASM storage for a cluster
        gb_ohsize           NUMBER, -- Multi-vm cluster OH size partition size
        CONSTRAINT exaunitdetail_pk PRIMARY KEY (exaunit_id)
);

PROMPT Creating table ecs_registries
create table ecs_registries (
    RACK_ID       VARCHAR2(512),
    REQUEST_ID    VARCHAR2(36),
    OPERATION     VARCHAR2(24)
);

PROMPT Creating table wf_task_retry_info
create table wf_task_retry_info (
    wf_uuid varchar2(2048) not null,
    taskname varchar2(2048) not null,
    action varchar2(2048),
    retry_count NUMBER,
    CONSTRAINT wf_task_retry_info_pk PRIMARY KEY (wf_uuid, taskname)
);

PROMPT Creating table ecs_associations
create table ecs_associations (
    ID             VARCHAR2(128),
    EXAUNIT_ID     NUMBER,
    SERVICE_ID     VARCHAR2(128),
    SERVICE_NAME   VARCHAR2(128),
    SERVICE_TYPE   VARCHAR2(128),
    ENDPOINTS      CLOB,
    CONSTRAINT association_pk PRIMARY KEY (id)
);

PROMPT Creating table psm_properties(
create table psm_properties(
    exaunit_id       NUMBER not null , 
    dbname           VARCHAR2(4000) not null,
    identityDomainId VARCHAR2(4000) not null,
    PSMserviceId     VARCHAR2(4000) not null,
    idcsPort         NUMBER,
    idcsProtocol     VARCHAR2(128),
    idcsHost         VARCHAR2(500),
    clientId         VARCHAR2(4000),
    cnsInfo          VARCHAR2(4000), 
    idcsTenant       VARCHAR2(2000),
    encodedString    VARCHAR2(4000),
    cloudProps       CLOB,
    CONSTRAINT psm_properties_pk PRIMARY KEY (exaunit_id,dbname)
);

-- Any change in ecs_scheduledjob should be reviewed with
-- ecra.ecs_archive_scheduledjob() procedure
PROMPT Creating table ecs_scheduledjob
create table ecs_scheduledjob (
    id              NUMBER,
    job_class       VARCHAR2(256)   NOT NULL,
    job_cmd         VARCHAR2(4000),
    job_params      VARCHAR2(1024),
    enabled         CHAR(1) CHECK (enabled in ('Y', 'N')),
    interval        NUMBER          NOT NULL,
    last_update     TIMESTAMP,
    last_update_by  VARCHAR2(256),
    status          VARCHAR2(16),
    target_server   VARCHAR2(50) DEFAULT 'ANY',
    type            VARCHAR2(20),
    planned_start   TIMESTAMP,
    timeout         NUMBER,
    cron_schedule   VARCHAR2(64),
    CONSTRAINT ecs_scheduledjob_pk PRIMARY KEY (id),
    CONSTRAINT ecs_scheduledjob_uniq UNIQUE (job_class, job_cmd, job_params, target_server)
);

-- For 'ONE-OFF' type jobs
-- Most values are copied from ecs_scheduledjob except end_time, exit_status and result
-- start_time is copied from last_update of ecs_scheduledjob
-- end_time is systimestamp of ecra.ecs_archive_scheduledjob()
-- Any change in ecs_scheduledjob should be reviewed with
-- ecra.ecs_archive_scheduledjob() procedure
PROMPT Creating table ecs_scheduledjob_history
create table ecs_scheduledjob_history (
    id              NUMBER,
    job_class       VARCHAR2(256)   NOT NULL,
    job_cmd         VARCHAR2(4000),
    job_params      VARCHAR2(1024),
    start_time      TIMESTAMP,
    end_time        TIMESTAMP,
    last_update_by  VARCHAR2(256),
    target_server   VARCHAR2(50),
    type            VARCHAR2(20),
    planned_start   TIMESTAMP,
    timeout         NUMBER,
    exit_status     VARCHAR2(20),
    result          CLOB,
    CONSTRAINT ecs_scheduledjob_history_pk PRIMARY KEY (id)
);

PROMPT Creating table ecs_atpjoblocks 
create table ecs_atpjoblocks (
    rack_name      varchar2(256),
    job_id         number,
    CONSTRAINT pk_ecs_atpjoblocks
         PRIMARY KEY(rack_name),
    CONSTRAINT fk_rack_name_atpjoblocks
         FOREIGN KEY(rack_name)
         REFERENCES ecs_atpscheduledracks(rack_name),
    CONSTRAINT fk_job_id_atpjoblocks
         FOREIGN KEY(job_id)
         REFERENCES ecs_scheduledjob(id)
         ON DELETE CASCADE
);

--Capacity Management v2 tables--
PROMPT Creating sequence exadata_capacity_res_order_seq
create sequence exadata_capacity_res_order_seq;

PROMPT Creating table ecs_exadata_capacity
create table ecs_exadata_capacity (
    inventory_id    VARCHAR2(512),
    hw_type         VARCHAR2(64) CHECK (hw_type in ('RACK', 'COMPUTE','CELL')) NOT NULL,
    status          VARCHAR2(64) DEFAULT 'READY' NOT NULL,
    opstate         VARCHAR2(64) DEFAULT 'ONLINE' NOT NULL,
    fabric_id       VARCHAR2(400),
    base_hwtype     VARCHAR2(128),
    CONSTRAINT ecs_exadata_capacity_pk PRIMARY KEY (inventory_id)
);

PROMPT Creating table ecs_exadata_cell_node
create table ecs_exadata_cell_node (
    inventory_id    VARCHAR2(512),
    local_storage_gb number  NOT NULL,
    cell_type       VARCHAR2(64)  NOT NULL,
    model           VARCHAR2(128)  NOT NULL,
    name            VARCHAR2(128)  NOT NULL,
    exadata_id      VARCHAR2(512),
    CONSTRAINT ecs_capacity_inventory_cell_fk
      FOREIGN KEY (inventory_id)
      REFERENCES ecs_exadata_capacity(inventory_id) on delete CASCADE
);


PROMPT Creating table ecs_exadata_entity
create table ecs_exadata_entity (
    exadata_formation_id   NUMBER,
    exadata_id VARCHAR2(512) not null, 
    CONSTRAINT ecs_exadata_entity_pk PRIMARY KEY (exadata_formation_id) 
);
PROMPT Creating sequence exadata_entity_seq
create sequence exadata_entity_seq;

PROMPT Creating table ecs_exadata_formation
create table ecs_exadata_formation (
    inventory_id    VARCHAR2(512) not null, 
    exadata_id      NUMBER not null,
    CONSTRAINT ecs_exadata_formation_fk 
      FOREIGN KEY (inventory_id) 
      REFERENCES ecs_exadata_capacity(inventory_id)
);

PROMPT Creating sequence ecs_scheduledjob_id_seq
create sequence ecs_scheduledjob_id_seq;

PROMPT Creating table ecs_diag_problem
create table ecs_diag_problem (
    id              NUMBER,
    start_time      TIMESTAMP,
    resolved_time   TIMESTAMP,      -- null if the problem is not resolved
    last_time       TIMESTAMP,      -- last occurred timestamp
    status          VARCHAR2(20),   -- analyzing / done
    scope_level     VARCHAR2(20),   -- cluster / hwrack / cabinet / controlplane
    scope_name      VARCHAR2(100),  -- name of cluster, hwrack, cabinet, or cp
    root_cause      VARCHAR2(500),
    CONSTRAINT ecs_diag_problem_pk PRIMARY KEY (id)
);

PROMPT Creating sequence ecs_diag_problem_id_seq
create sequence ecs_diag_problem_id_seq;

PROMPT Creating table ecs_diag_report
create table ecs_diag_report (
    problem_id      NUMBER,
    requested_time  TIMESTAMP,
    problem_json    CLOB,
    CONSTRAINT ecs_diag_report_pk PRIMARY KEY (problem_id, requested_time)
);

PROMPT Creating sequence ecs_diag_report_id_seq
create sequence ecs_diag_report_id_seq;

PROMPT Creating table ecs_diag_request
create table ecs_diag_request (
    id              NUMBER,
    status          VARCHAR2(20),
    tool_type       VARCHAR2(20),
    run_timestamp   TIMESTAMP,
    target          VARCHAR2(1000),
    res_output      CLOB,
    res_file        BLOB,
    res_file_ext    VARCHAR2(10),
    CONSTRAINT ecs_diag_request_pk PRIMARY KEY (id)
);

PROMPT Creating sequence ecs_diag_request_id_seq
create sequence ecs_diag_request_id_seq;

PROMPT Creating table ecs_diag_fault
create table ecs_diag_fault (
    id              NUMBER,
    problem_id      NUMBER,         -- -1: ignored, 0: unassigned, n>0: assigned
    severity        NUMBER,
    start_time      TIMESTAMP,
    resolved_time   TIMESTAMP,      -- null if the fault is not resolved
    last_time       TIMESTAMP,      -- last occurred timestamp
    status          VARCHAR2(20),
    fault_level     VARCHAR2(20),
    cabinet         VARCHAR2(50),
    hwrack          VARCHAR2(250),
    cluster_name    VARCHAR2(250),
    host            VARCHAR2(400),
    host_type       VARCHAR2(20),
    message         VARCHAR2(4000),
    required_action VARCHAR2(1000),
    extra_fields    VARCHAR2(2000),
    CONSTRAINT ecs_diag_fault_pk PRIMARY KEY (id),
    -- Set unique constraint to prevent ESscanner from putting duplicated faults
    -- ORA-00001 will be gracefully handled by ESscanner
    CONSTRAINT ecs_diag_fault_unq UNIQUE (start_time, host, message),
    CONSTRAINT ecs_diag_fault_fk FOREIGN KEY (problem_id)
      REFERENCES ecs_diag_problem(id) ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

PROMPT Creating sequence ecs_diag_fault_id_seq
create sequence ecs_diag_fault_id_seq;

PROMPT Creating table ecs_diag_fault_request
create table ecs_diag_fault_request (
    fault_id      NUMBER,
    request_id    NUMBER,
    direction     VARCHAR2(10),
    CONSTRAINT ecs_diag_fault_request_pk PRIMARY KEY (fault_id, request_id, direction),
    CONSTRAINT ecs_diag_fault_request_fid_fk FOREIGN KEY (fault_id)
      REFERENCES ecs_diag_fault(id) ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT ecs_diag_fault_request_tid_fk FOREIGN KEY (request_id)
      REFERENCES ecs_diag_request(id) ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT ecs_diag_fault_dir_chk
       CHECK (direction in ('F2R', 'R2F'))
);

PROMPT Creating table ecs_diag_rack_info
create table ecs_diag_rack_info (
    cabinet         VARCHAR2(250),
    hwrack          VARCHAR2(250),
    rack_name       VARCHAR2(250),
    status          VARCHAR2(30),
    host_type       VARCHAR2(20),
    host            VARCHAR2(400),
    dom0            VARCHAR2(400),  -- Used only for domu to specify xen host
    CONSTRAINT ecs_diag_rack_info_unq UNIQUE (cabinet, hwrack, rack_name, host)
);

PROMPT Creating table ecs_diag_rackxml_monitor
create table ecs_diag_rackxml_monitor (
    rack_name       VARCHAR2(250),
    status          VARCHAR2(20),
    action          VARCHAR2(20),
    updated         TIMESTAMP,
    CONSTRAINT ecs_diag_rackxml_monitor_pk PRIMARY KEY (rack_name)
);

PROMPT Creating table ecs_diag_logcol_history
create table ecs_diag_logcol_history (
    id              NUMBER,
    ecrauser        VARCHAR2(32),
    request_ts      TIMESTAMP,
    end_ts          TIMESTAMP,
    rack_name       VARCHAR2(256),
    status          VARCHAR2(32),
    input_json      CLOB,
    output_json     CLOB,
    run_log         CLOB,
    ecra_msg        VARCHAR2(512),
    CONSTRAINT ecs_diag_logcol_history_pk PRIMARY KEY (id)
);

PROMPT Creating sequence ecs_diag_logcol_history_id_seq
create sequence ecs_diag_logcol_history_id_seq;

-- begin Enh 32322406
PROMPT Creating index ecs_diag_logcol_hist_rack_idx
create index ecs_diag_logcol_hist_rack_idx
  on ecs_diag_logcol_history(rack_name);
-- end Enh 32322406

-- begin Enh 32322406
PROMPT Creating table ecs_diag_logcol_req_hist
create table ecs_diag_logcol_req_hist (
    id              NUMBER,
    ecrauser        VARCHAR2(32),
    status          VARCHAR2(32),
    request_ts      TIMESTAMP,
    rack_name       VARCHAR2(256),
    payload_json    CLOB,
    response_json   CLOB,
    timerange_start VARCHAR2(40),
    timerange_end   VARCHAR2(40),
    uuid            CHAR(36),
    CONSTRAINT ecs_diag_logcol_req_hist_pk PRIMARY KEY (id)
);

PROMPT Creating sequence ecs_logcol_req_hist_id_seq
create sequence ecs_logcol_req_hist_id_seq;
-- end Enh 32322406

PROMPT Creating table ecs_diag_stats
create table ecs_diag_stats (
    collect_time    TIMESTAMP,
    metric_name     VARCHAR2(32),
    collect_from    VARCHAR2(128),
    value           NUMBER not null,
    CONSTRAINT ecs_diag_stats_pk PRIMARY KEY (collect_time, metric_name, collect_from)
);

PROMPT Creating table ecs_diag_ignore_target
create table ecs_diag_ignore_target (
    id              NUMBER,
    pattern         VARCHAR2(256),
    type            VARCHAR2(32),
    CONSTRAINT ecs_diag_ignore_target_pk PRIMARY KEY (id)
);

PROMPT Creating sequence ecs_diag_ignore_target_id_seq
create sequence ecs_diag_ignore_target_id_seq;

PROMPT Creating table ecs_cos_pool
create table ecs_cos_pool  (    
    pool_id         NUMBER NOT NULL,
    pool_size       NUMBER,
    subfactor       NUMBER,
    exaservice_id   VARCHAR2(512),
    CONSTRAINT ecs_cos_pool_pk PRIMARY KEY (pool_id),
    CONSTRAINT ecs_cos_pool_fk FOREIGN KEY (exaservice_id)
      REFERENCES ecs_exaservice(id) ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

PROMPT Creating sequence ecs_cos_pool_seq
create sequence ecs_cos_pool_seq;

Rem --- Start Gen2 cloud -----

Rem Queries/Actions that we want to answer from these tables
Rem Query 1: Show me the available capacity
Rem   select count(ehn.id)/REGEXP_SUBSTR(:NODE_CONSTRAINT, '(\d+)comp',1,1,'i',1)
Rem   from ecs_hw_nodes ehn
Rem   where ehn.node_type = 'COMPUTE'
Rem   and ehn.cluster_size_constraint = :NODE_CONSTRAINT
Rem   and ehn.node_state = 'FREE'
Rem   and ((ehn.node_model = :MODEL and :MODEL is not null) or (1=1 and :MODEL is null))
Rem   group by ehn.cabinet_id, ehn.ib_fabric_id, ehn.node_model;
Rem
Rem   Where the bind variables have to be provided to the query
Rem    :NODE_CONSTRAINT can have values '12cell8comp3ibsw2pdu1ethsw',
Rem                                     '6cell4comp3ibsw2pdu1ethsw',
Rem                                     '3cell2comp3ibsw2pdu1ethsw', 
Rem                                     'half_3cell2comp3ibsw2pdu1ethsw'
Rem    :MODEL can be 'X6-2' or 'X7-2'
Rem      If the model is immeterial, the above query to be changed as 

Rem  Query/Action 2: Composing a  cluster
Rem   It has two parts: 
Rem   1. Begin composing a cluster. It reserves the required hw nodes.
Rem   Run the following query to begin composing a quarter rack cluster
Rem   select * from table(ecs_pkg.ecs_compose_cluster_begin
Rem                          ('3cell2comp3ibsw2pdu1ethsw','X6-2', 'AD1'));
Rem   This query will carve out the nodes from the available capacity and
Rem   returns a JSON with the node details and temporary ecs_racke_name.
Rem
Rem   2. End composing a cluster. Depending on the ECRA actions after the begin
Rem      composing cluster step, ECRA may want to rollback or commit the cluster
Rem      compose action. So this call will provide the functionality to commit or
Rem      rollback.
Rem      run the following query to end composing cluster
Rem      select * from table(ecs_pkg.ecs_compose_cluster_end
Rem         ( '3cell2comp3ibsw2pdu1ethsw',  'old_ecs_racks_name'.
Rem            'new_ecs_racks_name', 
Rem            'comma separated oracle_admin_hostname list',
Rem            'comma seprated nat_ip list',
Rem            'COMMIT'
Rem         ));
Rem
Rem      where old_ecs_racks_name =  clusters.temporary_ecs_rack_name_pick_ of JSON from
Rem            the previous step
Rem            comma separated oracle_admin_hostname list values can be gotten from
Rem            the previous step JSON result clusters.nodes[1..2].oracle_hostname_pick_
Rem            comma seprated nat_ip list has to be provided by ECRA.
Rem      This query will return a result of the end compose cluster in JSON format.
Rem
Rem      After the Begin compose cluster if one wants to rollback the action, run the
Rem      cluster end step wih the 'ROLLBACK' argument as shown below:
Rem      select * from table(ecs_pkg.ecs_compose_cluster_end
Rem         ( '3cell2comp3ibsw2pdu1ethsw',  'old_ecs_racks_name'.
Rem            'new_ecs_racks_name', 
Rem            'comma separated oracle_admin_hostname list',
Rem            'comma seprated nat_ip list',
Rem            'ROLLBACK'
Rem         ));
Rem      
Rem  Query to get the cavium ids for a given cluster. Results is in JSON format
Rem   select * from table(ecra.ecs_get_cluster_info('<ecs_racks_name>', 'INDEX_BY_CAVIUMS'));
Rem   example : 
Rem     select * from table(ecra.ecs_get_cluster_info('scam07-qr-1', 'INDEX_BY_CAVIUMS'));
Rem
Rem  Query to get the given cluster''s info. Results is in JSON format
Rem   select * from table(ecra.ecs_get_cluster_info('<ecs_racks_name>', 'ALL'));
Rem

-- begin: bug 26751817
Rem  ecs_generation_types
Rem    Holds all kinds of the cloud types where the ExaData hardware is used
Rem    
Rem    name - 
Rem      Primary Key
Rem
Rem      At present following types are seeded
Rem      BMC - Bare Metal Cloud (or gen2)
Rem      GEN1 - As the name suggests
Rem      AD - Availability Domain evolution of Gen1 
Rem      EXACM - ExaData Cloud Machine
Rem
PROMPT Creating tablem ecs_generation_types
create table ecs_generation_types
(   name       varchar2(256) not null,
    CONSTRAINT ecs_generation_types_pk PRIMARY KEY (name)
);

-- end: bug 26751817

Rem  ecs_hw_cabinets
Rem    The physical shipment that comes from the factory.
Rem    Capture the various manufacturing models such as X6-2 expansion, ZDLRA etc.
Rem    Populated by add-a-cabinet functionality
Rem
Rem    id -
Rem      Primary key
Rem    name -
Rem      Unique key
Rem      Constructed using the Availability Domain(AD) (aka data center), tile row, tile column
Rem      Example: for AD = SCA, tile row = qab, tile column 09, the cabinet name becomes "scaqab09"
Rem      AD, tile row and tile column is provided by the  DBaaS Control Plane call to add a cabinet.
Rem    availability_domain -
Rem      As the name says it represents the data center aka availability domain. 
Rem      provided by the  DBaaS Control Plane call to add a cabinet.
Rem    cage_id - 
Rem      Cage is what the data center people call "cage". For example all the
Rem      cabinets exclusive use for Govt business may be cordoned off in a physical
Rem      secure section - that actually looks like a metal cage - in the data center.
Rem      It becomes important when we may have to make sure clusters for such "cagey"
Rem      customers come from suitable cage.
Rem    model -
Rem      The short name used typically by OEDA to identify the hardware type such as Exadata X6-2 Elastic
Rem      Provided by the DBaaS Control Plane call to add a cabinet.
Rem    cluster_list_constraint -
Rem      Constraints the cabinet to the given node mix of clusters.
Rem      For example if 3cell2comp3ibsw2pdu1ethsw given, this cabinet can only
Rem      clusters with 3 cell 3 compute 3 ibsw 2 pdus and 1 ethersw.
Rem      Provided by the DBaaS Control Plane call to add a cabinet.
Rem      Examples:
Rem        Full: 12cell8comp3ibsw2pdu1ethsw - 12 cells, 8 compute, 3 IB switches, 2 PDU s, 1 Ethernet switch
Rem        Half: 6cell4comp3ibsw2pdu1ethsw - 12 cells, 8 compute, 3 IB switches, 2 PDU s, 1 Ethernet switch
Rem        Quarter: 3cell2comp3ibsw2pdu1ethsw - 3 cells, 2 compute, 3 IB switches, 2 PDU s, 1 Ethernet switch
Rem        Eighth: half_3cell2comp3ibsw2pdu1ethsw - for 8th Rack Exadata
Rem    time_zone - the timezone to be same for all the nodes in a hardware
Rem      cluster. So we have this column here
Rem    domainname - 
Rem      to be same for all the nodes in a hardware so that they can be accessed via
Rem      fully qualified hostnames
Rem
Rem    subnet_id-
Rem       subnet id of the cabinet if one given, else VCN subnet is Used
Rem       format is 
Rem         '255.255.240.0|DNS:8.8.8.8,8.8.4.4|NTP:169.254.0.3|GATEWAY:10.0.1.1'
Rem
Rem    product -
Rem      Product serviced from this hardware cabinet
Rem      Valid values are:
Rem      exd for Exadata
Rem      exl for ExaLogic
Rem      zdl for ZDLRA
Rem      bds for bdcs
Rem      oda for ODA
Rem      scl for SuperCluster
Rem
Rem    generation_type - 
Rem      What kind of cloud generation to which this cabinet belongs
Rem
Rem    TODO: Should the node list be normalized into different columns like:
Rem      cell_count            number(6,1) not null,
Rem      compute_count         number(6,1) not null,
Rem      IB_switch_count       number(3) not null,
Rem      PDU_count             number(3) not null,
Rem      Ethernet_switch_count number(3) not null,
Rem    Answer: Yes and NO. 
Rem       Yes, it would make it more readable. No, because, it will account for the 
Rem       changes coming from the newer versions of the Exadata. For example the distiction
Rem       betwen Compute and cell may merge into one. Hence, for now we will go with the 
Rem       entries shown in the example above. 

PROMPT Creating sequence ecs_hw_cabinets_seq_id
create sequence ecs_hw_cabinets_seq_id nocache nocycle order;

PROMPT Creating table ecs_hw_cabinets
create table ecs_hw_cabinets(
    id                      number            not null,
    name                    varchar2(256)     not null,
    availability_domain     varchar2(256)     not null,
    fault_domain            varchar2(256),
    cage_id                 varchar2(256)     not null,
    model                   varchar2(512)     not null,
    cluster_size_constraint varchar2(512)     not null,
    time_zone               varchar2(256)     not null, 
    domainname              varchar2(512)     not null,
    subnet_id               varchar2(4000)    not null,
    product                 varchar2(256)     not null,
    -- begin: bug 26751817
    generation_type         varchar2(256)     default 'BMC' not null,
    CONSTRAINT ecs_hw_cabinets_usg_typ_fk 
      FOREIGN KEY (generation_type)
      REFERENCES ecs_generation_types(name) deferrable initially deferred,
    -- end: bug 26751817
    CONSTRAINT ecs_hw_cabinets_pk PRIMARY KEY (id),
    CONSTRAINT ecs_hw_cabinets_name UNIQUE (name)
);

PROMPT Creating index ecs_hw_cabinets_usg_typ_fkidx
create index ecs_hw_cabinets_usg_typ_fkidx 
  on ecs_hw_cabinets(generation_type);

-- begin: bug 26751817
Rem ecs_hw_cabinet_alerts
Rem   Information about the alerts where to send and how to send
Rem   This belongs at the cabinet level
Rem
Rem   cabinet_id   - Cabinet to which this alert belongs to
Rem   alert_type   - From where this alert is orginated, cell, compute, ib, pdu 
Rem                  or ethersw
Rem   protocol     - SNMP or SMTP
Rem   from_address - Senders address
Rem   to_address   - To whom it is addressed to
Rem   from_text    - From text
Rem   server_name  - server where this alert has to be sent
Rem   server_port  - server port
Rem   auth_n_encrypt_mode - SSL, TLS, SASL and so on
Rem
PROMPT Creating table ecs_hw_cabinet_alerts
create table ecs_hw_cabinet_alerts
( cabinet_id    number         not null,
  alert_type    varchar2(50)   default 'CELL' not null,
  --
  server_name   varchar2(4000) not null,
  server_port   number         not null,
  auth_n_encrypt_mode varchar2(256),
  --
  protocol      varchar2(50)   default 'SMTP' not null,
  --
  from_address  clob,
  to_address    clob,
  from_text     varchar2(4000),
  --
  community     varchar2(256),
  CONSTRAINT ecs_hw_cabinet_alerts_pk 
    PRIMARY KEY (cabinet_id, alert_type, protocol),
  CONSTRAINT ecs_hw_cab_alrts_cid_fk FOREIGN KEY (cabinet_id)
    REFERENCES ecs_hw_cabinets(id) deferrable initially deferred,
  CONSTRAINT ecs_hw_cabinet_alerts_type_ck 
      CHECK (alert_type in ('CELL', 'COMPUTE', 'IBSW', 'ROCE',
                            'PDU', 'ETHERSW', 'SPINESW')),
  CONSTRAINT ecs_hw_cabinet_alerts_prtcl_ck 
      CHECK (protocol in ('SMTP', 'SNMP')),
  CONSTRAINT ecs_hw_cabinet_alrt_frm_to_ck
      CHECK (( protocol = 'SMTP' 
              and from_address is not null
              and to_address   is not null
            )
            or
            ( protocol = 'SNMP'
              and from_address is null
              and to_address   is null
            )) 
);

PROMPT Creating index ecs_hw_cab_alrts_cid_fk_idx
create index ecs_hw_cab_alrts_cid_fk_idx 
  on ecs_hw_cabinet_alerts(cabinet_id);
-- end: bug 26751817

Rem  ecs_ib_fabrics
Rem    List of the IB fabrics. There is one per cabinet for non interconnected cabinets.
Rem    Populated by add-a-cabinet and kept up to date by each provision and patch
Rem    Used to constrain the nodes making a cluster come from same IB fabric
Rem
Rem    id -  
Rem      Primary key
Rem    fabric_sha512 -
Rem      hash based on concatenated sorted IB switch names as seen from output of ibswicthes command.
Rem      Populated by add-a-cabinet and kept up to date by each provision and patch
Rem    list_of_ibsw -
Rem      List of node id s from ecs_hw_nodes for the IB switches making this fabric.
Rem      Populated by add-a-cabinet and kept up to date by each provision and patch
Rem
PROMPT Creating sequence ecs_ib_fabrics_seq_id
create sequence ecs_ib_fabrics_seq_id nocache nocycle order;

PROMPT Creating table ecs_ib_fabrics
create table ecs_ib_fabrics(
    id  number                   not null,
    fabric_name   varchar2(1024),
    fabric_sha512 varchar2(1024) not null,
    list_of_ibsw  clob           not null,
    last_used_cib_ip_octet_1     number default 1 not null,
    last_used_cib_ip_octet_2     number default 132 not null,
    last_used_cib_ip_octet_3     number default 168 not null,
    last_used_cib_ip_octet_4     number default 192 not null,
    last_used_stib_ip_octet_1     number default 1 not null,
    last_used_stib_ip_octet_2     number default 136 not null,
    last_used_stib_ip_octet_3     number default 168 not null,
    last_used_stib_ip_octet_4     number default 192 not null,
    CONSTRAINT ecs_ib_fabrics_pk PRIMARY KEY (id),
    CONSTRAINT ecs_ib_fabrics_cib_range_ck CHECK
      (last_used_cib_ip_octet_2 between 132 and 135
       and last_used_cib_ip_octet_1 between 0 and 254
       and last_used_cib_ip_octet_3 = 168 
       and last_used_cib_ip_octet_4 = 192),
    CONSTRAINT ecs_ib_fabrics_stib_range_ck CHECK
      (last_used_stib_ip_octet_2 between 136 and 143
       and last_used_stib_ip_octet_1 between 0 and 254
       and last_used_stib_ip_octet_3 = 168 
       and last_used_stib_ip_octet_4 = 192)
);

Rem  ecs_hw_nodes
Rem    List of the hardware nodes
Rem    This is the main table for capacity inventory.
Rem    Populated by add-a-cabinet functionality.
Rem
Rem    id - 
Rem      Primary key
Rem    cabinet_id -
Rem      Refers to ecs_hw_cabinets.id
Rem      Populated by add-a-cabinet
Rem    ib_fabric_id -
Rem      Refers to the ecs_ib_fabrics.id
Rem      Initially populated by add-a-cabinet
Rem   ecs_racks_name_list -
Rem      Is NULL when node is not provisioned
Rem      Refers to ecs_racks.name provisioned, A comma separated values of names forming 
Rem      the cluster.
Rem      Populated at customer provision
Rem      Value looks like |domuname1|domuname2|domuname3|
Rem    node_type -
Rem      For Exadata cabinets: cell, compute, ibsw, pdu, ethersw
Rem    node_model -
Rem      For Exadata X6-2, X7-2
Rem        Even if this is redundant with the ecs_hw_cabinets.sku, it is more efficient to have it here.
Rem      Populated by add-a-cabinet
Rem    sw_version -
Rem      For Exadata, the Exadata image version such as 12.1.2.3.4.170111
Rem      Initially populated by add-a-cabinet, kept up to date by customer provision and patching
Rem    date_updated -
Rem      Date of last update of data.
Rem      Initially populated by add-a-cabinet, kept up to date by customer provision and patching
Rem      Used for ensuring currency of the data before use.
Rem    oracle_ip -
Rem      Oracle Admin network IP address for eth0
Rem      Initially populated by add-a-cabinet
Rem    oracle_hostname -
Rem      Oracle Admin network fully qualified hostname for eth0
Rem      Initially populated by add-a-cabinet
Rem    oracle_ilom_ip -
Rem      Oracle ilom network IP address
Rem      Initially populated by add-a-cabinet
Rem    oracle_ilom_hostname -
Rem      Oracle Admin ilom fully qualified hostname
Rem      Initially populated by add-a-cabinet
Rem    location_rackunit -
Rem      The rack unit in the cabinet where the node is physically located.
Rem      Initially populated by add-a-cabinet
Rem      Used at customer provision to select the nodes to make the cluster. Nodes with lower rackunit
Rem      get chosen first.
Rem        This sequencing will be tweaked based on current Gen1 operations input
Rem    node_type_order_bottom_up -
Rem      this will be used for cells and computes - 
Rem       cells bottom to top numbered 1 to count of total cells in the cabinet
Rem       and the computes the same way 1 to count of total computes in the cabinet.
Rem    cluster_size_constraint -
Rem      Restrics this node to be part of a cluster of certain node mix such as a quarter cluster.
Rem      The values used are same as the ecs_hw_cabinets.node_list.
Rem      Initially populated by add-a-cabinet using directive from DBaaSCP to do so.
Rem
Rem    node_state -
Rem      Current state of the node.
Rem      Possible values are : FREE, COMPOSING, ALLOCATED, HW_REPAIR, HW_UPGRADE, HW_FAIL 
Rem    ib[12]_* -
Rem      IB interface properties
Rem 
Rem    higgs_bond0_* - 
Rem      In higgs env all the interfaces except for eth0 are bonded into one 
Rem      bondeth0 and this colum stores the IP for that bonded ethface
Rem      All the related info go here.
Rem
Rem    TODO:
Rem      Next iteration - not this round.
Rem      Add node_operation_state - this is states of maintenance
Rem      We will use node_state for its non maintenance states.
Rem      The life of a hardware node
Rem
PROMPT Creating sequence ecs_hw_nodes_seq_id
create sequence ecs_hw_nodes_seq_id nocache nocycle order;
PROMPT Creating sequence ecs_hw_nodes_seq_clu_hw_id
create sequence ecs_hw_nodes_seq_clu_hw_id nocache nocycle order;

PROMPT Creating table ecs_hw_nodes
create table ecs_hw_nodes(
    id                        number        not null,
    cabinet_id                number        not null,
    ib_fabric_id              number        not null,
    ecs_racks_name_list       varchar2(4000),
    node_type                 varchar2(256) not null,
    node_model                varchar2(256) not null, 
    sw_version                varchar2(256) not null,
    date_modified timestamp   default systimestamp not null,
    oracle_ip                 varchar2(256) not null,
    oracle_hostname           varchar2(256) not null,
    oracle_ilom_ip            varchar2(256),
    oracle_ilom_hostname      varchar2(256),
    location_rackunit         number(3)     not null,
    node_type_order_bottom_up number(3)     not null, 
    cluster_size_constraint   varchar2(256),
    node_state                varchar2(32) default 'FREE' not null,
    -- begin: bug 26751817
    ib1_hostname              varchar2(256),
    ib1_ip                    varchar2(256),
    ib1_domain_name           varchar2(256),
    ib1_netmask               varchar2(256),
    ib2_hostname              varchar2(256),
    ib2_ip                    varchar2(256),
    ib2_domain_name           varchar2(256),
    ib2_netmask               varchar2(256),
    higgs_bond0_ip            varchar2(256), 
    higgs_bond0_hostname      varchar2(256), 
    higgs_bond0_netmask       varchar2(256),
    higgs_bond0_gateway       varchar2(256),
    -- end: bug 26751817
    CONSTRAINT ecs_hw_nodes_pk PRIMARY KEY (id),
    CONSTRAINT ecs_hw_nodes_cabinet_id_fk 
      FOREIGN KEY (cabinet_id)
      REFERENCES ecs_hw_cabinets(id) deferrable initially deferred,
    CONSTRAINT ecs_hw_nodes_ib_fabric_id_fk
      FOREIGN KEY (ib_fabric_id)
      REFERENCES ecs_ib_fabrics(id) deferrable initially deferred,
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
              'other')),
    CONSTRAINT ck_ecs_hw_nodes_node_type 
      CHECK (node_type in ('CELL', 'COMPUTE', 'IBSW', 'ROCESW', 
                           'SPINESW', 'PDU', 'ETHERSW')),
    CONSTRAINT ck_ecs_hw_nodes_node_state 
      CHECK (node_state in ('FREE', 'COMPOSING', 'ALLOCATED', 'HW_REPAIR', 
                            'HW_UPGRADE', 'HW_FAIL')),
    CONSTRAINT ck_ecs_hw_nodes_ilom_ip CHECK
    (( /* if not null, node type should be 'CELL', 'COMPUTE' */
          oracle_ilom_ip is not null
      and node_type in ('CELL', 'COMPUTE')
    )
    or
    ( /* if null node type should be ''IBSW', 'PDU', 'ETHERSW' */
          oracle_ilom_ip is null
      and node_type in ('IBSW', 'ROCESW', 'SPINESW', 'PDU', 'ETHERSW')
    )),
    CONSTRAINT ck_ecs_hw_nodes_ilom_hostname CHECK
    (( /* if not null, node type should be 'CELL', 'COMPUTE' */
          oracle_ilom_hostname is not null
      and node_type in ('CELL', 'COMPUTE')
    )
    or
    ( /* if null node type should be ''IBSW', 'PDU', 'ETHERSW' */
          oracle_ilom_hostname is null
      and node_type in ('IBSW', 'ROCESW', 'SPINESW', 'PDU', 'ETHERSW')
    )),
    CONSTRAINT ck_ecs_hw_nodes_ib_info CHECK
    (( node_type in ('CELL', 'COMPUTE')
       and ib1_hostname    is not null
       and ib1_ip          is not null
       and ib1_domain_name is not null
       and ib1_netmask     is not null
       and ib2_hostname    is not null
       and ib2_ip          is not null
       and ib2_domain_name is not null
       and ib2_netmask     is not null
     )
     or
     ( node_type in ('IBSW', 'ROCESW', 'SPINESW', 'PDU', 'ETHERSW')
       and ib1_hostname    is  null
       and ib1_ip          is  null
       and ib1_domain_name is  null
       and ib1_netmask     is  null
       and ib2_hostname    is  null
       and ib2_ip          is  null
       and ib2_domain_name is  null
       and ib2_netmask     is  null
     )
    )
);

Rem NOTE : every FOREIGN key should be backed by its own index
Rem        Else, during the parent record delete the child table gets locked instead
Rem        of the child records.
Rem
PROMPT Creating index ecs_hd_nodes_cabnt_id_fk_idx
create index ecs_hd_nodes_cabnt_id_fk_idx 
  on ecs_hw_nodes(cabinet_id);

PROMPT Creating index ecs_hw_nodes_ibfbrcid_fk_idx
create index ecs_hw_nodes_ibfbrcid_fk_idx
  on ecs_hw_nodes(ib_fabric_id);

PROMPT Creating index ecs_hw_nodes_ern_idx
create index ecs_hw_nodes_ern_idx
  on ecs_hw_nodes(ecs_racks_name_list);

PROMPT Creating index ecs_hw_nodes_ohn_idx
create index ecs_hw_nodes_ohn_idx
  on ecs_hw_nodes(oracle_hostname);

Rem  ecs_ib_pkeys_used
Rem    Inventory of the IB pkeys in use
Rem    Populated and kept up to date by each ecra.ecs_compose_cluster_begin
Rem    Used to ensure new pkeys do not conflict with existing pkeys
Rem    At present for every cluster two rows are added to this table
Rem      One for the COMPUTE and one for the STORAGE
Rem    TODO : Need to handle the case where two clusters sharing the same storage.
Rem           One example is the eighth rack configuration.
Rem   
Rem    ib_fabric_id -
Rem      Refers to ecs_ib_fabrics.id
Rem    pkey -
Rem      Pkey
Rem    ecs_racks_nMe
Rem      Refers to ecs_racks.name. 
Rem    pkey_use -
Rem      Storage pkey(STORAGE) or Compute pkey(COMPUTE) 
Rem
PROMPT Creating table ecs_ib_pkeys_used
create table ecs_ib_pkeys_used
(   ib_fabric_id          number        not null,
    pkey                  varchar2(6)   not null,
    ecs_racks_name        varchar2(256) not null,
    pkey_use              varchar2(256) not null,
    CONSTRAINT ecs_ib_pkeys_used_pk PRIMARY KEY 
      (ecs_racks_name, pkey_use),
    CONSTRAINT ecs_ib_pkeys_used_fk FOREIGN KEY (ecs_racks_name)
      REFERENCES ecs_racks(name) deferrable initially deferred,
    CONSTRAINT ecs_ib_fabrics_id_fk FOREIGN KEY (ib_fabric_id) 
      REFERENCES ecs_ib_fabrics(id) deferrable initially deferred,
    CONSTRAINT ecs_ib_pkeys_used_ck CHECK (pkey_use in ('STORAGE', 'COMPUTE'))
);

Rem 
Rem Exadata  PKEY ranges
Rem compute - 0xa000 to 0xa9ff  (0 - 2559 decimal)
Rem storage - 0xaa00 to 0xafff  (0 - 4095 decimal)
Rem
Rem When multiple clusters on same hardware set our logic for pkey will need to change 
Rem  the storage pkey will be same for 2 such clusters because cells don't support 
Rem  more than one pkey. Only computes do. 
Rem
Rem TODO :The logic of selecting existing storage pkey from the cells that already 
Rem  have a storage pkey. This will be a trick look up as we don't store anything 
Rem  but the ecs_rack_name in pkey table. Not worth implementing right now. 
Rem  But will do shortly after the drop as we need it internally for multiple 
Rem  clusters we do for development.
Rem
 
PROMPT Creating sequence ecs_ib_compute_pkeys_seq_id
create sequence ecs_ib_compute_pkeys_seq_id 
  start with 40960 -- 0xa000
  increment by 1
  minvalue 40960
  maxvalue 43519   -- 0xa9ff
nocache nocycle order;

PROMPT Creating sequence ecs_ib_storage_pkeys_seq_id
create sequence ecs_ib_storage_pkeys_seq_id 
  start with 43520  -- 0xaa00
  increment by 1
  minvalue 43520
  maxvalue 45055    -- 0xafff
nocache nocycle order;

Rem  ecs_caviums
Rem    Map of Cavium to Ether interfaces of hw nodes
Rem    Used for provision.
Rem
Rem    hw_node_id -
Rem      Refers to ecs_hw_nodes.id
Rem    cavium_id -
Rem      Cavium id
Rem      Populated by add-a-cabinet using data from DBaaSCP
Rem      Example: "ocid1.port.integ-next.integ-next.abuw4ljrtbuftyuraujsapcukd3c2meokzuu3idpnz2evaghrclxiyo576ea"
Rem    etherface -
Rem      Ether interface such as eth5
Rem      Populated by add-a-cabinet using data from DBaaSCP
Rem    MAC -
Rem      MAC for etherface
Rem      Populated by add-a-cabinet
Rem    etherface_type -
Rem      Relates the given etherface to a type such 
Rem      as 'DB_CLIENT', 'DB_BACKUP', 'ORACLE_ADMIN', 'CUSTOMER_ADMIN', 'OTHER'
Rem
PROMPT Creating table ecs_caviums
create table ecs_caviums
(   hw_node_id number         not null,
    cavium_id  varchar2(4000) not null, 
    etherface  varchar2(256)  not null,
    MAC        varchar2(256)  not null,
    etherface_type varchar2(256) not null,
    CONSTRAINT ecs_caviums_node_id_fk FOREIGN KEY (hw_node_id) 
      REFERENCES ecs_hw_nodes(id) deferrable initially deferred,
    CONSTRAINT ecs_caviums_eface_type_ck 
      CHECK (etherface_type in 
             ('DB_CLIENT', 'DB_BACKUP', 'ORACLE_ADMIN', 
              'CUSTOMER_ADMIN', 'OTHER'))
);

PROMPT Creating index ecs_caviums_node_id_fk_idx
create index ecs_caviums_node_id_fk_idx
  on ecs_caviums(hw_node_id);

Rem ecs_vcns
Rem  List of VCNs
Rem 
Rem    id -
Rem      Given by VNC control plane
Rem    availability_domain -
Rem      As the name says
Rem    subnet_id - 
Rem      One large subnet from which one can carve out the IPs
Rem    generation_type -
Rem      BMC, HIGGS, AD or GEN1
Rem      
PROMPT Creating table ecs_vcns
create table ecs_vcns
( id                  varchar2(4000) not null,
  availability_domain varchar2(256)  not null,
  subnet_id           varchar2(4000) not null,
-- begin: bug 26751817
  generation_type            varchar2(256)  not null,
  CONSTRAINT ecs_vcns_vcn_typ_fk 
      FOREIGN KEY (generation_type)
      REFERENCES ecs_generation_types(name) deferrable initially deferred,
-- end: bug 26751817
  CONSTRAINT ecs_vcns_pk PRIMARY KEY (id)
);
PROMPT Creating index ecs_vcns_vcn_typ_fk_idx
create index ecs_vcns_vcn_typ_fk_idx on ecs_vcns(generation_type);

Rem  ecs_oracle_admin_subnets
Rem    List of subnets within the Oracle Admin VCN if and when we want to 
Rem      isolate the Oracle Admin
Rem      for hardware hosting the clusters.
Rem    Populated by compose cluster. Adds a row cluster
Rem
Rem    vcn_id -
Rem      The Oracle admin VCN id
Rem    subnet_id -
Rem      Oracle admin subnet_id per cluster. A subset in the given 
Rem      vnc_id/subnet_id.
Rem      If manually adding a cabinet, this column holds the data about the 
Rem      DNS, NTP and size of the subnet. 
Rem      Example value : 
Rem        '255.255.240.0|DNS:8.8.8.8,8.8.4.4|NTP:169.254.0.3|GATEWAY:10.0.1.1'
Rem      If added via 'addCabinet' call, it will have the subnet_id given by the
Rem       ECRA/DBasS.
Rem      In such case it is used to query the VCN control plane using
Rem      VCN id and subnet ID to get the actual subnet, DNS and NTP.
Rem 
Rem      During compose cluster the list of DNS and NTP has to be broken into
Rem      DNS1, DNS2, DNS3, NTP1, NTP2, NTP3 tokens as OEDA expects them like that. It
Rem      do not expect an array of DNS or NTP.
Rem    ecs_racks_name -
Rem      Refers to ecs_racks.name. 
Rem
PROMPT Creating table ecs_oracle_admin_subnets
create table ecs_oracle_admin_subnets
(   vcn_id         varchar2(4000) not null,
    subnet_id      varchar2(4000) not null,
    ecs_racks_name varchar2(256)  not null ,
    CONSTRAINT ecs_oracle_admin_subnets_fk FOREIGN KEY(vcn_id) 
      REFERENCES ecs_vcns(id) deferrable initially deferred,
    CONSTRAINT ecs_oracle_admin_subnets_fk1 FOREIGN KEY(ecs_racks_name) 
      REFERENCES ecs_racks(name) deferrable initially deferred
);
PROMPT Creating index ecs_orcl_adm_subnets_fk_idx
create index ecs_orcl_adm_subnets_fk_idx
  on ecs_oracle_admin_subnets(vcn_id);
PROMPT Creating index ecs_orcl_adm_subnets_fk1_idx
create index ecs_orcl_adm_subnets_fk1_idx
  on ecs_oracle_admin_subnets(ecs_racks_name);

Rem ecs_domus
Rem   List of DOMUs belonging to a cluster and their details
Rem   
Rem   Populated during the composeClusterEnd
Rem
Rem   ecs_racks_name -
Rem     Refers to ecs_racks.name. 
Rem   hw_node_id -
Rem     Refers to ecs_hw_nodes.id
Rem     
Rem   db_client_mac -
Rem     DOMU db client  MAC. uniquely generated during compose cluster begin
Rem                          if ExaCloud provides it during compose cluster end
Rem                          time, it is updated with that data.
Rem   db_backup_mac -
Rem     DOMU db backup MAC. uniquely generated during compose cluster begin
Rem                          if ExaCloud provides it during compose cluster end
Rem                          time, it is updated with that data.
Rem
Rem   gateway_adapter-
Rem   hostname_adapter-
Rem     out of multiple networks - which one will be used for the default gateway.
Rem     It determines the default traffic route for the non direct attached 
Rem     networks.
Rem
Rem   admin_* - 
Rem     eth1 on domus are used for the administation from the Oracle side.
Rem     These columns host the details of that interface.
Rem   admin_network_type - 
Rem     tells if the given admin network is of NAT kind or not In BMC it 
Rem     is of NAT types and rest are  NON-NAT types.
Rem
Rem   db_client_* -
Rem     These columns list the customer admin, vip network info 
Rem
Rem   db_backup_* -
Rem     These columns list the customer backup network info 
Rem
Rem   compute_ib_* -
Rem     Information about the interfaces which interconnect the the domus to
Rem     the other domus over IB, i.e, compute nodes interconnection.
Rem
Rem   storage_ib_* -
Rem     Information about the interfaces which interconnect the the domus to
Rem     the storage cells over IB
Rem
Rem   vm_* - 
Rem     VM size info like mem, cpu and disk 
Rem 
Rem   NOTES :
Rem     This table can be used to answer following queries
Rem     a. Given a domu_name get cavium ids  and etherfaces
Rem     b. Given a domu_name get the oracle admin net info
Rem
Rem    How NAT ip/host used: the admin of DOMU is now through the NAT ip which is just
Rem      a secondary ip on eth0/vmeth0 of DOM0. And eth0 is oracle admin so sits
Rem      behind the in cabinet ether switch that sits behind the special bridge VNIC
Rem      cavium that takes no MAC
Rem
Rem    The admin* columns could be combined with admin_nat* columns with an extra
Rem    column with the type = NAT or NON-NAT. But for now keeping it separate.
Rem
PROMPT Creating table ecs_domus
create table ecs_domus
( ecs_racks_name       varchar2(256) not null, 
  hw_node_id           number        not null,
  db_client_mac        varchar2(256) ,
  db_backup_mac        varchar2(256) ,
  -- begin: bug 26751817
  gateway_adapter  varchar(50) default 'CLIENT' not null,
  hostname_adapter varchar(50) default 'CLIENT' not null,
  --
  admin_ip           varchar2(256), 
  admin_host_name    varchar2(512) not null,
  admin_netmask      varchar2(256),
  admin_domianname   varchar2(512),
  admin_vlan_tag     number,
  admin_gateway      varchar2(256),
  admin_network_type varchar2(256) default 'NAT' not null,
  --
  db_client_ip         varchar2(256), 
  db_client_host_name  varchar2(512),
  db_client_netmask    varchar2(256),
  db_client_domianname varchar2(512),
  db_client_vlan_tag   number,
  db_client_gateway    varchar2(256),
  --
  db_client_master_interface  varchar2(256),
  db_client_slave_interface_1 varchar2(256),
  db_client_slave_interface_2 varchar2(256),
  --
  db_client_vip            varchar2(256), 
  db_client_vip_host_name  varchar2(512),
  db_client_vip_netmask    varchar2(256),
  db_client_vip_domianname varchar2(512),
  db_client_vip_vlan_tag   number,
  db_client_vip_gateway    varchar2(256),
  --
  db_backup_ip         varchar2(256), 
  db_backup_host_name  varchar2(512),
  db_backup_netmask    varchar2(256),
  db_backup_domianname varchar2(512),
  db_backup_vlan_tag   number,
  db_backup_gateway    varchar2(256),
  --
  db_backup_master_interface  varchar2(256),
  db_backup_slave_interface_1 varchar2(256),
  db_backup_slave_interface_2 varchar2(256),
  --
  compute_ib1_ip         varchar2(256),
  compute_ib1_host_name  varchar2(256),
  compute_ib1_netmask    varchar2(256),
  compute_ib1_domianname varchar2(512),
  compute_ib1_gateway    varchar2(256),
  --
  compute_ib2_ip         varchar2(256),
  compute_ib2_host_name  varchar2(256),
  compute_ib2_netmask    varchar2(256),
  compute_ib2_domianname varchar2(512),
  compute_ib2_gateway    varchar2(256),
  --
  storage_ib1_ip         varchar2(256),
  storage_ib1_host_name  varchar2(256),
  storage_ib1_netmask    varchar2(256),
  storage_ib1_domianname varchar2(512),
  storage_ib1_gateway    varchar2(256),
  --
  storage_ib2_ip         varchar2(256),
  storage_ib2_host_name  varchar2(256),
  storage_ib2_netmask    varchar2(256),
  storage_ib2_domianname varchar2(512),
  storage_ib2_gateway    varchar2(256),
  --
  vm_size_name          varchar2(32),
  -- end: bug 26751817
  CONSTRAINT ecs_domus_ecs_racks_name_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred,
  CONSTRAINT ecs_domus_hw_node_id_fk FOREIGN KEY (hw_node_id)
    REFERENCES ecs_hw_nodes(id) deferrable initially deferred,
  CONSTRAINT ecs_domus_adm_nettype_ck CHECK
     (admin_network_type in ('NAT', 'NON-NAT')),
  CONSTRAINT ecs_domus_gtwy_adptr CHECK
     (gateway_adapter in ('ADMIN', 'CLIENT', 'BACKUP')),
  CONSTRAINT ecs_domus_hostname_adptr CHECK
     (hostname_adapter in ('ADMIN', 'CLIENT', 'BACKUP')),
  CONSTRAINT ecs_domus_admin_ck CHECK
    (( /* for BMC :if admin_network_type is NAT, admin_host_name cannot be null */
          admin_network_type = 'NAT'
      and db_client_mac   is not null
      and db_backup_mac   is not null
     ) 
     or
     ( /* for all others db_client_mac, db_backup_mac are null */
          admin_network_type = 'NON-NAT'
    )) 
);
PROMPT Creating index ecs_domus_ecsracksname_fk_idx
create index ecs_domus_ecsracksname_fk_idx on ecs_domus(ecs_racks_name);
PROMPT Creating index ecs_domus_hw_node_id_fk_idx
create index ecs_domus_hw_node_id_fk_idx on ecs_domus(hw_node_id);

-- begin: bug 26751817
Rem
Rem  ecs_vm_sizes
Rem    Table to hold the vm size detail for various hw models.
Rem
Rem  hw_model - hw model of the node X6-2 or X7-2 and so on
Rem  size_name - Large, Medium and Small. Names that go into the OEDA XML
Rem  cpu_count - Cpus for the given size_name
Rem  memory_size - Memory for the given size_name
Rem  disk_size   - Disk for the given size_name
Rem
PROMPT Creating table ecs_vm_sizes
create table ecs_vm_sizes
( hw_model   varchar2(128) not null,
  size_name  varchar2(32)  default 'Large' not null,
  cpu_count  number        not null,
  memory_size varchar2(64) not null,
  disk_size varchar2(64)   not null,
  CONSTRAINT ecs_vm_sizes_pk PRIMARY KEY (hw_model, size_name),
  CONSTRAINT ecs_vm_sizes_name_ck CHECK
    (size_name in ('Large', 'Medium', 'Small'))
);

Rem
Rem  ecs_domu_dns_masqs
Rem    In AD/HIGGS dnsmasq is used to manage the domainname to dns.
Rem    This table holds that data
Rem    Primary key is the ecs_racks_name, domu admin_host_name and 
Rem    domain_name
Rem
PROMPT Creating table ecs_domu_dns_masqs
create table ecs_domu_dns_masqs
( ecs_racks_name       varchar2(256) not null, 
  admin_host_name      varchar2(256) not null,
  domain_name          varchar2(512) not null,
  dns_ip               varchar2(256) not null,
  CONSTRAINT ecs_domus_dnsmsq_pk PRIMARY KEY 
    (ecs_racks_name, admin_host_name, domain_name),  
  CONSTRAINT ecs_domus_dnsmsq_ecrk_name_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);

PROMPT Creating index ecs_dmu_dnsmsq_rk_name_fk_idx
create index ecs_dmu_dnsmsq_rk_name_fk_idx
  on ecs_domu_dns_masqs(ecs_racks_name);
-- end: bug 26751817


Rem ecs_temp_domus
Rem   Place to hold the admin_nat_ip and nat_host_name
Rem   required by the compose cluster action. But these info are
Rem   provided during the add cabinet flat file bulk loads. As a
Rem   stop gap arrangement  this table is created.
Rem   We could not have used ecs_domus because of the ecs_racks_name
Rem   primary key are we do not have it until the compose cluster
Rem   done.
Rem
Rem   hw_node_id -
Rem     Refers to ecs_hw_nodes.id
Rem   admin_nat_ip -
Rem     DOMU admin NAT IP 
Rem   admin_nat_host_name 
Rem     DOMU admin NAT host name
Rem   db_client_mac -
Rem     DOMU db client  MAC. Loaded from the flat file
Rem   db_backup_mac -
Rem     DOMU db backup  MAC. Loaded from the flat file
Rem
Rem  Notes:
Rem  So the logic of compose cluster now is to first verify if the
Rem  table holds any records for the hw_nodes that were carved out.
Rem  If there are records found, then the compose_cluster_begin would
Rem  put them in the ecs_domus along with the generated nat_hostname
Rem  and return the same nat_ip, nat_host_name, db_client_mac, db_backup_mac
Rem   in the JSON output.
Rem  Then the Exaclould would return back the same info or altered one to the
Rem  compose_cluser_end which would then update ecs_domus entries.
Rem
PROMPT Creating table ecs_temp_domus
create table ecs_temp_domus
( hw_node_id           number        not null,
  admin_nat_ip         varchar2(256) not null,
  admin_nat_host_name  varchar2(512) not null,
  db_client_mac        varchar2(256) not null,
  db_backup_mac        varchar2(256) not null,
  CONSTRAINT ecs_tdomus_hw_node_id_pk PRIMARY KEY (hw_node_id),
  CONSTRAINT ecs_tdomus_hw_node_id_fk FOREIGN KEY (hw_node_id)
    REFERENCES ecs_hw_nodes(id) deferrable initially deferred
);

Rem
Rem ecs_clusters_purge_queue
Rem  When a cluster (ecs_racks.name) is deleted, it will be put on to
Rem  a purge queue since deleting a cluster is a catastrophic event.
Rem  Moving a cluster into a purge queue puts it into a suspended state.
Rem  A centralized job control will do the actual purging of the cluster
Rem  on the specified purge_time.
Rem
Rem   ecs_racks_name
Rem     references ecs_racks.name
Rem   cluster_xml
Rem     references ecs.ranges.xml
Rem   deleted_time
Rem     time of deletion from ecs_racks. During this time the relevant
Rem     data is moved into this table.
Rem   purge_time
Rem     time when the cluster to be purged.
Rem
PROMPT Creating table ecs_clusters_purge_queue
create table ecs_clusters_purge_queue
( ecs_racks_name    varchar2(100) not null,
  cluster_xml       CLOB,
  deleted_time      timestamp default systimestamp not null ,
  purge_time        timestamp default (systimestamp + 7) not null ,
  CONSTRAINT ecs_clusters_prgq_rakname_pk PRIMARY KEY (ecs_racks_name),
  CONSTRAINT ecs_clusters_prgq_rakname_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);

-- begin: bug 26751817
Rem
Rem ecs_clusters
Rem    Holds each real application cluster(RAC) info like scan, 
Rem    version, DNS, NTP, timezone so on
Rem
PROMPT Creating table ecs_clusters
create table ecs_clusters
( ecs_racks_name    varchar2(100)  not null,
  scan_name         varchar2(4000) not null,
  scan_port         number         not null,
  scan_ip1          varchar2(256)  not null,
  scan_ip2          varchar2(256)  ,
  scan_ip3          varchar2(256) ,
  scan_netmask      varchar2(256),
  scan_gateway      varchar2(256),
  scan_domainname   varchar2(512),
  scan_vlan_tag     number,
  --
  gi_basedir     varchar2(4000) not null,
  gi_clustername varchar2(8)    not null,
  gi_homeloc     varchar2(4000) not null,
  gi_version     varchar2(256)  not null,
  inventory_loc  varchar2(4000) not null,
  patchlist      clob,
  --
  ntp_ip1        varchar2(256) not null,
  ntp_ip2        varchar2(256),
  ntp_ip3        varchar2(256),
  --
  dns_ip1        varchar2(256) not null,
  dns_ip2        varchar2(256),
  dns_ip3        varchar2(256),
  --
  timezone       varchar2(64),
  CONSTRAINT ecs_clusters_rakname_pk PRIMARY KEY (ecs_racks_name),
  CONSTRAINT ecs_clusters_rakname_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);

Rem
Rem ecs_cluster_diskgroups
Rem    Every Real Application Cluster (RAC) can bave many diskgroups
Rem    and we catalog them here in this table
Rem
PROMPT Creating table ecs_cluster_diskgroups
create table ecs_cluster_diskgroups
( ecs_racks_name   varchar2(100) not null,
  disk_group_name  varchar2(256) not null,
  disk_group_type  varchar2(256) default 'DATA' not null,
  disk_group_size  varchar2(128) not null,
  disk_group_redundancy varchar2(128) default 'HIGH' not null,
  CONSTRAINT ecs_clusters_dskgrp_pk 
    PRIMARY KEY (ecs_racks_name, disk_group_name),
  CONSTRAINT ecs_cls_dskgrp_rknm_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred,
  CONSTRAINT ecs_cls_dskgrp_type_ck CHECK 
    (disk_group_type in ('DATA', 'RECO', 'REDO')),
  CONSTRAINT ecs_cls_dskgrp_reduncy_ck CHECK
    (disk_group_redundancy in ('HIGH', 'NORMAL', 'EXTERNAL'))
);
PROMPT Creating index ecs_cls_dskgrp_rknm_fk_idx
create index ecs_cls_dskgrp_rknm_fk_idx 
  on ecs_cluster_diskgroups(ecs_racks_name);

Rem
Rem ecs_database_homes
Rem    With in a given Real Application Cluster (RAC) there can be 
Rem    multiple database homes.
Rem    Holds each database home  info like lang, version and so on
Rem    on a given real application cluster.
Rem
PROMPT Creating table ecs_database_homes
create table ecs_database_homes
( ecs_racks_name  varchar2(100) not null,
  basedir         varchar2(256) not null,
  db_home_name    varchar2(256) not null,
  db_home_loc     varchar2(4000) not null,
  invloc          varchar2(4000) not null,
  db_version      varchar2(256) not null,
  db_lang         varchar2(128) not null,
  patchlist       clob,
  CONSTRAINT ecs_database_homes_pk PRIMARY KEY (ecs_racks_name, db_home_name),
  CONSTRAINT ecs_db_homes_rknm_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred
);
PROMPT Creating index ecs_db_homes_rknm_fk_idx
create index ecs_db_homes_rknm_fk_idx
  on ecs_database_homes(ecs_racks_name);

Rem
Rem ecs_databases
Rem    Holds each database info like lang, version and so on
Rem    on a given real application cluster
Rem    Many databases can share a database home.
Rem
PROMPT Creating table ecs_databases
create table ecs_databases 
( ecs_racks_name  varchar2(100) not null,
  db_home_name     varchar2(256) not null,
  db_name_or_sid   varchar2(256) not null,
  db_lang          varchar2(256) not null,
  db_version       varchar2(256) not null,
  db_charset       varchar2(256) not null,
  cdb_or_pdb       varchar2(256) default 'CDB' not null,
  db_blocksize     number,
  db_template      varchar2(256) default 'OLTP' not null ,
  CONSTRAINT ecs_database_pk PRIMARY KEY 
     (ecs_racks_name, db_home_name, db_name_or_sid),
  CONSTRAINT ecs_db_rakname_fk FOREIGN KEY (ecs_racks_name)
    REFERENCES ecs_racks(name) deferrable initially deferred,
  CONSTRAINT ecs_db_home_fk FOREIGN KEY (ecs_racks_name, db_home_name)
    REFERENCES ecs_database_homes(ecs_racks_name, db_home_name) 
    deferrable initially deferred,
  CONSTRAINT ecs_databases_type_ck CHECK
     (cdb_or_pdb in ('CDB', 'PDB')),
  CONSTRAINT ecs_databases_template_ck CHECK
     (db_template in ('OLTP', 'DSS'))
);
PROMPT Creating index ecs_db_rakname_fk_idx
create index ecs_db_rakname_fk_idx on ecs_databases(ecs_racks_name);
PROMPT Creating index ecs_db_home_fk_idx
create index ecs_db_home_fk_idx on ecs_databases(ecs_racks_name, db_home_name);


Rem
Rem ecs_emtrackingresource
Rem    Holds resources to be tracked with EM and their current state
Rem    resource_info1 column is used to store the name of the PDB in case of 
Rem    PDB registration. resource_info2 is use to store the jobid of the 
Rem    asynchronous emcli call made to register the PDB. 
Rem    These two columns are named as resource_info* so that we can overload
Rem    any other information that we would want to store in the future. 
Rem
PROMPT Creating table ecs_emtrackingresource
create table ecs_emtrackingresource (
  em_type     varchar2(36) not null,
  exaunit_id   number not null,
  db_sid       varchar2(4000) not null,
  em_state    varchar2(36) not null,
  reg_attempt number not null,
  resource_info1 varchar2(2000) default 'NoVal' not null,
  resource_info2 varchar2(2000),
  em_agent varchar2(256), -- em_agent is populated only for cluster and observer
  CONSTRAINT ecs_emres_state_ck CHECK (EM_STATE in ('created', 'registered', 'deleted', 'not_processing', 'deleting', 'create_pending_delete', 'reconfig')),
  CONSTRAINT em_track_res_pk PRIMARY KEY(exaunit_id, db_sid, resource_info1)
);
-- end: bug 26751817
Rem --- End Gen2 cloud   -----


PROMPT Creating table atp_properties
create table atp_properties (
    name     varchar2(256),
    type     varchar2(256) not null,
    value    varchar2(2048) not null,
    CONSTRAINT atpproperty_pk PRIMARY KEY (value, type)
);

PROMPT create sequence user_auth_id_seq
create sequence user_auth_id_seq;

PROMPT Creating table user_auth
CREATE TABLE user_auth (
    id INT PRIMARY KEY,
    auth_type varchar2(128) NOT NULL,
    username varchar2(256) NOT NULL,
    passwd BLOB NOT NULL,
    token varchar2(512),
    CONSTRAINT auth_info_auth_type_ck CHECK (auth_type in ('BASIC', 'IDCS'))
);

PROMPT create sequence ecra_info_id_seq
create sequence ecra_info_id_seq;

PROMPT Creating table ecra_info
CREATE TABLE ecra_info (
    id INT PRIMARY KEY,
    uri varchar2(512) NOT NULL,
    authid INT NOT NULL,
    CONSTRAINT ecra_uri_unique UNIQUE(URI) enable,
    CONSTRAINT FK_authid FOREIGN KEY (authid) REFERENCES user_auth(id)
);

PROMPT Creating table ecs_zone_locations
CREATE TABLE ecs_zone_locations (
    region varchar2(512) NOT NULL,
    dc varchar2(512),
    zone varchar2(100),
    ecra_info_id INT NOT NULL,
    CONSTRAINT zoneloc_pk  PRIMARY KEY (dc, zone),
    CONSTRAINT FK_ecra_infoid_zone FOREIGN KEY (ecra_info_id) REFERENCES ecra_info(id)
);

PROMPT Creating table ecs_site_locations
CREATE TABLE ecs_site_locations (
    region varchar2(512) NOT NULL,
    site varchar2(512),
    subscription_id varchar2(100),
    ecra_info_id INT NOT NULL,
    CONSTRAINT site_pk  PRIMARY KEY (site, subscription_id),
    CONSTRAINT FK_ecra_infoid_site FOREIGN KEY (ecra_info_id) REFERENCES ecra_info(id)
);

PROMPT Creating table ecs_ad_locations
CREATE TABLE ecs_ad_locations (
    region varchar2(512) NOT NULL,
    compute_zone varchar2(512),
    ad varchar2(100),
    ecra_info_id INT NOT NULL,
    CONSTRAINT ad_pk  PRIMARY KEY (compute_zone, ad),
    CONSTRAINT FK_ecra_infoid_ad FOREIGN KEY (ecra_info_id) REFERENCES ecra_info(id)
);

PROMPT Creating table ecs_pdb
create table ecs_pdb(
      pdb_name                varchar2(256) not null,
      cdb_id                  number not null,
      ocid                    varchar2(2048) not null,
      payload CLOB,
      CONSTRAINT ecs_pdb_pk PRIMARY KEY (pdb_name, cdb_id),
      CONSTRAINT ecs_pdb_fk FOREIGN KEY (cdb_id)
      REFERENCES databases(dbid) ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

--CNS related tables
create table ecs_events
(
  event_uuid VARCHAR2(128) NOT NULL,
  event_name  VARCHAR(256) NOT NULL,
  event_type VARCHAR2(32) NOT NULL,
  event_status VARCHAR2(32) NOT NULL, -- indicates Success or Failure of event
  request_id VARCHAR2(36) NOT NULL, -- from ecs_requests table
  host_name VARCHAR2(256),
  raw_event CLOB NOT NULL,
  received_time TIMESTAMP WITH TIME ZONE DEFAULT systimestamp NOT NULL,
  exaunit_id NUMBER,
  exadata_service_name VARCHAR2(512),   -- references name field of ecs_exaservice
  final_event CLOB,
  posted_time TIMESTAMP WITH TIME ZONE,
  status  NUMBER NOT NULL, --processing status 1-RAW, 2-INVALID, 3 -POSTERROR 4-SUCCESS
  processing_error VARCHAR2(1024), -- processing error message
  CONSTRAINT ecs_events_pk PRIMARY KEY (event_uuid),
  CONSTRAINT ecs_events_unique UNIQUE (event_name, request_id, exaunit_id, event_status)
);

--OCI-Exa Tables
create table ecs_oci_tenant_info (
    tenant_ocid         varchar2(512) not null,
    tenant_name         varchar2(256),
    tenant_email        varchar2(512),
    CONSTRAINT          oci_tenant_info_pk
        PRIMARY KEY (tenant_ocid)
);


create table ecs_oci_exa_info (
    tenant_ocid         varchar2(512) not null,
    exa_ocid            varchar2(512) not null,
    exa_name            varchar2(256) not null,
    dns                 varchar2(512) not null,
    ntp                 varchar2(512) not null,
    timezone            varchar2(512) not null,
    multivm             number(1)     not null,
    env                 varchar2(16)  not null,
    admin_nw_cidr       varchar2(512),
    ib_nw_cidr          varchar2(512),
    ec_keys_db          CLOB, -- Zip with ExaCloud keys.db + wallet (for ExaCC-OCI)
    CONSTRAINT unique_exa_ocid UNIQUE(exa_ocid) enable,
    CONSTRAINT  oci_exa_info_pk
        PRIMARY KEY (tenant_ocid, exa_ocid),
    CONSTRAINT  fk_tenant_ocid_exainfo
        FOREIGN KEY (tenant_ocid)
        REFERENCES ecs_oci_tenant_info(tenant_ocid)
);


create table ecs_oci_exa_controlserver (
    exa_ocid            varchar2(512)  not null,
    ip_control_server1  varchar2(32)   not null,
    ip_control_server2  varchar2(32)   not null,
    gateway             varchar2(32)   not null,
    netmask             varchar2(32)   not null,
    dhcp                varchar2(1)    not null,
    proxy               varchar2(32)   ,
    ssh_pub_key         varchar2(2048) not null,
    ssh_priv_key        varchar2(2048) not null,
    CONSTRAINT  oci_exa_controlserver_pk
        PRIMARY KEY(exa_ocid),
    CONSTRAINT  fk_exa_ocid_controlserver
        FOREIGN KEY (exa_ocid)
        REFERENCES  ecs_oci_exa_info(exa_ocid)
);

create table ecs_oci_config_bundle_details(
    exa_ocid        varchar2(512) not null,
    config_bundle   BLOB,
    time_stamp      varchar2(64) not null,
    cksum           varchar2(128) not null,
    CONSTRAINT  oci_config_bundle_details_pk
        PRIMARY KEY(exa_ocid),
    CONSTRAINT  fk_exa_ocid_cfgbundle
        FOREIGN KEY (exa_ocid)
        REFERENCES ecs_oci_exa_info(exa_ocid)
);

CREATE TABLE ecs_oci_vpn_cert_info(
    ad                VARCHAR2(2) NOT NULL,
    opensslenv        BLOB,
    opensslcfg        BLOB,
    index_txt         BLOB,
    serial            BLOB,
    ca_crt            BLOB,
    ca_key            BLOB,
    openvpn_srv_p12   BLOB,
    openvpn_srv_crt   BLOB,
    crl_pem           BLOB,
    dh_pem            BLOB,
    ca_password       VARCHAR2(512),
    vpnhe_fqdn        VARCHAR2(512),
    client_conf       BLOB,
    crl_pem_loc       VARCHAR2(256),
    vpn_proxy_cert    BLOB,
    vpn_proxy_key     BLOB,
    cps_proxy_cert    BLOB,
    cps_proxy_key     BLOB,
    tls_auth_key     BLOB,
    patchsvr_cert     BLOB,
    patchsvr_key      BLOB,
    CONSTRAINT ecs_oci_vpn_cert_info_pk PRIMARY KEY(ad)
);

PROMPT Creating table ECS_OCI_NETWORKS
create table ECS_OCI_NETWORKS(
  exa_ocid        varchar2(512) not null,
  network_ocid    varchar2(512) not null,
  network_name    varchar2(256) not null,
  status          varchar2(64)  not null,
  ntp             varchar2(256),
  dns             varchar2(256),
  scan_hostname   varchar2(512),
  scan_port       varchar2(64),
  scan_ips        varchar2(256),
  CONSTRAINT  ecs_oci_networks_pk PRIMARY KEY (network_ocid),
  CONSTRAINT  ecs_oci_networks_fk FOREIGN KEY (exa_ocid) REFERENCES ecs_oci_exa_info(exa_ocid)
);

PROMPT Creating table ECS_OCI_NETWORKNODES
create table ECS_OCI_NETWORKNODES(
  node_id           varchar2(512) not null,
  network_ocid      varchar2(512) not null,
  node_type         varchar2(32)  not null,
  domainname        varchar2(512) not null,
  ip                varchar2(32)  not null,
  hostname          varchar2(512) not null,
  netmask           varchar2(32),
  vlantag           varchar2(32),
  gateway           varchar2(32),
  CONSTRAINT  ecs_oci_networknodes_fk FOREIGN KEY (network_ocid)
      REFERENCES ECS_OCI_NETWORKS(network_ocid)
			ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED
);

PROMPT Creating table ecs_patching_versions
create table ecs_patching_versions(
  rack_name          		varchar2(512) not null,
  exacc_ocid      		varchar2(512),
  exadata_rack_applied_ver      varchar2(128),
  exadata_rack_avail_ver	varchar2(128),
  cps_sw_applied_ver		varchar2(128),
  cps_sw_avail_ver		varchar2(128),
  cps_image_applied_ver		varchar2(128),
  cps_image_avail_ver		varchar2(128),
  exacloud_applied_ver		varchar2(128),
  exacloud_avail_ver		varchar2(128),
  last_updated_time             varchar2(128),
  CONSTRAINT          ecs_patching_versions_pk
        PRIMARY KEY (rack_name)
);

						
CREATE TABLE ecs_oci_vpn_he_info(
    ad                varchar2(2)    NOT NULL,
    user_id           varchar2(64)   NOT NULL,
    he_ip             varchar2(32)   NOT NULL,
    status            varchar2(32)   NOT NULL,
    sshkey            varchar2(4000) NOT NULL,
    he_name           varchar2(64)   NOT NULL,
    CONSTRAINT ecs_oci_vpn_he_info_pk PRIMARY KEY(ad, he_ip)
);

PROMPT Creating table ECS_ATPCLIENT_VCN
create table ECS_ATPCLIENT_VCN(
vcn_id         varchar2(2048) not null,
vcn_index      number         not null,
subnet_count   number         default 0 not null,
vcn_fsm         varchar2(32),
compartmentocid varchar2(256),
cidrblock       varchar2(64),
CONSTRAINT ecs_atpclient_vcn_pk PRIMARY KEY (vcn_id)
);

PROMPT Creating sequence ecs_atpclient_vcn_seq
create sequence ecs_atpclient_vcn_seq;

CREATE TABLE ecs_cipher_passwds(
    timestamp     timestamp NOT NULL,
    cipher_passwd varchar2(16) NOT NULL,
    status        varchar2(8) NOT NULL
    CHECK (status in ('ACTIVE', 'EXPIRED')),
    CONSTRAINT pk_ecs_cipher_passwds PRIMARY KEY (cipher_passwd)
);

CREATE TABLE ecs_oci_vpn_ca_secrets(
    ad                			varchar2(2)   NOT NULL,
    ca_secrets_oss_fname        varchar2(256)  NOT NULL,
    ca_secrets_oss_container    varchar2(1024)  NOT NULL,
    ca_secrets_kms_token        varchar2(1024)  NOT NULL,
    CONSTRAINT ecs_oci_vpn_ca_secrets_pk PRIMARY KEY(ad)
);

PROMPT Creating table ecs_compliance_aep_status
create table ecs_compliance_aep_status (
    host_id                  VARCHAR2(500),
    component                VARCHAR2(50), -- AV, FIM, ...
    status                   VARCHAR2(10), -- True, False, NA
    last_check_time          TIMESTAMP,
    last_status_change_time  TIMESTAMP,
    error_detail             VARCHAR2(4000),
    CONSTRAINT ecs_compliance_aep_status_pk PRIMARY KEY (host_id, component)
);

PROMPT Creating table ecs_compliance_cm_status
CREATE TABLE ecs_compliance_cm_status(
    host_id                   VARCHAR2(500) NOT NULL,
    config_name               VARCHAR2(50) NOT NULL,
    baseline_config_id        NUMBER,
    baseline_config_checksum  CHAR(64),
    current_config_id         NUMBER,
    current_config_checksum   CHAR(64),
    CONSTRAINT cm_status_pk PRIMARY KEY (host_id, config_name)
);

PROMPT Creating table ecs_compliance_cm_host_config
CREATE TABLE ecs_compliance_cm_host_config(
    id          NUMBER,
    config_name VARCHAR2(50) NOT NULL,
    checksum    CHAR(64) NOT NULL,
    content     CLOB NOT NULL,
    CONSTRAINT cm_host_config_pk PRIMARY KEY (id)
);

PROMPT Creating sequence cm_host_config_id_seq
CREATE SEQUENCE cm_host_config_id_seq;

PROMPT Creating table ecs_compliance_cm_change_log
CREATE TABLE ecs_compliance_cm_change_log(
    id              NUMBER,
    host_id         VARCHAR2(500) NOT NULL,
    config_name     VARCHAR2(50) NOT NULL,
    change_type     VARCHAR2(50) NOT NULL,  -- config change or baseline change
    old_config_id   NUMBER NOT NULL,
    new_config_id   NUMBER NOT NULL,
    change_time     TIMESTAMP NOT NULL,
    description     VARCHAR2(4000),
    CONSTRAINT cm_change_log_pk PRIMARY KEY (id)
);

PROMPT Creating sequence cm_change_log_id_seq
CREATE SEQUENCE cm_change_log_id_seq;

PROMPT Creating table ecs_compliance_paused_hosts
CREATE TABLE ecs_compliance_paused_hosts(
    host        VARCHAR2(400) NOT NULL,
    request     VARCHAR2(400) NOT NULL,
    pause_time  TIMESTAMP NOT NULL,
    resume_time TIMESTAMP
);

PROMPT Creating index ecs_compliance_paused_hosts_host_idx
CREATE INDEX ecs_compliance_paused_hosts_host_idx
  on ecs_compliance_paused_hosts(host);

PROMPT Creating index ecs_compliance_paused_hosts_req_idx
CREATE INDEX ecs_compliance_paused_hosts_req_idx
  on ecs_compliance_paused_hosts(request);

PROMPT Creating table ecs_compliance_pause_rule
CREATE TABLE ecs_compliance_pause_rule(
    operation       VARCHAR2(64),
    request_class   VARCHAR2(64),   -- CommonRequest concrete class name
    target_rack     VARCHAR2(512),
    target_host     VARCHAR2(512),
    host_type       VARCHAR2(32),
    CONSTRAINT ecs_compliance_pause_rule_pk PRIMARY KEY (operation, request_class)
);

PROMPT Creating table ecs_compliance_rpm_info
create table ecs_compliance_rpm_info (
    name                VARCHAR2(50),  -- clamav.x86_64, clamav-avdefs.noarch
    version             VARCHAR2(100), -- 0.103.11-1, 4.0-3054
    yum_upload_time     TIMESTAMP,
    ecra_download_time  TIMESTAMP,
    CONSTRAINT ecs_compliance_rpm_info_pk PRIMARY KEY (name, version)
);

create table ecs_patching_exadata_info (
  environment          		varchar2(512) ,
  rackname      		varchar2(512) ,
  last_updated_time		varchar2(128),
  CONSTRAINT rack_cluster_pk PRIMARY KEY (rackname)
);

PROMPT Creating table ecs_patching_exadata_version
create table ecs_patching_exadata_version(
  rackname      		varchar2(512) not null,
  node_type                     varchar2(128),
  image_version         	varchar2(128),
  hostname                      varchar2(512),
  CONSTRAINT  ecs_rack_cluster_fk FOREIGN KEY (rackname) REFERENCES ecs_patching_exadata_info(rackname)
);

PROMPT CREATE TABLE ECS_CLU_RES_ACTIVITY_LOG
CREATE TABLE ECS_CLU_RES_ACTIVITY_LOG (
        log_id NUMBER NOT NULL,
        cluster_name varchar2(256) NOT NULL,
        operation_type varchar2(24) NOT NULL,
        clu_resource varchar2(24) NOT NULL,
        resource_value varchar2(32) NOT NULL,
        start_time TIMESTAMP NOT NULL,
        end_time TIMESTAMP NOT NULL,
        vm_hostname varchar2(128),
        status_activity_poll varchar2(10),     -- SUCCESS, FAIL, NA (NOT AVAILABLE)
        status_details_activity_poll varchar2(1024),
        soft_delete varchar2(1) DEFAULT 'N',   -- IF marked for cleanup
        exa_ocid varchar2(512) NOT NULL,
        CONSTRAINT ecs_ecs_clu_res_activity_log
                PRIMARY KEY (log_id),
        CONSTRAINT chk_status_activity_poll
                CHECK (status_activity_poll IN ('SUCCESS', 'FAIL', 'NA')),
        CONSTRAINT chk_soft_delete
                CHECK (soft_delete IN ('Y', 'N'))
);

PROMPT Creating table ecs_exaservice_allocations
CREATE TABLE ECS_EXASERVICE_ALLOCATIONS (
	exaservice_id varchar2(4000) NOT NULL,
	metered_cores NUMBER NOT NULL,
	memorygb NUMBER NOT NULL,
	usable_ohstoragegb NUMBER NOT NULL, -- This is per node value
	storagegb NUMBER NOT NULL,
	CONSTRAINT fk_ecs_exaservice_allocations 
		FOREIGN KEY (exaservice_id)
		REFERENCES ECS_EXASERVICE(id),
	CONSTRAINT pk_ecs_exaservice_allocations 
		PRIMARY KEY (exaservice_id)
);

PROMPT Creating table ecs_exaservice_reserved_alloc
CREATE TABLE ECS_EXASERVICE_RESERVED_ALLOC (
     rackname varchar2(256) NOT NULL,
     exaservice_id varchar2(4000) NOT NULL,
     metered_cores NUMBER NOT NULL,
     memorygb NUMBER NOT NULL, -- This is per node value
     usable_ohstoragegb NUMBER NOT NULL,
     storagegb NUMBER NOT NULL,
     CONSTRAINT pk_ecs_rackname_res_alloc
          PRIMARY KEY (rackname)
);

PROMPT Creating table ECS_OCI_WSS_HE_INFO  - WSS details
create table ecs_oci_wss_he_info  (
    ad            varchar2(100) not null,
    user_id       varchar2(64) not null,
    user_password varchar2(128) not null,
    he_ip         varchar2(32),
    status        varchar2(32),
    he_name       varchar2(64),
    he_vcn_type   varchar2(32) not null,
    he_wss_url    varchar2(256) not null
);

PROMPT Creating table ECS_NAT_VIP_HOST  
create table ecs_nat_vip_host  (
    rackname        varchar2(512) not null,
    dom0name        varchar2(512) not null,
    nat_ip          varchar2(128) not null,
    dom0_ip         varchar2(128) not null,
    nat_hostname    varchar2(512) not null,
    nat_vip_ip      varchar2(128) not null,
    netmask         varchar2(128) not null,
    CONSTRAINT pk_ecs_atp_nat_vip_host
          PRIMARY KEY (rackname, dom0name)
);

PROMPT Creating Analytics table
create table ecs_analytics(
    id           NUMBER not null,
    exaunitId    NUMBER,
    rackName     VARCHAR2(256),
    operation    VARCHAR2(256) not null,
    customerName VARCHAR2(256),
    status       VARCHAR2(24) not null,
    start_time   VARCHAR2(50) not null,
    end_time     VARCHAR2(50),
    CONSTRAINT pk_id_analytics PRIMARY KEY (id)
);

PROMPT Creating sequence ecs_analytics_id_seq
create sequence ecs_analytics_id_seq;

PROMPT Creating table ECS_TFATENANTBUCKET
create table ecs_tfatenantbucket (
     custTenantId     varchar2(2048),
     tfaBucketName    varchar2(2048),
     parurl           varchar2(2048),
     par_expiry_time  TIMESTAMP,
     refcount         NUMBER, 
     CONSTRAINT ecs_tfatenantbucket_pk 
	       PRIMARY KEY (custTenantId)
);

Rem  ecs_bonding
Rem    Place to hold bonding information for dom0Map of Cavium to Ether interfaces of hw nodes
Rem    Used for provision.
Rem
Rem    hw_node_id -
Rem      Refers to ecs_hw_nodes.id
Rem    control_ip1 -
Rem      Populated by add-a-cabinet using data from DBaaSCP
Rem      Primary Cavium monitoring interface primary IP
Rem    control_ip2 -
Rem      Populated by add-a-cabinet using data from DBaaSCP
Rem      Standby Cavium  monitoring interface primary IP
Rem    control_vip -
Rem      Populated by add-a-cabinet using data from DBaaSCP
Rem      Primary Cavium monitoring interface Secondary IP 
Rem      (floatingIP/vip for the bond interface) 
Rem    control_netmask -
Rem      Populated by add-a-cabinet using data from DBaaSCP
Rem    control_vlantag -
Rem      Populated by add-a-cabinet using data from DBaaSCP
Rem      Default to 0
Rem

PROMPT Creating table ecs_bonding
create table ecs_bonding
(   hw_node_id number         not null,
    control_ip1 varchar2(256),
    control_ip2 varchar2(256),
    control_vip varchar2(256),
    control_netmask varchar2(256),
    control_vlantag number default 0,
    CONSTRAINT ecs_bonding_node_id_fk FOREIGN KEY (hw_node_id)
      REFERENCES ecs_hw_nodes(id) deferrable initially deferred
);

PROMPT Creating index ecs_bonding_node_id_fk_idx
create index ecs_bonding_node_id_fk_idx
  on ecs_bonding(hw_node_id);

PROMPT Creating table ecs_bonding_migration
create table ecs_bonding_migration
(  
    rackname     varchar2(256),
    clusterxml   clob,
    clusterpayload clob,
    CONSTRAINT ecs_bonding_migration_pk PRIMARY KEY (rackname)
);

PROMPT Creating table ecs_customvip
create table ecs_customvip
(
    rackname            varchar2(256),
    customip            varchar2(64),
    hostname            varchar2(256),
    domainname          varchar2(512),
    nodename            varchar2(256),
    interfacetype       varchar2(64),
    standby_vnic_mac    varchar2(256),
    ipocid              varchar2(256),
    vnicocid            varchar2(256),
    zoneocid            varchar2(256),
    iptype              varchar2(64) DEFAULT 'CUSTOMVIP' NOT NULL,
    constraint ecs_customvip_pk PRIMARY KEY (rackname, customip)
);

PROMPT Creating exaie table - infra events
create table exaie_events
(
    event_hash          varchar2(512) not null,
    event_type          varchar2(512) not null,
    event_time          number        not null,
    event_name          varchar2(512) not null,
    event_details_json  clob,
    CONSTRAINT event_pk PRIMARY KEY(event_hash)
);

PROMPT Creating exaie_events_switches table 
create table exaie_events_switches
(
    event_name          varchar2(512) not null,
    event_switch        varchar2(16)  not null,
    CONSTRAINT event_switch_pk PRIMARY KEY(event_name)
);

PROMPT Creating exadata applied patch details table
create table ecs_exa_applied_patches
(
    id                    number not null,
    exa_ocid              varchar2(512),
    exaunit_id            number,
    rack_name             varchar2(256),
    cabinet_name          varchar2(256),
    patch_type            varchar2(128) not null,
    target_type           varchar2(128) not null,
    target_fqdn           varchar2(512) not null,
    operation             varchar2(128) not null,
    current_image_version varchar2(512),
    start_time            timestamp,
    end_time              timestamp,
    status                varchar2(512),
    attempted_version     varchar2(512),
    error_code            varchar2(256),
    error_msg             varchar2(1024),
    constraint pk_ecs_exa_applied_patches
        primary key (ID)
);


PROMPT Creating available images info table
create table exacc_availimages_info
(
    id                    number not null,
    exa_ocid              varchar2(512),
    base_uri              varchar2(512),
    product_type          varchar2(512),
    download_timestamp    varchar2(512),
    updated_timestamp     varchar2(512),
    constraint pk_exacc_availimages_info
        primary key (id)
);

PROMPT Creating sequence exacc_availimages_info_id_seq
create sequence exacc_availimages_info_id_seq;

PROMPT Creating cps tuner patches details table
create table exacc_cpstuner_patches
(
    id                    number not null,
    exa_ocid              varchar2(512) not null,
    cps_host              varchar2(512) not null,
    bug_id                varchar2(512) not null,
    download_location     varchar2(512),
    download_timestamp    varchar2(512),
    execution_status      varchar2(512) not null,
    execution_timestamp   varchar2(512),  
    updated_timestamp     varchar2(512),
    constraint pk_exacc_cpstuner_patches
        primary key (id)
);

PROMPT Creating sequence exacc_cpstuner_patches_id_seq
create sequence exacc_cpstuner_patches_id_seq;

PROMPT Creating software components version info table
create table exacc_sw_versions
(
    id                    number not null,
    exa_ocid              varchar2(512) not null,
    node_name             varchar2(512) not null,
    component_name        varchar2(512) not null,
    component_version     varchar2(512) not null, 
    updated_timestamp     varchar2(512),
    constraint pk_exacc_sw_versions
        primary key (id)
);

PROMPT Creating sequence exacc_sw_versions_id_seq
create sequence exacc_sw_versions_id_seq;

PROMPT Creating exacc node miscellaneous info table
create table exacc_nodemisc_info
(
    id                    number not null,
    node_type             varchar2(512),
    exa_ocid              varchar2(512) not null,
    node_name             varchar2(512) not null,
    latest_installed_rpms CLOB,
    serial_number         varchar2(512) not null, 
    updated_timestamp     varchar2(512),
    constraint pk_exacc_nodemisc_info
        primary key (id)
);

PROMPT Creating sequence exacc_nodemisc_info_id_seq
create sequence exacc_nodemisc_info_id_seq;

PROMPT Creating exacc node applied image versions info table
create table exacc_nodeimg_versions
(
    id                    number not null,
    exa_ocid              varchar2(512) not null,
    node_name             varchar2(512) not null,
    node_type             varchar2(512),
    image_version         varchar2(512) not null,
    patch_mode            varchar2(512),
    image_activation_date varchar2(512) not null,
    status                varchar2(512) not null,
    updated_timestamp     varchar2(512),
    constraint pk_exacc_nodeimg_versions
        primary key (id)
);

PROMPT Creating sequence exacc_nodeimg_versions_id_seq
create sequence exacc_nodeimg_versions_id_seq;

PROMPT Creating exacc exa_k splices info table
create table exacc_exaksplice_info
(
    id                    number not null,
    exa_ocid              varchar2(512) not null,
    node_name             varchar2(512) not null,
    node_type             varchar2(512),
    exasplice_updated_version   varchar2(512),
    exspl_updt_activated_date   varchar2(512),
    ksplice_view          CLOB,
    updated_timestamp     varchar2(512),
    constraint pk_exacc_exaksplice_info
        primary key (id)
);

PROMPT Creating sequence exacc_exaksplice_info_id_seq
create sequence exacc_exaksplice_info_id_seq;

PROMPT Creating exacc exception racks info table
create table exacc_exception_racks
(
    exa_ocid    varchar2(512) not null,
    exception_list        varchar2(512) not null,
    cps_push              varchar2(512),
    updated_timestamp     varchar2(512),
    constraint pk_exacc_exception_racks
        primary key (exa_ocid)
);

PROMPT Creating sequence ecs_exa_applied_patches_id_seq
create sequence ecs_exa_applied_patches_id_seq;

PROMPT Creating table ecs_cloudvnuma_tenancy
create table ecs_cloudvnuma_tenancy
(
    user_group          varchar2(512) not null,
    tenancy_id          varchar2(512) not null,
    cloud_vnuma         varchar2(512) not null,
    CONSTRAINT ecs_cloudvunma_tenancy_pk PRIMARY KEY(tenancy_id)
);

PROMPT Creating Error table
create table ecs_error(
    uuid             VARCHAR2(2048) not null,
    error_code       VARCHAR2(256) not null,
    error_name       VARCHAR2(256),
    description      VARCHAR2(256),
    error_action     VARCHAR2(256) not null,
    retry_count      VARCHAR2(256),
    comments         VARCHAR2(4000),
    CONSTRAINT pk_uuid_error PRIMARY KEY (uuid)
);

Rem    ecs_exadata_patch_versions
Rem    Place to hold exadata patch versions
Rem    Used for registration of exadata patch bundles.

PROMPT Creating table ecs_exadata_patch_versions
create table ecs_exadata_patch_versions(
service_type            varchar2(128) not null,
patch_type              varchar2(128) not null,
target_type             varchar2(128) not null,
image_version           varchar2(512) not null,
comments                varchar2(1024) ,
last_updated_time       timestamp default systimestamp not null,
CONSTRAINT pk_exadata_patch_versions PRIMARY KEY (service_type ,patch_type,target_type )
);

Rem    ecs_registered_infrapatch_plugins
Rem    Place to hold registered plugin metadata 
Rem    Used for registration of plugin metadata.

PROMPT Creating table ecs_registered_infrapatch_plugins

create table ecs_registered_infrapatch_plugins(
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
registration_time     timestamp default systimestamp not null,
CONSTRAINT pk_registered_infrapatch_plugins PRIMARY KEY (script_alias, plugin_target, plugin_type)
);


Rem    ecs_infrapatching_launch_nodes
Rem    Place to hold registered launch nodes for infrapatching
Rem    Used for registration of launch nodes for infrapatching

PROMPT Creating table ecs_infrapatching_launch_nodes
create table ecs_infrapatching_launch_nodes(
infra_name            varchar2(128) not null,
launch_nodes          varchar2(4000) not null,
infra_type            varchar2(128) not null,
CONSTRAINT pk_infrapatch_launch_nodes PRIMARY KEY (infra_name ,infra_type )
);

PROMPT Creating table ecs_oci_clu_xmls
create table ecs_oci_clu_xmls(
exa_ocid                varchar2(512) NOT NULL,
rackname                varchar2(256) NOT NULL,
xml                     clob,
updated_xml             clob,
CONSTRAINT pk_rack_name_clu_xmls PRIMARY KEY (rackname)
);

PROMPT Creating table ecs_oci_cell_last_ips
create table ecs_oci_cell_last_ip_cidr(
exa_ocid                varchar2(512) NOT NULL,
admin_ip                varchar2(256),
clib                    varchar2(256), 
stib                    varchar2(256),
admin_cidr              varchar2(256),
storage_cidr            varchar2(256),
cluster_cidr            varchar2(256),
CONSTRAINT pk_exa_ocid_last_ip PRIMARY KEY (exa_ocid)
);

PROMPT Creating table ecs_oci_infra_last_ips_trnst
create table ecs_oci_infra_last_ips_trnst(
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

PROMPT Creating table ecs_hw_elastic_nodes
create table ecs_hw_elastic_nodes(
    exa_ocid                varchar2(512) NOT NULL,
    ecs_racks_name_list       varchar2(4000),
    node_type                 varchar2(256) not null,
    node_model                varchar2(256) not null, 
    date_modified timestamp   default systimestamp not null,
    oracle_ip                 varchar2(256) not null,
    oracle_hostname           varchar2(256) not null,
    oracle_ilom_ip            varchar2(256),
    oracle_ilom_hostname      varchar2(256),
    location_rackunit         number(3)     not null,
    rack_num                  number(3) DEFAULT 1,
    ib1_hostname              varchar2(256),
    ib1_ip                    varchar2(256),
    ib1_domain_name           varchar2(256),
    ib1_netmask               varchar2(256),
    ib2_hostname              varchar2(256),
    ib2_ip                    varchar2(256),
    ib2_domain_name           varchar2(256),
    ib2_netmask               varchar2(256),
    delete_candidate          char(1) DEFAULT 'N',
    elastic_state             varchar2(64) DEFAULT 'PRE-ACTIVATION',
    CONSTRAINT ck_ecs_hw_elastic_nodes
      CHECK (elastic_state in ('PRE-ACTIVATION', 'ATTACHED', 'ACTIVATED', 'ERROR'))
);

PROMPT ecs_scheduled_ondemand_exec
CREATE TABLE ecs_scheduled_ondemand_exec(
    jobid                     varchar2(64),
    submitted                 timestamp,
    executed                  timestamp,
    classpath                 varchar2(512),
    custom_method             varchar2(128),
    priority                  number(3),
    status                    varchar2(16),
    CONSTRAINT ck_ecs_schd_ondemand_exec_sts
      CHECK (status in ('QUEUED', 'WAIT_AND_RETRY', 'PROCESSING', 'PROCESSED', 'FAILED'))
);

PROMPT elastic_node_attach_jobs
CREATE TABLE elastic_node_attach_jobs(
    jobid                     varchar2(64),
    parent_req_id             varchar2(64),
    exaocid                   varchar2(512),
    cluster_name              varchar2(256),
    node_type                 varchar2(16),
    status                    varchar2(16),
    target_uri                varchar2(1024),
    CONSTRAINT ck_elastic_node_att_jobs_sts
      CHECK (status in ('PENDING', 'PROCESSING', 'PASSED', 'FAILED')),
    CONSTRAINT ck_elastic__attach_node_type
      CHECK (node_type in('COMPUTE', 'CELL'))
);

PROMPT Creating table ecs_infra_resourceprincipal
CREATE TABLE ecs_infra_resourceprincipal(
    exaocid                     VARCHAR2(512) NOT NULL,
    uuid                        VARCHAR2(36) NOT NULL,
    resourceprincipal           CLOB NOT NULL,
    CONSTRAINT pk_infra_resourceprincipal
        PRIMARY KEY (exaocid),
    CONSTRAINT  fk_exa_ocid_infra_resourceprincipal
        FOREIGN KEY (exaocid)
        REFERENCES  ecs_oci_exa_info(exa_ocid)
);


PROMPT Creating table ecs_infrapwd_audit
CREATE TABLE ecs_infrapwd_audit(
    req_type                  varchar2(16),
    req_time                  timestamp,
    exaocid                   varchar2(512),
    CONSTRAINT  fk_exa_ocid_infrapwd_audit
        FOREIGN KEY (exaocid)
        REFERENCES  ecs_oci_exa_info(exa_ocid)
);

PROMPT Creating table ecs_infrapwd_schedule
CREATE TABLE ecs_infrapwd_schedule(
    exaocid                   varchar2(512),
    last_rotation             timestamp,
    rotation_status           varchar2(8),
    CONSTRAINT ck_infrapwd_rotation_status
      CHECK (rotation_status in ('DONE', 'PENDING', 'FAILED')),
    CONSTRAINT pk_infrapwd_schedule
        PRIMARY KEY (exaocid),
    CONSTRAINT  fk_exa_ocid_infrapwd_schedule
        FOREIGN KEY (exaocid)
        REFERENCES  ecs_oci_exa_info(exa_ocid)
);

PROMPT Enh 32347095 - ecs_gold_specs
CREATE TABLE ecs_gold_specs(
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

PROMPT Creating se linux tables
create table ecs_selinux_data
(
    component      varchar2(32) not null,
    policy_name    varchar2(256) not null,
    policy_data    blob,
    service_type   varchar2(64) default 'exacs',
    CONSTRAINT ck_ecs_selinux_policy_comp
      CHECK (component in ('dom0', 'cell', 'domu')),
    CONSTRAINT selinux_policy_pk PRIMARY KEY(component,policy_name)
);


PROMPT Enh 32677648 - ecs_selinux_policies
CREATE TABLE ecs_selinux_policies(
    component               varchar2(512),
    hostname                varchar2(512),
    rackname                varchar2(512),
    policy_name             varchar2(512),
    status                  varchar2(32),
    CONSTRAINT ecs_selinux_policies
        PRIMARY KEY (component,hostname),
    CONSTRAINT chk_status
        CHECK (status IN ('pending','done')),
    CONSTRAINT chk_component
        CHECK (component IN ('domu', 'dom0','cell'))
);

PROMPT Creating table ECS_FPTENANTBUCKET
create table ecs_fptenantbucket (
    custTenantId     varchar2(2048),
    fpBucketName     varchar2(2048),
    parurl           varchar2(2048),
    par_expiry_time  TIMESTAMP,
    refcount         NUMBER, 
    CONSTRAINT ecs_fptenantbucket_pk 
	    PRIMARY KEY (custTenantId)
);

PROMPT Creating table ecs_ecra_heartbeat
CREATE TABLE ecs_ecra_heartbeat (
    id              NUMBER,
    ecra_server     VARCHAR2(16),
    start_ts        TIMESTAMP,
    last_ts         TIMESTAMP,
    CONSTRAINT ecs_ecra_heartbeat_pk PRIMARY KEY (id)
);

PROMPT Creating sequence ecs_ecra_heartbeat_id_seq
create sequence ecs_ecra_heartbeat_id_seq;

PROMPT ecs_fs_encryption
CREATE TABLE ecs_fs_encryption(
     customer_tenancy_id    varchar2(128),
     kms_id                 varchar2(128),
     bucket_id              varchar2(128),
     kms_key_endpoint       varchar2(128),
     bucket_name            varchar2(128),
     bucket_namespace       varchar2(128),
     customer_tenancy_name  varchar2(128),
     infra_component        varchar2(16),
     encryption_mode        varchar2(16),
     target_filesystems     varchar2(64) DEFAULT 'all',
     key_source             varchar2(8),
     vault_id               varchar2(128),
     secret_compartment_id  varchar2(128),
     CONSTRAINT pk_ecs_fs_encyption
              PRIMARY KEY(customer_tenancy_id,infra_component,vault_id),
    CONSTRAINT ck_infra_component
      CHECK (infra_component in('dom0', 'domu'))
);

CREATE TABLE state_store
(
    state_handle    NUMBER(32),                                              
    state_data      CLOB,                                                                 
    CONSTRAINT      state_handle_pk PRIMARY KEY(state_handle)                       
);   
PROMPT Creating table ecs_retry_task
CREATE TABLE ecs_retry_task (
    wf_uuid            varchar2(2048),
    status_uuid        varchar2(2048),
    retry_count        NUMBER,
 CONSTRAINT pk_retry_task_status_uuid
              PRIMARY KEY(status_uuid)
);

CREATE INDEX state_handle_index                                         
       ON state_store(state_data) INDEXTYPE IS CTXSYS.CONTEXT; 
       
EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'state_store', CASCADE=>TRUE); 

CREATE TABLE state_lock_data
(                                             
    lock_state      CHAR(8),
    lock_handle     NUMBER(32),
    state_handle    NUMBER(32),                   
    CONSTRAINT lock_state_value check(lock_state in ('FREE', 'LOCKED'))
);

PROMPT Enh 33509359 Creating exacompute entity
create table ecs_exacompute_entity
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
    volumes clob,
    servicesubtype varchar2(16) default 'exadbxs' not null,
    clustertype varchar2(16) default 'smartstorage' not null,
    CONSTRAINT exacompute_entity_pk PRIMARY KEY(rack_name)
);

PROMPT creating table ecs_sla_records
CREATE TABLE ecs_sla_records
(
    rack_name           VARCHAR2(256),
    measure_time        TIMESTAMP,
    sla                 NUMBER,
    interval_seconds    NUMBER,
    CONSTRAINT pk_ecs_sla_records PRIMARY KEY (rack_name, measure_time)
);

PROMPT creating index ecs_sla_measure_time_idx
CREATE INDEX ecs_sla_measure_time_idx
    ON ecs_sla_records(measure_time);

PROMPT creating table ecs_sla_enable_tenancy
CREATE TABLE ecs_sla_enable_tenancy
(
    tenancy_ocid        VARCHAR2(2048) not null,
    CONSTRAINT pk_ecs_sla_enable_tenancy PRIMARY KEY (tenancy_ocid)
);

PROMPT creating table ecs_sla_server_records
CREATE TABLE ecs_sla_server_records
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
PROMPT creating index ecs_sla_server_records_idx
CREATE INDEX ecs_sla_server_records_idx
    ON ecs_sla_server_records(measure_time);

PROMPT creating table ecs_rotation_schedule
CREATE TABLE ecs_rotation_schedule
(
    secret_name         VARCHAR2(100) NOT NULL,
    vault_name          VARCHAR2(100) NOT NULL,
    last_rotation       TIMESTAMP NOT NULL,
    rotation_status     VARCHAR2(8) NOT NULL,
    CONSTRAINT ck_rotation_status CHECK (rotation_status in ('DONE', 'PENDING', 'FAILED')),
    CONSTRAINT pk_rotation_schedule PRIMARY KEY (secret_name, vault_name)
);


PROMPT creating table ecs_cps_dyn_task
CREATE TABLE ecs_cps_dyn_task
(
    component_name         VARCHAR2(16) NOT NULL,
    tar_location           VARCHAR2(254) NOT NULL,
    ecs_series             VARCHAR2(100) NOT NULL,
    script_order           VARCHAR2(8) NOT NULL,
    CONSTRAINT pk_cps_dyn_task PRIMARY KEY (component_name, ecs_series)
);

create table ecs_maintenance_domains
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
        REFERENCES  ecs_rocefabric(fabric_name),
    CONSTRAINT maintenance_domains_pk PRIMARY KEY(id,fabric_name)
);

create table ecs_cps_wf_details
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


PROMPT creating table ecs_users
create table ecs_users
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

PROMPT creating sequence ecs_users_seq
create sequence ecs_users_seq;

PROMPT creating table ecs_users_history
create table ecs_users_history
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

PROMPT creating sequence ecs_users_history_seq
create sequence ecs_users_history_seq;

PROMPT creating table ecs_users_locks
create table ecs_users_locks
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

PROMPT creating sequence ecs_users_locks_seq
create sequence ecs_users_locks_seq;

PROMPT creating table ecs_password_resets
create table ecs_password_resets
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

PROMPT creating table ecs_users_roles
create table ecs_users_roles
(
    id number not null,
    role varchar2(32),
    created_at timestamp default systimestamp,
    deleted_at timestamp,
    updated_at timestamp,
    CONSTRAINT USERS_ROLES_PK PRIMARY KEY (id),
    CONSTRAINT UNIQUE_USERS_ROLES UNIQUE (role)
);

create table ecs_mdcontext 
(
    name      varchar2(1024),
    model     varchar2(16),
    max_cpu   number,
    max_memory_in_bytes number,
    max_storageLocal_in_bytes number,
    CONSTRAINT  fk_mdcontext_name
        FOREIGN KEY (name)
        REFERENCES  ecs_rocefabric(fabric_name),
    CONSTRAINT mdcontext_pk PRIMARY KEY(name, model)
);

PROMPT creating table ecs_oci_console_history
create table ecs_oci_console_history (
    REQUESTOCID VARCHAR2(256),
    EXAUNITID NUMBER NOT NULL,
    VMHOSTNAME VARCHAR2(512) NOT NULL,
    STATUS VARCHAR2(32) NOT NULL,
    OSSOBJECT VARCHAR2(256) NOT NULL,
    DETAILS VARCHAR2(1024),
    SYMMETRICKEY VARCHAR2(4000),
    SSHPUBKEY VARCHAR2(4000),
    MD5CKSUM VARCHAR2(128),
    CONSTRAINT pk_console_history
        PRIMARY KEY (REQUESTOCID),
    CONSTRAINT fk_console_history 
        FOREIGN KEY(EXAUNITID)
            REFERENCES ECS_EXAUNITDETAILS(EXAUNIT_ID),
    CONSTRAINT chk_history_status
       CHECK (STATUS in ('REQUESTED', 'GETTING-HISTORY', 'SUCCEEDED', 'FAILED'))
);

PROMPT creating table ecs_oci_subnets
create table ecs_oci_subnets (
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
            REFERENCES ECS_ATPCLIENT_VCN(VCN_ID)
);

PROMPT creating table ecs_compute_instances
create table ecs_compute_instances (
    OCID VARCHAR2(256) NOT NULL,
    CAVIUMID VARCHAR2(256),
    RACKNAME VARCHAR2(256),
    HOSTNAMELABEL VARCHAR2(256),
    AVAILABILITYDOMAIN VARCHAR2(64),
    SHAPE VARCHAR2(64),
    CONSTRAINT pk_compute_instances
        PRIMARY KEY (OCID),
    CONSTRAINT fk_ecsracks_computeinstance
        FOREIGN KEY(RACKNAME)
            REFERENCES ECS_RACKS(NAME)
);

PROMPT creating table ecs_oci_vnics
create table ecs_oci_vnics (
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
            REFERENCES ECS_COMPUTE_INSTANCES(OCID),
    CONSTRAINT fk_ocisubnet_ocivnic 
        FOREIGN KEY(SUBNETOCID)
            REFERENCES ECS_OCI_SUBNETS(OCID)
);

PROMPT creating table ecs_oci_console_connection
create table ecs_oci_console_connection (
    ID NUMBER NOT NULL,
    VMHOSTNAME VARCHAR2(512) NOT NULL,
    EXAUNITID NUMBER NOT NULL,
    PORT NUMBER NOT NULL,
    DOM0 VARCHAR2(512) NOT NULL,
    EXA_OCID varchar2(512) NOT NULL,
    CREATED_AT timestamp default systimestamp,
    CONSTRAINT pk_console_connection
        PRIMARY KEY (ID),
    CONSTRAINT fk_console_exaunit
        FOREIGN KEY(EXAUNITID)
            REFERENCES ECS_EXAUNITDETAILS(EXAUNIT_ID),
    CONSTRAINT fk_console_exocid
        FOREIGN KEY(EXA_OCID)
            REFERENCES ECS_EXADATA(exadata_id)
);
create sequence ecs_oci_console_conn_id_seq;

PROMPT creating table ecs_volumes
CREATE TABLE ecs_volumes(
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

PROMPT creating table ECS_EXA_VER_MATRIX
CREATE TABLE ECS_EXA_VER_MATRIX(
        id                                              NUMBER NOT NULL,
        os_version              varchar(100) NOT NULL, -- domu os version
        exa_version             varchar(500) NOT NULL, -- domu exadata version, supports comma separated values
        hw_model                        varchar(500) NOT NULL, -- dom0 model, supports comma separated values
        gi_version              varchar(500) NOT NULL, -- GI Version, supports comma separated values
        service_type    varchar(100) DEFAULT 'EXACS' NOT NULL, -- EXACS,ADBD, supports comma separated values
        created_at              timestamp DEFAULT systimestamp NOT NULL,
        updated_at              timestamp DEFAULT systimestamp NOT NULL,
        status        varchar(32) DEFAULT 'ENABLED' NOT NULL,
        CONSTRAINT ECS_EXA_VER_MATRIX_PK PRIMARY KEY(id),
        CONSTRAINT ECS_EXA_VER_MATRIX_OS_UNIQ UNIQUE(os_version, hw_model, exa_version, gi_version, service_type) enable,
        CONSTRAINT "CK_ECS_EXA_VER_MATRIX_STATUS" CHECK (status in ('ENABLED', 'DISABLED', 'EXCLUDED')) ENABLE
);
CREATE SEQUENCE ECS_EXA_VER_MAT_SEQ_ID nocache nocycle ORDER;

CREATE TABLE ECS_GRID_VERSION (
    id                                          NUMBER NOT NULL,
    gi_version          varchar(100) NOT NULL, -- domu os version
    created_at          timestamp DEFAULT systimestamp NOT NULL,
    updated_at          timestamp DEFAULT systimestamp NOT NULL,
    status        varchar(32) DEFAULT 'ENABLED' NOT NULL,
    CONSTRAINT ECS_GRID_VERSION_PK PRIMARY KEY(id),
    CONSTRAINT "CK_ECS_GI_VER_STATUS" CHECK (status in ('ENABLED', 'DISABLED', 'EXCLUDED')) ENABLE
    );
CREATE SEQUENCE ECS_GI_VER_SEQ_ID nocache nocycle ORDER;

PROMPT creating table ecs_sla_info
CREATE TABLE ecs_sla_info
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

CREATE SEQUENCE sla_info_id_seq START WITH 1;

CREATE OR REPLACE TRIGGER sla_info_id_trg
BEFORE INSERT ON ecs_sla_info 
FOR EACH ROW

BEGIN
  SELECT sla_info_id_seq.NEXTVAL
  INTO   :new.sla_info_id
  FROM   dual;
END;
/

PROMPT creating table ecs_sla_hosts
CREATE TABLE ecs_sla_hosts
(
    sla_host_id        number(10)    not null,
    hostname           varchar2(512) not null,
    domainname         varchar2(512) not null,
    hw_type            varchar2(64) CHECK (hw_type in ('VM', 'COMPUTE','CELL')) NOT NULL,
    CONSTRAINT pk_sla_hosts PRIMARY KEY(sla_host_id)
);

CREATE SEQUENCE sla_host_id_seq START WITH 1;

CREATE OR REPLACE TRIGGER sla_host_id_trg
BEFORE INSERT ON ecs_sla_hosts
FOR EACH ROW

BEGIN
  SELECT sla_host_id_seq.NEXTVAL
  INTO   :new.sla_host_id
  FROM   dual;
END;
/

PROMPT creating table ecs_metric_type
CREATE TABLE ecs_metric_type
(
    metric_type_id          number(3)     not null,
    name                    varchar2(512) not null,
    description             varchar2(512) not null,
    sla_impact              varchar2(8) not null,
    CONSTRAINT pk_metric_type_id PRIMARY KEY(metric_type_id)
);

PROMPT creating table ecs_cluster_metrics
CREATE TABLE ecs_cluster_metrics
(
    metric_cluster_id        number(10)    not null,
    exaocid                  varchar2(150) not null,
    metric_type_id           number(3) not null,
    timeutc_event            timestamp not null,
    raw_metric               blob not null,
    value                    varchar2(512) not null,
    hw_type                  varchar2(64) CHECK (hw_type in ('VM', 'COMPUTE','CELL')) NOT NULL,
    hostname                 varchar2(512) not null,
    CONSTRAINT pk_metric_cluster_id  PRIMARY KEY(metric_cluster_id),
    CONSTRAINT fk_metric_type_id  FOREIGN KEY (metric_type_id) REFERENCES ecs_metric_type(metric_type_id)
);


CREATE SEQUENCE ecs_cluster_metrics_seq START WITH 1;

CREATE OR REPLACE TRIGGER ecs_cluster_metrics_trg
BEFORE INSERT ON ecs_cluster_metrics 
FOR EACH ROW

BEGIN
  SELECT ecs_cluster_metrics_seq.NEXTVAL
  INTO   :new.metric_cluster_id
  FROM   dual;
END;
/

PROMPT creating table ecs_sla_infra_chkpoint
CREATE TABLE ecs_sla_infra_chkpoint
(
    exa_ocid         varchar2(150) not null,
    last_check       timestamp not null,
    CONSTRAINT pk_exaocid  PRIMARY KEY(exa_ocid)
);

PROMPT creating table ecs_sla_breach
CREATE TABLE ecs_sla_breach
(
    sla_breach_id           number(10) not null,
    metric_cluster_id       number(10) not null,
    sla_info_id             number(10) not null,
    time_event_start        timestamp not null,
    time_event_end          timestamp not null,
    breach_type             varchar2(100) CHECK (breach_type in ('availability', 'performance')) NOT NULL,
    CONSTRAINT pk_sla_breach_id  PRIMARY KEY(sla_breach_id),
    CONSTRAINT fk_metric_cluster_id  FOREIGN KEY (metric_cluster_id) REFERENCES ecs_cluster_metrics(metric_cluster_id),
    CONSTRAINT fk_sla_breach_info_id  FOREIGN KEY (sla_info_id) REFERENCES ecs_sla_info(sla_info_id)
);

CREATE SEQUENCE ecs_sla_breach_seq START WITH 1;

CREATE OR REPLACE TRIGGER ecs_sla_breach_trg
BEFORE INSERT ON ecs_sla_breach 
FOR EACH ROW

BEGIN
  SELECT ecs_sla_breach_seq.NEXTVAL
  INTO   :new.sla_breach_id
  FROM   dual;
END;
/


PROMPT creating table ecs_sla_breach_reason
CREATE TABLE ecs_sla_breach_reason
(
    sla_breach_id         number(10) not null,
    reason                varchar2(256) not null,
    CONSTRAINT pk_sla_breach_reason_id  PRIMARY KEY(sla_breach_id),
    CONSTRAINT fk_sla_breach_id  FOREIGN KEY (sla_breach_id) REFERENCES ecs_sla_breach(sla_breach_id)
);

PROMPT creating table ecs_sla_info_hosts
CREATE TABLE ecs_sla_info_hosts
(
    sla_info_id        number(10)    not null,
    sla_host_id        number(10)    not null
);

PROMPT creating table ecs_sla_breach_hosts
CREATE TABLE ecs_sla_breach_hosts
(
    sla_breach_id      number(10)    not null,
    sla_host_id        number(10)    not null
);

--creating ecs_wf_auto_retry_action_rule_table
PROMPT creating table ecs_wf_auto_retry_action_rule
create table ecs_wf_auto_retry_action_rule (
    wfname VARCHAR2(256) NOT NULL,
    taskname VARCHAR2(256),
    errorcode VARCHAR2(256),
    action VARCHAR2(256),
    CONSTRAINT wf_actionrule_pk PRIMARY KEY(wfname, taskname, errorcode)
);

-- creating ecs_lb_cookie_info
PROMPT creating table ecs_lb_cookie_info
create table ecs_lb_cookie_info
(
    status_uuid            varchar2(2048) not null,
    exacloud_hostname      varchar2(512) not null,
    lb_cookie              varchar2(2048),
    operation              varchar2(256),
    server_name            varchar2(256),
    start_time             timestamp,
    end_time               timestamp,
    CONSTRAINT pk_lb_cookie_id PRIMARY KEY ( status_uuid , exacloud_hostname)
);

-- -- creating ecs_exaservice_iorm_resources
create table ecs_exaservice_iorm_resources
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

-- -- creating ecs_exascale_vaults
create table ecs_exascale_vaults
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

create table ecs_exascale_nw (
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
      REFERENCES ecs_exadata(exadata_id)
      ON DELETE CASCADE
);

PROMPT Creating table database_heartbeat_task
create table database_heartbeat_task (
    server_name              varchar2(256),
    last_heartbeat_update    timestamp not null,
    status                   varchar2(128),
    constraint pk_db_health primary key(server_name)
);


PROMPT creating table ecs_snapshots
CREATE TABLE ecs_snapshots(
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

CREATE TABLE ECS_VMBACKUPHISTORY (
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


PROMPT creating table  ecs_lse_log
CREATE TABLE ecs_lse_log(
    lse_id number(10) not null, 
    oneview_requesttime timestamp not null,
    cp_requesttime timestamp not null,
    ecra_requesttime timestamp not null,
    ecradb_requesttime timestamp not null,
    ecradb_responsetime timestamp not null,
    CONSTRAINT pk_lse_id PRIMARY KEY (lse_id)
);

CREATE SEQUENCE lse_id_seq START WITH 1;

PROMPT Creating table ecs_operations_compatibility
create table ecs_operations_compatibility (
    operation varchar2(50) not null,
    compatibleoperation varchar2(50) not null,
    env varchar2(20) DEFAULT ON NULL 'bm' NOT NULL,
    CONSTRAINT ecs_operations_compatibility_pk PRIMARY KEY (operation, compatibleoperation, env)
);
CREATE TABLE ECS_ECRA_ARCHIVE (
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


whenever sqlerror exit FAILURE;
