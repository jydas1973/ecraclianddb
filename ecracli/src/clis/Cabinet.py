#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Cabinet.py /main/20 2025/09/23 18:30:44 caborbon Exp $
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
#       caborbon 09/09/25 - ENH 38410599 - Adding command to ingest new
#                           cabinets
#       gvalderr 11/25/24 - Enh 37123564 - Addng extra commands for managing
#                           shared racks
#       caborbon 11/04/24 - ENH 37055704 - Adding change in cabinet
#                           modelsubtype API to request less information
#       caborbon 10/14/24 - ENH 37154198 - Changing the keys name in payload to
#                           convert subtype
#       caborbon 09/26/24 - ENH 37029692 - Adding changes to allow new
#                           convertion for X11M-2
#       nitishgu 08/07/24 - BUG 36273903 - ECRACLI/API FOR SETTING CABINET STATE
#                           TO READY SHOULD CHECK IF AVAILABILITY >= THRESHOLD
#       gvalderr 06/24/24 - Enh 36334590 - Adding command for purging archived
#                           nodes
#       gvalderr 06/14/24 - Enh 36334590 - Adding commands to archive and
#                           recover nodes
#       llmartin 06/11/24 - Enh 36651857 - cli to update mvm domus IPs
#       caborbon 04/25/24 - Bug 36037965 - Fixing output in cabinet
#                           modelsubtype
#       zpallare 04/01/24 - Enh 36452336 - ECRA api to handle disable and
#                           enable bonding on compute nodes coming from an x8m
#                           standard rack
#       zpallare 11/08/23 - Bug 35961238 - ECRA: ECRACLI - Fix filters in
#                           cabinet list command
#       caborbon 10/19/23 - Bug 35792183 - Adding modelsubtype command 
#       zpallare 09/28/23 - Enh 35819391 - EXACS - Cabinets port api 
#                           to support cabinetname parameter
#       rgmurali 08/12/21 - Enh 33186942 - Update cabinet details
#       rgmurali 08/24/20 - Create file
#
from formatter import cl
from pathlib import Path
import json
import re
import base64

class Cabinet:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_list_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        query=query.replace(" ","%20")
        response = ecli.issue_get_request("{0}/cabinet{1}".format(host, query), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_ports_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('cabinet', 'ports', params)
        except Exception as e:
            cl.perr(str(e))
            return
        iscabinetid = params.get("cabinetid") is not None
        iscabinetname = params.get("cabinetname") is not None
        paramcount = (1 if iscabinetid else 0) + (1 if iscabinetname else 0)
        if paramcount != 1:
            cl.perr("You have to provide exactly one param cabinetid or cabinetname.")
            return
        cabinetvalue = ""
        cabinetid = -1
        queryParams = ""
        if iscabinetid:
            cabinetid = params.pop("cabinetid")
            cabinetvalue = cabinetid
        else:
            cabinetvalue = params.pop("cabinetname")
            queryParams += "&cabinetname=" + cabinetvalue

        url="{0}/cabinet/{1}/ports"

        if len(queryParams)>0:
            url += "?" + queryParams[1:]

        response = self.HTTP.get(url.format(host, cabinetid))

        if not response:
            cl.perr("Failed to retrieve cabinet port information from cabinet: " + cabinetvalue)
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_update_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="cabinetname")
        try:
            ecli.validate_parameters("cabinet", "update", params, strict=False)
        except Exception as e:
            cl.perr(str(e))
            return
        query_param = ""
        if "force" in params:
            query_param = "?force="+params["force"]
        cabinetname = params.pop("cabinetname")
        response = self.HTTP.put("{0}/cabinet/{1}{2}".format(host, cabinetname, query_param), json.dumps(params), "cabinet")
        if response:
            cl.prt("n", json.dumps(response))
  
    def do_getinfo_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('cabinet', 'get', params)
        except Exception as e:
            cl.perr(str(e))
            return

        cabinetname = params.pop("cabinetname")
        response = self.HTTP.get("{0}/cabinet/{1}".format(host, cabinetname))

        if not response:
            cl.perr("Failed to retrieve cabinet information from cabinet: " + cabinetname)
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_updatexml_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="cabinetname")
        try:
            ecli.validate_parameters("cabinet", "updatexml", params, strict=False)
        except Exception as e:
            cl.perr(str(e))
            return

        cabinetname = params.pop("cabinetname")
        response = self.HTTP.put("{0}/cabinet/updatexml/{1}".format(host, cabinetname), json.dumps(params), "cabinet")
        if not response:
            cl.perr("Failed to update cabinet xml information for cabinet: " + cabinetname)
            return
        cl.prt("n", json.dumps(response))

    def do_getxml_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="cabinetname")
        try:
            ecli.validate_parameters("cabinet", "getxml", params)
        except Exception as e:
            cl.perr(str(e))
            return

        cabinetname = params["cabinetname"]
        response = self.HTTP.get("{0}/cabinet/{1}/xml".format(host, cabinetname))
        if not response:
            cl.perr("Failed to get xml for cabinet: " + cabinetname)
            return

        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_model_subtype_convert(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        self.model_subtype_convert_request(ecli, params, host)

    def do_model_subtype_convert_large(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        params['modelsubtype'] = "LARGE"
        params['nodetype'] = "COMPUTE"
        self.model_subtype_convert_request(ecli, params, host)

    def do_model_subtype_convert_extralarge(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        params['modelsubtype'] = "EXTRALARGE"
        params['nodetype'] = "COMPUTE"
        self.model_subtype_convert_request(ecli, params, host)

    def do_model_subtype_convert_cell_z(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        params['modelsubtype'] = "Z"
        params['nodetype'] = "CELL"
        self.model_subtype_convert_request(ecli, params, host)

    def do_model_subtype_convert_cell_ef(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        params['modelsubtype'] = "EF"
        params['nodetype'] = "CELL"
        self.model_subtype_convert_request(ecli, params, host)

    def do_model_subtype_convert_standard(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        params['modelsubtype'] = "STANDARD"
        self.model_subtype_convert_request(ecli, params, host)

    def do_model_subtype_get_report(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('cabinet', ['modelsubtype', 'getreport'], params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/cabinet/modelsubtype/{1}?model_subtype={2}&model={3}".format(host, params["nodetype"], params["modelsubtype"], params["model"])
        if "cabinetname" in params:
            url = "{0}/cabinet/modelsubtype/{1}?model_subtype={2}&model={3}&cabinetname={4}".format(host, params["nodetype"], params["modelsubtype"], params["model"],params["cabinetname"])
        response = self.HTTP.get(url)
        if not response:
            cl.perr("Failed to retrieve the report")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


    def do_model_subtype_release_nodes(self, ecli, line, host):        
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('cabinet', ['modelsubtype', 'releasenodes'], params)
        except Exception as e:
            cl.perr("Submit Failed: " + str(e))
            return
        
        urlStr="{0}/cabinet/modelsubtype/release"
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(urlStr.format(host), data, "cabinet")

        if not response:
            cl.perr("Failed to Release the nodes.")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def model_subtype_convert_request(self, ecli, params, host):
        #Validate the parameters
        try:
            ecli.validate_parameters('cabinet', ['modelsubtype', 'convert'], params) 
        except Exception as e:
            cl.perr(str(e))
            return
        
        # validate the different combinations if it does not affect the help information
        params['model_subtype'] = params['modelsubtype']
        params.pop('modelsubtype')
        urlStr="{0}/cabinet/modelsubtype/convert"
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(urlStr.format(host), data, "cabinet")

        if not response:
            cl.perr("Failed to retrieve cabinet elastic information for node type.") #correct the error message
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_composexml_cabinet(self, ecli, line, host):
        #Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'composexml', params) 
        except Exception as e:
            cl.perr(str(e))
            return
        
        url="{0}/cabinet/{1}/composexml"
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "cabinet", url.format(host, params["cabinetname"]))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


    def do_get_domu_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="dom0")
        try:
            ecli.validate_parameters('cabinet', ['domu', 'get'], params)
        except Exception as e:
            cl.perr(str(e))
            return

        dom0 = params["dom0"]
        response = ecli.issue_get_request("{0}/cabinet/domu/{1}".format(host, dom0), False)
        headers = ["<admin_nat_host_name>","<admin_nat_ip>","<db_client_mac>","<db_backup_mac>","<admin_vlan_tag>"]
        maxLength = [
            len(headers[0]),
            len(headers[1]),
            len(headers[2]),
            len(headers[3]),
            len(headers[4])
            ]
        for domu in response["domus"]:
            if len(domu['admin_nat_host_name']) > maxLength[0]:
                maxLength[0]=len(domu['admin_nat_host_name'])
            if len(domu['admin_nat_ip']) > maxLength[1]:
                maxLength[1]=len(domu['admin_nat_ip'])
            if len(domu['db_client_mac']) > maxLength[2]:
                maxLength[2]=len(domu['db_client_mac'])
            if len(domu['db_backup_mac']) > maxLength[3]:
                maxLength[3]=len(domu['db_backup_mac'])


        cl.prt("b", " {0} : {1} : {2} : {3} : {4}".format(headers[0].ljust(maxLength[0]),
                                                     headers[1].ljust(maxLength[1]),
                                                     headers[2].ljust(maxLength[2]),
                                                     headers[3].ljust(maxLength[3]),
                                                     headers[4].ljust(maxLength[4])))
        for domu in response["domus"]:
            cl.prt("c", " {0} : {1} : {2} : {3} : {4} ".format(domu['admin_nat_host_name'].ljust(maxLength[0]),
                                                         domu['admin_nat_ip'].ljust(maxLength[1]),
                                                         domu['db_client_mac'].ljust(maxLength[2]),
                                                         domu['db_backup_mac'].ljust(maxLength[3]),
                                                         " " if domu.get('admin_vlan_tag') is None else domu['admin_vlan_tag'].ljust(maxLength[4]) ))

    def do_update_domu_cabinet(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="hostname")
        try:
            ecli.validate_parameters('cabinet', ['domu', 'update'], params)
        except Exception as e:
            cl.perr(str(e))
            return

        hostname = params.pop('hostname')


        urlStr="{0}/cabinet/domu/{1}"
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(urlStr.format(host, hostname), data, "cabinet")
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


    def do_softdeletenode_cabinet(self, ecli, line, host):
        #Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'softdeletenode', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url="{0}/cabinet/{1}/softdelete/{2}"
        cabinetname = params.pop("cabinetname")
        hostname = params.pop("hostname")
        response = self.HTTP.put(url.format(host, cabinetname, hostname), json.dumps(params), "cabinet")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getnodes_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'getnodes', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/{1}/nodestatus"
        cabinetname = params.pop("cabinetname")
        response = self.HTTP.get(url.format(host, cabinetname))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_recovernode_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'recovernode', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/{1}/recovernode/{2}"
        cabinetname = params.pop("cabinetname")
        hostname = params.pop("hostname")
        response = self.HTTP.put(url.format(host, cabinetname, hostname), json.dumps(params), "cabinet")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_purgenode_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'purgenode', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/{1}/purgenode/{2}"
        cabinetname = params.pop("cabinetname")
        hostname = params.pop("hostname")
        response = self.HTTP.put(url.format(host, cabinetname, hostname), json.dumps(params), "cabinet")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getnodestatusreport_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'getnodestatusreport', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/nodestatusreport"
        response = self.HTTP.get(url.format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getnodearchivedreason_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'getnodearchivedreason', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/archivednodeinfo/{1}"
        hostname = params.pop("hostname")
        response = self.HTTP.get(url.format(host,hostname))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_updatenodearchivedreason_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'updatenodearchivedreason', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/archivednodeinfo/{1}"
        hostname = params.pop("hostname")
        response = self.HTTP.put(url.format(host, hostname), json.dumps(params), "cabinet")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_getnodearchivedextrainfo_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'getnodearchivedextrainfo', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/extranodeinfo/{1}"
        hostname = params.pop("hostname")
        response = self.HTTP.get(url.format(host, hostname))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_updatenodearchivedextrainfo_cabinet(self, ecli, line, host):
        # Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'updatenodearchivedextrainfo', params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/cabinet/extranodeinfo/{1}"
        hostname = params.pop("hostname")
        payload = json.load(open(params["extrainfojsonpath"]))
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put(url.format(host, hostname), data, "cabinet")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_ingestion_cabinet(self, ecli, line, host):
        #Validate the parameters
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('cabinet', 'ingestion', params)
        except Exception as e:
            cl.perr(str(e))
            return
        jsonPayload = {}
        xmlPath = params["xml"]
        flatfilePath = params["flatfile"]

        #Validate both files path are valid
        xmlObject = Path(xmlPath)
        flatfileObject = Path(flatfilePath)
        if not xmlObject.is_file() or not flatfileObject.is_file():
            cl.perr("One or both of the given path for xml/flatfile are not valid")
            return
        
        #Get Idemtoken
        headers = {}
        if "idemtoken" in params:
            headers["idemtoken"] = params.pop("idemtoken")
        else:
            headers["idemtoken"] = ecli.getNewIdemtoken()
 
        if headers["idemtoken"] is None:
            cl.perr("Could not get idemtoken")
            return      

        #Get the XML file and converted to base64    
        with open(xmlPath, 'rb') as xmlfile:
            xmlfile_content = xmlfile.read()
            xml_base64 = base64.b64encode(xmlfile_content).decode("utf-8")
            jsonPayload["xml"] = xml_base64
        
        #Get the Flatfile
        flatfileContent = None
        isJsonFormat = False
        
        #Check if it is a valid Json Format
        try:
            with open(flatfilePath, "r") as f:
                flatfileContent = f.read()
            json.loads(flatfileContent)
            isJsonFormat = True
        except Exception:
            isJsonFormat = False

        if isJsonFormat:
            jsonPayload["flatfile"] = flatfileContent
        else:
            jsonPayload["flatfile"] = self.convert_flatfile_to_json(flatfilePath)
        

        url="{0}/cabinet/ingestion"

        data = json.dumps(jsonPayload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "cabinet", url.format(host), headers)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def convert_flatfile_to_json(self,flatfilePath):
        result = {}
        nodes = []
        ersIp = []
        in_nodes = False
        in_ers = False
        gateway = subnetMask = subnetId = vcnId = None
        dns = []
        ntp = []
        computeModelSubtype = None
        cellModelSubtype = None
        swVersion = None
        
        # Helper for camelCase conversion
        def cc(s):
            parts = s.lower().split('_')
            return parts[0] + ''.join(x.title() for x in parts[1:])

        camel_map = {
            "AD": "ad",
            "BLOCK_NUMBER": "blockNumber",
            "CABINETNUMBER": "cabinetNumber",
            "CABINETSERIAL": "cabinetSerial",
            "CAGE_ID": "cageId",
            "CANONICAL_BUILDING": "canonicalBuilding",
            "CANONICAL_ROOM": "canonicalRoom",
            "CELL_MODEL_SUBTYPE": "cellModelSubtype",
            "COMPUTE_MODEL_SUBTYPE": "computeModelSubtype",
            "DOMAINNAME": "domainName",
            "FABRIC_NAME": "fabricName",
            "FD": "faultDomain",
            "MODEL": "model",
            "NODE_LIST": "clusterSizeConstraint",
            "PRODUCT": "product",
            "TIMEZONE": "timezone",
            "SITEGROUP": "sitegroup",
            "ETH0": "eth0",
            "ELASTIC_FLEX": "elasticFlex",
            "SUBNET_MASK": "subnetMask",
            "DNS": "dns",
            "NTP": "ntp",
            "GATEWAY": "gateway",
            "VCN_ID": "vcnId",
            "VCN_SUBNET": "vcnSubnet",
            "SW_VERSION": "swVersion",
            }

        # Open the flatfile location 
        with open(flatfilePath, 'r') as f:
            lines = f.readlines()

        # Loop to read each line in flatfile
        for line in lines:
            line = line.strip()
            if not line or line.startswith("#"):
                if "# CABINET_NODES" in line:
                    in_nodes = True
                    in_ers = False
                elif "# Exascale ERS IP addresses" in line:
                    in_ers = True
                    in_nodes = False
                continue
            if in_nodes:
                tokens = line.split()
                if tokens:
                    node = {}
                    eth1 = {}
                    eth2 = {}
                    index = 0
                    def next_token():
                        nonlocal index
                        val = tokens[index] if len(tokens) > index else ""
                        index += 1
                        return val
                    node["nodeType"] = next_token()
                    node["bottomUpOrder"] = next_token()
                    node["unitLoc"] = next_token()
                    node["adminIp"] = next_token()
                    
                    if node["nodeType"] == "cell":
                        node["ilomIp"] = next_token()
                        sixth = next_token() if len(tokens) > index else ""
                        # If the 6th element has ip format
                        # Means that stre values are present
                        if re.match(r'^\d+\.\d+\.\d+\.\d+$', sixth):
                            node["stre0"] = sixth
                            node["stre1"] = next_token()
                            node["modelSubtype"] = cellModelSubtype if cellModelSubtype is not None else next_token()
                        else:
                            node["stre0"] = ""
                            node["stre1"] = ""
                            node["modelSubtype"] = cellModelSubtype if cellModelSubtype is not None else sixth
                        node["swVersion"] = swVersion

                    elif node["nodeType"] == "compute":
                        node["smartnics"] = []
                        node["ilomIp"] = next_token()
                        node["adminNatDomu01"] = next_token()
                        # Create eth1 and eth2 objects
                        eth1["serial"] = next_token()
                        eth2["serial"] = next_token()
                        eth1["mac"] = next_token()
                        eth2["mac"] = next_token()
                        eth1["vmMac"] = next_token()
                        eth2["vmMac"] = next_token()
                        eth1["active"] = True if next_token() == "eth1" else False # Ignored value
                        eth2["active"] = False if next_token() == "eth2" else True # Ignored value
                        eth1["ip"] = next_token()
                        eth2["ip"] = next_token()
                        node["smartnics"].append(eth1)
                        node["smartnics"].append(eth2)
                        node["modelSubtype"] = computeModelSubtype if computeModelSubtype is not None else next_token()
                        node["swVersion"] = swVersion                                        
                    nodes.append(node)
                continue
            if in_ers:
                tokens = line.split()
                if len(tokens) >= 3:
                    ersIp.append({
                        "name": tokens[0],
                        "ip": tokens[1],
                        "ocid": tokens[2]
                    })
                else:
                    #Exception
                    cl.perr("ERROR: Found '# Exascale ERS IP addresses' header without information")
                    return
                continue
            if '=' in line:
                k, v = line.split("=", 1)
                k, v = k.strip(), v.strip()
                key = camel_map.get(k, cc(k))
                # Handle new structure/booleans
                if key == "computeModelSubtype" :
                    computeModelSubtype = v
                elif key == "cellModelSubtype" :
                    cellModelSubtype = v
                elif key == "swVersion" :
                    swVersion = v                    
                # Values that will be in subnetInfo section     
                elif key in ("gateway", "subnetMask", "subnetId", "vcnId"):
                    if key == "gateway": gateway = v
                    elif key == "subnetMask": subnetMask = v
                    elif key == "subnetId": subnetId = v
                    elif key == "vcnId": vcnId = v
                # Creating DNS array    
                elif key == "dns":
                    dns.append(v)
                # Creating NTP array
                elif key == "ntp":
                    ntp.append(v)
                elif key == "eth0":
                    result[key] = v.upper() == "TRUE" or v.upper() == "ENABLED"
                elif key == "elasticFlex":
                    result[key] = v.upper() == "TRUE"
                else:
                    result[key] = v
        # Compose new JSON format
        result["dns"] = dns
        result["ntp"] = ntp
        result["subnetInfo"] = {
            "gateway": gateway or "",
            "subnetMask": subnetMask or "",
            "subnetId": subnetId or "",
            "vcnId": vcnId or ""
        }
        result["nodes"] = nodes
        result["ersIp"] = ersIp
        return result

