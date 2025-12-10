 #!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Exacompute.py /main/67 2025/11/28 04:38:12 zpallare Exp $
#
# Exacompute.py
#
# Copyright (c) 2021, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Exacompute.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      Python class for ExaCompute operations
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    zpallare    11/26/25 - Enh 38684873 - EXACS - Review mvm subnet usage in
#                           provisioning flow
#    illamas     11/03/25 - Enh 38470291 - Guest release
#    zpallare    11/03/25 - Bug 38470320 - EXADBXS - Include /rack prefix in 3
#                           new endpoint to avoid collision.
#    illamas     10/30/25 - Enh 38470264 Guest reserve
#    zpallare    10/08/25 - Enh 38443483 - EXADBXS - Create new rack reserve
#                           api for exadbxs/basedb flows
#    gvalderr    09/26/25 - Enh 38469560 - Adding vmclusterocid details command
#                           for exacompute
#    gvalderr    09/01/25 - Enh 38359812 - Creating endpoint for returning
#                           client hostnames of a compute
#    jzandate    08/08/25 - Enh 37866326 - Adding validate volume endpoints
#    gvalderr    07/09/25 - Enh 38145989 - Adding volumes parameters for
#                           exacompute reshape
#    caborbon    07/08/25 - ENH 38140076 - Adding option to execute exacompute
#                           ports with caviumid or hwid
#    jzandate    06/17/25 - Enh 37710713 - add sanity check to fleetstate json
#    jzandate    05/05/25 - Enh 37903772 - Adding dbvolumes operations
#    rgmurali    04/28/25 - Bug 37873738 - Fix the computecleanup cli
#    illamas     03/03/25 - Enh 37630003 - Custom fs exacompute CS
#    jzandate    02/27/25 - Enh 37614605 - Compute cleanup
#    jzandate    11/26/24 - Enh 36979496 - Adding history backup in analytics
#                           table
#    illamas     10/30/24 - Enh 37224619 - Add/Delete fabric
#    kukrakes    10/28/24 - Enh 37195352 - ECRA CHANGES FOR EXACOMPUTE REQUEST
#                           CLEANUP FOR HARDWARE NODE FAILURE
#    dekuckre    10/07/24 - 36644925: Added precheck for exacompute
#    gvalderr    09/19/24 - Enh 37025370 -Adding extradetail parameter to
#                           ecracli exacompute listclusters
#    jzandate    09/13/24 - Enh 37025361 - Adding service detail cmd
#    illamas     08/09/24 - Enh 36893856 - Adding support to get exacompute
#                           template filtering with vmclusterocid
#    illamas     08/07/24 - Enh 36797845 - Deconfigure roce IPs
#    rgmurali    08/05/24 - Enh 36918660 - cli support for RoCE IP configure
#    illamas     07/22/24 - Enh 36793533 - Remove node from XML
#    illamas     07/01/24 - Enh 36793084 - Mount and unmount support for
#                           exacompute
#    rgmurali    05/13/24 - ER 36009525 - Endpoint to check if exascale pool is created
#    jreyesm     02/16/24 - bug 36301029. secure random using secrets
#    zpallare    02/02/24 - Enh 36228435 - EXADB-XS: ECRA: Implement new api to
#                           secure vms : /exacompute/clusters/securevms
#    zpallare    11/14/23 - Enh 35797702 - EXADB-XS: ECRA to enhance the
#                           listclusters api to include more information
#    gvalderr    10/24/23 - Enh 35939023 - Correcting delete vault access
#                           details endpoint to have no body
#    ybansod     10/23/23 - Enh 35678058 - Add ecracli command for Fleet
#                           HardwareNodes update async api
#    gvalderr    09/21/23 - Enh 35631676 - Adding get vault access details
#                           endpoint
#    gvalderr    09/01/23 - Enh 35751657 - Adding delete vault acces details endpoint
#    zpallare    08/07/23 - Enh 35587158 - List all nat ips from dom0
#    ybansod     07/25/23 - Enh 35475687 - Add ecracli commands for system
#                           vault CRUDL operations
#    ybansod     07/20/23 - Bug 35614729 - Fix ecracli command for
#                           precheckEdvVolumes API
#    anudatta    07/18/23 - Bug 35603095 - SPEC CHANGE FOR SCALE PRECHECK EXACOMPUTE 
#    anudatta    07/14/23 - ENH 35548767 - Precheck Reshape Exacompute
#    illamas     07/04/23 - Enh 35300907 - vm restore exacompute
#    gvalderr    06/26/23 - Modifying exacompute getvaultaccessdetails command
#    ybansod     06/17/23 - ENH 35454583 - ADD ECRA API FOR EDV
#                           VOLUMEMOUNTNAMES PRECHECK
#    illamas     05/19/23 - Bug 35410985 - Fixes for template
#    gvalderr    05/05/23 - Adding endpoints of exacompute for providing kvm
#                           host sshkey
#    illamas     05/15/23 - Enh 35268841 - Exacompute templates
#    illamas     05/13/23 - Enh 35268795 - Store nodeOcid and initiator
#    rgmurali    05/11/23 - ER 35384012 - Change stateid to string
#    kukrakes    04/12/23 - ENH 35276852 - ADD SANITY CHECK API FOR THE
#                           PROVISIONING OF A CLUSTER CONFIG IN ECRA
#    illamas     03/14/23 - Enh 35141899 - Add/delete compute exacompute
#    illamas     03/11/23 - Enh 35080777 - Exacompute scale
#    rgmurali    03/06/23 - ER 35080784 - Idempotency support for placement
#    illamas     01/10/23 - Enh 34901089 - List racks with oracle hostname
#    rgmurali    12/05/22 - ER 34696811 - Provide unlock API
#    illamas     11/28/22 - Enh 34581266 - Added reserved cores/memory
#    rmavilla    11/17/22 - EXACS-99613 ECRA - VM Move should be enhanced to
#                           support Patching
#    rgmurali    10/17/22 - ER 34325936 - MD support in ECRA
#    rmavilla    09/13/22 - EXACS-96336 ECRA - VM Move in
#                           Exacompute/ExascaleEXACS-96339 ECRA - VM Move
#                           Sanity Check in Exacompute/Exascale
#    illamas     08/30/22 - Enh 34411011 - Active cavium
#    illamas     01/28/22 - Enh 33509359 - Store and retrieve exacompute
#                           payload
#    rgmurali    12/15/21 - ER 33671567 - Minor updates
#    illamas     12/14/21 - Enh 33508854 - Delete cluster exacompute
#    illamas     12/09/21 - Enh 33508821 - Create Service exacompute
#    rgmurali    12/09/21 - ER 33509397 - Chaine state store support
#    illamas     11/22/21 - Enh 33509425 - Exascale - exacompute ports
#
from formatter import cl
import json
import secrets
import uuid
import re
import time

class Exacompute:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_hostname_ports(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'hostnameports', params)
        except Exception as e:
            return cl.perr(str(e))

        if "hostname" in params:
            input_value  = params["hostname"]
        elif "hwid" in params:
            input_value  = params["hwid"]
        elif "smartnicid" in params:
            input_value  = params["smartnicid"]
        else:
            return cl.perr(str("Please provide one of the 3 options to search: hostname, hwid, smartnicid"))

        url  = "{0}/exacompute/{1}/ports".format(host,input_value)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4)) 

    def do_exacompute_getfleetstatelock(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'getfleetstatelock', params)
        except Exception as e:
            return cl.perr(str(e))

        if ("stateid" in params):
            url = "{0}/chaine/fleetstatelock?state-id={1}".format(host, params["stateid"])
        else:
            url = "{0}/chaine/fleetstatelock".format(host)

        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_exacompute_getfleetstate(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'getfleetstate', params)
        except Exception as e:
            return cl.perr(str(e))

        fleetstatehandle = params["fleetstatehandle"]

        url = "{0}/chaine/fleetstate/{1}".format(host, fleetstatehandle)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_exacompute_getfleetstateid(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'getfleetstateid', params)
        except Exception as e:
            return cl.perr(str(e))

        url = "{0}/chaine/fleetStateIds".format(host)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))
    
    def do_exacompute_getlatestfleet(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'getlatestfleet', params)
        except Exception as e:
            return cl.perr(str(e))

        url = "{0}/chaine/fleetstate/latest".format(host)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_exacompute_updatefleetstate(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        fleetstatehandle = params["fleetstatehandle"]

        if "json_path" in params:
            params = json.load(open(params["json_path"]))
        
        params["fleetstatehandle"] = fleetstatehandle

        try:
            ecli.validate_parameters('exacompute', 'updatefleetstate', params)
        except Exception as e:
            return cl.perr(str(e))

        stateid = "0"
        if ("stateid" in params):
            stateid = params["stateid"]
        params["state-id"] = stateid
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/chaine/fleetstate/{1}".format(host, fleetstatehandle), data, "exacompute")

        if response:
            cl.prt("n", json.dumps(response))
    
    def do_exacompute_fleetstateunlock(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        fleetstatehandle = params.pop("fleetstatehandle")
        fleetlockhandle = params.pop("fleetlockhandle")

        params["fleetStateHandle"] = fleetstatehandle
        params["fleetLockHandle"] = fleetlockhandle

        try:
            ecli.validate_parameters('exacompute', 'fleetstateunlock', params)
        except Exception as e:
            return cl.perr(str(e))
        
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/chaine/fleetstateunlock".format(host), data, "exacompute")

        if response:
            cl.prt("n", json.dumps(response))

    def modify_payload_add_cluster(self,payload,nodes):
        system_random = secrets.SystemRandom()
        nodes_payload = payload["customer_network"]["nodes"]
        dom0 = nodes.split(",")
        new_nodes = []
        index=0
        for node in nodes_payload:
            current_node = node
            id_hostname = str(system_random.randint(1, 300))
            current_node["client"]["dom0_oracle_name"] = dom0[index]
            current_node["client"]["hostname"] = current_node["client"]["hostname"] + id_hostname
            current_node["backup"]["dom0_oracle_name"] = dom0[index]
            current_node["backup"]["hostname"] = current_node["backup"]["hostname"] + id_hostname
            current_node["vmId"] = current_node["vmId"] + str(system_random.randint(1, 300))
            index = index + 1
            new_nodes.append(current_node)
        payload["customer_network"]["nodes"] = new_nodes
        payload["clusterId"]   = payload["clusterId"] + str(system_random.randint(1, 300))
        payload["clustername"] = payload["clustername"] + str(system_random.randint(1, 300))
        return payload

    def do_add_cluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'addcluster' , params)
        except Exception as e:
            return cl.perr(str(e))
        payload   = json.load(open(params["json_path"]))
        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        if "hostnames" in params:
            payload = self.modify_payload_add_cluster(payload,params["hostnames"])
        if "rackname" in params:
            payload["rackname"] = params.get("rackname")
            if "dev" in params:
                if params['dev'] == 'default' or params['dev'] == 'true':
                    payload = self.create_addcluster_payload(params["rackname"], payload, host)
        payload["idemtoken"] = idemtoken
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacompute/clusters".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_sanity_check(self, ecli, line, host):
            params = ecli.parse_params(line, None)
            print_raw = "raw" in params and params.pop("raw").lower() == "true"
            try:
                ecli.validate_parameters('exacompute', 'runfleetjsoncheck' , params)
            except Exception as e:
                return cl.perr(str(e))

            payload = {}
            payload["hostname"] = None
            data = json.dumps(payload, sort_keys=True, indent=4)
            response = self.HTTP.post(data,"exacompute","{0}/chaine/fleetstate/latest/sanitycheck".format(host))
            if response:
                cl.prt("n", json.dumps(response))

    def do_add_cluster_precheck(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'addcluster' , params)
        except Exception as e:
            return cl.perr(str(e))
        payload   = json.load(open(params["json_path"]))
        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        if "hostnames" in params:
            payload = self.modify_payload_add_cluster(payload,params["hostnames"])
        payload["idemtoken"] = idemtoken
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacompute/clusters/precheck".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_precheck(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'precheck' , params) 
        except Exception as e:
            return cl.perr(str(e))
        payload  = {'hostname': params["hostname"]}
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacompute/precheck".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_delete_cluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'deletecluster' , params)
        except Exception as e:
            return cl.perr(str(e))

        vmClusterId = params["vmclusterid"]
        url = "{0}/exacompute/clusters/{1}".format(self.HTTP.host, vmClusterId)
        data = None
        response = self.HTTP.delete(url, data)

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_list_cluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'listcluster' , params)
        except Exception as e:
            return cl.perr(str(e))
        typePayload = params.get("type")
        queryParams = ""
        vmClusterId = "ALL" if not 'vmclusterid' in params else params["vmclusterid"]
        if typePayload:
            url = "{0}/exacomputeVmClusters/{1}".format(self.HTTP.host, vmClusterId)
        else:
            url = "{0}/exacompute/clusters/{1}".format(self.HTTP.host, vmClusterId)

        if "verbose" in params:
            queryParams += "&verbose=" + params["verbose"]

        if len(queryParams)>0:
            url += "?" + queryParams[1:]
        response = ecli.issue_get_request(url, False)

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_active_card(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'activecard' , params)
        except Exception as e:
            return cl.perr(str(e))
        oracleHostname = params.get("oraclehostname")
        url = "{0}/exacompute/{1}/activecard".format(self.HTTP.host, oracleHostname)
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_vm(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"

        try:
            ecli.validate_parameters('exacompute', 'vm' , params)
        except Exception as e:
            return cl.perr(str(e))

        url = "{0}/exacompute/exaUnit/{1}/vm/{2}".format(self.HTTP.host, params.pop("exaUnitId"), params.pop("vmName"))
        vmOp = {}
        vmOp['vmOperation'] = params
        data = json.dumps(vmOp, indent=4)
        response = self.HTTP.post(data,"exacompute",url)

        if response:
            try:
                # dumping json
                cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
            except Exception as e:
                cl.perr("Error: {0}".format(e))
    
    def do_exacompute_createmdcontext(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'createmdcontext' , params)
        except Exception as e:
            return cl.perr(str(e))

        payload   = json.load(open(params["json_path"]))
        fabricname = payload.get("fabricname")
        
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exacompute", "{0}/fabrics/{1}/maintenanceDomainContext".format(host, fabricname))
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_deletemdcontext(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'deletemdcontext' , params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")
        url = "{0}/fabrics/{1}/maintenanceDomainContext".format(self.HTTP.host, fabricname)
        data = None
        response = self.HTTP.delete(url, data)

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_updatemdcontext(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'updatemdcontext' , params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")

        payload   = json.load(open(params["json_path"]))

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/fabrics/{1}/maintenanceDomainContext".format(host, fabricname), data, "exacompute")

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))   
    
    def do_exacompute_getmdcontext(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'getmdcontext', params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")
        url = "{0}/fabrics/{1}/maintenanceDomainContext".format(self.HTTP.host, fabricname)
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_createmaintenancedomain(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'createmaintenancedomain' , params)
        except Exception as e:
            return cl.perr(str(e))

        payload   = json.load(open(params["json_path"]))
        fabricname = payload.get("fabricname")
        
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exacompute", "{0}/fabrics/{1}/mdContext/maintenanceDomains".format(host, fabricname))
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_deletemaintenancedomain(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'deletemaintenancedomain' , params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")
        mdid = params.get("maintenancedomainid")
        url = "{0}/fabrics/{1}/mdContext/maintenanceDomains/{2}".format(self.HTTP.host, fabricname, mdid)
        data = None
        response = self.HTTP.delete(url, data)

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_updatemaintenancedomain(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'updatemaintenancedomain' , params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")
        mdid = params.get("maintenancedomainid")

        payload   = json.load(open(params["json_path"]))

        data = json.dumps(payload, sort_keys=True, indent=4)
        if 'action' in params:
            response = self.HTTP.put("{0}/fabrics/{1}/mdContext/maintenanceDomains/{2}?action={3}".format(host, fabricname, mdid, params["action"]), data, "exacompute")
        else:
            response = self.HTTP.put("{0}/fabrics/{1}/mdContext/maintenanceDomains/{2}".format(host, fabricname, mdid), data, "exacompute")

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))   

    def do_exacompute_getmdnodes(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'getmdnodes' , params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")
        mdid = params.get("maintenancedomainid")
        url = "{0}/fabrics/{1}/mdContext/maintenanceDomains/{2}/computeNodes".format(self.HTTP.host, fabricname, mdid)
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))
    
    def do_exacompute_getmaintenancedomain(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'getmaintenancedomain' , params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")
        mdid = params.get("maintenancedomainid")
        url = "{0}/fabrics/{1}/mdContext/maintenanceDomains/{2}".format(self.HTTP.host, fabricname, mdid)
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_listmaintenancedomain(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'listmaintenancedomain' , params)
        except Exception as e:
            return cl.perr(str(e))

        fabricname = params.get("fabricname")
        url = "{0}/fabrics/{1}/mdContext/maintenanceDomains".format(self.HTTP.host, fabricname)
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_computedetail(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'computedetail' , params)
        except Exception as e:
            return cl.perr(str(e))

        hostname = params.get("hostname")

        url = "{0}/exacompute/computedetail/{1}".format( self.HTTP.host, hostname )
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_updatenodemdmapping(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'updatenodemdmapping', params)
        except Exception as e:
            return cl.perr(str(e))

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/nodemdmapping".format(host), data, "exacompute")

        if response:
            cl.prt("n", json.dumps(response))

    def do_get_rack(self, ecli, host, vmclusterid):
        query = "?{0}={1}".format("vm_cluster_ocid",vmclusterid)
        response = ecli.issue_get_request("{0}/racks{1}".format(host, query),False)
        return json.dumps(response)

    def create_json_reshape(self,ecli,host,vmclusterid,operation,resource,quantity):
        result = {}
        exaunitId = ""
        racks = json.loads(self.do_get_rack(ecli,host,vmclusterid))
        if racks:
            for rack in racks['racks']:
                exaunitId = rack['exaunitID']
        else:
            result["ERROR"] = ""
            return json.dumps(result)

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

    def create_json_reshape_filesystem(self,ecli,host,vmclusterid,operation,resourceFS,resourceVol,quantityFS,quantityVol):
        result = {}
        exaunitId = ""
        racks = json.loads(self.do_get_rack(ecli,host,vmclusterid))
        if racks:
            for rack in racks['racks']:
                exaunitId = rack['exaunitID']
        else:
            result["ERROR"] = ""
            return json.dumps(result)

        listNewServers = []
        cores = self.HTTP.get("{0}/exaunit/{1}/cores".format(host, exaunitId))
        if cores:
            for ocpu in cores['ocpuAllocations']:
                newServer = {}
                newServer[resourceFS] = quantityFS
                newServer[resourceVol] = quantityVol
                newServer["hostName"] = ocpu["hostName"]
                listNewServers.append(newServer)
        else:
            result["ERROR"] = ""
        result["operation"]          = operation
        result["clusterAllocations"] = listNewServers
        return json.dumps(result)


    def do_exacompute_reshapecluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'reshapecluster', params)
        except Exception as e:
            return cl.perr(str(e))
        strCores   = "cores"
        strMemory  = "memoryGb"
        strOhSize  = "ohomeSizeGb"
        strFilesystems = "filesystem"
        strVolumes = "volumes"

        resourcesKeys = {strCores,strMemory,strOhSize,strFilesystems, strVolumes}

        resourcesParams = [ k for k, v in params.items() if k in resourcesKeys and v is not None]

        if len(resourcesParams) == 0:
            cl.perr("You have to provide at least one resource. "+str(resourcesKeys))
            return
        if len(resourcesParams) > 1:
            if(len(resourcesParams) == 2):
                if(strFilesystems not in resourcesParams):
                    cl.perr("You have to provide not more than one resource at the time")
                    return
                else:
                    if (strVolumes not in resourcesParams):
                        cl.perr("You have to provide volumes and filesystem parameter for filesystem cluster reshape")
                        return
            else:
                cl.perr("You have to provide not more than one resource at the time.")
                return

        resource = resourcesParams[0]

        if resource == strFilesystems or resource == strVolumes:
            filesystemQuantity = [{"mountpoint": mountpoint[0], "sizegb": mountpoint[1]} for mountpoint in [ element.split(':') for element in params.get(strFilesystems).split(',') ]]
            volumesQuantity = [{"volumetype": volumetype[0], "sizegb": volumetype[1]} for volumetype in [element.split(':') for element in params.get(strVolumes).split(',')]]
        else:
            quantity  = int(params.get(resource))

        operation = "updateAllocation"
        vmclusterid = params["vmclusterid"]
        if resource == strFilesystems or resource == strVolumes:
            payload = json.loads(self.create_json_reshape_filesystem(ecli, host, vmclusterid, operation, strFilesystems, strVolumes, filesystemQuantity, volumesQuantity))
        else:
            payload = json.loads(self.create_json_reshape(ecli, host, vmclusterid, operation, resource, quantity))

        if payload.get("ERROR"):
            cl.perr("Unable to fetch current cores information from ecra. Reshape cluster operation failed")
            return

        if "idemtoken" not in payload:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            payload["idemtoken"] = idemtoken

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/{1}".format(host, vmclusterid), data, "exacompute")
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_reshapecluster_precheck(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'reshapecluster', params)
        except Exception as e:
            return cl.perr(str(e))

        strCores   = "cores"
        strMemory  = "memoryGb"
        strOhSize  = "ohomeSizeGb"

        cores   = params.get(strCores) is not None
        memory  = params.get(strMemory) is not None
        ohsize  = params.get(strOhSize) is not None

        isValid = cores  ^ memory ^  ohsize

        if not isValid:
            cl.perr("You have to provide at least one resource and not more than one. Available [cores|memoryGb|ohomeSizeGb] ")
            return

        if params.get(strCores):
            resource = strCores
        elif params.get(strMemory):
            resource = strMemory
        elif params.get(strOhSize):
            resource = strOhSize

        quantity  = int(params.get(resource))

        operation = "updateAllocation"
        vmclusterid = params["vmclusterid"]
        payload = json.loads(self.create_json_reshape(ecli,host,vmclusterid,operation,resource,quantity))

        if payload.get("ERROR"):
            cl.perr("Unable to fetch current cores information from ecra. Reshape cluster operation failed")
            return

        if "idemtoken" not in payload:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            payload["idemtoken"] = idemtoken

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exacompute", "{0}/exacompute/{1}/scaleprecheck".format(host,vmclusterid))
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_initiator(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'initiator', params)
        except Exception as e:
            return cl.perr(str(e))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacompute/initialingestion".format(host))

        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_updateocid(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'updateocid', params)
        except Exception as e:
            return cl.perr(str(e))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/initialingestion".format(host), data, "exacompute")

        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_gettemplate(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'gettemplate' , params)
        except Exception as e:
            return cl.perr(str(e))

        type = params.get("type")
        vmclusterocid = params.get("vmclusterocid")

        url = "{0}/exacompute/template?type={1}".format(self.HTTP.host, type)

        if vmclusterocid is not None:
            url = "{0}&vmclusterocid={1}".format(url,vmclusterocid)

        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))


    def do_exacompute_validatevolumes(self, ecli, line, host):
        wait = False
        if "wait" in line:
            wait = True
            line = re.sub('wait', '', line).strip()

        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'validatevolumes' , params)
        except Exception as e:
            return cl.perr(str(e))

        is_rackname_valid = "rackname" in params and params["rackname"] != ""
        is_hostname_valid = "hostname" in params and params["hostname"] != ""

        if is_rackname_valid and is_hostname_valid:
            cl.perr("Unable to combine rackname and hostname use either one")
            return
        if is_rackname_valid == False and is_hostname_valid == False:
            cl.perr("Unable to run volume validation, use rackname or hostname")
            return
        if is_hostname_valid and "." in params["hostname"]:
            cl.perr("Use only oracle hostname, not FQDN")
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacompute/volumevalidations".format(host))

        if response and not wait:
            cl.prt("n", json.dumps(response))

        if response and wait:
            cl.prt("n", json.dumps(response))
            statusid = response["status_uri"].split('/')[-1]
            cl.prt("c", "Status UUID: " + statusid)
            statusrsp = 202
            while (statusrsp != 200):
                statusongoing = ecli.issue_get_request("{0}/statuses/{1}".format(host, statusid), False)
                statusrsp = statusongoing["status"]
                if (statusrsp == 500):
                    cl.prt("r", "Volume validation failed")
                    statusrsp = 200
                time.sleep(10)

            url  = "{0}/exacompute/volumevalidations/{1}".format(host, statusid)
            validation_result = ecli.issue_get_request(url, False)
            cl.prt("n", json.dumps(validation_result, sort_keys=False, indent=4))



    def do_exacompute_postvolumes(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'postvolumes' , params)
        except Exception as e:
            return cl.perr(str(e))
        payload   = json.load(open(params["jsonpath"]))
        idemtoken = ecli.getNewIdemtoken()
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacompute/volumes".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_getvolumes(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('exacompute', 'getvolumes', params)
        except Exception as e:
            return cl.perr(str(e))
        try:
            from urllib import urlencode
        except ImportError:
            from urllib.parse import urlencode

        response = None
        if "rackname" in params:
            rackname  = params["rackname"]
            query = urlencode(params) if len(params) > 0 else ""
            url  = "{0}/exacompute/volumes/{1}?{2}".format(host,rackname,query)
            response = ecli.issue_get_request(url, False)
        elif "hostname" in params:
            query = urlencode(params) if len(params) > 0 else ""
            url  = "{0}/exacompute/volumes?{1}".format(host,query)
            response = ecli.issue_get_request(url, False)
        else:
            cl.prt("r", "Provide either rackname or hostname")
            return

        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_exacompute_generatesshkeys(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'generatesshkeys', params)
        except Exception as e:
            return cl.perr(str(e))


        hostname = params.get("hostname") is not None
        if not hostname:
            cl.perr("You have to provide a hostname.")
            return

        if "idemtoken" not in params:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            params["idemtoken"] = idemtoken

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/generatesshkeys".format(host), data, "exacompute")

        if not response:
            cl.perr("Failed to generate ssh keys")
            return

        cl.prt("n",json.dumps(response, indent=4, sort_keys=True))

    def do_exacompute_getpublickey(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'getpublickey', params)
        except Exception as e:
            return cl.perr(str(e))

        hostname = params.get("hostname") is not None
        if not hostname:
            cl.perr("You have to provide a hostname.")
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.get("{0}/exacompute/getpublickey/{1}".format(host, params["hostname"]))

        if not response:
            cl.perr("Failed to get public key")
            return

        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_exacompute_getvaultaccess(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'getvaultaccess', params)
        except Exception as e:
            return cl.perr(str(e))

        hasVaultOCID = params.get("vaultaccessid") is not None
        if not hasVaultOCID:
            cl.perr("You have to provide a vaultaccessid.")
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.get("{0}/exacompute/getvaultaccess/{1}".format(host, params["vaultaccessid"]))

        if not response:
            cl.perr("Failed to get vault access information")
            return

        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_exacompute_updatevaultaccessdetails(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'updatevaultaccessdetails', params)
        except Exception as e:
            return cl.perr(str(e))

        paramsjson = json.load(open(params["jsonpath"]))
        if "idemtoken" not in params:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            idemtokenjson ={"idemtoken":idemtoken}
            paramsjson.update(idemtokenjson)

        data = json.dumps(paramsjson, sort_keys=True, indent=4)

        response = self.HTTP.put("{0}/exacompute/updatevaultaccessdetails".format(host), data, "exacompute")

        if not response:
            cl.perr("Failed to get vault access details")
            return

        cl.prt("n",json.dumps(response, indent=4, sort_keys=True))

    def do_exacompute_deletevaultaccessdetails(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'deletevaultaccessdetails', params)
        except Exception as e:
            return cl.perr(str(e))

        validParam = (params.get("hostname") is not None) or (params.get("vaultaccessid") is not None)
        if not validParam:
            cl.perr("You have to provide a vaultaccessid or hostname.")
            return
        elif params.get("vaultaccessid") is not None:
            parameter = params.get("vaultaccessid")
        else:
            parameter = params.get("hostname")

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/exacompute/vaultaccessdetails/{1}".format(host, parameter), data)

        if not response:
            cl.perr("Failed to delete vault access details")
            return

        cl.prt("n",json.dumps(response, indent=4, sort_keys=True))

    def do_exacompute_precheckedvvolumes(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'precheckedvvolumes', params)
        except Exception as e:
            return cl.perr(str(e))
        payload = json.load(open(params["jsonpath"]))
        idemtoken = ecli.getNewIdemtoken()
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacomputeVmClusters/precheckEdvVolumes".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_snapshotmount(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'snapshotmount', params)
        except Exception as e:
            return cl.perr(str(e))
        payload = json.load(open(params["jsonpath"]))
        if "idemtoken" in params:
            payload["idemtoken"] =  params["idemtoken"]
        else:
            payload["idemtoken"] = ecli.getNewIdemtoken()
        if "vminstanceid" in params:
            payload["vminstanceid"] =  params["vminstanceid"]
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/exacompute/snapshot".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_snapshotunmount(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'snapshotunmount', params)
        except Exception as e:
            return cl.perr(str(e))
        payload = json.load(open(params["jsonpath"]))
        if "idemtoken" in params:
            payload["idemtoken"] =  params["idemtoken"]
        else:
            payload["idemtoken"] = ecli.getNewIdemtoken()
        if "vminstanceid" in params:
            payload["vminstanceid"] =  params["vminstanceid"]
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/snapshot".format(host),data,"exacompute")
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_listsystemvault(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'listsystemvault', params)
        except Exception as e:
            return cl.perr(str(e))

        if ("vaultid" in params):
            url = "{0}/systemVault?vaultId={1}".format(host, params["vaultid"])
        else:
            url = "{0}/systemVault".format(host)

        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_exacompute_updatesystemvault(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'updatesystemvault', params)
        except Exception as e:
            return cl.perr(str(e))

        vault_id = params.get("vaultid") is not None
        if not vault_id:
            cl.perr("You have to provide a vaultId")
            return
        payload = json.load(open(params["jsonpath"]))
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/systemVault/{1}".format(host, params["vaultid"]), data, "exacompute")

        if not response:
            cl.perr("Failed to update system vault")
            return

        cl.prt("n",json.dumps(response, indent=4, sort_keys=True))

    def do_exacompute_deletesystemvault(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'deletesystemvault', params)
        except Exception as e:
            return cl.perr(str(e))

        vault_id = params.get("vaultid") is not None
        if not vault_id:
            cl.perr("You have to provide a vaultId")
            return
        url = "{0}/systemVault/{1}".format(self.HTTP.host, params["vaultid"])
        data = None
        response = self.HTTP.delete(url, data)

        if not response:
            cl.perr("Failed to update system vault")
            return

        cl.prt("n",json.dumps(response, indent=4, sort_keys=True))

    def do_exacompute_createsystemvault(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'createsystemvault', params)
        except Exception as e:
            return cl.perr(str(e))

        payload = json.load(open(params["jsonpath"]))
        idemtoken = ecli.getNewIdemtoken()
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/systemVault".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_getnathostnames(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'getnathostnames' , params)
        except Exception as e:
            return cl.perr(str(e))

        hostname = params.get("hostname")

        url = "{0}/exacompute/{1}/getnathostnames".format( self.HTTP.host, hostname )
        response = ecli.issue_get_request(url, False)
        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_updatefleetnode(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'updatefleetnode', params)
        except Exception as e:
            return cl.perr(str(e))

        hostname = params.get("hostname") is not None
        if not hostname:
            cl.perr("Please provide hostname")
            return
        payload = json.load(open(params["jsonpath"]))
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/updatefleetnode/{1}".format(host, params["hostname"]), data, "exacompute")

        if not response:
            cl.perr("Failed to update Hardware Node")
            return

        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_clusterdetail(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'clusterdetail' , params)
        except Exception as e:
            return cl.perr(str(e))
        vmClusterId = params["vmclusterid"]
        url = "{0}/exacomputeVmClusters/{1}/detail".format(self.HTTP.host, vmClusterId)
        response = ecli.issue_get_request(url, False)

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_securevms(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'securevms' , params)
        except Exception as e:
            return cl.perr(str(e))
        vmClusterId = params["vmclusterid"]
        payload = {}
        idemtoken = None
        if "payload" in params:
            payload = json.load(open(params["payload"]))
        if "idemtoken" in params:
            idemtoken = params["idemtoken"]
        else:
            idemtoken = ecli.getNewIdemtoken()
            
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        payload["idemtoken"] = idemtoken
        data = json.dumps(payload, sort_keys=True, indent=4)
        url = "{0}/exacompute/securevm/{1}".format(host,vmClusterId)
        response = self.HTTP.post(data,"exacompute",url)

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_removenodexml(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'removenodexml' , params)
        except Exception as e:
            return cl.perr(str(e))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/removenodexml".format(host), data, "exacompute")

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_configureroceips(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'configureroceips', params)
        except Exception as e:
            return cl.perr(str(e))
        
        idemtoken = None
        if "idemtoken" in params:
            idemtoken = params["idemtoken"]
        else:
            idemtoken = ecli.getNewIdemtoken()
            
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        params["idemtoken"] = idemtoken
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exacompute", "{0}/exascaleroceips/configure".format(host))

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))
        
        
    def do_exacompute_deconfigureroceips(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'deconfigureroceips', params)
        except Exception as e:
            return cl.perr(str(e))
        
        idemtoken = None
        if "idemtoken" in params:
            idemtoken = params["idemtoken"]
        else:
            idemtoken = ecli.getNewIdemtoken()
            
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        params["idemtoken"] = idemtoken

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exacompute", "{0}/exascaleroceips/deconfigure".format(host))

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_nodedetail(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'nodedetail', params)
        except Exception as e:
            return cl.perr(str(e))

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items() if value != None]) if params else ""
        url  = "{0}/exacompute/nodedetail{1}".format(host, query)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=2))

    def do_exacompute_computecleanup(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('exacompute', 'computecleanup', params)
        except Exception as e:
            return cl.perr(str(e))

        hostname = params.get('hostname')
        first_confirmation = input("Are you sure you want to execute compute cleanup on host: '" + hostname + "'?(yes|no):")
        if first_confirmation != "yes":
            cl.prt("c", "Compute cleanup not confirmed, aborting")
            return False

        second_confirmation = input("Is this host on ERROR or HW_FAIL state?: '" + hostname + "'?(yes|no):")
        if second_confirmation != "yes":
            cl.prt("c", "Compute cleanup not confirmed, aborting")
            return False

        idemtoken = ecli.getNewIdemtoken()
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exacompute", "{0}/exacompute/computecleanup".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_clusterhistory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'clusterhistory', params)
        except Exception as e:
            return cl.perr(str(e))

        rackname = params.pop("rackname")
        url  = "{0}/exacompute/cluster/{1}/history".format(host, rackname)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=2))

    def do_exacompute_cleanup_request(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        if not params.get("opc-request-id"):
            params["opc-request-id"] = str(uuid.uuid4())
        try:
            ecli.validate_parameters('exacompute', 'cleanuprequest' , params)
        except Exception as e:
            return cl.perr(str(e))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exacompute/cleanup/{1}".format(host, params["requestid"]), data, "exacompute")
        if response:
            cl.prt("n", json.dumps(response))

    def do_exacompute_updatefabricfleet(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'updatefabricfleet', params)
        except Exception as e:
            return cl.perr(str(e))
        
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exacompute", "{0}/exacompute/updatefabricsfleet".format(host))

        if response:
            try:
                # dumping json
                data = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", data)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_exacompute_dbvolumes_operation(self, ecli, line, host):
            params = ecli.parse_params(line, None)
            if not params.get("opc-request-id"):
                params["opc-request-id"] = str(uuid.uuid4())
            try:
                ecli.validate_parameters('exacompute', 'dbvolumes' , params)
            except Exception as e:
                return cl.perr(str(e))


            vm_cluster_ocid = params.pop("vmclusterocid")
            operation = params.pop("operation")
            payload = params.pop("jsonpath")
            req_id = params.pop("opc-request-id")


            elasticPayload = None
            with open(payload) as json_file:
                elasticPayload = json.load(json_file)

            headers = {}
            headers["idemtoken"] = ecli.getNewIdemtoken()

            if headers["idemtoken"] is None:
                cl.perr("Could not get idemtoken")
                return
            else:
                elasticPayload["idemtoken"] = headers["idemtoken"]

            data = json.dumps(elasticPayload, sort_keys=True, indent=4)
            if operation == "attach":
                response = self.HTTP.post(data, "exacompute", "{0}/exacompute/{1}/dbvolumes?opc-request-id={2}"
                                    .format(host, vm_cluster_ocid, req_id), header=headers)

            if operation == "detach":
                response = self.HTTP.post(data, "exacompute", "{0}/exacompute/{1}/deletedbvolumes?opc-request-id={2}"
                                    .format(host, vm_cluster_ocid, req_id), header=headers)

            if operation == "resize":
                response = self.HTTP.put("{0}/exacompute/{1}/dbvolumes?opc-request-id={2}"
                                    .format(host, vm_cluster_ocid, req_id), data, "exacompute", idemtoken=headers["idemtoken"])

            if response:
                cl.prt("n", json.dumps(response))

    def do_exacompute_getdomus(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'getdomus', params)
        except Exception as e:
            return cl.perr(str(e))

        hostname = params["hostname"]

        url  = "{0}/exacompute/nodecomposition/{1}".format(host,hostname)
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_exacompute_getvmclusterdetails(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'getvmclusterdetails', params)
        except Exception as e:
            return cl.perr(str(e))

        url  = "{0}/exacompute/vmclusterociddetails".format(host)
        queryParams = ""

        if "vmclusterocid" in params:
            queryParams += "&vmclusterocid=" + params["vmclusterocid"]
        if "opc-request-id" in params:
            queryParams += "&opc-request-id=" + params["opc-request-id"]


        if len(queryParams)>0:
            url += "?" + queryParams[1:]
        
        response = ecli.issue_get_request(url, False)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_exacompute_rackreserve(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'rackreserve', params)
        except Exception as e:
            return cl.perr(str(e))
        headers = {}
        if "idemtoken" in params:
            headers["idemtoken"] = params.pop("idemtoken")
        else:
            headers["idemtoken"] = ecli.getNewIdemtoken()
        if headers["idemtoken"] is None:
            cl.perr("Could not get idemtoken")
            return
        url  = "{0}/exacompute/rack/rackreserve".format(host)
        params["nodes"] = self.get_nodes_array(params.pop("hostnames"))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(url, data, "exacompute", idemtoken=headers["idemtoken"])
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def get_nodes_array(self, hostnames):
        nodesArray = []
        hostnamesArray = hostnames.split(",")
        for i in range(len(hostnamesArray)):
            nodeObj = {}
            nodeObj["dom0OracleName"] = hostnamesArray[i]
            nodesArray.append(nodeObj)
        return nodesArray
    
    def do_exacompute_guestreserve(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'guestreserve', params)
        except Exception as e:
            return cl.perr(str(e))
        headers = {}
        if "idemtoken" in params:
            headers["idemtoken"] = params.pop("idemtoken")
        else:
            headers["idemtoken"] = ecli.getNewIdemtoken()
        if headers["idemtoken"] is None:
            cl.perr("Could not get idemtoken")
            return
        url  = "{0}/exacompute/rack/guestreserve".format(host)
        params["nodes"] = self.get_nodes_array(params.pop("hostnames"))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(url, data, "exacompute", idemtoken=headers["idemtoken"])
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))


    def do_exacompute_guestrelease(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacompute', 'guestrelease', params)
        except Exception as e:
            return cl.perr(str(e))
        headers = {}
        if "idemtoken" in params:
            headers["idemtoken"] = params.pop("idemtoken")
        else:
            headers["idemtoken"] = ecli.getNewIdemtoken()
        if headers["idemtoken"] is None:
            cl.perr("Could not get idemtoken")
            return
        url  = "{0}/exacompute/rack/guestrelease".format(host)
        params["nodes"] = self.get_nodes_array(params.pop("hostnames"))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(url, data, "exacompute", idemtoken=headers["idemtoken"])
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

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
