"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Exawatcher - CLIs related to exawatcher management and log collection

FUNCTION:
    Provides the clis to get exawatcher logs from cells, dom0s, domUs etc

NOTE:
    None

History:
    rgmurali    08/07/2019 - Create file
"""
from formatter import cl
import json

class Exawatcher:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_getlog_exawatcher(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('exawatcher', 'getlog', params)
        except Exception as e:
            cl.perr(str(e))
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/exawatcher/logs{1}".format(host, query), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_listlog_exawatcher(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('exawatcher', 'listlog', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/exawatcher/list/{1}{2}".format(host, rackname, query), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


