"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    Status - CLI for status on the exaunit or on a UUID

FUNCTION:
    Provides the cli to query the status information

NOTE:
    None

History:
    rgmurali    07/14/2017 - Create file
"""
from formatter import cl
import json

class Status:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    # get the status information from a status uuid or a request id
    def do_status(self, ecli, line, host):
        isUUID = True
        try:
            exaunit_id = int(ecli.exaunit_id_from(line))
            isUUID = False
        except:
            pass

        if isUUID:
            request_id = line
        else:
            # try to get the latest view of ongoing operations
            try:
                ecli.pull_exaunits()
            except Exception as e:
                cl.perr("failed to pull exaunits state info please check whether ecra service is up and running")
                cl.perr(str(e))
                return

            if exaunit_id not in ecli.exaunits or "request_id" not in ecli.exaunits[exaunit_id]:
                cl.prt("c", "No ongoing operation found for exaunit " + str(exaunit_id))
                return
            request_id = ecli.exaunits[exaunit_id]["request_id"]

        if not request_id:
            cl.perr("Please specify a valid request/status uuid")
            return

        ecli.issue_get_request("{0}/statuses/{1}".format(host, request_id))

    def do_get_submitted_wf_list(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        required_params = {"id", "resource_id", "status", "operation", "start_time","wf_uuid", "end_time"}
        result = required_params & set(params)

        if len(result) > 0:
            urlStr = "{0}/statuses/listSubmittedWf"
            urlStr += "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
            response = ecli.HTTP.get(urlStr.format(host))
            if response:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
        else:
            cl.perr("[listSubmittedWf]: Required parameter are not present in request, Available fields for query are: {0}".format(required_params))
            return
