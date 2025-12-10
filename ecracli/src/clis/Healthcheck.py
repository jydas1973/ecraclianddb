"""
 Copyright (c) 2015, 2022, Oracle and/or its affiliates. 

NAME:
    Healthcheck - CLIs to perform health check operations

FUNCTION:
    Provides the clis to perform healthcheck

NOTE:
    None

History:
    dekuckre    01/09/2018 - Bug 27292546: Allow more parameters to be passed
                             to health check command.
    dekuckre    11/24/2017 - Bug 27082067: Remove spaces from the optional
                             parameters.
    rgmurali    07/07/2017 - Create file
"""
from formatter import cl
import json

class Healthcheck:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_health_check(self, ecli, line, host, mytmpldir):
        health_check_url = "{0}/clusterstatus/zone".format(host)
        #expecting line as "/health_check <rack_name>/exachk [arg=<arg>]"
        line = line.split(' ', 1)
        data = None
        request_type = line[0].rsplit('/', 1)
        if len(request_type) > 1 and request_type[1] == "exachk":
            def get_json():
               objJson = None
               inputJson = mytmpldir +  "/exachk.json"
               with open(inputJson) as json_file:
                   objJson = json.load(json_file)
               return objJson
            try:
                objJson = None
                if(len(line) == 1):
                    objJson = get_json()
                elif len(line) == 2 and line[1].split('=')[0].strip() == 'arg':
                    #custom nodes 
                    objJson = {}
                    if "cells" in line[1] or "ibswitches" in line[1] or "domu" in line[1]:
                        #support custom cmd run on dom0 only
                        objJson['dom0_verify'] = "True"
                        objJson['other'] = line[1].split('=')[1].strip()
                    else:
                       #
                        objJson = get_json()
                        objJson['other'] = line[1].split('=')[1].strip()
                else:
                    cl.perr("Please use health_check <rack_name>/exachk [arg=<arg>]")
                    return
                data = json.dumps(objJson)
            except Exception as e:
                cl.perr("Failed to form json payload: {0}".format(e))
                return

            health_check_url += "/" + line[0]
            response = self.HTTP.post(data, "health_check", health_check_url)
            ecli.waitForCompletion(response, "health_check")
        elif(len(line) == 2):
            # health_check <rack_name> [profilepath=</file_path/custom_profile.json>]
            params = ecli.parse_params(line[1], None)
            allowed_params = ["domucheck", "target_hosts"]
            if len(params) == 1 and "profilepath" in list(params.keys()):
                try:    
                    objJson = None
                    with open(params["profilepath"]) as json_file:
                        objJson = json.load(json_file)
                    data = json.dumps(objJson)
                    
                except Exception as e:
                    cl.perr("Failed to form json payload: {0}".format(e))
                    return
                
                health_check_url += "/" + line[0]
                response = self.HTTP.post(data, "health_check", health_check_url)
                cl.prt("n", json.dumps(response))
            #expecting line as "/health_check <rack_name>/envcheck [domucheck=<True|False>]" or 
            #"/health_check <rack_name> [target_hosts = dom0s,domUs,cells"] or
            elif "profilepath" not in list(params.keys()) and all(key in allowed_params for key in list(params.keys())):
                query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
                url = ("{0}/{1}{2}".format(health_check_url, line[0], query))
                ecli.issue_get_request(url)
            else:
                cl.perr(line[1] + " is not a valid option to be passed as part of health_check. Please check health_check help for valid options.")
                return
        else:
            if line[0]:
                health_check_url += "/" + line[0]
            ecli.issue_get_request(health_check_url)
