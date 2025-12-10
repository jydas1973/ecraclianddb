"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Dataguard - CLIs for sub-operations under Data Guard

FUNCTION:
    Provides the clis to create config and setup data guard

NOTE:
    None

History:
    rgmurali    12/07/2017 - Bug 27195870 - Fix pylint errors
    rgmurali    07/11/2017 - Create file
"""
from formatter import cl
from os import path
import json

class Dataguard:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_dgsetup(self, ecli, line, host, mytmpldir):
        dbJson, exaunit_id = ecli.get_dbJson(line);

        dg_setupPath = path.join(mytmpldir, "dg_setup.json")

        with open(dg_setupPath) as json_file:
            dgJson = json.load(json_file)

        if not dgJson['dataguard_clusters']['primary'].get('vms'):
            cl.perr("Error: DG setup json entries missing")
            return

        for node in dgJson['dataguard_clusters']['standbys']:
            if not node['vms']:
                cl.perr("Error: DG config json entries missing for requested instance")
                return

        dbJson.update(dgJson)
        data = json.dumps(dbJson, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "dataguard", uri="{0}/exaunit/{1}/dataguard/setup".format(host,exaunit_id))
        ecli.waitForCompletion(response, "dgsetup")

    def do_dgconfig(self, ecli, line, host, mytmpldir):
        params = line.split(' ')
        if len(params) != 2:
            cl.perr("required parameters <exaunit> <instance>")
            print(ecli.sub_ops_help["dg"]["config"])
            return

        exaunit_id = params.pop(0)
        instance  = params.pop(0)

        if instance == "primary":
            dg_configPath = path.join(mytmpldir, "dg_config_primary.json")
        elif instance == "standby":
            dg_configPath = path.join(mytmpldir, "dg_config_standby.json")

        with open(dg_configPath) as json_file:
            dgJson = json.load(json_file)

        for node in dgJson['remote_cluster']['scannames']:
            if ((not node['ip']) or (not node['name'])):
                cl.perr("Error: DG config json entries missing for requested instance")
                return

        for node in dgJson['remote_cluster']['vms']:
            if ((not node['ip']) or (not node['fdn'])):
                cl.perr("Error: DG config json entries missing for requested instance")
                return

        if (not dgJson['ssh_key'].get('public') or not dgJson['ssh_key'].get('private')):
            cl.perr("Error: DG config json entries missing for requested instance")
            return

        data = json.dumps(dgJson, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "dataguard", uri="{0}/exaunit/{1}/dataguard/configure".format(host,exaunit_id))
        ecli.waitForCompletion(response, "dgconfig")

    def do_create_dgdb(self, ecli, line):
        response = ecli.issue_create_db(line, True, True)
        ecli.waitForCompletion(response, "create_dgdb")

