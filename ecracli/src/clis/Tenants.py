"""
 Copyright (c) 2015, 2024, Oracle and/or its affiliates.

NAME:
    Tenants - CLIs for handling Tenants specific actions 

FUNCTION:
    Provides the clis to manage tenants

NOTE:
    None

History:
    pverma    05/13/2019 - Create file
"""
from formatter import cl
import json
import os

class Tenants:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_list_ocitenants(self, ecli, line, host):
        # Call ECRA to get tenants list
        if ecli.interactive:
            cl.prt("c", "Getting list of tenants registered with this ECRA")

        url = "{0}/tenants".format(host)
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))
        
    def do_list_capacity_ocitenants(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocitenants", "capacity", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if params is None:
            params = {}
 
        # Call ECRA to get capacity details
        if ecli.interactive:
            cl.prt("c", "Get OCI tenant Exadata capacity with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        url = "{0}/capacity/exadata{1}".format(host, query)
        cl.prt("c", "GET " + url)
        
        response = ecli.issue_get_request(url, False, printPaginationHeaders=True)
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))

    def do_list_fleetcapacity_ocitenants(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocitenants", "fleetcapacity", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if params is None:
            params = {}

        # Call ECRA to get fleet capacity attributes
        if ecli.interactive:
            cl.prt("c", "Get OCI tenant Exadata capacity with parameters:")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        url = "{0}/capacity/exadata/all/basic{1}".format(host, query)
        cl.prt("c", "GET " + url)

        response = ecli.issue_get_request(url, False, printPaginationHeaders=True)
        cl.prt("c", json.dumps(response, indent=4, sort_keys=True))
