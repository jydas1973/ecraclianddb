"""
 Copyright (c) 2015, 2017, Oracle and/or its affiliates. All rights reserved.

NAME:
    CreateSdb - CLI for create-service and create-db combined

FUNCTION:
    Provides the cli to trigger a create-service followed by create starter db

NOTE:
    None

History:
    rgmurali    07/11/2017 - Create file
"""
from formatter import cl

class CreateSdb:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_create_sdb(self, ecli, line):
        response = ecli.issue_create_service(line, warning=False)
        if not response:
            return
        created_exaunit = ecli.waitForCompletion(response, "create_service", requireCompletion=True)
        if not created_exaunit:
            return
        ecli.pull_exaunits()

        line = line.split(' ', 1)
        params = (" " + line[1]) if len(line) > 1 else ""
        response = ecli.issue_create_db(created_exaunit + params, new_api=False)
        if not response:
            return
        ecli.waitForCompletion(response, "create_db")
