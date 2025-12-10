Rem
Rem $Header: ecs/ecra/db/scripts/BackfillDataForLargeInfras.sql /main/1 2024/12/10 23:17:02 zpallare Exp $
Rem
Rem BackfillDataForLargeInfras.sql
Rem
Rem Copyright (c) 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      BackfillDataForLargeInfras.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/BackfillDataForLargeInfras.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    zpallare    12/06/24 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report, 2. Fix infrastructures (1/2):  '

DECLARE 
    userselection varchar2(10);
    
    PROCEDURE mainMethod(reallyRun BOOLEAN)  IS
        reportCount NUMBER;
        rackRecordsCount NUMBER;
        hwRecordsCount NUMBER;
        currentSubtype VARCHAR2(1024);
        currentRackname VARCHAR2(1024);
        
    BEGIN
        reportCount := 0;
        SELECT COUNT(*) INTO reportCount FROM ecs_ceidetails join ecs_racks on ecs_ceidetails.rackname=ecs_racks.name WHERE LOWER(ecs_racks.racksize_subtype) IN ('elastic_large','elastic_extralarge');
        SELECT COUNT(*) INTO rackRecordsCount FROM ecs_racks WHERE LOWER(racksize_subtype) IN ('elastic_large','elastic_extralarge');
        SELECT COUNT(*) INTO hwRecordsCount FROM ecs_hw_nodes WHERE LOWER(model_subtype) IN ('elastic_large','elastic_extralarge');
        
        dbms_output.put_line(chr(10)||'Impacted Infrastructures with issues: ' || reportCount);
        dbms_output.put_line(chr(10)||'Impacted Clusters with issues: ' || rackRecordsCount);
        dbms_output.put_line(chr(10)||'Impacted Nodes with issues: ' || hwRecordsCount);
        
        if reallyRun = TRUE then
             FOR ceiRecord IN (SELECT DISTINCT ceiocid FROM ecs_ceidetails join ecs_racks on ecs_ceidetails.rackname=ecs_racks.name WHERE LOWER(ecs_racks.racksize_subtype) IN ('elastic_large','elastic_extralarge'))
             LOOP
                currentSubtype:='';
                currentRackname:='';
                dbms_output.put_line('Updating compute_subtype for infra: '||ceiRecord.ceiocid);
                SELECT rackname INTO currentRackname FROM ecs_ceidetails WHERE ceiocid = ceiRecord.ceiocid;
                SELECT racksize_subtype INTO currentSubtype FROM ecs_racks WHERE name = currentRackname;
                IF LOWER(currentSubtype) = 'elastic_large' THEN
                    UPDATE ecs_ceidetails SET COMPUTE_SUBTYPE='LARGE' WHERE ceiocid=ceiRecord.ceiocid;
                ELSIF LOWER(currentSubtype) = 'elastic_extralarge' THEN
                    UPDATE ecs_ceidetails SET COMPUTE_SUBTYPE='EXTRALARGE' WHERE ceiocid=ceiRecord.ceiocid;
                END IF;
            END LOOP;
            dbms_output.put_line('Updating racks');
            UPDATE ecs_racks SET racksize_subtype='elastic' WHERE LOWER(racksize_subtype)='elastic_large';
            UPDATE ecs_racks SET racksize_subtype='elastic' WHERE LOWER(racksize_subtype)='elastic_extralarge';
            dbms_output.put_line('Updating hardware nodes');
            UPDATE ecs_hw_nodes SET model_subtype='LARGE' WHERE LOWER(model_subtype)='elastic_large';
            UPDATE ecs_hw_nodes SET model_subtype='EXTRALARGE' WHERE LOWER(model_subtype)='elastic_extralarge';
            COMMIT;
            dbms_output.put_line(chr(10)||'Number of fixed Infrastructures: ' || reportCount);
        end if;
        
      
    END mainMethod;

    ---------------
    --CREATE BACKUP
    ---------------
    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        ceidetailsTable varchar2(1024);
        nodesTable varchar2(1024);
        racksTable varchar2(1024);

    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
        ceidetailsTable:= 'ECS_CEIDETAILS_'||timeStr;
        nodesTable:= 'ECS_HW_NODES_'||timeStr;
        racksTable:= 'ECS_RACKS_'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||ceidetailsTable||' AS (select * from ecs_ceidetails)';
        EXECUTE IMMEDIATE 'CREATE TABLE '||nodesTable||' AS (select * from ecs_hw_nodes)';
        EXECUTE IMMEDIATE 'CREATE TABLE '||racksTable||' AS (select * from ecs_racks)';

        dbms_output.put_line('ecs_ceidetails backup table: '||ceidetailsTable);
        dbms_output.put_line('ecs_hw_nodes backup table: '||nodesTable);
        dbms_output.put_line('ecs_racks backup table: '||racksTable);

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
 
