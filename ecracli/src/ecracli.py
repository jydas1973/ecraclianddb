#!/usr/bin/env python
# -*- coding: utf-8 -*-
# THIS FILE CONTAINS ECRACLI FUNCTIONALITY
# $Header: ecs/ecra/ecracli/src/ecracli.py /main/712 2025/12/03 06:36:02 hcheon Exp $
#
# apiv2.py
#
# Copyright (c) 2013, 2025, Oracle and/or its affiliates.
#
#    NAME
#      ecracli Official interaface for ecra
#
#    DESCRIPTION
#      Official CLI for ECS
#
#    NOTES
#      ecracli
#
#    MODIFIED   (MM/DD/YY)
#    hcheon      11/17/25 - 38466555 Sanitycheck for ready racks
#    illamas     11/03/25 - Enh 38470291 - Guest release
#    jzandate    11/03/25 - Enh 38475130 - Adding admin smarting backfill
#    illamas     10/30/25 - Enh 38470264 Guest reserve
#    hbpatel     10/25/25 - Enh 37912972 - Exacc gen2: api call to force deletion of infra from 
#                           ecra during decommissioning process in case of disconnected
#    oespinos    10/09/25 - Bug 38220438 - Mark Cells To Delete command
#    zpallare    10/08/25 - Enh 38443483 - EXADBXS - Create new rack reserve
#                           api for exadbxs/basedb flows
#    gvalderr    09/26/25 - Enh 38469560 - Adding vmclusterocid details command
#                           for exacompute
#    caborbon    09/09/25 - ENH 38410599 - Adding command to ingest new
#                           cabinets
#    gvalderr    09/01/25 - Enh 38359812 - Creating endpoint for returning
#                           client hostnames of a compute
#    hbpatel     08/28/25 - Enh 38303743: Implement ops ecracli cmd for altering vm state in ecra db
#    jvaldovi    08/13/25 - Enh 38266898 - Vmboss_Scheduler | Need A Api
#    kanmanic    08/11/25 - Add atp getAdminIdentity
#    piyushsi    08/07/25 - BUG 38202038 WorkflowCtl Utility for workflow
#                           cleanup
#    luperalt    07/30/25 - Bug 38259193 - Added configure exascale command
#    jzandate    08/08/25 - Enh 37866326 - Adding validate volume endpoints
#    llmartin    07/16/25 - Enh 38035533 - Add exascale commands
#    caborbon    07/11/25 - ENH 38135205 - Adding logic to restore ilom
#                           password from secrets
#    hbpatel     07/07/25 - Enh 38036654: Exacc gen 2| infra patching |
#                           need ecra api to provide report on submitted wf's
#    hbpatel     07/07/25 - Enh 38036654: Exacc gen 2| infra patching | 
#    hbpatel     07/07/25 - Enh 38036654: Exacc gen 2| infra patching | 
#                           need ecra api to provide report on submitted wf's
#    luperalt    06/27/25 - Bug 37980254 - Added migrate vmbackup to xs command
#    caborbon    06/24/25 - Enh 37972633 - Adding ilom command execution api
#    llmartin    06/23/25 - Enh 38052083 - Add Map, unmap and update
#    jvaldovi    06/22/25 - Enh 37985641 - Exacs Ecra - Ecra To Configure Dbaas
#                           Tools Name Rpm Basd On Cloud Vendor
#    luperalt    06/19/25 - Bug 37768099 - Added acfs commands
#    jzandate   06/17/25 - Enh 37710713 - add sanity check to fleetstate json
#    sdevasek    06/05/25 - Enh 37987808 - PROVIDE ECRACLI COMMAND TO DELETE
#                           LAUNCHNODE METADATA ABOUT RUNNING PATCHING SESSIONS
#    zpallare   05/22/25 - Enh 37864848 - EXACS: ADBS: Key exchange api support
#                          : ecra support
#    jbrigido   05/20/25 - Bug 37562013 Enabling patch cmd for vmbackup
#    llmartin   05/16/25 - Enh 37705371 - Add Attach cell exascale command
#    jzandate   05/15/25 - Enh 37903772 - Adding dbvolumes operations
#    llmartin   04/28/25 - Enh 37783329 - Add AttachStorageExascale command
#    oespinos   03/26/25 - Bug 37077891 - Remove deprecated method get_occ_auth
#    ybansod    03/18/25 - Enh 34558104 - PROVIDE API FOR ECRA RESOURCE
#                          BLACKOUT
#    jzandate   03/18/25 - Enh 37525577 - Adding configured features
#    bshenoy    03/13/25 - EXACS-143285 - QFAB support for X11M & ABS Threshold
#    sdevasek    03/10/25 - Enh 37473003 - ECRA REGISTER BASED ON RACK MODEL
#    llmartin   03/04/25 - Enh 35461557 - Async API for delete tmp keys
#    jzandate   02/27/25 - Enh 37614605 - Compute cleanup
#    ririgoye   02/13/25 - Enh 35270020 - CREATE AN API IN ECRA FOR MARS TEAM
#                          TO PUSH THE VMCORE TO MOS
#    hcheon     02/10/25 - 37379447 whitelist infra for fault injection test
#    jyotdas    02/07/25 - Enh 37267618 - Expose Ecra api to return registered
#                          versions for image series in exacs
#    ririgoye   01/27/25 - Enh 35023107 - Add compute size API
#    gvalderr   01/22/25 - Enh 37464170 - Create endpoint for retreiving and
#                          updating json input of a given task
#    luperalt   01/16/25 - Bug 37486596 - Added wss ingestion ecracli command
#    zpallare   01/08/25 - Enh 37327315 - EXACS ECRA - Create rotatekeys
#                          command at exaunit level
#    abysebas   12/20/24 - Enh 37407965 - EXACS ECRA - NEW ECRA ENDPOINT TO
#                          UPDATE THE NTP AND DNS DETAILS IN THE XML, FOR THE
#                          EXISTING PROVISIONED CLUSTERS.
#    zpallare   12/16/24 - Enh 35170531 - EXACS:ECRACLI,sshkey, add support to
#                          get sshkeys of a cei
#    abyayada   12/12/24 - 37371775 : Support to get nat and hostname map
#    gvalderr   12/04/24 - Enh 37244095 - Adding command for disabling backups
#                          and increase available storage
#    piyushsi   12/13/24 - ER 36933899 Workflow mark exacloud task success
#    zpallare   12/04/24 - Enh 36754344 - EXACS Compatibility - create new apis
#                          for compatibility matrix and algorithm for locking
#    luperalt   12/02/24 - Bug 37345269 - Added option to regenerate dbcs
#                          wallters
#    jzandate   11/26/24 - Enh 36979496 - Adding history backup in analytics
#                          table
#    gvalderr   11/26/24 - Enh 37316013 - Adding command for updating and
#                          listing files
#    gvalderr   11/25/24 - Enh 37123564 - Addng extra commands for managing
#                          shared racks
#    gvalderr   11/06/24 - Enh 37197084 - Adding addRegistry command
#    illamas    10/30/24 - Enh 37224619 - Add/Delete fabric
#    kukrakes   10/28/24 - Enh 37195352 - ECRA CHANGES FOR EXACOMPUTE REQUEST
#                          CLEANUP FOR HARDWARE NODE FAILURE
#    jzandate   10/24/24 - Enh 37159676 - Adding scheduler nextrun
#    llmartin   10/22/24 - Enh 37081820 - Add endpoint to complete task
#    illamas    10/17/24 - Bug 37181860 - Changing value with correct
#    pverma     10/08/24 - Add updateAsmss command
#    dekuckre   09/24/24 - Add exacompute_precheck
#    jzandate   09/13/24 - Enh 37025361 - Adding service detail cmd
#    rgmurali    09/10/24 - Enh 36995884 - Configuring vmbackup cronjob on dom0
#    gvalderr   09/10/24 - Enh 36990685 - Adding securevms command
#    zpallare   09/09/24 - Enh 34972266 - EXACS Compatibility - create new
#                          tables to support compatibility on operations
#    jyotdas    09/07/24 - ENH 36108574 - API to update ecra with dom0 and
#                          cells version
#    illamas    09/03/24 - Enh 36918015 - Mark nathostname in ecs_domus and
#                          generate a new one for vm move
#    piyushsi   08/27/24 - Enh 36991930 Database Heartbeat Ecracli Command
#    luperalt   08/26/24 - Bug 36975561 Added undo exscale operation
#    zpallare   08/26/24 - Bug 36959599 - EXACS: Indigo feature needs an
#                          ecracli command to update sitegrp information
#    jzandate   08/08/24 - Enh 36904108 - Adding ecracli cmd for secure erase
#    luperalt   08/08/24 - Bug 36907987 - Added undo exascale operation
#    illamas    08/07/24 - Enh 36797845 - Deconfigure roce IPs
#    rgmurali    08/05/24 - Enh 36918660 - cli support for RoCE IP configure
#    jzandate   07/25/24 - Enh 36870390 - Adding restore location after wf
#                          finishes
#    illamas    07/22/24 - Enh 36793533 - Remove node from XML
#    ybansod     07/17/24 - Enh 35070702 - PROVIDE ECRACLI AND API TO VALIDATE
#                           PASSWORDS STORED IN SIV
#    jyotdas     07/16/24 - Enh 36799146 - CLI to sync ecra metadata for vm
#                           state with actual state of the vm in infra
#    antamil    07/09/24 - Bug 35827899 - Changes to make infraName optional
#                          for register launchnode
#    luperalt    07/04/24 - Bug 36754210 Added option to backfill the vnic of
#                           the cabinets
#    jzandate    07/02/24 - Enh 36197323 - Adding new endpoint for hardware
#                           models
#    abysebas    07/01/24 - Enh 36729554 - NEED SEPERATE COMMAND TO ADD
#                           SECRET_ID OF NEW USER
#    illamas     07/01/24 - Enh 36793084 - Mount and unmount support for
#                           exacompute
#    gvalderr    06/24/24 - Enh 36334590 - Adding command for purging archived
#                           nodes
#    jzandate    06/12/24 - Enh 36721694 - Adding status check
#    llmartin    06/10/24 - Enh 36651857 - cli to update mvm domus IPs
#    jzandate    05/28/24 - Enh 36587400 - Adding vmbackup local restore
#    gvalderr    05/24/24 - Enh 36334590 - Add command for archiving, retriving
#                           and reporting nodes
#    rgmurali    05/13/24 - ER 36009525 - Endpoint to check if exascale pool is created
#    jvaldovi    04/30/24 - Enh 36478797 - Node Recovery : Ecra Api For Free
#                           Computes Availability Required To Support Sop
#                           Automation
#    cgarud      04/25/24 - EXACS-125310 - QFAB reservation for expansion in
#                           highly utilized QFABs
#    jzandate    04/23/24 - Enh 36479065 - Adding new status endpoint
#    zpallare    04/22/24 - Enh 36520348 - ECRA EXACS - Review idempotency on
#                           mvm apis
#    pverma      04/09/24 - Pagination support for ExaCC capacity APIs
#    rgmurali    04/07/24 - Enh 36166633 - Remove dev clis for exacompute from ops use
#    zpallare    04/01/24 - Enh 36452336 - ECRA api to handle disable and
#                           enable bonding on compute nodes coming from an x8m
#                           standard rack
#    jiacpeng    04/01/24 - exacs-129321: reformat sla api for OneView
#                           integration
#    sdevasek    03/29/24 - Enh 36316080 - ECRACLI IMPLEMENTATION FOR PLUGIN
#                           REGISTRATION MANAGEMENT AND EXECUTING OP=ONEOFFV2
#    cgarud      03/22/24 - 35339379 - API for updating cavium info
#    zpallare    03/22/24 - Enh 36390188 - EXACS: Add new endpoint to retrieve
#                           request data
#    zpallare    03/16/24 - Bug 36268401 - EXACS-EXACLOUD: ECRACLI hung at
#                           connecting to endpoint and getting version info...
#    pverma      03/15/24 - Bug 36077336: Add support for WF janitor restart
#    jzandate    03/15/24 - Enh 36394639 - Adding new endpoint for xml details
#    piyushsi    02/28/24 - BUG 36335609 Block API Implementation
#    jzandate    02/27/24 - Enh 36193252 - Adding artifacts cli
#    nitishgu    02/21/24 - BUG 36318373: remove references of private key ecra
#                           https support
#    jzandate    02/16/24 - Enh 36192008 - Adding pagination headers to
#                           response output
#    zpallare    02/02/24 - Enh 36228435 - EXADB-XS: ECRA: Implement new api to
#                           secure vms : /exacompute/clusters/securevms
#    jiacpeng    01/26/24 - add topology network switch api
#    ybansod     01/23/24 - Bug 36207149 - fix precmd to correctly mask
#                           password for ecracli.log
#    zpallare    01/17/24 - Enh 35865892 - ECRA, ECRACLI - Provide mechanism to
#                           connect to a different ecraserver
#    zpallare    01/10/24 - Bug 36110921 - Node recovery : ecra apis support
#                           required for sop automation
#    ddelgadi    01/10/24 - Bug 36168090 - increase size of ecracli log file
#    zpallare    01/09/24 - Enh 36166029 - ECRACLI - Create ecracli commands to
#                           update xml
#    zpallare    12/18/23 - Enh 36068362 - Create ecra api to invoke an
#                           endpoint for time zone changes
#    anudatta    12/12/23 - Enh 36088456 - IORM async Api
#    pverma      12/12/23 - NodeRecovery SOP support
#    jzandate    12/06/23 - Bug 36077623 - Removing VMBackuposs cmd
#    zpallare    12/06/23 - Enh 35960747 - Add a property get types to know all
#                           the property types that we have in the env
#    zpallare    11/30/23 - Bug 35866829 - Allow retry after setting
#                           exacloud_cs_skip_swversion_check
#    hcheon      11/29/23 - 36052156 Added diagnosis rackhealth_* cmds
#    zpallare    11/21/23 - Enh 36023077 - ECRA - Create exadatainfrastructure
#                           command to get the initial payload
#    ddelgadi    11/16/23 - Enh 35756274 - Add functionality to SiteGroup
#    zpallare    11/14/23 - Enh 35797702 - EXADB-XS: ECRA to enhance the
#                           listclusters api to include more information
#    jzandate    11/02/23 - Bug 35954834 - Adding rollback for flow tester
#                           usage
#    gvalderr    10/31/23 - Enh 35832683 - adding delete storage endpoint
#    illamas     10/27/23 - Catalog support more than one exaversion
#    zpallare    10/25/23 - Enh 35823610 - Preprovisioning:need ecra endpoint
#                           for get compute VNICS
#    ybansod     10/23/23 - Enh 35678058 - Add ecracli command for Fleet
#                           HardwareNodes update async api
#    jzandate    10/16/23 - Bug 35866266 - Fixing overall help for vmbackup
#    zpallare    10/11/23 - Enh 35823587 - EXACS: Preprovisioning need ecra
#                           endpoint for get subnets
#    jvaldovi    10/10/23 - Enh 35892155 - Ecra Indigo - Create Backfilling
#                           Apis To Populate Indigo Data
#    caborbon    10/09/23 - Bug 35792183 - Adding subcommand for model_subtype
#                           updates and consult
#    jiacpeng    09/22/23 - Re-deisgn of SLA feature
#    pkbose      09/21/23 - EXACS-106515 topology API
#    gvalderr    09/21/23 - Enh 35631676 - Adding get vault access details
#                           endpoint
#    illamas     09/08/23 - Enh 35677356 - GI support
#    gvalderr    09/01/23 - Enh 35751657 - Adding delete sshkeys endpoint
#    byyang      08/26/23 - bug 33754780 enhance schedule cmd usability
#    ddelgadi    08/23/23 - Bug 35723608 - Include masked for sensitive info
#    zpallare    08/14/23 - Enh 35617595 - Get payload for some operation
#    gvalderr    08/10/23 - Correcting order of statementes of
#                           do_getsanityresults_kvmroce
#    zpallare    08/07/23 - Enh 35587158 - List all nat ips from dom0
#    jzandate    08/04/23 - Enh 35651071 - Adding delete ECRA_FILE from date
#    ybansod     07/25/23 - Enh 35475687 - Add ecracli commands for system
#                           vault CRUDL operations
#    anudatta    07/14/23 - ENH 35548767 - Precheck Reshape Exacompute
#    hcheon      07/10/23 - 34764008 Log search url for given request
#    llmartin    07/04/23 - Enh 34851277 - Preprov, use 3-level commands
#    illamas     07/04/23 - Enh 35300907 - vm restore exacompute
#    abysebas    06/27/23 - EXACS-114022 - Fetch vault OCID and feed it into
#                           the deployment.config and application.json.
#    jzandate    06/26/23 - Enh 35156973 - Adding Capacity Move
#    caborbon    06/26/23 - Bug 35537841 - Fixing missing comma issue
#    ririgoye    06/22/23 - Enh 35319264 - EXACS MVM: CREATE DROP
#                           EXADATAINFRASTRUCTURE API
#    caborbon    06/20/23 - ENH 35402932 - Adding capacity compatibility
#                           command
#    ybansod     06/17/23 - ENH 35454583 - ADD ECRA API FOR EDV
#                           VOLUMEMOUNTNAMES PRECHECK
#    gvalderr    06/14/23 - Adding capacity filesytem definitions command
#    gvalderr    05/18/23 - Adding endpoint for giving free capacity
#    illamas     05/15/23 - Enh 35268841 - Exacompute templates
#    illamas     05/13/23 - Enh 35268795 - Store nodeOcid and initiator
#    rmavilla    05/12/23 - exacs-96388 ECRA: Bonding Precheck API should
#                           support async URI functionality for all scenarios.
#    jiacpeng    05/09/23 - Add enable SLA by tenancy
#    gvalderr    05/09/23 - Adding endpoint for updating and getting
#                           status_comment for node and cabinet
#    gvalderr    05/05/23 - Adding endpoints of exacompute for providing kvm
#                           host sshkey
#    jzandate    05/05/23 - Enh 35108484 - Adding get,delete,create DNS methods
#                           to OciResource
#    aadavalo    05/04/23 - EXACS-104356 - Adding vmbackup suconfig creation
#    jzandate    05/04/23 - Bug 35346701 - updating cli, removing non existing
#    antamil     04/28/23 - ENH 35091346 - ECRA CLI TO REGISTER,DERGISTER
#                           and GET LAUNCH NODES
#    gvalderr    04/24/23 - Adding command for updating xml of a cabinet
#    jzandate    04/20/23 - Enh 35161257 - Adding oci conectivity check
#    gvalderr    04/18/23 - Adding cabinets get elastic large command
#    ririgoye    04/18/23 - Added ExaCSPreprov correction and Preprov jobs
#                           endpoints
#    kukrakes    04/12/23 - ENH 35276852 - ADD SANITY CHECK API FOR THE
#                           PROVISIONING OF A CLUSTER CONFIG IN ECRA
#    aadavalo    04/11/23 - Enh 35132786 - vm backup support for dom0 sending
#    jzandate    03/24/23 - Enh 35064903 - Add compute oci apis
#    jzandate    03/21/23 - Enh 35108484 - Adding Network wrapper for oci apis
#    rmavilla    03/21/23 - exacs-91468 ALLOW ECRA TO IMPORT A PARTIALLY
#                           INGESTED CABINET
#    antamil     03/14/23   - Enh 35108948 cli support for qfab patch
#    anudatta    04/18/22 - Bug 35281539 : Precheck API for  exadatainfrastructure reshapecluster operation
#    illamas     03/11/23 - Enh 35080777 - Exacompute scale
#    jzandate    03/08/23 - Enh 35048451 - adding api calls for oci compute
#                           client
#    luperalt    03/02/23 - Bug 35112601 Added enableVMConsole command
#    ririgoye    02/20/23 - Enh 34402212 - REQUIREMENT FOR HEALTH CHECK API
#    luperalt    02/16/23 - Bug 34926012 Added vmconsole for Serial VM console
#    jzandate    02/03/23 - Bug 34863490 - Adding new operation for bonding
#                           status
#    rgmurali    02/01/23 - Enh 34925514 - Add node to MD mapping support
#    jvaldovi    01/24/23 - Enh 34825983 - Ecra: Create Endpoint To Enable Sop
#                           Calls From Ecra
#    piyushsi    01/24/23 - BUG 3494150 Workflow Reload option for
#                           Active-Active
#    illamas     01/16/23 - Enh 34983763 - Endpoint restart monitor
#    illamas     01/10/23 - Enh 34901089 - List racks with oracle hostname
#    llmartin    01/06/23 - Enh 34865282 - Bonding consistency check endpoint
#    abysebas    01/03/23 - EXACS-104079 : Refresh credentials after updating
#                           password
#    pverma      12/18/22 - ocicapacity release/reserve API imple
#    gvalderr    12/14/22 - Adding get file command from ECRA_FILES table
#    rgmurali    12/05/22 - ER 34696811 - Provide unlock API
#    ririgoye    11/25/22 - Enh 33467698 - Added analytics operation details
#                           subcommand
#    pverma      11/22/22 - Add new command option fixXmlActionTag for
#                           ocicapacity
#    jzandate    11/15/22 - Bug 34700954 - Adding rack drop to ecracli
#    jiacpeng    11/04/22 - adding the api for getting the SLA based on
#    aadavalo    10/24/22 - Enh 34582054 - Adding cli interaction with user
#                           management API
#    ybansod     10/21/22 - Bug 34613544 - Adding command to get wf_server
#                           status
#    rgmurali    10/17/22 - ER 34325936 - MD support in ECRA
#    pverma      10/03/22 - Restore allocation cmd imple
#    ririgoye    09/30/22 - ECRACLI TO PARSE PARAMETERS SPACING CORRECTLY
#    jzandate    09/20/22 - Bug 34616926 - Adding domu command to ecracli
#    jvaldovi    09/15/22 - Enh 33994048 - Ecra To Send Region Info On Exacloud
#                           Start Call, Remove Region Endpoint Call
#    rmavilla    09/13/22 - EXACS-96336 ECRA - VM Move in
#                           Exacompute/ExascaleEXACS-96339 ECRA - VM Move
#                           Sanity Check in Exacompute/Exascale
#    illamas     09/13/22 - Enh 34567610 - Support error code for exadb-v
#    rgmurali    09/08/22 - ER 34544811 - Support linkfailover for bonding
#    aadavalo    09/06/22 - Enh 34552077 - Adding update fault domain
#    illamas     09/01/22 - Enh 34530558 - List VMs based on oracle hostname
#    illamas     08/30/22 - Enh 34411011 - Active cavium
#    aadavalo    08/26/22 - Enh 34534047 - adding complete inventory commands
#    rmavilla    08/24/22 - EXACS-73257 PROVIDE ECRA APIs FOR CAVIUM OPERATIONS
#                           TO SUPPORT CAVIUM REPLACEMENT IN BONDED NODE AND
#                           CLUSTER
#    jzandate    08/22/22 - Enh 34511129 - Adding command to ping exaunit vm
#    aadavalo    08/22/22 - Enh 34453046 - Adding get all fault domains command
#    ririgoye    08/04/22 - Enh 34409795 - Added inventory summary sub-op
#    bshenoy     07/16/22 - Bug 34184276: Endpoint to save FS location & ecs
#                           series for dyn task tar
#    caborbon    07/12/22 - Bug 34343793 - Adding info option to
#                           exadatainfrastructure command
#    rgmurali    06/24/22 - ER-34318923 - Add spare cavium ip updation
#    llmartin    06/13/22 - Enh 34235229 - Patch XML with missing nodes
#    aadavalo    06/09/22 - Enh 34248435 - EXACS - CREATE VALIDATE XML ENDPOINT
#                           FOR A RACK
#    jyotdas     06/08/22 - 34203244 - CURL endpoint to return debug and log
#                           metadata on patching
#    hcheon      06/02/22 - 34166256 Added SLA of tenancies
#    illamas     05/30/22 - Enh 34165620 - Adding support to show post checks
#                           templates
#    illamas     05/20/22 - Enh 34165620 - Adding support to purge singleton
#    aadavalo    05/09/22 - Bug 34124066 - Adding method for waiting for async
#                           call
#    ddelgadi    05/05/22 - Bug 33195567 - Added parameter to profiling to
#                           consulting for celocid
#    jyotdas     05/05/22 - Enh 34042024 - Ecra api to display all prior patch
#                           versions
#    marislop    04/21/22 - ENH 34009216 - dataplane diagnostics
#    jreyesm     04/19/22 - Enh 34050387 - cabinet info command for details.
#    abherrer    04/13/22 - added new commands to get all service types and
#                           to add a new one
#    rgmurali    04/12/22 - Enh 34062991 - Support exascale ip range
#    ashisban    04/05/22 - Enh 34036211 - IMPLEMENT ECRACLI COMMANDS FOR
#                           EXISTING RESHAPE PRECHECK APIS IN ECRA
#    aadavalo    03/30/22 - Bug 34003576 - inventory command not present in
#                           available_commands
#    aadavalo    03/29/22 - ER 33817649 - Adding exaunit getcspayload command
#    marislop    03/04/22 - ENH 33911804 - support for ECRA/agent communication
#    llmartin    03/04/22 - Enh 33408159 - Delete cell API
#    aadavalo    02/23/22 - Enh 33846431 - EXACS - ADD ECRACLI COMMAND TO GET
#                           INFO FROM XML
#    seha        02/18/22 - Bug-32260715 Run AV/FIM on a specific host
#    llmartin    02/15/22 - Enh 33055667 - OciBM Migration, SVM to MVM
#    hcheon      02/08/22 - 33691502 Added SLA gathering
#    illamas     01/28/22 - Enh 33509359 - Store and retrieve exacompute
#                           payload
#    essharm     01/25/22 - Bug-33676011 Adding ecracli command fro Activate
#                           Compute API
#    caborbon    01/25/22 - Bug 33630707 - Adding command to check Data
#                           integrity
#    llmartin    01/25/22 - Bug 33774620 - Creat command for InfraV2 backfill
#    pverma      01/20/22 - Elastic compute support
#    rgmurali    01/18/22 - ER 33539014 - T93 blackout support
#    jvaldovi    01/11/22 - Enh 33605620 - Ecra Deployer To Create
#                           Regions-Config.Json And Communicate Changes To
#                           Exacloud
#    illamas     01/03/22 - Enh 33676584 - Changing reshape input from JSON to
#                           arguments in ecracli
#    jyotdas     12/20/21 - Enh 33095986 - Cleanup exadata bundle patches and
#                           images regularly in EXACS
#    aadavalo    12/20/21 - Bug 33678279 - X9M FIX CAVIUM COLLECT DIAG NOT
#                           RETURNING INFO
#    aadavalo    12/14/21 - Enh 33612595 - VM-BACKUP: OS VM BACKUP TOOL NEEDS
#                           TO PROVIDE SUPPORT FOR FAILED BACKUPS
#    illamas     12/14/21 - Enh 33508854 - Delete cluster exacompute
#    illamas     12/09/21 - Enh 33508821 - Create Service exacompute
#    rgmurali    12/09/21 - ER 33509397 - Chaine state store support
#    hcheon      12/07/21 - 33496439 Added inventory resetvlan
#    illamas     11/22/21 - Enh 33509425 - Exascale - exacompute ports
#    llmartin    10/21/21 - Enh 33318820 - ExaCS MVM, Add storage
#    aadavalo    10/19/21 - Enh 33431064 - ECRA CREATE NEW ENDPOINT FOR
#                           COLLECTING T93 DIAG INFO FROM ILOM
#    piyushsi    10/14/21 - BUG 33055662 Exacs MVM Reshape Support
#    rgmurali    10/09/21 - ER 33159369 - Gcs data requirements
#    jreyesm     10/03/21 - E.R 33396336. Rack nodes get command.
#    rgmurali    09/28/21 - ER 33324107 - Support X9M_Cloud in ecracli
#    jreyesm     09/27/21 - E.R 33396326. Backfill api for mvm
#    aadavalo    09/17/21 - Enh 33304243 - ECRA CREATE NEW ENDPOINT FOR TURN
#                           OFF T93 SLOT
#    llmartin    08/27/21 - Enh 33055649 - AddCluster API for MVM
#    rgmurali    08/24/21 - ER 32256415 - Bonding custom vip support
#    rgmurali    08/23/21 - Er 33250690 - Add delete endpoint for vmbackuposs
#    rgmurali    08/12/21 - Enh 33186942 - Update cabinet details
#    marislop    08/06/21 - ENH 32941844 Filesystem encryption
#    illamas     08/04/21 - Enh 33055641 - New apis for rack reserve/release
#    rgmurali    08/03/21 - ER 33027372 - Bond monitor rpm update support
#    piyushsi    08/02/21 - BUG 33181471 - CLUSTERLESS OPERATION SUPPORT IN
#                           ROLLING UPGRADE AND ECRACLI
#    illamas     07/26/21 - Bug 33141790 - Automatic policy store should
#                           include network communication
#    sringran    07/05/21 - ER 33011365 - DELETING EXASERVICE WITH NO VM CLUSTERS
#                           SHOULD NOT CALL EXACLOUD
#    rgmurali    06/28/21 - ER 33056005 - APIs for cabinets/nodes
#    marislop    06/16/21 - ENH 32925891 - New command to get details on
#                           computes and cells
#    oespinos    06/15/21 - Bug 32496937 - New commands for password rotation
#    rgmurali    06/07/21 - ER 32926443 - Support canonical QFAB names
#    piyushsi    06/04/21 - Bug 32949627 - ECRA API TO RETURN ATP PREPROV
#                           INFORMATION
#    illamas     06/03/21 - Enh 32894712 - Operations for a given rack
#    hcheon      06/03/21 - 32811546 DB connection pool usage monitoring
#    rgmurali    05/17/21 - ER 32810345 - Support bonding migration
#    rgmurali    05/16/21 - ER 32893441 - precheck for bonding
#    byyang      05/12/21 - bug 32322406. add pre_logcol cmds
#    jreyesm     05/01/21 - E.R 32817912. Add security command.
#    marislop    04/29/21 - ENH 32702798 Added upgrade history command
#    illamas     04/29/21 - Enh 32677648 - Update se linux policy on
#                           provisioned clusters
#    jreyesm     04/13/21 - E.R add detail_update command
#    bshenoy     04/01/21 - Bug 31808416: new endpoint to download nw
#                           validation report
#    llmartin    03/29/21 - Bug 32695923 - Initialize exaunit map
#    illamas     03/12/21 - Enh 32479332 - Cloud Exadata Infrastrucure creation
#    bshenoy     03/08/21 - Ecracli support for updating Infra Status
#    aadavalo    03/05/21 - Adding endpoint to get config check
#    luperalt    03/05/21 - Bug 32587402 Added elastic commands
#    rgmurali    03/04/21 - Bug 32587586 - Add agentAuth to instance metadata
#    piyushsi    02/26/21 - BUG-32548442 Workflow Pause Ecracli Implementation
#    rgmurali    02/25/21 - ER 32481148 - Sanity check API for RoCE
#    llmartin    02/15/21 - Enh 32471858 - Update TZ in rack XML
#    rgmurali    01/26/21 - ER 32416102 - VMbackup support with OSS
#    rgmurali    01/25/21 - ER 32421802 - Store the monitor bonding payload in ECRA
#    jvaldovi    01/08/21 - bug 31981072 - Profiling for specific operations
#    rgmurali    01/02/21 - ER 32133333 - Support Elastic shapes
#    rgmurali    12/28/20 - ER 32300454 - APIs for fabrics, cabinets & nodes
#    illamas     12/08/20 - Enh 32015878 - Support for X9 models
#    rgmurali    12/08/20 - ER 31416683 - Add the backfill API
#    marcoslo    11/30/20 - ER 31712130 - create XML for compose elastic rack
#    marcoslo    11/12/20 - ER 31881281 - Ability to delete elastic compute and
#                           storage
#    seha        11/11/20 - Bug-31635349 Upload report to CSS bucket
#    hcheon      11/11/20 - ER 32100233 - Add diagnosis ignore command
#    jyotdas     11/10/20 - ENH 31997453 - Ecra API to list patch updates
#    illamas     11/09/20 - Enh 32061490 - Adding coredump feature support
#    luperalt    10/29/20 - Bug 31887036 Added migrateVpnToWSS command
#    llmartin    10/19/20 - Enh 31944421 - MultipleOperations cancel task
#                           feature
#    marcoslo    10/14/20 - ER 31712130 - Add Async inventory operation
#    jyotdas     10/13/20 - Enh 31684095 - Provide option to Register Exadata
#                           Patch Versions
#    jyotdas     09/30/20 - Bug 31869208 - ECRA Interface for CPS OS Patching
#    josedelg    09/24/20 - Enh 31646088 - Add new exaversion patches report
#    marcoslo    09/24/20 - ER 31816960 Add support for jumbo frames
#    bshenoy     09/21/20 - Bug 31913586: Ecracli support for cps sw patching
#    piyushsi    09/14/20 - BUG-31862843 Mark task fail for workflows
#    marcoslo    09/11/20 - ER 31856863 add hardwareinfo/cloudvnuma operations
#    illamas     09/07/20 - Enh 31783059 - Analytics for all endpoints
#    nisrikan    08/25/20 - Bug 31791748 - BACKPORT OPCTL FIXES TO MAIN
#    rgmurali    08/23/20 - ER 31789990 - Cabinet level clis
#    rgmurali    08/15/20 - Bug 31536477 - Fix fortify issues
#    llmartin    08/10/20 - Enh 31120036 - Top level monitoring API
#    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
#    illamas     08/03/20 - Enh 31657170 - Exassh endpoint to update records in
#                           exassh table
#    rgmurali    08/01/20 - ER 31695260 - ECRA-infra patch integration for X8M
#    rgmurali    07/22/20 - ER 31543012 - Bonding setup APIs
#    marcoslo    07/21/20 - ER 31626667 -for hardware/properties
#                           endpoint
#    marcoslo    07/21/20 - Add commaBug 31626667 -for hardware/properties
#                           endpoint
#                           endpoint
#    rgmurali    07/09/20 - Bug 31522598 - Use Popen with shell=False
#    hcheon      07/02/20 - ER 31568956 Use -u option without password
#    hcheon      06/30/20 - ER 31152543 Inventory check command
#    marcoslo    06/23/20 - Add new requestId parameter to ecracli
#    sdeekshi    01/07/20 - Bug 31564449: CLEANUP NON USEFUL XIMAGES CODE
#    rgmurali    06/23/20 - Bug 31522598 - Security issue for not using popen
#    rgmurali    06/04/20 - ER 31334566 - Bonding info API
#    itcherna    06/03/20 - 31441342 - RETIRE CODE FOR ECS DIAG TOOL
#    rgmurali    05/14/20 - ER 30952096 - Support dbsytemId in delete service
#    piyushsi    04/27/20 - BUG 31086118 Cancel the current workflow task
#    nisrikan    04/23/20 - ER 31169019 - Add CCA operations
#    rgmurali    04/21/20 - ER 30971270 Inventory reserve/release APIs
#    rgmurali    04/20/20 - ER 31201148 Add list fabric support
#    jreyesm     04/17/20 - E.R 31127541. Refactor inventory for OCI.
#    jvaldovi    04/14/20 - Enh 30854165 - Adding update_memory command to
#                           exaunit set of commands
#    luperalt    04/02/20 - Bug 31040089 Adding new commands for the secret
#                           service
#    pverma      03/19/20 - Support for OCI-ExaCC SVM->MVM migration
#    bshenoy     03/23/20 - Bug 31055331: Support MVM reshape operations
#    aabharti    03/18/20 - ER 31000123 - API to seed admin tenancy details
#    llmartin    03/17/20 - Enh 30971142 - Get DomU key to get access for
#                           elastic
#    jreyesm     03/09/20 - E.R 30858091. Add Compute/elastic commands
#    rgmurali    03/06/20 - XbranchMerge rgmurali_bug-30870817 from
#                           st_ecs_pt-x8m
#    jloubet     02/26/20 - Changes to getExadataModel
#    jreyesm     02/19/20 - XbranchMerge rgmurali_bug-30802702 from
#                           st_ecs_pt-x8m
#    ananyban    02/03/20 - Bug 30840695: adding em enable/disable endpoint
#    luperalt    01/21/20 - Add new certificate rotation command
#    jaseol      12/30/19 - Bug 30666174 - replace logstash with rsyslog
#    rgmurali    12/02/19 - ER 30582157 Maintain OCI URL mappings
#    rgmurali    12/02/19 - ER 30550141 - List domu bonding racks
#    jreyesm     11/28/19 - Enh. recreate db
#    llmartin    11/14/19 - Enh 30538475 - Rack cells/domU unlock endpoint.
#    rgmurali    11/13/19 - Bug 30539823 Honor username from cmd line in exacc
#    jvaldovi    11/05/19 - Adding command to call 'add_vm_extra_size' exacloud
#                           endpoint to resize vm
#    rgmurali    10/30/19 - ER 30390456 Adding ExaCS profiling
#    illamas     10/23/19 - ER 30432244 - Added databases/info in order to get
#                           a list of cdbs for a given ATP ExaUnitId
#    illamas     10/10/19 - Bug 29785842 - Added Metadata operation in cli, in
#                           order to select and update values of some allowed
#                           tables
#    rgmurali    10/07/19 - ER 30383122 - Add ATP bootstrap API
#    rgmurali    10/02/19 - ER 29845757 - Add observer delete support
#    byyang      09/25/19 - ER 30308961. Add diagnosis plgmon. Rename diagcollect to logcol
#    bshenoy     09/22/19 - Bug: 30288886 list exadata target applied version
#    rgmurali    03/03/20 - ER 30870817 - Fabric addition APIs
#    rgmurali    02/13/20 - ER 30802702 - Add IP Pool support for KVM RoCE
#    rgmurali    01/24/19 - ER 30663489 - KVM RoCE Vlan pool management
#    jloubet     11/21/19 - Adding centralized regex for exadata validation
#    aanverma    09/19/19 - Bug #30125180: Mask password while logging ecracli
#                           commands
#    rgmurali    09/12/19 - ER 30299292 - Reset properties automatically after delete
#    jvaldovi    09/05/19 - Adding atp validateHealth command
#    ananyban    09/03/19 - ER 30250741: Adding EM add/update/delete cmd
#    hcheon      08/28/19 - bug-30208357 add compliance status command
#    illamas     08/26/19 - Added request confirmation in some delete
#                           operations
#    ananyban    08/20/19 - Bug 29285599: Adding interface for EM setup
#    byyang      08/19/19 - ER 30150021. Add diagnosis diagcollect
#    rgmurali    08/15/19 - ER 30035718 - Add Exawatcher support
#    llmartin    08/14/19 - Enh 30175171 - Rack cli to dump XML to the file
#                           system
#    rgmurali    08/02/19 - Bug 30135591 - Get the observer SSH keys
#    pverma      08/01/19 - Support for VPN HE details management fron ECRA
#                           Ecracli
#    bshenoy     07/29/19 - XbranchMerge bshenoy_bug-29875966 from
#                           st_ebm_19.1.1.0.0
#    hcheon      07/31/19 - bug-30025165 add compliance command
#    pverma      07/27/19 - Support for Cipher password related APIs.
#    byyang      07/21/19 - ER 30065482. ExaCD-A intg with Otto.
#    jvaldovi    07/18/19 - Adding update cidr operation
#    jvaldovi    07/19/19 - Adding profiling operation cli
#    csmarque    07/10/19 - atp configRule command
#    joseort     07/02/19 - Creating methods for enable and disable heartbeat
#                           scheduler, to avoid ecra restart.
#    sachikuk    07/01/19 - Bug 29216924: Remove ecracli_key_passwd from
#                           ecracl.cfg
#    anupanda    06/13/19 - 29899573: Asynchronous call to script and restructuring
#    jloubet     06/25/19 - Adding vm rollback
#    hhhernan    06/24/19 - 29802719 avoit prompting in ExaCC/OCC env detection
#    joseort     06/20/19 - Use OciExadata for retrieving all racks to ping.
#    csmarque    06/19/19 - Adding exaunit hasOperation cmd
#    joseort     06/18/19 - Adding cli for heartbeat.
#    aabharti    06/12/19 - 29859890 ExaccOCI workflow abort API
#    jvaldovi    05/26/19 - Addding funcionality for ReqOperations endpoint
#    ananyban    05/22/19 - Adding EM cmds
#    hhhernan    05/21/19 - 29740321 OCC-ExaCC pre checks
#    sringran    05/20/19 - ExaccOCI - Workflow changes 29716990
#    llmartin    05/14/19 - Add ExaCC Activate command
#    pverma      05/13/19 - Pre-Activation APIs
#    jvaldovi    04/29/19 - Adding code to exit with proper <0|1> exit code of
#                           script
#    hgaldame    04/23/19 - 29236318 : adding X8-2 support
#    sringran    04/16/19 - ExaccOCI workflow management. 29447581, 29466791, 29466828, 29668448, 29447509
#    llmartin    04/12/19 - ENH 29538644 - OCI/EXACC Network Object API
#    jvaldovi    04/11/19 - Sort help commands of ECRACLI BUG 29617739
#    jvaldovi    04/11/19 - Enh 29371638 Adding functionality to ECRA to accept
#                           up to three sub commands
#    hhhernan    04/08/19 - 29595482 get auth in occ env
#    jloubet     04/08/19 - Adding endpoint to sync rack slots
#    rgmurali    04/08/10 - Bug 29617694 - Fix output of atp deleteNetwork
#    rgmurali    04/01/19 - ER 29530642 Support for move capacity
#    diegchav    04/01/19 - ER 29553245 : Integrate subnetpool creation with
#                           terraform ingestion
#    llmartin    02/18/19 - ENH 29266406 - Elastic, command to change ASM
#                           rebalance power
#    hhhernan    02/12/19 - 29331153 Read password from file system
#    csmarque    02/05/19 - Adding multiops
#    rgmurali    02/04/19 - Bug 29254948 - Introduce srguser for SRGs
#    sachikuk    01/24/19 - Bug - 29196199 : REST APIs for ATP pre provisioning
#                           scheduler
#    rgmurali    01/23/19 - ER 29121810 - Observer LCM operartions
#    rgmurali    01/16/19 - Bug 29170694 - Security fix for clear text passwords
#    csmarque    01/10/19 - Adding Exaservice resourceinfo command
#    rgmurali    01/15/18 - Bug 29132107 - Fix multiple logging in ecracli
#    piyushsi    12/20/18 - ENH 28943345 - ECRA API SKELETON - GIServiceStop
#    diegchav    12/18/18 - ER 29062402 - ATP: Reconfig service
#    rgmurali    12/12/18 - Bug 29050191 - Get observer instance details endpoint
#    sachikuk    12/05/18 - XbranchMerge sachikuk_bug-28943104 from
#                           st_ebm_18.2.5.2.0
#    aanverma    12/03/18 - Bug #28843249: Lex split the input line
#    sachikuk    11/22/18 - Bug 28943104: Support mTLS authentication between
#                           ecracli and ECRA
#    srtata      02/12/18 - bug 27550083: add cns receive
#    llmartin    11/13/18 - Bug 28895194 - PDB metadata support
#    aanverma    10/09/18 - Bug #28662168: Add location details command
#    llmartin    10/03/18 - Bug 28731307 - Grid version 19, temporary fix
#    jloubet     09/24/18 - Created service and Database modules
#    sachikuk    09/13/18 - Bug 28643725 - ecracli changes for brokerproxy
#    diegchav    09/12/18 - ER 28633340 : Data model to support ATP whitelist
#    piyushsi    09/06/18 - BUG 28435880 - Site/AD modeling
#    diegchav    09/03/18 - Bug 28565066 : Get rack hardware information from ECRA endpoint
#    llmartin    08/24/18 - BUG 28211648 - Change suspend_on_create location on
#    diegchav    08/21/18 - Bug 28487268 : Validate parameters for service
#                           command.
#    piyushsi    08/13/18   ENH 28465156 - Api to fetch all rackslot information associated with exaservice id
#    sgundra     08/13/18 - XbranchMerge sgundra_bug-28223653 from
#    rgmurali    08/02/18 - Bug 28388547 - register OM VCN components and details
#    piyushsi    07/19/18 - ER  28370708 - EXACM: Ecra API to fetch client and backup network info
#    rgmurali    07/18/18 - Bug 28368747 - deleteAtpNetwork REST API
#    rgmurali    07/09/18 - Bug 28313998 - getAtpPartnerSubnet API
#    rgmurali    07/07/18 - XbranchMerge rgmurali_bug-28181495 from
#                            st_ebm_18.2.5.1.0
#    diegchav    07/03/18 - Bug 28258133 - Implement operation to abort pending
#                           requests.
#    brsudars    07/01/18 - Add postfetch and postupdate cmds for multi-mv
#                           migration
#    sdeekshi    06/08/18 - Bug 28189332 : Add ecra ximages image management apis
#    hnvenkat    06/29/18 - Bug 28262410 Fixed regression due to delete_user/role addition
#    piyushsi    06/26/18 - E.R 28112751 - ECRA API AND ECRACLI FOR FETCHING SSH KEYS FROM EXACLOUD
#    piyushsi    06/26/18 - E.R 27850198 - CREATE ZONAL REQUEST TRACKING FEATURE IN ECRACL
#    rgmurali    06/19/18 - Bug 28181495 Subnet sizing for ATP
#    jreyesm     06/21/18 - Bug 28223621. Gen2payload atp params should have
#                           priority over ecracl.cfg
#    sgundra     06/19/18 - Bug-28204941 : Exaservice suspend/resume endpoints
#    jreyesm     06/18/18 - E.R 28186833. Moved atp code for all flows
#    nmallego    06/13/18 - ER Bug28155938 - Pass additional arguments for
#                           exadata infra patching and integrate of ibswitch
#                           upgrade per rack basis
#    rgmurali    06/06/18 - Bug 28129580 - REST endpoint for ATP register VNIC
#    rgmurali    05/31/18 - ER 28109468 - Get ATP Network endpoint
#    jreyesm     05/31/18 - E.R 28043393. Rename atp_enaled for AutonomousDb
#    llmartin    05/30/18 - Bug 28085752 - parse_params/validate_parameters fix
#                           error messages
#    dekuckre    05/25/18 - 28060479: Add userconfig commands
#    llmartin    05/17/18 - Bug 27896448 - Handle Exacloud failure timeout with
#                           appropriate message
#    jgsudrik    05/10/18 - Handling of autonomousDB parameter in create
#                           service.
#    rgmurali    05/08/18 - Bug 27995482 - REST endpoint for hardware properties
#    sgundra     05/11/10 - Bug-28013177 - Create service support for Iaas/Paas
#    sgundra     04/30/18 - Bug 27947099 - Exaunit Suspend/Resume
#    jreyesm     04/17/18 - Bug 27351303. Add higgs subnet ignore functionality
#    jreyesm     04/12/18 - Bug 27824348. Elastic Storage mgmt.
#    dekuckre    04/04/18 - 27703864: Add vmbackup commands.
#    jreyesm     04/03/18 - Bug 27796041. Add Ecralog extraction command.
#    vgerard     02/22/18 - Higgs audit command
#    llmartin    04/04/18 - Bug 27759881 - Higgs: NAT ip secrules
#    hhhernan    03/23/18 - 27572737 support base system as racksize
#    brsudars    03/21/18 - Multi-vm migration changes
#    llmartin    03/20/18 - Bug 27663955 - Migrate admin_username, appidUser
#                           and appidPwd to ecracli.cfg
#    sgundra     03/14/18 - Bug-27687516 - Double Rack support
#    llmartin    03/01/18 - Bug 27186959. Add flags for higgs client/backup
#                           network and subscription id.
#    sgundra     03/09/18 - Bug 27663955 - create service with rackname/racksize
#    jreyesm     02/15/18 - Bug 27520916. NodevIps/scanvIps generation
#    jreyesm     02/02/18 - Bug 27011241. Exaunit VM log extraction
#    rgmurali    02/01/18 - Bug 27275671 - Use compute endpoint from TAS payload
#    aschital    01/11/18 - Bug 27244265. Log user details for ecracli operations
#    jreyesm     01/10/18 - DBRegister not working when dbSID provided.
#    jreyesm     01/10/18 - Bug 27244251. Prompt user/password if empty
#    jreyesm     12/17/17 - Bug 27278178. Provide dependent_links element for
#                           NOSDI.
#    jreyesm     12/05/17 - Bug 27207485. Show appropiate message if ECRA is
#                           down.
#    brsudars    11/30/17 - delete_cluster will return 202 instead of 200
#    brsudars    11/22/17 - Add reshape exaservice multi-vm command
#    jreyesm     11/17/17 - Bug 27137450. Add Higgs register/deregister
#                           commands.
#    jreyesm     11/09/17 - Bug 27090986. Add Higgs prepare bond0
#                           functionality.
#    brsudars    11/08/17 - Multi-vm changes
#    sachikuk    11/08/17 - Bug - 27086265 : Enhance rack slot registration
#    sgundra     11/08/17 - Bug-27063758 : Support X7 hardware
#    srtata      11/07/17 - bug 27034487: enable/disable cns at rack level
#    brsudars    10/26/17 - Add PickRackSize to service_specific_payload for
#                           nosdi
#    rgmurali    10/24/17 - Bug 26823575 - Add APPID support for higgs.
#    jreyesm     10/10/17 - Bug 26949879. Support grid_bp parameter to select
#    sachikuk    10/03/17 - Bug - 26885989: ecra endpoints for customer network
#                           info management
#    hgaldame    09/29/17 - XbranchMerge hgaldame_bug-26359353 from
#                           st_ecs_17.2.6.0.0exacm
#    sachikuk    09/26/17 - get capacity details endpoint [Bug - 26860773]
#    aanverma    09/18/17 - Bug #26819554: Add Jumbo Framework support
#    sachikuk    09/10/17 - Reserve/release capacity for multi-vm [Bug -
#                           26748905]
#    rgmurali    09/09/17 - Bug 26409403 Override VM memory size.
#    rgmurali    09/09/17 - Bug: 26702797 - Set mincores after detecting the
#                           platform
#    srtata      09/07/17 - cns setup should take exauniId
#    dekuckre   09/06/17 -  Bug 26735879: Add do_get_clientkeys
#    sachikuk    08/29/17 - New rack register/deregister flows for multi-vm
#                           [Bug - 26574643]
#    srtata      08/20/17 - bug 26657194: add setup endpoint
#    byyang      08/19/17 - Bug 26624287: add scheduler
#    sachikuk    07/26/17 - Disable cell shredding for dev mode [Bug-26524020]
#    srtata      07/15/17 - bug 26309263: add cns commands
#    brsudars    07/11/17 - is_ha and zone name fields will be sent by TAS as
#                           part of service_specific_payload
#    brsudars    07/24/17 - Change in burst flow payload for nosdi
#    brsudars    06/23/17 - Generate nosdi request for update cores
#    nkedlaya    06/18/17 - bug 26242636 : patching payload can accept either
#                           clustername or exauntid
#    hhhernan    06/15/17 - XbranchMerge
#                           hhhernan_corevalues_fix_17.2.6.0.0exacm from
#                           st_ecs_17.2.6.0.0exacm
#    hhhernan    06/15/17 - XbranchMerge angfigue_corevalues_fix from
#                           st_ecs_17.1.4.0.0exacm
#    rgmurali    06/14/17 - Bug 26123554 - Fixing delete_db
#    rgmurali    06/12/17 - Bug 26248932 - Issue with parse_params
#    sgundra     06/06/17 - Bug-26222189 : domukeys endpoint
#    nkedlaya    06/06/17 - bug 25892555 - make DOMU patching a standalone
#                           action like IB switch patching
#    brsudars    05/29/17 - Add HA options to nosdi create service
#    rgmurali    04/21/17 - 25961135 - Refactor Ecracli code
#    rgmurali    04/13/17 - 25927451 - Add help support similar to ADE
#    xihzhang    04/13/17 - Bug 25683130 BM: add opstate attribute for racks
#    sdeekshi    04/05/17 - Bug 25570415 - delete service should return success if exaunitid not found
#    hhhernan    03/31/17 - Port 25765772
#    sgundra     03/30/17 - Rename DELETE_STARTER_DB as ROLLBACK_STARTER_DB
#    brsudars    03/30/17 - Add support for no SDI create service
#    brsudars    03/26/17 - Add username and passwd to add_zone command
#    sgundra     03/21/17 - Bug-25752523: implement put_property
#    brsudars    03/13/17 - Add support for ECRA zones
#    hhhernan    03/09/17 - Bug 25697839 racksize parameter in register_rack
#    xihzhang    03/03/17 - Bug 25660990 BM: implement listCapacity
#    xihzhang    02/28/17 - Bug 25619867 BM: implement reserveCapacity
#    ededgarc    01/31/17 - Exposing parameter backuptodisk
#    ededgarc    01/26/17 - Expose backupToDisk parameter from ecracli
#    ijassi      12/28/16 - Fix ECS DG endpoints
#    angfigue    11/07/16 - fix error
#    ijassi      11/03/16 - DG provisioning
#    hhhernan    10/27/16 - Adding the commands structure <op> <subop> <args>
#    angfigue    09/29/16 - dbpatch pdate to display the patching information
#    angfigue    09/20/16 - XbranchMerge angfigue_bug-24697086 from
#                           st_ecs_16.4.3.0.0
#    angfigue    09/12/16 - recovery endpoint
#    angfigue    09/09/16 - ecra logs support
#    angfigue    08/30/16 - fixing test case
#    angfigue    08/24/16 - data
#    angfigue    08/23/16 - update to use backup endpoints
#    angfigue    07/22/16 - XbranchMerge angfigue_bug-24328294 from
#                           st_ecs_16.3.5.0.0
#    angfigue    07/22/16 - ibswitch operation standalone
#    marrorod    07/14/16 - update for the new format of patching
#    angfigue    02/10/16 - dbpatch support
#    yifding     02/10/16 - creation


import ast
import base64
import cmd
import collections
import configparser
import datetime
import getpass
import json
import logging
import logging.handlers
import os
import pprint
import re
import socket
import sys
import time
import urllib.request, urllib.error, urllib.parse
import uuid
import http.client
import shlex
import defusedxml.ElementTree as et

from subprocess import Popen, PIPE
from optparse import OptionParser
from os import path

from clis.Sop import Sop
from util.constants import ECRACLI_MODES

from formatter import ExitCode
from EcraHTTP import HTTP
from formatter import cl
from clis.Capacity import Capacity
from clis.RackSlot import RackSlot
from clis.Mode import Mode
from clis.Clone import Clone
from clis.CNS import CNS
from clis.Cores import Cores
from clis.CreateSdb import CreateSdb
from clis.Dataguard import Dataguard
from clis.Database import Database
from clis.Diagnosis import Diagnosis
from clis.Ebtables import Ebtables
from clis.Exaservice import Exaservice
from clis.Exadata import Exadata
from clis.Exaunit import Exaunit
from clis.FaultInjection import FaultInjection
from clis.Healthcheck import Healthcheck
from clis.Higgs import Higgs
from clis.RemoteEc import RemoteEc
from clis.Idemtoken import Idemtoken
from clis.Info import Info
from clis.Iorm import Iorm
from clis.Patch import Patch
from clis.Properties import Properties
from clis.Queryreq import Queryreq
from clis.Rack import Rack
from clis.Schedule import Schedule
from clis.Service import Service
from clis.Sshkey import Sshkey
from clis.Status import Status
from clis.Testops import Testops
from clis.Vm import Vm
from clis.Zone import Zone
from clis.Jumbo import Jumbo
from clis.Inventory import Inventory
from clis.Formation import Formation
from clis.VMBackup import VMBackup
from clis.Hardware import Hardware
from clis.UserConfig import UserConfig
from clis.ATP import ATP
from clis.Location import Location
from clis.Cluster import Cluster
from clis.Tenants import Tenants
from clis.ComplexOperation import ComplexOperation
from collections import OrderedDict
from clis.Workflows import Workflows
from clis.WorkflowCtl import WorkflowCtl
from clis.ExaCC import ExaCC
from clis.Ocicpinfra import Ocicpinfra
from clis.EM import EM
from clis.Heartbeat import Heartbeat
from clis.Profiling import Profiling
from clis.Ecra import Ecra
from clis.Compliance import Compliance
from clis.ECSPatching import ECSPatching
from clis.Exawatcher import Exawatcher
from clis.ECSExadataVersion import ECSExadataVersion
from clis.Metadata import Metadata
from clis.Kvmroce import Kvmroce
from clis.Cca import Cca
from clis.Bonding import Bonding
from clis.Exacloud import Exacloud
from clis.Cabinet import Cabinet
from clis.Exaversion import Exaversion
from clis.Analytics import Analytics
from clis.CPSSWUpgrade import CPSSWUpgrade
from clis.CPSUpgrade import CPSUpgrade
from clis.Backfill import Backfill
from clis.ExadataInfra import ExadataInfra
from clis.Security import Security
from clis.InfraPassword import InfraPassword
from clis.PasswordManagement import PasswordManagement
from clis.GcsInfra import GcsInfra
from clis.Exacompute import Exacompute
from clis.Sla import Sla
from clis.Topology import Topology
from clis.SiteGroup import SiteGroup
from clis.Agent import Agent
from clis.Cache import Cache
from clis.Errorcode import Errorcode
from clis.Preprovision import Preprovision
from clis.Oci import Oci
from clis.DomU import DomU
from clis.User import User
from clis.VMConsole import VMConsole
from clis.Ingestion import Ingestion
from clis.PatchMetadata import PatchMetadata
from clis.Artifact import Artifact
from clis.Compatibility import Compatibility
from clis.ExascaleVault import ExascaleVault
from clis.ResourceBlackout import ResourceBlackout
from clis.Exascale import Exascale
from formatSensitiveData import formatSensitiveData


# ECRACLI_VERSION=1.1.0

# Prevent execution by root account
if os.geteuid() == 0:
    print('ECRACLI cannot be run as root. Exiting.')
    sys.exit(1)

####################################################
######  LOGGING SETUP                              #
####################################################

my    = path.abspath(__file__)
mydir = path.dirname(my)
mytmpldir = path.join(mydir, "tmpl")
mylogdir = path.join(mydir, "log")
mysshdir = path.join(mydir, "ssh_keys")
try:
    if not os.path.exists(mylogdir):
        os.makedirs(mylogdir)
except Exception as e:
    logging.error("Error creating the log dir, check the permissions : {0}".format(e))
    sys.exit(0)

try:
    if not os.path.exists(mysshdir):
        os.makedirs(mysshdir)
except Exception as e:
    logging.error("Error creating the ssh dir, check the permissions : {0}".format(e))
    sys.exit(0)

# mylog = path.join(mylogdir, datetime.datetime.now().strftime('%Y-%m-%d_%H:%M:%S') + "-ecracli.log")
mylog = path.join(mylogdir, "ecracli.log")

logger = logging.getLogger("ECRACLI")
handler = logging.handlers.RotatingFileHandler(mylog, maxBytes=5000000, backupCount=10)

FORMAT = "%(asctime)-15s - " + str(os.getpid()) + " - %(message)s"
fmt = logging.Formatter(FORMAT,datefmt='%Y-%m-%d %H:%M:%S')

handler.setFormatter(fmt)
while logger.handlers:
    logger.handlers.pop()
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.addFilter(formatSensitiveData())

interactive = False

#######################################################
#  COMMAND LINE INTERFACE CLASS                       #
#######################################################

class Ecracli(cmd.Cmd):
    prompt = 'ecra> '
    ssl_params = ["ecra_cert_file"]

    api_params = ["host",
                  "ecra_cert_file"
                ]

    json_tmpls = ["dbJson", "podJson"]
    available_commands = [
                          "ocitenants",
                          "ocicapacity",
                          "ocicpinfra",
                          "capacity",
                          "rackslot",
                          "cabinet",
                          "clone",
                          "cluster",
                          "cns",
                          "compliance",
                          "create_sdb",
                          "db",
                          "pdb",
                          "em",
                          "dg",
                          "ebtables",
                          "exaservice",
                          "exaunit",
                          "exadata",
                          "exawatcher",
                          "health_check",
                          "higgs",
                          "hardware",
                          "idemtoken",
                          "info",
                          "iorm",
                          "inventory",
                          "kvmroce",
                          "patch",
                          "properties",
                          "query_requests",
                          "rack",
                          "schedule",
                          "security",
                          "service",
                          "sitegroup",
                          "sla",
                          "sshkey",
                          "status",
                          "test",
                          "update_cores",
                          "vm",
                          "zone",
                          "location",
                          "jumbo",
                          "requests",
                          "ecralogs",
                          "vmbackup",
                          "userconfig",
                          "atp",
                          "switchmode",
                          "workflows",
                          "workflowctl",
                          "exacc",
                          "diagnosis",
                          "profiling",
                          "heartbeat",
                          "ecspatchversion",
                          "ecra",
                          "exadata_applied_version",
                          "metadata",
                          "backfill",
                          "exadatainfrastructure",
                          "bonding",
                          "opctl",
                          "exacloud",
                          "exaversion",
                          "analytics",
                          "patchcps",
                          "passwordmanagement",
                          "infrapassword",
                          "gcsinfra",
                          "exacompute",
                          "agent",
                          "cache",
                          "errorcode",
                          "preprov",
                          "oci",
                          "domu",
                          "user",
                          "vmconsole",
                          "patchmetadata",
                          "topology",
                          "artifact",
                          "compatibility",
                          "vault",
                          "faultinjection",
                          "resourceblackout",
                          "listsubmittedwfs",
                          "exascale"
                          ]

    minCoresPerRack = {"base system" : 16, "eighth": 16, "quarter" : 16,
                       "half" : 56, "full" : 112, "double": 176}
    minCoresPerPlatform = {"X4-2" : 8, "X5-2" : 8, "X6-2" : 8,"X7-2" : 8, "X8-2" : 8}
    purchasetypeMap = {"subscription" : "SRVC_ENTITLEMENT", "metered" : "CLOUD_CREDIT"}
    nodesToRacksize = {2 : "quarter", 4 : "half", 8 : "full", 16 : "double"}
    racksizes = ["Base System", "Eighth","Quarter", "Half", "Full","Double"]
    models = ["X5-2", "X6-2", "X7-2", "X8-2"]

    #Assumption that the cluster is multiVM with 8 clusters
    #if any other value of cores is needed, please use the cores parameter
    minCoresMultiVM = {"X4-2" : 4, "X5-2" : 4, "X6-2" : 4, "X7-2" : 4, "X8-2" : 4}


    interactive = False

    #***** <op> <subop> [<subop>] <options> *****#
    sub_ops = {
        "vm":{
            "start"  :"start_vm",
            "stop"   :"stop_vm",
            "restart":"restart_vm",
            "status" :"status_vm",
            "relation" :"relation_vm"
         },
        "sshkey":{
            "add"   :"add_sshkey",
            "delete":"delete_sshkey",
            "rescue":"rescue_sshkey",
            "get"   :"get_ssh_info",
            "createdomukey" : "createpublic_sshkey",
            "verifydomukey" : "verifypublic_sshkey",
            "deletedomukey" : "deletepublic_sshkey",
            "getdomukey"    : "getpublic_sshkey",
            "addadbskey"    : "addadbskey_sshkey",
            "removeadbskey"    : "removeadbskey_sshkey"
        },
        "rack":{
            "register"  :"register_rack",
            "deregister":"deregister_rack",
            "update"    :"update_rack",
            "get"       :"get_rack",
            "compose"   :"compose_rack",
            "reserve"   :"reserve_rack",
            "drop"      :"drop_rack",
            "release"   :"release_rack",
            "fetchatp"  :"fetchatp_rack",
            "getxml"    :"getxml_rack",
            "unlock"    :"unlock_rack",
            "exaid"     :"exaid_rack",
            "ports"     :"ports_rack",
            "nodes"     :"nodes_rack",
            "update_selinux_policy" : "update_selinux_rack",
            "list_selinux_policy"   : "list_selinux_rack",
            "update_custom_selinux_policy" : "update_custom_selinux_rack",
            "xml" : {
                "patch" : "rack_xml_patch",
                "patchnodes" : "rack_xml_patchnodes"
            },
            "getxmlinfo": "get_xml_info",
            "validatexml": "validate_xml",
            "updatexml": "update_xml",
            "sanitycheck": "run_sanitycheck_rack",
        },
        "idemtoken":{
            "new"  :"idemtoken_new",
            "renew":"idemtoken_renew"
        },
        "cabinet":{
            "list"    :"list_cabinet",
            "ports"   :"ports_cabinet",
            "update"  :"update_cabinet",
            "get"     :"getinfo_cabinet",
            "updatexml":"updatexml_cabinet",
            "getxml":"getxml_cabinet",
            "modelsubtype": {
                "convert": "model_subtype_convert",
                "convertlarge": "model_subtype_convert_large",
                "convertextralarge": "model_subtype_convert_extralarge",
                "convertstandard": "model_subtype_convert_standard",
                "getreport":"model_subtype_get_report",
                "releasenodes":"model_subtype_release_nodes"
                },
            "composexml"     :"composexml_cabinet",
            "domu" : {
                "get" : "get_domu_cabinet",
                "update" : "update_domu_cabinet"
            },
            "softdeletenode" : "softdeletenode_cabinet",
            "getnodes" : "getnodes_cabinet",
            "recovernode":"recovernode_cabinet",
            "purgenode": "purgenode_cabinet",
            "getnodestatusreport":"getnodestatusreport_cabinet",
            "getnodearchivedreason":"getnodearchivedreason_cabinet",
            "updatenodearchivedreason": "updatenodearchivedreason_cabinet",
            "getnodearchivedextrainfo": "getnodearchivedextrainfo_cabinet",
            "updatenodearchivedextrainfo": "updatenodearchivedextrainfo_cabinet",
            "ingestion": "ingestion_cabinet"
        },
        "zone":{
            "add"     :"add_zone",
            "list"    :"list_zone",
            "delete"  :"delete_zone"
        },
        "location":{
            "add"     :"add_location",
            "list"    :"list_locations",
            "delete"  :"delete_location",
            "details" :"details_location"
        },
        "inventory":{
            "register"   :"register_inventory",
            "deregister" :"deregister_inventory",
            "update"     :"update_inventory",
            "update_hwnode":"update_hwnode",
            "get_hardware" : "get_hardware_inventory",
            "reviewcapacity":"reviewcapacity_inventory",
            "get"        :"get_inventory",
            "reserve"    :"reserve_inventory",
            "release"    :"release_inventory",
            "check"      :"check_inventory",
            "getexcludelist" : "getexcludelist_inventory",
            "get_node_detail": "node_detail",
            "update_node_detail": "update_node_detail",
            "updatenodes" : "updatenodes_inventory",
            "resetcavium": "reset_cavium",
            "caviumcollectdiag": "cavium_collect_diag",
            "caviumdiagresponse": "cavium_diag_response",
            "resetvlan": "resetvlan_inventory",
            "startblackout" : "startblackout_inventory",
            "endblackout" : "endblackout_inventory",
            "getspec" : "getspec_inventory",
            "summary" : "get_inventory_summary",
            "updatestatuscomment":"update_status_comment",
            "getstatuscomment": "get_status_comment",
            "resetilomdefaultpassword": "reset_ilom_default_password",
            "resetilomvaultpassword": "reset_ilom_vault_password"
         },
        "exadatainfrastructure":{
            "create"     :"create_exadatainfrastructure",
            "get"        :"get_exadatainfrastructure",
            "delete"     :"delete_exadatainfrastructure",
            "rack_reserve"    :"rack_reserve_exadatainfrastructure",
            "rack_release"    :"rack_release_exadatainfrastructure",
            "add_cluster"     :"add_cluster_exadatainfrastructure",
            "reshapecluster" : "reshape_cluster_exadatainfrastructure",
            "reshapecluster_precheck": "reshape_cluster_precheck_exadatainfrastructure",
            "restorecluster" : "restore_cluster_exadatainfrastructure",
            "attachstorage" : "attach_storage_exadatainfrastructure",
            "attachstorage_exascale" : "attach_storage_exascale_exadatainfrastructure",
            "deletestorage": "delete_storage_exadatainfrastructure",
            "checkdataintegrity": "check_data_integrity_exadatainfrastructure",
            "migratetomvm" : "migrate_to_mvm_exadatainfrastructure",
            "info": "info_exadatainfrastructure",
            "computevms" : "computevms_exadatainfrastructure",
            "drop": "drop_exadatainfrastructure",
            "getinitialpayload": "exadatainfrastructure_getinitialpayload",
            "recoverclunodes_sop": "run_recoverclunodes_sop",
            "dropclunodes_sop": "run_dropclunodes_sop",
            "secureerase": "secureerase_exadatainfrastructure",
            "getsecureerasecert": "getsecureerasecert_exadatainfrastructure",
            "disablebackup": "disablebackup_exadatainfrastructure",
            "getkeys": "exadatainfrastructure_getkeys",
            "updatevmstate":"update_vm_state"
        },
        "backfill":{
            "caviumip"         : "caviumip_backfill",
            "adminsmartnics"  : "adminsmartnics_backfill",
            "update_caviumid"  : "update_caviumid_backfill",
            "qfabdetails"      : "qfabdetails_backfill",
            "mvmsubnetinfo"    : "mvmsubnetinfo_backfill",
            "fabricexascale"   : "fabricexascale_backfill",
            "updatecaviumip"   : "updatecaviumip_backfill",
            "updatesitegroup"  : "updatesitegroup_backfill",
            "update_cavium"    : "update_cavium_backfill", #update multiple cavium fields
            "vnic_cabinets"    : "vnic_cabinets_backfill"
        },
        "formation":{
          "delete"     : "delete_formation",
          "list"        : "list_formation"
        },
        "ocitenants":{
            "list"         : "list_ocitenants",
            "capacity"     : "list_capacity_ocitenants",
            "fleetcapacity": "list_fleetcapacity_ocitenants"
        },
        "ocicapacity":{
            "register"           : "register_ocicapacity",
            "details"            : "details_ocicapacity",
            "update"             : "update_ocicapacity",
            "delete"             : "delete_ocicapacity",
            "reserve"            : "reserve_ocicapacity",
            "getconfigbundle"    : "get_exa_cfgbundle_ocicapacity",
            "getcfgbundlecksum"  : "get_exa_cfgbundlecksum_ocicapacity",
            "getprivkey"         : "get_bastion_privkey_ocicapacity",
            "getcfgbundlepasswd" : "get_exa_cfgbundlepasswd_ocicapacity",
            "migrateToMvm"       : "migrate_ocicapacity_to_mvm",
            "enableNs"           : "migrate_ocicapacity_to_ns",
            "enableElasticCell"  : "migrate_ocicapacity_to_ecell",
            "enableElasticCompute": "migrate_ocicapacity_to_ecompute",
            "migrateVpnToWss"    : "migrate_ocicapacity_to_wss",
            "release"            : "release_ocicapacity",
            "activateCellServers": "activate_cell_servers",
            "attachCellServers"  : "attach_cell_servers",
            "attachCellServersExascale" : "attach_cell_servers_exascale",
            "migrateToElasticCell": "migrate_to_elastic_cell",
            "markCellsToDelete"  : "mark_cells_to_delete",
            "updateInfraStatus"  : "update_infrastatus",
            "activateComputes"   : "activate_computes",
            "restoreAllocations" : "restore_allocations",
            "fixXmlActionTag"    : "fix_xml_action_tag",
            "releaseInfra"       : "release_infra",
            "reserveInfra"       : "reserve_infra",
            "configureExascale":"configure_exascale",
            "undoExascale"       : "undo_exascale_configuration",
            "regenerateDBCSWallets":"renerate_dbcs_wallets",
            "updateAsmss"        : "update_asmss_for_infra",
            "getnatmap"          : "get_domuhost_nat_mapping",
            "cleanupEcraMetadata": "cleanup_ecra_meta_data"
        },
        "ocicpinfra":{
            "savevpnserverdetails"  : "save_vpn_server_details_ocicpinfra",
            "getvpnserverdetails"   : "get_vpn_server_details_ocicpinfra",
            "updatevpnserverdetails": "update_vpn_server_details_ocicpinfra",
            "rotatecipherpasswd"    : "rotate_cipher_passwd",
            "getecracipherpasswd"   : "get_ecra_cipher_passwd",
            "geteallcipherpasswds"  : "get_ecra_all_cipher_passwds",
            "registervpnhe"         : "add_new_vpn_he_record",
            "updatevpnhe"           : "update_vpn_he_record",
            "getvpnhedetails"       : "get_vpn_he_details",
            "getvpnhelist"          : "get_vpn_he_list"
        },
        "capacity":{
            "register"   :"register_capacity",
            "deregister" :"deregister_capacity",
            "list"       :"list_capacity",
            "get"        :"get_capacity",
            "reserve"    :"reserve_capacity",
            "release"    :"release_capacity",
            "move"       :"move_capacity",
            "infrav2backfill" : "infrav2_backfill",
            "getavailability": "capacity_getavailability",
            "getfilesystemdefinitions":"capacity_getfilesystemdefinitions",
            "compatibility": {
                "addmatrix"     : "capacity_compatibility_addmatrix",
                "updatematrix"  : "capacity_compatibility_updatematrix",
                "disablematrix" : "capacity_compatibility_disablematrix",
                "enablematrix"  : "capacity_compatibility_enablematrix",
                "addexclusion"  : "capacity_compatibility_addexclusion",
                "list"          : "capacity_compatibility_list",
                "catalog"       : "capacity_compatibility_catalog"
            },
            "gioperation" : "capacity_gioperation",
            "configureExascale":"configure_exascale",
            "undoExascale"       : "undo_exascale_configuration"
        },
        "rackslot":{
            "list"       :"list_rackslot",
            "get"        :"get_rackslot",
            "register"   :"register_rackslot",
            "deregister" :"deregister_rackslot"
        },
        "service":{
            "create"  :"create_service",
            "delete"  :"delete_service",
            "recreate":"recreate_service",
            "get"     :"get_service",
            "update_memory" :"service_update_memory"
        },
        "security":{
            "add_selinuxpolicy"  :"add_selinuxpolicy",
            "list_selinuxpolicy"  :"list_selinuxpolicy",
            "dump_selinuxpolicy"  :"dump_selinuxpolicy",
            "add_fsencryption"  :"add_fsencryption",
            "remove_fsencryption"  :"remove_fsencryption",
            "list_fsencryption"  :"list_fsencryption"
        },
        "exaservice": {
            "create"  :"create_exaservice",
            "addcluster"  :"add_cluster",
            "reshape" : "reshape_exaservice",
            "reshapecluster": "reshape_cluster",
            "coreburstcluster": "coreburst_cluster",
            "deletecluster": "delete_cluster",
            "delete"  :"delete_exaservice",
            "list"     :"list_exaservice",
            "migrate"  :"migrate_exaservice",
            "migratestatus": "migrate_status",
            "migrateprefetch": "migrate_prefetch",
            "migratepostfetch": "migrate_postfetch",
            "migratepostupdate": "migrate_postupdate",
            "migraterollback": "migrate_rollback",
            "suspend" :"suspend_exaservice",
            "resume" : "resume_exaservice",
            "rackinfo" : "fetch_rackinfo",
            "resourceinfo" : "fetch_resourceinfo",
            "syncrackslots": "syncrackslots"
        },
        "exaunit":{
            "info"    :"exaunit_info",
            "logs"    :"exaunit_logs",
            "cores"   :"exaunit_cores",
            "dbs"     :"exaunit_dbs",
            "detail"  :"exaunit_detail",
            "detail_update"  :"exaunit_detail_update",
            "vms"     :"exaunit_vms",
            "domukeys":"exaunit_domukeys",
            "resize"  :"resize_exaunit",
            "get"     :"get_exaunit",
            "getallforinfra": "get_allexaunits",
            "drop"    :"drop_exaunit",
            "resume"  : "exaunit_resume",
            "suspend" : "exaunit_suspend",
            "hasopr": "exaunit_hasoperation",
            "asmrebalance"     : "exaunit_asmrebalance",
            "resizefs":"exaunit_resizefs",
            "list"    :"exaunit_list",
            "addcompute": "exaunit_addcompute",
            "addcell" : "exaunit_addcell",
            "deletecompute" : "exaunit_deletecompute",
            "reshape" :"exaunit_reshape",
            "monitoring" : "exaunit_monitoring",
            "deletecell" : "exaunit_deletecell",
            "getcspayload" : "exaunit_getcspayload",
            "reshapeprecheck" : "exaunit_reshapeprecheck",
            "elasticnodeprecheck" : "exaunit_elasticnodeprecheck",
            "getelasticnodeprecheck" : "exaunit_getelasticnodeprecheck",
            "generatecspayload" : "exaunit_generatecspayload",
            "updatetimezone" : "exaunit_updatetimezone",
            "getdginfo" : "exaunit_getdginfo",
            "securevms":"exaunit_securevms",
            "migrateVMBackupXs":"migrate_vmbackup_xs",
            "getoperations":"exaunit_getoperations",
            "updatentpdns":"exaunit_updatentpdns",
            "rotatekeys":"exaunit_rotatekeys",
            "getcomputesizes":"exaunit_getcomputesizes",
            "collectvmcore":"exaunit_collectvmcore",
            "acfs": "acfs_operations"
        },
        "exadata":{
            "network_info": "fetch_network_info",
            "models": "models_exadata"
        },
        "exawatcher":{
            "getlog"    : "getlog_exawatcher",
            "listlog"   : "listlog_exawatcher"
        },
        "db":{
            "create"        :"create_db",
            "recreate"      :"recreate_db",
            "info"          :"info_db",
            "info_all"      :"info_all_db",
            "delete"        :"delete_db",
            "create_starter":"create_starter_db",
            "rollback_starter":"rollback_starter_db",
            "register"      :"register_db",
            "deregister"    :"deregister_db",
            "registered_info": "registered_info_db",
            "backup"        :"backup",
            "recover"       :"recover",
            "patch"         :"dbpatch",
            "update_ecra_heartbeat" : "heartbeat_ecra_db"
        },
        "pdb":{
            "register"      :"register_pdb",
            "deregister"    :"deregister_pdb",
            "info"          :"info_pdb"
        },
        "em":{
            "list"        :"list_em",
            "reregister"  :"reregister_em",
            "update"      :"update_em",
            "add"         :"add_em",
            "delete"      :"delete_em",
            "setup"       :"setup_em",
            "disable"     :"disable_em",
            "enable"      :"enable_em"
        },
        "iorm":{
            "get_dblist"   :"get_dblist",
            "get_flashsize":"get_flashsize",
            "get_obj"      :"get_obj",
            "set_obj"      :"set_obj",
            "set_dbplan"   :"set_dbplan",
            "set_dbplan_v2"  :"set_dbplan_v2",
            "get_dbplan"   :"get_dbplan",
            "reset_dbplan" :"reset_dbplan",
            "get_clientkeys" : "get_clientkeys",
            "set_dbplan_v2": "set_dbplan_v2",
            "reset_dbplan_v2": "reset_dbplan_v2",
            "set_obj_v2": "set_obj_v2",
            "get_pmemsize": "get_pmemsize",
            "get_resources": "get_resources_iorm",
            "set_clusterplan": "set_clusterplan",
            "get_clusterplan": "get_clusterplan"
        },
        "dg":{
            "config"       :"dgconfig",
            "create"       :"create_dgdb",
            "setup"        :"dgsetup"
        },
        "ebtables":{
            "enable"       :"enable_ebtables",
            "disable"      :"disable_ebtables",
            "add"          :"add_ebtrules",
            "delete"       :"del_ebtrules"
        },
        "clone":{
            "snap"         :"create_snap",
            "testmaster"   :"create_tm"
        },
        "higgs":{
            "createNetwork" : "create_network",
            "getNetwork"    : "get_network",
            "getAllNetwork" : "getall_network",
            "deleteNetwork" : "delete_network",
            "deleteResources" : "delete_resources",
            "deregister"    : "deregister_higgs",
            "createNatvips"  : "create_natvips",
            "deleteNatvips"  : "delete_natvips",
            "listNatvips"  : "list_natvips",
            "addIbsubnet"   : "add_ibsubnet",
            "deleteIbsubnet"   : "delete_ibsubnet",
            "createSecProtocol" : "create_secprotocol",
            "createSecRule" : "create_secrule",
            "deleteSecRule" : "delete_secrule",
            "getSecRule" : "get_secrule",
            "getResources" : "get_resources",
            "removeResource" : "remove_resource"
        },
        "kvmroce":{
            "allocateComputeVlan"   : "allocateComputeVlan_kvmroce",
            "allocateStorageVlan"   : "allocateStorageVlan_kvmroce",
            "getComputeVlan"        : "getComputeVlan_kvmroce",
            "getStorageVlan"        : "getStorageVlan_kvmroce",
            "freeComputeVlan"       : "freeComputeVlan_kvmroce",
            "freeStorageVlan"       : "freeStorageVlan_kvmroce",
            "allocateComputeIP"     : "allocateComputeIP_kvmroce",
            "allocateStorageIP"     : "allocateStorageIP_kvmroce",
            "allocateExascaleIP"    : "allocateExascaleIP_kvmroce",
            "getComputeIP"          : "getComputeIP_kvmroce",
            "getStorageIP"          : "getStorageIP_kvmroce",
            "getExascaleIP"         : "getExascaleIP_kvmroce",
            "freeComputeIP"         : "freeComputeIP_kvmroce",
            "freeStorageIP"         : "freeStorageIP_kvmroce",
            "freeExascaleIP"        : "freeExascaleIP_kvmroce",
            "addFabric"             : "addFabric_kvmroce",
            "deleteFabric"          : "deleteFabric_kvmroce",
            "listFabric"            : "listFabric_kvmroce",
            "getAllFabric"          : "getAllFabric_kvmroce",
            "getAllCabinets"        : "getAllCabinets_kvmroce",
            "getAllNodes"           : "getAllNodes_kvmroce",
            "getCabinets"           : "getCabinets_kvmroce",
            "getCabinetNodes"       : "getCabinetNodes_kvmroce",
            "listfaultdomains"      : "listFaultDomains_kvmroce",
            "runsanitycheck"        : "runsanitycheck_kvmroce",
            "getsanityresults"      : "getsanityresults_kvmroce",
            "isexascalepoolcreated" : "isexascalepoolcreated_kvmroce",
            "updatefaultdomain"     : "updateFaultDomain_kvmroce",
            "get_elastic_reservation_threshold" : "get_elastic_reservation_threshold_kvmroce",
            "set_elastic_reservation_threshold" : "set_elastic_reservation_threshold_kvmroce",
            "get_elastic_reservation_setting"   : "get_elastic_reservation_setting_kvmroce",
            "set_elastic_reservation_threshold_abs" : "set_elastic_reservation_threshold_kvmroce_abs",
            "enable_utilization_based_elastic_reservation"  : "enable_utilization_based_elastic_reservation_kvmroce",
            "disable_utilization_based_elastic_reservation" : "disable_utilization_based_elastic_reservation_kvmroce"
        },
        "bonding":{
            "getInfo"               : "getInfo_bonding",
            "setupMonitoringBond"   : "setupMonitoringBond_bonding",
            "deleteMonitoringBond"  : "deleteMonitoringBond_bonding",
            "getpayload"            : "getpayload_bonding",
            "retrysetup"            : "retrysetup_bonding",
            "migrationPrecheck"     : "migrationPrecheck_bonding",
            "smartnicaction"        : "smartnicaction_bonding",
            "migratevlan"           : "migratevlan_bonding",
            "networkupdate"         : "networkupdate_bonding",
            "monitorswitch"         : "monitorswitch_bonding",
            "rpmupdate"             : "rpmupdate_bonding",
            "rpmupdateall"          : "rpmupdateall_bonding",
            "getelasticcabinets"    : "getelasticcabinets_bonding",
            "addcustomvip"          : "addcustomvip_bonding",
            "deletecustomvip"       : "deletecustomvip_bonding",
            "linkfailover"          : "linkfailover_bonding",
            "consistencycheck"      : "consistencycheck_bonding",
            "restartmonitor"        : "restartmonitor_bonding",
            "status"                : "statusmonitor_bonding"
        },
        "atp":{
            "getDetails"            : "getDetails_atp",
            "getNetwork"            : "getNetwork_atp",
            "registerVnic"          : "registerVnic_atp",
            "getVnicDetails"        : "getVnicDetails_atp",
            "registerVcnDetails"    : "registerVcnDetails_atp",
            "registerAuth"          : "registerAuth_atp",
            "createNetwork"         : "createNetwork_atp",
            "deleteNetwork"         : "deleteNetwork_atp",
            "registerSubnet"        : "registerSubnet_atp",
            "getPartnerSubnet"      : "getPartnerSubnet_atp",
            "setupDGNetwork"        : "setupDGNetwork_atp",
            "deleteDGNetworkRules"  : "deleteDGNetworkRules_atp",
            "addProperty"           : "addProperty_atp",
            "getProperty"           : "getProperty_atp",
            "deleteProperty"        : "deleteProperty_atp",
            "updateNetMetadata"     : "updateNetMetadata_atp",
            "createOracleClientSubnet" : "createOracleClientSubnet_atp",
            "giServiceStop"         : "giServiceStop_atp",
            "launchObserver"        : "launchObserver_atp",
            "deleteObserver"        : "deleteObserver_atp",
            "getObserverDetails"    : "getObserverDetails_atp",
            "fetchObserverKeys"     : "fetchObserverKeys_atp",
            "createPreprovDbSystem" : "createPreprovDbSystem_atp",
            "getPreprovScheduler"   : "getPreprovScheduler_atp",
            "listScheduledRacks"    : "listScheduledRacks_atp",
            "getScheduledRackPreprovJobs" : "getScheduledRackPreprovJobs_atp",
            "startPreprovScheduler" : "startPreprovScheduler_atp",
            "shutdownPreprovScheduler"  : "shutdownPreprovScheduler_atp",
            "reconfigService"       : "reconfigService_atp",
            "terminateObserver"     : "terminateObserver_atp",
            "startObserver"         : "startObserver_atp",
            "stopObserver"          : "stopObserver_atp",
            "restartObserver"       : "restartObserver_atp",
            "deletePreprovOracleClientVCN" : "deletePreprovOracleClientVCN_atp",
            "deletePreprovOracleDbSystem" : "deletePreprovOracleDbSystem_atp",
            "ingestTerraformData" : "ingestTerraformData_atp",
            "bootstrap"             : "bootstrap_atp",
            "configDom0Rule": "configRule_atp",
            "vmrollback"          : "vmrollback_atp",
            "configDomURules"       :"config_domurules_atp",
            "createOciUrlMap"       : "createOciUrlMap_atp",
            "getOciUrlMap"          : "getOciUrlMap_atp",
            "getOciUrlMapAll"       : "getOciUrlMapAll_atp",
            "getAdminIdentity"      : "getAdminIdentity_atp",
            "registerAdminIdentity" : "registerAdminIdentity_atp",
            "listCustomerTenancy"   : "customertenancy_list",
            "putCustomerTenancy"    : "customertenancy_put",
            "deleteCustomerTenancy" : "customertenancy_del",
            "getPreprovMetrics"     : "getPreprovMetrics_atp",
            "createPreprovExadataInfrastructure":"exadata_infrastructure_create",
            "createPreProvVMCluster" : "createPreProvVMCluster_atp"
        },
        "profiling":{
            "report"             :"profiling_report",
            "operation"          :"profiling_operation",
            "infrastructure"     :"profiling_infrastructure"
        },
        "test":{
            "createdelete" :"test_createdelete"
        },
        "properties":{
            "get"         :"get_property",
            "put"         :"put_property",
            "gettypes"    :"properties_gettypes"
        },
        "cns":{
            "run"         :"runcns",
            "post"        :"postcns",
            "setup"       :"setupcns",
            "setupinterval" :"setupcnsinterval",
            "enable"        :"enablecns",
            "disable"       :"disablecns",
            "enablerack"    :"enablerackcns",
            "disablerack"    :"disablerackcns",
            "getrackstatus"  :"getrackstatuscns",
            "receive"        :"receivecns"
        },
        "schedule":{
            "add"       :"add_schedule",
            "delete"    :"delete_schedule",
            "list"      :"list_schedule",
            "update"    :"update_schedule"
        },
        "diagnosis":{
            "rsyslog_get"            :"rsyslog_get_diagnosis",
            "rsyslog_set"            :"rsyslog_set_diagnosis",
            "logcol"                 :"logcol_diagnosis",
            "add_pre_logcol_rack"    :"add_pre_logcol_rack_diagnosis",
            "list_pre_logcol_rack"   :"list_pre_logcol_rack_diagnosis",
            "delete_pre_logcol_rack" :"delete_pre_logcol_rack_diagnosis",
            "plgmon"                 :"plgmon_diagnosis",
            "add_ignore"             :"add_ignore_diagnosis",
            "list_ignore"            :"list_ignore_diagnosis",
            "delete_ignore"          :"delete_ignore_diagnosis",
            "show_active_db_conn"    :"show_active_db_conn_diagnosis",
            "db_conn_stacktrace"     :"db_conn_stacktrace_diagnosis",
            "logsearch"              :"logsearch_diagnosis",
            "rackhealth_run"         :"rackhealth_run_diagnosis",
            "rackhealth_result"      :"rackhealth_result_diagnosis",
        },
        "jumbo":{
            "enable"    :"enable_jumbo",
            "disable"   :"disable_jumbo",
            "query"     :"query_jumbo"
        },
        "vmbackup":{
            "enable" : "enable_vmbackup",
            "disable" : "disable_vmbackup",
            "set_param" : "set_param_vmbackup",
            "get_param" : "get_param_vmbackup",
            "install"   : "install_vmbackup",
            "backup"    : "backup_vmbackup",
            "status"    : "status_vmbackup",
            "rollback"    : "rollback_vmbackup",
            "patch"     : "patch_vmbackup",
            "scheduler" : {
                "setnextrun": "setnextrun_scheduler_vmbackup",
                "setfrequency": "setfrequency_scheduler_vmbackup"
            },
            "schedulerstatus"      : "schedulerstatus_vmbackup",
            "schedulerhistory"     : "schedulerhistory_vmbackup",
            "list"      : "list_vmbackup",
            "osslist"   : "osslist_vmbackup",
            "download"  : "ossrestore_vmbackup",
            "restorelocal"  : "localrestore_vmbackup",
            "restorepath"   : "restorepath_vmbackup",
            "suconfig"  : "suconfig_vmbackup",
            "configurecronjob" : "configurecronjob_vmbackup"
        },
        "hardware":{
            "properties"      : "properties_hardware",
            "tenancypropertylist"  : "tenancyproperty_list",
            "tenancypropertyput"   : "tenancyproperty_put",
            "tenancypropertydel"   : "tenancyproperty_del",
            "configurefeaturetenancy":"configurefeaturetenancy_hardware",
        },
        "cluster":{
            "details"     : "details_cluster"
        },
        "gcsinfra":{
            "getinfo"     : "getinfo_gcsinfra"
        },
        "userconfig":{
            "create_user" : "create_user",
            "alter_user"  : "alter_user",
            "grant_role"  : "grant_role",
            "list_user"   : "list_user",
            "delete_user"   : "delete_user",
            "delete_role"   : "delete_role"
        },
        "requests": {
            "abort"          : "abort_request",
            "info"           : "requests_info",
            "abort_async"    : "abort_async",
            "list_async"     : "list_async",
            "multiop_details": "multiop_details",
            "multiop_recover": "multiop_recover",
            "multiopupdate" : "multiop_update_step",
            "update"         : "update_request",
            "get"         : "request_get",
            "addregistry": "addregistry",
        },
        "workflows":{
            "list"        : "workflow_list",
            "describe"    : "workflow_describe",
            "undo"        : "workflow_undo",
            "retry"       : "workflow_retry",
            "complete_task" : "workflow_complete_task",
            "rollback_mode_on" : "workflow_rollback_mode_on",
            "rollback_mode_off" : "workflow_rollback_mode_off",
            "rollback" : "workflow_rollback",
            "operation"   : "workflow_operation",
            "abort"       : "workflow_abort",
            "cancel_task" : "workflow_cancel_task",
            "fail_task"   :  "workflows_fail_task",
            "pause"   :  "workflows_pause",
            "server_status" : "workflow_server_status",
            "reload"      : "workflows_reload",
            "restart_janitor": "wf_janitor_restart",
            "exacloud_success": "wf_exacloud_success",
            "getinput":"workflows_getinput",
            "updateinput": "workflows_updateinput"
        },
        "exacc": {
            "createNetwork"      : "createNetwork_exacc",
            "listNetworks"       : "listNetworks_exacc",
            "updateNetwork"      : "updateNetwork_exacc",
            "getNetwork"         : "getNetwork_exacc",
            "deleteNetwork"      : "deleteNetwork_exacc",
            "validateNetwork"    : "validateNetwork_exacc",
            "activate"           : "activate_exacc",
            "certificateRotation": "certificateRotation_exacc",
            "secretServiceCompartment":"secretServiceCompartment_exacc",
            "secretServiceRotation":"secretServiceRotation_exacc",
            "networkValidationReport":"nwValidationReport_exacc",
            "wssIngestion": "wssIngestion_exacc"
        },
        "heartbeat":{
            "get"                :"heartbeat_get",
            "exadata"            :"heartbeat_exadata",
            "enableScheduler"    :"heartbeat_enable_scheduler"
        },
        "compliance": {
            "scan"              : "compliance_scan",
            "default_scan"      : "compliance_default_scan",
            "base_cfg"          : "compliance_base_cfg",
            "cfg_status"        : "compliance_cfg_status",
            "cfg_history"       : "compliance_cfg_history",
            "report_oss_namespace" : "compliance_report_oss_namespace",
            "auto_revert"       : "compliance_auto_revert",
            "status"            : "compliance_status",
            "avfim"             : "compliance_avfim"
        },
        "ecspatchversion": {
             "list"        : "list_ecspatchversion",
         },
         "ecra":{
            "validateApis"      : "validate_apis",
            "dumpConfig"        : "dump_config",
            "coredump"          : "core_dump",
            "upgradeHistory"    : "upgrade_history",
            "getfile"           : "get_file",
            "check"             : "ecra_health_check",
            "deletepayloads"    : "deletepayloads",
            "connect"           : "ecra_connect",
            "updatefile"        : "update_file_ecra",
            "listfiles"         : "list_files_ecra"
         },
        "exadata_applied_version": {
             "list"        : "list_exadata_applied_version",
         },
         "metadata":{
            "select"        : "metadata_select",
            "update"        : "metadata_update",
            "tables"        : "metadata_tables"
        },
        "opctl":{
            "create_user"   : "opctl_create_user",
            "delete_user"   : "opctl_delete_user",
            "assign"        : "opctl_assign"
        },
        "exacloud":{
            "setexassh" : "exacloud_setexassh"
        },
        "exaversion":{
            "patchesreport" :"exaversion_patchesreport",
            "register": "register_exaversion",
            "registerimageseries": "register_exaversion_imageseries",
            "get": "get_exaversion",
            "getimageseries": "get_exaversion_imageseries",
            "listpatches":"list_patches",
            "purge":"purge_patches",
            "listpatchesmetadata":"list_patchesmetadata",
            "servicetype":"get_service_type",
            "addservicetype":"add_service_type",
            "deregisterexaversion":"deregister_exaversion"
        },
        "analytics":{
            "analyze" : "analytics_analyze",
            "history" : "analytics_history",
            "stats"   : "analytics_stats",
            "csconfigcheck" : "analytics_cs_check",
            "rack" : "analytics_rack",
            "csconfigtemplate" : "analytics_cs_template",
            "getoperationdetails" : "analytics_op_details",
            "getpayload" : "analytics_getpayload",
            "info" : "analytics_info"
        },
        "passwordmanagement":{
            "rotate" : "passwordmanagement_rotate",
            "change" : "passwordmanagement_change",
            "listuser"  : "passwordmanagement_listuser",
            "seedsiv" : "passwordmanagement_seedsiv",
            "getsiv" : "passwordmanagement_getsiv",
            "updatesivinfo" : "passwordmanagement_updatesivinfo",
            "validatepassword" : "passwordmanagement_validatepassword"
        },
        "patchcps":{
            "cpsswupgrade"  :"cpssw_upgrade",
            "cps_tar_upload"  :"cps_tar_upload"

        },
        "infrapassword":{
            "rotate" : "infrapassword_rotate",
            "get"    : "infrapassword_get"
        },
        "exacompute":{
            "ports" : "exacompute_ports",
            "getfleetstatelock" : "exacompute_getfleetstatelock",
            "fleetstateunlock" : "exacompute_fleetstateunlock",
            "getfleetstate" : "exacompute_getfleetstate",
            "getlatestfleet"   : "exacompute_getlatestfleet",
            "updatefleetstate" : "exacompute_updatefleetstate",
            "getfleetstateid" : "exacompute_getfleetstateid",
            "addcluster"       : "exacompute_add_cluster",
            "addclusterprecheck"       : "exacompute_add_cluster_precheck",
            "deletecluster"    : "exacompute_delete_cluster",
            "listcluster"      : "exacompute_list_cluster",
            "activecard"       : "exacompute_active_card",
            "vm"                : "exacompute_vm",
            "createmdcontext"   : "exacompute_createmdcontext",
            "updatemdcontext"   : "exacompute_updatemdcontext",
            "deletemdcontext"   : "exacompute_deletemdcontext",
            "getmdcontext"      : "exacompute_getmdcontext",
            "createmaintenancedomain" : "exacompute_createmaintenancedomain",
            "deletemaintenancedomain" : "exacompute_deletemaintenancedomain",
            "updatemaintenancedomain" : "exacompute_updatemaintenancedomain",
            "getmaintenancedomain" : "exacompute_getmaintenancedomain",
            "listmaintenancedomain" : "exacompute_listmaintenancedomain",
            "getmdnodes" : "exacompute_getmdnodes",
            "computedetail" : "exacompute_computedetail",
            "updatenodemdmapping" : "exacompute_updatenodemdmapping",
            "reshapecluster" : "exacompute_reshapecluster",
            "reshapecluster_precheck": "exacompute_reshapecluster_precheck",
            "initiator"  : "exacompute_initiator",
            "updateocid" : "exacompute_updateocid",
            "gettemplate"    : "exacompute_gettemplate",
            "postvolumes"    : "exacompute_postvolumes",
            "getvolumes"     : "exacompute_getvolumes",
            "validatevolumes"     : "exacompute_validatevolumes",
            "generatesshkeys": "exacompute_generatesshkeys",
            "getpublickey": "exacompute_getpublickey",
            "getvaultaccess": "exacompute_getvaultaccess",
            "updatevaultaccessdetails" : "exacompute_updatevaultaccessdetails",
            "deletevaultaccessdetails": "exacompute_deletevaultaccessdetails",
            "precheckedvvolumes" : "exacompute_precheckedvvolumes",
            "snapshotmount" : "exacompute_snapshotmount",
            "snapshotunmount" : "exacompute_snapshotunmount",
            "listsystemvault" : "exacompute_listsystemvault",
            "updatesystemvault" : "exacompute_updatesystemvault",
            "deletesystemvault" : "exacompute_deletesystemvault",
            "createsystemvault" : "exacompute_createsystemvault",
            "getnathostnames" : "exacompute_getnathostnames",
            "updatefleetnode"   : "exacompute_updatefleetnode",
            "clusterdetail"   : "exacompute_clusterdetail",
            "securevms"   : "exacompute_securevms",
            "removenodexml" : "exacompute_removenodexml",
            "precheck" : "exacompute_precheck",
            "configureroceips": "exacompute_configureroceips",
            "deconfigureroceips" : "exacompute_deconfigureroceips",
            "cleanuprequest" : "exacompute_cleanup_request",
            "nodedetail" : "exacompute_nodedetail",
            "computecleanup" : "exacompute_computecleanup",
            "dbvolumes" : "exacompute_dbvolumes",
            "clusterhistory" : "exacompute_clusterhistory",
            "updatefabricfleet" : "exacompute_updatefabricfleet",
            "runfleetjsoncheck" : "exacompute_runsanitycheck",
            "getdomus" : "exacompute_getdomus",
            "getvmclusterdetails" : "exacompute_getvmclusterdetails",
            "rackreserve" : "exacompute_rackreserve",
            "guestreserve" : "exacompute_guestreserve",
            "guestrelease" : "exacompute_guestrelease"
        },
        "sla":{
            "get_average_all": "sla_get_average_all",
            "get_average": "sla_get_average",
            "get_average_tenancy": "sla_get_average_tenancy",
            "get_details": "sla_get_details",
            "get_details_infra": "sla_get_details_infra",
            "tenancy_turnon": "sla_tenancy_turnon",
            "tenancy_turnoff": "sla_tenancy_turnoff",
            "get_turnedon_tenancy": "sla_get_turnedon_tenancy",
            "get_tenant_report" : "sla_get_tenant_report",
            "get_cei_report" : "sla_get_cei_report",
            "get_vm_report" : "sla_get_vm_report"
        },
        "topology":{
            "get_topology_for_ad": "topology_get_ad",
            "get_network_switch_for_ad" : "topology_get_network_switch_for_ad"
        },
        "agent":{
            "request" : "agent_request",
            "dataplanesettings" : "dataplane_settings"
        },
        "cache":{
            "purge" : "cache_purge"
        },
        "errorcode":{
            "get": "errorcode_get",
            "category" : "errorcode_category",
            "endpoint" : "errorcode_endpoint"
        },
        "preprov": {
            "scheduler": {
                "start" : "preprov_scheduler_start",
                "stop"  : "preprov_scheduler_stop",
                "list"  : "preprov_scheduler_list"
            },
            "jobs": {
                 "get"    : "preprov_jobs_get",
                 "update" : "preprov_jobs_update"
            },
            "vcn": {
                 "get"    : "preprov_vcn_get"
            },
            "subnet": {
                 "get"    : "preprov_subnet_get"
            },
            "vnics": {
                 "get"    : "preprov_vnics_get"
            },
            "deleterackresources": "preprov_delete_rack_resources",
            "capacitymove": "preprov_capacitymove",
            "fleet" : "preprov_fleet_get"
        },
        "oci": {
            "connectivity": {
                "check": "connectivity_check"
            },
            "compute": {
                "create": "create_compute_instance",
                "delete" : "delete_compute_instance",
                "get": "get_compute_instance",
                "createvnic" : "create_oci_vnic",
                "getvnic"    : "get_oci_vnic",
                "deletevnic" : "delete_oci_vnic",
                "attachvnic" : "attach_oci_vnic",
                "detachvnic" : "detach_oci_vnic",
                "createfloatingip" : "create_floatingip",
                "getfloatingip"    : "get_floatingip",
                "mapfloatingip"    : "map_floatingip",
                "unmapfloatingip"    : "unmap_floatingip",
		"updatefloatingip" : "update_floatingip",
                "deletefloatingip" : "delete_floatingip",
                "listvnics": "list_vnics",
                "listips": "list_ips"
            },
            "network": {
                "configuredns": "configure_dns",
                "deletedns": "delete_dns",
                "getdns": "get_dns"
            }
        },
        "domu": {
            "get": "domu_get",
            "search": "domu_search",
            "deletebadhostname": "domu_deletebadhostname"
        },
        "user": {
            "getall": "users_get_all",
            "get": "users_get",
            "resetpassword": "users_reset_password",
            "create": "users_create",
            "update": "users_update",
            "delete": "users_delete",
            "activate": "users_activate",
            "deactivate": "users_deactivate",
            "refreshcredentials": "users_refresh_credentials"
        },
        "ingestion" : {
            "import": "ingestion_import"
        },
        "vmconsole":{
            "deployment":"vmconsole_deployment",
            "enable": "enable_vm_console"
        },
        "sop": {
            "request": "sop_request",
            "list": "sop_list",
            "details": "sop_details",
            "cancel": "sop_cancel",
            "retry": "sop_retry"
        },
        "patchmetadata": {
            "registerlaunchnodes": "register_launch_node",
            "deregisterlaunchnodes": "deregister_launch_node",
            "getlaunchnodes": "get_launch_node",
            "registerpluginscript": "register_pluginscript",
            "listpluginscripts": "list_pluginscript",
            "updatepluginscript": "update_pluginscript",
            "deregisterpluginscript": "deregister_pluginscript",
            "deletelaunchnodemetadata": "delete_launchnodemetadata",
            "syncvmstate":"sync_vm_state",
            "syncinfraimages":"sync_infra_images"
        },
        "sitegroup": {
            "add": "sitegroup_add",
            "list": "sitegroup_get",
            "update": "sitegroup_update",
            "updaterpm":"sitegroup_updaterpm",
            "configurefeature": "sitegroup_configurefeature"
        },
        "artifact": {
            "deliver": "artifact_deliver",
            "deliver_status": "artifact_deliver_status"
        },
        "compatibility": {
            "list": "compatibility_get",
            "add": "compatibility_add",
            "remove": "compatibility_remove",
            "check": "compatibility_check",
            "validoperations": "compatibility_validoperations"
        },
        "vault": {
            "details" : "get_xs_vault_details"
        },
        "faultinjection": {
            "listinfra": "fault_injection_infra_list",
            "addinfra": "fault_injection_infra_add",
            "deleteinfra": "fault_injection_infra_delete"
        },
        "resourceblackout": {
            "getlatest": "resource_blackout_get_latest",
            "gethistory": "resource_blackout_get_history",
            "getenabled": "resource_blackout_get_enabled",
            "create": "resource_blackout_create",
            "update": "resource_blackout_update",
            "refresh": "resource_blackout_refresh",
            "disable": "resource_blackout_disable"
        },
        "exascale" : {
            "ersip" : {
                "get" : "exascale_ersip_get",
                "register" : "exascale_ersip_register",
                "delete" : "exascale_ersip_delete"
            }
        }
    }

    #Load the help JSON file for help text
    help_path = path.join(mytmpldir, "help.json")
    with open(help_path) as json_file:
        sub_ops_help = json.load(json_file)

    #Load the parameters JSON file for validating the parameters
    param_path = path.join(mytmpldir, "parameters.json")
    with open(param_path) as json_file:
        valid_params = json.load(json_file)

    blocklist_api = path.join(mytmpldir, "blockapilist.json")
    with open(blocklist_api) as json_file:
        blocklist_api_params = json.load(json_file)


    # initialize params
    def __init__(self, options_dict, args):
        self.init_ecracli(options_dict, args)

    def getExadataModel(self, xml):
        m = re.search("X[456789]M?-2", xml)
        if m:
            model = m.group();
            kvmModels = {"X8-2": "X8M-2" , "X9-2" : "X9M-2"}
            if (model in kvmModels):
                root = et.fromstring(re.sub('xmlns="\w*"', '', xml))
                osTypes =  [x.text for x in root.findall("machines/machine/osType")]
                model = kvmModels[model] if "LinuxKVM" in osTypes else model
            return model
        else:
            m = re.search("X[9]M_Cloud", xml)
            if m:
                return "X9M-2"

        return ""

    def init_ecracli(self, options_dict, args, switchmode=False):
        if (options_dict["mode"] not in list(ECRACLI_MODES.reverse_mapping().values())):
            cl.perr("Invalid ecracli mode: %s, please select from %s." %
                    (options_dict["mode"], list(ECRACLI_MODES.reverse_mapping().values())))
            sys.exit(1)

        if (options_dict["mode"] == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
            if (options_dict["cimid"] is None):
                cl.perr("For 'brokerproxy' mode, 'cimid' is required to initialize ecracli")
                sys.exit(1)
            self.prompt = 'brokerproxy> '
        else:
            self.prompt = 'ecra> '

        cmd.Cmd.__init__(self)
        self.config = configparser.ConfigParser()
        self.config.optionxform = str
        self.config.read(options_dict["config"])
        sections = self.config.sections()

        #adding all info in ecracli.cfg file to a dictionary
        self.configJson  = {}
        for section in sections:
            self.configJson[section]= dict(self.config.items(section))


        for field in Ecracli.api_params:
            setattr(self, field, self.config.get("apiParams", field))

        Ecracli.api_params.append("username")
        Ecracli.api_params.append("password")
        valid_users = ["srguser"]
        exacloudPath = self.config.get("apiParams", "exacloudpath")
        self.racks = {}
        if exacloudPath:
            for directory in os.listdir(path.join(exacloudPath, "clusters")):
                if directory[:len("cluster-")] == "cluster-":
                    clusterName = directory[len("cluster-"):]
                    self.racks[clusterName] = path.join(exacloudPath, "clusters/" + directory + "/config/" + clusterName + ".xml")

        self.racks.update(dict(self.config.items("exadataClusters")))

        self.dbJsonPath = options_dict["dbJson"]
        self.podJsonPath = options_dict["podJson"]
        self.verbose = False
        self.startup_options = options_dict
        self.startup_args = args

        version_info = path.join(mydir, "release.dat")
        if os.path.exists(version_info):
            with open(version_info) as f:
                self.version = f.read().replace("\n", "")
        else:
            self.version = ""

        if options_dict["host"]:
            self.host = options_dict["host"]

        if (options_dict["mode"] == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
            self.host = "{0}/brokerproxy/{1}".format(self.host, options_dict["cimid"])

        setattr(self, "username", None)
        setattr(self, "password", None)

        if options_dict["user"]:
            if ':' in options_dict["user"]:
                self.username, self.password = options_dict["user"].split(":")
                if self.username not in valid_users:
                    cl.perr("*** ECRA communication. This option is not valid ***")
                    sys.exit(1)
            else:
                self.username = options_dict["user"]
                self.password = self.prompt_values("password")
            self.config.set("apiParams", "username", self.username)
            self.config.set("apiParams", "password", self.password)

        if options_dict["verbose"]:
            self.verbose = options_dict["verbose"]

        if options_dict.get("username") is not None:
            self.get_ecra_auth(options_dict.get("username"),
                               options_dict.get("password"))

        if not options_dict["user"] and self.password is None:
            self.handle_prompt() # If pwds are still empty, they will be prompted

        self.initHttp()

        logger.info("******** starting ecracli with pid " + str(os.getpid()) + " ********")

        #Init the remoteec endpoint and information
        self.remoteEc = RemoteEc(self)
        self.pull_exaunits()

        if len(args) > 0:
            line = self.precmd(" ".join(args))
            if (line.startswith("switchmode")):
                cl.prt("p", "For non-interactive invocation of ecracli, switchmode command is not supported.")
                return
            interactive = False
            cl.interactive = False
            self.interactive = False
            self.onecmd(line)
            return


        interactive = True
        cl.interactive = True
        self.interactive = True
        try:
            import readline
            readline.parse_and_bind("tab: complete")
        except ImportError:
            pass

        ecra_mode = self.issue_get_request("{0}/properties/{1}".format(self.HTTP.host, "ECRA_MODE"),False)
        hide_clusters=""
        if "property_value" in ecra_mode and ecra_mode["property_value"] == "prod":
            hide_clusters = "hide_clusters=True "
        hide_clusters += "ecraonly=yes"
        self.do_info(hide_clusters)
        if not switchmode:
            self.cmdloop()

    def getNewIdemtoken(self):
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token")
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        idemtoken = retObj["idemtoken"]
        return  idemtoken

    def get_ecra_auth(self, username=None, password=None):
        """
        29331153 Read password from file system
        This should be only able when 'username' and 'password' Command line
        options were provided, being username the a string with the name of
        the ECRA user and password the path of the file were the password
        is stored, this file should have write permission to erase it after
        the password was read.

        29856089 Password file should always be deleted after being used
        """


        if password is None:
            cl.perr("The option 'username' requires 'password' option.")
            sys.exit(1)

        if os.path.isfile(password) is False:
            cl.perr("The option 'password' should pass an existing file!")
            sys.exit(1)

        if os.access(os.path.abspath(os.path.dirname(password)), os.W_OK) is False:
            cl.perr("The directory of the password file is not writable!")
            sys.exit(1)

        passwd = None
        with open(password, 'r') as fobj:
            passwd = fobj.read().strip()

        if passwd == "":
            cl.perr("Empty password inside the password file provided '%s'." % \
                    password)
            sys.exit(1)

        os.remove(password)

        setattr(self, "username", username)
        setattr(self, "password", passwd)


    #Handle empty pwds
    def handle_prompt(self):
        patterns=["username","password"] #Patterns to look in api_params for prompt
        for pattern in patterns :
            if pattern == "username":
                value = input("Enter 'username': ")
            else:
                # Prompt for an input from the users
                value = self.prompt_values(pattern)
            # Accept the user input and set the value
            if pattern in self.api_params:
                setattr(self, pattern, value)

        #Ask for empty pwds, for PROD purposes only, although pwds can be provided in command line
    def prompt_values (self , key) :
        data = getpass.getpass("Enter '{0}': ".format (key))
        return data

    # Getter for ECRA API params
    def get_api_params_dict(self):
        api_params_dict = {}
        for param in self.api_params:
            api_params_dict[param] = getattr(self, param, None)
        return api_params_dict

    # create http endpoint caller with current settings
    def initHttp(self):
        self.HTTP = HTTP(self.get_api_params_dict(), self.ssl_params, self.verbose)
        if (self.startup_options["mode"] == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
            return

        try:
            req_headers = {}
            req_headers["Authorization"] = self.HTTP.auth_header
            req=urllib.request.Request("{0}/version".format(self.host), headers=req_headers)
            response=self.HTTP.opener.open(req)
        except (http.client.HTTPException,urllib.error.URLError) as e:
            cl.perr(str(e))
            cl.perr("*** ECRA communication. Please ensure host '%s' is up and running and credentials are ok. ***" % self.host)
            sys.exit(0)

    def emptyline(self):
        pass

    def precmd(self, line):
        user = self.username if self.username else "not-set"
        try:
            tokenized_line = shlex.split(line)
            modified_line = ""
            for token in tokenized_line:
                modified_token = re.sub(r'(.?)([pP][aA][sS]*[wW][oO]*[rR]*[dD])(=)([\w\W]*)', lambda x : x.group(1)+x.group(2)+'='+'********', token)
                modified_line += modified_token + ' '
            modified_line.strip()
            logger.info("[User: " + user + "]" + self.prompt + modified_line)
        except Exception as e:
            cl.perr(str(e))
        return line

    def onecmd(self, line):
        try:
            blocklistApi = self.blocklist_api_params
            apiBlocked = False
            if line.strip() in blocklistApi:
                cl.perr("API is blocked from ECRA: {0}".format(line))
                apiBlocked = True
            else:
                line_split = line.split()
                for item in blocklistApi:
                    item_split = item.split()
                    if item_split == line_split:
                        cl.perr("API is blocked for ECRA: {0}".format(line))
                        apiBlocked = True
                        break
            if not apiBlocked:
                return cmd.Cmd.onecmd(self, line)
        except Exception as e:
            cl.perr(str(e))

    # handle interactive parameter setting: param_name=param_value
    def default(self, line):
        if not line:
            return

        paramList = line.replace(' ', '').split('=', 1)
        if len(paramList) != 2:
            cl.perr("Command not found: {0}".format(line))
            return

        if paramList[0] in Ecracli.api_params:
            setattr(self, paramList[0], paramList[1])
            if interactive:
                cl.prt("c", "SET {0} = {1}".format(paramList[0], paramList[1]))
            self.initHttp()

        elif paramList[0] == "verbose":
            self.verbose = paramList[1] == "True" or paramList[1] == "true"
            self.HTTP.verbose = self.verbose
            if interactive:
                cl.prt("c", "SET {0} = {1}".format(paramList[0], str(self.verbose)))
        else:
            cl.perr("{0} is not a valid parameter or it's not allowed to edit interactively".format(paramList[0]))

    def parse_params(self, line, config_sections, warning=True, optional_key=None):
        config_params = dict()
        if line:
            line = re.sub(' {2,}', ' ', line)
            try:
                params = shlex.split(line)

                #Handle first optional parameter.
                if optional_key and "=" not in params[0]:
                    params[0] = optional_key+"="+params[0]

                params = [option.split("=", 1) for option in params]
                params = dict(params)
            except Exception:
                return "invalid options format, please specify options with <param_option>=<value>"
        else:
            params = {}

        if config_sections is None:
            return params

        if type(config_sections) is list:
            for section in config_sections:
                config_params.update(dict(self.config.items(section)))
        else:
            config_params = dict(self.config.items(config_sections))

        for option in params:
            if option in config_params or not warning:
                config_params[option] = params[option]
            elif warning:
                return "{0} is not a valid option, available options are {1}".format(option, ",".join(self.config.options(config_sections)))

        return config_params

    def exaunit_id_from(self, item):
        if item in self.rackToExaunit:
            item = str(self.rackToExaunit[item])

        if item is None or not item or not item.isdigit():
            error_str = "Please specify a valid exaunit ID or a unique rack name. Available racknames & exaunit ids are: " + str(self.rackToExaunit)
            raise Exception(error_str)

        return item

    def waitForCompletion(self, response, request_type, requireCompletion=False):
        # Empty response. Nothing to do. print error.
        if not response:
            cl.perr(request_type + " failed.")
            return

        non_202_responses = ["delete_service"]
        if response["status"] != 202:
            if request_type not in non_202_responses:
                cl.perr("{} failed. Response code: {}".format(request_type, response["status"]))
                try:
                    data = json.dumps(response, sort_keys=True, indent=4)
                    cl.prt("c", data)
                except Exception as e:
                    cl.perr("Error: {}".format(e))
                return

        status_uri = response["status_uri"]
        status_response = self.HTTP.get(status_uri)

        if not status_response:
            cl.perr(request_type + " failed")
            return

        if status_response["status"] != 202 and status_response["status"] != 200:
            cl.perr("Request failed:")
            try:
                # dumping json
                data = json.dumps(status_response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

            return

        target_uri = None
        if "target_uri" in status_response:
            target_uri = status_response["target_uri"]

        if not requireCompletion and not interactive:
            print(status_uri)
            return

        cl.prt("c", "STATUS URI : {0}".format(status_uri))
        if target_uri:
            cl.prt("c", "TARGET URI : {0}".format(target_uri))
        if self.pull_status(status_uri):
            cl.prt("c", "Request " + request_type + " successfully completed")
            if request_type == "create_service":
                exaunit_id = (target_uri.split("/"))[-1]
                cl.prt("c", "Exaunit {0} created".format(exaunit_id))
                return exaunit_id
            if request_type == "backup":
                status_response = self.HTTP.get(status_uri)
                backup_fields = ["backup_error","backup_success","backup","tag"]
                for e in backup_fields:
                    if e in status_response:
                        if e != "backup":
                            cl.prt("c", "{0}:{1}".format(e, status_response[e]))
                        else:
                            try:
                                if status_response[e]:
                                    data = json.dumps(status_response[e], indent=4)
                                    cl.prt("c", data)
                            except Exception as backupError:
                                cl.perr("{0}".format(backupError))
        else:
            cl.perr("Request " + request_type + " failed")

    # pull status information until complete and return target uri
    # verbose parameter is True by default to keep previous behavior
    def pull_status(self, status_uri, verbose=True):
        if verbose:
            cl.prt("c", "Request issued. Wait for completion. Pulling Status.")
        response = self.HTTP.get(status_uri)
        if not response:
            cl.perr("pulling status failed")
            return
        if verbose:
            print("* Status: processing..."),
            sys.stdout.flush()
        while response["status"] == 202:
            time.sleep(30)
            if verbose:
                print("......"),
                sys.stdout.flush()
            response = self.HTTP.get(status_uri)

            if not response:
                cl.perr("pulling status failed")
                return

            self.display_subworks(response)
        if verbose:
            print()
        if response["status"] != 200:
            cl.perr("Request failed:")
            # pringint json
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("n", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

        else:
            if "target_uri" in response:
                return response["target_uri"]
            return "no target uri"

    def do_switchmode(self, line):
        modeObj = Mode()
        modeObj.do_switchmode(self, line)

    def do_vm(self, line):
        return self.sub_op_do(line, 'vm')

    def do_service(self, line):
        return self.sub_op_do(line, 'service')

    def do_exaservice(self, line):
        return self.sub_op_do(line, 'exaservice')

    def do_exaunit(self, line):
        return self.sub_op_do(line, 'exaunit')

    def do_db(self, line):
        return self.sub_op_do(line, 'db')

    def do_pdb(self, line):
        return self.sub_op_do(line, 'pdb')

    def do_em(self, line):
        return self.sub_op_do(line, 'em')

    def do_rack(self, line):
        return self.sub_op_do(line, 'rack')

    def do_zone(self, line):
        return self.sub_op_do(line, 'zone')

    def do_location(self, line):
        return self.sub_op_do(line, 'location')

    def do_sshkey(self, line):
        return self.sub_op_do(line, 'sshkey')

    def do_patchcps(self, line):
        return self.sub_op_do(line, 'patchcps')

    def do_iorm(self, line):
        return self.sub_op_do(line, 'iorm')

    def do_properties(self, line):
        return self.sub_op_do(line, 'properties')

    def do_inventory(self, line):
        return self.sub_op_do(line, 'inventory')

    def do_formation(self, line):
        return self.sub_op_do(line, 'formation')

    def do_capacity(self, line):
        return self.sub_op_do(line, 'capacity')

    def do_ecspatchversion(self, line):
         return self.sub_op_do(line, 'ecspatchversion')

    def do_exadata_applied_version(self, line):
         return self.sub_op_do(line, 'exadata_applied_version')

    def do_rackslot(self, line):
        return self.sub_op_do(line, 'rackslot')

    def do_dg(self, line):
        return self.sub_op_do(line, 'dg')

    def do_ebtables(self, line):
        return self.sub_op_do(line, 'ebtables')

    def do_clone(self, line):
        return self.sub_op_do(line, 'clone')

    def do_test(self, line):
        return self.sub_op_do(line, 'test')

    def do_idemtoken(self, line):
        return self.sub_op_do(line, 'idemtoken')

    def do_snap(self, line):
        return self.sub_op_do(line, 'clone')

    def do_cns(self, line):
        return self.sub_op_do(line, 'cns')

    def do_schedule(self, line):
        return self.sub_op_do(line, 'schedule')

    def do_diagnosis(self, line):
        return self.sub_op_do(line, 'diagnosis')

    def do_higgs(self, line):
        return self.sub_op_do(line, 'higgs')

    def do_kvmroce(self, line):
        return self.sub_op_do(line, 'kvmroce')

    def do_backfill(self, line):
        return self.sub_op_do(line, 'backfill')

    def do_exadatainfrastructure(self, line):
        return self.sub_op_do(line, 'exadatainfrastructure')

    def do_atp(self, line):
        return self.sub_op_do(line, 'atp')

    def do_profiling(self, line):
        return self.sub_op_do(line, 'profiling')

    def do_ecra(self, line):
        return self.sub_op_do(line, 'ecra')

    def do_metadata(self, line):
        return self.sub_op_do(line, 'metadata')

    def do_exacloud(self, line):
        return self.sub_op_do(line, 'exacloud')

    def do_analytics(self, line):
        return self.sub_op_do(line, 'analytics')

    def do_cache(self, line):
        return self.sub_op_do(line, 'cache')

    def do_preprov(self, line):
        return self.sub_op_do(line, 'preprov')

    def do_ingestion(self, line):
        return self.sub_op_do(line, 'ingestion')

    def do_exacompute(self, line):
        return self.sub_op_do(line, 'exacompute')

    def do_errorcode(self, line):
        return self.sub_op_do(line, 'errorcode')

    def do_cluster(self, line):
        return self.sub_op_do(line, 'cluster')

    def do_cabinet(self, line):
        return self.sub_op_do(line, 'cabinet')

    def do_gcsinfra(self, line):
        return self.sub_op_do(line, 'gcsinfra')

    def do_jumbo(self, line):
        return self.sub_op_do(line, 'jumbo')

    def do_requests(self, line):
        return self.sub_op_do(line, 'requests')

    def do_exadata(self, line):
        return self.sub_op_do(line, 'exadata')

    def do_exawatcher(self, line):
        return self.sub_op_do(line, 'exawatcher')

    def do_vmbackup(self, line):
        return self.sub_op_do(line, 'vmbackup')

    def do_hardware(self, line):
        return self.sub_op_do(line, 'hardware')

    def do_userconfig(self, line):
        return self.sub_op_do(line, 'userconfig')

    def do_workflowctl(self, line):
        propObj = WorkflowCtl(self.HTTP)
        propObj.do_workflowctl(self, line, self.host)

    def do_workflows(self, line):
        return self.sub_op_do(line, 'workflows')

    def do_exacc(self, line):
        return self.sub_op_do(line, 'exacc')

    def do_ocitenants(self, line):
        return self.sub_op_do(line, 'ocitenants')

    def do_ocicapacity(self, line):
        return self.sub_op_do(line, 'ocicapacity')

    def do_ocicpinfra(self, line):
        return self.sub_op_do(line, 'ocicpinfra')

    def do_heartbeat(self, line):
        return self.sub_op_do(line, 'heartbeat')

    def do_compliance(self, line):
        return self.sub_op_do(line, 'compliance')

    def do_opctl(self, line):
        return self.sub_op_do(line, 'opctl')

    def do_bonding(self, line):
        return self.sub_op_do(line, 'bonding')

    def do_exaversion(self, line):
        return self.sub_op_do(line, 'exaversion')

    def do_security(self, line):
        return self.sub_op_do(line, 'security')

    def do_infrapassword(self, line):
        return self.sub_op_do(line, 'infrapassword')

    def do_passwordmanagement(self, line):
        return self.sub_op_do(line, 'passwordmanagement')

    def do_agent(self,line):
       return self.sub_op_do(line, 'agent')

    def do_sla(self, line):
        return self.sub_op_do(line, 'sla')

    def do_topology(self, line):
        return self.sub_op_do(line, 'topology')

    def do_sitegroup(self, line):
        return self.sub_op_do(line, 'sitegroup')

    def do_oci(self, line):
        return self.sub_op_do(line, 'oci')

    def do_domu(self, line):
        return self.sub_op_do(line, 'domu')

    def do_user(self, line):
        return self.sub_op_do(line, 'user')

    def do_vmconsole(self, line):
        return self.sub_op_do(line, 'vmconsole')

    def do_patchmetadata(self, line):
        return self.sub_op_do(line, 'patchmetadata')

    def do_artifact(self, line):
        return self.sub_op_do(line, 'artifact')

    def do_compatibility(self, line):
        return self.sub_op_do(line, 'compatibility')

    def do_vault(self, line):
        return self.sub_op_do(line, 'vault')

    def do_faultinjection(self, line):
        return self.sub_op_do(line, 'faultinjection')

    def do_resourceblackout(self, line):
        return self.sub_op_do(line, 'resourceblackout')

    def do_exascale(self, line):
        return self.sub_op_do(line, 'exascale')

    # for each operation <op> look for the corresponding sub-operation <sub_act>
    def sub_op_do(self, line, op):
        sub_act = line.split(' ').pop(0)
        args = line.replace(sub_act,"",1).strip()
        #check if suc_act is valid sub operation
        if self.sub_ops[op].get(sub_act, None) is not  None :
            errorFlag = False
            #if sub_ops json has 3rd level sub operations
            if isinstance(self.sub_ops[op][sub_act],dict):
                if args == "":
                    #if ecra expects a 3rd sub command and it's not given will be exit with sub command hints
                    errorFlag = True
                else:
                    tmp_3rdact = args.split(' ').pop(0)
                    #check if next parameters is a sub activity
                    if tmp_3rdact in self.sub_ops[op][sub_act]:
                        #delete 3 sub op from args and run
                        args2 = args.replace(tmp_3rdact,"",1).strip()
                        return getattr(self,"do_"+self.sub_ops[op][sub_act][tmp_3rdact])(args2)
                    else:
                        #if passed command is not on the list will exit showing valid commands
                        errorFlag = True
                if errorFlag:
                    cl.perr("{0} error: \"{1} {2}\" is not a valid sub operation, should have a valid 3rd sub Operation associated.".format(op, sub_act, args))
                    cl.prt("n","Valid 3rd sub operations: "+str(list((self.sub_ops[op][sub_act]).keys())))
                    return 0
            return getattr(self,"do_"+self.sub_ops[op][sub_act])(args)
        cl.perr("{0} error: \"{1}\" is not a valid sub operation.".format(op, sub_act))
        cl.prt("n","Valid sub operations: "+str(sorted((self.sub_ops[op]).keys())))

    def complete_vm(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'vm')

    def complete_service(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'service')

    def complete_exaservice(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exaservice')

    def complete_exaversion(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exaversion')

    def complete_exaunit(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exaunit')

    def complete_exacloud(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exacloud')

    def complete_analytics(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'analytics')

    def complete_cache(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'cache')

    def complete_preprov(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'preprov')

    def complete_ingestion(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'ingestion')

    def complete_exacompute(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exacompute')

    def complete_errorcode(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'errorcode')

    def complete_exawatcher(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exawatcher')

    def complete_db(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'db')

    def complete_rack(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'rack')

    def complete_zone(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'zone')

    def complete_location(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'location')

    def complete_sshkey(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'sshkey')

    def complete_iorm(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'iorm')

    def complete_dg(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'dg')

    def complete_ebtables(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'ebtables')

    def complete_clone(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'clone')

    def complete_capacity(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'capacity')

    def complete_rackslot(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'rackslot')

    def complete_test(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'test')

    def complete_properties(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'properties')

    def complete_idemtoken(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'idemtoken')

    def complete_cns(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'cns')

    def complete_schedule(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'schedule')

    def complete_diagnosis(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'diagnosis')

    def complete_higgs(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'higgs')

    def complete_inventory(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'inventory')

    def complete_kvmroce(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'kvmroce')

    def complete_backfill(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'backfill')

    def complete_exadatainfrastructure(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exadatainfrastructure')

    def complete_bonding(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'bonding')

    def complete_gcsinfra(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'gcsinfra')

    def complete_jumbo(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'jumbo')

    def complete_em(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'em')

    def complete_vmbackup(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'vmbackup')

    def complete_requests(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'requests')

    def complete_exadata(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'exadata')

    def complete_hardware(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'hardware')

    def complete_cluster(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'cluster')

    def complete_cabinet(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'cabinet')

    def complete_userconfig(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'userconfig')

    def complete_workflows(self, text, line, begidx, endidx):
        return self.sub_op_complete (text, line, 'workflows')

    def complete_ocitenants(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'ocitenants')

    def complete_ocicapacity(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'ocicapacity')

    def complete_ocicpinfra(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'ocicpinfra')

    def complete_compliance(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'compliance')

    def complete_infrapassword(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'infrapassword')

    def complete_passwordmanagement(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'passwordmanagement')

    def complete_sla(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'sla')


    def complete_topology(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'topology')

    def complete_oci(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'oci')

    def complete_domu(self, text, line, begidx, endidx):
        if line.count(" ") > 2: return []
        return self.sub_op_complete(text, line, 'domu')

    def complete_user(self, text, line, begidx, endidx):
        if line.count(" ") > 2 : return []
        return self.sub_op_complete (text, line, 'user')

    def do_register_launch_node(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_register_launch_node(self, line, self.host)

    def do_sync_infra_images(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_sync_infra_images(self, line, self.host)

    def do_deregister_launch_node(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_deregister_launch_node(self, line, self.host)

    def do_sync_vm_state(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_sync_vm_state(self, line, self.host)

    def do_get_launch_node(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_get_launch_node(self, line, self.host)

    def do_register_pluginscript(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_register_pluginscript(self, line, self.host)

    def do_list_pluginscript(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_list_pluginscript(self, line, self.host)

    def do_update_pluginscript(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_update_pluginscript(self, line, self.host)

    def do_deregister_pluginscript(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_deregister_pluginscript(self, line, self.host)

    def do_delete_launchnodemetadata(self, line):
        PatchMetaObj = PatchMetadata(self.HTTP)
        PatchMetaObj.do_delete_launchnodemetadata(self, line, self.host)

    # The generic "complete_<...>"
    def sub_op_complete (self, text, line, op):
        if not text:
            completions = list(self.sub_ops[op].keys())
        else:
            completions = []
            for i in list(self.sub_ops[op].keys()) :
                if i.startswith( (str(text)) ) :
                    completions.append(i)
        return completions

    def do_create_sdb(self, line):
        CreateSdbObj = CreateSdb(self.HTTP)
        CreateSdbObj.do_create_sdb(self, line)

    # create service and delete it upon completion
    def do_test_createdelete(self, line):
        testObj = Testops(self.HTTP)
        testObj.do_test_createdelete(self, line, self.host)

    # Patching code interface
    def do_patch(self, line):
        patchObj = Patch(self.HTTP)
        target = line.split(' ').pop(0)
        if (target == 'cps'):
            patchObj.do_cps_patch(self, line, self.host)
        elif (target == 'getDebugInfo'):
            patchObj.do_get_patch_debug_info(self, line, self.host)
        elif (target == 'qfab'):
            patchObj.do_qfab_patch(self, line, self.host, mytmpldir)
        else:
            patchObj.do_patch(self, line, self.host, mytmpldir)

    def do_register_exaversion_imageseries(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_register_exaversion_imageseries(self, line, self.host)

    def do_get_exaversion_imageseries(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_get_exaversion_imageseries(self, line, self.host)

    def do_register_exaversion(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_register_exaversion(self, line, self.host)

    def do_deregister_exaversion(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_deregister_exaversion(self, line, self.host)

    def do_get_service_type(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_get_service_type(self, line, self.host)

    def do_add_service_type(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_add_service_type(self, line, self.host)

    def do_get_exaversion(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_get_exaversion(self, line, self.host)

    def do_list_patches(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_list_patches(self, line, self.host)

    def do_list_patchesmetadata(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_list_patchesmetadata(self, line, self.host)

    def do_purge_patches(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_purge_patches(self, line, self.host)

    #pdb commands
    def do_register_pdb(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_register_pdb(self, line)

    def do_deregister_pdb(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_deregister_pdb(self, line)

    def do_info_pdb(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_info_pdb(self, line)

    # em commands
    def do_list_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_list_em(self, line, self.host)

    def do_reregister_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_reregister_em(self, line, self.host)

    def do_setup_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_setup_em(self, line, self.host)

    def do_update_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_update_em(self, line, self.host)

    def do_add_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_add_em(self, line, self.host)

    def do_delete_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_delete_em(self, line, self.host)

    def do_disable_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_disable_em(self, line, self.host)

    def do_enable_em(self, line):
        EMObj = EM(self.HTTP)
        EMObj.do_enable_em(self, line, self.host)


    # logs flow is interactive
    def do_ecralogs(self, line):
        response=""
        if len(line) == 0:
            self.help_ecralogs()
            return

        params = line.split(" ")
        folder=os.path.abspath(params[0])
        requestId=None
        if len(params) >= 3:
            requestId=params[2]

        if "-zip" in line:
            self.issue_ecralogs_zip(line,folder,requestId)
        elif os.path.isdir(folder.strip()):
            response = self.issue_ecralogs(folder)
        else:
            self.help_ecralogs()

    # db backup flow
    def do_backup(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_backup(self, line)

    def do_recover(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_recover(self, line)

    def do_dbpatch(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_dbpatch(self, line)

    def do_heartbeat_ecra_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_heartbeat_ecra_db(self, line)

    def do_dgsetup(self, line):
        dgObj = Dataguard(self.HTTP)
        dgObj.do_dgsetup(self, line, self.host, mytmpldir)

    def do_dgconfig(self, line):
        dgObj = Dataguard(self.HTTP)
        dgObj.do_dgconfig(self, line, self.host, mytmpldir)

    def do_create_dgdb(self, line):
        dgObj = Dataguard(self.HTTP)
        dgObj.do_create_dgdb(self, line)

    def get_dbJson(self, line):
        line = line.split(' ', 1)
        exaunit_id, rest = self.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = self.parse_params(rest, "DBParams", warning=False)
        if type(params) is str:
            cl.perr(params)
            return

        if "dbSID" not in params or not params["dbSID"]:
            params["dbSID"] = "db" + str(uuid.uuid4())[-6:]

        # Also add it as dbName.
        params["dbName"] = params["dbSID"]

        with open(self.dbJsonPath) as json_file:
            dbJson = json.load(json_file)

        dbJson["exaunitID"] = exaunit_id

        for name, value in list(params.items()):
            if value:
                dbJson[name] = value


        if "sshkey" in params and params["sshkey"]:
            key_file_path = dbJson["sshkey"]
            if not os.path.exists(key_file_path):
                cl.perr("SSH key path for createDB is not valid")
                return
            with open(key_file_path, 'r') as ssh_key_file:
                dbJson["sshkey"] = ssh_key_file.read()
        else:
            _cmd = ["ssh-keygen", "-t", "rsa", "-N", "", "-q", "-f", "dbexaunit"]
            process = Popen(_cmd, stdout=PIPE, stderr=PIPE, shell=False)
            output, error = process.communicate()

            with open('dbexaunit.pub', 'r') as f:
                dbJson["sshkey"] = f.read()

            try:
                os.remove('dbexaunit')
                os.remove('dbexaunit.pub')
            except:
                cl.perr("Cannot delete the ssh key file")

        container = dbJson["cloudStorageContainer"]
        password  = dbJson["cloudStoragePassword"]
        username  = dbJson["cloudStorageUsername"]

        # adding white list to not validate the connectivity in the following configurations
        # NONE / NFS / ZDLRA
        if "backupDest" in dbJson:
            if dbJson["backupDest"] is not None and dbJson["backupDest"].upper() not in ["NONE","NFS","ZDLRA"]:
                try:
                    req = urllib.request.Request(container)
                    req.add_header("Authorization", "Basic " + base64.b64encode(username + ":" + password).rstrip())
                    res = urllib.request.urlopen(req)
                except Exception as e:
                    cl.perr(str(e))
                    cl.perr("OSS cloudStorageContainer is not reachable by the given credentials. Please modify it in ecracli.cfg")
                    return
        return dbJson, exaunit_id

    def issue_ecralogs(self, line):
        # verifying if directory is valid
        if not path.exists(line.strip()):
            cl.perr("Error: target directory does not exist {0}".format(line))
            self.help_ecralogs()
            return

        getOut = self.HTTP.get("{0}/control/logs".format(self.host))
        if not getOut:
            cl.perr("Error: cannot get the list of ecra logs")
            return

        try:
            if not "logs" in getOut:
                cl.perr("no logging information for this instance")
                return
            if getOut["logs"]:
                for log in getOut["logs"]:
                    cl.prt("c", log["name"])
                    if log["content"]:
                        try:
                            cl.prt("c", "saving .. content")
                            with open(os.path.join(line, str(log["name"]).replace("/","")), "w") as logfile:
                                logfile.write(log["content"])

                        except Exception as IOError:
                            cl.perr("{0}".format(IOError))

        except Exception as err:
            cl.perr("{0}".format(err))

        return getOut

    def issue_ecralogs_zip(self,line,mylogdir,requestId = None):

        response = self.HTTP.get("{0}/control/logs/zip?dest={1}&requestId={2}".format(self.host,mylogdir,requestId))
        if not response:
            cl.perr("Error: cannot get the list of ecra logs")
            return
        cl.prt("n", json.dumps(response))

    #issue create service request and pull status until complete
    def do_create_service(self, line):
        self.Hardware = Hardware(self.HTTP)
        serviceObj = Service(self.HTTP)
        serviceObj.do_create_service(self, line, mytmpldir, interactive)

    def get_entitlement_category(self, purchase_type):
        if purchase_type not in self.purchasetypeMap:
            cl.perr("given purchase_type " + purchase_type + " is not valid. available service types are: " + ", ".join(
                list(self.purchasetypeMap.keys())))
            return None

        return self.purchasetypeMap[purchase_type]

    # delete the given exaunit and then recreate it
    def do_recreate_service(self, line):
        serviceObj = Service(self.HTTP)
        serviceObj.do_recreate_service(self, line, interactive)

    # delete service on given exaunit
    def do_delete_service(self, line):
        serviceObj = Service(self.HTTP)
        serviceObj.do_delete_service(self, line, interactive)

    # reshape service on given exaunit
    def do_exaunit_reshape(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_reshape(self, line, self.host)

    # get the monitoring information for the given exaunit
    def do_exaunit_monitoring(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_monitoring(self, line, self.host)

    # drop exaunit information
    def do_drop_exaunit(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_drop_exaunit(self, line, self.host)

    # get exaunit information
    def do_get_exaunit(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_get_exaunit(self, line, self.host)

    def do_get_allexaunits(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_get_allexaunits(self, line, self.host)

    # issue a get request to the given url
    def issue_get_request(self, url, printResponse=True, printPaginationHeaders=False):
        if interactive and printResponse:
            cl.prt("c", "GET " + url)
        response = self.HTTP.get(url, printPaginationHeaders=printPaginationHeaders)
        if not response:
            cl.perr("Failed to get " + url)
            return
        if printResponse:
            cl.prt("n", json.dumps(response))
        return response

    # get service information
    def do_get_service(self, line):
        serviceObj = Service(self.HTTP)
        serviceObj.do_get_service(self, line)

    # update vm memory on given exaunit
    def do_service_update_memory(self, line):
        serviceObj = Service(self.HTTP)
        serviceObj.do_service_update_memory(self, line, self.host)

    #Add SE linux policy
    def do_add_selinuxpolicy(self, line):
        securityObj = Security(self.HTTP)
        securityObj.do_add_selinuxpolicy(self, line, self.host)

    #List SE linux policy
    def do_list_selinuxpolicy(self, line):
        securityObj = Security(self.HTTP)
        securityObj.do_list_selinuxpolicy(self, line, self.host)

    def do_dump_selinuxpolicy(self, line):
        securityObj = Security(self.HTTP)
        securityObj.do_dump_selinuxpolicy(self, line, self.host)

    #Filesystem
    def do_add_fsencryption(self, line):
        securityObj = Security(self.HTTP)
        securityObj.do_add_fsencryption(self, line, self.host)

    def do_remove_fsencryption(self, line):
        securityObj = Security(self.HTTP)
        securityObj.do_remove_fsencryption(self, line, self.host)

    def do_list_fsencryption(self, line):
        securityObj = Security(self.HTTP)
        securityObj.do_list_fsencryption(self, line, self.host)

    def do_create_exaservice(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_create_exaservice(self, line, self.host, mytmpldir)
        self.waitForCompletion(response, "create_exaservice")
        self.pull_exaunits()

    def do_add_cluster(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_add_cluster(self, line, self.host, mytmpldir)
        self.waitForCompletion(response, "add_cluster")
        self.pull_exaunits()

    def do_reshape_cluster(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_reshape_cluster(self, line, self.host, mytmpldir)
        self.waitForCompletion(response, "reshape_cluster")

    def do_coreburst_cluster(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_coreburst_cluster(self, line, self.host, mytmpldir)
        self.waitForCompletion(response, "coreburst_cluster")

    def do_delete_cluster(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_delete_cluster(self, line, self.host, mytmpldir)
        self.waitForCompletion(response, "delete_cluster")
        self.pull_exaunits()

    def do_migrate_exaservice(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_migrate_exaservice(self, line, self.host)

    def do_migrate_status(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_migrate_status(self, line, self.host)

    def do_migrate_prefetch(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_migrate_prefetch(self, line, self.host)

    def do_migrate_postfetch(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_migrate_postfetch(self, line, self.host)

    def do_migrate_postupdate(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_migrate_postupdate(self, line, self.host)

    def do_migrate_rollback(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_migrate_rollback(self, line, self.host)

    def do_reshape_exaservice(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_reshape_exaservice(self, line, self.host)
        self.waitForCompletion(response, "reshape_exaservice")

    def do_delete_exaservice(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_delete_exaservice(self, line, self.host, mytmpldir)

    def do_list_exaservice(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_list_exaservice(self, line, self.host)

    def do_fetch_rackinfo(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_fetch_rackinfo_for_exaservice(self, line, self.host)

    def do_resume_exaservice(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_resume_exaservice(self, line, self.host)
        if response["status"] == 200:
            return response
        self.waitForCompletion(response, "resume_exaservice")

    def do_suspend_exaservice(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        response = exaserviceObj.do_suspend_exaservice(self, line, self.host)
        if response["status"] == 200:
            return response
        self.waitForCompletion(response, "suspend_exaservice")

    def do_fetch_resourceinfo(self, line):
        exaserviceObj = Exaservice(self.HTTP)
        exaserviceObj.do_fetch_resourceinfo(self, line, self.host)

    # get network information from rack xml for the given exaunit
    def do_exaunit_info(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_info(self, line, self.host)

    #Extract logs from exaunit
    def do_exaunit_logs(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_logs(self,line,self.host,mylogdir)

    # get cores allocation info for the given exaunit
    def do_exaunit_cores(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_cores(self, line, self.host)

    # list dbSIDs of created databases for the given exaunit
    def do_exaunit_dbs(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_dbs(self, line, self.host)

    # resume exaunit
    def do_exaunit_resume(self, line):
        self.exaunit_operation("resume", line)

    # suspend exaunit
    def do_exaunit_suspend(self, line):
        self.exaunit_operation("suspend", line)

    # get the detailed parameters for the given exaunit
    def exaunit_operation(self, action, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.exaunit_operation(self, action, line, self.host)

    # get the detailed parameters for the given exaunit
    def do_exaunit_detail(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_detail(self, line, self.host)

    # update exaunit detail
    def do_exaunit_detail_update(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_detail_update(self, line, self.host)

    def do_exaunit_vms(self,line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_vms(self, line, self.host)

    def do_exaunit_domukeys(self,line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_domukeys(self, line, self.host)

    # resize service with given number of cores
    def do_resize_exaunit(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_resize_exaunit(self, line, self.host, mytmpldir)

    # put the asm rebalance power
    def do_exaunit_asmrebalance(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_asmrebalance(self, line, self.host)

    def do_exaunit_hasoperation(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_hasoperation(self, line, self.host)

    def do_exaunit_resizefs(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_resizefs(self, line, self.host)

    def do_exaunit_list(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_list(self, line, self.host)


    def do_exaunit_addcompute(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_addcompute(self, line, self.host)

    def do_exaunit_addcell(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_addcell(self, line, self.host)

    def do_exaunit_deletecompute(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_deletecompute(self, line, self.host)

    def do_exaunit_deletecell(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_deletecell(self, line, self.host)

    def do_exaunit_reshapeprecheck(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_reshapeprecheck(self, line, self.host)

    def do_exaunit_elasticnodeprecheck(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_reshapeprecheck(self, line, self.host)

    def do_exaunit_getelasticnodeprecheck(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_getelasticnodeprecheck(self, line, self.host)

    def do_exaunit_getcspayload(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_getcspayload(self, line, self.host)

    def do_exaunit_generatecspayload(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_generatecspayload(self, line, self.host)

    def do_exaunit_updatetimezone(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_updatetimezone(self, line, self.host)

    def do_exaunit_getdginfo(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_getdginfo(self, line, self.host)

    def do_exaunit_securevms(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_securevms(self, line, self.host)

    def do_migrate_vmbackup_xs(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_migrate_vmbackup_xs(self, line, self.host)

    def do_exaunit_getoperations(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_getoperations(self, line, self.host)

    def do_exaunit_updatentpdns(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_updatentpdns(self, line, self.host)

    def do_exaunit_rotatekeys(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_rotatekeys(self, line, self.host)

    def do_exaunit_getcomputesizes(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_getcomputesizes(self, line, self.host)

    def do_exaunit_collectvmcore(self, line):
        exaunitObj = Exaunit(self.HTTP)
        exaunitObj.do_exaunit_collectvmcore(self, line, self.host)

    # get the status information from a status uuid or a request id
    def do_status(self, line):
        statusObj = Status(self.HTTP)
        statusObj.do_status(self, line, self.host)

    def do_listsubmittedwfs(self, line):
        statusObj = Status(self.HTTP)
        statusObj.do_get_submitted_wf_list(self, line, self.host)

    # get property value from the given property name
    def do_get_property(self, line):
        propObj = Properties(self.HTTP)
        propObj.do_get_property(self, line, self.host)

    # put property value for a given property name
    def do_put_property(self, line):
        propObj = Properties(self.HTTP)
        propObj.do_put_property(self, line, self.host)

    # get property types
    def do_properties_gettypes(self, line):
        propObj = Properties(self.HTTP)
        propObj.do_properties_gettypes(self, line, self.host)

    # Remove bond0 ips
    def do_deregister_higgs(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_deregister_higgs(self, line, self.host)

    # Higgs add ibsubnet function
    def do_add_ibsubnet(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_add_ibsubnet(self, line, self.host)

    # Higgs delete ibsubnet functoin
    def do_delete_ibsubnet(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_delete_ibsubnet(self, line, self.host)

    # create a new network
    def do_create_network(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_create_network(self, line, self.host)

    # delete a new network
    def do_delete_network(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_delete_network(self, line, self.host)

    # Get a particular network
    def do_get_network(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_get_network(self, line, self.host)

    # Get all the networks for a customer
    def do_getall_network(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_getall_network(self, line, self.host)

    # Delete all the higgs resources
    def do_delete_resources(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_delete_resources(self, line, self.host)

    #create NatIPS (NodeVIPs and SCANIps)
    def do_create_natvips(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_create_natvips(self, line, self.host)

    #delete NatIPS (NodeVIPs and SCANIps)
    def do_delete_natvips(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_delete_natvips(self, line, self.host)

    #list NatIPS (NodeVIPs and SCANIps)
    def do_list_natvips(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_list_natvips(self, line, self.host)

    #Create NatIP secrules
    def do_create_secprotocol(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_create_secprotocol(self, line, self.host)

    def do_create_secrule(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_create_secrule(self, line, self.host)

    def do_delete_secrule(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_delete_secrule(self, line, self.host)

    def do_get_secrule(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_get_secrule(self, line, self.host)

    def do_get_resources(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_get_resources(self, line, self.host)

    def do_remove_resource(self, line):
        higgsObj = Higgs(self.HTTP)
        higgsObj.do_remove_resource(self, line, self.host)

    def do_getInfo_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_getInfo_bonding(self, line, self.host)

    def do_setupMonitoringBond_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_setupMonitoringBond_bonding(self, line, self.host)

    def do_deleteMonitoringBond_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_deleteMonitoringBond_bonding(self, line, self.host)

    def do_getpayload_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_getpayload_bonding(self, line, self.host)

    def do_retrysetup_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_retrysetup_bonding(self, line, self.host)

    def do_migrationPrecheck_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_migrationPrecheck_bonding(self, line, self.host)

    def do_smartnicaction_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_smartnicaction_bonding(self, line, self.host)

    def do_migratevlan_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_migratevlan_bonding(self, line, self.host)

    def do_networkupdate_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_networkupdate_bonding(self, line, self.host)

    def do_monitorswitch_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_monitorswitch_bonding(self, line, self.host)

    def do_rpmupdate_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_rpmupdate_bonding(self, line, self.host)

    def do_rpmupdateall_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_rpmupdateall_bonding(self, line, self.host)

    def do_getelasticcabinets_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_getelasticcabinets_bonding(self, line, self.host)

    def do_addcustomvip_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_addcustomvip_bonding(self, line, self.host)

    def do_deletecustomvip_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_deletecustomvip_bonding(self, line, self.host)

    def do_linkfailover_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_linkfailover_bonding(self, line, self.host)

    def do_consistencycheck_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_consistencycheck_bonding(self, line, self.host)

    def do_restartmonitor_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_restartmonitor_bonding(self, line, self.host)

    def do_statusmonitor_bonding(self, line):
        bondingObj = Bonding(self.HTTP)
        bondingObj.do_statusmonitor_bonding(self, line, self.host)

    def do_create_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_create_exadatainfrastructure(self, line, self.host)

    def do_get_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_get_exadatainfrastructure(self, line, self.host)

    def do_delete_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_delete_exadatainfrastructure(self, line, self.host)

    def do_rack_reserve_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_rack_reserve_exadatainfrastructure(self, line, self.host)

    def do_rack_release_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_rack_release_exadatainfrastructure(self, line, self.host)

    def do_add_cluster_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_add_cluster(self, line, self.host)

    def do_reshape_cluster_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_reshape_cluster(self, line, self.host)

    def do_reshape_cluster_precheck_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_reshape_cluster_precheck(self, line, self.host)

    def do_restore_cluster_exadatainfrastructure(self,line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_restore_cluster(self, line, self.host)

    def do_attach_storage_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_attach_storage(self, line, self.host)

    def do_attach_storage_exascale_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_attach_storage_exascale(self, line, self.host)

    def do_delete_storage_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_delete_storage(self, line, self.host)

    def do_secureerase_exadatainfrastructure(self, line):
            exadatainfraObj = ExadataInfra(self.HTTP)
            exadatainfraObj.do_secureerase(self, line, self.host, interactive)

    def do_getsecureerasecert_exadatainfrastructure(self, line):
            exadatainfraObj = ExadataInfra(self.HTTP)
            exadatainfraObj.do_getsecureerasecert(self, line, self.host)

    def do_disablebackup_exadatainfrastructure(self, line):
            exadatainfraObj = ExadataInfra(self.HTTP)
            exadatainfraObj.do_disablebackup(self, line, self.host)

    def do_update_vm_state(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_update_vm_state(self, line, self.host)
    
    def do_check_data_integrity_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_check_data_integrity(self, line, self.host)

    def do_migrate_to_mvm_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_migrate_to_mvm(self, line, self.host)

    def do_info_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_info(self, line, self.host)

    def do_computevms_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_computevms(self, line, self.host)

    def do_drop_exadatainfrastructure(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_drop(self, line, self.host)

    def do_exadatainfrastructure_getinitialpayload(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_getinitialpayload(self, line, self.host)

    def do_exadatainfrastructure_getkeys(self, line):
            exadatainfraObj = ExadataInfra(self.HTTP)
            exadatainfraObj.do_getkeys(self, line, self.host)

    def do_run_recoverclunodes_sop(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_run_recoverclunodes_sop(self, line, self.host)

    def do_run_dropclunodes_sop(self, line):
        exadatainfraObj = ExadataInfra(self.HTTP)
        exadatainfraObj.do_run_dropclunodes_sop(self, line, self.host)

    def do_caviumip_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_caviumip_backfill(self, line, self.host)

    def do_adminsmartnics_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_adminsmartnics_backfill(self, line, self.host)

    def do_update_caviumid_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_update_caviumid_backfill(self, line, self.host)

    def do_updatecaviumip_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_updatecaviumip_backfill(self, line, self.host)

    def do_update_cavium_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_update_cavium_backfill(self, line, self.host)

    def do_updatesitegroup_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_updatesitegroup_backfill(self, line, self.host)

    def do_qfabdetails_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_qfabdetails_backfill(self, line, self.host)

    def do_mvmsubnetinfo_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_mvmsubnetinfo_backfill(self, line, self.host)

    def do_fabricexascale_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_fabricexascale_backfill(self, line, self.host)

    def do_vnic_cabinets_backfill(self, line):
        backfillObj = Backfill(self.HTTP)
        backfillObj.do_vnic_cabinets_backfill(self, line, self.host)

    def do_allocateComputeVlan_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_allocateComputeVlan_kvmroce(self, line, self.host)

    def do_allocateStorageVlan_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_allocateStorageVlan_kvmroce(self, line, self.host)

    def do_getComputeVlan_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getComputeVlan_kvmroce(self, line, self.host)

    def do_getStorageVlan_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getStorageVlan_kvmroce(self, line, self.host)

    def do_freeComputeVlan_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_freeComputeVlan_kvmroce(self, line, self.host)

    def do_freeStorageVlan_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_freeStorageVlan_kvmroce(self, line, self.host)

    def do_allocateComputeIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_allocateComputeIP_kvmroce(self, line, self.host)

    def do_allocateStorageIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_allocateStorageIP_kvmroce(self, line, self.host)

    def do_getComputeIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getComputeIP_kvmroce(self, line, self.host)

    def do_getStorageIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getStorageIP_kvmroce(self, line, self.host)

    def do_freeComputeIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_freeComputeIP_kvmroce(self, line, self.host)

    def do_freeStorageIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_freeStorageIP_kvmroce(self, line, self.host)

    def do_allocateExascaleIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_allocateExascaleIP_kvmroce(self, line, self.host)

    def do_getExascaleIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getExascaleIP_kvmroce(self, line, self.host)

    def do_freeExascaleIP_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_freeExascaleIP_kvmroce(self, line, self.host)

    def do_addFabric_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_addFabric_kvmroce(self, line, self.host)

    def do_deleteFabric_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_deleteFabric_kvmroce(self, line, self.host)

    def do_listFabric_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_listFabric_kvmroce(self, line, self.host)

    def do_getAllFabric_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getAllFabric_kvmroce(self, line, self.host)

    def do_isexascalepoolcreated_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_isexascalepoolcreated_kvmroce(self, line, self.host)

    def do_getAllCabinets_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getAllCabinets_kvmroce(self, line, self.host)

    def do_getAllNodes_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getAllNodes_kvmroce(self, line, self.host)

    def do_getCabinets_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getCabinets_kvmroce(self, line, self.host)

    def do_getCabinetNodes_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getCabinetNodes_kvmroce(self, line, self.host)

    def do_listFaultDomains_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_listFaultDomains_kvmroce(self, line, self.host)

    def do_runsanitycheck_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_runsanitycheck_kvmroce(self, line, self.host)

    def do_getsanityresults_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_getsanityresults_kvmroce(self, line, self.host)

    def do_updateFaultDomain_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_updateFaultDomain_kvmroce(self, line, self.host)

    def do_get_elastic_reservation_threshold_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_get_elastic_reservation_threshold_kvmroce(self, line, self.host)

    def do_set_elastic_reservation_threshold_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_set_elastic_reservation_threshold_kvmroce(self, line, self.host)

    def do_set_elastic_reservation_threshold_kvmroce_abs(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_set_elastic_reservation_threshold_kvmroce_abs(self, line, self.host)

    def do_get_elastic_reservation_setting_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_get_elastic_reservation_setting_kvmroce(self, line, self.host)

    def do_enable_utilization_based_elastic_reservation_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_enable_utilization_based_elastic_reservation_kvmroce(self, line, self.host)

    def do_disable_utilization_based_elastic_reservation_kvmroce(self, line):
        kvmRoceObj = Kvmroce(self.HTTP)
        kvmRoceObj.do_disable_utilization_based_elastic_reservation_kvmroce(self, line, self.host)

    def do_getinfo_gcsinfra(self, line):
        gcsInfraObj = GcsInfra(self.HTTP)
        gcsInfraObj.do_getinfo_gcsinfra(self, line, self.host)

    def do_getDetails_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getDetails_atp(self, line, self.host)

    #Get ATP Network details
    def do_getNetwork_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getNetwork_atp(self, line, self.host)

    #Save ATP Vnic info
    def do_registerVnic_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_registerVnic_atp(self, line, self.host)

    #Get ATP Vnic details
    def do_getVnicDetails_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getVnicDetails_atp(self, line, self.host)

    #Save ATP Management VCN details and components info
    def do_registerVcnDetails_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_registerVcnDetails_atp(self, line, self.host)

    #Save ATP Network Authentication info
    def do_registerAuth_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_registerAuth_atp(self, line, self.host)

    #Get ATP Admin tenancy Authentication info
    def do_getAdminIdentity_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getAdminIdentity_atp(self, line, self.host)

    #Save ATP Admin tenancy Authentication info
    def do_registerAdminIdentity_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_registerAdminIdentity_atp(self, line, self.host)

    #Create ATP Network
    def do_createNetwork_atp(self, line):
        atpObj = ATP(self.HTTP)
        response = atpObj.do_createNetwork_atp(self, line, self.host)
        self.waitForCompletion(response, "createNetwork_atp")

    #Delete ATP Network
    def do_deleteNetwork_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_deleteNetwork_atp(self, line, self.host)

    #Set some properties as part of bootstrap.
    def do_bootstrap_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_bootstrap_atp(self, line, self.host)

    #Save ATP Subnet info
    def do_registerSubnet_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_registerSubnet_atp(self, line, self.host)

    #Get ATP Network Subnet internal details
    def do_getPartnerSubnet_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getPartnerSubnet_atp(self, line, self.host)

    #Setup Dataguard  Network
    def do_setupDGNetwork_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_setupDGNetwork_atp(self, line, self.host)

    #Delete Dataguard  Network Rules
    def do_deleteDGNetworkRules_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_deleteDGNetworkRules_atp(self, line, self.host)

    # Add an ATP property
    def do_addProperty_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.add_property(self, line, self.host)

    # Get an ATP property
    def do_getProperty_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.get_property(self, line, self.host)

    # Delete an ATP property
    def do_deleteProperty_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.delete_property(self, line, self.host)

    # List customer tenancy records
    def do_customertenancy_list(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_customertenancy_list(self, line, self.host)

    # Insert/Update customer tenancy record
    def do_customertenancy_put(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_customertenancy_put(self, line, self.host)

    # Delete customer tenancy record
    def do_customertenancy_del(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_customertenancy_del(self, line, self.host)

    # Create Exadata Infrastructure
    def do_exadata_infrastructure_create(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_exadata_infrastructure_create(self, line, self.host)

    # Delete customer tenancy record
    def do_createPreProvVMCluster_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.createPreProvVMCluster(self, line, self.host)

    # Get atp Preprov metrics
    def do_getPreprovMetrics_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.getPreprovMetrics(self, line, self.host)

    # Update ECRA metadata related to ATP
    def do_updateNetMetadata_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.updateNetMetadata(self, line, self.host)

    # Create Oracle Client Subnet for ATP PreProvisioning
    def do_createOracleClientSubnet_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.createOracleClientSubnet(self, line, self.host)

    # Stop GI Service for ATP PreProvisioning
    def do_giServiceStop_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.giServiceStop(self, line, self.host)

    # Launch an observer instance
    def do_launchObserver_atp(self, line):
        atpObj = ATP(self.HTTP)
        response = atpObj.do_launchObserver_atp(self, line, self.host)
        self.waitForCompletion(response, "launchObserver_atp")

   # Delete an observer instance
    def do_deleteObserver_atp(self, line):
        atpObj = ATP(self.HTTP)
        response = atpObj.do_deleteObserver_atp(self, line, self.host)

    # Get observer instance details
    def do_getObserverDetails_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getObserverDetails_atp(self, line, self.host)

    # Fetch the observer SSH keys
    def do_fetchObserverKeys_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_fetchObserverKeys_atp(self, line, self.host)

    # Terminate observer instance
    def do_terminateObserver_atp(self, line):
        atpObj = ATP(self.HTTP)
        response = atpObj.do_terminateObserver_atp(self, line, self.host)
        self.waitForCompletion(response, "terminateObserver_atp")

    # Start an observer
    def do_startObserver_atp(self, line):
        self.observer_operation("START", line)

    # Stop an observer
    def do_stopObserver_atp(self, line):
        self.observer_operation("STOP", line)

    # Restart an observer
    def do_restartObserver_atp(self, line):
        self.observer_operation("SOFTRESET", line)

    # perform observer start/stop/restart
    def observer_operation(self, action, line):
        atpObj = ATP(self.HTTP)
        response = atpObj.observer_operation(self, action, line, self.host)
        self.waitForCompletion(response, "observer_operation")

    # Create preprovision dbsystem
    def do_createPreprovDbSystem_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_createPreprovDbSystem_atp(self, line, self.host)

    # Get pre provisioning scheduler details
    def do_getPreprovScheduler_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getPreprovScheduler_atp(self, line)

    # List racks scheduled for pre provisioning
    def do_listScheduledRacks_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_listScheduledRacks_atp(self, line)

    # Get pre provisioning jobs for scheduled rack
    def do_getScheduledRackPreprovJobs_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getScheduledRackPreprovJobs_atp(self, line)

    # Start pre provisioning scheduler
    def do_startPreprovScheduler_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_startPreprovScheduler_atp(self, line, mytmpldir)

    # Shutdown pre provisioning scheduler
    def do_shutdownPreprovScheduler_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_shutdownPreprovScheduler_atp(self, line)

    def do_reconfigService_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_reconfigService_atp(self, line, self.host)

    # Delete pre provisioning oracle client vcn
    def do_deletePreprovOracleClientVCN_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_deletePreprovOracleClientVCN_atp(self, line, self.host)

    # Delete pre provisioning oracle dbsystem
    def do_deletePreprovOracleDbSystem_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_deletePreprovOracleDbSystem_atp(self, line, self.host)

    # Ingest terraform data.
    def do_ingestTerraformData_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_ingestTerraformData_atp(self, line, self.host)

    # Set config rule
    def do_configRule_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_configRule_atp(self, line, self.host)

    # ATP vm rollback
    def do_vmrollback_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_vmrollback_atp(self, line, self.host)

    # ATP Update domU Rules
    def do_config_domurules_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_config_domurules_atp(self, line, self.host)

    # ATP create the OCI URL map
    def do_createOciUrlMap_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_createOciUrlMap_atp(self, line, self.host)

    # ATP Get the OCI URL map for a region
    def do_getOciUrlMap_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getOciUrlMap_atp(self, line, self.host)

    # ATP Get the OCI URL map for all
    def do_getOciUrlMapAll_atp(self, line):
        atpObj = ATP(self.HTTP)
        atpObj.do_getOciUrlMapAll_atp(self, line, self.host)

    #Profiling atp API
    def do_profiling_report(self,line):
        profilingObj = Profiling(self.HTTP)
        profilingObj.do_profiling_report(self, line, self.host)

    #Profiling for Specific Operations
    def do_profiling_operation(self, line):
        profilingObj = Profiling(self.HTTP)
        profilingObj.do_profiling_operation(self, line, self.host)

    #Profiling for Specific Infrastructure
    def do_profiling_infrastructure(self, line):
        profilingObj = Profiling(self.HTTP)
        profilingObj.do_profiling_infrastructure(self, line, self.host)

    #ECRA VALIDATE APIS Op
    def do_validate_apis(self, line):
        ecraObj = Ecra(self.HTTP)
        ecraObj.do_validate_apis(self, line, self.host)

    #ECRA dump config commands
    def do_dump_config(self, line):
        ecraObj = Ecra(self.HTTP)
        ecraObj.do_dump_config(self, line, self.host)

    #ECRA coredump commands
    def do_core_dump(self, line):
        ecraObj = Ecra(self.HTTP)
        ecraObj.do_core_dump(self, line, self.host)

    def do_upgrade_history(self,line):
        ecraObj = Ecra(self.HTTP)
        ecraObj.do_upgrade_history(self,line,self.host)

    #ECRA get file command
    def do_get_file(self, line):
        ecraObj = Ecra(self.HTTP)
        ecraObj.do_get_file(self, line, self.host)

    def do_update_file_ecra(self, line):
        ecraObj = Ecra(self.HTTP)
        ecraObj.do_update_file_ecra(self, line, self.host)

    def do_list_files_ecra(self, line):
        ecraObj = Ecra(self.HTTP)
        ecraObj.do_list_files_ecra(self, line, self.host)

    def do_deletepayloads(self, line):
        ecra = Ecra(self.HTTP)
        ecra.do_ecra_deletepayloads(self, line, self.host)

    def do_ecra_connect(self, line):
        ecra = Ecra(self.HTTP)
        response = ecra.do_ecra_connect(self, line, self.host, self.interactive)
        if 'status' in response and response['status'] == 200:
            if 'hostname' in response:
                self.host = response['hostname']

    #Metadata Select
    def do_metadata_select(self,line):
        ecraObj = Metadata(self.HTTP)
        ecraObj.do_metadata_select(self, line, self.host)

    #Metadata Update
    def do_metadata_update(self,line):
        ecraObj = Metadata(self.HTTP)
        ecraObj.do_metadata_update(self, line, self.host)

    #Metadata Tables
    def do_metadata_tables(self,line):
        ecraObj = Metadata(self.HTTP)
        ecraObj.do_metadata_tables(self, line, self.host)

    def do_exacloud_setexassh(self,line):
        exacloudObj = Exacloud(self.HTTP)
        exacloudObj.do_setexassh(self, line, self.host)

    def do_analytics_analyze(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_analyze(self, line, self.host)

    def do_analytics_history(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_history(self, line, self.host)

    def do_analytics_stats(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_stats(self, line, self.host)

    def do_analytics_cs_check(self, line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_cs_check(self, line, self.host)


    def do_analytics_rack(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_rack(self, line, self.host)

    def do_analytics_cs_template(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_cs_template(self, line, self.host)

    def do_analytics_op_details(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_get_op_details(self, line, self.host)

    def do_analytics_getpayload(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_analytics_getpayload(self, line, self.host)

    def do_analytics_info(self,line):
        ecraObj = Analytics(self.HTTP)
        ecraObj.do_analytics_info(self, line, self.host)

    # cache
    def do_cache_purge(self,line):
        cache = Cache(self.HTTP)
        cache.do_purge(self, line, self.host)

    # ingestion
    def do_ingestion_import(self,line):
        ingestion = Ingestion(self.HTTP)
        ingestion.do_ingestion_import(self, line, self.host)

    #exacompute
    def do_exacompute_ports(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_hostname_ports(self, line, self.host)

    def do_exacompute_getfleetstatelock(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getfleetstatelock(self, line, self.host)

    def do_exacompute_fleetstateunlock(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_fleetstateunlock(self, line, self.host)

    def do_exacompute_getfleetstate(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getfleetstate(self, line, self.host)

    def do_exacompute_getfleetstateid(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getfleetstateid(self, line, self.host)

    def do_exacompute_getlatestfleet(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getlatestfleet(self, line, self.host)

    def do_exacompute_updatefleetstate(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatefleetstate(self, line, self.host)

    def do_exacompute_add_cluster(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_add_cluster(self, line, self.host)

    def do_exacompute_add_cluster_precheck(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_add_cluster_precheck(self, line, self.host)

    def do_exacompute_precheck(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_precheck(self, line, self.host)

    def do_exacompute_delete_cluster(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_delete_cluster(self, line, self.host)

    def do_exacompute_list_cluster(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_list_cluster(self, line, self.host)

    def do_exacompute_active_card(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_active_card(self, line, self.host)

    def do_exacompute_vm(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_vm(self, line, self.host)

    def do_exacompute_createmdcontext(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_createmdcontext(self, line, self.host)

    def do_exacompute_deletemdcontext(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_deletemdcontext(self, line, self.host)

    def do_exacompute_updatemdcontext(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatemdcontext(self, line, self.host)

    def do_exacompute_getmdcontext(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getmdcontext(self, line, self.host)

    def do_exacompute_createmaintenancedomain(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_createmaintenancedomain(self, line, self.host)

    def do_exacompute_deletemaintenancedomain(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_deletemaintenancedomain(self, line, self.host)

    def do_exacompute_updatemaintenancedomain(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatemaintenancedomain(self, line, self.host)

    def do_exacompute_getmdnodes(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getmdnodes(self, line, self.host)

    def do_exacompute_updatenodemdmapping(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatenodemdmapping(self, line, self.host)

    def do_exacompute_computedetail(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_computedetail(self, line, self.host)

    def do_exacompute_getmaintenancedomain(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getmaintenancedomain(self, line, self.host)

    def do_exacompute_listmaintenancedomain(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_listmaintenancedomain(self, line, self.host)

    def do_exacompute_reshapecluster(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_reshapecluster(self, line, self.host)

    def do_exacompute_reshapecluster_precheck(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_reshapecluster_precheck(self, line, self.host)

    def do_exacompute_initiator(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_initiator(self, line, self.host)

    def do_exacompute_updateocid(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updateocid(self, line, self.host)

    def do_exacompute_gettemplate(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_gettemplate(self, line, self.host)

    def do_exacompute_postvolumes(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_postvolumes(self, line, self.host)

    def do_exacompute_getvolumes(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getvolumes(self, line, self.host)

    def do_exacompute_validatevolumes(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_validatevolumes(self, line, self.host)

    def do_exacompute_generatesshkeys(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_generatesshkeys(self, line, self.host)

    def do_exacompute_getpublickey(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getpublickey(self, line, self.host)

    def do_exacompute_getvaultaccess(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getvaultaccess(self, line, self.host)

    def do_exacompute_updatevaultaccessdetails(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatevaultaccessdetails(self, line, self.host)

    def do_exacompute_deletevaultaccessdetails(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_deletevaultaccessdetails(self, line, self.host)

    def do_exacompute_precheckedvvolumes(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_precheckedvvolumes(self, line, self.host)

    def do_exacompute_snapshotmount(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_snapshotmount(self, line, self.host)

    def do_exacompute_snapshotunmount(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_snapshotunmount(self, line, self.host)

    def do_exacompute_listsystemvault(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_listsystemvault(self, line, self.host)

    def do_exacompute_updatesystemvault(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatesystemvault(self, line, self.host)

    def do_exacompute_deletesystemvault(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_deletesystemvault(self, line, self.host)

    def do_exacompute_createsystemvault(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_createsystemvault(self, line, self.host)

    def do_exacompute_getnathostnames(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getnathostnames(self, line, self.host)

    def do_exacompute_updatefleetnode(self, line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatefleetnode(self, line, self.host)

    def do_exacompute_clusterdetail(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_clusterdetail(self, line, self.host)

    def do_exacompute_securevms(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_securevms(self, line, self.host)

    def do_exacompute_removenodexml(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_removenodexml(self, line, self.host)

    def do_exacompute_configureroceips(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_configureroceips(self, line, self.host)

    def do_exacompute_deconfigureroceips(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_deconfigureroceips(self, line, self.host)

    def do_exacompute_nodedetail(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_nodedetail(self, line, self.host)

    def do_exacompute_computecleanup(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_computecleanup(self, line, self.host)

    def do_exacompute_dbvolumes(self,line):
            ecraObj = Exacompute(self.HTTP)
            ecraObj.do_exacompute_dbvolumes_operation(self, line, self.host)

    def do_exacompute_clusterhistory(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_clusterhistory(self, line, self.host)

    def do_exacompute_cleanup_request(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_cleanup_request(self, line, self.host)

    def do_exacompute_updatefabricfleet(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_updatefabricfleet(self, line, self.host)

    def do_exacompute_runsanitycheck(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_sanity_check(self, line, self.host)

    def do_exacompute_getdomus(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getdomus(self, line, self.host)

    def do_exacompute_getvmclusterdetails(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_getvmclusterdetails(self, line, self.host)

    def do_exacompute_rackreserve(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_rackreserve(self, line, self.host)

    def do_exacompute_guestreserve(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_guestreserve(self, line, self.host)

    def do_exacompute_guestrelease(self,line):
        ecraObj = Exacompute(self.HTTP)
        ecraObj.do_exacompute_guestrelease(self, line, self.host)

    # errorcode
    def do_errorcode_get(self,line):
        ecraObj = Errorcode(self.HTTP)
        ecraObj.do_get(self, line, self.host)

    def do_errorcode_category(self,line):
        ecraObj = Errorcode(self.HTTP)
        ecraObj.do_category(self, line, self.host)

    def do_errorcode_endpoint(self,line):
        ecraObj = Errorcode(self.HTTP)
        ecraObj.do_endpoint(self, line, self.host)

    # query requests with options as query params
    def do_query_requests(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_query_requests(self, line, self.host)

    # abort a request operation
    def do_abort_request(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_abort_request(self, line, self.host)

    # query requests with options
    def do_requests_info(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_requests_info(self, line, self.host)

    # abort async call
    def do_abort_async(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_abort_async(self, line, self.host)

    # list async calls
    def do_list_async(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_list_async(self, line, self.host)

    #update request status
    def do_update_request(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_update_request(self, line, self.host)

    #get request data
    def do_request_get(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_request_get(self, line, self.host)

    # add registry record
    def do_addregistry(self, line):
        queryObj = Queryreq(self.HTTP)
        queryObj.do_addregistry(self, line, self.host)

    # create db on given exaunit
    def do_create_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_create_db(self, line, mytmpldir, interactive)

    # recreate db on given exaunit
    def do_recreate_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_recreate_db(self, line,interactive)

    # create starter db on given exaunit using the old endpoint
    def do_create_starter_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_create_starter_db(self, line, mytmpldir, interactive)

    # register additional databases created through SM instead of ecra
    # this will only register the db record in ecra but will not actually create any database on rack
    def do_register_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_register_db(self, line, interactive)

    #Deregister additional database created outside cloud automation, this DO NOT delete the database on the rack.
    def do_deregister_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_deregister_db(self, line, interactive)

    #Get registered info from ECRA, not going to the rack
    def do_registered_info_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_registered_info_db(self, line, interactive)

    def do_info_all_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_info_all_db(self, line, interactive)

    def do_info_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_info_db(self, line, interactive)

    def do_delete_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_delete_db(self, line, interactive)

    def do_rollback_starter_db(self, line):
        databaseObj = Database(self.HTTP, self.host)
        databaseObj.do_rollback_starter_db(self, line, interactive)

    def do_start_vm(self, line):
        self.vm_operation("start", line)

    def do_stop_vm(self, line):
        self.vm_operation("stop", line)

    def do_restart_vm(self, line):
        self.vm_operation("restart", line)

    def do_status_vm(self, line):
        vm = Vm(self.HTTP)
        vm.do_status_vm(self, line, self.host)

    def do_relation_vm(self, line):
        vm = Vm(self.HTTP)
        vm.do_relation_vm(self, line, self.host)

    def do_cpssw_upgrade(self, line):
        cpsPatchObj = CPSSWUpgrade(self.HTTP)
        cpsPatchObj.do_cpssw_patch(self, line, self.host)

    def do_cps_tar_upload(self, line):
        cpsPatchTarObj = CPSUpgrade(self.HTTP)
        cpsPatchTarObj.do_cps_tar_upload(self, line, self.host)

    def do_infrapassword_rotate(self, line):
        infraPasswordObj = InfraPassword(self.HTTP)
        infraPasswordObj.do_infrapassword_rotate(self, line, self.host)

    def do_infrapassword_get(self, line):
        infraPasswordObj = InfraPassword(self.HTTP)
        infraPasswordObj.do_infrapassword_get(self, line, self.host)

    def do_passwordmanagement_rotate(self, line):
        passwordObj = PasswordManagement(self.HTTP)
        passwordObj.do_passwordmanagement_rotate(self, line, self.host, mydir)

    def do_passwordmanagement_change(self, line):
        passwordObj = PasswordManagement(self.HTTP)
        passwordObj.do_passwordmanagement_change(self, line, self.host, mydir)

    def do_passwordmanagement_listuser(self, line):
        passwordObj = PasswordManagement(self.HTTP)
        passwordObj.do_passwordmanagement_listuser(self, line, self.host)

    def do_passwordmanagement_getsiv(self, line):
        passwordObj = PasswordManagement(self.HTTP)
        passwordObj.do_passwordmanagement_getsiv(self, line, self.host)

    def do_passwordmanagement_seedsiv(self, line):
        passwordObj = PasswordManagement(self.HTTP)
        passwordObj.do_passwordmanagement_seedsiv(self, line, self.host)

    def do_passwordmanagement_updatesivinfo(self, line):
        passwordObj = PasswordManagement(self.HTTP)
        passwordObj.do_passwordmanagement_updatesivinfo(self, line, self.host)

    def do_passwordmanagement_validatepassword(self, line):
        passwordObj = PasswordManagement(self.HTTP)
        passwordObj.do_passwordmanagement_validatepassword(self, line, self.host)

    # perform vm start/stop/restart
    def vm_operation(self, action, line):
        vmObj = Vm(self.HTTP)
        vmObj.vm_operation(self, action, line, self.host)

    def do_get_ssh_info(self, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.do_get_ssh_info(self, line, self.host)

    def do_add_sshkey(self, line):
        self.sshkey_operation("addkey", line)

    def do_reset_sshkey(self, line):
        self.sshkey_operation("resetkey", line)

    def do_rescue_sshkey(self, line):
        self.sshkey_operation("rescuekey", line)

    def do_delete_sshkey(self, line):
        self.sshkey_operation("deletekey", line)

    def sshkey_operation(self, action, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.sshkey_operation(self, action, line, self.host)

    def do_createpublic_sshkey(self, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.do_create_public_key(self, line, self.host)

    def do_verifypublic_sshkey(self, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.do_verify_public_key(self, line, self.host)

    def do_deletepublic_sshkey(self, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.do_delete_public_key(self, line, self.host)

    def do_getpublic_sshkey(self, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.do_get_public_key(self, line, self.host)

    def do_addadbskey_sshkey(self, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.do_add_adbs_key(self, line, self.host)

    def do_removeadbskey_sshkey(self, line):
        sshObj = Sshkey(self.HTTP)
        sshObj.do_remove_adbs_key(self, line, self.host)

    def do_update_cores(self, line):
        coreObj = Cores(self.HTTP)
        coreObj.do_update_cores(self, line, self.host, mytmpldir)

    def do_register_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_register_rack(self, line)

    def do_deregister_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_deregister_rack(self, line, self.host)

    def do_update_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_update_rack(self, line, self.host)

    def do_get_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_get_rack(self, line, self.host)

    def do_exaid_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_exaid_rack(self, line, self.host)

    def do_reserve_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_reserve_rack(self, line, self.host)

    def do_compose_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_compose_rack(self, line, self.host)

    def do_release_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_release_rack(self, line, self.host)

    def do_drop_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_drop_rack(self, line, self.host)

    def do_fetchatp_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_fetchatp_rack(self, line, self.host)

    def do_getxml_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_getxml_rack(self, line, self.host)

    def do_unlock_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_unlock_rack(self, line, self.host)

    def do_ports_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_ports_rack(self, line, self.host)

    def do_nodes_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_nodes_rack(self, line, self.host)

    def do_update_selinux_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_update_selinux_rack(self, line, self.host)

    def do_list_selinux_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_list_selinux_rack(self, line, self.host)

    def do_update_custom_selinux_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_update_custom_selinux_rack(self, line, self.host)

    def do_rack_xml_patch(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_rack_xml_patch(self, line, self.host)

    def do_get_xml_info(self, line):
        ecraObj = Rack(self.HTTP)
        ecraObj.do_get_xml_info(self, line, self.host)

    def do_validate_xml(self, line):
        ecraObj = Rack(self.HTTP)
        ecraObj.do_validate_xml(self, line, self.host)

    def do_rack_xml_patchnodes(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_rack_xml_patchnodes(self, line, self.host)

    def do_update_xml(self, line):
        ecraObj = Rack(self.HTTP)
        ecraObj.do_update_xml(self, line, self.host)

    def do_run_sanitycheck_rack(self, line):
        rackObj = Rack(self.HTTP)
        rackObj.do_run_sanitycheck_rack(self, line, self.host)

    def do_acfs_operations(self, line):
        ecraObj = Exaunit(self.HTTP)
        ecraObj.do_acfs_operations(self, line, self.host)

    def do_idemtoken_new(self, line):
        idemObj = Idemtoken(self.HTTP)
        idemObj.do_idemtoken_new(self, line, self.host)

    def do_idemtoken_renew(self, line):
        idemObj = Idemtoken(self.HTTP)
        idemObj.do_idemtoken_renew(self, line, self.host)

    def do_add_zone(self, line):
        zoneObj = Zone(self.HTTP)
        zoneObj.do_add_zone(self, line, self.host, mytmpldir)

    def do_list_zone(self, line):
        zoneObj = Zone(self.HTTP)
        zoneObj.do_list_zone(self, line, self.host)

    def do_delete_zone(self, line):
        zoneObj = Zone(self.HTTP)
        zoneObj.do_delete_zone(self, line, self.host)

    def do_add_location(self, line):
        locationObj = Location(self.HTTP)
        locationObj.do_add_location(self, line, self.host, mytmpldir)

    def do_list_locations(self, line):
        locationObj = Location(self.HTTP)
        locationObj.do_list_locations(self, line, self.host)

    def do_delete_location(self, line):
        locationObj = Location(self.HTTP)
        locationObj.do_delete_location(self, line, self.host)

    def do_details_location(self, line):
        locationObj = Location(self.HTTP)
        locationObj.do_get_location_details(self, line, self.host)

    def do_fetch_network_info(self, line):
        exadataObj = Exadata(self.HTTP)
        exadataObj.do_fetch_network_info(self, line, self.host)

    def do_models_exadata(self, line):
        exadataObj = Exadata(self.HTTP)
        exadataObj.do_models(self, line, self.host)

    def do_syncrackslots(self, line):
            exaserviceObj = Exaservice(self.HTTP)
            exaserviceObj.do_syncrackslots(self, line, self.host)

    ## BEGIN : OCI Capacity/Pre-activation APIs
    # List the tenants in OCI
    def do_list_ocitenants(self, line):
        tenants_obj = Tenants(self.HTTP)
        tenants_obj.do_list_ocitenants(self, line, self.host)

    # List capacity of given tenant identified by Tenant OCID
    def do_list_capacity_ocitenants(self, line):
        tenants_obj = Tenants(self.HTTP)
        tenants_obj.do_list_capacity_ocitenants(self, line, self.host)

    def do_list_fleetcapacity_ocitenants(self, line):
        tenants_obj = Tenants(self.HTTP)
        tenants_obj.do_list_fleetcapacity_ocitenants(self, line, self.host)

    # Register capacity - Pre-activation aka ingestion of new Exadata
    def do_register_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_register_ocicapacity(self, line, self.host)

    # List details of a specific Exadata identified by ExaOcid
    def do_details_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_details_ocicapacity(self, line, self.host)

    # List natmap of a specific Exadata identified by ExaOcid and vmClusterOcid(optional)
    def do_get_domuhost_nat_mapping(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_get_domuhost_nat_mapping(self, line, self.host)
   
    # Ecra MetaData cleanup 
    def do_cleanup_ecra_meta_data(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_clean_ecra_meta_data(self, line, self.host)

    # Update specific attributes of the Exadata in Pre-Activation state with given ExaOCID
    def do_update_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_update_ocicapacity(self, line, self.host)

    # Delete the Exadata in Pre-Activation state with given ExaOCID
    def do_delete_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_delete_ocicapacity(self, line, self.host)

    # Reserve the Exadata in Pre-Activation state with given ExaOCID
    def do_reserve_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_reserve_ocicapacity(self, line, self.host)

    # Download the config bundle of the Exadata with given ExaOCID
    def do_get_exa_cfgbundle_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_get_exa_cfgbundle_ocicapacity(self, line, self.host)

    # List ecs patching for exadata and cps services version detail
    def do_list_ecspatchversion(self, line):
         patching_obj = ECSPatching(self.HTTP)
         patching_obj.do_list_ecspatchversion(self, line, self.host)

    # List ecs patching for exadata applied version detail
    def do_list_exadata_applied_version(self, line):
         exadata_patch_obj = ECSExadataVersion(self.HTTP)
         exadata_patch_obj.do_list_exadata_version(self, line, self.host)

    # Get the SHA-256 checksum of the config bundle for the Exadata with given ExaOCID
    def do_get_exa_cfgbundlecksum_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_get_exa_cfgbundlecksum_ocicapacity(self, line, self.host)

    # Get the private key for the bastion host to connect to OCPS of the Exadata with given ExaOCID
    def do_get_bastion_privkey_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_get_bastion_privkey_ocicapacity(self, line, self.host)

    # Get the Cipher pswd to decrypt the encrypted config bundle of the OCI Exadata with given ocid
    def do_get_exa_cfgbundlepasswd_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_get_exa_cfgbundlepasswd_ocicapacity(self, line, self.host)

    # Migrate existing SVM capacity to MVM
    def do_migrate_ocicapacity_to_mvm(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_migrate_ocicapacity_to_mvm(self, line, self.host)

    def do_migrate_ocicapacity_to_ns(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_migrate_ocicapacity_to_ns(self, line, self.host)

    def do_migrate_ocicapacity_to_ecell(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_migrate_ocicapacity_to_ecell(self, line, self.host)

    def do_migrate_ocicapacity_to_ecompute(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_migrate_ocicapacity_to_ecompute(self, line, self.host)


    # Migrate existing VPN capacity to WSS
    def do_migrate_ocicapacity_to_wss(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_migrate_ocicapacity_to_wss(self, line, self.host)

    # Release existing rack from a MVM capacity
    def do_release_ocicapacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_release_ocicapacity(self, line, self.host)

    #Activate new cells in an existing infra
    def do_activate_cell_servers(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_activate_cell_servers(self, line, self.host)

    #Attach new cells in an existing infra
    def do_attach_cell_servers(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_attach_cell_servers(self, line, self.host)

    #Attach new cells in an existing infra exascale or hybrid
    def do_attach_cell_servers_exascale(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_attach_cell_servers_exascale(self, line, self.host)

   #Migrate to elastic cell in an existing infra
    def do_migrate_to_elastic_cell(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_migrate_to_elastic_cell(self, line, self.host)

    def do_mark_cells_to_delete(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_mark_cells_to_delete(self, line, self.host)

    def do_update_asmss_for_infra(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_update_asmss_for_infra(self, line, self.host)

    def do_renerate_dbcs_wallets(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_regenerate_dbcs_wallets_infra(self, line, self.host)

    # update infra status
    def do_update_infrastatus(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_infra_status_update(self, line, self.host)

    def do_get_vpn_server_details_ocicpinfra(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_get_vpn_server_details_ocicpinfra(self, line, self.host)

    def do_save_vpn_server_details_ocicpinfra(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_save_vpn_server_details_ocicpinfra(self, line, self.host)

    def do_update_vpn_server_details_ocicpinfra(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_update_vpn_server_details_ocicpinfra(self, line, self.host)

    def do_rotate_cipher_passwd(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_rotate_cipher_passwd(self, line, self.host)

    def do_get_ecra_cipher_passwd(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_get_ecra_cipher_passwd(self, line, self.host)

    def do_get_ecra_all_cipher_passwds(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_get_ecra_all_cipher_passwds(self, line, self.host)

    def do_add_new_vpn_he_record(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_add_new_vpn_he_record(self, line, self.host)

    def do_update_vpn_he_record(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_update_vpn_he_record(self, line, self.host)

    def do_get_vpn_he_details(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_get_vpn_he_details(self, line, self.host)

    def do_get_vpn_he_list(self, line):
        ocicpinfra_obj = Ocicpinfra(self.HTTP)
        ocicpinfra_obj.do_get_vpn_he_list(self, line, self.host)

    def do_activates_computes(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_activate_computes(self, line, self.host)

    def do_restore_allocations(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_restore_allocations(self, line, self.host)

    def do_fix_xml_action_tag(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_fix_xml_action_tag(self, line, self.host)

    def do_release_infra(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_release_infra(self, line, self.host)

    def do_undo_exascale_configuration(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_undo_exascale_configuration(self, line, self.host)

    def do_configure_exascale(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_configure_exascale(self, line, self.host)

    def do_reserve_infra(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_reserve_infra(self, line, self.host)

    ## END : OCI Capacity/Pre-activation APIs

    def do_capacity_compatibility_addmatrix(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_compatibility_addmatrix(self, line, self.host)

    def do_capacity_compatibility_updatematrix(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_compatibility_updatematrix(self, line, self.host)

    def do_capacity_compatibility_disablematrix(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_compatibility_disablematrix(self, line, self.host)

    def do_capacity_compatibility_enablematrix(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_compatibility_enablematrix(self, line, self.host)

    def do_capacity_compatibility_addexclusion(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_compatibility_addexclusion(self, line, self.host)

    def do_capacity_compatibility_list(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_compatibility_list(self, line, self.host)

    def do_capacity_gioperation(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_gioperation(self, line, self.host)

    def do_register_capacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_register_capacity(self, line, self.host)

    def do_capacity_compatibility_catalog(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_capacity_compatibility_catalog(self, line, self.host)

    def do_register_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_register_inventory(self, line, self.host)

    def do_deregister_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_deregister_inventory(self, line, self.host)

    def do_update_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_update_inventory(self, line, self.host)

    def do_update_hwnode(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_update_hwnode(self, line, self.host)

    def do_get_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_get_inventory(self, line, self.host)

    def do_get_hardware_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_get_inventory_hardware(self, line, self.host)

    def do_reviewcapacity_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_reviewcapacity_inventory(self, line, self.host)

    def do_getexcludelist_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_getexcludelist_inventory(self, line, self.host)

    def do_node_detail(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_node_detail(self, line, self.host)

    def do_update_node_detail(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_update_node_detail(self, line, self.host)

    def do_reset_cavium(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_reset_cavium(self, line, self.host)

    def do_cavium_collect_diag(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_cavium_collect_diag(self, line, self.host)

    def do_cavium_diag_response(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_cavium_diag_response(self, line, self.host)

    def do_reserve_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_reserve_inventory(self, line, self.host)

    def do_release_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_release_inventory(self, line, self.host)

    def do_check_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_check_inventory(self, line, self.host)

    def do_updatenodes_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_updatenodes_inventory(self, line, self.host)

    def do_resetvlan_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_reset_cell_vlan(self, line, self.host)

    def do_startblackout_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_startblackout_inventory(self, line, self.host)

    def do_endblackout_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_endblackout_inventory(self, line, self.host)

    def do_getspec_inventory(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_getspec_inventory(self, line, self.host)

    def do_get_inventory_summary(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_get_inventory_summary(self, line, self.host)

    def do_update_status_comment(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_update_status_comment(self, line, self.host)

    def do_get_status_comment(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_get_status_comment(self, line, self.host)

    def do_reset_ilom_default_password(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_reset_ilom_default_password(self, line, self.host)

    def do_reset_ilom_vault_password(self, line):
        inventory_obj = Inventory(self.HTTP)
        inventory_obj.do_reset_ilom_vault_password(self, line, self.host)

    def do_delete_formation(self, line):
        formation_obj = Formation(self.HTTP)
        formation_obj.do_formation_delete(self, line, self.host)

    def do_list_formation(self, line):
        formation_obj = Formation(self.HTTP)
        formation_obj.do_formation_list(self, line, self.host)

    def do_preprov_delete_rack_resources(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_preprov_delete_rack_resources(self, line, self.host)

    def do_preprov_capacitymove(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_preprov_capacitymove(self, line, self.host)

    def do_preprov_scheduler_start(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_scheduler_start(self, line, self.host)

    def do_preprov_scheduler_stop(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_scheduler_stop(self, line, self.host)

    def do_preprov_scheduler_list(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_scheduler_list(self, line, self.host)

    def do_preprov_jobs_get(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_get_jobs(self, line, self.host)

    def do_preprov_jobs_update(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_update_job(self, line, self.host)

    def do_preprov_vcn_get(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_get_vcn(self, line, self.host)

    def do_preprov_subnet_get(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_get_subnet(self, line, self.host)

    def do_preprov_vnics_get(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_get_vnics(self, line, self.host)

    def do_preprov_fleet_get(self, line):
        preprov_obj = Preprovision(self.HTTP)
        preprov_obj.do_fleet_get(self, line, self.host)

    def do_create_compute_instance(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_create_compute_instance(self, line, self.host)

    def do_delete_compute_instance(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_delete_compute_instance(self, line, self.host)

    def do_get_compute_instance(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_get_compute_instance(self, line, self.host)

    def do_create_oci_vnic(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_create_oci_vnic(self, line, self.host)

    def do_get_oci_vnic(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_get_oci_vnic(self, line, self.host)

    def do_delete_oci_vnic(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_delete_oci_vnic(self, line, self.host)

    def do_attach_oci_vnic(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_attach_oci_vnic(self, line, self.host)

    def do_detach_oci_vnic(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_detach_oci_vnic(self, line, self.host)

    def do_create_floatingip(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_create_floatingip(self, line, self.host)

    def do_get_floatingip(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_get_floatingip(self, line, self.host)

    def do_map_floatingip(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_map_floatingip(self, line, self.host)

    def do_unmap_floatingip(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_unmap_floatingip(self, line, self.host)

    def do_update_floatingip(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_update_floatingip(self, line, self.host)

    def do_delete_floatingip(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_delete_floatingip(self, line, self.host)

    def do_list_vnics(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_list_vnics(self, line, self.host)

    def do_list_ips(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_list_ips(self, line, self.host)

    def do_configure_dns(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_configuredns(self, line, self.host)

    def do_delete_dns(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_delete_dns(self, line, self.host)

    def do_get_dns(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_get_dns(self, line, self.host)

    def do_connectivity_check(self, line):
        oci_obj = Oci(self.HTTP)
        oci_obj.do_conectivity_check(self, line, self.host)

    def do_deregister_capacity(self, line):
        capacity_obj = Capacity(self.HTTP)
        capacity_obj.do_deregister_capacity(self, line, self.host)

    def do_reserve_capacity(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_reserve_capacity(self, line, self.host)

    def do_release_capacity(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_release_capacity(self, line, self.host)

    def do_list_capacity(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_list_capacity(self, line, self.host)

    def do_get_capacity(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_get_capacity(self, line, self.host)

    def do_move_capacity(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_move_capacity(self, line, self.host)

    def do_enable_vm_console (self, line):
        vmConsoleObj = VMConsole(self.HTTP)
        vmConsoleObj.do_enable_vm_console(self, line, self.host)

    def do_infrav2_backfill(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_infrav2_backfill(self, line, self.host)

    def do_capacity_getavailability(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_capacity_getavailability(self, line, self.host)

    def do_capacity_getfilesystemdefinitions(self, line):
        capacityObj = Capacity(self.HTTP)
        capacityObj.do_capacity_getfilesystemdefinitions(self, line, self.host)

    def do_list_rackslot(self, line):
        rackSlotObj = RackSlot(self.HTTP)
        rackSlotObj.do_list_rackslot(self, line, self.host)

    def do_get_rackslot(self, line):
        rackSlotObj = RackSlot(self.HTTP)
        rackSlotObj.do_get_rackslot(self, line, self.host)

    def do_register_rackslot(self, line):
        rackSlotObj = RackSlot(self.HTTP)
        rackSlotObj.do_register_rackslot(self, line, self.host)

    def do_deregister_rackslot(self, line):
        rackSlotObj = RackSlot(self.HTTP)
        rackSlotObj.do_deregister_rackslot(self, line, self.host)

    def do_get_dblist(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_dblist(self, line, self.host)

    def do_get_flashsize(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_flashsize(self, line, self.host)

    def do_get_obj(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_obj(self, line, self.host)

    def do_set_obj(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_set_obj(self, line, self.host, mytmpldir)

    def do_set_obj_v2(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_set_obj_v2(self, line, self.host, mytmpldir)

    def do_get_dbplan(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_dbplan(self, line, self.host)

    def do_set_dbplan(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_set_dbplan(self, line, self.host, mytmpldir)

    def do_set_dbplan_v2(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_set_dbplan_v2(self, line, self.host, mytmpldir)

    def do_reset_dbplan(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_reset_dbplan(self, line, self.host)

    def do_reset_dbplan_v2(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_reset_dbplan_v2(self, line, self.host)

    def do_get_clientkeys(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_clientkeys(self, line, self.host)

    def do_get_pmemsize(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_pmemsize(self, line, self.host)

    def do_get_resources_iorm(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_resources(self, line, self.host)

    def do_get_clusterplan(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_get_clusterplan(self, line, self.host)

    def do_set_clusterplan(self, line):
        iormObj = Iorm(self.HTTP)
        iormObj.do_set_clusterplan(self, line, self.host, mytmpldir)

    def do_ecra_health_check(self, line):
        ecraHealthObj = Ecra(self.HTTP)
        ecraHealthObj.do_ecra_health_check(self, line, self.host)

    def do_health_check(self, line):
        healthObj = Healthcheck(self.HTTP)
        healthObj.do_health_check(self, line, self.host, mytmpldir)

    def do_create_tm(self, line, snap=False, warning=True):
        cloneObj = Clone(self.HTTP)
        cloneObj.do_create_tm(self, line, self.host, mytmpldir, snap, warning)

    def do_create_snap(self, line, warning=True):
        return self.do_create_tm(line, True, warning)

    def do_enable_ebtables(self, line):
        ebtablesObj = Ebtables(self.HTTP)
        ebtablesObj.do_enable_ebtables(self, line, self.host)

    def do_disable_ebtables(self, line):
        ebtablesObj = Ebtables(self.HTTP)
        ebtablesObj.do_disable_ebtables(self, line, self.host)

    def do_add_ebtrules(self, line):
        ebtablesObj = Ebtables(self.HTTP)
        ebtablesObj.do_add_ebtrules(self, line, self.host)

    def do_del_ebtrules(self, line):
        ebtablesObj = Ebtables(self.HTTP)
        ebtablesObj.do_del_ebtrules(self, line, self.host)

    def do_runcns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_runcns(line)

    def do_postcns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_postcns(self, line)

    def do_setupcns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_setupcns(line)

    def do_setupcnsinterval(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_setupcnsinterval(line)

    def do_enablecns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_enablecns(line)

    def do_disablecns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_disablecns(line)

    def do_enablerackcns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_enablerackcns(line)

    def do_disablerackcns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_disablerackcns(line)

    def do_getrackstatuscns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_getrackstatuscns(line)

    def do_receivecns(self, line):
        cnsObj = CNS(self.HTTP, self.host)
        cnsObj.do_receivecns(line)

    def do_add_schedule(self, line):
        scheduleObj = Schedule(self.HTTP, self.host)
        scheduleObj.do_add_schedule(line)

    def do_delete_schedule(self, line):
        scheduleObj = Schedule(self.HTTP, self.host)
        scheduleObj.do_delete_schedule(line)

    def do_list_schedule(self, line):
        scheduleObj = Schedule(self.HTTP, self.host)
        scheduleObj.do_list_schedule(line)

    def do_update_schedule(self, line):
        scheduleObj = Schedule(self.HTTP, self.host)
        scheduleObj.do_update_schedule(self, line)

    def do_rsyslog_get_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_rsyslog_get_diagnosis(self, line)

    def do_rsyslog_set_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_rsyslog_set_diagnosis(self, line)

    def do_logcol_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_logcol_diagnosis(self, line)

    def do_add_pre_logcol_rack_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_add_pre_logcol_rack_diagnosis(self, line)

    def do_list_pre_logcol_rack_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_list_pre_logcol_rack_diagnosis(self, line)

    def do_delete_pre_logcol_rack_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_delete_pre_logcol_rack_diagnosis(self, line)

    def do_plgmon_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_plgmon_diagnosis(self, line)

    def do_add_ignore_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_add_ignore_diagnosis(self, line)

    def do_list_ignore_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_list_ignore_diagnosis(self, line)

    def do_delete_ignore_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_delete_ignore_diagnosis(self, line)

    def do_show_active_db_conn_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_show_active_db_conn_diagnosis(self, line)

    def do_db_conn_stacktrace_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_db_conn_stacktrace_diagnosis(self, line)

    def do_logsearch_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_logsearch_diagnosis(self, line)

    def do_rackhealth_run_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_rackhealth_run_diagnosis(self, line)

    def do_rackhealth_result_diagnosis(self, line):
        diagnosisObj = Diagnosis(self.HTTP, self.host)
        diagnosisObj.do_rackhealth_result_diagnosis(self, line)

    def do_enable_jumbo(self, line):
        jumboObj = Jumbo(self.HTTP)
        jumboObj.do_enable_jumbo(self, line, self.host)

    def do_disable_jumbo(self, line):
        jumboObj = Jumbo(self.HTTP)
        jumboObj.do_disable_jumbo(self, line, self.host)

    def do_query_jumbo(self, line):
        jumboObj = Jumbo(self.HTTP)
        jumboObj.do_query_jumbo(self, line, self.host)

    def do_enable_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_enable(self, line, self.host)

    def do_disable_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_disable(self, line, self.host)

    def do_set_param_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_set_param(self, line, self.host)

    def do_get_param_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_get_param(self, line, self.host)

    def do_install_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_install(self, line, self.host)

    def do_backup_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_backup(self, line, self.host)

    def do_status_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_status(self, line, self.host)

    def do_rollback_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_rollback(self, line, self.host)

    def do_schedulerstatus_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_get_schedulestatus(self, line, self.host)

    def do_setnextrun_scheduler_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_setnextrun_scheduler(self, line, self.host)

    def do_setfrequency_scheduler_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_setfrequency_scheduler(self, line, self.host)

    def do_schedulerhistory_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_get_scheduler_history(self, line, self.host)

    def do_patch_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_patch(self, line, self.host)

    def do_list_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_list(self, line, self.host)

    def do_osslist_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_osslist(self, line, self.host)

    def do_ossrestore_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_ossrestore(self, line, self.host)

    def do_localrestore_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_localrestore(self, line, self.host)

    def do_restorepath_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_restorepath(self, line, self.host)

    def do_suconfig_vmbackup(self, line):
        vmbackupObj = VMBackup(self.HTTP)
        vmbackupObj.do_suconfig(self, line, self.host)

    def do_configurecronjob_vmbackup(self, line):
    	vmbackupObj = VMBackup(self.HTTP)
    	vmbackupObj.do_configurecronjob_vmbackup(self, line, self.host)

    def do_multiop_details(self, line):
        complexOpObj = ComplexOperation(self.HTTP)
        complexOpObj.do_details(self, line, self.host)

    def do_multiop_recover(self, line):
        complexOpObj = ComplexOperation(self.HTTP)
        complexOpObj.do_recover(self, line, self.host)

    def do_multiop_update_step(self, line):
        complexOpObj = ComplexOperation(self.HTTP)
        complexOpObj.do_update_step(self, line, self.host)

    def do_properties_hardware(self, line):
        hardwareObj = Hardware(self.HTTP)
        hardwareObj.do_properties_hardware(self, line, self.host)

    def do_tenancyproperty_list(self, line):
        hardwareObj = Hardware(self.HTTP)
        hardwareObj.do_tenancyproperty_list(self, line, self.host)

    def do_tenancyproperty_put(self, line):
        hardwareObj = Hardware(self.HTTP)
        hardwareObj.do_tenancyproperty_put(self, line, self.host)

    def do_tenancyproperty_del(self, line):
        hardwareObj = Hardware(self.HTTP)
        hardwareObj.do_tenancyproperty_del(self, line, self.host)

    def do_configurefeaturetenancy_hardware(self,line):
        hardwareObj = Hardware(self.HTTP)
        hardwareObj.do_configurefeaturetenancy_hardware(self, line)

    def do_details_cluster(self, line):
        clusterObj = Cluster(self.HTTP)
        clusterObj.do_details_cluster(self, line, self.host)

    def do_list_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_list_cabinet(self, line, self.host)

    def do_ports_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_ports_cabinet(self, line, self.host)

    def do_update_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_update_cabinet(self, line, self.host)

    def do_getinfo_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_getinfo_cabinet(self, line, self.host)

    def do_updatexml_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_updatexml_cabinet(self, line, self.host)

    def do_getxml_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_getxml_cabinet(self, line, self.host)

    def do_composexml_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_composexml_cabinet(self, line, self.host)

    def do_softdeletenode_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_softdeletenode_cabinet(self, line, self.host)

    def do_getnodestatusreport_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_getnodestatusreport_cabinet(self, line, self.host)

    def do_getnodearchivedreason_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_getnodearchivedreason_cabinet(self, line, self.host)

    def do_updatenodearchivedreason_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_updatenodearchivedreason_cabinet(self, line, self.host)

    def do_getnodearchivedextrainfo_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_getnodearchivedextrainfo_cabinet(self, line, self.host)

    def do_updatenodearchivedextrainfo_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_updatenodearchivedextrainfo_cabinet(self, line, self.host)

    def do_getnodes_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_getnodes_cabinet(self, line, self.host)

    def do_recovernode_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_recovernode_cabinet(self, line, self.host)

    def do_purgenode_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_purgenode_cabinet(self, line, self.host)

    def do_model_subtype_convert(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_model_subtype_convert(self, line, self.host)

    def do_model_subtype_convert_large(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_model_subtype_convert_large(self, line, self.host)

    def do_model_subtype_convert_extralarge(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_model_subtype_convert_extralarge(self, line, self.host)

    def do_model_subtype_convert_standard(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_model_subtype_convert_standard(self, line, self.host)

    def do_get_domu_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_get_domu_cabinet(self, line, self.host)

    def do_update_domu_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_update_domu_cabinet(self, line, self.host)

    def do_ingestion_cabinet(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_ingestion_cabinet(self, line, self.host)

    def do_model_subtype_get_report(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_model_subtype_get_report(self, line, self.host)

    def do_model_subtype_release_nodes(self, line):
        cabinetObj = Cabinet(self.HTTP)
        cabinetObj.do_model_subtype_release_nodes(self, line, self.host)

    def do_getlog_exawatcher(self, line):
        exawatcherObj = Exawatcher(self.HTTP)
        exawatcherObj.do_getlog_exawatcher(self, line, self.host)

    def do_listlog_exawatcher(self, line):
        exawatcherObj = Exawatcher(self.HTTP)
        exawatcherObj.do_listlog_exawatcher(self, line, self.host)

    def do_create_user(self, line):
        usrconfigObj = UserConfig(self.HTTP)
        usrconfigObj.do_create_user(self, line, self.host)

    def do_alter_user(self, line):
        usrconfigObj = UserConfig(self.HTTP)
        usrconfigObj.do_alter_user(self, line, self.host)

    def do_grant_role(self, line):
        usrconfigObj = UserConfig(self.HTTP)
        usrconfigObj.do_grant_role(self, line, self.host)

    def do_list_user(self, line):
        usrconfigObj = UserConfig(self.HTTP)
        usrconfigObj.do_list_user(self, line, self.host)

    def do_delete_user(self, line):
        usrconfigObj = UserConfig(self.HTTP)
        usrconfigObj.do_delete_user(self, line, self.host)

    def do_delete_role(self, line):
        usrconfigObj = UserConfig(self.HTTP)
        usrconfigObj.do_delete_role(self, line, self.host)

    def do_createNetwork_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_createNetwork(self, line, self.host)

    def do_listNetworks_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_listNetworks(self, line, self.host)

    def do_updateNetwork_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_updateNetwork(self, line, self.host)

    def do_getNetwork_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_getNetwork(self, line, self.host)

    def do_deleteNetwork_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_deleteNetwork(self, line, self.host)

    def do_validateNetwork_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_validateNetwork(self, line, self.host)

    def do_nwValidationReport_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_getNwValidationReport(self, line, self.host)

    def do_wssIngestion_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_wssIngestion(self, line, self.host)

    def do_activate_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_activate(self, line, self.host)

    def do_certificateRotation_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_certificate_rotation(self, line, self.host)

    def do_secretServiceCompartment_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_secretservice_compartment(self, line, self.host)

    def do_secretServiceRotation_exacc(self, line):
        exacc = ExaCC(self.HTTP)
        exacc.do_secretservice_rotation(self, line, self.host)

    def do_compatibility_get(self, line):
        compatibilityObject = Compatibility(self.HTTP)
        compatibilityObject.do_compatibility_list(self, line, self.host)

    def do_compatibility_add(self, line):
        compatibilityObject = Compatibility(self.HTTP)
        compatibilityObject.do_compatibility_add(self, line, self.host)

    def do_compatibility_remove(self, line):
        compatibilityObject = Compatibility(self.HTTP)
        compatibilityObject.do_compatibility_remove(self, line, self.host)

    def do_compatibility_check(self, line):
        compatibilityObject = Compatibility(self.HTTP)
        compatibilityObject.do_compatibility_check(self, line, self.host)

    def do_compatibility_validoperations(self, line):
        compatibilityObject = Compatibility(self.HTTP)
        compatibilityObject.do_compatibility_validoperations(self, line, self.host)

    def do_remoteec(self, line):
        self.remoteEc.mExecute(line)

    def complete_remoteec(self, text, line, begid, endidx):
        return self.remoteEc.mComplete(line, text)

    def complete_create_service(self, text, line, begidx, endidx):
        return self.completeRackname(text, line)

    def complete_create_sdb(self, text, line, begidx, endidx):
        return self.completeRackname(text, line)

    def complete_test_createdelete(self, text, line, begidx, endidx):
        return self.completeRackname(text, line)

    def complete_register_rack(self, text, line, begidx, endidx):
        return self.completeRackname(text, line)

    def complete_update_rack(self, text, line, begidx, endidx):
        return self.completeRackname(text, line)

    def complete_create_db(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_create_starter_db(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_rollback_starter_db(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_get_exaunit(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_delete_service(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_recreate_service(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_delete_db(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_start_vm(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_stop_vm(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_restart_vm(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_add_sshkey(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_delete_sshkey(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_rescue_sshkey(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_update_cores(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_exaunit_cores(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_exaunit_resume(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_exaunit_suspend(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_exaunit_dbs(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_exaunit_info(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_exaunit_domukeys(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_drop_exaunit(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_register_db(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_properties_hardware(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_startObserver_atp(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_stopObserver_atp(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def complete_restartObserver_atp(self, text, line, begidx, endidx):
        return self.completeID(text, line)

    def completeID(self, text, line):
        if line.count(" ") > 1:
            return []
        if not text:
            completions = [str(i) for i in sorted(self.exaunits.keys())]
        else:
            completions = [str(i) for i in sorted(self.exaunits.keys()) if str(i).startswith(text)]

        return completions

    def completeRackname(self, text, line):
        if line.count(" ") > 1:
            return []
        if not text:
            completions = sorted(self.racks.keys())
        else:
            completions = [i for i in sorted(self.racks.keys()) if i.startswith(text)]
        return completions

    # get all hearbeats for all racks in ECRA
    def do_heartbeat_get(self, line):
        heartbeatObj = Heartbeat(self.HTTP, self.host)
        heartbeatObj.do_list_heartbeat(line)

    # get hearbeats for given racks in ECRA
    def do_heartbeat_exadata(self, line):
        heartbeatObj = Heartbeat(self.HTTP, self.host)
        heartbeatObj.do_list_heartbeat_exadata(self, line)

    # change heartbeat status for scheduler
    def do_heartbeat_enable_scheduler(self, line):
        heartbeatObj = Heartbeat(self.HTTP, self.host)
        heartbeatObj.do_heartbeat_enable_scheduler(self, line)

    def do_compliance_scan(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_scan(self, line)

    def do_compliance_default_scan(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_default_scan(self, line)

    def do_compliance_base_cfg(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_base_cfg(self, line)

    def do_compliance_cfg_status(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_cfg_status(self, line)

    def do_compliance_cfg_history(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_cfg_history(self, line)

    def do_compliance_report_oss_namespace(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_report_oss_namespace(self, line)

    def do_compliance_auto_revert(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_auto_revert(self, line)

    def do_compliance_status(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_status(self, line)

    def do_compliance_avfim(self, line):
        complianceObj = Compliance(self.HTTP, self.host)
        complianceObj.do_compliance_avfim(self, line)

    def do_get_xs_vault_details(self, line):
        exascaleVaultObj = ExascaleVault(self.HTTP)
        exascaleVaultObj.do_get_xs_vault_details(self, line, self.host)

    def do_EOF(self, line):
        print()
        return True

    def do_exit(self, line):
        return True

    def do_quit(self, line):
        return True

    def pull_exaunits(self):
        request_url = "{0}/exaunits".format(self.host)
        if (self.startup_options["mode"] == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
            request_url = "{0}?cimid={1}".format(request_url, self.startup_options["cimid"])
        response = self.HTTP.get(request_url)
        self.exaunits = {}
        self.rackToExaunit = {}
        self.ongoingOP = []

        if response and "exaunits" in response:
            for exaunit in response["exaunits"]:
                exaunit_id = exaunit.pop("exaunit_id", None)
                self.exaunits[exaunit_id] = exaunit
                if "rackname" in exaunit:
                    self.rackToExaunit[str(exaunit["rackname"])] = exaunit_id
        else:
            cl.perr("Failed to get list of created exaunits")

        if response and "ongoingOperations" in response:
            self.ongoingOP = response["ongoingOperations"]


    def getExaunitIDs(self):
        return sorted(self.exaunits.keys())

    def do_info(self, line):
        infoObj = Info(self.HTTP)
        infoObj.do_info(self, line)

    def do_list_params(self, line):
        print("params: ......")

    def cmdloop(self):
        try:
            cmd.Cmd.cmdloop(self)
        except KeyboardInterrupt as e:
            print()
            self.cmdloop()

    def help_ecralogs(self):
        print(""" ecralogs returns available internal logs for the target ecra instance to the given folder. """)
        print(""" Optionally a request Id can be especified to filter logs where it is included. Only available with -zip option""")
        print(""" ecralogs <target_path> [-zip] <requestId> """)

    def dict_lookup(self, dict, key, *keys):
        if keys:
            return self.dict_lookup(dict.get(key, {}), keys[0], *keys[1:])
        return dict.get(key)

    def validate_parameters(self, op, subop, params = None, strict = True):
        # Validate that all are valid parameters
        if params is not None:
            error_str = None
            # Handle possible parse_params error message.
            if type(params) is str:
                raise Exception(params)

            # Validate that all mandatory parameters are present and check if 3rd sub operation was given in a list of subops
            # the list should have at least 2 elements to avoid errors, if have more will be ignored
            if type(subop) is list and len(subop) > 1 :
                mandatory_params = list(self.valid_params[op][subop[0]][subop[1]]["mandatory"])
            else:
                mandatory_params = list(self.valid_params[op][subop]["mandatory"])

            for item in params:
                if item in mandatory_params:
                    mandatory_params.remove(item)

            if len(mandatory_params) > 0:
                error_str = "Please provide all mandatory parameters. Missing mandatory parameters are: " + str(mandatory_params)

            if strict:
                # Validate that there are no more parameters than expected.
                # Check the list of parameters in both the mandatory and optional list
                if type(subop) is list and len(subop) > 1:
                    merged_param_list = self.valid_params[op][subop[0]][subop[1]]["mandatory"] + self.valid_params[op][subop[0]][subop[1]]["optional"]
                else:
                    merged_param_list = self.valid_params[op][subop]["mandatory"] + self.valid_params[op][subop]["optional"]
                not_supported_params = []

                for item in params:
                    if item not in merged_param_list:
                        not_supported_params.append(item)

                if len(not_supported_params) > 0:
                    error_str_notexp = "Not supported parameter(s): " + str(not_supported_params) +". The available ones are: " + str(merged_param_list)

                    if error_str:
                        error_str = error_str + '\n' + error_str_notexp
                    else:
                        error_str = error_str_notexp

            if error_str:
                raise Exception(error_str)

        return

    def is_required_validation(self):
        ops_ecra_mode = self.issue_get_request("{0}/properties/{1}".format(self.HTTP.host, "ECRA_MODE"),False)
        ops_ecra_mode = ops_ecra_mode["property_value"]

        return ( ops_ecra_mode == "prod")

    def run_postdelete_validation(self):
        params = {'value' : 'DISABLED'}
        name = 'OPS_DELETE_OPERATIONS'
        data = json.dumps(params, sort_keys=True, indent=4)
        self.HTTP.put("{0}/properties/{1}".format(self.host,name), data, "ecsproperties")

    def run_postdelete_rackupdate(self, rackname):
        params = {'ops_delete_service' : 'N'}
        params["name"] = rackname
        data = json.dumps(params, sort_keys=True, indent=4)
        self.HTTP.put("{0}/racks".format(self.host), data, "racks")

    def stop_delete(self, confirmation_parameter, name_parameter):
        # Allow only valid users to do a delete in PROD mode
        valid_users = ["srguser", "ops"]
        if self.username not in valid_users:
            cl.prt("r", "Not a valid user for this operation")
            return True

        ops_ecra_delete = self.issue_get_request("{0}/properties/{1}".format(self.HTTP.host, "OPS_DELETE_OPERATIONS"),False)
        ops_ecra_delete = ops_ecra_delete["property_value"]

        if ops_ecra_delete != "ENABLED":
            cl.prt("r", "Delete operations has been disabled for ops in this ECRA")
            return True

        cl.prt("c","Are you sure you want to delete "+name_parameter+" ["+confirmation_parameter+"]? This action cannot be undone")
        confirmation = input("Type again "+confirmation_parameter+" in order to proceed with the delete command in opposite case just hit enter:")

        if confirmation == confirmation_parameter:
            self.run_postdelete_validation();
            return False

        return True

    def do_help(self, line):
        line = re.sub(' {2,}', ' ', line)

        if line.startswith("remoteec"):
            self.remoteEc.mProcessHelp(line)
            return

        #Special case for help patch cps
        if line.startswith("patch"):
            cpspatchline = line.split(' ', 1)
            cmd, firstarg = cpspatchline[0], cpspatchline[1] if len(cpspatchline) > 1 else None
            if firstarg and firstarg == "cps":
                Patch.cps_help()
                return
            elif firstarg and firstarg == "getDebugInfo":
                Patch.patch_debug_help()
                return
            elif firstarg and firstarg == "qfab":
                Patch.patch_qfab_help()
                return

        token_list = line.split(' ')
        if line:
            #Special case if all is typed
            if  token_list[0] == "all":
                #sort output for every command in json file
                tmpSort = json.dumps(self.sub_ops_help, sort_keys=True, indent=4)
                #order available commands
                ecraCmds = sorted (Ecracli.available_commands)
                for c in ecraCmds:
                    #check if command exists, if so print info
                    if c in self.sub_ops_help:
                        print("{0} <sub_operation> <args>".format(c))
                        tmpSort = json.dumps(self.sub_ops_help[c], sort_keys=True, indent=4)
                        print(tmpSort)
                        print("\n")
                return

            result = self.dict_lookup(self.sub_ops_help, *token_list)

            if result is None:
                print("Invalid command used")

            if isinstance(result, dict):
                print("{0} <sub_operation> <args>\n".format(' '.join(token_list)))
                #orders json portion and the returned to a dictionary objet saving key order
                result = json.dumps(result, sort_keys=True, indent=4)
                result = json.loads(result, object_pairs_hook=OrderedDict)
                for i in result:
                    # To avoid printing unicode prefix
                    if isinstance(result[i], list):
                        result[i] = "\n".join(result[i])
                    print(' '.join(token_list) + " " + "{0} {1}\n".format(i, result[i]))
            elif isinstance(result, str):
                print(' '.join(token_list) + " " + result)
            elif isinstance(result, list):
                for substring in result:
                    print(substring)
            return

        print("ECRACLI is a tool to simplify the use of ECRA utility for provisioning and lifecycle management of the exacloud database offering. It functions as a wrapper to communicate with the ECRA rest service endpoint. For more detailed information, please visit the ecracli wiki page https://stbeehive.oracle.com/teamcollab/wiki/Exadata+PaaS:ecracli")
        print("-------------------")
        print("Available commands:")
        Ecracli.available_commands.sort()
        for c in Ecracli.available_commands:
            print(' ' * 15 + '| ' + c)
        print("For help on a particular command, use [help <command>]")
        print("For help on a particular sub-command use [help <command> <sub-command>]")
        print("You can request help of all commands by typing [help all]")

    def display_subworks(self, resp):
        # currently only supported by patching
        if "op" not in list(resp.keys()) or "patch_list" not in list(resp.keys()):
            return

        if resp["patch_list"] == "Undef":
            return

        if resp["op"] == "PATCHING":
            # the exception might happend if exacloud does not return
            # a valid json, because patch_list is bypassed directly by
            try:
                works = ast.literal_eval(resp["patch_list"])

                print("\n")
                for subReq in works:
                    cl.prt("c","* subwork: {0}".format(subReq))
                    for item in works[subReq]:
                        cl.prt("c", "-> {0} {1}".format(item, works[subReq][item]))

            except Exception as e:
                logger.error(e)

    #work flow list retrieval
    def do_workflow_list(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_list(self, line, self.host)

    #work flow describe
    def do_workflow_describe(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_describe(self, line, self.host)

    #work flow restart janitor
    def do_wf_janitor_restart(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_wf_janitor_restart(self, line, self.host)

    def do_wf_exacloud_success(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_exacloud_task_success(self, line, self.host)

    def do_workflows_getinput(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_getinput(self, line, self.host)

    def do_workflows_updateinput(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_updateinput(self, line, self.host)

    #work flow task undo
    def do_workflow_undo(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_undo(self, line, self.host)

    #work flow task retry
    def do_workflow_retry(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_retry(self, line, self.host)

    #workflow task complete
    def do_workflow_complete_task(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_task_complete(self, line, self.host)

    #work flow abort
    def do_workflow_abort(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_abort(self, line, self.host)

    #work flow cancel task
    def do_workflow_cancel_task(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_cancel_task(self, line, self.host)

    #workflow fail task
    def do_workflows_fail_task(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflows_fail_task(self, line, self.host)

    #workflow fail task
    def do_workflows_pause(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflows_pause(self, line, self.host)

    #workflows reload
    def do_workflows_reload(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflows_reload(self, line, self.host)


    #work flow rollback mode on
    def do_workflow_rollback_mode_on(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_rollback_mode_on(self, line, self.host)

    #work flow rollback mode off
    def do_workflow_rollback_mode_off(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_rollback_mode_off(self, line, self.host)

    #work flow rollback
    def do_workflow_rollback(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_rollback(self, line, self.host)

    def do_workflow_operation(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_operation(self, line, self.host)

    #wf_server status
    def do_workflow_server_status(self, line):
         propObj = Workflows(self.HTTP)
         propObj.do_workflow_server_status(self, line, self.host)

    def do_opctl_create_user(self, line):
        propObj = Cca(self.HTTP)
        propObj.do_opctl_create_user(self, line, self.host)

    def do_opctl_delete_user(self, line):
        propObj = Cca(self.HTTP)
        propObj.do_opctl_delete_user(self, line, self.host)

    def do_opctl_assign(self, line):
        propObj = Cca(self.HTTP)
        propObj.do_opctl_assign(self, line, self.host)

    def do_exaversion_patchesreport(self, line):
        exaVersionObj = Exaversion(self.HTTP)
        exaVersionObj.do_get_patches_report(self, line, self.host)

    def do_sla_get_average_all(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_average_all(self, line)

    def do_sla_get_average(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_average(self, line)

    def do_sla_get_average_tenancy(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_average_tenancy(self, line)

    def do_sla_get_details(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_details(self, line)

    def do_sla_get_details_infra(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_details_infra(self, line)

    def do_sla_tenancy_turnon(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_tenancy_turnon(self, line)

    def do_sla_tenancy_turnoff(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_tenancy_turnoff(self, line)

    def do_sla_get_turnedon_tenancy(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_turnedon_tenancy(self, line)

    def do_sla_get_tenant_report(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_tenant_report(self, line)

    def do_sla_get_cei_report(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_cei_report(self, line)

    def do_sla_get_vm_report(self, line):
        slaObj = Sla(self.HTTP, self.host)
        slaObj.do_sla_get_vm_report(self, line)

    #agent
    def do_agent_request(self, line):
        agent = Agent(self.HTTP)
        agent.do_agent_request(self, line, self.host)

    def do_dataplane_settings(self, line):
        agent = Agent(self.HTTP)
        agent.do_dataplane_settings(self, line, self.host)

    def do_domu_get(self, line):
        domU = DomU(self.HTTP)
        domU.do_get_by_name(self, line, self.host)

    def do_domu_search(self, line):
        domU = DomU(self.HTTP)
        domU.do_search(self, line, self.host)

    def do_domu_deletebadhostname(self, line):
        domU = DomU(self.HTTP)
        domU.do_domu_deletebadhostname(self, line, self.host)

    def do_users_get_all(self, line):
        user = User(self.HTTP)
        user.do_get_all(self, line, self.host)

    def do_users_get(self, line):
        user = User(self.HTTP)
        user.do_get(self, line, self.host)

    def do_users_reset_password(self, line):
        user = User(self.HTTP)
        user.do_reset_password(self, line, self.host, mydir)

    def do_users_create(self, line):
        user = User(self.HTTP)
        user.do_create(self, line, self.host)

    def do_users_update(self, line):
        user = User(self.HTTP)
        user.do_update(self, line, self.host)

    def do_users_delete(self, line):
        user = User(self.HTTP)
        user.do_delete(self, line, self.host)

    def do_users_activate(self, line):
        user = User(self.HTTP)
        user.do_activate(self, line, self.host)

    def do_users_deactivate(self, line):
        user = User(self.HTTP)
        user.do_deactivate(self, line, self.host)

    def do_users_refresh_credentials(self, line):
        user = User(self.HTTP)
        user.do_refresh_credentials(self, line, self.host)

    def do_vmconsole_deployment(self, line):
        vmconsole = VMConsole(self.HTTP)
        vmconsole.do_vmconsole_deployment(self, line, self.host)
    def do_sop(self, line):
        return self.sub_op_do(line, 'sop')

    def do_sop_request(self, line):
        sop = Sop(self.HTTP)
        sop.do_sop_request(self, line, self.host)

    def do_sop_list(self, line):
        sop = Sop(self.HTTP)
        sop.do_sop_list(self, line, self.host)

    def do_sop_details(self, line):
        sop = Sop(self.HTTP)
        sop.do_sop_details(self, line, self.host)

    def do_sop_cancel(self, line):
        sop = Sop(self.HTTP)
        sop.do_sop_cancel(self, line, self.host)

    def do_sop_retry(self, line):
        sop = Sop(self.HTTP)
        sop.do_sop_retry(self, line, self.host)

    def do_topology_get_ad(self, line):
        topologyObj = Topology(self.HTTP, self.host)
        topologyObj.do_topology_get_topology_for_ad(self, line)

    def do_topology_get_network_switch_for_ad(self, line):
        topologyObj = Topology(self.HTTP, self.host)
        topologyObj.do_topology_get_network_switch_for_ad(self, line)

    def do_sitegroup_get(self, line):
         sitegroupObj = SiteGroup(self.HTTP)
         sitegroupObj.do_sitegroup_list(self, line)

    def do_sitegroup_add(self, line):
         sitegroupObj = SiteGroup(self.HTTP)
         sitegroupObj.do_sitegroup_add(self, line)

    def do_sitegroup_update(self, line):
         sitegroupObj = SiteGroup(self.HTTP)
         sitegroupObj.do_sitegroup_update(self, line)

    def do_sitegroup_updaterpm(self, line):
     sitegroupObj = SiteGroup(self.HTTP)
     sitegroupObj.do_sitegroup_updaterpm(self, line)

    def do_sitegroup_configurefeature(self, line):
         sitegroupObj = SiteGroup(self.HTTP)
         sitegroupObj.do_sitegroup_configurefeature(self, line)

    def do_artifact_deliver(self, line):
         artifact = Artifact(self.HTTP)
         artifact.do_deliver(self, line, self.host)

    def do_artifact_deliver_status(self, line):
        artifact= Artifact(self.HTTP)
        artifact.do_deliver_status(self, line, self.host)

    def do_fault_injection_infra_list(self, line):
        faultinjection = FaultInjection(self.HTTP)
        faultinjection.do_list_infra(self, line, self.host)

    def do_fault_injection_infra_add(self, line):
        faultinjection = FaultInjection(self.HTTP)
        faultinjection.do_add_infra(self, line, self.host)

    def do_fault_injection_infra_delete(self, line):
        faultinjection = FaultInjection(self.HTTP)
        faultinjection.do_delete_infra(self, line, self.host)

    def do_resource_blackout_get_latest(self, line):
        resourceblackout = ResourceBlackout(self.HTTP)
        resourceblackout.do_get_latest(self, line, self.host)

    def do_resource_blackout_get_history(self, line):
        resourceblackout = ResourceBlackout(self.HTTP)
        resourceblackout.do_get_history(self, line, self.host)

    def do_resource_blackout_get_enabled(self, line):
        resourceblackout = ResourceBlackout(self.HTTP)
        resourceblackout.do_get_enabled(self, line, self.host)

    def do_resource_blackout_create(self, line):
        resourceblackout = ResourceBlackout(self.HTTP)
        resourceblackout.do_create(self, line, self.host)

    def do_resource_blackout_update(self, line):
        resourceblackout = ResourceBlackout(self.HTTP)
        resourceblackout.do_update(self, line, self.host)

    def do_resource_blackout_refresh(self, line):
        resourceblackout = ResourceBlackout(self.HTTP)
        resourceblackout.do_refresh(self, line, self.host)

    def do_resource_blackout_disable(self, line):
        resourceblackout = ResourceBlackout(self.HTTP)
        resourceblackout.do_disable(self, line, self.host)

    def do_exascale_ersip_get(self, line):
        exascale = Exascale(self.HTTP)
        exascale.do_ersip_get(self, line, self.host)

    def do_exascale_ersip_register(self, line):
        exascale = Exascale(self.HTTP)
        exascale.do_ersip_register(self, line, self.host)

    def do_exascale_ersip_delete(self, line):
        exascale = Exascale(self.HTTP)
        exascale.do_ersip_delete(self, line, self.host)

def main():
    global interactive

    parser = OptionParser()
    parser.add_option("-a", "--rest-api", dest="host", help="url to rest api endpoint")
    parser.add_option("-c", "--config", dest="config", help="request config file")
    parser.add_option("-d", "--dbcs-json", dest="dbJson", help="dbcs json path")
    parser.add_option("-p", "--pod-json", dest="podJson", help="pod json path")
    parser.add_option("-u", "--user", dest="user",
        help="<username> or <username>:<password>. The second form can be used only for srguser")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", help="print details of each operation")
    ecracli_modes = list(ECRACLI_MODES.reverse_mapping().values())
    parser.add_option("-m", "--mode", dest="mode", help="ecracli mode, select from " + str(ecracli_modes),
        default=ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.default), choices=ecracli_modes)
    parser.add_option("-i", "--cimid", dest="cimid", help="CIM ID of a service instance")
    parser.add_option("--username", dest="username", default=None, \
        help="ECRA user name, this option should be used with 'password' option.")
    parser.add_option("--password", dest="password", default=None, \
        help="File to read ECRA user password.")

    (options, args) = parser.parse_args()

    if (options.mode == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
        if (options.cimid is None):
            cl.perr("For 'brokerproxy' mode, please provide CIM ID using --cimid (or -i) option")
            sys.exit(1)

    if not options.config:
        options.config = path.join(mydir, "ecracli.cfg")
    if not options.dbJson:
        options.dbJson = path.join(mytmpldir, "dbcs.json")
    if not options.podJson:
        options.podJson = path.join(mytmpldir, "pod.json")


    options_dict = vars(options)

    Ecracli(options_dict, args)

if __name__ == '__main__':
    main()
    #exit with proper code according to realized operations
    #this value should not be considered when executing non interactive mode
    #of ecracli since this is not handled by script and can no reflect (so far)
    #exit code for all executed operations
    sys.exit(ExitCode[0])


