Rem
Rem $Header: ecs/ecra/db/upgrade1714ExaCM.sql /main/1 2017/02/08 16:54:32 hhhernan Exp $
Rem
Rem upgrade1714ExaCM.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1714ExaCM.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1714ExaCM.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hhhernan    02/02/17 - Upgrade ECRA schema from 16.4.4 to 17.1.4 ExaCM
Rem    hhhernan    02/02/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Upgrade from 16.4.3 to 16.4.5

-- specifies the restrictions of secgroups
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_RULES_PER_GROUP', 'FIREWALL', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_GROUPS_PER_EXAUNIT',  'FIREWALL', '5');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_GROUPS_PER_CUSTOMER',  'FIREWALL', '15');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_ROTATION_MAX',  'FIREWALL', '9998');

-- bdcs user/password
--INSERT INTO ecs_properties (name, type, value) VALUES ('BDCS_USERNAME', 'BDCS', 'bdcs');
--INSERT INTO ecs_properties (name, type, value) VALUES ('BDCS_PASSWORD', 'BDCS', 'welcome1');

ALTER TABLE ecs_racks ADD CONSTRAINT unique_name UNIQUE(name) enable;

--- missed from upgrade1643.sql
ALTER TABLE databases ADD dbtype VARCHAR2(36);
UPDATE databases SET dbtype='STARTER' WHERE dbtype is null;

-- Upgrade from 16.4.5 to 17.1.3

-- increase association fields
ALTER TABLE ecs_associations MODIFY (
    ID VARCHAR2(128),
    SERVICE_ID VARCHAR2(128),
    SERVICE_NAME VARCHAR2(128),
    SERVICE_TYPE VARCHAR2(128));

-- update x6 min cores
UPDATE ecs_hardware SET minCoresPerNode=11 where model='X6-2';

-- Upgrade from 17.1.3 to 17.1.4 ExaCM

INSERT INTO ecs_hardware (model, racksize, minCoresPerNode, maxCoresPerNode)VALUES ('X6-2', 'EIGHTH',  8, 22);

COMMIT;
EXIT;
 
