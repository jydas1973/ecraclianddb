#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/ExascaleVault.py /main/1 2024/12/18 02:40:56 abyayada Exp $
#
# ExascaleVault.py
#
# Copyright (c) 2024, Oracle and/or its affiliates.
#
#    NAME
#      ExascaleVault.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    abyayada    12/12/24 - Creation
#
from formatter import cl
import json
import os
import urllib.request, urllib.error, urllib.parse
import shutil
from urllib.request import Request

class ExascaleVault:

    def __init__(self, HTTP):
        self.HTTP = HTTP

      
    def do_get_xs_vault_details(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("vault", "details", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get OCI Exadata details
        if ecli.interactive:
            cl.prt("c", "Get Vault details with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        ecraenv_response = ecli.issue_get_request("{0}/properties/ECRA_ENV".format(host), False)
        ecraenv_value = ecraenv_response.get("property_value")
        url = ""
        if ecraenv_value == "bm":
            url = "{0}/exadatainfrastructure/{1}/exascale/vault".format(host, params["exaOcid"])
        else:
            url = "{0}/exadata/{1}/vaults".format(host, params["exaOcid"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))

#EOF
