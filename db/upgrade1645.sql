Rem
Rem $Header: ecs/ecra/db/upgrade1645.sql /main/4 2016/11/03 21:33:46 diglesia Exp $
Rem
Rem upgrade1645.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1645.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1645.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    diglesia    11/03/16 - add dbtype column for upgrade
Rem    yifding     10/12/16 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- specifies the restrictions of secgroups
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_RULES_PER_GROUP', 'FIREWALL', '10');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_GROUPS_PER_EXAUNIT',  'FIREWALL', '5');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_GROUPS_PER_CUSTOMER',  'FIREWALL', '15');
INSERT INTO ecs_properties (name, type, value) VALUES ('FIREWALL_ROTATION_MAX',  'FIREWALL', '9998');

-- bdcs user/password
INSERT INTO ecs_properties (name, type, value) VALUES ('BDCS_USERNAME', 'BDCS', 'bdcs');
INSERT INTO ecs_properties (name, type, value) VALUES ('BDCS_PASSWORD', 'BDCS', 'welcome1');

ALTER TABLE ecs_racks ADD CONSTRAINT unique_name UNIQUE(name) enable;

--- missed from upgrade1643.sql
ALTER TABLE databases ADD dbtype VARCHAR2(36);
UPDATE databases SET dbtype='STARTER' WHERE dbtype is null;

commit;
exit;
