Rem
Rem $Header: ecs/ecra/db/scripts/CleanDeletedCEIs.sql /main/1 2022/12/07 23:05:40 llmartin Exp $
Rem
Rem CleanDeletedCEIs.sql
Rem
Rem Copyright (c) 2022, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      CleanDeletedCEIs.sql - Clean deleted CEI records from ECRA
Rem
Rem    DESCRIPTION
Rem      Some racks are associated to more than one CEI records, this script will delete
Rem      the extra CEI records.
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/CleanDeletedCEIs.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    llmartin    11/24/22 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report, 2. Fix racks (1/2):  '

DECLARE 
    userselection varchar2(10);
    ecscoresprecheck BOOLEAN;
    
    -- Get the correct CEI OCID based on which infrastructure has associated records in the 
    -- ECS_HW_NODES table.
    FUNCTION getCorrectInfra(i_rackname varchar2) RETURN VARCHAR2 IS
        hwRecordsCount NUMBER;
        correctOcid VARCHAR2(1024);
    BEGIN
        correctOcid := NULL;
        FOR ceiRecord IN (SELECT * FROM ecs_ceidetails WHERE rackname = i_rackname)
        LOOP
            SELECT COUNT(*) INTO hwRecordsCount FROM ecs_hw_nodes WHERE ceiocid = ceiRecord.ceiocid;
        
            IF hwRecordsCount > 0 THEN
                IF correctOcid IS NULL THEN
                    correctOcid := ceiRecord.ceiocid; 
                ELSE
                    RETURN NULL;
                END IF;
            END IF;
        END LOOP;
        
        RETURN correctOcid;
    end getCorrectInfra;
        
    PROCEDURE fixRecords(i_rackname varchar2, fix BOOLEAN) IS
        correctInfraOcid  varchar2(4000);
        
    BEGIN
        --Getting correct Infrastructure OCID for this rack.
        correctInfraOcid := getCorrectInfra(i_rackname);
        
        IF correctInfraOcid IS NULL THEN
            dbms_output.put_line('Correct CEI  could not been determined, manual intervention needed to fix this rack.' );
                FOR ceiRecord IN (SELECT ceiocid FROM ecs_ceidetails WHERE rackname = i_rackname)
                LOOP
                    dbms_output.put_line('     [Incorrect] ' ||  ceiRecord.ceiocid );          
                END LOOP;
            RETURN;
        END IF;
        
        dbms_output.put_line('Exadata Infrastructure list: ' );
        FOR ceiRecord IN (SELECT * FROM ecs_ceidetails WHERE rackname = i_rackname)
        LOOP
            IF ceiRecord.ceiocid = correctInfraOcid THEN
                dbms_output.put_line('     [Correct]   ' ||  ceiRecord.ceiocid );
            ELSE
                dbms_output.put_line('     [Incorrect] ' ||  ceiRecord.ceiocid );
            END If;
        END LOOP;
        
        IF fix THEN
            dbms_output.put_line('Deleting incorrect Infrastructure records');
            DELETE FROM ecs_ceidetails WHERE rackname = i_rackname AND ceiocid <> correctInfraOcid;
            COMMIT;
        END IF;
        
        dbms_output.put_line(chr(10) );
    END fixRecords;
    
    PROCEDURE mainMethod(fix BOOLEAN)  IS
        reportCount NUMBER;
    BEGIN
        reportCount := 0;
        FOR rackRecord IN 
            (SELECT rackname, infraCounter FROM 
            (SELECT COUNT(*) AS infraCounter, rackname FROM ecs_ceidetails GROUP BY rackname)
            WHERE infraCounter >1)
        LOOP
             dbms_output.put_line('Rack: ' || rackRecord.rackname || ' is associated to ' || 
                                  rackRecord.infraCounter || ' infrastructures');
            
            IF rackRecord.rackname IS NOT NULL THEN
                fixRecords(rackRecord.rackname, fix);
            ELSE
                dbms_output.put_line('Skipping rack' || chr(10) );
            END IF;
            
            reportCount := reportCount +1;
        END LOOP;
        
        dbms_output.put_line(chr(10)||'Impacted Racks: ' || reportCount);
        IF reportCount = 0  THEN
            dbms_output.put_line(chr(10)||'No racks associated to more than one Infrastructure');
        END IF;
      
    END mainMethod;

    ---------------
    --CREATE BACKUP
    ---------------
    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        ceiTable varchar2(1024);
    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
        ceiTable:= 'ECS_CEIDETAILS'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||ceiTable||' AS (select * from ecs_ceidetails)';
    
        dbms_output.put_line('ECS_CEIDETAILS backup table: '||ceiTable);
        COMMIT;
    END createBackup;
    

begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    
    IF userselection = 1 THEN
        dbms_output.put_line('Getting report...' );
        mainMethod(FALSE);
    ELSIF userselection = 2 THEN
        
        dbms_output.put_line('Creating  backup...' );
        createBackup();
        dbms_output.put_line('Fixing metadata...' );
        mainMethod (TRUE);
        
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/
