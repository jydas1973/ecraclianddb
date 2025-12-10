Rem
Rem $Header: ecs/ecra/db/revert_ebr_changes.sql /main/3 2024/03/28 05:05:56 dtalla Exp $
Rem
Rem revert_ebr_changes.sql
Rem
Rem Copyright (c) 2023, 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      revert_ebr_changes.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script will be used for reverting back ebr schema changes
Rem    USAGE
Rem      SQL>@revert_ebr_changes.sql <ecraDBUser>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/revert_ebr_changes.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    dtalla      03/07/24 - BUG 36373140 - HANDLE EXCEPTIONS
Rem    kukrakes    01/20/23 - ENH 34921831 - ECRA UPGRADE AND EBR FLOW
Rem                           (INCLUDES DEPLOYER , APPLICATION AND DATABASE
Rem                           CHANGES)
Rem    kukrakes    01/20/23 - Created
Rem

SET SERVEROUTPUT ON
SET ECHO ON
SET FEEDBACK ON
whenever sqlerror continue;
PROMPT updating session edition
alter session set edition=ORA$BASE;

DECLARE
    sql_stmt VARCHAR2(1000);
    logged_in_user VARCHAR2(50);
    user_name VARCHAR2(20);

BEGIN
    logged_in_user := '&1';
    user_name := USER;
    IF (upper(user_name) like upper(logged_in_user)) THEN

        FOR lf IN (
            /* SQL query to find all views in the schema
            whose referenced_type is table and
            referenced_name ending with '_TABLE'
            */
            SELECT
                name,
                referenced_name
            FROM
            user_dependencies
            WHERE
                type = 'VIEW'
            AND referenced_type = 'TABLE'
            AND upper(referenced_name) LIKE '%_TABLE'
            AND upper(name) not in ('ECS_V_MVM_DOMUS', 'ECS_V_MVM_COMPUTES', 'ECS_V_MVM_EXASERVICE', 'ECS_HARDWARE_FILTERED')
        ) LOOP
            DBMS_OUTPUT.NEW_LINE();
            dbms_output.put_line('VIEW_NAME: ' || lf.name);
            dbms_output.put_line('TABLE_NAME: ' || lf.referenced_name);
            dbms_output.put_line('Deleting view: ' || lf.name);
            dbms_output.put_line('Renaming Table: '
                    || lf.referenced_name
                    || ' to '
                    || lf.name);
            -- Dropping view
            sql_stmt := 'drop view ' || lf.name;
            dbms_output.put_line(sql_stmt);
            BEGIN
                EXECUTE IMMEDIATE sql_stmt;
            EXCEPTION
                WHEN OTHERS THEN
                    dbms_output.put_line('Error droping view - '
                                         || lf.name
                                         || ': '
                                         || sqlerrm);
            END;
            -- Renaming table
            sql_stmt := 'rename '
                || lf.referenced_name
                || ' to '
                || lf.name;
            dbms_output.put_line(sql_stmt);
            BEGIN
                EXECUTE IMMEDIATE sql_stmt;
            EXCEPTION
                WHEN OTHERS THEN
                    dbms_output.put_line('Error renaming table '
                                         || lf.referenced_name
                                         || ': '
                                         || sqlerrm);
            END;
        END LOOP;
    END IF;
END;
/
