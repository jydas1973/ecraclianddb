Rem
Rem $Header: ecs/ecra/db/misc/schema_report.sql /main/3 2024/07/23 07:32:45 dtalla Exp $
Rem
Rem schema_report.sql
Rem
Rem Copyright (c) 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      schema_report.sql - Generate report on user schema
Rem
Rem    DESCRIPTION
Rem      This script systematically scans all tables within the schema,
Rem      extracting associated views, constraints, and referential constraints.
Rem      Following the table iteration, it proceeds to triggers and finally to sequences.
Rem
Rem    NOTES
Rem      The report file, located at '/tmp/schema_report.txt',
Rem      gets overwritten with each execution.
Rem
Rem
Rem    MODIFIED    (MM/DD/YY)
Rem    dtalla      07/18/24 - Enh 36854201: Remove constraint names in report
Rem    dtalla      05/02/24 - Enh 36574162: Include indexes and column details
Rem    dtalla      02/23/24 - Schema Report
Rem    dtalla      02/23/24 - Created
Rem

SET SERVEROUTPUT ON FORMAT WRA
SET LINE 160
SET FEEDBACK OFF

prompt ReportFile - /tmp/schema_report.txt

SET TERM OFF
SET TRIMS ON
spool '/tmp/schema_report.txt'
DECLARE
    -- Variables for table, view, constraint, trigger, and synonym names
    v_table_name          VARCHAR2(500);
    v_dep_name            VARCHAR2(500);
    v_dep_type            VARCHAR2(500);
    v_constraint_type     VARCHAR2(500);
    v_constraint          VARCHAR2(50);
    v_edition             VARCHAR2(100);
    v_constraint_status   VARCHAR2(100);
BEGIN
    -- Loop through each table in the schema
dbms_output.put_line('Script execution started: '
                     || to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS')
                     || chr(10));

dbms_output.put_line('User: ' || user);

SELECT
    sys_context('userenv', 'current_edition_name')
INTO v_edition
FROM
    dual;

dbms_output.put_line('Current Edition: '
                     || v_edition
                     || chr(10));

dbms_output.put_line('== Tables in the schema ==');

FOR tables IN (
    SELECT
        table_name
    FROM
        user_tables
    WHERE
        table_name NOT LIKE 'DR$%'
    ORDER BY
        table_name
) LOOP
    v_table_name := tables.table_name;

    -- Print table name
    dbms_output.put_line(chr(10)
                         || 'Table: '
                         || v_table_name);
    dbms_output.put_line ('  Table_Columns: ');
    -- List columns in the table:
    FOR tcolumns IN ( SELECT
        COLUMN_NAME as tcolumn
    FROM
        user_tab_columns
    WHERE
        table_name = tables.table_name
    ORDER BY
        1
    ) LOOP
      dbms_output.put_line('    ' || tcolumns.tcolumn);
    END LOOP;
    -- Check for views on the current table
    FOR tab_views IN (
        SELECT
            name,
            type
        FROM
            user_dependencies
        WHERE
            referenced_name = v_table_name
        ORDER BY
            type, name
    ) LOOP
        v_dep_name := tab_views.name;
        v_dep_type := upper(substr(tab_views.type, 1, 1))
                      || lower(substr(tab_views.type, 2));


        dbms_output.put_line('  '
                             || v_dep_type
                             || ': '
                             || v_dep_name);
        -- List columns in the view:
        IF v_dep_type = 'View' THEN
            dbms_output.put_line('  View_Columns: ');
            -- List columns in the table:
            FOR vcolumns IN ( SELECT
                COLUMN_NAME as vcolumn
            FROM
                user_tab_columns
            WHERE
                table_name = tables.table_name
            ORDER BY
                1
            ) LOOP
            dbms_output.put_line('    ' || vcolumns.vcolumn);
            END LOOP;
        END IF;

    END LOOP;

    -- Check for Indexes on the current Table
    -- NOTE: Constraint indexes are not part of this report, only user defined indexes are picked

    FOR tab_index IN (
        SELECT
            c.column_name,
            i.index_name
        FROM
            user_ind_columns c,
            user_indexes     i
        WHERE
                c.index_name = i.index_name
            AND i.constraint_index = 'NO'
                AND i.table_name = v_table_name
        ORDER BY
            2,
            1
    ) LOOP
        dbms_output.put_line('  Index: ' || tab_index.index_name);
        dbms_output.put_line('    Index_Column: ' || tab_index.column_name);
    END LOOP;

    -- Check for constraints on the current table
    FOR constraints IN (
        SELECT
            user_constraints.constraint_type            AS constraint_type,
            user_constraints.status                     AS status,
            LISTAGG(user_cons_columns.column_name, ',') within GROUP (ORDER BY user_cons_columns.column_name) AS column_name
        FROM
            user_constraints,
            user_cons_columns
        WHERE
                user_constraints.table_name = v_table_name
            AND user_constraints.constraint_name = user_cons_columns.constraint_name
        GROUP BY
            user_constraints.constraint_type,
            user_constraints.status
        ORDER BY
            1
    ) LOOP
        v_constraint_status := constraints.status;
        v_constraint_type := constraints.constraint_type;
        dbms_output.put_line('  Constraint_Type: ' || v_constraint_type);
        dbms_output.put_line('    Status: ' || v_constraint_status);
        dbms_output.put_line('    Columns: ' || constraints.column_name);
    END LOOP;

END LOOP;

-- Check for triggers in the schema
dbms_output.put_line('== Triggers in the schema ==' || chr(10));

FOR triggers IN (
    SELECT
        trigger_name,
        trigger_type,
        triggering_event,
        table_name,
        status
    FROM
        user_triggers
    ORDER BY
        trigger_name
) LOOP
    dbms_output.put_line('Trigger: ' || triggers.trigger_name);
    dbms_output.put_line('  Type: ' || triggers.trigger_type);
    dbms_output.put_line('  Event: ' || triggers.triggering_event);
    dbms_output.put_line('  Status: ' || triggers.status);
    dbms_output.put_line('  Table_name: '
                         || triggers.table_name
                         || chr(10));
END LOOP;

-- Check for Sequences in Schema
dbms_output.put_line('== Sequences in the schema ==' || chr(10));

FOR sequence IN (
    SELECT
        sequence_name,
        min_value,
        max_value
    FROM
        user_sequences
    ORDER BY
        sequence_name
) LOOP
    dbms_output.put_line('Sequence: ' || sequence.sequence_name);
    dbms_output.put_line('  min_value: ' || sequence.min_value);
    dbms_output.put_line('  max_value: '
                         || sequence.max_value
                         || chr(10));
END LOOP;

dbms_output.put_line('Script execution completed: ' || to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS'));

end;
/

spool off;

EXIT;