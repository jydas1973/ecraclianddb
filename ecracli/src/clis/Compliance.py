"""
 Copyright (c) 2015, 2022, Oracle and/or its affiliates.

NAME:
    Compliance - CLIs for sub-operations under compliance (AEP/CM)

FUNCTION:
    Provides the clis for
        compliance scan
        compliance default_scan
        compliance base_cfg
        compliance cfg_status
        compliance cfg_history
        compliance report_oss_namespace
        compliance auto_revert
        compliance status
        compliance avfim

NOTE:
    None

History:
    seha         02/18/2022 - Bug-32260715 Run AV/FIM on a specific host
    hcheon       03/25/2021 - 32619051 Show diff summary from cfg_status command
    seha         11/11/2020 - Bug-31635349 Upload report to CSS bucket 
    hcheon       09/28/2020 - bug-31942864 Fixed pylint errors
    hcheon       01/20/2020 - 30683297 show diff summary from cfg_history show
    hcheon       08/28/2019 - bug-30208357 add compliance status command
    hcheon       07/31/2019 - bug-30025165 add compliance command
    hcheon       07/31/2019 - Create file
"""

from formatter import cl
import difflib
import json
import urllib


class Compliance:
    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host

    def do_compliance_scan(self, ecli, line):
        try:
            cmd, params = self.parse_params('scan', ecli, line, False,
                                            'enable', 'disable', 'show')
        except Exception as e:
            cl.perr(str(e))
            return

        filter_cond = {k: v for k, v in params.items()
                       if k in ['host', 'host_type', 'rack']}
        if not filter_cond:
            filter_cond['host'] = 'all'

        url = '{0}/compliance/aepcm_scan_config'.format(self.host)
        if cmd == 'show':
            self.issue_http_request('GET', url, filter_cond)
        else:
            req_body = filter_cond
            req_body['enable'] = (cmd == 'enable')
            self.issue_http_request('PUT', url, req_body)

    def do_compliance_default_scan(self, ecli, line):
        try:
            cmd, params = self.parse_params('default_scan', ecli, line, False,
                                            'enable', 'disable', 'show')
        except Exception as e:
            cl.perr(str(e))
            return

        url = '{0}/properties/COMPLIANCE_AEP_CM'.format(self.host)
        if cmd == 'show':
            self.issue_http_request('GET', url)
        elif cmd == 'enable':
            self.issue_http_request('PUT', url, {'value': 'enabled'})
        elif cmd == 'disable':
            self.issue_http_request('PUT', url, {'value': 'disabled'})

    def do_compliance_base_cfg(self, ecli, line):
        try:
            cmd, params = self.parse_params('base_cfg', ecli, line, False,
                                            'update')
        except Exception as e:
            cl.perr(str(e))
            return

        if not any(k for k in ['host', 'host_type', 'rack'] if k in params):
            params['host'] = 'all'
        params['config_type'] = 'all'
        url = '{0}/compliance/baseline_config'.format(self.host)
        self.issue_http_request('PUT', url, params)

    def do_compliance_cfg_status(self, ecli, line):
        try:
            cmd, params = self.parse_params('cfg_status', ecli, line, False,
                                            'show')
        except Exception as e:
            cl.perr(str(e))
            return
        host = params['host']
        cfg_type = params.get('cfg_type', 'all')
        url = '{0}/compliance/host_config_status/{1}/{2}'.format(
                self.host, host, cfg_type)
        response = self.issue_http_request('GET', url)
        if response and response['status'] == 200:
            for name, config in response['config_status'].items():
                if config['current_config'] != 'same with baseline':
                    self.show_cfg_diff_summary(name, config['baseline_config'],
                                               config['current_config'])

    def do_compliance_cfg_history(self, ecli, line):
        try:
            cmd, params = self.parse_params('cfg_history', ecli, line, True,
                                            'show', 'list')
        except Exception as e:
            cl.perr(str(e))
            return

        if cmd == 'list':
            url = '{0}/compliance/config_change_history'.format(self.host)
            self.issue_http_request('GET', url, params)
        else:
            url = '{0}/compliance/config_change_history/{1}'.format(
                    self.host, params['change_id'])
            response = self.issue_http_request('GET', url)
            if response and response['status'] == 200:
                name = response['config_type']
                old_config = response.get('old_config')
                new_config = response.get('new_config')
                self.show_cfg_diff_summary(name, old_config, new_config)

    def do_compliance_report_oss_namespace(self, ecli, line):
        try:
            cmd, params = self.parse_params('report_oss_namespace', ecli, line, True,
                                            'set', 'show')
        except Exception as e:
            cl.perr(str(e))
            return

        url = '{0}/properties/COMPLIANCE_SCAN_REPORT_OSS_NAMESPACE'.format(self.host)
        if cmd == 'show':
            self.issue_http_request('GET', url)
        elif cmd == 'set':
            self.issue_http_request('PUT', url, {'value': params['value']})

    def do_compliance_auto_revert(self, ecli, line):
        try:
            cmd, params = self.parse_params('auto_revert', ecli, line, False,
                                            'enable', 'disable', 'show')
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/compliance/auto_revert_config'.format(self.host)
        if cmd == 'show':
            self.issue_http_request('GET', url)
        else:
            self.issue_http_request('PUT', url, {'enable': (cmd == 'enable')})

    def do_compliance_status(self, ecli, line):
        try:
            cmd, params = self.parse_params('status', ecli, line, False,
                                            'show')
        except Exception as e:
            cl.perr(str(e))
            return
        url = '{0}/compliance/status'.format(self.host)
        self.issue_http_request('GET', url)

    def do_compliance_avfim(self, ecli, line):
        try:
            cmd, params = self.parse_params('avfim', ecli, line, False,
                                            'run')
        except Exception as e:
            cl.perr(str(e))
            return

        url = '{0}/compliance/avfim'.format(self.host)
        self.issue_http_request('PUT', url, params)

    @staticmethod
    def parse_params(subop, ecli, line, param_per_action, *valid_actions):
        params = ecli.parse_params(line, None, optional_key='action')
        action = params.get('action')
        if action not in valid_actions:
            raise Exception('Invalid action {0}'.format(action))
        del params['action']
        if param_per_action:
            ecli.validate_parameters('compliance', [subop, action], params)
        else:
            ecli.validate_parameters('compliance', subop, params)
        return action, params

    def issue_http_request(self, http_method, url, data=None):
        if data:
            if http_method == 'GET':
                url = '{0}?{1}'.format(url, urllib.parse.urlencode(data))
            else:
                if isinstance(data, dict):
                    data = json.dumps(data)
                elif not isinstance(data, str):
                    data = str(data)

        cl.prt('c', '{0} {1}'.format(http_method, url))

        if http_method == 'DELETE':
            res = self.HTTP.delete(url)
        elif http_method == 'POST':
            res = self.HTTP.post(data, 'compliance', url)
        elif http_method == 'PUT':
            res = self.HTTP.put(url, data, 'compliance')
        else:
            res = self.HTTP.get(url)

        if not res:
            cl.perr('Failed to get ' + url)
            return None
        cl.prt('n', json.dumps(res, sort_keys=True,
                               indent=2, separators=(',', ': ')))
        return res

    def show_cfg_diff_summary(self, name, old_config, new_config):
        cl.prt('n', ' ')
        cl.prt('b', 'Change summary ({0}):'.format(name), True)
        if not old_config:
            cl.prt('c', ' Config has been created')
            return
        if not new_config:
            cl.prt('p', ' Config has been deleted')
            return

        for item in self.compare_json_keys(old_config, new_config,
                                           ' ', ''):
            new_item = new_config[item]
            old_item = old_config[item]
            cl.prt('g', ' {0} has been changed'.format(item))
            for prop in self.compare_json_keys(old_item, new_item,
                                                   '   * ', ''):
                diff = difflib.unified_diff(
                    str(old_item[prop]).splitlines(),
                    str(new_item[prop]).splitlines(),
                    fromfile='old '+prop,
                    tofile='new '+prop,
                    lineterm='')
                for line in diff:
                    if line.startswith('+'):
                        cl.prt('c', line)
                    elif line.startswith('-'):
                        cl.prt('p', line)
                    else:
                        cl.prt('n', line)
            cl.prt('n', ' ')

    def compare_json_keys(self, old_json, new_json, prefix, suffix):
        for key in new_json:
            if key not in old_json:
                cl.prt('c',
                       '{0}{1} has been created{2}'.format(prefix, key, suffix))
        for key in old_json:
            if key not in new_json:
                cl.prt('p',
                       '{0}{1} has been deleted{2}'.format(prefix, key, suffix))
            else:
                if new_json[key] != old_json[key]:
                    yield key
