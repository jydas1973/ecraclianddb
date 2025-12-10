"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Heartbeat - CLIs for sub-operations under heartbeat (Rack Reachability)

FUNCTION:
    Provides the clis for
        heartbeat get
        heartbeat rack

NOTE:
    None

History:
    marcoslo     08/08/2020 - ER 30613740 Update code to use python 3
    joseort      06/17/2019 - Create file
"""
from formatter import cl
import json
 
class Heartbeat:

    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host

    def do_list_heartbeat(self, line):
        if len(line.split()) != 0:
            cl.perr('heartbeat list does not take any argument')
            return
        url = '{0}/heartbeat'.format(self.host)
        self.issue_http_request('GET', url)

    def do_list_heartbeat_exadata(self, ecli, line):
        tenant_ocid = None
        exa_ocid = None
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('heartbeat', 'exadata', params)
        except Exception as e:
            cl.perr(str(e))
        
        if "tenant_ocid" in params:
            tenant_ocid = params["tenant_ocid"]
       
        if "exadata_ocid" in params:
            exa_ocid = params["exadata_ocid"]

        url = '{0}/heartbeat/{1}/{2}'.format(self.host, tenant_ocid, exa_ocid)
        self.issue_http_request('GET', url)

    def do_heartbeat_enable_scheduler(self, ecli, line):
        enableHeartbeatScheduler = None
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('heartbeat', 'enableScheduler', params)
        except Exception as e:
            cl.perr(str(e))

        url = '{0}/heartbeat/enableHeartbeatScheduler'.format(self.host)
        data = json.dumps(params, sort_keys=True, indent=4)
        self.issue_http_request('PUT', url, data)

    def issue_http_request(self, http_method, url, data = None):
        cl.prt('c','{0} {1}'.format(http_method, url))

        if http_method == 'DELETE':
            res = self.HTTP.delete(url)
        elif http_method == 'POST':
            res = self.HTTP.post(data, 'schedule', url)
        elif http_method == 'PUT':
            res = self.HTTP.put(url, data, 'schedule')
        else:
            res = self.HTTP.get(url)

        if not res:
            cl.perr('Failed to get ' + url)
            return
        cl.prt('n',json.dumps(res, sort_keys=True, indent=4, separators=(',', ': ')))



