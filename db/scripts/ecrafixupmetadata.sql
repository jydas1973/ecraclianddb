Rem
Rem $Header: ecs/ecra/db/scripts/ecrafixupmetadata.sql /main/3 2024/03/07 00:15:21 jreyesm Exp $
Rem
Rem ecrafixupmetadata.sql
Rem
Rem Copyright (c) 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      ecrafixupmetadata.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      This script will manage fixing metadata issues in ecra. Plan is to run this script everytime metadata issues are found.
Rem      
Rem      Below this line, please include all the cases that are getting fixed in this script.
Rem      
Rem     1. Fixing ecs_racks_name_list value in MVM cases for all models
Rem             (This field must contain association separated by comas with all racks this node belongs to )
Rem     2. ONLY checking  missing entries in ecs_exadata_compute_node for a given provisioned infrastructure, source of truth
Rem             would be ecs_hw_nodes table. 
Rem     3. Fixing ecs_cores table for rackname column on any missing data. This table should have the rackname for every entry. 
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/ecrafixupmetadata.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     03/04/24 - E.R 36350011. Fix ecs_exadata_compute_nodes
Rem                           ceiocid.
Rem    jreyesm     01/31/24 - Bug 36238407. Add fixes for ecs_cores rackname
Rem                           column.
Rem    jreyesm     01/05/24 - Creating script to fix ecra metadata, mostly mvm
Rem                           in exacs.
Rem    jreyesm     01/05/24 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Execute Precheck, 2. Execute Fix script? (1/2):  '

DECLARE 
    userselection varchar2(10);
    precheckPassed BOOLEAN;


    PROCEDURE fixMetadata (reallyRun BOOLEAN)  IS
        errorFound BOOLEAN;
        errorCoresFound BOOLEAN;
        missingComputes NUMBER;
        missingCells NUMBER;
        incorrectRacks NUMBER;
        racks_list varchar2(1024);
        exadatainfraid varchar2(512);
        exadatainfrarack varchar2(512);
        hwRecordsCount NUMBER;
        computeRecordsCount NUMBER;
        computeRecordsCountBasedRack NUMBER;

        CURSOR infras_cursor IS
        SELECT * FROM ecs_ceidetails   where multivm='true';

        names_t  infras_cursor%ROWTYPE;
        TYPE names_ntt IS TABLE OF names_t%TYPE; -- must use type
        l_infras  names_ntt;
        
    BEGIN
        incorrectRacks:=0;
		
        OPEN  infras_cursor;
        FETCH infras_cursor BULK COLLECT INTO l_infras;
        CLOSE infras_cursor;
        -- Getting all infrastructures from ECRA
        errorFound:=FALSE; 
        FOR indx IN 1..l_infras.COUNT LOOP
            
            exadatainfraid  := l_infras(indx).ceiocid;
            exadatainfrarack:= l_infras(indx).rackname;

            --=========================================================================================
            -- Check Number 1
            -- Checking consistency in racks_name_list on ecs_hw_nodes
            -- To fix this, we will check ecs_cores table and take that as the source of truth, as 
            -- this table has been stable from the beginning. 
            --=========================================================================================
            for rackRecord IN (select racks.name from ecs_racks racks where racks.exadata_id=l_infras(indx).rackname) loop
                 --dbms_output.put_line('Multivm virtual rack:' || rackRecord.name );

                 for coresRecord in (select cores.dom0 from ecs_cores cores where cores.rackname=rackRecord.name) loop
                    --dbms_output.put_line('Dom0: ' || coresRecord.dom0 );
                    select ecs_racks_name_list into racks_list from ecs_hw_nodes where INSTR(coresRecord.dom0,oracle_hostname) > 0;
                    --dbms_output.put_line('Rack names lists : ' || racks_list );
                    -- validate if the rack is correctly associated with ecs_racks_name_list column 
                    if INSTR(racks_list,rackRecord.name) =  0 and reallyRun = FALSE then
                        dbms_output.put_line('================================================================='  );
                        dbms_output.put_line('Infra Rack:' || exadatainfrarack || ', ocid: ' ||  exadatainfraid );

                        dbms_output.put_line('Found issues for rack ' || rackRecord.name || ', missing association for this dom0: ' || coresRecord.dom0);
                        errorFound:=TRUE;
                    end if ;
                    if INSTR(racks_list,rackRecord.name) =  0 and reallyRun = TRUE then
                        dbms_output.put_line('Fixing  issues for rack ' || rackRecord.name || ', missing association for this dom0: ' || coresRecord.dom0);
                        update ecs_hw_nodes set ecs_racks_name_list=CONCAT(ecs_racks_name_list, ',' || rackRecord.name) 
                            where INSTR(coresRecord.dom0,oracle_hostname) > 0 ;
                        COMMIT; 
                    end if ;
                 end loop;

            end loop; 

            --=========================================================================================
            -- Check Number 2 and 3
            -- Checking consistency in ecs_exadata_compute_node against ecs_hw_nodes
            -- Checking ceiocid between ecs_hw_nodes and ecs_exadata_compute_node. 
            -- To fix this, we will check ecs_hw_nodes table and take that as the source of truth
            --=========================================================================================
            
                
            SELECT COUNT(*) INTO hwRecordsCount FROM ecs_hw_nodes WHERE ceiocid = exadatainfraid and node_type='COMPUTE';
            SELECT COUNT(*) INTO computeRecordsCount FROM ecs_exadata_compute_node WHERE exaservice_id = exadatainfraid;
            SELECT COUNT(*) INTO computeRecordsCountBasedRack FROM ecs_exadata_compute_node WHERE exadata_id=exadatainfrarack;
                 
            if reallyRun = FALSE then
                IF hwRecordsCount < computeRecordsCount or hwRecordsCount < computeRecordsCountBasedRack THEN
                    errorFound:=TRUE;
                    dbms_output.put_line('Found issues for infrarack: ' || exadatainfrarack|| ',ocid:' 
                    ||exadatainfraid || ', missing ecs_hw_nodes entries, please review, these will not be fixed automatically!!');
                END IF;
                IF computeRecordsCount < hwRecordsCount  or computeRecordsCountBasedRack < hwRecordsCount  THEN
                    errorFound:=TRUE;
                    dbms_output.put_line('Found issues for infrarack: ' || exadatainfrarack|| ',ocid:' 
                    ||exadatainfraid || ', missing ecs_exadata_compute_node entries, please review,these will not be fixed automatically !!');
                END IF;
            end if; 
            IF computeRecordsCountBasedRack != computeRecordsCount THEN
                errorFound:=TRUE;
                dbms_output.put_line('Found issues for infrarack: ' || exadatainfrarack|| ',ocid:' 
                ||exadatainfraid || ', mistmatch on ecs_exadata_compute_node table from rackname and ocid. ');

                if reallyRun = TRUE and errorFound = TRUE then 
                    IF computeRecordsCount < computeRecordsCountBasedRack THEN 
                        UPDATE ecs_exadata_compute_node SET exaservice_id = exadatainfraid  
                            where ecs_exadata_compute_node.exadata_id=exadatainfrarack 
                            AND (ecs_exadata_compute_node.exaservice_id != exadatainfraid or ecs_exadata_compute_node.exaservice_id is null ) ;
                            commit;
                    END IF;
                    IF  computeRecordsCountBasedRack < computeRecordsCount THEN
                        UPDATE ecs_exadata_compute_node SET exadata_id = exadatainfrarack  
                            where ecs_exadata_compute_node.exaservice_id=exadatainfraid 
                            AND (ecs_exadata_compute_node.exadata_id != exadatainfrarack or ecs_exadata_compute_node.exadata_id  is null );
                            commit;
                    END IF; 
                         
                end if ;

            END IF; 
            
            
            --=========================================================================================
            -- Check Number 4
            -- Checking  ecs_cores rackname column, populate if this is null.
            --=========================================================================================
            for rackRecord IN (select racks.name,racks.exaunitid,services.id from ecs_racks racks 
                        join services services on  racks.exaunitid=services.ecra_pod_id where racks.status='PROVISIONED' ) loop
                
                
                for coresRecord IN (select cores.rackname from ecs_cores cores where cores.service=rackRecord.id) loop
                    if coresRecord.rackname is null then
                        errorCoresFound:=TRUE;
                        exit; 
                    end if ;
                end loop;
                
                if errorCoresFound = TRUE and reallyRun = FALSE  then
                    dbms_output.put_line('Found issues for infrarack: ' || 
                            rackRecord.name || ' missing rackname value on ecs_cores table.'); 
                end if; 
                if reallyRun = TRUE and errorCoresFound = TRUE then
                    UPDATE ecs_cores SET rackname = rackRecord.name  
                            where ecs_cores.service=rackRecord.id AND ecs_cores.rackname is null;
                    commit; 
                end if ;
            end loop; 
           
        END LOOP;

        if reallyRun = FALSE  then
            if errorFound = TRUE or errorCoresFound = TRUE then 
                dbms_output.put_line('');
                dbms_output.put_line('*** Detected issues to fix on ecra infrastructures, please run script in mode 2 to fix. !!!! ');
            else 
                dbms_output.put_line('');
                dbms_output.put_line('<<<<< No issues detected >>>>');
            end if;
        end if; 
      
    end fixMetadata;

begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    
    IF userselection = 1 THEN
        dbms_output.put_line('Executing prechecks...' );
        fixMetadata(FALSE);
    ELSIF userselection = 2 THEN
        --dbms_output.put_line('Creating  backup...' );
        --createBackup();
        dbms_output.put_line('Fixing racks ...' );
        fixMetadata(TRUE);
        
        
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/
 

 
