#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/PasswordManagement.py /main/9 2024/07/29 04:02:08 ybansod Exp $
#
# PasswordManagement.py
#
# Copyright (c) 2021, 2024, Oracle and/or its affiliates.
#
#    NAME
#      PasswordManagement.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    ybansod     07/17/24 - Enh 35070702 - PROVIDE ECRACLI AND API TO VALIDATE
#                           PASSWORDS STORED IN SIV
#    abysebas    07/02/24 - Enh 36729554 - NEED SEPERATE COMMAND TO ADD
#                           SECRET_ID OF NEW USER
#    kukrakes    01/23/24 - Bug 36207161 - EXACS:23.4.1.2:PASSWORD
#                           ROTATION:ADMIN USER SHOWS AN ERROR MESSAGE AFTER
#                           ROTATE THE PASSWORD, BUT THE NEW PASSWORD WORKS
#    abysebas    06/27/23 - EXACS-114022 - Fetch vault OCID and feed it into
#                           the deployment.config and application.json.
#    abysebas    01/03/23 - EXACS-104079 : Refresh credentials after updating
#                           password
#    piyushsi    02/25/22 - BUG-33897090 Fetch SIV Info using vaultId and
#                           compartmentId
#    piyushsi    08/30/21 - Creation
#

from os import path, pardir
from formatter import cl
import json

class PasswordManagement:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_passwordmanagement_rotate(self, ecli, line, host, ecracli_home):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("passwordmanagement", "rotate", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["usertype"] = params["usertype"]
        payload["username"] = params["username"]
        response = self.HTTP.put("{0}/passwordmanagement/rotate".format(host), json.dumps(payload), None)
        cl.prt("c", json.dumps(response, indent=4))
        isDBPasswordRotation = False
        if (params["usertype"] =="DB"):
            isDBPasswordRotation = True
            cl.prt("c", "Refreshing connection pool")
        if (response is not None):
            # Call refresh API for both the hosts
            self.do_refresh_credentials_both_hosts(ecracli_home, host, True, isDBPasswordRotation)
        else:
            cl.prt("c", "Password change failed, not refreshing connection pool")

    def do_passwordmanagement_change(self, ecli, line, host, ecracli_home):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("passwordmanagement", "change", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["usertype"] = params["usertype"]
        payload["username"] = params["username"]
        payload["newpassword"] = params["newpassword"]
        isDBPasswordRotation = False
        if (params["usertype"] =="DB"):
            isDBPasswordRotation = True
            cl.prt("c", "Refreshing connection pool")
        response = self.HTTP.put("{0}/passwordmanagement/change".format(host), json.dumps(payload), None)
        cl.prt("c", json.dumps(response, indent=4))
        if (response is not None):
            # Call refresh API for both the hosts
            self.do_refresh_credentials_both_hosts(ecracli_home, host, True, isDBPasswordRotation)
        else:
            cl.prt("c", "Password change failed, not refreshing connection pool")

    def do_refresh_credentials_both_hosts(self, ecracli_home, host, refresh_both_hosts=False, isDBPasswordRotation=False):
        # Call refresh API for both the hosts
        ecra_home = path.abspath(path.join(ecracli_home, pardir))
        deployment_config = path.join(ecra_home, "deployment/state/deployment.config")
        managed_servers = None
        with open(deployment_config) as json_file:
            data = json.load(json_file)
            managed_servers = data['deployment']['wls']['managedservers']
        for server in managed_servers:
            hostname = server['host']
            endpoint = host.split(':')[2].split('/', 1)[1]
            urlPre = ""
            if host.startswith("https://"):
                portno = server['ssl_port']
                urlPre = "https://" + hostname + ":" + str(portno) + "/" + endpoint
            else:
                portno = server['port']
                urlPre = "http://" + hostname + ":" + str(portno) + "/" + endpoint
            url = urlPre + "/users/refresh-credentials"
            if (isDBPasswordRotation):
                url = urlPre + "/passwordmanagement/refresh-pool"
            # refresh credentials only required for remote ECRA in user reset password, password management needs to refresh explicitly
            if(refresh_both_hosts):
                cl.prt("c", "Refreshing credentials on host " + url)
                cl.prt("c", "POST " + url)
                resObj = self.HTTP.post("", "refreshcredentials", url)
                cl.prt("n", json.dumps(resObj))
            elif(host != urlPre):
                cl.prt("c", "Refreshing credentials on remote ECRA host " + url)
                cl.prt("c", "POST " + url)
                resObj = self.HTTP.post("", "refreshcredentials", url)
                cl.prt("n", json.dumps(resObj))

    def do_passwordmanagement_listuser(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("passwordmanagement", "listuser", params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = ecli.issue_get_request("{0}/passwordmanagement/listuser".format(host), False)
        cl.prt("c", json.dumps(response, indent=4))

    def do_passwordmanagement_getsiv(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("passwordmanagement", "getsiv", params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = ecli.issue_get_request("{0}/passwordmanagement/getsiv".format(host), False)
        cl.prt("c", json.dumps(response, indent=4))

    def do_passwordmanagement_seedsiv(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("passwordmanagement", "seedsiv", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        payload = {}
        if "region" in params:
            payload["region"] = params["region"]
        if "vault_name" in params:
            payload["vault_name"] = params["vault_name"]
        if "secrets" in params:
            payload["secrets"] = params["secrets"]
        payload["compartment_ocid"] = params["compartment_ocid"]
        payload["vault_id"] = params["vault_id"]
        response = self.HTTP.put("{0}/passwordmanagement/seedsiv".format(host), json.dumps(payload), None)
        cl.prt("c", json.dumps(response, indent=4))

    def do_passwordmanagement_updatesivinfo(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("passwordmanagement", "updatesivinfo", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["secret_name"] = params["secret_name"]
        response = self.HTTP.put("{0}/passwordmanagement/updatesivinfo".format(host), json.dumps(payload), None)
        cl.prt("c", json.dumps(response, indent=4))

    def do_passwordmanagement_validatepassword(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("passwordmanagement", "validatepassword", params)
        except Exception as e:
            cl.perr(str(e))
            return

        username = params.get("username")
        response = None
        if username is not None:
            response = ecli.issue_get_request("{0}/passwordmanagement/validatepassword/{1}".format(host, username), False)
        else:
            response = ecli.issue_get_request("{0}/passwordmanagement/validatepassword".format(host), False)
        cl.prt("c", json.dumps(response, indent=4))


