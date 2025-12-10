#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Kvmroce.py /main/22 2025/03/24 05:44:25 bshenoy Exp $
#
# Kvmroce.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Kvmroce.py - CLIs to related to KVM RoCE project
#
#    DESCRIPTION
#      Provides the clis to run some of the KVM roce components such as
#      vlan and ip pools etc
#
#    NOTES
#
#    MODIFIED   (MM/DD/YY)
#    caborbon    03/20/25 - ENH 37664918 - Adding includearchivednodes in
#                           getAllCabinets
#    bshenoy     03/13/25 - EXACS-143285 - QFAB support for X11M & ABS
#                           Threshold
#    caborbon    03/06/25 - Bug 37613945 - Adding new parameter to getAllNodes
#                           and getAllCabinets
#    rgmurali    05/13/24 - ER 36009525 - Endpoint to check if exascale pool is created
#    rgmurali    06/13/22 - Bug 34229481 - Fix freeComputeIP with ListOfIps
#    rgmurali    04/12/22 - Enh 34062991 - Support exascale ip range
#    llmartin    03/16/22 - Enh 33846537 - SanityCheck support for ExaCS MVM
#    rgmurali    06/28/21 - ER 33056005 - APIs for cabinets/nodes
#    rgmurali    02/25/21 - ER 32481148 - Sanity check API for RoCE
#    rgmurali    12/28/20 - ER 32300454 - APIs for fabrics, cabinets & nodes
#    rgmurali    11/03/20 - ER 31951376 - add verbose option to listFabric
#    rgmurali    10/25/20 - ER 31951325 - Cabinet level utilization
#    rgmurali    09/23/20 - ER 31928370 - Add cabinet type in listFabric
#    rgmurali    04/20/20 - ER 31201148 Add list fabric support
#    rgmurali    03/03/20 - ER 30870817 - Fabric addition APIs
#    rgmurali    02/13/20 - ER 30802702 - Add IP Pool support for KVM RoCE
#    rgmurali    01/24/19 - ER 30663489 - KVM RoCE Vlan pool management
#    rgmurali    01/24/2018 - Create file
#

from formatter import cl
import json

class Kvmroce:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_allocateComputeVlan_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'allocateComputeVlan', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/vlan/compute".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_allocateStorageVlan_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'allocateStorageVlan', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/vlan/storage".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    
    def do_getComputeVlan_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getComputeVlan', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")

        response = ecli.issue_get_request("{0}/vlan/compute/{1}".format(host, rackname))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_getStorageVlan_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getStorageVlan', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")

        response = ecli.issue_get_request("{0}/vlan/storage/{1}".format(host, rackname))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_freeComputeVlan_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'freeComputeVlan', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/vlan/compute".format(host), data)

        if response:
            cl.prt("n", json.dumps(response))

    def do_freeStorageVlan_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'freeStorageVlan', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/vlan/storage".format(host), data)

        if response:
            cl.prt("n", json.dumps(response))

    def do_allocateComputeIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'allocateComputeIP', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/roce/ipaddress/compute".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_allocateStorageIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'allocateStorageIP', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/roce/ipaddress/storage".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_allocateExascaleIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'allocateExascaleIP', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/roce/ipaddress/exascale".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_getExascaleIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getExascaleIP', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")

        response = ecli.issue_get_request("{0}/roce/ipaddress/exascale/{1}".format(host, rackname))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_freeExascaleIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'freeExascaleIP', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/roce/ipaddress/exascale".format(host), data)

        if response:
            cl.prt("n", json.dumps(response))

    def do_getComputeIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getComputeIP', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")

        response = ecli.issue_get_request("{0}/roce/ipaddress/compute/{1}".format(host, rackname))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_getStorageIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getStorageIP', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")

        response = ecli.issue_get_request("{0}/roce/ipaddress/storage/{1}".format(host, rackname))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_freeComputeIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'freeComputeIP', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        data = json.dumps(params, sort_keys=True, indent=4)
        if "ListOfIps" in data and "rackname" in data:
            raise ValueError("Provide either rackname or ListOfIps, not both")
        response = self.HTTP.delete("{0}/roce/ipaddress/compute".format(host), data)

        if response:
            cl.prt("n", json.dumps(response))

    def do_freeStorageIP_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'freeStorageIP', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        data = json.dumps(params, sort_keys=True, indent=4)
        if "ListOfIps" in data and "rackname" in data:
            raise ValueError("Provide either rackname or ListOfIps, not both")
        response = self.HTTP.delete("{0}/roce/ipaddress/storage".format(host), data)

        if response:
            cl.prt("n", json.dumps(response))

    def do_addFabric_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'addFabric', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/roce/fabric".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_deleteFabric_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'deleteFabric', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/roce/fabric".format(host), data)
        if response:
            cl.prt("n", json.dumps(response))

    def do_listFabric_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'listFabric', params)
        except Exception as e:
            cl.perr(str(e))
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/roce/fabric{1}".format(host, query), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getAllFabric_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getAllFabric', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = ecli.issue_get_request("{0}/fabrics".format(host), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_isexascalepoolcreated_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'isexascalepoolcreated', params)
        except Exception as e:
            cl.perr(str(e))
            return

        fabricname = params["fabricname"]

        response = ecli.issue_get_request("{0}/roce/ipaddress/exascalepool/{1}".format(host, fabricname), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getAllCabinets_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getAllCabinets', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        query = ""
        if "includearchivednodes" in params:
            query = "?" + "&" + "includearchivednodes=" + params["includearchivednodes"]

        response = ecli.issue_get_request("{0}/fabrics/cabinets{1}".format(host,query), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getAllNodes_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getAllNodes', params)
        except Exception as e:
            cl.perr(str(e))
            return
       	
        query = ""
        if "includearchivednodes" in params:
            query = "?" + "&" + "includearchivednodes=" + params["includearchivednodes"]
        
        response = ecli.issue_get_request("{0}/fabrics/nodes{1}".format(host,query), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getCabinets_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getCabinets', params)
        except Exception as e:
            cl.perr(str(e))
            return

        fabric_name = params["fabric_name"]
        response = ecli.issue_get_request("{0}/fabrics/{1}/cabinets".format(host, fabric_name), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getCabinetNodes_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getCabinetNodes', params)
        except Exception as e:
            cl.perr(str(e))
            return

        fabric_name = params["fabric_name"]
        cabinet_name = params["cabinet_name"]
        response = ecli.issue_get_request("{0}/fabrics/{1}/cabinets/{2}".format(host, fabric_name, cabinet_name), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_runsanitycheck_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'runsanitycheck', params)
        except Exception as e:
            cl.perr(str(e))
            return

        #Convert the provided comma separated list in a JSON array.
        # iad103709exdd017,iad103709exdd016 -> "elasticnodes": ["iad103709exdd017","iad103709exdd016"]
        if "elasticnodes" in params and not params['elasticnodes'] is None:
            params["elasticnodes"] = params["elasticnodes"].split(',')

        if "idemtoken" not in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to reserve CEI for elastic shapes")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]
        
        cl.prt("n", "Idemtoken used is: " + params["idemtoken"])

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/kvmroce/sanitycheck".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_getsanityresults_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'getsanityresults', params)
        except Exception as e:
            cl.perr(str(e))
            return

        idemtoken = params.pop("idemtoken")

        response = ecli.issue_get_request("{0}/kvmroce/sanitycheck/{1}".format(host, idemtoken), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_listFaultDomains_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'listfaultdomains', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = ecli.issue_get_request("{0}/fabrics/faultdomains".format(host), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_updateFaultDomain_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'updatefaultdomain', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {}
        data['fault_domain'] = params.get('faultdomain')
        data['fabric_name'] = params.get('fabricname')
        data = json.dumps(data)

        response = ecli.HTTP.put('{0}/fabrics/faultdomains'.format(host), data, 'kvmroce')

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_get_elastic_reservation_threshold_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'get_elastic_reservation_threshold', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {}
        data['fabric_name'] = params.get('fabric_name')
        data = json.dumps(data)

        fabric_name = params["fabric_name"]
        response = ecli.issue_get_request("{0}/fabrics/{1}/elasticreservationthreshold/".format(host, fabric_name), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_set_elastic_reservation_threshold_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'set_elastic_reservation_threshold', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {}
        data['fabric_name'] = params.get('fabric_name')
        data['type'] = params.get('type')
        data['model'] = params.get('model')
        data['model_subtype'] = params.get('model_subtype')
        data['threshold'] = params.get('threshold')
        data = json.dumps(data)

        fabric_name = params["fabric_name"]
        model = params["model"]
        type = params["type"]
        query = "?type=" + params["type"] + "&model=" + params["model"] +  "&modelSubtype=" + params["model_subtype"] + "&threshold=" + params['threshold']
        #print('{0}/fabrics/{1}/elasticreservationthreshold{2}'.format(host, fabric_name, query))
        response = ecli.HTTP.put('{0}/fabrics/{1}/elasticreservationthreshold{2}'.format(host, fabric_name, query), None, 'kvmroce')

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_set_elastic_reservation_threshold_kvmroce_abs(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'set_elastic_reservation_threshold_abs', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {}
        data['fabric_name'] = params.get('fabric_name')
        data['type'] = params.get('type')
        data['model'] = params.get('model')
        data['model_subtype'] = params.get('model_subtype')
        data['threshold_abs'] = params.get('threshold_abs')
        data = json.dumps(data)

        fabric_name = params["fabric_name"]
        model = params["model"]
        type = params["type"]
        query = "?type=" + params["type"] + "&model=" + params["model"] +  "&modelSubtype=" + params["model_subtype"] + "&threshold_abs=" + params["threshold_abs"]

        #print('{0}/fabrics/{1}/elasticreservationthresholdAbs{2}'.format(host, fabric_name, query))
        response = ecli.HTTP.put('{0}/fabrics/{1}/elasticreservationthresholdAbs{2}'.format(host, fabric_name, query), None, 'kvmroce')

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))



    def do_get_elastic_reservation_setting_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'get_elastic_reservation_setting', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {}
        data['fabric_name'] = params.get('fabric_name')
        data = json.dumps(data)

        fabric_name = params["fabric_name"]
        response = ecli.issue_get_request("{0}/fabrics/{1}/elasticreservationsetting/".format(host, fabric_name), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_enable_utilization_based_elastic_reservation_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'enable_utilization_based_elastic_reservation', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {}
        data['fabric_name'] = params.get('fabric_name')
        data['type'] = params.get('type')
        data['model'] = params.get('model')
        data['threshold'] = params.get('threshold')
        data = json.dumps(data)

        fabric_name = params["fabric_name"]
        model = params["model"]
        query = "?model=" + params["model"] + "&setting=ENABLED"

        #print('{0}/fabrics/{1}/elasticreservationsetting{2}'.format(host, fabric_name, query))
        response = ecli.HTTP.put('{0}/fabrics/{1}/elasticreservationsetting{2}'.format(host, fabric_name, query), None, 'kvmroce')

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_disable_utilization_based_elastic_reservation_kvmroce(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('kvmroce', 'disable_utilization_based_elastic_reservation', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {}
        data['fabric_name'] = params.get('fabric_name')
        data['type'] = params.get('type')
        data['model'] = params.get('model')
        data['threshold'] = params.get('threshold')
        data = json.dumps(data)

        fabric_name = params["fabric_name"]
        model = params["model"]
        query = "?model=" + params["model"] + "&setting=DISABLED"

        #print('{0}/fabrics/{1}/elasticreservationsetting{2}'.format(host, fabric_name, query))
        response = ecli.HTTP.put('{0}/fabrics/{1}/elasticreservationsetting{2}'.format(host, fabric_name, query), None, 'kvmroce')

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

