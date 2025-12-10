Rem
Rem $Header: ecs/ecra/db/upgrade1631.sql /main/4 2016/05/19 20:27:16 angfigue Exp $
Rem
Rem upgrade1631.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1631.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1631.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    angfigue    05/19/16 - information for dom0 patching required on
Rem                           ecs_racks;
Rem    angfigue    05/04/16 - schema changes
Rem    angfigue    05/04/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

drop table hardware_info;
drop table ecs_hardware;

create table ecs_hardware (
      model            varchar2(100) not null,
      racksize         varchar2(100) not null,
      minCoresPerNode  number        not null,
      maxCoresPerNode  number        not null,
      CONSTRAINT hardware_pk PRIMARY KEY (model, racksize)
);

commit;


alter table services
    add identity_domain_display_name VARCHAR(4000);

INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X4-2', 'QUARTER', 8, 22);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X4-2', 'HALF',    8, 22);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X4-2', 'FULL',    8, 22);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X5-2', 'QUARTER', 8, 34);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X5-2', 'HALF',   14, 34);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X5-2', 'FULL',   14, 34);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X6-2', 'QUARTER', 8, 42);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X6-2', 'HALF',   14, 42);
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X6-2', 'FULL',   14, 42);


alter table ecs_racks add envType varchar2(100);
alter table ecs_racks add dom0 VARCHAR(512);
alter table ecs_racks drop constraint racks_pk;
alter table ecs_racks rename column cluid to domu;
alter table ecs_racks add constraint racks_pk PRIMARY KEY (domu);

commit;
exit;
