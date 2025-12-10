set serveroutput on size 100000;
set linesize 4000;
set pagesize 4000;
begin

  FOR i IN (select * from async_calls a where not exists (select 1 from ecs_requests r where r.status_uuid = a.uuid))
  LOOP

    insert into ecs_requests (id, operation, status, status_uuid, start_time, end_time, resource_id, details, errors)
    values (i.uuid, i.type, nvl(i.status,'599'), i.uuid, i.start_time, i.end_time, i.rid, i.details, i.errors);

    dbms_output.put_line('Added request: ' || i.uuid || ' status: ' || nvl(i.status,'599') || ' operation: ' || i.type);
  END LOOP;
end;

/
exit;