Rem
Rem $Header: ecs/ecra/db/seed_tables_exacc.sql /main/2 2019/05/22 15:48:05 hhhernan Exp $
Rem
Rem seed_tables_exacc.sql
Rem
Rem Copyright (c) 2018, 2019, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      seed_tables_exacc.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      Intended to be called after see_table.sql for 
Rem      specific ExaCC values
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/seed_tables_exacc.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hhhernan    05/22/19 - 29740321 CleanUp ExaCloud requets table
Rem    hhhernan    08/22/18 - 28455118 add specific exacc values for base sys
Rem    hhhernan    08/22/18 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

PROMPT Setting ExaCC values 
UPDATE ecs_properties SET value='exacm' WHERE name='ECRA_ENV';
UPDATE ecs_properties SET value='X7-2' WHERE name='MIN_BASE_SYSTEM_MODEL';
UPDATE ecs_properties SET value='X7-2' WHERE name='DEFAULT_BASE_SYSTEM_MODEL';
UPDATE ecs_properties SET value='X6-2' WHERE name='DEFAULT_NON_BASE_SYSTEM_MODEL';
PROMPT All ExaCC Values were set


Rem ---  29740321 ---
--- PROMPT Checking total entries in requests table
--- select count(uuid) from requests;

---PROMPT Checking requests of rack_info, info and checkcluster from more than a week ago
---select count(to_date( substr(starttime,4,length(starttime)),'Mon DD hh24:mi:ss yyyy' ,'NLS_DATE_LANGUAGE = American')) fmt_date
---from requests
---where cmdtype in('cluctrl.rack_info','cluctrl.info','cluctrl.checkcluster')
---and status = 'Done'
---and  to_date( substr(starttime,4,length(starttime)),'Mon DD hh24:mi:ss yyyy' ,'NLS_DATE_LANGUAGE = American') <  (sysdate-7)
---order by fmt_date desc;


PROMPT Cleaning ExaCloud requests table
DELETE requests
WHERE cmdtype in('cluctrl.rack_info','cluctrl.info','cluctrl.checkcluster')
and status = 'Done'
and  to_date( substr(starttime,4,length(starttime)),'Mon DD hh24:mi:ss yyyy' ,'NLS_DATE_LANGUAGE = American') <  (sysdate-7) ;
PROMPT ExaCloud requests table cleaned

---PROMPT Checking total entries in requests table
---select count(uuid) from requests;

commit;
quit;
