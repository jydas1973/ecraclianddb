Rem
Rem $Header: ecs/ecra/db/upgrade1726ExaCM.sql /main/1 2017/05/29 11:22:54 hgaldame Exp $
Rem
Rem upgrade1726ExaCM.sql
Rem
Rem Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      upgrade1726ExaCM.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: ecs/ecra/db/upgrade1726ExaCM.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    hgaldame    05/18/17 - upgrade1726ExaCM.sql does the upgrade to ExaCM1726
Rem    hgaldame    05/18/17 - Created
Rem

ALTER TABLE ecs_hardware ADD memsize number default 240 not null;
UPDATE ecs_hardware SET memsize=240 WHERE model='X6-2' AND racksize='EIGHTH';
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='QUARTER';  
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='HALF';
UPDATE ecs_hardware SET memsize=720 WHERE model='X6-2' AND racksize='FULL';
COMMIT;

EXIT;
