#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Cache.py /main/2 2023/01/27 17:33:09 ririgoye Exp $
#
# Cache.py
#
# Copyright (c) 2022, 2023, Oracle and/or its affiliates.
#
#    NAME
#      Cache.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      Class that helps to purge caches, refresh or change the state of any in-memory object
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    ririgoye    01/24/23 - Enh 34808479 - Added purge properties type
#    illamas     05/20/22 - Creation
#
from formatter import cl
import json

class Cache:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_purge(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('cache', 'purge', params)
        except Exception as e:
            return cl.perr(str(e))
        purge_endpoints = {
            "cspostchecks": "analytics/csconfigcheck",
            "csfilesystem": "exadatainfrastructure/filesystemcs",
            "ecsproperties": "properties/cache"
        }
        valid_types = purge_endpoints.keys()
        typePurge = params["type"].lower();
        if typePurge not in valid_types:
            return cl.perr("{0} is not valid, available commands are {1}".format(typePurge,valid_types))
        endpoint = purge_endpoints.get(typePurge)
        url = "{0}/{1}".format(host,endpoint)
        response = self.HTTP.delete(url)
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                cl.prt("n", json.dumps(response, sort_keys=False, indent=4)) 
# EOF
