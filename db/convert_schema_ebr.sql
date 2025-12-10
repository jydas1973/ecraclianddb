Rem
Rem $Header: ecs/ecra/db/convert_schema_ebr.sql /main/3 2024/03/28 05:05:56 dtalla Exp $
Rem
Rem convert_schema_ebr.sql
Rem
Rem Copyright (c) 2023, 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      convert_schema_ebr.sql - This script is to make changes in
Rem      ECRA scheam to make it EBR acquiescent
Rem
Rem    DESCRIPTION
Rem      This file is created as part of making ECRA schema EBR compatible
Rem
Rem    NOTES
Rem      Script logic:
Rem         Query tables from user_tables view and table name should not be ending with '_TABLE'
Rem         Rename existing tables as '<existing_name>_TABLE'
Rem         Create editioning view with <old_table_name>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/convert_schema_ebr.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    dtalla      03/07/24 - BUG 36373140 - HANDLE EXCEPTIONS
Rem    kukrakes    01/12/23 - ENH 34921831 - ECRA UPGRADE AND EBR FLOW
Rem                           (INCLUDES DEPLOYER , APPLICATION AND DATABASE
Rem                           CHANGES)
Rem    kukrakes    01/12/23 - Created
Rem


SET SERVEROUTPUT ON
SET ECHO ON
SET FEEDBACK ON

PROMPT Enabling edition for &2
ALTER USER &2
    ENABLE EDITIONS;

GRANT USE ON EDITION ora$base TO PUBLIC WITH GRANT OPTION;

ALTER DATABASE DEFAULT EDITION = ora$base;

ALTER SESSION SET EDITION = ora$base;

DECLARE
    newtable       VARCHAR2(100);
    sql_stmt       VARCHAR2(1000);
    user_name      VARCHAR2(50);
    logged_in_user VARCHAR2(50);
BEGIN
    logged_in_user := '&2';
    user_name := user;
    IF ( upper(user_name) LIKE upper(logged_in_user) ) THEN
        dbms_output.new_line();
        dbms_output.put_line('USERNAME: ' || user_name);
        FOR lf IN (
            /* SQL query to find all table in the schema
            whose names are not ending with '_TABLE'
            '_TABLE' is used to identify the entity as table by name
            */
            SELECT
                table_name
            FROM
                user_tables
            WHERE
                upper(table_name) NOT LIKE '%_TABLE'
                AND upper(table_name) NOT LIKE 'DR$STATE_HANDLE_INDEX%'
        ) LOOP
            newtable := lf.table_name || '_TABLE';
            dbms_output.put_line('OLD_NAME: ' || lf.table_name);
            dbms_output.put_line('NEW_NAME: ' || newtable);
            -- Renaming the table name
            sql_stmt := 'rename '
                        || lf.table_name
                        || ' to '
                        || newtable;
            dbms_output.put_line(sql_stmt);
            BEGIN
                EXECUTE IMMEDIATE sql_stmt;
            EXCEPTION
                WHEN OTHERS THEN
                    dbms_output.put_line('Error renaming table '
                                         || lf.table_name
                                         || ': '
                                         || sqlerrm);
                    CONTINUE;
            END;
            -- Creating Editioning view
            sql_stmt := 'CREATE OR REPLACE EDITIONING VIEW '
                        || lf.table_name
                        || ' AS select * from '
                        || newtable;
            dbms_output.put_line(sql_stmt);
            BEGIN
                EXECUTE IMMEDIATE sql_stmt;
            EXCEPTION
                WHEN OTHERS THEN
                    dbms_output.put_line('Error creating edition view - '
                                         || lf.table_name
                                         || ': '
                                         || sqlerrm);
            END;
        END LOOP;

    ELSE
        dbms_output.new_line();
        dbms_output.put_line('Invalid Username, skipping renaming of table and editioning view creation');
    END IF;
END;
/


