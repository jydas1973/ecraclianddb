#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Compatibility.py /main/1 2024/11/27 22:42:19 zpallare Exp $
#
# Compatibility.py
#
# Copyright (c) 2024, Oracle and/or its affiliates.
#
#    NAME
#      Compatibility.py - CLIs for compatibility matrix
#
#    DESCRIPTION
#      Provides clis for compatibility matrix
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    zpallare    09/09/24 - Creation
#

from formatter import cl
import json

class Compatibility:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_compatibility_list(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="operationname")
        try:
            ecli.validate_parameters("compatibility", "list", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/compatibility".format(host)
        if "operationname" in params:
            url += "/{0}".format(params.get("operationname"))
        response = ecli.issue_get_request(url, False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
        
    def do_compatibility_add(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="operationname")
        try:
            ecli.validate_parameters("compatibility", "add", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/compatibility/{1}".format(host, params.get("operationname"))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(url, data, "compatibility")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_compatibility_remove(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="operationname")
        try:
            ecli.validate_parameters("compatibility", "remove", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/compatibility/remove/{1}".format(host, params.get("operationname"))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "compatibility", url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_compatibility_check(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="operationname")
        try:
            ecli.validate_parameters("compatibility", "check", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/compatibility/check/{1}".format(host, params.get("operationname"))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "compatibility", url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_compatibility_validoperations(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("compatibility", "validoperations", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/compatibility/validoperations".format(host)
        response = ecli.issue_get_request(url, False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))