"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    Rack - CLIs for operations on the rack

FUNCTION:
    Provides the clis to perform actions such as register, reserve, update etc on rack
NOTE:
    None

History:
    hcheon      11/17/25 - 38466555 Sanitycheck for ready racks
    gvalderr    10/30/24 - Enh 37025137 - Changing operators to be compatible
                           with python 3.8
    Enh 34235229 - Patch XML with missing nodes
    zpallare    01/09/24 - Enh 36166029 - ECRACLI - Create ecracli commands to update xml
    jzandate    11/15/22 - Bug 34700954 - Adding rack drop to ecracli
    ririgoye	07/21/22 - Enh 34349156 - Let ECRACLI return info from an external xml given a file path
    aadavalo    02/23/22 - Enh 33846431 - EXACS - ADD ECRACLI COMMAND TO GET
                           INFO FROM XML
    marcoslo    11/30/2020 - ER 31712130 - create XML for compose elastic rack
    rgmurali    08/15/2020 - Bug 31536477 - Fix fortify issues
    marcoslo    08/08/2020 - ER 30613740 Update code to use python 3
    rgmurali    05/14/20 - ER 30952096 - Support dbsystemId in delete service
    jloubet     11/21/19 - Enh 30564557 Adding centralized regex for exadata validation
    llmartin    08/13/19 - Enh 30175171 Rack cli to dump XML to the file system
    rgmurali    04/01/19 - ER 29530642 Support for move capacity
    mpedapro    01/09/2019 - bug 28971555 : add do_updatecavium_rack
    sgundra     03/09/18   - Opstate fix
    rgmurali    07/14/2017 - Create file
"""
from formatter import cl
import json
import os
from os import path
import re
import sys
import defusedxml.ElementTree as et

class Rack:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def findDom0Domu(self, root):
        nodes = root.findall("software/clusters/cluster/clusterVips/clusterVip/machines/machine")
        domu_ids = [domu_node.attrib["id"] for domu_node in nodes]
        dom0s = []
        domus = []

        machines = root.findall("machines/machine")
        for machine in machines:
            if machine.attrib["id"] in domu_ids:
                domus.append(machine.find("hostName").text)
            elif len(machine.findall("machine")) != 0:
                #Machine have list of DomU, find match and add to dom0 list
                for _domUofDom0 in machine.findall("machine"):
                    if (_domUofDom0.attrib["id"] in domu_ids):
                        dom0s.append(machine.find("hostName").text)
                        break
        dom0s = [dom0.split(".", 1)[0] for dom0 in dom0s]
        domus = [domu.split(".", 1)[0] for domu in domus]
        return "".join(sorted(dom0s)), "".join(sorted(domus))

    def get_param_rack_operation(self, ecli, line):
        rack_xml_path = None
        rack_name     = None
        rest = ''
        if "rackname" in line:
            line = line.split(' ', 1)
            rackname_param = ecli.parse_params(line[0], None)
            if type(rackname_param) is  str or not rackname_param['rackname']:
                cl.perr("Rack name must be provided with rackname parameter")
            else:
                rack_name = rackname_param.pop("rackname")
                rest = "".join(line[1:]) if len(line) > 1 else ""
                if ecli.verbose :
                    cl.prt ("n", "[Verbose] rackname param = " + rack_name)
        elif "rackxmlpath" in line:
            line = line.split(' ', 1)
            xml_param = ecli.parse_params(line[0], None)
            if type(xml_param) is str or not xml_param['rackxmlpath']:
                cl.perr("Rack xml file must be provided with rackxmlpath parameter")
            else:
                rack_xml_path = xml_param.pop("rackxmlpath")
                if rack_xml_path.endswith(".xml"):
                    rest = "".join(line[1:]) if len(line) > 1 else ""
                    if ecli.verbose :
                        cl.prt ("n","[Verbose] rackxmlpath param = " + rack_xml_path)
                else:
                    cl.perr("Rack name must has xml extension")
                    rack_xml_path = None
        # To maintain compability with the current register rack process  (without a parameter)
        else:
            line = line.split(' ', 1)
            rack_name, rest = line[0], line[1] if len(line) > 1 else ""

        return (rack_xml_path, rack_name, rest)



    def do_register_rack(self, ecli, line):
        rack_xml_path = None
        rack_path     = None
        rack_name     = None
        rest = ''
        (rack_xml_path, rack_name, rest) = self.get_param_rack_operation(ecli, line)
        if not rack_xml_path and not rack_name:
            cl.perr("Rack name or the xml path is not valid")
            return
        if rack_name not in ecli.racks:
            if not rack_xml_path:
                cl.perr("Rack name not found in ecracli.cfg, please put it under exadataClusters or use the file path instead of rack name")
                cl.perr("Racks found in ecracli.cfg are: " + str(sorted(ecli.racks.keys())))
                return
            else:
                rack_path = rack_xml_path
        else:
            rack_path = ecli.racks[rack_name]

        if not rack_path:
            cl.perr("Rack xml path is  not valid")
            return


        if not os.path.exists(rack_path):
            cl.perr("Rack xml path " + rack_path + " is not valid")
            return

        with open(rack_path, 'r') as xml_file:
            xml = xml_file.read()

        cluid = ""
        root = et.fromstring(re.sub('xmlns="\w*"', '', xml))
        node_count = len(root.findall("software/clusters/cluster/clusterVips/clusterVip/machines/machine"))
        rack_name = root.find("customerName").text
        dom0, domu = self.findDom0Domu(root)

        model = ecli.getExadataModel(xml)
        params = {}
        params["dom0"] = dom0
        params["domu"] = domu
        params["name"]  = rack_name
        params["model"] = model
        params["xml"]   = xml
        params["status"] = "READY"
        params["opstate"] = "ONLINE"
        params["racksize"] = ecli.nodesToRacksize[node_count]

        # Bug 25697839 - ECRACLI DOES NOT ALLOW REGISTER_RACK AS EIGHTH RACK
        _valid_racksize = ["full","half","quarter","eighth", "double", "elastic"]
        _subtype = root.find("machines/machine/machineSubType")
        if _subtype != None :
            if ecli.verbose :
                cl.prt ("n","[Verbose] _subtype =  " + _subtype.text)
            if "_one_eighth" in _subtype.text :
                params["racksize"] = "eighth"
        else :
            if ecli.verbose :
                cl.prt ("n","[Verbose] _subtype =  None")

        for key, value in ecli.parse_params(rest, None).items():
            if key == "racksize" and value.lower() not in _valid_racksize :
                cl.prt ("r","[ERROR] Non valid racksize value = '{0}' ".format(value) )
                return #continue
            if ecli.verbose :
                cl.prt ("n","[Verbose] (key,)value) = ({0},{1})".format(key,value))
            params[key] = value

        params["racksize"] = params["racksize"].upper()
        
        if ecli.interactive:
            cl.prt("c", "Registering rack with rack name: {0}".format(params["name"]))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "racks")
        cl.prt("c", "{0}".format(response))

    def do_deregister_rack(self, ecli, line, host):
        rack_xml_path = None
        rack_name     = None
        (rack_xml_path, rack_name, _) = self.get_param_rack_operation(ecli, line)
        if not rack_xml_path and not rack_name:
            cl.perr("The rack name or the xml path is not valid")
            return
        if rack_name not in ecli.racks:
            if not rack_xml_path:
                cl.perr("Rack name not found in ecracli.cfg, please put it under exadataClusters or use the file path instead of rack name")
                cl.perr("Racks found in ecracli.cfg are: " + str(sorted(ecli.racks.keys())))
                return
            else:
                if not os.path.exists(rack_xml_path):
                    cl.perr("Rack xml path " + rack_xml_path + " is not valid")
                    return
                else:
                    with open(rack_xml_path, 'r') as xml_file:
                        xml = xml_file.read()
                    root      = et.fromstring(re.sub('xmlns="\w*"', '', xml))
                    rack_name = root.find("customerName").text

        if not rack_name:
            cl.perr("Please specify rack name")
            return

        if ecli.interactive:
            cl.prt("c", "Deregistering rack with name: {0}".format(rack_name))
        response = self.HTTP.delete("{0}/racks/{1}".format(host, rack_name))
        cl.prt("c", "{0}".format(response))
     
    def do_updatecavium_rack(self, ecli, line, host):
        if len(line.split()) != 2:
            cl.perr("do_updatecavium_rack will take exactly two mandatory parameters")
        else:
            line = line.split(' ')
            oldcaviumid, newcaviumid = line[0], line[1] if len(line) > 1 else ""
            update_puturl = "{0}/racks/{1}/{2}/updatecavium".format(host,oldcaviumid,newcaviumid)
            retObj = self.HTTP.put(update_puturl, "", "racks")
            cl.prt("c", "{0}".format(retObj))
            return


    def do_update_rack(self, ecli, line, host):
        line = line.split(' ', 1)
        rack_name, rest = line[0], line[1] if len(line) > 1 else ""
        if not rest:
            cl.perr("please specify field/value to update in commmand options")
            return
        params = ecli.parse_params(rest, None)

        if "opstate" in params:
            opstate = params["opstate"]
            cl.prt("c", "Put opstate to {0} for rack {1}".format(opstate, rack_name))
            retObj = self.HTTP.put("{0}/racks/{1}/opstate/{2}".format(host, rack_name, opstate), "", "racks")
            if retObj is not None and retObj['status'] == 200:
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))

        else:
            params["name"] = rack_name

            if "mode" in params:
                mode = params.pop("mode")
                if mode == "enabled":
                    params["disabled"] = 0
                elif mode == "disabled":
                    params["disabled"] = 1
                else:
                    cl.perr("mode %s is not supported. Available modes are: %s" % (mode, ["enabled", "disabled"]))
                    return

            if ecli.interactive:
                cl.prt("c", "Updating rack with rack name: {0}".format(rack_name))
            data = json.dumps(params, sort_keys=True, indent=4)

            response = self.HTTP.put("{0}/racks".format(host), data, "racks")
            print(response)

    def do_get_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/racks{1}".format(host, query),False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_compose_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('rack', 'compose', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post("", "racks", "{0}/racks/{1}/compose".format(host, params["rackname"]))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_reserve_rack(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr("do_reserve_rack takes only one mandatory argument <rack_name>")
        else:
            cl.prt("c", "Reserve rack : {0}".format(line))
            retObj = self.HTTP.put("{0}/racks/{1}/reserve".format(host, line), "", "racks")
            if retObj is not None and retObj['status'] == 200:
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))

    def do_release_rack(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr("do_release_rack takes only one mandatory argument <rack_name>")
        else:
            cl.prt("c", "Release rack : {0}".format(line))
            retObj = self.HTTP.put("{0}/racks/{1}/release".format(host, line), "", "racks")
            if retObj is not None and retObj['status'] == 200:
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                    
    def do_drop_rack(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr("Rack Drop only takes one mandatory argument <rack_name>")
            return None

        params = ecli.parse_params(line, None, optional_key="rackname")
        # Validate the parameters
        try:
            ecli.validate_parameters('rack', 'drop', params)
        except Exception as e:
            cl.perr(str(e))
            return
        rackname = line if "=" not in line or "rackname" not in params else params.get("rackname")
        confirmation = input("Do you want to delete all related records for rack {0}? [y/n] ".format(rackname))
        if "y" not in confirmation:
            cl.prt("c", "Skipping drop of rack {0}".format(rackname))
            return None
        
        cl.prt("c", "Drop rack : {0}".format(line))
        result = self.HTTP.put("{0}/racks/{1}/drop".format(host, rackname), "", "racks")
        
        if result is not None and "status" in result and result["status"] == 200:
            cl.prt("n", "Response data")
            for k, v in result.items():
                cl.prt("p", "{0} : {1}".format(k, v))

    def do_exaid_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('rack', 'exaid', params)
        except Exception as e:
            cl.perr(str(e))
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/racks/exaid{1}".format(host, query), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_fetchatp_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # default params
        default_model = 'X7-2'

        # Validate the parameters
        try:
            ecli.validate_parameters('rack', 'fetchatp', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # update params
        if not "model" in params:
            params["model"] = default_model

        if ecli.interactive:
           cl.prt("c", "Move capacity with parameters:")
           for key, value in params.items():
               cl.prt("c", "{0} : {1}".format(key, value))
        
        response = self.HTTP.post(json.dumps(params), "racks", "{0}/racks/fetchAtp".format(host))

        # Print response obtained from ECRA
        if response:
            cl.prt("n", json.dumps(response))

    def do_getxml_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="rackname")
        try:
            ecli.validate_parameters("rack", "getxml", params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params["rackname"]
        response = self.HTTP.get("{0}/racks/{1}/xml".format(host, rackname))
        if not response:
            cl.perr("Failed to get rack: " + rackname)
            return
        
        cl.prt("n", json.dumps(response,indent=4, sort_keys=True))

    def do_unlock_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="rackname")
        try:
            ecli.validate_parameters("rack", "unlock", params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params["rackname"]
        response = self.HTTP.put("{0}/racks/{1}/unlock".format(host, rackname), "", "racks")
        if not response:
            cl.perr("Failed to unlock rack: " + rackname)
            return
        
        cl.prt("n", json.dumps(response,indent=4, sort_keys=True))

    def do_ports_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('rack', 'ports', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")
        if "nodeList" in params:
            params["node_list"] = params.pop("nodeList")
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = self.HTTP.get("{0}/racks/{1}/ports{2}".format(host, rackname,query))

        if not response:
            cl.perr("Failed to retrieve rack port information from rack: " + rackname)
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_nodes_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('rack', 'nodes', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")
        response = self.HTTP.get("{0}/racks/{1}/nodes".format(host, rackname))

        if not response:
            cl.perr("Failed to retrieve rack nodes information from rack: " + rackname)
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_rack_xml_patch(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="rackname")
        try:
            ecli.validate_parameters("rack", ["xml", "patch"], params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/racks/{1}/patchxml".format(host, rackname), data, "racks")
        if not response:
            cl.perr("Failed to patch rack XML: " + rackname)
            return
        
        cl.prt("n", json.dumps(response,indent=4, sort_keys=True))

    def do_update_selinux_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('rack', 'selinuxupdate', params)
        except Exception as e:
            cl.perr(str(e))
            return
        #Verify just one of the parameters is provided not both and at least one of them
        if not (("rackname" in params) ^ ("cabinetname" in params)): 
            cl.perr("Provide at least one [rackname or cabinetname] but not both")
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "racks", "{0}/selinux/setpolicies".format(host))
        if not response:
            cl.perr("Failed to update se_linux policies")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_list_selinux_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('rack', 'selinuxlist', params)
        except Exception as e:
            cl.perr(str(e))
            return
        rackname = params.pop("rackname")
        response = self.HTTP.get("{0}/selinux/getpolicies/{1}".format(host,rackname))

        if not response:
            cl.perr("Failed to retrieve se_linux policies for rack: " + rackname)
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_update_custom_selinux_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #Validate the parameters
        try:
            ecli.validate_parameters('rack', 'selinuxcustomupdate', params)
        except Exception as e:
            cl.perr(str(e))
            return
        #Verify just one of the parameters is provided not both and at least one of them
        if not (("rackname" in params) ^ ("cabinetname" in params)): 
            cl.perr("Provide at least one [rackname or cabinetname] but not both")
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "racks", "{0}/selinux/setcustompolicies".format(host))
        if not response:
            cl.perr("Failed to update custom se_linux policies")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_get_xml_info(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="rackname")
        try:
            ecli.validate_parameters("rack", "getxmlinfo", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = ""
        if params.get("rackname"):
            rack_name = params["rackname"]
            url = "{0}/racks/{1}/xml/info".format(host, rack_name)
        elif params.get("xmlpath"):
            xmlpath = params["xmlpath"]
            url = "{0}/racks/xml/info?xmlpath={1}".format(host, xmlpath)
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_rack_xml_patchnodes(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("rack", "patchxmlnodes", params)
        except Exception as e:
            cl.perr(str(e))
            return

        added_cells = []
        added_computes = []

        inventoryList = params["inventories"].split(",")
        for inventory in inventoryList:
            inventory = inventory.strip()
            inventory_query = "{0}/inventory/hardware?hostname={1}".format(host,inventory)
            response=ecli.issue_get_request(inventory_query, False)
	 
            node_type=response["servers"][0]["hw_type"]
            if "COMPUTE" == node_type:
                node = {}
                node["compute_node_hostname"] = inventory + "." + response["servers"][0]["domainname"]
                added_computes.append(node)
            if "CELL" == node_type:
                node = {}
                node["cell_hostname"] = inventory + "." + response["servers"][0]["domainname"]
                added_cells.append(node)

        payload = {}
        rns = {}
        rns["added_cells"] = added_cells
        rns["added_computes"] = added_computes
        payload["reshaped_node_subset"] = rns
        payload["update_rack"]=params["updaterack"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/racks/{1}/xml/patchnodes".format(host, params["rackname"]), data, "racks")
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))



    def do_validate_xml(self, ecli, line, host):
        line = line.split(' ', 1)
        rackname, rest = line[0], line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)
        try:
            ecli.validate_parameters("rack", "validatexml", params)
        except Exception as e:
            cl.perr(str(e))
            return
        # Single rack validation
        if rackname:
            url = "{0}/racks/{1}/validatexml".format(host, rackname)
            response = self.HTTP.get(url)
            if response:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
                return

        # All racks in ECRA fleet validation
        url = "{0}/racks/validatexml".format(host)
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_update_xml(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("rack", "updatexml", params)
        except Exception as e:
            cl.perr(str(e))
            return
        if "force" in params:
            force=params.pop("force").lower()
            if "true" == force:
                params['force']=force
            else:
                params['force']="false"
        
        rackname = params.pop("rackname")
        xml=params.pop("xml").lower()
        if xml == "original":
            params['xml']=params.pop("path")
        elif xml == "updated":
            params['updated_xml'] = params.pop("path")
        else:
            cl.perr("The xml param should be 'original' or 'updated'")
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/racks/{1}/xml".format(host, rackname), data, "racks")
        if response:
            cl.prt("w", json.dumps(response, indent=2, sort_keys=False))

    def do_run_sanitycheck_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("rack", "sanitycheck", params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = {}
        targets = params.get("targets")
        if targets and targets != "all":
            payload["targets"] = targets.split(",")
        payload["allowStatusChange"] = bool(
            params.get("update_rack_status", "true"))

        response = self.HTTP.post(json.dumps(payload), "racks",
                                  "{0}/racks/sanitycheck".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=2, sort_keys=False))
