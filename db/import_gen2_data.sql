Rem
Rem $Header: ecs/ecra/db/import_gen2_data.sql /main/3 2017/03/14 12:34:51 nkedlaya Exp $
Rem
Rem import_gen2_data.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      import_gen2_data.sql
Rem
Rem    DESCRIPTION
Rem      Adds just enoung data to generation 2 tables for 1 quarter cluster with ECRA name scam07-qr-1
Rem      This is only for a simplest API test for ECRA with the DBaaS control plane.
Rem      There will be a utility for bulk upload soon to populate the data from flat files.
Rem
Rem    NOTES
Rem      To load the data into ECRA database simply run the sql
Rem       e.g sqlplus ecra/ecra @ecs/ecra/db/import_gen2_data.sql
Rem           commit; 
Rem 
Rem      You can load additional clusters by editing a copy of this file and doing another
Rem      execution.
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/import_gen2_data.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    nkedlaya    03/02/17 - import a test GEN2 data
Rem    nkedlaya    03/02/17 - Created
Rem
declare
  l_ecs_vcns varchar2(256) := 'vcn1|192.168.0.0/16|sca';
  l_ecs_ib_fabrics varchar2(4000) := '5e1e676ebcc3add1c8c88de351b97d1edcb549bcd87ee0085edfdf3fa937e49220f6215dda3578fc4c8c57d1111154e034a530892aa751c1c62e0511842c61e1|scam07sw-iba0,scam07sw-ibb0,scam07sw-ibs0';
  l_ecs_domu1 varchar2(4000) := 'scam07-qr-1|1|192.168.128.101/22|scam07adm01vm01-nat.us.oracle.com|169.254.0.10/24|0c:0b:0a:01:02:03|0c:0b:0a:01:02:04|0c:0b:0a:01:02:05';
  l_ecs_domu2 varchar2(4000) := 'scam07-qr-1|2|192.168.128.102/22|scam07adm02vm01-nat.us.oracle.com|169.254.0.10/24|0c:0b:0a:01:02:06|0c:0b:0a:01:02:07|0c:0b:0a:01:02:08';

  l_ecs_ib_pkeys_compute varchar2(4000) := '0xa000|compute|scam07-qr-1';
  l_ecs_ib_pkeys_storage varchar2(4000) := '0xaa00|storage|scam07-qr-1';

  l_ecs_domu1_cavimum1 varchar2(500) := '1|cavium.1|eth4|0a:0b:0c:03:02:01|db_client';
  l_ecs_domu1_cavimum2 varchar2(500) := '1|cavium.2|eth5|0a:0b:0c:03:02:02|db_client';
  l_ecs_domu1_cavimum3 varchar2(500) := '1|cavium.3|eth6|0a:0b:0c:03:02:03|db_backup';
  l_ecs_domu1_cavimum4 varchar2(500) := '1|cavium.4|eth7|0a:0b:0c:03:02:04|db_backup';
  l_ecs_domu2_cavimum1 varchar2(500) := '2|cavium.5|eth4|0a:0b:0c:03:02:05|db_client';
  l_ecs_domu2_cavimum2 varchar2(500) := '2|cavium.6|eth5|0a:0b:0c:03:02:06|db_client';
  l_ecs_domu2_cavimum3 varchar2(500) := '2|cavium.7|eth6|0a:0b:0c:03:02:07|db_backup';
  l_ecs_domu2_cavimum4 varchar2(500) := '2|cavium.8|eth7|0a:0b:0c:03:02:08|db_backup';

  l_ecs_racks varchar2(500) := 'scam07adm01vm01scam07adm02vm01|scam07-qr-1';

  l_ecs_hw_node_comp1 varchar2(4000) := '2|1|scam07-qr-1|COMPUTE|X6-2|12.1.2.3.4.170111|192.168.128.2/22|scam07adm01.us.oracle.com|16|1|3cell2comp3ibsw2pdu1ethsw|ALLOCATED';
  l_ecs_hw_node_comp2 varchar2(4000) := '2|1|scam07-qr-1|COMPUTE|X6-2|12.1.2.3.4.170111|192.168.128.2/22|scam07adm02.us.oracle.com|17|2|3cell2comp3ibsw2pdu1ethsw|ALLOCATED';
  l_ecs_hw_node_cell1 varchar2(4000) := '2|1|scam07-qr-1|CELL|X6-2|12.1.2.3.4.170111|192.168.128.2/22|scam07cel01.us.oracle.com|2|1|3cell2comp3ibsw2pdu1ethsw|ALLOCATED';
  l_ecs_hw_node_cell2 varchar2(4000) := '2|1|scam07-qr-1|CELL|X6-2|12.1.2.3.4.170111|192.168.128.2/22|scam07cel02.us.oracle.com|4|2|3cell2comp3ibsw2pdu1ethsw|ALLOCATED';
  l_ecs_hw_node_cell3 varchar2(4000) := '2|1|scam07-qr-1|CELL|X6-2|12.1.2.3.4.170111|192.168.128.2/22|scam07cel03.us.oracle.com|6|3|3cell2comp3ibsw2pdu1ethsw|ALLOCATED';

  l_vnc_info_array dbms_sql.varchar2_table;
  l_hw_node_info_array dbms_sql.varchar2_table;
  l_ib_fabric_info_array dbms_sql.varchar2_table;
  l_hw_node_id_array dbms_sql.number_table;
  l_cavium_info_array dbms_sql.varchar2_table;
  l_domu_info_array dbms_sql.varchar2_table;
  l_ecs_racks_info_array dbms_sql.varchar2_table;
  l_host_name_parts dbms_sql.varchar2_table;
  l_cabinet_id number;
  l_ib_fabric_id number;
  l_hw_node_id_start number;
  l_cluster_hw_id_start number;

  function split_str
  ( p_string        in varchar2
  , p_delimiter     in varchar2
  ) return dbms_sql.varchar2_table is
    l_bigstr    varchar2(30000);
    l_smlstr    varchar2(30000);
    l_idx       pls_integer;
    l_array_idx pls_integer := 0;
    l_string_coll dbms_sql.varchar2_table;
  begin
    --
    -- parse the input line to extract path info
    --
    l_bigstr := p_string;
    loop
      exit when l_bigstr is null;
      l_idx := instr( l_bigstr, p_delimiter);
      if l_idx = 0 then
        l_smlstr:= l_bigstr;
      else
        l_smlstr:= substr( l_bigstr, 1, l_idx - 1 );
        l_bigstr:= substr( l_bigstr, l_idx + 1 );
      end if;
      if l_smlstr is not null then
        l_array_idx := l_array_idx + 1;
        l_string_coll(l_array_idx) := l_smlstr;
      end if;
      exit when l_idx = 0;
    end loop;
    return l_string_coll;
  end split_str;

begin

  -- insert into ecs_vcns
  l_vnc_info_array := split_str(l_ecs_vcns, '|');
  if (l_vnc_info_array.count > 0) then
    dbms_output.put_line('l_vnc_info_array.count = '||l_vnc_info_array.count);
  else
    dbms_output.put_line('0');
  end if;
  dbms_output.put_line(l_vnc_info_array(1));

  insert into ecs_vcns
  values (l_vnc_info_array(1) , l_vnc_info_array(2), l_vnc_info_array(3));
  -- insert into ecs_hw_cabinets (cage_id is hardcoded for testing)
  l_hw_node_info_array := split_str(l_ecs_hw_node_comp1, '|');
  insert into ecs_hw_cabinets
  values (l_hw_node_info_array(1), 'scam07','SCA', 100,'X6-2 Elastic', 
          l_hw_node_info_array(11), 'Other/UTC', 'us.oracle.com','exd')
  returning id into l_cabinet_id;

  -- insert into ecs_ib_fabrics
  l_ib_fabric_info_array := split_str(l_ecs_ib_fabrics, '|');
  insert into ecs_ib_fabrics
  values (l_hw_node_info_array(2), l_ib_fabric_info_array(1), 
          l_ib_fabric_info_array(2))
  returning id into l_ib_fabric_id;
  
  -- insert into ecs_hw_nodes
  select nvl(max(id), 0) 
  into l_hw_node_id_start 
  from ecs_hw_nodes;

  --cabinet_id|ib_fabric_id|ecs_racks_name|node_type|node_model|sw_version|oracle_ip|oracle_hostname|location_rackunit|node_order|cluster_size_constraint|node_state
  -- For testing ilom name and ip are bogus in this script
  l_hw_node_info_array := split_str(l_ecs_hw_node_comp1, '|');
  l_host_name_parts := split_str(l_hw_node_info_array(8), '.');  
  insert into ecs_hw_nodes
  values(l_hw_node_id_start+1, l_cabinet_id, l_ib_fabric_id, 
         l_hw_node_info_array(3), l_hw_node_info_array(4), 
         l_hw_node_info_array(5), l_hw_node_info_array(6),
         systimestamp, l_hw_node_info_array(7),
         l_hw_node_info_array(8), l_hw_node_info_array(7), 
         l_host_name_parts(1)||'-ilom', l_hw_node_info_array(9),
         l_hw_node_info_array(10), 
         l_hw_node_info_array(11), l_hw_node_info_array(12))
   returning id into l_hw_node_id_array(1);

  l_hw_node_info_array := split_str(l_ecs_hw_node_comp2, '|');
  l_host_name_parts := split_str(l_hw_node_info_array(8), '.');  
  insert into ecs_hw_nodes
  values(l_hw_node_id_array(1)+1, l_cabinet_id, l_ib_fabric_id, 
         l_hw_node_info_array(3), l_hw_node_info_array(4), 
         l_hw_node_info_array(5), l_hw_node_info_array(6),
         systimestamp, l_hw_node_info_array(7),
         l_hw_node_info_array(8), l_hw_node_info_array(7), 
         l_host_name_parts(1)||'-ilom', l_hw_node_info_array(9),
         l_hw_node_info_array(10), 
         l_hw_node_info_array(11), l_hw_node_info_array(12))
   returning id into l_hw_node_id_array(2);

  l_hw_node_info_array := split_str(l_ecs_hw_node_cell1, '|');
  l_host_name_parts := split_str(l_hw_node_info_array(8), '.');  
  insert into ecs_hw_nodes
  values(l_hw_node_id_array(2)+1, l_cabinet_id, l_ib_fabric_id, 
         l_hw_node_info_array(3), l_hw_node_info_array(4), 
         l_hw_node_info_array(5), l_hw_node_info_array(6),
         systimestamp, l_hw_node_info_array(7),
         l_hw_node_info_array(8), l_hw_node_info_array(7), 
         l_host_name_parts(1)||'-ilom', l_hw_node_info_array(9),
         l_hw_node_info_array(10),
         l_hw_node_info_array(11), l_hw_node_info_array(12))
   returning id into l_hw_node_id_array(3);

  l_hw_node_info_array := split_str(l_ecs_hw_node_cell2, '|');
  l_host_name_parts := split_str(l_hw_node_info_array(8), '.');  
  insert into ecs_hw_nodes
  values(l_hw_node_id_array(3)+1, l_cabinet_id, l_ib_fabric_id, 
         l_hw_node_info_array(3), l_hw_node_info_array(4), 
         l_hw_node_info_array(5), l_hw_node_info_array(6),
         systimestamp, l_hw_node_info_array(7),
         l_hw_node_info_array(8), l_hw_node_info_array(7), 
         l_host_name_parts(1)||'-ilom', l_hw_node_info_array(9),
         l_hw_node_info_array(10),
         l_hw_node_info_array(11), l_hw_node_info_array(12))
   returning id into l_hw_node_id_array(4);
         
  l_hw_node_info_array := split_str(l_ecs_hw_node_cell3, '|');
  l_host_name_parts := split_str(l_hw_node_info_array(8), '.');  
  insert into ecs_hw_nodes
  values(l_hw_node_id_array(4)+1, l_cabinet_id, l_ib_fabric_id, 
         l_hw_node_info_array(3), l_hw_node_info_array(4), 
         l_hw_node_info_array(5), l_hw_node_info_array(6),
         systimestamp, l_hw_node_info_array(7),
         l_hw_node_info_array(8), l_hw_node_info_array(7), 
         l_host_name_parts(1)||'-ilom', l_hw_node_info_array(9),
         l_hw_node_info_array(10), 
         l_hw_node_info_array(11), l_hw_node_info_array(12))
   returning id into l_hw_node_id_array(5);

   -- isnert into ecs_caviums
   l_cavium_info_array := split_str(l_ecs_domu1_cavimum1, '|');
   --'1|cavium.1|eth4|0a:0b:0c:03:02:01|db_backup';
   insert into ecs_caviums
   values (l_hw_node_id_array(1),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));
   l_cavium_info_array := split_str(l_ecs_domu1_cavimum2, '|');
   insert into ecs_caviums
   values (l_hw_node_id_array(1),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));
   l_cavium_info_array := split_str(l_ecs_domu1_cavimum3, '|');
   insert into ecs_caviums
   values (l_hw_node_id_array(1),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));
   l_cavium_info_array := split_str(l_ecs_domu1_cavimum4, '|');
   insert into ecs_caviums
   values (l_hw_node_id_array(1),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));

   l_cavium_info_array := split_str(l_ecs_domu2_cavimum1, '|');
   insert into ecs_caviums
   values (l_hw_node_id_array(2),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));
   l_cavium_info_array := split_str(l_ecs_domu2_cavimum2, '|');
   insert into ecs_caviums
   values (l_hw_node_id_array(2),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));
   l_cavium_info_array := split_str(l_ecs_domu2_cavimum3, '|');
   insert into ecs_caviums
   values (l_hw_node_id_array(2),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));
   l_cavium_info_array := split_str(l_ecs_domu2_cavimum4, '|');
   insert into ecs_caviums
   values (l_hw_node_id_array(2),l_cavium_info_array(2),
           l_cavium_info_array(3), l_cavium_info_array(4),
           upper(l_cavium_info_array(5)));
   
   -- insert into ecs_domus
   --'scam07-qr-1|1|192.168.128.101/22|scam07adm01vm01-nat.us.oracle.com|169.254.0.10/24|0c:0b:0a:01:02:03|0c:0b:0a:01:02:04|0c:0b:0a:01:02:05';
   l_domu_info_array := split_str(l_ecs_domu1, '|');
   insert into ecs_domus
   values (l_domu_info_array(1), l_hw_node_id_array(1),
           l_domu_info_array(3), l_domu_info_array(4),
           l_domu_info_array(7) , l_domu_info_array(8));

   l_domu_info_array := split_str(l_ecs_domu2, '|');
   insert into ecs_domus
   values (l_domu_info_array(1), l_hw_node_id_array(2),
           l_domu_info_array(3), l_domu_info_array(4),
           l_domu_info_array(7), l_domu_info_array(8));

   -- insert into ecs_racks
   l_ecs_racks_info_array := split_str(l_ecs_racks, '|');
   insert into ecs_racks(domu, name, status)
   values (l_ecs_racks_info_array(1), l_ecs_racks_info_array(2), 'READY');

   -- insert into ecs_oracle_admin_subnets (for this test script timezone is hardcoded)
   insert into ecs_oracle_admin_subnets
   values (l_vnc_info_array(1), l_vnc_info_array(2), l_ecs_racks_info_array(2));

end;
/
