#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Sop.py /main/2 2024/07/18 21:58:36 jvaldovi Exp $
#
# Sop.py
#
# Copyright (c) 2023, 2024, Oracle and/or its affiliates.
#
#    NAME
#      Sop.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      Class that will handle SOP (Standard Operating Procedure) remote executions  into Exadata hardware
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    jvaldovi    06/18/24 - Enh 36697212 - Ecra: Remote Execution Cli Cannot
#                           Reach Out To Specified Cps In Exacc
#    jvaldovi    01/24/23 - Enh 34825983 - Ecra: Create Endpoint To Enable Sop
#                           Calls From Ecra
#    jvaldovi    01/24/23 - Creation
#
import json

from formatter import cl


class Sop:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_sop_list(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sop', 'list', params)
        except Exception as e:
            cl.perr(str(e))
            return
        query_params = ""
        if "exaocid" in params:
            query_params = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()])
        response = ecli.issue_get_request("{0}/sop/requests/scripts{1}".format(self.HTTP.host, query_params), printResponse=False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


    def do_sop_details(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sop', 'details', params)
        except Exception as e:
            cl.perr(str(e))
            return
        uuid = params.get('uuid')
        # TODO non implemented yet
        return

    def do_sop_request(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sop', 'request', params)
        except Exception as e:
            cl.perr(str(e))
            return
        data = None
        with open(params["jsonpayload"]) as json_file:
            data = json.load(json_file)
        mandatory_params = {"cmd", "nodes", "scriptname"}
        if "cmd" not in data:
            data["cmd"] = "start"

        #Check for mandatory params on request
        for mp in mandatory_params:
            if mp not in data.keys():
                cl.prt("n", "Payload must contain {0} mandatory params".format(mandatory_params))
                return
        # Add exaocid if passed
        if "exaocid" in params:
            data["exaocid"] = params["exaocid"]
        data = json.dumps(data, sort_keys=True, indent=4)
        response = self.HTTP.post(data, None, "{0}/sop/requests".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_sop_cancel(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sop', 'cancel', params)
        except Exception as e:
            cl.perr(str(e))
            return
        data = None
        with open(params["jsonpayload"]) as json_file:
            data = json.load(json_file)
        mandatory_params = {"cmd", "uuid"}
        if "cmd" not in data:
            data["cmd"] = "delete"

        #Check for mandatory params on request
        for mp in mandatory_params:
            if mp not in data.keys():
                cl.prt("n", "Payload must contain {0} mandatory params".format(mandatory_params))
                return
        # Add exaocid if passed
        if "exaocid" in params:
            data["exaocid"] = params["exaocid"]
        data = json.dumps(data, sort_keys=True, indent=4)
        response = self.HTTP.post(data, None, "{0}/sop/requests/cancel".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_sop_retry(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sop', 'retry', params)
        except Exception as e:
            cl.perr(str(e))
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        # TODO Not implemented yet
        return
