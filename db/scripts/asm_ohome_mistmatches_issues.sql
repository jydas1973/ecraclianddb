Rem
Rem $Header: ecs/ecra/db/scripts/asm_ohome_mistmatches_issues.sql /main/2 2025/08/06 20:08:38 caborbon Exp $
Rem
Rem asm_ohome_mistmatches_issues.sql
Rem
Rem Copyright (c) 2025, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      asm_ohome_mistmatches_issues.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This Script will fix meteadata issue in tables: 
Rem         - ECS_EXAUNITDETAILS
Rem              - Set TB_STORAGE value when it does not match with GB_STORAGE value in this same table.
Rem         - ECS_EXASERVICE_ALLOCATIONS
Rem              - Set STORAGEGB when this value does not match with the result of SUM all values from GB_STORAGE 
Rem                in ECS_EXAUNITDETAILS table for current Infrastructure, we will use the SUM result and set it in STORAGEGB.
Rem              - Set USABLE_OHSTORAGEGB when this value does not match with the result of SUM all values from LOCAL_STORAGE_GB 
Rem                in ECS_EXADATA_COMPUTE_NODE table for current Infrastructure, we will use the SUM result and set it in USABLE_OHSTORAGEGB.
Rem         - ECS_EXADATA_COMPUTE_NODE
Rem              - Set AVAIL_LOCAL_STORAGE_GB when this value does not match with the SUM of all ECS_GOLD_SPECS  + GB_OHSIZE 
Rem                from ECS_EXAUNITDETAILS we will use the result of this SUM, and then substract it from the total size 
Rem                usable for this Compute (Value obtained from ECS_OH_SPACE_RULES based on exadata model) and the difference 
Rem                will give us the corrrect Free space in each dom0, that value will be set it in AVAIL_LOCAL_STORAGE_GB.
Rem
Rem    NOTES
Rem      Defines the option to use, 2 options available:
Rem          1.- Will generate a report with the wrong metadata found (not intrusive).
Rem          2.- Will create a backup of the 3 tables to review, 
Rem              Then generate a report with the wrong metadata, 
Rem              Then it will fix corrupted Metadata found, 
Rem              Finally will generate a new report for confirmation.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/asm_ohome_mistmatches_issues.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    caborbon    08/04/25 - ENH 38275662 - Adding rollback queries section
Rem    caborbon    06/11/25 - Created
Rem

SET SERVEROUTPUT ON
SET LINESIZE 4000;
SET PAGESIZE 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report 2.Fix the Data: '

DECLARE 
    userselection VARCHAR2(10);
    backupPosfix VARCHAR2(15);
    TYPE string_array_t IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    rollbackStatements string_array_t;
    indexValue PLS_INTEGER := 0;

    TYPE r_ohome_test_1_results IS RECORD (
        CEIOCID ECS_EXADATA_COMPUTE_NODE.EXASERVICE_ID%TYPE,
        NODE ECS_EXADATA_COMPUTE_NODE.HOSTNAME%TYPE,
        TOTAL_U02_GOLD_SPECS NUMBER,
        TOTAL_SPACE_IN_DOM0 NUMBER,
        TOTAL_FREE_EXPECTED NUMBER,
        TOTAL_FREE_FOUND NUMBER    
    );
    TYPE t_ohome_test_1_results IS TABLE OF r_ohome_test_1_results INDEX BY PLS_INTEGER;
    v_ohome_test_1_results t_ohome_test_1_results;
    i_ohome_1 PLS_INTEGER := 0;


    TYPE r_ohome_test_2_results IS RECORD (
        CEIOCID ECS_EXADATA_COMPUTE_NODE.EXASERVICE_ID%TYPE,
        ALLLOCATIONS_TOTAL_USED NUMBER,
        EXADATA_COMPUTE_TOTAL_USED NUMBER
    );
    TYPE t_ohome_test_2_results IS TABLE OF r_ohome_test_2_results INDEX BY PLS_INTEGER;
    v_ohome_test_2_results t_ohome_test_2_results;
    i_ohome_2 PLS_INTEGER := 0;


    TYPE r_asm_test_1_results IS RECORD (
        CEIOCID ECS_EXADATA_COMPUTE_NODE.EXASERVICE_ID%TYPE,
        EXAUNITDETAILS_TB NUMBER,
        EXAUNITDETAILS_GB NUMBER,
        EXAUNITDETAILS_TB_VS_GB_TEST VARCHAR2(6),
        ALLOCATIONS_GB NUMBER,
        EXAUNITDETAILS_VS_ALLOCATIONS_TEST VARCHAR2(6)    
    );
    TYPE t_asm_test_1_results IS TABLE OF r_asm_test_1_results INDEX BY PLS_INTEGER;
    v_asm_test_1_results t_asm_test_1_results;
    i_asm_1 PLS_INTEGER := 0;

    PROCEDURE createRollbackQueries(rollbackQuery IN VARCHAR2) IS
    BEGIN
        indexValue := indexValue + 1;
        rollbackStatements(indexValue) := rollbackQuery;

    END createRollbackQueries; 


    PROCEDURE getOracleASMInformation(s_ocid IN VARCHAR2, issuesFound OUT BOOLEAN, apply_fix IN BOOLEAN) IS
        CURSOR C_ASM_QUERY IS
            SELECT 
                SUM(TB_STORAGE) EXAUNITDETAILS_TB,
                SUM(GB_STORAGE) EXAUNITDETAILS_GB,
                CASE WHEN TO_NUMBER(SUM(TB_STORAGE))*1024 = TO_NUMBER(SUM(GB_STORAGE)) THEN 'TRUE' ELSE 'FALSE' END AS EXAUNITDETAILS_TB_VS_GB_TEST,
                ALLOC.STORAGEGB ALLOCATIONS_GB,
                CASE WHEN ALLOC.STORAGEGB = SUM(GB_STORAGE) THEN 'TRUE' ELSE 'FALSE' END AS EXAUNITDETAILS_VS_ALLOCATIONS_TEST
            FROM
                ECS_RACKS RACKS
                INNER JOIN
                ECS_CEIDETAILS INFRAS
                ON RACKS.EXADATA_ID = INFRAS.RACKNAME AND MULTIVM = 'true' AND INFRAS.CEIOCID = s_ocid
                INNER JOIN 
                ECS_EXAUNITDETAILS EXAUNITS
                ON RACKS.EXAUNITID = EXAUNITS.EXAUNIT_ID
                INNER JOIN
                ECS_EXASERVICE_ALLOCATIONS ALLOC
                ON ALLOC.EXASERVICE_ID = INFRAS.CEIOCID
            WHERE
                EXAUNITID IS NOT NULL
                AND
                EXAUNITS.STORAGE = 'ASM'
            HAVING 
                TO_NUMBER(SUM(TB_STORAGE))*1024 != TO_NUMBER(SUM(GB_STORAGE))
                OR
                ALLOC.STORAGEGB != SUM(GB_STORAGE)
            GROUP BY 
                CEIOCID,
                ALLOC.STORAGEGB;
        R_ASM_RECORD  C_ASM_QUERY%ROWTYPE;
        TYPE T_ASM_TABLE IS TABLE OF R_ASM_RECORD%TYPE; -- must use type
        L_ASM_RESULTS  T_ASM_TABLE;
    BEGIN
        OPEN  C_ASM_QUERY;
        FETCH C_ASM_QUERY BULK COLLECT INTO L_ASM_RESULTS;
        CLOSE C_ASM_QUERY;
        
        
        IF L_ASM_RESULTS.COUNT > 0 THEN
            issuesFound := TRUE;
            FOR i IN 1..L_ASM_RESULTS.COUNT          
            LOOP
                
                i_asm_1 := i_asm_1 + 1;
                v_asm_test_1_results(i_asm_1).CEIOCID := s_ocid;
                v_asm_test_1_results(i_asm_1).EXAUNITDETAILS_TB := L_ASM_RESULTS(i).EXAUNITDETAILS_TB;
                v_asm_test_1_results(i_asm_1).EXAUNITDETAILS_GB := L_ASM_RESULTS(i).EXAUNITDETAILS_GB;
                v_asm_test_1_results(i_asm_1).EXAUNITDETAILS_TB_VS_GB_TEST := L_ASM_RESULTS(i).EXAUNITDETAILS_TB_VS_GB_TEST;
                v_asm_test_1_results(i_asm_1).ALLOCATIONS_GB := L_ASM_RESULTS(i).ALLOCATIONS_GB;
                v_asm_test_1_results(i_asm_1).EXAUNITDETAILS_VS_ALLOCATIONS_TEST := L_ASM_RESULTS(i).EXAUNITDETAILS_VS_ALLOCATIONS_TEST;

                IF apply_fix THEN
                    IF L_ASM_RESULTS(i).EXAUNITDETAILS_TB_VS_GB_TEST = 'FALSE' THEN
                        UPDATE ECS_EXAUNITDETAILS SET TB_STORAGE = GB_STORAGE/1024
                        WHERE EXAUNIT_ID IN (
                            SELECT EXAUNIT_ID FROM ECS_RACKS RACKS
                            INNER JOIN ECS_CEIDETAILS INFRAS
                            ON RACKS.EXADATA_ID = INFRAS.RACKNAME AND MULTIVM = 'true' AND INFRAS.CEIOCID = s_ocid
                            INNER JOIN ECS_EXAUNITDETAILS EXAUNITS
                            ON RACKS.EXAUNITID = EXAUNITS.EXAUNIT_ID); 
                    END IF;
                    IF L_ASM_RESULTS(i).EXAUNITDETAILS_VS_ALLOCATIONS_TEST = 'FALSE' THEN
                        UPDATE ECS_EXASERVICE_ALLOCATIONS SET STORAGEGB = L_ASM_RESULTS(i).EXAUNITDETAILS_GB
                        WHERE EXASERVICE_ID = s_ocid;
                        -- Created rollback query
                        createRollbackQueries('UPDATE ECS_EXASERVICE_ALLOCATIONS SET STORAGEGB = '''|| L_ASM_RESULTS(i).ALLOCATIONS_GB ||''' WHERE EXASERVICE_ID = ' || s_ocid);
                    END IF; 
                END IF;
            END LOOP;
        ELSE
            issuesFound := FALSE;
        END IF;
    END getOracleASMInformation;


    PROCEDURE getOracleHomeInformationTest2(s_ocid IN VARCHAR2, issuesFoundCheck1 IN BOOLEAN, issuesFoundCheck2 IN OUT BOOLEAN, apply_fix IN BOOLEAN) IS
        CURSOR C_OHOME_QUERY IS
            SELECT 
                USABLE_OHSTORAGEGB AS ALLLOCATIONS_TOTAL_USED,
                sum(LOCAL_STORAGE_GB) AS EXADATA_COMPUTE_TOTAL_USED,
                CASE WHEN USABLE_OHSTORAGEGB != SUM(LOCAL_STORAGE_GB) THEN 'FALSE' ELSE 'TRUE' END AS TEST_EXASERVICE_ALLOCATIONS_PASSED
            FROM 
                ECS_EXADATA_COMPUTE_NODE A 
                INNER JOIN 
                ECS_EXASERVICE_ALLOCATIONS B 
                ON 
                A.EXASERVICE_ID=B.EXASERVICE_ID AND A.EXASERVICE_ID=s_ocid
            HAVING 
                USABLE_OHSTORAGEGB != SUM(LOCAL_STORAGE_GB)
            GROUP BY 
                USABLE_OHSTORAGEGB,A.EXASERVICE_ID;            
        R_OHOME_RECORD  C_OHOME_QUERY%ROWTYPE;
        TYPE T_OHOME_TABLE IS TABLE OF R_OHOME_RECORD%TYPE; -- must use type
        L_OHOME_RESULTS  T_OHOME_TABLE;
    BEGIN
        OPEN  C_OHOME_QUERY;
        FETCH C_OHOME_QUERY BULK COLLECT INTO L_OHOME_RESULTS;
        CLOSE C_OHOME_QUERY;
        
        IF L_OHOME_RESULTS.COUNT > 0 THEN
            issuesFoundCheck2 := TRUE;
            FOR i IN 1..L_OHOME_RESULTS.COUNT          
            LOOP
                i_ohome_2 := i_ohome_2 + 1;
                v_ohome_test_2_results(i_ohome_2).CEIOCID := s_ocid;
                v_ohome_test_2_results(i_ohome_2).ALLLOCATIONS_TOTAL_USED := L_OHOME_RESULTS(i).ALLLOCATIONS_TOTAL_USED;
                v_ohome_test_2_results(i_ohome_2).EXADATA_COMPUTE_TOTAL_USED := L_OHOME_RESULTS(i).EXADATA_COMPUTE_TOTAL_USED;

                IF apply_fix THEN
                    UPDATE ECS_EXASERVICE_ALLOCATIONS SET USABLE_OHSTORAGEGB = L_OHOME_RESULTS(i).EXADATA_COMPUTE_TOTAL_USED
                    WHERE EXASERVICE_ID = s_ocid;
                    createRollbackQueries('UPDATE ECS_EXASERVICE_ALLOCATIONS SET USABLE_OHSTORAGEGB = '''|| L_OHOME_RESULTS(i).ALLLOCATIONS_TOTAL_USED ||''' WHERE EXASERVICE_ID = ' || s_ocid);
                END IF; 
            END LOOP;
        END IF;
    END getOracleHomeInformationTest2;

    
    PROCEDURE getOracleHomeInformation(s_ocid IN VARCHAR2, issuesFound OUT BOOLEAN, apply_fix IN BOOLEAN) IS
        CURSOR C_OHOME_QUERY IS
            SELECT 
                NODE,
                SUM(TOTAL_USED) AS TOTAL_USED_U02_AND_GOLD_SPECS,
                TOTAL_SPACE TOTAL_SPACE_IN_DOM0,
                TOTAL_SPACE - SUM(TOTAL_USED) TOTAL_FREE_EXPECTED,
                AVAIL_LOCAL_STORAGE_GB TOTAL_FREE_FOUND,
                CASE WHEN AVAIL_LOCAL_STORAGE_GB = TOTAL_SPACE - SUM(TOTAL_USED) THEN 'TRUE' ELSE 'FALSE' END TEST_PASSED
            FROM 
               (SELECT 
                    GOLD_SPECS.CEIOCID,
                    SUBSTR(VCOMPUTE.EXACOMPUTE_HOSTNAME, 1, INSTR(VCOMPUTE.EXACOMPUTE_HOSTNAME, '.') - 1) NODE,
                    (SUM(CASE WHEN LOWER(NAME) IN ('/','/var') THEN CURRENT_VALUE_GB*2 ELSE CURRENT_VALUE_GB END)) 
                    + (SELECT GB_OHSIZE FROM ECS_EXAUNITDETAILS DETAILS WHERE DETAILS.EXAUNIT_ID = GOLD_SPECS.EXAUNIT_ID) AS TOTAL_USED,
                    (SELECT 
                        USEABLEOHSPACEINGB
                    FROM 
                        ECS_OH_SPACE_RULE
                    WHERE 
                        MODEL = (SELECT MODEL FROM ECS_CEIDETAILS WHERE CEIOCID = GOLD_SPECS.CEIOCID)
                        AND
                        RACKSIZE = 'ALL'
                        AND
                        ENV = 'bm' ) AS TOTAL_SPACE
                FROM 
                    (SELECT 
                        INFRAS.CEIOCID,
                        GOLD_SPECS.EXAUNIT_ID,
                        GOLD_SPECS.TARGET_MACHINE_NAME,
                        GOLD_SPECS.NAME,
                        SUM(CASE
                            WHEN INSTR(CURRENT_VALUE,'T') > 0 THEN TO_NUMBER(REPLACE(CURRENT_VALUE,'T'))*1024
                            WHEN INSTR(CURRENT_VALUE,'G') > 0 THEN TO_NUMBER(REPLACE(CURRENT_VALUE,'G'))
                            WHEN INSTR(CURRENT_VALUE,'M') > 0 THEN TO_NUMBER(REPLACE(CURRENT_VALUE,'M'))*0.0009765625
                            ELSE TO_NUMBER(CURRENT_VALUE)
                        END) AS CURRENT_VALUE_GB 
                    FROM 
                        ECS_GOLD_SPECS GOLD_SPECS
                        INNER JOIN 
                        ECS_RACKS RACKS
                        ON GOLD_SPECS.EXAUNIT_ID = RACKS.EXAUNITID
                        INNER JOIN
                        ECS_CEIDETAILS INFRAS
                        ON RACKS.EXADATA_ID = INFRAS.RACKNAME AND INFRAS.CEIOCID = s_ocid
                    WHERE
                        (MUTABLE = 'true' OR GOLD_SPECS.NAME = 'nonMutableMountpoints')
                        AND
                        LOWER(TARGET_MACHINE) = 'domu'
                        AND
                        LOWER(VALIDATION_TYPE) = 'filesystem'
                    GROUP BY 
                        INFRAS.CEIOCID, EXAUNIT_ID, TARGET_MACHINE_NAME, GOLD_SPECS.NAME 
                    ) GOLD_SPECS
                    INNER JOIN 
                    ECS_EXADATA_VCOMPUTE_NODE VCOMPUTE ON VCOMPUTE.HOSTNAME_CUSTOMER = TARGET_MACHINE_NAME
                GROUP BY
                    GOLD_SPECS.CEIOCID,
                    GOLD_SPECS.EXAUNIT_ID, 
                    VCOMPUTE.EXACOMPUTE_HOSTNAME
                ) GOLD_EXAUNIT
            INNER JOIN
                ECS_EXADATA_COMPUTE_NODE
                ON INVENTORY_ID = NODE
            HAVING 
                AVAIL_LOCAL_STORAGE_GB != TOTAL_SPACE - SUM(TOTAL_USED)
            GROUP BY 
                NODE, 
                TOTAL_SPACE,
                AVAIL_LOCAL_STORAGE_GB
            ORDER BY
                NODE;
        R_OHOME_RECORD  C_OHOME_QUERY%ROWTYPE;
        TYPE T_OHOME_TABLE IS TABLE OF R_OHOME_RECORD%TYPE; -- must use type
        L_OHOME_RESULTS  T_OHOME_TABLE;
    BEGIN
        OPEN  C_OHOME_QUERY;
        FETCH C_OHOME_QUERY BULK COLLECT INTO L_OHOME_RESULTS;
        CLOSE C_OHOME_QUERY;

        IF L_OHOME_RESULTS.COUNT > 0 THEN
            issuesFound := TRUE; 
            FOR i IN 1..L_OHOME_RESULTS.COUNT          
            LOOP
                i_ohome_1 := i_ohome_1 + 1;
                v_ohome_test_1_results(i_ohome_1).CEIOCID := s_ocid;
                v_ohome_test_1_results(i_ohome_1).NODE := L_OHOME_RESULTS(i).NODE;
                v_ohome_test_1_results(i_ohome_1).TOTAL_U02_GOLD_SPECS := L_OHOME_RESULTS(i).TOTAL_USED_U02_AND_GOLD_SPECS;
                v_ohome_test_1_results(i_ohome_1).TOTAL_SPACE_IN_DOM0 := L_OHOME_RESULTS(i).TOTAL_SPACE_IN_DOM0;
                v_ohome_test_1_results(i_ohome_1).TOTAL_FREE_EXPECTED := L_OHOME_RESULTS(i).TOTAL_FREE_EXPECTED;
                v_ohome_test_1_results(i_ohome_1).TOTAL_FREE_FOUND := L_OHOME_RESULTS(i).TOTAL_FREE_FOUND;
                IF apply_fix THEN
                    UPDATE ECS_EXADATA_COMPUTE_NODE SET AVAIL_LOCAL_STORAGE_GB = L_OHOME_RESULTS(i).TOTAL_FREE_EXPECTED 
                    WHERE INVENTORY_ID = L_OHOME_RESULTS(i).NODE;

                    createRollbackQueries('UPDATE ECS_EXADATA_COMPUTE_NODE SET AVAIL_LOCAL_STORAGE_GB = '''|| L_OHOME_RESULTS(i).TOTAL_FREE_FOUND ||''' WHERE INVENTORY_ID = ' || L_OHOME_RESULTS(i).NODE);
                END IF;
            END LOOP;
        ELSE
            issuesFound := FALSE;
        END IF;
    END getOracleHomeInformation;
    
    PROCEDURE mainMethod(reallyRun BOOLEAN) IS
        totalInfrasReviewedCount NUMBER;
        totalInfrasWithIssuesCount NUMBER;
        oHomeIssuesFound BOOLEAN;
        ASMIssuesFound BOOLEAN;
        oHomeIssuesFoundV2 BOOLEAN;
        result1 NUMBER;
    BEGIN 
        totalInfrasReviewedCount := 0;
        totalInfrasWithIssuesCount := 0;
        oHomeIssuesFound := FALSE;
        ASMIssuesFound := FALSE;
        oHomeIssuesFoundV2 := FALSE;
        DBMS_OUTPUT.PUT_LINE('==================================== Reviewing ====================================');
        FOR ceiRecord IN 
            (select CEIOCID, RACKNAME FROM ecs_ceidetails WHERE multivm='true')
        LOOP

                DBMS_OUTPUT.PUT_LINE('Analyzing infrastructure: ' || ceiRecord.CEIOCID);
                DBMS_OUTPUT.PUT_LINE('Rackname: '|| ceiRecord.RACKNAME );
                getOracleHomeInformation(ceiRecord.CEIOCID,oHomeIssuesFound,reallyRun);
                getOracleHomeInformationTest2(ceiRecord.CEIOCID,oHomeIssuesFound,oHomeIssuesFoundV2,reallyRun);
                getOracleASMInformation(ceiRecord.CEIOCID,ASMIssuesFound,reallyRun);
                totalInfrasReviewedCount := totalInfrasReviewedCount + 1;
                IF oHomeIssuesFound OR ASMIssuesFound OR oHomeIssuesFoundV2 THEN 
                    totalInfrasWithIssuesCount := totalInfrasWithIssuesCount +1;
                    DBMS_OUTPUT.PUT_LINE('Result?: ERRORS Found');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Result?: CORRECT');
                END IF;
                oHomeIssuesFound := FALSE;
                ASMIssuesFound := FALSE;
                oHomeIssuesFoundV2 := FALSE;
                DBMS_OUTPUT.PUT_LINE('------------------------------------');
            
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('===================================== Summary =====================================');
        DBMS_OUTPUT.PUT_LINE('Total Infrastructures reviewed: '||totalInfrasReviewedCount);
        DBMS_OUTPUT.PUT_LINE('Total Infrastructures with problems: '||totalInfrasWithIssuesCount);
        IF totalInfrasWithIssuesCount = 0  THEN
            DBMS_OUTPUT.PUT_LINE(chr(10)||'Infrastructures with Metadata issue about ASM or oHome were not found.');
        END IF;
        DBMS_OUTPUT.PUT_LINE(chr(10));
        IF i_ohome_1 > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Ohome First Test');
            DBMS_OUTPUT.PUT_LINE(
                RPAD('CEIOCID', 110) 
                ||RPAD('NODE', 25) 
                ||RPAD('TOTAL_U02_GOLD_SPECS', 25) 
                ||RPAD('TOTAL_SPACE_IN_DOM0', 25)
                ||RPAD('TOTAL_FREE_EXPECTED',25)
                ||RPAD('TOTAL_FREE_FOUND',22));
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 125, '-'));
            FOR j IN 1 .. i_ohome_1 LOOP
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_ohome_test_1_results(j).CEIOCID, 110)
                    ||RPAD(v_ohome_test_1_results(j).NODE, 25)
                    ||RPAD(v_ohome_test_1_results(j).TOTAL_U02_GOLD_SPECS, 25) 
                    ||RPAD(v_ohome_test_1_results(j).TOTAL_SPACE_IN_DOM0, 25) 
                    ||RPAD(v_ohome_test_1_results(j).TOTAL_FREE_EXPECTED, 25) 
                    ||RPAD(v_ohome_test_1_results(j).TOTAL_FREE_FOUND, 22));
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(chr(10));
            v_ohome_test_1_results.DELETE;
            i_ohome_1 := 0;
        END IF;

        IF i_ohome_2 > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Ohome Second Test');
            DBMS_OUTPUT.PUT_LINE(
                RPAD('CEIOCID', 110)
                ||RPAD('ALLLOCATIONS_TOTAL_USED', 35) 
                ||RPAD('EXADATA_COMPUTE_TOTAL_USED', 35));
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 180, '-'));
            FOR j IN 1 .. i_ohome_2 LOOP
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_ohome_test_2_results(j).CEIOCID, 110)
                    ||RPAD(v_ohome_test_2_results(j).ALLLOCATIONS_TOTAL_USED, 35) 
                    ||RPAD(v_ohome_test_2_results(j).EXADATA_COMPUTE_TOTAL_USED, 35));
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(chr(10));
            v_ohome_test_2_results.DELETE;
            i_ohome_2 := 0;
        END IF;

        IF i_asm_1 > 0 THEN
            DBMS_OUTPUT.PUT_LINE('ASM Test');
            DBMS_OUTPUT.PUT_LINE(
                RPAD('CEIOCID', 110) 
                ||RPAD('EXAUNITDETAILS_TB', 25) 
                ||RPAD('EXAUNITDETAILS_GB', 25)
                ||RPAD('EXAUNITDETAILS_TB_VS_GB_TEST',35)
                ||RPAD('ALLOCATIONS_GB',25)
                ||RPAD('EXAUNITDETAILS_VS_ALLOCATIONS_TEST',40));
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 180, '-'));
            FOR j IN 1 .. i_asm_1 LOOP
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_asm_test_1_results(j).CEIOCID, 110)
                    ||RPAD(v_asm_test_1_results(j).EXAUNITDETAILS_TB, 25)
                    ||RPAD(v_asm_test_1_results(j).EXAUNITDETAILS_GB, 25) 
                    ||RPAD(v_asm_test_1_results(j).EXAUNITDETAILS_TB_VS_GB_TEST, 35) 
                    ||RPAD(v_asm_test_1_results(j).ALLOCATIONS_GB, 25) 
                    ||RPAD(v_asm_test_1_results(j).EXAUNITDETAILS_VS_ALLOCATIONS_TEST, 40));
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(chr(10));
            v_asm_test_1_results.DELETE;
            i_asm_1 := 0;
        END IF;


    END mainMethod;

    PROCEDURE createBackup(tableName IN VARCHAR2) IS
    ceiBkpTable varchar2(1024);
    nodesBkpTable varchar2(1024);
    BEGIN
        nodesBkpTable:= tableName || '_' || backupPosfix;
        EXECUTE IMMEDIATE 'CREATE TABLE '||nodesBkpTable||' AS (select * from ' || tableName || ')';
        DBMS_OUTPUT.PUT_LINE(tableName || ' backup table: '||nodesBkpTable);
        COMMIT;
    END createBackup; 

    PROCEDURE printRollbackQueries IS
    BEGIN
        FOR i IN 1 .. indexValue LOOP
            IF rollbackStatements.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(rollbackStatements(i));
            END IF;
        END LOOP;
   END printRollbackQueries;

BEGIN
    userselection := '&userselectionprompt';
    DBMS_OUTPUT.PUT_LINE('====================================== BEGIN ======================================');
    IF userselection = 1 THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Executing prechecks...');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        mainMethod(FALSE);
    ELSIF userselection = 2 THEN
        backupPosfix := TO_CHAR(Sysdate, 'HH24_MI_SS');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Creating backup...');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        createBackup('ECS_EXASERVICE_ALLOCATIONS');
        createBackup('ECS_EXAUNITDETAILS');
        createBackup('ECS_EXADATA_COMPUTE_NODE');
        
        mainMethod(TRUE);
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Fixing issues ...');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Creating new report ...');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        mainMethod(FALSE);
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Printing rollback queries ...');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        printRollbackQueries;
    ELSE
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('Invalid option...');
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
    END IF;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('======================================  END  ======================================');
    
END;
/


