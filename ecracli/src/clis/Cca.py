"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Cca - CLIs for customer controlled access

FUNCTION:
    Provides the clis to add and remove cca users. Cli is only testing purpose
    Deployment uses ECRA exposed endpoints from middle-tier

NOTE:
    None

History:
    nisrikan    08/25/20 - Bug 31791748 - BACKPORT OPCTL FIXES TO MAIN
    nisrikan    04/29/20 - ER 31169019 - Create file
"""
from formatter import cl
import json
import os

class Cca:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_opctl_create_user(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            params = json.load(open(params["json_path"]))
        else :
            cl.prt("r", "Pass in a json file with correct keys")

        # Validate the parameters
        try:
            ecli.validate_parameters("opctl", "create_user", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        exaOcid = params['exaOcid']
        retObj = self.HTTP.post(data, "opctl", "{0}/exadata/{1}/opctl/user".format(host, exaOcid))
        if retObj:
            retObjJson = json.dumps(retObj, ensure_ascii=False).encode('utf8')
            cl.prt("b", retObjJson)

    def do_opctl_delete_user(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        if "json_path" in params:
            params = json.load(open(params["json_path"]))
        else :
            cl.prt("r", "Pass in a json file with correct keys")

        # Validate the parameters
        try:
            ecli.validate_parameters("opctl", "delete_user", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        accessRequestId = params['accessRequestId']
        exaOcid = params['exaOcid']
        retObj = self.HTTP.delete("{0}/exadata/{1}/opctl/user/{2}".format(host, exaOcid, accessRequestId), data)
        if retObj:
            retObjJson = json.dumps(retObj, ensure_ascii=False).encode('utf8')
            cl.prt("b", retObjJson)

    def do_opctl_assign(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        if "json_path" in params:
            params = json.load(open(params["json_path"]))
        else :
            cl.prt("r", "Pass in a json file with correct keys")

        # Validate the parameters
        try:
            ecli.validate_parameters("opctl", "assign", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        exaOcid = params['exaOcid']
        retObj = self.HTTP.PUT("{0}/exadata/{1}/opctl/assign".format(host, exaOcid), data)
        if retObj:
            retObjJson = json.dumps(retObj, ensure_ascii=False).encode('utf8')
            cl.prt("b", retObjJson)
