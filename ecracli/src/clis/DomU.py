#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/DomU.py /main/2 2024/09/09 16:37:36 illamas Exp $
#
# DomU.py
#
# Copyright (c) 2022, 2024, Oracle and/or its affiliates.
#
#    NAME
#      DomU.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      This cli class is the interface used to fetch DomU 
#
#    NOTES
#      At the moment it only retrieves data from ecs_domus.
#
#    MODIFIED   (MM/DD/YY)
#    illamas     09/03/24 - Enh 36918015 - Mark nathostname in ecs_domus and
#                           generate a new one for vm move
#    jzandate    09/20/22 - Bug 34616926 - Adding domu command to ecracli
#    jzandate    09/20/22 - Creation
#

from formatter import cl
import json

class DomU:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        
    def do_get_by_name(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('domu', 'get', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/domu/{1}".format(host, params["name"])
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
            
    def do_search(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        
        try:
            ecli.validate_parameters('domu', 'search', params)
        except Exception as e:
            cl.perr(str(e))
            return
        try:
            from urllib import urlencode
        except ImportError:
            from urllib.parse import urlencode
        query = urlencode(params) if len(params) > 0 else ""
        url = "{0}/domu/search?{1}".format(host, query)
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_domu_deletebadhostname(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('domu', 'deletebadhostname', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/domu/badnathostname/{1}".format(host, params["nathostname"])
        data = None
        response = self.HTTP.delete(url, data)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
