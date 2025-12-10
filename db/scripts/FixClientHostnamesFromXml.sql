Rem
Rem $Header: ecs/ecra/db/scripts/FixClientHostnamesFromXml.sql /main/1 2023/02/08 17:02:08 jreyesm Exp $
Rem
Rem FixClientHostnamesFromXml.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      FixClientHostnamesFromXml.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem     
Rem   This is script will review patched xml and compare with what ecra has in ecs_cores and ecs_exadata_vcompute_node, if those are not matching, 
Rem   it will update those tables automatically,  this will be executed only in PROVISIONED and  atp=Y racks.
Rem 
Rem
Rem    NOTES
Rem    Exacs racks will will not be impacted
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/FixClientHostnamesFromXml.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     02/03/23 - E.R 35043698. Production script for fixing client hostnames from xml                       
Rem    jreyesm     02/03/23 - Created
Rem


SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1 -> Get Report ,  2->  Fix adbd issues '

DECLARE 
    userselection varchar2(10);
    domuId VARCHAR2(250);
    domuId2 VARCHAR2(250);
    incorrectRack VARCHAR2(250);
    reportCount INTEGER ;
    clientHostnameFromXml VARCHAR2(250);
    clientHostnameFromXml2 VARCHAR2(250);
    PROCEDURE crossHotnamecheck(reallyRun BOOLEAN)  IS
        reportCount NUMBER;
    BEGIN
        reportCount := 0;
        
        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks 
          LEFT JOIN ecs_exaunitdetails details ON racks.exaunitid = details.exaunit_id  WHERE racks.status='PROVISIONED'  AND details.atp ='Y' )
        LOOP
            dbms_output.put_line(chr(10)||'===================================================================================='  );    
            incorrectRack:= NULL;
            
            FOR computeNode IN (SELECT computeNodes.* FROM ecs_exadata_vcompute_node computeNodes where rack_name=rackRecord.name)
            LOOP
                clientHostnameFromXml:=NULL;
                domuId:=NULL;
               -- dbms_output.put_line(chr(10)||'Analyzing: ' || computeNode.exacompute_hostname );
               SELECT COALESCE ( EXTRACTVALUE(xmltype(updated_xml), '/engineeredSystem/machines/machine[hostName="' ||computeNode.exacompute_hostname || '"]/machine/@id') ,
                                 EXTRACTVALUE(xmltype(updated_xml), '/engineeredSystem/machines/machine[hostName="' ||computeNode.exacompute_hostname || '"]/machine/@id','xmlns="model"') )
                                into domuId FROM ecs_racks where ecs_racks.name=rackRecord.name;
                
                
               if domuId is not null then
                    SELECT COALESCE ( EXTRACTVALUE(xmltype(updated_xml), '/engineeredSystem/machines/machine[@id="' ||domuId || '"]/hostName') ,
                                    EXTRACTVALUE(xmltype(updated_xml), '/engineeredSystem/machines/machine[@id="' ||domuId || '"]/hostName','xmlns="model"'))
                                    into clientHostnameFromXml FROM ecs_racks where ecs_racks.name=rackRecord.name;
                         
               end if;
               
               -- check ecra tables vcompute and ecs_cores
               if clientHostnameFromXml is not null and computeNode.hostname_customer != clientHostnameFromXml then
                    dbms_output.put_line('Incorrect client hostname for host : ' || computeNode.hostname_customer || ' xml correct hostname: ' || clientHostnameFromXml); 
                    incorrectRack:=rackRecord.name;
                    if reallyRun then
                         dbms_output.put_line('Fixing hostnames in ecs_cores and ecs_exadata_vcompute_node' ); 
                        update ecs_cores set hostname=clientHostnameFromXml where  hostname=computeNode.hostname_customer  and dom0=computeNode.exacompute_hostname;
                        update ecs_exadata_vcompute_node set HOSTNAME_CUSTOMER=clientHostnameFromXml where  
                        rack_name=rackRecord.name and EXACOMPUTE_HOSTNAME=computeNode.exacompute_hostname;
                        commit;
                    end if;                    
               end if;
            end loop;
            if incorrectRack is not null then
                    dbms_output.put_line(chr(10)||'Incorrect rack ->[ ' || rackrecord.name || ' ]');
                    reportCount := reportCount + 1;
                   
            end if;
            if incorrectRack is not null and reallyRun then
                    dbms_output.put_line('Fixed  rack ->[ ' || rackrecord.name || ' ]');
                    dbms_output.put_line('===================================================================================='  );
            end if;

        end loop;
        dbms_output.put_line(chr(10)||'Number of incorrect racks found: ' || reportCount );
    
    END crossHotnamecheck;

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
        dbms_output.put_line('Getting report ...' );
        crossHotnamecheck(FALSE);
    elsif userselection = 2 then
        dbms_output.put_line('Creating backup and fixing medatata ...' );
        createBackup();
        crossHotnamecheck(TRUE);
        
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/
