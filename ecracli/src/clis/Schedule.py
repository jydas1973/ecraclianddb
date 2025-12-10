#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Schedule.py /main/3 2023/09/06 22:59:58 byyang Exp $
#
# Schedule.py
#
# Copyright (c) 2015, 2023, Oracle and/or its affiliates.
#
#    NAME
#      Schedule.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      Provides the clis for
#          schedule add
#          schedule delete
#          schedule list
#          schedule update
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    byyang     08/26/23 - bug 33754780 enhance schedule cmd usability
#    byyang     08/19/17 - Created

# Copyright (c) 2023, Oracle and/or its affiliates.

from formatter import cl
import json

 
class Schedule:

    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host

    def do_add_schedule(self, line):
        if len(line.split()) != 1:
            cl.perr('schedule add takes a mandatory argument <job_desc_file>')
            return
        jsonfile = line;
        url = '{0}/schedule'.format(self.host)
        self.issue_http_request('POST', url, jsonfile)

    def do_delete_schedule(self, line):
        if len(line.split()) != 1:
            cl.perr('schedule delete takes a mandatory argument <job_id>')
            return
        job_id = line
        url = '{0}/schedule/{1}'.format(self.host, job_id)
        self.issue_http_request('DELETE', url)

    def do_list_schedule(self, line):
        tokens = line.split()
        if len(tokens) > 1:
            cl.perr('schedule list takes no argument, '
                    'or takes <job_id> or <substring of job_class>')
            return

        query_params = "?scheduledjobkey={0}".format(tokens[0]) if len(tokens) == 1 else ""
        url = '{0}/schedule{1}'.format(self.host, query_params)
        self.issue_http_request('GET', url)

    def do_update_schedule(self, ecli, line):
        if len(line.split()) < 2:
            cl.perr('schedule update takes 2 or more mandatory arguments <job_id> [key=value]*]')
            return

        job_id, params_str = line.split(None, 1)
        params = ecli.parse_params(params_str, None)
        url = '{0}/schedule/{1}'.format(self.host, job_id)
        self.issue_http_request('PUT', url, params)

    def issue_http_request(self, http_method, url, jsondata=None):
        cl.prt('c', '{0} {1}'.format(http_method, url))
        if isinstance(jsondata, dict):
            data = json.dumps(jsondata)
        elif isinstance(jsondata, str):
            with open(jsondata, 'r') as fh:
                data = fh.read().replace('\n', '')

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
        cl.prt('n', json.dumps(res, sort_keys=True, indent=4, separators=(',', ': ')))



