#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/VMConsole.py /main/4 2023/06/10 16:28:39 ddelgadi Exp $
#
# VMConsole.py
#
# Copyright (c) 2023, Oracle and/or its affiliates.
#
#    NAME
#      VMConsole.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    ddelgadi    06/08/23 - Enh 35441136 - remove wrong print
#    luperalt    04/19/23 - Bug 35279983 - Fixed vmconsole response
#    luperalt    03/02/23 - Bug 35112601 Added enableVMConsole command
#    luperalt    02/16/23 - Bug 34926012 - Creation
#
from formatter import cl
import socket
import json
import re
class VMConsole:
     def __init__(self, HTTP):
        self.HTTP = HTTP
     def do_vmconsole_deployment(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("vmconsole", "deployment", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["action"] = params["action"]
        actionTypes =['status', 'uninstall', 'install']
        if not payload["action"] in actionTypes:
           cl.perr("action valid options are: install, uninstall and status")
           return
        parameters = False;
        if 'dom0' in params:
           payload["dom0"] = params["dom0"]
           parameters = True;
        if 'exaOcid' in params:
           payload["exaOcid"] = params["exaOcid"]
           parameters = True;
        if 'exaunitId' in params:
           payload["exaunitId"] = params["exaunitId"]
           parameters = True;

        if parameters is False:
           cl.perr("Specify at least one parameter [dom0], [exaunitId] or [exaOcid]")
           return
 
        data = json.dumps(payload, sort_keys=True, indent=4)
        # Rotate the Cipher psswd for the ECRA instance
        url = "{0}/vmconsole".format(host)
        response = self.HTTP.put(url, data, "network")

        # Print response obtained from ECRA
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True) )


     def do_enable_vm_console(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("vmconsole", "enable", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCI Exadata details
        if ecli.interactive:
            cl.prt("c", "Enable vm console infra:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        url = "{0}/capacity/exadata/{1}/enableVMConsole".format(host, params["exaOcid"])
        cl.prt("c", "PUT " + url)
        response = self.HTTP.put(url, None, "capacity")
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))
