Rem
Rem $Header: ecs/ecra/db/upgrademvm.sql /main/1 2017/11/27 22:14:49 shlal Exp $
Rem
Rem upgrade1745.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1745.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrademvm.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    sachikuk    11/08/17 - Bug - 27086265 : Enhance rack slot registration
Rem    sachikuk    09/28/17 - ecra endpoints for customer network info
Rem                           management [Bug - 26885989]
Rem    sachikuk    09/28/17 - Created
Rem

SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

-- Create ecs_rack_slots table
create table ecs_rack_slots (
    rack_name        varchar2(256),
    exadata_id       varchar2(512) not null,
    details          CLOB not null,
    source           varchar2(256) not null, -- OPS, HIGGS
    CONSTRAINT pk_rack_slots_rack_name
        PRIMARY KEY (rack_name),
    CONSTRAINT fk_rack_slots_exadata_id
        FOREIGN KEY (exadata_id)
        REFERENCES ecs_exadata(exadata_id) NOVALIDATE,
    CONSTRAINT chk_rack_slots_source
       CHECK (source in ('OPS', 'HIGGS'))
);

COMMIT;
EXIT;
