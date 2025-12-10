"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Testops - CLI for triggering some test functions
FUNCTION:
    Provides the cli to createdelete

NOTE:
    None

History:
    marcoslo    08/08/2020 - ER 30613740 Update code to use python 3
    rgmurali    06/29/2017 - Create file
"""
from formatter import cl
import urllib.request, urllib.error, urllib.parse

class Testops:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    # create service and delete it upon completion
    def do_test_createdelete(self, ecli, line, host):
        response = ecli.issue_create_service(line, warning=False)
        if not response:
            return

        ecli.waitForCompletion(response, "create_service", requireCompletion=True)
        try:
            created_exaunit = (self.HTTP.get(response["status_uri"], ignoreError=True))["target_uri"].split("/")[-1]
        except Exception as e:
            cl.perr("unable to fetch exaunit id from target_uri: " + str(e))


        if ecli.interactive:
            cl.prt("c", "Deleting service with exaunit ID: {0}".format(created_exaunit))
        response = self.HTTP.delete("{0}/exaunit/{1}".format(host, created_exaunit))
        ecli.waitForCompletion(response, "delete_service", requireCompletion=True)
        ecli.pull_exaunits()
