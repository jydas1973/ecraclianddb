Rem
Rem $Header: ecs/ecra/db/scripts/CapacityComputeCellNodeBackfill.sql /main/1 2023/05/12 21:07:14 illamas Exp $
Rem
Rem CapacityComputeCellNodeBackfill.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      CapacityComputeCellNodeBackfill.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/CapacityComputeCellNodeBackfill.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    illamas     05/11/23 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Execute Precheck, 2. Execute Backfill ? (1/2):  '

DECLARE 
    userselection varchar2(10);
    precheckPassed BOOLEAN;

    PROCEDURE updateCapacity(rackname varchar2, nodeType varchar2, model varchar2) IS
    numberOfRecords NUMBER;
    faultdomain varchar2 (500);
    cabinetname varchar2 (500);
    fabricib varchar2 (500);
    BEGIN
        FOR nodeRecord IN (SELECT * from ecs_hw_nodes 
                WHERE ecs_racks_name_list like '%'||rackname||'%' and node_type=nodeType)
        LOOP
            SELECT COUNT(*) INTO numberOfRecords FROM ecs_exadata_capacity 
                WHERE inventory_id=nodeRecord.oracle_hostname;

            IF numberOfRecords = 0 THEN 
                dbms_output.put_line(' Fixing inventory_id [' || nodeRecord.oracle_hostname || '] in exadata capacity' );


                select cabinet.fault_domain into faultdomain from ecs_hw_nodes hw 
                join ecs_hw_cabinets cabinet on cabinet.id=hw.cabinet_id 
                where hw.oracle_hostname=nodeRecord.oracle_hostname;
                
                select cabinet.name into cabinetname from ecs_hw_nodes hw 
                join ecs_hw_cabinets cabinet on cabinet.id=hw.cabinet_id 
                where hw.oracle_hostname=nodeRecord.oracle_hostname;
                
                select fabric_name into fabricib from ecs_ib_fabrics
                where list_of_ibsw like '%'|| lower(cabinetname) || '%';                

                -- dbms_output.put_line( nodeRecord.oracle_hostname || ' ' ||
                --      nodeType || ' ' || 'PROVISIONED' || ' ' || 'ONLINE' ||
                --      faultdomain || ' ' || fabricib || ' ' || model);

                INSERT into ecs_exadata_capacity (INVENTORY_ID,HW_TYPE,STATUS,OPSTATE,FAULT_DOMAIN, FABRIC_NAME,CONFIGURED_MODEL)
                VALUES (nodeRecord.oracle_hostname,nodeType,'PROVISIONED','ONLINE', faultdomain,fabricib,model);
                commit;

            ELSE
                dbms_output.put_line('Skipping insert for inventory_id ['||nodeRecord.oracle_hostname ||'] is already present');
            END IF;

        END LOOP;
    end updateCapacity;


    PROCEDURE updateComputeNode(rackname varchar2) IS
    numberOfRecords NUMBER;
    cabinetdomain varchar2 (500);
    aliasCount NUMBER;
    BEGIN
        aliasCount := 1;
        FOR nodeRecord IN (SELECT * from ecs_hw_nodes 
                WHERE ecs_racks_name_list like '%'||rackname||'%' and node_type='COMPUTE' order by oracle_hostname)
        LOOP
            SELECT COUNT(*) INTO numberOfRecords FROM ecs_exadata_compute_node 
                WHERE exadata_id=rackname and inventory_id=nodeRecord.oracle_hostname;

            IF numberOfRecords = 0 THEN 
                dbms_output.put_line(' Fixing inventory_id [' || nodeRecord.oracle_hostname || '] in exadata compute node' );


                select cabinet.domainname into cabinetdomain from ecs_hw_nodes hw 
                join ecs_hw_cabinets cabinet on cabinet.id=hw.cabinet_id 
                where hw.oracle_hostname=nodeRecord.oracle_hostname;


                INSERT into ecs_exadata_compute_node (HOSTNAME, ALIASNAME,ALLOCATED_PURCHASED_CORES,ALLOCATED_BURST_CORES,MEMORY_GB,LOCAL_STORAGE_GB,EXADATA_ID,AVAIL_LOCAL_STORAGE_GB,INVENTORY_ID,TOTAL_CORES)
                VALUES (nodeRecord.oracle_hostname || '.' || cabinetdomain,'dbserver' || '-' || aliasCount,0,0,0,0,rackname,0,nodeRecord.oracle_hostname,0);
                commit;

            ELSE
                dbms_output.put_line('Skipping insert for inventory_id ['||nodeRecord.oracle_hostname ||'] is already present');
            END IF;

            aliasCount := aliasCount + 1;

        END LOOP;
    end updateComputeNode;


    PROCEDURE updateCellNode(rackname varchar2,model varchar2) IS
    numberOfRecords NUMBER;
    cabinetdomain varchar2 (500);
    BEGIN
        FOR nodeRecord IN (SELECT * from ecs_hw_nodes 
                WHERE ecs_racks_name_list like '%'||rackname||'%' and node_type='CELL' order by oracle_hostname)
        LOOP
            SELECT COUNT(*) INTO numberOfRecords FROM ecs_exadata_cell_node 
                WHERE exadata_id=rackname and inventory_id=nodeRecord.oracle_hostname;

            IF numberOfRecords = 0 THEN 
                dbms_output.put_line(' Fixing inventory_id [' || nodeRecord.oracle_hostname || '] in exadata cell node' );

                select cabinet.domainname into cabinetdomain from ecs_hw_nodes hw 
                join ecs_hw_cabinets cabinet on cabinet.id=hw.cabinet_id 
                where hw.oracle_hostname=nodeRecord.oracle_hostname;

                INSERT into ecs_exadata_cell_node (INVENTORY_ID,LOCAL_STORAGE_GB,CELL_TYPE,MODEL,HOSTNAME,EXADATA_ID) 
                VALUES (nodeRecord.oracle_hostname,0,'highPerformance',model,nodeRecord.oracle_hostname || '.' || cabinetdomain,rackname);
                commit;
            ELSE
                dbms_output.put_line('Skipping insert for inventory_id ['||nodeRecord.oracle_hostname ||'] is already present');
            END IF;
        END LOOP;
    end updateCellNode;
    
    
    PROCEDURE fixMetadata(reallyRun BOOLEAN)  IS
        provisionedRacks NUMBER;
        numberOfComputes NUMBER;
        numberOfCells NUMBER;
        nComputesInComputeNode NUMBER;
        nCellsInCellNode NUMBER;
        computeCapacity NUMBER;
        cellCapacity NUMBER;
        errorFoundCapacityCompute BOOLEAN;
        errorFoundCapacityCell BOOLEAN;
        errorFoundExadataCompute BOOLEAN;
        errorFoundExadataCell BOOLEAN;
        totalRacksAffected NUMBER;
    BEGIN
        totalRacksAffected := 0;
        dbms_output.put_line(chr(10)||'reallyRun: ['|| case
                  when reallyRun then 'TRUE'
                  when reallyRun is null then 'NULL'
                  else 'FALSE'
               end || ']');

        SELECT COUNT(*) INTO provisionedRacks FROM ecs_racks racks 
            LEFT JOIN ecs_exaunitdetails details ON racks.exaunitid = details.exaunit_id 
            WHERE racks.status='PROVISIONED' and racks.name not in (select rackname from ecs_ceidetails);
        dbms_output.put_line('Total PROVISIONED racks that does not have infra: ' || provisionedRacks );
        
        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks
            LEFT JOIN ecs_exaunitdetails details ON racks.exaunitid = details.exaunit_id
            WHERE racks.status='PROVISIONED' and racks.name not in (select rackname from ecs_ceidetails))
        LOOP
            errorFoundCapacityCompute :=  FALSE;
            errorFoundCapacityCell := FALSE;
            errorFoundExadataCompute := FALSE;
            errorFoundExadataCell := FALSE;

            dbms_output.put_line(chr(10)||'Rack: ##############' || rackrecord.name || '##############');

            --====================================
            -- Count computes and cells
            --====================================
            SELECT COUNT(*) INTO numberOfComputes FROM ecs_hw_nodes 
                WHERE ecs_racks_name_list like '%'||rackRecord.name||'%' and node_type='COMPUTE';
            SELECT COUNT(*) INTO numberOfCells FROM ecs_hw_nodes 
                WHERE ecs_racks_name_list like '%'||rackRecord.name||'%' and node_type='CELL';
            dbms_output.put_line(chr(10)||'Has: [' || numberOfComputes || '] computes and [' || numberOfCells || '] cells');

            --====================================
            -- Validate ecs_exadata_capacity data
            --====================================

            SELECT COUNT(*) INTO computeCapacity FROM ecs_exadata_capacity 
                WHERE inventory_id in (select oracle_hostname from ecs_hw_nodes WHERE ecs_racks_name_list like '%'||rackRecord.name||'%' and node_type='COMPUTE');

            IF computeCapacity <> numberOfComputes THEN 
                dbms_output.put_line('   ---  WARNING: Missing capacity records for compute ----');
                dbms_output.put_line(chr(10)||'Computes in Hw nodes: [' || numberOfComputes || '] Computes in capacity:[' || computeCapacity || ']');
                errorFoundCapacityCompute := TRUE;
            END IF;


            SELECT COUNT(*) INTO cellCapacity FROM ecs_exadata_capacity 
                WHERE inventory_id in (select oracle_hostname from ecs_hw_nodes WHERE ecs_racks_name_list like '%'||rackRecord.name||'%' and node_type='CELL');
            
            IF cellCapacity <> numberOfCells THEN 
                dbms_output.put_line('   ---  WARNING: Missing capacity records for cell ----');
                dbms_output.put_line(chr(10)||'Computes in Hw nodes: [' || numberOfCells || '] Computes in capacity:[' || cellCapacity || ']');
                errorFoundCapacityCell := TRUE;
            END IF;

            --====================================
            -- Validate ecs_exadata_cell_node data
            --====================================
            SELECT COUNT(*) INTO nComputesInComputeNode FROM ECS_EXADATA_COMPUTE_NODE 
                WHERE exadata_id = rackRecord.name;

            IF nComputesInComputeNode <> numberOfComputes THEN 
                dbms_output.put_line('   ---  WARNING: Missing compute records ----');
                dbms_output.put_line(chr(10)||'Computes in Hw nodes: [' || numberOfComputes || '] Computes in exadata compute:[' || nComputesInComputeNode || ']');
                errorFoundExadataCompute := TRUE;
            END IF;

            --=========================================
            -- Validate ecs_exadata_compute_node data
            --=========================================
            SELECT COUNT(*) INTO nCellsInCellNode FROM ECS_EXADATA_CELL_NODE 
                WHERE exadata_id = rackRecord.name;

            IF nCellsInCellNode <> numberOfCells THEN 
                dbms_output.put_line('   ---  WARNING: Missing cell records ----');
                dbms_output.put_line(chr(10)||'Computes in Hw nodes: [' || numberOfComputes || '] Computes in exadata cell:[' || nCellsInCellNode || ']');
                errorFoundExadataCell := TRUE;
            END IF;

            if reallyRun then
                if errorFoundCapacityCompute then
                    dbms_output.put_line('#Fixing capacity compute nodes#');
                    updateCapacity(rackRecord.name,'COMPUTE',rackRecord.model);
                end if;

                if errorFoundCapacityCell then
                    dbms_output.put_line('#Fixing capacity cell nodes#');
                    updateCapacity(rackRecord.name,'CELL',rackRecord.model);
                end if;

                if errorFoundExadataCompute then
                    dbms_output.put_line('#Fixing exadata compute nodes#');
                    updateComputeNode(rackRecord.name);
                end if;

                if errorFoundExadataCell then
                    dbms_output.put_line('#Fixing exadata cell nodes#');
                    updateCellNode(rackRecord.name,rackRecord.model);
                end if;
            END IF;

            if errorFoundCapacityCompute or errorFoundCapacityCell or errorFoundExadataCompute or errorFoundExadataCell then
                    totalRacksAffected := totalRacksAffected + 1;
            end if;

            dbms_output.put_line('-----------------------------------------------------------------------------------');
        END LOOP;        

        if totalRacksAffected <> 0 then
            dbms_output.put_line('# of affected racks [' || totalRacksAffected || ']');
        else
            dbms_output.put_line('There are not racks affected');
        end if;
    end fixMetadata;

    
    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        ecsExadataCapacityBk varchar2(1024);
        ecsExadataCellNode varchar2(1024);
        ecsExadataComputeNode varchar2(1024);
    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');

        ecsExadataCapacityBk:= 'ECS_EXADATA_CAPACITY_'||timeStr;
        ecsExadataCellNode:='ECS_EXADATA_CELL_NODE_'||timeStr;
        ecsExadataComputeNode:='ECS_EXADATA_COMPUTE_NODE_'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||ecsExadataCapacityBk||' AS (select * from ECS_EXADATA_CAPACITY)';
        EXECUTE IMMEDIATE 'CREATE TABLE '||ecsExadataCellNode||' AS (select * from ECS_EXADATA_CELL_NODE)';
        EXECUTE IMMEDIATE 'CREATE TABLE '||ecsExadataComputeNode||' AS (select * from ECS_EXADATA_COMPUTE_NODE)';
        
        dbms_output.put_line('ECS_EXADATA_CAPACITY backup table: '||ecsExadataCapacityBk);
        dbms_output.put_line('ECS_EXADATA_CELL_NODE backup table: '||ecsExadataCellNode);
        dbms_output.put_line('ECS_EXADATA_COMPUTE_NODE backup table: '||ecsExadataComputeNode);
        COMMIT;
    END createBackup;

begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    
    IF userselection = 1 THEN
        dbms_output.put_line('Executing prechecks...' );
        fixMetadata(FALSE);
    ELSIF userselection = 2 THEN
        dbms_output.put_line('Creating  backup...' );
        createBackup();
        dbms_output.put_line('Executing backfill...' );
        fixMetadata(TRUE);
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/
 
