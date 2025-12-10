"""
 Copyright (c) 2018, 2024, Oracle and/or its affiliates.

NAME:
    Exadata - CLI for exadata resources

FUNCTION:
    Provides the cli to query the exadata information

NOTE:
    None

History:
    jzandate    07/01/2024 - Enh 36197323 - Adding new endpoint for hardware models
    piyushsi    09/17/2018 - Call Broker Endpoint to Fetch Exadata Network Info
    piyushsi    08/03/2018 - Create file
"""
from formatter import cl
import json

class Exadata:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_fetch_network_info(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        zone = None
        # Validate the parameters
        try:
            ecli.validate_parameters('exadata', 'network_info', params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get network information
        racksize = params["racksize"]
        if "zone" in params:
            zone = params["zone"]
        if zone == None:
            # Send the request to local ECRA
            url = "{0}/exadata/networks?racksize={1}".format(host, racksize)
        else:
            # Zone is given, Broker URL will be called
            url = "{0}/broker/exadata/networks?racksize={1}&zone={2}".format(host, racksize, zone)
            
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)

        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))

    def do_models(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('exadata', 'models', params)
        except Exception as e:
            cl.perr(str(e))
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""

        response = ecli.issue_get_request("{0}/exadata/models{1}".format(host, query), False)
        cl.prt("n", json.dumps(response, sort_keys=True, indent=4))
