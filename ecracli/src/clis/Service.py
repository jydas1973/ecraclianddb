#!/usr/bin/env python
# -*- coding: utf-8 -*-
# THIS FILE CONTAINS ECRACLI FUNCTIONALITY
#
# Copyright (c) 2013, 2025, Oracle and/or its affiliates.
#
#    NAME
#      ecracli Official interface for ecra
#
#    DESCRIPTION
#      Official CLI for ECS
#
#    NOTES
#      ecracli
#
#    MODIFIED   (MM/DD/YY)
#    gvalderr    06/20/25 - Enh 38020987 - Adding PDIT parameter for create
#                           service
#    llmartin    09/12/23 - Bug 35747355 -Preprov, set correct rack state after
#                           delete service
#    ddelgadi    11/22/22 - Enh 34579733 Include param AutonomousDB to create service
#    ddelgadi    07/04/22 - Bug 34349164 Include param deferralKeyDeletion to create service
#    llmartin    06/16/22 - Add dev option to fix payload
#    ddelgadi    06/09/22 - Bug 32690620 Include param sshkey to create service
#    jreyesm     02/26/21 - E.R 32503057. Elastic shapes support
#    llmartin    10/11/20 - Enh 31999563 - request idemtoken for exaunit updata
#                           memory
#    rgmurali    08/15/20 - Bug 31536477 - Fix fortify issues
#    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
#    llmartin    06/08/20 - Enh 31415724 - Ecracli framework, elastic cell
#                           scenario
#    rgmurali    05/28/20 - ER 31395494 - Support query parameters for delete service
#    rgmurali    05/14/20 - ER 30952096 - Support dbsystemId in delete service
#    jvaldovi    05/11/20 - Adding update memory command
#    bshenoy     04/08/20 - Bug 31140930 : Handle optional param infra for
#                           ocimvm
#    bshenoy     03/26/20 - Support for OCI MVM CSBug 31055331: Support MVM reshape operations
#    rgmurali    03/17/20 - Bug 30977714 Correct the check for vmbackup during delete
#    pverma      01/21/20 - Support for OCI MVM CS
#    jloubet     11/21/19 - Adding centralized regex for exadata validation
#    rgmurali    09/12/19 - ER 30299292 - Reset properties automatically after delete
#    rgmurali    09/10/19 - ER 30275876 - Add customername check to delete service
#    rgmurali    09/06/19 - Bug 30275159 - Remove force option for delete
#    rgmurali    08/29/19 - Bug 30247131 - Fix delete_service with sse option
#    rgmurali    08/20/19 - ER 30202025 - Add additional checks before delete service
#    csmarque    05/20/19 - Allow more RESERVED* status
#    jvaldovi    05/08/19 - adding functionality for isRackEnabled flag on
#                           service_create command for gen2 flows to use
#                           Reserved racks
#    hgaldame    04/22/19 - XbranchMerge hgaldame_x8support1921 from
#                           st_ebm_19.1.1.0.0
#    jreyesm     04/19/19 - Validate 'base' rack_subtype
#    jloubet     01/22/19 - Deleting previous workaround created for grid 19
#    hgaldame    03/26/19 - 29236318 : adding X8-2 support
#    llmartin    12/05/18 - Enh 28702021 - OCI Base System Support
#    jloubet     09/27/18 - Creation

from os import path

from clis.EcliUtil import EcliUtil
from util.constants import ECRACLI_MODES
from formatter import cl
from clis.Hardware import Hardware
from clis.ExadataInfra import ExadataInfra

import os
import json
import sys
import base64
import re
import uuid
import defusedxml.ElementTree as et

class Service:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_create_service(self, ecli, line, mytmpldir, interactive):
        self.Hardware = Hardware(self.HTTP)
        response = self.issue_create_service(ecli, line, mytmpldir, interactive)
        created_exaunit = ecli.waitForCompletion(response, "create_service")
        ecli.pull_exaunits()

    def issue_create_service(self, ecli, line, mytmpldir, interactive, warning=False):
        if "racksize" in line:
            return self.issue_create_service_nosdi_broker(ecli, line, mytmpldir, interactive, warning=False)

        line = line.split(' ', 1)
        rack_name, rest = line[0], line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, "serviceParams", warning=warning)

        try:
            ecli.validate_parameters('service', 'create', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Get env - nosdi, gen1, (gen2 or infra=ocimvm ) ?
        svcEnv = None
        svcInfra = None
        if 'env' in params:
            svcEnv = params['env']
            if svcEnv != 'nosdi' and svcEnv != 'gen2':
                cl.perr("Invalid value specified for env: " + svcEnv + ", available values are: nosdi, gen2, ocimvm")
                return

        rak_path = None
        rack_xml_content = None

        #Gen2 flows could have empty xml for elastic shapes 
        if svcEnv and (svcEnv == 'gen2'):
            return self.issue_create_service_gen2(ecli, rack_name, params, interactive)

        if not rack_name.endswith(".xml") and rack_name not in ecli.racks:
            rack_info = ecli.issue_get_request("{0}/racks?name={1}&verbose=true".format(self.HTTP.host, rack_name), printResponse=False)
            if rack_info and len(rack_info["racks"]) == 1:
                rack_xml_content = str(rack_info["racks"][0]["xml"])
                if svcEnv and svcEnv == 'nosdi':
                    rack_path =str(rack_info["racks"][0]["name"])+".xml"
            else:
                cl.perr("Could not find rack: " + rack_name)
                return
        else:
            rack_path = None
            if rack_name.endswith(".xml"):
                rack_path = rack_name
            elif rack_name in ecli.racks:
                rack_path = ecli.racks[rack_name]

            if rack_path:
                if not os.path.exists(rack_path):
                    cl.perr("Rack xml path " + rack_path + " is not valid")
                    return
                with open(rack_path) as f:
                    rack_xml_content = f.read()

        if not rack_xml_content:
            cl.perr("create_service now takes rack name as input. Please run: create_service <rack_name>")
            cl.perr("racks found in ecracli.cfg are: " + str(sorted(ecli.racks.keys())))
            cl.perr("to do provisioning on other racks, please add entry under ecracli.cfg [exadataClusters]")
            return

        if svcEnv and svcEnv == 'nosdi':
          return self.issue_create_service_nosdi_rackname(ecli, rest, rack_name, rack_xml_content, rack_path, params, mytmpldir, interactive)

        purchase_type = params.pop("type")
        if purchase_type not in ecli.purchasetypeMap:
            cl.perr("given purchase_type " + purchase_type + " is not valid. available service types are: " + ", ".join(list(ecli.purchasetypeMap.keys())))
            return
        entitlement_category = ecli.purchasetypeMap[purchase_type]

        with open(ecli.podJsonPath) as json_file:
            podJson = json.load(json_file)
        pod_payload = base64.b64encode(rack_xml_content.encode("utf-8")).decode("utf-8")
        if not pod_payload:
            raise Exception("Error: Cannot load the rack xml")
        podJson["pod_payload"] = pod_payload
        podJson["atp"] = self.getAtpParams(ecli, params)
        # find whether this cluster is a multi-vm or dedicated cluster and calculate min cores requirement for it
        node_count = 0
        root = et.fromstring(re.sub('xmlns="\w*"', '', rack_xml_content))
        node_count = len(root.findall("software/clusters/cluster/clusterVips/clusterVip/machines/machine"))
        if "racksize" not in params or not params["racksize"]:
            params["racksize"] = ecli.nodesToRacksize[node_count]

        model = ecli.getExadataModel(rack_xml_content)
        
        rackInfo = ecli.Hardware.get_rack_info(ecli, ecli.host, params["racksize"], model)
        minCoresPerNode = rackInfo["minCoresPerNode"]
        maxCoresPerNode = rackInfo["maxCoresPerNode"]

        vms = len(root.findall("machines/machine/machine"))
        vmPerDom0 = vms / node_count

        # If it is multi-vm
        if vmPerDom0 > 1:
            minCores = node_count * min(minCoresPerNode, int(maxCoresPerNode / vmPerDom0))
        else:
            minCores = node_count * minCoresPerNode

        if "cores" not in params or not params["cores"]:
            params["cores"] = minCores

        if "entitlement_id" not in params or not params["entitlement_id"]:
            params["entitlement_id"] = "100000000"

        service_uuid = str(uuid.uuid4())

        if "exaunitName" in params and params["exaunitName"]:
            exaunitName = params["exaunitName"]
        else:
            exaunitName = rack_path.split("/")[-1]
            exaunitName = exaunitName.lower()
            exaunitName = re.sub('-|\.xml$', '', exaunitName)

        if len(exaunitName) > 11:
            exaunitName = exaunitName[:7] + exaunitName[-4:]
            cl.prt("c", "exaunit name exceeds 11 characters limit. shorten it to " + exaunitName)

        podJson["uri"] = self.HTTP.host + "/exaunit"
        podJson["pod_guid"] = service_uuid
        podJson["services"][0]["id"] = service_uuid

        if "service_type" in params and params["service_type"]:
            serType = params["service_type"]
            podJson["service_type"] = serType
            podJson["services"][0]["service_type"] = serType

        if "memsize" in params and params["memsize"]:
            podJson["memsize"] = params["memsize"]

        backupToDisk = "N"
        if "backupToDisk" in params and params["backupToDisk"]:
            backupToDisk = params["backupToDisk"]
            if not backupToDisk in ("Y", "N"):
                cl.perr(backupToDisk + " is not a valid option for backupToDisk: [Y, N]")
                return

        iaas = "N"
        if "iaas" in params and params["iaas"]:
            iaas = params["iaas"]

        suspend_on_create = "N"
        if "suspend_on_create" in params and params["suspend_on_create"]:
            suspend_on_create = params["suspend_on_create"]

        if suspend_on_create == "Y":
            params["SuspendedCores"] = str(int(params["cores"]))
        else:
            params["SuspendedCores"] = str(0)

        service_components = os.path.join(mytmpldir,"service_components.xml")
        payload = open(service_components).read()
        root = et.fromstring(re.sub('xmlns="\w*"', '', payload))
        for key in root.iter("serviceSpecificProps"):
            if key[0].text == 'order.components':
                order = key[1]
                order_data = base64.b64decode(order.text)
                with open(path.join(mytmpldir, "order.components.xml")) as f:
                    if not params["racksize"].lower() in ecli.minCoresPerRack:
                        cl.perr(params["racksize"] + " is not a valid rack size: [quarter, half, full]")
                        return
                    oc = f.read()
                    oc = oc.replace("%RACK_SIZE%", params["racksize"] + " rack")

                    if suspend_on_create == "Y":
                        oc = oc.replace("%CORES_NUMBER%", str(0))
                        oc = oc.replace("%ADDI_CORES_NUMBER%", str(0))
                    else:
                        oc = oc.replace("%CORES_NUMBER%", str(minCores))
                        oc = oc.replace("%ADDI_CORES_NUMBER%", str(int(params["cores"]) - minCores))
                order.text = base64.b64encode(oc.encode("utf-8")).decode("utf-8")
            if key[0].text.lower() == "exaunitname":
                key[1].text = exaunitName
            elif key[0].text.lower() == "backuptodisk":
                key[1].text = backupToDisk
            elif key[0].text.lower() == "entitlement.category":
                key[1].text = entitlement_category
            elif key[0].text.lower() == "service.entitlementid":
                key[1].text = params["entitlement_id"]
            elif key[0].text.lower() == "iaas":
                key[1].text = iaas
            elif key[0].text.lower() == "suspendoncreate":
                key[1].text = suspend_on_create
            elif key[0].text.lower() == "suspendedcores":
                key[1].text = params["SuspendedCores"]

        for key in root.iter("mosPayload"):
            if key[0].text == "subscription.id":
                key[1].text = service_uuid
            elif key[0].text.lower() == "service.entitlementid":
                key[1].text = params["entitlement_id"]
        root_str = et.tostring(root)
        payload = base64.b64encode(root_str).decode("utf-8")
        podJson["services"][0]["service_specific_payload"] = payload

        if "sshkey" in params and len(params["sshkey"])>0:
            try:
                with open(params["sshkey"]) as ssh_file:
                    payload["sshkey"] = ssh_file.read()
            except FileNotFoundError:
                payload["sshkey"] = params["sshkey"]
        if "clustername" in params and len(params["clustername"])>0:
           payload["clustername"] = params["clustername"]

        if "grid_version" in params and params["grid_version"]:
            podJson["grid_version"] = params["grid_version"]
        #Track GI BP versions 
        if "grid_bp" in params and params["grid_bp"]:
            podJson["grid_bp"] = params["grid_bp"]


        if "enable_nid_starterdb" in params and params["enable_nid_starterdb"]:
            podJson["enable_nid_starterdb"] = params["enable_nid_starterdb"]

        if interactive:
            cl.prt("c", "Creating exaunit with service uuid: {0}".format(service_uuid))
        
        data = json.dumps(podJson, sort_keys=True, indent=4)
        return self.HTTP.post(data, "exaunits")



        #issue create service for nosdi with racksize/modelname
    def issue_create_service_nosdi_broker(self, ecli, rest, mytmpldir, interactive, warning):

        # For NoSDI broker case, both location and service params are required
        params = ecli.parse_params(rest, ["serviceParams","noSDIserviceParams","higgsParams"], warning=warning)

        try:
            ecli.validate_parameters('service', 'create', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "racksize" not in params or not params["racksize"]:
            cl.perr("racksize/rackname is a mandatory parameter for nosdi flow. Use command: create_service racksize=<> model=<> or create_service_rackname")
            return

        if params["racksize"] == "base_system":
            params["racksize"] = params["racksize"].replace("_", " ")
            
        racksize = params["racksize"].lower().title()
        if racksize not in ecli.racksizes:
            cl.perr("Invalid racksize. Valid  rack sizes : " + str(ecli.racksizes))
            return

        model = params["model"].upper()
        if model not in ecli.models:
            cl.perr("Invalid Model. Valid Models: " + str(ecli.models))
            return

        if params.get("dcId"):
            params["datacenterId"] = params["dcId"]
            params.pop("dcId")

        params["mincores"] = ecli.minCoresMultiVM[model]

        if params["racksize"] == "base system":
            params["mincores"] = 2 * ecli.minCoresPerPlatform[model]

        if "cores" not in params or not params["cores"]:
            params["cores"] = params["mincores"]

        svcJson = {}
        data = self.issue_create_service_nosdi(ecli, svcJson, params, mytmpldir, interactive)

        return self.HTTP.post(data, "regionecra", "{0}/broker/exaunits".format(self.HTTP.host))

    #issue create service for no SDI environment
    def issue_create_service_nosdi(self, ecli, svcJson, params, mytmpldir, interactive, warning=False, rack_path=None):

        purchase_type = params.pop("type")
        if purchase_type not in ecli.purchasetypeMap:
            cl.perr("given purchase_type " + purchase_type + " is not valid. available service types are: " + ", ".join(list(ecli.purchasetypeMap.keys())))
            return
        entitlement_category = ecli.purchasetypeMap[purchase_type]

        with open(ecli.podJsonPath) as json_file:
            podJson = json.load(json_file)

        if "entitlement_id" not in params or not params["entitlement_id"]:
            params["entitlement_id"] = "100000000"

        service_uuid = str(uuid.uuid4())

        if "exaunitName" in params and params["exaunitName"]:
            exaunitName = params["exaunitName"]
        else:
            if rack_path is not None:
                exaunitName = rack_path.split("/")[-1]
                exaunitName = exaunitName.lower()
                exaunitName = re.sub('-|\.xml$', '', exaunitName)
            else:
                cl.perr("exaunitName parameter needs to be provided if neither rack name or rack path are present")
                return

        if len(exaunitName) > 11:
            exaunitName = exaunitName[:7] + exaunitName[-4:]
            cl.prt("c", "exaunit name exceeds 11 characters limit. shorten it to " + exaunitName)

        backupToDisk = "N"
        if "backupToDisk" in params and params["backupToDisk"]:
            backupToDisk = params["backupToDisk"]
            if not backupToDisk in ("Y", "N"):
                cl.perr(backupToDisk + " is not a valid option for backupToDisk: [Y, N]")
                return

        isHA = "N"
        if "is_ha" in params and params["is_ha"]:
          isHA = params["is_ha"].upper()
          if not isHA in ("Y", "N"):
            cl.perr(isHA + " is not a valid option for is_ha: [Y, N]")
            return

        ipNetworks = "N"
        if "ipNet" in params and params["ipNet"]:
            ipNetworks = params["ipNet"].upper()
            if not ipNetworks in ("Y", "N"):
                cl.perr(ipNetworks + " is not a valid option for ipNet : [Y, N]")
                return

        adminUser = None
        if "admin_username" in params and params["admin_username"]:
            adminUser = params["admin_username"]

        instName = "Inst1"
        if "instName" in params and params["instName"]:
            instName = params["instName"]

        zoneName = None
        if "zone" in params and params["zone"]:
            zoneName = params["zone"]
        
        iaas = "N"
        if "iaas" in params and params["iaas"]:
            iaas = params["iaas"]

        suspend_on_create = "N"
        if "suspend_on_create" in params and params["suspend_on_create"]:
            suspend_on_create = params["suspend_on_create"]

        svcJson["id"] = service_uuid
        svcJson["identity_service_instance_guid"] = "idcs-dummy-svc-guid";
        svcJson["admin_username"] = adminUser
        svcJson["atp"] = self.getAtpParams(ecli, params)
        
        sspList = []
        sspList.append({"name" : "ExaUnitName", "value" : exaunitName})
        sspList.append({"name" : "BackupToDisk", "value" : backupToDisk})
        sspList.append({"name" : "entitlement.category", "value" : entitlement_category})
        sspList.append({"name" : "service.entitlementid", "value" : params["entitlement_id"]})

        if params["racksize"] == "base_system":
            params["racksize"] = params["racksize"].replace("_", " ")

        pickRackSize = params["racksize"] + ' Rack ' + params["model"]
        sspList.append({"name" : "PickRackSize", "value" : pickRackSize})

        createSparse = False
        order = None
        dataCenterId = None
        dataCenterRegionId = None
        clientNet = None
        backupNet = None        
        subId = None

        clientNet = params["clientNetwork"]
        backupNet = params["backupNetwork"]
        subId = params["subscriptionId"]

        service_components = os.path.join(mytmpldir,"service_components.xml")
        payload = open(service_components).read()
        root = et.fromstring(re.sub('xmlns="\w*"', '', payload))
        for key in root.iter("serviceSpecificProps"):
            if key[0].text == 'order.components':
                order = key[1]
                order_data = base64.b64decode(order.text)
                with open(path.join(mytmpldir, "order.components.xml")) as f:
                    if not params["racksize"].lower() in ecli.minCoresPerRack:
                        cl.perr(params["racksize"] + " is not a valid rack " +\
                            "size: [base_system, eighth, quarter, half, full]")
                        return
                    oc = f.read()
                    oc = oc.replace("%RACK_SIZE%", params["racksize"] + " rack")
                    if suspend_on_create == "Y":
                        oc = oc.replace("%CORES_NUMBER%", str(0))
                        oc = oc.replace("%ADDI_CORES_NUMBER%", str(0))
                        params["SuspendedCores"] = str(params["cores"])
                    else:
                        oc = oc.replace("%CORES_NUMBER%", str(params["cores"]))
                        oc = oc.replace("%ADDI_CORES_NUMBER%", str(0))
                        params["SuspendedCores"] = str(0)
                order.text = base64.b64encode(oc.encode("utf-8")).decode("utf-8")
            if key[0].text.lower() == "createsparse":
                createSparse = key[1].text
        dataCenterId = params["datacenterId"]
        dataCenterRegionId = params["datacenterRegionId"]

        sspList.append({"name" : "CreateSparse", "value" : createSparse})
        sspList.append({"name" : "order.components", "value" : order.text})
        sspList.append({"name" : "datacenter.id", "value" : dataCenterId})
        sspList.append({"name" : "datacenter.region.id", "value" : dataCenterRegionId})
        sspList.append({"name" : "subscription.id", "value" : subId})
        sspList.append({"name" : "SuspendOnCreate", "value" : suspend_on_create})
        sspList.append({"name" : "iaas", "value" : iaas})
        sspList.append({"name" : "SuspendedCores", "value" : params["SuspendedCores"]})
            
        if zoneName:
          sspList.append({"name" : "zone", "value" : zoneName})
        
        if ipNetworks == "Y":
            sspList.append({"name" : "IpNet", "value" : ipNetworks})
            sspList.append({"name" : "ClientNetwork", "value" : clientNet})
            sspList.append({"name" : "BackupNetwork", "value" : backupNet})

        sspList.append({"name" : "is_ha", "value" : params["isHA"]})
        
        svcJson["service_specific_payload"] = sspList

        appidUser = None
        appidPwd = None

        if "appidUser" in params and params["appidUser"]:
            appidUser = params["appidUser"]
        if "appidPwd" in params and params["appidPwd"]:
            appidPwd = params["appidPwd"]

        appidList = []
        depenList = []
        linksList = []
        higgsUrl = None
        if 'higgs_url' in params:
            higgsUrl = params['higgs_url']

        appidList.append({"name" : appidUser, "value" : appidPwd})
        svcJson["app_id_credentials"] = appidList
        linksList.append({"uri" : higgsUrl, "type" : "REST_INTERNAL"})
        #dependent_links element needed for higgs payload
        depenList.append({"entity_id" : subId, "service_type" : "Compute", "links" : linksList})
        svcJson["dependent_links"] = depenList
        svcJson["name"] = instName  
        
        if interactive:
            cl.prt("c", "Creating exaunit with service uuid: {0}".format(service_uuid))
        
        data = json.dumps(svcJson, sort_keys=True, indent=4)
        return data

    def getAtpParams(self, ecli, params):
        #----- ATP section --------
        atpParams = ecli.parse_params(None, "atpParams", warning=False)
        for p in atpParams:
            if p in params:
                atpParams[p] = params.pop(p)
        return atpParams

    #issue create service for noSDI env with rackname
    def issue_create_service_nosdi_rackname(self, ecli, rest, rackname, rack_xml_content, rack_path, params, mytmpldir, interactive, warning=False):
        
        params = ecli.parse_params(rest, ["serviceParams","noSDIserviceParams","higgsParams"], warning=warning)
        if type(params) is str:
            cl.perr(params)
            return
        # find whether this cluster is a multi-vm or dedicated cluster and calculate min cores requirement for it
        node_count = 0
        root = et.fromstring(re.sub('xmlns="\w*"', '', rack_xml_content))
        node_count = len(root.findall("software/clusters/cluster/clusterVips/clusterVip/machines/machine"))

        if params["racksize"] == "base_system":
            params["racksize"] = params["racksize"].replace("_", " ")

        if "racksize" not in params or not params["racksize"]:
            params["racksize"] = ecli.nodesToRacksize[node_count]

        model = ecli.getExadataModel(rack_xml_content)
        params["model"] = model
        
        rackInfo = ecli.Hardware.get_rack_info(ecli, ecli.host, params["racksize"], model)
        minCoresPerNode = rackInfo["minCoresPerNode"]
        maxCoresPerNode = rackInfo["maxCoresPerNode"]

        vms = len(root.findall("machines/machine/machine"))
        vmPerDom0 = vms / node_count

        # If it is multi-vm
        if vmPerDom0 > 1:
            minCores = node_count * min(minCoresPerNode, maxCoresPerNode / vmPerDom0)
        else:
            minCores = node_count * minCoresPerNode

        params["mincores"] = minCores

        if "cores" not in params or not params["cores"]:
            params["cores"] = minCores

        svcJson = {}
        svcJson["rackname"] = rackname

        response = self.HTTP.get("{0}/zones".format(self.HTTP.host))
        if not response:
            cl.perr("Error: Unable to fetch zone list")
            return
    
        if response["status"] != 200:
            cl.perr("Error: Invalid status response {0} from ECRA for list zones request".format(response["status"]))
            return

        data = self.issue_create_service_nosdi(ecli, svcJson, params, mytmpldir, interactive, rack_path=rack_path)
        return self.HTTP.post(data, "exaunits", "{0}/exaunits".format(self.HTTP.host))


    #issue create service for Gen2 environment
    def issue_create_service_gen2(self, ecli, rack_name, params, interactive):
        # Make sure status is READY
        rack_info = ecli.issue_get_request("{0}/racks?name={1}&verbose=true".format(self.HTTP.host, rack_name), printResponse=False)
        if rack_info and len(rack_info["racks"]) == 1:
            rack_status = str(rack_info["racks"][0]["status"])
        else :
            cl.perr("Could not find rack: " + rack_name)
            return
        #check if isRackReserved=true and given rack is Reserved
        reservedFlag = False
        if "isRackReserved" in params and params["isRackReserved"] == "true" and "RESERVED" in rack_status.upper():
            reservedFlag = True
        if not reservedFlag and rack_status not in ("READY", "PRE_PROVISIONED_ORCL_ATP_DB", "PRE_PROVISIONED_ORCL_NETWORK"):
            cl.perr("Rack : " + rack_name + " is in status:  " + rack_status + ", must be in READY state")
            return
        # Validate gen2payload has customer network and other mandatory param
        gen2Payload = None
        if not "gen2PayloadPath" in params:
            cl.perr("Missing gen2PayloadPath value")
            return
        with open(params["gen2PayloadPath"]) as json_file:
            gen2Payload = json.load(json_file)
        requiredKeys = {"purchasetype":"", "backup_disk":"", "cores":"", "customer_network":""}
        svcInfra = None
        svcEnv = params['env']

        if 'infra' in params:
            svcInfra = params['infra']

        #TODO: Temp fix: We will create another env ociexacc and remove this code
        if "exaOcid" in gen2Payload:
            requiredKeys = {"purchasetype":"", "backup_disk":"", "cores":"", "exaOcid": ""}
        if svcInfra == 'ocimvm':
            requiredKeys = {"backup_disk": "", "exaOcid": "", "exaunitAllocations": "", "zdlra": "", "createsparse": ""}

        for key in list(requiredKeys):
            if key in gen2Payload:
                requiredKeys.pop(key)
        if requiredKeys :
            cl.perr("Gen2 payload does not contain following kes: "+ str(list(requiredKeys.keys())))
            return

        if 'pdit' in params and params["pdit"] == 'true':
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get token to provision rack : " + rack_name)
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            idemtoken = retObj["idemtoken"]

            gen2Payload["rackname"] = rack_name
            gen2Payload["idemtoken"] = idemtoken
            gen2Payload["pdit"] = params["pdit"]

            if "clustername" in params and len(params["clustername"]) > 0:
                gen2Payload["clustername"] = params["clustername"]

            if "autonomousdb" in params and len(params["autonomousdb"]) > 0:
                gen2Payload["atp"]["AutonomousDb"] = params["autonomousdb"]

            # Send the request
            data = json.dumps(gen2Payload, sort_keys=True, indent=4)
            cl.prt("c", "Lauching PDIT create service")
            return self.HTTP.post(data, "exaunits")


        if 'dev' in params:
            exadatainfraObj = ExadataInfra(self.HTTP)
            payload = exadatainfraObj.create_addcluster_payload(rack_name, gen2Payload, self.HTTP.host)

        # Reserve the rack
        if svcInfra == 'ocimvm':
            # Get token to send reserve request
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get token to provision rack : " + rack_name)
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            idemtoken = retObj["idemtoken"]
            reservePayload = {}
            reservePayload["idemtoken"] = idemtoken
            url = "{0}/capacity/exadata/{1}/reserve".format(self.HTTP.host, gen2Payload["exaOcid"])
            cl.prt("c", "PUT " + url)
            data = json.dumps(reservePayload, indent=4, sort_keys=True)
            if ecli.interactive:
                cl.prt("c", "Reserving OCI Exadata capacity with details: " + data)
            retObj = self.HTTP.put(url, data, "capacity")
        else:
            retObj = self.HTTP.put("{0}/racks/{1}/reserve".format(self.HTTP.host, rack_name), "", "racks")
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not reserve rack : " + rack_name)
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        else:
            if svcInfra == 'ocimvm':
                cl.prt("c", "Reserved OCI Exadata capacity")

        # Update rack racksize_subtype for base_system
        if "subtype" in params:
            rackUpdatePayload = {}
            rackUpdatePayload["name"]=rack_name
            rackUpdatePayload["racksize_subtype"]=params["subtype"].upper()
            if params["subtype"].lower() != 'base':
                cl.perr("Invalid subtype, provide valid one 'base' ")
                return
            rackUpdateData = json.dumps(rackUpdatePayload, sort_keys=True, indent=4)
            rackUpdateResponse = self.HTTP.put("{0}/racks/".format(self.HTTP.host), rackUpdateData, "racks")
            
            if rackUpdateResponse is None or rackUpdateResponse['status'] != 200:
                cl.perr("Could not update rack racksize_subtype to: " + params["subtype"])
                cl.prt("n", "Response data")
                for key, value in rackUpdateResponse.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
        # Get token to send provisioning request
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token to provision rack : " + rack_name)
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        idemtoken = retObj["idemtoken"]
        if "atp" not in gen2Payload:
            gen2Payload["atp"] = self.getAtpParams(ecli, params)

        if "deferKeyDeletion" in params:
            gen2Payload["deferKeyDeletion"] = params["deferKeyDeletion"]

        # Update payload with token, rackname, sshkey, clustername
        gen2Payload["rackname"] = rack_name
        gen2Payload["idemtoken"] = idemtoken
        if "sshkey" in params and len(params["sshkey"])>0:
            try:
                with open(params["sshkey"]) as ssh_file:
                    gen2Payload["sshkey"] = ssh_file.read()
            except FileNotFoundError:
                gen2Payload["sshkey"] = params["sshkey"]
        if "clustername" in params and len(params["clustername"])>0:
           gen2Payload["clustername"] = params["clustername"]
        
        if "autonomousdb" in params and len(params["autonomousdb"])>0:
           gen2Payload["atp"]["AutonomousDb"] = params["autonomousdb"]

        # Send the request
        data = json.dumps(gen2Payload, sort_keys=True, indent=4)

        if ecli.interactive:
            cl.prt("c", "Creating exaunit with service uuid: {0}\n PAYLOAD:\n {1}".format(idemtoken, data))

        if svcInfra == 'ocimvm':
            cl.prt("c", "Requested ENV is OCI MVM. Attempting Create Cluster on exaOcid : [{0}]".format(gen2Payload["exaOcid"]))
            url = "{0}/exadata/{1}".format(self.HTTP.host, gen2Payload["exaOcid"])
            cl.prt("c", "PUT " + url)
            return self.HTTP.put(url, data, "exadata")
        else:
            return self.HTTP.post(data, "exaunits")

    def do_delete_service(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        data = None
        delete_section = None
        if "deleteParams" in ecli.config.sections():
           delete_section = "deleteParams"

        if delete_section is not None:
           data = json.dumps(dict(ecli.config.items(delete_section)))
        if rest:
           data = json.dumps(ecli.parse_params(rest, delete_section, warning=False))

        json_str = json.dumps(self.HTTP.get("{0}/properties/{1}".format(self.HTTP.host, "ECRA_MODE")))        
        ecraMode = json.loads(json_str)

        if (ecraMode["property_value"] == "prod"):
            if not self.do_confirm_delete_service(ecli, exaunit_id):
                cl.prt("r", "Cannot perform delete operation")
                return
    
        if interactive:
            cl.prt("c", "Deleting service with exaunit ID: {0}".format(exaunit_id))

        params = ecli.parse_params(rest, None, warning=False)
        url = None
        svcInfra = None
        if 'infra' in params:
            svcInfra = params['infra']

        if 'env' in params and params['env'] == 'gen2' and 'infra' in params and svcInfra == 'ocimvm':
            if "exaOcid" not in params:
                cl.prt("r", "Missing mandatory param for delete cluster in ocimvm env : [exaOcid]")
                return
            url = "{0}/exadata/{1}/exaunit/{2}".format(self.HTTP.host, params["exaOcid"], exaunit_id)
        else:
            dbsystem_ocid = ""
            query = None
            if 'dbsystem_id' in params:
                dbsystem_ocid = params['dbsystem_id']
            query = "?" + "{0}={1}".format("dbsystem_id", dbsystem_ocid)

            sse = False
            keepRackReserved = False
            optimizedVMDelete = False
            forceVMDelete  = False
            if 'sse' in params:
                sse = params['sse']
            query = query + "&" + "{0}={1}".format("sse", sse)

            if 'keepRackReserved' in params:
                keepRackReserved = params['keepRackReserved']
            query = query + "&" + "{0}={1}".format("keepRackReserved", keepRackReserved)
             
            if 'optimizedVMDelete' in params:
                optimizedVMDelete = params['optimizedVMDelete']
            query = query + "&" + "{0}={1}".format("optimizedVMDelete", optimizedVMDelete)
            
            if 'forceVMDelete' in params:
                forceVMDelete = params['forceVMDelete']
            query = query + "&" + "{0}={1}".format("forceVMDelete", forceVMDelete)

            if 'deletePreprovResources' in params:
                deletePreprovResources = params['deletePreprovResources']
                query = query + "&" + "{0}={1}".format("deletePreprovResources", deletePreprovResources)           

            url = "{0}/exaunit/{1}{2}".format(self.HTTP.host, exaunit_id, query)

        response = self.HTTP.delete(url, data)

        if response and response["status"] == 200:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))
        else:
            ecli.waitForCompletion(response, "delete_service")
        ecli.pull_exaunits()

    def do_confirm_delete_service(self, ecli, exaunit_id):
    
        # Allow only valid users to do a delete in PROD mode
        valid_users = ["srguser", "ops"]
        if ecli.username not in valid_users:
            cl.prt("r", "Not a valid user for this operation")
            return False

        ops_ecra_delete = ecli.issue_get_request("{0}/properties/{1}".format(self.HTTP.host, "OPS_DELETE_OPERATIONS"),False)
        ops_ecra_delete = ops_ecra_delete["property_value"]

        if ops_ecra_delete != "ENABLED":
            cl.prt("r", "Delete service operation has been disabled for ops in this ECRA")
            return False

        summary_info = ecli.issue_get_request("{0}/exaunit/{1}/summary".format(self.HTTP.host, exaunit_id),False)

        if summary_info:
            if "error_str" in summary_info:
                cl.prt("r", summary_info["error_str"])
                return False
            else:
                rack_name = summary_info["rackname"]
                exacloud_status = None
                try:
                    cl.prt("c", "Checking if any vambackups exist, please wait ....")
                    vmbackupObj = json.dumps(self.HTTP.get("{0}/racks/{1}/vmbackup".format(self.HTTP.host, rack_name)))
                    exacloud_status = json.loads(vmbackupObj)
                except Exception as e:
                    pass

                cl.prt("c","{0:15} : {1:8}".format("Rackname",summary_info["rackname"]))
                cl.prt("c","{0:15} : {1:8}".format("Rackstatus",summary_info["rackstatus"]))
                cl.prt("c","{0:15} : {1:8}".format("ATP",summary_info["atp"]))
                cl.prt("c","{0:15} : {1:8}".format("Customer name",summary_info["customer_name"]))
                cl.prt("c","{0:15} : {1:8}".format("CSI",summary_info["csi"]))
                cl.prt("c","{0:15} : {1:8}".format("Entitlement_id",summary_info["entitlement_id"]))
                if exacloud_status is not None:
                    if  ("Exacloud Cmd Status" in exacloud_status and exacloud_status["Exacloud Cmd Status"] == "Pass"):
                        vmbackupDetails = exacloud_status['Log']
                        cl.prt("c", str(vmbackupDetails))

                if (summary_info["ops_delete_service"] == "N"):
                    cl.prt("r", "Delete service operation has been disabled for ops on this rack, you need to enable it first")
                    return False

                if (summary_info["rackstatus"] == "PROVISIONED"):
                    ask_confirmation = input("Rack is in PROVISIONED state, do you really want to delete? (yes|no)")
                    if ask_confirmation != "yes":
                        cl.prt("c", "Deletion operation not confirmed, aborting")
                        return False

                first_confirmation = input("Do you have L1/L2 approvals to delete exaunit id : '"+exaunit_id+"'?(yes|no):")
                if first_confirmation != "yes":
                    cl.prt("c", "Deletion operation not confirmed, aborting")
                    return False
    
                cl.prt("r","Are you sure you want to delete the exaunit with id: " + exaunit_id +"? VM and data will be lost. This action cannot be undone")
                second_confirmation = input("Type rackname associated with the exaunitid in order to proceed with the delete command, if not just hit enter to quit:")

                if second_confirmation != summary_info["rackname"]:
                    cl.prt("c", "Invalid rackname provided, aborting the request")
                    return False

                third_confirmation = input("Type customer-name associated with the exaunitid in order to proceed with the delete command, if not just hit enter to quit:")

                if third_confirmation != summary_info["customer_name"]:
                    cl.prt("c", "Invalid customer name provided, aborting the request")
                    return False
                ecli.run_postdelete_validation()
                ecli.run_postdelete_rackupdate(summary_info["rackname"])
                return True
        else:
            return False

    # delete the given exaunit and then recreate it
    def do_recreate_service(self, ecli, line, interactive):

        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        if interactive:
            cl.prt("c", "Recreating exaunit with exaunit ID: {0}".format(exaunit_id))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, None, "{0}/exaunit/{1}/recreate".format(self.HTTP.host, exaunit_id))
        ecli.waitForCompletion(response, "recreate_service")

    # get service information
    def do_get_service(self, ecli, line):
        if not line:
            cl.perr("Please enter a valid service uuid")
            return

        if (ecli.startup_options["mode"] == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
            cimid = ecli.startup_options["cimid"]
            if (cimid != line):
                cl.perr("In 'brokerproxy' mode, 'service_uuid' must match with 'cimid', service_uuid: %s, cimid: %s" %
                        (line, cimid))
                return None
        ecli.issue_get_request("{0}/services/{1}".format(self.HTTP.host, line))

    def do_service_update_memory(self, ecli, line, host):
        line = line.split(' ', 1)
        exaunitId, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)
        if type(params) == dict:
            params.update(exaunit_Id=exaunitId)

        try:
            ecli.validate_parameters('service', 'update_memory', params)
        except Exception as e:
            return cl.perr(str(e))

        vms_values = [
            "all"
        ]
        if "json_path" in params:
            if "vms" in params or "gb_memory" in params:
                cl.perr("Please specify only json_path or [all_vms and  gb_memory] options")
                return
            #json_path processing
            data = EcliUtil.load_json(params["json_path"])
            if data == False:
                return

            response = "exacuting from json"
        elif "vms" in params and "gb_memory" in params and "idemtoken" in params:
            if params["vms"] not in vms_values:
                cl.perr("Valid values for vms params are {0}".format(vms_values))
                return
            # get vms from exaunit cores endpoint
            cores = self.HTTP.get("{0}/exaunit/{1}/cores".format(host, exaunitId))
            if not cores:
                cl.perr("Unable to fetch current vms information from ecra. Update memory failed")
                return
            vms = []
            for vm in cores["ocpuAllocations"]:
                vms.append(vm.get("hostName"))
            if len(vms) == 0:
                cl.perr("Unable to fetch current vms information from ecra. Update memory failed")
                return
            data = {}
            dataList = []
            for vm in vms:
                vmInfo = {
                    "hostname":vm,
                    "gb_memory": params["gb_memory"]
                }
                dataList.append(vmInfo)
            data.update(memoryAllocations=dataList)
            data["idemtoken"]=params["idemtoken"]
            cl.prt("n", "Using {0} data json".format(data))
        else:
            cl.perr("Please Check usage of parameters")
            return

        exaunit_info = self.HTTP.get("{0}/exaunit/{1}".format(host, exaunitId))
        svcuri = exaunit_info["svcuri"]

        cl.prt("c", "PUT " + svcuri)
        data = json.dumps(data)
        response = self.HTTP.put(svcuri, data, "services")
        cl.prt("c", json.dumps(response))

