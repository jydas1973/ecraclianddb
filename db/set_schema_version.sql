Rem
Rem set_schema_version.sql
Rem
Rem Copyright (c) 2017, 2023, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      set_schema_version.sql - Set the ECRA schema version to the given
Rem      string using database editions
Rem
Rem    DESCRIPTION
Rem      ECRA makes use of the Database Editions to maintain the schema
Rem      version. For more info refer to ecs/ecra/db/install_ecra_schema.sql
Rem
Rem    NOTES
Rem      This script does the following:
Rem      1. Create the Database EDITION using the string that was passed to
Rem         the script as input. Input version string should not be more
Rem         than 30 chars. String can contain alpha-numeric and "_". No
Rem         other chars are allowed.
Rem      2. Grant the use of the edition to the ECRA schema
Rem      3. Set the EDITION as the DEFAULT databasewide edition.
Rem
Rem    USAGE
Rem      set_schema_version.sql <ALPHA_NUMERIC_STRING_OF_LENGTH_UP_TO_30_CHARS>
Rem    EXAMPLE
Rem      set_schema_version.sql ECS_MAIN_LINUX_X64_171202_010
Rem
Rem    CHECK the CURRENT VERSION of the ECRA Schema
Rem      SELECT property_value FROM  database_properties WHERE  property_name = 'DEFAULT_EDITION';
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/set_schema_version.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    kukrakes    01/16/23 - ENH 34921831 - ECRA UPGRADE AND EBR FLOW
Rem                           (INCLUDES DEPLOYER , APPLICATION AND DATABASE
Rem                           CHANGES)
Rem    rgmurali    05/12/20 - Bug 31321032 - Ignore edition errors in QA/dev envs
Rem    nkedlaya    12/02/17 - Enh 27209353 - SEAMLESS ECRA SCHEMA UPGRADE
Rem                           BETWEEN VERSIONS
Rem    nkedlaya    12/02/17 - Created
Rem
whenever sqlerror continue;
PROMPT Creating edition &1 
create edition &1;

PROMPT Granting the use of edition &1 to PUBLIC
grant use on edition &1 to public;

-- see the ECRA schema'c current version
SELECT property_value ECRA_SCHEMA_VERSION 
FROM  database_properties WHERE  property_name = 'DEFAULT_EDITION';
