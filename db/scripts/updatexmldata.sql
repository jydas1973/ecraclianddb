Rem
Rem $Header: ecs/ecra/db/scripts/updatexmldata.sql /main/1 2023/06/17 04:00:57 jreyesm Exp $
Rem
Rem updatexmldata.sql
Rem
Rem Copyright (c) 2023, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      updatexmldata.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/updatexmldata.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jreyesm     06/15/23 - E.R 35408195. Update xml using xpath.
Rem    jreyesm     06/15/23 - Created
Rem


SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1 -> Get Rack detail ,  2->  Fix Rack dg sizes'
ACCEPT racknameprompt CHAR FORMAT 'A100' PROMPT 'Please provide rackname: '

DECLARE 
    userselection varchar2(10);
    userrackname  varchar2(100);
    domuId VARCHAR2(250);
    domuId2 VARCHAR2(250);
    incorrectRack VARCHAR2(250);
    reportCount INTEGER ;
  
    
    TYPE numbers_t IS TABLE OF NUMBER;
    
    ---**************************************
    --- Define slice and dg group sizes here
    ---**************************************
    datadg numbers_t := numbers_t (50, 100);
    recodg numbers_t := numbers_t (87, 590);
    --sparsedg numbers_t := numbers_t (800, 850);
    
    
    PROCEDURE diskgroupfix(reallyRun BOOLEAN)  IS
        reportCount NUMBER;
    BEGIN
        reportCount := 0;
        
        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks 
            WHERE racks.name=userrackname) -- 'iad103708exd-d0-01-02-cl-01-03-clu01'   )
        LOOP
            dbms_output.put_line(chr(10)||'===================================================================================='  );    
            incorrectRack:= NULL;
            
            FOR dgroups IN (  
                 SELECT EXTRACTVALUE(VALUE(a1), '/diskGroup/diskGroupType/text()') AS dgtype ,
                  EXTRACTVALUE(VALUE(a1), '/diskGroup/@id') AS dgid ,
                  EXTRACTVALUE(VALUE(a1), '/diskGroup/sliceSize/text()') AS slice ,
                  EXTRACTVALUE(VALUE(a1), '/diskGroup/diskGroupSize/text()') AS dgsize 
                    from 
                    TABLE(XMLSEQUENCE(EXTRACT(xmltype(rackRecord.xml), '/engineeredSystem/storage/diskGroups/diskGroup'))) a1 )
            LOOP
               
                domuId:=NULL;
                
                if reallyRun = TRUE then 
                
                  if dgroups.dgtype = 'DATA' then
                    dbms_output.put_line(chr(10)||'Fixing   ' || dgroups.dgtype || ' ' || dgroups.dgid || 'to sliceSize: ' || datadg(1) || 'G' || ' and dgSize: ' || datadg(2) || 'G');
                    update ecs_racks racks 
                     set racks.xml = updatexml(xmltype(racks.xml),
                        '/engineeredSystem/storage/diskGroups/diskGroup[@id="'|| dgroups.dgid ||'"]/sliceSize/text()',datadg(1) || 'G').getClobVal() where name=rackRecord.name;
                    update ecs_racks racks 
                     set racks.xml = updatexml(xmltype(racks.xml),
                        '/engineeredSystem/storage/diskGroups/diskGroup[@id="'|| dgroups.dgid ||'"]/diskGroupSize/text()',datadg(2) || 'G').getClobVal() where name=rackRecord.name;
                    
                 elsif dgroups.dgtype = 'RECO' then
                  dbms_output.put_line(chr(10)||'Fixing   ' || dgroups.dgtype || ' ' || dgroups.dgid || 'to sliceSize: ' || recodg(1) || 'G' || ' and dgSize: ' || recodg(2) || 'G');
                  update ecs_racks racks 
                     set racks.xml = updatexml(xmltype(racks.xml),
                        '/engineeredSystem/storage/diskGroups/diskGroup[@id="'|| dgroups.dgid ||'"]/sliceSize/text()',recodg(1) || 'G').getClobVal() where name=rackRecord.name;
                    update ecs_racks racks 
                     set racks.xml = updatexml(xmltype(racks.xml),
                        '/engineeredSystem/storage/diskGroups/diskGroup[@id="'|| dgroups.dgid ||'"]/diskGroupSize/text()',recodg(2) || 'G').getClobVal() where name=rackRecord.name;
                 
                 -- pending to implement sparse
                 end if;
                 commit;
                 
              elsif reallyRun = FALSE then
                dbms_output.put_line(chr(10)||  dgroups.dgtype || ' SliceSize: ' || dgroups.slice || ',  diskGroupSize: ' || dgroups.dgsize);
                
              end if;
            
            end loop;
           

        end loop;
    
    END diskgroupfix;

   
      
begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';
    userrackname := '&racknameprompt';
    
    IF userselection = 1 THEN
        dbms_output.put_line('Getting report ...' );
        diskgroupfix(FALSE);
    elsif userselection = 2 then
        dbms_output.put_line('Fixing medatata ...' );
       
        diskgroupfix(TRUE);
        
    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;
    
end;
/


