#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Capacity.py /main/51 2025/11/06 13:41:51 hbpatel Exp $
#
# ExadataInfra.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Capacity - CLIs for reserving and listing capacity
#
#    DESCRIPTION
#      Provides the clis to list and reserve capacity
#
#    NOTES
#      None
#
#    MODIFIED   (MM/DD/YY)
#       hbpatel  10/25/25 - Enh 37912972 - Exacc gen2: api call to force deletion of infra from 
#                          ecra during decommissioning process in case of disconnected
#       oespinos 10/09/25 - Bug 38220438 - Mark Cells to Delete
#       luperalt 07/30/25 - Bug 38259193 - Added configure exascale command
#       luperalt 07/22/25 - Bug 38173167 - Added parameter type to generate
#                           dbcs wallets
#       llmartin 05/16/25 - Enh 37705371 - Add Attach cell exascale command
#       abyayada 12/12/24 - 37371775 : Support to get nat and hostname map
#       luperalt 12/02/24 - Bug 37345269 - Added option to regenerate dbcs
#                           wallters
#       pverma   10/08/24 - Implement updateAsmss command
#       luperalt 09/13/24 - Bug 37053087 - Added TOTALXSGB for undoExascale for
#                           exacs
#       luperalt 08/08/24 - Bug 36907987 - Added undo exascale operation
#       caborbon 06/18/24 - Bug 36741558 - Modifying the data types in
#                           getRacksCapacityReport
#       caborbon 06/07/24 - Bug 36695576 - Changes in the getavailability
#                           method to match with the new output
#       illamas  10/27/23 - Catalog support more than one exaversion
#       illamas  09/08/23 - Enh 35677356 - GI support
#       caborbon 06/20/23 - ENH 35402932 - Adding compatibility command
#       ddelgadi 07/28/22 - Bug 34413294 - Add option rackname in command
#                           ocicapacity_to_ns
#       rgmurali 08/15/20 - Bug 31536477 - Fix fortify issues
#       marcoslo 08/08/20 - ER 30613740 Update code to use python 3
#       pverma   05/13/19 - Pre-Activation APIs
#       jvaldovi 05/08/19 - Bug 29751191 Changed default model value to X6-2 
#                           instead of X5-2 on capacity reserve Op
#       diegchav 03/27/19 - ER 29546333 : Rename capacity reserve atp parameter
#       rgmurali 04/01/19 - ER 29530642 Support for move capacity
#       sachikuk 11/08/17 - Bug - 27086265 : Enhance rack slot registration
#       sachikuk 10/03/17 - Bug - 26885989: ecra endpoints for customer network 
#                           info management
#       sachikuk 09/26/17 - get capacity details endpoint [Bug - 26860773]
#       sachikuk 09/10/17 - Reserve/release capacity for multi-vm [Bug -
#                           26748905]
#       sachikuk 08/29/17 - New rack register/deregister flows for multi-vm
#                           [Bug - 26574643]
#       rgmurali 04/20/17 - Create file

from formatter import cl
import json
import os
import urllib.request, urllib.error, urllib.parse
import shutil
from urllib.request import Request

class Capacity:
    MATRIX_ENABLED="ENABLED"
    MATRIX_DISABLED="DISABLED"
    MATRIX_EXCLUSION="EXCLUDED"

    def __init__(self, HTTP):
        self.HTTP = HTTP

    def print_success_response(self, response):
        if response is not None and response['status'] == 200:
            cl.prt("n", "Response data")
            for key, value in response.items():
                cl.prt("p", "{0} : {1}".format(key, value))

    def do_register_capacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("capacity", "register", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Template xml must exist
        tmpl_xml_path = params["tmpl_xml"]
        if not os.path.isfile(tmpl_xml_path):
           cl.perr("Template xml path: " + tmpl_xml_path + " does not exist.")
           return 

        # Read template xml
        with open(tmpl_xml_path, 'r') as tmpl_xml_file:
             params["tmpl_xml"] = tmpl_xml_file.read()
             tmpl_xml_file.close()

        # Register capacity with ECRA
        if ecli.interactive:
           cl.prt("c", "Registering capacity with exadata id: " + params["exadata_id"])
        response = self.HTTP.post(json.dumps(params), "capacity", "{0}/capacity".format(host))
   
        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_deregister_capacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("capacity", "deregister", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Deregister capacity with ECRA
        exadata_id = params["exadata_id"]
        if ecli.interactive:
           cl.prt("c", "Deregistering capacity with exadata id: {0}".format(exadata_id))
        response = self.HTTP.delete("{0}/capacity/{1}".format(host, exadata_id), json.dumps(params))

        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_release_capacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("capacity", "release", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to release capacity
        exadata_id = params["exadata_id"]
        if ecli.interactive:
           cl.prt("c", "Releasing capacity with exadata id: {0}".format(exadata_id))
        response = self.HTTP.put("{0}/capacity/{1}/release".format(host, exadata_id), None, "capacity")

        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_reserve_capacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # default params
        default_model = 'X6-2'

        # Validate the parameters
        try:
            ecli.validate_parameters('capacity', 'reserve', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # update params
        if not "model" in params:
            params["model"] = default_model

        # Change atp parameter name to the way is expected by the API.
        if "atp" in params:
            params["AutonomousDb"] = params["atp"]
            params.pop("atp")

        # Call ECRA to reserve capacity
        if ecli.interactive:
           cl.prt("c", "Reserve capacity with parameters:")
           for key, value in params.items():
               cl.prt("c", "{0} : {1}".format(key, value))
        response = self.HTTP.post(json.dumps(params), "capacity", "{0}/capacity/reserve".format(host))

        # Print response obtained from ECRA
        self.print_success_response(response) 

    
    def do_move_capacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # default params
        default_model = 'X7-2'
        default_numberToMove = 1

        # Validate the parameters
        try:
            ecli.validate_parameters('capacity', 'move', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # update params
        if not "model" in params:
            params["model"] = default_model

        if not "numberOfRacks" in params:
            params["numberOfRacks"] = default_numberToMove

        # Call ECRA to move capacity
        if ecli.interactive:
           cl.prt("c", "Move capacity with parameters:")
           for key, value in params.items():
               cl.prt("c", "{0} : {1}".format(key, value))
        response = self.HTTP.post(json.dumps(params), "capacity", "{0}/capacity/move".format(host))

        if response:
            cl.prt("n", json.dumps(response))
        
    def do_list_capacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('capacity', 'list', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get capacity list
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        url = "{0}/capacity{1}".format(host, query)
        cl.prt("c", "GET " + url)
        retObj = ecli.issue_get_request(url, False)

        # Print response obtained from ECRA
        if retObj is not None and retObj['status'] == 200:
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                if key != "capacity":
                    cl.prt("p", "{0} : {1}".format(key, value))
                else:
                    capacity_list = value
            if capacity_list is not None:
                cl.prt("p", "capacity : ")
                for capacity in capacity_list:
                    for key, value in capacity.items():
                        cl.prt("p", "{0} : {1}".format(key, value))
                    cl.prt("p", "\n")

    def do_get_capacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("capacity", "get", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if params is None:
           params = {}
 
        # Call ECRA to get capacity details
        if ecli.interactive:
           cl.prt("c", "Get capacity with parameters:")
           for key, value in params.items():
               cl.prt("c", "{0} : {1}".format(key, value))

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        url = "{0}/capacity/details{1}".format(host, query)
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)

        # Print response obtained from ECRA
        self.print_success_response(response)
        
    def do_register_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "register", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonconf"]
        if not os.path.isfile(input_json_path):
            cl.perr("OCI Capacity Register input JSON: " + input_json_path + " does not exist.")
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

        # Register capacity with ECRA
        url = "{0}/capacity/exadata".format(host)
        cl.prt("c", "POST " + url)
        if ecli.interactive:
            cl.prt("c", "Registering OCI Exadata capacity with details: " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.post(data, "capacity", url)
   
        ecli.waitForCompletion(response, "register_ocicapacity")
        
    def do_details_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "details", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCI Exadata details
        if ecli.interactive:
            cl.prt("c", "Get OCI Exadata details with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/{1}".format(host, params["exaOcid"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))

    def do_get_domuhost_nat_mapping(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "getnatmap", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCI Exadata details
        if ecli.interactive:
            cl.prt("c", "Get OCI Exadata details with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/{1}".format(host, params["exaOcid"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        vmClusterOcid = params['vmClusterOcid'] if 'vmClusterOcid' in params else None
        result = [
            {
                "vmClusterOcid": details["vmClusterOcid"],
                "dom0domUDetails": details["dom0domUDetails"]
            }
            for tenant in response.get("tenantCapacity", [])
            for capacity in tenant.get("capacity", [])
            for details in capacity.get("rackSlotsDetails", [])
            if details.get("vmClusterOcid") and details.get("dom0domUDetails")
            and details.get("status") != "READY"
            and (vmClusterOcid is None or details["vmClusterOcid"] == vmClusterOcid)
        ]
        cl.prt("c", json.dumps(result, indent=4, sort_keys=True))
        
    def do_update_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "update", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonconf"]
        if not os.path.isfile(input_json_path):
            cl.perr("OCI Capacity update input JSON: " + input_json_path + " does not exist.")
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
            
        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c", "Update Exadata with OCID: " + exa_ocid + " details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")

        ecli.waitForCompletion(response, "update_ocicapacity")
        
    def do_delete_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "delete", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to delete OCI Exadata
        if ecli.interactive:
            cl.prt("c", "Delete OCI Exadata with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/{1}".format(host, params["exaOcid"])
        cl.prt("c", "DELETE " + url)
        response = self.HTTP.delete(url)

        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_infra_status_update(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Call ECRA to update infra status
        if ecli.interactive:
            cl.prt("c", "Update Exadata infra:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/infra/{1}/{2}".format(host, params["exaOcid"], params["status"])
        cl.prt("c", "POST " + url)
        response = self.HTTP.post(json.dumps(params), "capacity", url)

        # Print response obtained from ECRA
        self.print_success_response(response)

        
    def do_reserve_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "reserve", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to reserve OCI Exadata
        exa_ocid = params["exaOcid"]
        if ecli.interactive:
            cl.prt("c", "Reserve Exadata with OCID: {0}".format(exa_ocid))
            
        payload = {}

        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)
        url = "{0}/capacity/exadata/{1}/reserve".format(host, params["exaOcid"])
        cl.prt("c", "PUT " + url)
        response = self.HTTP.put(url, data, "capacity")

        # Print response obtained from ECRA
        self.print_success_response(response)
        
    def do_get_exa_cfgbundle_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "getconfigbundle", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCI Exadata details
        if ecli.interactive:
            cl.prt("c", "Get OCI Exadata config bundle with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))
                
        save_location = params["saveloc"]
        while save_location.endswith('/'):
            save_location = save_location[:-1]
        
        # Save location file must NOT exist
        if os.path.isfile(save_location):
            cl.perr("File already exists: " + save_location)
            return
        
        url = "{0}/capacity/exadata/{1}/config-bundle".format(host, params["exaOcid"])
        cl.prt("c", "GET " + url)
        
        header = {}
        header["Authorization"] = ecli.HTTP.auth_header
        req = urllib.request.Request(url, None, header)
        response = urllib.request.urlopen(req)
        open(save_location, 'wb').write(response.read())
        cl.prt("c", "Download Complete")

    def do_get_exa_cfgbundlecksum_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "getcfgbundlecksum", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCPS config bundle
        if ecli.interactive:
            cl.prt("c", "Get OCI Exadata SHA-256 checksum of the config bundle with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/{1}/config-bundle-cksum".format(host, params["exaOcid"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        self.print_success_response(response)

    def do_get_bastion_privkey_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "getprivkey", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get SSH private key for Bastion->OCPS Access
        if ecli.interactive:
            cl.prt("c", "Get OCI Exadata SSH private key for Bastion->OCPS comm with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))
                
        save_location = params["saveloc"]
        while save_location.endswith('/'):
            save_location = save_location[:-1]
        
        # Save location file must NOT exist
        if os.path.isfile(save_location):
            cl.perr("File already exists: " + save_location)
            return

        url = "{0}/capacity/exadata/{1}/ocps-ssh-priv-key".format(host, params["exaOcid"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        if response is not None and response['status'] == 200:
            open(save_location, 'wb').write(response['controlServerPrivKey'])
            cl.prt("c", "Saved requested file")
        else:
            cl.prt("c", "Error getting bastion privkey")        
        
    def do_get_exa_cfgbundlepasswd_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "getcfgbundlepasswd", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get Cipher psswd to decrypt the encrypted config bundle
        if ecli.interactive:
            cl.prt("c", "Get the Cipher password to decrypt the encrypted config bundle with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        save_location = params["saveloc"]
        while save_location.endswith('/'):
            save_location = save_location[:-1]
        
        # Save location file must NOT exist
        if os.path.isfile(save_location):
            cl.perr("File already exists: " + save_location)
            return
        
        url = "{0}/capacity/exadata/{1}/config-bundle-cipher-passwd".format(host, params["exaOcid"])
        cl.prt("c", "GET " + url)
        header = {}
        header["Authorization"] = ecli.HTTP.auth_header
        req = urllib.request.Request(url, None, header)
        response = urllib.request.urlopen(req)
        open(save_location, 'wb').write(response.read())
        cl.prt("c", "Saved requested file")

    def do_migrate_ocicapacity_to_mvm(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "migrateToMvm", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        if "rackname" in params:
            payload["rackname"] = params["rackname"]

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/migrateToMvm".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Migrate Exadata with OCID: " + exa_ocid + " to MVM with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")
        ecli.waitForCompletion(response, "migrate_to_mvm_ocicapacity")

    def do_migrate_ocicapacity_to_ns(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "enableNs", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        if "rackname" in params:
            payload["rackname"] = params["rackname"]

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/enableNodeSubset".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Enable NS feature on Exadata with OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")
        ecli.waitForCompletion(response, "migrate_ocicapacity_to_ns")

    def do_migrate_ocicapacity_to_ecell(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "enableElasticCell", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/migrateToElasticCell".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Migrate Exadata with OCID: " + exa_ocid + " to Elastic Storage with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")
        ecli.waitForCompletion(response, "migrate_ocicapacity_to_ecell")

    def do_migrate_ocicapacity_to_ecompute(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "enableElasticCompute", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/migrateToElasticCompute".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Migrate Exadata with OCID: " + exa_ocid + " to Elastic Compute with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")
        ecli.waitForCompletion(response, "migrate_ocicapacity_to_ecompute")

    def do_migrate_ocicapacity_to_wss(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "migrateVpnToWss", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()
        payload["phase"] = params["phase"]
        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/migrateVpnToWss".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Migrate Exadata with OCID: " + exa_ocid + " to WSS with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")
        ecli.waitForCompletion(response, "capacity_migrate_wss")


    def do_release_ocicapacity(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "release", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        payload["rackSlot"] = params["rackSlot"]

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/release".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c", "Release RackSlot: " + payload[
                "rackSlot"] + " for Exadata with OCID: " + exa_ocid + " details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")

        ecli.waitForCompletion(response, "release_ocicapacity")

    def do_activate_cell_servers(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "activateCellServers", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if not "idemtoken" in params:
            params["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/activateCellServers".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Activate new cells with OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity", params["idemtoken"] )
        ecli.waitForCompletion(response, "activate_new_cells")

    def do_attach_cell_servers(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "attachCellServers", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if not "idemtoken" in params:
            params["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/attachCellServers".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Attach new cells with OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity", params["idemtoken"]  )
        ecli.waitForCompletion(response, "attach_cell_server")

    def do_attach_cell_servers_exascale(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "attachCellServersExascale", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if not "idemtoken" in params:
            params["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/attachCellServers/exascale".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Attach new cells with OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity", params["idemtoken"]  )
        ecli.waitForCompletion(response, "attach_cell_server")


    def do_migrate_to_elastic_cell(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "migrateElasticCell", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/migrateToElasticCell".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Migrate to elastic cell with OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")
        ecli.waitForCompletion(response, "migrate_to_elastic_cell")

    def do_update_asmss_for_infra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "updateAsmss", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        if params["asmss"].lower() == "true":
            payload["asmss"] = True
        elif params["asmss"].lower() == "false":
            payload["asmss"] = False
        else:
            cl.perr("Invalid value for param asmss: " + params["asmss"])
            return

        data = json.dumps(payload)

        # Call ECRA to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/updateAsmssConfig".format(host, exa_ocid)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c",
                   "Update ASMSS for OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4,
                                                                                                     sort_keys=True))
        response = self.HTTP.put(url, data, "capacity")
        self.print_success_response(response)

    def _get_new_ecra_idemtoken(self):
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token from ECRA")
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        return retObj["idemtoken"]

    def do_infrav2_backfill(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("capacity", "infrav2backfill", params)
        except Exception as e:
            cl.perr(str(e))
            return
       
        infra_ocid = params.pop("exadataInfrastructureId")
        data = json.dumps(params)

        url = "{0}/capacity/exadata/{1}/enableNodeSubset".format(host, infra_ocid)
        response = self.HTTP.put(url, data, "capacity")
        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_activate_computes(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #validate parameters
        try:
            ecli.validate_parameters("ocicapacity", "activateComputes", params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = {}
        if not "idemtoken" in params:
            params["idemtoken"] = self._get_new_ecra_idemtoken()
        data = json.dumps(payload)
        #call ecra to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/activateComputes".format(host, exa_ocid)
        cl.prt("c", "PUT" + url)
        if ecli.interactive:
            cl.prt("c", "Activate new computes with OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "capacity", params["idemtoken"])
        ecli.waitForCompletion(response, "activate_computes")

    def do_restore_allocations(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #validate parameters
        try:
            ecli.validate_parameters("ocicapacity", "restoreAllocation", params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = {}
        if not "idemtoken" in params:
            params["idemtoken"] = self._get_new_ecra_idemtoken()
        data = json.dumps(payload)
        #call ecra to restore OCI Exadata capacity
        exa_ocid = params["exaOcid"]
        exaunit_id = params["exaunitId"]
        url = "{0}/exadata/{1}/exaunit/{2}".format(host, exa_ocid, exaunit_id)
        cl.prt("c", "PUT" + url)
        if ecli.interactive:
            cl.prt("c", "Restore allocations for OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "capacity", params["idemtoken"])
        ecli.waitForCompletion(response, "restore_allocations")

    def do_fix_xml_action_tag(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        #validate parameters
        try:
            ecli.validate_parameters("ocicapacity", "fixXmlActionTag", params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = {}
        data = json.dumps(payload)
        #call ecra to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/markActionsDeployedInUpdatedXmls".format(host, exa_ocid)
        cl.prt("c", "PUT" + url)
        if ecli.interactive:
            cl.prt("c", "Fixing XMLs for OCID: " + exa_ocid + " with details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "capacity", None)
        ecli.waitForCompletion(response, "activate_computes")

    def do_release_infra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "releaseInfra", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCI Exadata details
        if ecli.interactive:
            cl.prt("c", "Release OCI Exadata infra with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/{1}/releaseInfra".format(host, params["exaOcid"])
        cl.prt("c", "PUT " + url)
        response = self.HTTP.put(url, None, "capacity")
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))

    def do_reserve_infra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "reserveInfra", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCI Exadata details
        if ecli.interactive:
            cl.prt("c", "Reserve OCI Exadata infra with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/{1}/reserveInfra".format(host, params["exaOcid"])
        cl.prt("c", "PUT " + url)
        response = self.HTTP.put(url, None, "capacity")
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))

    def do_capacity_getavailability(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("capacity", "getavailability", params)
        except Exception as e:
            cl.perr(str(e))
            return

        query=""
        
        if "type" not in params:
            type = "all"
        else:
            type = params["type"]
        query = "?type=" + type
        if "detailed" not in params:
            detailed=False
        else:
            if (params["detailed"] == "true"):
                detailed = True
                query += "&detailed=true"
            else:
                detailed = False
                query += "&detailed=false"

        if "raw" not in params:
            raw = False
        else:
            if (params["raw"] == "true"):
                raw = True
            else:
                raw = False
        url="{0}/capacity/availability/" + query
        response = self.HTTP.get(url.format(host))
        if not response:
            cl.perr("Failed to get availability for option: " + type)
            return
        if raw:
            cl.prt("n", json.dumps(response, indent=4))
        else:
            columns = {
                "type": "TYPE",
                "used": "USED",
                "free": "FREE",
                "other_states": "OTHER_STATES",
                "total": "TOTAL" }
            if detailed:
                columns["model"] = "MODEL"
                if type == "rack":
                   columns["totalcomputes"] = "TOTAL COMPUTES"
            table = []
            table.append(columns.copy())
            if type == "all":
                table[0]["type"] = "RACK TYPE"
                table = table + response['rack']
                columns["type"] = "NODE TYPE" 
                table.append(columns.copy())
                table = table + response['elastic']
            else:
                table[0]["type"] = "RACK TYPE" if type == "rack" else "NODE TYPE" 
                table = table + response[type]
            result = "\n"

            for row in table:
                if "TYPE" in row["type"]:
                    result += "\n"
                result.ljust(10," ")
                result += str(row["type"]).ljust(10," ") + "  "
                if(detailed):
                    result += str(row["model"]).ljust(10," ") + "  "
                result += str(row["used"]).ljust(10," ")+ "  "
                result += str(row["free"]).ljust(10," ") + "  "
                result += str(row["other_states"]).ljust(15," ") + "  "
                result += str(row["total"]).ljust(10," ") + "  "
                if(detailed and type=="rack"):
                    result += str(row["totalcomputes"]).ljust(10, " ") + "  "
                result += "\n"
            cl.prt("n", result)

    def do_capacity_getfilesystemdefinitions(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("capacity", "getfilesystemdefinitions", params)
        except Exception as e:
            cl.perr(str(e))
            return

        model = params["model"]
        queryParams=""
        if "exaOcid" in params:
            queryParams += "&exaOcid=" + params["exaOcid"]
        if "rackname" in params:
            queryParams+="&rackname=" + params["rackname"]
        if "adbd" in params:
            queryParams+="&adbd=" + params["adbd"]
        if "svm" in params:
            queryParams+="&svm=" + params["svm"]

        url="{0}/capacity/exadata/filesystemdefinitions/{1}"

        if len(queryParams)>0:
            url += "?" + queryParams[1:]

        response = self.HTTP.get(url.format(host, model))
        if not response:
            cl.perr("Failed to get filsystem defiitions for model: " + model)
            return
        cl.prt("n", json.dumps(response, indent=4))

    def capacity_compatibility_addrecord(self, ecli, params, host):
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "capacity", "{0}/capacity/compatibility/matrix".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def capacity_compatibility_updaterecord(self, ecli, params, host):
        id = params["id"]
        params.pop("id")
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/capacity/compatibility/matrix/{1}".format(host,id), data, "capacity")
        if response:
            cl.prt("n", json.dumps(response))

    def do_capacity_compatibility_addmatrix(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("capacity", ["compatibility","addmatrix"], params)
        except Exception as e:
            cl.perr(str(e))
            return
        self.capacity_compatibility_addrecord(ecli, params, host)

    def do_capacity_compatibility_addexclusion(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("capacity", ["compatibility","addexclusion"], params)
        except Exception as e:
            cl.perr(str(e))
            return
        params["status"] = self.MATRIX_EXCLUSION
        self.capacity_compatibility_addrecord(ecli, params, host)

    def do_capacity_compatibility_updatematrix(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("capacity", ["compatibility","updatematrix"], params)
        except Exception as e:
            cl.perr(str(e))
            return
        self.capacity_compatibility_updaterecord(ecli, params, host)
    
    def do_capacity_compatibility_enablematrix(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("capacity", ["compatibility","enablematrix"], params)
        except Exception as e:
            cl.perr(str(e))
            return
        params["status"] = self.MATRIX_ENABLED
        self.capacity_compatibility_updaterecord(ecli, params, host)

    def do_capacity_compatibility_disablematrix(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("capacity", ["compatibility","disablematrix"], params)
        except Exception as e:
            cl.perr(str(e))
            return
        params["status"] = self.MATRIX_DISABLED
        self.capacity_compatibility_updaterecord(ecli, params, host)

    def do_capacity_compatibility_list(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        get_params = "?"
        # Validate the parameters for a status change
        try:
            ecli.validate_parameters("capacity", ["compatibility","list"], params)
        except Exception as e:
            cl.perr(str(e))
            return
        #Check how to pass the optional parameters
        if len(params) == 0:
            response = ecli.issue_get_request("{0}/capacity/compatibility/matrix/".format(host), False)
        else:
            count = 0
            for key,value in params.items():
                if count == 0:
                    get_params = get_params + key + "=" + value
                else: 
                    get_params = get_params + "&" + key + "=" + value
                count = count + 1
            response = ecli.issue_get_request("{0}/capacity/compatibility/matrix/{1}".format(host,get_params), False)
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))


    def do_capacity_compatibility_catalog(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        get_params = "?"
        # Validate the parameters for a status change
        try:
            ecli.validate_parameters("capacity", ["compatibility","catalog"], params)
        except Exception as e:
            cl.perr(str(e))
            return
        #Check how to pass the optional parameters
        if len(params) == 0:
            response = ecli.issue_get_request("{0}/capacity/compatibility/catalog".format(host), False)
        else:
            count = 0
            for key,value in params.items():
                if count == 0:
                    get_params = get_params + key + "=" + value
                else: 
                    get_params = get_params + "&" + key + "=" + value
                count = count + 1
            response = ecli.issue_get_request("{0}/capacity/compatibility/catalog{1}".format(host,get_params), False)
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_capacity_gioperation(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("capacity", "gioperation", params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = json.load(open(params["jsonpath"]))
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exacompute","{0}/capacity/gi".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_undo_exascale_configuration(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "undoExascale", params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()
        payload["undo"]="true"
        payload["exascale"]="true"
        payload["storagexsGb"]=0
        payload["totalxsGB"]=0
        data = json.dumps(payload, indent=4, sort_keys=True)
        #call ecra to update OCI Exadata Details
        exa_ocid = params["exaOcid"]
        url = "{0}/capacity/exadata/{1}/xsconfig".format(host, exa_ocid)
        cl.prt("c", "PUT" + url+" " +data)
        response = self.HTTP.put(url,data,"capacity")
        if response:
            cl.prt("n", json.dumps(response))

    def do_clean_ecra_meta_data(self,ecli,line,host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("ocicapacity", "cleanupmetadata", params)
        except Exception as e:
            cl.perr(str(e))
            return
        pass
        exaOcid = params["exaOcid"]
        idemtoken = params["idemtoken"]
        url = "{0}/capacity/{1}/{2}/ecraMetaDataCleanup".format(host,exaOcid,idemtoken)
        cl.prt("c", "DELETE " + url)
        response = self.HTTP.delete("{0}/capacity/{1}/{2}/ecraMetaDataCleanup".format(host,exaOcid,idemtoken))
        if response:
            cl.prt("n", json.dumps(response))

    def do_regenerate_dbcs_wallets_infra (self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicapacity", "regenerateDBCSWallets", params)
        except Exception as e:
            cl.perr(str(e))
            return
        exaOcid = params["exaOcid"]
        outputDir = params["outputDir"]
        type = params["type"]
        if type not in ["initial", "current"]:
            cl.perr("Type invalid. Valid values: initial, current")
        url = "{0}/capacity/exadata/{1}/dbcsWallets?outputDir={2}&type={3}".format(host,exaOcid,outputDir, type)
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False) 
        if response:
            cl.prt("n", json.dumps(response))

    def do_configure_exascale(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        ecra_env = ecli.issue_get_request("{0}/properties/{1}".format(self.HTTP.host, "ECRA_ENV"),False)
        ecra_env = ecra_env["property_value"]
        # Validate the parameters
        try:
            if ecra_env == "ociexacc":
                ecli.validate_parameters("ocicapacity", "configureExascale", params)
            else:
                ecli.validate_parameters("capacity", "configureExascale", params)
        except Exception as e:
            cl.perr(str(e))
            return
        payload = {}
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()
        payload["exascale"]="true"
        if "vmstoragexsGb" in params:
            payload["vmstoragexsGb"] = params["vmstoragexsGb"]

        #call ecra to update OCI Exadata Details
        if ecra_env == "ociexacc":
            payload["storagexsGb"]=params["storagexsGb"]
            exa_ocid = params["exaOcid"]
            url = "{0}/capacity/exadata/{1}/xsconfig".format(host, exa_ocid)
        else:
            infra_ocid = params["infraOcid"]
            payload["totalxsGB"]=params["storagexsGb"]
            url = "{0}/exadatainfrastructure/{1}/exascale/xsconfig".format(host, infra_ocid)
        data = json.dumps(payload, indent=4, sort_keys=True)
        cl.prt("c", "PUT" + url+" " +data)
        response = self.HTTP.put(url,data,"capacity")
        if response:
            cl.prt("n", json.dumps(response))

    def do_mark_cells_to_delete(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("ocicapacity", "markCellsToDelete", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["deleteCellList"] = [cellName.strip() for cellName in params["cellList"].split(",")]

        data = json.dumps(payload)
        url = "{0}/capacity/exadata/{1}/markCellsToDelete".format(host, params["exaOcid"])
        cl.prt("c", " ".join(["PUT", url, data]))
        response = self.HTTP.put(url, data, "capacity")
        if response:
            cl.prt("n", json.dumps(response))


#EOF
