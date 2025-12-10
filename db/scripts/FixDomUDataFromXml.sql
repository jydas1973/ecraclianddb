Rem
Rem $Header: ecs/ecra/db/scripts/FixDomUDataFromXml.sql /main/2 2024/04/12 23:40:41 jvaldovi Exp $
Rem
Rem FixDomUDataFromXml.sql
Rem
Rem Copyright (c) 2024, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      FixDomUDataFromXml.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/FixDomUDataFromXml.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    jvaldovi    04/11/24 - Bug 36502571 - Ecra:Db: Enhance
Rem                           Fixdomudatafromxml.Sql To Show More Info On Domu
Rem                           Issues And To Make Changes Only On Affected Domus
Rem    jvaldovi    01/06/24 - Bug 36056408 - Phx2|Ecra Metadata Missing For
Rem                           Domu In Table Ecs_Domus For Node Recovery
Rem                           Automation
Rem    jvaldovi    01/06/24 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

ACCEPT userselectionprompt CHAR FORMAT 'A20' PROMPT 'Please select one option: 1 -> Get Report ,  2->  Fix DomU Issues '

DECLARE
    userselection varchar2(10);
    incorrectDomu VARCHAR2(250);
    reportCount INTEGER ;
    vDB_CLIENT_IP varchar(250);
    vCUSTOMER_CLIENT_MAC varchar(250);
    vDB_CLIENT_HOST_NAME varchar(250);
    vDB_CLIENT_NETMASK varchar(250);
    vDB_CLIENT_DOMIANNAME varchar(250);
    vDB_CLIENT_GATEWAY varchar(250);
    vDB_CLIENT_VLAN_TAG varchar(250);
    vDB_BACKUP_IP varchar(250);
    vCUSTOMER_BACKUP_MAC varchar(250);
    vDB_BACKUP_HOST_NAME varchar(250);
    vDB_BACKUP_NETMASK varchar(250);
    vDB_BACKUP_DOMIANNAME varchar(250);
    vDB_BACKUP_GATEWAY varchar(250);
    vDB_BACKUP_VLAN_TAG varchar(250);
    PROCEDURE crossDomUcheck(reallyRun BOOLEAN)  IS
        reportCount NUMBER;
    BEGIN
        reportCount := 0;
        FOR rackRecord IN (SELECT racks.* FROM ecs_racks racks
          LEFT JOIN ecs_exaunitdetails details ON racks.exaunitid = details.exaunit_id  WHERE racks.status='PROVISIONED' )
        LOOP
            dbms_output.put_line(chr(10)||'===================================================================================='  );

            dbms_output.put_line(rackRecord.name );
            FOR domu IN (SELECT domus.* FROM ecs_domus domus where ecs_racks_name=rackRecord.name)
            LOOP
                incorrectDomu:= NULL;
                vDB_CLIENT_IP:=NULL;
                vCUSTOMER_CLIENT_MAC:=NULL;
                vDB_CLIENT_HOST_NAME:=NULL;
                vDB_CLIENT_NETMASK:=NULL;
                vDB_CLIENT_DOMIANNAME:=NULL;
                vDB_CLIENT_GATEWAY:=NULL;
                vDB_CLIENT_VLAN_TAG:=NULL;
                vDB_BACKUP_IP:=NULL;
                vCUSTOMER_BACKUP_MAC:=NULL;
                vDB_BACKUP_HOST_NAME:=NULL;
                vDB_BACKUP_NETMASK:=NULL;
                vDB_BACKUP_DOMIANNAME:=NULL;
                vDB_BACKUP_GATEWAY:=NULL;
                vDB_BACKUP_VLAN_TAG:=NULL;



                if domu.ADMIN_HOST_NAME is not null then


                    SELECT upper(COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/macAddress') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/macAddress', 'xmlns="model"') ))
                                into vCUSTOMER_CLIENT_MAC FROM ecs_racks where name=rackRecord.name;
                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/netMask') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/netMask', 'xmlns="model"') )
                                into vDB_CLIENT_NETMASK FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/gateway') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/gateway', 'xmlns="model"') )
                                into vDB_CLIENT_GATEWAY FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/ipAddress') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/ipAddress', 'xmlns="model"') )
                                into vDB_CLIENT_IP FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/hostName') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/hostName', 'xmlns="model"') )
                                into vDB_CLIENT_HOST_NAME FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/domainName') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/domainName', 'xmlns="model"') )
                                into vDB_CLIENT_DOMIANNAME FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/vlanId') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[nathostName="'|| domu.ADMIN_HOST_NAME ||'"]/vlanId', 'xmlns="model"') )
                                into vDB_CLIENT_VLAN_TAG FROM ecs_racks where name=rackRecord.name;

                    -- Values from backup

                    SELECT upper(COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/macAddress') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/macAddress', 'xmlns="model"') ))
                                into vCUSTOMER_BACKUP_MAC FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/netMask') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/netMask', 'xmlns="model"') )
                                into vDB_BACKUP_NETMASK FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/gateway') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/gateway', 'xmlns="model"') )
                                into vDB_BACKUP_GATEWAY FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/ipAddress') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/ipAddress', 'xmlns="model"') )
                                into vDB_BACKUP_IP FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/hostName') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/hostName', 'xmlns="model"') )
                                into vDB_BACKUP_HOST_NAME FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/domainName') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/domainName', 'xmlns="model"') )
                                into vDB_BACKUP_DOMIANNAME FROM ecs_racks where name=rackRecord.name;

                    SELECT COALESCE( EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/vlanId') ,
                                EXTRACTVALUE(xmltype(updated_xml), 'engineeredSystem/networks/network[hostName="'|| vDB_CLIENT_HOST_NAME ||'-backup"]/vlanId', 'xmlns="model"') )
                                into vDB_BACKUP_VLAN_TAG FROM ecs_racks where name=rackRecord.name;


               end if;



               -- check values in DomU and update accordingly
              if (domu.DB_CLIENT_IP!=vDB_CLIENT_IP OR domu.DB_CLIENT_IP is NULL) AND vDB_CLIENT_IP is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_CLIENT_IP found in DB: ' || domu.DB_CLIENT_IP || ' and XML have ' ||vDB_CLIENT_IP );
                  if reallyRun then
                      update ecs_domus set DB_CLIENT_IP=vDB_CLIENT_IP where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;

                  end if;

              end if;

              if (domu.CUSTOMER_CLIENT_MAC!=vCUSTOMER_CLIENT_MAC OR domu.CUSTOMER_CLIENT_MAC is NULL) AND vCUSTOMER_CLIENT_MAC is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.CUSTOMER_CLIENT_MAC found in DB: ' || domu.CUSTOMER_CLIENT_MAC || ' and XML have ' || vCUSTOMER_CLIENT_MAC);
                  if reallyRun then
                      update ecs_domus set CUSTOMER_CLIENT_MAC=vCUSTOMER_CLIENT_MAC where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_CLIENT_HOST_NAME!=vDB_CLIENT_HOST_NAME OR domu.DB_CLIENT_HOST_NAME is NULL) AND vDB_CLIENT_HOST_NAME is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_CLIENT_HOST_NAME found in DB: ' || domu.DB_CLIENT_HOST_NAME || ' and XML have ' || vDB_CLIENT_HOST_NAME);
                  if reallyRun then
                      update ecs_domus set DB_CLIENT_HOST_NAME=vDB_CLIENT_HOST_NAME where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_CLIENT_NETMASK!=vDB_CLIENT_NETMASK OR domu.DB_CLIENT_NETMASK is NULL) AND vDB_CLIENT_NETMASK is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_CLIENT_NETMASK found in DB: ' || domu.DB_CLIENT_NETMASK || ' and XML have ' || vDB_CLIENT_NETMASK);
                  if reallyRun then
                      update ecs_domus set DB_CLIENT_NETMASK=vDB_CLIENT_NETMASK where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_CLIENT_DOMIANNAME!=vDB_CLIENT_DOMIANNAME OR domu.DB_CLIENT_DOMIANNAME is NULL) AND vDB_CLIENT_DOMIANNAME is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_CLIENT_DOMIANNAME found in DB: ' || domu.DB_CLIENT_DOMIANNAME || ' and XML have ' || vDB_CLIENT_DOMIANNAME);
                  if reallyRun then
                      update ecs_domus set DB_CLIENT_DOMIANNAME=vDB_CLIENT_DOMIANNAME where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_CLIENT_GATEWAY!=vDB_CLIENT_GATEWAY OR domu.DB_CLIENT_GATEWAY is NULL) AND vDB_CLIENT_GATEWAY is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_CLIENT_GATEWAY found in DB: ' || domu.DB_CLIENT_GATEWAY || ' and XML have ' || vDB_CLIENT_GATEWAY);
                  if reallyRun then
                      update ecs_domus set DB_CLIENT_GATEWAY=vDB_CLIENT_GATEWAY where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_CLIENT_VLAN_TAG!=vDB_CLIENT_VLAN_TAG OR domu.DB_CLIENT_VLAN_TAG is NULL) AND vDB_CLIENT_VLAN_TAG is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_CLIENT_VLAN_TAG found in DB: ' || domu.DB_CLIENT_VLAN_TAG || ' and XML have ' || vDB_CLIENT_VLAN_TAG);
                  if reallyRun then
                      update ecs_domus set DB_CLIENT_VLAN_TAG=vDB_CLIENT_VLAN_TAG where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_BACKUP_IP!=vDB_BACKUP_IP OR domu.DB_BACKUP_IP is NULL) AND vDB_BACKUP_IP is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_BACKUP_IP found in DB: ' || domu.DB_BACKUP_IP || ' and XML have ' ||vDB_BACKUP_IP );
                  if reallyRun then
                      update ecs_domus set DB_BACKUP_IP=vDB_BACKUP_IP where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.CUSTOMER_BACKUP_MAC!=vCUSTOMER_BACKUP_MAC OR domu.CUSTOMER_BACKUP_MAC is NULL) AND vCUSTOMER_BACKUP_MAC is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.CUSTOMER_BACKUP_MAC found in DB: ' || domu.CUSTOMER_BACKUP_MAC || ' and XML have ' || vCUSTOMER_BACKUP_MAC);
                  if reallyRun then
                      update ecs_domus set CUSTOMER_BACKUP_MAC=vCUSTOMER_BACKUP_MAC where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_BACKUP_HOST_NAME!=vDB_BACKUP_HOST_NAME OR domu.DB_BACKUP_HOST_NAME is NULL) AND vDB_BACKUP_HOST_NAME is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_BACKUP_HOST_NAME found in DB: ' || domu.DB_BACKUP_HOST_NAME || ' and XML have ' || vDB_BACKUP_HOST_NAME);
                  if reallyRun then
                      update ecs_domus set DB_BACKUP_HOST_NAME=vDB_BACKUP_HOST_NAME where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_BACKUP_NETMASK!=vDB_BACKUP_NETMASK OR domu.DB_BACKUP_NETMASK is NULL) AND vDB_BACKUP_NETMASK is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_BACKUP_NETMASK found in DB: ' || domu.DB_BACKUP_NETMASK || ' and XML have ' || vDB_BACKUP_NETMASK);
                  if reallyRun then
                      update ecs_domus set DB_BACKUP_NETMASK=vDB_BACKUP_NETMASK where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_BACKUP_DOMIANNAME!=vDB_BACKUP_DOMIANNAME OR domu.DB_BACKUP_DOMIANNAME is NULL) AND vDB_BACKUP_DOMIANNAME is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_BACKUP_DOMIANNAME found in DB: ' || domu.DB_BACKUP_DOMIANNAME  || ' and XML have ' ||vDB_BACKUP_DOMIANNAME );
                  if reallyRun then
                      update ecs_domus set DB_BACKUP_DOMIANNAME=vDB_BACKUP_DOMIANNAME where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_BACKUP_GATEWAY!=vDB_BACKUP_GATEWAY OR domu.DB_BACKUP_GATEWAY is NULL) AND vDB_BACKUP_GATEWAY is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_BACKUP_GATEWAY found in DB: ' || domu.DB_BACKUP_GATEWAY || ' and XML have ' || vDB_BACKUP_GATEWAY);
                  if reallyRun then
                      update ecs_domus set DB_BACKUP_GATEWAY=vDB_BACKUP_GATEWAY where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if (domu.DB_BACKUP_VLAN_TAG!=vDB_BACKUP_VLAN_TAG OR domu.DB_BACKUP_VLAN_TAG is NULL) AND vDB_BACKUP_VLAN_TAG is NOT NULL
              then
                  incorrectDomu:=domu.ADMIN_HOST_NAME;
                  dbms_output.put_line(chr(10)|| 'Incorrect value for domu.DB_BACKUP_VLAN_TAG found in DB: ' || domu.DB_BACKUP_VLAN_TAG || ' and XML have ' || vDB_BACKUP_VLAN_TAG);
                  if reallyRun then
                      update ecs_domus set DB_BACKUP_VLAN_TAG=vDB_BACKUP_VLAN_TAG where admin_host_name=domu.ADMIN_HOST_NAME and ECS_RACKS_NAME=rackRecord.name;
                  end if;
              end if;
              if incorrectDomu is not null then
                        dbms_output.put_line(chr(10)||'Incorrect DomU ->[ ' || domu.ADMIN_HOST_NAME || ' from rack ' ||rackrecord.name || ' ]');
                        reportCount := reportCount + 1;

               end if;
               if incorrectDomu is not null and reallyRun then
                        dbms_output.put_line('Fixed  DomU ->[ ' || domu.ADMIN_HOST_NAME || ' from rack ' ||rackrecord.name || ' ]');
                        dbms_output.put_line('===================================================================================='  );
               end if;
               commit;
            end loop;
        end loop;
        dbms_output.put_line(chr(10)||'Number of incorrect DomUs found: ' || reportCount );

    END crossDomUcheck;




    PROCEDURE createBackup IS
          timeStr  varchar2(1024);
          domusTable varchar2(1024);
    BEGIN
          timeStr:= TO_CHAR(Sysdate, 'HH24_MI_SS');
          domusTable:= 'ECS_DOMUS'||timeStr;
          EXECUTE IMMEDIATE 'CREATE TABLE '|| domusTable ||' AS (select * from ECS_DOMUS)';
          dbms_output.put_line('ECS_DOMUS backup table: '||domusTable);
          COMMIT;
    END createBackup;


begin
    dbms_output.put_line('==========================================================');
    userselection := '&userselectionprompt';

    IF userselection = 1 THEN
        dbms_output.put_line('Getting report ...' );
        crossDomUcheck(FALSE);
    elsif userselection = 2 then
        dbms_output.put_line('Creating backup and fixing medatata ...' );
        createBackup();
        crossDomUcheck(TRUE);

    ELSE
        dbms_output.put_line('Invalid option...' );
    END IF;

end;
/

