#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/User.py /main/7 2025/03/24 11:46:31 rothakk Exp $
#
# py
#
# Copyright (c) 2022, 2025, Oracle and/or its affiliates.
#
#    NAME
#      py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    rothakk     03/12/25 - Bug 37684216 - EXACS:ECS MAIN:USER
#                           /RESETPASSWORD/CREATE/DELETE/UPDATE APIS TO USE THE
#                           USERNAME AS INPUT PARAM INSTEAD OF USERID/ID
#    abysebas    01/23/25 - Enh 37496297 - CREATE NEW USER IN SIV FROM ECRA
#    kukrakes    08/09/23 - Bug 35650508 - ECRA NG - USER MANAGEMENT API,
#                           FAILING TO RESET USER PASSWORDS FROM ECRALCI
#    abysebas    01/04/23 - EXACS-104079 : Refresh credentials after updating
#                           password
#    aadavalo    10/24/22 - Enh 34582054 - Create cli interaction for user
#                           management API
#    aadavalo    10/24/22 - Creation
#

from formatter import cl
from clis.PasswordManagement import PasswordManagement
import json

class User:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def map_params(self, params, type="dict"):
        # Add here any other params that need mapping so every 
        # ecli params are in lowercase, no dash and
        # no underscores. Params not present in map
        # will be passed as they are given.
        params_map = {
            "userid": "user_id",
            "firstname": "first_name",
            "lastname": "last_name",
            "roleid": "role_id",
            "password": "password",
            "active": "active",
            "createdby": "created_by",
            "modifiedby": "modified_by",
            "createdat": "created_at",
            "updatedat": "updated_at",
            "deletedat": "deleted_at",
            "reusesiv" : "get_from_siv"
        }

        if type == "dict":
            return  { params_map.get(k, k): v for k, v in params.items() }
        elif type == "list":
            return [ params_map.get(k, k) for k in params ]

    def do_get_all(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'getall', params)
        except Exception as e:
            cl.perr(str(e))
            return
        response = self.HTTP.get("{0}/users".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_get(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'get', params)
        except Exception as e:
            cl.perr(str(e))
            return
        user_id = params.get('userid')
        response = self.HTTP.get("{0}/users/{1}".format(host, user_id))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_reset_password(self, ecli, line, host, ecracli_home):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'resetpassword', params)
        except Exception as e:
            cl.perr(str(e))
            return
        user_id = params.get("userid")
        params['new_password'] = params.pop('newpassword')
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, None, "{0}/users/{1}/resetPassword".format(host, user_id))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
            # Call refresh API for both the hosts
            passwordObj = PasswordManagement(self.HTTP)
            passwordObj.do_refresh_credentials_both_hosts(ecracli_home, host, False, False)

    def do_create(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'create', params)
        except Exception as e:
            cl.perr(str(e))
            return
        mapped_params = self.map_params(params)
        # Ensure first_name, last_name, and role_id are not empty or null
        user_id = mapped_params.get("user_id", "").strip()
        if not mapped_params.get("first_name") or not mapped_params["first_name"].strip():
            mapped_params["first_name"] = user_id
        if not mapped_params.get("last_name") or not mapped_params["last_name"].strip():
            mapped_params["last_name"] = user_id
        if not mapped_params.get("role_id") or not mapped_params["role_id"].strip():
            mapped_params["role_id"] = "2"

        data = json.dumps(mapped_params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, None, "{0}/users".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_update(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'update', params)
        except Exception as e:
            cl.perr(str(e))
            return
        user_id = params.get('userid')
        mapped_params = self.map_params(params)
        data = json.dumps(mapped_params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/users/{1}".format(host, user_id), data, None)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_delete(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'delete', params)
        except Exception as e:
            cl.perr(str(e))
            return
        user_id = params.get('userid')
        response = self.HTTP.delete("{0}/users/{1}".format(host, user_id))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_activate(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'activate', params)
        except Exception as e:
            cl.perr(str(e))
            return
        user_id = params.get('userid')
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, None, "{0}/users/{1}/activation".format(host, user_id))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_deactivate(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'deactivate', params)
        except Exception as e:
            cl.perr(str(e))
            return
        user_id = params.get('id')
        response = self.HTTP.delete("{0}/users/{1}/activation".format(host, user_id))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_refresh_credentials(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('user', 'refreshcredentials', params)
        except Exception as e:
            cl.perr(str(e))
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, None, "{0}/users/refresh-credentials".format(host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

