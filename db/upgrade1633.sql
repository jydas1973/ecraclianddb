Rem
Rem $Header: ecs/ecra/db/upgrade1633.sql /main/6 2016/07/19 02:02:54 aschital Exp $
Rem
Rem upgrade1633.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1633.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      add secgroups & secrules
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1633.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    yifding     06/08/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

drop table ecs_secgroups;
drop table ecs_secrules;
drop table ecs_seccount;
drop table ecs_exaunitsec;
drop table ecs_properties;
drop table restrictions;
drop table ecs_dataguard;

ALTER TABLE ecs_requests MODIFY (id NOT NULL);
ALTER TABLE ecs_requests MODIFY (operation NOT NULL);
ALTER TABLE ecs_requests MODIFY (status NOT NULL);
ALTER TABLE ecs_requests MODIFY details VARCHAR2(1024);

create table ecs_secgroups (
    SEC_ID      NUMBER not null,
    CUSTOMER_ID VARCHAR2(256) not null,
    NAME        VARCHAR2(256) not null, 
    DESCRIPTION VARCHAR2(512),
    VERSION     NUMBER not null,
    CONSTRAINT secgroups_pk PRIMARY KEY (SEC_ID, CUSTOMER_ID),
    CONSTRAINT secgroups_unique UNIQUE(NAME, CUSTOMER_ID) enable
);


create table ecs_secrules (
    SEC_ID      NUMBER not null,
    CUSTOMER_ID VARCHAR2(256) not null,
    DIRECTION   VARCHAR2(32) not null,
    PROTO       VARCHAR2(32) not null,
    START_PORT  NUMBER,
    END_PORT    NUMBER,
    IP_SUBNET   VARCHAR2(32) not null,
    INTERFACE   VARCHAR2(32) not null
);

create table ecs_seccount (
    CUSTOMER_ID VARCHAR2(256) not null,
    SEC_COUNT   NUMBER not null,
    CONSTRAINT sec_count_pk PRIMARY KEY (CUSTOMER_ID)
);

create table ecs_exaunitsec (
    EXAUNIT_ID  NUMBER not null,
    SEC_ID      NUMBER not null,
    CUSTOMER_ID VARCHAR2(256) not null
);

create table ecs_dataguard (
      exaunitID  number not null,
      CONSTRAINT dataguard_pk PRIMARY KEY (exaunitID)
);

create table ecs_properties (
    NAME     VARCHAR2(256) not null,
    TYPE     VARCHAR2(256),
    VALUE    VARCHAR2(256),
    CONSTRAINT property_pk PRIMARY KEY (NAME)
);


INSERT INTO ecs_properties (name, type, value) VALUES ('SBE_CORE_BURST_MULT', 'CORE_BURST', '2');
INSERT INTO ecs_properties (name, type, value) VALUES ('MBE_CORE_BURST_MULT', 'CORE_BURST', '2');

INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_TOOL_HOST', 'FIREWALL', 'http://localhost:8500');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_TOOL_KEY',  'FIREWALL', '3faab95b4120b2c8d44861aca29e0f41');

INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL',  'FEATURE', 'DISABLED');

commit;
exit;
