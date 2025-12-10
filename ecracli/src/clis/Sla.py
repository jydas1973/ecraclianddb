#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Sla.py /main/7 2024/04/08 03:55:58 jiacpeng Exp $
#
# Sla.py
#
# Copyright (c) 2022, 2024, Oracle and/or its affiliates.
#
#    NAME
#      Sla.py - CLIs for SLA sub-operations
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    jiacpeng    04/01/24 - exacs-129321: refomat sla api for OneView
#                           integration
#    jiacpeng    09/22/23 - redesign of SLA feature
#    jiacpeng    05/09/23 - add enable sla by tenancy
#    jiacpeng    11/04/22 - adding the enpoint for getting SLA based on
#                           infraOcid (CEI)
#    hcheon      06/02/22 - 34166256 Added SLA of tenancies
#    hcheon      02/08/22 - 33691502 Added SLA gathering
#    hcheon      02/08/22 - Creation
#
import json

from formatter import cl


class Sla:
    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host

    def do_sla_get_average_all(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla', 'get_average_all', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/average'.format(self.host)
        print(url)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_average(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla', 'get_average', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/average/{1}'.format(self.host, params.pop('rackname'))
        print(url)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_average_tenancy(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla', 'get_average_tenancy', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/average/tenancy/{1}'.format(self.host, params.pop('tenancy_ocid'))
        print(url)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_details(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla', 'get_details', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/details/{1}'.format(self.host, params.pop('rackname'))
        print(url)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_details_infra(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla','get_details_infra', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/details/infra/{1}'.format(self.host, params.pop('infraOcid'))
        print(url)
        response = self.HTTP.query(url,params)
        cl.prt('n',json.dumps(response, indent=2))

    def do_sla_tenancy_turnon(self, ecli, line): 
        params = ecli.parse_params(line, None) 
        try: 
            ecli.validate_parameters('sla', 'tenancy_turnon', params) 
        except Exception as e: 
            cl.perr(str(e)) 
            return 
        url = '{0}/sla/tenancy/turnon/{1}'.format(self.host, params.pop('tenancy_ocid')) 
        print(url)
        data = json.dumps(params, sort_keys=True, indent=4) 
        response = self.HTTP.put(url, data, None) 
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_tenancy_turnoff(self, ecli, line): 
        params = ecli.parse_params(line, None) 
        try: 
            ecli.validate_parameters('sla', 'tenancy_turnoff', params) 
        except Exception as e: 
            cl.perr(str(e)) 
            return 
        url = '{0}/sla/tenancy/turnoff/{1}'.format(self.host, params.pop('tenancy_ocid')) 
        print(url)
        data = json.dumps(params, sort_keys=True, indent=4) 
        response = self.HTTP.put(url, data, None) 
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_turnedon_tenancy(self, ecli, line): 
        params = ecli.parse_params(line, None) 
        try: 
            ecli.validate_parameters('sla', 'get_turnedon_tenancy', params) 
        except Exception as e: 
            cl.perr(str(e)) 
            return 
        url = '{0}/sla/tenancy/get_tenancy_sla_on'.format(self.host) 
        print(url)
        response = self.HTTP.query(url, params) 
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_tenant_report(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla', 'get_tenant_report', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/v1/tenant/{1}'.format(self.host, params.pop('tenancyOcid'))
        print(url)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_cei_report(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla', 'get_cei_report', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/v1/cei/{1}'.format(self.host, params.pop('cei'))
        print(url)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

    def do_sla_get_vm_report(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sla', 'get_vm_report', params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/sla/v1/vm/{1}'.format(self.host, params.pop('vm'))
        print(url)
        response = self.HTTP.query(url, params)
        cl.prt('n', json.dumps(response, indent=2))

