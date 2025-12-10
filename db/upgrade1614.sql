Rem
Rem $Header: ecs/ecra/db/upgrade1614.sql /main/1 2016/01/12 18:33:15 yifding Exp $
Rem
Rem upgrade1614.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1614.sql - database upgrade script for 16.1.4 release
Rem
Rem    DESCRIPTION
Rem      set minimum required cores per node to 4
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1614.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    yifding     01/12/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100



UPDATE hardware_info SET minCoresPerNode=4 WHERE model='X4-2';
UPDATE hardware_info SET minCoresPerNode=4 WHERE model='X5-2';
exit;