Rem
Rem $Header: ecs/ecra/db/create_directory.sql /main/1 2024/11/13 11:25:25 dtalla Exp $
Rem
Rem create_directory.sql
Rem
Rem Copyright (c) 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      create_directory.sql - Create a directory object in Database
Rem
Rem    DESCRIPTION
Rem      A directory object specifies an alias for a directory on the server file system -
Rem      where external files could be stored.
Rem
Rem    NOTES
Rem      Gold Image dump files are created and starged in directory
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    dtalla      08/20/24 - File to create directory in ECRA Schema
Rem    dtalla      08/20/24 - Created
Rem

PROMPT creating directory &1
CREATE OR REPLACE DIRECTORY stageDir AS '&1';