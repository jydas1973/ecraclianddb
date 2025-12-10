"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    CLI for fetching available and applied version on exadata cloud env and CPS
    services.

FUNCTION:
    Provides the clis to manage ecs patching versions.

NOTE:
    CLI is for fetching the available and applied version of exadata, exacloud,
    cps os image and cps software version.


History:
    bshenoy    09/08/2019 - Bug 30217554: Removed profile json from ecra, since
                            the profile should be located in exacloud side. 
    bshenoy    07/25/2019 - Bug 29875966: Fetch applied and available versions 
    bshenoy    07/25/2019 - Create file
"""
from formatter import cl
import json
import os

class ECSPatching:
      def __init__(self, HTTP):
          self.HTTP = HTTP
          
      def do_list_ecspatchversion(self, ecli, line, host):
          params = ecli.parse_params(line, None)
  
          # Validate the parameters
          try:
              ecli.validate_parameters("ecspatchversion", "list", params)
          except Exception as e:
              cl.perr(str(e))
              return
  
          if params is None:
              params = {}
   
          # Call ECRA to get patching details
          if ecli.interactive:
              cl.prt("c", "Getting list of available and applied Patches for Exadata and CPS services:")
              for key, value in params.items():
                  cl.prt("c", "{0} : {1}".format(key, value))
 

          rackname = params["rackname"]
          url = "{0}/clusterstatus/versions/{1}".format(host, rackname)
          cl.prt("c", "GET " + url)
          
          response = ecli.issue_get_request(url, False)
          cl.prt("c", json.dumps(response, indent=4, sort_keys=True))