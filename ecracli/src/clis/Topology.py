#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Topology.py /main/4 2025/09/22 06:06:51 jiacpeng Exp $
#
# Sla.py
#
# Copyright (c) 2022, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Topology.py - CLIs for Topology sub-operations
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    jiacpeng    09/11/25 - Add Topology API pagination
#    jiacpeng    03/14/24 - EXACS-127613: Add cli support for topology
#                           proximity api
#    jiacpeng    01/26/24 - add topology network switch api
#    pkbose      21/09/23 - Creation
#
import json

from formatter import cl


class Topology:
    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host

    def do_topology_get_topology_for_ad(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('topology', 'get_topology_for_ad', params)
        except Exception as e:
            cl.perr(str(e))
            return
        page      = params.pop('page', None)
        pageSize  = params.pop('pageSize', params.pop('pagesize', None))  # accept both spellings
        version   = params.pop('version', None)

        def with_paging(u):
            qs = []
            if page is not None:
                qs.append(f'page={page}')
            if pageSize is not None:
                qs.append(f'pageSize={pageSize}')
            if version is not None:
                qs.append(f'version={version}')
            return u + (('&' + '&'.join(qs)) if qs else '')

        if 'rackname' in params:
            url = '{0}/topology/v1/availabilityDomains/{1}?serviceType={2}&rackNumber={3}'.\
                format(self.host,params.pop('ad'),params.pop('service'),params.pop('rackname'))
            url = with_paging(url)
            print(url)
            response = self.HTTP.query(url, params)
            cl.prt('n', json.dumps(response, indent=2))
        elif 'switchname' in params:
            url = '{0}/topology/v1/availabilityDomains/{1}?serviceType={2}&switchName={3}'.\
                format(self.host,params.pop('ad'),params.pop('service'),params.pop('switchname'))
            url = with_paging(url)
            print(url)
            response = self.HTTP.query(url, params)
            cl.prt('n', json.dumps(response, indent=2))
        elif 'clustername' in params:
            url = '{0}/topology/v1/availabilityDomains/{1}?serviceType={2}&clusterName={3}'.\
                format(self.host,params.pop('ad'),params.pop('service'),params.pop('clustername'))
            url = with_paging(url)
            print(url)
            response = self.HTTP.query(url, params)
            cl.prt('n', json.dumps(response, indent=2))
        elif 'vmclusterocid' in params:
            url = '{0}/topology/v1/availabilityDomains/{1}?serviceType={2}&vmClusterId={3}'.\
                format(self.host,params.pop('ad'),params.pop('service'),params.pop('vmclusterocid'))
            url = with_paging(url)
            print(url)
            response = self.HTTP.query(url, params)
            cl.prt('n', json.dumps(response, indent=2))
        else:
            url = '{0}/topology/v1/availabilityDomains/{1}?serviceType={2}'. \
                format(self.host, params.pop('ad'), params.pop('service'))
            url = with_paging(url)
            print(url)
            response = self.HTTP.query(url, params)
            cl.prt('n', json.dumps(response, indent=2))

    def do_topology_get_network_switch_for_ad(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('topology', 'get_network_switch_for_ad', params)
        except Exception as e:
            cl.perr(str(e))
            return
        if len(params) == 1:
            url = '{0}/topology/v1/networkSwitches/{1}'. \
                format(self.host, params.pop('ad'))
            print(url)
            response = self.HTTP.query(url, params)
            cl.prt('n', json.dumps(response, indent=2))
        elif 'physicalRackNumber' in params:
            url = '{0}/topology/v1/networkSwitches/{1}?physicalRackNumber={2}'. \
                format(self.host,params.pop('ad'),params.pop('physicalRackNumber'))
            print(url)
            response = self.HTTP.query(url, params)
            cl.prt('n', json.dumps(response, indent=2))


