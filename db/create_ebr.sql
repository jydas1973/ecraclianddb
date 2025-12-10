Rem
Rem $Header: ecs/ecra/db/create_ebr.sql /main/1 2023/02/02 08:01:28 kukrakes Exp $
Rem
Rem create_ebr.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      create_ebr.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      This script does the following:
Rem      1. Create the Database EDITION using the string that was passed to
Rem         the script as input. Input version string should not be more
Rem         than 30 chars. String can contain alpha-numeric and "_". No
Rem         other chars are allowed.
Rem      2. Grant the use of the edition to the ECRA schema
Rem
Rem    USAGE
Rem      create_ebr.sql <ALPHA_NUMERIC_STRING_OF_LENGTH_UP_TO_30_CHARS> <user>
Rem    EXAMPLE
Rem      create_ebr.sql ECS_MAIN_LINUX_X64_171202_010 ecradbuser
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
whenever sqlerror continue;
PROMPT Creating edition &1 
create edition &1;

PROMPT Granting the use of edition &1 to PUBLIC
grant use on edition &1 to public with grant option;
PROMPT Granting the create any edition, drop any edition of edition &2
grant create any edition, drop any edition to &2;

PROMPT Granting the use of edition &1 to PUBLIC
alter user &2 enable editions
 
