Rem
Rem $Header: ecs/ecra/db/upgrade1635.sql /main/5 2016/07/28 23:01:52 yifding Exp $
Rem
Rem upgrade1635.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1635.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      alter primary key for rack table
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1635.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aschital    07/20/16 - XbranchMerge aschital_bug-24321445 from
Rem                           st_ecs_16.3.5.0.0
Rem    yifding     07/12/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

drop table ecs_optimeouts;

create table ecs_optimeouts (
    OPERATION     VARCHAR2(24) not null,
    RACKSIZE      VARCHAR2(24) not null,
    SOFT_TIMEOUT  number,
    HARD_TIMEOUT  number,
    CONSTRAINT optimeout_pk PRIMARY KEY (OPERATION, RACKSIZE)
);

INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('createDatabase', 'QUARTER', 2 * 3600, 3 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('createDatabase', 'HALF',    5 * 3600, 6 * 3600);
INSERT INTO ecs_optimeouts (operation, racksize, soft_timeout, hard_timeout) VALUES ('createDatabase', 'FULL',    7 * 3600, 8 * 3600);

ALTER TABLE ecs_racks DROP CONSTRAINT racks_pk;
ALTER TABLE ecs_racks ADD  CONSTRAINT racks_pk PRIMARY KEY (domu);

ALTER TABLE ecs_subscriptions ADD entitlement_id VARCHAR2(50);

drop table dataguard;
drop table ecs_dataguard;
create table ecs_dataguard (
      exaunitID  number not null,
      CONSTRAINT dataguard_pk PRIMARY KEY (exaunitID)
);

commit;
exit;
