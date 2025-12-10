#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/FaultInjection.py /main/1 2025/02/26 07:34:40 hcheon Exp $
#
# FaultInjection.py
#
# Copyright (c) 2025, Oracle and/or its affiliates.
#
#    NAME
#      FaultInjection.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    hcheon      02/10/25 - 37379447 whitelist infra for fault injection test
#    hcheon      02/10/25 - Creation
#
import json

from formatter import cl


class FaultInjection:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_list_infra(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('faultinjection', 'listinfra', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/faultInjectionInfra'.format(host)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

    def do_add_infra(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('faultinjection', 'addinfra', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/faultInjectionInfra/{1}'.format(host, params['infraocid'])
        response = self.HTTP.post('', None, url)
        cl.prt('n', json.dumps(response, indent=2))

    def do_delete_infra(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('faultinjection', 'deleteinfra', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/faultInjectionInfra/{1}'.format(host, params['infraocid'])
        response = self.HTTP.delete(url)
        cl.prt('n', json.dumps(response, indent=2))
