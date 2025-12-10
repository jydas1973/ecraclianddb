Rem
Rem $Header: ecs/ecra/db/update_endtime.sql /main/1 2016/11/03 19:48:06 angfigue Exp $
Rem
Rem update_endtime.sql
Rem
Rem Copyright (c) 2016, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      update_endtime.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/update_endtime.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    SQL_CALLING_FILE:
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    angfigue    11/02/16 - update format
Rem    angfigue    11/01/16 - update the endtime format
Rem    angfigue    11/01/16 - Created
Rem

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

set heading off;
set serveroutput on;

DECLARE
    char_end_time ecs_requests.end_time%type;
    updatedtime   TIMESTAMP WITH TIME ZONE;
    items         number;
BEGIN
    select count(*) into items from ecs_requests WHERE REGEXP_LIKE(LOWER(end_time), '^[a-z]');
    DBMS_OUTPUT.put_line(' legacy items: ' || items);

    FOR item in (SELECT * from ecs_requests WHERE REGEXP_LIKE(LOWER(end_time), '^[a-z]'))
    LOOP
        SELECT TO_TIMESTAMP_TZ(item.end_time, 'DY MON DD hh24:mi:ss YYYY') at local zone INTO updatedtime FROM dual;
        SELECT TO_CHAR(updatedtime, 'YYYY-MM-DD"T"hh24:mi:ssTZHTZM') INTO char_end_time FROM dual;
        UPDATE ecs_requests SET end_time=char_end_time;
        COMMIT;
        DBMS_OUTPUT.put_line(item.id || ' old (' || item.end_time || ')  new (  ' || char_end_time);
    END LOOP;

    select count(*) into items from ecs_requests WHERE REGEXP_LIKE(LOWER(end_time), '^[a-z]');
    DBMS_OUTPUT.put_line(' remaining: ' || items);

END;
/
