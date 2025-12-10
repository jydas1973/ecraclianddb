Rem
Rem $Header: ecs/ecra/db/scripts/KvmIpPoolScan.sql /main/1 2025/02/12 22:51:21 llmartin Exp $
Rem
Rem KvmIpPoolScan.sql
Rem
Rem Copyright (c) 2025, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      KvmIpPoolScan.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/scripts/KvmIpPoolScan.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    llmartin    01/30/25 - Created
Rem

SET SERVEROUTPUT ON
set linesize 4000;
set pagesize 4000;

DECLARE 
    verbose BOOLEAN;

    FUNCTION scanBlock(p_fabric varchar2, p_iptype varchar2, verbose boolean) RETURN BOOLEAN  IS
    fisrt_id NUMBER;
    previous_id NUMBER;
    previous_ip varchar2 (500);
    isBlockOk BOOLEAN;
    BEGIN
    
        isBlockOk := TRUE;
        fisrt_id := null;

        FOR ipRecord IN (
            select resource_id, ipaddress
            ,cast(regexp_substr(ipaddress,'[^\.]+') as number)  seg1
            ,cast(regexp_substr(ipaddress,'[^\.]+',1,2) as number) seg2
            ,cast(regexp_substr(ipaddress,'[^\.]+',1,3) as number) seg3 
            ,cast(regexp_substr(ipaddress,'[^\.]+',1,4) as number) seg4
            from ECS_KVMIPPOOL pool
            where pool.fabric_name = p_fabric AND REGEXP_LIKE(iptype, p_iptype)
            order by seg1, seg2, seg3, seg4 )
        LOOP
            IF previous_id is null THEN
                previous_id := ipRecord.resource_id;
                previous_ip := ipRecord.ipaddress;
                --IF verbose THEN
                --    dbms_output.put_line('First resource_id ' || previous_id);
                --END IF;
            ELSE 
                IF (previous_id + 1 ) != ipRecord.resource_id THEN
                    dbms_output.put_line(chr(9) ||'Broken sequence in '|| p_iptype || ' block.');

                    IF verbose THEN
                        dbms_output.put_line(chr(9)||chr(9) ||previous_id || ' ' || previous_ip);
                        dbms_output.put_line(chr(9)||chr(9) ||ipRecord.resource_id || ' ' || ipRecord.ipaddress);
                    END IF;

                    isBlockOk := FALSE;
                    --EXIT;
                END IF;
            END IF;
              
            previous_id := ipRecord.resource_id;
            previous_ip := ipRecord.ipaddress;
        END LOOP;
        IF isBlockOk AND verbose THEN
           dbms_output.put_line(chr(9) ||p_iptype||': OK');
        END IF;
    
        RETURN isBlockOk;
    end scanBlock;

    
    PROCEDURE scanPool(verbose BOOLEAN)  IS
        isBlockOk BOOLEAN;
        isFabricOk BOOLEAN;
        overallResult BOOLEAN;
        type list_type is table of varchar2(100);
        nt list_type := list_type ('COMPUTE$', 'EXASCALE', 'STORAGE');
    BEGIN
        overallResult := TRUE;
        FOR fabricRecord IN (SELECT DISTINCT pool.fabric_name FROM ECS_KVMIPPOOL pool)
        LOOP
            isFabricOk := TRUE;
            dbms_output.put_line(chr(10)||'Fabric: ' || fabricRecord.fabric_name );

            FOR tIndex IN 1..nt.count
            LOOP
                --dbms_output.put_line(chr(10)||chr(9)||'Type: ' || nt(tIndex));
                isBlockOk := scanBlock(fabricRecord.fabric_name , nt(tIndex), verbose);
                
                IF NOT isBlockOk THEN
                    isFabricOk := FALSE;
                    overallResult := FALSE;
                END IF;               
            END LOOP;  
            
            IF isFabricOk THEN
                dbms_output.put_line(chr(9)||'OK');
            END IF;
        END LOOP;        
        dbms_output.put_line(chr(10)||'-----------------------------------------------------------------------------------');
        IF overallResult THEN
           dbms_output.put_line(chr(10)||'Result: CORRECT');
        ELSE
           dbms_output.put_line(chr(10)||'Result: FAILED');
        END IF;

    end scanPool;
    
begin
    dbms_output.put_line('==========================================================');
    verbose := TRUE;    
    dbms_output.put_line('Scanning ECS_KVMIPPOOL...' );
    scanPool(verbose);
    
end;
/
