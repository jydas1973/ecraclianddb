Rem
Rem $Header: ecs/ecra/db/scripts/elasticShapeMigration.sql /main/1 2023/05/31 22:09:05 llmartin Exp $
Rem
Rem elasticShapeMigration.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      elasticShapeMigration.sql -ELASTIC SHAPE CREATE SCRIPT TO MIGRATE CURRENT CLUSTERS
Rem
Rem    DESCRIPTION
Rem      
Rem
Rem    NOTES
Rem      
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/elasticShapeMigration.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    llmartin    12/19/21 - Validate more than one CEI record
Rem    llmartin    12/19/21 - Backup tables
Rem    llmartin    12/16/21 - Update metadata if new OCID is found
Rem    llmartin    11/23/21 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Execute Precheck, 2. Execute Migration ? (1/2):  '

DECLARE 
    userselection varchar2(10);
    precheckPassed BOOLEAN;

    FUNCTION getCEI (i_rackname VARCHAR2) RETURN VARCHAR2 IS 
        infrastructureocid VARCHAR2(1024);
    BEGIN
        SELECT dbsystem_id INTO infrastructureocid FROM ecs_atpcustomertenancy WHERE rackname = i_rackname;
        
        IF infrastructureocid LIKE '%cloudexadatainfrastructure%' THEN
            RETURN infrastructureocid;
        END IF;

        FOR nodeRecord IN (SELECT ceiocid FROM ecs_hw_nodes WHERE ecs_racks_name_list LIKE '%'||i_rackname||'%' 
            AND Node_Type IN ('COMPUTE','CELL') AND ceiocid IS NOT NULL 
            AND ceiocid <> infrastructureocid AND ceiocid LIKE '%cloudexadatainfrastructure%')
        LOOP
            infrastructureocid := nodeRecord.ceiocid;
        END LOOP;
        
        RETURN infrastructureocid;
    END getCEI;
    
    
    FUNCTION precheck RETURN BOOLEAN IS
        provisionedRacks NUMBER;
        missingCustomerInfo NUMBER;
        errorFound BOOLEAN;
        errorStr VARCHAR2(4096);
        currentInfraOcid VARCHAR2(1024);
        currentInfraOcidTMP VARCHAR2(1024);
        incorrectNodes NUMBER;
        incorrectInfra NUMBER;
        incorrectRack NUMBER;
        
    BEGIN
        SELECT COUNT(*) INTO provisionedRacks FROM ecs_racks racks 
            LEFT JOIN ecs_exaunitdetails details ON racks.exaunitid = details.exaunit_id 
            WHERE racks.status='PROVISIONED' AND racks.model LIKE 'X%M-2' AND details.atp ='N';
        dbms_output.put_line('Total PROVISIONED KVM non-ATP racks: ' || provisionedRacks );
        
        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks
            LEFT JOIN ecs_exaunitdetails details ON racks.exaunitid = details.exaunit_id
            WHERE racks.status='PROVISIONED' AND racks.model LIKE 'X%M-2' AND details.atp ='N')
        LOOP
            
            --====================================
            --Validate ecs_atpcustomertenancy data
            --====================================
            SELECT COUNT(*) INTO missingCustomerInfo FROM ecs_racks 
                LEFT JOIN ecs_atpcustomertenancy ON ecs_racks.name = ecs_atpcustomertenancy.rackname 
                WHERE ecs_atpcustomertenancy.dbsystem_id IS NOT NULL AND ecs_racks.name = rackRecord.name;
            IF missingCustomerInfo = 0 THEN
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    ERROR: Missing ecs_atpcustomertenancy record(s)');
                errorFound:=TRUE;
                CONTINUE;     
            ELSIF missingCustomerInfo > 1 THEN
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    ERROR: More than one ecs_atpcustomertenancy records found');
                errorFound:=TRUE;
                CONTINUE;
            END IF;
            
            --====================================
            --Warn about the  CEI OCID that will be used
            --====================================
            SELECT dbsystem_id INTO currentInfraOcid FROM ecs_atpcustomertenancy WHERE rackname = rackRecord.name;
            currentInfraOcidTMP := getCEI(rackRecord.name);
            
            IF currentInfraOcid <> currentInfraOcidTMP THEN
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    WARNING: New ExadataInfrastructure OCID found in ECS_HW_NODES table');
                dbms_output.put_line('    Previous OCID: '|| currentInfraOcid);
                dbms_output.put_line('    New OCID:      '|| currentInfraOcidTMP);
                currentInfraOcid := currentInfraOcidTMP;
            END IF;
            
            --====================================
            --Validate OCID format
            --====================================
            IF currentInfraOcid NOT LIKE '%cloudexadatainfrastructure%' THEN
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    WARNING: Exadata OCID '|| currentInfraOcid||' do not match the expected OCID format. ');
            END IF;

            --====================================
            --Warn about ECS_HW_NODES data updates
            --====================================
            SELECT COUNT(*) INTO incorrectNodes FROM ecs_hw_nodes 
                WHERE ecs_racks_name_list LIKE '%'||rackRecord.name||'%' 
                    AND Node_Type IN ('COMPUTE','CELL') 
                    AND ceiocid IS NOT NULL AND ceiocid <> currentInfraOcid;
            
            IF incorrectNodes > 0 THEN
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    WARNING: '|| incorrectNodes || ' node(s) will be updated to a new OCID');
                errorFound:=TRUE;
            END IF;
            
            --====================================
            --Validate ECS_ELASTIC_CEIDETAILS data
            --====================================
            SELECT COUNT(*) INTO incorrectRack FROM ECS_ELASTIC_CEIDETAILS 
                WHERE CEIOCID = currentInfraOcid AND rackname <> rackRecord.name;
            
            IF incorrectRack >0 THEN 
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    ERROR: Infrastructure registered with a different rackname');
                errorFound:=TRUE;
                CONTINUE;
            END IF;

            --====================================
            --Validate ECS_ELASTIC_CEIDETAILS number of records
            --====================================
            SELECT COUNT(*) INTO incorrectRack FROM ECS_ELASTIC_CEIDETAILS 
            WHERE rackname = rackRecord.name;
            
            IF incorrectRack >1 THEN 
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    ERROR: more than one record found in ECS_ELASTIC_CEIDETAILS table for rack '||
                    rackRecord.name||', delete the extra record before continuing with the migration');
                errorFound:=TRUE;
                CONTINUE;
            END IF;

            --====================================
            --Warn about ECS_ELASTIC_CEIDETAILS data updates
            --====================================
            SELECT COUNT(*) INTO incorrectInfra FROM ECS_ELASTIC_CEIDETAILS 
                WHERE CEIOCID <> currentInfraOcid AND rackname = rackRecord.name;
            
            IF incorrectInfra >0 THEN 
                dbms_output.put_line(chr(10)||'Rack: ' || rackrecord.name);
                dbms_output.put_line('    WARNING: Infrastructure record will be updated with a new OCID');
                errorFound:=TRUE;
                CONTINUE;
            END IF;
            
        END LOOP;
        
        IF errorFound THEN
            dbms_output.put_line(chr(10)||'Errors were found during the precheck, if you continue with the migration the following actions will be taken:');
            dbms_output.put_line('    1. Racks with missing or multiple records in ecs_atpcustomertenancy table will be ignored.');
            dbms_output.put_line('    2. ExadataInfrastructure OCID found in ECS_HW_NODES table will be used instead of the OCID found in ecs_atpcustomertenancy.');
            dbms_output.put_line('    3. Nodes from ECS_HW_NODES table associated to a different ExadataInfrastructure OCID will be updated.');
        ELSE
            dbms_output.put_line('No Errors were found.');
        END IF;
        
        RETURN FALSE;
    end precheck;

    
    FUNCTION createCEI (i_rackname VARCHAR2) RETURN VARCHAR2 IS 
        infrastructureocid VARCHAR2(1024);
        oldinfrastructureocid VARCHAR2(1024);
        recordCount number;
    BEGIN
        infrastructureocid := getCEI(i_rackname);
        SELECT count(*) INTO recordCount FROM ecs_elastic_ceidetails WHERE RACKNAME = i_rackname;
        IF recordCount = 0 THEN 
            INSERT INTO ecs_elastic_ceidetails (CEIOCID, RACKNAME, RACKNAME_GENERATED) 
            VALUES (infrastructureocid, i_rackname, 0);
            dbms_output.put_line('    New record inserted in ECS_ELASTIC_CEIDETAILS, Rack:'
                ||i_rackname||' CEI:'||infrastructureocid);
        ELSE
            SELECT ceiocid INTO oldinfrastructureocid FROM ecs_elastic_ceidetails WHERE RACKNAME = i_rackname;
            IF oldinfrastructureocid <> infrastructureocid THEN
                UPDATE ecs_elastic_ceidetails SET CEIOCID = infrastructureocid WHERE RACKNAME = i_rackname;
                dbms_output.put_line('    ECS_ELASTIC_CEIDETAILS record updated, old OCID:'
                    ||oldinfrastructureocid||' new OCID:'||infrastructureocid);
            ELSE
                dbms_output.put_line('    No change in ECS_ELASTIC_CEIDETAILS table');
            END IF;
        END IF;
        return infrastructureocid;
    END createCEI;

    PROCEDURE updateNodes(i_rackname varchar2, i_infraocid varchar2) IS
        updatedRecords NUMBER;
    BEGIN
        updatedRecords:=0;
        FOR nodeRecord IN (SELECT * FROM ecs_hw_nodes 
            WHERE ecs_racks_name_list LIKE '%'||i_rackname||'%' AND NODE_TYPE IN ('COMPUTE','CELL')
            AND (ceiocid IS NULL OR ceiocid <> i_infraocid))
        LOOP
            UPDATE ecs_hw_nodes SET ceiocid=i_infraocid WHERE ID=nodeRecord.ID;
            dbms_output.put_line('    Node ID '||nodeRecord.ID||' updated, old OCID:'||
                nodeRecord.ceiocid||' new OCID:'||i_infraocid);
            updatedRecords:= updatedRecords + 1;
        END LOOP;
        
        IF updatedRecords = 0 THEN
            dbms_output.put_line('    No change in ECS_HW_NODES table');
        END IF;
        
    end updateNodes;
    
    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        ceiBkpTable varchar2(1024);
        nodesBkpTable varchar2(1024);
    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
        ceiBkpTable:= 'ECS_ELASTIC_CEIDETAILS'||timeStr;
        nodesBkpTable:='ECS_HW_NODES_'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||ceiBkpTable||' AS (select * from ECS_ELASTIC_CEIDETAILS)';
        EXECUTE IMMEDIATE 'CREATE TABLE '||nodesBkpTable||' AS (select * from ECS_HW_NODES)';
        
        dbms_output.put_line('ECS_ELASTIC_CEIDETAILS backup table: '||ceiBkpTable);
        dbms_output.put_line('ECS_HW_NODES backup table: '||nodesBkpTable);
        COMMIT;
    END createBackup;
    
    PROCEDURE performMigration IS
        infraocid varchar2(1024);
        customerinfo_count number;
        backupname varchar2(1024);
    BEGIN

        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks
            LEFT JOIN ECS_EXAUNITDETAILS details ON racks.exaunitid = details.exaunit_id
            WHERE racks.status='PROVISIONED' AND racks.model LIKE 'X%M-2' AND details.atp ='N')
        LOOP
            SELECT COUNT(*) INTO customerinfo_count FROM ecs_racks 
            LEFT JOIN ecs_atpcustomertenancy ON ecs_racks.name = ecs_atpcustomertenancy.rackname 
            WHERE ecs_atpcustomertenancy.dbsystem_id IS NOT NULL AND ecs_racks.name = rackRecord.name;
        
            IF customerinfo_count <> 1 THEN
                dbms_output.put_line('Skipping '||rackRecord.name||', rack with missing or multiple records in ecs_atpcustomertenancy');
                CONTINUE;
            END IF;

            dbms_output.put_line('Processing rack: ' || rackrecord.name);
            infraocid := createCEI(rackrecord.name);
            updateNodes(rackrecord.name, infraocid);
        END LOOP;
        COMMIT;
    end performMigration;

begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    
    IF userselection = 1 THEN
        dbms_output.put_line('Executing prechecks...' );
        precheckPassed := precheck();
    ELSIF userselection = 2 THEN
        dbms_output.put_line('Creating  backup...' );
        createBackup();
        dbms_output.put_line('Executing migration...' );
        performMigration();
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/