Rem
Rem install_ecra_schema.sql
Rem
Rem Copyright (c) 2017, 2019, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      install_ecra_schema.sql - Driver script for the new ECRA schema
Rem      installation or upgrade of an existing ECRA schema
Rem
Rem    DESCRIPTION
Rem      Installs a new ECRA schema
Rem      Also upgrades an existing ECRA schema
Rem
Rem    Why this file? To do
Rem     Label to label upgrades
Rem     Untangle DDLs
Rem     Separate out Schema object Creations and Alterations and Deletions.
Rem     Make Triggers creation a separate action
Rem     Seed Data go in the end as a separate action
Rem     No need to have upgrade*.sql files.
Rem 
Rem    Details
Rem     The ECRA schema creation/upgrade has the following general categories:
Rem     1. Tables/Index/Sequence creation
Rem       All the table creation DDLs go to the ecs/ecra/db/create_tables.sql. 
Rem       Along with the tables, their respective indexes can also be added in 
Rem       the file. Alos the sequences. 
Rem       So. the following DDLs should go in this catagory:
Rem 
Rem       CREATE TABLE
Rem       CREATE INDEX
Rem       CREATE SEQUENCE
Rem 
Rem       The file should NOT contain any other DDLs. 
Rem       Here are the list to DDLs that DO NOT go to this file:
Rem 
Rem       ALTER TABLE
Rem       DROP TABLE
Rem       CREATE TRIGGER
Rem       INSERT, UPDATE and DELETE
Rem 
Rem    2. Table/Index/Sequence Alterations
Rem      Once the table is created via create_tables.sql all the alterations to 
Rem      the same should go to ecs/ecra/db/alter_tables.sql. 
Rem      Following alterations are allowed in this catagory:
Rem 
Rem      ALTER TABLE ADD COLUMN
Rem      ALTER TABLE MODIFY COLUMN
Rem      ALTER TABLE DROP COLUMN
Rem      ALTER TABLE RENAME COLUMN
Rem      ALTER TABLE ADD CONSTRAINT (PK, FK, CHECK and so on)
Rem      ALTER TABLE MODIFY CONSTRAINT (PK, FK, CHECK and so on)
Rem      ALTER TABLE DROP CONSTRAINT (PK, FK, CHECK and so on)
Rem      ALTER TABLE ALTER INDEX
Rem      ALTER TABLE DROP INDEX
Rem 
Rem      All of the modifications have to be in chronological + logical order.  
Rem      For example, one will not attempt to modify a column with OLD name 
Rem      after it has been renamed to NEW name.
Rem
Rem    3. Drop Tables/Sequence
Rem      They all go to ecs/ecra/db/drop_tables.sql.  
Rem      Dropping of tables should NOT be required unless the table in question 
Rem      is not necessary going forward. For completeness sake the DROP action 
Rem      is kept in the ECRA install/upgrade
Rem      DDLs allowed in this catagory are :
Rem      DROP TABLE
Rem      DROP SEQUENCE
Rem
Rem    4. Alter sequences
Rem     If the upgrade need to alter the sequences,  it has to be done 
Rem     programmatically. Because the sequence may have a different current value
Rem     than when it was created due to its usage. So the logic should first get
Rem     the current value of the sequence and then alter it or recreate it with 
Rem     the START value set to the current value.
Rem   
Rem   5. Create or alter PL/SQL packages
Rem     Since the triggers have an upper limit of number of lines in them,
Rem     PL/SQL functions/procedures are used in triggers. So this action
Rem     has to happen before create triggers action.
Rem   
Rem   6. Create/Alter Triggers
Rem     Since trigger DDLs allow REPLACE the existing trigger, altering them 
Rem     during upgrade is easy. 
Rem     So they all go into ecs/ecra/db/create_triggers.sql
Rem
Rem   7. Seeding the tables
Rem     This action should be the last one to be run. All the seed data go into 
Rem     the file ecs/ecra/db/seed_tables.sql  If the data already exists in the 
Rem     tables, due to the PK, UNIQUE or CHECK constraints, it will error out 
Rem     and become no-op.
Rem 
Rem   8. Set ECRA Schema version
Rem     Need to have a schema version in order to identify the current version 
Rem     it is in. It also allows one to build smarter upgrades (if needed). 
Rem     Simplest way to achieve is to make use of the Oracle Database 
Rem     feature "EDITIONS".   This allows one to upgrade the schema with 
Rem     zero downtime.  For now ECRA don't need the full fledged use of the 
Rem     EDITIONS other than making use of it to identify the schema version. 
Rem     Here is how it is going to work:
Rem 
Rem     1. ECRA build will put the current label name (after massagin to fit
Rem        to 30 chars) into the file 
Rem        ecs/ecra/db/ecra_schema_version.txt This file is a Derived Object.
Rem     2. ECRA deployer reads the content of the file and passes it to this 
Rem        script which in turn creates a database 
Rem        EDITION with that name and sets it as the DEFAULT EDITION.
Rem 
Rem     Once done, one can query current EDITION as
Rem      SELECT property_value ECRA_SCHEMA_VERSION 
Rem      FROM  database_properties WHERE  property_name = 'DEFAULT_EDITION';
Rem 
Rem      BTW,  Database EDITIONS are supported in Oracle 11G.
Rem 
Rem    9. Putting all together
Rem      With all the disciplined actions and their respective files here is 
Rem      how the new ECRA schema creation or an upgrade of it goes.
Rem      Beauty of this is that both actions share the same set of sub actions.
Rem      So no need to have separate code paths.
Rem      Essentially the ECRA deployer just calls this script the schema version
Rem      string which does the following:
Rem      a. create tables/indexes/sequences (ecs/ecra/db/create_tables.sql
Rem      b. alter tables/indexes (ecs/ecra/db/alter_tables.sql)
Rem      c. create/alter triggers (ecs/ecra/db/create_triggers.sql)
Rem      d. seed tables (ecs/ecra/db/seed_tables.sql)
Rem      e. Set ECRA Schema version (ecs/ecra/db/set_schema_version.sql)
Rem 
Rem    10. Branching and different code lines
Rem     Again this sequence of actions are properly handled by virtue of the 
Rem     underlying ADE branching of the files.  Depending on from where they 
Rem     got branched, each action file contains only those relevant changes. 
Rem     And both new schema creation or the upgrade will run only those DDLs 
Rem     which are in the action files. That is all.
Rem 
Rem    NOTES
Rem      Does the following in the order given
Rem      1. table, index, sequence creation
Rem      2. alters the existing tables
Rem      3. Create or alter PL/SQL packages
Rem      4. creates triggers
Rem      5. seeds the ecra schema tables
Rem      6. sets the ECRA schema version
Rem
Rem    USAGE 
Rem      install_ecra_schema.sql <ECRA_VER_ALPHA_NUMERIC_STRING_OF_LEN_UP_TO_30_CHARS>
Rem    EXAMPLE
Rem      set_schema_version.sql ECS_MAIN_171202_010
Rem      set_schema_version.sql ECS_18_1_3_0_0_171202_010
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/install_ecra_schema.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    panmishr    09/05/19 - Integrate workflow infra with Janitor
Rem    aabharti    08/21/19 - Bug 30157612: EXACC OCI Workflow alter tables
Rem    vmallu      05/31/19 - bug 29631598: ATP COMPOSE CLUSTER SUPPORT FOR CAPACITY CONSOLIDATION.
Rem    byyang      02/06/18 - ER 27417896. Refactor log collection
Rem    byyang      01/11/18 - Pass ecradpy mode parameter
Rem    nkedlaya    12/03/17 - Enh 27209353 - SEAMLESS ECRA SCHEMA UPGRADE
Rem                           BETWEEN VERSIONS
Rem    nkedlaya    12/03/17 - Created
Rem

whenever sqlerror continue;

-- Define variables for subscript arguments
DEFINE ecs_version = &1

PROMPT Creating ECRA tables, indexes and sequences
@@create_tables

PROMPT Creating Workflow infra tables, indexes and sequences
@@create_wf_tables

PROMPT Altering ECRA tables, indexes
@@alter_tables

PROMPT Altering Workflow infra tables, indexes and sequences
@@alter_wf_tables

PROMPT Create and compile PL/SQL packages
@@compile_plsql

PROMPT Create ECRA triggers
@@create_triggers

PROMPT Seed ECRA tables
@@seed_tables

PROMPT Seed Worklfow infra  tables
@@seed_wf_tables

PROMPT Update Compose Cluster info 
@@update_cc_info

PROMPT Set ECRA schema version
@@set_schema_version &ecs_version

quit;
