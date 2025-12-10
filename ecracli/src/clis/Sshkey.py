"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    Sshkey - CLI for SSH key operations

FUNCTION:
    Provides the cli to add, reset, rescue and delete sshkey

NOTE:
    None

History:
    zpallare    05/22/2025 - Enh 37657856 - Enh 37864848 - EXACS: ADBS: 
                             Key exchange api support : ecra support
    zpallare    03/04/2025 - Enh 37657856 - EXACS ECRA - Convert tempsskey
                             endpoint to workflow
    rgmurali    07/10/2017 - Create file
"""
from formatter import cl
import json
import os


class Sshkey:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def sshkey_operation(self, ecli, action, line, host):

        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, "sshkeyOperationParams", warning=False)

        try:
            ecli.validate_parameters('sshkey', 'action', params)
        except Exception as e:
            cl.perr(str(e))
            return

        env_value = "gen1"
        if "env" in params:
            env_value = params["env"]
            if env_value != "gen2" and env_value != "gen1":
                cl.perr("The only supported values for env param is gen1,gen2")
                return

        if env_value == "gen2":
            if "hostname" not in params or params["hostname"] is None or params["hostname"] == "" :
                cl.perr("Hostname is mandatory for gen2 environment")
                return

        vmJson = {"exaunitID" : exaunit_id, "action" : action}
        for name, value in list(params.items()):
            vmJson[name] = value

        vmJson["users"] = vmJson["users"].replace(" ", "").split(",")
        vmJson["vms"] = vmJson["vms"].replace(" ", "").split(",")
        key_file_path = vmJson["sshkey"]
        if not os.path.exists(key_file_path):
            cl.perr("SSH key path for sshkey operation is not valid")
            return
        with open(key_file_path, 'r') as ssh_key_file:
            vmJson["sshkey"] = ssh_key_file.read()

        if ecli.interactive:
            cl.prt("c", "{0} for user {1} at vm {2} on exaunit {3}".format(vmJson["action"], ", ".join(vmJson["users"]), ", ".join(vmJson["vms"]), exaunit_id))

        response = ""
        if (env_value == "gen1"):
            data = json.dumps(vmJson, sort_keys=True, indent=4)
            vmJson.pop("hostname", None)
            vmJson.pop("env", None)
            response = self.HTTP.put("{0}/vms".format(host), data, "vms")
        elif (env_value == "gen2"):
            # For Gen2, vm gets added based on URL PathParam
            vmJson.pop("vms", None)
            hostname = vmJson["hostname"]
            vmJson.pop("hostname", None)
            vmJson.pop("env", None)
            data = json.dumps(vmJson, sort_keys=True, indent=4)
            response = self.HTTP.put("{0}/exaunit/{1}/vms/{2}".format(host, exaunit_id, hostname), data, "vms")
        else:
            cl.perr("Unsupported value for env: " + env_value)
            return
        ecli.waitForCompletion(response, action)

    def do_get_ssh_info(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sshkey', 'get', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunit_id = None
        if "exaunit_id" in params:
            exaunit_id = params["exaunit_id"]
            params.pop("exaunit_id")

        if exaunit_id is None:
            return cl.perr("Could not find the exaunit id from given params %s"%params)
        
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/exaunit/{1}/fetchkeys{2}".format(host, exaunit_id, query), printResponse=False)

        if not response:
            return

        if not response["data"]:
            cl.prt("c", str(response))
            cl.prt("c", "No response data found for given query")
            return

        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))

    def do_create_public_key(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunit_id")
        try:
            ecli.validate_parameters('sshkey', 'createPublicKey', params)
        except Exception as e:
            return cl.perr(str(e))
        
        exaunit_id = params.pop("exaunit_id")
        params["idemtoken"] = ecli.getNewIdemtoken()
        wait = "true"
        if "wait" in params:
            wait = params.pop("wait")
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "vms", "{0}/exaunit/{1}/vms/sshkey".format(host, exaunit_id))

        if not response:
            cl.perr("Failed to create domU SSH key")
            return
        if wait == "false":
            cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
            return

        target_uri = ecli.pull_status(response["status_uri"], verbose=False)
        request_id = target_uri.split("/")[-1]
        
        response = self.HTTP.get(target_uri)
        if not response:
            cl.perr("Failed to GET target_uri {0}".format(target_uri))
            return
        response["request"] = request_id
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))


    def do_verify_public_key(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunit_id")
        try:
            ecli.validate_parameters('sshkey', 'verifyPublicKey', params)
        except Exception as e:
            return cl.perr(str(e))
        
        exaunit_id = params.pop("exaunit_id")
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = self.HTTP.get("{0}/exaunit/{1}/vms/tempkey/verify{2}".format(host, exaunit_id,query))

        if not response:
            cl.perr("Failed to verify domU SSH key")
            return
        
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))

    def do_delete_public_key(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunit_id")
        try:
            ecli.validate_parameters('sshkey', 'deletePublicKey', params)
        except Exception as e:
            return cl.perr(str(e))
        
        headers = {}
        headers["idemtoken"] = ecli.getNewIdemtoken()
    
        exaunit_id = params.pop("exaunit_id")
        #data = json.dumps(params, sort_keys=True, indent=4)
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = self.HTTP.delete("{0}/exaunit/{1}/vms/sshkey{2}".format(host, exaunit_id, query), data=None, header=headers)

        if not response:
            cl.perr("Failed to delete domU SSH key")
            return
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))

    def do_get_public_key(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="id")
        try:
            ecli.validate_parameters('sshkey', 'getPublicKey', params)
        except Exception as e:
            return cl.perr(str(e))

        operation_id = params.pop("id")
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.get("{0}/exaunit/{1}/vms/sshkey/{2}".format(host, 1,operation_id))

        if not response:
            cl.perr("Failed to get domU SSH key")
            return
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))

    def do_add_adbs_key(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('sshkey', 'addadbskey', params)
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

        exaunitId = params.pop("exaunitid")
        data = json.dumps(params, sort_keys=True, indent=4)
        url = "{0}/exaunit/{1}/vms/addadbskey".format(host, exaunitId)
        response = self.HTTP.post(data=data, resource="vms", uri=url, header=headers)
        if response:
            cl.prt("n", json.dumps(response))
        

    def do_remove_adbs_key(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('sshkey', 'removeadbskey', params)
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

        exaunitId = params.pop("exaunitid")
        data = json.dumps(params, sort_keys=True, indent=4)
        url = "{0}/exaunit/{1}/vms/removeadbskey".format(host, exaunitId)
        response = self.HTTP.post(data=data, resource="vms", uri=url, header=headers)
        if response:
            cl.prt("n", json.dumps(response))

