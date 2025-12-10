#! /usr/bin/env python3
#
# $Header: ecs/ecra/db/misc/partition_archive_tables.py /main/6 2024/02/26 15:24:44 dtalla Exp $
#
# partition_archive_tables.py
#
# Copyright (c) 2023, 2024, Oracle and/or its affiliates.
#
#    NAME
#      partition_archive_tables.py - Partition ECRA Tables and
#      archive the partitions exceeding retention period.
#
#    DESCRIPTION
#      Interval partitioning is required on ECRA table to maintain the data.
#
#    MODIFIED   (MM/DD/YY)
#    kukrakes    01/22/24 - Bug 36186763 - EXACS: ECRA-DB-PARTITIONING: ECRA
#                           OPERATIONS FAILING POST PARTITIONING AND ARCHIVING
#                           OF TABLES
#    dtalla      11/03/23 - Creation
#
import argparse
import atexit
import logging as log
import os
import cx_Oracle
import csv
import getpass
import socket
from datetime import datetime

parser = argparse.ArgumentParser(description='ECRA Schema Maintenance Utility')

parser.add_argument('--archive', dest='archive', action='store_true',
                    help='Flag controls archiving on given tables')
parser.add_argument('--column', dest='pColumn', action='store',
                    help='Partitioning column name, should be of type timestamp')
parser.add_argument('--dbHost', dest='dbHost', action='store',
                    default=socket.getfqdn(), help='Database Host Name/IP')
parser.add_argument('--dbPort', dest='dbPort', action='store',
                    default=1521, help='ECRA Database listener port, (default: 1521)')
parser.add_argument('--dbService', dest='dbService', action='store',
                    required=True, help='ECRA DB service')
parser.add_argument('--dbUser', dest='dbUser', action='store',
                    default='ECRADBUSER', help='ECRA database user name')
parser.add_argument('--debug', dest='debug', action='store_true',
                    help='enable debug mode (default: false)')
parser.add_argument('--logDir', dest='logDir', action='store', default='/tmp/ecraLog',
                    help='Log file directory path (default: /tmp/ecraLog)')
parser.add_argument('--seedFile', dest='seed', action='store',
                    help='File with table details')
parser.add_argument('--retain', dest='retain', action='store',
                    help='retain X days of data in tables, (default: 60)')
parser.add_argument('--report', dest='report', action='store_true',
                    help='only reports on partition and archive')
parser.add_argument('--table', dest='table', action='store',
                    help='Table name to partition and / or archive')

args = parser.parse_args()

# Checking whether log directory exists and writeable #
if (os.path.isdir(args.logDir) is False):
    exit(f'Log directory {args.logDir} does not exists')
MODULE = os.path.basename(__file__)
logFile = f'{args.logDir}/{os.path.splitext(MODULE)[0]}_{args.table}_{os.getpid()}.log'

# Initiating logging #
log.basicConfig(filename=logFile,
                format='%(asctime)s: %(levelname)s - %(message)s',
                level=log.DEBUG if args.debug else log.INFO)
print(f'Please check log: {logFile} to track progress\n')
log.info('#### START ####')
log.debug(f'List of arguments: {vars(args)}')


def __exitHandler():
    """ Take care of cleanup and state updates """
    log.info("Exit cleanup")
    if cursor:
        log.info("Closing cursor")
        cursor.close()
    if connection:
        log.info("Closing connection")
        connection.close()


def __execute(cursor, sql, fetch=True):
    """ Execute given sql statement in given cursor
    return the results, if fetch is True
    """
    log.debug(f'Running query: {sql}')
    err = 0
    try:
        cursor.execute(sql)
        # Fetching the result, if fetch is True #
        rows = cursor.fetchall() if fetch else []
    except cx_Oracle.DatabaseError as e:
        log.critical(f"Exception running {sql}\n{e}")
        err = 1
        rows = []
    return (rows, err)


def __partition(table, column, check=True):
    """ Partition given table using given column
    return 1 on success and 0 on failure
    """
    # checking whether table exists #
    if check is True:
        if not __checkTable(table):
            log.info(f"Table {table} does not exists")
            return 0
    # checking partition status on table #
    log.info(f"Checking whether '{table}' already partitioned..")
    sql = (f'SELECT COUNT(*) FROM USER_PART_TABLES '
           f"WHERE UPPER(TABLE_NAME) = '{table}'")
    rows, err = __execute(cursor, sql)
    if err:
        log.critical(f'Failed to identify partition status of table: {table}')
        return 0
    elif rows[0][0]:
        log.info(f"Table: '{table}' already partitioned")
    # partitioning the table #
    # Moving all data before Jul 2022 to single partition #
    else:
        if not column:
            column = 'start_time_ts'  # using default, if no column given
            log.info(f"No partitioning column given, using default: '{column}'")
        else:
            column = column.strip()
        # Validating column #
        log.info(f'Validating partitioning column: {column}')
        sql = f'SELECT COUNT(ROWNUM) FROM {table} WHERE {column} IS NULL'
        rows, err = __execute(cursor, sql)
        if err:
            log.critical(f'Invalid column {column} from {table}')
            return 0
        if rows[0][0]:
            log.critical(f"'{column}' has NULL cells, invalid for partitioning")
            return 0
        # Partitioning table #
        sql = (f'ALTER TABLE {table} MODIFY'
               f' PARTITION BY RANGE ({column})'
               f" INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))"
               f" (PARTITION {table}_BEFORE_JUL2022 "
               f" VALUES LESS THAN (TO_DATE('01-07-2022', 'DD-MM-YYYY')))"
               f" ONLINE")
        # Reports the sql statement and table will not be partitioned #
        if args.report:
            log.info(f'Table will be partitioned using query: {sql}')
            return 1
        log.info(f"Partitioning table: '{table}'")
        rows, err = __execute(cursor, sql, fetch=False)
        if err:
            log.critical(f'Failed partitioning table: {table}')
            return 0
        # Gathering stats on table after partitioning #
        log.info(f'Gathering stats on table')
        sql = f"BEGIN DBMS_STATS.GATHER_TABLE_STATS('{args.dbUser}', '{table}'); END;"
        rows, err = __execute(cursor, sql, fetch=False)
        if err:
            log.critical(f'Failed gathering stats on table: {table}')
            return 0
    return 1


def __checkTable(table):
    """Check whether table exists or not"""
    log.info(f"Checking table: {table}..")
    sql = (f"SELECT COUNT(*) FROM USER_TABLES"
           f" WHERE UPPER(TABLE_NAME) = '{table}'")
    rows, err = __execute(cursor, sql)
    if err:
        log.critical(f'Failed checking table: {table}')
        return 0
    elif rows[0][0] == 0:
        log.info(f"Table: '{table}' does not exists")
        return 0
    else:
        log.info(f"Table: '{table}' exists")
    return 1


def __archive(table, retain, column):
    """Archive given table using given retention window
    Default retention window, 60 days
    """
    # Setting retain to default, if not passed #
    retain = int(retain) if retain else 60
    # Checking whether archive table exist, create one if does not #
    # Default: <table_name>_ARCHIVE
    # No action will be taken, if report flag is set #
    stageTable = f"{table}_STAGE"
    archiveTable = f"{table}_ARCHIVE"
    if not args.report:
        for _table in (stageTable, archiveTable):
            # Creating archive / stage table #
            if not __checkTable(_table):
                log.info(f"Creating table: {_table}")
                sql = (f"CREATE TABLE {_table}"
                    f" FOR EXCHANGE WITH TABLE {table}")
                rows, err = __execute(cursor, sql, fetch=False)
                if err:
                    log.critical(f'Failed table: {_table}')
                    return 0
        # Partitioning archive table #
        if not __partition(archiveTable, column, check=False):
            log.critical(f'Failed partitioning archive table: {archiveTable}')
            return 0
    # checking for existing partitions in source table #
    # Note converting high_value from clob to date and calculating number of days from sysdate #
    sql = """WITH FUNCTION clobToDate( value IN CLOB ) RETURN DATE
  IS
    ts DATE;
  BEGIN
    EXECUTE IMMEDIATE 'BEGIN :ts := ' || value || '; END;' USING OUT ts;
    RETURN ts;
  END;
SELECT PARTITION_NAME,
      HIGH_VALUE,
       TRUNC(sysdate - clobToDate(
         EXTRACTVALUE(
           dbms_xmlgen.getxmltype(
             'SELECT high_value'
             || ' FROM  USER_TAB_PARTITIONS'
             || ' WHERE PARTITION_NAME    = ''' || t.PARTITION_NAME || ''''
           ),
           '//text()'
         )
       )) AS days
FROM   USER_TAB_PARTITIONS t
WHERE UPPER(TABLE_NAME) = '{table}' ORDER BY 3 DESC
    """.format(table=table)
    rows, err = __execute(cursor, sql)
    if err:
        log.critical(f'Failed getting partitions of "{table}"')
        return 0
    log.debug(f"Partition Names and Age: {rows}")
    # variable to track archived and total partition #
    archived = 0
    totalPartitions = len(rows)
    # Parsing the partitions #
    for row in rows:
        partition, highValue, pAge = row
        eligible = 'YES' if pAge > retain else 'NO'
        log.info(f"""\n
        Partition: {partition}
        Partition Date: {highValue}
        Partition Age: {pAge}
        Archive Eligibility (older than {retain} days): {eligible}
        """)
        if args.report is False and eligible == 'YES':
            # Condition to skip archiving last partition in table #
            if totalPartitions == (archived + 1):
                log.info(f"This is the last or only partition in table, not archiving")
                return 1
            # Exchanging partitions #
            # ALTER TABLE WF_TASK_TABLE_BKP EXCHANGE
            # PARTITION <PARTITION> WITH TABLE WF_TASK_TABLE_BKP_STAGE
            log.info(f"Exchanging Partition: {partition}")
            # Exchange with stage #
            log.info(f'Staging partition: {partition}')
            sql = (f"ALTER TABLE {table} EXCHANGE PARTITION"
                   f" {partition} WITH TABLE {stageTable}"
                   f" WITHOUT VALIDATION UPDATE GLOBAL INDEXES")
            rows, err = __execute(cursor, sql, fetch=False)
            if err:
                log.critical(f'Failed staging partition: {partition}')
                return 0
            # Exchange with Archive #
            # ALTER TABLE WF_TASK_TABLE_BKP_ARCH EXCHANGE
            # PARTITION FOR ( TIMESTAMP ' 2022-09-01 00:00:00' ) WITH
            # TABLE WF_TASK_TABLE_BKP_STAGE WITHOUT VALIDATION
            log.info(f'Archiving partition: {partition}')
            sql = (f"ALTER TABLE {archiveTable} EXCHANGE"
                   f" PARTITION FOR ( {highValue} )"
                   f" WITH TABLE {stageTable}"
                   f" WITHOUT VALIDATION UPDATE GLOBAL INDEXES")
            rows, err = __execute(cursor, sql, fetch=False)
            if err:
                log.critical(f'Failed archiving partition: {partition}')
                return 0
            # Drop archived partitions #
            sql = (f"ALTER TABLE {table} DROP PARTITION {partition}")
            rows, err = __execute(cursor, sql, fetch=False)
            if err:
                log.critical(f'Failed archiving partition: {partition}')
                return 0
            archived += 1
    return 1


def partArch(table, column, archive, retain):
    """Partition and archive the given table using given args """
    # Cleaning variables #
    table = table.strip().upper()
    column = column
    log.debug(f'### Start of Table: {table} ###\n')
    if args.report:
        log.info("ONLY REPORTING AS '--report' FLAG WAS USED")
    log.info(f'Table: {table}')
    if not __partition(table, column) and archive:
        log.warning((f'Partitioning does not exists or has issues'
                     f' on table: {table}, not continuing with archive'))
    elif archive:
        __archive(table, retain, column)
    else:
        log.info(f'Archive set to: {archive}, no action needed')
    log.debug(f'### End of Table: {table} ###\n')


# Validating arguments, Need table or seedFile for partitioning #
if not any([args.table, args.seed]):
    parser.print_usage()
    msg = (f"{__file__}: Error: Missing mandatory arguments"
           f" please provide --table or --seedFile")
    log.critical(msg)
    exit(f'\n{msg}')

# Seeking DB user password #

_passwd = getpass.getpass(prompt='Enter dbUser password: ')
_reEntry = getpass.getpass(prompt='Confirm password: ')
if (_passwd != _reEntry):
    exit("Password did not match")

cString = f'{args.dbHost}:{args.dbPort}/{args.dbService}'
log.info(f'Using database connect string: {cString}')
connection = cx_Oracle.connect(user=args.dbUser, password=_passwd,
                               dsn=cString, encoding="UTF-8")
cursor = connection.cursor()

atexit.register(__exitHandler)

# # Reading seedFile #
if args.seed:
    log.info(f"seed File is - {args.seed}")
    # Reading the file content #
    with open(args.seed, mode='r') as file:
        lines = csv.reader(file, skipinitialspace=True)
        for line in lines:
            # ignoring commented lines
            if not line[0].startswith('#'):
                if len(line) != 3:
                    log.error(f'Invalid entry: {line}, Ignoring...')
                    continue
                table, column, retain = line
                partArch(table, column, args.archive, retain)
else:
    partArch(args.table, args.pColumn, args.archive, args.retain)
