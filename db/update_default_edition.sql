Rem
Rem $Header: ecs/ecra/db/update_default_edition.sql /main/1 2023/02/02 08:01:28 kukrakes Exp $
Rem
Rem update_default_edition.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      update_default_edition.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem
Rem    NOTES
Rem      This script does the following:
Rem      1. Set the EDITION as the DEFAULT databasewide edition.
Rem
Rem    USAGE
Rem      set_schema_version.sql <ALPHA_NUMERIC_STRING_OF_LENGTH_UP_TO_30_CHARS>
Rem    EXAMPLE
Rem      set_schema_version.sql ECS_MAIN_LINUX_X64_171202_010
Rem
Rem    CHECK the CURRENT VERSION of the ECRA Schema
Rem      SELECT property_value FROM  database_properties WHERE  property_name = 'DEFAULT_EDITION';
Rem
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    kukrakes    01/11/23 - ENH 34921831 - ECRA UPGRADE AND EBR FLOW
Rem                           (INCLUDES DEPLOYER , APPLICATION AND DATABASE
Rem                           CHANGES)
Rem    kukrakes    01/11/23 - Created
Rem

PROMPT Setting the edition &1 as default database Edition
alter database default edition=&1;

-- see the ECRA schema'c current version
SELECT property_value ECRA_SCHEMA_VERSION 
FROM  database_properties WHERE  property_name = 'DEFAULT_EDITION';


