#!/usr/bin/env python
# -*- coding: utf-8 -*-
# THIS FILE CONTAINS ECRACLI FUNCTIONALITY
#
# Copyright (c) 2013, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Ecracli cli to handle diagnosis
#
#    DESCRIPTION
#
#    NOTES
#      ecracli
#
#    MODIFIED   (MM/DD/YY)
#    hcheon      12/02/25 - 37891253 Changed RsyslogOutput_PUT payload format
#    seha        02/29/24 - 36014885 Added netchk parameter to rackhealth api
#    hcheon      11/29/23 - 36052156 Added diagnosis rackhealth_* cmds
#    hcheon      08/21/23 - 35619159 Search url for adbcs patch logs
#    hcheon      07/10/23 - 34764008 Log search url for given request
#    hcheon      06/03/21 - 32811546 DB connection pool usage monitoring
#    byyang      05/12/21 - bug 32322406. add pre_logcol cmds
#    hcheon      11/11/20 - ER 32100233 - Add diagnosis ignore command
#    byyang      03/28/20 - ER 30887452. Allow unexpected params for logcol
#    jaseol      12/30/19 - Bug-30666174, replace logstash with rsyslog
#    byyang      09/26/19 - ER 30308961. Add diagnosis plgmon
#    byyang      07/20/19 - Creation


from formatter import cl
import json


class Diagnosis:

    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host
        return

    def do_rsyslog_get_diagnosis(self, ecli, line):
        url = '{0}/diagnosis/rsyslog/output'.format(self.host)
        self._issue_http_request('GET', url)
        return

    def do_rsyslog_set_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None)
        # Validate parameters
        try:
            ecli.validate_parameters("diagnosis", "rsyslog_set", params)
        except Exception as e:
            cl.perr(str(e))
            return
        target = params['target']
        value = params['value']
        url = '{0}/diagnosis/rsyslog/output/{1}'.format(self.host, target)
        jsonpayload = {"value": value}

        # add otto config
        if target == 'otto' and value.lower() == 'enabled':
            if 'otto_config_path' not in params:
                cl.perr('Please specify otto_config_path. diagnosis rsyslog_set target=otto value=enabled otto_config_path=<absolute_path_to_config_file>')
                return

            otto_config_path = params['otto_config_path']
            with open(otto_config_path, 'r') as f:
                otto_config = json.load(f)

            jsonpayload.update(otto_config)

        jsonpayload = json.dumps(jsonpayload)
        self._issue_http_request('PUT', url, jsonstr=jsonpayload)
        return

    def do_logcol_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('diagnosis', 'logcol', params, False) 
        except Exception as e:
            cl.perr(str(e))
            return  
        url = '{0}/diagnosis/logcol'.format(self.host)
        self._issue_http_request('PUT', url, jsonstr=json.dumps(params))
        return

    def do_add_pre_logcol_rack_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('diagnosis', 'add_pre_logcol_rack', params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/diagnosis/pre_logcol_rack/{1}'.format(self.host, params['name'])
        self._issue_http_request('POST', url, jsonstr=json.dumps(params))
        return

    def do_list_pre_logcol_rack_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('diagnosis', 'list_pre_logcol_rack', params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/diagnosis/pre_logcol_rack'.format(self.host)
        self._issue_http_request('GET', url)
        return

    def do_delete_pre_logcol_rack_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('diagnosis', 'delete_pre_logcol_rack', params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/diagnosis/pre_logcol_rack/{1}'.format(self.host, params['name'])
        self._issue_http_request('DELETE', url, jsonstr=json.dumps(params))
        return

    def do_plgmon_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('diagnosis', 'plgmon', params, False) 
        except Exception as e:
            cl.perr(str(e))
            return  
        url = '{0}/diagnosis/plgmon'.format(self.host)
        self._issue_http_request('PUT', url, jsonstr=json.dumps(params))
        return

    def do_add_ignore_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, optional_key='type')
        try:
            ecli.validate_parameters('diagnosis', 'add_ignore', params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/diagnosis/ignore/{1}'.format(self.host, params['type'])
        req = {'pattern': params['pattern']}
        self._issue_http_request('POST', url, jsonstr=json.dumps(req))

    def do_list_ignore_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, optional_key='type')
        try:
            ecli.validate_parameters('diagnosis', 'list_ignore', params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/diagnosis/ignore/{1}'.format(self.host, params['type'])
        self._issue_http_request('GET', url)

    def do_delete_ignore_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, optional_key='type')
        try:
            ecli.validate_parameters('diagnosis', 'delete_ignore', params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/diagnosis/ignore/{1}'.format(self.host, params['type'])
        if 'id' in params:
            req = {'id': params['id']}
        elif 'pattern' in params:
            req = {'pattern': params['pattern']}
        else:
            cl.perr('Either "id" or "pattern" should be specified')
            return
        self._issue_http_request('DELETE', url, jsonstr=json.dumps(req))

    def do_show_active_db_conn_diagnosis(self, ecli, line):
        url = '{0}/diagnosis/db_connection'.format(self.host)
        self._issue_http_request('GET', url)

    def do_db_conn_stacktrace_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None, optional_key='action')
        action = params.get('action')
        if action not in ['enable', 'disable', 'show']:
            cl.perr('Invalid action {0}'.format(action))
            return
        url = '{0}/diagnosis/db_connection/stack_trace_config'.format(self.host)
        if action == 'show':
            self._issue_http_request('GET', url)
        elif action == 'enable':
            self._issue_http_request('PUT', url,
                                     jsonstr=json.dumps({'enable': True}))
        elif action == 'disable':
            self._issue_http_request('PUT', url,
                                     jsonstr=json.dumps({'enable': False}))

    def do_logsearch_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None)
        cli_param_to_rest_param = {'request': 'ecra-requests',
                                   'workflow': 'ecra-workflows',
                                   'workflow_task': 'ecra-workflow-tasks',
                                   'exacloud_request': 'exacloud-requests',
                                   'patch_crid': 'patch-requests'}
        count = 0
        for cli_key, rest_key in cli_param_to_rest_param.items():
            if cli_key in params:
                url = '{0}/diagnosis/logsearchurls/{1}/{2}'.format(
                    self.host, rest_key, params[cli_key])
                count += 1
        if count != 1:
            cl.perr('1 request type should be specified: [{0}]'.format(
                ', '.join(cli_param_to_rest_param.keys())))
            return
        if 'scope' in params:
            scope = params['scope'].replace('_', '-')
            valid_scope_options = ['all', 'subrequests', 'single-request']
            if scope not in valid_scope_options:
                cl.perr('Invalid value for scope. Valid values are: '
                        'all, subrequests, single_request')
                return
            url = '{0}?scope={1}'.format(url, scope)
        # self._issue_http_request('GET', url)  # sort_keys is not good for this
        cl.prt('c', 'GET {0}'.format(url))
        res = self.HTTP.get(url)
        if not res:
            cl.perr('Failed to get ' + url)
            return
        cl.prt('n',json.dumps(res, indent=2))

    def do_rackhealth_run_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('diagnosis', 'rackhealth_run', params)
        except Exception as e:
            cl.perr(str(e))
            return
        target_type = params['type']
        targets = params['targets'].split(',')
        valid_types = ['clusters', 'cabinets']
        if target_type not in valid_types:
            cl.perr(f'"type" should be one of: {valid_types})')
            return
        payload = {target_type: targets}
        if 'checks' in params:
            checks = params['checks'].split(',')
            payload['checks'] = checks
        url = f'{self.host}/diagnosis/rackhealth/{target_type}'
        self._issue_http_request('POST', url, jsonstr=json.dumps(payload))

    def do_rackhealth_result_diagnosis(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('diagnosis', 'rackhealth_result', params)
        except Exception as e:
            cl.perr(str(e))
            return
        target_type = params['type']
        uuid = params['id']
        valid_types = ['clusters', 'cabinets']
        if target_type not in valid_types:
            cl.perr(f'"type" should be one of: {valid_types})')
            return
        url = f'{self.host}/diagnosis/rackhealth/{target_type}/{uuid}'
        self._issue_http_request('GET', url)

    def _issue_http_request(self, http_method, url, jsonfile=None, jsonstr=None):
        cl.prt('c','{0} {1}'.format(http_method, url))

        payload = None
        if jsonfile:
            with open (jsonfile, 'r') as fh:
                payload = fh.read().replace('\n', '')
        elif jsonstr:
            payload = jsonstr

        if http_method == 'DELETE':
            res = self.HTTP.delete(url, payload)
        elif http_method == 'POST':
            res = self.HTTP.post(payload, 'diagnosis', url)
        elif http_method == 'PUT':
            res = self.HTTP.put(url, payload, 'diagnosis')
        else:
            res = self.HTTP.get(url)

        if not res:
            cl.perr('Failed to get ' + url)
            return
        cl.prt('n',json.dumps(res, sort_keys=True, indent=4, separators=(',', ': ')))
