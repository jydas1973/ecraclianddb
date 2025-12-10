Rem
Rem $Header: ecs/ecra/db/scripts/FixModelCEIs.sql /main/1 2024/05/17 18:55:45 gvalderr Exp $
Rem
Rem FixModelCEIs.sql
Rem
Rem Copyright (c) 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      FixModelCEIs.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/FixModelCEIs.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    gvalderr    05/13/24 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report, 2. Fix CEI models (1/2):  '

DECLARE 
    userselection varchar2(10);
    ecscoresprecheck BOOLEAN;
    
    -- Get the correct CEI OCID MODEL based on what is stored on the rack it has associated
    FUNCTION getCorrectModel(i_rackname varchar2) RETURN VARCHAR2 IS
        correctModel VARCHAR2(1024);
        rackModel VARCHAR2(1024);
    BEGIN
        correctModel := NULL;
        SELECT MODEL INTO rackModel FROM ecs_racks WHERE NAME = i_rackname;
        dbms_output.put_line(' Selected rack: ' ||  i_rackname );
        dbms_output.put_line(' Current model of rack: ' ||  rackModel );
        
        IF rackModel IS NOT NULL THEN
            correctModel := rackModel; 
        ELSE
            RETURN NULL;
        END IF;
        
        RETURN correctModel;
    end getCorrectModel;
        
        
    PROCEDURE fixRecords(i_ceiOcid varchar2, i_rackname varchar2, fix BOOLEAN) IS
        correctModel  varchar2(4000);
        currentInfra VARCHAR2(1024);
        currentModel VARCHAR2(1024);
    BEGIN
        --Getting correct Infrastructure Model for this rack.
        correctModel := getCorrectModel(i_rackname);
        
        IF correctModel IS NULL THEN
            dbms_output.put_line('Correct MODEL could not been determined from rack, manual intervention needed to fix this Infra.' );
            RETURN;
        END IF;
        
        dbms_output.put_line('Exadata Infrastructure state: ' );
        SELECT ceiocid INTO currentInfra FROM ecs_ceidetails WHERE ceiocid = i_ceiOcid;
        SELECT model INTO currentModel FROM ecs_ceidetails WHERE ceiocid = i_ceiOcid;
        
        IF currentModel = correctModel THEN
            dbms_output.put_line('     [Correct]   ' ||  currentInfra );
        ELSE
            dbms_output.put_line('     [Incorrect] ' ||  currentInfra );
        END If;
        
        IF fix THEN
            dbms_output.put_line('Updating Infrastructure record with correct model');
            UPDATE ecs_ceidetails SET MODEL=correctModel WHERE ceiocid = i_ceiOcid;
            COMMIT;
        END IF;
        
        dbms_output.put_line(chr(10) );
    END fixRecords;
    
    PROCEDURE mainMethod(fix BOOLEAN)  IS
        reportCount NUMBER;
    BEGIN 
        reportCount := 0;
        FOR ceiRecord IN 
            (SELECT CEIOCID, RACKNAME FROM ecs_ceidetails WHERE MODEL IS NULL)
        LOOP
             dbms_output.put_line('Infrastructure: ' || ceiRecord.CEIOCID || ' is associated to NULL model ');
            
            IF ceiRecord.rackname IS NOT NULL THEN
                fixRecords(ceiRecord.CEIOCID, ceiRecord.rackname, fix);
            ELSE
                dbms_output.put_line('Infrastructure: ' || ceiRecord.CEIOCID || ' could not been achieved, manual intervention needed to fix this Infra.' );
            END IF;
            
            reportCount := reportCount +1;
        END LOOP;
        
        dbms_output.put_line(chr(10)||'Impacted Infras: ' || reportCount);
        IF reportCount = 0  THEN
            dbms_output.put_line(chr(10)||'No infras associated with NULL model');
        END IF;
      
    END mainMethod; 

begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    
    IF userselection = 1 THEN
        dbms_output.put_line('Getting report...' );
        mainMethod(FALSE);
    ELSIF userselection = 2 THEN
        dbms_output.put_line('Fixing metadata...' );
        mainMethod (TRUE);
        
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/

