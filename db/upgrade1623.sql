Rem
Rem $Header: ecs/ecra/db/upgrade1623.sql /main/7 2016/04/08 09:43:19 yifding Exp $
Rem
Rem upgrade1623.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1623.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      create a table ecs_subscriptions which maps the relation between subscription_id and exaunit
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1623.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    angfigue    03/29/16 - Bug 23019573 - UPDATE MINCORES TO 8 CORES PER
Rem                           NODE
Rem    yifding     03/17/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

drop table ecs_subscriptions;
drop table ecs_partnums;
drop table subscriptions;
drop table racks;
drop table ecs_racks;
drop table cores;
drop table ecs_cores;
drop table ecs_requests;
drop table ecs_purchasetypes;

create table ecs_subscriptions (
        exaunit_id          NUMBER,
        subscription_id     VARCHAR2(50),
        customer_name       VARCHAR2(256),
        csi                 VARCHAR2(256)
);

commit;

create table ecs_purchasetypes(
    entitlement_category varchar(50) not null,
    purchase_type        varchar(50) not null,
    CONSTRAINT purchasetype_pk PRIMARY KEY (entitlement_category)
);
commit;

-- these insert statements need to be kept synced with those in create_tables.sql
INSERT INTO ecs_purchasetypes (entitlement_category, purchase_type) VALUES ('cloud_credit', 'metered');
INSERT INTO ecs_purchasetypes (entitlement_category, purchase_type) VALUES ('srvc_entitlement', 'subscription');
commit;


create table ecs_racks (
    name        varchar2(256) not null,
    model       varchar2(100) not null,
    status      varchar2(100) not null,
    racksize    varchar2(100) not null,
    details     varchar2(4000),
    location    varchar2(256),
    xml         CLOB,
    exaunitID   number,
    CONSTRAINT racks_pk PRIMARY KEY (name)
);
commit;


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
commit;


create table ecs_requests (
        ID              VARCHAR2(36),
        EXAUNIT_ID      NUMBER,
        RESOURCE_ID     VARCHAR2(36),
        OPERATION       VARCHAR2(24),
        STATUS          VARCHAR2(24),
        STATUS_UUID     VARCHAR2(36),
        START_TIME      VARCHAR2(50),
        END_TIME        VARCHAR2(50),
        DETAILS         VARCHAR2(256),
        ERRORS          VARCHAR2(4000),
        TARGET_URI      VARCHAR2(256)
);
commit;


-- ROLLBACK of min cores per node to 8
UPDATE hardware_info
SET minCoresPerNode=8;

commit;

exit;
