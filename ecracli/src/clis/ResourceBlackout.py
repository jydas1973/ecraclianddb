#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/ResourceBlackout.py /main/1 2025/03/28 11:43:26 ybansod Exp $
#
# ResourceBlackout.py
#
# Copyright (c) 2025, Oracle and/or its affiliates.
#
#    NAME
#      ResourceBlackout.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    ybansod     03/18/25 - Enh 34558104 - PROVIDE API FOR ECRA RESOURCE
#                           BLACKOUT
#    ybansod     03/18/25 - Creation
#
from formatter import cl
import json

class ResourceBlackout:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_get_latest(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resourceblackout', 'getlatest', params)
        except Exception as e:
            cl.perr(str(e))
            return
        resource_name = params.get('resourcename')
        urlStr = "{0}/blackout/{1}"
        if "audit" in params:
            urlStr += "?audit=" + params.get('audit')
        response = self.HTTP.get(urlStr.format(host, resource_name))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_get_history(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resourceblackout', 'gethistory', params)
        except Exception as e:
            cl.perr(str(e))
            return
        resource_name = params.get('resourcename')
        urlStr = "{0}/blackout/history/{1}"
        if "daylimit" in params:
            urlStr += "?daylimit=" + params.get('daylimit')
        response = self.HTTP.get(urlStr.format(host, resource_name))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_get_enabled(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resourceblackout', 'getenabled', params)
        except Exception as e:
            cl.perr(str(e))
            return
        response = self.HTTP.get("{0}/blackout/enabled".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_create(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resourceblackout', 'create', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "payload" in params:
            params = json.load(open(params["payload"]))

        data = json.dumps(params, sort_keys=True, indent=4)

        response = self.HTTP.post(data, None, "{0}/blackout".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_update(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resourceblackout', 'update', params)
        except Exception as e:
            cl.perr(str(e))
            return

        resource_name = params.get('resourcename')
        if "payload" in params:
            params = json.load(open(params["payload"]))

        data = json.dumps(params, sort_keys=True, indent=4)

        response = self.HTTP.put("{0}/blackout/{1}".format(host, resource_name), data, None)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_refresh(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resourceblackout', 'refresh', params)
        except Exception as e:
            cl.perr(str(e))
            return

        resource_name = params.get('resourcename')

        response = self.HTTP.put("{0}/blackout/refresh-status/{1}".format(host, resource_name), "", None)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_disable(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resourceblackout', 'disable', params)
        except Exception as e:
            cl.perr(str(e))
            return

        resource_name = params.get('resourcename')

        response = self.HTTP.put("{0}/blackout/{1}".format(host, resource_name), '{"status":"DISABLED"}', None)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

