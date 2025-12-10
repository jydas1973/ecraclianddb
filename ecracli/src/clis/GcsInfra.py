#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/GcsInfra.py /main/1 2021/10/14 15:25:17 rgmurali Exp $
#
# GcsInfra.py
#
# Copyright (c) 2021, Oracle and/or its affiliates. 
#
#    NAME
#      GcsInfra.py - clis to get data fro GCS
#
#    DESCRIPTION
#
#    NOTES
#
#    MODIFIED   (MM/DD/YY)
#    rgmurali    10/09/21 - Creation
#
from formatter import cl
import json

class GcsInfra:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_getinfo_gcsinfra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('gcsinfra', 'getinfo', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params.pop("rackname")
        response = ecli.issue_get_request("{0}/gcsinfrainfo/{1}".format(host, rackname), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

