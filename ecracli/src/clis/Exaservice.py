"""
 Copyright (c) 2015, 2021, Oracle and/or its affiliates. 

NAME:
    Exaservice - CLI for operations on the exaservice

FUNCTION:
    Provides the cli for CRUD operations on exaservice

NOTE:
    None

History:
    sringran    07/05/2021 - Bug 33011365 - DELETING EXASERVICE WITH NO VM CLUSTERS 
                             SHOULD NOT CALL EXACLOUD
    hcheon      09/28/2020 - Bug 31942864 - Fixed pylint errors
    marcoslo    08/08/2020 - ER 30613740 Update code to use python 3
    jvaldovi    05/27/2019 - Bug 29832597  - Adding Request_id on create exaservice op payload
    sachikuk    09/13/2018 - Bug 28643725 - ecracli changes for brokerproxy
    piyushsi    07/30/2018 - Bug 28422861 - rack_name selection in exaservice create operation
    llmartin    07/19/2018 - Bug 28096666 - CPU oversubscription
    brsudars    05/29/2018 - Node subset changes
    sgundra     06/19/2018 - Bug-28204941 : Exaservice suspend/resume endpoints
    sgundra     06/19/2018 - Add iaas/paas support for multivm
    brsudars    04/08/2018 - Add param instance name. This is the overall service name.
    brsudars    03/21/2018 - Add multi-vm migration command
    llmartin    03/21/2018 - Bug 27733524 MultiVM params validation issue. 
    brsudars    01/05/2018 - Higgs related changes
    brsudars    11/08/2017 - Create file
"""

import ast
import base64
import cmd
import collections
import configparser
import datetime
import json
import logging
import logging.handlers
import os
import pprint
import re
import socket
import sys
import time
import urllib.request, urllib.error, urllib.parse
import uuid

from optparse import OptionParser
from os import path

from EcraHTTP import HTTP
from formatter import cl

from clis.MvmCluster import MvmCluster
from clis.EcliUtil import EcliUtil
from clis.Higgs import Higgs
from util.constants import ECRACLI_MODES
from defusedxml.ElementTree import parse

class Exaservice:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        self.ecraHost = None

    def getHardwareInfo(self, racksize, model):
        hwinfoApi = "{0}/hardwareinfo?racksize={1}&model={2}".format(self.ecraHost, racksize, model)
        response = self.HTTP.get(hwinfoApi)
        if response is None:
            cl.perr("Error: Unable to fetch hardwareinfo for rack " + racksize + " and model " + model)
            return None
        return response

    def getResourceInfo(self, exaservice_id):
        resourceInfoApi = "{0}/exaservice/{1}/resourceinfo".format(self.ecraHost, exaservice_id)
        response = self.HTTP.get(resourceInfoApi)
        if response is None:
            cl.perr("Error: Unable to fetch resource info for exaservice: " + exaservice_id)
            return None
        return response


    def getExaServiceAllocJson(self, params):

        currResourceInfoJson = self.getResourceInfo(params["exaservice_id"])
        if not currResourceInfoJson:
            return None

        burstCores = int(currResourceInfoJson["AllocatedExaServiceResources"]["BurstCores"])
        subscriptionCores = int(currResourceInfoJson["AllocatedExaServiceResources"]["BaseNumOfCores"])
        subscriptionCores += int(currResourceInfoJson["AllocatedExaServiceResources"]["AdditionalNumOfCores"])

        if "rack_cores" in params:
            subscriptionCores = int(params["rack_cores"])
        elif "burst_cores" in params:
            burstCores = int(params["burst_cores"])

        exaserviceJson = {}

        exaserviceProperties = []
        exaserviceProperties.append({"name": "Operation", "value": "ReshapeExaService"})
        exaserviceProperties.append({"name": "ExaserviceId", "value": params["exaservice_id"]})
        exaserviceProperties.append({"name": "SubscriptionCores", "value": subscriptionCores})
        exaserviceProperties.append({"name": "BurstCores", "value": burstCores})
        
        if "add_cell" in params:
            exaserviceProperties.append({"name": "ElasticStorageCells", "value": params["add_cell"]})

        if "add_compute" in params:
            exaserviceProperties.append({"name": "ElasticComputeNodes", "value": params["add_compute"]})

        if ("rack_cores_dist_list" in params) or ("burst_cores_dist_list" in params):
            coresDistJson = {}
            if "rack_cores" in params:
                coreDistList = params["rack_cores_dist_list"]
            else:
                coreDistList = params["burst_cores_dist_list"]
            coresDistribution = []
            i = 0
            while i < len(coreDistList):
                nodeId = i + 1
                coresDistribution.append({"ComputeNode": ("node-" + str(nodeId)), "NumCores": coreDistList[i]})
                i += 1
            coresDistJson["CoresDistribution"] = coresDistribution
            coresDistJsonStr = json.dumps(coresDistJson, sort_keys=True, indent=4)
            if "rack_cores" in params:
                exaserviceProperties.append({"name": "SubscriptionCoresDistribution", "value": base64.b64encode(coresDistJsonStr.encode("utf-8")).decode("utf-8")})
            else:
                exaserviceProperties.append({"name": "BurstCoresDistribution", "value": base64.b64encode(coresDistJsonStr.encode("utf-8")).decode("utf-8")})

        exaserviceJson["ExaServiceProperties"] = exaserviceProperties

        return json.dumps(exaserviceJson, sort_keys=True, indent=4)

    def composeMigrateExaServiceJson(self, params):

        jsonFile = params["json"]
        jsonFp = open(jsonFile, "r")
        with open(jsonFile, "r") as jsonFp:
            jsonMigrationData = json.load(jsonFp)
            if "outfile" in params and params["outfile"]:
                jsonMigrationData["outfile"] = params["outfile"]
            return jsonMigrationData

        cl.perr("Failed to compose request for migration: unable to open json file: " + jsonFile)
        return None

    def composeReshapeExaServiceJson(self, params):
        svcJson = {}
        svcJson["request_id"] =  str(uuid.uuid4())
        svcJson["id"] = params["exaservice_id"]
        sspList = []
        exaservicePropsStr = self.getExaServiceAllocJson(params)
        sspList.append({"name": "EXASERVICE_ALLOCATIONS", "value": base64.b64encode(exaservicePropsStr.encode("utf-8")).decode("utf-8")})

        if "isCOS" in params:
            sspList.append({"name": "isCOS", "value": params["isCOS"]})

        svcJson["service_specific_payload"] = sspList
        return svcJson

    def composeDeleteExaServiceJson(self, params):

        svcJson = {}
        svcJson["request_id"] =  str(uuid.uuid4())
        svcJson["id"] = params["exaservice_id"]
        sspList = []
        if params["sse"] == "Y":
            sspList.append({"name": "sse", "value": "true"})
        else:
            sspList.append({"name": "sse", "value": "false"})
        svcJson["service_specific_payload"] = sspList
        return svcJson

    def composeCreateExaServiceJson(self, params, mytmpldir):

        svcJson = {}
        svcJson["request_id"] =  str(uuid.uuid4())
        svcJson["id"] = params["exaservice_id"]
        svcJson["admin_email"] = params["admin_email"]
        svcJson["identity_service_instance_guid"] = params["identity_service_instance_guid"]
        # The TAS service instance name.
        svcJson["name"] = params["inst_name"]

        sspList = []
        sspList.append({"name": "PickRackSize", "value": params["racksize"] + " " + params["model"]})
        service_components = os.path.join(mytmpldir, "service_components.xml")
        root = parse(service_components)
        order = None
        dataCenterId = None
        dataCenterRegionId = None
        dataCenterName = None
        dataCenterRegionName = None

        for key in root.iter("serviceSpecificProps"):
            if key[0].text == 'order.components':
                order = key[1]
                with open(path.join(mytmpldir, "order.components.xml")) as f:
                    oc = f.read()
                    oc = oc.replace("%RACK_SIZE%", params["racksize"] + " rack")
                    minCores = int(params["mincores"])
                    totalCores = int(params["rack_cores"])
                    if params["suspend_on_create"] == "Y":
                        oc = oc.replace("%CORES_NUMBER%", str(0))
                        oc = oc.replace("%ADDI_CORES_NUMBER%", str(0))
                        params["SuspendedCores"] = str(totalCores)
                    else:
                        oc = oc.replace("%CORES_NUMBER%", str(minCores))
                        oc = oc.replace("%ADDI_CORES_NUMBER%", str(totalCores - minCores))
                        params["SuspendedCores"] = str(0)
                order.text = base64.b64encode(oc.encode("utf-8")).decode("utf-8")
            elif key[0].text.lower() == "datacenter.id":
                dataCenterId = key[1].text
            elif key[0].text.lower() == "datacenter.region.id":
                dataCenterRegionId = key[1].text
            elif key[0].text.lower() == "datacenter.name":
                dataCenterName = key[1].text
            elif key[0].text.lower() == "datacenter.region.name":
                dataCenterRegionName = key[1].text

        sspList.append({"name": "order.components", "value": order.text})
        sspList.append({"name": "datacenter.id", "value": dataCenterId})
        sspList.append({"name": "datacenter.region.id", "value": dataCenterRegionId})
        sspList.append({"name": "datacenter.name", "value": dataCenterName})
        sspList.append({"name": "datacenter.region.name", "value": dataCenterRegionName})
        sspList.append({"name": "iaas", "value": params["iaas"]})
        sspList.append({"name": "SuspendOnCreate", "value": params["suspend_on_create"]})
        sspList.append({"name": "SuspendedCores", "value": params["SuspendedCores"]})

        sspList.append({"name": "entitlement.category", "value": params["entitlement_category"]})
        if "zone" in params and params["zone"]:
            sspList.append({"name": "zone", "value": params["zone"]})
        sspList.append({"name": "is_ha", "value": params["is_ha"]})

        sspList.append({"name": "ExaUnitName", "value": params["clu_name"]})
        params["clu_operation"] = "addcluster";

        cluster = MvmCluster(self.HTTP, self.ecraHost, params)
        if cluster is None:
            cl.perr("Error: Unable to process cluster params")
            return None

        exaunitAlloc = cluster.getExaunitAllocation()
        if exaunitAlloc:
            exaunitAlloc =  json.loads(exaunitAlloc)
        if not exaunitAlloc:
            cl.perr("Error: Failed to create exaunit allocation payload for cluster")
            return None

        clusterSspList = exaunitAlloc["ExaunitProperties"]
        # Add higgs specific payload
        if not Higgs.setHiggsPayloadForCreate(mytmpldir, svcJson, clusterSspList, params):
            cl.perr("Error: Failed to set Higgs specific payload params")
            return None

        exaunitAllocJsonStr = json.dumps(exaunitAlloc, sort_keys=True, indent=4)
        sspList.append({"name": "EXAUNIT_ALLOCATIONS", "value": base64.b64encode(exaunitAllocJsonStr.encode("utf-8")).decode("utf-8")})

        if "isCOS" in params:
            sspList.append({"name": "isCOS", "value": params["isCOS"]})

        svcJson["service_specific_payload"] = sspList

        return svcJson

    def validateMigrateRollbackExaserviceParams(self, params):

        if "mode" in params and params["mode"]:
            if params["mode"] not in Exaservice.getMigrationModes():
                cl.perr("Unknown migration mode:" + params["mode"])
                return False
        else:
            params["mode"] = "svm-to-mvm"

        return True

    def validateMigrateStatusExaserviceParams(self, params):

        if "mode" in params and params["mode"]:
            if params["mode"] not in Exaservice.getMigrationModes():
                cl.perr("Unknown migration mode:" + params["mode"])
                return False
        else:
            params["mode"] = "svm-to-mvm"

        return True


    def validateMigratePostfetchExaserviceParams(self, params):

        if "exaunit_id" in params and params["exaunit_id"]:
            if not EcliUtil.isIntegerParam(params["exaunit_id"], "exaunit_id"):
                cl.perr("Invalid value for integer param: exaunit_id. Value should be greater than 0")
                return False

        return True

    def validateMigratePrefetchExaserviceParams(self, params):

        if "exaunit_id" in params and params["exaunit_id"]:
            if not EcliUtil.isIntegerParam(params["exaunit_id"], "exaunit_id"):
                cl.perr("Invalid value for integer param: exaunit_id. Value should be greater than 0")
                return False
            return True
        if "service_id" in params and params["service_id"]:
            return True

        cl.perr("One of <exaunit_id> or <service_id> has to be specified.")
        return False

    @staticmethod
    def getMigrationModes():
        # add new modes here
        # svm-to-mvm is the default mode
        # svm-to-mvm - Single-vm to regular multi-vm
        # mvm-to-nodesubset - Regular multi-vm to multi-vm with node subsets
        return ["svm-to-mvm", "mvm-to-nodesubset"]

    def validateMigrateExaserviceParams(self, params):

        if not "json" in params or not params["json"]:
            cl.perr("Please specify the json input file to migrate")
            return False

        migrationMode = "svm-to-mvm"
        if "mode" in params and params["mode"]:
            if params["mode"] not in Exaservice.getMigrationModes():
                cl.perr("Unknown migration mode:" + params["mode"])
                return False
            migrationMode = params["mode"]
        else:
            params["mode"] = "svm-to-mvm"

        jsonFile = params["json"]
        try:
            jsonFp = open(jsonFile, "r")
            with open(jsonFile, "r") as jsonFp:
                jsonMigrationData = json.load(jsonFp)
                mandatoryKeys = None
                if migrationMode == "svm-to-mvm":
                    mandatoryKeys = ["instanceId", "exaunitId", "isHiggsCluster", "racksize", "model", "exadata"]
                elif migrationMode == "mvm-to-nodesubset":
                    mandatoryKeys = ["instanceId", "exadataId"]
                missingKeys = [mKey for mKey in mandatoryKeys if mKey not in jsonMigrationData]
                if len(missingKeys) > 0:
                    cl.perr("Json file " + jsonFile + " missing mandatory params: " + str(missingKeys))
                    return False
                if migrationMode == "mvm-to-nodesubset":
                    params["instanceId"] = jsonMigrationData["instanceId"]
                return True
        except Exception:
            cl.perr("Failed to open or read json file: " + jsonFile)

        return False


    def validateReshapeExaserviceParams(self, params):

        if "rack_cores" in params and "burst_cores" in params:
          cl.perr("Only one of rack_cores or burst_cores can be specified.")
          return False

        if "rack_cores" in params:
            if not EcliUtil.isIntegerParam(params["rack_cores"], "rack_cores", 0):
                return False

        if "burst_cores" in params:
            if not EcliUtil.isIntegerParam(params["burst_cores"], "burst_cores", 0):
                return False

        rackCoresDist = False
        if "rack_cores_dist" in params:
            rackCoresDist = True
            rackCoresDistCsv = params["rack_cores_dist"]
            rackCoresDistList = [rc.strip() for rc in rackCoresDistCsv.split(',')]
            params["rack_cores_dist_list"] = rackCoresDistList

        burstCoresDist = False
        if "burst_cores_dist" in params:
            burstCoresDist = True
            burstCoresDistCsv = params["burst_cores_dist"]
            burstCoresDistList = [bc.strip() for bc in burstCoresDistCsv.split(',')]
            params["burst_cores_dist_list"] = burstCoresDistList

        if "rack_cores" in params and burstCoresDist:
            cl.perr("Param burst_cores_dist cannot be specified along with param rack_cores")
            return False

        if "burst_cores" in params and rackCoresDist:
            cl.perr("Param rack_cores_dist cannot be specified along with param burst_cores")
            return False

        # validate COS.
        if "isCOS" in params:
            if not params["isCOS"] or params["isCOS"].upper() not in ["Y", "N"]:
                cl.perr("Param isCOS is not valid. Please specify one of: [Y, N]")
                return False

        # validate elastic parameters
        if "add_cell" in params:
            if not EcliUtil.isIntegerParam(params["add_cell"], "add_cell", 0):
                cl.perr("Param add_cell is not valid param.")
                return False
        if "add_compute" in params:
            if not EcliUtil.isIntegerParam(params["add_compute"], "add_compute", 0):
                cl.perr("Param add_compute is not valid param.")
                return False

        return True

    def validateDeleteExaserviceParams(self, params):

        if "sse" in params and params["sse"]:
            sse = params["sse"].upper()
            if not sse in ("Y", "N"):
                cl.perr(sse + " is not a valid option for sse flag. Please specify one of: [Y, N]")
                return False
        else:
            # By default do not do disk and VM image shredding
            params["sse"] = "Y"
        return True

    def validateCreateExaserviceParams(self, params):

        # Create a uniq CIM Id
        exaservice_id = params["exaservice_id"] = str(uuid.uuid4())

        # Add missing params
        if "rack_cores" not in params or not params["rack_cores"]:
            params["rack_cores"] = params["mincores"]

        if not EcliUtil.isIntegerParam(params["rack_cores"], "rack_cores"):
          return False;

        # Set cluster name. If not  specified generate a random name
        if "clu_name" in params and params["clu_name"]:
            clusterName = params["clu_name"]
        else:
            clusterName =  "clu" + str(uuid.uuid4().hex.lower()[:7])

        if len(clusterName) > 11:
            clusterName = clusterName[:7] + clusterName[-4:]
            cl.prt("c", "clu_name name exceeds 11 characters limit. Shortened to " + clusterName)
        # this is used both by service and first cluster
        params["clu_name"] = clusterName

        # Set overall service name
        if "inst_name" not in params or not params["inst_name"]:
            cl.prt("c", "Service instance name inst_name not specified. Will use clu_name as service instance name")
            params["inst_name"] = params["clu_name"]

        if "is_ha" in params and params["is_ha"]:
            isHA = params["is_ha"].upper()
            if not isHA in ("Y", "N"):
                cl.perr(isHA + " is not a valid option for is_ha. Please specify one of: [Y, N]")
                return False
        else:
            params["is_ha"] = "N"

        ipNetworks = "N"
        if "ipNet" in params and params["ipNet"]:
            ipNetworks = params["ipNet"].upper()
            if not ipNetworks in ("Y", "N"):
                cl.perr(ipNetworks + " is not a valid option for ipNet : [Y, N]")
                return False
        else:
            params["ipNet"] = "N"

        # validate COS.
        if "isCOS" in params:
            if not params["isCOS"] or params["isCOS"].upper() not in ["Y", "N"]:
                cl.perr("Param isCOS is not valid. Please specify one of: [Y, N]")
                return False

        params["identity_service_instance_guid"] = "idcs-dummy-svc-guid";
        params["admin_email"] = "firstname.lastname@acme.com";

        return True

    def init(self, ecli, line, host, subop):

        higgslist = ['create', 'addcluster']
        if subop in higgslist:
            params = ecli.parse_params(line, "higgsParams", False)
        else:
            params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exaservice', subop, params)
        except Exception as e:
            cl.perr(str(e))
            return None

        if (ecli.startup_options["mode"] == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
            if ("exaservice_id" not in params):
                cl.perr("In 'brokerproxy' mode, exaservice level operations not tied to an 'exaservice_id' are blocked.")
                return None

            cimid = ecli.startup_options["cimid"]
            exaservice_id =  params["exaservice_id"]
            if (exaservice_id != cimid):
                cl.perr("In 'brokerproxy' mode, 'exaservice_id' must match with 'cimid', exaservice_id: %s, cimid: %s" %
                        (exaservice_id, cimid))
                return None

        self.ecraHost = host
        # Add cmd_init_done to not return a None in case of commands that have no mandatory params
        params["cmd_init_done"] = True
        return params


    # create a multi-vm exaservice including the first cluster
    def do_create_exaservice(self, ecli, line, host, mytmpldir):

        params = self.init(ecli, line, host, 'create')
        if not params:
            return None

        racksize = params["racksize"]
        model = params["model"]
        if "type" not in params or not params["type"]:
            params["type"] = "subscription"

        if "iaas" not in params or not params["iaas"]:
            params["iaas"] = "N"

        if "suspend_on_create" not in params or not params["suspend_on_create"]:
            params["suspend_on_create"] = "N"

        entitlement_cat = ecli.get_entitlement_category(params["type"].lower())
        if not entitlement_cat:
            return None

        params["entitlement_category"] = entitlement_cat

        hwInfoJson = self.getHardwareInfo(racksize, model)
        if not hwInfoJson:
            return None

        minCores = int(int(hwInfoJson["minCoresPerNode"]) * int(hwInfoJson["numComputes"]))       
    
        if params["iaas"] == "Y":
            params["mincores"] = int(hwInfoJson["numComputes"])

        else:
            params["mincores"] = minCores

        if not self.validateCreateExaserviceParams(params):
            return None
        svcJson = self.composeCreateExaServiceJson(params, mytmpldir)
        if not svcJson:
            return None

        if ecli.interactive:
            cl.prt("c", "Creating exaservice with id: {0}".format(params["exaservice_id"]))

        data = json.dumps(svcJson, sort_keys=True, indent=4)
        return self.HTTP.post(data, "regionecra", "{0}/broker/exaunits/multivm".format(self.ecraHost))

    def do_add_cluster(self, ecli, line, host, mytmpldir):

        # validate params and initialize
        params = self.init(ecli, line, host, 'addcluster')
        if not params:
            return None

        params["clu_operation"] = "addcluster";
        cluster = MvmCluster(self.HTTP, self.ecraHost, params, mytmpldir)
        svcJson = cluster.createPayload()
        if not svcJson:
            return None

        if ecli.interactive:
            cl.prt("c", "Adding cluster to exaservice with id: {0}".format(params["exaservice_id"]))

        data = json.dumps(svcJson, sort_keys=True, indent=4)
        return self.HTTP.put("{0}/exaservice/{1}".format(host, params["exaservice_id"]), data, "exaservice")

    def do_reshape_cluster(self, ecli, line, host, mytmpldir):

        # validate params and initialize
        params = self.init(ecli, line, host, 'reshapecluster')
        if not params:
            return None

        params["clu_operation"] = "reshapecluster";
        cluster = MvmCluster(self.HTTP, self.ecraHost, params)

        svcJson = cluster.createPayload()
        if not svcJson:
            return None

        if ecli.interactive:
            cl.prt("c", "Reshaping cluster {0} with exaservice with id: {1}".format(params["exaunit_id"], params["exaservice_id"]))

        data = json.dumps(svcJson, sort_keys=True, indent=4)
        return self.HTTP.put("{0}/exaservice/{1}".format(host, params["exaservice_id"]), data, "exaservice")


    def do_coreburst_cluster(self, ecli, line, host, mytmpldir):

        cl.prt("n", "This command is disabled for now. Core burst is supported only at exaservice level")
        if False:
            return None

        # validate params and initialize
        params = self.init(ecli, line, host, 'coreburstcluster')
        if not params:
            return None

        params["clu_operation"] = "coreburstcluster";
        cluster = MvmCluster(self.HTTP, self.ecraHost, params)

        svcJson = cluster.createPayload()
        if not svcJson:
            return None

        if ecli.interactive:
            cl.prt("c", "Core bursting cluster {0} with exaservice with id: {1}".format(params["exaunit_id"],
                                                                                    params["exaservice_id"]))
        data = json.dumps(svcJson, sort_keys=True, indent=4)
        return self.HTTP.put("{0}/exaservice/{1}".format(host, params["exaservice_id"]), data, "exaservice")


    def do_delete_cluster(self, ecli, line, host, mytmpldir):

        # validate params and initialize
        params = self.init(ecli, line, host, 'deletecluster')
        if not params:
            return None

        params["clu_operation"] = "deletecluster";
        cluster = MvmCluster(self.HTTP, self.ecraHost, params)

        svcJson = cluster.createPayload()
        if not svcJson:
            return None

        if ecli.interactive:
            cl.prt("c", "Deleting cluster {0} with exaservice with id: {1}".format(params["exaunit_id"],
                                                                                    params["exaservice_id"]))
        data = json.dumps(svcJson, sort_keys=True, indent=4)
        return self.HTTP.put("{0}/exaservice/{1}".format(host, params["exaservice_id"]), data, "exaservice")


    def do_delete_exaservice(self, ecli, line, host, mytmpldir):

        # validate params and initialize
        params = self.init(ecli, line, host, 'delete')
        if not params:
            return None

        if not self.validateDeleteExaserviceParams(params):
            return
        svcJson = self.composeDeleteExaServiceJson(params)
        if not svcJson:
            return None

        if ecli.interactive:
            cl.prt("c", "Deleting exaservice with id: {0}".format(params["exaservice_id"]))

        data = json.dumps(svcJson, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/exaservice/{1}".format(host, params["exaservice_id"]), data)
        print(response)


    def do_list_exaservice_ids(self):
        listExaservicesApi = "{0}/exaservice/list".format(self.ecraHost)
        response = self.HTTP.get(listExaservicesApi)
        if response is None:
            cl.perr("Error: Unable to fetch list of exaservices from ECRA")
            return None
        return response

    def do_list_clusters(self, params):
        exaserviceId = params["exaservice_id"]
        exaunitId = None
        if "exaunit_id" in params and params["exaunit_id"]:
            exaunitId = params["exaunit_id"]

        listExaservicesApi = "{0}/exaservice/{1}/resourceinfo".format(self.ecraHost, exaserviceId)
        if exaunitId:
            listExaservicesApi += "?exaunit={0}".format(exaunitId)
        response = self.HTTP.get(listExaservicesApi)
        if response is None:
            cl.perr("Error: Unable to fetch list of clusters for exaservice " +  exaserviceId + " from ECRA")
            return None
        return response

    def do_list_exaservice(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'list')
        if not params :
            return None

        response = None
        if "exaservice_id" not in params or not params["exaservice_id"]:
            if "exaunit_id" in params:
                cl.perr("<exaunit_id> specified but missing param <exaservice_id>")
                return None
            else:
                # return a simple list of existing exaservice ids with no resource info
                response = self.do_list_exaservice_ids()
        else:
            response  = self.do_list_clusters(params)

        cl.prt("n", json.dumps(response))


    def do_migrate_exaservice(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'migrate')
        if not params :
            return None

        response = None
        if not self.validateMigrateExaserviceParams(params):
            return None

        migJson = self.composeMigrateExaServiceJson(params)
        if not migJson:
            return None
        data = json.dumps(migJson, sort_keys=True, indent=4)
        if params["mode"] == "svm-to-mvm":
            if ecli.interactive:
                cl.prt("c", "Migrating single vm service with id: {0}".format(migJson["instanceId"]))
            response = self.HTTP.post(data, "exaservice", "{0}/exaservice/migrate".format(self.ecraHost))
        elif params["mode"] == "mvm-to-nodesubset":
            exaserviceId = params["instanceId"]
            if ecli.interactive:
                cl.prt("c", "Migrating multi-vm service to multi-vm with node subsets. Instance id: {0}".format(exaserviceId))
            mvmToNodeSubsetMigrateApi = "{0}/exaservice/migrate/mvmtonodesubset/instanceid/{1}"
            payload = json.dumps(migJson, sort_keys=True, indent=4)
            response = self.HTTP.put(mvmToNodeSubsetMigrateApi.format(self.ecraHost, exaserviceId), payload, "exaservice")

        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))

        return response


    def do_migrate_status(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'migratestatus')
        if not params:
            return None

        response = None
        if not self.validateMigrateStatusExaserviceParams(params):
            return

        serviceId = params["service_id"]
        outfile = None
        if "outfile" in params and params["outfile"]:
            outfile = params["outfile"]
        cl.prt("c", "Fetching migration status for single-vm service with id: {0}".format(serviceId))
        statusApi = "{0}/exaservice/migrate/status?instanceid={1}"
        if params["mode"] == "mvm-to-nodesubset":
            statusApi += "&operation=mvm-nodesubset-migrate"
        else:
            statusApi += "&operation=mvm-migrate"
        if outfile:
            statusApi += "&statusfile={0}".format(outfile)

        response = self.HTTP.get(statusApi.format(self.ecraHost, serviceId))
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
        return response


    def do_migrate_prefetch(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'migrateprefetch')
        if not params:
            return None

        response = None
        if not self.validateMigratePrefetchExaserviceParams(params):
            return None

        exaunitId = None
        serviceId = None
        outfile = None
        if "exaunit_id" in params and params["exaunit_id"]:
            exaunitId = params["exaunit_id"]
        if "service_id" in params and params["service_id"]:
            serviceId = params["service_id"]
        if "outfile" in params and params["outfile"]:
            outfile = params["outfile"]
        cl.prt("c",
               "Prefetching details from ecra. No migration will be attempted. Please use the prefetched data to manually verify the data")
        prefetchApi = "{0}/exaservice/migrate/prefetch?"
        amp = ""
        if exaunitId:
            prefetchApi += "exaunitid={0}".format(exaunitId)
            amp = '&'
        if serviceId:
            prefetchApi += "{0}instanceid={1}".format(amp, serviceId)
            amp = '&'
        if outfile:
            prefetchApi += "{0}outfile={1}".format(amp, outfile)

        response = self.HTTP.get(prefetchApi.format(self.ecraHost))
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
        return response


    def do_migrate_postfetch(self, ecli, line, host):
        # validate params and initialize
        params = self.init(ecli, line, host, 'migratepostfetch')
        if not params:
            return None

        response = None
        if not self.validateMigratePostfetchExaserviceParams(params):
            return None

        exaserviceId = params["exaservice_id"]
        # The ecra db entity to fetch
        entity = params["entity"]
        exaunitId = None
        outfile = None
        if "exaunit_id" in params and params["exaunit_id"]:
            exaunitId = params["exaunit_id"]
        if "outfile" in params and params["outfile"]:
            outfile = params["outfile"]
        cl.prt("c",
               "Fetching details from ecra (post migration) for exaservice_id " + exaserviceId + " Entity: " + entity)
        postfetchApi = "{0}/exaservice/migrate/postfetch?"
        postfetchApi += "instanceid={0}&entity={1}".format(exaserviceId, entity)
        if exaunitId:
            postfetchApi += "&exaunitid={0}".format(exaunitId)
        if outfile:
            postfetchApi += "&outfile={0}".format(outfile)

        response = self.HTTP.get(postfetchApi.format(self.ecraHost))
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
        return response


    def do_migrate_postupdate(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'migratepostupdate')
        if not params:
            return None

        exaserviceId = params["exaservice_id"]
        payloadJsonFile = params["input_json"]
        payload = open(payloadJsonFile).read()
        # Validate the json
        payloadJson = json.loads(payload)
        postupdateApi = "{0}/exaservice/migrate/postupdate/instanceid/{1}"
        payload = json.dumps(payloadJson, sort_keys=True, indent=4)
        response = self.HTTP.put(postupdateApi.format(self.ecraHost, exaserviceId), payload, "exaservice")
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
        return response


    def do_migrate_rollback(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'migraterollback')
        if not params:
            return None

        response = None
        if not self.validateMigrateRollbackExaserviceParams(params):
            return None

        serviceId = params["service_id"]
        cl.prt("c", "Rolling back migration for single-vm service with id: {0}".format(serviceId))
        rollbackApi = "{0}/exaservice/migrate/rollback/{1}/operation/{2}"
        migOperation = None
        if params["mode"] == "mvm-to-nodesubset":
            migOperation = "mvm-nodesubset-migrate"
        else:
            migOperation = "mvm-migrate"
        response =  self.HTTP.put(rollbackApi.format(self.ecraHost, serviceId, migOperation), None, "exaservice")
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
        return response


    def do_reshape_exaservice(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'reshape')
        if not params :
            return None

        response = None
        if "rack_cores" in params and "burst_cores" in params:
          cl.perr("Only one of rack_cores or burst_cores can be specified.")
          return None

        if not self.validateReshapeExaserviceParams(params):
            return None

        svcJson = self.composeReshapeExaServiceJson(params)
        if not svcJson:
            return None

        if ecli.interactive:
            cl.prt("c", "Reshaping exaservice with id: {0}".format(params["exaservice_id"]))

        data = json.dumps(svcJson, sort_keys=True, indent=4)
        response =  self.HTTP.put("{0}/exaservice/{1}".format(host, params["exaservice_id"]), data, "exaservice")
        cl.prt("n", json.dumps(response))
        return response
    
    def do_suspend_exaservice(self, ecli, line, host):
        # validate params and initialize
        params = self.init(ecli, line, host, 'suspend')
        if not params :
            return None
        
        response = None
        if "exaservice_id" not in params or not params["exaservice_id"]:  
            cl.perr("<exaservice id> is a manadatory parameter")
            return None
            
        response =  self.HTTP.put("{0}/exaservice/{1}/suspend".format(host, params["exaservice_id"]), None, "exaservice")
        cl.prt("n", json.dumps(response))
        return response

    def do_resume_exaservice(self, ecli, line, host):

        # validate params and initialize
        params = self.init(ecli, line, host, 'resume')
        if not params :
            return None

        response = None
        if "exaservice_id" not in params or not params["exaservice_id"]:
            cl.perr("<exaservice id> is a manadatory parameter")
            return None    

        response =  self.HTTP.put("{0}/exaservice/{1}/resume".format(host, params["exaservice_id"]), None, "exaservice")
        cl.prt("n", json.dumps(response))
        return response

    def do_fetch_rackinfo_for_exaservice(self, ecli, line, host):
        # validate params and initialize
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("exaservice", "rackinfo", params)
        except Exception as e:
            cl.perr(str(e))
            return  

        response = None
        if "exaservice_id" not in params or not params["exaservice_id"]:
            cl.perr("<exaservice id> is a manadatory parameter")
            return None    

        url = "{0}/exaservice/{1}/rackinfo".format(host, params["exaservice_id"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
        return response

    def do_fetch_resourceinfo(self, ecli, line, host):
        self.ecraHost = host
        params = ecli.parse_params(line, None, optional_key="exaservice_id")
        try:
            ecli.validate_parameters("exaservice", "resourceinfo", params)
        except Exception as e:
            cl.perr(str(e))
            return
        response = self.getResourceInfo(params["exaservice_id"])
        cl.prt("c", json.dumps(response, sort_keys=True, indent=4))


    def do_syncrackslots(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exaservice', 'syncrackslots', params)
        except Exception as e:
            cl.perr(str(e))
            return

        exadata = params["exadata_id"]

        response = self.HTTP.put("{0}/exaservice/{1}/syncrackslots".format(host, exadata), json.dumps(params), "exaservice")
        cl.prt("n", json.dumps(response))

