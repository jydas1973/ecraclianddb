#!/usr/bin/env python
# -*- coding: utf-8 -*-
# THIS FILE CONTAINS ECRACLI FUNCTIONALITY
# $Header: ecs/ecra/ecracli/src/clis/Ecra.py /main/13 2025/08/08 22:35:17 zpallare Exp $
#
# apiv2.py
#
# Copyright (c) 2013, 2025, Oracle and/or its affiliates.
#
#    NAME
#      ECRA - CLI to execute ECRA related commands
#
#    DESCRIPTION
#      Provides the clis to perform ECRA ops
#
#    NOTES
#      ecracli
#
#    MODIFIED   (MM/DD/YY)
#    zpallare    07/29/25 - Enh 38205599 - Fix issue with connect
#    gvalderr    11/26/24 - Enh 37316013 - Adding command for updating and
#                           listing files
#    zpallare    01/17/24 - Enh 35865892 - ECRA, ECRACLI - Provide mechanism to
#                           connect to a different ecraserver
#    jzandate    08/04/23 - Enh 35651071 - Adding delete ECRA_FILE from date
#    ririgoye    02/17/23 - Enh 34402212 - REQUIREMENT FOR HEALTH CHECK API
#    gvalderr    12/14/22 - Adding code for the request http for the ecra
#                           getfile command
#    jvaldovi    09/15/22 - Enh 33994048 - Ecra To Send Region Info On Exacloud
#                           Start Call, Remove Region Endpoint Call
#    jvaldovi    01/11/22 - Enh 33605620 - Ecra Deployer To Create
#                           Regions-Config.Json And Communicate Changes To
#                           Exacloud
#    illamas     11/10/20 - Enh 32061490 - Adding coredump feature support
#    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
#    jvaldovi    10/09/19 - Create file

from formatter import cl
from os import path
import http.client
import json
import os
import urllib.parse

class Ecra:
    def __init__(self, HTTP):
        self.HTTP = HTTP
    
    
    def do_validate_apis(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('ecra', 'validateApis', params)
        except Exception as e:
            return cl.perr(str(e))
        # load payload
        payload_path = ""
        if ("json_path" in params):
             payload_path = params["json_path"]

        # Payload path must exist
        if (not os.path.isfile(payload_path)):
            cl.perr("Validate Health payload path: %s does not exist." % payload_path)
            return

        # Load payload
        with open(payload_path) as f:
            payload = json.load(f)
        data  = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.issue_http_request("POST", "{0}/healthcheck".format(host), data)
        if response:
            cl.prt("n", json.dumps(response))
            
    def do_dump_config(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('ecra', 'dumpConfig', params)
        except Exception as e:
            return cl.perr(str(e))
        # load payload
        if ("target" in params):
            target = params["target"]
            #here can be added another targets
            if(target == "ecracli"):       
                data  = json.dumps(ecli.configJson, sort_keys=True, indent=4)
                cl.prt("p", data)
                return
            else:
                cl.perr("Please check target value")
                return

    def do_core_dump(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('ecra', 'coreDump', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunitId = params["exaunitId"]
        url  = "{0}/exaunit/{1}/coredump".format(host,exaunitId)
        params.pop("exaunitId"); 
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(url, data, "ecra")
        if response:
            cl.prt("n", json.dumps(response))

    def do_upgrade_history(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("ecra", "upgradeHistory", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/version/upgrades".format(host)
        response = self.HTTP.query(url, params)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_get_file(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="filename")
        try:
            ecli.validate_parameters("ecra", "getfile", params)
        except Exception as e:
            cl.perr(str(e))
            return
        filename = params.pop("filename")
        url = "{0}/ecra/file?filename={1}".format(host,filename)
        response = self.HTTP.query(url, params)
        if not response:
            cl.perr("Failed to get file: " + filename)
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
    
    def do_ecra_health_check(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("ecra", "check", params)
        except Exception as e:
            cl.perr(str(e))
            return
        url = "{0}/ecra/healthcheck".format(host)
        response = self.HTTP.get(url)
        if not response:
            cl.perr("Failed to execute ECRA health check")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_ecra_deletepayloads(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("ecra", "deletepayloads", params)
        except Exception as e:
            cl.perr(str(e))
            return
        olderthan = params["olderthan"] if "olderthan" in params else None
        onlycheck = params["onlycheck"] if "onlycheck" in params else "true"
        olderthan = urllib.parse.quote(olderthan)
        url = "{0}/ecra/file?olderthan={1}&onlycheck={2}".format(host, olderthan, onlycheck)

        response = self.HTTP.delete(url)
        if not response:
            cl.perr("Failed to execute ECRA delete from")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_ecra_connect(self, ecli, line, host, interactive):
        params = ecli.parse_params(line, None, optional_key="hostname")
        result = {}
        try:
            ecli.validate_parameters("ecra", "connect", params)
        except Exception as e:
            cl.perr(str(e))
            return result
        hostname = ""
        if 'hostname' in params:
            hostname = params['hostname']
        elif interactive:
            url = "{0}/ecra/healthcheck".format(host)
            response = self.HTTP.get(url)
            if not response or "managedServers" not in response:
                cl.perr("Failed to retrieve available hosts")
                return result
            
            servers = response['managedServers']
            current = 1
            cl.prt("n", "Available Servers:")
            for item in servers:
                if 'hostname' in item:
                    cl.prt("n", "{0}) {1}".format(current,item['hostname']))
                current+=1
            
            cl.prt("n", "Select server [1]:")
            server = input()
            valid_option = False
            if server.isnumeric():
                server = int(server) - 1
                if server < len(servers):
                    valid_option = True
            if valid_option == False:
                cl.prt("n", "Invalid option, using default: {0}".format(\
                servers[0]['hostname']))
                server = 0
            hostname = servers[server]['hostname']
        else:
            cl.perr("The hostname param is required")
            return result

        result = self.is_valid_ecra_host(hostname)
        cl.prt("n", json.dumps(result, indent=4, sort_keys=False))
        return result
                
    #Check if hostname is valid
    def is_valid_ecra_host(self, hostname):
        result = {}
        try:
            req_headers = {}
            if hostname[-1] == "/":
                hostname = hostname[:-1]
            req_headers["Authorization"] = self.HTTP.auth_header
            req=urllib.request.Request("{0}/version".format(hostname),\
             headers=req_headers)
            response=self.HTTP.opener.open(req)
            result['status'] = 200
            result['hostname'] = hostname
            result['message'] = "The ECRA host has been set to: {0}"\
            .format(hostname)
        except (http.client.HTTPException,urllib.error.URLError,Exception) as e:
            result['status'] = 404
            result['message'] = "*** ECRA communication. Please "\
            +"ensure host '%s' is up and running and credentials are ok. ***"\
            % hostname
        return result

    def do_update_file_ecra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('ecra', 'updatefile', params)
        except Exception as e:
            return cl.perr(str(e))

        filename = params.pop("filename")
        contentpath = params.pop("contentpath")
        url = "{0}/ecra/file?filename={1}&contentpath={2}".format(host, filename, contentpath)
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put(url, data, "ecra")
        if response:
            cl.prt("n", json.dumps(response))

    def do_list_files_ecra(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("ecra", "listfiles", params)
        except Exception as e:
            cl.perr(str(e))
            return

        url = "{0}/ecra/filelist".format(host)
        response = self.HTTP.query(url, params)
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
