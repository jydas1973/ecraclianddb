Rem
Rem $Header: ecs/ecra/db/compile_plsql.sql /main/2 2017/12/20 13:48:54 nkedlaya Exp $
Rem
Rem compile_plsql.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      compile_plsql.sql - compile PL/SQL package and functions 
Rem
Rem    DESCRIPTION
Rem      Compile ECRA PL/SQL package and functions
Rem
Rem    NOTES
Rem      How it works?
Rem      Just add the file that contains the PL/SQL package or functions
Rem      to this file. During the fresh installation of the ECRA or its
Rem      upgrade to any version this file will be called.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/compile_plsql.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nkedlaya    09/22/17 - infrastructure to compile and recompile PL/SQL
Rem                           code
Rem    nkedlaya    09/22/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Compile ECRA PL/SQL Package specs. All specs are compiled first.
PROMPT Compiling PL/SQL Package specs
@@ecra_pkg.pls

-- Compile ECRA PL/SQL Package bodies, Then the bodies.
PROMPT Compiling PL/SQL Package bodies
@@ecra_pkg.plb
