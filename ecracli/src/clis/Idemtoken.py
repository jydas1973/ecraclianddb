"""
 Copyright (c) 2015, 2024, Oracle and/or its affiliates.

NAME:
    Idemtoken - CLIs for creating a new idemtoken

FUNCTION:
    Provides the clis to get a new idemtoken

NOTE:
    None

History:
    zpallare    23/04/2024 - Adding method to renew idemtoken
    rgmurali    05/15/2017 - Create file
"""
from formatter import cl
import json

class Idemtoken:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        
    def do_idemtoken_new(self, ecli, line, host):
        try:
            ecli.validate_parameters('idemtoken', 'new')
        except Exception as e:
            cl.perr(str(e))

        cl.prt("c", "Request new idemtoken")
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
        cl.prt("n", "Response data")
        for key, value in retObj.items():
            cl.prt("p", "{0} : {1}".format(key, value))

    def do_idemtoken_renew(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="idemtoken")
        try:
            ecli.validate_parameters('idemtoken', 'renew')
        except Exception as e:
            cl.perr(str(e))
            return
        idemtoken = params.get("idemtoken")
        if idemtoken is None or idemtoken == "":
            cl.perr("You should provide an idemtoken")
            return
        response = self.HTTP.post("", "idemtokens", \
                "{0}/idemtokens/{1}/renew".format(host,idemtoken))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
