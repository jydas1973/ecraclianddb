#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/InfraPassword.py /main/1 2021/08/12 14:29:52 oespinos Exp $
#
# InfraPassword.py
#
# Copyright (c) 2021, Oracle and/or its affiliates. 
#
#    NAME
#      InfraPassword.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      Class for infra password rotation commands
#      Defines commands for get and rotate passwords
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    oespinos    06/14/21 - Infra password rotation project
#    oespinos    06/14/21 - Creation
#

from formatter import cl
import json

class InfraPassword:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_infrapassword_rotate(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("infrapassword", "rotate", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["infra_ocid"] = params["exaOcid"]
        payload["demand"] = "True"
        response = self.HTTP.put("{0}/rackpwdrotation".format(host), json.dumps(payload), None)
        cl.prt("c", json.dumps(response, indent=4))


    def do_infrapassword_get(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("infrapassword", "get", params)
        except Exception as e:
            cl.perr(str(e))
            return

        exaOcid = params["exaOcid"]
        response = ecli.issue_get_request("{0}/rackpwdrotation/{1}".format(host, exaOcid), False)
        cl.prt("c", json.dumps(response, indent=4))

