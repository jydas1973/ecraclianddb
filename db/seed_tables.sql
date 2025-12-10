Rem
Rem seed_tables.sql
Rem
Rem Copyright (c) 2017, 2025, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      seed_tables.sql - Seed the ECRA schema with bootstrapping data
Rem      For more info refer to the file ecs/ecra/db/install_ecra_schema.sql
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
Rem      3. DELETE from <TABLE>
Rem     
Rem      No DDLs are allowed in this file
Rem      There should be one single commit in the end of the file.
Rem      Do not COMMIT in the middle of the file
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/seed_tables.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    luperalt    07/21/25 - Bug 38173167 - Added property to rotate dbcs
Rem                           agent user passswords
Rem    caborbon    04/30/25 - ENH 37799591 - Fixing Bug in insert query for
Rem                           LIMIT_PER_CABINET_EXTRALARGE_X11M property
Rem    zpallare    04/22/25 - Enh 37811586 - EXACC EF - Add yaml and support
Rem                           change for ef during infra creation and scale up
Rem    nitishgu    04/17/25 - bug 37822390 : ECRA ROLLING
Rem                           UPGRADE:'EXTENDED_CLUSTER_ID' PROPERTY CHANGED
Rem                           AFTER UPGRADE
Rem    jzandate    04/08/25 - Bug 37806372 - Remove IMDS V1
Rem    jzandate    04/02/25 - Enh 37675147 - Adding brancher for
Rem                           ImageBaseProvisioning
Rem    illamas     03/25/25 - Enh 37740901 - 19c support for exadbxs
Rem    jzandate    03/24/25 - Enh 37692741 - Adding property to use 6x9 for
Rem                           exacompute
Rem    essharm     03/02/25 - Bug 37249099 - FEDRAMP ENHANCEMENT: ECRA TO HAVE
Rem                           MECHANISM TO ROTATE ITS LISTENER CERTIFICATE
Rem    gvalderr    02/24/25 - Enh 37503396 - Enable auto undo/retry mechanism
Rem                           for vault-access creation workflow
Rem    jzandate    02/22/25 - Enh 37598887 - Adding exacloud wait time property
Rem    zpallare    02/13/25 - Bug 37583640 - EXACS: Delete two storage
Rem                           servers fails: error:oeda-2006: diskgroup sprc1
Rem                           requires at least 5 storage nodes
Rem    illamas     01/21/25 - Enh 37326852 FS exadbxs
Rem    zpallare    01/08/25 - Bug 37459422 - EXACS ECRA - Update zldra to zrcv
Rem                           in cross platform table for x11m
Rem    aypaul      12/10/24 - ER-37026081 add property to use body details for
Rem                           parsing status response.
Rem    jzandate    12/02/24 - Enh 36979503 - Saving systemvault into ecra
Rem                           archive
Rem    zpallare    11/28/24 - Enh 36754344 - EXACS Compatibility - create new
Rem                           apis for compatibility matrix and algorithm for
Rem                           locking
Rem    illamas     11/25/24 - Enh 37312529 - Support exadata 25.1
Rem    illamas     11/21/24 - Enh 37115247 - enable CUSTOM_GI
Rem    zpallare    11/08/24 - Enh 37260372 - EXACS X11M - Update x11m cell
Rem                           definitions by removing xrmem cc/cs
Rem    josedelg    11/07/24 - Enh 35677516 - Increase timeout for ongoing ops
Rem    zpallare    11/04/24 - Enh 37243715 - ECRA X11M - ECRA Should disable
Rem                           delete bonding for non eht0 nodes only
Rem    essharm     10/31/24 - Bug 37236181 - ECRA INSTALLATION FAILED:FAILED TO
Rem                           EXECUTE ROTATE_ECRA_CERTS.PY SCRIPT IN MAIN
Rem    zpallare    10/30/24 - Bug 37231258 - EXACS:X11M:Remove oeda_codename
Rem                           values for some models
Rem    zpallare    10/28/24 - Bug 37208679 - EXACS X11M - ZDLRA Flow should be
Rem                           also working for x11m-xrmen cells
Rem    zpallare    10/23/24 - Enh 37155618 - EXACC X11M - Implement new oeda
Rem                           types for compute/cell ecra -> oxpa
Rem    caborbon    10/23/24 - ENH 37208776 - Adding new cp codename for model
Rem                           subtypes
Rem    luperalt    10/22/24 - Bug 37202795 Fixed maxracks for X11 for exacc
Rem    zpallare    10/21/24 - Enh 37197440 - Add a way to force celltype and
Rem                           computetype during infra creation
Rem    caborbon    10/21/24 - ENH 37179993 - Adding new exacloud codename field
Rem                           in ecs_platform_info to store the modelsubtype name for OEDA 
Rem    zpallare    10/20/24 - Enh 37102594 - EXACS X11M - Update base system
Rem                           regular flow to take X11M-X(base) cells on
Rem                           algorithm
Rem    jzandate    10/18/24 - Enh 37159566 - Adding vmbackup history
Rem    zpallare    10/16/24 - Enh 37176101 - EXACS X11M - Validate zrcv flow
Rem                           for x-z models to only pick x11m-z models
Rem    llmartin    10/15/24 - Enh 37150594 - Allow different exadata version
Rem                           during CEI creation
Rem    gvalderr    10/14/24 - Enh 37127579 - Adding property for max size of
Rem                           customer domain name
Rem    caborbon    10/13/24 - ENH 37154198 - Inserting EF Cell information in
Rem                           ecs_hardware
Rem    zpallare    10/09/24 - Enh 37025371 - EXACC X11M Support for compute
Rem                           standard/large and extra large
Rem    hcheon      10/08/24 - 36061279 Scheduler changes for active/active 2c
Rem    essharm     10/08/24 - Bug 37070289 Adding ecra_ssv2_cert_path property
Rem    gvalderr    10/07/24 - Enh 37126647 - Removing the -2 form the X11M
Rem                           models
Rem    jzandate    10/04/24 - Enh 36906964 - Automating secure erase
Rem                           certificate upload to oss
Rem    gvalderr    10/03/24 - Enh 37128995 - Make filesystem feature enabled by
Rem                           default
Rem    caborbon    09/26/24 - Bug 37108140 - UPDATE DESCRIPTION TO REMOVE -2 ON
Rem                           ELASTIC X11M HARDWARE DEFINITION
Rem    jyotdas     09/25/24 - ER 37089701 - ECRA Exacloud integration to
Rem                           enhance infrapatching operation to run on a
Rem                           single thread
Rem    nitishgu    09/25/24 - BUG 37093574: ATPEXACLOUDJSONCREATION FAILING IN
Rem                           ECRA WITH UNABLE TO RETRIEVE THE VLAN RECORDS
Rem                           ERROR
Rem    nitishgu    09/25/24 - BUG 37093574: ATPEXACLOUDJSONCREATION FAILING IN
Rem    llmartin    09/23/24 - Enh 37081824 - Add property to skip add/delete
Rem                           storage precheck
Rem    zpallare    09/23/24 - Enh 36922155 - EXACS X11M - Base system support
Rem    caborbon    09/21/24 - ENH 37029692 - Changing ecs_hardware racksize
Rem                           values for Large/ExtraLarge for BM/EXACS
Rem    anudatta    09/18/24 - 37052085 - NEW API FOR ECRA_ACTIVE ACTIVE FLAG and ECRA_INFRA_SETUP flag
Rem    gvalderr    09/13/24 - Enh 37050952 - Changing default values of certain
Rem                           properties for decomposing
Rem    nitishgu    09/12/24 - 36991882 - ECRA TO SUPPORT EXTENDED CLUSTER VLAN
Rem    zpallare    09/09/24 - Enh 34972266 - EXACS Compatibility - create new
Rem                           tables to support compatibility on operations
Rem    illamas     08/30/24 - Enh 36918015 - Mark nathostname in ecs_domus and
Rem                           generate a new one for vm move
Rem    gvalderr    08/26/24 - Enh 36329200 - Adding asm power limit default
Rem                           value property
Rem    caborbon    08/26/24 - ENH 36908403 - Adding X11M-2 to the elastic
Rem                           platform info table
Rem    caborbon    08/20/24 - ENH 36955594 - Adding new property to control FS
Rem                           Encryption Feature on ADBD Provisionings
Rem    caborbon    08/20/24 - Bug 36969730 - Adding back property
Rem                           DOMU_OS_VERSION_OVERRIDING_ATP for Early Adopter
Rem                           Feature in ATP
Rem    caborbon    08/13/24 - ENH 36931770 - Adding new field in ecs_hardware
Rem                           for ecpu feature on X11
Rem    gvalderr    08/06/24 - Enh 36908332 - Adding required records for X11
Rem    llmartin    08/05/24 - Enh 36908696 - Preprov, configurable GI
Rem    cgarud      08/05/24 - EXACS-136976 - Fix QFAB reservation defaults and
Rem                           change column names
Rem    jzandate    07/31/24 - Enh 36902645 - Changing property
Rem                           REMOVE_KEYS_AFTER_PROVISIONING to disabled
Rem    abyayada    07/19/24 - 36842063 : Configurable min storage for clu
Rem                           creation
Rem    essharm     07/10/24 - Enh 36383801 - Adding config for ecs_lse_log
Rem                           table. Enabling this config will let ecra know to
Rem                           save log details to ecs_lse_log table
Rem    illamas     07/01/24 - Enh 36770879 - Reducing vm size for exacompute
Rem                           post ga phase1
Rem    jzandate    07/01/24 - Enh 36197323 - Adding new columns for network
Rem                           type and support status
Rem    llmartin    06/27/24 - XbranchMerge llmartin_bug-36742283 from
Rem                           st_ecs_23.4.1.2.6
Rem    caborbon    06/24/24 - Enh 36754615 - Adding property for FS Encryption
Rem                           by region
Rem    gvalderr    06/21/24 - Enh 36759971 - Changing ROCE_MIN_ELASTIC_COMPUTES
Rem                           to 1 by default
Rem    zpallare    06/10/24 - Bug 36711554 - EXACS: Update default value to
Rem                           enabled for BONDING_FOR_ELASTIC property
Rem    rgmurali    06/07/24 - Enh 36710874 - Seed data in state_lock_data
Rem    llmartin    06/06/24 - Bug 36702018 - Fix fresh install issues
Rem    pverma      05/28/24 - Add properties for XS Vault details sync
Rem    caborbon    05/27/24 - ENH 36659169 - Adding new property to force
Rem                           EarlyAdopter version in all new CEI
Rem    zpallare    05/24/24 - Enh 36628793 - ECRA EXACS - Add property
Rem                           description column for new properties
Rem    illamas     05/24/24 - Bug 36656481 - Exacompute change tmp from 3G to
Rem    jreyesm     05/24/24 - Bug 36655357. Change EXACS_MVM_MAX_ALLOWED_RACKS
Rem                           to 16.
Rem    jzandate    05/23/24 - Enh 36637427 - Updating properties for domu image
Rem                           version override
Rem    caborbon    05/22/24 - Bug 36641332 - Adding new Property for ATP Early
Rem                           Adopter Feature
Rem    jzandate    05/21/24 - Enh 36642660 - Adding BASE for BaseSystem in
Rem                           exadata matrix catalog
Rem    jzandate    05/17/24 - Bug 36630289 - Adding new property to control
Rem                           EXACS and ATP image_version separately
Rem    gvalderr    05/09/24 - Enh 36602015 - Adding EXACS_IGNORABLE_MOUNTPOINTS
Rem                           property
Rem    gvalderr    05/07/24 - Enh 36592196 - Set FILESYSTEM_FEATURE property
Rem                           enabled for fresh installs
Rem    jreyesm     05/07/24 - Bug 36592675. default value for
Rem                           restricted_sitegroup
Rem    illamas     05/07/24 - Enh 36588086 - Adjust grid for atp
Rem    caborbon    05/03/24 - Bug 36576562 - Adding Max SW Version property
Rem    jzandate    05/02/24 - Adding insert for new exadata image version to
Rem                           exa ver matrix
Rem    jzandate    04/30/24 - Enh 36564221 - Adding property to limit beta
Rem                           exadata image versions
Rem    pverma      04/25/24 - Insert property FleetVmStatusSyncJob
Rem    cgarud      04/20/24 - EXACS-125310 - QFAB reservation for expansion in
Rem                           highly utilized QFABs
Rem    jzandate    04/20/24 - Bug 36534927 - Adding property to override
Rem                           image_version on CS when using GI 23 and null
Rem                           image version
Rem    rgmurali    04/18/24 - Bug 36437100 - ExaDB-XS scale sanitycheck changes
Rem    illamas     04/18/24 - Enh 36529231 - Ocpu to ecpu ratio
Rem    rgmurali    04/14/24 - Bug 36505331 - e2e maintenance fix for exadb-xs
Rem    llmartin    04/12/24 - Enh 36340464 - Active-active, ip rules for
Rem                           multiple ECRAs
Rem    llmartin    04/05/24 - Bug 36488210 - Change SERVERNAME_INIT_VALIDATION
Rem                           default value
Rem    zpallare    04/03/24 - Bug 36308005 - EXACS: Fresh provisioning with 23c
Rem                           gi has 19cgi configured post provisioning
Rem    gvalderr    03/27/24 - Enh 36361990 - Correcting inserts for ecs oh
Rem                           space rule
Rem    gvalderr    03/27/24 - Enh 36449520 - Adding adbdmvm filesystem
Rem                           template sizes
Rem    illamas     03/26/24 - Bug 36390893 - Removing constraint of 900G for
Rem                           exacompute racks
Rem    gvalderr    03/25/24 - Enh 36361990 - Adding X8M Elastic OH size rules
Rem    gvalderr    03/14/24 - Enh 36405883 - Making property ECRA_STORAGE_DEST
Rem                           be db by default
Rem    zpallare    03/14/24 - Bug 36369842 - Update exacloud retry count value
Rem    jzandate    03/05/24 - Bug 36370137 - Change default value for vm gold
Rem                           backup retry timeout
Rem    jzandate    03/05/24 - Bug 36340175 - Update last_Update for vmbackupjob
Rem                           on every upgrade or update db
Rem    llmartin    03/04/24 - Enh 35878687 - Ecra instance validation
Rem    gvalderr    03/04/24 - Enh 36361990 - Changing total storage size for
Rem                           X10M
Rem    jzandate    03/01/24 - Bug 36344989 - Adding property to wait between
Rem                           batches
Rem    gvalderr    02/23/24 - Enh 36330149 - Adding filesystem migration
Rem                           complete property
Rem    gvalderr    02/16/24 - Enh 36268211 - Changing BASE_SYSTEM_MODELS
Rem                           default value
Rem    jbrigido    02/15/24 - Bug 36301987 - Changing mutable value to false
Rem                           for /crashfiles mountpoint
Rem    zpallare    02/09/24 - Enh 36212504 - ECRA ANALYTICS - Make sure old
Rem                           records are being removed from ecs_analytics
Rem    illamas     02/06/24 - Enh 36268622 - Decreasing GI for exacompute
Rem    seha        02/02/24 - Enh 35695712 Send CM metrics to T2
Rem    gvalderr    02/01/24 - Enh 36214478 - Correcting template value for
Rem                           exacs in filesystem
Rem    gvalderr    01/24/24 - Enh 36222099 - Changing size limit on OHomeRUles
Rem                           for X9M
Rem    luperalt    01/23/24 - Bug 36206167 Fixed Real domain for OC5
Rem    zpallare    01/22/24 - Enh 36165741 - EXACS: After termination of cei,
Rem                           elastic shape nodes needs to be patched to latest
Rem                           exadata version
Rem    caborbon    01/22/24 - Bug 36207227 - Removing updates on ecs_properties
Rem                           for VM backup
Rem    llmartin    01/16/24 - Bug 36165477 - Add parallel preprovisioning
Rem    gvalderr    01/10/24 - Enh 36174560 - modifying the exacc filesystem
Rem                           templates
Rem    pverma      01/09/24 - Add support NODE_RECOVERY_SOP_FROM_BACKUP
Rem                           property
Rem    jzandate    01/08/24 - Bug 36156767 - Changing interval to 7 days for
Rem                           vmbackup job
Rem    illamas     01/03/24 - Enh 36148326 - Change GCV from 32G to 2G
Rem    anudatta    12/21/23 - Bug 36080194 - Active active Phase 2A , enable autoretry
Rem    gvalderr    12/19/23 - Enh 36078029_1 - Adding filesystem mountpoints
Rem                           values for exaccmvm ib
Rem    jiacpeng    12/16/23 - add topology property
Rem    gvalderr    12/12/23 - Enh 36090848 - Changing handling of
Rem                           ECRA_STORAGE_DEST property
Rem    jzandate    12/11/23 - Enh 36096298 - Adding new property for preprov VM
Rem                           GI Deconfigure
Rem    zpallare    11/28/23 - Enh 35774761 - ECRA - Disabling trigger for
Rem                           exa_ver_matrix
Rem    llmartin    11/24/23 - Bug 36000274 - Move jobs to Active server
Rem    illamas     11/23/23 - Bug 36038143 - Adding missing X8-2 model to
Rem                           catalog ol7/ol8
Rem    caborbon    11/21/23 - Bug 35990354 - Adding new field to save the
Rem                           custom linux uid/gid value
Rem    gvalderr    11/09/23 - Enh 35998924 - Correcting exacsmvmminspecs
Rem                           crasfiles to no mutable
Rem    luperalt    11/03/23 - Bug 35951076 Added FS_ENCRYPTION property
Rem    jzandate    11/03/23 - Bug 15969374 - use the same trust store for auth
Rem                           provider methods
Rem    caborbon    11/02/23 - Bug 33779609 - Adding new field 'env' for
Rem                           ecs_hardware and a new view named 
Rem                           ecs_hardware_filtered
Rem    gvalderr    10/30/23 - Enh 35950877- add property to know if use 184 or
Rem                           443 overhead
Rem    illamas     10/27/23 - Catalog support more than one exaversion
Rem    jyotdas     10/25/23 - Abort ecra wf when infra patching wf has failed
Rem    gvalderr    10/19/23 - Enh 35945349 - Changing minimum values for boot
Rem                           and reserved and adding exacs svm min template
Rem    caborbon    10/18/23 - Bug 35792183 - Adding properties to control the
Rem                           limits for Model Subtypess
Rem    caborbon    10/18/23 - Bug 35792183 - Adding properties to control the
Rem    illamas     10/17/23 - Enh 35920336 - Modify size for system
Rem    gvalderr    10/16/23 - Enh 35870618 - Adding num_servers column to
Rem                           ecs_elastic_platform_info table
Rem    jzandate    10/02/23 - Enh 35769747 - Adding properties for gold vm
Rem                           backup
Rem    gvalderr    10/09/23 - Enh 35875930 - Changing exacc filesystem name for
Rem                           grid_home
Rem    jzandate    10/05/23 - Bug 35880434 - Change default vmbackup job state
Rem    caborbon    10/04/23 - Bug 35859903 - Adding FAULT_DOMAIN property
Rem    caborbon    09/29/23 - Bug 35859903 - adding update statement to avoid
Rem                           FD null in ecs_hw_cabinets
Rem    gvalderr    09/25/23 - Enh 35842708 - Adding template fields for minimum
Rem                           sizes in filesystem for exacsmvm
Rem    zpallare    09/25/23 - Bug 35810502 - Fix bug in update vmossbackup
Rem                           property
Rem    illamas     09/12/23 - Bug 35792160 - Fix X9M-2 ecs_hardware values
Rem    jzandate    09/11/23 - Bug 35777412 - Updating ADBD to ATP for
Rem                           EXA_VER_MATRIX
Rem    illamas     09/06/23 - Enh 35677356 - GI support
Rem    llmartin    09/08/23 - Bug 35747355 -Preprov, set correct rack state
Rem                           after delete service
Rem    jreyesm     09/01/23 - Bug 35582806. disabled vmback property.
Rem    jreyesm     08/31/23 - Bug 35582806. Enable BASESYSTEM_USE_BONDING_INPUT
Rem                           by default.
Rem    hcheon      08/30/23 - 35197827 Use OCI instance metadata v2
Rem    abysebas    08/30/23 - Enh 35758198 - SET DEFAULTS VALUE OF
Rem                           CAPACITY_EXPANSION AS TRUE
Rem    jzandate    08/24/23 - Bug 35743292 - Adding ecra property for oci auth
Rem                           path
Rem    essharm     08/23/23 - Bug 35729575 - REMOVE SWITCHES METRICS FOR SLA
Rem                           SLO
Rem    jzandate    08/17/23 - Bug 35698870 - Toggle vmboss su config with ecra
Rem                           property
Rem    gvalderr    08/16/23 - Adding update statemete for ECRA STORAGE property
Rem    jbrigido    08/10/23 - Bug 35698800 Changing some wrong property values
Rem    gvalderr    08/09/23 - Enh 35654996 - Correcting mutable field from u02
Rem                           insert
Rem    jzandate    08/08/23 - Bug 35668830 - Changing job name and config
Rem                           metadata
Rem    jzandate    08/04/23 - Enh 35651071 - Add property to delete ecra db
Rem                           files older than 1Y on ecra start
Rem    seha        08/03/23 - Enh 34546732 - Add EcLogScanner retry count
Rem    caborbon    08/03/23 - Bug 35672672 - Fixing X10M-2 Catalog in
Rem                           ecs_hardware
Rem    kukrakes    07/31/23 - Bug 35649220 - USER PASSWORD IN ECRA-NG NEEDS TO
Rem                           BE SALTED, IT IS HASHED USING SHA-256 TODAY)
Rem                           [Secure Bug] ACL
Rem    gvalderr    07/26/23 - Modyfying elastic stepwise addition properties
Rem                           update statement.
Rem    abyayada    07/24/23 - 35617302 - ADD SUPPORT FOR CREATE READ ONLY PAR
Rem                           URL
Rem    illamas     07/24/23 - Enh 35622639 - Convert casing attributes
Rem    jzandate    07/21/23 - Enh 35602217 - Adding properties for image
Rem                           version overrides for domu provision, only for
Rem                           adbd
Rem    caborbon    07/14/23 - Bug 35567246 - Adding property to
Rem                           enabled/disabled X9M-2 Large
Rem    hcheon      07/10/23 - 34764008 Added LUMBERJACK_INFO
Rem    llmartin    07/21/23 - Enh 35624372 - Create CEI_SKIP_SERASE property
Rem    aadavalo    06/27/23 - Enh 35543208 - Add vmbackup status tracker
Rem    essharm     06/29/23 - SeedSeeding Sla Mertic Types
Rem    illamas     06/27/23 - Enh 35510460 - Enhacement for exacompute
Rem                           templates
Rem    gvalderr    06/22/23 - Modifying EXACLOUD_CS_SKIP_SWVERSION_CHECK
Rem                           property
Rem    rgmurali    06/19/23 - ER 35516416 - Add support for flex shapes
Rem    jzandate    06/13/23 - Bug 35402924 - Adding new tables for exadata 23
Rem                           compatibility matrix
Rem    gvalderr    06/12/23 - Adding MAX_MOUNT_SIZE property value
Rem    caborbon    06/12/23 - Bug 35417101 - Adding support for X9M-2 Large -
Rem                           2TB
Rem    gvalderr    06/09/23 - Adding registries to ecs_gold_specs for exaccmvm
Rem                           and exaccadbdmvm
Rem    aadavalo    06/05/23 - Bug 35460577 - Set gold image backup as disabled
Rem                           by default
Rem    bshenoy     06/01/23 - Bug 35453247: support error code in powermock
Rem    abyayada    06/01/23 - Bug 35432526 - MAKE THE SQL CHANGES EBR
Rem                           COMPATIBLE IN TRANSACTION
Rem                           HTTPS://ORAREVIEW.US.ORACLE.COM/126730528
Rem                           ABYAYADA_BUG-34988256 (ECRA: CREATE INFRA API
Rem                           REQUEST SPECIAL ATTRIBUTE FOR RACK MIGRATION)
Rem    illamas     06/01/23 - Enh 35388181 - Adding more ONSR regions
Rem    jzandate    05/30/23 - Enh 35425757 - Adding compartment override by
Rem                           user input
Rem    hcheon      05/25/23 - 35414915 ECRA json logging
Rem    llmartin    05/25/23 - Enh 35403512 - Preprov, create bonded
Rem                           configuration
Rem    gvalderr    05/25/23 - Adding elastic stepwise addition properties
Rem    caborbon    05/23/23 - Bug 35370235 - Adding support for X10M-2
Rem                           ExtraLarge nodes
Rem    illamas     05/19/23 - Bug 35410985 - Fixes for template
Rem    jiacpeng    05/17/23 - enable SLA by tenancy
Rem    bshenoy     05/16/23 - X10M-2 new config XL
Rem    aadavalo    05/10/23 - EXACS-104356 - Add gold VM backup support for ecra
Rem    illamas     05/06/23 - Enh 35268841 - Exacompute templates
Rem    llmartin    05/05/23 - Enh 35048274 - Preprov, launch vm cluster
Rem                           creation
Rem    ddelgadi    04/27/23 - Bug 35219691 - add X9M-2 for BASE_SYSTEM_MODELS
Rem    llmartin    04/24/23 - Enh 35047850 - Preprov, configure dbNode job
Rem    illamas     04/18/23 - Enh 35215344 - GoldSpecs FA support
Rem    llmartin    04/18/23 - Enh 35297632 - Setup authentication for
Rem                           networking node
Rem    caborbon    04/11/23 - Bug 35177584 - Adding support for X10M2 Large
Rem                           computes
Rem    ddelgadi    04/10/23 - Enh 35241763 Remove X6-2 for BASE_SYSTEM_MODELS
Rem    abyayada    04/06/23 - ENH 34988256 - Create Infra enhancement for Rack
Rem                           Rehome
Rem    illamas     04/01/23 - Enh 35064034 - Adding more ONSR regions
Rem    aadavalo    03/31/23 - Enh 35132786 - Update specs of vmbackup job
Rem    llmartin    03/28/23 - Enh 35047969 - ExaCS Preprovision - Create
Rem                           Infrastructure job
Rem    luperalt    03/06/23 - Bug 35145654 Updated TLS_CA_BUNDLE_PATH value
Rem    illamas     03/01/23 - Enh 35126723 - Discover IP property
Rem    josedelg    02/28/23 - Bug 35069021: Add support for CPS OS Upgrade V1
Rem                           api along with V2 api
Rem    bshenoy     02/28/23 - update memory, storage & ohome for x10m
Rem    caborbon    02/23/23 - Bug 35006542 - Updating values for X10M-2
Rem                           Cabinets
Rem    luperalt    02/22/23 - Bug 35107681 Removed WSSERVER,WSADMIN,WSPROXY
Rem                           from CERT_ROTATION_LIST
Rem    aadavalo    02/22/23 - Enh 35048435 - Changes in schema for preprov
Rem    jzandate    02/21/23 - Ehn 35048488 - Create CEI supports preprov infra
Rem    bshenoy     02/20/23 - Bug 35097829: Update Cluster count to 12 for X10M
Rem                           model
Rem    illamas     02/18/23 - Bug 35098451 - ADBD mvm filesystem
Rem    luperalt    02/17/23 - Bug 34792737 Added TLS_CA_BUNDLE_PATH
Rem    llmartin    02/15/23 - Enh 35047827 - OCI Preprov, VCN and SUBNET job
Rem    bshenoy     02/14/23 - Bug 35081786: Add entry for racksize=ALL and
Rem                           model X10M
Rem    aadavalo    02/11/23 - ENH 35044023 - Modify default value of delta for
Rem                           relaxed version
Rem    bshenoy     02/06/23 - Bug 35046037: Set Ohome rule for x10m
Rem    jyotdas     01/31/23 - BUG 35030506 - Add free_under_maint status to
Rem                           clusterless property and handle node not found
Rem                           scenario
Rem    llmartin    01/23/23 - Enh 34983738 - Attach storage stepwise for ExaCS
Rem                           MVM
Rem    illamas     01/30/23 - Enh 35000918 - Delete compute, add minimum
Rem                           computes to depend on a property
Rem    rgmurali    01/24/23 - ER 34953026 - Support concurrent db updates for active-active
Rem    kukrakes    01/31/23 - ENH 34921831 - ECRA UPGRADE AND EBR FLOW
Rem                           (INCLUDES DEPLOYER , APPLICATION AND DATABASE
Rem                           CHANGES)
Rem    gvalderr    01/24/23 - Enh-34710742 - Adding ECRASTORAGE property
Rem    jzandate    01/23/23 - Bug 34932304 - Adding more time to exacloud
Rem                           connection timeout
Rem    ririgoye    01/20/23 - Enh 34808479 - Added property cache cleanup
Rem                           scheduled job
Rem    llmartin    01/18/23 - Enh 34992359 - Enable attach compute stepwise
Rem    jyotdas     01/04/23 - BUG 34877457 - make domu precheck and patch
Rem                           failures as fail_and_show
Rem    bshenoy     12/21/22 - Ecra support for X10M-2 model
Rem    essharm     10/17/22 - Seeding sla slo metric collection fequency
Rem    jyotdas     12/20/22 - Enh 34713683 - Handle free nodes in patching 
Rem    pverma      12/14/22 - Serial Console History changes
Rem    illamas     12/14/22 - Enh 34892203 - Modify tmp and u01 of mvm to match
Rem                           svm filesystem
Rem    bshenoy     11/25/22 - Bug 34654356: Support X10M hardware
Rem    llmartin    11/25/22 - Enh 34830053 - Metadata precheck for rack during
Rem                           CEI creation
Rem    jyotdas     11/15/22 - ENH 34696986 - Exacompute:Enhance patch config
Rem                           endpoint to have value for
Rem                           maxconcurrentpatchrequests
Rem    bshenoy     11/02/22 - Bug 34712586: Support DRCC-Include realm domains
Rem                           as a part of ocpsSetup json
Rem    caborbon    10/31/22 - Bug 34722441 - Updating value of
Rem                           STATUS_UPDATER_THREAD_POOL_SIZE property to 20
Rem    illamas     10/31/22 - Bug 34707424 - Increase tb storage value
Rem    luperalt    10/26/22 - Bug 34729800 Changed time out to a property in
Rem                           the DB
Rem    aadavalo    10/14/22 - Enh 34394111 - Adding values for admin and user
Rem                           in user mangament roles
Rem    illamas     10/14/22 - Bug 34704950 - Fix tbstorage calculation
Rem    jiacpeng    10/11/22 - Making the property SLA_EXACLOUD_JOB_CONCURRENCY
Rem                           deafult value as 16. So it avoids envoke too many
Rem                           threads to corrupt the system.
Rem    abysebas    10/10/22 - Enh 33505376 - ENHANCE ECRA TO ASSIGN CLUSTER
Rem                           BASED ON CAPACITY
Rem    abysebas    10/07/22 - Enh 33505376 - ENHANCE ECRA TO ASSIGN CLUSTER
Rem                           BASED ON CAPACITY
Rem    rmavilla    09/22/22 - EXACS-91468 ALLOW ECRA TO IMPORT A PARTIALLY
Rem                           INGESTED CABINET
Rem    luperalt    09/07/22 - Bug 34572631 added hardware records for
Rem    bshenoy     09/06/22 - Bug 34543297: increase retry count & sleep cycle
Rem                           for ecra exacloud calls
Rem    jyotdas     09/01/22 - ENH 34350092 - Handle validations and
Rem                           configuration parameters for exacompute patching
Rem    byyang      08/30/22 - bug 34396610 disable
Rem                           EXACD_OUTPUT_EXADATA_LOG_TO_LUMBERJACK
Rem    bshenoy     08/25/22 - Bug 34531990: support x7 infrastructure for add
Rem    jvaldovi    08/19/22 - Enh 33226278 - Ecra, Include Instance Principals
Rem                           For Authentication In Oci
Rem    sdevasek    08/16/22 - ENH 34400333 - EXACOMPUTE IMAGE REGISTRATION
Rem    ddelgadi    08/05/22 - Bug 34452861 - add property to sent to exacloud to 
Rem                           validate or not exadataimage version 
Rem    bshenoy     08/04/22 - Bug 34458050: Add support for V1 api along with
Rem                           V2 api
Rem    bshenoy     07/14/22 - Bug 34385903:fix cluster count for elastic
Rem                           racksize
Rem    hcheon      07/11/22 - 34340409 Changed properties for Lumberjack
Rem    aadavalo    07/11/22 - Bug 34228488 - add property to handle max version
Rem                           delta in CEI creation
Rem    illamas     07/07/22 - Enh 34358535 - Adding asmss parameter
Rem    ddelgadi    06/29/22 - Bug 34331186 Disable propertie of create starter db
Rem    llmartin    06/27/22 - Enh 32205490 - Stepwise for attach compute
Rem    luperalt    06/27/22 - Bug 34325030 Fixed max racks elastic
Rem    illamas     06/22/22 - Enh 34045327 - Add natgateway configuration for
Rem                           mvm domu host
Rem    luperalt    06/07/22 - Bug 34250544 Fixed maxracks by model
Rem    essharm     05/25/22 - enh-34165843Added new property to rotate
Rem                           dataplane encryption key every 60 days
Rem    luperalt    05/24/22 - Added hadware entry for elastic X8-2
Rem    cgarud      05/22/22 - EXACS-89789 - turn off no-db-activity event
Rem    aadavalo    05/06/22 - BUG 34096543 - EXACS ECRADPY TO REPORT POST CHECK
Rem                           FOR ALL PROPERTIES THAT HAVE CHANGED
Rem    mpedapro    04/28/22 - Enh::33903288 adding suppport for exacc network
Rem                           reconfigure
Rem    llmartin    04/27/22 - Bug 34090698 - Add X8M-2 to BaseSystem models
Rem    rgmurali    04/21/22 - Bug 33033823 - Change bonding to workflow based model.
Rem    jvaldovi    04/12/22 - Enh 34045489 - Jumbo Frames Setup On X9m
Rem    caborbon    04/06/22 - Bug 33983946 - Changing the value of property
Rem                           EXACS_MVM_MAX_ALLOWED_RACKS from 16 to 8
Rem    aadavalo    04/05/22 - Bug 34037510 - UPGRADE SET ATP_PREPROVISION ECRA
Rem                           PROPERTY TO DISABLED AS DEFAULT
Rem    illamas     04/04/22 - Enh 34034291 - gb memory for exacompute
Rem    abherrer    03/31/22 - ER 33372007 - Adding service type catalog
Rem    hcheon      03/30/22 - 33947401 Added SLA properties
Rem    illamas     03/28/22 - Enh 33969007 - Add ethernet gb information for
Rem                           x9m and x10m
Rem    rgmurali    02/28/22 - ER 33907092 - Exascale storage vlan
Rem    rgmurali    02/15/22 - Bug 33801928 retain ociurlmap across upgrades
Rem    hcheon      02/08/22 - 33691502 Added SLA gathering
Rem    illamas     02/04/22 - Enh 33820899 Adding data/reco checks
Rem    llmartin    02/02/22 - Bug 33813535 - Consider Bonding in BaseSystem
Rem                           reservation
Rem    illamas     01/31/22 - Enh 33214491 - Add mvm support for postchecks
Rem                           framework
Rem    illamas     01/28/22 - Bug 33801972 - Update cores to 126 per node for
Rem                           x9m models
Rem    llmartin    01/20/22 - Bug 33775123 - Update X9M-2 memory
Rem    illamas     01/19/22 - Property for exacompute cells
Rem    jvaldovi    01/11/22 - Enh 33605620 - Ecra Deployer To Create
Rem                           Regions-Config.Json And Communicate Changes To
Rem                           Exacloud
Rem    marislop    12/17/21 - BUG 33658022-Avoid vulnerability clear text
Rem    aadavalo    12/14/21 - Enh 33612595 - VM-BACKUP: OS VM BACKUP TOOL NEEDS
Rem                           TO PROVIDE SUPPORT FOR FAILED BACKUPS
Rem    hcheon      12/14/21 - 33656919 Merge CM workarounds
Rem    hcheon      11/15/21 - 33563885 Changed CM pause rule for bonding
Rem    jvaldovi    11/03/21 - Enh 33532354 - X9m - Adbd Direct Launch -
Rem                           Atp_Preprovision Value Is Not Retained Across
Rem                           Upgrades
Rem    illamas     10/20/21 - Bug 33479721 - Fixing inventory reserve issues
Rem                           for idemtoken
Rem    jvaldovi    10/13/21 - Bug 33457514 - change maxcores pernode to x9-m2
Rem                           hardware
Rem    illamas     10/12/21 - Enh 33444585 - Enhancement for postChecks
Rem    mpedapro    10/08/21 - Enh::32864894 adding valid rack exceptions to ecs
Rem                           properties
Rem    bshenoy     10/04/21 - Bug 33399711: send mock error when mock_error
Rem                           mode is enabled
Rem    jreyesm     09/30/21 - Remove exacs mvm feature flag.
Rem    marislop    09/24/21 - ENH 33368545 Admin Weblogic host and port
Rem    rgmurali    09/22/21 - Bug 33379072 - Clustertag fix for elastic shape
Rem    essharm     09/08/21 - Adding OCI_ECRA_TENANCY_ID in ecs_properties
Rem    piyushsi    08/19/21 - Bug 33159220 - Elastic Cross Platform Support
Rem    jvaldovi    08/12/21 - Enh 33210767 - Enable Ecra Scheduler For Deleting
Rem                           Vm Backups From Objectstore
Rem    luperalt    08/12/21 - tmp
Rem    illamas     08/12/21 - Bug 33214951 - Fixed backup network for jumbo in
Rem                           atp case
Rem    luperalt    08/11/21 - Bug 33214685 Added maxracks to x7 and x8 racks
Rem                           models
Rem    hcheon      08/10/21 - 33090623 Added ecs_compliance_pause_rule
Rem    illamas     08/09/21 - Enh 33055641 - New apis for rack reserve/release
Rem    abyayada    08/09/21 - Bug 33042605 - Configurable request wait cycles to
Rem			      cps for custom image ops
Rem    luperalt    08/05/21 - Bug 33194821 Fixed maxracks quarter and eight
Rem    byyang      08/02/21 - bug 32932746. Change scheduler target_server
Rem                           scheme
Rem    illamas     08/02/21 - Bug 33170510 - Fixing model sizes for u02 check
Rem    llmartin    08/01/21 - Enh 33055636 - MVM, Exadata Infrastructure
Rem                           initial metadata
Rem    hcheon      07/31/21 - 33140149 Added CM_REPORT_SKIP_LIST property
Rem    rgmurali    07/28/21 - Enh 33165592 - Bonding with X6-2 support
Rem    bshenoy     07/22/21 - Support node subset add and delete cluster
Rem    seha        07/21/21 - Bug 30438363 - Add STIG_SCAN_REALMS properties
Rem    piyushsi    07/18/21 - BUG-33113808 Workflow Task Failure Retry Feature
Rem    illamas     07/16/21 - Bug 33116643 - The mandatory field is wrong when
Rem                           the result is stored in DB
Rem    rgmurali    07/12/21 - ER 33020203 - Precheck changes with X9M
Rem    illamas     07/09/21 - Enh 33037280 - FEDRAMP parameter
Rem    jvaldovi    07/01/21 - Enh 33070332 - X9M-2: Increase memsize from 1390
Rem    rgmurali    06/30/21 - ER 33020098 - X9M support for elastic
Rem    illamas     06/30/21 - Enh 33055022 - Adding more validations for
Rem                           postcheck framework
Rem    illamas     06/23/21 - Enh 32983245 - Refactor to avoid duplicated
Rem                           records
Rem    kvimal      06/06/21 - Updated for ParUrl Rotation
Rem    rgmurali    06/11/21 - ER 32992005 - Change capacity reserve for bonding
Rem    llmartin    06/11/21 - Bug 32887643 - Remove keys after provisioning
Rem    jvaldovi    06/03/21 - Enh 32848008 - Ecra. X9m Enhancements
Rem    rgmurali    05/17/21 - ER 32810345 - Support bonding migration
Rem    llmartin    05/26/21 - Enh 32883455 - URM Reconfig workflow
Rem    rgmurali    05/17/21 - ER 32810345 - Support bonding migration
Rem    byyang      05/12/21 - bug 32322406. add DIAG_PRE_LOGCOL type props
Rem    illamas     05/10/21 - Enh 32848331 - Add more validations in postchecks
Rem    jvaldovi    04/19/21 - Adding VM Backup Job
Rem    bshenoy     05/07/21 - Backport bshenoy_bug-32792701 from
Rem                           st_ecs_21.1.1.0.0
Rem    illamas     04/28/21 - Enh 32677648 - Update se linux policy on
Rem                           provisioned clusters
Rem    luperalt    04/08/21 - Bug 32161011 Removed hardcoded default password
Rem    hcheon      04/08/21 - Bug 32742071 - Fixed X7-2 double rack
Rem    bshenoy     04/05/21 - Bug 32149280: increase timeout for
Rem                           reshape-service and elastic operation
Rem    llmartin    03/25/21 - Enh 32669837 - Execute SanityCheck from Capacity
Rem                           Reserve API
Rem    illamas     03/25/21 - Enh 32669782 - Functional completion of ceiCreate
Rem                           API in ECRA
Rem    cgarud      03/15/21 - exaie_events_switches values indicating ON/OFF
Rem                           switches for each event
Rem    llmartin    03/09/21 - Enh 32555427 - Parallel compute addition
Rem    illamas     03/04/21 - Enh 32347095 - Define json config testing
Rem                           template for config check
Rem    rgmurali    03/04/21 - Bug 32587586 - Add agentAuth to instance metadata
Rem    llmartin    03/04/21 - Enh 32325568 - Add pre-checks for elastic scale
Rem                           up
Rem    rgmurali    02/28/21 - Bug 32546169 - Small fixes for CEI
Rem    jreyesm     02/26/21 - E.R 32503057. Elastic shapes.
Rem    illamas     02/22/21 - Bug 32438102 - Increasing timeout for
Rem                           createATPDbSystem
Rem    piyushsi    02/11/21 - BUG-32357781 EXACLOUD_DS_SINGLE_STEP_PROVISIONING
Rem                           for single step delete service
Rem    illamas     02/11/21 - Enh 32079911 - add cert path for onsr realms
Rem    rgmurali    02/02/21 - Bug 32453312 - Add ZDLRA to supported cluster tags.
Rem    pverma      01/25/21 - update usable OH size for x9m
Rem    llmartin    01/22/21 - Enh 32205491 - Stepwise for cell attachment
Rem    gmandali    01/21/21 - 31163153 properties to enable communication with
Rem                           fleet patching engine in management VCN
Rem    jreyesm     01/21/21 - Bug 32391619. Change iaas DEFAULT_CORES to 2.
Rem    josedelg    01/08/21 - ENH 31634262, 31634316, 31635079 mocks for 
Rem                           preactivacion, activation and create newtwork object
Rem    pverma      01/06/21 - Add new columns for IV and SALT
Rem    rgmurali    01/02/21 - ER 32133333 - Support Elastic shapes
Rem    rgmurali    01/02/20 - ER 32337905 - Add bonding info in delete-service
Rem    bshenoy     12/21/20 - Bug 32245522: Support x9m-2 exadata model
Rem    joseort     12/15/20 - Adding Oci Vault secret rotation Job.
Rem    rgmurali    12/13/20 - ER 32201418 - Capacity reservation changes for X8M
Rem    bshenoy     12/08/20 - Bug 32245522: Support x9m-2 exadata model
Rem    illamas     12/08/20 - Enh 32015878 - Support for X9 models
Rem    rgmurali    01/02/20 - ER 32337905 - Add bonding info in delete-service
Rem    nmallego    11/18/20 - Bug-32059474  - Add  value for
Rem                                          EXACC_EXADATA_PATCH_TARGET_VERSION
Rem    hcheon      11/13/20 - bug-32149173 Add casper, auth to ecs_ociservices
Rem    seha        11/11/20 - Bug-31635349 Upload report to CSS bucket 
Rem    illamas     11/10/20 - Enh 32139044 - Property for mock cp flow
Rem    llmartin    11/05/20 - Enh 32069434 - Parallel elastic addition for
Rem                           storage
Rem    rgmurali    10/31/20 - ER 32056304 - ZDLRA support on ExaCS
Rem    illamas     10/29/20 - Bug 32078131 - Getting onsr realms using a
Rem                           property
Rem    llmartin    10/21/20 - Bug 32038247 - Add BASE_SYSTEM_MODELS from BASE
Rem                           system algorithm
Rem    luperalt    10/13/20 - Bug 31956971 Added LOG_COL_BUCKET seed
Rem    gmandali    09/25/20 - 31163153 feature property to enable communication
Rem                           with fleet patching engine in management VCN
Rem    llmartin    10/01/20 - Bug 31930130 - Cluster details cache feature flag
Rem    rgmurali    11/12/20 - Bug 31880560 - Change max cells to 64 for KVM ROCE
Rem    jvaldovi    09/18/20 - Adding property to bypass KMS movement
Rem    bshenoy     09/16/20 - Bug 31708469: Add mock tests for CPS upgrade flow
Rem    llmartin    09/08/20 - Enh 31711533 - Support new ELASTIC rack shape
Rem    marcoslo    09/08/20 - ER 31856863 - enable ADB-S in ecra
Rem    talagusu    09/08/20 - Bug 31849473 - EXACC GEN1 X7-2 BASE SYSTEM TOTAL
Rem                           MAXIMUM NUMBER OF ENABLED CPU CORES
Rem    rgmurali    09/04/20 - ER 31850640 - setup bonding API changes
Rem    pverma      09/01/20 - Update new OHOME size values for X8M
Rem    illamas     08/20/20 - Enh 31782184 - ECRA versioning to reflect the one
Rem                           off patches applied
Rem    illamas     08/18/20 - Enh 30945957 - Send gi version to exacloud
Rem                           instead of enablegilatest
Rem    aabharti    08/04/20 - Enh 31708707 - ADD ECS PROPERTY TEST_MODE FOR JUNIT
Rem    pverma      07/30/20 - Add OCI_EXACC_SIMULTED_ENV to ecs_properties
Rem    llmartin    07/29/20 - Enh 31675462 - set ELASTIC_CDB_EXTENSION property
Rem                           ENABLED by default
Rem    llmartin    07/31/20 - Bug 31698739 - Remove extra space in
Rem                           ELASTIC_CDB_EXTENSION property
Rem    llmartin    07/21/20 - Enh 31638150 - Sent CDB list only if
Rem                           ELASTIC_CDB_EXTENSION is enabled
Rem    pverma      07/14/20 - update X8M values for storage to match public
Rem                           documentation.
Rem    rgmurali    07/12/20 - Bug 31607840 - Ecra IP allocation based on hw_nodes
Rem    hcheon      07/08/20 - ER 31152543 Add SANITYCHECK_RUN_TIMEOUT property
Rem    illamas     07/07/20 - Enh 31585186 - ECRA property to turn on SE Linux
Rem                           and FIPS
Rem    sdeekshi    01/07/20 - Bug 31564449: CLEANUP NON USEFUL XIMAGES CODE
Rem    llmartin    06/10/20 - Enh 31470743 - Update memory info for X8M-2
Rem    rgmurali    06/06/20 - ER 31446572 Use OCI realms
Rem    bshenoy     06/02/20 - Bug 31432109 : wss not being set to default
Rem                           admin_headend_type durig ecra upgrade
Rem    rgmurali    05/31/20 - ER 31170843 - Bonding payload changes.
Rem    luperalt    05/27/20 - Bug 31404560 Add oci metadata instance URL
Rem    kvimal      05/13/20 - adding property SKIP_OCI_PAR_URL_CREATION
Rem    rgmurali    05/07/20 - ER 31317950 - validate against max elastic expansion
Rem    llmartin    05/07/20 - Bug 31235032 - ASM rebalance power for OCI Cell
Rem                           addition
Rem    rgmurali    05/04/20 = Bug 31257809 - Correct the endpoints for LTN region
Rem    jreyesm     04/30/20 - Remove sdk_version to refactor.
Rem    rgmurali    04/21/20 - ER 30971270 Inventory reserve/release APIs
Rem    rgmurali    04/19/20 - Bug 31196760 - Make VLAN ranges configurable for KVM RoCE
Rem    joseort     04/07/20 - Changes for cert rotation staggered.
Rem    luperalt    03/16/20 - Bug 31040089 Added properties for Secret Service
Rem                           feature
Rem    bshenoy     04/07/20 - Bug 31059390: make WSS as default for ADMIN VCN
Rem    pverma      04/07/20 - update oh space rule for x8-2
Rem    aabharti    04/07/20 - Bug 31130288 - Rolling upgrade support PREPROV_RECONFIG_TIMEOUT 
Rem    rgmurali    04/01/20 - ER 31057723 - KVM RoCE create service changes
Rem    llmartin    04/02/20 - Bug 31106568 - Additional ports for iptables
Rem                           rules
Rem    yyingl      03/27/20 - 31030128 - SCHEDULER FOR CERTIFICATE ROTATION
Rem    panmishr    03/11/20 - 30994178 - ROLLING UPGRADE : DISABLE PROGRESS OF
Rem                           WORKFLOWS UNTIL THE SERVER SWITCH OVER TASK HAS
Rem                           FINISHED.
Rem    rgmurali    03/06/20 - XbranchMerge rgmurali_bug-30870817 from
Rem                           st_ecs_pt-x8m
Rem    luperalt    02/27/20 - Bug 30926876 WSS Support
Rem    aabharti    02/19/20 - Bug 30764493 - block capacity reserve and rolling upgrade properties
Rem    bshenoy     02/14/20 - wss support
Rem    panmishr    01/30/20 - EXACS-30673: Support for rolling upgrade of ECRA   
Rem    llmartin    02/12/20 - Enh 30750950 - Validate if patcher script exists.
Rem    panmishr    02/05/20 - 30703275 - ECRA API SUPPORT TO CALL NEW EXACLOUD
Rem                           FORCE STOP API
Rem    panmishr    01/27/20 - 30804733 - WORKFLOW SHOULD BE SET TO NO-RESTART
Rem                           BY DEFAULT AFTER SERVER RESTART
Rem    llmartin    01/24/20 - Enh 30749351 - ATP Resume preprov dbsystem
Rem                           polling status
Rem    pverma      01/15/20 - Add OH Space rule for X8-2
Rem    pverma      01/14/20 - OCI-ExaCC MVM CreateService Impl
Rem    jaseol      12/30/19 - Bug 30666174 - replace logstash with rsyslog
Rem    piyushsi    12/23/19 - Bug 30694347 ENABLE ECRA Property WORKFLOW_BASED_OPERATION
Rem    pverma      12/23/19 - OCI-ExaCC MVM support changes to Pre-Activation
Rem                           Flow
Rem    rgmurali    12/17/19 - ER 30550146 - Support bigger subnets for bonding
Rem    jvaldovi    12/06/19 - bug30591379 - Removing properties from
Rem                           ecs_properties
Rem    bshenoy     11/27/19 - Bug 30560468 - Create Jobs for fetching applied
Rem                           and available versions
Rem    piyushsi    11/13/19 - Bug 30343513 ECRA Property for Workflow Operation
Rem    jreyesm     10/28/19 - Bug 30474038. Enabled iaas in fresh installs.
Rem    jloubet     10/16/19 - Adding properties for oss ingestion
Rem    sringran    10/11/19 - Bug 30328269 transaction associated third upload changes were
Rem                           not merged. Hence ReOpeneing the transaction
Rem    llmartin    10/01/19 - Bug 30366036 - AEI Reconfig progress percentage
Rem    sringran    09/30/19 - Bug 30328269 - Increase value for
Rem                           MAX_LOCAL_STORAGE_DELTA_IN_GB
Rem    rgmurali    03/03/20 - ER 30870817 - Fabric addition APIs
Rem    jloubet     01/16/20 - Adding x8m-2 base system
Rem    jloubet     11/21/19 - Adding new X8M-2 models
Rem    rgmurali    09/23/19 - Bug 30340316 - Fix the syntax error
Rem    jvaldovi    09/20/19 - Adding property FILE_OSS_CONTAINER
Rem    jreyesm     09/19/19 - E.R 30328990 Double rack metadata for X8
Rem    rgmurali    09/15/19 - Bug 30307663 - ADD X7 DOUBLE RACK SUPPORT IN ECRA
Rem    jloubet     09/12/19 - Fixing migration query
Rem    jreyesm     08/26/19 - Bug. 30225622. Cluster tags wrong update
Rem    rgmurali    08/20/19 - ER 30202025 - Add additional checks before delete service
Rem    bshenoy     08/19/19 - Bug 30198612: Add null value for ec_keys_db in
Rem                           ecs_oci_exa_info table
Rem    llmartin    08/14/19 - Enh 30109293 - ATP deprecate
Rem                           ECS_ATPRACKSIZE_SUBNET table
Rem    seha        08/12/19 - Bug-30161808 Use hw serial number as asset id
Rem    llmartin    08/08/19 - Bug 29636171 - Auto detect free subnet in
Rem                           Management VCN
Rem    jreyesm     08/07/19 - E.r 30153459. DEFAULT_CORES fof iaas to 4
Rem    pverma      08/02/19 - Correct ECRA Cipher table name
Rem    seha        07/31/19 - Bug 30025251 Report compliance status
Rem    jloubet     07/30/19 - Merging identity tables
Rem    hcheon      07/28/19 - bug-30024961 Add ENABLE_CM_CHANGE_REVERT
Rem    pverma      07/24/19 - Properties for holding cipher key and length
Rem    seha        07/23/19 - Bug 30041007 update columns for asset endpoint protection
Rem    llmartin    07/22/19 - Bug 29689196 - ATP Consolidate multiple Oracle
Rem                           Client VCNs
Rem    byyang      07/21/19 - ER 30065482. ExaCD-A intg with otto
Rem    aschital    07/19/19 - Bug 30069938 - CONFIGURE WF EXECUTION ONLY ON ONE OF THE ECRA SERVERS
Rem    jloubet     07/18/19 - Adding versioning to terraform tables
Rem    joseort     07/18/19 - Adding HEARTBEAT_JOBS_ENABLED property and Change default heartbeat properties.
Rem    jreyesm     07/15/19 - X8 tb storage update
Rem    piyushsi    07/09/19 - Bug 30024344 - Add Property IMMEDIATE_ERROR_REPORTING
Rem    llmartin    06/26/19 - Bug 29773119 - Exacc OCI Activation OCPS
Rem    pverma      06/25/19 - Conectivity status to EXA_INFO
Rem    hgaldame    06/25/19 - 29945963 - x8-2 : fix the ecs_hardware table
Rem                           values for x8-2 for oci/exacc gen2
Rem    joseort     06/14/19 - Adding heartbeat default properties on
Rem                           configuration table.
Rem    aanverma    06/10/19 - Bug #29874733: Add ociexacc properties
Rem    hcheon      06/03/19 - bug-29832933, Add SCHEDULER_THREAD_POOL_SIZE,
Rem                           DEFAULT_COMMAND_TIMEOUT
Rem    piyushsi    05/16/19 - Bug 29777060 - OCIExacc: Add Property EXACLOUD_STEPWISE_PROVISIONING
Rem    rgmurali    05/13/19 - ER 29773132 - ingest dbsystem cidr for ATP
Rem    rgmurali    05/05/19 - E.R 29464642 - Support rack maintenance mode
Rem    jreyesm     04/30/19 - Bug 29712991. base system minimum cores.
Rem    hgaldame    04/22/19 - Bug 29236318 : adding X8-2 support
Rem    jreyesm     04/19/19 - E.R 29617720. Chance racksizes to base.
Rem    jvaldovi    04/12/19 - changing total storage for Base system, x6 from
Rem                           74 to 72
Rem    jreyesm     04/11/19 - E.R clustertag values
Rem    pverma      04/07/19 - Data modelling for OCI-Exa changes
Rem    jreyesm     04/01/19 - E.R 2952821. Outbound subnets list property
Rem    diegchav    03/28/19 - ER 29548259 : Default ATP_PREPROVISION property to
Rem                           ENABLED
Rem    sdeekshi    03/21/19 - Bug 29129733 - Disable em visaualization for FA
Rem    jreyesm     03/08/19 - E.R 29461478. Property for client vcn preprov.
Rem    hcheon      03/06/19 - Bug 29450636 - Rename KMS property
Rem    llmartin    02/28/19 - Bug 29412818- Fix elastic storage for ExaService
Rem    jloubet     02/14/19 - XbranchMerge jloubet_bug-29344629 from
Rem                           st_ebm_19.1.1.0.0
Rem    aanverma    02/11/19 - Bug #29333321: Add/update entries for OH usable
Rem                           space
Rem    sachikuk    02/12/19 - Bug - 29341155 : Increase default pre
Rem                           provisioning scheduler interval to 8 minutes
Rem    jloubet     02/13/19 - Changes for elastic enabled
Rem    srtata      02/05/19 - bug 29308926: add CNS_EMAIL_OPS_ONLY
Rem    jreyesm     01/31/19 - Bug 29290860. Invalid casper ip value
Rem    sachikuk    01/29/19 - Bug - 29196255 : Racks monitoring job for ATP pre
Rem                           prov scheduler
Rem    rgmurali    01/24/19 - Bug 29245761 - Open up port 6200 for ONS
Rem    llmartin    01/23/19 - Bug 29252629 - BaseSystem, fix memory allocation.
Rem    jgsudrik    01/23/19 - Backing out masking diag template passwords.
Rem    piyushsi    01/18/19 - XbranchMerge piyushsi_update_security_list from
Rem                           main
Rem    diegchav    01/17/19 - XbranchMerge diegchav_bug-28999178 from main
Rem    rgmurali    01/17/19 - XbranchMerge rgmurali_bug-29170694 from main
Rem    rgmurali    01/16/19 - Bug 29170694 - Security fix for clear text passwords
Rem    jgsudrik    01/16/19 - Blanking the template passwords for Diag servers.
Rem    sachikuk    01/10/19 - Bug - 29196230 : DB schema for ATP pre
Rem                           provisioning scheduler
Rem    hcheon      01/07/19 - Backport hcheon_bug-28870545 from main
Rem    llmartin    01/07/19 - XbranchMerge llmartin_bug-28702021 from main
Rem    jreyesm     01/02/19 - XbranchMerge brsudars_bug-28943273 from main
Rem    jungnlee    01/01/19 - remove diagnostic path
Rem    srtata      12/18/18 - bug 27550083: add cns_ops_email_list
Rem    seha        12/12/18 - ER 29045487. Add ECRA_LOG_LEVEL
Rem    diegchav    12/05/18 - Add time properties for polling ATP DbSystem creation.
Rem    jreyesm     11/28/18 - E.R Add ORCL_CLIENT_ADNAME
Rem    hcheon      11/22/18 - enh28870545, Add KMS properties
Rem    brsudars    11/21/18 - Add property OCI_SDK_VERSION
Rem    brsudars    11/09/18 - intialization for ecs_oh_space_rule
Rem    jungnlee    11/08/18 - delete DiagnosisNotifier scheduled job
Rem    jreyesm     11/02/18 - E.R 28878547. Modify on atp whitelist data
Rem    llmartin    11/01/18 - Enh 28702021 - OCI Base System Support
Rem    hcheon      10/23/18 - Bug 28828490 refresh diag_rack_info after upgrade
Rem    jungnlee    10/14/18 - remove ExaCD OSS info
Rem    aanverma    10/11/18 - Bug #28662168: Add values for Thread pool parameters
Rem    byyang      10/05/18 - ER 28731684. Scheduler support for one-off job
Rem    sdeekshi    09/30/18 - Bug 28717132 - ecra ximages auto selection of latest bundle patch
Rem    jreyesm     09/28/18 - Bug 28722024. Add APT passthrough flag.
Rem    jreyesm     09/24/18 - E.R 28691488. Add ATP default db version
Rem    diegchav    09/11/18 - ER 28633340 : Data model to support ATP whitelist
Rem    jgsudrik    08/27/18 - Adding more properties for ATP.
Rem    jreyesm     09/11/18 - Bug 28628707. ATP Grid default to 18
Rem    llmartin    09/07/18 - Bug 28618525 - Add new ECS_HARDWARE tags for
Rem    aanverma    09/05/18 - BUG #28435921: New type UIIMPACTING_FEATURES
Rem                           introduced for UI impacting features
Rem    jreyesm     08/31/18 - E.R 28585399. ATP Default grid in a property
Rem    sachikuk    08/30/18 - Bug 28095675 : Request forwarding from broker
Rem                           to remote ECRAs
Rem    jungnlee    08/30/18 - remove default Scheduler jobs seeds
Rem    brsudars    08/30/18 - Change X7 rack cell storage values
Rem    jreyesm     08/29/18 - E.R 28529198. Add ATP_MGMT_PORT property
Rem    sachikuk    08/20/18 - XbranchMerge sachikuk_bug-28515367 from
Rem    sachikuk    08/16/18 - Set ECRA_ENV value to 'edcs' [Bug - 28515367]
Rem    shpashan    08/08/18 - Update co-ordinates of EM remote agent.
Rem    jungnlee    08/09/18 - add EXACD properties
Rem    sachikuk    08/06/18 - Set default ECRA_ENV to 'exacm' [Bug - 28455118]
Rem    byyang      07/25/18 - ER 28356826. ExaCD support for MVM
Rem    jreyesm     07/23/18 - E.R 28381512. Add FedRamp support.
Rem    jungnlee    07/10/18 - add exacd scheduled job(default disabled)
Rem    rgmurali    07/07/18 - XbranchMerge rgmurali_bug-28242735 from
Rem                           st_ebm_18.2.5.1.0
Rem    jreyesm     07/05/18 - E.R 27926559. Property to enabled Exaformation
Rem                           for elastic S/C
Rem    rgmurali    07/07/18 - XbranchMerge rgmurali_bug-28181495 from
Rem                           st_ebm_18.2.5.1.0
Rem    jgsudrik    06/26/18 - Add oss details to diag section.
Rem    byyang      06/21/18 - Remove old log collection job
Rem    llmartin    06/18/18 - ENH 28193584 - Add hardware tags for Iaas-Paas
Rem    jreyesm     06/11/18 - E.R 28043393. Changes for atp OCI
Rem    sdeekshi    06/08/18 - Bug 28189332 : Add ecra ximages image management api
Rem    seha        05/31/18 - Add DIAGNOSTIC properties to ECSProperties table
Rem    brsudars    05/27/18 - Flag to enable or diable node subsets
Rem    byyang      05/27/18 - ExaCD: use LogScanner instead of
Rem                           DiagnosisResource
Rem    sachikuk    05/25/18 - Define operation specific timeouts in
Rem                           ecs_optimeouts table [Bug - 28081740]
Rem    sgundra     05/11/10 - Bug-28013177 - Create service support for Iaas/Paas

Rem    rgmurali    05/08/18 - Bug 27995482 - cores REST endpoint for Iaas-Paas
Rem    jungnlee    05/01/18 - Bug 27879725 - ADD ECRA_ENV
Rem    jgsudrik    03/17/18 - Correcting some erraneous lines left there by
Rem                           mistake.
Rem    jgsudrik    03/16/18 - Adding ADBCS properties to ECSProperties table.
Rem    jreyesm     03/15/18 - Bug 27700775. Add DEFAULT_WAIT_CYCLES for
Rem                           exacloud sync calls.
Rem    sgundra     03/14/18 - Bug-27687516 - Double Rack support
Rem    jreyesm     03/01/18 - Bug 27614474. Add client/backup natips
Rem    jreyesm     02/22/18 - Bug 27520916. Add NAT_IP_POOL property.
Rem    rgmurali    02/01/18 - Bug 27275671 - Use compute endpoint from TAS payload
Rem    byyang      01/21/18 - ER 27417896. Refactor log collection
Rem    byyang      01/11/18 - ER 27378924. Enable log collection in dev mode
Rem    byyang      01/06/18 - ER 29743223. Insert base problems
Rem    nkedlaya    12/02/17 - Enh 27209353 - SEAMLESS ECRA SCHEMA UPGRADE
Rem                           BETWEEN VERSIONS
Rem    nkedlaya    12/02/17 - Created
Rem
SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

--------------------- BEGIN DELETE --------------------------------------
PROMPT Deleting data from the schema tables

-- ExaCD: Delete deprecated scheduled jobs
DELETE FROM ecs_scheduledjob WHERE job_class='oracle.exadata.ecra.resources.DiagnosisResource';
DELETE FROM ecs_scheduledjob WHERE job_class='oracle.exadata.ecra.diagnosis.notifier.DiagnosisNotifier';
DELETE FROM ecs_scheduledjob WHERE job_class='oracle.exadata.ecra.diagnosis.scanner.ElasticSearchScanner'; 
DELETE FROM ecs_scheduledjob WHERE job_class='oracle.exadata.ecra.scheduler.AvailableVersionsJob'; 
DELETE FROM ecs_scheduledjob WHERE job_class='oracle.exadata.ecra.scheduler.AppliedVersionsJob';


-- ExaCD old properties
DELETE FROM ecs_properties WHERE name = 'EXACD_LOGSTASH_OUTPUT_LUMBERJACK';
DELETE FROM ecs_properties WHERE name = 'EXACD_LOGSTASH_OUTPUT_OTTO';
DELETE FROM ecs_properties WHERE name = 'EXACD_ES_URL';
DELETE FROM ecs_properties WHERE name = 'EXACD_OUTPUT_LUMBERJACK';
-- end ExaCD old properties

-- Compliance old properties
DELETE FROM ecs_properties WHERE name = 'COMPLIANCE_SCAN_REPORT_OSS_PAR';

--Bug 28618525: Delete old ECS_HARDWARE tags before insert the new ones.
DELETE FROM ecs_hardware;

-- Enh 32347095 Delete base template for ecs_gold_specs
DELETE FROM ecs_gold_specs where exaunit_id=-1;

--Bug 32438102: Delete old ecs_optimeouts values before insert new ones 
DELETE FROM ecs_optimeouts;

delete from atp_properties where type='IPTABLE_WHITELIST';
DELETE FROM ecs_properties WHERE name = 'OCI_SDK_VERSION';

--DELETE ximage related entries from ecs_properties
DELETE from ecs_properties where name='DEFAULT_GRID';
DELETE from ecs_properties where name='DEFAULT_SERVICE';
DELETE from ecs_properties where name='DEFAULT_REPO';
DELETE from ecs_properties where name='AUTO_BPVER';
DELETE from ecs_properties where name='AUTO_PURGE';

--DELETE old entries related to applied & available versions job
DELETE from ecs_properties where name='APPLIED_PATCHES_JOBS_ENABLED';
DELETE from ecs_properties where name='AVAILABLE_PATCHES_JOBS_ENABLED';
DELETE from ecs_properties where name='PATCH_VERSION_THREAD_POOL_SIZE';
DELETE from ecs_properties where name='PATCH_VERSION_JOB_SCHEDULER_TIME_PERIOD';
DELETE from ecs_properties where name='PATCH_VERSION_WORKER_TIMEOUT';

--Delete stale CM status records
DELETE FROM ecs_compliance_cm_status WHERE config_name IN ('mount', 'iptables');

--Delete catalog of CrossPlatform combinations
DELETE FROM ecs_elastic_platform_info;

--Delete catalog of ol7/ol8
ALTER TRIGGER ECS_EXA_VERS_MATRIX_ID DISABLE;
DELETE FROM ECS_EXA_VER_MATRIX;

PROMPT Done Deleting data from the schema tables
commit;
--------------------- END DELETE --------------------------------------


--------------------- BEGIN INSERT --------------------------------------
PROMPT Inserting data into the schema tables
INSERT INTO ecs_purchasetypes (entitlement_category, purchase_type) VALUES ('cloud_credit', 'metered');
INSERT INTO ecs_purchasetypes (entitlement_category, purchase_type) VALUES ('srvc_entitlement', 'subscription');
commit;

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
-- Update X7-2 tb_storage values in ecs_hardware
--   Old values were from Exadata X7-2 specifications - http://www.oracle.com/technetwork/database/exadata/exadata-x7-2-ds-3908482.pdf
--   New values are from Exadata cloud specifications - http://www.oracle.com/technetwork/database/exadata/exacc-x7-ds-4126773.pdf. Values are rounded down.
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

--=====================================================--
-- END FOR ECS_HARDWARE INSERTS STATEMENTS             -- 
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

-- Elastic Platform Info for Cross Platform
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

-- cluster shapes
-- Have presets that are fixed per shape and is same for all racksizes and models
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'SMALL', 4, 30, 3, 60);
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'MEDIUM', 8, 60, 8, 60);
INSERT INTO ecs_cluster_shapes (model, racksize, shape, numCoresPerNode, gbMemPerNode, tbStoragePerCluster, gbOhSize ) VALUES ('ALL', 'ALL', 'LARGE', 16, 120, 20, 60);
-- The default WHOLE value will be fetched from ecs_hardware table

-- Service type catalog
INSERT INTO ecs_properties (name, type, value) VALUES ('SERVICE_TYPE', 'PATCHING', 'EXACS,FA,ADBD,ADBS,EXACC,PREPROD,GBU,IDCS,OMCS,TEST');

-- The max duration in mins that a exaservice sync operation can be in progress
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_EXASERVICE_LOCK_TIME_MINS', 'EXASERVICE', '10');
-- specifies the bursting limit for SBE/MBE
INSERT INTO ecs_properties (name, type, value) VALUES ('SBE_CORE_BURST_MULT', 'CORE_BURST', '2');
INSERT INTO ecs_properties (name, type, value) VALUES ('MBE_CORE_BURST_MULT', 'CORE_BURST', '2');

-- The max allowed delta for the physical space found on an empty exadata rack 
-- and the standard physical space as per the Exadata specification
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_LOCAL_STORAGE_DELTA_IN_GB', 'EXADATA', '200');

-- this registers the connection key/host info for ecs firewall tool
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_TOOL_HOST', 'FIREWALL', 'http://localhost:8500');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_TOOL_KEY',  'FIREWALL', '3faab95b4120b2c8d44861aca29e0f41');

-- specifies the restrictions of secgroups
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_RULES_PER_GROUP', 'FIREWALL', '25');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_GROUPS_PER_EXAUNIT',  'FIREWALL', '15');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_GROUPS_PER_CUSTOMER',  'FIREWALL', '15');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_ROTATION_MAX',  'FIREWALL', '9998');

-- for selective feature rollout, the state of a feature is registered under type 'FEATURE'
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_FEATURE',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('NODE_SUBSETS_FEATURE',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('CONTROLPLANE_OFFLOAD_FEATURE',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_STEPWISE_PROVISIONING',  'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_DS_SINGLE_STEP_PROVISIONING',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('WORKFLOW_BASED_OPERATION',  'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('WF_AUTO_REQ_UPDATE',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('IMMEDIATE_ERROR_REPORTING',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('AUTO_MAINTENANCE',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('OPS_DELETE_OPERATIONS',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOM0_BONDING',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('BONDING_FOR_ELASTIC',  'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('BONDING_EXACLOUD_ENABLE',  'FEATURE', 'false');
INSERT INTO ecs_properties (name, type, value) VALUES ('BONDING_CLIENT_VLANTAG',  'BONDING', '100');
INSERT INTO ecs_properties (name, type, value) VALUES ('BONDING_BACKUP_VLANTAG',  'BONDING', '200');
INSERT INTO ecs_properties (name, type, value) VALUES ('CHOOSE_NONBONDED_CLUSTERS',  'BONDING', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('CHOOSE_NONBONDED_X6',  'BONDING', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('BONDING_WORKFLOW_MODE',  'BONDING', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLUSTER_DETAILS_CACHE',  'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('FPE_MGMT_VCN',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_TASK_FAILURE_AUTORETRY',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('MAXIMUM_RETRY_COUNT_FOR_TASK_FAILURE',  'AUTORETRY', '1');
INSERT INTO ecs_properties (name, type, value) VALUES ('CROSS_PLATFORM_SUPPORT', 'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('WF_INFRAPATCHING_REALTIME_OPERATION', 'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_ACTIVE_ACTIVE_SPLIT_MODE',  'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_BODY_DETAILS_PARSE', 'FEATURE', 'ENABLED');

-- ZDLRA properties
INSERT INTO ecs_properties (name, type, value) VALUES ('ZDLRA_HYPERTHREADING', 'ZDLRA', 'DISABLED');

-- WF related properties
INSERT INTO ecs_properties (name, type, value) VALUES ('NUM_EC_CLEANUP_RETRIES', 'ECRA_RESILIENCE', '20');
INSERT INTO ecs_properties (name, type, value) VALUES ('WF_EXECUTION_SERVER', 'ECRA_WF', 'EcraServer1');
INSERT INTO ecs_properties (name, type, value) VALUES ('AUTO_RESTART_WF', 'ECRA_WF', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('SERVER_SWITCHOVER_INPROGRESS', 'ECRA_RESILIENCE', 'false');
INSERT INTO ecs_properties (name, type, value) VALUES ('ROLLING_UPGRADE_RECONFIG_CHECK', 'ECRA_RESILIENCE', 'ENABLED');

-- Rolling upgrade related properties

INSERT INTO ecs_properties (name, type, value) VALUES ('CURRENT_ACTIVE_SERVER', 'ECRA_RESILIENCE', 'EcraServer1');

/* ENH 34710742 - Strorage propertie to dertermine where the files of the 
workflow will be searched and stored. */

INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_STORAGE_DEST', 'FEATURE', 'db');
-- Enh 36090848 - Commenting update statement so it respects the previous assigned value when an upgrade is done.
-- UPDATE ecs_properties SET value='fs' WHERE name='ECRA_STORAGE_DEST';

-- Enh 36329200 - Adding default value for asm power limit
INSERT INTO ecs_properties (name, type, value, description) VALUES ('ASM_POWER_LIMIT_DEFAULT_VALUE','FEATURE', '4', 'Default an minimum value the rebalance power can take for attach and dettach operations.');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('ASM_POWER_LIMIT_MAX_VALUE','FEATURE', '64', 'Maximum value the rebalance power can take for attach and dettach operations.');


/* New TYPE for UI impacting features in Control Plane Offload Project. List is
   incremental. NAME column is primary key, so its values are changed a bit. */
INSERT INTO ecs_properties (name, type, value) VALUES ('UIIMPACTING_HIGGS', 'UIIMPACTING_FEATURES', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('UIIMPACTING_NODE_SUBSETS', 'UIIMPACTING_FEATURES', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('UIIMPACTING_MVM', 'UIIMPACTING_FEATURES', 'DISABLED');

/* Add seed values for the Thread pool parameters used for getting the details
   like features, capacity for the locations fetched based on the parameters
   like subscription id, model, etc.*/
INSERT INTO ecs_properties (name, type, value) VALUES ('CORE_POOL_SIZE', 'LOCATION_DETAILS', '2');
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_POOL_SIZE', 'LOCATION_DETAILS', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('KEEP_ALIVE_TIME', 'LOCATION_DETAILS', '5');
INSERT INTO ecs_properties (name, type, value) VALUES ('WORK_QUEUE', 'LOCATION_DETAILS', '20');

-- bdcs user/password
INSERT INTO ecs_properties (name, type, value) VALUES ('BDCS_USERNAME', 'BDCS', 'bdcs');
INSERT INTO ecs_properties (name, type, value) VALUES ('BDCS_PASSWORD', 'BDCS', '');

-- specifies the idemtoken expiration time
INSERT INTO ecs_properties (name, type, value) VALUES ('IDEMTOKEN_EXPIRATION_TIME', 'IDEMTOKEN', '86400000');

-- Cluster life cycle management properties
-- default time for purging a cluser after it is deleted (7 days). Can be changed.
-- Only the future deletes will get the new changed value
--
INSERT INTO ecs_properties (name, type, value) VALUES ('CLUSTER_PURGE_DEFAULT_TIME', 'CLUSTER_LIFE_CYCLE', (60 * 60 * 24 * 7));
-- EM integration for create and delete servcie monitoring
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_EMAGENT_PORT', 'EM', '21868');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_EMAGENT_HOST_NAME', 'EM', 'xyz.us.oracle.com');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_TARGET_TYPE', 'EM', 'oracle_cloud_exadata_service');
INSERT INTO ecs_properties (name, type, value) VALUES ('EM_FILE_PATH', 'EM', '/tmp');
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_EM_INTEGRATION', 'EM', 'false');
-- EM Integration for version2
INSERT INTO ecs_properties (name, type, value) VALUES ('LIFECYCLE_STATUS_SDI', 'EM', 'Production');
INSERT INTO ecs_properties (name, type, value) VALUES ('POD_ASSC_PREFIX', 'EM', 'oracle_cloud_exadata_service_sys:ExaCS ');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_TARGET_NAME_PREFIX', 'EM', 'ExaCS ');
INSERT INTO ecs_properties (name, type, value) VALUES ('CLOUD_SERVICE_TARGET_NAME_SUFFIX', 'EM', '-svc');
INSERT INTO ecs_properties (name, type, value) VALUES ('DELIMITER_EM', 'EM', '|');
INSERT INTO ecs_properties (name, type, value) VALUES ('CREATE_SERVICE', 'EM', 'ADD_CLOUD_SERVICE');
INSERT INTO ecs_properties (name, type, value) VALUES ('DELETE_SERVICE', 'EM', 'DELETE_CLOUD_SERVICE');
INSERT INTO ecs_properties (name, type, value) VALUES ('CUSTOMER_NAME_SUFFIX', 'EM', ' (Metered)');

-- specifies the HIGGs endpoint related information
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_URL', 'HIGGS', 'https://10.128.95.197/');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_CLOUD_IPPOOL', 'HIGGS', '/oracle/public/cloud-ippool');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NAT_IPPOOL', 'HIGGS', '/oracle/public/ippool');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_SITENAME', 'HIGGS', 'usdev2347');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_DNS_IPS', 'HIGGS', '10.128.95.200,10.128.95.201');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NIMBULA_API_DNS_IPS', 'HIGGS', '10.128.95.199');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NTP_IP', 'HIGGS', '10.150.240.129');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_PSM_SERVICEIP', 'HIGGS', '10.150.240.132/32');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_URL_OVERRIDE', 'HIGGS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_IB_SUBNET', 'HIGGS', '192.168.1.0/22');

--ATP Properties
-- TODO In the future, we will rename these ATP properties in a more generic way when new
-- services gets integrated with our service.
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OM_VCNID', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OM_GWOCID', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OM_SECRULEOCID', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OM_CONFIGPATH', 'ATP', '~/.oci/config');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_RUNTIME_ENVIRONMENT', 'ATP', 'PROD');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_ADNAME', 'ATP', 'hmAF:SEA-AD-2');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_VNIC_DELAY', 'ATP', '10000');
INSERT INTO ecs_properties (name, type, value) VALUES ('CASPER_IP', 'ATP', '192.168.0.0/29');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_MGMT_PORT', 'ATP', '1522');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_ONS_PORT', 'ATP', '6200');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_DEFAULT_GRID', 'ATP', '19');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_DEFAULT_DB', 'ATP', '19.0.0.0');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OM_ROUTERULE', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OM_TENANCYOCID', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OBSERVER_IMAGE', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OBSERVER_SHAPE', 'ATP', 'VM.Standard2.1');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OBSERVER_FLEXSHAPE_CORES', 'ATP', '8.0');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OBSERVER_FLEXSHAPE_MEMORY', 'ATP', '128.0');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OBSERVER_SUBNETDELETE', 'ATP', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_REGION', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_ORCL_CLIENT_VCNCIDR', 'ATP', '10.0.0.0/16');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_ORCL_CLIENT_SUBNETSIZE', 'ATP', '26');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_VCN_CONSOLIDATION', 'ATP', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_SUBNET_AUTODISCOVER', 'ATP', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_CLIENTVCN_RETRIES', 'ATP', '5');
INSERT INTO ecs_properties (name, type, value) VALUES ('ORCL_CLIENT_ADNAME', 'ATP', 'hmAF:SEA-AD-2');
INSERT INTO ecs_properties (name, type, value) VALUES ('ORACLE_SERVICES_CIDRS', 'ATP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('BACKUP_SUBNETS_RESERVED_CIDR', 'ATP', '');

-- ATP Preprovisioning
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_PREPROVISION', 'ATP', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_PP_OFFLINE_HR', 'ATP', '2');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_CLIENTSUBNET_PRIVATE', 'ATP', 'TRUE');
INSERT INTO ecs_properties (name, type, value) VALUES ('MAXIMUM_PARALLEL_RACKS_FOR_PREPROV', 'ATP', '3');

-- OCI Preprovisioning
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACS_PREPROV', 'PREPROVISION', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_SCHEDULER_INTERVAL_SECONDS', 'PREPROVISION', '600');
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_JOBS_TARGET_SERVER', 'PREPROVISION', 'PRIMARY');
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_PARALLEL', 'PREPROVISION','DISABLED');

-- Filesystem mount size
INSERT INTO ecs_properties (name, type, value) VALUES ('FILESYSTEM_MAX', 'FEATURE', '900');
-- Filesystem back compatibility with 443 overhead
INSERT INTO ecs_properties (name, type, value) VALUES ('FILESYSTEM_FEATURE', 'FEATURE', 'ENABLED');
-- Enh 36330149 - Adding filesystem migration complete property
INSERT INTO ecs_properties (name, type, value) VALUES ('FS_MIGRATION_COMPLETE', 'FEATURE', 'false');
-- Enh 36602015 - Adding filesystem ignorable mountpoins for CP
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACS_IGNORABLE_MOUNTPOINTS', 'FILESYSTEM', 'swap,reserved');

-- Enh 36564221 - Adding property for Exadata Early Adopter Version
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_EARLY_ADOPTER_VERSION', 'EXADATA', 'DISABLED');

-- Enh 36641332 - Adding property for Exadata ATP Early Adopter Version
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_ATP_EARLY_ADOPTER_VERSION', 'EXADATA', '24.1');

-- Enh 36659169 - Adding property to force the use of nodes with Early Adopter version
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_EARLY_ADOPTER_VERSION_FORCE', 'EXADATA', 'DISABLED');

-- Enh 36576562 - Adding property to define the max SW version to use in CEI
INSERT INTO ecs_properties (name, type, value) VALUES ('INFRA_DEFAULT_MAX_VERSION', 'EXADATA', 'DISABLED');

-- Bug 36969730 - Adding back the property to content the override version for ATP Early Adopter Feature
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_OS_VERSION_OVERRIDING_ATP', 'FEATURE', '');

-- Bug 36969730 Early Adopter related properties to be update with description and FEATURE as type value
UPDATE ecs_properties set type='FEATURE', description='Property to set exact version that domU needs for ATP cluster if Early Adopter is enabled for ATP and its version match with the version of the Infrastructure' where NAME='DOMU_OS_VERSION_OVERRIDING_ATP';
UPDATE ecs_properties set type='FEATURE', description='Defines the Exadata SW version to be consider as Early Adopter Version for EXACS provisionings (Example 24.1), use DISABLED to turn this feature off' where NAME = 'EXADATA_EARLY_ADOPTER_VERSION';
UPDATE ecs_properties set type='FEATURE', description='Defines the Exadata SW version to be consider as Early Adopter Version for ATP/ADBD provisionings (Example 24.1), use DISABLED to turn this feature off' where NAME = 'EXADATA_ATP_EARLY_ADOPTER_VERSION';
UPDATE ecs_properties set type='FEATURE', description='Defines if this Region should ONLY use nodes with SW Version = EARLY ADOPTER, use ENABLED/DISABLED as values' where NAME = 'EXADATA_EARLY_ADOPTER_VERSION_FORCE';
UPDATE ecs_properties set type='FEATURE', description='Defines a Maximum version from Exadata SW that the nodes can have for new Infrastructure' where NAME = 'INFRA_DEFAULT_MAX_VERSION';

INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_HOST', 'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_PORT', 'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_AUTH_USER',  'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_LB_AUTH_PASSWD',  'FEATURE', '');

-- Enh 36754615 - Adding property to force the use of FS Encryption to all provisionings
INSERT INTO ecs_properties (name, type, value, description) VALUES ('FS_ENCRYPTION_FOR_ALL','FEATURE','DISABLED','Property to force FS Encryption by region');

-- Enh 36955594 -  Adding property to control if FS Encryption is allowed or not for ATP provisionings
INSERT INTO ecs_properties (name, type, value, description) VALUES ('FS_ENCRYPTION_FOR_ATP','FEATURE','DISABLED','Property to Allow/Avoid FS Encryption in ATP clusters');

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
                    "grid": "v23"
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
                    "grid": "v23"
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

-- KVM RoCE 
INSERT INTO ecs_properties (name, type, value) values ('ROCE_EXASCALE_NETWORK_CIDR', 'KVMROCE', '100.105.0.0/16');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_STORAGE_NETWORK_CIDR', 'KVMROCE', '100.106.0.0/16');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_CLUSTER_NETWORK_CIDR', 'KVMROCE', '100.107.0.0/16');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_EXASCALE_VLAN_SIZE', 'KVMROCE', 32);
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ENABLE_69RACK_FOR_ELASTIC', 'KVMROCE', 'TRUE');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_CAPACITY_SELECTION_TECHNIQUE', 'KVMROCE', 'DENSELY_PACKED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ALLOCATE_CLUSTERVLAN', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ALLOCATE_STORAGEVLAN', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ALLOCATE_CLUSTERIP', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ALLOCATE_STORAGEIP', 'KVMROCE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_OCI_RESERVED_VLANRANGE', 'KVMROCE', '10-99');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_EXADATA_VLANRANGE', 'KVMROCE', '100-963');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_EXASCALE_VLANRANGE', 'KVMROCE', '3968-3999');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ARISTA_INTERNAL_VLANRANGE', 'KVMROCE', '4000-4094');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ASM_REBALANCE', 'KVMROCE', '16');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_MAX_ELASTIC_COMPUTES', 'KVMROCE', 32);
INSERT INTO ecs_properties (name, type, value) values ('ROCE_MAX_ELASTIC_STORAGE', 'KVMROCE', 64);
INSERT INTO ecs_properties (name, type, value) values ('ROCE_MIN_ELASTIC_COMPUTES', 'KVMROCE', 1);
INSERT INTO ecs_properties (name, type, value) values ('ROCE_MIN_ELASTIC_STORAGE', 'KVMROCE', 3);
INSERT INTO ecs_properties (name, type, value) values ('ELASTIC_CDB_EXTENSION', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ELASTIC_PARALLEL_CELL_ADDITION', 'KVMROCE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) values ('ELASTIC_PARALLEL_COMPUTE_ADDITION', 'KVMROCE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) values ('ELASTIC_CELL_STEPWISE_ADDITION', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ELASTIC_COMPUTE_STEPWISE_ADDITION', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ELASTIC_CELL_MVM_STEPWISE_ADDITION', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ELASTIC_SANITY_CHECK', 'KVMROCE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_PRECHECK', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_ENABLE_FABRICNAME_FOR_QR', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_CEI_SELECTION_APPROACH', 'ELASTICSHAPE', 'SPLIT_REQUEST');
INSERT INTO ecs_properties (name, type, value) values ('ALLOCATE_NODES_FROM_69_CEI', 'ELASTICSHAPE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_FABRIC_SELECTION_CEI', 'ELASTICSHAPE', 'LEAST_LOADED');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_NODE_SELECTION_CEI', 'ELASTICSHAPE', 'DENSELY_PACKED');
INSERT INTO ecs_properties (name, type, value) values ('CROSS_PLATFORM_SW_VERSION_SELECTION', 'ELASTICSHAPE', 'MINIMUM_DEVIATION');
INSERT INTO ecs_properties (name, type, value) values ('ROCE_CEI_EXPANSION_ONLY_CABINETS', 'ELASTICSHAPE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('VALIDATE_NODE_SELECTCOUNT', 'ELASTICSHAPE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('CAPACITY_RESERVE_CIE_RETRIES', 'KVMROCE', 3);
INSERT INTO ecs_properties (name, type, value) values ('CAPACITY_RESERVE_CIE_SANITYCHECK', 'KVMROCE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) values ('CAPACITY_RESERVE_CIE_SANITYCHECK_RETRIES', 'KVMROCE', 3);
INSERT INTO ecs_properties (name, type, value) values ('CAPACITY_RESERVE_CIE_METADATACHECK', 'KVMROCE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) values ('CAPACITY_EXPANSION', 'KVMROCE', 'ENABLED');

-- ATP Oracle Client DbSystem Polling Time Properties (in seconds)
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_DBSYSTEM_POLL_INTERVAL', 'ATP', '900');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_DBSYSTEM_TIMEOUT', 'ATP', '86400');

-- Insert ExaCompute Patching Related Configuration Parameters
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_NUMBER_OF_NODES_TO_PATCH_PER_REQUEST', 'EXACOMPUTE', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_PATCH_OPERATION_POLLING_INTERVAL_IN_SECONDS', 'EXACOMPUTE', '300');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_MAX_CONCURRENT_PATCH_REQUESTS', 'EXACOMPUTE', '5');

-- Node states which will be considered for Clusterless patching
INSERT INTO ecs_properties (name, type, value) VALUES ('CLUSTERLESS_NODE_STATES_TO_PATCH', 'PATCHING', 'FREE,RESERVED,FREE_MAINTENANCE,FREE_FAILURE,RESERVED_MAINTENANCE,RESERVED_FAILURE');

-- Property to control whether to abort infrapatching worklfows on Failure
INSERT INTO ecs_properties (name, type, value) VALUES ('ABORT_INFRAPATCH_WORKFLOWS_ON_FAILURE', 'PATCHING', 'ENABLED');
-- Property to control triggering of single request infrapatching
INSERT INTO ecs_properties (name, type, value) VALUES ('SINGLE_REQUEST_INFRAPATCH_OPERATION', 'PATCHING', 'DISABLED');

-- Domu Patching Rollback and PreCheck errors which will be treated as PAGE_ONCALL. Will be empty string initially
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_PATCH_ROLLBACK_PRECHECK_PAGEONCALL_ERRORS', 'PATCHING', '');

INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_PREPROV_SCHEDULER_STATE', 'ATP', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROV_SCHEDULER_INTERVAL_SECONDS', 'ATP', '60');

INSERT INTO ecs_properties (name, type, value) VALUES ('ORCL_CLIENT_SECURITY_LIST_CIDR','ATP', '0.0.0.0/0');
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_OPS_MODE','ATP', 'FALSE');

INSERT INTO ecs_properties (name, type, value) VALUES ('CLUSTERTAGS','CLUSTERPOOL', 'ALL,FASAAS');


DELETE FROM ecs_properties where name='ATP_R1_ADNAME';
DELETE FROM ecs_properties where name='DOMU_BONDING';

-- Higgs NoSDI support
-- This is a temporary field which supports a single region, to be removed in the next version.
INSERT INTO ecs_properties (name, type, value) VALUES ('DC_ID', 'NOSDI', 'US-Central');

-- for enabling debug tracing (True/False)     
INSERT INTO ecs_properties (name, type, value) VALUES ('DEBUG_EXACLOUD', 'DEBUG', 'False');

-- for setting log level (VERBOSE, DEBUG, INFO, WARNING, ERROR, CRITICAL) in Exacloud.
INSERT INTO ecs_properties (name, type, value) VALUES ('LOG_LEVEL', 'EXACLOUD', 'INFO');

-- for Mock Exacloud implementation. This is protected by other config too, see Exacloud.java
INSERT INTO ecs_properties (name, type, value) VALUES ('MOCKEXACLOUD', 'EXACLOUD', 'False');

-- for Mock WSS implementation. This is protected by other config too, see WSSRequestAgent.java
INSERT INTO ecs_properties (name, type, value) VALUES ('MOCKWSS', 'WSS', 'False');

-- for Mock CPS implementation. This is protected by other config too, see CPSRequestAgent.java
INSERT INTO ecs_properties (name, type, value) VALUES ('MOCKCPS', 'CPS', 'False');

-- for Mock remoteEC implementation. This is protected by other config too
INSERT INTO ecs_properties (name, type, value) VALUES ('MOCKREMOTEEC', 'REMOTEEXACLOUD', 'False');

-- LB URL for OCI ExaCC environments
INSERT INTO ecs_properties (name, type, value) VALUES ('VPNHEAD_LB_URL', 'EXACLOUD', NULL);
-- Other OCI ExaCC parameters
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_REGION', 'EXACLOUD', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_VPNHEIP', 'EXACLOUD', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_IMAGEOSSURL', 'EXACLOUD', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_SIMULTED_ENV', 'ECRA', 'N');
INSERT INTO ecs_properties (name, type, value) VALUES ('OPENSSL_PATH', 'OPENSSL', '/etc/openvpn/openssl');
INSERT INTO ecs_properties (name, type, value) VALUES ('OPENSSL_TMP_PATH', 'OPENSSL', '/tmp/activation');
INSERT INTO ecs_properties (name, type, value) VALUES ('OPENSSL_SIGN_CMD', 'OPENSSL', 'openssl x509 -req -days 180 -extfile %s -extensions v3_client -in %s -CA %s -CAkey %s -CAcreateserial -out %s -extensions v3_client -passin pass:%s');
INSERT INTO ecs_properties (name, type, value) VALUES ('OPENSSL_P12TOCRT_CMD', 'OPENSSL', 'openssl pkcs12  -in %s -clcerts -nokeys -out %s  -password pass:%s');
INSERT INTO ecs_properties (name, type, value) VALUES ('OPENSSL_REVOKE_CMD', 'OPENSSL', 'openssl ca -revoke  %s  -cert %s  -keyfile %s  -passin pass:%s');
INSERT INTO ecs_properties (name, type, value) VALUES ('OPENSSL_GENCRL_CMD', 'OPENSSL', 'openssl ca -gencrl -out %s -passin pass:%s');


-- Keeping AD name as '1' per suggestion as no real AD concept exists for oci-exacc
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_AD', 'EXACLOUD', '1');

-- Value use for supporting node subset feature
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_NODE_SUBSET_SUPPORTED', 'NODE_SUBSET', 'FALSE');

-- for domukeys endpoint
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMUKEYS_TTL', 'EXAUNIT', '86400');

--for CNS and ORDS integration
INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_INTEGRATION', 'CNS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('ORDS_INTEGRATION', 'ORDS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('ORDS_PASSWORD_SIZE', 'ORDS', '8');
INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_ENABLE','CNS','False');
INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_OPS_EMAIL_LIST','CNS','');
INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_EMAIL_OPS_ONLY','CNS','FALSE'); -- notifications are to both customer and ops by default
INSERT INTO ecs_properties (name, type, value) VALUES ('TEST_CNSTOPIC','CNS','NONE');
INSERT INTO ecs_properties (name, type, value) VALUES ('TEST_CNSURLS','CNS','FALSE');

-- FEDRAMP support
INSERT INTO ecs_properties (name, type, value) VALUES ('FEDRAMP_FEATURE','FEDRAMP','DISABLED');

-- Add OSS Container for files
INSERT INTO ecs_properties (name, type, value) VALUES ('FILE_OSS_CONTAINER','ATP','https://objectstorage.us-ashburn-1.oraclecloud.com/p/92a4hEkg7J9n8OToCNjVFFI-2Py_xP6jilUXIbsuXDI/n/intexadatateam/b/dib_dev_data/o/');

--Enh 33055641
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACS_MVM_MAX_ALLOWED_RACKS','MVM', '16');
-- Enh 34045327. Delete this property once we have the complete support
INSERT INTO ecs_properties (name, type, value) VALUES ('MVM_EGRESS_FEATURE','MVM', 'ENABLED');

-- SLA calculation
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACS_SLA', 'SLA', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('RACK_STATUSES_FOR_SLA', 'SLA', 'ALL');
INSERT INTO ecs_properties (name, type, value) VALUES ('SEND_SLA_TO_T2', 'SLA', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('SLA_EXACLOUD_JOB_CONCURRENCY', 'SLA', '16');
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_SLA_BY_TENANCY', 'SLA', 'ENABLED');

UPDATE ecs_properties SET value = 'ENABLED' WHERE name = 'EXACS_SLA';
UPDATE ecs_properties SET value = 16 WHERE name = 'SLA_EXACLOUD_JOB_CONCURRENCY';

-- Property for remove functionality of create starter db
insert into ecs_properties (name, type, value) values ('CREATE_STARTER_DB', 'FEATURE', 'DISABLED');

-- Property to sent to exacloud to validate or not exadataimage version
insert into ecs_properties (name, type, value) values ('EXACLOUD_CS_SKIP_SWVERSION_CHECK', 'MVM', 'ENABLED');

-- Property for Jumbo Frames for X9M-2
INSERT INTO ecs_properties (name, type, value) VALUES ('JUMBO_FOR_X9M', 'KVMROCE', 'ENABLED');

-- Bug 35567246 - Adding property to handle 2TB memory in X9M-2 (aka X9M-2L)
INSERT INTO ecs_properties (name, type, value) VALUES ('LARGE_FOR_X9M','KVMROCE','ENABLED');

-- Enh 37050952 - Setting new values for decomposing x8m racks
UPDATE ecs_properties set VALUE='ENABLED', DESCRIPTION='Property to use nodes, if enabled, from X8M-2 6:9 cabinet for elastic pool if they are not part of a fixed shape.' WHERE NAME='ALLOCATE_NODES_FROM_69_CEI';
UPDATE ecs_properties set VALUE='TRUE', DESCRIPTION='Property for Scale Up Infra (adding a node, compute or cell to the existing Infrastructure) to use nodes, if enabled, from X8M-2 6:9 cabinet for elastic pool if they are not part of a fixed shape.' WHERE NAME='ROCE_ENABLE_69RACK_FOR_ELASTIC';
UPDATE ecs_properties set VALUE='ENABLED', DESCRIPTION='Property to use only expansion cabinets and not to use 6:9 cabinets if enabled, this override ROCE_CEI_SELECTION_APPROACH' WHERE NAME='ROCE_CEI_EXPANSION_ONLY_CABINETS';

-- Enh 37127579 - Adding property for max size of customer domain name
INSERT INTO ecs_properties (name, type, value, description) values ('MAX_SIZE_HOST_LENGTH', 'FEATURE', '384', 'Property to determine the max size the customer domain name can be.');

--Add operation specific timeouts
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('update-service', 'ALL', 1 * 3600, 1 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('create-starter-db', 'ALL', 30 * 3600, 30 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('create-addi-db', 'ALL', 30 * 3600, 30 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('create-service', 'ALL', 30 * 3600, 30 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('delete-pod', 'ALL', 120 * 3600, 120 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('delete-starter-db', 'ALL', 12 * 3600, 12 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('delete-addi-db', 'ALL', 12 * 3600, 12 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('tm-delete', 'ALL', 12 * 3600, 12 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('snap-delete', 'ALL', 12 * 3600, 12 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('delete-exaservice', 'ALL', 120 * 3600, 120 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('create-sparse-diskgroup', 'ALL', 3600, 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('create-data-diskgroup', 'ALL', 3600, 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('resize-sparse-diskgroup', 'ALL', 3600, 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('resize-data-diskgroup', 'ALL', 3600, 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('fetch-info-diskgroup', 'ALL', 3600, 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('rebalance-diskgroup', 'ALL', 3600, 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('drop-diskgroup', 'ALL', 3600, 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dbaas_patch', 'ALL', 20 * 3600, 20 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('reconfigure-connectivity', 'ALL', 5 * 3600, 5 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('reverify-connectivity', 'ALL', 5 * 3600, 5 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('recreate-create', 'ALL', 5 * 3600, 5 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('recreate-delete', 'ALL', 20 * 3600, 20 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('recreate-grid-create-db', 'ALL', 30 * 3600, 30 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('recreate-service', 'ALL', 20 * 3600, 20 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('reshape-service', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('reshape-cores', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('mvm-attach-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('mvm-delete-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('reshape-storage', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('oci-attach-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit-attach-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit-delete-cell', 'ALL', 504 * 3600, 504 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit_resume', 'ALL', 20 * 3600, 20 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('resume-updatecores', 'ALL', 20 * 3600, 20 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_fresh_setup', 'ALL', 30 * 3600, 30 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_repeat_setup', 'ALL', 30 * 3600, 30 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit_suspend', 'ALL', 20 * 3600, 20 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('update-cores', 'ALL', 20 * 3600, 20 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('db_backup', 'ALL', 5 * 3600, 5 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('db_listbackups', 'ALL', 5 * 3600, 5 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('healthcheck_rackexachk', 'ALL', 1800, 1800);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_configure', 'ALL', 3 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_deleteconn', 'ALL', 3 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_failover', 'ALL', 3 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_reinstate', 'ALL', 3 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_state', 'ALL', 3 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_switchover', 'ALL', 3 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dg_verifyconn', 'ALL', 3 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit_association_bdcs_list', 'ALL', 30 * 3600, 30 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('exaunit_vmcmd_put', 'ALL', 1800, 1800);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('dbpatch', 'ALL', 5 * 3600, 5 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('PATCHING', 'ALL', 24 * 3600, 24 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('tm-create', 'ALL', 6 * 3600, 6 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('snap-create', 'ALL', 6 * 3600, 6 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('vm_sshcommand', 'ALL', 600, 600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('vm_command', 'ALL', 1800, 1800);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('createATPDbSystem', 'ALL', 48*3600, 48*3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('capacity_tenant_attcells', 'ALL', 504*3600, 504*3600);


-- TBD:  remove below three operation timeouts for createDatabase,
-- if they are not getting used anywhere
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('createDatabase', 'QUARTER', 2 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('createDatabase', 'HALF',    5 * 3600, 6 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('createDatabase', 'FULL',    7 * 3600, 8 * 3600);

-- Ecra Async operations polling.
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_ASYNC_POLLING_INTERVAL','ECRA_ASYNC', '30');
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_ASYNC_TIMEOUT','ECRA_ASYNC', '108000');
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_ASYNC_RETRIES','ECRA_ASYNC', '3');

-- Exacloud timeout error and wait cycles
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_ERROR_TIMEOUT','EXACLOUD', '60');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_WAIT_CYCLES','EXACLOUD', '200');

-- MDBCS properties for integration
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_ENABLE','MDBCS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_PATH'  ,'MDBCS', '../../../../mdbcs_home/mdbcscli');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_USER'  ,'MDBCS', 'mdbcs');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_SECRET','MDBCS', 'V2VsY29tZTEh');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_PATCH' , 'MDBCS','fleet_patch');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_CANCEL', 'MDBCS','cancel');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_PATCHER', 'MDBCS','none');
INSERT INTO ecs_properties (name, type, value) VALUES ('MDBCS_FLEET_PATCHER_RETRIES', 'MDBCS','5');
INSERT INTO ecs_properties (name, type, value) VALUES ('FPE_LB_ADDRESS', 'MDBCS', 'https://lb.url');

-- DIAG properties 
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_HOST', 'DIAG','pqr.us.oracle.com');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_PORT', 'DIAG','7802');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_USER', 'DIAG','sysman');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_PASSWD', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_LOGSTASH_HOST', 'DIAG','abc.us.oracle.com');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_LOGSTASH_PORT', 'DIAG','1234');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_LOGSTASH_USER', 'DIAG','abc');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_LOGSTASH_PASSWD', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_TFAWEB_HOST', 'DIAG','xyz.us.oracle.com');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_TFAWEB_PORT', 'DIAG','5678');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_TFAWEB_USER', 'DIAG','xyz');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_TFAWEB_PASSWD', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_OSS_TYPE', 'DIAG','atp');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_OSS_URL', 'DIAG','https://swiftobjectstorage.us-phoenix-1.oraclecloud.com/v1/exadata/patches/dbaas_patch/adbcs/em');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_OSS_USER', 'DIAG','ops');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_OSS_PASSWD', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_OSS_PROXY', 'DIAG','www-proxy.us.oracle.com:80');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_AGENT_HOST', 'DIAG','pqr.us.oracle.com');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_AGENT_PORT', 'DIAG','1234');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_AGENT_USER', 'DIAG','pqr');
INSERT INTO ecs_properties (name, type, value) VALUES ('DIAG_EM_AGENT_PASSWD', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOD_HOST', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOD_PORT', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOD_USER_NAME', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOD_USER_PASSWORD', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('ELASTIC_SEARCH_HOST', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('ELASTIC_SEARCH_PORT', 'DIAG','');
INSERT INTO ecs_properties (name, type, value) VALUES ('SANITYCHECK_RUN_TIMEOUT', 'DIAG','1200');

-- EXACD properties, default value is for dev env. will be updated by ecradpy diagnostic
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACD_OUTPUT_EXADATA_LOG_TO_LUMBERJACK', 'DIAGNOSTIC', 'disabled');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACD_OUTPUT_OTTO', 'DIAGNOSTIC', 'disabled');

-- DIAG_PRE_LOGCOL properties
INSERT INTO ecs_properties (name, type, value) VALUES ('PRE_LOGCOL_TARGET', 'DIAG_PRE_LOGCOL', 'adb-s');
INSERT INTO ecs_properties (name, type, value) VALUES ('PRE_LOGCOL_INTERVAL_HOURS', 'DIAG_PRE_LOGCOL', '3');
INSERT INTO ecs_properties (name, type, value) VALUES ('PRE_LOGCOL_COLLECTION_TYPE', 'DIAG_PRE_LOGCOL', 'generic');
INSERT INTO ecs_properties (name, type, value) VALUES ('PRE_LOGCOL_MAX_PARALLEL_OPS', 'DIAG_PRE_LOGCOL', '6');
INSERT INTO ecs_properties (name, type, value) VALUES ('PRE_LOGCOL_IGNORE_GAP_MINUTES', 'DIAG_PRE_LOGCOL', '15');
INSERT INTO ecs_properties (name, type, value) VALUES ('PRE_LOGCOL_CLEANUP_HOURS', 'DIAG_PRE_LOGCOL', '3');

-- Compliance properties
INSERT INTO ecs_properties (name, type, value) VALUES ('COMPLIANCE_AEP_CM', 'COMPLIANCE','disabled');
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_CM_CHANGE_REVERT', 'COMPLIANCE', 'N');
INSERT INTO ecs_properties (name, type, value) VALUES ('COMPLIANCE_SCAN_REPORT_OSS_NAMESPACE', 'COMPLIANCE', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('CM_REPORT_SKIP_LIST', 'COMPLIANCE', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('SEND_CM_TO_T2', 'COMPLIANCE', 'ENABLED');

-- STIG properties
INSERT INTO ecs_properties (name, type, value) VALUES ('STIG_SCAN_REALMS', 'STIG', '7');

-- Iaas support for Gen2
INSERT INTO ecs_properties (name, type, value) VALUES ('IAAS_ENABLED', 'IAAS', 'true');
INSERT INTO ecs_properties (name, type, value) VALUES ('DEFAULT_CORES', 'IAAS', '2');
-- Set ecra mode
-- This value is updated by ecradpy post op
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_MODE', 'ECRA', 'prod');
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_ENV', 'ECRA', 'edcs');

-- Set default opstate
INSERT INTO ecs_properties (name, type, value) VALUES ('DEFAULT_OPSTATE', 'ECRA', 'ONLINE');

-- Set ECRA exception stacktrace to single-line
INSERT INTO ecs_properties (name, type, value) VALUES ('STACKTRACE_FORMAT', 'ECRA', 'MULTI');

-- for setting log level (ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF) in ECRA.
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_LOG_LEVEL', 'ECRA', 'INFO');

-- Bug 30346688 -  30366036 Add progress percentage to /statuses API
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_STATUS_PERCENTAGE', 'ECRA', 'enabled');



-- Problem ID 0 is a default pool for faults
INSERT INTO ecs_diag_problem (id, start_time) VALUES (0, systimestamp);
INSERT INTO ecs_diag_problem (id, start_time) VALUES (-1, systimestamp);


-- BEGIN: Bug 28376960. Insert existing racks to ecs_diag_rackxml_monitor
-- existing exadata
INSERT INTO ecs_diag_rackxml_monitor (rack_name, status, action, updated)
  SELECT ecs_exadata.exadata_id || '-infra', 'init', 'existing', systimestamp
  FROM ecs_exadata
  WHERE ecs_exadata.exadata_id || '-infra' NOT IN (
    SELECT rack_name FROM ecs_diag_rackxml_monitor
  );  
  
-- existing rack_slots
INSERT INTO ecs_diag_rackxml_monitor (rack_name, status, action, updated)
  SELECT ecs_rack_slots.rack_name, 'init', 'existing', systimestamp
  FROM ecs_rack_slots
  WHERE ecs_rack_slots.rack_name NOT IN (
    SELECT rack_name FROM ecs_diag_rackxml_monitor
  );
  
-- existing racks
INSERT INTO ecs_diag_rackxml_monitor (rack_name, status, action, updated)
  SELECT ecs_racks.name, 'init', 'existing', systimestamp
  FROM ecs_racks
  WHERE ecs_racks.name NOT IN (
    SELECT rack_name FROM ecs_diag_rackxml_monitor
  );
-- END: Bug 28376960. Insert existing racks to ecs_diag_rackxml_monitor


-- Set PAAS cores properties
INSERT INTO ecs_properties (name, type, value) VALUES ('DEFAULT_PAAS_CORES', 'PAAS', '2');
INSERT INTO ecs_properties (name, type, value) VALUES ('MIN_PAAS_CORES', 'PAAS', '1');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXADATA_IMAGE_VERSION', 'PAAS', '19.2.0.0.0.190225');

-- Set ECRA model value of DEFAULT BASE SYSTEM MODEL and NON BASE SYSTEM MODEL 
INSERT INTO ecs_properties (name, type, value) VALUES ('DEFAULT_BASE_SYSTEM_MODEL', 'ECRA', 'X7-2');
INSERT INTO ecs_properties (name, type, value) VALUES ('DEFAULT_NON_BASE_SYSTEM_MODEL', 'ECRA', 'X5-2');
INSERT INTO ecs_properties (name, type, value) VALUES ('MIN_BASE_SYSTEM_MODEL', 'ECRA', 'X5-2');
INSERT INTO ecs_properties (name, type, value) VALUES ('BASE_SYSTEM_MODELS', 'EXACS', 'X8M-2,X9M-2');
INSERT INTO ecs_properties (name, type, value) VALUES ('PURE_ELASTIC_MODELS', 'EXACS', 'X9M-2');
INSERT INTO ecs_properties (name, type, value) VALUES ('BASESYSTEM_USE_BONDING_INPUT', 'EXACS', 'ENABLED');

-- Status tracker properties
INSERT INTO ecs_properties (name, type, value) VALUES ('STATUS_MANAGER_POLLING_INTERVAL_SECONDS', 'STATUS_TRACKER', '60');
INSERT INTO ecs_properties (name, type, value) VALUES ('STATUS_MANAGER_THREAD_POOL_SIZE', 'STATUS_TRACKER', '1');
INSERT INTO ecs_properties (name, type, value) VALUES ('STATUS_MANAGER_FAILOVER_TIMEOUT_SECONDS', 'STATUS_TRACKER', '604800');
INSERT INTO ecs_properties (name, type, value) VALUES ('STATUS_UPDATER_THREAD_POOL_SIZE', 'STATUS_TRACKER', '5');
INSERT INTO ecs_properties (name, type, value) VALUES ('STATUS_UPDATE_TIMEOUT_SECONDS', 'STATUS_TRACKER', '18000');

INSERT INTO ecs_properties (name, type, value) VALUES ('DEFAULT_OPERATION_TIMEOUT_SECONDS', 'OPERATION_TIMEOUT', '432000');

--changes for elastic storage/compute
--INSERT INTO ecs_properties (name, type, value) VALUES ('EXAFORMATION_FEATURE', 'ELASTIC', 'DISABLED'); TBD
INSERT INTO ecs_properties (name, type, value) VALUES ('ELASTIC_FEATURE', 'ELASTIC', 'ENABLED');

insert into ecs_generation_types values('BMC');
insert into ecs_generation_types values('GEN1');
insert into ecs_generation_types values('AD');
insert into ecs_generation_types values('EXACM');

insert into ecs_vm_sizes values ('X6-2','Large', 16,'64Gb', '60Gb');
insert into ecs_vm_sizes values ('X6-2','Medium',8, '32Gb', '40Gb');
insert into ecs_vm_sizes values ('X6-2','Small', 4, '16Gb', '20Gb');
insert into ecs_vm_sizes values ('X7-2','Large', 16,'64Gb', '60Gb');
insert into ecs_vm_sizes values ('X7-2','Medium',8, '32Gb', '40Gb');
insert into ecs_vm_sizes values ('X7-2','Small', 4, '16Gb', '20Gb');

-- BEGIN: ER 28633340. Data model to support ATP whitelist
INSERT INTO atp_properties (name, value, type) VALUES ('p1','@1521@in', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p2','@1521@out', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p3','@2484@in', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p4','@2484@out', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p5','@443@in', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p6','@443@out', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p7','@6200@in', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p8','s169.254.169.254@7060@in', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p9','s169.254.169.254@7070@in', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p10','@6200@out', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p1','22', 'ORCL_CLIENT_SUBNET_PORT');
INSERT INTO atp_properties (name, value, type) VALUES ('p11','@25@out',  'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p12','@587@out', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p13','@80@out',  'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p14','@389@out', 'IPTABLE_WHITELIST');
INSERT INTO atp_properties (name, value, type) VALUES ('p15','@636@out', 'IPTABLE_WHITELIST');
-- END: ER 28633340. Data model to support ATP whitelist 
 
-- KMS configurations (values will be set by ecradpy)
INSERT INTO ecs_properties (name, type, value) VALUES ('KMS_DP_ENDPOINT', 'KMS', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('KMS_KEY_ID', 'KMS', NULL);

-- KMS ENABLE/DISABLED Movement of Keys
INSERT INTO ecs_properties (name, type, value) VALUES ('KMS_ENABLE_MOVE_KEYS', 'KMS', 'DISABLED');

-- FA_DEPLOYMENT
INSERT INTO ecs_properties (name, type, value) VALUES ('FA_DEPLOYMENT','FA','FALSE');

-- ATP pre provisioning jobs' metadata
-- TODO: Enh 29281630: Move timeout values from ecs_atpjobsmetadata table to timeout properties
-- For URM False Cases
INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, metadata, job_category) 
    VALUES ('READY', 'oracle.exadata.ecra.cloudservices.atp.jobs.ATPPreprovCreateOracleNetwork', '{"timeout": 900}', 'NON-URM');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, metadata, job_category) 
    VALUES ('PRE_PROVISIONED_ORCL_NETWORK', 'oracle.exadata.ecra.cloudservices.atp.jobs.ATPPreprovCreateDBSystem', '{"timeout": 86400}', 'NON-URM');

-- For URM True Cases
INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, metadata, job_category) 
    VALUES ('NEW', 'oracle.exadata.ecra.cloudservices.atp.jobs.ATPPreprovCEIPrecheck', '{"timeout": 86400}', 'URM');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, metadata, job_category) 
    VALUES ('READY', 'oracle.exadata.ecra.cloudservices.atp.jobs.ATPPreprovCEIPrecheck', '{"timeout": 86400}', 'URM');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, metadata, job_category) 
    VALUES ('CEI_PRECHECK_DONE', 'oracle.exadata.ecra.cloudservices.atp.jobs.ATPPreprovCEICreate', '{"timeout": 86400}', 'URM');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, metadata, job_category) 
    VALUES ('CEI_AVAILABLE', 'oracle.exadata.ecra.cloudservices.atp.jobs.ATPPreprovCreateOracleNetwork', '{"timeout": 86400}', 'URM');

INSERT INTO ecs_atpjobsmetadata (rack_status, job_class, metadata, job_category) 
    VALUES ('PRE_PROVISIONED_ORCL_NETWORK', 'oracle.exadata.ecra.cloudservices.atp.jobs.ATPPreprovCEIVMCluster', '{"timeout": 86400}', 'URM');

-- SSH command timeout
INSERT INTO ecs_properties (name, type, value) VALUES ('DEFAULT_COMMAND_TIMEOUT', 'ECRA', '30');

-- ECRA scheduler thread pool size
INSERT INTO ecs_properties (name, type, value) VALUES ('SCHEDULER_THREAD_POOL_SIZE' , 'ECRA', '10');

-- Insert for ecs_properties for heartbeat configuration values.
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_ENDPOINT_HISTORY_SIZE','HEARTBEAT','5');
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_JOB_SCHEDULER_TIME_PERIOD','HEARTBEAT','60');
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_THREAD_POOL_SIZE','HEARTBEAT','10');
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_UNREACHABLE_COUNT_LIMIT','HEARTBEAT','3');
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_WORKER_REQUEST_TIMEOUT','HEARTBEAT','60');
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_WORKER_TIMEOUT','HEARTBEAT','180');
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_WORKER_TIME_PERIOD','HEARTBEAT','120');
INSERT INTO ecs_properties (name, type, value) VALUES ('HEARTBEAT_JOBS_ENABLED','HEARTBEAT','true');

INSERT INTO ecs_scheduledjob (job_class, job_cmd, job_params, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.heartbeat.HeartbeatJobManager', null, null, 'Y', 120, 'Init');

-- Enh 30366036
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.scheduler.ProfilingCacheJob', 'Y', 3600, 'Init');

-- Enh 32775738  - VM Backup Job
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.VMBackupJob', 'N', 7200, 'Init', 'RECURRENT', 'STANDBY');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_CONCURRENT_BACKUP','FEATURE','15');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_INTERVAL_BACKUP','FEATURE','120');

-- Enh 33612595  - VM Backup Job, support for failed backups
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_CONCURRENT_BACKUP_FOR_RACK','FEATURE','2');

-- Enh 33210767 - Delete VM Backup Job
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type) VALUES ('oracle.exadata.ecra.scheduler.VMDelBackupJob', 'Y', 604800, 'Init', 'RECURRENT');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_RETENTION_BACKUP_DEL','FEATURE','-1');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_INTERVAL_BACKUP_DEL','FEATURE','604800');

-- Enh 35543208 - Add vm backup status tracker job
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.VMBackupStatusTrackerJob', 'N', 600, 'Init', 'RECURRENT', 'STANDBY');

-- Enh 30560468
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.scheduler.AvailableVersionsJob', 'Y', 86400, 'Init');
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.scheduler.AppliedVersionsJob', 'Y', 86400, 'Init');

-- certificate rotation scheduler
INSERT INTO ecs_properties (name, type, value) VALUES ('CERT_ROTATION_LIST','CERTROTATION','CLIENT,WSSERVER,WSADMIN,WSPROXY');
INSERT INTO ecs_properties (name, type, value) VALUES ('CERT_ROTATION_REQUEST_TIMEOUT','CERTROTATION','600');
INSERT INTO ecs_properties (name, type, value) VALUES ('CERTIFICATE_EXPIRE','CERTROTATION','7776000');
INSERT INTO ecs_properties (name, type, value) VALUES ('CERT_ROTATION_ENABLED','CERTROTATION','false');
INSERT INTO ecs_properties (name, type, value) VALUES ('CERT_ROTATION_INTERVAL','CERTROTATION','86400');
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.certrotation.CertRotationJob', 'Y', 86400, 'Init');

-- password rotation scheduler
INSERT INTO ecs_properties (name, type, value) VALUES ('INFRAPWD_ROTATION_PERIOD', 'INT', '60');
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type) VALUES ('oracle.exadata.ecra.scheduler.InfraPasswordRotationJob', 'Y', 3600, 'Init', 'RECURRENT');

-- dataplane key rotation schduler
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_ECRA_DATAPLANE_ROTATION_PERIOD', 'INT', '60');
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by, type) VALUES ('oracle.exadata.ecra.scheduler.DataPlaneKeyRotationJob', 'Y', 5184000, 'Init', 'RECURRENT');

-- Enh 34808479 - REDUCE DB QUERY BY CACHING CONSTANT VALUES
INSERT INTO ecs_scheduledjob(job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.PropertyCacheJob', 'Y', 86400, 'Init', 'RECURRENT', 'ANY');

-- Enh 31585186
INSERT INTO ecs_properties (name, type, value) VALUES ('FIPS_COMPLIANCE',  'FEATURE', 'DISABLED');

-- Enh 32677648
INSERT INTO ecs_properties (name, type, value) VALUES ('SELINUX_DOM0',  'FEATURE', 'disabled');
INSERT INTO ecs_properties (name, type, value) VALUES ('SELINUX_DOMU',  'FEATURE', 'disabled');
INSERT INTO ecs_properties (name, type, value) VALUES ('SELINUX_CELL',  'FEATURE', 'disabled');
DELETE FROM ecs_properties where name='SE_LINUX';

-- Enh 31856863 cluod vnuma
INSERT INTO ecs_cloudvnuma_tenancy (user_group, tenancy_id, cloud_vnuma) VALUES ('EXACS',  '__default_tenancy__', 'enabled_with_dom0_overlap');

-- Enh 31782184
INSERT INTO ecs_properties (name, type, value) VALUES ('AUTO_PATCH_VERSION',  'FEATURE', 'NONE');

-- Enh 30945957
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACS_DEFAULT_GRID',  'EXACS', '19');
INSERT INTO ecs_properties (name, type, value) VALUES ('OVERRIDE_GRID',  'FEATURE', 'ENABLED');

-- Enh 32078131
INSERT INTO ecs_properties (name, type, value) VALUES ('ONSR_REALMS',  'FEATURE', '5,6,7');

-- Enh 33037280 
INSERT INTO ecs_properties (name, type, value) VALUES ('GOV_ONSR_REALMS',  'FEATURE', '2,3,4,5,6,7,9');

-- Enh 32079911
INSERT INTO ecs_properties (name, type, value) VALUES ('PRODUCTION_CERT',  'FEATURE', 'DISABLED');

INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_SCALE_SANITYCHECK_DOMUVERSION',  'EXACOMPUTE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_TEST_ENVIRONMENT',  'EXACOMPUTE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_TEST_CELLS',  'EXACOMPUTE', 'iad103712exdcl01,iad103712exdcl02,iad103712exdcl03');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXASCALE_STORAGE_VLAN',  'EXACOMPUTE', '3999');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_DEFAULT_CURRENTMDID',  'EXACOMPUTE', '15');

-- Bug 36308005 - EXACS: Fresh provisioning with 23c gi has 19cgi configured post provisioning
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_OVERRIDE_GRID',  'FEATURE', 'DISABLED');

-- Enh 37197440 - Add a way to force celltype and computetype during infra creation
INSERT INTO ecs_properties (name, type, value, description) values ('OVERRIDE_CELLTYPE_CEI_CREATION', 'FEATURE', '', 'Property to force the specified celltype during infra creation flow');
INSERT INTO ecs_properties (name, type, value, description) values ('OVERRIDE_COMPUTETYPE_CEI_CREATION', 'FEATURE', '', 'Property to force the specified computetype during infra creation flow');

-- ExaIE events switches
INSERT INTO exaie_events_switches (event_name, event_switch) VALUES ('exaie_sql_quarantine_event',      'ON');
INSERT INTO exaie_events_switches (event_name, event_switch) VALUES ('exaie_flash_disk_failure_event',  'ON');
INSERT INTO exaie_events_switches (event_name, event_switch) VALUES ('exaie_no_db_activity_event',      'OFF');
INSERT INTO exaie_events_switches (event_name, event_switch) VALUES ('exaie_dom0_down_event',           'OFF');

-- CompliancePauseRule definition (There are also UPDATEs below)
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('atp-reconfig-service', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('atp-vm-rollback', 'Request', 'exaunit_id', '', 'domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('bonding-migration-setup', 'Request', 'resource_id', '', 'dom0,domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('bonding-network-migrate', 'Request', 'resource_id', '', 'dom0,domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('BONDING_VLANMIGRATE', 'Request', 'resource_id', '', 'dom0,domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('create-addi-db', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('create-service', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('create-starter-db', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('dbaas_patch', 'Request', 'exaunit_id', '', 'domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('delete-addi-db', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('delete-bonding', 'Request', 'resource_id', '', 'dom0,domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('delete-pod', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('delete-starter-db', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('dg_fresh_setup', 'Request', 'exaunit_id', '', 'domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('dg_repeat_setup', 'Request', 'exaunit_id', '', 'domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('disable-bond-monitor', 'Request', 'resource_id', '', 'dom0,domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('enable-bond-monitor', 'Request', 'resource_id', '', 'dom0,domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('exaunit-attach-cell', 'Request', 'exaunit_id', 'resource_id', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('exaunit-attach-compute', 'Request', 'exaunit_id', 'resource_id', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('exaunit-dettach-cell', 'Request', 'exaunit_id', 'resource_id', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('exaunit-dettach-compute', 'Request', 'exaunit_id', 'resource_id', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('oci-attach-', 'Request', 'exaunit_id', 'resource_id', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('oci-attach-cell', 'Request', 'exaunit_id', 'resource_id', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('oci-attach-comp', 'Request', 'exaunit_id', 'resource_id', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('oci-dettach-', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('oci-dettach-cell', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('oci-dettach-comp', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('recreate-create', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('recreate-db', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('recreate-delete', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('recreate-grid-create-db', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('recreate-service', 'Request', 'exaunit_id', '', '');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('setup-bonding', 'Request', 'resource_id', '', 'dom0,domu');
INSERT INTO ecs_compliance_pause_rule(operation, request_class, target_rack, target_host, host_type) VALUES('update-service', 'Request', 'exaunit_id', '', 'dom0,domu');

-- Enh 34972266 - EXACS Compatibility - create new tables to support compatibility on operations
INSERT INTO ecs_operations_compatibility(operation, compatibleoperation, env) VALUES('reshape-cores', 'reshape-storage', 'bm');
INSERT INTO ecs_operations_compatibility(operation, compatibleoperation, env) VALUES('reshape-cores', 'oci-attach-cell', 'bm');
INSERT INTO ecs_operations_compatibility(operation, compatibleoperation, env) VALUES('reshape-cores', 'exaunit-attach-cell', 'bm');
INSERT INTO ecs_operations_compatibility(operation, compatibleoperation, env) VALUES('reshape-cores', 'exaunit-delete-cell', 'bm');
INSERT INTO ecs_operations_compatibility(operation, compatibleoperation, env) VALUES('reshape-cores', 'mvm-attach-storage', 'bm');
INSERT INTO ecs_operations_compatibility(operation, compatibleoperation, env) VALUES('reshape-cores', 'mvm-delete-storage', 'bm');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('OPERATION_COMPATIBILITY_FEATURE',  'FEATURE', 'DISABLED', 'Property to enable/disable operations compatibility. If the property is enabled the code will use the compatibility matrix to allow parallel operations');


PROMPT Done Inserting data into the schema tables
--------------------- END INSERT ----------------------------------------

--------------------- BEGIN UPDATE --------------------------------------
PROMPT Updating existing data in the schema tables

update ECS_SCHEDULEDJOB set ENABLED='N' where JOB_CLASS = 'oracle.exadata.ecra.scheduler.VMBackupStatusTrackerJob';
update ECS_SCHEDULEDJOB set ENABLED='N' where JOB_CLASS = 'oracle.exadata.ecra.scheduler.VMBackupJob';
update ECS_SCHEDULEDJOB set INTERVAL=604800 where JOB_CLASS = 'oracle.exadata.ecra.scheduler.VMBackupJob';
UPDATE ecs_properties set value='0' where name='VM_CONCURRENT_BACKUP';

PROMPT UPDATING VMBACKUP JOB FOR WEEKLY UPDATES
UPDATE ECS_SCHEDULEDJOB 
SET LAST_UPDATE = trunc(sysdate, 'IW') - INTERVAL  '1' DAY + INTERVAL '1' HOUR 
WHERE JOB_CLASS = 'oracle.exadata.ecra.scheduler.VMBackupJob';

UPDATE ecs_properties SET value='2' WHERE name='OCI_SDK_VERSION';

-- certificate rotation scheduler Add new elements in rotation list
UPDATE ecs_properties SET value='CLIENT' WHERE name='CERT_ROTATION_LIST';

-- Update the value of FIREWALL_RULES_PER_GROUP
update ecs_properties
 set VALUE=25
 where NAME='FIREWALL_RULES_PER_GROUP';

-- Update the value of FIREWALL_GROUPS_PER_EXAUNIT 
update ecs_properties
 set VALUE=15
 where NAME='FIREWALL_GROUPS_PER_EXAUNIT';

update ecs_properties set VALUE=64 where name='ROCE_MAX_ELASTIC_STORAGE';

-- Update the value of STATUS_UPDATER_THREAD_POOL_SIZE
update ecs_properties
 set VALUE='20'
 where NAME='STATUS_UPDATER_THREAD_POOL_SIZE';

-- Update HIGGS properties 
UPDATE ecs_properties SET value='https://10.128.95.197/' WHERE name='HIGGS_URL';
UPDATE ecs_properties SET value='https://10.128.95.197:443/' WHERE name='HIGGS_QUERY_URL';
UPDATE ecs_properties SET value='/oracle/public/cloud-ippool' WHERE name='HIGGS_CLOUD_IPPOOL';
UPDATE ecs_properties SET value='root/root' WHERE name='HIGGS_USERNAME';

UPDATE ecs_properties SET value='ENABLED' WHERE name='ELASTIC_FEATURE';

-- Enh 35132786 - vm backup support for dom0 sending
UPDATE ecs_properties SET value='15' WHERE name='VM_CONCURRENT_BACKUP';
UPDATE ecs_properties SET value='120' WHERE name='VM_INTERVAL_BACKUP';


-- ER 28731684. Scheduler support for one-off job
-- Assign 'RECURRENT' type for existing jobs
UPDATE ecs_scheduledjob SET type='RECURRENT' WHERE type IS NULL;

-- Reset diag_rackxml_monitor so that all diag_rack_info data will be refreshed
UPDATE ecs_diag_rackxml_monitor SET status='init' WHERE action='ins_upd';

-- Bug - 29341155: Increase default pre provisioning scheduler interval to 8 minutes
update ecs_properties set value='480' where name='PREPROV_SCHEDULER_INTERVAL_SECONDS';

-- Remove old entries in ecs_oh_space_rule for 8 disks with 3800Gb physical storage
delete from ECS_OH_SPACE_RULE where MODEL='ALL' and RACKSIZE='ALL' and PHYSICALSPACEINGB=3800 and USEABLEOHSPACEINGB=1100;
delete from ECS_OH_SPACE_RULE where MODEL='X7-2' and RACKSIZE='ALL' and PHYSICALSPACEINGB=3800 and USEABLEOHSPACEINGB=1100;
update ECS_OH_SPACE_RULE set USEABLEOHSPACEINGB=500 where MODEL='ALL' and RACKSIZE='ALL' and PHYSICALSPACEINGB=1600 and USEABLEOHSPACEINGB=400;


-- Update atp db property to 19
UPDATE ecs_properties SET value = '19' WHERE name = 'ATP_DEFAULT_GRID';

INSERT INTO ecs_properties (name, type, value) VALUES ('ADMIN_HEADEND_TYPE', 'ATP', 'WSS');
INSERT INTO ecs_properties (name, type, value) VALUES ('MGMT_VCN_EXACC_ENABLED', 'ATP', 'true');

-- Update Service type catalog to have EXACOMPUTE also
UPDATE ecs_properties SET value='EXACS,FA,ADBD,ADBS,EXACC,PREPROD,GBU,IDCS,OMCS,TEST,EXACOMPUTE' WHERE name='SERVICE_TYPE' and type='PATCHING';

-- Updated Node states which will be considered for Clusterless patching
UPDATE ecs_properties SET value='FREE,RESERVED,FREE_MAINTENANCE,FREE_FAILURE,RESERVED_MAINTENANCE,RESERVED_FAILURE,FREE_UNDER_MAINT,FREE_AUTO_MAINTENANCE' WHERE name='CLUSTERLESS_NODE_STATES_TO_PATCH' and type='PATCHING';

-- Ecra async calls properties.
UPDATE ecs_properties SET value='15' WHERE name='ECRA_ASYNC_POLLING_INTERVAL';

UPDATE ecs_properties SET value='10.0.0.0/16' WHERE name='ATP_ORCL_CLIENT_VCNCIDR';

-- Update WORKFLOW_BASED_OPERATION to Enabled
UPDATE ecs_properties SET value='ENABLED' WHERE name='WORKFLOW_BASED_OPERATION';

-- Update CLUSTERTAGS for ZDLRA
update ecs_properties set value = CASE WHEN value NOT LIKE '%ZDLRA%' THEN value || ',ZDLRA' ELSE value end where name='CLUSTERTAGS';

-- Update max delta sw version between cells and computes
UPDATE ecs_properties SET value='2.0.0' WHERE name='MAX_DELTA_FOR_RELAXED_VERSION';

-- Enh 35421067 - EXACS MVM - ENABLE PARALLEL CELL/COMPUTE BEHAVIOR BY DEFAULT IN DROP4 
UPDATE ecs_properties SET value='ENABLED' WHERE name='ELASTIC_CELL_STEPWISE_ADDITION';
UPDATE ecs_properties SET value='ENABLED' WHERE name='ELASTIC_COMPUTE_STEPWISE_ADDITION';
UPDATE ecs_properties SET value='ENABLED' WHERE name='ELASTIC_CELL_MVM_STEPWISE_ADDITION';

-- Enh 35523781 - SYSTEM IMAGE VERSION CHECK FAILED: ENABLE EXACLOUD_CS_SKIP_SWVERSION_CHECK PROPERTY 
UPDATE ecs_properties SET value='ENABLED' WHERE name='EXACLOUD_CS_SKIP_SWVERSION_CHECK';

-- OCI-ExA seeds
INSERT INTO ecs_oci_tenant_info values ('EXISTING.PUBLIC.CLOUD.TENANT', NULL, NULL);

INSERT INTO ecs_oci_exa_info(TENANT_OCID,EXA_OCID,EXA_NAME,DNS,NTP,TIMEZONE,MULTIVM,ENV,ADMIN_NW_CIDR,IB_NW_CIDR,CONNECTIVITY,HEARTBEAT_COUNT,HEARTBEAT_LASTUPDATE,EC_KEYS_DB,RACK_BASENAME,ATP, STATUS, HEADENDTYPE) values (
    'EXISTING.PUBLIC.CLOUD.TENANT',
    'EXISTING.PUBLIC.CLOUD.EXADATA',
    'EXISTING.PUBLIC.CLOUD.EXADATA',
    '000.000.000.000',
    '000.000.000.000',
    'NA',
    -1,
    'ociexacs',
    NULL,
    NULL,
    'NOT_REACHABLE',
    0,
    CURRENT_TIMESTAMP,
    NULL,
    'EXISTING.PUBLIC.CLOUD.EXADATA',
    'N',
    'READY',
    'VPN'
);

UPDATE ecs_oci_exa_info SET asmss='FALSE' WHERE asmss is NULL;

INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_CIPHER_LENGTH', 'ECRA', '16');

UPDATE ecs_properties SET value='2' WHERE name='DEFAULT_CORES';

-- MIGRATION FOR TERRAFORM VERSIONING

INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_CURRENT_MGMT_VCNID', 'ATP', '');

-- CREATE RECORD ON ecs_atpterraformversion
INSERT INTO ecs_atpterraformversion (ingestion_version, vcnid, servicejson_data, ingestion_date)
SELECT 1, terradata.vcnid, null, current_timestamp from 
(SELECT VALUE AS VCNID FROM ECS_PROPERTIES WHERE NAME='ATP_OM_VCNID') terradata 
WHERE not exists(select * from ecs_atpterraformversion) and exists(select * from ecs_atpomvcnnetwork);

-- INSERT DATA ON ECS_ATPOMVCNNETWORK, COPYING CURRENT VALUES WITH DEFAULT VCNID
INSERT INTO ECS_ATPOMVCNNETWORK (tenancy_ocid, id, component, cidr_block, availability_domain_name, NAME, TYPE, DOMAIN_NAME, ingestion_version, vcnid)
SELECT anet.tenancy_ocid, anet.id, anet.component, anet.cidr_block, anet.availability_domain_name, anet.NAME, anet.TYPE, anet.DOMAIN_NAME, 1, terraversion.vcnid 
FROM ECS_ATPOMVCNNETWORK anet 
INNER JOIN ecs_atpterraformversion terraversion 
ON anet.ingestion_version=terraversion.ingestion_version 
WHERE 
EXISTS ( SELECT * FROM ECS_ATPOMVCNNETWORK WHERE VCNID='default_value_vcnid');


-- UPDATE DATA ON ECS_ATPWHITELISTSECRULES
update ECS_ATPWHITELISTSECRULES T1
set 
INGESTION_VERSION=1,
VCNID= (SELECT VCNID FROM ecs_atpterraformversion WHERE INGESTION_VERSION = 1)
WHERE 
EXISTS ( SELECT * FROM ECS_ATPWHITELISTSECRULES WHERE VCNID='default_value_vcnid');

-- DELETE VALUES FROM ECS_ATPOMVCNNETWORK WITH THE DEFAULT VCNID
DELETE FROM ECS_ATPOMVCNNETWORK WHERE VCNID='default_value_vcnid';

-- UPDATE DATA ON ECS_ATPOMVCNRESOURCE
update ECS_ATPOMVCNRESOURCE T1
set 
INGESTION_VERSION=1,
VCNID= (SELECT VCNID FROM ecs_atpterraformversion WHERE INGESTION_VERSION = 1)
WHERE 
EXISTS ( SELECT * FROM ECS_ATPOMVCNRESOURCE WHERE VCNID='default_value_vcnid');


-- UPDATE DATA ON ECS_ATPOMVCNCONFIGPROPS
update ECS_ATPOMVCNCONFIGPROPS T1
set 
INGESTION_VERSION=1,
VCNID= (SELECT VCNID FROM ecs_atpterraformversion WHERE INGESTION_VERSION = 1)
WHERE 
EXISTS ( SELECT * FROM ECS_ATPOMVCNCONFIGPROPS WHERE VCNID='default_value_vcnid');


-- UPDATE DATA ON ECS_ATPSUBNETPOOL
update ECS_ATPSUBNETPOOL T1
set 
INGESTION_VERSION=1,
VCNID= (SELECT VCNID FROM ecs_atpterraformversion WHERE INGESTION_VERSION = 1)
WHERE 
EXISTS ( SELECT * FROM ECS_ATPSUBNETPOOL WHERE VCNID='default_value_vcnid');


-- ATP_CURRENT_MGMT_VCNID
UPDATE ecs_properties SET
VALUE= (SELECT VCNID FROM ecs_atpterraformversion WHERE INGESTION_VERSION = 1)
WHERE
NAME='ATP_CURRENT_MGMT_VCNID' AND
EXISTS ( SELECT * FROM ecs_atpomvcnidentity WHERE VCNID='default_value_vcnid');

-- UPDATE DATA ON ecs_atpomvcnidentity
update ecs_atpomvcnidentity T1
set 
INGESTION_VERSION=1,
VCNID= (SELECT VCNID FROM ecs_atpterraformversion WHERE INGESTION_VERSION = 1)
WHERE 
EXISTS ( SELECT * FROM ecs_atpomvcnidentity WHERE VCNID='default_value_vcnid');
--END OF MIGRATION FOR TERRAFORM VERSIONING


--Migrate information from clientidentity to identity table
INSERT INTO ecs_atpomvcnidentity (tenancy_ocid, region, compartment_ocid, user_ocid, fingerprint, private_pem_key, ingestion_version, vcnid, identity_type)
SELECT tenancy_ocid, region, compartment_ocid, user_ocid, fingerprint, private_pem_key, ingestion_version, vcnid, 'ORCL_CLIENT' from 
(SELECT tenancy_ocid, region, compartment_ocid, user_ocid, fingerprint, private_pem_key,1 as joinid FROM ecs_atporacleclientidentity) ci inner join
(SELECT ingestion_version, vcnid, 1 as joinid FROM ecs_atpomvcnidentity where rownum=1) i on i.joinid=ci.joinid
where not exists(select identity_type from ecs_atpomvcnidentity where identity_type='ORCL_CLIENT');
-- End of data migration

--change the  max allowed delta for the physical space found on an empty exadata
--rack need to be increased from current 200GB to 400GB
UPDATE ecs_properties SET value='400' WHERE name='MAX_LOCAL_STORAGE_DELTA_IN_GB';



INSERT INTO ecs_properties (name, type, value) VALUES ('INGEST_TERRAFORM_OSS_BUCKET', 'ATP', 'terraform-servicejson');

INSERT INTO ecs_properties (name, type, value) VALUES ('SERVICE_JSON_ENCRYPTION_KEY', 'ATP', '');

INSERT INTO ecs_properties (name, type, value) VALUES ('ADMIN_HEADEND_TYPE', 'ATP', 'VPN');


-- using this property to toggle capacity reserve call while ecra rolling upgrade after preprovisioning
INSERT INTO ecs_properties (name, type, value) VALUES ('BLOCK_ECRA_API', 'ATP', 'DISABLED');
-- use this property to block fleet patching update calls while ecra rolling upgrade at begining
INSERT INTO ecs_properties (name, type, value) VALUES ('CP_ROLLING_UPGRADE', 'ATP', 'DISABLED');

INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROV_RECONFIG_TIMEOUT', 'ATP', '30');

INSERT INTO ecs_properties (name, type, value) VALUES ('TEST_MODE', 'TEST', 'FALSE');

-- Enh 32139044 Property for mock cp flow 
INSERT INTO ecs_properties (name, type, value) VALUES ('CP_WORKFLOW_SIMULATION', 'TEST', 'DISABLED');

--seeding for ecs_atpociendpointurl table
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC1', 'oraclecloud.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC2', 'oraclegovcloud.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC3', 'oraclegovcloud.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC4', 'oraclegovcloud.uk');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC5', 'oracleonsrcloud.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC6', 'oracleonsrcloud.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC7', 'oracleonsrcloud.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC8', 'oraclecloud8.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('OC9', 'oraclecloud9.com');
INSERT INTO ecs_atpociendpointurl (realm, realmdomain) VALUES ('R1_ENVIRONMENT', 'oracleiaas.com');
-- Enh 36206167 
UPDATE ecs_atpociendpointurl SET realmdomain='oraclecloud5.com' where realm='OC5';

alter table ecs_atpociendpointurl add constraint pk_ecs_atpociendpointurl primary key (realm);


--seeding for ecs_ociservices
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('COMPUTE', 'iaas');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('DATABASE', 'database');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('OSS', 'swiftobjectstorage');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('KMS', 'kms');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('AUTOSCALING', 'autoscaling');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('IMAGECATALOG', 'imagecatalog');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('BLOCKVOLUMES', 'iaas');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('IDENTITY', 'identity');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('INCIDENTMGMT', 'incidentmanagement');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('LOGIN', 'login');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('FILESTORAGE', 'filestorage');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('FUNCTIONS', 'functions');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('CONSOLE', 'console');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('DNS', 'dns');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('CASPER', 'objectstorage');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('AUTH', 'auth');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('VAULTS', 'vaults');
INSERT INTO ecs_ociservices (service, serviceidentifier) VALUES ('SECRETS', 'secrets.vaults');

-- Upgrade path: update usable OH space to 900GB for X8-2 with 8 disks
UPDATE ECS_OH_SPACE_RULE SET useableohspaceingb=900 WHERE model='X8-2' AND PHYSICALSPACEINGB=3100;


INSERT INTO ecs_properties (name, type, value) VALUES ('CA_BUNDLE_PATH', 'EXACC', '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem');
INSERT INTO ecs_properties (name, type, value) VALUES ('INSTANCE_HOST_OCI', 'EXACC', '169.254.169.254');
INSERT INTO ecs_properties (name, type, value) VALUES ('COMPARTMENT_OCID', 'EXACC', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_INSTANCE_METADATA_URL', 'EXACC', 'http://169.254.169.254/opc/v2/instance/');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACD_LOG_COL_BUCKET_EXACC', 'EXACC', 'log_col_exacc');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACD_ECLOGSCANNER_RETRY_COUNT', 'EXACC', '2');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACC_EXADATA_PATCH_TARGET_VERSION', 'EXACC', 'LATEST');
INSERT INTO ecs_properties (name, type, value) VALUES ('CUSTOM_IMAGE_WAIT_CYCLES', 'EXACC', '720');
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_ECRA_TENANCY_ID', 'EXACC', null);
INSERT INTO ecs_properties (name, type, value, description) values ('BLUE_GREEN_DEPLOYMENT', 'FEATURE', 'DISABLED', 'Property for blue-green deployment changes');
INSERT INTO ecs_properties (name, type, value, description) values ('BLUE_GREEN_BACKEND_PREFERENCE', 'FEATURE', 'PASSIVE', 'Property for default backendsets for add node');
INSERT INTO ecs_properties (name, type, value, description) values ('ECRA_ACTIVE_ACTIVE', 'FEATURE', 'DISABLED', 'Property for active active ECRA  deployment changes');
INSERT INTO ecs_properties (name, type, value, description) values ('ECRA_INFRA_SETUP', 'FEATURE', 'ACTIVE_ACTIVE', 'Property for  ECRA  infra setup  deployment type');
INSERT INTO ecs_properties (name, type, value) VALUES ('SKIP_OCI_PAR_URL_CREATION',  'FEATURE', 'DISABLED');

UPDATE ecs_properties SET value = 'WSS' WHERE name = 'ADMIN_HEADEND_TYPE';

UPDATE ECS_OH_SPACE_RULE
    SET USEABLEOHSPACEINGB=2340
    WHERE MODEL='X8M-2';
UPDATE ECS_OH_SPACE_RULE
    SET PHYSICALSPACEINGB=7200
    WHERE MODEL='X8M-2';
UPDATE ECS_OH_SPACE_RULE
    SET MAX_OHSIZE_PER_NODE=900
    WHERE MODEL='X8M-2' AND USEABLEOHSPACEINGB>900;

UPDATE ECS_OH_SPACE_RULE
    SET USEABLEOHSPACEINGB=2243
    WHERE MODEL='X9M-2' AND RACKSIZE<>'EIGHTH';
-- CompliancePauseRule definition update
UPDATE ecs_compliance_pause_rule SET target_host='details:json:nodes.hostname' WHERE (operation='setup-bonding' OR operation='delete-bonding') AND request_class='Request';
UPDATE ecs_properties SET value='installed_sw,iptables2,bios_info' WHERE name='CM_REPORT_SKIP_LIST';

-- Infrastructure Dataplane Events (ExaIE) Settings
UPDATE exaie_events_switches SET event_switch='OFF' WHERE event_name='exaie_no_db_activity_event';

-- Bug 36308005 - EXACS: Fresh provisioning with 23c gi has 19cgi configured post provisioning
UPDATE ecs_properties SET value='DISABLED' WHERE name='OVERRIDE_GRID';

-- Bug 37115247 -Enable CUSTOM_GI
UPDATE ecs_properties SET value='ENABLED' WHERE name='CUSTOM_GI';

PROMPT Done Updating existing data in the schema tables
--------------------- END UPDATE --------------------------------------
commit;
 
PROMPT Deleting tables from update script
-- DROP TABLES SECTION --
drop table ecs_atporacleclientidentity;
drop table ecs_atpauthentication;
drop table vms;
PROMPT Done Deleting tables from update script

PROMPT Adding scheduler job for secret rotation for OCI Upgrade vault
INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by) VALUES ('oracle.exadata.ecra.certrotation.EcraOciUpgradeRotationJob', 'Y', 7776000, 'Init');
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_UPGRADE_BUCKET_NAME', 'OCI_UPGRADE', 'upgrade_gen1_gen2');
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_REHOME_BUCKET_NAME', 'OCI_REHOME', 'exacc_oci_rehome');

PROMPT policies for RegisteredJonManager
INSERT INTO ecs_properties (name, type, value) VALUES ('REG_JOB_MANAGER_POLLING_INTERVAL_SECONDS', 'REG_JOB_MANAGER', '60');
INSERT INTO ecs_properties (name, type, value) VALUES ('REG_JOB_MANAGER_THREAD_POOL_SIZE', 'REG_JOB_MANAGER', '1');

PROMPT Feature flag for URM
INSERT INTO ecs_properties (name, type, value) VALUES ('URM_FEATURE', 'FEATURE', 'DISABLED');

DELETE FROM ecs_properties where name in ('FPE_PASSWORD','OFFLINE_PASSWORD','PERHUB_PASSWORD','DOD_PASSWORD');

-- Enh 32347095
PROMPT property for Post Create Service config check
INSERT INTO ecs_properties (name, type, value) VALUES ('RUN_CS_POST_CHECK_EXACS', 'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('RUN_CS_POST_CHECK_ADBD', 'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('FAIL_CS_ON_POST_CHECK_ERROR', 'FEATURE', 'DISABLED');

INSERT INTO ecs_properties (name, type, value) VALUES ('REMOVE_KEYS_AFTER_PROVISIONING', 'FEATURE', 'DISABLED');


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
VALUES (-1,'exacsminspec','domU','-1','kvm','filesystem','/var/log/audit','3G','','','','','','','true','all','false');
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

-- EXACOMPUTE 19c
INSERT INTO ecs_gold_specs(exaunit_id,type,target_machine,target_machine_name,network_communication,validation_type,name,expected,current_value,command,arguments,expected_return_code,current_return_code,result,mandatory,model)
VALUES (-1,'exacsexacompute19c','domU','-1','kvm','filesystem','/u01','80G','','','','','','','false','all');

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


UPDATE ecs_properties SET value='DISABLED' WHERE name='FAIL_CS_ON_POST_CHECK_ERROR';

INSERT INTO ecs_scheduledjob (job_class, enabled, interval, last_update_by,type) VALUES ('oracle.exadata.ecra.cloudservices.atp.parurlrotation.ParUrlRotationJob', 'Y', 86400, 'Init', 'RECURRENT');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_FP_BUCKET', 'ATP_FP', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('ATP_FP_COMPARTMENT_OCID', 'ATP_FP', '');

-- Used by EcraHeartbeat
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_HEARTBEAT_TIMEOUT', 'ECRA', '150');
INSERT INTO ecs_properties (name, type, value) VALUES ('FAILOVER_SCHEDULEDJOBS', 'ECRA', '0');
INSERT INTO ecs_properties (name, type, value) VALUES ('RESTORE_SCHEDULEDJOBS_SECONDS', 'ECRA', '1800');

-- Weblogic admin port and host
INSERT INTO ecs_properties (name, type, value) VALUES ('WEBLOGIC_HOST_URL', 'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('WEBLOGIC_CONSOLE_PORT', 'FEATURE', '');

-- for Mock Error implementation.
INSERT INTO ecs_properties (name, type, value) VALUES ('MOCK_ERROR', 'EXACLOUD', 'False');

INSERT INTO ecs_properties (name, type, value) VALUES ('MOCK_ERROR_ACTION', 'EXACLOUD', 'FAIL_AND_SHOW');

--cps sw retry count
INSERT INTO ecs_properties (name, type, value) VALUES ('CPS_SW_RETRY_COUNT', 'EXACLOUD', '60');
-- Instance Principals
INSERT INTO ecs_properties (name, type, value) VALUES ('ENABLE_INSTANCE_PRINCIPALS', 'FEATURE', 'DISABLED');

--asynvc api version
INSERT INTO ecs_properties (name, type, value) VALUES ('ASYNC-API-VERSION', 'ECRA', 'v2');
COMMIT;

-- Enh 34096543 Add property to fail ecra upgrade if a property is modified
INSERT INTO ecs_properties (name, type, value) VALUES ('MODIFIED_PROPERTIES_FAIL_UPGRADE', 'ECRA', 'ENABLED');
--network reconfigure properties.
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE', 'FEATURE', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE_NW_TYPES', 'EXACC_NETWORK', 'backup');
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE_NW_OPERATIONS', 'EXACC_NETWORK', 'cidr_update,vlan_update');
INSERT INTO ecs_properties (name, type, value) VALUES ('NETWORK_RECONFIGURE_NW_SERVICES', 'EXACC_NETWORK', NULL);

-- Enh-34009623
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_EXACC_DATAPLANE_BUCKET_NAME', 'ECRA', 'bucket_dataplane_log_upload'); 

-- Enh 34358535 asmss support
insert into ecs_properties (name, type, value) values ('ASMSS_FEATURE', 'FEATURE', 'ENABLED'); 

-- Bug 34228488 infra relaxed version support
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_DELTA_FOR_RELAXED_VERSION', 'ELASTICSHAPE', '2.0.0'); 

-- Bug 34458050: Add support for V1 api along with V2 api for CPS SW upgrade
INSERT INTO ecs_properties (name, type, value) VALUES ('CPSSW_UPGRADE_VERSION', 'EXACLOUD', 'V2');

-- Bug 35069021: Add support for V1 api along with V2 api for CPS OS upgrade
INSERT INTO ecs_properties (name, type, value) VALUES ('CPSOS_UPGRADE_VERSION', 'EXACLOUD', 'V2');

-- Bug 35677516: Increase timeout for ongoing operations
INSERT INTO ecs_properties (name, type, value) VALUES ('SWITCHOVER_MAX_WAIT_INTERVAL', 'ECRA', '80');

-- Bug 34543297: Add config prop for retry count and sleep interval for ecra exacloud calls
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_RETRY_COUNT', 'EXACLOUD', '20'); 
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACLOUD_DEFAULT_WAIT_TIME_IN_MILLIS', 'EXACLOUD', '5000'); 

--Bug 34712586: Support DRCC-Include realm domains as a part of ocpsSetup json
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_INSTANCE_IAASINFO_URL', 'EXACLOUD', 'http://169.254.169.254/opc/v2/iaasInfo'); 

-- Enh 34394111 - Adding admin and user values for user management ecra ng
INSERT INTO ecs_users_roles (id, role) VALUES (1, 'ADMINISTRATOR');
INSERT INTO ecs_users_roles (id, role) VALUES (2, 'APPLICATION_USER');

-- Enh 34710874 ECRA SLA SLO Metric Collection
INSERT INTO ecs_properties(name, type, value) VALUES ('OCI_EXACC_ECRA_SLA_FREQUENCY_MINS', 'INT', '60');
INSERT INTO ecs_properties(name, type, value) VALUES ('OCI_EXACC_EXAMON_TENANT_OCID', 'EXACC', null);
INSERT INTO ecs_scheduledjob(job_class, enabled, interval, last_update_by, type, target_server) VALUES ('oracle.exadata.ecra.scheduler.ECRASlaSloMetricJob', 'Y', '3600', 'Init', 'RECURRENT', 'STANDBY'); 

-- Enh 34394111 - Adding default admin user
INSERT INTO ecs_users (id, user_id, first_name, last_name, password, active, role_id) VALUES (1, 'admin', 'admin', 'admin', 'afda4f4abe00a4a62227776052fffe7a73f7b6f771ecbc14820930cfbd007b73', 1, '1,2');

INSERT INTO ecs_properties (name, type, value) VALUES ('RUNNER_TIMEOUT', 'ECRA', '10');

-- Enh 34792757 - Serial Console feature properties
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_HISTORY_CONSOLES_CC', 'ECRA', '10000');
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_HISTORY_CONSOLES', 'ECRA', '100');
INSERT INTO ecs_properties (name, type, value) VALUES ('CONSOLE_HISTORY_OSS_NAMESPACE', 'ECRA', 'FILLED_BY_ECRA');
INSERT INTO ecs_properties (name, type, value) VALUES ('CONSOLE_HISTORY_OSS_BUCKETNAME', 'ECRA', 'vm_history_console');

-- EXACS-91468 Add Node(cell, compute) availability threshold for ingestion filtering
INSERT INTO ecs_properties (name, type, value) VALUES ('CELL_THRESHOLD', 'INGESTION', 90);
INSERT INTO ecs_properties (name, type, value) VALUES ('COMPUTE_THRESHOLD', 'INGESTION', 90);

-- EXACS-125310 - QFAB reservation for expansion in highly utilized QFABs
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X8M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X8M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X9M-COMPUTE nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD', 'INGESTION', 90, 'Threshold(percentage) utilization above which X9M-CELL nodes in the QFAB will be reserved for elastic expansion only');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS', 'ELASTIC', 'DISABLED', 'Enable/Disable QFAB reservation of X8M nodes for elastic expansion once the utilization goes above threshold');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('X9M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS', 'ELASTIC', 'DISABLED', 'Enable/Disable QFAB reservation of X9M nodes for elastic expansion once the utilization goes above threshold');


-- Bug 34932304 - Adding more time to exacloud connection timeout
INSERT INTO ecs_properties (name, type, value) VALUES ('CONNECT_REQ_TIMEOUT_MILLIS', 'EXACLOUD', '120000');
INSERT INTO ecs_properties (name, type, value) VALUES ('CONNECT_TIMEOUT_MILLIS',     'EXACLOUD', '120000');
INSERT INTO ecs_properties (name, type, value) VALUES ('SOCKET_TIMEOUT_MILLIS',      'EXACLOUD', '180000');

-- Bug 35414915 - json logging
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_LOG_FORMAT', 'ECRA', 'json');

MERGE INTO ecs_registries
USING
    (SELECT 1 "one" FROM dual) 
ON
    (ecs_registries.RACK_ID= 'ceirack' and ecs_registries.request_id='3deb041b-275d-4ad9-8267-23ec18bdd705' and ecs_registries.operation='cei-creation') 
WHEN NOT matched THEN
INSERT (rack_id, request_id, operation)
VALUES ('ceirack', '3deb041b-275d-4ad9-8267-23ec18bdd705', 'cei-creation');

-- Enh 36710874 - Seed data in state_lock_data
MERGE INTO state_lock_data
USING
    (SELECT 1 "one" FROM dual)
ON
    (state_lock_data.LOCK_STATE='FREE' or state_lock_data.LOCK_STATE='LOCKED')
WHEN NOT matched THEN
INSERT (LOCK_STATE, LOCK_HANDLE, STATE_HANDLE, LOCK_ACQUIRED_TIME)
VALUES ('FREE', 1, 0, '');

--ENH 34921831 - ECRA UPGRADE AND EBR FLOW (INCLUDES DEPLOYER , APPLICATION AND DATABASE CHANGES)
INSERT INTO ecs_properties (name, type, value) VALUES ('SERVER_SWITCHOVER_NAME', 'ECRA_RESILIENCE', '');

INSERT INTO ecs_properties (name, type, value) VALUES ('TLS_CA_BUNDLE_PATH', 'VMCONSOLE', '');

update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=900 where MODEL='X10M-2' and RACKSIZE='ELASTIC_EIGHTH';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='ELASTIC';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='LARGE';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='EXTRALARGE';
update ECS_OH_SPACE_RULE SET USEABLEOHSPACEINGB=2243 where MODEL='X10M-2' and RACKSIZE='ALL';

-- EXACS-104356 - Add CreateGoldImageBackup support
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_OSS_BACKUP', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_LOCAL_BACKUP', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_GOLD_BACKUP', 'ECRA', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_BACKUP_SUCONFIG_TENANCY_OCID', 'ECRA', NULL);
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_BACKUP_WAITTIME_BATCHES', 'ECRA', '120');

--Enh 35126723
INSERT INTO ecs_properties (name, type, value) VALUES ('MVM_DISCOVER_IP','MVM', 'DISABLED');
--Enh 35241763
UPDATE ecs_properties SET value = replace(value, 'X6-2,', '') WHERE name='BASE_SYSTEM_MODELS';

--Enh 35177584
UPDATE ecs_properties SET value='X9M-2,X10M-2,X11M' WHERE name='PURE_ELASTIC_MODELS';

--Enh 35064034
--Enh 35388181  
UPDATE ecs_properties SET value = '2,3,5,6,7,11,12' WHERE name = 'ONSR_REALMS';

--Enh 35370235
UPDATE ecs_hw_nodes SET model_subtype = 'STANDARD' where model_subtype = 'STOCK' or model_subtype is null;

UPDATE ecs_properties SET value='ENABLED' WHERE name='BASESYSTEM_USE_BONDING_INPUT';

-- Bug 36369842 - Update exacloud retry count value
UPDATE ecs_properties SET value='5' WHERE name='EXACLOUD_RETRY_COUNT';

-- ENh 35425757 - Default to DISABLED, Otherwise put the OCID for the COMPARMENT_ID in this property
INSERT INTO ecs_properties (name, type, value) VALUES ('OCI_OVERRIDES_COMPARTMENT_ID','OCI', 'DISABLED');

INSERT INTO ecs_properties (name, type, value) VALUES ('POWERMOCK_MODE','ECRA', 'false');

INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_FS_MOUNTPOINT_SIZE', 'ECRA', '900');

-- Enh 35602217 - CREATE PROPERTY GENERAL AND PER TENANT FOR DOMU OS VERSION
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_IMAGE_OVERRIDE_FOR_GI23', 'FEATURE', 'ENABLED');

PROMPT Inserting new properties for DOMU FINAL OVERRIDE ON PROVISIONING
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_VERSION_OVERRIDE_EXACS', 'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, TYPE, value) VALUES ('DOMU_VERSION_OVERRIDE_ATP', 'FEATURE', 'DISABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_FINAL_VERSION_OVERRIDING_ATP', 'FEATURE', '');
INSERT INTO ecs_properties (name, type, value) VALUES ('DOMU_FINAL_VERSION_OVERRIDING_EXACS', 'FEATURE', '');

PROMPT Removing old DOMU override properties
DELETE FROM ecs_properties where name = 'DOMU_OS_VERSION_OVERRIDE';
DELETE FROM ecs_properties where name = 'DOMU_OS_VERSION_OVERRIDING_EXACS';



-- Bug 35402924 - Adding values to compatibility matrix table
INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
('ol8', '23.1', 'BASE,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,21,19', 'EXACS', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
('ol7', '22.1', 'BASE,X9M-2,X8M-2,X8-2,X7-2', '21,19', 'EXACS,ATP', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
('ol8', '24.1', 'BASE,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,19', 'EXACS', 'ENABLED');
INSERT INTO ECS_EXA_VER_MATRIX (os_version, exa_version, hw_model, gi_version, service_type, status) VALUES
('ol8', '25.1', 'BASE,X11M,X10M-2XL,X10M-2L,X10M-2,X9M-2,X8M-2,X8-2,X7-2', '23,19', 'EXACS', 'ENABLED');

-- AutoUndoRetry Rule for Provisioning
INSERT INTO ecs_wf_auto_retry_action_rule (wfname, taskname, errorcode, action) VALUES
('create-service-wfd', 'all', 'all', 'AutoUndoAndRetry');
-- AutoUndoRetry Rule for Provisioning
INSERT INTO ecs_wf_auto_retry_action_rule (wfname, taskname, errorcode, action) VALUES
('vm-move-wfd', 'all', 'all', 'AutoUndoAndRetry');

-- AutoUndoRetry Rule for Reshape
INSERT INTO ecs_wf_auto_retry_action_rule (wfname, taskname, errorcode, action) VALUES 
('reshape-service-wfd', 'all', 'all', 'AutoUndoAndRetry');

-- AutoUndoRetry Rule for Delete Service
INSERT INTO ecs_wf_auto_retry_action_rule (wfname, taskname, errorcode, action) VALUES 
('delete-service-wfd', 'all', 'all', 'AutoUndoAndRetry');

-- AutoUndoRetry Rule for Vault Access Creation 
INSERT INTO ecs_wf_auto_retry_action_rule (wfname, taskname, errorcode, action) VALUES 
('exacompute-vaultaccessupdate-wfd', 'all', 'all', 'AutoUndoAndRetry');

INSERT INTO ecs_properties (name, type, value) VALUES ('CEI_SKIP_SERASE','FEATURE', 'false');

--Enh 34764008 - Will be initialized by LogSearchUrlGenerator.java at runtime
INSERT INTO ecs_properties (name, type, value) VALUES ('LUMBERJACK_INFO', 'DIAG', 'N/A');

-- Bug 34538859 - Adding Metric types for exacc sla
INSERT INTO ecs_metric_type(metric_type_id, name, description, sla_impact) VALUES ('2', 'Exadata.Cell.Uptime', 'Cell uptime', 'TRUE');
INSERT INTO ecs_metric_type(metric_type_id, name, description, sla_impact) VALUES ('3', 'Exadata.Dom0.Uptime', 'Dom0 uptime', 'TRUE');
INSERT INTO ecs_metric_type(metric_type_id, name, description, sla_impact) VALUES ('4', 'Exadata.Cell.Status', 'Cell Status', 'TRUE');

INSERT INTO ecs_properties (name, type, value) VALUES ('STATE_STORE_TIMEOUT', 'ECRA', '300000');

--Enh 35651071
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_FILES_ONSTART_DELETE_OLDERTHAN', 'ECRA', '1Y');

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

-- Bug 36080194 - Active-active Phase 2a ,Enable autoretry property
UPDATE ecs_properties SET value = 'ENABLED' WHERE name = 'ECRA_TASK_FAILURE_AUTORETRY';

-- Bug 35677356 - Custom GI support
INSERT INTO ecs_properties (name, type, value) VALUES ('CUSTOM_GI','FEATURE', 'DISABLED');

-- Bug 35859903 - Removing null values for Fault Domain columns
UPDATE ecs_hw_cabinets SET FAULT_DOMAIN = 'NULL' WHERE FAULT_DOMAIN IS NULL;
UPDATE ECS_HW_CABINETS SET RESTRICTED_SITEGROUP = 'N' WHERE RESTRICTED_SITEGROUP IS NULL;

INSERT INTO ecs_properties (name, type, value) VALUES ('DELETE_PREPROV_RESOURCES_ON_DS', 'PREPROVISION', 'ENABLED');

-- BUG 36096298 - Adding property for VM Deconfigure for preprov
INSERT INTO ecs_properties (name, type, value) VALUES ('PREPROVISION_DECONFIG_WORKFLOW', 'PREPROV', 'create-service-wfd');

-- Bug 35859903 - Adding FAULT_DOMAIN property
INSERT INTO ecs_properties (name, type, value) VALUES ('FAULT_DOMAIN', 'FEATURE', 'DISABLED');

-- Enh 35769747 - GoldVM Backup async operation properties 
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_GOLD_BACKUP_RETRIES','ECRA', '3');
INSERT INTO ecs_properties (name, type, value) VALUES ('VM_GOLD_BACKUP_RETRY_TIMEOUT_SECONDS','ECRA', '1800');


-- Bug 35792183 - Model Subtype Limits for X10M-2 and X9M-2
INSERT INTO ecs_properties (name, type, value) VALUES ('LIMIT_PER_CABINET_EXTRALARGE_X10M', 'ELASTIC', '5');
INSERT INTO ecs_properties (name, type, value) VALUES ('LIMIT_PER_CABINET_LARGE_X10M', 'ELASTIC', '-1');
INSERT INTO ecs_properties (name, type, value) VALUES ('LIMIT_PER_CABINET_LARGE_X9M', 'ELASTIC', '5');

-- Enh 36908403 - Model Subtype Limits for X11M
INSERT INTO ecs_properties (name, type, value, description) VALUES ('LIMIT_PER_CABINET_EXTRALARGE_X11M', 'ELASTIC', '5', 'This defines the max nodes with ExtraLarge configuration that each cabinet can have, a -1 means no limit');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('LIMIT_PER_CABINET_LARGE_X11M', 'ELASTIC', '-1', 'This defines the max nodes with Large configuration that each cabinet can have, a -1 means no limit');

--Bug 35923119 - Multiple exaversion in catalog
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_EXAVERSION_CATALOG','ELASTIC', '10'); 

-- Bug 35951076 - FS Encryption flag for EXACC
INSERT INTO ecs_properties (name, type, value) VALUES ('FS_ENCRYPTION','ECRA', 'DISABLED');

--FEDRAMP
INSERT INTO ecs_properties (name, type, value) VALUES ('CPS_CERT_ROTATE_PATH', 'FEATURE', '/tmp/cert');


-- Enh 35990354 - Adding custom linux uid/gid feature
INSERT INTO ecs_properties (name, type, value) VALUES ('CUSTOM_UID_GID', 'FEATURE', 'DISABLED');

-- ExaCS Topology
INSERT INTO ecs_properties (name, type, value) VALUES ('TOPOLOGY_OSS_NAMESPACE', 'TOPOLOGY', 'exadata');

-- Node Recovery SOP recover from backup
INSERT INTO ecs_properties (name, type, value) VALUES ('NODE_RECOVERY_SOP_FROM_BACKUP', 'SOP', 'true');

-- Enh 36212504 - ECRA ANALYTICS - Make sure old records are being removed from ecs_analytics
INSERT INTO ecs_properties (name, type, value) VALUES ('ANALYTICS_KEEP_RECORDS_DAYS', 'ANALYTICS', '300');

INSERT INTO ecs_properties (name, type, value) VALUES ('SERVERNAME_INIT_VALIDATION', 'ECRA', 'DISABLED');

-- Enh 36390893 - Change limit oh for exacompute 
INSERT INTO ecs_properties (name, type, value) VALUES ('MAX_OH_GB_PER_NODE_EXACOMPUTE',  'EXACOMPUTE', '2000');

-- Enh 36529231 - Change limit oh for ocpu to ecpu ratio 
INSERT INTO ecs_properties (name, type, value) VALUES ('OCPU_ECPU_RATIO','FEATURE', '4');

-- Bug 36545094 - Introduce VM status sync job
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACC_VMSTATUS_SYNC','EXACC', 'ENABLED');

-- Enh 36340464 - Active-active, ip rules for multiple ECRAs. Expected values CIDR,HOSTNAME
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_SERVERS_INFO_FORMAT', 'ECRA', 'CIDR');

- Enh 36627653 - Add properties for XS Vault details sync scheduler
INSERT INTO ecs_properties (name, type, value) VALUES ('JOB_COUNT_FOR_VAULTS_SYNC','ECRA', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('XSVAULT_DETAILS_UPDATE_TIMEOUT_SECONDS','ECRA', '12');

-- Enh 36842063 - Add minimum storage for XS clu creation
INSERT INTO ecs_properties (name, type, value) VALUES ('MIN_STORAGEGB_FOR_CLU_CREATION','ECRA', '2048');

-- Bug 36628793 - Update some properties description
UPDATE ecs_properties SET description='Number of retries for exacloud calls' WHERE name='EXACLOUD_RETRY_COUNT';
UPDATE ecs_properties SET description='Number of days to keep records in analytics table' WHERE name='ANALYTICS_KEEP_RECORDS_DAYS';
UPDATE ecs_properties SET description='Comma split models to be used in base system provisions. Ex: X8M-2,X9M-2,X10M-2' WHERE name='BASE_SYSTEM_MODELS';
UPDATE ecs_properties SET description='Property to enable/disable file system feature, if disabled, 443GB default file system will be in place for new clusters, if enabled, 184GB.', VALUE='ENABLED' WHERE name='FILESYSTEM_FEATURE';

-- EBug 36742283 - Add extra server information for routing rules
INSERT INTO ecs_properties (name, type, value) VALUES ('EXTRA_NATWHITELIST_ENTRIES','ECRA', '');

-- EXACS-138437 Ecra to support extended cluster vlan
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXTENDED_CLUSTER_ID', 'ECRA', 'DISABLED', 'Enable/Disable extended cluster id for vlan allocation');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXTENDED_CLUSTER_ID_MIN_SW_VER', 'ECRA', '24.1.0', 'Minimum software version supporting extended cluster id, first three numbers');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('SKIP_ATTACHSTORAGE_PRECHECK', 'FEATURE', 'DISABLED', 'Skip the precheck task in the ExaCS/ADBS attach storage workflows');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('SKIP_DELETESTORAGE_PRECHECK', 'FEATURE', 'DISABLED', 'Skip the precheck task in the DELETE_ELASTIC_CELL_WFD workflow');

-- Enh 36906964 - Automating secure erase certificate upload to oss
INSERT INTO ecs_properties (name, type, value, description) VALUES ('SECURE_ERASE_OCI_BUCKET_NAME', 'FEATURE', 'DISABLED', 'Bucket name used to store certificates of secure erase operation');

-- Enh 36383801 - Adding config for ecs_lse_log table. Enabling this config will let ecra know to save log details to ecs_lse_log table. Default is False. Set it to enable in case of LSE only.
INSERT INTO ecs_properties (name, type, value) VALUES('ENABLE_LSE_LOG', 'EXACC', 'FALSE'); 

INSERT INTO ecs_properties (name, type, value, description) VALUES ('CEI_SKIP_SWVERSION_CHECK', 'FEATURE', 'DISABLED', 'Skip the sw_version check during CEI creation');

-- Enh 37159566 - Adding vmbackup history
INSERT INTO ecs_properties (name, type, value, description) VALUES ('VM_SCHEDULER_MAX_RETRIES', 'ECRA', '6', 'Sets the maximum retries that the scheduler uses to fail a backup');
INSERT INTO ecs_properties (name, type, value, description) VALUES ('VM_SCHEDULER_MAX_RETRY_HOURS', 'ECRA', '12', 'Sets the maximum hours that the scheduler uses to fail a backup');

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

--Enh 37243715 - ECRA X11M - ECRA Should disable delete bonding for non eht0 nodes only
INSERT INTO ecs_properties (name, type, value, description) VALUES ('DELETE_BONDING_FOR_NON_ETH0','BONDING', 'DISABLED', 'This property enable/disable delete bonding for non-eth0 nodes');

-- Enh 36979503 - Saving systemvault into ecra archive
INSERT INTO ecs_properties (name, type, value, description) VALUES ('ECRA_ARCHIVE_DEFAULT_RETENTION_DAYS', 'ECRA', '182', 'Number of days to have this metadata in the table after that it will be removed');

-- Enh 37326852 - Add FS exacompute support
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_SYSTEM_VOLUME_GB', 'EXACOMPUTE', '114');
INSERT INTO ecs_properties (name, type, value) VALUES ('EXACOMPUTE_MAX_SIZE_VM_GB', 'EXACOMPUTE', '1100');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('MINIMUM_CELLS_FOR_SPARSE', 'ELASTIC', '5', 'The minimum ammount of cells that should remain for sparse clusters after delete storage flow');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXACLOUD_DEFAULT_BASE_WAIT_TIME_PER_CYCLE_MILLIS', 'ECRA', '1000', 'Total wait time in milliseconds to be added to exponential backoff for exacloud calls used in between wait cycles');

-- Bug 37106813 - OCI-EXACC: [FEDRAMP]ECRA TO HAVE MECHANISM TO ROTATE ITS LISTENER CERTIFICATE
INSERT INTO ecs_properties (name, type, value) VALUES ('ECRA_SSV2_CERT_PATH', 'ECRA', '');

INSERT INTO ecs_properties (name, type, value) VALUES ('INFRA_ACTIVATION_WF', 'EXACC', 'false');

INSERT INTO ecs_properties (name, type, value, description) VALUES ('EXACOMPUTE_USE_69_TO_FETCH_CABINETS', 'EXACOMPUTE', 'ENABLED', 'Enable to look for computes in 6x9 cabinets for exacompute');

--Enh 37675147 - Adding brancher for ImageBaseProvisioning
INSERT INTO ecs_properties (name, type, value, description)
VALUES ('FORCE_GOLD_IMAGE_PROVISIONING', 'EXACOMPUTE', 'FALSE', 'FORCE GOLD IMAGE PROVISIOING FLAG AS IT WILL REPLACE PostVMInstall, CreateUser, ExaScaleComplete for GoldComplete task in CS WF');

-- BUG 38173167 --  DBCS WALLETS GET OUT OF SYNC DURING THE ROTATION
INSERT INTO ecs_properties (name, type, value, description) VALUES ('SCHEDULE_DBCS_PASSWORD_ROTATION', 'ECRA', 'ENABLED', 'Enable the schedule password rotation for the dbcs users, every 90 days');


COMMIT;

