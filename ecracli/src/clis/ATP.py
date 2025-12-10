"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    ATP - CLIs to operate on Autonomous Transaction Processing (ATP)

FUNCTION:
    Provides the clis to get and create ATP networks

NOTE:
    None

History:
    kanmanic    21/08/25 - Added getAdminIdentity
    ddelgadi    11/14/22 - ENH 34579733 - add rackname and dev for 
                           updateNetMetadata
    piyushsi    05/19/21 - ENH 32888345 - LOCK MGMT SUBNET CIDR FOR AVM
                           CREATION
    illamas     03/12/21 - Enh 32479332 - Cloud Exadata Infrastrucure creation
    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
    rgmurali    06/06/20 - ER 31446572 Use OCI realms
    aabharti    03/18/20 - ER 31000123 - API to seed admin tenancy details
    rgmurali    12/02/19 - ER 30582157 Maintain OCI URL mappings
    rgmurali    10/07/19 - ER 30383122 - Add ATP bootstrap API
    rgmurali    10/02/19 - ER 29845757 - Add observer delete support
    rgmurali    08/02/19 - Bug 30135591 - Get the observer SSH keys
    rgmurali    04/08/10 - Bug 29617694 - Fix output of atp deleteNetwork
    sachikuk    01/24/19 - Bug - 29196199 : REST APIs for ATP pre provisioning
                           scheduler    
    rgmurali    01/23/19 - ER 29121810 - Observer LCM operartions
    piyushsi    12/20/18 - ENH 28943345 - ECRA API SKELETON - GIServiceStop
    rgmurali    12/12/18 - Bug 29050191 - Get observer instance details endpoint
    diegchav    10/30/18 - ER 28902241 - Add method to get network details
    rgmurali    07/18/18 - Bug 28368747 - deleteAtpNetwork REST API
    rgmurali    07/09/18 - Bug 28313998 - getAtpPartnerSubnet API
    rgmurali    06/27/18 - Bug: 28216034 - Register VNIC changes
    rgmurali    06/19/18 - Bug 28181495 Subnet sizing for ATP
    rgmurali    05/17/18 - Create file
"""

from formatter import cl
from os import path
import http.client
import json
import os
from clis.ExadataInfra import ExadataInfra

class ATP:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        self.PREPROV_SCHEDULER_START_PAYLOAD = 'atp_preprov_scheduler.json'

    def do_getDetails_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate parameters
        try:
            ecli.validate_parameters("atp", "getDetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        dbSystemId = params.pop("dbSystemId")

        response = ecli.issue_get_request("{0}/atp/details/{1}".format(host, dbSystemId))

    def do_getNetwork_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "getNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        dbSystemId = params.pop("dbSystemId")

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/atp/networks/mgmt/{1}{2}".format(host, dbSystemId, query))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_getVnicDetails_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "getVnicDetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        dbSystemId = params.pop("dbSystemId")

        response = ecli.issue_get_request("{0}/atp/networks/mgmt/registervnic/{1}".format(host, dbSystemId))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_registerVnic_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "registerVnic", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/networks/mgmt/registervnic".format(host))
        if response:
            cl.prt("n", json.dumps(response))
       
    def do_createOciUrlMap_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "createOciUrlMap", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/networks/mgmt/ociurlmap".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_getOciUrlMap_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "getOciUrlMap", params)
        except Exception as e:
            cl.perr(str(e))
            return

        realm = params.pop("realm")

        response = ecli.issue_get_request("{0}/atp/networks/mgmt/ociurlmap/{1}".format(host, realm), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getOciUrlMapAll_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "getOciUrlMapAll", params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = ecli.issue_get_request("{0}/atp/networks/mgmt/ociurlmap".format(host), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_bootstrap_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "bootstrap", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/networks/mgmt/bootstrap".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_registerVcnDetails_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "registerVcnDetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/terraform/vcn/register".format(host))
        if response:
            cl.prt("n", json.dumps(response))


    def do_registerAuth_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "registerAuth", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/authentication/register".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_registerAdminIdentity_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "registerAdminIdentity", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/adminidentity/register".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_getAdminIdentity_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        response = ecli.issue_get_request("{0}/atp/adminidentity".format(host))
        if response is None:
            cl.prt("n", "No Admin Identity details available")

    def do_createNetwork_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "createNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackName = params.pop("rackname")

        query_str = "?rackname=" + rackName
        data = json.dumps(params, sort_keys=True, indent=4)
        return self.HTTP.post(data, "atp", "{0}/atp/networks/mgmt{1}".format(host, query_str))

    def do_deleteNetwork_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "deleteNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        dbSystemId = params.pop("dbSystemId")
        optimizedDelete = "false"
        if "optimizedDelete" in params:
            optimizedDelete = params.pop("optimizedDelete")

        if(ecli.is_required_validation()):
            if(ecli.stop_delete(dbSystemId,"DbSystemOCID")):
                cl.prt("r", "Skipped deleteNetwork command")
                return

        query_str = "?optimizedDelete=" + optimizedDelete
        return self.HTTP.delete("{0}/atp/networks/mgmt/{1}{2}".format(host, dbSystemId, query_str))

    def do_registerSubnet_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "registerSubnet", params)
        except Exception as e:
            cl.perr(str(e))
            return

        jsonData = {}
        jsonData["vcnCIDR"] = params.pop("vcnCIDR")

        # Put adName in json payload in case it was passed.
        if "adName" in params:
            jsonData["adName"] = params.pop("adName")

        data = json.dumps(jsonData, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/subnet/register".format(host))
        if response:
            cl.prt("n", json.dumps(response))


    def do_getPartnerSubnet_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "getPartnerSubnet", params)
        except Exception as e:
            cl.perr(str(e))
            return

        subnetOcid = params.pop("subnetOcid")

        response = ecli.issue_get_request("{0}/atp/partnersubnet/{1}".format(host, subnetOcid))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_setupDGNetwork_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "setupDGNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        targetType = params.pop("targetType")

        slaAvailabilityType = params.pop("slaAvailabilityType")

        params = json.load(open(params["json_path"]))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/dataguard/setup/{1}/{2}".format(host, targetType, slaAvailabilityType))
        if response:
            cl.prt("n", json.dumps(response))


    def do_deleteDGNetworkRules_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "deleteDGNetworkRules", params)
        except Exception as e:
            cl.perr(str(e))
            return

        targetType = params.pop("targetType")

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/atp/dataguard/setup/{1}".format(host, targetType), data)
        if response:
            cl.prt("n", json.dumps(response))

    def add_property(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "addProperty", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/properties".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def get_property(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "getProperty", params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.query("{0}/atp/properties".format(host), params)
        if response:
            cl.prt("n", json.dumps(response))

    def delete_property(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "deleteProperty", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/atp/properties".format(host), data)
        if response:
            cl.prt("n", json.dumps(response))

    def updateNetMetadata(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "updateNetMetadata", params)
        except Exception as e:
            cl.perr(str(e))
            return

        
        jsonPayload = json.load(open(params["json_path"]))

        if "rackname" in params:
            jsonPayload["rackname"] = params["rackname"]

        rack_name=jsonPayload["rackname"]
        if 'dev' in params:
            if 'addCluster_json_path' in params:
                add_cluster_payload = json.load(open(params["addCluster_json_path"]))
                exadatainfraObj = ExadataInfra(self.HTTP)
                jsonPayload = exadatainfraObj.create_updateNetMetadata_payload(rack_name, jsonPayload, add_cluster_payload, self.HTTP.host)
            else:
                cl.perr("if used a dev parameter is necessary the json path of add cluster payload")
                return


        data = json.dumps(jsonPayload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/metadata/register".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def createOracleClientSubnet(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "createOracleClientSubnet", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/client/orclclient".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_launchObserver_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "launchObserver", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        return self.HTTP.post(data, "atp", "{0}/atp/compute/observer/launch".format(host))

    def do_terminateObserver_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "terminateObserver", params)
        except Exception as e:
            cl.perr(str(e))
            return

        custTenantId = params.pop("custTenantId")

        if (ecli.is_required_validation()):
            if (ecli.stop_delete(custTenantId,"CustomerOCID")):
                cl.prt("r", "Skipped terminateObserver command")
                return
        return self.HTTP.delete("{0}/atp/compute/observer/terminate/{1}".format(host, custTenantId))

    def do_deleteObserver_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "deleteObserver", params)
        except Exception as e:
            cl.perr(str(e))
            return

        custTenantId = params.pop("custTenantId")
        dbSystemId = params.pop("dbSystemId")

        if (ecli.is_required_validation()):
            if (ecli.stop_delete(dbSystemId,"DbSystemOCID")):
                cl.prt("r", "Skipped deleteObserver command")
                return
        return self.HTTP.delete("{0}/atp/compute/observer/launch/{1}/{2}".format(host, custTenantId, dbSystemId))

    # Perform observer start/stop/restart operations
    def observer_operation(self, ecli, action, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "observerOperation", params)
        except Exception as e:
            cl.perr(str(e))
            return

        custTenantId = params.pop("custTenantId")
        observerJson = {"action" : action}
        data = json.dumps(observerJson, sort_keys=True, indent=4)
        return self.HTTP.post(data, "atp", "{0}/atp/compute/observer/lifecycle/{1}".format(host, custTenantId))

    def do_getObserverDetails_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "getObserverDetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        dbSystemId = params.pop("dbSystemId")

        response = ecli.issue_get_request("{0}/atp/compute/observer/launch/{1}".format(host, dbSystemId))

        if not response:
            cl.prt("n", json.dumps(response))

    def do_fetchObserverKeys_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "fetchObserverKeys", params)
        except Exception as e:
            cl.perr(str(e))
            return

        dbSystemId = params.pop("dbSystemId")

        response = ecli.issue_get_request("{0}/atp/compute/observer/fetchkeys/{1}".format(host, dbSystemId))

        if not response:
            cl.prt("n", json.dumps(response))

    def giServiceStop(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("atp", "giServiceStop", params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")

        response = self.HTTP.put("{0}/atp/giservice/stop/{1}".format(host, rackname), None, "atp")

        if response:
            cl.prt("n", json.dumps(response))

    def do_createPreprovDbSystem_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "createPreprovDbSystem", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/client/orcldbsystem".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_getPreprovScheduler_atp(self, ecli, line):
        params = ecli.parse_params(line, None)

        # Validate parameters
        try:
            ecli.validate_parameters("atp", "getPreprovScheduler", params)
        except Exception as e:
            cl.perr(str(e))
            return
  
        # Call ECRA to get pre provisioning scheduler's details 
        ecli.issue_get_request("{0}/atp/scheduler/preprov".format(self.HTTP.host))

    def do_listScheduledRacks_atp(self, ecli, line):
        params = ecli.parse_params(line, None)

        # Validate parameters
        try:
            ecli.validate_parameters("atp", "listScheduledRacks", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get list of racks scheduled for pre provisioning
        ecli.issue_get_request("{0}/atp/scheduler/preprov/scheduledracks".format(self.HTTP.host))

    def do_getScheduledRackPreprovJobs_atp(self, ecli, line):
        params = ecli.parse_params(line, None)

        # Validate parameters
        try:
            ecli.validate_parameters("atp", "getScheduledRackPreprovJobs", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get pre provisioning jobs for scheduled rack
        rack_name = params["rackname"]
        url = "{0}/atp/scheduler/preprov/scheduledracks/{1}"
        url = url.format(self.HTTP.host, rack_name)
        ecli.issue_get_request(url)

    def do_startPreprovScheduler_atp(self, ecli, line, mytmpldir):
        params = ecli.parse_params(line, None)

        # Validate parameters
        try:
            ecli.validate_parameters("atp", "startPreprovScheduler", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Initialize payload path
        payload_path = os.path.join(os.path.abspath(mytmpldir), self.PREPROV_SCHEDULER_START_PAYLOAD)
        if ("payload" in params):
             payload_path = params["payload"]

        # Payload path must exist
        if (not os.path.isfile(payload_path)):
            cl.perr("Preprov scheduler payload path: %s does not exist." % payload_path)
            return

        # Load payload
        with open(payload_path) as f:
            payload = json.load(f)

        if("mode" in payload):
            mode = payload["mode"]
            if mode.upper() not in ["PARALLEL", "SEQUENTIAL"]:
                cl.perr("Preprov scheduler incorrect value of mode: %s has passed. " %(mode) +
                         " Correct values are [PARALLEL, SEQUENTIAL] ")
                return
                

        # Call ECRA to start pre provisioning scheduler
        response = self.HTTP.post(json.dumps(payload), "atp", "{0}/atp/scheduler/preprov".format(self.HTTP.host))
        if (response):
            cl.prt("n", json.dumps(response)) 

    def do_shutdownPreprovScheduler_atp(self, ecli, line):
        params = ecli.parse_params(line, None)

        # Validate parameters
        try:
            ecli.validate_parameters("atp", "shutdownPreprovScheduler", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to stop pre provisioning scheduler
        response = self.HTTP.delete("{0}/atp/scheduler/preprov".format(self.HTTP.host))
        if (response):
            cl.prt("n", json.dumps(response))

    def do_reconfigService_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "reconfigService", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if len(params["rackname"]) == 0:
            cl.perr("No rack name provided")
            return

        if len(params["reconfig_payload"]) == 0:
            cl.perr("No reconfig payload provided")
            return

        payload = None
        with open(params["reconfig_payload"]) as file:
            payload = json.load(file)


        payload["rackname"] = params["rackname"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/orclreconfigservice".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_deletePreprovOracleClientVCN_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "deletePreprovOracleClientVCN", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if len(params["rackname"]) == 0:
            cl.perr("Invalid rack name provided")
            return

        rackname = params["rackname"]

        if(ecli.is_required_validation()):
            if(ecli.stop_delete(rackname,"RackName")):
                cl.prt("r", "Skipped deletePreprovOracleClientVCN command")
                return

        response = self.HTTP.delete("{0}/atp/client/orclclient/{1}".format(self.HTTP.host, rackname))
        if response:
            cl.prt("n", json.dumps(response))

    def do_deletePreprovOracleDbSystem_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "deletePreprovOracleDbSystem", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if len(params["rackname"]) == 0:
            cl.perr("Invalid rack name provided")
            return

        rackname = params["rackname"]

        if(ecli.is_required_validation()):
            if(ecli.stop_delete(rackname,"RackName")):
                cl.prt("r", "Skipped deletePreprovOracleDbSystem command")
                return

        response = self.HTTP.delete("{0}/atp/client/orcldbsystem/{1}".format(self.HTTP.host, rackname))
        if response:
            cl.prt("n", json.dumps(response))

    def do_ingestTerraformData_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if ('json_path' in params and 'oss_filename' in params):
            cl.perr(str('json_path and oss_filename cannot be used together'))
            return

        if ('json_path' not in params and 'oss_filename' not in params):
            cl.perr(str('json_path or oss_filename should be specified'))
            return

        try:
            ecli.validate_parameters("atp", "ingestTerraformData", params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        # Load json_path to sent it as part of body post request.
        if ('json_path' in params):
            params["terraformJson"] = json.load(open(params["json_path"]))
            params['file_path'] = params['json_path']
        else:
            params['file_path'] = params['oss_filename']

        data = json.dumps(params, sort_keys=True, indent=4)
        if ('json_path' in params):
            response = self.HTTP.post(data, "atp", "{0}/atp/terraform/ingest".format(host))
        else:
            response = self.HTTP.post(data, "atp", "{0}/atp/terraform/ingestOss".format(host))
        if response:
            status_code = int(response["status_code"]) if "status_code" in response else 200
            status_message = response["status_message"] if "status_message" in response else ""

            # Manage confirmation if requested by server.
            if status_code == http.client.CONFLICT:
                cl.prt("r", status_message)
                resp = input()
                while resp.lower() not in ["y", "n"]:
                    cl.prt("r", "Invalid input: '{0}'".format(resp))
                    cl.prt("r", status_message)
                    resp = input()

                params["confirmDeletion"] = resp
                data = json.dumps(params, sort_keys=True, indent=4)

                response = self.HTTP.post(data, "atp", "{0}/atp/terraform/ingest".format(host))
                if response:
                    cl.prt("n", json.dumps(response))
            else:
                cl.prt("n", json.dumps(response))

    def do_configRule_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        protocols = ["ssh", "udp", "tcp", "http", "icmp"]
        actions = ["add", "remove"]

        try:
            ecli.validate_parameters("atp", "configDom0Rule", params)
        except Exception as e:
            cl.perr(str(e))
            return
        if "protocol" in params and params["protocol"] not in protocols:
            cl.perr(params["protocol"] + " protocol is not supported. Use any of the following")
            cl.perr(str(protocols))
            return
        if params["action"] not in actions:
            cl.perr(params["action"] + " action is not supported. Use any of the following")
            cl.perr(str(actions))
            return
        try:
            port = params["port"] = int(params["port"])
            if port < 1 or port > 65532:
                raise ValueError
        except ValueError as _:
            cl.perr("port param should be an integer between 1 and 65532")
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/client/vcn/configrule".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_vmrollback_atp(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        response = self.HTTP.post("", "atp", "{0}/atp/orclreconfigservice/vmrollback/{1}".format(host, exaunit_id))

        if response:
            cl.prt("n", json.dumps(response))
    
    def do_config_domurules_atp(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
             ecli.validate_parameters('atp', 'configDomURules', params)
        except Exception as e:
            return cl.perr(str(e))
        cidrs = params["cidr"]
        cidrArray = cidrs.split(',')
        cidrsList = []   
        for elem in cidrArray:
            pair = {
                "cidr" : elem
            }
            cidrsList.append(pair)
        jsonPayload = {}
        jsonPayload.update({"rackname": params["rackname"]})
        jsonPayload.update({"routes": cidrsList})
        data = json.dumps(jsonPayload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/client/configdomurules".format(host))
        if response:
            cl.prt("n", json.dumps(response))
            
    def do_customertenancy_list(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('atp', 'listCustomerTenancy', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "dbsystem_id" in params:
            response = ecli.issue_get_request("{0}/atp/customertenancy/{1}".format(host,params["dbsystem_id"]), printResponse=False)
        else:
            response = ecli.issue_get_request("{0}/atp/customertenancy".format(host), printResponse=False)
        #print(response)
        if response is None:
            cl.perr("Cannot get customer tenancy information")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_customertenancy_put(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('atp', 'putCustomerTenancy', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/customertenancy".format(host))
        if response is None:
            cl.perr("Cannot add customer tenancy record information")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_customertenancy_del(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('atp', 'deleteCustomerTenancy', params)
        except Exception as e:
            cl.perr(str(e))
            return

        dbsystem_id = params["dbsystem_id"]
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/atp/customertenancy/{1}".format(host,dbsystem_id))
        if response is None:
            cl.perr("Cannot add customer tenancy record information")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_exadata_infrastructure_create(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('atp', 'createPreprovExadataInfrastructure', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/exadatainfra/create".format(host))
        if response is None:
            cl.perr("Cannot create an Exadata Infrastructure")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def createPreProvVMCluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("atp", "createPreProvVMCluster", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "atp", "{0}/atp/vmcluster/create".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def getPreprovMetrics(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('atp', 'getPreprovMetrics', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")
        response = ecli.issue_get_request("{0}/atp/preprov/getmetrics/{1}".format(host, rackname), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))


