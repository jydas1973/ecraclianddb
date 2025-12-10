"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Cluster - CLIs to get cluster details such as cells, ibswitches etc

FUNCTION:
    Provides the clis to get cluster details such as cells, dom0s, domUs, iloms etc

NOTE:
    None

History:
    rgmurali    10/16/2018 - Create file
"""
from formatter import cl
import json

class Cluster:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_details_cluster(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('cluster', 'details', params)
        except Exception as e:
            cl.perr(str(e))
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/cluster/details{1}".format(host, query), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

