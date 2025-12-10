"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    EM - CLIs for Enterprise Manager (EM) of ATP

FUNCTION:
    Provides the clis to get and update EM metadata table

NOTE:
    None

History:
    marcoslo   08/08/20 - ER 30613740 Update code to use python 3
    ananyban    05/30/19 - Create file
"""

from formatter import cl
from os import path
import http.client
import json
import os

class EM:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_setup_em(self, ecli, line, host):
        if len(line.split()) > 1:
            cl.perr('em setup takes one optional argument <properties.json>')
            return
        jsonfile = line
        url = '{0}/em'.format(host)
        self.issue_http_request('POST', url, jsonfile)

    def do_reregister_em(self, ecli, line, host):
        line = line.split(' ', 1)
        exaunit_id, rest = line[0] if len(line) > 0 else "", line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None , warning=False)
        if exaunit_id.lower() == 'all' :
            uri = "{0}/em".format(host)
        elif ("cdb_sid" in params) and (not "pdb_name" in params) :
            cdbSID = params.pop("cdb_sid")
            uri = "{0}/em/{1}/databases/{2}".format(host, exaunit_id,cdbSID)
        elif (("cdb_sid" in params) and ("pdb_name" in params)):
            cdbSID = params.pop("cdb_sid")
            pdbName = params.pop("pdb_name")
            uri =  "{0}/em/{1}/databases/{2}/pdbs/{3}".format(host, exaunit_id,cdbSID, pdbName)
        else :
            uri = "{0}/em/{1}".format(host, exaunit_id)
        self.issue_http_request('PUT', uri)
    
    def do_list_em(self, ecli, line, host):
        line = line.split(' ', 1)
        exaunit_id, rest = line[0] if len(line) > 0 else "", line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None , warning=False)
        if not exaunit_id :
            uri = "{0}/em".format(host)
        elif ("cdb_sid" in params) and (not "pdb_name" in params) and exaunit_id:
            cdbSID = params.pop("cdb_sid")
            uri = "{0}/em/{1}/databases/{2}".format(host, exaunit_id,cdbSID)
        elif (("cdb_sid" in params) and ("pdb_name" in params)) and exaunit_id:
            cdbSID = params.pop("cdb_sid")
            pdbName = params.pop("pdb_name")
            uri =  "{0}/em/{1}/databases/{2}/pdbs/{3}".format(host, exaunit_id,cdbSID, pdbName)
        elif exaunit_id :
            uri = "{0}/em/{1}".format(host, exaunit_id)
        else:
            cl.perr('Invalid parameters provided for em list cmd.')
            return
        self.issue_http_request('GET', uri)
    
    def do_update_em(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr('em update takes one mandatory param <row_value.json>')
            return
        jsonfile = line
        url = '{0}/em/update'.format(host)
        self.issue_http_request('PUT', url, jsonfile)

    def do_add_em(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr('em add takes one mandatory param <row_value.json>')
            return
        jsonfile = line
        url = '{0}/em/add'.format(host)
        self.issue_http_request('POST', url, jsonfile)
    
    def do_delete_em(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr('em delete takes one mandatory param <row_value.json>')
            return
        jsonfile = line
        url = '{0}/em'.format(host)
        self.issue_http_request('DELETE', url, jsonfile)

    def issue_http_request(self, http_method, url, jsonfile=None):
        cl.prt('c','{0} {1}'.format(http_method, url))
        data = ''
        if jsonfile :
            if http_method in ['POST', 'PUT', 'DELETE']:
                with open (jsonfile, 'r') as fh:
                    data = fh.read().replace('\n', '')

        if http_method == 'DELETE':
            res = self.HTTP.delete(url, data)
        elif http_method == 'POST':
            res = self.HTTP.post(data, 'em', url)
        elif http_method == 'PUT':
            res = self.HTTP.put(url, data, 'em')
        else:
            res = self.HTTP.get(url)

        if not res:
            cl.perr('Failed to get ' + url)
            return
        cl.prt('n',json.dumps(res, sort_keys=True, indent=4, separators=(',', ': ')))

    def do_disable_em(self, ecli, line, host):
        if len(line.split()) != 0:
            cl.perr('em disable does not take any prarameter')
            return
        url = '{0}/em/disable'.format(host)
        self.issue_http_request('PUT', url)
    
    def do_enable_em(self, ecli, line, host):
        if len(line.split()) != 0:
            cl.perr('em enable does not take any prarameter')
            return
        url = '{0}/em/enable'.format(host)
        self.issue_http_request('PUT', url)
