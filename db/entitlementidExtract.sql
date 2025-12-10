set serveroutput on size 100000;
set linesize 4000;
set pagesize 4000;

begin

    FOR i IN (select id as sid, service_entitlement_id as eid from cim_instances where service_type='Exadata')
    LOOP

    dbms_output.put_line('UPDATE ecs_subscriptions SET entitlement_id=''' || i.eid || ''' WHERE ' || 'subscription_id=''' || i.sid || ''';');
    dbms_output.put_line('UPDATE ecs_exaunitdetails SET entitlement_id=''' || i.eid || ''' WHERE ' || 'subscription_id=''' || i.sid || ''';');
    
    END LOOP;
end;
/
exit;