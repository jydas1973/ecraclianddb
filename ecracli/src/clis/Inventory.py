#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Inventory.py /main/42 2025/08/06 20:59:02 caborbon Exp $
#
# Inventory.py
#
# Copyright (c) 2015, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Inventory.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      Inventory operations
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    caborbon   07/11/25 - ENH 38135205 - Adding logic to restore ilom password
#                          from secrets
#    caborbon   06/24/25 - Enh 37972633 - Adding ilom command execution api
#    zpallare   10/02/24 - Enh 36922155 - EXACS X11M - Base system support
#    jvaldovi   04/30/24 - Enh 36478797 - Node Recovery : Ecra Api For Free
#                          Computes Availability Required To Support Sop
#                          Automation
#    caborbon   02/17/24 - Bug 36249781 - Adding Model Subtype value in
#                          inventory summary command
#    jzandate   02/16/24 - Enh 36192008 - Adding pagination headers to response
#                          output
#    zpallare   08/22/23 - Enh 35665349 - EXACS: normalize the parameter to
#                          indicate a dom0 in reserve, addcompute,
#                          deletecompute in ecracli
#    gvalderr   05/09/23 - Adding endpoint for updating and getting
#                          status_comment for node and cabinet
#    illamas    11/11/22 - Enh 34784491 - Target device support
#    ririgoye   10/08/22 - Enh 34409795 - ECRA should have a node summary across all fabrics, fault domains, etc. 
#    rgmurali   01/18/22 - ER 33539014 - T93 blackout support
#    illamas    22/09/21 - Enh 33381947 - Moving specs from ecs_exadata_capacity to ecs_exadata_formation
#    rgmurali   08/12/21 - Enh 33186942 - Update cabinet details
#    marislop   06/30/21 - ENH 32925891 - Added details on computes and cells
#    jreyesm    03/01/20 - Enh 32503057. Format inventory output 
#    llmartin   10/19/20 - Enh 32133351 - Inventory release for elastic shapes
#    llmartin   10/19/20 - Enh 31944421 - MultipleOperations cancel task feature
#    jreyesm   08/08/20 - ER 31794630  Inventory release changes
#    marcoslo   08/08/20 - ER 30613740 Update code to use python 3
#    rgmurali   08/01/20 - ER 31695260 - ECRA-infra patch integration for X8M
#    hcheon     06/30/20 - ER 31152543 Inventory check command
#    rgmurali   05/12/20 - ER 31340720 Inventory reserve to create idemtoken 
#    rgmurali   04/21/20 - ER 30971270 Inventory reserve/release APIs
#    jreyesm    04/13/20 - E.R 31127541. Refactor inventory for oci gen2
#    jreyesm    04/12/18 - creation
#

from formatter import cl
import json
import os
from os import path
import re
import sys


try:
    from lxml import etree as et
except ImportError:
    #Code updated for python 3. Assert is not valid anymore.
    #assert sys.version_info[:2] == (2, 7), "please use python 2.7"
    import xml.etree.ElementTree as et

class Inventory:
    
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_get_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "get", params,False)
        except Exception as e:
            cl.perr(str(e))
            return
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/inventory{1}".format(host,query), False)
        cl.prt("n",json.dumps(response, indent=4, sort_keys=False))


    #Specific method for OCI, as this is dependent of compose cluster tables
    def do_get_inventory_hardware(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "get_hardware", params,False)
        except Exception as e:
            cl.perr(str(e))
            return
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response=ecli.issue_get_request("{0}/inventory/hardware{1}".format(host,query), False, printPaginationHeaders=True)
        cl.prt("n",json.dumps(response, indent=4, sort_keys=False))

    # Method that will return a boolean value if selected HW is available
    def do_reviewcapacity_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "reviewcapacity", params,False)
        except Exception as e:
            cl.perr(str(e))
            return
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response=ecli.issue_get_request("{0}/inventory/reviewcapacity{1}".format(host,query), False)
        cl.prt("n",json.dumps(response, indent=4, sort_keys=False))

    #This method gets a list of non-free nodes for a cabinet (Storage only or compute only)
    #It returns a list of FQDNs of the non-free nodes.
    def do_getexcludelist_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "getexcludelist", params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/inventory/excludelist{1}".format(host,query), False)
        cl.prt("n",json.dumps(response, indent=4, sort_keys=False))
        

    def do_register_inventory(self, ecli, line, host):
        line = line.split(' ', 1)
        inventory_id, rest = line[0], line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        if not inventory_id or '=' in inventory_id:
            cl.perr ("Missing Inventory Id")
            return
        try:
            ecli.validate_parameters("inventory", "register", params)
        except Exception as e:
            cl.perr(str(e))
            return
        params['inventory_id']=inventory_id

        if "specs_path" in params:
            specs_path = params["specs_path"]
            if (os.path.isfile(specs_path)):
                specs_file = open(specs_path)
                params["specs"] = specs_file.read().replace('\n','')
                specs_file.close()
            else:
                cl.perr("Missing file from specs_path")
                return

        response = self.HTTP.post(json.dumps(params), "capacity", "{0}/inventory".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_deregister_inventory(self, ecli, line, host):
        line = line.split(' ', 1)
        inventory_id, rest = line[0], line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        if not inventory_id or '=' in inventory_id:
            cl.perr ("Missing Inventory Id")
            return
        try:
            ecli.validate_parameters("inventory", "deregister", params)
        except Exception as e:
            cl.perr(str(e))
            return
        response = self.HTTP.delete("{0}/inventory/{1}".format(host,inventory_id))
        if response:
            cl.prt("n", json.dumps(response))

    def do_update_inventory(self, ecli, line, host):
        line = line.split(' ', 1)
        inventory_id, rest = line[0], line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        if not inventory_id or '=' in inventory_id:
            cl.perr ("Missing Inventory Id")
            return
        try:
            ecli.validate_parameters("inventory", "update", params,False)
        except Exception as e:
            cl.perr(str(e))
            return
        params['inventory_id']=inventory_id

        if "specs_path" in params:
            specs_path = params["specs_path"]
            if (os.path.isfile(specs_path)):
                specs_file = open(specs_path)
                params["specs"] = specs_file.read().replace('\n','')
                specs_file.close()
            else:
                cl.perr("Missing file from specs_path")
                return

        response = self.HTTP.put("{0}/inventory".format(host), json.dumps(params), "inventory")
        if response:
            cl.prt("n", json.dumps(response))

    def do_reserve_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            infraId = None
            rackname = None
            model = None
            if 'exadataInfrastructureId' in params:
                infraId = params['exadataInfrastructureId']
            if 'rackname' in params:
                rackname = params['rackname']
            if 'model' in params:
                model = params['model']
            params = json.load(open(params["json_path"]))

            if 'hostnames' in params:
                params['nodesToReserve'] = params['hostnames']

            if infraId:
                params['exadataInfrastructureId'] = infraId
            if rackname:
                params['rackname'] = rackname
            if model:
                for item in params['servers']:
                    item['model'] = model
            
        else :
            #Build json from parameters.
            if "nodesToReserve" in params:
                params["nodesToReserve"] = params["nodesToReserve"].split(',')
            elif "hostnames" in params:
                params["nodesToReserve"] = params["hostnames"].split(',')
            else:
                cl.prt("r", "Pass in a json file with correct keys")

        # Validate the parameters
        try:
            ecli.validate_parameters("inventory", "reserve", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "idemtoken" not in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to reserve inventory")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "capacity", "{0}/inventory/reserve".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_release_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("inventory", "release", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            params = json.load(open(params["json_path"]))
        elif "hostname" in params and "hw_type" in params :
            server = dict()
            servers = dict()
            server['hostname'] = params['hostname']
            server['hw_type'] = params['hw_type']
            servers['servers']= [server]

            if "exadataInfrastructureId" in params:
                servers['exadataInfrastructureId']= params['exadataInfrastructureId']

            if "rackname" in params:
                servers['rackname']= params['rackname']

            params = servers
        elif "quantity" in params and "hw_type" in params and "rackname" in params:
            server = dict()
            servers = dict()
            server['quantity'] = params['quantity']
            server['hw_type'] = params['hw_type']
            servers['servers']= [server]
            servers['rackname']= params['rackname']

            if "exadataInfrastructureId" in params:
                servers['exadataInfrastructureId']= params['exadataInfrastructureId']

            params = servers
        else:
             cl.prt("r", "Expected parameters, either json_path or (hostname and hw_type) or (quantity, hw_type and rackname)" )
             return

        if "idemtoken" not in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to reserve inventory")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]

        response = self.HTTP.put("{0}/inventory/release".format(host), json.dumps(params), "inventory")
        if response:
            cl.prt("n", json.dumps(response))

    def do_check_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("inventory", "check", params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        http_params = {}
        if 'target_nodes' in params and params['target_nodes'] != 'all':
            http_params['target_nodes'] = params['target_nodes'].split(',')
        else:
            # InventoryResource interprets empty array as 'all'
            http_params['target_nodes'] = []
        http_params['update_node_state'] = bool(params.get('update_node_state', 'true'))

        response = self.HTTP.put("{0}/inventory/check".format(host), json.dumps(http_params), 'inventory')
        if response:
            cl.prt("n", json.dumps(response, indent=4))


    def do_update_hwnode(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="hostname")
        try:
            ecli.validate_parameters("inventory", "update_hwnode", params, strict=False)
        except Exception as e:
            cl.perr(str(e))
            return

        hostname = params.pop("hostname")
        response = self.HTTP.put("{0}/inventory/hardware/{1}".format(host, hostname), json.dumps(params), "inventory")
        if response:
            cl.prt("n", json.dumps(response))

    def do_updatenodes_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "updatenodes", params, strict=False)
        except Exception as e:
            cl.perr(str(e))
            return

        listofnodes = params.pop("listofnodes").split(",")
        for node in listofnodes:
            response = self.HTTP.put("{0}/inventory/hardware/{1}".format(host, node), json.dumps(params), "inventory")
            if response:
                if (response["status"] == 200):
                    cl.prt("c", "Successfully updated the node: " + node)
                else:
                    cl.prt("n", json.dumps(response))

    def do_node_detail(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "get_node_detail", params, False)
            if 'hostnames' not in params and 'cabinetName' not in params:
                raise Exception("cabinetName or hostnames parameter is required")
        except Exception as e:
            cl.perr(str(e))
            return

        queryData = {}
        typehw, queryData["data"] = ("cabinetName", params["cabinetName"]) if "cabinetName" in params else ("hostnames", params["hostnames"])

        url = "{0}/inventory/nodeDetail/{1}".format(host,typehw)

        response = self.HTTP.query(url,queryData)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_update_node_detail(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "update_node_detail", params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/inventory/nodeDetail".format(host)
        if len(params) == 0:
            cl.perr("Use allnodes=true if you want to update all nodes")
            return

        response = self.HTTP.post(json.dumps(params), "inventory", url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_reset_cavium(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "resetcavium", params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        valid_actions = ["start", "stop", "reset"]
        valid_targets = ["ilom","dom0"]
        idemtoken = ecli.getNewIdemtoken()
        if idemtoken is None:
            cl.perr("Could not get idemtoken")
            return
        params["idemtoken"] = idemtoken
        params["cavium_id"] = params.pop("caviumid")
        if "ignorenodestate" in params:
            params["ignore_node_state"] = params.pop("ignorenodestate")
        if "targetdevice" in params:
            targetDevice = params.pop("targetdevice").lower()
            if targetDevice not in valid_targets:
                cl.perr("Invalid targetdevice, try with [" + ', '.join(valid_targets) + "]")
                return
            params["target_device"] = targetDevice
        if "action" in params:
            if not params.get("action").casefold() in [action.casefold() for action in valid_actions]:
                cl.perr("Invalid action, try with [" + ', '.join(valid_actions) + "]")
                return
    
        response = self.HTTP.put("{0}/inventory/cavium".format(host), json.dumps(params), "inventory")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_cavium_collect_diag(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "caviumcollectdiag", params, False)
            if 'caviumid' not in params and 'hostname' not in params:
                raise Exception("caviumid or hostname parameter is required")
        except Exception as e:
            cl.perr(str(e))
            return
        
        if "caviumid" in params: params["cavium_id"] = params.pop("caviumid")

        url = "{0}/inventory/caviumcollectdiag".format(host)

        response = self.HTTP.post(json.dumps(params), "inventory", url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_cavium_diag_response(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "caviumdiagresponse", params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        params["clob_id"] = params.pop("clobid")

        url = "{0}/inventory/caviumdiagresponse/{1}".format(host, params["clob_id"])


        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_reset_cell_vlan(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "resetvlan", params, True)
        except Exception as e:
            cl.perr(str(e))
            return
        params["cells"] = params["cells"].split(",")

        url = "{0}/inventory/resetvlan".format(host)
        response = self.HTTP.put(url, json.dumps(params), "inventory")
        if response:
            cl.prt("n", json.dumps(response, indent=4))

    def do_startblackout_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "startblackout", params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/inventory/startblackout".format(host)
        response = self.HTTP.put(url, json.dumps(params), "inventory")
        if response:
            cl.prt("n", json.dumps(response, indent=4))

    def do_endblackout_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "endblackout", params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/inventory/endblackout".format(host)
        response = self.HTTP.put(url, json.dumps(params), "inventory")
        if response:
            cl.prt("n", json.dumps(response, indent=4))

    def do_getspec_inventory(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "getspec", params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/inventory/spec/{1}/{2}".format(host, params.get("inventoryid"), params.get("rackname"))
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, indent=4))

    def print_values(self, coll: dict, level):
        for key, value in coll.items():
            if isinstance(value, list):
                for node in value:
                    hostname = node.get('hostname')
                    node_state = node.get('nodeState')
                    model_subtype = node.get('modelSubtype')
                    if hostname and node_state:
                        space = '\t' * (level // 2)
                        print("{0}{1}\t{2}\t{3}".format(space, hostname, node_state, model_subtype))
            elif isinstance(value, dict):
                if level % 2 != 0:
                    space = '\t' * (level // 2)
                    if value.get("nodes"):
                        print("{0}{1} ({2})".format(space, key, len(value.get('nodes'))))
                    else:
                        print("{0}{1}".format(space, key))
                self.print_values(value, level + 1)
    
    def do_get_inventory_summary(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "summary", params, True)
        except Exception as e:
            cl.perr(str(e))
            return
        nodestate = params.get("nodestate") if params.get("nodestate") else "FREE"
        url = "{0}/inventory/summary?nodeState={1}".format(host, nodestate)
        response = self.HTTP.get(url)
        self.print_values(response, 0)

    def do_update_status_comment(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "updatestatuscomment", params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.put("{0}/inventory/statuscomment".format(host), json.dumps(params), "inventory")
        if not response:
            cl.perr("Failed to update the status comment field for the provided component.")
            return

        cl.prt("n",json.dumps(response, indent=4))

    def do_get_status_comment(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "getstatuscomment", params, True)
        except Exception as e:
            cl.perr(str(e))
            return
        component = params.get("component")
        name = params.get("name")
        url = "{0}/inventory/getstatuscomment/{1}?name={2}".format(host, component, name)
        response = self.HTTP.get(url)
        if not response:
            cl.perr("Failed to get the status comment field for the provided component.")
            return

        cl.prt("n",json.dumps(response, indent=4))

    def do_reset_ilom_default_password(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "resetilomdefaultpassword", params, False)
            listofnodes = params.pop("listofnodes").split(",")
            params["listofnodes"] = listofnodes
            headers = {}
            if "idemtoken" in params:
                headers["idemtoken"] = params.pop("idemtoken")
            else:
                headers["idemtoken"] = ecli.getNewIdemtoken()

            if headers["idemtoken"] is None:
                cl.perr("Could not get idemtoken")
                return
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/inventory/ilom/resetpassword/default".format(host)
        response = self.HTTP.post(str(params), "inventory", url, headers)
        cl.prt("n",json.dumps(response, indent=4, sort_keys=False))

    def do_reset_ilom_vault_password(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("inventory", "resetilomvaultpassword", params, False)
            listofnodes = params.pop("listofnodes").split(",")
            params["listofnodes"] = listofnodes
            headers = {}
            if "idemtoken" in params:
                headers["idemtoken"] = params.pop("idemtoken")
            else:
                headers["idemtoken"] = ecli.getNewIdemtoken()

            if headers["idemtoken"] is None:
                cl.perr("Could not get idemtoken")
                return
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/inventory/ilom/resetpassword/vault".format(host)
        response = self.HTTP.post(str(params), "inventory", url, headers)
        cl.prt("n",json.dumps(response, indent=4, sort_keys=False))
