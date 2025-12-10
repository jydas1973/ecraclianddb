Rem
Rem $Header: ecs/ecra/db/scripts/fixecscomputenodes.sql /main/1 2023/07/27 17:27:59 jreyesm Exp $
Rem
Rem fixecscomputenodes.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      fixecscomputenodes.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Fix exaservice_id value on ecs_exadata_compute_node table. This ocid comes from ecs_ceidetails
Rem      and the valididation is done counting ecs_hw_nodes vs compute nodes.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/fixecscomputenodes.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     07/25/23 - Bug 35627394. Fix ecs_exadata_compute_nodes table
Rem    jreyesm     07/25/23 - Created
Rem


 
SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report, 2. Fix infrastructures (1/2):  '

DECLARE 
    userselection varchar2(10);
    ecscoresprecheck BOOLEAN;
    
    PROCEDURE mainMethod(reallyRun BOOLEAN)  IS
        reportCount NUMBER;
        hwRecordsCount NUMBER;
        computeRecordsCount NUMBER;
        
    BEGIN
        reportCount := 0;
        
        FOR ceiRecord IN (SELECT * FROM ecs_ceidetails join ecs_racks on ecs_ceidetails.rackname=ecs_racks.name WHERE ecs_racks.model like '%M-2' and ecs_racks.status='PROVISIONED')
        LOOP
            SELECT COUNT(*) INTO hwRecordsCount FROM ecs_hw_nodes WHERE ceiocid = ceiRecord.ceiocid and node_type='COMPUTE';
            SELECT COUNT(*) INTO computeRecordsCount FROM ecs_exadata_compute_node WHERE exaservice_id = ceiRecord.ceiocid;
        
            IF hwRecordsCount != computeRecordsCount THEN
              reportCount := reportCount + 1;
            END IF;
        END LOOP;
        
        dbms_output.put_line(chr(10)||'Impacted Infrastructures with issues: ' || reportCount);
        
        if reallyRun = TRUE then
             reportCount:= 0;
             FOR ceiRecord IN (SELECT * FROM ecs_ceidetails join ecs_racks on ecs_ceidetails.rackname=ecs_racks.name WHERE ecs_racks.model like '%M-2'  and ecs_racks.status='PROVISIONED')
             LOOP
                SELECT COUNT(*) INTO hwRecordsCount FROM ecs_hw_nodes WHERE ceiocid = ceiRecord.ceiocid and node_type='COMPUTE';
                SELECT COUNT(*) INTO computeRecordsCount FROM ecs_exadata_compute_node WHERE exaservice_id = ceiRecord.ceiocid;
        
                IF hwRecordsCount != computeRecordsCount THEN
                   update ecs_exadata_compute_node set exaservice_id=ceiRecord.ceiocid where exadata_id=ceiRecord.rackname and exaservice_id is null;
                  reportCount := reportCount + 1;
                END IF;
            END LOOP;
            commit;
             dbms_output.put_line(chr(10)||'Number of fixed racks: ' || reportCount);
        end if;
        
      
    END mainMethod;

    ---------------
    --CREATE BACKUP
    ---------------
    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        compTable varchar2(1024);
    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
        compTable:= 'ECS_EXA_COM_NODE'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||compTable||' AS (select * from ecs_exadata_compute_node)';
    
        dbms_output.put_line('ecs_exadata_compute_node backup table: '||compTable);
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
