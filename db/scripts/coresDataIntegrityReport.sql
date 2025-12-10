Rem
Rem $Header: ecs/ecra/db/scripts/coresDataIntegrityReport.sql /main/3 2024/03/22 02:21:35 caborbon Exp $
Rem
Rem coresDataIntegrityReport.sql
Rem
Rem Copyright (c) 2023, 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      coresDataIntegrityReport.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script will show a list of MVM Infrastructures where core information is
Rem      not healthy and need to be repair, to avoid future issues.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/coresDataIntegrityReport.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    caborbon    03/21/24 - Bug 36380593 - Minor changes in the output format
Rem    caborbon    03/12/24 - Bug 36334557 - Adding fix option
Rem    caborbon    11/15/23 - Created
Rem
SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Execute Precheck, 2. Execute Fix script ? (1/2):  '

DECLARE

    userselection varchar2(10);

    PROCEDURE precheckAndFix(apply_fix BOOLEAN) IS
        provisionedInfras   NUMBER;
        computesSum         NUMBER;
        computeCount        NUMBER;
        computeCores        NUMBER;
        nw_aliasname        VARCHAR2(256);
        node_name           VARCHAR2(64);
        viewTotalCores      NUMBER;
        viewNodeCores       NUMBER;
        nodewise_a          JSON_ARRAY_T;
        nodewise_obj        JSON_OBJECT_T;
        flag_issue_found                BOOLEAN := FALSE;
        flag_wisealloc_issue_found      BOOLEAN := FALSE;
        flag_perform_update             BOOLEAN := FALSE;
        flag_backup_created             BOOLEAN := FALSE;
        nodewise_old        CLOB;
        nodewise_new        CLOB;
        current_cores       NUMBER;
        current_memory      NUMBER;
        current_ohome       NUMBER;
        current_storage     NUMBER;

    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        ceiBkpTable varchar2(1024);
        nodesBkpTable varchar2(1024);
    BEGIN
        IF NOT flag_backup_created THEN
            timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
            nodesBkpTable:='ECS_EXASERVICE_ALLOCATIONS_'||timeStr;

            EXECUTE IMMEDIATE 'CREATE TABLE '||nodesBkpTable||' AS (select * from ECS_EXASERVICE_ALLOCATIONS)';
            dbms_output.put_line('ECS_EXASERVICE_ALLOCATIONS backup table: '||nodesBkpTable);
            flag_backup_created := TRUE;
            COMMIT;
        END IF;
    END createBackup;

    PROCEDURE printInfraName(NAME VARCHAR2) IS
    BEGIN
        IF NOT flag_issue_found THEN
            dbms_output.put_line('----------------------------------------------');
            dbms_output.put_line('    INFRA''s NAME: ' || NAME);
            dbms_output.put_line('----------------------------------------------');
        END IF;
    END printInfraName;

    BEGIN
        SELECT COUNT(*) INTO provisionedInfras FROM ecs_ceidetails
            WHERE fsm_state='PROVISIONED' AND multivm ='true';
        dbms_output.put_line('          Total PROVISIONED MVM infrastructures: ' || provisionedInfras );
        dbms_output.put_line('====================================================================================================================');
        dbms_output.put_line('');
        dbms_output.put_line('');

        FOR ceiRecord IN (SELECT cei.*, allocation.* FROM ecs_ceidetails cei
            LEFT JOIN ECS_EXASERVICE_ALLOCATIONS allocation ON cei.ceiocid = allocation.EXASERVICE_ID
            WHERE cei.fsm_state='PROVISIONED' AND cei.multivm ='true')
        LOOP
            flag_issue_found := false;
            --====================================
            --Validate ECS_EXADATA_COMPUTE_NODE Sum vs ECS_EXASERVICE_ALLOCATIONS.
            --====================================
            SELECT SUM(ALLOCATED_PURCHASED_CORES) INTO computesSum FROM ECS_EXADATA_COMPUTE_NODE
                WHERE EXASERVICE_ID=ceiRecord.ceiocid;

            IF computesSum <> ceiRecord.METERED_CORES THEN
                printInfraName(ceiRecord.ceiocid);
                dbms_output.put_line('    - Mismatch in ECS_EXADATA_COMPUTE_NODE ' || computesSum || ' cores VS ' || ceiRecord.METERED_CORES || ' cores ECS_EXASERVICE_ALLOCATIONS');
                flag_issue_found := true;
            END IF;


            --====================================
            --Validate ECS_EXASERVICE_ALLOCATIONS vs ECS_V_MVM_EXASERVICE(view)
            --====================================
            SELECT ALLOCATED_CORES INTO viewTotalCores FROM ECS_V_MVM_EXASERVICE
                WHERE ID=ceiRecord.ceiocid;

            IF viewTotalCores <> ceiRecord.METERED_CORES THEN
                printInfraName(ceiRecord.ceiocid);
                dbms_output.put_line('    - Mismatch in ECS_V_MVM_EXASERVICE '||viewTotalCores|| ' cores VS ' || ceiRecord.METERED_CORES || 'cores ECS_EXASERVICE_ALLOCATIONS');
                flag_issue_found := true;
            END IF;


            --====================================
            --Validate ECS_EXADATA_COMPUTE_NODE vs ECS_V_MVM_COMPUTES(view)
            --====================================
            FOR computeNodeRecord IN (SELECT INVENTORY_ID,ALLOCATED_PURCHASED_CORES
                FROM ECS_EXADATA_COMPUTE_NODE WHERE EXASERVICE_ID=ceiRecord.ceiocid)
            LOOP
                SELECT ALLOCATED_CORES INTO viewNodeCores FROM ECS_V_MVM_COMPUTES
                    WHERE NODE=computeNodeRecord.INVENTORY_ID;

                IF viewNodeCores <> computeNodeRecord.ALLOCATED_PURCHASED_CORES THEN
                    printInfraName(ceiRecord.ceiocid);
                    dbms_output.put_line('    - Mismatch in ECS_V_MVM_COMPUTES '|| viewNodeCores || ' cores VS ' || computeNodeRecord.ALLOCATED_PURCHASED_CORES || ' cores ECS_EXADATA_COMPUTE_NODE');
                    flag_issue_found := true;
                END IF;

            END LOOP;

            --====================================
            --Validate ECS_CORES vs ECS_V_MVM_DOMUS(view)
            --====================================
            FOR computeNodeRecord IN (SELECT NODE, SUM(CORES) VIEW_CORES, SUM(METEROCPUS) CORES
                FROM ECS_CORES INNER JOIN ECS_V_MVM_DOMUS ON HOSTNAME = HOSTNAME_CUSTOMER
                WHERE EXASERVICE_ID=ceiRecord.ceiocid GROUP BY NODE)
            LOOP
                IF computeNodeRecord.CORES <> computeNodeRecord.VIEW_CORES THEN
                    printInfraName(ceiRecord.ceiocid);
                    dbms_output.put_line('    - Mismatch in node ' || computeNodeRecord.NODE || ' ->  ECS_V_MVM_DOMUS '|| computeNodeRecord.VIEW_CORES || ' cores VS '|| computeNodeRecord.CORES || ' cores ECS_CORES' );
                    flag_issue_found := true;
                END IF;
            END LOOP;

            --====================================
            --Validate NODE_WISE_ALLOCATIONS vs ECS_EXADATA_COMPUTE_NODE
            --====================================
            SELECT count(*) INTO computeCount FROM ECS_EXADATA_COMPUTE_NODE
                WHERE EXASERVICE_ID=ceiRecord.ceiocid;

            nodewise_a := JSON_ARRAY_T.parse(ceiRecord.NODE_WISE_ALLOCATIONS);

            FOR i IN 0 .. nodewise_a.get_size - 1
            LOOP
                nodewise_obj := JSON_OBJECT_T(nodewise_a.get(i));
                nw_aliasname := nodewise_obj.get_String('nodeAlias');

                SELECT ALLOCATED_PURCHASED_CORES into computeCores from ECS_EXADATA_COMPUTE_NODE computenode
                    WHERE computenode.EXASERVICE_ID=ceiRecord.ceiocid AND computenode.ALIASNAME=nw_aliasname;
                IF computeCores <> nodewise_obj.get_Number('allocatedCores') THEN
                    printInfraName(ceiRecord.ceiocid);
                    dbms_output.put_line('    - Mismatch in NODE_WISE_ALLOCATIONS Node: '|| nodewise_obj.get_String('hostname') ||' -> NODE_WISE_ALLOCATIONS '|| nodewise_obj.get_Number('allocatedCores')||' cores VS ' || computeCores || ' cores ECS_EXADATA_COMPUTE_NODE ');
                    flag_wisealloc_issue_found := true;
                    flag_issue_found := true;
                END IF;

            END LOOP;

            --====================================
            -- FIX NODE_WISE_ALLOCATIONS issues
            --====================================
            IF flag_wisealloc_issue_found AND apply_fix THEN
                dbms_output.put_line('Creating  backup...' );
                createBackup();
                dbms_output.put_line('Fixing node wise allocations ...' );
                nodewise_a := JSON_ARRAY_T.parse(ceiRecord.NODE_WISE_ALLOCATIONS);
                nodewise_old := ceiRecord.NODE_WISE_ALLOCATIONS;
                flag_perform_update := false;
                FOR i IN 0 .. nodewise_a.get_size - 1
                LOOP
                    nodewise_obj := JSON_OBJECT_T(nodewise_a.get(i));
                    nw_aliasname := nodewise_obj.get_String('nodeAlias');
                    
                    SELECT ALLOCATED_PURCHASED_CORES, MEMORY_GB, LOCAL_STORAGE_GB INTO current_cores, current_memory, current_ohome from ECS_EXADATA_COMPUTE_NODE computenode
                    WHERE computenode.EXASERVICE_ID=ceiRecord.ceiocid AND computenode.ALIASNAME=nw_aliasname;

                    IF current_cores <> nodewise_obj.get_Number('allocatedCores') THEN
                        dbms_output.put_line('Fixing Core in JSON, old value: '|| nodewise_obj.get_Number('allocatedCores')  || ' - new value: ' || current_cores );
                        nodewise_obj.put('allocatedCores',current_cores);
                        flag_perform_update := true;
                        nodewise_a.put(i,nodewise_obj,TRUE);
                    END IF;
                    

                END LOOP;
                IF flag_perform_update THEN
                        nodewise_new := nodewise_a.to_string;
                        UPDATE ECS_EXASERVICE_ALLOCATIONS SET NODE_WISE_ALLOCATIONS = nodewise_new WHERE EXASERVICE_ID = ceiRecord.EXASERVICE_ID;
                        COMMIT;
                        dbms_output.put_line('=======================================================');
                        dbms_output.put_line('---- Old JSON:');
                        dbms_output.put_line('');
                        dbms_output.put_line(nodewise_old);
                        dbms_output.put_line('---- New JSON:');
                        dbms_output.put_line('');
                        dbms_output.put_line(nodewise_new);
                        dbms_output.put_line('=======================================================');
                END IF;
            ELSIF NOT flag_wisealloc_issue_found THEN
		 printInfraName(ceiRecord.ceiocid);
                 dbms_output.put_line('WISE ALLOCATIONS CORRECT, NO NEED TO PERFORM ANY FIX');
            END IF;
        END LOOP;

    END precheckAndFix;

    

    BEGIN
        dbms_output.put_line('====================================================================================================================');
        userselection := '&userselectionprompt';
        IF userselection = 1 THEN
            dbms_output.put_line('          Executing only report...' );
            precheckAndFix(FALSE);
        ELSIF userselection = 2 THEN
            dbms_output.put_line('          Executing Pre-check validations ...' );
            precheckAndFix(TRUE);
        ELSE
            dbms_output.put_line('          Invalid option...' );
            dbms_output.put_line('====================================================================================================================');
        END IF;
    END;
/
