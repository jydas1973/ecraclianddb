Rem
Rem $Header: ecs/ecra/db/scripts/VComputeBackfill.sql /main/3 2022/11/02 20:06:21 illamas Exp $
Rem
Rem VComputeBackfill.sql
Rem
Rem Copyright (c) 2022, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      VComputeBackfill.sql - Backfill missing metadata in ECS_EXADATA_VCOMPUTE_NODE table
Rem
Rem    DESCRIPTION
Rem      BUG 34710700 - EXACS MVM - VCOMPUTES BACKFILLING SCRIPT
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/VComputeBackfill.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    illamas     10/21/22 - Bug 34728275 - Fix precheck
Rem    illamas     10/20/22 - Bug 34720322 - Fix lpad order
Rem    llmartin    10/17/22 - Created
Rem


SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1. Get Report, 2. Fix racks (1/2):  '

DECLARE 
    userselection varchar2(10);
    ecscoresprecheck BOOLEAN;
    
    -- precheck for ecs cores table
    FUNCTION precheck(i_rackname varchar2) RETURN BOOLEAN IS
        serviceId varchar2(4000);
        coreRecords NUMBER;
        coreMissingHostname NUMBER;
        precheckPass BOOLEAN;
        
    BEGIN
       precheckPass:= TRUE;
        --Get serviceId
        SELECT id INTO serviceId FROM services join ecs_racks on services.ecra_pod_id=ecs_racks.exaunitid WHERE services.name = i_rackname;
        
        SELECT COUNT(*) INTO coreRecords FROM ecs_cores 
        WHERE service=serviceId;
        
        SELECT COUNT(*) INTO coreMissingHostname FROM ecs_cores 
        WHERE service=serviceId AND dom0 IS NULL;
        
        IF coreMissingHostname > 0 AND coreMissingHostname != coreRecords THEN
            precheckPass:= FALSE;
        END IF;
        
        RETURN precheckPass;
    end precheck;
    
    -- Fix the rack by populating ecs_exadata_vcompute_node and empty values on in 
    
    PROCEDURE fixRack(i_rackname varchar2, fixecscores BOOLEAN) IS
        serviceId  varchar2(4000);
        domainname varchar2(512);
        vcomputeCount number;
        dom0FQDN varchar2(500);
        domUAdmin varchar2(500);
        customerHostname varchar2 (500);
        cabinetdomain varchar2 (500);
        
        CURSOR dom0_cur IS
        SELECT * FROM ecs_hw_nodes WHERE ecs_racks_name_list 
        LIKE '%'||i_rackname||'%'  AND  node_type='COMPUTE' ORDER BY oracle_hostname;

        names_t  dom0_cur%ROWTYPE;
        TYPE names_ntt IS TABLE OF names_t%TYPE; -- must use type
        l_dom0  names_ntt;
    
        CURSOR clienthostnames_cur IS
        SELECT * FROM ecs_cores JOIN services on ecs_cores.service=services.id 
            WHERE rackname=i_rackname ORDER BY lpad(ecs_cores.hostname,128);

        clients_t  clienthostnames_cur%ROWTYPE;
        TYPE clients_ntt IS TABLE OF clients_t%TYPE; -- must use type
        l_clients  clients_ntt;
    BEGIN
    
        --Fix RACKNAME in ECS_CORES to simplify other queries
        SELECT services.id INTO serviceId FROM services join ecs_racks on services.ecra_pod_id=ecs_racks.exaunitid WHERE services.name = i_rackname;
        IF fixecscores then
            UPDATE ecs_cores SET rackname = i_rackname where ecs_cores.service=serviceId AND ecs_cores.rackname is null;
        else 
            dbms_output.put_line('Skipping ecs_cores update.'  );
        end if;
        
        
        --Fix Dom0 in ECS_CORES
        OPEN  dom0_cur;
        FETCH dom0_cur BULK COLLECT INTO l_dom0;
        CLOSE dom0_cur;
        
        OPEN  clienthostnames_cur;
        FETCH clienthostnames_cur BULK COLLECT INTO l_clients;
        CLOSE clienthostnames_cur;
    
        FOR indx IN 1..l_dom0.COUNT LOOP
            --Get domain in case it is needed to update Dom0 in ECS_CORES table
            SELECT l_dom0(indx).oracle_hostname||'.'||cabinets.domainname INTO dom0FQDN FROM ecs_hw_cabinets cabinets JOIN  ecs_hw_nodes nodes on nodes.cabinet_id = cabinets.id
            WHERE nodes.oracle_hostname = l_dom0(indx).oracle_hostname;
            IF fixecscores then
                UPDATE ecs_cores SET dom0 = dom0FQDN WHERE hostname = l_clients(indx).hostname AND dom0 is null;
            end if;
           
           --Create or Update ECS_EXADATA_VCOMPUTE
            select count(*) INTO vcomputeCount FROM ecs_exadata_vcompute_node 
            WHERE RACK_NAME = i_rackname AND EXACOMPUTE_HOSTNAME = dom0FQDN;
            
            BEGIN
                SELECT hostname INTO customerHostname FROM ecs_cores
                WHERE rackname=i_rackname AND dom0 = dom0FQDN;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                customerHostname := l_clients(indx).hostname;
            END;
            
            IF vcomputeCount = 1 THEN
                UPDATE ECS_EXADATA_VCOMPUTE_NODE SET HOSTNAME_CUSTOMER = customerHostname 
                WHERE HOSTNAME_CUSTOMER is null AND RACK_NAME = i_rackname AND EXACOMPUTE_HOSTNAME = dom0FQDN;
    
            ELSIF vcomputeCount =0 THEN
            
                select domainname  into cabinetdomain from ecs_hw_cabinets  join ecs_hw_nodes on ecs_hw_cabinets.id=ecs_hw_nodes.cabinet_id where ecs_hw_nodes.oracle_hostname=l_dom0(indx).oracle_hostname and
                ecs_hw_nodes.ecs_racks_name_list like '%' || i_rackname || '%';
                SELECT domu.admin_host_name||'.'|| cabinetdomain  into domUAdmin FROM ECS_DOMUS domu 
                WHERE domu.ecs_racks_name= i_rackname AND domu.hw_node_id = l_dom0(indx).ID;
            
                INSERT into ECS_EXADATA_VCOMPUTE_NODE (HOSTNAME,EXACOMPUTE_HOSTNAME, EXAUNIT_ID, RACK_NAME,  HOSTNAME_CUSTOMER )
                VALUES (domUAdmin, dom0FQDN, l_clients(indx).ecra_pod_id, i_rackname, customerHostname);
            END IF;
           
        END LOOP;
        commit;
        
    END fixRack;
    
    PROCEDURE fixMetadata(reallyRun BOOLEAN)  IS
        missingHostnameCount NUMBER;
        vcomputeCount NUMBER;
        errorFound BOOLEAN;
        errorStr VARCHAR2(4096);
        serviceId varchar2(4000);
        coreRecords NUMBER;
        reportCount NUMBER;
    BEGIN
        reportCount := 0;
        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks
            WHERE racks.status='PROVISIONED' and racks.exaunitid is not null)
        LOOP
            errorFound:=FALSE;    
            --Get serviceId
            SELECT id INTO serviceId FROM services join ecs_racks on services.ecra_pod_id=ecs_racks.exaunitid WHERE services.name = rackRecord.name;
            
            SELECT COUNT(*) INTO coreRecords FROM ecs_cores WHERE service=serviceId;
            
            --====================================
            --Validate missing ECS_EXADATA_VCOMPUTE_NODE records
            --====================================
            SELECT COUNT(*) INTO vcomputeCount FROM ECS_EXADATA_VCOMPUTE_NODE vcompute 
                WHERE vcompute.EXAUNIT_ID = rackRecord.exaunitid;
            IF coreRecords > vcomputeCount THEN
                dbms_output.put_line('Missing vcompute entry for : ' || rackrecord.name);
                
                errorFound:= TRUE;
            END IF;
             
            --====================================
            --Validate missing HOSTNAME_CUSTOMER in ECS_EXADATA_VCOMPUTE_NODE
            --====================================
            SELECT COUNT(*) INTO missingHostnameCount FROM ECS_EXADATA_VCOMPUTE_NODE vcompute 
                WHERE vcompute.HOSTNAME_CUSTOMER IS NULL AND vcompute.EXAUNIT_ID = rackRecord.exaunitid;
            IF missingHostnameCount > 0 THEN
                dbms_output.put_line('Empty client hostname for : ' || rackrecord.name);
                errorFound:= TRUE;
            END IF;

            if errorFound then
                reportCount := reportCount +1;
            END IF;
            
            if errorFound AND  reallyRun  then
                dbms_output.put_line('Fixing rack: ' || rackrecord.name);
                -- will not be fixing ecs_cores table if partially updated.
                ecscoresprecheck:= precheck(rackrecord.name);
                fixRack(rackrecord.name,ecscoresprecheck);
            END IF;
            
        END LOOP;
        
        dbms_output.put_line(chr(10)||'Impacted Racks: ' || reportCount);
        if reportCount = 0  THEN
            dbms_output.put_line(chr(10)||'No racks with missing vcomputes metadata');
        END IF;
      
    END fixMetadata;
    
    PROCEDURE createBackup IS
        timeStr  varchar2(1024);
        coresTable varchar2(1024);
        vcomputeTable varchar2(1024);
    BEGIN
        timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
        coresTable:= 'ECS_CORES'||timeStr;
        vcomputeTable:= 'ECS_VCOMPUTE_NODE'||timeStr;
        
        EXECUTE IMMEDIATE 'CREATE TABLE '||coresTable||' AS (select * from ECS_CORES)';
        EXECUTE IMMEDIATE 'CREATE TABLE '||vcomputeTable||' AS (select * from ECS_EXADATA_VCOMPUTE_NODE)';
    
        dbms_output.put_line('ECS_EXADATA_VCOMPUTE_NODE backup table: '||vcomputeTable);
        dbms_output.put_line('ECS_CORES backup table: '||coresTable);
        COMMIT;
    END createBackup;
    
        
    

begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    
    IF userselection = 1 THEN
        dbms_output.put_line('Getting report...' );
        fixMetadata(FALSE);
    ELSIF userselection = 2 THEN
        
        dbms_output.put_line('Creating  backup...' );
        createBackup();
        dbms_output.put_line('Fixing metadata...' );
        fixMetadata (TRUE);
        
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/



