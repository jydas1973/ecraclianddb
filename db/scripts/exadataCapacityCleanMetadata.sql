Rem
Rem $Header: ecs/ecra/db/scripts/exadataCapacityCleanMetadata.sql /main/1 2025/04/07 23:03:22 gvalderr Exp $
Rem
Rem exadataCapacityCleanMetadata.sql
Rem
Rem Copyright (c) 2025, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      exadataCapacityCleanMetadata.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/exadataCapacityCleanMetadata.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    gvalderr    03/31/25 - 37755720 - Creating script for cleaning exadata
Rem                           capacity metadata or giving a report
Rem    gvalderr    03/31/25 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report, 2. Fix exadata Capacity records (1/2):  '

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
        SELECT COUNT(DISTINCT CEIOCID) INTO reportCount FROM ECS_HW_NODES LEFT JOIN ECS_EXADATA_CAPACITY ON ORACLE_HOSTNAME=INVENTORY_ID WHERE CEIOCID IS NOT NULL AND STATUS='PROVISIONING' AND NODE_STATE='ALLOCATED';
        SELECT COUNT(DISTINCT INVENTORY_ID) INTO hwRecordsCount FROM ECS_HW_NODES LEFT JOIN ECS_EXADATA_CAPACITY ON ORACLE_HOSTNAME=INVENTORY_ID WHERE CEIOCID IS NOT NULL AND STATUS='PROVISIONING' AND NODE_STATE='ALLOCATED';
        
        dbms_output.put_line(chr(10)||'Impacted Infrastructures with issues: ' || reportCount);
        dbms_output.put_line(chr(10)||'Impacted Nodes with issues: ' || hwRecordsCount);
        
        if reallyRun = TRUE then
            FOR ceiRecord IN (SELECT DISTINCT CEIOCID FROM ECS_HW_NODES LEFT JOIN ECS_EXADATA_CAPACITY ON ORACLE_HOSTNAME=INVENTORY_ID WHERE CEIOCID IS NOT NULL AND STATUS='PROVISIONING' AND NODE_STATE='ALLOCATED')
            LOOP
                dbms_output.put_line('Updating exadata_capacity node status for nodes of infra: '||ceiRecord.ceiocid);
                FOR nodeRecord IN (SELECT DISTINCT INVENTORY_ID FROM ECS_HW_NODES LEFT JOIN ECS_EXADATA_CAPACITY ON ORACLE_HOSTNAME=INVENTORY_ID WHERE CEIOCID=ceiRecord.ceiocid AND STATUS='PROVISIONING' AND NODE_STATE='ALLOCATED')
                LOOP
                    dbms_output.put_line('Updating exadata_capacity node status for node: '||nodeRecord.inventory_id);
                    UPDATE ECS_EXADATA_CAPACITY SET STATUS='PROVISIONED' WHERE inventory_id=nodeRecord.inventory_id;
                END LOOP;
            END LOOP;
            COMMIT;
            dbms_output.put_line(chr(10)||'Number of fixed Infrastructures: ' || reportCount);
        end if;
        
      
    END mainMethod;

    ---------------
    --CREATE BACKUP
    ---------------
    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        exadataCapacityTable varchar2(1024);

    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
        exadataCapacityTable:= 'ECS_EXADATA_CAPACITY_'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||exadataCapacityTable||' AS (select * from ecs_exadata_capacity)';

        dbms_output.put_line('ecs_exadata_capacity backup table: '||exadataCapacityTable);

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
 
