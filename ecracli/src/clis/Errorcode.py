#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Errorcode.py /main/1 2022/09/22 22:34:54 illamas Exp $
#
# Errorcode.py
#
# Copyright (c) 2022, Oracle and/or its affiliates.
#
#    NAME
#      Errorcode.py - <one-line expansion of the name>
#
#    DESCRIPTION
#     A class that helps users to interact with error codes
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    illamas     09/13/22 - Creation
#
from formatter import cl
import json

class Errorcode:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_get(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('errorcode', 'get', params)
        except Exception as e:
            return cl.perr(str(e))

        err_code = params.get("code")

        url  = "{0}/errorcodes/{1}".format(host,err_code)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_category(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('errorcode', 'category', params)
        except Exception as e:
            return cl.perr(str(e))

        err_code = params.get("code")

        url  = "{0}/errorcodes/{1}/category".format(host,err_code)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_endpoint(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('errorcode', 'endpoint', params)
        except Exception as e:
            return cl.perr(str(e))

        endpoint = params.get("name")

        url  = "{0}/errorcodes/endpoint/{1}".format(host,endpoint)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

#eof
