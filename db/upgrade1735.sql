Rem
Rem $Header: ecs/ecra/db/upgrade1735.sql /main/3 2017/07/20 14:05:06 sgundra Exp $
Rem
Rem upgrade1735.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1735.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1735.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    sgundra     07/13/17 - Add CNS and ORDS Integration options
Rem    sachikuk    06/16/17 - Getting rid of multiple duplicate rack xml
Rem                           sources [Bug - 26195118]
Rem    sachikuk    06/16/17 - ECRA DB upgrade script for upgrade from 17.3.3 to
Rem                           17.3.5
Rem    sachikuk    06/16/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Add UPDATED_XML column to ECS_RACKS table
ALTER TABLE ECS_RACKS ADD (UPDATED_XML CLOB);

--for CNS and ORDS integration
INSERT INTO ecs_properties (name, type, value) VALUES ('CNS_INTEGRATION', 'CNS', 'False');
INSERT INTO ecs_properties (name, type, value) VALUES ('ORDS_INTEGRATION', 'ORDS', 'False');

COMMIT;
EXIT; 
