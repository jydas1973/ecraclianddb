"""
 Copyright (c) 2015, 2022, Oracle and/or its affiliates.

NAME:
    Profiling class to retrieve  statistical values for operations that are happening in ECRA and DBC

FUNCTION:
    Provides the clis to get and create Profiling operations

NOTE:
    None

History:
    ddelgadi    11/30/22 - Enh - 34833717 Added parameter to show subtask
    ddelgadi    05/05/22 - Bug - 33195567 Added parameter to profiling/{infrastructure} 
    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
    rgmurali    10/30/19 - ER 30390456 Adding ExaCS profiling
    jvaldovi    08/14/19 - Adding /profiling/{rackname} endpoint when rackname is passed
    jvaldovi    07/19/19 - Adding profiling operation
    jvaldovi    07/19/19 - Create file
"""

from formatter import cl
from os import path
import http.client
import json
import os

class Profiling:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        
    def do_profiling_report(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
             ecli.validate_parameters('profiling', 'report', params)
        except Exception as e:
            return cl.perr(str(e))
        #if rackname if given will call endpoint for specific rack information
        rack = ""
        if "rackname" in params:
            rack = params["rackname"]
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put( "{0}/profiling/{1}".format(host,rack ), data, "atp")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_profiling_infrastructure(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
             ecli.validate_parameters('profiling', 'infrastructure', params)
        except Exception as e:
            return cl.perr(str(e))

        if "ceiocid" in params:
            operation = params["ceiocid"]
        else:
            return cl.perr("infrastructure should be include in command")

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/profiling/infrastructure/{1}".format(host,operation), data, "atp")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


    def do_profiling_operation(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('profiling', 'operation', params)
        except Exception as e:
            return cl.perr(str(e))
        if "taskId" in params:
            operation = params["taskId"]
        else:
            return cl.perr("Operation should be include in command")

        if "subtask" in params:
            params["subtask"] = bool(params["subtask"])
        else:
            params["subtask"] = False

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/profiling/operation/{1}".format(host, operation), data, "atp")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


