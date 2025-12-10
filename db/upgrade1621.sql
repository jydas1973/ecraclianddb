Rem
Rem $Header: ecs/ecra/db/upgrade1621.sql /main/2 2016/02/29 13:52:10 yifding Exp $
Rem
Rem upgrade1621.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1621.sql - database upgrade script for 16.2.1 release
Rem
Rem    DESCRIPTION
Rem      create racks table for rack inventory management
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA 
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1621.sql 
Rem    SQL_SHIPPED_FILE: 
Rem    SQL_PHASE: 
Rem    SQL_STARTUP_MODE: NORMAL 
Rem    SQL_IGNORABLE_ERRORS: NONE 
Rem    SQL_CALLING_FILE: 
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    angfigue    02/25/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

drop table cores;
drop table restrictions;
drop table subscriptions;
drop table racks;


create table racks (
    name        varchar2(256) not null,
    model       varchar2(100) not null,
    status      varchar2(100) default on null 'UNPROV',
    racksize    varchar2(100) not null,
    details     varchar2(4000),
    location    varchar2(256),
    xml         CLOB,
    exaunitID   number,
    CONSTRAINT racks_pk PRIMARY KEY (name)
);


commit;



alter table services
    add purchase_type varchar2(50) null;

commit;

create table cores(
      service varchar2(4000) not null,
      hostname varchar2(500) not null,
      subscocpus number not null,
      meterocpus number not null,
      burstocpus number not null,
      CONSTRAINT coreskeys_pk PRIMARY KEY(hostname),
      CONSTRAINT fk_service
         FOREIGN KEY(service)
         REFERENCES  services(id)
);
commit;

create table restrictions(
     name varchar(100) not null,
     limit number not null,
     CONSTRAINT restrictions_pk PRIMARY KEY(name)
);
commit;

create table subscriptions(
     id varchar(100) not null,
     purchasetype number not null,
     CONSTRAINT subscriptions_pk PRIMARY KEY(id)
);

Rem  purchase valid _values
Rem  0 - metered
Rem  1 - subscription

INSERT INTO subscriptions (id, purchasetype)
VALUES ('B84707', 0);
INSERT INTO subscriptions (id, purchasetype)
VALUES ('B84708', 0);
INSERT INTO subscriptions (id, purchasetype)
VALUES ('B84709', 0);
INSERT INTO subscriptions (id, purchasetype)
VALUES ('B81633', 1);
INSERT INTO subscriptions (id, purchasetype)
VALUES ('B81634', 1);
INSERT INTO subscriptions (id, purchasetype)
VALUES ('B81635', 1);
INSERT INTO restrictions (name, limit)
VALUES ('subscription_core_limit', 2);

commit;

exit;
