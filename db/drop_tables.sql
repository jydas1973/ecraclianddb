Rem
Rem drop_tables.sql
Rem
Rem Copyright (c) 2017, 2020, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      drop_tables.sql - drop the ecra tables
Rem
Rem    DESCRIPTION
Rem      This file is created as part of the ECRA schema hardening effort.
Rem      For more details refer to :
Rem      https://confluence.oraclecorp.com/confluence/display/EDCS/ECRA+Schema+Hardening
Rem      https://confluence.oraclecorp.com/confluence/display/EDCS/ECRA+Schema+Upgrade
Rem      
Rem    NOTES
Rem      Only DROP TABLE, INDEX, SEQUENCE DDLs are allowed here in this file
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/drop_tables.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    josedelg    09/15/20 - ENH 31646088: Cleanup unused tables patches report
Rem    sdeekshi    01/07/20 - Bug 31564449: CLEANUP NON USEFUL XIMAGES CODE
Rem    llmartin    08/13/19 - Enh 30109293 - ATP deprecate
Rem                           ECS_ATPRACKSIZE_SUBNET table
Rem    hcheon      07/29/19 - bug-30024961 Add configuration manager
Rem    seha        07/23/19 - 30041007 Drop tables for asset endpoint protection
Rem    jreyesm     11/26/18 - Delete Elastic tables.
Rem    jungnlee    11/08/18 - Bug 28902534 a new sequence ecs_diag_report_id_seq
Rem    sdeekshi    06/08/18 - Bug 28189332 : Add ecra ximages image management api
Rem    brsudars    05/28/18 - node subset changes
Rem    byyang      01/06/18 - ER 27943223. Drop tables for ecs diag phase 2
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

PROMPT Dropping table ecs_exadata
drop table ecs_exadata  cascade constraints;
PROMPT Dropping table ecs_exadata_compute_node
drop table ecs_exadata_compute_node cascade constraints;
PROMPT Dropping table ecs_exaservice
drop table ecs_exaservice cascade constraints;
PROMPT Dropping table pods
drop table pods cascade constraints;
PROMPT Dropping table services
drop table services cascade constraints;
PROMPT Dropping table ecs_exadata_vcompute_node
drop table ecs_exadata_vcompute_node cascade constraints;
PROMPT Dropping table exaunit_info
drop table exaunit_info cascade constraints;
PROMPT Dropping table resources
drop table resources cascade constraints;
PROMPT Dropping table databases
drop table databases  cascade constraints;
PROMPT Dropping table ecs_dataguard
drop table ecs_dataguard  cascade constraints;
PROMPT Dropping table tenantinfo
drop table tenantinfo  cascade constraints;
PROMPT Dropping table exaunits
drop table exaunits  cascade constraints;
PROMPT Dropping table clusters
drop table clusters  cascade constraints;
PROMPT Dropping table vms
drop table vms  cascade constraints;
PROMPT Dropping table async_calls
drop table async_calls  cascade constraints;
PROMPT Dropping table sshkeys
drop table sshkeys  cascade constraints;
PROMPT Dropping table ecs_hardware
drop table ecs_hardware  cascade constraints;
PROMPT Dropping table ecs_cluster_shapes
drop table ecs_cluster_shapes  cascade constraints;
PROMPT Dropping table ecs_zones
drop table ecs_zones  cascade constraints;
PROMPT Dropping table ecs_racks
drop table ecs_racks  cascade constraints;
PROMPT Dropping table ecs_rack_slots
drop table ecs_rack_slots  cascade constraints;
PROMPT Dropping table ecs_idemtokens
drop table ecs_idemtokens  cascade constraints;
PROMPT Dropping table ecs_higgscookie
drop table ecs_higgscookie  cascade constraints;
PROMPT Dropping table ecs_higgsresources
drop table ecs_higgsresources  cascade constraints;
PROMPT Dropping table ecs_higgscloudip
drop table ecs_higgscloudip  cascade constraints;
PROMPT Dropping table ecs_higgspredeploy
drop table ecs_higgspredeploy  cascade constraints;
PROMPT Dropping table ecs_cores
drop table ecs_cores cascade constraints;
PROMPT Dropping table ecs_ords_info
drop table ecs_ords_info cascade constraints;
PROMPT Dropping table ecs_mdbcs_patching
drop table ecs_mdbcs_patching cascade constraints;
PROMPT Dropping table ecs_subscriptions
drop table ecs_subscriptions  cascade constraints;
PROMPT Dropping table ecs_purchasetypes
drop table ecs_purchasetypes cascade constraints;
PROMPT Dropping table ecra_files
drop table ecra_files  cascade constraints;
PROMPT Dropping table ecs_zonal_requests
drop table ecs_zonal_requests  cascade constraints;
PROMPT Dropping table ecs_requests
drop table ecs_requests  cascade constraints;
PROMPT Dropping table ecs_secgroups
drop table ecs_secgroups  cascade constraints;
PROMPT Dropping table ecs_secrules
drop table ecs_secrules  cascade constraints;
PROMPT Dropping table ecs_seccount
drop table ecs_seccount  cascade constraints;
PROMPT Dropping table ecs_exaunitsec
drop table ecs_exaunitsec  cascade constraints;
PROMPT Dropping table ecs_properties
drop table ecs_properties  cascade constraints;
PROMPT Dropping table ecs_optimeouts
drop table ecs_optimeouts  cascade constraints;
PROMPT Dropping table ecs_domukeysinfo
drop table ecs_domukeysinfo  cascade constraints;
PROMPT Dropping table ecs_exaunitdetails
drop table ecs_exaunitdetails  cascade constraints;
PROMPT Dropping table ecs_registries
drop table ecs_registries  cascade constraints;
PROMPT Dropping table ecs_associations
drop table ecs_associations  cascade constraints;
PROMPT Dropping table psm_properties
drop table psm_properties cascade constraints;
PROMPT Dropping table ecs_scheduledjob
drop table ecs_scheduledjob  cascade constraints;
PROMPT Dropping table ecs_diag_rack_info
drop table ecs_diag_rack_info cascade constraints;
PROMPT Dropping table ecs_diag_rackxml_monitor
drop table ecs_diag_rackxml_monitor cascade constraints;
PROMPT Dropping table ecs_diag_fault_request
drop table ecs_diag_fault_request cascade constraints;
PROMPT Dropping table ecs_diag_fault
drop table ecs_diag_fault cascade constraints;
PROMPT Dropping table ecs_diag_request
drop table ecs_diag_request cascade constraints;
PROMPT Dropping table ecs_diag_report
drop table ecs_diag_report cascade constraints;
PROMPT Dropping table ecs_diag_problem
drop table ecs_diag_problem cascade constraints;
PROMPT Dropping table ecs_hw_cabinets
drop table ecs_hw_cabinets cascade constraints;
PROMPT Dropping table ecs_ib_fabrics
drop table ecs_ib_fabrics cascade constraints;
PROMPT Dropping table ecs_hw_nodes
drop table ecs_hw_nodes cascade constraints;
PROMPT Dropping table ecs_ib_pkeys_used
drop table ecs_ib_pkeys_used cascade constraints;
PROMPT Dropping table ecs_caviums
drop table ecs_caviums cascade constraints;
PROMPT Dropping table ecs_vcns
drop table ecs_vcns cascade constraints;
PROMPT Dropping table ecs_oracle_admin_subnets
drop table ecs_oracle_admin_subnets cascade constraints;
PROMPT Dropping table ecs_domus
drop table ecs_domus cascade constraints;
PROMPT Dropping table ecs_temp_domus
drop table ecs_temp_domus cascade constraints;
PROMPT Dropping table ecs_clusters_purge_queue
drop table ecs_clusters_purge_queue cascade constraints;
PROMPT Dropping table ecs_exadata_entity
drop table ecs_exadata_entity cascade constraints;
PROMPT Dropping table ecs_exadata_formation
drop table ecs_exadata_formation cascade constraints;
PROMPT Dropping table ecs_exadata_cell_node
drop table ecs_exadata_cell_node cascade constraints;
PROMPT Dropping table ecs_exadata_capacity
drop table ecs_exadata_capacity cascade constraints;
PROMPT Dropping table ecra_clobs
drop table ecra_clobs cascade constraints;
PROMPT Dropping table ecs_compliance_aep_status
drop table ecs_compliance_aep_status cascade constraints;
PROMPT Dropping table ecs_compliance_cm_status
drop table ecs_compliance_cm_status cascade constraints;
PROMPT Dropping table ecs_compliance_cm_host_config
drop table ecs_compliance_cm_host_config cascade constraints;
PROMPT Dropping table ecs_compliance_cm_change_log
drop table ecs_compliance_cm_change_log cascade constraints;
PROMPT Dropping table ecs_atpracksize_subnet
drop table ecs_atpracksize_subnet cascade constraints;
PROMPT Dropping table ecs_available_db_version
drop table ecs_available_db_version cascade constraints;
PROMPT Dropping table ecs_patching_available_version
drop table ecs_patching_available_version cascade constraints;
PROMPT Dropping table ecs_exadata_db_applied_patches
drop table ecs_exadata_db_applied_patches cascade constraints;
PROMPT Dropping table ecs_exadata_applied_patches
drop table ecs_exadata_applied_patches cascade constraints;
PROMPT Dropping table ecs_domu_applied_patches
drop table ecs_domu_applied_patches cascade constraints;
PROMPT Dropping table ecs_patching_applied_version
drop table ecs_patching_applied_version cascade constraints;

PROMPT Dropping sequence pod_id_seq
drop sequence pod_id_seq;
PROMPT Dropping sequence services_id_seq
drop sequence services_id_seq;
PROMPT Dropping sequence exaunit_info_id_seq
drop sequence exaunit_info_id_seq;
PROMPT Dropping sequence resources_id_seq
drop sequence resources_id_seq;
PROMPT Dropping sequence databases_id_seq
drop sequence databases_id_seq;
PROMPT Dropping sequence ecs_scheduledjob_id_seq
drop sequence ecs_scheduledjob_id_seq;
PROMPT Dropping sequence ecs_diag_fault_id_seq
drop sequence ecs_diag_fault_id_seq;
PROMPT Dropping sequence ecs_diag_request_id_seq
drop sequence ecs_diag_request_id_seq;
PROMPT Dropping sequence ecs_diag_problem_id_seq
drop sequence ecs_diag_problem_id_seq;
PROMPT Dropping sequence ecs_diag_report_id_seq
drop sequence ecs_diag_report_id_seq;
PROMPT Dropping sequence ecs_hw_cabinets_seq_id
drop sequence ecs_hw_cabinets_seq_id;
PROMPT Dropping sequence ecs_ib_fabrics_seq_id
drop sequence ecs_ib_fabrics_seq_id;
PROMPT Dropping sequence ecs_hw_nodes_seq_id
drop sequence ecs_hw_nodes_seq_id;
PROMPT Dropping sequence ecs_hw_nodes_seq_clu_hw_id
drop sequence ecs_hw_nodes_seq_clu_hw_id;
PROMPT Dropping sequence ecs_ib_compute_pkeys_seq_id
drop sequence ecs_ib_compute_pkeys_seq_id ;
PROMPT Dropping sequence ecs_ib_storage_pkeys_seq_id
drop sequence ecs_ib_storage_pkeys_seq_id ;
PROMPT Dropping sequence image_id_seq
drop sequence image_id_seq;
PROMPT Dropping sequence image_category_id_seq
drop sequence image_category_id_seq;
PROMPT Dropping sequence exadata_entity_seq
drop sequence exadata_entity_seq;
PROMPT Dropping sequence ecra_clobs_id_seq
drop sequence ecra_clobs_id_seq;
PROMPT Dropping sequence cm_host_config_id_seq
drop sequence cm_host_config_id_seq;
PROMPT Dropping sequence cm_change_log_id_seq
drop sequence cm_change_log_id_seq;
