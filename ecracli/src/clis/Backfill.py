#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Backfill.py /main/15 2025/11/24 18:41:55 zpallare Exp $
#
# Backfill.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Backfill.py - CLIs for backfilling ECRA data
#
#    DESCRIPTION
#      Provides clis that ops can use to backfill data in ECRA tables
#
#    NOTES
#
#    MODIFIED   (MM/DD/YY)
#    zpallare    11/21/25 - Bug 38635603 - EXADBX - Rack ports not working if
#                           admin info is present
#    zpallare    11/03/25 - Enh 38475153 - EXACS - Update ecracli backfill
#                           mvmsubnetinfo command to support multiple subnet
#                           ingestion
#    jzandate    11/03/25 - Enh 38475130 - Adding admin smarting backfill
#    jreyesm     08/12/25 - E.R 36651275. Support mvm flat v2
#    luperalt    07/04/24 - Bug 36754210 Added option to backfill the vnic of
#                           the cabinets
#    llmartin    05/23/24 - Bug 36646014 - Add option to skip IPs validations
#    cgarud      03/22/24 - 35339379 - API for updating cavium info
#    jvaldovi    10/10/23 - Enh 35892155 - Ecra Indigo - Create Backfilling
#                           Apis To Populate Indigo Data
#    rgmurali    06/24/22 - ER-34318923 - Add spare cavium ip updation
#    jreyesm     04/28/22 - Bug 34120311. Incorrect parsing for mvm flat.
#    rgmurali    04/12/22 - Enh 34062991 - Support exascale ip range
#    illamas     03/01/22 - Enh 33910631 - Add nat vlan configuration for mvm
#                           domu host
#    jreyesm     09/27/21 - E.R 33396326. Backfill api for mvm
#    rgmurali    06/07/21 - ER 32926443 - Support canonical QFAB names
#    rgmurali    12/09/20 - Creation
#

from formatter import cl
import json
import re

class Backfill:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_caviumip_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'caviumip', params)
        except Exception as e:
            cl.perr(str(e))
            return

        file_to_import = params["flatfile"]
        json_list = []
        backfill = {}
        with open(file_to_import, 'r') as fh:
            for line in fh:
                line = line.rstrip()
                node_props = line.split()
                pair1 = {"cavium_id": node_props[0], "cavium_ip": node_props[1]}
                json_list.append(pair1)

        backfill["nodes"] = json_list
        data = json.dumps(backfill, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "backfill", "{0}/cavium/caviumip".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_adminsmartnics_backfill(self, ecli, line, host):
            params = ecli.parse_params(line, None)

            # Validate the parameters
            try:
                ecli.validate_parameters('backfill', 'adminsmartnics', params)
            except Exception as e:
                cl.perr(str(e))
                return

            payload = json.load(open(params["payload"]))
            if "cabinetname" in params:
                payload["ad"] = params.get("cabinetname")[:3]
                payload["cabinetNumber"] = params.get("cabinetname")[3:]
            data = json.dumps(payload, sort_keys=True, indent=4)
            response = self.HTTP.post(data, "backfill", "{0}/cavium/adminsmartnic".format(host))
            if response:
                cl.prt("n", json.dumps(response))

    def do_update_caviumid_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'update_caviumid', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "backfill", "{0}/cavium/caviumid".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    # This API allows multiple cavium properties to be updated 
    def do_update_cavium_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'update_cavium', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/cavium/properties".format(host), data, "backfill")
        if response:
            cl.prt("n", json.dumps(response))

    def _getValue(self,text):
        return text.split("=")[1].replace("\n","")

    def do_mvmsubnetinfo_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'mvmsubnetinfo', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        # Validate if the flow is to backfill subnets only
        if "jsonpayload" in params:
            data = json.load(open(params["jsonpayload"]))
            data = json.dumps(data, sort_keys=True, indent=4)
            response = self.HTTP.put("{0}/cabinet/mvm/subnetinfo".format(host), data, "backfill")
            if response:
                cl.prt("n", json.dumps(response))
            return
        mainObj = {}

        hasSubnet   = "subnetmask" in params
        hasGateway  = "gateway" in params
        hasDomain   = "domain" in params
        hasCabinet  = "cabinetname" in params
        hasFlatFile = "flatfile" in params
        hasForce    = "force" in params

        commandPath  = hasSubnet or hasGateway or hasDomain
        flatFilePath = hasFlatFile

        if not (commandPath ^ flatFilePath):
            firstPar  = "subnetmask,gateway,domain,cabinetname"
            secondPar = "flatfile,cabinetname"
            cl.perr("You have to provide [{0}](all mandatory) or [{1}](cabinetname is optional)".format(firstPar,secondPar))
            return
        
        if commandPath and not hasCabinet:
            cl.perr("You have to provide cabinetname")
            return
        
        if flatFilePath:
            if hasCabinet:
                mainObj["cabinetname"] = params["cabinetname"]

            if hasForce:
                mainObj["force"] = params["force"]

            f = open(params["flatfile"], "r")

            first = f.readline().strip()
            # Ignore initial comments if present
            while first is None or len(first) <=1  or first.startswith('#') :
                first = f.readline().strip()

            # Expectation is to have CIDR for flat file v1
            if ( 'MVM_SUBNET_CIDR' in first.upper()):
                mvmcidr    = self._getValue(first)         # mvm_subnet_cidr
                mvmNetmask = self._getValue(f.readline())  # mvm_subnet_mask
                mvmGateway = self._getValue(f.readline())  # mvm_gateway
                mvmDomain  = self._getValue(f.readline())  # mvm_domainname
                subNetId   = self._getValue(f.readline())  # mvm_subnetid
        
                mainObj["subnetmask"] = mvmNetmask
                mainObj["domain"]     = mvmDomain
                mainObj["gateway"]    = mvmGateway
                mainObj["subnetid"]   = subNetId
                mainObj["version"]   = "v1"
            else:
                mainObj["version"]   = "v2"

            #Ignore  headers
            x = f.readline().strip()
            while x is None or len(x) <=1 or x.startswith('#'):
                x = f.readline().strip()
        
            arrNodes = []
            while not x is None and len(x) > 0:
                x = x.strip()
                if x.startswith('#') or len(x) <= 1:
                    x = f.readline()
                    continue
               
                element = re.split(r'\s+',x)
                
                nodeTmp = {}
                nodeTmp["vnicid"]              = element[0]
                nodeTmp["admin_nat_host_name"] = element[1]
                nodeTmp["admin_nat_ip"]        = element[2]
                nodeTmp["admin_vlan_tag"]      = element[3]
                # mvm flat file v2 contains mvm subnet information for each row
                if (len(element) > 4 ):
                    nodeTmp["subnetid"] = element[4]
                    nodeTmp["domain"]   = element[5]
                    nodeTmp["cidrblock"]  = element[6]
                    nodeTmp["subnetmask"]  = element[7]
                    nodeTmp["gateway"]  = element[8]

                arrNodes.append(nodeTmp)
                x = f.readline()

            mainObj["nodes"] = arrNodes
            data = json.dumps(mainObj, sort_keys=True, indent=4)
        else: #parameters path
            data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/cabinet/mvm/subnetinfo".format(host), data, "backfill")
        if response:
            cl.prt("n", json.dumps(response))

    def do_qfabdetails_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'qfabdetails', params)
        except Exception as e:
            cl.perr(str(e))
            return

        file_to_import = params["flatfile"]
        json_list = []
        backfill = {}
        with open(file_to_import, 'r') as fh:
            for line in fh:
                line = line.rstrip()
                node_props = line.split()
                pair1 = {"cabinet-name": node_props[0], "canonical-building": node_props[1], "canonical-room": node_props[2], "block-number": node_props[3], "serial-number": node_props[4]}
                json_list.append(pair1)

        backfill["cabinets"] = json_list
        data = json.dumps(backfill, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "backfill", "{0}/cabinet/qfabdetails".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_fabricexascale_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'fabricexascale', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "kvmroce", "{0}/roce/fabric/exascale".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_updatecaviumip_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'updatecaviumip', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "backfill", "{0}/cavium/caviumipspare".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_updatesitegroup_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'updatesitegroup', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/cabinet/sitegroup".format(host), data, "backfill")
        if response:
            cl.prt("n", json.dumps(response))

    def do_vnic_cabinets_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('backfill', 'caviumip', params)
        except Exception as e:
            cl.perr(str(e))
            return

        file_to_import = params["flatfile"]
        json_list = []
        backfill = {}
        with open(file_to_import, 'r') as fh:
            for line in fh:
                line = line.rstrip()
                node_props = line.split()
                pair1 = {"cabinet-name": node_props[0], "admin_active_vnic": node_props[1], "admin_standby_vnic":node_props[2], "subnet_ocid": node_props[3]}
                json_list.append(pair1)

        backfill["cabinets"] = json_list
        data = json.dumps(backfill, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "backfill", "{0}/cabinet/vnics".format(host))
        if response:
            cl.prt("n", json.dumps(response))

