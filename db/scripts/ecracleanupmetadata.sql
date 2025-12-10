Rem
Rem $Header: ecs/ecra/db/scripts/ecracleanupmetadata.sql /main/2 2023/12/08 20:20:44 jreyesm Exp $
Rem
Rem ecracleanupmetadata.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      ecracleanupmetadata.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      
Rem    This script will  clenup old metadata from the current ecra schema
Rem    it will allow to keep  health in schema and lower number of records for 
Rem    faster  performance.
Rem    The following tables will be impactec:  
Rem      
Rem    1. ecs_wf_requests  
Rem    2. ecs_requests
Rem    3. wf_state_machine
Rem    4. ecs_idemtokens
Rem
Rem   script will also do some cleanup from existing tables 
Rem   1. it will mark as 'Failed' any record in ecs_wf_request table which start_time is null, 
Rem      as these records are not in use for any workflow, but cause delay in performance 
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/ecracleanupmetadata.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     12/06/23 - Bug 36082097. Fix message and include pending
Rem                           patch operations
Rem    jreyesm     11/03/23 - E.R 35973070. Cleanup metadata in ecra.
Rem    jreyesm     11/03/23 - Created
Rem



SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report, 2. Delete old records: '
ACCEPT numberofdays char   FORMAT 'A20' PROMPT 'Please add number of days(Max 15) :  '

DECLARE 
    userselection varchar2(10);
	numberofdays integer;
    precheckresult BOOLEAN;
    
    -- precheck for ecs cores table
    FUNCTION precheck(daystoCheck integer) RETURN BOOLEAN IS
        datewf timestamp;
        dateplus10 timestamp;
        coreRecords NUMBER;
        datewfrequests timestamp;
        dateplus10wfrequests timestamp;
        recordsWfRequests NUMBER;
        daterequest timestamp;
        dateplus10request timestamp;
        requestRecords NUMBER;
        requestPatchRecords NUMBER;
        dateplus10Idemtokens timestamp;
        idemtokensRecords NUMBER;
        wfmachinenull NUMBER;
		
    BEGIN
		
        ---
        
        --- Getting the oldest day from wf_state_machine table, this will be used as pivot for other tables.
		select trunc(start_time) + daystoCheck,start_time into dateplus10, datewf 
            from (select start_time from wf_state_machine where start_time is not null order by start_time asc) WHERE ROWNUM = 1;
        select count(wf_uuid)  into wfmachinenull from wf_state_machine where start_time is null and  current_state!='Aborted' AND current_state!='Completed';

        if not datewf is NULL then
            dbms_output.put_line('Older record date from wf_state_machine ->' || datewf  );
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10 );
        else 
            dbms_output.put_line('Older record date from wf_state_machine -> not records'  );
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: not records' );
        
        end if;
        
		select count(*) into coreRecords from wf_state_machine where start_time  <=  dateplus10;
		dbms_output.put_line('Number of records potentially be deleted from wf_state_machine(along with childs):  ' || coreRecords  );
        dbms_output.put_line('Number of records with start_time null to be marked as "Aborted":  ' || wfmachinenull  );
        
         dbms_output.put_line('----------------------------------------------------------------------------------------' );     


        -- ******************************************************************************
        -- Checking from ecs_wf_request table. 
        -- ******************************************************************************
        dateplus10wfrequests:=dateplus10;

         if not dateplus10wfrequests is NULL then
            
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10wfrequests );
       
        else 
            dbms_output.put_line('Older record date from ecs_request -> no records');
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: no records' );
        end if;
       
        
        select count(*) into recordsWfRequests from ecs_wf_requests where 
            to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  dateplus10wfrequests;
        dbms_output.put_line('Number of records potentially be deleted from ecs_wf_request:  ' || recordsWfRequests  );
        
        dbms_output.put_line('----------------------------------------------------------------------------------------' );    
        
        -- ******************************************************
        -- ecs_requests 
        -- ******************************************************
        dateplus10request:=dateplus10;
         
        if not dateplus10request is NULL then
            
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10request );
       
        else 
            dbms_output.put_line('Older record date from ecs_request -> no records');
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: no records' );
        end if;
       
        
        select count(*) into requestRecords from ecs_requests where 
            to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  dateplus10request;
        dbms_output.put_line('Number of records potentially be deleted from ecs_request:  ' || requestRecords  );
        
        -- patching pending records in 202 
        select count(*) into requestPatchRecords from ecs_requests where 
            to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  TRUNC(SYSDATE) - 60 and status=202 and operation='PATCHING';
        dbms_output.put_line('Number of patching records in 202 older than 60 days:  ' || requestPatchRecords  );
        
        
        -- ******************************************************************************
        dbms_output.put_line('----------------------------------------------------------------------------------------' );    
        dateplus10Idemtokens:=dateplus10;
        if not dateplus10Idemtokens is NULL then
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10Idemtokens );
        else
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: no records ');
        end if;
        
        select count(*) into idemtokensRecords from ecs_idemtokens where 
            TIMESTAMP '1970-01-01 00:00:00.000' + NUMTODSINTERVAL( created / 1000, 'SECOND' )  <=  dateplus10Idemtokens;
        dbms_output.put_line('Number of records potentially be deleted from ecs_idemtokens:  ' || idemtokensRecords  );
        
        
        RETURN TRUE;
    end precheck;
    
    
    --
    -- Perform delete of records 
    --
    
    PROCEDURE performWipeout(daystoCheck integer,reallyRun BOOLEAN)  IS
        datewf timestamp;
        dateplus10 timestamp;
        coreRecords NUMBER;
        daterequest timestamp;
        dateplus10request timestamp;
        requestRecords NUMBER;
        requestPatchRecords NUMBER;
        dateplus10Idemtokens timestamp;
        idemtokensRecords NUMBER;
        datewfrequests timestamp;
        dateplus10wfrequests timestamp;
        recordsWfRequests NUMBER;
        wfmachinenull NUMBER;
    BEGIN
        
      if   reallyRun  then
        

        select trunc(start_time) + daystoCheck,start_time into dateplus10, datewf from (select start_time from wf_state_machine where start_time is not null order by start_time asc) WHERE ROWNUM = 1;
        if not datewf is NULL then
            dbms_output.put_line('Older record date from wf_state_machine ->' || datewf  );
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10 );
        else 
            dbms_output.put_line('Older record date from wf_state_machine -> not records'  );
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: not records' );
        
        end if;
        
		select count(*) into coreRecords from wf_state_machine where start_time  <=  dateplus10;
        select count(wf_uuid)  into wfmachinenull from wf_state_machine where start_time is null and  current_state!='Aborted' AND current_state!='Completed';

        if coreRecords > 0 then
            dbms_output.put_line('Number of records to be deleted  from wf_state_machine: ' || coreRecords  );
            dbms_output.put_line('deleting records ...');
            delete from wf_state_machine  where start_time  <=  dateplus10;
            commit;
        end if;
        if wfmachinenull > 0 then
            dbms_output.put_line('Number of records to be updated in wf_state_machine to be Aborted: ' || wfmachinenull  );
            dbms_output.put_line('updating records ...');
            update  wf_state_machine  set current_state='Aborted',start_time='27-AUG-23 01.00.00.000000 AM'  where start_time is null and  current_state!='Aborted' AND current_state!='Completed';
            commit;
        end if;
        
        dbms_output.put_line('----------------------------------------------------------------------------------------' );    

        --***************************************************************************************
        -- Checking from ecs_wf_requests table. 
        -- ***********************************************************
         
        dateplus10wfrequests:=dateplus10;
        if not dateplus10wfrequests is NULL then
            
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10wfrequests );
       
        else 
            dbms_output.put_line('Older record date from ecs_wf_requests -> no records');
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: no records' );
        end if;
       
        
        select count(*) into recordsWfRequests from ecs_wf_requests where 
            to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  dateplus10wfrequests;
        
         if recordsWfRequests > 0 then
            dbms_output.put_line('Number of records to be deleted  from ecs_wf_requests: ' || recordsWfRequests  );
            dbms_output.put_line('deleting records ...');
            delete from ecs_wf_requests  where to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  dateplus10wfrequests;
            commit;
        end if;
        dbms_output.put_line('----------------------------------------------------------------------------------------' );    
        --**************************************************
        -- ecs_requests 
        -- ************************************************
         dateplus10request:=dateplus10;
        if not dateplus10request is NULL then
            
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10request );
       
        else 
            dbms_output.put_line('Older record date from ecs_request -> no records');
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: no records' );
        end if;
       
        
        select count(*) into requestRecords from ecs_requests where 
           start_time is not null and  to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  dateplus10request;
        
         if requestRecords > 0 then
            dbms_output.put_line('Number of records to be deleted  from ecs_requests ' || requestRecords  );
            dbms_output.put_line('deleting records ...');
            delete from ecs_requests  where  to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  dateplus10request;
            commit;
        end if;

        -- Patching requests 
        select count(*) into requestPatchRecords from ecs_requests where 
           start_time is not null and  to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=  
                TRUNC(SYSDATE) - 60 and status=202 and operation='PATCHING';
        
         if requestPatchRecords > 0 then
            dbms_output.put_line('Number of records to be updated from 202 to 200 with PATCHING operation: ' || requestPatchRecords  );
            
            update  ecs_requests set status=200  where  start_time is not null and to_date(replace(substr(start_time,0,19),'T',' '),'YYYY-MM-DD HH24:MI:SS','NLS_DATE_LANGUAGE = American')  <=
                TRUNC(SYSDATE) - 60 and status=202 and operation='PATCHING';
            commit;
        end if;
        
        -- ************************************
        -- ecs_idemtokens
        -- ************************************
        dbms_output.put_line('----------------------------------------------------------------------------------------' );    
        dateplus10Idemtokens:=dateplus10;
        if not dateplus10Idemtokens is NULL then
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: '||  dateplus10Idemtokens );
        else
            dbms_output.put_line('Date with more than: ' || daystoCheck || ' days: no records ');
        end if;
		
        
        select count(*) into idemtokensRecords from ecs_idemtokens where 
            TIMESTAMP '1970-01-01 00:00:00.000' + NUMTODSINTERVAL( created / 1000, 'SECOND' )  <=  dateplus10Idemtokens;
        
        if idemtokensRecords > 0 then
            dbms_output.put_line('Number of records to be deleted from ecs_idemtokens:  ' || idemtokensRecords  );  
            dbms_output.put_line('deleting records ...');
            delete from ecs_idemtokens  where   TIMESTAMP '1970-01-01 00:00:00.000' + NUMTODSINTERVAL( created / 1000, 'SECOND' )  <=  dateplus10Idemtokens;
            commit;
        end if;
      
      end if;
      
	  
    END performWipeout;
    

begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    numberofdays := '&numberofdays';
	
    IF userselection = 1 and numberofdays <= 15 THEN
        dbms_output.put_line('Prechecks ...' );
        precheckresult:= precheck(numberofdays);
    ELSIF userselection = 2 THEN
        dbms_output.put_line('Purge ...' );
        performWipeout (numberofdays, TRUE);
        
    ELSE
        dbms_output.put_line('Invalid option or invalid days ...' );
    END IF;
    dbms_output.put_line('Completed '  );
    
end;
/
