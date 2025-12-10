Rem
Rem $Header: ecs/ecra/db/upgrade18111.sql /main/2 2018/03/03 18:23:13 jreyesm Exp $
Rem
Rem upgrade18111.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade18111.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade18111.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     03/01/18 - Bug 27614474. Add client/backup natips
Rem    jreyesm     02/26/18 - Created
Rem

--table creation
drop table ecs_higgsnatvips;
create table ecs_higgsnatvips (
    exaunitID number not null,
    hostname    varchar2(500),
    ip     varchar2(128) not null,
    ip_type varchar(128) not null,
    CONSTRAINT ecs_higgsnatvips_pk PRIMARY KEY(exaunitID,ip,ip_type)
);

--alters
alter table ecs_higgsresources
    add (clientnetwork varchar(256));
alter table ecs_higgsresources
    add (backupnetwork varchar(256));

alter table ecs_higgsresources
    add (nodevips_name varchar(4000),scanvips_name varchar(4000));
alter table ecs_higgsresources
    add (clientvnic_name varchar(1024),backupvnic_name varchar(1024));


--inserts
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_NAT_IPPOOL', 'HIGGS', '/oracle/public/ippool');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_CREATE_CLIENTNATVIPS', 'HIGGS', 'ENABLED');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_CREATE_BACKUPNATVIPS', 'HIGGS', 'ENABLED');

DELETE FROM ecs_properties WHERE name = 'HIGGS_ENABLE_NATVIPS';
UPDATE ecs_properties SET value='10.150.240.132/32' WHERE name='HIGGS_PSM_SERVICEIP';

COMMIT;
EXIT;


