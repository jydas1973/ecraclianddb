"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Exaunit - CLIs for operations on the exaservice

FUNCTION:
    Provides the clis for CRUD operations on exaservice

NOTE:
    None

History:
    hcheon      28/09/2020 - bug-31942864 Fixed pylint errors
    brsudars    27/05/2018 - Node subset related changes
    brsudars    01/05/2018 - Higgs related changes
    brsudars    11/08/2017 - Create file
"""
from formatter import cl
import json
import os
from os import path
import base64
import pdb
import uuid
from clis.EcliUtil import EcliUtil
from clis.Higgs import Higgs

class MvmCluster:
    def __init__(self, HTTP, host, params, tmplDir=None):
        self.HTTP = HTTP
        self.ecraHost = host
        self.params = params
        self.tmplDir = tmplDir

    def getExaunitAllocation(self):

        op = self.params["clu_operation"]
        if op == "addcluster":
            return self.createExaunitPropPayloadForAddCluster()
        elif op == "reshapecluster":
            return self.createExaunitPropPayloadForReshapeCluster()
        elif op == "coreburstcluster":
            return self.createExaunitPropPayloadForCoreburstCluster()
        elif op == "deletecluster":
            return self.createExaunitPropPayloadForDeleteCluster()
        else:
            cl.perr("Internal error: Unknown operation " + op)
            return None

    def validateDeleteClusterParams(self):
        # Exaunit id is already validated at this point. Nothing to do
        return True

    def validateCoreburstClusterParams(self):

        if not EcliUtil.isIntegerParam(self.params["clu_cores"], "clu_cores"):
          return False

        return True


    def validateReshapeClusterParams(self):

        # Validate the resource params
        reshapeParams = ["clu_cores", "clu_memory", "clu_storage", "clu_ohsize"]
        for rp in reshapeParams:
            if rp in self.params and self.params[rp]:
              if not EcliUtil.isIntegerParam(self.params[rp], rp):
                return False
              else:
                return True

        # No resource param was specified. Validate the node_subset param.
        # Convert user given list to ecra "node-N" format
        # For example, "1,node-2,4,node-7" to "node-1,node-2,node-4,node-7"
        if "node_subset" in self.params and self.params["node_subset"]:
            nodeSubsetCsv = self.params["node_subset"]
            nodeSubsetList = [ns.strip() for ns in nodeSubsetCsv.split(',')]
            self.params["node_subset_list"] = ["node-" + str(node) if node.isdigit() else node for node in
                                               nodeSubsetList]
            return True

        reshapeParams.append("node_subset")
        cl.perr("Missing param: One of the following cluster resource params need to be specified: " + str(reshapeParams))
        return False

    def getRacksizeAndModelFromExaservice(self):
        listExaservicesApi = "{0}/exaservice/list".format(self.ecraHost)
        response = self.HTTP.get(listExaservicesApi)
        if response is None:
            cl.perr("Error: Unable to fetch list of exaservices from ECRA. Failed to determine racksize and model.")
            return False

        exaserviceList = response["exaservices"]
        for svc in exaserviceList:
            if svc["id"].lower() == self.params["exaservice_id"].lower():
                self.params["racksize"] = svc["racksize"]
                self.params["model"] = svc["model"]
                cl.prt("n", "Racksize is: " + self.params["racksize"] + " Model is: " + self.params["model"])
                return True

        cl.perr("Error: Invalid exaservice_id:" + self.params["exaservice_id"] + ". Failed to determine racksize and model.")
        return False



    def validateAddClusterParams(self):

        if "enable_sparse" in self.params and self.params["enable_sparse"]:
            createSparse = self.params["enable_sparse"]
            if not createSparse in ("Y", "N"):
                cl.perr(createSparse + " is not a valid option for enable_sparse: [Y, N]")
                return False
        else:
            self.params["enable_sparse"] = "N"

        if "backupto_disk" in self.params and self.params["backupto_disk"]:
            backupToDisk = self.params["backupto_disk"]
            if not backupToDisk in ("Y", "N"):
                cl.perr(backupToDisk + " is not a valid option for backupto_disk. Please specify one of: [Y, N]")
                return False
        else:
            self.params["backupto_disk"] = "N"

        # Convert user given list to ecra "node-N" format
        # For example, "1,node-2,4,node-7" to "node-1,node-2,node-4,node-7"
        if "node_subset" in self.params and self.params["node_subset"]:
            nodeSubsetCsv = self.params["node_subset"]
            nodeSubsetList = [ns.strip() for ns in nodeSubsetCsv.split(',')]
            self.params["node_subset_list"] = ["node-" + str(node) if node.isdigit() else node for node in nodeSubsetList]

        # Default to SMALL size if not specified
        if "clu_size" not in self.params or not self.params["clu_size"]:
            self.params["clu_size"] = "SMALL"

        if "clu_name" not in self.params or not self.params["clu_name"]:
            # Prepend "clu" as cluster names have to begin with an alphabet
            self.params["clu_name"] = "clu" + str(uuid.uuid4().hex.lower()[:7])

        mandatoryResourceParams = ["clu_cores", "clu_memory", "clu_storage", "clu_ohsize"]
        foundAllParams = True
        for rp in mandatoryResourceParams:
            if rp not in self.params or not self.params[rp]:
                foundAllParams = False
            elif not EcliUtil.isIntegerParam(self.params[rp], rp):
                return False

        # All resource params have been specified on command line. There is no need to call shapes API.
        if foundAllParams:
            return True

        if "racksize" not in self.params or "model" not in self.params:
            if not self.getRacksizeAndModelFromExaservice():
                return False

        racksize = self.params["racksize"]
        model = self.params["model"]
        shapesApi = "{0}/clustershapes?racksize={1}&model={2}".format(self.ecraHost, racksize, model)
        shapesJson = self.HTTP.get(shapesApi)
        if shapesJson is None:
            cl.perr("Error: Unable to fetch shape info for rack " + racksize + " and model " + model)
            return False
        shape = None
        shapeFound = False
        for shape in shapesJson["clusterShapes"]:
            if shape["shape"].upper() == self.params["clu_size"].upper():
                shapeFound = True
                break

        if not shapeFound:
            cl.perr("Error: Shape not found: " + self.params["clu_size"] + ". Racksize:" + racksize + " model:" + model)
            return False

        if "clu_cores" not in self.params or not self.params["clu_cores"]:
            self.params["clu_cores"] = shape["numCoresPerCluster"]
        if "clu_memory" not in self.params or not self.params["clu_memory"]:
            self.params["clu_memory"] = shape["gbMemPerCluster"]

        if "clu_storage" not in self.params or not self.params["clu_storage"]:
            self.params["clu_storage"] = shape["tbStoragePerCluster"]

        if "clu_ohsize" not in self.params or not self.params["clu_ohsize"]:
            self.params["clu_ohsize"] = shape["gbOhSize"]

        return True

    def getCurrCoresForCluster(self):

        cores = self.HTTP.get("{0}/exaunit/{1}/cores".format(self.ecraHost, self.params["exaunit_id"]))
        if not cores:
            cl.perr("Unable to fetch current cores information from ecra for cluster:" + self.params["exaunit_id"])
            return None
        return cores

    def getOcpuAllocForCoreBurst(self):

        cores = self.getCurrCoresForCluster()
        if not cores:
            return None
        numComputes = len(cores["ocpuAllocations"])
        if (int(self.params["clu_cores"]) % numComputes) != 0 :
            cl.perr("Cores specified " + self.params["clu_cores"] + " should be a multiple of number of computes: " + str(numComputes))
            return None

        burstCoresPerNode = int(self.params["clu_cores"]) / numComputes
        # loop through each compute node
        for vm_cores in cores["ocpuAllocations"]:
            vm_cores["burstOcpu"] = burstCoresPerNode

        return cores

    def createExaunitPropPayloadForDeleteCluster(self):

        if not self.validateDeleteClusterParams():
            return None

        clusterJson = {}
        exaunitProperties = []
        exaunitProperties.append({"name": "Operation", "value": "DeleteCluster"})
        exaunitProperties.append({"name": "ExaunitID", "value": self.params["exaunit_id"]})
        clusterJson["ExaunitProperties"] = exaunitProperties

        return json.dumps(clusterJson, sort_keys=True, indent=4)


    def createExaunitPropPayloadForCoreburstCluster(self):

        if not self.validateCoreburstClusterParams():
            return None

        clusterJson = {}

        exaunitProperties = []
        exaunitProperties.append({"name": "Operation", "value": "CoreBurst"})
        exaunitProperties.append({"name": "ExaunitID", "value": self.params["exaunit_id"]})
        # OCPU_ALLOCATIONS json
        ocpuAlloc = self.getOcpuAllocForCoreBurst()
        if not ocpuAlloc:
            cl.perr("Error: Failed to create core burst OCPU_ALLOCATIONS payload for: " + self.params["clu_operation"])
            return None
        ocpuAllocStr = json.dumps(ocpuAlloc, sort_keys=True, indent=4)
        exaunitProperties.append({"name": "OCPU_ALLOCATIONS", "value": base64.b64encode(ocpuAllocStr.encode("utf-8")).decode("utf-8")})
        # Values below for AdditionalNumOfCoresHourly is not the delta that is expected by PSM
        # but is ok here as ecracli is not used by PSM. In the real end to end flow CIM/TAS will set this.
        #  ECRA doesn't use these values
        exaunitProperties.append({"name": "AdditionalNumOfCoresHourly", "value": self.params["clu_cores"]})
        clusterJson["ExaunitProperties"] = exaunitProperties

        return json.dumps(clusterJson, sort_keys=True, indent=4)


    def createExaunitPropPayloadForReshapeCluster(self):

        if not self.validateReshapeClusterParams():
            return None

        clusterJson = {}

        exaunitProperties = []
        exaunitProperties.append({"name": "Operation", "value": "ReshapeCluster"})
        if "clu_cores" in self.params and self.params["clu_cores"]:
            exaunitProperties.append({"name": "TotalNumOfCoresForCluster", "value": self.params["clu_cores"]})
        if "clu_memory" in self.params and self.params["clu_memory"]:
            exaunitProperties.append({"name": "TotalMemoryInGb", "value": self.params["clu_memory"]})
        if "clu_storage" in self.params and self.params["clu_storage"]:
            exaunitProperties.append({"name": "StorageInTb", "value": self.params["clu_storage"]})
        if "clu_ohsize" in self.params and self.params["clu_ohsize"]:
            exaunitProperties.append({"name": "OhomePartitionInGB", "value": self.params["clu_ohsize"]})
        if "node_subset_list" in self.params:
            participatingNodesJson = {}
            participatingNodes = []
            nodeSubsetList = self.params["node_subset_list"]
            i = 0
            while i < len(nodeSubsetList):
                participatingNodes.append({"ComputeNodeAlias": nodeSubsetList[i]})
                i += 1
            participatingNodesJson["ParticipatingNodes"] = participatingNodes
            participatingNodesJsonStr = json.dumps(participatingNodesJson, sort_keys=True, indent=4)
            exaunitProperties.append({"name": "NodeSubset", "value": base64.b64encode(participatingNodesJsonStr.encode("utf-8")).decode("utf-8")})

        exaunitProperties.append({"name": "ExaunitID", "value": self.params["exaunit_id"]})
        clusterJson["ExaunitProperties"] = exaunitProperties

        return json.dumps(clusterJson, sort_keys=True, indent=4)

    def createExaunitPropPayloadForAddCluster(self):

        if not self.validateAddClusterParams():
            return None

        clusterJson = {}

        exaunitProperties = []
        exaunitProperties.append({"name": "Operation", "value": "AddCluster"})
        exaunitProperties.append({"name": "TotalNumOfCoresForCluster", "value": self.params["clu_cores"]})
        exaunitProperties.append({"name": "TotalMemoryInGb", "value": self.params["clu_memory"]})
        exaunitProperties.append({"name": "StorageInTb", "value": self.params["clu_storage"]})
        exaunitProperties.append({"name": "OracleHomeDiskSizeInGb", "value": self.params["clu_ohsize"]})
        exaunitProperties.append({"name": "ExaUnitName", "value": self.params["clu_name"]})
        exaunitProperties.append({"name": "CreateSparse", "value": self.params["enable_sparse"]})
        exaunitProperties.append({"name": "BackupToDisk", "value": self.params["backupto_disk"]})
        if "rack_name" in self.params:
            exaunitProperties.append({"name": "rack_name", "value": self.params["rack_name"]})
        if "exadata_id" in self.params:
            exaunitProperties.append({"name": "exadata_id", "value": self.params["exadata_id"]})
        if "node_subset_list" in self.params:
            participatingNodesJson = {}
            participatingNodes = []
            nodeSubsetList = self.params["node_subset_list"]
            i = 0
            while i < len(nodeSubsetList):
                participatingNodes.append({"ComputeNodeAlias": nodeSubsetList[i]})
                i += 1
            participatingNodesJson["ParticipatingNodes"] = participatingNodes
            participatingNodesJsonStr = json.dumps(participatingNodesJson, sort_keys=True, indent=4)
            exaunitProperties.append({"name": "NodeSubset", "value": base64.b64encode(participatingNodesJsonStr.encode("utf-8")).decode("utf-8")})

        clusterJson["ExaunitProperties"] = exaunitProperties

        return json.dumps(clusterJson, sort_keys=True, indent=4)

    # Creates the base/standard cluster payload with EXAUNUIT_ALLOCATIONS json. Caller can add additional fields if any
    def createBasePayload(self):
        exaunitAlloc = self.getExaunitAllocation()
        if not exaunitAlloc:
            cl.perr("Error: Failed to create exaunit allocation payload for: " + self.params["clu_operation"])
            return None

        svcJson = {}
        svcJson["request_id"] =   str(uuid.uuid4())
        svcJson["id"] = self.params["exaservice_id"]
        sspList = []
        sspList.append({"name": "EXAUNIT_ALLOCATIONS", "value": base64.b64encode(exaunitAlloc.encode("utf-8")).decode("utf-8")})
        svcJson["service_specific_payload"] = sspList
        return svcJson

    def createPayloadForDeleteCluster(self):
        return self.createBasePayload()

    def createPayloadForCoreburstCluster(self):
        return self.createBasePayload()

    def createPayloadForReshapeCluster(self):
        return self.createBasePayload()

    def createPayloadForAddCluster(self):
        svcJson = self.createBasePayload()
        if not svcJson:
            return None

        # Add higgs specific payload to cluster payload
        exaunitAlloc64 = None
        exaunitAlocNvp = None
        nvp = None
        for nvp in svcJson["service_specific_payload"]:
            name = nvp["name"]
            if name == "EXAUNIT_ALLOCATIONS":
                exaunitAlloc64 = nvp["value"]
                exaunitAlocNvp = nvp
                break

        if not exaunitAlloc64:
            cl.perr("Error: payload missing EXAUNIT_ALLOCATIONS")
            return None

        exaunitAlloc = json.loads(base64.b64decode(exaunitAlloc64))
        if not Higgs.setHiggsPayloadForCreate(self.tmplDir, svcJson, exaunitAlloc["ExaunitProperties"], self.params):
            cl.perr("Error: Failed to set Higgs specific payload params")
            return None
        # Store the updated EXAUNIT_ALLOCATIONS
        exaunitAlocNvp["value"] =  base64.b64encode(json.dumps(exaunitAlloc, sort_keys=True, indent=4).encode("utf-8")).decode("utf-8")
        return svcJson

    def createPayload(self):

        op = self.params["clu_operation"]
        if op == "addcluster":
            return self.createPayloadForAddCluster()
        elif op == "reshapecluster":
            return self.createPayloadForReshapeCluster()
        elif op == "coreburstcluster":
            return self.createPayloadForCoreburstCluster()
        elif op == "deletecluster":
            return self.createPayloadForDeleteCluster()
        else:
            cl.perr("Internal error: Unknown operation " + op)
            return None
