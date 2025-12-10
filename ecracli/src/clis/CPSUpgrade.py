#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/CPSUpgrade.py /main/1 2022/10/24 16:38:17 oespinos Exp $
#
# CPSUpgrade.py
#
# Copyright (c) 2022, Oracle and/or its affiliates.
#
#    NAME
#      CPSUpgrade.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    oespinos    10/17/22 - Creation
#
"""
 Copyright (c) 2020, 2022, Oracle and/or its affiliates.

NAME:
    CPS patching - CLIs for handling CPS pre/post upgrade oneoff scripts

FUNCTION:
    Provides the clis to manage CPS oneoff scripts for SW/OS upgrade

NOTE:
    None

History:
    oespinos    10/17/22 - Creation
"""

from formatter import cl
import json
import os

class CPSUpgrade:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        self.DEFAULT_COMP = "CPSSW"


    def do_cps_tar_upload(self,ecli,line,host):
        rest = line 
        data = None

        if rest:
            data = json.dumps(ecli.parse_params(rest, None))

        # Get token to send cps tar request
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token to cps patch tar")
            cl.prt("n", "Response data")
            for key, value in retObj.iteritems():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        idemtoken = retObj["idemtoken"]
        cl.prt("c", "Idemtoken is: " + idemtoken )

        params = ecli.parse_params(rest, None)
        cpsPatchPayload = None
        if not "cps_tar_payload" in params:
            cl.perr("Missing cps_tar_payload value")
            return
        with open(params["cps_tar_payload"]) as json_file:
            cpsPatchPayload = json.load(json_file)

        # Default component if not provided
        if not "component_name" in cpsPatchPayload:
            cpsPatchPayload["component_name"] = self.DEFAULT_COMP

        cpsPatchPayload["idemtoken"] = idemtoken
        data = json.dumps(cpsPatchPayload)
        cl.prt("p", data )
        response = self.HTTP.post(data, "exadata", "{0}/patching/dynTask/tarLoc".format(self.HTTP.host))
        cl.prt("c", json.dumps(response))

