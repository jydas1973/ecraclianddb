#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Artifact.py /main/1 2024/06/25 19:37:35 jzandate Exp $
#
# Artifact.py
#
# Copyright (c) 2024, Oracle and/or its affiliates.
#
#    NAME
#      Artifact.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    jzandate    02/27/24 - Enh 36193252 - Adding artifacts cli
#    jzandate    02/27/24 - Creation
#

from formatter import cl
import json

class Artifact:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        
    def do_deliver(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("artifact", "deliver", params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        params["artifact"] = params["artifactname"]

        response = self.HTTP.post(json.dumps(params), "artifact", "{0}/artifact/deliver".format(host))
        if response:
            cl.prt("n", json.dumps(response, sort_keys=True, indent=2))

    def do_deliver_status(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("artifact", "deliver_status", params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        id = params["statusid"]
        url = "{0}/requests/{1}?fields=component_response".format(host, id)
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, sort_keys=True, indent=2))