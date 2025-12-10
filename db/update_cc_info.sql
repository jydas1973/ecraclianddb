Rem
Rem $Header: ecs/ecra/db/update_cc_info.sql /main/2 2019/11/06 13:51:06 jreyesm Exp $
Rem
Rem update_cc_info.sql
Rem
Rem Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      update_cc_info.sql - updates Compose Cluster info in ECRA db
Rem
Rem    DESCRIPTION
Rem      Sql file for Compose Cluster info update in ECRA db
Rem
Rem    NOTES
Rem      This script does the following:
Rem      1. Updates the cabinet_id column for all the dom0s in ecs_racks table
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/update_cc_info.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     11/06/19 - Add ignore errors on script
Rem    vmallu      05/31/19 - bug 29631598: ATP COMPOSE CLUSTER SUPPORT FOR 
Rem                           CAPACITY CONSOLIDATION
Rem    vmallu      05/31/19 - Created
Rem

whenever sqlerror continue;
declare
  l_cabinet_id ecs_hw_nodes.cabinet_id%TYPE;
begin
  for rec in
  (
    select distinct(dom0) from ecs_racks where cabinet_id is null
  )
  loop
    select distinct(cabinet_id) into l_cabinet_id from ecs_hw_nodes where node_type='COMPUTE' and regexp_like(rec.dom0,oracle_hostname);
    update ecs_racks set cabinet_id = l_cabinet_id where dom0 = rec.dom0;
  end loop rec;
  commit;
end;
/
show errors;
whenever sqlerror continue;

