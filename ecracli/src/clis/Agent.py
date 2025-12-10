#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Agent.py /main/2 2022/05/03 16:26:05 marislop Exp $
#
# Agent.py
#
# Copyright (c) 2022, Oracle and/or its affiliates.
#
#    NAME
#      Agent.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      Communication with Exagent 
#
#    NOTES
#      Communication with Exagent 
#
#    MODIFIED   (MM/DD/YY)
#    marislop    04/21/22 - ENH 34009216 - dataplane diagnostics
#    marislop    03/04/22 - Endpoint for get, post and put methods
#    marislop    03/04/22 - Creation
#
from formatter import cl
import json

class Agent:
    def __init__(self,HTTP):
        self.HTTP = HTTP
    def do_agent_request(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('agent', 'request', params)
        except Exception as e:
            cl.perr(str(e))
            return
        try: 
            method = params['method']
            if(method == 'post' or method == 'put'):
                if 'payload' in params:
                    with open(params['payload']) as json_file:
                        payload = json.load(json_file)
                else:
                    payload = json.loads('{}')
                if 'token' in params:
                    payload['opc-idempotency-token'] = params['token']

            # Redirect to agent by calling ECRA
            url = "{0}/dbcsagent/{1}/{2}/{3}".format(host, params['exaunit'], params['domu'], params['url'])

            if(method == "get"):
                response = self.HTTP.get(url,"ecra")
            elif(method == "post"):
                response = self.HTTP.post(json.dumps(payload),"ecra",url)
            elif(method == "put"):
                response = self.HTTP.put(url,json.dumps(payload),"ecra")
            elif(method == "delete"):
                payload = self.HTTP.delete(url)
            else:
                raise Exception("Allowed methods: get, post, put and delete")
            if response:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=False))                                                                                                                                       
            else:
                cl.perr("Response {0}".format(response))
        except Exception as e:
            print(e)

    def do_dataplane_settings(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('agent', 'dataplane_settings', params)
        except Exception as e:
            cl.perr(str(e))
            return
        with open(params['payload']) as json_file:
            payload = json.load(json_file)

        url = "{0}/dataplane/diagnostics".format(host)
        response = self.HTTP.post(json.dumps(payload),"ecra",url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))                                                                                                                                               
