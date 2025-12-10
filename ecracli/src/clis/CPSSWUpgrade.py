"""
 Copyright (c) 2020, 2022, Oracle and/or its affiliates.

NAME:
    CPS patching - CLIs for handling CPS SW Patching

FUNCTION:
    Provides the clis to manage CPS infra

NOTE:
    None

History:
    bshenoy     09/28/20 - Bug 31913586: Ecracli support for cps sw patching
    bshenoy     09/28/20 - Creation
"""

from formatter import cl
import json
import os

class CPSSWUpgrade:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_cpssw_patch(self,ecli,line,host):
        rest = line 
        data = None

        if rest:
            data = json.dumps(ecli.parse_params(rest, None))

        # Get token to send provisioning request
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token to cps sw patch")
            cl.prt("n", "Response data")
            for key, value in retObj.iteritems():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        idemtoken = retObj["idemtoken"]
        cl.prt("c", "Idemtoken is: " + idemtoken )

        params = ecli.parse_params(rest, None)

        cpsSwPatchPayload = None
        if not "cps_payload" in params:
            cl.perr("Missing cps_payload value")
            return
        with open(params["cps_payload"]) as json_file:
            cpsSwPatchPayload = json.load(json_file)

        cpsSwPatchPayload["idemtoken"] = idemtoken

        data = json.dumps(cpsSwPatchPayload)
        cl.prt("p", data )

        response = self.HTTP.post(data, "exadata", "{0}/patching/patchCPS".format(self.HTTP.host))
        cl.prt("c", json.dumps(response))
        

    def do_cpssw_tar_upload(self,ecli,line,host):
        rest = line 
        data = None

        if rest:
            data = json.dumps(ecli.parse_params(rest, None))

        # Get token to send cpssw tar request
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token to cps sw patch tar")
            cl.prt("n", "Response data")
            for key, value in retObj.iteritems():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        idemtoken = retObj["idemtoken"]
        cl.prt("c", "Idemtoken is: " + idemtoken )

        params = ecli.parse_params(rest, None)
        cpsSwPatchPayload = None
        if not "cps_tar_payload" in params:
            cl.perr("Missing cps_tar_payload value")
            return
        with open(params["cps_tar_payload"]) as json_file:
            cpsSwPatchPayload = json.load(json_file)

        # Default component is CPSSW
        if not "component_name" in cpsSwPatchPayload:
            cpsSwPatchPayload["component_name"] = "CPSSW"

        cpsSwPatchPayload["idemtoken"] = idemtoken
        data = json.dumps(cpsSwPatchPayload)
        cl.prt("p", data )
        response = self.HTTP.post(data, "exadata", "{0}/patching/dynTask/tarLoc".format(self.HTTP.host))
        cl.prt("c", json.dumps(response))

