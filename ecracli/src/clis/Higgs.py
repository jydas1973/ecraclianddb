"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Higgs - CLIs to operate on Higgs control plane

FUNCTION:
    Provides the clis to get a network and create a property

NOTE:
    None

History:
    rgmurali    08/15/20 - Bug 31536477 - Fix fortify issues
    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
    llmartin    04/04/18 - Bug 27759881 - Higgs: NAT ip secrules
    jreyesm     04/17/18 - Bug 27351303. Add higgs subnet ignore functionality
    brsudars    04/08/18 - bug 27780209 - Remove instName param check from setHiggsPayloadForCreate (multi-vm) as the
                           name param is the TAS service name and has no relation with Higgs. Move to Exaservice.
    llmartin    03/07/18 - Bug 27186959 - Add flags for client/backup network and subscriptionId.
    jreyesm     02/15/18 - Bug 27520916 - NodevIps/scanvIps generation
    rgmurali    02/01/18 - Bug 27275671 - Use compute endpoint from TAS payload
    brsduars    01/04/17 - Bug 27331792 - Support mutli-vm
    jreyesm     11/17/17 - Bug 27137450. Add Higgs register/deregister.
    jreyesm     11/09/17 - Bug 27090986. Add Higgs prepare bond0 functionality.
    rgmurali    10/24/17 - Bug 26823575 - Add APPID support for higgs.
    rgmurali    04/29/17 - Create file
"""

from formatter import cl
from os import path
import re
import os
import json
import sys
import base64

import SysCURL as curl
import defusedxml.ElementTree as et

class Higgs:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_deregister_higgs(self, ecli, line , host):
        line = line.split(' ', 1)
        rack_name, rest = line[0], line[1] if len(line) > 1 else ""
        if not rack_name:
            cl.perr("Missing rack name." )
            return

        params = ecli.parse_params(rest, None)
        rack_type = "singlevm"
        if "rack_type" in params and params["rack_type"]:
            rack_type = params["rack_type"].lower()

        if (rack_type != "multivm") and (rack_type != "singlevm"):
            cl.perr("Invalid value for rack_type:" + rack_type + ".Please specify one of: singlevm, multivm");
            return
        payload = {}
        payload["rack_type"] = rack_type
        payloadJson = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/subscriptions/higgs/{1}/register".format(host,rack_name), payloadJson)
        if response:
            cl.prt("n", json.dumps(response))

    def get_rack_xml_content(self, ecli, host, rack_name):
        rack_xml_content = None
        if not rack_name.endswith(".xml") and rack_name not in ecli.racks:
            rack_info = ecli.issue_get_request("{0}/racks?name={1}&verbose=true".format(host, rack_name), printResponse=False)
            if rack_info and len(rack_info["racks"]) == 1:
                rack_xml_content = str(rack_info["racks"][0]["xml"])
            else :
                cl.perr("Could not find rack: '%s'" % rack_name)
                return None
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
        return rack_xml_content

    def get_exadata_xml_content(self, ecli, host, exadata_name):
      response = ecli.issue_get_request("{0}/capacity/details?exadata_id={1}&all=y".format(host, exadata_name), printResponse=False)
      if not response or not response["exadata"]:
        cl.perr("Failed to get exadata XML content")
        return None

      exadata_list = response["exadata"]
      exadata_info = exadata_list[0]
      tmpl_xml_64 = exadata_info["tmpl_xml"]
      tmpl_xml = base64.b64decode(tmpl_xml_64)
      return tmpl_xml

    # get info about a particular network
    def do_get_network(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "getNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        subscriptionId = params.pop("subscriptionId")

        if "network_username" in params and params["network_username"]:
            netUser = params["network_username"]
        else:
            netUser = "administrator"

        params["network_username"] = "/Compute-" + subscriptionId + "/" + netUser + "/"

        query_str = "?"
        for param in params:
            query_str = query_str + param + "=" + params[param] + "&"
        query_str = query_str[:-1]
        ecli.issue_get_request("{0}/subscriptions/{1}/higgs/networkbyname{2}".format(host, subscriptionId, query_str), True)

    # get info about all networks for a customer
    def do_getall_network(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "getAllNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        subscriptionId = params.pop("subscriptionId")

        if "network_username" in params and params["network_username"]:
            netUser = params["network_username"]
        else:
            netUser = "administrator"

        params["network_username"] = "/Compute-" + subscriptionId + "/" + netUser + "/"

        query_str = "?"
        for param in params:
            query_str = query_str + param + "=" + params[param] + "&"
        query_str = query_str[:-1]
        ecli.issue_get_request("{0}/subscriptions/{1}/higgs/networks{2}".format(host, subscriptionId, query_str), True)

    def do_create_network(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")
        subscriptionId = params["subscriptionId"]

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "createNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "network_username" in params and params["network_username"]:
            netUser = params["network_username"]
        else:
            netUser = "administrator"

        params["network_username"] = "/Compute-" + subscriptionId + "/" + netUser + "/"
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/subscriptions/{1}/higgs/networks/".format(host,subscriptionId), data, "higgs")
        if response:
            cl.prt("n", json.dumps(response))

    # delete a particular network
    def do_delete_network(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "deleteNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return
        subscriptionId = params.pop("subscriptionId")
        if "network_username" in params and params["network_username"]:
            netUser = params["network_username"]
        else:
            netUser = "administrator"

        params["network_username"] = "/Compute-" + subscriptionId + "/" + netUser + "/"
        data = json.dumps(params, sort_keys=True, indent=4)    
        response = self.HTTP.delete("{0}/subscriptions/{1}/higgs/networks/".format(host, subscriptionId), data)
        if response:
            cl.prt("n", json.dumps(response))

    # delete all the higgs resources
    def do_delete_resources(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "deleteResources", params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        subscriptionId = params.pop("subscriptionId")
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/subscriptions/{1}/higgs/resources/".format(host, subscriptionId), data)
        if response:
            cl.prt("n", json.dumps(response))

    #create natips
    def do_create_natvips(self, ecli, line, host):
        line = line.split(' ', 1)
        rackName, rest = line[0], line[1] if len(line) > 1 else ""
        if not rackName:
            cl.perr("Mandatory parameters missing - rackName")
            return
        params = ecli.parse_params(rest, None, False)
        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "createNatvips", params)
        except Exception as e:
            cl.perr(str(e))
            return
        query_str=""
        if 'target' in params:
            query_str = "?target="+params['target']

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/subscriptions/higgs/{1}/natvipcreation{2}".format(host,rackName,query_str), data, "higgs")
        if response:
            cl.prt("n", json.dumps(response))
    # delete natips
    def do_delete_natvips(self, ecli, line, host):
        line = line.split(' ', 1)
        rackName, rest = line[0], line[1] if len(line) > 1 else ""
        if not rackName:
            cl.perr("Mandatory parameters missing - rackName")
            return
        params = ecli.parse_params(rest, None, False)
        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "deleteNatvips", params)
        except Exception as e:
            cl.perr(str(e))
            return
        query_str=""
        if 'target' in params:
            query_str = "?target="+params['target']

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/subscriptions/higgs/{1}/natvipcreation{2}".format(host,rackName,query_str), data)
        if response:
            cl.prt("n", json.dumps(response))

    #List natips for the specified rack
    def do_list_natvips(self, ecli, line, host):
        query_str = ""
        line = line.split(' ', 1)
        rackName, rest = line[0], line[1] if len(line) > 1 else ""
        if not rackName:
            cl.perr("Mandatory parameters missing - rackName")
            return
        params = ecli.parse_params(rest, None, False)
        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "listNatvips", params)
        except Exception as e:
            cl.perr(str(e))
            return
        query_str=""
        if 'target' in params:
            query_str = "?target="+params['target']

        ecli.issue_get_request("{0}/subscriptions/higgs/{1}/natvipcreation{2}".format(host,rackName,query_str), True)


    def do_add_ibsubnet(self, ecli, line, host):
        pattern= "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}" #validates strings like 192.168.0.0/24
        ecraProp = "HIGGS_IB_SUBNET"
        line = line.split(' ', 1)
        ibsubnet, rest = line[0], line[1] if len(line) > 1 else ""
        if not ibsubnet:
            cl.perr("Mandatory parameter missing - ibsubnet")
            return
        if re.compile(pattern).match(ibsubnet) is None:
            cl.perr("Invalid ibsubnet " + ibsubnet + ". Use form like 192.168.0.0/24")
            return

        prop = ecli.issue_get_request("{0}/properties/{1}".format(host, ecraProp),False)
        propValue = prop.get('property_value','')
        if len(propValue) == 0:
            propValue = ibsubnet
        else:
            propValue = propValue + "," + ibsubnet

        response = self.HTTP.put("{0}/properties/{1}".format(host,ecraProp), json.dumps({"value":propValue}), "ecsproperties")
        if response:
            cl.prt("n", json.dumps(response))
            ecli.issue_get_request("{0}/properties/{1}".format(host, ecraProp))


    def do_delete_ibsubnet(self, ecli, line, host):
        ecraProp = "HIGGS_IB_SUBNET"
        line = line.split(' ', 1)
        ibsubnet, rest = line[0], line[1] if len(line) > 1 else ""
        if not ibsubnet:
            cl.perr("Mandatory parameter missing - ibsubnet")
            return
        
        prop = ecli.issue_get_request("{0}/properties/{1}".format(host, ecraProp),False)
        propValue = prop.get('property_value','')
        
        if not ibsubnet in propValue:
            cl.perr("Unable to find ibsubnet: " + ibsubnet + " in " + propValue)
            return
        subnets = propValue.split(',')
        subnets.remove(ibsubnet)
        propValue = ",".join(subnets)

        response = self.HTTP.put("{0}/properties/{1}".format(host,ecraProp), json.dumps({"value":propValue}), "ecsproperties")
        if response:
            cl.prt("n", json.dumps(response))
            ecli.issue_get_request("{0}/properties/{1}".format(host, ecraProp))
    

    @staticmethod
    def setHiggsPayloadForCreate(mytmpldir, svcJson, sspList, params):

        if not mytmpldir:
            cl.perr("Error: Template directory not defined")
            return False

        service_components = os.path.join(mytmpldir, "service_components.xml")
        payload = open(service_components).read()
        root = et.fromstring(re.sub('xmlns="\w*"', '', payload))
        # Higgs network names
        clientNet = None
        backupNet = None
        # subscription id
        subId = None

        for key in root.iter("serviceSpecificProps"):
            if key[0].text.lower() == "clientnetwork":
                clientNet = key[1].text
            elif key[0].text.lower() == "backupnetwork":
                backupNet = key[1].text

        for key in root.iter("mosPayload"):
            if key[0].text == "subscription.id":
                subId = key[1].text

        if "client_nw" in params and params["client_nw"]:
            clientNet = params["client_nw"]

        if "backup_nw" in params and params["backup_nw"]:
            backupNet = params["backup_nw"]
        # TAS send the entity id in production flow which ecra uses as subscription id
        if "entity_id" in params and params["entity_id"]:
            subId = params["entity_id"]

        ipNetworks = "N"
        if "ipNet" in params and params["ipNet"]:
            ipNetworks = params["ipNet"].upper()
            if not ipNetworks in ("Y", "N"):
                cl.perr(ipNetworks + " is not a valid option for ipNet : [Y, N]")
                return False
        else:
            params["ipNet"] = "N"

        # Note: ipNet is not part of payload to ecra
        if params["ipNet"] == "Y":
            sspList.append({"name": "ClientNetwork", "value": clientNet})
            sspList.append({"name": "BackupNetwork", "value": backupNet})

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
        if 'higgs_url' in params and params["higgs_url"]:
            higgsUrl = params['higgs_url']
        
        appidList.append({"name": appidUser, "value": appidPwd})
        svcJson["app_id_credentials"] = appidList
        linksList.append({"uri" : higgsUrl, "type" : "REST_INTERNAL"})
        # dependent_links element needed for higgs payload
        depenList.append({"entity_id": subId, "service_type": "Compute", "links" : linksList})
        svcJson["dependent_links"] = depenList

        adminUser = None
        if "admin_username" in params and params["admin_username"]:
            adminUser = params["admin_username"]
        svcJson["admin_username"] = adminUser

        return True

    # Secure rules
    def do_create_secrule(self, ecli, line, host):
        cl.prt("r", "WARNING: Opening up SSH and SQLNet traffic to the domU from the whole Internet")

        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "createSecrule", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            # Load json file
            cl.prt("r", "WARNING: Json file provided, the other parameters will be ignored.")
            rulesData = json.load(open(params["json_path"]))
        else:      
            #Build json data.
            rulesData = {}

            if "secProtocols" in params:
                params["secProtocols"] = params["secProtocols"].split(",")

            if "srcIpAddressPrefixSets" in params:
                params["srcIpAddressPrefixSets"] = params["srcIpAddressPrefixSets"].split(",")

            if "dstIpAddressPrefixSets" in params:
                params["dstIpAddressPrefixSets"] = params["dstIpAddressPrefixSets"].split(",")

            rulesData["rules"] = [params]

        # Authentication
        cmd_cookie = curl.auth(params)

        # Iterate the list
        for item in rulesData["rules"]:

            if "name" not in item:
                cl.perr("Missing mandatory parameter 'name'")
                continue
            
            cl.prt("g", "Creating SecureRule: {0}".format(item["name"]))

            # Build query
            resPrefix = "/Compute-{0}/{1}/".format(params["subscriptionId"],params["admin_username"])
            cmd_url = params["higgs_url"]+"network/v1/secrule/"

            # Headers
            cmd_headers=[]
            cmd_headers.append(curl.CONTTYPE_HEADER)
            cmd_headers.append("X-Oracle-Compute-As: " + resPrefix)

            # security protocols
            secProtocols = []
            if "secProtocols" in item:
                for protocol in item["secProtocols"]:
                    secProtocols.append(resPrefix+protocol)

            #srcIpAddressPrefixSets 
            srcIpAddressPrefixSets = []
            if "srcIpAddressPrefixSets" in item:
                for srcIpAddressPrefix in item["srcIpAddressPrefixSets"]:
                    srcIpAddressPrefixSets.append(resPrefix+srcIpAddressPrefix)

            #srcIpAddressPrefixSets 
            dstIpAddressPrefixSets = []
            if "dstIpAddressPrefixSets" in item:   
                for dstIpAddressPrefix in item["dstIpAddressPrefixSets"]:
                    dstIpAddressPrefixSets.append(resPrefix+dstIpAddressPrefix)
                
            # data
            cmd_data = {}
            cmd_data["name"] = resPrefix + item["name"]

            if "flowDirection" in item:
                cmd_data["flowDirection"] = item["flowDirection"]
            else:
                cmd_data["flowDirection"] = "ingress"

            if "acl" in item:
                cmd_data["acl"] =  resPrefix + item["acl"]
            
            cmd_data["secProtocols"] = secProtocols
            cmd_data["srcIpAddressPrefixSets"] = srcIpAddressPrefixSets
            cmd_data["dstIpAddressPrefixSets"] = dstIpAddressPrefixSets
            cmd_data["enabledFlag"] = "true"

            if "dstVnicSet" in item and item["dstVnicSet"] is not None:
                cmd_data["dstVnicSet"] = resPrefix + item["dstVnicSet"]

            if "srcVnicSet" in item and item["srcVnicSet"] is not None:
                cmd_data["srcVnicSet"] = resPrefix + item["srcVnicSet"]

            str_cmd_data = json.dumps(cmd_data)
            output = curl.system_curl(cmd_url,"POST", cmd_headers, str_cmd_data, cmd_cookie)
            cl.prt("c", output)

    def do_delete_secrule(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "deleteSecrule", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Authentication
        cmd_cookie = curl.auth(params)

        # Build query
        resPrefix = "/Compute-{0}/{1}/".format(params["subscriptionId"],params["admin_username"])
        cmd_url = params["higgs_url"]+"network/v1/secrule" + resPrefix + params["name"]

        # Headers
        cmd_headers=[]
        cmd_headers.append(curl.CONTTYPE_HEADER)
        cmd_headers.append("X-Oracle-Compute-As: " + resPrefix)

        output = curl.system_curl(cmd_url,"DELETE", cmd_headers, None, cmd_cookie)
        
        if output is not None:
            cl.prt("r", output)


    def do_get_secrule(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "getSecrule", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Authentication
        cmd_cookie = curl.auth(params)

        # Build query
        resPrefix = "/Compute-{0}/{1}/".format(params["subscriptionId"],params["admin_username"])
        cmd_url = params["higgs_url"]+"network/v1/secrule" + resPrefix + params["name"]

        # Headers
        cmd_headers=[]
        cmd_headers.append(curl.CONTTYPE_HEADER)
        cmd_headers.append("X-Oracle-Compute-As: " + resPrefix)

        output = curl.system_curl(cmd_url,"GET", cmd_headers, None, cmd_cookie)
        cl.prt("n", output)

    def do_get_resources(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "getResources", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Authentication
        cmd_cookie = curl.auth(params)

        # Build query
        resPrefix = "/Compute-{0}/{1}/".format(params["subscriptionId"],params["admin_username"])
        cmd_url = params["higgs_url"] + "network/v1/" +params["resource_type"] + resPrefix

        # Headers
        cmd_headers=[]
        cmd_headers.append(curl.CONTTYPE_HEADER)
        cmd_headers.append("X-Oracle-Compute-As: " + resPrefix)

        response = curl.system_curl(cmd_url,"GET", cmd_headers, None, cmd_cookie)
        jsonResponse =json.loads(response)


        if "result" in jsonResponse:
            count=1
            for item in jsonResponse["result"]:
                cl.prt("n", "{0}\tNAME: {1} \n\tURI: {2}".format(count,item["name"],item["uri"]))  
                count+=1
        else:
            cl.prt("r", "The response does not contain the 'result' section.")

    def do_remove_resource(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "removeResource", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Authentication
        cmd_cookie = curl.auth(params)

        # Build query
        resPrefix = "/Compute-{0}/{1}/".format(params["subscriptionId"],params["admin_username"])
        cmd_url = params["name"]

        # Headers
        cmd_headers=[]
        cmd_headers.append(curl.CONTTYPE_HEADER)
        cmd_headers.append("X-Oracle-Compute-As: " + resPrefix)

        response = curl.system_curl(cmd_url,"DELETE", cmd_headers, None, cmd_cookie)
        cl.prt("c", response)

    def do_create_secprotocol(self, ecli, line, host):
        params = ecli.parse_params(line, "higgsParams", False,"subscriptionId")

        # Validate the parameters
        try:
            ecli.validate_parameters("higgs", "createSecprotocol", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Authentication
        cmd_cookie = curl.auth(params)

        # Build query
        cmd_url = params["higgs_url"]+"network/v1/secprotocol/"

        cmd_headers=[]
        cmd_headers.append(curl.CONTTYPE_HEADER)
        cmd_headers.append("X-Oracle-Compute-As: /Compute-{0}/{1}".format(params["subscriptionId"], params["admin_username"]))

        # data
        cmd_data = {}

        cmd_data_name="/Compute-{0}/{1}/Inst1_{2}_sqlnet".format(params["subscriptionId"],params["admin_username"],params["rack"])
        cmd_data["name"] = cmd_data_name
        cmd_data["ipProtocol"] = params["ipProtocol"]

        dstPortSetList = params["dstPortSet"].split(",")
        cmd_data["dstPortSet"] = dstPortSetList

        str_cmd_data = json.dumps(cmd_data)

        output = curl.system_curl(cmd_url,"POST", cmd_headers, str_cmd_data, cmd_cookie)
        cl.prt("n", output)

