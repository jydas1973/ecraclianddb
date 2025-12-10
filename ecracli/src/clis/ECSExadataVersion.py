"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    CLI for fetching applied version on exadata cloud env.

FUNCTION:
    Provides the clis to manage ecs exadata patching versions.

NOTE:
    CLI is for fetching applied version of exadata.

History:
    bshenoy    10/11/2019 - Bug: 30288886 list exadata target applied version
    bshenoy    09/23/2019 - Create file
"""
from formatter import cl
import json
import os

class ECSExadataVersion:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        

    def do_list_exadata_version(self, ecli, line, host):
         params = ecli.parse_params(line, None)
  
         # Validate the parameters
         try:
             ecli.validate_parameters("exadata_applied_version", "list", params)
         except Exception as e:
             cl.perr(str(e))
             return
  
         if params is None:
             params = {}
   
         # Call ECRA to get patching details
         if ecli.interactive:
             cl.prt("c", "Getting list of applied Patches for Exadata:")
             for key, value in params.items():
                 cl.prt("c", "{0} : {1}".format(key, value))
 

         rackname = params["rackname"]
         url = "{0}/clusterstatus/exadata/{1}".format(host, rackname)
         cl.prt("c", "GET " + url)
          
         response = ecli.issue_get_request(url, False)
         cl.prt("c", json.dumps(response, indent=4, sort_keys=True))
