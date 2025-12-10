"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    Vm - CLIs to start/stop and restart VM

FUNCTION:
    Provides the clis to perform operations on VM

NOTE:
    None

History:
    jesandov    10/30/25 - 38554948: Add force shutdown and force bounce
    gvalderr    10/02/25 - Enh 38431945 - Adding force flag to vm action
                           endpoint
    zpallare    12/04/24 - Enh 36754344 - EXACS Compatibility - create new 
                           apis for compatibility matrix and algorithm for locking
    zpallare    01/10/24 - Bug 36110921 - Node recovery : ecra apis support
                           required for sop automation
    zpallare    10/04/23 - Bug 35862588 - ECRA, ECRACLI - Fix vm stop and
                           exaunit suspend
    jzandate    08/22/22 - Enh 34511129 - Adding command to ping exaunit vm
    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
    rgmurali    07/06/17 - Create file
"""
from formatter import cl
from .Exaunit import Exaunit
import socket
import json
import re


class Vm:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        
    def do_status_vm(self, ecli, line, host):
        tokens = line.split()
        num_tokens = len(tokens)
        if num_tokens != 2:
            cl.perr("Please use- vm status <exaunit_id> <vm_name>")
            return
        exaunit_id, domuCustomerHostname = ecli.exaunit_id_from(tokens[0]), tokens[1]
        if not re.match(r"[a-zA-Z0-9\.\-\_]+$", domuCustomerHostname):
            cl.perr("Please use a valid vm_name")
            
        response = self.HTTP.get("{0}/exaunit/{1}/vms/{2}".format(host, exaunit_id, domuCustomerHostname))
        
        cl.prt("c", json.dumps(response, sort_keys=True, indent=4))

    # perform vm start/stop/restart
    def vm_operation(self, ecli, action, line, host):
        num_tokens = len(line.split())
        if num_tokens < 2 or num_tokens > 4 :
            cl.perr("Please use- vm <action> <exaunit_id> <vm_name> [env=<env-value>][force=true/false]")
            return
        line = line.split()
        exaunit_id, hostname = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        if not hostname:
            cl.perr("Please use- vm <action> <exaunit_id> <vm_name> [env=<env-value>][force=true/false]")
            return

        env_value = "gen1"
        if num_tokens >= 3:
            params = ecli.parse_params(" ".join(line[2:]), None)

            # Validate all the parameters and values
            try:
                ecli.validate_parameters('vm', 'action', params)
            except Exception as e:
                cl.perr(str(e))

            if type(params) is str:
                cl.perr("Invalid optional parameters: " + line[2])
                return

            if "env" in params:
                env_value = params["env"]
                if env_value != "gen1" and env_value != "gen2":
                    cl.perr("The only supported value for env param is gen1 and gen2")
                    cl.perr("Please use- vm <action> <exaunit_id> <vm_name> [env=<env-value>]")
                    return

        #search the fqdn
        #The check will not work in gen2 due to networking setup.
        #actually it's not very helpful to do this check even in gen1 too
        if env_value == "gen1":
            try:
                hostname = socket.getfqdn(hostname)
                socket.gethostbyname(hostname)
            except socket.gaierror as e:
                cl.prt("r","Warning: The <vm_name> given may be wrong.")

        #Check if the vm_name is one of the exaunit vms
        exaunitObj = Exaunit(self.HTTP)
        vms = []
        if hostname.find('flowtester_vm_test_') == -1:
            vms = exaunitObj.get_exaunit_vms(ecli, exaunit_id, host)

        if hostname not in vms and hostname != "_all_" and hostname.find('flowtester_vm_test_') == -1:
            cl.perr("Invalid <vm_name>.")
            cl.prt("n","Valid vm names are: {0}".format(str(vms)))
            return

        if "force" in params:
            force = params["force"]
        else:
            force = "false"

        vmJson = {"action" : action, "exaunitID" : exaunit_id, "force": force}

        if ecli.interactive:
            cl.prt("c", "{0}ing vm {1} on exaunit {2}".format(action.capitalize(), hostname, exaunit_id))

        data = json.dumps(vmJson, sort_keys=True, indent=4)
        response = ""
        if (env_value == "gen1"):
            response = self.HTTP.put("{0}/vms/{1}".format(host, hostname), data, "vms")
        elif (env_value == "gen2"):
            response = self.HTTP.put("{0}/exaunit/{1}/vms/{2}".format(host, exaunit_id, hostname), data, "vms")
        else:
            cl.perr("Unsupported value for env: " + env_value)
            return

        if response is None:
            return
        # case for return of 200 directly from ecra
        # this case is supported for negative testing
        # stop twice the vm
        if "status" in response and "message" in response:
            if response["status"] == 200:
                cl.prt("c", response["message"])
                return

        ecli.waitForCompletion(response, action + "_vm")

    def do_relation_vm(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("vm", "relation", params)
        except Exception as e:
            cl.perr(str(e))
            return
        domuname = params['domu']
        response = self.HTTP.get("{0}/vms/{1}/relation".format(host, domuname))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
            return

