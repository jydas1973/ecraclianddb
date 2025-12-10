Rem
Rem $Header: ecs/ecra/db/upgrade1733.sql /main/4 2017/06/21 15:34:58 hgaldame Exp $
Rem
Rem upgrade1733.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1733.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1733.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hgaldame    06/13/17 - Bug 26269525 : Configurable rack memory settings
Rem    sgundra     06/06/17 - Bug-26222189 : domukeys endpoint
Rem    dekuckre    05/31/17 - Bug 26003269 - Add DEBUG_EXACLOUD to ecs_properties
Rem    rgmurali    05/23/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- for supporting temporary ssh keys
create table ecs_domukeysinfo (
    id              VARCHAR2(36) not null,
    exaunit_id      NUMBER,
    public_key      VARCHAR2(2048),
    users           VARCHAR(20) ,
    creation_time   VARCHAR2(64) not null,
    ttl             VARCHAR2(64) DEFAULT 86400,
    CONSTRAINT key_id PRIMARY KEY (id)
);

-- Specifies the HIGGs endpoint related information
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_USERNAME', 'HIGGS', 'higgs');
INSERT INTO ecs_properties (name, type, value) VALUES ('HIGGS_URL', 'HIGGS', 'http://localhost:8513');

-- for enabling debug tracing (True/False)
INSERT INTO ecs_properties (name, type, value) VALUES ('DEBUG_EXACLOUD', 'DEBUG', 'False');

-- for configurable rack mem settings in a non shared enviroment
ALTER TABLE ecs_hardware ADD memsize number default 240 not null;
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='QUARTER';
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='HALF';
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='FULL';
INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode, memsize ) VALUES ('X6-2', 'EIGHTH',   8, 34, 240);

INSERT INTO ecs_properties (name, type, value) VALUES ('DOMUKEYS_TTL', 'EXAUNIT', '86400');

COMMIT;
EXIT;
