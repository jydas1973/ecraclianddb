Rem
Rem $Header: ecs/ecra/db/scripts/FixRackAssociation.sql /main/1 2023/05/26 20:37:37 jreyesm Exp $
Rem
Rem FixRackAssociation.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      FixRackAssociation.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script will fix x8m rack missing association in ecs_hw_nodes if any.
Rem      ecs_racks and ecs_hw_nodes are related using ecs_racksn_name_list field.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/FixRackAssociation.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     05/25/23 - Bug 35427025. Fix up script to repair association
Rem    jreyesm     05/25/23 - Created
Rem


SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Execute Precheck, 2. Execute Fix script ? (1/2):  '

DECLARE 
    userselection varchar2(10);
    precheckPassed BOOLEAN;

    
    PROCEDURE fixRack(rackname varchar2) IS
    computeName VARCHAR2(100);
    cellName VARCHAR2(100);
    reportCount NUMBER;
    basename VARCHAR2(100);
    dom0 VARCHAR2(10);
    cell  VARCHAR2(10);
    firstIndex NUMBER;
    dom0Start NUMBER;
    dom0End NUMBER;
    cellStart NUMBER;
    cellEnd NUMBER; 
    missingComputes NUMBER;
    missingCells NUMBER;
    i NUMBER;
    BEGIN
        reportCount := 0;
        i := 0;
        firstIndex := INSTR(rackname,'-');
        basename := SUBSTR(rackname,0, firstIndex - 1);
        dom0  := SUBSTR(rackname,firstIndex+1, 8 );
        cell :=  SUBSTR(rackname,firstIndex + 8 + 2, 8);
        
        dom0Start := TO_NUMBER(SUBSTR(dom0, 4 , 2));
        dom0End := TO_NUMBER(SUBSTR(dom0, 7 , 2));
        
        cellStart := TO_NUMBER(SUBSTR(cell, 4 , 2));
        cellEnd := TO_NUMBER(SUBSTR(cell, 7 , 2));
        
        dbms_output.put_line('Rack base to fix : ' || basename || ',' || dom0 || ',' || cell || ',' ||dom0Start || dom0End || ',' || cellStart || cellEnd );
        --
        -- Fix computes first if needed  
        SELECT COUNT(*) INTO missingComputes FROM ecs_hw_nodes 
                WHERE ecs_racks_name_list  like '%'|| rackname || '%' AND  node_type='COMPUTE' ;
            
        IF missingComputes  < 2 THEN
            FOR idx IN dom0Start..dom0End loop
                computeName :=basename || 'd0' || LPAD(TO_CHAR(idx) , 2 , '0');
                update ecs_hw_nodes set ecs_racks_name_list=rackname where oracle_hostname=computeName 
                    and (ecs_racks_name_list is null or length(ecs_racks_name_list) = 0 );
                i := SQL%rowcount; 
                IF i > 0 then
                    dbms_output.put_line('Fixing Compute if missing association: ' || computeName);
                end if;
                
            end loop;
            
        END IF;
        
         SELECT COUNT(*) INTO missingCells FROM ecs_hw_nodes 
                WHERE ecs_racks_name_list  like '%'|| rackname || '%' AND  node_type='CELL' ;
             
        IF missingCells < 3 THEN
             FOR idx IN cellStart..cellEnd loop
                cellName :=basename || 'cl' || LPAD(TO_CHAR(idx) , 2 , '0');
                update ecs_hw_nodes set ecs_racks_name_list=rackname where oracle_hostname=cellName 
                    and (ecs_racks_name_list is null or length(ecs_racks_name_list) = 0);
                i := SQL%rowcount; 
                IF i > 0 then
                    dbms_output.put_line('Fixing cell if missing association: ' || cellName);
                end if;
                
            end loop;
        END IF;
        commit;
        
    END fixRack;
    
    -- =====================================================
    -- Scan table to review  missing associations
    -- =====================================================
    PROCEDURE fixMetadata (reallyRun BOOLEAN)  IS
        errorFound BOOLEAN;
        missingComputes NUMBER;
        missingCells NUMBER;
        incorrectRacks NUMBER;
        
    BEGIN
        
		incorrectRacks:=0;
       
        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks
            WHERE racks.status='READY' AND racks.model LIKE 'X8M-2' AND racks.racksize='quarter') 
        LOOP
            errorFound:=FALSE; 
            --====================================
            --Validate validate if association is missing for those racks.
            --====================================
            SELECT COUNT(*) INTO missingComputes FROM ecs_hw_nodes 
                WHERE ecs_racks_name_list  like '%'|| rackRecord.name || '%' AND  node_type='COMPUTE' ;
            
            IF missingComputes  < 2 THEN
                dbms_output.put_line('ERROR: Missing computes for rack:' || rackrecord.name);
                errorFound:= TRUE;
            END IF;
            SELECT COUNT(*) INTO missingCells FROM ecs_hw_nodes 
                WHERE ecs_racks_name_list  like '%'|| rackRecord.name || '%' AND  node_type='CELL' ;
             
            IF missingCells < 3 THEN
                dbms_output.put_line('ERROR: Missing cells for rack:' || rackrecord.name );
                errorFound:= TRUE;
            END IF;
            
            if errorFound then
                incorrectRacks:= incorrectRacks + 1;
            END IF;
            
            if errorFound and reallyRun  then
                dbms_output.put_line('Fixing rack with errors: -> ' || rackrecord.name);
                fixRack(rackrecord.name);
            END IF;
            dbms_output.put_line('----------------------------------------');
        END LOOP;
        
        IF incorrectRacks > 0 and not reallyRun  THEN
            dbms_output.put_line(chr(10)||'Errors were found during the precheck, Racks found with errors: ' || incorrectRacks);
        ELSIf incorrectRacks = 0 then
            dbms_output.put_line('No Errors were found.');
        END IF;
      
    end fixMetadata;

    

    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        ceiBkpTable varchar2(1024);
        nodesBkpTable varchar2(1024);
    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
        nodesBkpTable:='ECS_HW_NODES_'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||nodesBkpTable||' AS (select * from ECS_HW_NODES)';
        dbms_output.put_line('ECS_HW_NODES backup table: '||nodesBkpTable);
        
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
        dbms_output.put_line('Fixing racks ...' );
        fixMetadata(TRUE);
        
        
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/
 
