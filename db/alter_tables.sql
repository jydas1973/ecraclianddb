Rem
Rem alter_tables.sql
Rem
Rem Copyright (c) 2017, 2025, Oracle and/or its affiliates.
Rem All rights reserved.
Rem
Rem    NAME
Rem      alter_tables.sql - All the modifictions to the existing tables and
Rem      indexes are done through this script.
Rem      ecs/ecra/db/install_ecra_schema.sql calls this script
Rem
Rem    DESCRIPTION
Rem      This file is created as part of the ECRA schema hardening effort.
Rem      For more details refer to the file ecs/ecra/db/install_ecra_schema.sql
Rem
Rem    NOTES
Rem      Following are big NO NO in this file
Rem      1. No DDL should start with CREATE.
Rem      2. No DDLs other than ALTER TABLE or ALTER INDEX allowed.
Rem      3. No DDL should start with DROP.
Rem      4. No DMLs like INSER, DELETE, UPDATE are allowed.
Rem
Rem      Following things are allowed
Rem      1. alter table/index add
Rem      2. alter table/index drop
Rem      3. alter table/index modify
Rem      4. alter table/index rename
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/alter_tables.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    gvalderr    11/14/25 - Bug 38652293 - Eliminating exaunit details
Rem                           storage constraint
Rem    jvaldovi    06/19/25 - Enh 37985641 - Exacs Ecra - Ecra To Configure
Rem                           Dbaas Tools Name Rpm Basd On Cloud Vendor
Rem    rgmurali    04/30/25 - Enh 37837172 - Change the range for extended
Rem                           clusterid
Rem    anudatta    04/18/25 - bug 37831640 - fixing regression from site_groups addition 
Rem    illamas     03/24/25 - Enh 37740901 - 19c support for exadbxs
Rem    jzandate    03/18/25 - Enh 37525577 - Adding CONFIGURED_FEATURES to site
Rem                           groups
Rem    jzandate    02/28/25 - Bug 37651695 - Add missing column on alter tables
Rem    illamas     01/30/25 - Enh 37508426 - Store more values in CS exacompute
Rem    jvaldovi    01/15/25 - Enh 37477523 - Exacs Sitegroup - Include Mtu
Rem                           Config Per Site Group
Rem    llmartin    10/25/24 - Enh 37193905 - Encrypt PUBLIC_KEY column in
Rem                           ECS_DOMUKEYSINFO table
Rem    caborbon    10/21/24 - ENH 37179993 - Adding new oeda codename field
Rem                           in ecs_platform_info to store the modelsubtype name for OEDA
Rem    jvaldovi    10/17/24 - Enh 37181642 - Add Cloud_Provider_Az And
Rem                           Cloud_Provider_Building To Site Groups Table In
Rem                           Ecra
Rem    caborbon    10/16/24 - ENH 37154198 - Changing model subtype from Z to
Rem                           X-Z
Rem    pverma      10/15/24 - Add VAULT_ECRA_ID column to
Rem                           ecs_exascale_vaults_table
Rem    gvalderr    10/11/24 - Enh 37126647 - Adding correction to statements on
Rem    zpallare    10/09/24 - Enh 37025371 - EXACC X11M Support for compute
Rem                           standard/large and extra large
Rem    rgmurali    10/07/24 - Enh 37144818 - isPlacementDisabled support in system-vault  
Rem    caborbon    10/02/24 - ENH 37102944 - Adding new cluster size constraint
Rem                           needed for X11M generation in ecs_hw_nodes
Rem    kukrakes    09/30/24 - Bug 37117708 - LISTALIASES API AFTER SUCCESSFUL
Rem                           MOUNT IS NOT WORKING [EXACOMCP-3476]
Rem    zpallare    09/26/24 - Bug 37107444 - EXACS:24.4.1:CEI creation failing
Rem                           at elasticshapeceicapacity:ora-00904:
Rem                           x9m_elastic_reservation_for_high_util_qfabs:
Rem                           invalid identifier
Rem    zpallare    09/23/24 - Enh 36922155 - EXACS X11M - Base system support
Rem    caborbon    09/21/24 - ENH 37029692 - Updating the constraints values
Rem                           for cell & computes subtypes in ecs_ceidetails
Rem    nitishgu    09/20/24 - BUG: 37071966 Remove Bit vector for EXTENDED
Rem                           CLUSTER ID
Rem    caborbon    09/18/24 - ENH 37071580 - Adding nee fields to
Rem                           ecs_ceidetails for node subtype
Rem    essharm     09/17/24 - Bug 37070289 - RENAME ATTRIBUTE NEWDEV TO
Rem                           DEVELOPER
Rem    nitishgu    09/12/24 - 36991882 - ECRA TO SUPPORT EXTENDED CLUSTER VLAN
Rem    bshenoy     09/05/24 - Bug 37023096: Add column private_key_content to
Rem                           table ecs_atpadminidentity
Rem    gvalderr    08/28/24 - Enh 37001368 - change the TARGET_URI field sized
Rem                           to 512 on the ECS_REQUESTS table
Rem    zpallare    08/21/24 - Enh 34972266 - EXACS Compatibility - create new
Rem                           tables to support compatibility on operations
Rem    luperalt    08/20/24 - Bug 36965316 Drop constraint fk_exascale_id
Rem    caborbon    08/12/24 - ENH 36931770 - Adding new field in ecs_hardware
Rem                           for ecpu feature on X11
Rem    jzandate    08/07/24 - Enh 36904134 - Saving results for secure erase wf
Rem    jvaldovi    07/26/24 - Enh 36858584 - Ecra: Multicloud: Add Site Group
Rem                           Data To Ecra
Rem    luperalt    07/03/24 - Bug 36754210 Added vnic id column to
Rem                           ecs_hw_cabinets
Rem    abysebas    07/03/24 - Bug 36800736 - IPV6 - DUAL STACK SUPPORT FOR
Rem                           CLIENT AND BACKUP
Rem    jzandate    07/01/24 - Enh 36197323 - Adding new columns for network
Rem                           type and support status
Rem    essharm     06/26/24 - Enh 36755078 - Add Col to Support for
Rem                           NEWDEV/REGULAR CLUSTER TYPE
Rem    abysebas    06/13/24 - BUG 36708304 - ECRA IPV6 FLOW - UPDATE YAML AND
Rem                           REMOVE IPV6 FROM CLIENT/BACKUP
Rem    sdevasek    06/12/24 - Bug 36696921 - UPDATE ERROR_MSG COL TO HAVE 4000
Rem                           LENGTH IN ECS_EXA_APPLIED_PATCHES_TABLE TO CATER
Rem                           MADDERROR ERROR MESG SUGGESTION STRING
Rem    llmartin    06/06/24 - Bug 36702018 - Fix ecs_v_mvm_computes creation
Rem    luperalt    05/28/24 - Bug 36197980 - Added last_password_rotation
Rem                           to ecs_oci_exa_info table
Rem    gvalderr    05/24/24 - Enh 36334590 - Adding column ECS_HW_CABINET to
Rem                           determine if a cabinet is dedicated or shared
Rem    zpallare    05/24/24 - Enh 36628793 - ECRA EXACS - Add property
Rem                           description column for new properties
Rem    pverma      05/20/24 - Exascale related changes
Rem    jyotdas     05/08/24 - Enh 36506201 - infrapatching tool to update
Rem                           exasplice version on ecs_hw_nodes table
Rem    jreyesm     05/07/24 - Bug 36592675. Incorrect default on
Rem                           restrited_sitegroup
Rem    caborbon    05/03/24 - Bug 36576562 - Adding new field to cloudvnuma
Rem                           table for early adopter feature
Rem    gvalderr    04/22/24 - Enh 36494348 - adding extra columns for keys on
Rem                           system_vault_table
Rem    cgarud      04/17/24 - EXACS-125310 - QFAB blocking for highly utilized
Rem                           fabrics
Rem    abysebas    04/12/24 - Enh 36495315 - ECRA IPV6 SUPPORT - PROVISIONING
Rem                           FLOW
Rem    zpallare    04/09/24 - Bug 36218977 - EXACS: Validate resources using
Rem                           views instead of json node_wise_allocations
Rem    kukrakes    04/05/24 - Bug 36484203 - PLAN COLUMN WAS VARCHAR2(4000) AND
Rem                           NOT A CLOB
Rem    jiacpeng    03/29/24 - exacs-129303: change VMCLUSER_NAMES to
Rem                           VARCHAR2(4000) to support 64 vms per compute
Rem    gvalderr    03/27/24 - Enh 36361990 - Adding new field env for ecs
Rem                           ohhomerules
Rem    jzandate    03/21/24 - Enh 36405281 - Adding new column to hold image
Rem                           version and code to update it for a given cluster
Rem    illamas     03/11/24 - Enh 36380665 - Change node state for vm move
Rem    jyotdas     02/21/24 - Bug 36228424 - ECRA infra patch registration to
Rem                           support rack model
Rem    zpallare    02/20/24 - Enh 36034772 - EXACS: Keep records of deleted
Rem                           clusters in ecra
Rem    jzandate    01/25/24 - Enh 36096298 - Adding deconfigure flag for create
Rem                           service execution
Rem    zpallare    01/22/24 - Enh 36165741 - EXACS: After termination of cei,
Rem                           elastic shape nodes needs to be patched to latest
Rem                           exadata version
Rem    kukrakes    01/22/24 - Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA
Rem                           OPERATIONS FAILING POST PARTITIONING AND
Rem                           ARCHIVING OF TABLES
Rem    bshenoy     01/09/24 - Add rack serial number to ecs_oci_exa_info
Rem    gvalderr    01/03/24 - Enh 36117657 - Correcting instructions for
Rem                           ecs_elastic_platform_info
Rem    jyotdas     12/22/23 - Bug 36024518 - QMR failing for HA check when vm
Rem                           cluster was stopped by customer before patching
Rem    essharm     12/19/23 - Bug 36122803 - EXACC:MAIN:SRG:PREACTIVATION
Rem                           FAILED WITH
Rem                           EXCEPTION:JAVA.SQL.SQLSYNTAXERROREXCEPTION:
Rem                           ORA-00904:"START_TIME_TS": INVALID IDENTIFIER
Rem    cgarud      12/14/23 - 36086852 - UNDO EXACS-114176 CHANGES - Causes
Rem                           compose cluster failure due to change in default
Rem                           node_state from FREE to UNDER_INGESTION
Rem    kukrakes    12/11/23 - Enhancement Request 36070977 - ECRA APPLICATION
Rem                           CHANGES TO IMPLEMENT PARTITIONING IN ECRA SCHEMA
Rem    llmartin    12/07/23 - Bug 36023027 - Fix zone lenght
Rem    jvaldovi    12/06/23 - Enh 35914352 - ECRA INDIGO - MODIFY CAPACITY
Rem                           ALGORITHMS FOR SITE GROUP
Rem    hcheon      11/29/23 - 35572548 Created indexes for wf_uuid
Rem    caborbon    11/21/23 - Bug 35990354 - Adding new field to save the
Rem                           custom linux uid/gid value
Rem    jreyesm     11/23/23 - Enh 35999428. Add file system config.
Rem    oespinos    11/21/23 - Bug 35999841 - Alter ExaCC sla metrics table
Rem    essharm     11/09/23 - Bug 35941946 - Adding ON DELETE CASCADE clause
Rem    ddelgadi    11/14/23 - Enh 35756274 - Modify ECS_AD_LOCATIONS
Rem    caborbon    11/02/23 - Bug 33779609 - Adding new field 'env' for
Rem                           ecs_hardware and a new view named 
Rem                           ecs_hardware_filtered
Rem    caborbon    10/25/23 - Bug 35938508 - Modifying ecs_hw_nodes ->
Rem                           model_subtype to have a default on null value
Rem    zpallare    10/25/23 - Enh 35823610 - Adding rackname column to
Rem                           ecs_oci_vnics
Rem    gvalderr    10/19/23 - Enh 35945349 - Adding min value for filesystem
Rem                           constraint
Rem    essharm     10/18/23 - BUG 35858470 - EXACC: SLA REPORT: CHANGE TYPE OF
Rem                           V ALUE FIELD IN ECS_CLUSTER_METRICS TO NUMBER AND
Rem                           STORE UPTIME AND CELLSRV STATUS (AS 1 OR 0)
Rem    gvalderr    10/16/23 - Enh 35870618 - Adding num_servers column to
Rem                           ecs_elastic_platform_info table
Rem    gvalderr    10/11/23 - Enh 35875930 - Adding exaccsvm type to golspecs
Rem    jvaldovi    10/10/23 - Enh 35892155 - Ecra Indigo - Create Backfilling
Rem                           Apis To Populate Indigo Data
Rem    oespinos    10/05/23 - 35838202 ADD JOIN TABLE BETWEEN ECS_SLA_HOST AND
Rem                           ECS_SLA_INFO
Rem    piyushsi    10/05/23 - BUG 35862125 Updating totalcores and memory
Rem    jzandate    10/03/23 - Enh 35769747 - Adding gold vm backup status
Rem    rgmurali    09/29/23 - ER 35829025 - Free node patching support for ExaDB-XS
Rem    gvalderr    09/26/23 - Enh 35842708 - Adding template fields for minimum
Rem    oespinos    09/22/23 - Bug 35827954 - Adding hosts_involved to ecs_sla_breach_reason
Rem    abyayada    09/22/23 - Bug 35830731 - Remove Redundant attr
Rem                           OCI_REHOME_STATUS from network object
Rem    jiacpeng    09/20/23 - redesign of SLA
Rem    gvalderr    09/11/23 - Enh 35789663 - Deleteing constraint
Rem                           fk_console_exocid from ecs_oci_console_connection
Rem                           table
Rem    gvalderr    08/31/23 - Adding trustcertificates column to system vault
Rem                           access table
Rem    pverma      08/30/23 - Add new state REQUIRES_RECOVERY to ecs_hw_nodes
Rem                           constraint
Rem    luperalt    08/24/23 - Bug 35738941 Increased description characters in
Rem                           ecs_error
Rem    llmartin    08/18/23 - Bug 35719992 - Fix ecs_oci_subnets constrain
Rem    illamas     08/04/23 - Enh 35677356 - New columns for GI support
Rem    pverma      08/04/23 - Add DELETED state in ECS_DOMUS to support soft
Rem                           delete
Rem    essharm     08/02/23 - Bug 34710874 Altering ecs_cluster_metrics with
Rem                           three new cols
Rem    abyayada    07/24/23 - 35617302 - ADD SUPPORT FOR CREATE READ ONLY PAR
Rem                           URL
Rem    jzandate    07/17/23 - Enh 35592332 - ECRA PREPROV - INCLUDE INSTANCE
Rem                           TYPE ON ECS_COMPUTE_INSTANCES
Rem    aadavalo    07/05/23 - Enh 35435491 - update reshape cluster to support
Rem                           filesystem resize
Rem    aadavalo    06/28/23 - Enh 35543208 - Add vmbackup status tracker
Rem    rmavilla    06/21/23 - EXACS-114176 PARTIAL RACK INGESTION:THE DEFAULT
Rem                           NODE_STATE POST ADD CABINET FOR THE CLUSTERLESS
Rem                           NODES IS 'FREE' INSTEAD OF 'UNDER_INGESTION'
Rem    rgmurali    06/17/23 - ER 35495109 - Automatic unlock on timeout
Rem    jzandate    06/15/23 - Bug 35402924 - Adding new tables for exadata 23
Rem    jzandate    06/08/23 - Bug 35402914 - Adding new column osver
Rem    jreyesm     06/02/23 - E.R 35446340. Tenancy/Memory settings.
Rem    gvalderr    06/01/23 - .Adding column mutable to goldspecs table.
Rem    abyayada    06/01/23 - Bug 35432526 - MAKE THE SQL CHANGES EBR
Rem                           COMPATIBLE IN TRANSACTION
Rem                           HTTPS://ORAREVIEW.US.ORACLE.COM/126730528
Rem                           ABYAYADA_BUG-34988256 (ECRA: CREATE INFRA API
Rem                           REQUEST SPECIAL ATTRIBUTE FOR RACK MIGRATION)
Rem    illamas     05/30/23 - Enh 35403355 - SystemVaultInformation
Rem    caborbon    05/23/23 - Bug 35370235 - Adding support for X10M-2
Rem                           ExtraLarge nodes
Rem    llmartin    05/17/23 - Enh 35048274 - Preprov, launch vm cluster
Rem    gvalderr    05/11/23 - Adding columns for sshkeys table
Rem    aadavalo    05/10/23 - EXACS-104356 - Add gold VM backup support for ecra
Rem    illamas     05/09/23 - Enh 35268841 - Exacompute templates
Rem    gvalderr    05/08/23 - Adding new column for nodes and cabinets table
Rem    illamas     05/02/23 - Enh 35268795 - Store nodeOcid and initiator
Rem    llmartin    04/26/23 - Bug 35332477 - Attach compute, fix multiple
Rem                           formation records
Rem    ririgoye    04/25/23 - Enh 35318144 - ECRA - PREPROV, ADD COLUMN TO
Rem                           DISABLE JOB
Rem    pverma      04/19/23 - Add column parent_req_id to
Rem                           ecs_scheduled_ondemand_exec
Rem    illamas     04/19/23 - Enh 35215344 - GoldSpecs FA support
Rem    jzandate    04/13/23 - Enh 35289456 - Fix MACADDRESS length
Rem    caborbon    04/11/23 - Bug 35177584 - Adding default value for subtype
Rem                           field in ecs_hw_nodes
Rem    abyayada    04/06/23 - ENH 34988256 - Create Infra enhancement for Rack
Rem                           Rehome
Rem    aadavalo    03/31/23 - Enh 35132786 - Update specs of vmbackup job
Rem    aadavalo    03/30/23 - Enh 35182144 - Adding cron_schedule column to
Rem                           scheduled jobs
Rem    luperalt    03/28/23 - Bug 35223841 - Removed null from exa_ocid console connection
Rem    caborbon    03/22/23 - Bug 35196306 - Adding new field for subtype in
Rem                           ecs_hw_nodes
Rem    pverma      03/15/23 - change column width for salt in config bundle
Rem                           details table
Rem    aadavalo    03/09/23 - Enh 35161657 - Add two new node states
Rem                           UNDER_INGESTION and INGESTION_FAILED
Rem    aadavalo    02/22/23 - Enh 35048435 - Changes in schema for preprov
Rem    ririgoye    02/09/23 - Enh 34900889 - Added columns for version info in
Rem                           exaunit_info
Rem    luperalt    01/10/23 - Bug 34715383 Added scan fields for dr in the
Rem                           Network table
Rem    jreyesm     01/09/23 - E.R 34901094. add tenancy info to ceidetails
Rem    jzandate    12/19/22 - Bug 34910205 - Fix long column names for domu
Rem                           table
Rem    illamas     12/15/22 - Enh 34892203 - ADBD mvm
Rem    jbrigido    12/15/22 - bug 34901216 Adding new column rack_num
Rem    caborbon    12/14/22 - Bug 34858677 - Adding new field i ecs_hw_cabinets
Rem                           for eth0
Rem    jyotdas     12/09/22 - Bug 34713683 - Set the free node to 
Rem                           undermaintenance during free node patching
Rem    illamas     11/29/22 - Bug 34773085 - Remove dbsystemid drop
Rem    illamas     11/25/22 - Enh 34581266 - Added reserved cores/memory
Rem    bshenoy     11/24/22 - Bug 34831530: Add table constraint for dyn task
Rem                           in cpssw
Rem    pverma      11/24/22 - add timestamp column for few tables for
Rem                           partitioning
Rem    illamas     11/16/22 - Bug 34806316 - Added cascade for drop constraint
Rem    rgmurali    11/09/22 - Bug 34784596 - Placement plan details fix
Rem    dtalla      11/04/22 - EXACS-99606 ECRA - Create index on ECRA tables
Rem    rmavilla    10/18/22 - EXACS-98203 ECRA - VM Move in Exacompute/Exascale
Rem    essharm     10/17/22 - Adding new column to save examon compartment ocid
Rem    rgmurali    10/17/22 - ER 34325936 - MD support in ECRA
Rem    piyushsi    09/23/22 - BUG 34620149 Update Reserved Core For Exacompute
Rem    jzandate    09/22/22 - Bug 34616926 - Adding DomU provisioning
Rem                           properties to table
Rem    pverma      09/14/22 - Add n/w mode related columns to CC infra table
Rem    essharm     09/14/22 - Bug 34600815
Rem    rmavilla    09/13/22 - EXACS-96336 ECRA - VM Move in
Rem                           Exacompute/ExascaleEXACS-96339 ECRA - VM Move
Rem                           Sanity Check in Exacompute/Exascale
Rem    jzandate    09/05/22 - Add new column to exaunit details
Rem    rgmurali    09/05/22 - ER 34411021 - opc-request-id support
Rem    llmartin    09/02/22 - Bug 34552781 - unique constraint
Rem                           ALIAS_UNIQ_PER_EXADATA violated
Rem    caborbon    08/23/22 - Bug 34409879 - Adding model field in
Rem                           ecs_ceidetails
Rem    rgmurali    07/18/22 - Enh 34391265 - Support MVM bonding in ECRA
Rem    rgmurali    07/07/22 - Enh 34147002 - Add UNDER_INGESTION state for cabinets
Rem    illamas     07/01/22 - Enh 34295307 - Improve analytics for
Rem                           capacity,create infra and rack reserve mvm
Rem    illamas     06/30/22 - Enh 34325943 - Add Maintenance domain
Rem    illamas     07/07/22 - Enh 34358535 - Adding asmss parameter
Rem    illamas     06/30/22 - Enh 34325943 - Add Maintenance domain
Rem    jyotdas     06/21/22 - 34226671 Added child uuid to patching status data
Rem    rgmurlai    06/17/22 - Bug 34294182 - Send mac address to exacloud
Rem    ddelgadi    06/06/22 - Bug 32690620 Added new field in
Rem                           ecs_exaunitdetails
Rem    pverma      05/23/22 - Change to ecs_cores primary key
Rem    hcheon      05/31/22 - 34166256 Added SLA of tenancies
Rem    aadavalo    05/23/22 - Enh 34152630 - STORE IN THE DB THE HOSTNAMES OR
Rem                           IPS OF THE ECRA VMS
Rem    luperalt    05/09/22 - Bug 34143134 Added columns netmask to last ip
Rem    llmartin    05/02/22 - Enh 34110780 - Support multiple DomUs per Dom0
Rem    jreyesm     04/29/22 - bug 34120311. update ecs_temp_domus contraint
Rem    marislop    04/28/22 - ENH 34009216 - Dataplane diagnostics api flags
Rem    illamas     04/13/22 - Bug 34070545 - Delete infra is not deleting
Rem    josedelg    04/12/22 - Enh 33941228 - Support WF completion status
Rem    luperalt    04/04/22 - Bug 34034570 Added default value to STATE in the
Rem                           ecs_oci_networknodes table
Rem    illamas     03/28/22 - Enh 33969007 - Add ethernet gb information for
Rem                           x9m and x10m
Rem    aadavalo    03/25/22 - Enh 33817649 - Changing pod_payload and
Rem                           pod_payload2 from varchar to clob
Rem    llmartin    03/23/22 - Bug 33988756 - Mvm, fix resources calculation in
Rem                           DeleteService
Rem    bshenoy     03/21/22 - Bug 33941226: Support WF completion status
Rem    nmallego    03/09/22 - Bug33943722 - Add new state to ecs_hw_nodes
Rem    illamas     03/08/22 - Bug 33926536 - No compute endpoint found for r1
Rem    illamas     03/01/22 - Enh 33910631 - Add nat vlan configuration for mvm
Rem                           domu host
Rem    nmallego    02/28/22 - ER Bug33861897 - Change constraint of
Rem                           ecs_hw_nodes to accept new states
Rem    llmartin    02/28/22 - Bug 33886708 - Fixed alter table for
Rem                           ecs_oci_infranode_last_ips
Rem    marislop    02/25/22 - ENH 33867580 - default value in ecryption fs
Rem    luperalt    02/22/22 - 33886708 Fixed alter table for
Rem                           ecs_oci_infranode_last_ips
Rem    illamas     01/28/22 - Enh 33509359 - Store and retrieve exacompute
Rem                           payload
Rem    illamas     02/17/22 - Enh 33291247 - Touchless upgrade with SiV
Rem    rgmurali    02/15/22 - Bug 33801928 retain ociurlmap across upgrades
Rem    llmartin    02/15/22 - Enh 33055667 - OciBM Migration, SVM to MVM
Rem    luperalt    02/14/22 - Bug 33849666 Renamed the ecs_oci_cell_last_ips
Rem                           table was renamed to ecs_oci_infranode_last_ips
Rem    luperalt    02/11/22 - Bug 33676289 Removed null constraint network
Rem                           nodes
Rem    illamas     01/31/22 - Enh 33214491 - Add mvm support for postchecks
Rem                           framework
Rem    essharm     01/31/22 - Bug-33790761
Rem    mpedapro    01/30/22 - Bug::33803438 altering the datatypes of inventory
Rem                           project tables
Rem    rgmurali    01/18/22 - ER 33539014 - T93 blackout support
Rem    rgmurali    01/10/22 - Enh 33739958 - Exacompute minor fixes
Rem    caborbon    11/23/21 - Bug - 33581279 Update ATP Customer Tenancy table
Rem                           to include 2 new fields
Rem    marislop    11/16/21 - ENH 33392447 Update parameter bucket namespace to
Rem                           mandatory in FS encryption
Rem    essharm     11/15/21 - bug_33555050 Adding new column
Rem                           event_time_sent_last to store the event timestamp
Rem                           of last successfully sent event to otto
Rem    essharm     11/01/21 - Bug 33509962 - JUNIT TESTS FAILS BECAUSE OF THE
Rem                           TRIGGER EXACC_EXAKSPLICE_INFO_ID_SEQ
Rem    illamas     10/27/21 - Bug 33471995 - Fixed count computes
Rem    llmartin    10/26/21 - Bug 33504131 - ExaCS MultiVM views not created
Rem    llmartin    09/23/21 - Enh 33307814 - ExaCS MVM, update delete-service
Rem    illamas     09/20/21 - Enh 33381947 - Moving specs from ecs_exadata_capacity to
Rem                           ecs_exadata_formation
Rem    illamas     09/07/21 - Enh 33310154 - MvM for domainName and subnetId
Rem    llmartin    08/19/21 - Enh 33055649 - AddCluster API for MVM
Rem    piyushsi    08/11/21 - Bug 33159220 - Add new column configured_model in ecs_hw_nodes
Rem    rgmurali    08/02/21 - Bug 33181901 - Change canonical room to string
Rem    byyang      07/29/21 - bug 32932746. change scheduledjob target_server
Rem    vmallu      07/26/21 - Enh 33156886 - Enable X9M Model support in Compose
REM                           Cluster
Rem    jvaldovi    07/21/21 - Enh 33120371 - Ecradpy, Add Start Time To History
Rem                           Upgrade
Rem    essharm     07/19/21 - reverting back ecs_properties table.
Rem    essharm     07/12/21 - adding new columns in ecs_exaunitdetails,
Rem                           ecs_oci_exa_info and ecs_properties table
Rem    marislop    07/14/21 - ENH 33105953 Rename column name
Rem    illamas     07/14/21 - Bug 33116643 - The mandatory field is wrong when
Rem                           the result is stored in DB
Rem    illamas     07/12/21 - Enh 33105554 - Identify policies for KVM or IB in
Rem                           SELinux
Rem    illamas     07/01/21 - Enh 33055022- Increase size for expected colum in gold_specs
Rem    luperalt    06/21/21 - Bug 32944767 Added node_compute_alias to
Rem                           network_node table
Rem    marislop    06/18/21 - ENH 32925891 - Added columns to retrieve details
Rem                           on computes and cells
Rem    rgmurali    06/07/21 - ER 32926443 - Support canonical QFAB names
Rem    illamas     05/31/21 - Bug 32908698 - Fixing EC handling and JSON for
Rem                           se_linux
Rem    pverma      05/31/21 - Add node_wise_allocations to
Rem                           ExaServiceAllocations and
Rem                           ExaServiceReservedAllocations
Rem    llmartin    05/26/21 - Enh 32883455 - URM Reconfig workflow
Rem    byyang      05/23/21 - Enh 32322406. add timerange and uuid to logcol history
Rem    bshenoy     05/18/21 - Bug 32895120 : Support CPS SW patching fail &
Rem                           retry
Rem    piyushsi    05/17/21 - ENH 32888345 - LOCK MGMT SUBNET CIDR FOR AVM
Rem                           CREATION
Rem    jvaldovi    05/04/21 - Adding VM Backup Job
Rem    llmartin    04/20/21 - Enh 32764856 - CEI reconfig, capacity reserve
Rem    bshenoy     04/08/21 - Bug 32559000: encrypt password column
Rem    jreyesm     04/06/21 - E.R 32704826. Modify exaunit details for
Rem                           jumbo/vnuma.
Rem    llmartin    04/08/21 - Enh 32728201 - Get patch metadata list from ECRA
Rem    bshenoy     03/30/21 - Bug 31808416: new endpoint to download nw
Rem                           validation report
Rem    llmartin    04/05/21 - Enh 32669837 - Execute SanityCheck from Capacity
Rem                           Reserve API
Rem    illamas     03/23/21 - Enh 32669782 - Functional completion of ceiCreate
Rem                           API in ECRA
Rem    bshenoy     03/09/21 - Bug 32257560: Use new crypto util constructor as
Rem                           per security guidelines
Rem    pverma      03/09/21 - add shut_on_zero_core to ecs_oci_exa_info
Rem    luperalt    03/03/21 - Bug 32581463 Renamed details to resource_id
Rem    jreyesm     02/26/21 - E.R 32503057. Elastic shapes.
Rem    bshenoy     02/11/21 - Bug 32451136: cell attach workflow support
Rem    luperalt    02/05/21 - Bug 32465932 Changed details field to clob in the
Rem    ttkumar     01/05/21 - Bug 30431339 rotate patchsvr certificate
Rem    rgmurali    01/02/21 - ER 32133333 - Support Elastic shapes
Rem    pverma      01/06/21 - Add new columns for IV and SALT
Rem    luperalt    12/16/20 - Bug 32290578 Added migration_wss_status field in
Rem                           the ecs_oci_exa_info table
Rem    llmartin    12/02/20 - Enh 32133351 - Inventory release for elastic
Rem                           shapes
Rem    joseort     11/18/20 - Add ociUpgrade flag for handling gen1 to gen2
Rem                           upgrade.
Rem    jreyesm     10/30/20 - E.R 32065716. Expansion racks clustertags.
Rem    piyushsi    09/28/20 - BUG-31787586 Add column action in ecs_wf_requests
Rem    marcoslo    09/24/20 - ER 31816960 - add column to store jumbo frames
Rem                           value
Rem    rgmurali    09/12/20 - ER 31878447 - Add the PUT endpoint for Bonding
Rem    pverma      08/31/20 - Update table for additional disks in X8M2
Rem    rgmurali    08/01/20 - ER 31695260 - ECRA-infra patch integration for X8M
Rem    joseort     07/27/20 - Changes for adding column for migration
Rem                           use "ExaunitInfo" table
Rem    hcheon      06/30/20 - ER 31152543 Add ERROR state to ecs_hw_nodes
Rem    sdeekshi    01/07/20 - Bug 31564449: CLEANUP NON USEFUL XIMAGES CODE
Rem    rgmurali    06/06/20 - ER 31446572 Use OCI realms
Rem    rgmurali    05/31/20 - ER 31170843 - Bonding payload changes.
Rem    pverma      05/28/20 - Remove FK reference to compute records from
Rem                           Vcompute
Rem    vmallu      05/21/20 - Enh 31148086 Add cavium IP from flat file to ECRA
Rem                           metadata
Rem    rgmurali    05/15/20 - Bug 31358495 - Update ecs_domus issue
Rem    pverma      05/13/20 - Add component_response to ecs_requests
Rem    rgmurali    05/08/20 - ER 31195634 - Group the IP allocation under hosts.
Rem    rgmurali    04/21/20 - ER 30971270 Inventory reserve/release APIs
Rem    rgmurali    04/19/20 - Bug 31196760 - Make VLAN ranges configurable for KVM RoCE
Rem    rgmurali    04/18/20 - Bug 31177924 - Validate fabric_name during add cabinet
Rem    vmallu      04/15/20 - Bug 31132022 - add compute and storage only
Rem                           constraints
Rem    jvaldovi    04/08/20 - fixing typo on sql command
Rem    jreyesm     04/03/20 - E.R 31119857 add new version column to track last
Rem                           patch
Rem    rgmurali    04/01/20 - ER 31057723 - KVM RoCE create service changes
Rem    bshenoy     04/01/20 - Bug 31099426 : Skip adding VPN files when WSS is
Rem                           enabled
Rem    pverma      03/25/20 - Add network_ocid to ecs_racks
Rem    luperalt    03/19/20 - XbranchMerge luperalt_bug-31039348 from
Rem                           st_ecs_19.4.3.2.0
Rem    yyingl      03/17/20 - 31030128 - Scheduler for Certificate Rotation
Rem    rgmurali    03/17/20 - ER 31045047 - Add fabric name to ecs_racks
Rem    bshenoy     03/13/20 - Bug 31008157: config bundle changes for MVM
Rem                           migration
Rem    pverma      03/12/20 - Add remote_component to WFRequests
Rem    rgmurali    03/11/20 - ER 31014534 Rename fabric_id to fabric_name
Rem    jvaldovi    03/10/20 - Adding field compartment_id on table
Rem                           ecs_atpcustomertenancy
Rem    llmartin    03/06/20 - Enh 30971142 - Get DomU key to get access for
Rem                           elastic
Rem    rgmurali    03/06/20 - XbranchMerge rgmurali_bug-30870817 from
Rem                           st_ecs_pt-x8m
Rem    luperalt    03/16/20 - Bug 31039348 Added missing column
Rem                           nat_vip_hostname
Rem    pverma      03/03/20 - Add new column for VMClusterOcid to ECS_RACKS
Rem    pverma      03/03/20 - Remove PK constraint for
Rem                           ecs_exadata_vcompute_node and add composite PK
Rem    jreyesm     03/02/20 - E.R 29247537 changes to elastic x8m OCI
Rem    luperalt    02/13/20 - Bug 30764846: websocket server schema changes
Rem    pverma      02/06/20 - Remove NOT NULL constraint from rack_basename
Rem    pverma      02/02/20 - Add column to ecs_cores to record Dom0 name as
Rem                           wel
Rem    luperalt    01/31/20 - Added new field to the ecs_oci_vpn_cert_info
Rem                           table for new cert
Rem    piyushsi    01/31/20 - Bug 30417623 - Add Column wf_retry_count column
Rem    pverma      01/26/20 - Restore unique(name) constraint in ecs_racks
Rem                           which was dropped for OCI-ExaCC V1
Rem    pverma      01/14/20 - OCI-ExaCC MVM CreateService Impl
Rem    llmartin    01/14/20 - Enh 30749351 - ATP Resume preprov dbsystem
Rem                           polling status
Rem    pverma      12/23/19 - OCI-ExaCC MVM support changes to Pre-Activation
Rem                           Flow
Rem    rgmurali    12/17/19 - ER 30550146 - Support bigger subnets for bonding
Rem    luperalt    01/09/20 - Add vpn_proxy_key field to the
Rem                           ecs_oci_vpn_cert_info table
Rem    jvaldovi    11/25/19 - Adding modifiers for field errors in async_calls
Rem                           table
Rem    hhhernan    11/22/19 - 30582057 support CPS proxy null value
Rem    luperalt    11/20/19 - Added new field to store the CPS Nginx Key in the
Rem                           DB
Rem    rgmurali    11/19/19 - ER 30545214 - Add domU bonding support
Rem    rgmurali    10/30/19 - ER 30390456 Adding ExaCS profiling
Rem    hhhernan    10/30/19 - 30420823 include new ExaCC OCI certs
Rem    illamas     10/21/19 - Bug 30402383 - Added ATP to
Rem                           ECS_ATPCUSTOMERTENANCY
Rem    jloubet     10/16/19 - Adding changes for oss terraform ingestion
Rem    illamas     10/01/19 - Bug 29892564 - Add start time to
Rem                           ecs_atppreprovdetails
Rem    jaseol      09/25/19 - Bug-30329945 Change length of job_params column on
Rem                           ecs_scheduledjob, ecs_scheduledjob_history table to receive otto config.
Rem    rgmurali    03/03/20 - ER 30870817 - Fabric addition APIs
Rem    oespinos    02/13/19 - ENH 30766691 - ECRA SCHEMA UPGRADE SCRIPT FOR
Rem                           COMPOSE CLUSTER ROCE SUPPORT
Rem    rgmurali    01/27/20 - ER 30809227 - Schema changes for KVM RoCE
Rem    rgmurali    02/04/19 - Bug 30847525 - Remove fault domain id
Rem    vmallu      01/15/20 - ENH 30765027 - COMPOSE CLUSTER ROCE/X8M SUPPORT
Rem    hcheon      08/28/19 - 30208357 change ecs_diag_rack_info_chk constraint
Rem    rgmurali    08/20/19 - ER 30202025 - Add additional checks before delete service
Rem    joseort     08/08/19 - Changing table from ecs_racks ro
Rem                           ecs_oci_exa_info.
Rem    illamas     08/06/19 - Added new colum re_config_dbsystem_id_backup to
Rem                           ecs_atppreprovdetails
Rem    hhhernan    08/01/19 - 30097428 Save ExaCloud keys for CC-OCI
Rem    pverma      07/24/19 - Properties for holding cipher key for config
Rem                           bundle
Rem    seha        07/23/19 - 30041007 add columns for asset endpoint protection
Rem    jupined     07/22/19 - XbranchMerge jupined_bug-30072527_2 from
Rem                           st_ebm_19.1.1.0.0
Rem    hhhernan    07/19/19 - 30072527 take VPN HE user and path from the DB
Rem    jloubet     07/18/19 - Adding versioning to terraform tables
Rem    jreyesm     07/10/19 - E.R 29962765. Allow customertenancy details on
Rem                           exacs
Rem    pverma      07/09/19 - Add columns to ecs_oci_exa_controlserver
Rem    aanverma    07/04/19 - Bug #30003374: Change column name from
Rem                           exacloud_response to component_response in
Rem                           ecs_wf_requests
Rem    pverma      07/02/19 - Increase column size for proxy URL of OciExa CPS
Rem    bshenoy     07/01/19 - Bug 29908071: ssl cert issue
Rem    pverma      06/28/19 - New column in ecs_requests to identify target
Rem    pverma      06/21/19 - Add connectivity attribute to the OciExadata
Rem    aanverma    06/19/19 - Bug #29884927: Add columns for tracking time
Rem                           in ecs_wf_requests
Rem    jricoir     06/19/19 - 29927854: Handle cluster reconfig for EM
Rem                           registration
Rem    jloubet     06/03/19 - Adding identity_type column
Rem    jricoir     05/29/19 - 29618561: N-Remote agents support
Rem    piyushsi    05/07/19 - E.R exa_ocid in ecs_requests table
Rem    vmallu      05/06/19 - bug 29706888: fix 29625763 compose cluster
Rem    rgmurali    05/05/19 - E.R 29464642 - Support rack maintenance mode
Rem    rgmurali    05/01/19 - ER 29455997 - Capacity consolidate feature
Rem    jreyesm     04/11/19 - E.R 29625763. cluster tags for rack
Rem    ananyban    04/09/19 - Bug 29618547: Adding new EM state
Rem    pverma      04/07/19 - Data modelling for OCI-Exa changes
Rem    jloubet     03/05/19 - Deleting timezone constraint
Rem    diegchav    02/19/19 - Bug 29298014 : Add dbUniqueName to databases table
Rem    nkattige    02/19/19 - (29378186) Incorporate incremental changes added
Rem                           in create_tables.sql for ecs_emtrackingresource
Rem                           which is needed for upgrade scenarios.
Rem    jloubet     02/14/19 - XbranchMerge jloubet_bug-29344629 from
Rem                           st_ebm_19.1.1.0.0
Rem    sachikuk    01/29/19 - Bug - 29196255 : Racks monitoring job for ATP pre
Rem                           prov scheduler
Rem    ananyban    01/29/19 - Bug 28947732: Adding columns resource_info1 and
Rem                           resource_info2 in ecs_emtrackingresource
Rem    jloubet     02/13/19 - Changes for constraint in db
Rem    jreyesm     01/21/19 - E.R 29185790 Complex Opr support.
Rem    diegchav    01/17/19 - XbranchMerge diegchav_bug-29062412 from main
Rem    diegchav    01/17/19 - XbranchMerge diegchav_bug-28999178 from main
Rem    llmartin    01/07/19 - XbranchMerge llmartin_bug-28702021 from main
Rem    rgmurali    12/14/18 - XbranchMerge rgmurali_bug-29050191 from main
Rem    jloubet     12/10/18 - Adding column to ecs_exadata_capacity
Rem    diegchav    12/06/18 - ER 28992034 : Change primary key for ecs_atpauthentication
Rem    piyushsi    12/03/18 - XbranchMerge piyushsi_bug-28945176 from main
Rem    aanverma    11/30/18 - Bug #28843249: Add status_comment column to ecs_racks
Rem    jloubet     11/27/18 - Changes for register capacity
Rem    piyushsi    11/20/18 - ENHH 28945176 add orcl_client column in ecs_atpauthentication
Rem    diegchav    11/09/18 - ER 28901608 : ATP get dns ips for backup
Rem                           interface
Rem    llmartin    11/06/18 - Enh 28702021 - OCI Base System Support
Rem    jungnlee    11/08/18 - Bug 28902534 ecs_diag_report - add auto-incremental column
Rem    sringran    10/24/18 - ER 28698448 Adding and renaming few columns in ecs_images table.
Rem    byyang      10/03/18 - ER 28731684. Scheduler one-off job feature.
Rem    jreyesm     09/18/18 - E.R 28667721. Add ATP column to Rack table for
Rem    byyang      08/09/18 - Bug 28484201. Diag table change for ECRA DB
Rem    jreyesm     08/09/18 - E.R. node vip and scan for atp
Rem    sdeekshi    07/26/18 - Bug 28408108 - Ecra ximages integration with exacloud
Rem    llmartin    07/20/18 - Bug 28096666 - CPU oversubscription
Rem    rgmurali    07/07/18 - XbranchMerge rgmurali_bug-28242735 from
Rem                           st_ebm_18.2.5.1.0
Rem    brsudars    06/20/18 - Add field to track free local node storage per
Rem                           compute
Rem    sgundra     06/19/18 - Bug-28204869: Add iaas/paas support for multivm
Rem    llmartin    06/18/18 - ENH 28193584 - Add hardware tags for Iaas-Paas.
Rem    jreyesm     06/07/18 - E.R 28043393. NAT support for Pod
Rem    byyang      05/20/18 - ER 27989788. Support scheduler target_server
Rem    srtata      05/16/18 - bug 27727580 : x7 support in ecs_caviums
Rem    sgundra     05/11/10 - Bug-28013177 - Create service support for Iaas/Paas
Rem    sachikuk    05/11/18 - Common status tracker for ECRA [Bug - 27366188]
Rem    jreyesm     05/09/18 - alter exadata_id from exadataformation
Rem    sgundra     04/30/18 - Bug 27947099 - Exaunit Suspend/Resume
Rem    srtata      04/19/18 - bug 27697345: alter ecs_hw_nodes
Rem    brsudars    04/10/18 - Add U02 partition space fields to ecs_exaservice
Rem    sgundra     03/09/18 - Bug 27671189 - ENABLE OPSTATE TO ALLOW OPS TO PROVISION INSTANCES
Rem    rgmurali    03/08/18 - Bug 27588575. Backup cloud ip support
Rem    jreyesm     03/01/18 - Bug 27614474. Client/backup ip support.
Rem    jreyesm     02/22/18 - Bug 27520916. Include natvips/nodevips values.
Rem    rgmurali    02/20/18 - 27573225 - PSM-JCS integration
Rem    rgmurali    01/17/18 - 27377921 - higgs with mvm support
Rem    mmsharif    12/21/17 - 27300875 - COMPOSE CLUSTER: CLIENT JSON NEEDS TO
Rem                           HAVE DISKGROUP IDENTIFIER
Rem    nkedlaya    12/02/17 - table modification script
Rem    nkedlaya    12/02/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Don't exit on error
whenever sqlerror continue;

-- Add state column to ecs_domus table
PROMPT Altering table ecs_domus
alter table ecs_domus
    add (state varchar2(64) DEFAULT 'RUNNING' CHECK (state in ('RUNNING',
                'STOPPED', 'MIGRATING', 'PATCHING', 'RESOURCE_SCALING',
                'TERMINATING', 'ERROR', 'PROVISIONING', 'DELETED')));

-- Add exadata_id column to ecs_racks table
PROMPT Altering table ecs_racks
alter table ecs_racks
    add (exadata_id varchar2(512));

PROMPT Altering table ecs_racks
alter table ecs_racks
    add CONSTRAINT fk_rack_exadata_id
        FOREIGN KEY (exadata_id)
        REFERENCES ecs_exadata(exadata_id) NOVALIDATE;

PROMPT Altering table ecs_racks
alter table ecs_racks
    add (atp CHAR(1) DEFAULT 'N' CHECK (atp in ('Y', 'N')));

PROMPT Altering table ecs_racks
alter table ecs_racks
    add (domu_bonding CHAR(1) DEFAULT 'N' CHECK (domu_bonding in ('Y', 'N')));

alter table ecs_racks rename column domu_bonding to dom0_bonding;
alter table ecs_racks drop column domu_bonding;

alter table ecs_racks
    add (mvmbonding CHAR(1) DEFAULT 'N' CHECK (mvmbonding in ('Y', 'N')));

PROMPT Altering table ecs_racks
alter table ecs_racks
    add (clustertag varchar2(64) default 'ALL');

PROMPT Altering table ecs_racks
alter table ecs_racks
    add (previous_status varchar2(100));

PROMPT Altering table ecs_racks
alter table ecs_racks
    add auto_maintenance char(1) DEFAULT 'Y' CHECK (auto_maintenance in ('Y', 'N'));

PROMPT Altering table ecs_racks
alter table ecs_racks
    add ops_delete_service char(1) DEFAULT 'N' CHECK (ops_delete_service in ('Y', 'N'));

alter table ecs_racks drop column fault_domain;
alter table ecs_racks drop column fabric_name;

alter table ecs_racks
    add (featuretag varchar2(512));

-- Add maxracks column to ecs_hardware table to hold max racks
PROMPT Altering table ecs_hardware
alter table ecs_hardware
    add (maxracks number default 8 not null);
alter table ecs_hardware 
    add (env varchar2(20) default on null 'bm' not null);

PROMPT Altering table ecs_higgsresources
alter table ecs_higgsresources
    add (appid varchar(512));
PROMPT Altering table ecs_higgsresources
alter table ecs_higgsresources
    add (secret varchar(512));
PROMPT Altering table ecs_higgsresources
alter table ecs_higgsresources
    add (adminusername varchar(256));
PROMPT Altering table ecs_higgsresources
alter table ecs_higgsresources
    add (clientnetwork varchar(256), backupnetwork varchar(256));

PROMPT Altering table ecs_higgsresources
alter table ecs_higgsresources
    add (nodevips_name varchar(1024),scanvips_name varchar(1024));

PROMPT Altering table ecs_higgsresources
alter table ecs_higgsresources
    add (clientvnic_name varchar(1024),backupvnic_name varchar(1024));

PROMPT Altering table ecs_higgscloudip
alter table ecs_higgscloudip
    add (backupnwcloudip varchar2(128));

-- Begin multi-vm changes

PROMPT Altering table ecs_hardware
alter table ecs_hardware
    add (tbStorage number not null);

PROMPT Altering table pods
alter table pods
    add (exaservice_id varchar2(4000) null);

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails
    add (gb_storage NUMBER);

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails
    add (gb_ohsize NUMBER);

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails
    add (atp CHAR(1) DEFAULT 'N' CHECK (atp in ('Y', 'N')));

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails
    MODIFY exaunit_name varchar2(50);

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails
    add (domu_bonding CHAR(1) DEFAULT 'N' CHECK (domu_bonding in ('Y', 'N')));

alter table ecs_exaunitdetails rename column domu_bonding to dom0_bonding;
alter table ecs_exaunitdetails drop column domu_bonding;

alter table ecs_exaunitdetails add jumbo_frames varchar2(50);
alter table ecs_exaunitdetails add vnuma varchar2(50);
alter table ecs_exaunitdetails add admin_password varchar2(256);
alter table ecs_exaunitdetails add (reserved_cores number default 0);
alter table ecs_exaunitdetails add (reserved_memory number default 0);
alter table ecs_exaunitdetails add (total_cores number default 0);


PROMPT Altering table databases
alter table databases
    add (ocid varchar2(2048));
alter table databases
    add (dbUniqueName varchar2(512));
alter table databases
    modify (timezone varchar2(50) null);
alter table databases
    add (initial_dbversion varchar2(50) null);

PROMPT Altering table ecs_rack_slots
alter table ecs_rack_slots
    add (cluster_id varchar2(256) null);

PROMPT Altering table ecs_rack_slots
alter table ecs_rack_slots
    add (client_network_info varchar2(256) null);

PROMPT Altering table ecs_rack_slots
alter table ecs_rack_slots
    add (backup_network_info varchar2(256) null);

PROMPT Altering table ecs_exaservice
alter table ecs_exaservice
    add (total_ohstoragegb NUMBER);

PROMPT Altering table ecs_exaservice
alter table ecs_exaservice
    add (avail_ohstoragegb NUMBER);


-- End mulit-vm changes

-- Change the resourcelist cloumn in ecs_higgsresources from varchar to CLOB
-- And this is the easiest way. We could have used online redefinition.
-- So you see an update statement in the middle of the alter table.
PROMPT Altering table ecs_higgsresources (changing resourcelist from VARCHAR2 to CLOB)
alter table ecs_higgsresources add (temp CLOB);
update ecs_higgsresources SET temp = resourcelist;
commit;
alter table ecs_higgsresources drop column RESOURCELIST;
alter table ecs_higgsresources rename column temp to RESOURCELIST;

PROMPT Altering table ecs_exadata_formation (changing exadata_id name to exadata_formation_id)
alter table ecs_exadata_formation rename column exadata_id to exadata_formation_id;
alter table ecs_exadata_formation
add CONSTRAINT ecs_exadata_formation_id_fk
      FOREIGN KEY (exadata_formation_id)
      REFERENCES ecs_exadata_entity(exadata_formation_id) ;

alter table ecs_exadata_formation drop constraint ECS_EXADATA_FORMATION_FK;
alter table ecs_exadata_formation add constraint ECS_EXADATA_FORMATION_FK FOREIGN KEY (inventory_id) REFERENCES ecs_exadata_capacity(inventory_id);

-- changes to refacto exadata formation tables
alter table ecs_exadata_formation add (temp varchar2(250));
alter table ecs_exadata_entity add (temp varchar2(250));
update ecs_exadata_formation SET temp = exadata_formation_id;
update ecs_exadata_entity SET temp = exadata_formation_id;
commit;
alter table ecs_exadata_formation drop constraint ecs_exadata_formation_id_fk;
alter table ecs_exadata_formation drop constraint ecs_exadata_formation_pk;
alter table ecs_exadata_formation drop column exadata_formation_id;
alter table ecs_exadata_entity drop column exadata_formation_id;
alter table ecs_exadata_entity rename column temp to exadata_formation_id;
alter table ecs_exadata_formation rename column temp to exadata_formation_id;
alter table ecs_exadata_entity add CONSTRAINT ecs_exadata_entity_pk PRIMARY KEY (exadata_formation_id);
drop trigger exadata_entity_seq;
alter table ecs_exadata_formation add CONSTRAINT ecs_exadata_formation_id_fk FOREIGN KEY (exadata_formation_id) REFERENCES ecs_exadata_entity(exadata_formation_id) ;


-- Begin bug 27300875
alter table ecs_cluster_diskgroups drop constraint ecs_cls_dskgrp_type_ck;
alter table ecs_cluster_diskgroups add constraint ecs_cls_dskgrp_type_ck
  check  (disk_group_type in ('DATA', 'RECO', 'REDO','SYSTEM','DBFS', 'ACFS'));
-- End bug 27300875

-- Begin bug 27377921
alter table ecs_higgsresources add DOMUNAMES CLOB;
--End bug 27377921

-- Enable OPSTATE --
ALTER TABLE ecs_racks DROP CONSTRAINT ecs_racks_opstate_ck;

ALTER TABLE ecs_racks
add CONSTRAINT ecs_racks_opstate_ck CHECK (OPSTATE in ('ONLINE', 'OFFLINE', 'OPSTEST', 'PATCH'));

ALTER TABLE pods
    add iaas varchar2(10) DEFAULT 'false';

ALTER TABLE pods
    add suspend_on_create varchar2(10) DEFAULT 'false';

ALTER TABLE ecs_racks
    add cluster_status varchar(256) DEFAULT 'ACTIVE'
    CONSTRAINT cluster_status_ck
    CHECK (cluster_status in ('ACTIVE', 'SUSPENDED', 'VM_MOVE'));


ALTER TABLE ecs_requests
    add (
        last_heartbeat_update varchar2(50),
        ecra_server varchar2(256)
    );
ALTER TABLE ecs_requests add (parent_req_id varchar2(50));
ALTER TABLE ecs_requests add (sub_req_id number);
ALTER TABLE ecs_requests add (wf_uuid varchar2(36));
ALTER TABLE ecs_requests add (exa_ocid varchar2(2048));
ALTER TABLE ecs_requests add (atp_enabled CHAR(1) CHECK (atp_enabled in ('Y', 'N')));
--Enh 37001368 - Changing target_uri field size
ALTER TABLE ECS_REQUESTS MODIFY TARGET_URI VARCHAR2(512);


ALTER TABLE user_auth add (encryptionKey varchar2(16));
ALTER TABLE user_auth add (salt varchar2(16));
ALTER TABLE user_auth add (iv varchar2(16));

ALTER TABLE ecs_zones add (encryptionKey varchar2(16));
ALTER TABLE ecs_zones add (salt varchar2(16));
ALTER TABLE ecs_zones add (iv varchar2(16));

-- Add columns for tracking time in ecs_wf_requests
ALTER TABLE ecs_wf_requests
    ADD (
         last_heartbeat_update VARCHAR2(50),
         start_time VARCHAR2(50),
         end_time VARCHAR2(50),
         ecra_server VARCHAR2(256)
    );

alter table ecs_wf_requests
    add (action VARCHAR2(50) default 'EXECUTE');

alter table ecs_wf_requests
    add (wf_retry_count number default 0 not null);

alter table ecs_wf_requests
    add (remote_component VARCHAR2(50));

-- Change column name
ALTER TABLE ecs_wf_requests
    RENAME COLUMN exacloud_response TO component_response;

ALTER TABLE ecs_exadata_compute_node
    add avail_local_storage_gb number not null;

alter table ecs_exadata_compute_node modify exadata_id NULL;
ALTER TABLE ecs_exadata_compute_node add inventory_id varchar2(128);
ALTER TABLE ecs_exadata_compute_node add total_cores number;
alter table ecs_exadata_compute_node add constraint fk_comp_exadata_inv_id FOREIGN KEY (inventory_id) REFERENCES ecs_exadata_capacity(inventory_id) ON DELETE CASCADE;
alter table ecs_exadata_compute_node drop constraint fk_compute_exadata_id;

alter table ecs_exadata_capacity add specs CLOB;
alter table ecs_exadata_capacity add uloc varchar2(30);
alter table ecs_exadata_capacity drop column uloc;
alter table ecs_exadata_capacity add fault_domain varchar2(256);
alter table ecs_exadata_capacity add fabric_name varchar2(1024);
alter table ecs_exadata_capacity add service_type varchar2(128);
alter table ecs_exadata_capacity add reserved_order number default 0 NOT NULL;
ALTER TABLE ecs_exadata_capacity add (configured_model varchar2(1024));

-- change constraints for compose cluster roce support
alter table ecs_exadata_cell_node modify cell_type NULL;
alter table ecs_exadata_cell_node modify model NULL;
alter table ecs_exadata_cell_node modify local_storage_gb NULL;
alter table ecs_exadata_cell_node rename column name to hostname;

alter table ecs_exadata_compute_node modify allocated_purchased_cores default 0;
alter table ecs_exadata_compute_node modify allocated_burst_cores default 0;
alter table ecs_exadata_compute_node modify memory_gb default 0;
alter table ecs_exadata_compute_node modify local_storage_gb default 0;
alter table ecs_exadata_compute_node modify avail_local_storage_gb default 0;
alter table ecs_exadata_compute_node modify total_cores default 0;

-- change constraint for composed cluster sabre support

alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_clu_size;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_node_type;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_ilom_ip;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_ilom_hostname;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_ib_info;
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_node_state;

ALTER TABLE ecs_hw_nodes add
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

ALTER TABLE ecs_hw_nodes add
      CONSTRAINT ck_ecs_hw_nodes_node_type
        CHECK (node_type in ('CELL', 'COMPUTE', 'IBSW', 'ROCESW',
                             'SPINESW', 'PDU', 'ETHERSW'));

ALTER TABLE ecs_hw_nodes add
      CONSTRAINT ck_ecs_hw_nodes_ilom_ip CHECK
        (( oracle_ilom_ip is not null
           and node_type in ('CELL', 'COMPUTE')
        )
        or
        (  oracle_ilom_ip is null
           and node_type in ('IBSW', 'ROCESW', 'SPINESW', 'PDU', 'ETHERSW')
        ));

ALTER TABLE ecs_hw_nodes add
      CONSTRAINT ck_ecs_hw_nodes_ilom_hostname CHECK
        (( oracle_ilom_hostname is not null
           and node_type in ('CELL', 'COMPUTE')
        )
        or
        (  oracle_ilom_hostname is null
           and node_type in ('IBSW', 'ROCESW', 'SPINESW', 'PDU', 'ETHERSW')
        ));

ALTER TABLE ecs_hw_nodes add
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
      );

ALTER TABLE ecs_hw_nodes add
    CONSTRAINT ck_ecs_hw_nodes_node_state
      CHECK (node_state in ('FREE', 'COMPOSING', 'ALLOCATED', 'HW_REPAIR',
                            'HW_UPGRADE', 'HW_FAIL', 'RESERVED', 'ERROR', 'EXACOMP_RESERVED', 'RESERVED_MAINTENANCE', 'RESERVED_FAILURE',
                            'RESERVED_HW_FAILURE', 'FREE_FAILURE', 'FREE_MAINTENANCE','FREE_UNDER_MAINT', 'COMPOSING_UNDER_MAINT', 
                            'ALLOCATED_UNDER_MAINT', 'RESERVED_UNDER_MAINT',
                            'HW_REPAIR_UNDER_MAINT', 'HW_UPGRADE_UNDER_MAINT', 'HW_FAIL_UNDER_MAINT',
                            'ERROR_UNDER_MAINT', 'EXACOMP_RESERVED_UNDER_MAINT', 'INNOTIFICATION', 'INNOTIFICATION_UNDER_MAINT',
                            'INMAINTENANCE', 'INMAINTENANCE_UNDER_MAINT', 'UNDER_INGESTION', 'INGESTION_FAILED', 'REQUIRES_RECOVERY',
                            'FREE_AUTO_MAINTENANCE','MOVING','DECOMMISSIONING'));


ALTER TABLE  ecs_hw_nodes
    add (dom0_bonding CHAR(1) DEFAULT 'N' CHECK (dom0_bonding in ('Y', 'N')));

ALTER TABLE ecs_hw_nodes
    add (mvmbonding CHAR(1) DEFAULT 'N' CHECK (mvmbonding in ('Y', 'N')));

ALTER TABLE  ecs_hw_nodes
    add (clustertag varchar2(64) DEFAULT 'ALL');

ALTER TABLE ecs_hw_nodes
    add (ceiocid varchar2(1024));

ALTER TABLE ecs_hw_nodes
    add (servicetype varchar2(64) default 'exacs');

ALTER TABLE ecs_hw_nodes
    add (node_ocid varchar2(128));

ALTER TABLE ecs_hw_nodes
    add (initiator_id varchar2(128));

--Enh 35370235
--In case someone is using an old ECS version, we need to rename the created subtype field to model_subtype
ALTER TABLE ecs_hw_nodes 
    RENAME COLUMN subtype TO model_subtype;

--In case someone is using an old ECS version, we need to change the default value from STOCK to STANDARD
--ALTER TABLE ecs_hw_nodes
--    MODIFY (model_subtype varchar(64) default 'STANDARD');

--ALTER TABLE ecs_hw_nodes
--    MODIFY (model_subtype varchar(64) NOT NULL);
ALTER TABLE ecs_hw_nodes 
    MODIFY (model_subtype DEFAULT NULL);
ALTER TABLE ecs_hw_nodes 
    MODIFY (model_subtype varchar2(64) DEFAULT ON NULL 'STANDARD' NOT NULL);
ALTER TABLE ecs_hw_nodes
    add (model_subtype varchar2(64) DEFAULT ON NULL 'STANDARD' NOT NULL);

ALTER TABLE ecs_hw_cabinets
    add fault_domain varchar2(256);

ALTER TABLE ecs_hw_cabinets
    add status varchar2(256) default 'READY';

ALTER TABLE ecs_hw_cabinets modify status DEFAULT 'UNDER_INGESTION';

ALTER TABLE ecs_hw_cabinets
    add XML CLOB;

ALTER TABLE ecs_hw_cabinets drop constraint ck_ecs_hw_cabinets_status;

ALTER TABLE ecs_hw_cabinets add
    CONSTRAINT ck_ecs_hw_cabinets_status
      CHECK (status in ('READY', 'MAINTENANCE', 'RESERVED', 'UNDER_INGESTION'));

ALTER TABLE ecs_hw_cabinets
    add canonical_building varchar2(64);

ALTER TABLE ecs_hw_cabinets
    add canonical_room number;

ALTER TABLE ecs_hw_cabinets
    add block_number number;

ALTER TABLE ecs_hw_cabinets
    add serial_number varchar2(64);

ALTER TABLE ecs_hw_cabinets
    add (previous_status varchar2(256));

ALTER TABLE ecs_bonding
    add preferred_interface varchar2(256);

ALTER TABLE ecs_bonding
    add control_type varchar2(256);

ALTER TABLE ecs_bonding
    add cavium_ids CLOB;

ALTER TABLE ecs_hw_cabinets
    add launchnode varchar2(256);

-- Enh 36334590 - Adding column ECS_HW_CABINET to determine if a cabinet is dedicated or shared 
ALTER TABLE ECS_HW_CABINETS ADD ( OPSTATE varchar2(128) DEFAULT ON NULL 'DEDICATED' NOT NULL);
ALTER TABLE ECS_HW_CABINETS DROP CONSTRAINT ck_ecs_hw_cabinets_opstate;
ALTER TABLE ECS_HW_CABINETS add CONSTRAINT ck_ecs_hw_cabinets_opstate
      CHECK (OPSTATE in ('SHARED', 'DEDICATED'));

ALTER TABLE ecs_ib_fabrics
    add fabric_name varchar2(1024);

ALTER TABLE ecs_ib_fabrics
    add sw_type varchar2(32) default 'IBSW' not null;

ALTER TABLE ecs_ib_fabrics
      CONSTRAINT ecs_ib_fabrics_sw_type_ck
      CHECK (sw_type in ('IBSW','ROCESW'));

ALTER TABLE ecs_caviums
    add cavium_ip varchar2(256);

-- DROP unique cavium_id constraint for BM X7 support --
ALTER TABLE ecs_caviums drop constraint ECS_CAVIUMS_CAVIUM_ID;

--DROP ximage related columns and tables
ALTER TABLE ecs_exaunitdetails DROP COLUMN XIMAGE_ID;
ALTER TABLE databases DROP COLUMN XIMAGE_ID;
DROP table ecs_image_defaults cascade constraints;
DROP table ecs_images cascade constraints;
DROP table ecs_image_category cascade constraints;
DROP trigger images_category_id;
DROP trigger images_id;
DROP sequence image_id_seq;
DROP sequence image_category_id_seq;

-- Support Iaas/Paas for multiVM
ALTER TABLE ecs_exaservice
    add iaas varchar2(10) DEFAULT 'N';

ALTER TABLE ecs_exaservice
    add suspend_on_create varchar2(10) DEFAULT 'N';

ALTER TABLE ecs_exaservice
    add service_status varchar(256) DEFAULT 'ACTIVE'
    CONSTRAINT service_status_ck
    CHECK (service_status in ('ACTIVE', 'SUSPENDED'));

-- Begin ER 27989788. Support scheduler target_server
PROMPT Altering table ecs_scheduledjob
ALTER TABLE ecs_scheduledjob
    ADD target_server VARCHAR2(50) DEFAULT 'ANY';

ALTER TABLE ecs_scheduledjob
    DROP CONSTRAINT ecs_scheduledjob_uniq;

ALTER TABLE ecs_scheduledjob
    ADD CONSTRAINT ecs_scheduledjob_uniq UNIQUE (job_class, job_cmd, job_params, target_server);
-- End ER 27989788. Support scheduler target_server

-- Begin ER 28731684. Scheduler one-off job feature
PROMPT Altering table ecs_scheduledjob
ALTER TABLE ecs_scheduledjob
    ADD type VARCHAR2(20);

PROMPT Altering table ecs_scheduledjob
ALTER TABLE ecs_scheduledjob
    ADD planned_start TIMESTAMP;

PROMPT Altering table ecs_scheduledjob
ALTER TABLE ecs_scheduledjob
    ADD timeout NUMBER;
-- End ER 28731684. Scheduler one-off job feature

-- Begin ER 29196255. Support scheduler job group id
PROMPT Altering table ecs_scheduledjob
ALTER TABLE ecs_scheduledjob ADD job_group_id NUMBER;
PROMPT Altering table ecs_scheduledjob_history
ALTER TABLE ecs_scheduledjob_history ADD job_group_id NUMBER;
-- End ER 29196255. Support scheduler job group id

-- Begin Bug 30329945 Change job_params column length
PROMPT Altering table ecs_scheduledjob
ALTER TABLE ecs_scheduledjob
    MODIFY (JOB_CMD varchar2(3000), JOB_PARAMS varchar2(2500));

PROMPT Altering table ecs_scheduledjob_history
ALTER TABLE ecs_scheduledjob_history
    MODIFY (JOB_CMD varchar2(3000), JOB_PARAMS varchar2(2500));

-- End Bug 30329945 Change job_params column legnth


-- Begin Bug 32932746 Change target_server value

PROMPT Updating table ecs_scheduledjob
UPDATE ecs_scheduledjob
    SET target_server = 'PRIMARY'
    WHERE target_server = 'EcraServer1';
UPDATE ecs_scheduledjob
    SET target_server = 'STANDBY'
    WHERE target_server = 'EcraServer2';
COMMIT;
-- No need to update job_history table

-- Adding and setting current_target_server should be done only once
-- because current_target_server is set by ECRA as needed
PROMPT Altering table ecs_scheduledjob
DECLARE
    v_column_exists NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_column_exists
    FROM user_tab_cols
    WHERE LOWER(column_name) = 'current_target_server'
        AND LOWER(table_name) = 'ecs_scheduledjob';

    IF (v_column_exists = 0) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ecs_scheduledjob ADD (current_target_server VARCHAR2(50) DEFAULT ''ANY'')';
        EXECUTE IMMEDIATE 'ALTER TABLE ecs_scheduledjob_history ADD (current_target_server VARCHAR2(50))';
        EXECUTE IMMEDIATE 'UPDATE ecs_scheduledjob SET current_target_server = target_server';
        -- No need to update history table
        COMMIT;
    END IF;
END;
/
-- End Bug 32932746 Change target_server value

Promp Altering table ecs_scheduledjob
ALTER TABLE ecs_scheduledjob ADD cron_schedule VARCHAR2(64);

ALTER TABLE  ecs_atpnetworkpayload RENAME column AD to CUST_AD;
ALTER TABLE  ecs_atpnetworkpayload RENAME column REGION to CUST_REGION;

ALTER TABLE ecs_atpnetworkpayload
    DROP CONSTRAINT fk_atpnetworkpayload;

ALTER TABLE ecs_atpnetworkpayload
    ADD CONSTRAINT fk_atpnetworkpayload FOREIGN KEY (CUST_REGION) REFERENCES
    ecs_atpauthentication(region) ON DELETE CASCADE;

alter table ecs_atpcustomertenancy drop constraint fk_ecs_atpcustomertenancy;
alter table ecs_atpcustomertenancy  add (rackname        varchar2(256));
alter table ecs_atpcustomertenancy  add (atp CHAR(1) DEFAULT 'N' CHECK (atp in ('Y', 'N')));
alter table ecs_atpcustomertenancy  add (compartment_id varchar2(2048));
alter table ecs_atpcustomertenancy  add (ceiocid varchar2(256));
alter table ecs_atpcustomertenancy  add (vmclusterocid varchar2(256));
-- Begin ER 28992034: Change primary key for ecs_atpAuthentication to be (region, orcl_client)
ALTER TABLE ecs_atpnetworkpayload
    DROP CONSTRAINT fk_atpnetworkpayload;

ALTER TABLE ecs_atpauthentication DROP primary key;
ALTER TABLE ecs_atpauthentication
    ADD CONSTRAINT atpauth_pk PRIMARY KEY (region, orcl_client);
-- End

PROMPT Altering table ecs_atpauthentication
alter table ecs_atpauthentication
    add (orcl_client CHAR(1) DEFAULT 'N' CHECK (orcl_client in ('Y', 'N')));

ALTER TABLE ecs_atpvnicinfo DROP CONSTRAINT ecs_atpvnicinfo_fk;

ALTER TABLE ecs_atpvnicinfo
    ADD CONSTRAINT ecs_atpvnicinfo_fk FOREIGN KEY(dbsystem_id) REFERENCES
    ecs_atpnetworkpayload(dbsystem_id) ON DELETE CASCADE;

PROMPT Altering table ecs_atpvnicinfo
alter table ecs_atpvnicinfo
    add (subnet_fdqn   varchar2(2048));
PROMPT Altering table ecs_atpvnicinfo
alter table ecs_atpvnicinfo
    add (scanip        varchar2(512));
PROMPT Altering table ecs_atpvnicinfo
alter table ecs_atpvnicinfo
    add (vnic_nodevip  varchar2(512));
PROMPT Altering table ecs_atpvnicinfo
alter table ecs_atpvnicinfo
    add (scan_hostname varchar2(512));
PROMPT Altering table ecs_atpvnicinfo
alter table ecs_atpvnicinfo
    add (vnic_hostname varchar2(512));
PROMPT Altering table ecs_atpvnicinfo
alter table ecs_atpvnicinfo
    add (vip_hostname  varchar2(512));
PROMPT Altering table ecs_atpvnicinfo
alter table ecs_atpvnicinfo
    add (subnet_id  varchar2(2048));

PROMPT Altering table ecs_atpociendpointurl
alter table ecs_atpociendpointurl drop constraint pk_ecs_atpociendpointurl;
alter table ecs_atpociendpointurl drop column service;
alter table ecs_atpociendpointurl rename column region to realm;
alter table ecs_atpociendpointurl rename column endpoint to realmdomain;
alter table ecs_atpociendpointurl add constraint ecs_atpociendpointurl_pk primary key (realm);

-- The resource_info columns holds additional information
-- such as pdbname and job id if the resource being tracked is PDB.
-- However, these fields are optional for normal scenarios.

PROMPT Altering table ecs_emtrackingresource
alter table ecs_emtrackingresource
    add (resource_info1 varchar2(2000) default 'NoVal' not null,
         resource_info2 varchar2(2000));

alter table ecs_emtrackingresource drop constraint em_track_res_pk;
alter table ecs_emtrackingresource
    add constraint em_track_res_pk primary key (exaunit_id, db_sid, resource_info1);

alter table ecs_emtrackingresource drop constraint ecs_emres_state_ck;
alter table ecs_emtrackingresource
    add constraint ecs_emres_state_ck CHECK (EM_STATE in ('created', 'registered', 'deleted', 'not_processing', 'deleting', 'create_pending_delete', 'reconfig'));

-- em_agent is populated only for cluster and observer
alter table ecs_emtrackingresource
    add (em_agent varchar2(256));

PROMPT Altering table ecs_atpobservervmdetails
alter table ecs_atpobservervmdetails
    add (publicsshkey  varchar2(2048));

PROMPT Altering table ecs_atpobservervmdetails
alter table ecs_atpobservervmdetails
    add (compartmentid  varchar2(2048));

PROMPT Altering table ecs_atpobservervmdetails
alter table ecs_atpobservervmdetails
    add (vnicocid  varchar2(2048));

PROMPT Altering table ecs_atpobservervmdetails
alter table ecs_atpobservervmdetails
    add (privateip  varchar2(128));

PROMPT Altering table ecs_atpobservervmdetails
alter table ecs_atpobservervmdetails
    add (instancefqdn varchar2(256));

ALTER TABLE ecs_atpsubnetocid DROP CONSTRAINT ecs_atpsubnetocid_fk;

ALTER TABLE ecs_atpsubnetocid
    ADD CONSTRAINT ecs_atpsubnetocid_fk FOREIGN KEY (dbsystem_id) REFERENCES
    ecs_atpnetworkpayload(dbsystem_id) ON DELETE CASCADE;

PROMPT Altering table ecs_atpsubnetocid
alter table ecs_atpsubnetocid
    add (subnet_cidr  varchar2(512));

ALTER TABLE ecs_atptenantsubnet DROP CONSTRAINT fk_ecs_atptenantsubnet;

ALTER TABLE ecs_atptenantsubnet
    ADD CONSTRAINT fk_ecs_atptenantsubnet FOREIGN KEY(dbsystem_id) REFERENCES
    ecs_atpnetworkpayload(dbsystem_id) ON DELETE CASCADE;

-- ENH 28193584 - Add hardware tags for Iaas-Paas.
PROMPT Altering table ecs_hardware
alter table ecs_hardware
    add (tags varchar2(4000) null);

alter table ecs_hardware
    add (racktype_code varchar2(32) null);
alter table ecs_hardware
    add (description varchar2(512) null);

-- ENH 36931770 - Adding ecpu factor field
alter table ecs_hardware
    add (ecpufactor number null);

-- ENH 28096666 - CPU oversubscription
PROMPT Altering table pods
ALTER TABLE pods
    add (pool_id NUMBER);

-- Bug 28484201, 28902534 Diag table change for ECRA upgrade from 18.2.5.1EXABM
PROMPT Altering table ecs_diag_rack_info
ALTER TABLE ecs_diag_rack_info
    DROP COLUMN accessible;
ALTER TABLE ecs_diag_rack_info
    ADD status VARCHAR2(30);
ALTER TABLE ecs_diag_rack_info
    ADD host_id VARCHAR2(500);
ALTER TABLE ecs_diag_rack_info
    ADD aep_cm_enabled CHAR(1) DEFAULT 'N' NOT NULL;
ALTER TABLE ecs_diag_rack_info
    DROP CONSTRAINT ecs_diag_rack_info_chk;
ALTER TABLE ecs_diag_rack_info
    ADD CONSTRAINT ecs_diag_rack_info_chk
    CHECK (aep_cm_enabled in ('Y', 'N', 'P')) NOVALIDATE;

PROMPT Altering table ecs_diag_report
ALTER TABLE ecs_diag_report
    ADD (id NUMBER);
ALTER TABLE ecs_diag_report
    ADD CONSTRAINT ecs_diag_report_unq UNIQUE (id);

-- Enh 32322406 - Add time range and uuid in logcol history
PROMPT Altering table ecs_diag_logcol_history
ALTER TABLE ecs_diag_logcol_history
    ADD (timerange_start VARCHAR2(40));
ALTER TABLE ecs_diag_logcol_history
    ADD (timerange_end VARCHAR2(40));
ALTER TABLE ecs_diag_logcol_history
    ADD (uuid CHAR(36));
ALTER TABLE ecs_diag_logcol_history
    DROP COLUMN ecrauser;
PROMPT Creating index ecs_diag_logcol_hist_uuid_idx
CREATE INDEX ecs_diag_logcol_hist_uuid_idx
    ON ecs_diag_logcol_history(uuid);

-- Bug 28519109 - Higgs Audit Feature optimize performance and stability
PROMPT Altering table ecs_higgspredeploy
ALTER TABLE ecs_higgspredeploy
    ADD (bond0_hostnames VARCHAR(4000) null);

-- ER 28764057 - Change terraform Identity schema
PROMPT Altering table ecs_atpomvcnidentity
alter table ecs_atpomvcnidentity drop column private_key_path;
alter table ecs_atpomvcnidentity
    add (private_pem_key varchar2(4000));

-- ER 31217106 - OCI LB access using Instance Principal
alter table ecs_atpadminidentity add (domain varchar2(512));
alter table ecs_atpadminidentity add (cert_path varchar2(512));

-- ENH 28702021 - OCI Base System Support
PROMPT Altering table ecs_racks
ALTER TABLE ecs_racks
    ADD(racksize_subtype varchar2(100) null);

-- ER 28901608 - ATP get dns ips for backup interface
PROMPT Altering table ecs_atpomvcnnetwork
alter table ecs_atpomvcnnetwork
    add (name varchar2(512));
alter table ecs_atpomvcnnetwork
    add (type varchar2(512));
alter table ecs_atpomvcnnetwork
    add (domain_name varchar2(512));

PROMPT Altering table ecs_atppreprovdetails
alter table ecs_atppreprovdetails
    add (rack_shape varchar2(256));
-- Enh 32669782
alter table ecs_atppreprovdetails
    add (pre_prov_ceiocid varchar2(512));
alter table ecs_atppreprovdetails
    add (re_config_ceiocid varchar2(512));
alter table ecs_atppreprovdetails
    add (fsm_state varchar2(100));

-- ER #28843249: Add comment column for rack status
alter table ecs_racks
    add (status_comment varchar2(512));


PROMPT Altering table ecs_atppreprovdetails (changing oracle_client_vcn_security from VARCHAR2 to CLOB)
alter table ecs_atppreprovdetails add (temp CLOB);
update ecs_atppreprovdetails SET temp = oracle_client_vcn_security;
commit;
alter table ecs_atppreprovdetails drop column oracle_client_vcn_security;
alter table ecs_atppreprovdetails rename column temp to oracle_client_vcn_security;

PROMPT Altering table async_calls
alter table async_calls
    modify (type varchar2(100));
alter table async_calls
    modify (start_time varchar2(30));
alter table async_calls
    modify (end_time varchar2(30));
alter table async_calls
    modify (details varchar2(4000));
alter table async_calls
    add (last_heartbeat_update varchar2(30));
alter table async_calls
    modify (uuid varchar2(1024));
alter table async_calls
    modify (errors varchar2(4000));
alter table async_calls
    add (target_system varchar2(512));
alter table async_calls
    add (target_id varchar2(2048));
alter table async_calls
    add (ecra_server varchar2(256));

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails add image_version varchar2(64);

-- OCI-Exa related updates
-- ATP metadata
ALTER TABLE ecs_atppreprovdetails DROP CONSTRAINT fk_rackname_preprovdetails;

ALTER TABLE ecs_atppreprovdetails ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;
-- Adding column to backup dbsystemid in case we have to retry in reconfig phase with the same dbsystemid, related to bug 30087199
ALTER TABLE ecs_atppreprovdetails add (err_reconfig_dbsystemid varchar2(512));

ALTER TABLE ecs_atppreprovdetails DROP COLUMN vm_ref_count;

ALTER TABLE ecs_atpscheduledracks DROP CONSTRAINT fk_rack_name_atpscheduledracks;

ALTER TABLE ecs_atpscheduledracks ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_atpjobgroups DROP CONSTRAINT fk_rack_name_atpjobgroups;

ALTER TABLE ecs_atpjobgroups ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

-- Compose cluster metadata
ALTER TABLE ecs_ib_pkeys_used DROP CONSTRAINT ecs_ib_pkeys_used_fk;

ALTER TABLE ecs_ib_pkeys_used ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_oracle_admin_subnets DROP CONSTRAINT ecs_oracle_admin_subnets_fk1;

ALTER TABLE ecs_oracle_admin_subnets ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_domus DROP CONSTRAINT ecs_domus_ecs_racks_name_fk;

ALTER TABLE ecs_domus ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_domu_dns_masqs DROP CONSTRAINT ecs_domus_dnsmsq_ecrk_name_fk;

ALTER TABLE ecs_domu_dns_masqs ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_clusters_purge_queue DROP CONSTRAINT ecs_clusters_prgq_rakname_fk;

ALTER TABLE ecs_clusters_purge_queue ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_cluster_diskgroups DROP CONSTRAINT ecs_cls_dskgrp_rknm_fk;

ALTER TABLE ecs_cluster_diskgroups ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_database_homes DROP CONSTRAINT ecs_db_homes_rknm_fk;

ALTER TABLE ecs_database_homes ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

ALTER TABLE ecs_databases DROP CONSTRAINT ecs_db_rakname_fk;

ALTER TABLE ecs_databases ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;

-- MultiVM metadata
ALTER TABLE ecs_clusters DROP CONSTRAINT ecs_clusters_rakname_fk;

ALTER TABLE ecs_clusters ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;


-- ECS Racks
ALTER TABLE ecs_racks ADD CONSTRAINT unique_name UNIQUE(name) enable;

ALTER TABLE ECS_RACKS ADD exa_ocid varchar2(512)
                                DEFAULT 'EXISTING.PUBLIC.CLOUD.EXADATA'
                                NOT NULL NOVALIDATE;


ALTER TABLE ecs_racks ADD CONSTRAINT  fk_exa_ocid_racks
                                FOREIGN KEY (exa_ocid)
                                REFERENCES ecs_oci_exa_info(exa_ocid) NOVALIDATE;


ALTER TABLE ecs_racks ADD CONSTRAINT  pk_name_exa_ocid
                                PRIMARY KEY (name, exa_ocid) NOVALIDATE;


-- ATP metadata
ALTER TABLE ecs_atppreprovdetails ADD CONSTRAINT fk_rname_eocid_preprovdetails
                                FOREIGN KEY (rackname, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) NOVALIDATE;

ALTER TABLE ecs_atpscheduledracks ADD CONSTRAINT fk_rname_eocid_atpschedracks
                                FOREIGN KEY (rack_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) NOVALIDATE;

ALTER TABLE ecs_atpjobgroups ADD CONSTRAINT fk_rname_exaocid_atpjobgroups
                                FOREIGN KEY (rack_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) NOVALIDATE;

-- Compose cluster metadata
ALTER TABLE ecs_ib_pkeys_used ADD CONSTRAINT ecs_ib_pkeys_used_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_oracle_admin_subnets ADD CONSTRAINT ecs_oracle_admin_subnets_fk1
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_domus ADD CONSTRAINT ecs_domus_ecs_rname_exaocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_domu_dns_masqs ADD CONSTRAINT ecs_domus_dnsms_rname_eocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_clusters_purge_queue ADD CONSTRAINT ecs_clus_prgq_rname_eocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_cluster_diskgroups ADD CONSTRAINT ecs_clus_dgrp_rname_eocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_database_homes ADD CONSTRAINT ecs_db_homes_rname_eocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_databases ADD CONSTRAINT ecs_db_rname_exaocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) deferrable initially deferred;

ALTER TABLE ecs_requests ADD http_target varchar(32);

-- MultiVM metadata
ALTER TABLE ecs_clusters ADD CONSTRAINT ecs_clus_rname_exaocid_fk
                                FOREIGN KEY (ecs_racks_name, exa_ocid)
                                REFERENCES ECS_RACKS(name, exa_ocid) NOVALIDATE;

-- Oci Exadata metadata
ALTER TABLE ECS_OCI_EXA_INFO ADD
      (connectivity varchar2(32) DEFAULT 'NOT_REACHABLE' CHECK (connectivity IN ('NOT_REACHABLE', 'REACHABLE', 'UNKNOWN')),
      heartbeat_count NUMBER DEFAULT 0, -- Number of failed heartbeats
      heartbeat_lastupdate timestamp);

ALTER TABLE ECS_OCI_EXA_INFO ADD
      (last_rotation timestamp,
      rotation_status varchar2(2048));

ALTER TABLE ECS_OCI_EXA_CONTROLSERVER MODIFY PROXY varchar2(128);

ALTER TABLE ECS_OCI_EXA_CONTROLSERVER ADD
      (cps_cn varchar2(64),            -- Truncated OCID used as CPS Common Name CN which can be max 60 char long
       cps_cn_standby varchar2(64)     -- Truncated OCID ending with -s used as CPS standby Common Name CN which can be max 60 char long
      );

ALTER TABLE ecs_oci_config_bundle_details ADD cipher_passwd varchar2(16);
ALTER TABLE ecs_oci_config_bundle_details ADD cipher_salt varchar2(16);
ALTER TABLE ecs_oci_config_bundle_details ADD cipher_iv varchar2(16);

ALTER TABLE ecs_cipher_passwds ADD salt varchar2(16);
ALTER TABLE ecs_cipher_passwds ADD iv varchar2(16);

PROMPT Altering table ecs_racks
alter table ecs_racks add cabinet_id number;

PROMPT Altering table ecs_racks add constraint
alter table ecs_racks add CONSTRAINT ecs_racks_cabinet_id_fk FOREIGN KEY (cabinet_id) REFERENCES ecs_hw_cabinets(id);

PROMPT Altering table ecs_oci_config_bundle_details add columns OPENVPN_CERT_P12 CLIENT_CONFIG
alter table ecs_oci_config_bundle_details ADD ( OPENVPN_CERT_P12  BLOB NOT NULL NOVALIDATE, CLIENT_CONFIG  BLOB NOT NULL NOVALIDATE);

--- 30072527 / EXACS-23570
ALTER TABLE ecs_oci_vpn_he_info add (user_id varchar2(64));
ALTER TABLE ecs_oci_vpn_cert_info add(crl_pem_loc VARCHAR2(256));



-- CHANGES FOR  TERRAFORM VERSIONING
-- CHANGES FOR ecs_atpsubnetpool --
ALTER TABLE ecs_atpsubnetpool ADD (
    ingestion_version NUMBER default 1 NOT NULL
);
ALTER TABLE ecs_atpsubnetpool ADD (
    vcnid VARCHAR2(2048) default 'default_value_vcnid' NOT NULL
);
-- CHANGES FOR LOCK CIDR
ALTER TABLE ecs_atpsubnetpool ADD rackname varchar2(256) DEFAULT NULL;

ALTER TABLE ecs_atpsubnetpool DROP PRIMARY KEY;

ALTER TABLE ecs_atpsubnetpool
    ADD CONSTRAINT ecs_atpsubnetpool_pk PRIMARY KEY ( subnetid,
                                                      ingestion_version,
                                                      vcnid );

ALTER TABLE ecs_atpsubnetpool
    ADD CONSTRAINT ecs_atpsubnetpoolingest_fk FOREIGN KEY ( ingestion_version,
                                                            vcnid )
        REFERENCES ecs_atpterraformversion ( ingestion_version,
                                             vcnid ) NOVALIDATE;

-- CHANGES FOR ecs_atpomvcnconfigprops --
ALTER TABLE ecs_atpomvcnconfigprops ADD (
    ingestion_version NUMBER default 1 NOT NULL
);
ALTER TABLE ecs_atpomvcnconfigprops ADD (
    vcnid VARCHAR2(2048) default 'default_value_vcnid' NOT NULL
);
ALTER TABLE ecs_atpomvcnconfigprops DROP CONSTRAINT pk_ecs_atpomvcnconfigprops CASCADE;
ALTER TABLE ecs_atpomvcnconfigprops DROP CONSTRAINT FK_ECS_ATPOMVCNCONFIGPROPS;

ALTER TABLE ecs_atpomvcnconfigprops
    ADD CONSTRAINT pk_ecs_atpomvcnconfigprops PRIMARY KEY ( tenancy_ocid,
                                                            property_name,
                                                            ingestion_version,
                                                            vcnid );

ALTER TABLE ecs_atpomvcnconfigprops
    ADD CONSTRAINT ecs_atpomvcnconfig_fk FOREIGN KEY ( ingestion_version,
                                                       vcnid )
        REFERENCES ecs_atpterraformversion ( ingestion_version,
                                             vcnid ) NOVALIDATE;


-- CHANGES FOR ecs_atpomvcnresource --
ALTER TABLE ecs_atpomvcnresource ADD (
    ingestion_version NUMBER default 1 NOT NULL
);
ALTER TABLE ecs_atpomvcnresource ADD (
    vcnid VARCHAR2(2048) default 'default_value_vcnid' NOT NULL
);
ALTER TABLE ecs_atpomvcnresource DROP CONSTRAINT pk_ecs_atpomvcnresource CASCADE;
ALTER TABLE ecs_atpomvcnresource DROP CONSTRAINT FK_ECS_ATPOMVCNRESOURCE;

ALTER TABLE ecs_atpomvcnresource
    ADD CONSTRAINT pk_ecs_atpomvcnresource PRIMARY KEY ( tenancy_ocid,
                                                         id,
                                                         ingestion_version,
                                                         vcnid );
ALTER TABLE ecs_atpomvcnresource
    ADD CONSTRAINT ecs_atpomvcnresourceingest_fk FOREIGN KEY ( ingestion_version,
                                                               vcnid )
        REFERENCES ecs_atpterraformversion ( ingestion_version,
                                             vcnid ) NOVALIDATE;


--Delete constraint from whitelist
ALTER TABLE ecs_atpwhitelistsecrules DROP PRIMARY KEY CASCADE;


-- CHANGES FOR ecs_atpomvcnnetwork --
ALTER TABLE ecs_atpomvcnnetwork ADD (
    ingestion_version NUMBER default 1 NOT NULL
);
ALTER TABLE ecs_atpomvcnnetwork ADD (
    vcnid VARCHAR2(2048) default 'default_value_vcnid' NOT NULL
);


ALTER TABLE ecs_atpomvcnnetwork DROP CONSTRAINT pk_ecs_atpomvcnnetwork CASCADE;
ALTER TABLE ecs_atpomvcnnetwork DROP CONSTRAINT FK_ECS_ATPOMVCNNETWORK;

ALTER TABLE ecs_atpomvcnnetwork
    ADD CONSTRAINT pk_ecs_atpomvcnnetwork PRIMARY KEY ( tenancy_ocid,
                                                        id,
                                                        vcnid,
                                                        ingestion_version );
ALTER TABLE ecs_atpomvcnnetwork
    ADD CONSTRAINT ecs_atpomvcnnetworkingest_fk FOREIGN KEY ( ingestion_version,
                                                              vcnid )
        REFERENCES ecs_atpterraformversion ( ingestion_version,
                                             vcnid ) NOVALIDATE;


-- CHANGES FOR ecs_atpwhitelistsecrules --
ALTER TABLE ecs_atpwhitelistsecrules ADD (
    ingestion_version NUMBER default 1 NOT NULL
);
ALTER TABLE ecs_atpwhitelistsecrules ADD (
    vcnid VARCHAR2(2048) default 'default_value_vcnid' NOT NULL
);


ALTER TABLE ecs_atpwhitelistsecrules
    ADD CONSTRAINT ecs_atpwhitelistsecrules_pk PRIMARY KEY ( secrule_id,
                                                             ingestion_version,
                                                             vcnid );

ALTER TABLE ecs_atpwhitelistsecrules
    ADD CONSTRAINT fk_ecs_atpwhitelistsecrules FOREIGN KEY ( tenancy_ocid,
                                                             id,
                                                             vcnid,
                                                             ingestion_version )
        REFERENCES ecs_atpomvcnnetwork ( tenancy_ocid,
                                                              id,
                                                              vcnid,
                                                              ingestion_version );


-- CHANGES FOR ecs_atpomvcnidentity --
ALTER TABLE ecs_atpomvcnidentity ADD (
    ingestion_version NUMBER default 1 NOT NULL
);
ALTER TABLE ecs_atpomvcnidentity ADD (
    vcnid VARCHAR2(2048) default 'default_value_vcnid' NOT NULL
);
alter table ecs_atpomvcnidentity
    add (identity_type varchar2(50) default 'MGMT' not null);

alter table ecs_atpomvcnidentity
    add (passphrase varchar2(512));

ALTER TABLE ecs_atpomvcnidentity DROP PRIMARY KEY;

ALTER TABLE ecs_atpomvcnidentity
    ADD CONSTRAINT ecs_atpomvcnidentity_pk PRIMARY KEY ( tenancy_ocid,
                                                         ingestion_version,
                                                         vcnid,
                                                         identity_type );

ALTER TABLE ecs_atpomvcnidentity
    ADD CONSTRAINT ecs_atpomvcnidentityingest_fk FOREIGN KEY ( ingestion_version,
                                                               vcnid)
        REFERENCES ecs_atpterraformversion ( ingestion_version,
                                             vcnid ) NOVALIDATE;

-- END OF CHANGES FOR TERRAFORM VERSIONING

alter table ecs_kvmvlanpool drop constraint pk_ecs_kvmvlanpool;
alter table ecs_kvmvlanpool add constraint pk_ecs_kvmvlanpool primary key (fabric_id, vlan_id);
alter table ecs_kvmvlanpool drop column fault_domain_id;

alter table ecs_kvmvlanpool drop constraint ecs_kvmvlanpool_vlantype_ck;
alter table ecs_kvmvlanpool add constraint ecs_kvmvlanpool_vlantype_ck CHECK (VLANTYPE in ('COMPUTE', 'STORAGE', 'RESERVED', 'EXASCALE', 'LEFT FOR EXPANSION', 'UNAVAILABLE', 'OCI_RESERVED', 'ARISTA_INTERNAL', 'PREPROV', 'ANY'));

alter table ecs_kvmippool drop constraint ecs_kvmippool_iptype_ck;
alter table ecs_kvmippool add constraint ecs_kvmippool_iptype_ck CHECK (IPTYPE in ('COMPUTE', 'STORAGE', 'EXASCALE', 'COMPUTE-STORAGE', 'COMPUTE-EXASCALE'));
alter table ecs_kvmippool add (ipblock number default 1);
alter table ecs_kvmippool add (hostname varchar2(1024));
alter table ecs_kvmippool
    MODIFY resource_id number;
alter table ecs_kvmvlanpool
    MODIFY vlan_id number;
alter table ecs_rocefabric rename column fabric_id to fabric_name;
alter table ecs_rocefabric modify fabric_name varchar(1024);
alter table ecs_kvmvlanpool rename column fabric_id to fabric_name;
alter table ecs_kvmvlanpool modify fabric_name varchar(1024);
alter table ecs_kvmippool rename column fabric_id to fabric_name;
alter table ecs_kvmippool modify fabric_name varchar(1024);
ALTER TABLE ecs_oci_exa_info ADD ec_keys_db CLOB;


-- 30420823 / EXACS-27785
ALTER TABLE ecs_oci_vpn_cert_info add(vpn_proxy_cert BLOB);
ALTER TABLE ecs_oci_vpn_cert_info add(vpn_proxy_key BLOB);
ALTER TABLE ecs_oci_vpn_cert_info add(cps_proxy_cert BLOB);
ALTER TABLE ecs_oci_vpn_cert_info add(tls_auth_key BLOB);
ALTER TABLE ecs_oci_vpn_cert_info add(cps_proxy_key BLOB);

-- 30431339
ALTER TABLE ecs_oci_vpn_cert_info add(patchsvr_cert BLOB);
ALTER TABLE ecs_oci_vpn_cert_info add(patchsvr_key BLOB);


ALTER TABLE ecs_atpterraformversion ADD file_path varchar2(1024);

-- 0582057 / EXACS-29378
ALTER TABLE ecs_oci_exa_controlserver MODIFY (PROXY NULL);


-- OCI-ExaCC MVM updates
PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info ADD
      rack_basename varchar2(512);

PROMPT Altering table ecs_oci_exa_info
-- Record the rackname for given OCID which has ongoing infra operation
ALTER TABLE ecs_oci_exa_info ADD
      infra_update_on_rack varchar2(256);

PROMPT Altering table ecs_exaservice
ALTER TABLE ecs_exaservice RENAME COLUMN storagetb TO storagegb;

ALTER TABLE ecs_oci_vpn_cert_info add(vpn_proxy_key BLOB);

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info ADD atp varchar2(1)
		DEFAULT 'N'
		NOT NULL NOVALIDATE;
ALTER TABLE ecs_oci_exa_info ADD status varchar2(24)
		DEFAULT 'READY';

PROMPT Altering table ecs_exaservice_reserved_alloc
ALTER TABLE ecs_exaservice_reserved_alloc DROP CONSTRAINT fk_ecs_rnameocid_res_alloc;

ALTER TABLE ecs_exaservice_reserved_alloc ADD CONSTRAINT fk_ecs_rnameocid_res_alloc
          FOREIGN KEY (rackname)
          REFERENCES ECS_RACKS(name);

ALTER TABLE ecs_exaservice_reserved_alloc
          ADD node_wise_allocations VARCHAR2(2048);

PROMPT Altering table ecs_exaservice_allocations
ALTER TABLE ecs_exaservice_allocations
          ADD node_wise_allocations VARCHAR2(2048);

PROMPT Altering table ecs_cores
ALTER TABLE ecs_cores ADD (
    rackname varchar2(256),
    dom0 varchar2(500)
);

PROMPT Altering table ecs_cores
ALTER TABLE ecs_cores
    ADD CONSTRAINT ecs_cores_rackname_fk
        FOREIGN KEY(rackname)
        REFERENCES ecs_racks(name);

ALTER TABLE ecs_cores ADD (
    backuptimestamp varchar2(36)
);

ALTER TABLE ecs_cores ADD (
    backupstatus CLOB
);

ALTER TABLE ecs_hw_nodes ADD (
    localbackupenabled CHAR(1) DEFAULT 'Y' NOT NULL,
    ossbackupenabled CHAR(1) DEFAULT 'Y' NOT NULL
);

ALTER TABLE ecs_hw_nodes add (exasplice_version varchar2(128));

ALTER TABLE ecs_atpadminidentity add private_key_content varchar2(4000);

ALTER TABLE ecs_oci_exa_info ADD headendtype varchar2(64);

PROMPT Altering table ecs_racks
ALTER TABLE ecs_racks
    ADD vm_cluster_ocid varchar(512)
        DEFAULT NULL;

PROMPT Altering table ecs_exadata_vcompute_node
ALTER TABLE ecs_exadata_vcompute_node
    DROP CONSTRAINT pk_vcomp_hostname;
ALTER TABLE ecs_exadata_vcompute_node ADD (vm_state varchar2(50) DEFAULT NULL);
ALTER TABLE ecs_exadata_vcompute_node ADD last_vm_state_change_time TIMESTAMP;

ALTER TABLE ecs_exadata_vcompute_node
    ADD CONSTRAINT pk_vcomp_eu_hname
    PRIMARY KEY (exaunit_id, hostname);

ALTER TABLE ecs_oci_config_bundle_details ADD config_bundle_prev_version BLOB;

PROMPT Altering table ecs_domukeysinfo
ALTER TABLE ecs_domukeysinfo ADD (
    domu varchar2(500));

ALTER TABLE ecs_exadata_vcompute_node
    ADD hostname_customer varchar(512);

ALTER TABLE ecs_nat_vip_host add nat_vip_hostname varchar2(128) not null;

-- Add exasplice version to ecs_exa_applied_patches table
PROMPT Altering table ecs_exa_applied_patches
alter table ecs_exa_applied_patches
    add (exasplice_version varchar2(512));

-- Add exacloud child uuid to ecs_exa_applied_patches table
PROMPT Altering table ecs_exa_applied_patches
alter table ecs_exa_applied_patches
    add (child_uuid varchar2(2048));

-- Add exacloud dispatcher uuid to ecs_exa_applied_patches table
PROMPT Altering table ecs_exa_applied_patches
alter table ecs_exa_applied_patches
    add (dispatcher_uuid varchar2(2048));

-- Enh 36696921 - modify error_msg column in ecs_exa_applied_patches
PROMPT Altering table ecs_exa_applied_patches
alter table ecs_exa_applied_patches
    modify (error_msg varchar2(4000));

-- Add rack model (like X8-2, X6-2 etc) number to ecs_exadata_patch_versions
PROMPT Altering table ecs_exadata_patch_versions
alter table ecs_exadata_patch_versions drop constraint pk_exadata_patch_versions;
ALTER TABLE ecs_exadata_patch_versions ADD (rack_model varchar2(100) DEFAULT 'NOMODEL' NOT NULL);
alter table ecs_exadata_patch_versions add constraint pk_exadata_patch_versions primary key (service_type ,patch_type,target_type, rack_model );

-- Add network_ocid column to ecs_racks table
PROMPT Altering table ecs_racks
alter table ecs_racks
    add (network_ocid varchar2(512));

PROMPT Altering table ecs_racks
ALTER TABLE ecs_racks
    ADD (pre_logcol CHAR(1) DEFAULT 'N' CHECK (pre_logcol IN ('Y', 'N')));

alter table ecs_ib_fabrics
    add CONSTRAINT ecs_ib_fabrics_FK
    FOREIGN KEY (fabric_name) references  ecs_rocefabric(fabric_name);

PROMPT Altering table ecs_oci_config_bundle_details
alter table ecs_oci_config_bundle_details modify ( OPENVPN_CERT_P12 NULL);
alter table ecs_oci_config_bundle_details modify ( CLIENT_CONFIG NULL);

alter table ecs_idemtokens add response CLOB;

PROMPT Altering table ecs_exadata_vcompute_node
ALTER TABLE ecs_exadata_vcompute_node
     DROP CONSTRAINT fk_vcomp_exacompute_hostname;

PROMPT Altering table ecs_requests
ALTER TABLE ecs_requests ADD component_response CLOB;

PROMPT Altering table ecs_cloudvnuma_tenancy
ALTER TABLE ecs_cloudvnuma_tenancy ADD (jumbo_frames varchar2(512));
ALTER TABLE ecs_cloudvnuma_tenancy MODIFY (cloud_vnuma null);
ALTER TABLE ecs_cloudvnuma_tenancy add (memoryconfig varchar2(128) default 'STANDARD');
-- Enh 36576562 - Adding Early Adopter feature
ALTER TABLE ecs_cloudvnuma_tenancy add (early_adopter varchar2(1) DEFAULT ON NULL 'N');

PROMPT Altering table exaunit_info
ALTER TABLE exaunit_info
    ADD (exacc_migration CHAR(1) DEFAULT 'N' CHECK (exacc_migration in ('N', 'I', 'D')));
ALTER TABLE exaunit_info
    ADD (exacc_rehome CHAR(1) DEFAULT 'N' CHECK (exacc_rehome in ('N', 'I', 'D')));


ALTER TABLE exaunit_info
    ADD (ecra_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info
    ADD (exacloud_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info
    ADD (oeda_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info
    ADD (dbaas_version VARCHAR2(64) DEFAULT NULL);
ALTER TABLE exaunit_info ADD (deconfigured char(1) DEFAULT 'N' CHECK (deconfigured in ('N', 'Y')));

PROMPT Altering ECS_OH_SPACE_RULE
ALTER TABLE ECS_OH_SPACE_RULE
    ADD MAX_OHSIZE_PER_NODE NUMBER;
PROMPT Altering table ecs_oh_space_rule;
ALTER TABLE ecs_oh_space_rule add (env varchar2(20) DEFAULT ON NULL 'bm' NOT NULL);
ALTER TABLE ecs_oh_space_rule drop constraint OH_SPACE_RULE_PK;
ALTER TABLE ecs_oh_space_rule add CONSTRAINT "OH_SPACE_RULE_PK" PRIMARY KEY ("MODEL", "RACKSIZE", "PHYSICALSPACEINGB","ENV");



PROMPT Altering table ecs_oci_exa_info for adding oci_upgrade and oci_upgrade_status columns
ALTER TABLE ecs_oci_exa_info
    ADD (oci_upgrade_status CHAR(1) DEFAULT 'N' CHECK (oci_upgrade_status in ('N', 'I', 'D', 'O')));

PROMPT Altering table ecs_oci_networks for adding oci_upgrade and oci_upgrade_status columns
ALTER TABLE ecs_oci_networks
    ADD (oci_upgrade_status CHAR(1) DEFAULT 'N' CHECK (oci_upgrade_status in ('N', 'I', 'D', 'O')));

PROMPT Altering table ecs_oci_exa_info for adding oci_rehome and oci_rehome_status columns
ALTER TABLE ecs_oci_exa_info
    ADD (oci_rehome_status CHAR(1) DEFAULT 'N' CHECK (oci_rehome_status in ('N', 'I', 'D', 'O')));

ALTER TABLE ecs_oci_exa_info 
    ADD oci_rehome_uuid VARCHAR2(36) DEFAULT NULL;

ALTER TABLE ecs_oci_exa_info ADD migration_wss_status varchar2(64);

PROMPT Altering async_calls for changing the details field from varchar to clob
alter table async_calls add (tmp_details clob);
update async_calls set tmp_details=details;
alter table async_calls rename column details to details_tmp;
alter table async_calls rename column tmp_details  to details;
alter table async_calls rename column details_tmp to resource_id;
alter table async_calls drop column tmp_details;
alter table async_calls drop column details_tmp;

ALTER TABLE ecs_hw_elastic_nodes ADD (
oracle_gateway varchar2(64),
oracle_netmask varchar2(64),
oracle_ilom_gateway varchar2(64),
oracle_ilom_netmask varchar2(64),
oracle_admin_domain_name varchar2(64),
oracle_ilom_domain_name varchar2(64)
);

-- Enh 36334590 - Adding column ecs_hw_elastic_nodes to save extra information of archive nodes
ALTER TABLE ECS_HW_ELASTIC_NODES ADD EXTRA_ARCHIVE_INFO BLOB;
--Enh 37025371 - EXACC X11M Support for compute standard/large and extra large
ALTER TABLE ECS_HW_ELASTIC_NODES ADD (model_subtype varchar2(64) DEFAULT ON NULL 'STANDARD' NOT NULL);

PROMPT Altering ecs_cipher_passwds
ALTER TABLE ecs_cipher_passwds DROP salt;
ALTER TABLE ecs_cipher_passwds DROP iv;

PROMPT Altering ECS_SCHEDULED_ONDEMAND_EXEC
ALTER TABLE ECS_SCHEDULED_ONDEMAND_EXEC
    ADD JSONPAYLOAD varchar2(2048);

PROMPT Altering ecs_atpobservervmdetails for changing user_data from varchar to clob
alter table ecs_atpobservervmdetails add tempuserdata clob;
update ecs_atpobservervmdetails set tempuserdata=user_data;
update ecs_atpobservervmdetails set user_data=null;
alter table ecs_atpobservervmdetails modify user_data long;
alter table ecs_atpobservervmdetails modify user_data clob;
update ecs_atpobservervmdetails set user_data=tempuserdata;
alter table ecs_atpobservervmdetails drop column tempuserdata;

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info ADD
      (shut_on_zero_core varchar2(5) DEFAULT 'TRUE' CHECK (shut_on_zero_core IN ('FALSE', 'TRUE')));

PROMPT Altering table ecs_ceidetails
ALTER TABLE ecs_elastic_ceidetails RENAME TO ecs_ceidetails;
ALTER TABLE ecs_ceidetails ADD fsm_state varchar2(100);
ALTER TABLE ecs_ceidetails ADD constraint ECS_RACK_NAME_FK FOREIGN KEY (rackname) REFERENCES ecs_racks(name);
ALTER TABLE ecs_ceidetails ADD provisiontype varchar2(64);
alter table ecs_ceidetails drop constraint pk_ecs_elastic_ceidetails;
alter table ecs_ceidetails add constraint pk_ecs_elastic_ceidetails primary key ( ceiocid );
ALTER TABLE ecs_ceidetails ADD vm_ref_count number DEFAULT 0;
ALTER TABLE ecs_ceidetails ADD storage_vlan number;
ALTER TABLE ecs_ceidetails ADD multivm varchar(8) DEFAULT 'false' CHECK (multivm IN ('true', 'false'));
ALTER TABLE ecs_ceidetails ADD model varchar2(8);
ALTER TABLE ecs_ceidetails ADD tenancyname varchar2(128);
ALTER TABLE ecs_ceidetails ADD tenancyocid varchar2(512);

-- ENH 37071580 - Adding new fieds to keep node subtype at Infra Level
ALTER TABLE ecs_ceidetails ADD compute_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;
ALTER TABLE ecs_ceidetails ADD cell_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;

ALTER TABLE ecs_ceidetails DROP CONSTRAINT 
  ck_ecs_ceidetails_compute_subtype;

ALTER TABLE ecs_ceidetails ADD
      CONSTRAINT ck_ecs_ceidetails_compute_subtype
        CHECK (compute_subtype in
             ('BASE',
              'STANDARD',
              'LARGE',
              'EXTRALARGE'));

ALTER TABLE ecs_ceidetails DROP CONSTRAINT     
  ck_ecs_ceidetails_cell_subtype;

ALTER TABLE ecs_ceidetails ADD 
      CONSTRAINT ck_ecs_ceidetails_cell_subtype
        CHECK (cell_subtype in
             ('BASE',
              'Z',
              'X-Z',
              'STANDARD',
              'EF'));

ALTER TABLE ecs_oci_networks ADD network_validation_error clob;


PROMPT Altering table ecs_atpjobsmetadata

ALTER TABLE ecs_atpjobsmetadata ADD (job_category varchar2(100) DEFAULT 'NON-URM');
alter table ecs_atpjobsmetadata drop constraint pk_ecs_atpjobsmetadata;
alter table ecs_atpjobsmetadata add constraint pk_ecs_atpjobsmetadata primary key (rack_status, job_category);
ALTER TABLE ecs_atpjobsmetadata ADD (enabled varchar2(5) DEFAULT 'true' NOT NULL);
ALTER TABLE ecs_atpjobsmetadata DROP constraint chk_enabledvalues;
ALTER TABLE ecs_atpjobsmetadata ADD constraint chk_enabledvalues CHECK (enabled='true' OR enabled='false');

PROMPT Altering table ecs_cipher_passwds
alter table ecs_cipher_passwds modify(CIPHER_PASSWD ENCRYPT NO SALT);

PROMPT Altering table ecs_oci_config_bundle_details
alter table ecs_oci_config_bundle_details  modify(CIPHER_PASSWD ENCRYPT NO SALT);

PROMPT Altering ECS_MDBCS_PATCHING
ALTER TABLE ECS_MDBCS_PATCHING ADD start_time TIMESTAMP;
ALTER TABLE ECS_MDBCS_PATCHING ADD last_update TIMESTAMP;

PROMPT Altering table ecra_info
 alter table ecra_info add dbaas_version varchar2(50);
 alter table ecra_info add exacloud_version varchar2(20);
 alter table ecra_info add oeda_version varchar2(20);
 alter table ecra_info add label varchar2(50);
 alter table ecra_info add upgrade_type varchar2(128);
 alter table ecra_info add end_time TIMESTAMP;
 alter table ecra_info add start_time TIMESTAMP;
 alter table ecra_info modify uri NULL;
 alter table ecra_info modify authid NULL;
 alter table ecra_info drop CONSTRAINT FK_AUTHID;

PROMPT Altering ECS_REQUESTS
ALTER TABLE ECS_REQUESTS ADD retry_count NUMBER;

PROMPT Altering ecs_scheduled_ondemand_exec
ALTER TABLE ecs_scheduled_ondemand_exec ADD target_resource VARCHAR2(512);
ALTER TABLE ecs_scheduled_ondemand_exec ADD parent_req_id VARCHAR2(64);
ALTER TABLE ecs_scheduled_ondemand_exec DROP CONSTRAINT CK_ECS_SCHD_ONDEMAND_EXEC_STS;
ALTER TABLE ecs_scheduled_ondemand_exec ADD CONSTRAINT CK_ECS_SCHD_ONDEMAND_EXEC_STS CHECK (status in ('QUEUED', 'WAIT_AND_RETRY', 'PROCESSING', 'PROCESSED', 'FAILED', 'CANCELLED'));

PROMPT Altering ecs_hw_cabinets
alter table ecs_hw_cabinets add temp_room varchar2(64);
update ecs_hw_cabinets set temp_room=canonical_room;
alter table ecs_hw_cabinets drop column CANONICAL_ROOM;
alter table ecs_hw_cabinets rename column TEMP_ROOM to CANONICAL_ROOM;
commit;

PROMPT Altering elastic_node_attach_jobs
ALTER TABLE elastic_node_attach_jobs DROP CONSTRAINT CK_ELASTIC_NODE_ATT_JOBS_STS;
ALTER TABLE elastic_node_attach_jobs ADD CONSTRAINT CK_ELASTIC_NODE_ATT_JOBS_STS CHECK (status in ('PENDING', 'PROCESSING', 'PASSED', 'FAILED', 'CANCELLED'));

PROMPT Altering table ecs_selinux_policies
alter table ecs_selinux_policies drop constraint ecs_selinux_policies;
alter table ecs_selinux_policies add constraint ecs_selinux_policies primary key (component,hostname,policy_name);

PROMPT Altering table ecs_oci_networknodes
alter table ecs_oci_networknodes add compute_node_alias varchar2(256);
PROMT Altering table ecs_hw_nodes
alter table ecs_hw_nodes add admin_mac varchar2(30);
alter table ecs_hw_nodes add serial_number varchar2(20);
alter table ecs_hw_nodes rename column serial_number to node_serial_number;

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails ADD (isDataPlaneEnabled varchar2(5) default 'FALSE' check (isDataPlaneEnabled in ('TRUE', 'FALSE')));

PROMPT Altering table ecs_oci_exa_info
alter table ecs_oci_exa_info ADD compartment_ocid varchar2(512);

PROMPT Altering table ecs_gold_specs
alter table ecs_gold_specs modify expected varchar2(2048);
alter table ecs_gold_specs modify current_value varchar2(2048);

PROMPT Altering table ecs_gold_specs
--Enh 35435659 - ECRA FS
alter table ecs_gold_specs add mutable varchar2(16) default 'false';


PROMPT Altering table ecs_selinux_data
alter table ecs_selinux_data add network_communication varchar2(16);

PROMPT Altering table ecs_gold_specs
-- Enh 33310154 for MvM
alter table ecs_hw_cabinets add mvm_domainname varchar2(512);
alter table ecs_hw_cabinets add mvm_subnet_id varchar2(4000);

PROMPT Altering table ecs_exadata_formation
alter table ecs_exadata_formation add specs CLOB;

-- Bug 34552781 - unique constraint ALIAS_UNIQ_PER_EXADATA violated

ALTER TABLE ecs_exadata_compute_node DROP CONSTRAINT alias_uniq_per_exadata;
ALTER TABLE ecs_exadata_compute_node ADD CONSTRAINT alias_uniq_per_exadata UNIQUE (exadata_id, aliasname) deferrable initially deferred;

--VIEWS


CREATE OR REPLACE EDITIONABLE VIEW ecs_oh_space_rule_filtered AS
SELECT
    MODEL,
    RACKSIZE,
    PHYSICALSPACEINGB,
    USEABLEOHSPACEINGB,
    MAX_OHSIZE_PER_NODE,
    ENV
FROM
    ecs_oh_space_rule
WHERE
    ENV = (SELECT NVL((SELECT VALUE FROM ECS_PROPERTIES WHERE NAME = 'ECRA_ENV'
      AND ROWNUM = 1),'bm') FROM DUAL);


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
    (exaunit.gb_ohsize ) AS oracle_home
FROM ecs_exadata_vcompute_node vcompute
    LEFT JOIN ecs_exadata_compute_node ON substr(vcompute.exacompute_hostname,0,instr(vcompute.exacompute_hostname,'.')-1) = ecs_exadata_compute_node.inventory_id
    LEFT JOIN ecs_exaunitdetails exaunit ON vcompute.exaunit_id = exaunit.exaunit_id
ORDER BY vcompute.exaunit_id;


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
FROM ecs_hardware hardware, ecs_hw_nodes nodes, ecs_exadata_compute_node compute
    LEFT JOIN ecs_v_mvm_domus vdomu ON compute.inventory_id = vdomu.node,
    (SELECT model, racksize, MAX(useableohspaceingb) AS useableohspaceingb FROM ecs_oh_space_rule_filtered GROUP BY model, racksize) oh
WHERE
    compute.exaservice_id IS NOT NULL
    AND hardware.model=nodes.node_model
    AND hardware.env = 'bm'
    AND hardware.racksize= CASE WHEN nodes.model_subtype = 'STANDARD' THEN 'ELASTIC' ELSE nodes.model_subtype END
    AND oh.model = nodes.node_model
    AND oh.racksize = 'ALL'
    AND compute.inventory_id=nodes.oracle_hostname
GROUP BY compute.inventory_id,hardware.maxcorespernode, hardware.memsize, oh.useableohspaceingb, compute.aliasname, compute.hostname;


CREATE OR REPLACE VIEW ecs_v_mvm_exaservice AS
SELECT
    exa.id ,
    CASE WHEN SUM(domus.cores) IS NULL THEN 0 ELSE SUM(domus.cores) END AS allocated_cores,
    CASE WHEN SUM(domus.memory) IS NULL THEN 0 ELSE SUM(domus.memory) END allocated_memory,
    CASE WHEN SUM(domus.oracle_home) IS NULL THEN 0 ELSE SUM(domus.ORACLE_HOME) END allocated_oh
FROM ecs_exaservice exa
    LEFT JOIN ecs_v_mvm_domus domus ON exa.id = domus.exaservice_id
GROUP BY exa.id;


PROMPT Altering ecs_exaservice_reserved_alloc for changing the node_wise_allocations field from varchar to clob
alter table ecs_exaservice_reserved_alloc add (tmp_node_wise_allocations clob);
update ecs_exaservice_reserved_alloc set tmp_node_wise_allocations=node_wise_allocations;
alter table ecs_exaservice_reserved_alloc rename column node_wise_allocations to bak_node_wise_allocations;
alter table ecs_exaservice_reserved_alloc rename column tmp_node_wise_allocations to node_wise_allocations;
alter table ecs_exaservice_reserved_alloc drop column bak_node_wise_allocations;
alter table ecs_exaservice_reserved_alloc add reserve_type varchar2(64);

PROMPT Altering ecs_exaservice_allocations for changing the node_wise_allocations field from varchar to clob
alter table ecs_exaservice_allocations add (tmp_node_wise_allocations clob);
update ecs_exaservice_allocations set tmp_node_wise_allocations=node_wise_allocations;
alter table ecs_exaservice_allocations rename column node_wise_allocations to bak_node_wise_allocations;
alter table ecs_exaservice_allocations rename column tmp_node_wise_allocations to node_wise_allocations;
alter table ecs_exaservice_allocations drop column bak_node_wise_allocations;

PROMPT Altering table exacc_exaksplice_info
alter table exacc_exaksplice_info rename column exasplice_update_activated_date to exspl_updt_activated_date;

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info DROP column event_time_sent_last;
ALTER TABLE ecs_oci_exa_info ADD (event_process_time varchar2(256) default '0');

PROMPT Altering table ecs_fs_encryption
alter table ecs_fs_encryption modify bucket_namespace DEFAULT NULL;
alter table ecs_fs_encryption modify target_filesystems DEFAULT 'all';
alter table ecs_fs_encryption add vault_id varchar(128);
alter table ecs_fs_encryption add secret_compartment_id varchar(128);
alter table ecs_fs_encryption drop constraint pk_ecs_fs_encyption;
alter table ecs_fs_encryption add constraint pk_ecs_fs_encyption PRIMARY KEY(customer_tenancy_id,infra_component,vault_id);

PROMPT Renaming table ecs_oci_cell_last_ip_cidr to ecs_oci_infranode_last_ips
RENAME ecs_oci_cell_last_ip_cidr TO ecs_oci_infranode_last_ips

PROMPT Altering table ecs_oci_networknodes
alter table ecs_oci_networknodes add state varchar2(24)
      CONSTRAINT ecs_oci_networknodes_state
      CHECK (state in ('READY', 'AWATING_ACTIVATION', 'ACTIVATION_ERR', 'ATTACHED'));

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info ADD events_sent_in_heartbeat CLOB;

PROMPT Altering table exacc_availimages_info
alter TABLE exacc_availimages_info ADD (dwnld_tsp varchar2(512));
update exacc_availimages_info SET dwnld_tsp = download_timestamp;
alter table exacc_availimages_info drop column download_timestamp;
alter table exacc_availimages_info rename column dwnld_tsp to download_timestamp;
alter TABLE exacc_availimages_info ADD (updt_tsp varchar2(512));
update exacc_availimages_info SET updt_tsp = updated_timestamp;
alter table exacc_availimages_info drop column updated_timestamp;
alter table exacc_availimages_info rename column updt_tsp to updated_timestamp;

PROMPT Altering table exacc_cpstuner_patches
alter TABLE exacc_cpstuner_patches ADD (bugid_tmp varchar2(512));
update exacc_cpstuner_patches SET bugid_tmp = bug_id;
alter table exacc_cpstuner_patches drop column bug_id;
alter table exacc_cpstuner_patches rename column bugid_tmp to bug_id;
alter TABLE exacc_cpstuner_patches ADD (dwnld_tsp varchar2(512));
update exacc_cpstuner_patches SET dwnld_tsp = download_timestamp;
alter table exacc_cpstuner_patches drop column download_timestamp;
alter table exacc_cpstuner_patches rename column dwnld_tsp to download_timestamp;
alter TABLE exacc_cpstuner_patches ADD (exe_tsp varchar2(512));
update exacc_cpstuner_patches SET exe_tsp = execution_timestamp;
alter table exacc_cpstuner_patches drop column execution_timestamp;
alter table exacc_cpstuner_patches rename column exe_tsp to execution_timestamp;
alter TABLE exacc_cpstuner_patches ADD (updt_tsp varchar2(512));
update exacc_cpstuner_patches SET updt_tsp = updated_timestamp;
alter table exacc_cpstuner_patches drop column updated_timestamp;
alter table exacc_cpstuner_patches rename column updt_tsp to updated_timestamp;

PROMPT Altering table exacc_sw_versions
alter TABLE exacc_sw_versions ADD (updt_tsp varchar2(512));
update exacc_sw_versions SET updt_tsp = updated_timestamp;
alter table exacc_sw_versions drop column updated_timestamp;
alter table exacc_sw_versions rename column updt_tsp to updated_timestamp;


PROMPT Altering table exacc_nodemisc_info
alter TABLE exacc_nodemisc_info ADD (updt_tsp varchar2(512));
update exacc_nodemisc_info SET updt_tsp = updated_timestamp;
alter table exacc_nodemisc_info drop column updated_timestamp;
alter table exacc_nodemisc_info rename column updt_tsp to updated_timestamp;

PROMPT Altering table exacc_nodeimg_versions
alter TABLE exacc_nodeimg_versions ADD (img_actdate varchar2(512));
update exacc_nodeimg_versions SET img_actdate = image_activation_date;
alter table exacc_nodeimg_versions drop column image_activation_date;
alter table exacc_nodeimg_versions rename column img_actdate to image_activation_date;
alter TABLE exacc_nodeimg_versions ADD (updt_tsp varchar2(512));
update exacc_nodeimg_versions SET updt_tsp = updated_timestamp;
alter table exacc_nodeimg_versions drop column updated_timestamp;
alter table exacc_nodeimg_versions rename column updt_tsp to updated_timestamp;


PROMPT Altering table exacc_exaksplice_info
alter TABLE exacc_exaksplice_info ADD (exspk_update varchar2(512));
update exacc_exaksplice_info SET exspk_update = exspl_updt_activated_date;
alter table exacc_exaksplice_info drop column exspl_updt_activated_date;
alter table exacc_exaksplice_info rename column exspk_update to exspl_updt_activated_date;
alter TABLE exacc_exaksplice_info ADD (updt_tsp varchar2(512));
update exacc_exaksplice_info SET updt_tsp = updated_timestamp;
alter table exacc_exaksplice_info drop column updated_timestamp;
alter table exacc_exaksplice_info rename column updt_tsp to updated_timestamp;


PROMPT Altering table exacc_exception_racks
alter TABLE exacc_exception_racks ADD (cps_tmp varchar2(512));
update exacc_exception_racks SET cps_tmp = cps_push;
alter table exacc_exception_racks drop column cps_push;
alter table exacc_exception_racks rename column cps_tmp to cps_push;
alter TABLE exacc_exception_racks ADD (updt_tsp varchar2(512));
update exacc_exception_racks SET updt_tsp = updated_timestamp;
alter table exacc_exception_racks drop column updated_timestamp;
alter table exacc_exception_racks rename column updt_tsp to updated_timestamp;
alter table exacc_exception_racks rename column RACK_SERIAL_NUMBER to exa_ocid;

PROMPT Altering table ecs_gold_specs
ALTER TABLE ecs_gold_specs DROP CONSTRAINT chk_type;
ALTER TABLE ecs_gold_specs
    ADD CONSTRAINT chk_type
        CHECK (type IN ('exacs', 'adbd','adbs','exacsmvm','exacsminspec','exacsmvmminspec','adbdmvm','fa','exacsexacompute','exacc','exaccadbd','exaccmvm','exaccadbdmvm','exacsexacompute19c'));

alter table ecs_gold_specs modify type VARCHAR2(32);

alter table ecs_oci_networknodes modify IP VARCHAR2(32) null;
alter table ecs_oci_networknodes modify HOSTNAME VARCHAR2(512) null;
alter table ecs_oci_networknodes modify DOMAINNAME VARCHAR2(512) null;

PROMPT Renaming table ecs_oci_cell_last_ip_cidr to ecs_oci_infranode_last_ips
RENAME ecs_oci_cell_last_ip_cidr TO ecs_oci_infranode_last_ips;

PROMPT Altering table ecs_secretvaultinfo
alter table ecs_secretvaultinfo drop column secret_name;
alter table ecs_secretvaultinfo drop column secret_id;
alter table ecs_secretvaultinfo add (vault_name varchar2(2048));
alter table ecs_secretvaultinfo add (secrets varchar2(4000));

PROMPT Altering table ecs_oci_networknodes
alter table ecs_oci_networknodes add vmid varchar2(256);
alter table ecs_oci_networknodes add mac varchar2(256);
alter table ecs_oci_networknodes add standby_vnic_mac varchar2(256);

PROMPT Altering table ecs_domus
alter table ecs_domus add vmid varchar2(256);
alter table ecs_domus add customer_client_mac varchar2(256);
alter table ecs_domus add customer_client_vlantag number;
alter table ecs_domus add customer_client_mtu number;
alter table ecs_domus add customer_backup_mac varchar2(256);
alter table ecs_domus add customer_backup_vlantag number;
alter table ecs_domus add customer_backup_mtu number;

alter table ecs_domus add cus_client_standbyvnicmac varchar2(256);
alter table ecs_domus add cus_backup_standbyvnicmac varchar2(256);
alter table ecs_domus add image_version varchar2(64);

alter table ecs_domus add db_client_vip_v6 varchar2(256);
alter table ecs_domus add db_client_vip_v6netmask varchar2(256);
alter table ecs_domus add db_client_vip_v6gateway varchar2(256);
alter table ecs_domus add db_client_ipv6 varchar2(256);
alter table ecs_domus add db_client_v6gateway varchar2(256);
alter table ecs_domus add db_client_v6netmask varchar2(256);
alter table ecs_domus add db_backup_ipv6 varchar2(256);
alter table ecs_domus add db_backup_v6gateway varchar2(256);
alter table ecs_domus add db_backup_v6netmask varchar2(256);

PROMPT Altering table ecs_temp_domus
alter table ecs_temp_domus add (admin_vlan_tag varchar2(8));
alter table ecs_temp_domus DROP CONSTRAINT ecs_tdomus_hw_node_id_pk CASCADE;

alter table ecs_temp_domus
    add constraint ecs_tdomus_hw_node_id_pk PRIMARY KEY (hw_node_id,admin_nat_host_name);


-- ENH 33969007 network speed
PROMPT Altering table ecs_hardware
alter table ecs_hardware
    add (gbclientnetspeed number null);
alter table ecs_hardware
    add (gbrocenetspeed number null);
alter table ecs_hardware
    drop constraint HARDWARE_PK;
alter table ecs_hardware
    add CONSTRAINT "HARDWARE_PK" PRIMARY KEY ("MODEL", "RACKSIZE", "ENV");

PROMPT Altering table ecs_requests
alter table ecs_requests add (progress_percent NUMBER default 0);

PROMPT Altering table ecs_requests
alter table ecs_requests add (step_progress_details clob);

alter table ecs_oci_networknodes modify STATE DEFAULT 'AWATING_ACTIVATION';

-- Enh 33817649 - For storing ECRA and EC payloads
PROMPT Altering table pods (changing pod_payload from VARCHAR2 to CLOB)
alter table pods add (temp CLOB);
update pods SET temp = pod_payload;
commit;
alter table pods drop column pod_payload;
alter table pods rename column temp to pod_payload;

PROMPT Altering table pods (changing pod_payload2 from VARCHAR2 to CLOB)
alter table pods add (temp CLOB);
update pods SET temp = pod_payload2;
commit;
alter table pods drop column pod_payload2;
alter table pods rename column temp to pod_payload2;

PROMPT Altering table ecs_exaunitdetails
alter table ecs_exaunitdetails ADD (notifications_enabled varchar2(5) default 'FALSE' check (notifications_enabled in ('TRUE', 'FALSE')));
alter table ecs_exaunitdetails ADD (autolog_enabled varchar2(5) default 'FALSE' check (autolog_enabled in ('TRUE', 'FALSE')));
alter table ecs_exaunitdetails ADD (monitoring_enabled varchar2(5) default 'FALSE' check (monitoring_enabled in ('TRUE', 'FALSE')));

PROMPT Altering table ecs_oci_infranode_last_ips
alter table ecs_oci_infranode_last_ips ADD (admin_netmask varchar2(15));
alter table ecs_oci_infranode_last_ips ADD (clib_netmask varchar2(15));
alter table ecs_oci_infranode_last_ips ADD (stib_netmask varchar2(15));

PROMPT Altering table ecs_requests
alter table ecs_requests add (progress_percent NUMBER default 0);

PROMPT Altering table wf_server
alter table wf_server add (hostname varchar2(128));

PROMPT Altering table ecs_customvip
alter table ecs_customvip
    add (mac varchar(64));

-- Enh 34166256 - Add tenancy info to SLA records
PROMPT Altering table ecs_sla_records (adding tenancy and compartment info)
ALTER TABLE ecs_sla_records ADD (tenancy_ocid VARCHAR2(256));
ALTER TABLE ecs_sla_records ADD (compartment_ocid VARCHAR2(256));
ALTER TABLE ecs_sla_records ADD (cei_id VARCHAR2(256));
ALTER TABLE ecs_sla_records ADD (tenant_name VARCHAR2(256));

-- exacs-129303: change VMCLUSER_NAMES to VARCHAR2(4000) to support 64 vms per compute
ALTER TABLE ecs_sla_server_records MODIFY VMCLUSTER_NAMES VARCHAR2(4000);

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info DROP COLUMN shut_on_zero_core;
ALTER TABLE ecs_oci_exa_info ADD (exception_ops varchar2(512));

PROMPT Altering table ecs_cores
ALTER TABLE ECS_CORES DROP CONSTRAINT ECS_CORES_PK;
ALTER TABLE ECS_CORES ADD CONSTRAINT ECS_CORES_PK PRIMARY KEY (RACKNAME, HOSTNAME);
ALTER TABLE ecs_cores ADD (goldbackupstatus varchar2(64) default 'NotInstalled');

PROMPT Altering ecs_exadata_compute_node
ALTER TABLE ECS_EXADATA_COMPUTE_NODE DROP CONSTRAINT PK_COMP_HOSTNAME;
ALTER TABLE ECS_EXADATA_COMPUTE_NODE ADD CONSTRAINT PK_COMP_HOSTNAME PRIMARY KEY (EXADATA_ID, HOSTNAME);

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info DROP COLUMN client_network_lacp;
ALTER TABLE ecs_oci_exa_info DROP COLUMN backup_network_lacp;
ALTER TABLE ecs_oci_exa_info ADD client_network_bondingmode varchar(24) DEFAULT 'active-backup' CHECK (client_network_bondingmode IN ('active-backup', 'lacp'));
ALTER TABLE ecs_oci_exa_info ADD backup_network_bondingmode varchar(24) DEFAULT 'active-backup' CHECK (backup_network_bondingmode IN ('active-backup', 'lacp'));
ALTER TABLE ecs_oci_exa_info ADD nw_mode_validation_report clob;

PROMPT Altering table ecs_exaunitdetails
ALTER TABLE ecs_exaunitdetails ADD asmss_enabled varchar(8) DEFAULT 'FALSE' CHECK (asmss_enabled IN ('TRUE','FALSE'));
ALTER TABLE ecs_exaunitdetails ADD adbs_enabled varchar(8) CHECK (adbs_enabled IN ('TRUE', 'FALSE'));
ALTER TABLE ecs_exaunitdetails ADD fsconfig varchar2(32) DEFAULT '443';

-- jzandate    06/08/23 - Bug 35402914 - Adding new column osver
PROMPT Altering table ecs_exaunitdetails for exadata 23 support
ALTER TABLE ecs_exaunitdetails ADD osver varchar2(32) DEFAULT NULL;


--Enh 34325943 - Required for exacompute
PROMPT Altering tables for maintenance_domain
alter table ecs_hw_nodes add maintenance_domain_id number default -1;
alter table ecs_rocefabric add total_duration number;
alter table ecs_rocefabric add notification_duration number;
alter table ecs_rocefabric add total_mds number;
alter table ecs_rocefabric add current_md_id number;

--Enh EXACS-125310 - QFAB reservation for capacity expansion
PROMPT Altering rocefabric table for QFAB reservation columns
alter table ecs_rocefabric add X8M_COMPUTE_UTILIZATION number default 0;
alter table ecs_rocefabric add X8M_CELL_UTILIZATION number default 0;
alter table ecs_rocefabric add X8M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric add X8M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric add X9M_COMPUTE_UTILIZATION number default 0;
alter table ecs_rocefabric add X9M_CELL_UTILIZATION number default 0;
alter table ecs_rocefabric add X9M_COMPUTE_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric add X9M_CELL_QFAB_ELASTIC_RESERVATION_THRESHOLD number default -1;
alter table ecs_rocefabric add X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS varchar2(10) default 'ENABLED';
alter table ecs_rocefabric add CONSTRAINT override_capacity_constr_x8m CHECK (X8M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS in ('ENABLED', 'DISABLED'));
alter table ecs_rocefabric add X9M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS varchar2(10) default 'ENABLED';
alter table ecs_rocefabric add CONSTRAINT override_capacity_constr_x9m CHECK (X9M_ELASTIC_RESERVATION_FOR_HIGH_UTIL_QFABS in ('ENABLED', 'DISABLED'));

alter table ecs_rocefabric add extended_vlan_start number default 4097;
alter table ecs_rocefabric add extended_vlan_end number default 59456;


PROMPT Altering ECS_EXASERVICE_RESERVED_ALLOC
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC ADD (request_id varchar2(128));

PROMPT Altering ecs_analytics
alter table ecs_analytics add (ceiocid varchar2(1024));
alter table ecs_analytics add (idemtoken varchar2(40));
alter table ecs_analytics add (payload CLOB);
alter table ecs_analytics add (clusterocid varchar2(512));

-- Enh 36904134 - Saving results for secure erase wf
ALTER TABLE ECS_ANALYTICS ADD DATA BLOB default NULL;

PROMPT Altering table state_store
alter table state_store add (plan clob);
alter table state_store add (state_id varchar2(4000));
alter table state_store add constraint state_store_unique_stateid UNIQUE (state_id);

PROMPT Altering table state_lock_data
alter table state_lock_data add (lock_acquired_time varchar2(128));   

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info ADD previous_status varchar2(24)
	CHECK (previous_status IN ('PREPARING', 'PRE_ACTIVATION', 'READY', 'RESERVED', 'ACTIVE'));

PROMPT Altering table ecs_user_roles
DROP TABLE ECS_USER_ROLES CASCADE CONSTRAINTS;

PROMPT Altering table ecs_user_roles
DROP SEQUENCE ecs_user_roles_seq;
drop trigger ecs_user_roles_id_seq;

PROMPT Altering table ecs_users
ALTER TABLE ECS_USERS ADD CONSTRAINT ECS_USERS_UNIQUE_USERID UNIQUE (USER_ID);

-- ALTER only if col size is not 255
PROMPT Altering ecs_rotation_schedule
DECLARE
    scol_len  USER_TAB_COLS.DATA_LENGTH%TYPE;
    vcol_len  USER_TAB_COLS.DATA_LENGTH%TYPE;
BEGIN
    SELECT DATA_LENGTH INTO scol_len FROM USER_TAB_COLS WHERE LOWER(column_name) = 'secret_name' AND LOWER(table_name) = 'ecs_rotation_schedule';
    SELECT DATA_LENGTH INTO vcol_len FROM USER_TAB_COLS WHERE LOWER(column_name) = 'vault_name' AND LOWER(table_name) = 'ecs_rotation_schedule';
IF (scol_len != 255) THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ecs_rotation_schedule modify secret_name varchar2(255)';
    COMMIT;
END IF;
IF (vcol_len != 255) THEN
    EXECUTE IMMEDIATE 'ALTER TABLE ecs_rotation_schedule modify vault_name varchar2(255)';
    COMMIT;
END IF;
END;
/

-- Create indexes on ECRA tables to enhance ECRA query performance

create index wf_uuid_idx on WF_TASK(wf_uuid) nologging parallel 4 online;
alter index  wf_uuid_idx noparallel;

create index ECS_REQUESTS_ID_IDX on ECS_REQUESTS("ID") nologging parallel 4 online;
alter index ECS_REQUESTS_ID_IDX noparallel

create index ECS_WF_REQUESTS_STATUS_IDX on ECS_WF_REQUESTS("STATUS")  nologging parallel 4 online;
alter index ECS_WF_REQUESTS_STATUS_IDX noparallel;

create index ECS_REQUESTS_STATUS_IDX on ECS_REQUESTS("STATUS")  nologging parallel 4 online;
alter index ECS_REQUESTS_STATUS_IDX noparallel;

create index WF_TASK_STATE_MACHINE_IDX on WF_TASK_STATE_MACHINE("WF_UUID") nologging parallel 4 online;
alter index  WF_TASK_STATE_MACHINE_IDX noparallel;

PROMPT Altering ecs_requests
ALTER TABLE ecs_requests ADD start_time_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

PROMPT Altering ecs_wf_requests
ALTER TABLE ecs_wf_requests ADD start_time_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

PROMPT Altering ecs_analytics
ALTER TABLE ecs_analytics ADD start_time_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- END of alter table procedure

PROMPT Altering table ecs_oci_exa_info
ALTER TABLE ecs_oci_exa_info ADD (MONITORING_COMPARTMENT_OCID varchar2(100));


alter table ecs_cps_dyn_task drop constraint pk_cps_dyn_task;

alter table ecs_cps_dyn_task add constraint pk_cps_dyn_task PRIMARY KEY (component_name, ecs_series, script_order);

-- Enh 34858677 for eth0 Removal
ALTER TABLE ecs_hw_cabinets add eth0 varchar2(1) default 'Y' not null;

alter table ecs_hw_elastic_nodes add rack_num number(3) DEFAULT 1;

alter table ecs_oci_console_history rename column REQUESTOCID to request_ocid;
alter table ecs_oci_console_history rename column EXAUNITID to exaunit_id;
alter table ecs_oci_console_history rename column VMHOSTNAME to vm_hostname;
alter table ecs_oci_console_history rename column OSSOBJECT to oss_object;
alter table ecs_oci_console_history rename column SSHPUBKEY to ssh_pubkey;
alter table ecs_oci_console_history rename column SYMMETRICKEY to symmetric_key;
alter table ecs_oci_console_history rename column MD5CKSUM to md5_cksum;

alter table ecs_oci_networks add SCAN_DR_NETWORK_HOSTNAME VARCHAR2(512);
alter table ecs_oci_networks add SCAN_DR_NETWORK_PORT VARCHAR2(64);
alter table ecs_oci_networks add SCAN_DR_NETWORK_IPS VARCHAR2(256);
alter table ecs_oci_networks add SCAN_V6IPS VARCHAR2(256);

ALTER TABLE ecs_oci_exa_info ADD dr_network_bondingmode varchar(24) DEFAULT 'active-backup' CHECK (dr_network_bondingmode IN ('active-backup', 'lacp'));

ALTER TABLE ecs_zones MODIFY username varchar2(256) NULL;
ALTER TABLE ecs_zones MODIFY password BLOB NULL;

ALTER TABLE ecs_zones ADD subnetocid varchar2(256);
ALTER TABLE ecs_zones DROP CONSTRAINT ecs_zones_location_ck;

ALTER TABLE ecs_atpclient_vcn ADD compartmentocid varchar2(256);
ALTER TABLE ecs_atpclient_vcn ADD cidrblock varchar2(64);

ALTER TABLE ecs_customvip ADD ipocid varchar2(256);
ALTER TABLE ecs_customvip ADD vnicocid varchar2(256);
ALTER TABLE ecs_customvip ADD zoneocid varchar2(256);
ALTER TABLE ecs_customvip ADD iptype varchar2(64) DEFAULT 'CUSTOMVIP' NOT NULL;

ALTER TABLE ecs_customvip ADD customipv6 varchar2(64);
ALTER TABLE ecs_customvip ADD ipv6ocid varchar2(256);

-- Add ingestion_status column to ecs_hw_nodes table
PROMPT Altering table ecs_hw_nodes
alter table ecs_hw_nodes
    add (ingestion_status varchar2(64) DEFAULT 'INGESTION_IN_PROGRESS' CHECK (ingestion_status in ('INGESTION_IN_PROGRESS', 'INGESTION_SUCCESS', 'INGESTION_HW_FAILURE', 'INGESTION_SW_FAILURE', 'INGESTION_FAILURE')));

-- Add availability column to ecs_hw_cabinets table
PROMPT Altering table ecs_hw_cabinets
alter table ecs_hw_cabinets add (compute_availability number DEFAULT 0);
alter table ecs_hw_cabinets add (cell_availability number DEFAULT 0);

-- Modify node_state column values of ecs_hw_nodes tables
ALTER TABLE ecs_hw_nodes MODIFY node_state DEFAULT 'UNDER_INGESTION';
alter table ecs_hw_nodes drop constraint ck_ecs_hw_nodes_node_state;
ALTER TABLE ecs_hw_nodes add CONSTRAINT ck_ecs_hw_nodes_node_state
      CHECK (node_state in ('FREE', 'COMPOSING', 'ALLOCATED', 'HW_REPAIR',
                            'HW_UPGRADE', 'HW_FAIL', 'RESERVED', 'ERROR', 'EXACOMP_RESERVED', 'RESERVED_MAINTENANCE', 'RESERVED_FAILURE',
                            'RESERVED_HW_FAILURE', 'FREE_FAILURE', 'FREE_MAINTENANCE','FREE_UNDER_MAINT', 'COMPOSING_UNDER_MAINT', 
                            'ALLOCATED_UNDER_MAINT', 'RESERVED_UNDER_MAINT',
                            'HW_REPAIR_UNDER_MAINT', 'HW_UPGRADE_UNDER_MAINT', 'HW_FAIL_UNDER_MAINT',
                            'ERROR_UNDER_MAINT', 'EXACOMP_RESERVED_UNDER_MAINT', 'INNOTIFICATION', 'INNOTIFICATION_UNDER_MAINT',
                            'INMAINTENANCE', 'INMAINTENANCE_UNDER_MAINT', 'UNDER_INGESTION', 'INGESTION_FAILED', 'REQUIRES_RECOVERY',
                            'FREE_AUTO_MAINTENANCE','MOVING','DECOMMISSIONING'));

ALTER TABLE ecs_oci_config_bundle_details MODIFY cipher_salt VARCHAR2(64);

ALTER TABLE ecs_oci_console_connection MODIFY EXA_OCID varchar2(512) NULL;
ALTER TABLE ecs_oci_console_connection DROP CONSTRAINT FK_CONSOLE_EXOCID; 

ALTER TABLE ecs_exadata_formation ADD CONSTRAINT ecs_exadata_formation_pk PRIMARY KEY (inventory_id, exadata_formation_id);

-- Enh 35289456 - Fix MACADDRESS length
ALTER TABLE ecs_oci_vnics MODIFY MACADDRESS VARCHAR2(26);

-- Bug 36023027 - Preprov, change zone lenght in ECS_ZONES
PROMPT Altering table ECS_ZONES
ALTER TABLE ecs_zones MODIFY ZONE VARCHAR2(256);

-- Enh 35592332 - ECRA PREPROV - INCLUDE INSTANCE TYPE ON ECS_COMPUTE_INSTANCES 
ALTER TABLE ecs_compute_instances ADD computetype VARCHAR2(32) DEFAULT 'PREPROV' NOT NULL;
ALTER TABLE ecs_compute_instances ADD CONSTRAINT ck_ecs_comp_inst_type
      CHECK (computetype in ('CLIENT', 'ADMIN', 'PREPROV'));
ALTER TABLE ecs_oci_subnets DROP CONSTRAINT ck_ecs_oci_subnets_type;
ALTER TABLE ecs_oci_subnets ADD CONSTRAINT ck_ecs_oci_subnets_type 
      CHECK (subnettype in ('CLIENT', 'ADMIN', 'BACKUP'));




-- Enh 35328793 - EXADB-XS: ECRA API TO PROVIDE KVM HOST SSHKEY  
PROMPT Altering table sshkeys
ALTER TABLE sshkeys ADD oracle_hostname VARCHAR2(256);
ALTER TABLE sshkeys ADD exaroot_url VARCHAR2(256);
ALTER TABLE sshkeys ADD exaroot_username VARCHAR2(256);
ALTER TABLE sshkeys ADD vaultaccess VARCHAR2(256);
ALTER TABLE sshkeys ADD vaultid VARCHAR2(256);
ALTER TABLE sshkeys ADD trustcertificates BLOB;
ALTER TABLE sshkeys DROP CONSTRAINT FK_SSHCLUSTER;
ALTER TABLE sshkeys DROP CONSTRAINT FK_TENANTSSH;

-- Enh 35751773 - EXADBXS: TRANSITION THE SCHEMA FOR VAULT-ACCESS FROM SSHKEYS TABLE TO ECS_SYSTEM_VAULT_ACCESS  
ALTER TABLE ECS_SYSTEM_VAULT_ACCESS ADD TRUST_CERTIFICATES BLOB;
ALTER TABLE ECS_SYSTEM_VAULT_ACCESS ADD DRIVER_VERSION VARCHAR(2048);


-- Enh 35435491 - UPDATE RESHAPE CLUSTER TO SUPPORT FILESYSTEM RESIZE
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC ADD FILESYSTEMSGB NUMBER;


-- Enh 35304498 - ADD STATUS_COMMENT COLUMN TO CABINET AND NODES TABLES 
PROMPT Altering table ecs_hw_cabinets
ALTER TABLE ecs_hw_cabinets ADD status_comment VARCHAR2(4000);
PROMPT Altering table ecs_hw_nodes
ALTER TABLE ecs_hw_nodes ADD status_comment VARCHAR2(4000);

PROMPT Altering table ecs_cluster_metrics
-- BUG 35858470 - EXACC: SLA REPORT: CHANGE TYPE OF VALUE FIELD IN ECS_CLUSTER_METRICS TO NUMBER AND STORE UPTIME AND CELLSRV STATUS (AS 1 OR 0)
ALTER TABLE ecs_cluster_metrics MODIFY value NUMBER(10) NOT NULL;
ALTER TABLE ecs_cluster_metrics DROP COLUMN cellsrvStatus;
ALTER TABLE ecs_cluster_metrics DROP COLUMN eth1_interface;
ALTER TABLE ecs_cluster_metrics DROP COLUMN eth2_interface;
ALTER TABLE ecs_cluster_metrics ADD monitoring_timestamp TIMESTAMP;

-- Bug 35827954 - ADD HOSTS_INVOLVED COLUMN, MODIFY  ecs_sla_breach
ALTER TABLE ecs_sla_breach DROP CONSTRAINT fk_metric_cluster_id;
ALTER TABLE ecs_sla_breach DROP COLUMN metric_cluster_id;
ALTER TABLE ecs_sla_breach MODIFY time_event_end timestamp NULL;

-- Bug 35838202 - ADD JOIN TABLE BETWEEN ECS_SLA_HOST AND ECS_SLA_INFO
PROMPT Altering table ecs_sla_info_hosts and ecs_sla_breach_hosts
ALTER TABLE ecs_sla_hosts DROP CONSTRAINT fk_sla_info_id;
ALTER TABLE ecs_sla_hosts DROP CONSTRAINT pk_sla_hosts;
ALTER TABLE ecs_sla_hosts DROP COLUMN sla_info_id;
ALTER TABLE ecs_sla_hosts ADD sla_host_id number(10) NOT NULL;
ALTER TABLE ecs_sla_hosts ADD CONSTRAINT pk_sla_hosts PRIMARY KEY(sla_host_id)
ALTER TABLE ecs_sla_info_hosts ADD CONSTRAINT pk_sla_info_hosts PRIMARY KEY(sla_info_id, sla_host_id);
ALTER TABLE ecs_sla_breach_hosts ADD CONSTRAINT pk_sla_breach_hosts PRIMARY KEY(sla_breach_id, sla_host_id);

-- Bug 36541136 - REDUCE READS TO ECS_CLUSTER_METRICS (ADDING LAST_UPTIME_METRIC_ID TO ECS_SLA_HOST)
ALTER TABLE ecs_sla_hosts ADD last_uptime_metric_id number(10);
ALTER TABLE ecs_sla_hosts ADD CONSTRAINT fk_sla_hosts_sla_clu_metrics FOREIGN KEY(last_uptime_metric_id) REFERENCES ecs_cluster_metrics(metric_cluster_id);
CREATE INDEX ecs_sla_hosts_hostname_idx ON ecs_sla_hosts("HOSTNAME");
CREATE INDEX ecs_sla_info_exaocid_cluocid_idx ON ecs_sla_info("EXA_OCID", "VM_CLUSTER_OCID");
CREATE INDEX ecs_sla_breach_idx ON ecs_sla_breach("SLA_INFO_ID");
CREATE INDEX ecs_sla_info_hosts_idx ON ecs_sla_info_hosts("SLA_INFO_ID");
CREATE INDEX ecs_sla_breach_hosts_idx ON ecs_sla_breach_hosts("SLA_BREACH_ID");


-- Bug 36353998  MISSING AGGREGATE_STATUS COLUMN 
PROMPT Altering table ecs_sla_info
ALTER TABLE ecs_sla_info ADD AGGREGATE_STATUS VARCHAR2(32) DEFAULT 'PENDING';

alter table ecs_error modify DESCRIPTION VARCHAR2(4000);

-- Enh 35677356 - GI support 
ALTER TABLE ECS_GRID_VERSION
    add (service_type varchar2(64) default 'EXACS');
ALTER TABLE ECS_GRID_VERSION
    add (image_type varchar2(64) default 'RELEASE');
ALTER TABLE ECS_GRID_VERSION
    add (file_image_name varchar2(1024));
ALTER TABLE ECS_GRID_VERSION
    add (checksum varchar2(1024));
ALTER TABLE ECS_GRID_VERSION
    add (location_type varchar2(64));
ALTER TABLE ECS_GRID_VERSION
    add (location_info varchar2(1024));

alter table ecs_grid_version drop constraint ecs_grid_version_pk;
alter table ecs_grid_version add CONSTRAINT ecs_gridversion_pk PRIMARY KEY (gi_version,service_type);
drop sequence ecs_gi_ver_seq_id;
drop trigger ecs_gi_ver_id;
drop trigger ECS_GRID_VERSION_ID;
alter table ecs_grid_version drop column id;
-- Enh 35892155 - Ecra Indigo - Create Backfilling Apis To Populate Indigo Data
ALTER TABLE ECS_HW_CABINETS ADD (SITEGROUP varchar2(256));
ALTER TABLE ECS_HW_CABINETS ADD (RESTRICTED_SITEGROUP varchar2(64));
ALTER TABLE ECS_HW_CABINETS MODIFY RESTRICTED_SITEGROUP  DEFAULT 'N';


-- Enh 35870618 - EXACS ELASTIC - ADD QUANTITY OF SERVERS PER MODEL IN ECRA METADATA
PROMPT Altering table ecs_elastic_platform_info
ALTER TABLE ecs_elastic_platform_info ADD maxComputes NUMBER DEFAULT 1 NOT NULL;
ALTER TABLE ecs_elastic_platform_info ADD maxCells NUMBER DEFAULT 1 NOT NULL;

-- Enh 36197323 - ECRA CAN PROVIDE LOCATION OF ILOM ON SUBSTRATE OR OVERLAY FOR ALL SUPPORTED SHAPES
ALTER TABLE ecs_elastic_platform_info ADD ilomtype varchar2(64);
ALTER TABLE ecs_elastic_platform_info ADD support_status varchar2(64);

-- Enh 36922155 - EXACS X11M - Base system support
ALTER TABLE ecs_elastic_platform_info ADD (feature varchar2(64) DEFAULT 'CROSS_PLATFORM' NOT NULL);
ALTER TABLE ecs_elastic_platform_info ADD (hw_type varchar2(64) DEFAULT 'ALL' NOT NULL);
ALTER TABLE ecs_elastic_platform_info drop constraint pk_ecs_elastic_platform_info;
ALTER TABLE ecs_elastic_platform_info add constraint pk_ecs_elastic_platform_info primary key (model,feature,hw_type);

-- Enh 37179993 - EXACS X11M - Adding the codename that exacloud needs for each model/subtype 
ALTER TABLE ecs_elastic_platform_info ADD (oeda_codename varchar2(64));

-- Enh 35823610 - Adding rackname column to ecs_oci_vnics
PROMPT Altering table ecs_oci_vnics
ALTER TABLE ecs_oci_vnics ADD (RACKNAME varchar2(256));

-- Bug 35941946 - Adding ON DELETE CASCADE clause
ALTER TABLE ecs_sla_breach DROP CONSTRAINT fk_sla_breach_info_id;
ALTER TABLE ecs_sla_breach ADD CONSTRAINT fk_sla_breach_info_id FOREIGN KEY (sla_info_id) REFERENCES ecs_sla_info(sla_info_id) ON DELETE CASCADE;
 
ALTER TABLE ecs_sla_breach_reason DROP CONSTRAINT fk_sla_breach_id;
ALTER TABLE ecs_sla_breach_reason ADD CONSTRAINT fk_sla_breach_id FOREIGN KEY (sla_breach_id) REFERENCES ecs_sla_breach(sla_breach_id) ON DELETE CASCADE;

ALTER TABLE ecs_sla_breach_hosts DROP CONSTRAINT fk_sla_brch_hosts_sla_brch_id;
ALTER TABLE ecs_sla_breach_hosts ADD CONSTRAINT fk_sla_brch_hosts_sla_brch_id FOREIGN KEY (sla_breach_id) REFERENCES ecs_sla_breach(sla_breach_id) ON DELETE CASCADE;
ALTER TABLE ecs_sla_breach_hosts ADD CONSTRAINT fk_sla_brch_hosts_sla_host_id FOREIGN KEY (sla_host_id) REFERENCES ecs_sla_hosts(sla_host_id);

ALTER TABLE ecs_sla_info_hosts DROP CONSTRAINT fk_sla_info_hosts_sla_info_id;
ALTER TABLE ecs_sla_info_hosts ADD CONSTRAINT fk_sla_info_hosts_sla_info_id FOREIGN KEY (sla_info_id) REFERENCES ecs_sla_info(sla_info_id) ON DELETE CASCADE;
ALTER TABLE ecs_sla_info_hosts ADD CONSTRAINT fk_sla_info_hosts_sla_host_id FOREIGN KEY (sla_host_id) REFERENCES ecs_sla_hosts(sla_host_id);

-- Enh 35756274 - Rename ecs_ad_locations to ecs_sitegroups
ALTER TABLE ECS_AD_LOCATIONS rename column COMPUTE_ZONE to BUILDING;
ALTER TABLE ECS_AD_LOCATIONS ADD NAME varchar2(256);
ALTER TABLE ECS_AD_LOCATIONS ADD (RESTRICTED varchar2(64));
ALTER TABLE ECS_AD_LOCATIONS DROP constraint FK_ECRA_INFOID_AD;
ALTER TABLE ECS_AD_LOCATIONS RENAME TO ECS_SITEGROUPS;
-- Enh 36858584 - Ecra: Multicloud: Add Site Group Data To Ecra
ALTER TABLE ECS_SITEGROUPS ADD CLOUD_VENDOR varchar2(256)  DEFAULT 'OCI' NOT NULL;
ALTER TABLE ECS_SITEGROUPS ADD CLOUD_PROVIDER_REGION varchar2(256) DEFAULT 'OCI' NOT NULL;
ALTER TABLE ecs_sitegroups drop constraint AD_PK;
ALTER TABLE ecs_sitegroups ADD CONSTRAINT "ECS_SITEGROUPS_PK" PRIMARY KEY ("NAME");
ALTER TABLE ECS_SITEGROUPS ADD CLOUD_PROVIDER_AZ  varchar2(256);
ALTER TABLE ECS_SITEGROUPS ADD CLOUD_PROVIDER_BUILDING varchar2(256);
-- Enh 37477523 - Exacs Sitegroup - Include Mtu Config Per Site Group
ALTER TABLE ECS_SITEGROUPS ADD MTU number DEFAULT 9000; 
ALTER TABLE ECS_SITEGROUPS ADD FAR_CHILD_SITE varchar2(32) DEFAULT 'N';
ALTER TABLE ECS_SITEGROUPS ADD OVERLAY_BRIDGE_USED varchar2(32) DEFAULT 'N';
-- Enh 37985641 - Exacs Ecra - Ecra To Configure Dbaas Tools Name Rpm Basd On Cloud Vendor
ALTER TABLE ECS_SITEGROUPS ADD DBAASTOOLSRPM varchar2(100) DEFAULT 'dbaastools_exa_main.rpm';
ALTER TABLE ECS_SITEGROUPS ADD DBAASTOOLSRPM_CHECKSUM varchar2(100);

-- Enh 35572548 - enhance performance of request id backfill from json logger
PROMPT Altering table ecs_requests (creating index on wf_uuid)
CREATE INDEX ecs_requests_wf_uuid_idx ON ecs_requests(wf_uuid) NOLOGGING PARALLEL 4 ONLINE;
ALTER INDEX ecs_requests_wf_uuid_idx NOPARALLEL;

-- Bug 36050851 - fixed orphan workflows for async_calls
PROMPT Altering table async_calls
ALTER TABLE async_calls ADD wf_uuid VARCHAR2(36);
CREATE INDEX async_calls_wf_uuid_idx ON async_calls(wf_uuid);

-- Enh 35990354 - Adding custom linux uid/gid feature
ALTER TABLE ecs_cloudvnuma_tenancy ADD (CUSTOM_UID_GID varchar2(512));
ALTER TABLE ecs_exaunitdetails ADD (CUSTOM_UID_GID varchar2(512));

-- ENH 36931770 - Adding ecpu factor snapshot
ALTER TABLE ecs_exaunitdetails ADD (ecpufactor number null);

--
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
    ENV
FROM
    ECS_HARDWARE
WHERE
    ENV = (SELECT NVL((SELECT VALUE FROM ECS_PROPERTIES WHERE NAME = 'ECRA_ENV' AND ROWNUM = 1),'bm') FROM DUAL);

--  Enh 36070977 - ECRA APPLICATION CHANGES TO IMPLEMENT PARTITIONING IN ECRA SCHEMA 
ALTER TABLE ASYNC_CALLS ADD START_TIME_TS TIMESTAMP(6);

ALTER TABLE ecs_oci_exa_info ADD (rack_serial_number varchar2(128));

-- Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA OPERATIONS FAILING POST PARTITIONING AND ARCHIVING OF TABLES
ALTER TABLE ECS_IDEMTOKENS ADD START_TIME_TS TIMESTAMP(6);
ALTER TABLE ECS_SCHEDULEDJOB_HISTORY ADD START_TIME_TS TIMESTAMP(6);

-- Enh 36165741 - EXACS: After termination of cei, elastic shape nodes needs to be patched to latest exadata version
ALTER TABLE ECS_HW_CABINETS 
ADD (auto_maintenance varchar2(64) DEFAULT ON NULL 'Y' NOT NULL);

-- Enh 35751773 - EXADBXS: TRANSITION THE SCHEMA FOR VAULT-ACCESS FROM SSHKEYS TABLE TO ECS_SYSTEM_VAULT_ACCESS  
ALTER TABLE ecs_system_vault_access ADD TRUST_CERTIFICATES BLOB;
ALTER TABLE ecs_system_vault_access ADD DRIVER_VERSION VARCHAR(2048);
-- Enh 36494348 - Adding extra columns for extra keys for a vualt
ALTER TABLE ecs_system_vault_access ADD public_key_2 varchar2(2048);
ALTER TABLE ecs_system_vault_access ADD public_key_3 varchar2(2048);

-- Enh - Support for multipple system vault
ALTER TABLE ecs_system_vault ADD is_placement_disabled  varchar2(8) default 'false' check (is_placement_disabled in ('true','false'));

--Bug 36197980 - Added a new field to track last password rotation depareted from the cert rotation date
ALTER TABLE ECS_OCI_EXA_INFO ADD
      (last_password_rotation timestamp);

ALTER TABLE ecs_exaunitdetails ADD storage varchar2(6) DEFAULT 'ASM';
ALTER TABLE ecs_exaunitdetails ADD dbvault_ocid varchar2(256) default NULL;
ALTER TABLE ecs_exaunitdetails ADD vmvault_ocid varchar2(256) default NULL;

ALTER TABLE ecs_oci_exa_info ADD STORAGE varchar2(6) DEFAULT 'ASM';
ALTER TABLE ecs_oci_exa_info ADD XS_POOL_NAME varchar2(32);
ALTER TABLE ecs_oci_exa_info ADD asmss varchar2(5) DEFAULT 'FALSE' CHECK (asmss in ('TRUE', 'FALSE'));

ALTER TABLE ECS_EXASERVICE ADD STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE ADD AVAILABLE_STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE ADD VMSTORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE ADD AVAILABLE_VMSTORAGEXSGB NUMBER DEFAULT 0;

ALTER TABLE ECS_EXASERVICE_ALLOCATIONS ADD STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE_ALLOCATIONS ADD VMSTORAGEXSGB NUMBER DEFAULT 0;

ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC ADD STORAGEXSGB NUMBER DEFAULT 0;
ALTER TABLE ECS_EXASERVICE_RESERVED_ALLOC ADD VMSTORAGEXSGB NUMBER DEFAULT 0;

ALTER TABLE ECS_EXADATA_COMPUTE_NODE ADD VMVAULT_REFERENCEID VARCHAR2(256);

--Enh 36628793 - ECRA EXACS - Add property description column for new properties
ALTER TABLE ECS_PROPERTIES ADD DESCRIPTION varchar2(512);

--Enh 36754210 - ECRA: BACKFILL VNIC FOR THE EXISTING CABINETS
ALTER TABLE ECS_HW_CABINETS ADD ADMIN_ACTIVE_VNIC varchar2(256) default NULL;
ALTER TABLE ECS_HW_CABINETS ADD ADMIN_STANDBY_VNIC varchar2(256) default NULL;
ALTER TABLE ECS_HW_CABINETS ADD SUBNET_OCID varchar2(256) default NULL;

--Enh 34972266 - EXACS Compatibility - create new tables to support compatibility on operations
ALTER TABLE ecs_registries ADD resourceid VARCHAR2(256);

alter table ecs_exascale_nw drop constraint fk_exascale_id;

--Enh 36755078
PROMPT Altering table ecs_exaunitdetails
ALTER TABLE ecs_exaunitdetails DROP COLUMN vmclustertype;
ALTER TABLE ecs_exaunitdetails ADD vmclustertype VARCHAR2(64) DEFAULT 'regular' CONSTRAINT cluster_type_chk CHECK (vmclustertype in ('regular', 'developer')));

-- bug 37117708
PROMPT Altering table ECS_SNAPSHOTS
alter table ECS_SNAPSHOTS modify VMINSTANCEGROUPID VARCHAR2(256);

PROMPT Altering table ecs_oci_clu_xmls
ALTER TABLE ecs_oci_clu_xmls ADD exacloud_xml CLOB;
ALTER TABLE ecs_oci_clu_xmls ADD (attach_candidate VARCHAR2(3) DEFAULT 'NO' CHECK (attach_candidate in ('YES', 'NO')));

PROMPT Altering table ecs_exascale_vaults
ALTER TABLE ecs_exascale_vaults ADD VAULT_ECRA_ID varchar2(24);

--Enh 37025371 - EXACC X11M Support for compute standard/large and extra large
ALTER TABLE ecs_exadata ADD compute_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;
ALTER TABLE ecs_exadata ADD cell_subtype varchar2(64) DEFAULT 'STANDARD' NOT NULL;

ALTER TABLE ecs_exadata DROP CONSTRAINT
  ck_ecs_exadata_compute_subtype;

ALTER TABLE ecs_exadata ADD
      CONSTRAINT ck_ecs_exadata_compute_subtype
        CHECK (compute_subtype in
             ('BASE',
              'Z',
              'STANDARD',
              'ELASTIC_LARGE',
              'ELASTIC_EXTRALARGE'));

ALTER TABLE ecs_exadata DROP CONSTRAINT
  ck_ecs_exadata_cell_subtype;

ALTER TABLE ecs_exadata ADD
      CONSTRAINT ck_ecs_exadata_cell_subtype
        CHECK (cell_subtype in
             ('BASE',
              'Z',
              'STANDARD',
              'NOXRMEM',
              'EF'));

alter table ECS_DOMUKEYSINFO modify(PUBLIC_KEY ENCRYPT NO SALT);

-- Enh 37508426 Alter exacompute entity table
ALTER TABLE ecs_exacompute_entity ADD volumes clob;

ALTER TABLE ecs_cloudvnuma_tenancy add (skipresizedg varchar2(32) default 'no');

-- Enh 37740901 Alter exacompute entity table 19c support
ALTER TABLE ecs_exacompute_entity_table add (servicesubtype varchar2(16) default 'exadbxs' not null);
ALTER TABLE ecs_exacompute_entity_table add (clustertype varchar2(16) default 'smartstorage' not null);

-- Enh 38036035 - Clone VM Support for BaseDB
ALTER TABLE ecs_exacompute_entity_table add (sourceclusterid varchar2(256) default NULL);

-- Enh 37525577 - Adding CONFIGURED_FEATURES to site groups
ALTER TABLE ECS_SITEGROUPS ADD (CONFIGURED_FEATURES varchar2(1024));

ALTER TABLE ECS_ROCEFABRIC_TABLE MODIFY EXTENDED_VLAN_START DEFAULT 6000;
ALTER TABLE ECS_ROCEFABRIC_TABLE MODIFY EXTENDED_VLAN_END DEFAULT 58000;
whenever sqlerror exit FAILURE;

