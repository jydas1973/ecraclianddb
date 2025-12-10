Rem
Rem $Header: ecs/ecra/db/aq_config.sql /main/1 2025/09/04 06:49:30 aypaul Exp $
Rem
Rem aq_config.sql
Rem
Rem Copyright (c) 2025, Oracle and/or its affiliates.
Rem
Rem    NAME
Rem      aq_config.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aypaul      09/02/25 - Created
Rem

DECLARE
  v_queue_table_name VARCHAR2(128) := '&1';
  v_queue_name VARCHAR(128)        := '&2';
  v_currentschema VARCHAR(128)     := '&3';
  v_schema_queuetable_name VARCHAR(128);
  v_schema_queue_name VARCHAR(128);
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM ALL_TABLES
  WHERE TABLE_NAME = UPPER(v_queue_table_name)
  AND OWNER = UPPER(v_currentschema);

  IF v_count = 0 THEN
    v_schema_queuetable_name := UPPER(v_currentschema)|| '.' || UPPER(v_queue_table_name);
    v_schema_queue_name      := UPPER(v_currentschema) || '.' || UPPER(v_queue_name);
    dbms_aqadm.create_queue_table(v_schema_queuetable_name, 'RAW');
    dbms_aqadm.create_queue(v_schema_queue_name, v_schema_queuetable_name);
  END IF;
END;
/

commit;
