Rem
Rem $Header: ecs/ecra/db/clean_exacloud_schema.sql /main/2 2018/02/20 12:35:52 hgaldame Exp $
Rem
Rem clean_exacloud_schema.sql
Rem
Rem Copyright (c) 2017, 2018, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      clean_exacloud_schema.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Clean ExaCloud schema in the Oracle DB
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/clean_exacloud_schema.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hgaldame    02/07/18 - XbranchMerge hgaldame_bug-27071543_exacm from
Rem                           st_ecs_17.3.6.0.0exacm
Rem    hhhernan    06/08/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100


drop table agent;
drop table workers;
drop table registry;
drop table requests;
drop table ecra_files;
drop table exacloud_files ;

drop table patchlist;

drop sequence ibfabricibswitches_seq;
drop trigger ibfabricibswitches_bi;
drop table ibfabricibswitches;

drop sequence ibfabricclusters_seq;
drop trigger ibfabricclusters_bi;
drop table ibfabricclusters;


drop sequence ibfabriclocks_seq;
drop trigger ibfabriclocks_bi;
drop table ibfabriclocks;
commit;
exit;
