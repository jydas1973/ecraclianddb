#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/ExadataInfra.py /main/59 2025/11/28 04:38:12 zpallare Exp $
#
# ExadataInfra.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      ExadataInfra.py - CLIs for ExadataInfra for elastic shape
#
#    DESCRIPTION
#      Provides clis for elastic shape CEI creation/handling
#
#    NOTES
#
#    MODIFIED   (MM/DD/YY)
#    zpallare    11/27/25 - Enh 38684873 - EXACS - Review mvm subnet usage in
#                           provisioning flow
#    jzandate    11/18/25 - Enh 38618961 - Updating CS Payload for admin
#                           network
#    zpallare    09/01/25 - Enh 38205630 - Update asm reshape flow for cs to
#                           handle custom data/reco/sparse allocations
#    hbpatel     08/28/25 - Enh 38303743: Implement ops ecracli cmd for altering vm state in ecra db
#    zpallare    07/31/25 - Enh 38205599 - Update create service flow for cs to
#                           handle custom data/reco/sparse allocation
#    llmartin    07/08/25 - Enh 37468627 - forward skipresize parameter
#    llmartin    04/28/25 - Enh 37783329, Add AttachStorage exascale endpoint
#    llmartin    04/15/25 - Enh 37641386, Attach stroage new parameter,
#                           vmclusterocid
#    zpallare    12/16/24 - Enh 35170531 - EXACS:ECRACLI,sshkey, add support to
#                           get sshkeys of a cei
#    gvalderr    12/04/24 - Enh 37244095 - Adding command for disabling backups
#                           and increase available storage
#    caborbon    11/07/24 - ENH 37229123 - Adding option in create to
#                           dynamically pass the cpg value
#    zpallare    10/17/24 - Enh 37176101 - EXACS X11M - Validate zrcv flow for
#                           x-z models to only pick x11m-z models
#    zpallare    09/25/24 - Enh 36922155 - EXACS X11M - Base system support
#    jzandate    08/30/24 - Enh 36990358 - updating parameters
#    caborbon    08/15/24 - BUG 36862350 - Adding restriction in
#                           checkdataintegrity to avoid svm infrastructures
#    jzandate    08/08/24 - Enh 36904108 - Adding ecracli cmd for secure erase
#    gvalderr    07/16/24 - Enh 36329200 - Adding asm power limit parameter to
#                           add/delete storage
#    zpallare    05/28/24 - Bug 36536656 - ECRA - Fix problem in exadatainfra
#                           info
#    zpallare    04/04/24 - Bug 36308005 - Add gridversion param to add_cluster
#    jreyesm     02/16/24 - Bug 36301056. secure random using secrets
#    pverma      12/12/23 - NodeRecovery SOP support
#    caborbon    12/04/23 - Bug 36067387 - Adding cabinet name param for
#                           Exadatainfrastructure create command
#    zpallare    11/21/23 - Enh 36023077 - ECRA - Create exadatainfrastructure
#                           command to get the initial payload
#    gvalderr    10/31/23 - Enh 35832683 - adding delete storage endpoint
#    zpallare    10/10/23 - Enh 35853794 - EXACS: Fix padding in info operation
#    gvalderr    07/27/23 - Ehn 35621839 - Changing filesystem key value.
#    ddelgadi    07/11/23 - Enh 35586243 - add model as parameter when create infra 
#    ririgoye    06/22/23 - Enh 35319264 - Added drop command
#    aadavalo    06/21/23 - Enh 35435491 - update reshape cluster to support
#                           filesystem resize
#    ddelgadi    05/19/23 - Bug 35379450 - add skip command
#    anudatta    04/18/22 - Bug 35281539 : Precheck API for  exadatainfrastructure reshapecluster operation
#    ririgoye    12/13/22 - Bug 34838352 - Fixed insecure random function calls
#    caborbon    12/09/22 - Bug 34882729 - Fixing issue in add cluster -> oHome
#                           parameter
#    ddelgadi    11/22/22 - Enh 34579733 - Add support dev to updateNetmetadata
#    ddelgadi    11/07/22 - Bug - 34705200 add option to manage the cores,
#                           memory and storage
#    illamas     10/31/22 - Bug 34707424 - Increase tb storage value
#    caborbon    09/23/22 - Bug 34567183 - Correction in
#                           create_addcluster_payload to concatenate the
#                           correct hostname
#    illamas     09/01/22 - Enh 34530558 - List VMs based on oracle hostname
#    caborbon    08/23/22 - Bug 34409879 - Adding model field in exainfra info
#                           request
#    caborbon    07/12/22 - Bug 34343793 - Adding info command
#    llmartin    06/20/22 - Fix hostname if dev option is provided
#    caborbon    05/13/22 - Bug 34071434 - fixing bug in check_data_integrity
#                           function to force to provide parameters
#    aadavalo    05/11/22 - Bug 34096543 - Adding clustername to
#                           exadatainfrastructure add_cluster
#    caborbon    03/01/22 - ENH 33882107 - Adding filter in data integrity
#                           function
#    llmartin    02/15/22 - Enh 33055667 - OciBM Migration, SVM to MVM
#    caborbon    01/25/22 - Bug 33630707 - Adding commandfto check Data
#                           integrity
#    illamas     01/03/22 - Enh 33676584 - Changing reshape input from JSON to
#                           arguments in ecracli
#    caborbon    11/19/21 - Enh 33428084 - Adding dev=filter in addcluster
#    llmartin    10/27/21 - Remove 'continue' output
#    piyushsi    10/14/21 - BUG 33055662 Exacs MVM Reshape Support
#    jreyesm     09/14/21 - Return all infras option
#    llmartin    09/11/21 - Dev options for add_cluster
#    llmartin    08/27/21 - Enh 33055649 - AddCluster API for MVM
#    illamas     08/04/21 - Enh 33055641 - New apis for rack reserve/release
#    llmartin    08/03/21 - Enh 33055636 - MVM, Exadata Infrastructure initial
#                           metadata
#    rgmurali    07/09/21 - Bug 33080527 - Fix cli for exa infra create
#    rgmurali    03/12/21 - Bug 32622840 - add ceiocid in command line
#    rgmurali    12/09/20 - Creation
#

from formatter import cl
import json
import os
from os import path
import secrets

class ExadataInfra:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_create_exadatainfrastructure(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'create', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            payload = json.load(open(params["json_path"]))

        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get idemtoken to reserve CEI for elastic shapes")
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        payload["idemtoken"] = retObj["idemtoken"]

        if "exadataInfrastructureId" in params:
            payload["exadataInfrastructureId"] = params["exadataInfrastructureId"]
        
        if "model" in params:
            for item in payload['servers']:
                item['model'] = params["model"]
        if "computecabinetname" in params:
            for item in payload['servers']:
                if item["hw_type"] == "COMPUTE":
                    item["cabinetname"] = params["computecabinetname"]
        if "cellcabinetname" in params:
            for item in payload['servers']:
                if item["hw_type"] == "CELL":
                    item["cabinetname"] = params["cellcabinetname"]
        if "clustertag" in params:
            payload["clustertag"] = params["clustertag"]
        
        if "cellsubtype" in params:
            cellSubtype = params.get("cellsubtype")
            for item in payload['servers']:
                if item["hw_type"] == "CELL":
                    item["celltype"] = cellSubtype

        if "computesubtype" in params:
            computeSubtype = params.get("computesubtype")
            for item in payload['servers']:
                if item["hw_type"] == "COMPUTE":
                    item["computetype"] = computeSubtype

        if "sitegroup" in params:
            payload["sitegroup"] = params["sitegroup"]
       
        if "reuseceiocid" in params:
            try:
                response = ecli.issue_get_request("{0}/exadatainfrastructure/{1}".format(host,params.get("exadataInfrastructureId")), False)
            except Exception as e:
                response = ""
            if response and "ComputeNodeResourcesStatus" in response:
                response["skip_command"]=True
                cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
                return

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exadatainfrastructure", "{0}/exadatainfrastructure".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_get_exadatainfrastructure(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'get', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if params.get("rackname"):
            response = ecli.issue_get_request("{0}/exadatainfrastructure/rackname/{1}".format(host,params.get("rackname")), False)
            if response and "infra" in response:
                if response.get("infra") != "ERROR":
                    params["exadataInfrastructureId"] = response.get("infra")
                else:
                    cl.perr("Error getting infra for the provided rackname")
                    return
            else:
                cl.perr("Error getting infra for the provided rackname")
                return
        
        if not 'exadataInfrastructureId' in params:
             response = ecli.issue_get_request("{0}/exadatainfrastructure".format(host), False)
             cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
             return 
        ceiocid = params.pop("exadataInfrastructureId")
        response = ecli.issue_get_request("{0}/exadatainfrastructure/{1}".format(host, ceiocid), False)

        response_filter = params.pop("filter", "")
        if response:
            if response_filter == "computes":
                cl.prt("n", json.dumps(response["ComputeNodeResourcesStatus"], indent=4, sort_keys=True))
            elif response_filter == "servers":
                cl.prt("n", json.dumps(response["servers"], indent=4, sort_keys=True))
            elif response_filter == "rackslots":
                cl.prt("n", json.dumps(response["rackSlotsDetails"], indent=4, sort_keys=True))
            elif response_filter == "allocations":
                response.pop("ComputeNodeResourcesStatus")
                response.pop("servers")
                response.pop("rackSlotsDetails")
                response.pop("rackSlots")
                cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
            else:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_delete_exadatainfrastructure(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'delete', params)
        except Exception as e:
            cl.perr(str(e))
            return

        ceiocid = params.pop("exadataInfrastructureId")

        response = self.HTTP.delete("{0}/exadatainfrastructure/{1}".format(host, ceiocid))

        if response:
            cl.prt("n", json.dumps(response))

    def do_rack_reserve_exadatainfrastructure(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'rack_reserve', params)
        except Exception as e:
            cl.perr(str(e))
            return
        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        ceiocid = params["exadataInfrastructureId"]
        params.pop("exadataInfrastructureId")
        params["idemtoken"] = idemtoken
        if "nodeComputeAliases" in params:
            params["NodeComputeAliases"] = params.get("nodeComputeAliases").split(",")
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exadatainfrastructure", "{0}/exadatainfrastructure/{1}/racks/reserve".format(host, ceiocid))
        if response:
            cl.prt("n", json.dumps(response))

    def do_rack_release_exadatainfrastructure(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'rack_release', params)
        except Exception as e:
            cl.perr(str(e))
            return
        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        ceiocid = params["exadataInfrastructureId"]
        params["idemtoken"] = idemtoken
        rackname = params["rackname"]
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exadatainfrastructure", "{0}/exadatainfrastructure/{1}/racks/release/{2}".format(host, ceiocid, rackname))
        if response:
            cl.prt("n", json.dumps(response))


    def do_add_cluster(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'add_cluster', params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = json.load(open(params["json_path"]))
        payload["rackname"] = params["rackname"]

        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        payload["idemtoken"] = idemtoken
        ceiocid = params["exadataInfrastructureId"]
        if "dev" in params:
            if params['dev'] == 'default' or params['dev'] == 'true':
                payload = self.create_addcluster_payload(params["rackname"], payload, host)
                #cl.prt("n", json.dumps(payload))
            if params['dev'] == 'filter':
                payload = self.create_addcluster_payload_filter(params["rackname"], payload, host)
        if "clustername" in params:
            payload["clustername"] = params["clustername"]
        if "cores" in params:
            payload["exaunitAllocations"]["cores"] = params["cores"]
        if "memorygb" in params:
            payload["exaunitAllocations"]["memoryGb"] = params["memorygb"]
        if "storagetb" in params:
            payload["exaunitAllocations"]["storageTb"] = params["storagetb"]
        if "ohomesizegb" in params:
            payload["exaunitAllocations"]["ohomeSizeGb"] = params["ohomesizegb"]
        if "gridversion" in params:
            payload["grid_version"] = "v"+params["gridversion"]
        if "diskgroupsallocation" in params:
            payload["exaunitAllocations"]["diskgroupsAllocation"] = self.get_allocations_array(params["diskgroupsallocation"])
        if "createsparse" in params:
            payload["createsparse"] = params["createsparse"]
        if "backupdisk" in params:
            payload["backup_disk"] = params["backupdisk"]
                
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exadatainfrastructure/{1}/cluster".format(host, ceiocid), data, "exadatainfrastructure")
        if response:
            cl.prt("n", json.dumps(response))
      
    def create_addcluster_payload_filter(self, rackname, payload, host):
        racknodes = self.HTTP.get("{0}/racks/{1}/nodes".format(host, rackname))
        racknodes = list(filter(lambda node: node['type'].lower() == 'compute', racknodes['nodes'])) 
        nodes_in_payload = payload['customer_network']['nodes']
        valid_nodes=[]
        missing_node_flag = False;
        for racknode in racknodes:
            hostname = racknode['hostname']
            for node in nodes_in_payload:
                if node['client']['dom0_oracle_name'] == hostname:
                    valid_nodes.append(node)
                    missing_node_flag = False
                    break
                else:
                    missing_node_flag = True
            if(missing_node_flag):
                cl.perr("Could not find the node in payload {0}".format(hostname))
                valid_nodes=[]
                break
        
        payload['customer_network']['nodes'] = valid_nodes
        return payload
      
    def create_addcluster_payload(self, rackname, payload, host):
        rackports = self.HTTP.get("{0}/racks/{1}/ports".format(host, rackname))
        node_template = payload["customer_network"]["nodes"][0]

        nodes=[]
        node_set = set()
	
        num = 1
        for port in rackports["ports"]:
            node_id = port["hw_node_id"]
            if node_id in node_set: 
                continue
            node_set.add(node_id)
            current_node = json.loads( json.dumps( node_template) ) #deep copy
            dom0 = port["dom0_oracle_name"]
            domU = port["domu_oracle_name"]

            current_node["vip"]["hostname"] = domU + "-vip"            

            current_node["client"]["dom0_oracle_name"] = dom0
            current_node["client"]["domu_oracle_name"] = domU
            current_node["client"]["hostname"] = domU + "-client" + str(num)

            current_node["backup"]["dom0_oracle_name"] = dom0
            current_node["backup"]["domu_oracle_name"] = domU
            current_node["backup"]["hostname"] = domU + "-backup"

            if "admin" in node_template and node_template["admin"] is not None:
                current_node["admin"]["dom0_oracle_name"] = dom0
                current_node["admin"]["domu_oracle_name"] = domU
                current_node["admin"]["hostname"] = domU

            num = num + 1
            nodes.append(current_node)

        payload["customer_network"]["nodes"] = nodes
        return payload
     
    def create_updateNetMetadata_payload(self, rackname, payload, add_cluster_payload, host):
        node_template = payload["vnics"][0]

        nodes=[]
        node_set = set()

        num = 1
        add_cluster_payload = self.create_addcluster_payload(rackname, add_cluster_payload, host)

        for node_cluster in add_cluster_payload["customer_network"]["nodes"]:
            node_id = node_cluster["client"]["hostname"]
            if node_id in node_set:
                continue

            node_set.add(node_id)
            current_node = json.loads( json.dumps( node_template) ) #deep copy
            domU = node_cluster["client"]["domu_oracle_name"]
            current_node["macaddress"] = self.generate_random_mac()
            current_node["vip_hostname"] = domU + "-vip"
            current_node["vnic_hostname"] = domU
            current_node["scan_hostname"] = domU + "-scan" + str(num)
            current_node["vmname"] = node_cluster["backup"]["hostname"]
            num = num + 1
            nodes.append(current_node)
        payload["vnics"] = nodes
        return payload

    def generate_random_mac(self):
        return "%02x:%02x:%02x:%02x:%02x:%02x" % (
            secrets.SystemRandom().randint(0, 255),
            secrets.SystemRandom().randint(0, 255),
            secrets.SystemRandom().randint(0, 255),
            secrets.SystemRandom().randint(0, 255),
            secrets.SystemRandom().randint(0, 255),
            secrets.SystemRandom().randint(0, 255)
        )    

    def create_json_reshape(self,ecli,host,exaunitId,operation,resource,quantity):
        result = {}
        listNewServers = []
        cores = self.HTTP.get("{0}/exaunit/{1}/cores".format(host, exaunitId))
        if cores:
            for ocpu in cores['ocpuAllocations']:
                newServer = {}
                newServer[resource]   = quantity
                newServer["hostName"] = ocpu["hostName"]
                listNewServers.append(newServer)
        else:
            result["ERROR"] = ""
        result["operation"]          = operation
        result["clusterAllocations"] = listNewServers
        return json.dumps(result)
 
    def do_reshape_cluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'reshapecluster', params)
        except Exception as e:
            cl.perr(str(e))
            return
        strCores   = "cores"
        strMemory  = "memoryGb"
        strOhSize  = "ohomeSizeGb"
        strStorage = "storageTb"
        strFilesystems = "filesystem"

        cores   = params.get(strCores) is not None 
        memory  = params.get(strMemory) is not None
        ohsize  = params.get(strOhSize) is not None
        storage = params.get(strStorage) is not None
        filesystems = params.get(strFilesystems) is not None

        isValid = cores  ^ memory ^  ohsize ^ storage ^ filesystems

        if not isValid:
            cl.perr("You have to provide at least one resource and not more than one. Available [cores|memoryGb|ohomeSizeGb|storageTb|filesystem] ")
            return

        if params.get(strCores):
            resource = strCores
        elif params.get(strMemory):
            resource = strMemory
        elif params.get(strOhSize):
            resource = strOhSize
        elif params.get(strStorage):
            resource = strStorage
        elif params.get(strFilesystems):
            resource = strFilesystems

        if params.get(strStorage):
            quantity  = float(params.get(resource))
        elif params.get(strFilesystems):
            quantity = [{"mountpoint": mountpoint[0], "sizegb": mountpoint[1]} for mountpoint in [ element.split(':') for element in params.get(resource).split(',') ]]
        else:
            quantity  = int(params.get(resource))

        operation = "updateAllocation"
        exaunitId = params["exaunitId"]

        payload = {}
        if "diskgroupsallocation" in params:
            payload["diskgroupsAllocation"] = self.get_allocations_array(params["diskgroupsallocation"])
        if "createsparse" in params:
            payload["createsparse"] = params["createsparse"]
        if "backupdisk" in params:
            payload["backup_disk"] = params["backupdisk"]
   
        if resource == strStorage:
            payload["operation"] = operation
            payload[resource]    = quantity
        else:
            payload = json.loads(self.create_json_reshape(ecli,host,exaunitId,operation,resource,quantity))

        if payload.get("ERROR"):
            cl.perr("Unable to fetch current cores information from ecra. Reshape cluster operation failed")
            return
    
        if "idemtoken" not in payload:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            payload["idemtoken"] = idemtoken

        ceiocid = params["exadataInfrastructureId"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exadatainfrastructure/{1}/exaunit/{2}".format(host, ceiocid, exaunitId), data, "exadatainfrastructure")
        if response:
            cl.prt("n", json.dumps(response))

    def do_reshape_cluster_precheck(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'reshapecluster', params)
        except Exception as e:
            cl.perr(str(e))
            return
        strCores = "cores"
        strMemory = "memoryGb"
        strOhSize = "ohomeSizeGb"
        strStorage = "storageTb"

        cores = params.get(strCores) is not None
        memory = params.get(strMemory) is not None
        ohsize = params.get(strOhSize) is not None
        storage = params.get(strStorage) is not None

        isValid = cores ^ memory ^ ohsize ^ storage

        if not isValid:
            cl.perr(
                "You have to provide at least one resource and not more than one. Available [cores|memoryGb|ohomeSizeGb|storageTb] ")
            return

        if params.get(strCores):
            resource = strCores
        elif params.get(strMemory):
            resource = strMemory
        elif params.get(strOhSize):
            resource = strOhSize
        elif params.get(strStorage):
            resource = strStorage

        if params.get(strStorage):
            quantity = float(params.get(resource))
        else:
            quantity = int(params.get(resource))
        operation = "updateAllocation"
        exaunitId = params["exaunitId"]

        payload = {}

        if resource == strStorage:
            payload["operation"] = operation
            payload[resource] = quantity
        else:
            payload = json.loads(self.create_json_reshape(ecli, host, exaunitId, operation, resource, quantity))

        if payload.get("ERROR"):
            cl.perr("Unable to fetch current cores information from ecra. Reshape cluster Precheck  operation failed")
            return

        if "idemtoken" not in payload:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            payload["idemtoken"] = idemtoken

        ceiocid = params["exadataInfrastructureId"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data , "exadatainfrastructure",
            "{0}/exadatainfrastructure/{1}/exaunit/{2}/precheck".format(host, ceiocid, exaunitId))

        if response:
            cl.prt("n", json.dumps(response))

    def do_restore_cluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'restorecluster', params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = {}
        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        payload["idemtoken"] = idemtoken
        payload["operation"] = "restoreAllocation"
        payload["requestId"] = params["requestId"]
        data = json.dumps(payload, sort_keys=True, indent=4)
        ceiocid   = params["exadataInfrastructureId"]
        exaunitId = params["exaunitId"]
        response = self.HTTP.put("{0}/exadatainfrastructure/{1}/exaunit/{2}".format(host, ceiocid, exaunitId), data, "exadatainfrastructure")
        if response:
            cl.prt("n", json.dumps(response))

    def do_check_data_integrity(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'check_data_integrity', params)
        except Exception as e:
            cl.perr(str(e))
            return
        response = ecli.issue_get_request("{0}/exadatainfrastructure/{1}/checkdataintegrity".format(host,params.get("exadataInfrastructureId")), False)
        if response and "onlyvalidations" not in params:
            line2 = line + " filter=allocations"
            ecli.do_get_exadatainfrastructure(line2)
            line2 = line + " filter=computes"
            ecli.do_get_exadatainfrastructure(line2)
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
    
    def do_attach_storage(self, ecli, line, host):
        params = ecli.parse_params(line, None,optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'attach_storage', params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        queryParams=""

        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        if "asmpowerlimit" in params:
            queryParams += "&asmpowerlimit=" + params["asmpowerlimit"]

        if "vmclusterocid" in params:
            payload["vmclusterocid"] = params["vmclusterocid"]
        
        if "skipresize" in params:
            payload["skipresize"] = params["skipresize"]

        payload["idemtoken"] = idemtoken
        ceiocid = params["exadataInfrastructureId"]
        url = "{0}/exadatainfrastructure/{1}/storage".format(host, ceiocid)
        data = json.dumps(payload, sort_keys=True, indent=4)

        if len(queryParams)>0:
            url += "?" + queryParams[1:]

        response = self.HTTP.post(data, "exadatainfrastructure", url)
        if response:
            cl.prt("n", json.dumps(response))

    def do_attach_storage_exascale(self, ecli, line, host):
        params = ecli.parse_params(line, None,optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'attach_storage_exascale', params)
        except Exception as e:
            cl.perr(str(e))
            return

        headers = {}
        headers["idemtoken"] = ecli.getNewIdemtoken()        

        if headers["idemtoken"] is None:
            cl.perr("Could not get idemtoken")
            return

        ceiocid = params["exadataInfrastructureId"]
        url = "{0}/exadatainfrastructure/{1}/storage/exascale".format(host, ceiocid)

        response = self.HTTP.post(data=None, resource="exadatainfrastructure", uri=url, header=headers)
        if response:
            cl.prt("n", json.dumps(response))

    def do_delete_storage(self, ecli, line, host):
        params = ecli.parse_params(line, None,optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'delete_storage', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/exadatainfrastructure/{1}/storage"
        ceiocid = params["exadataInfrastructureId"]
        queryParams=""

        if "idemtoken" in params:
            queryParams += "&idemtoken=" + params["exaOcid"]
        else:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            else:
                queryParams += "&idemtoken=" + idemtoken
        if "servers" in params:
            queryParams += "&servers=" + params["servers"]
        if "releaseservers" in params:
            queryParams += "&releaseservers=" + params["releaseservers"]
        if "asmpowerlimit" in params:
            queryParams += "&asmpowerlimit=" + params["asmpowerlimit"]

        if len(queryParams)>0:
            url += "?" + queryParams[1:]

        response = self.HTTP.delete(url.format(host, ceiocid))
        if response:
            cl.prt("n", json.dumps(response))

    def do_migrate_to_mvm(self, ecli, line, host):
        params = ecli.parse_params(line, None,optional_key="exadataInfrastructureId")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'migrate_to_mvm', params)
        except Exception as e:
            cl.perr(str(e))
            return

        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return

        params["idemtoken"] = idemtoken
        ceiocid = params.pop("exadataInfrastructureId")
        url = "{0}/exadatainfrastructure/{1}/migratetomultivm".format(host, ceiocid)
        data = json.dumps(params, sort_keys=True, indent=4)

        response = self.HTTP.post(data, "exadatainfrastructure", url)
        if response:
            cl.prt("n", json.dumps(response))

    def do_info(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        response = ecli.issue_get_request("{0}/exadatainfrastructure?detailed=true".format(host), False)
        infraResponse = response
        headers = ["<infrastructure>","<rackname>","<state>","<clusters>","<model>"]
        maxLength = [
            len(headers[0]),
            len(headers[1]),
            len(headers[2]),
            len(headers[3]),
            len(headers[4])
            ]
        for infra in response["infras"]:
            if len(infra['ceiocid']) > maxLength[0]:
                maxLength[0]=len(infra['ceiocid'])
            if len(infra['rackname']) > maxLength[1]:
                maxLength[1]=len(infra['rackname'])
            if (infra.get('fsm_state') is not None):
                maxLength[2] = max(len(infra["fsm_state"]),maxLength[2])
            maxLength[4] = max(len(infra.get("model","--")),maxLength[4])
            
        cl.prt("b", " {0} : {1} : {2} : {3} : {4}".format(headers[0].ljust(maxLength[0]),
                                                     headers[1].ljust(maxLength[1]),
                                                     headers[2].ljust(maxLength[2]),
                                                     headers[3].ljust(maxLength[3]),
                                                     headers[4].ljust(maxLength[4])))
        for infra in response["infras"]:
            ceiocid = infra["ceiocid"]
            rackname = infra["rackname"]
            model = infra.get("model", "--")
            if (infra.get('fsm_state') is None):
                state = " "
            else:
                state = infra["fsm_state"]
            clusters = str(infra["clusters"])
            cl.prt("c", " {0} : {1} : {2} : {3} : {4} ".format(ceiocid.ljust(maxLength[0]), 
                                                         rackname.ljust(maxLength[1]),
                                                         state.ljust(maxLength[2]),
                                                         clusters.ljust(maxLength[3]),                                                         
                                                         model.ljust(maxLength[4])))

    def do_computevms(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exadatainfrastructure', 'computevms' , params)
        except Exception as e:
            return cl.perr(str(e))
        oracleHostname = params.get("oraclehostname")
        url = "{0}/exacompute/{1}/vms".format(self.HTTP.host, oracleHostname)
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_drop(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exadatainfrastructure', 'drop', params)
        except Exception as e:
            return cl.perr(str(e))
        ecraenv_response = ecli.issue_get_request("{0}/properties/ECRA_ENV".format(host), False)
        ecraenv_value = ecraenv_response.get("property_value")
        is_prod = ecraenv_value == "prod" if ecraenv_value else False
        proceed = True
        if is_prod:
            cl.prt("n", "CAUTION: The ECRA_ENV property value is currently \"prod\". Do you wish to proceed? (y/n):")
            user_input = input()
            if user_input != "y":
                proceed = False
            cl.prt("n", "CAUTION: Please confirm that you want to drop the following infrastructure:"+ params.get("exadataInfrastructureId") +" Do you wish to proceed? (y/n):")
            user_input2 = input()
            if user_input2 != "y":
                proceed = False
        if proceed:
            rackname = params.get("rackname")
            exadataid = params.get("exadataInfrastructureId")
            url = "{0}/exadatainfrastructure/{1}/drop/{2}".format(self.HTTP.host, rackname, exadataid)
            response = self.HTTP.delete(url)
            if response:
                cl.prt("n", json.dumps(response))
        
    def do_getinitialpayload(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="ceiocid")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'getinitialpayload', params)
        except Exception as e:
            cl.perr(str(e))
            return

        israckname = params.get("rackname") is not None
        isceiocid = params.get("ceiocid") is not None
        paramcount = (1 if israckname else 0) + (1 if isceiocid else 0)
        if paramcount != 1:
            cl.perr("You have to provide exactly one param rackname or ceiocid.")
            return
        ceiocid = ""
        if israckname:
            ceiocid = params.get("rackname")
        else:
            ceiocid = params.get("ceiocid")
    
        response = ecli.issue_get_request("{0}/exadatainfrastructure/{1}/initialpayload".format(host, ceiocid), False)

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("n", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_run_recoverclunodes_sop(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'recoverclunodes', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonpayload"]
        if not os.path.isfile(input_json_path):
            cl.perr("Node Recovery SOP input JSON: " + input_json_path + " does not exist.")
            return

        # Read input JSON
        with open(input_json_path, 'r') as input_json_file:
            payload = json.load(input_json_file)
            input_json_file.close()

        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to initiate recover nodes SOP flow
        exadataInfrastructureId = params["exadataInfrastructureId"]
        url = "{0}/exadatainfrastructure/{1}/recoverclunodes".format(host, exadataInfrastructureId)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c", "Submitting node recovery SOP for : " + exadataInfrastructureId + " with details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")

        ecli.waitForCompletion(response, "exadatainfrastructure")

    def do_run_dropclunodes_sop(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'dropclunodes', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonpayload"]
        if not os.path.isfile(input_json_path):
            cl.perr("Node Recovery SOP input JSON: " + input_json_path + " does not exist.")
            return

        # Read input JSON
        with open(input_json_path, 'r') as input_json_file:
            payload = json.load(input_json_file)
            input_json_file.close()

        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to initiate recover nodes SOP flow
        exadataInfrastructureId = params["exadataInfrastructureId"]
        url = "{0}/exadatainfrastructure/{1}/dropclunodes".format(host, exadataInfrastructureId)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c", "Submitting drop nodes SOP for : " + exadataInfrastructureId + " with details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")

        ecli.waitForCompletion(response, "exadatainfrastructure")

    def _get_new_ecra_idemtoken(self):
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token from ECRA")
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        return retObj["idemtoken"]

    def do_secureerase(self, ecli, line, host, interactive):
            params = ecli.parse_params(line, None)
            skip_validations = params.pop("skipvalidations") if "skipvalidations" in params else False
            # Validate the parameters
            try:
                ecli.validate_parameters('exadatainfrastructure', 'secureerase', params)
            except Exception as e:
                cl.perr(str(e))
                return

            ceiocid = params["exadataInfrastructureId"]
            json_str = json.dumps(self.HTTP.get("{0}/properties/{1}".format(self.HTTP.host, "ECRA_MODE")))
            ecraMode = json.loads(json_str)

            if (ecraMode["property_value"] == "prod"):
                if not self.do_confirm_delete_infra(ecli, ceiocid):
                    cl.prt("r", "Cannot perform delete operation")
                    return

            if interactive:
                cl.prt("c", "Executing secure erase on: {0}".format(ceiocid))


            params["skipValidations"] = skip_validations
            data = json.dumps(params, sort_keys=True, indent=4)
            response = self.HTTP.post(data, "exadatainfrastructure", "{0}/exadatainfrastructure/{1}/secureerase".format(host, ceiocid))

            if response:
                cl.prt("n", json.dumps(response))

    def do_getsecureerasecert(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'getsecureerasecert', params)
        except Exception as e:
            cl.perr(str(e))
            return

        ceiocid = params["exadataInfrastructureId"]

        my    = path.abspath(__file__)
        mydir = path.dirname(my)
        if "path" in params:
            params["filepath"] = mydir if "path" not in params else params["path"]
            cl.prt("n", "Using path: " + params["filepath"])
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items() if value != None]) if params else ""
        response = self.HTTP.get("{0}/exadatainfrastructure/{1}/secureerase{2}".format(host, ceiocid, query))
        if response:
            cl.prt("n", json.dumps(response))



    def do_confirm_delete_infra(self, ecli, ceiocid):
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

        summary_info = ecli.issue_get_request("{0}/exadatainfrastructure/{1}".format(self.HTTP.host, ceiocid),False)

        if summary_info:
            if "error_str" in summary_info:
                cl.prt("r", summary_info["error_str"])
                return False
            else:
                is_mvm = summary_info["multiVM"] if "multiVM" in summary_info else False
                rack_names = []
                if is_mvm:
                    if len(summary_info["rackSlots"]) > 0:
                        rack_names = summary_info["rackSlots"]
                    else:
                        rack_names = [summary_info["rackname"]]
                else:
                    rack_names = [summary_info["rackname"]]

                has_racks_provisioned = False
                try:
                    cl.prt("c", "Checking rack status: " + str(rack_names))
                    for name in rack_names:
                        query = "{0}/racks?name={1}".format(self.HTTP.host, name)
                        cl.prt("c", query)
                        rack_info = self.HTTP.get(query)
                        if rack_info and rack_info["status"] == 200:
                            if rack_info["racks"][0]["status"] == "PROVISIONED":
                                cl.prt("c", "Rack is provisioned: " + name)
                                has_racks_provisioned = True
                                break
                        else:
                            cl.prt("c", "Unable to load rack: " + name)
                except Exception as e:
                    cl.prt("c", "unable to check racks: " + str(e))
                    pass

                cl.prt("c","{0:15} : {1:8}".format("Rackname", summary_info["rackname"]))
                cl.prt("c","{0:15} : {1:8}".format("Provisioned racks", has_racks_provisioned))
                cl.prt("c","{0:15} : {1:8}".format("CEIOCID", summary_info["exadataInfrastructureId"]))

                if (has_racks_provisioned):
                    ask_confirmation = input("Infra has racks in PROVISIONED state, confirm to proceed anyways: (yes|no)")
                    if ask_confirmation != "yes":
                        cl.prt("c", "Operation not confirmed, aborting")
                        return False

                first_confirmation = input("Do you have L1/L2 approvals to execute erase operation in this Infra : '"+ceiocid+"'?(yes|no):")
                if first_confirmation != "yes":
                    cl.prt("c", "Operation not confirmed, aborting")
                    return False

                cl.prt("r","Are you sure you want to delete the infra with id: " + ceiocid +"? All data will be lost. This action cannot be undone")
                second_confirmation = input("Type rackname associated with the ceiocid in order to proceed with the delete command, if not just hit enter to quit:")

                if second_confirmation != summary_info["rackname"]:
                    cl.prt("c", "Invalid rackname provided, aborting the request")
                    return False

                third_confirmation = input("Type the Infrastructure Id (CEIOCID) in order to proceed with the secure erase command, if not just hit enter to quit:")

                if third_confirmation != summary_info["exadataInfrastructureId"]:
                    cl.prt("c", "Invalid exadata Infrastructure Id provided, aborting the request")
                    return False
                return True
        else:
            return False

    def do_update_vm_state(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        required_params = {"exaocid", "state", "servicetype"}
        servicetypelist = ['exacs', 'exacc']
        result = required_params & set(params)
        if len(result) > 2 and params.get('servicetype').lower().strip() in servicetypelist:
            if params.get('servicetype').lower().strip() == 'exacc':
                url = "{0}/exadata/{exaOcid}/update/vmstate/{vmState}"
            else:
                url = "{0}/exadatainfrastructure/{exaOcid}/update/vmstate/{vmState}"
            if "json_file" in params:
                jsonfile = params.get("json_file")
                with open(jsonfile, 'r') as fh:
                    data = fh.read().replace('\n', '')
                data = json.loads(data)
                if "vms" in data and len(data.get("vms")) > 0 and isinstance(data.get("vms"), list):
                    vm_list = {"vms": data.get("vms")}
                    response = ecli.HTTP.put(
                        url.format(host, exaOcid=params.get("exaocid"), vmState=params.get("state")),
                        data=json.dumps(vm_list), resource="exadata")
                    if response:
                        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
                else:
                    cl.perr("[update_vm_state]: Json file does not contains list of vms or type is not list")
            else:
                response = ecli.HTTP.put(url.format(host, exaOcid=params.get("exaocid"), vmState=params.get("state")),
                                         data=None, resource="exadata")
                if response:
                    cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
        else:
            cl.perr(
                "[update_vm_state]: Required parameter are not present in request, Available fields for query are: {0}".format(
                    required_params))

    def do_disablebackup(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'disablebackup', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/exadatainfrastructure/{1}/disablebackup"
        ceiocid = params["exadataInfrastructureId"]
        queryParams = "&increasefactor=" + params["increasefactor"]

        if len(queryParams) > 0:
            url += "?" + queryParams[1:]

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(url.format(host, ceiocid), data,"exadatainfrastructure")
        if response:
            cl.prt("n", json.dumps(response))

    def do_getkeys(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="ceiocid")
        # Validate the parameters
        try:
            ecli.validate_parameters('exadatainfrastructure', 'getkeys', params)
        except Exception as e:
            cl.perr(str(e))
            return
        ceiocid = params.get("ceiocid")

        if "idemtoken" not in params:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            params["idemtoken"] = idemtoken

        data = json.dumps(params, sort_keys=True, indent=4)

        response = self.HTTP.post(data, "exadatainfrastructure", "{0}/exadatainfrastructure/{1}/keys".format(host, ceiocid))

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("n", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def get_allocations_array(self, allocations):
        allocationsArray = []
        # DGS are in the form D:R:S
        dgNames = ["DATA", "RECO", "SPARSE"]
        dgs = allocations.split(":")
        for i in range(len(dgs)):
            dgObject = {}
            dgObject["diskgroup"] = dgNames[i]
            dgObject["percentage"] = float(dgs[i])
            allocationsArray.append(dgObject)
        return allocationsArray
#eof
