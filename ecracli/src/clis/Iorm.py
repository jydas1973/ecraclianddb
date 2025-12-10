"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates. 

NAME:
    Iorm - CLIs for IORM resources

FUNCTION:
    Provides the clis to get and set various properties like dblist, dbplan, flash etc


NOTE:
    None

History:
    anudatta    01/10/23 - Enh 37460598 - IORM GET call Enahncement
    anudatta    09/12/24 - Enh 36088456 - IORM async Api
    anudatta    03/01/23 - Enh 35918719 - set db plan V2 workflow API
    rgmurali    02/05/2021 - Bug 32471883 - Fix the reset dbplan cli
    dekuckre    09/06/17   - 26735879: Add do_get_clientkeys
    rgmurali    07/10/2017 - Create file
"""
from formatter import cl
import json
from os import path

class Iorm:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_get_dblist(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("get_dblist takes one mandatory argument <exaunit_id>")
            return

        ecli.issue_get_request("{0}/exaunit/{1}/iorm/dblist".format(host, line))

    def do_get_flashsize(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("get_flashsize takes one mandatory argument <exaunit_id>")
            return

        ecli.issue_get_request("{0}/exaunit/{1}/iorm/fcsize".format(host, line))

    def do_get_obj(self, ecli, line, host):
        line = line.split(' ', 1)
        exaunitId, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        if type(params) == dict:
            params.update(exaunit_Id=exaunitId)

        try:
            ecli.validate_parameters('iorm', 'getobj', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunit = params['exaunit_Id']

        if "idemtoken" in params and params["idemtoken"] is not None and params["idemtoken"].strip() != "":
            idemtoken = params['idemtoken']
            ecli.issue_get_request("{0}/exaunit/{1}/iorm/objective?idemtoken={2}".format(host, exaunit, idemtoken))
        else:
            ecli.issue_get_request("{0}/exaunit/{1}/iorm/objective?".format(host, exaunit))


    def do_set_obj(self, ecli, line, host, mytmpldir):

        inputJson = path.join(mytmpldir, "objective.json")

        if len(line.split()) != 1:
            cl.perr("set_obj takes one mandatory argument <exaunit_id>")
            return

        ojbJson = None
        with open(inputJson) as json_file:
            objJson = json.load(json_file)

        data = json.dumps(objJson)
        retObj = self.HTTP.put("{0}/exaunit/{1}/iorm/objective".format(host, line), data, "iorm")
        retObjJson = json.dumps(retObj,ensure_ascii=False)

        cl.prt("b",retObjJson)
   
    def do_set_obj_v2(self, ecli, line, host, mytmpldir):
        inputJson = path.join(mytmpldir, "objective.json")

        if len(line.split()) != 1:
            cl.perr("set_obj takes one mandatory argument <exaunit_id>")
            return

        ojbJson = None
        with open(inputJson) as json_file:
            objJson = json.load(json_file)

        data = json.dumps(objJson)
        retObj = self.HTTP.put("{0}/exaunit/{1}/iorm/objective/v2".format(host, line), data, "iorm")
        retObjJson = json.dumps(retObj,ensure_ascii=False)

        cl.prt("b",retObjJson)

    def do_get_dbplan(self, ecli, line, host):
        line = line.split(' ', 1)
        exaunitId, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        if type(params) == dict:
            params.update(exaunit_Id=exaunitId)

        try:
            ecli.validate_parameters('iorm', 'getdbplan', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunit = params['exaunit_Id']

        if "idemtoken" in params and params["idemtoken"] is not None and params["idemtoken"].strip() != "":
            idemtoken = params['idemtoken']
            ecli.issue_get_request("{0}/exaunit/{1}/iorm/dbplan?idemtoken={2}".format(host, exaunit, idemtoken))
        else:
            ecli.issue_get_request("{0}/exaunit/{1}/iorm/dbplan?".format(host, exaunit))

        

    def do_set_dbplan(self, ecli, line, host, mytmpldir):
        inputJson = path.join(mytmpldir, "dbplan.json")

        if len(line.split()) != 1:
            cl.perr("set_dbplan takes one mandatory argument <exaunit_id>")
            return

        objJson = None
        with open(inputJson) as json_file:
            objJson = json.load(json_file)

        data = json.dumps(objJson)
        retObj = self.HTTP.post(data, "iorm", "{0}/exaunit/{1}/iorm/dbplan".format(host, line))
        retObjJson = json.dumps(retObj,ensure_ascii=False)

        cl.prt("b",retObjJson)

    def do_set_dbplan_v2(self, ecli, line, host, mytmpldir):
        inputJson = path.join(mytmpldir, "dbplan.json")

        if len(line.split()) != 1:
            cl.perr("set_dbplan_v2 takes one mandatory argument <exaunit_id>")
            return

        objJson = None
        with open(inputJson) as json_file:
            objJson = json.load(json_file)

        data = json.dumps(objJson)
        retObj = self.HTTP.post(data, "iorm", "{0}/exaunit/{1}/iorm/dbplan/v2".format(host, line))
        retObjJson = json.dumps(retObj,ensure_ascii=False)

        cl.prt("b",retObjJson)

    def do_reset_dbplan(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("reset_dbplan takes one mandatory argument <exaunit_id>")
            return

        retObj = self.HTTP.put("{0}/exaunit/{1}/iorm/dbplan".format(host, line), "reset_dbplan", "reset_dbplan")
        retObjJson = json.dumps(retObj,ensure_ascii=False)

        cl.prt("b",retObjJson)
    
    def do_reset_dbplan_v2(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr("reset_dbplan takes one mandatory argument <exaunit_id>")
            return

        retObj = self.HTTP.put("{0}/exaunit/{1}/iorm/dbplan/v2".format(host, line), "reset_dbplan", "reset_dbplan")
        retObjJson = json.dumps(retObj,ensure_ascii=False)

        cl.prt("b",retObjJson)

    def do_get_clientkeys(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("get_clientkeys takes one mandatory argument <exaunit_id>")
            return

        ecli.issue_get_request("{0}/exaunit/{1}/iorm/clientkeys".format(host, line))

    def do_get_pmemsize(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("get_pmemsize takes one mandatory argument <exaunit_id>")
            return

        ecli.issue_get_request("{0}/exaunit/{1}/iorm/pmemcsize".format(host, line))

    def do_get_resources(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("get_resources takes one mandatory argument <exaunit_id>")
            return

        ecli.issue_get_request("{0}/exaunit/{1}/iorm/resources".format(host, line))

    def do_set_clusterplan(self, ecli, line, host, mytmpldir):
        inputJson = path.join(mytmpldir, "clusterplan.json")

        if len(line.split()) != 1:
            cl.perr("set_clusterplan takes one mandatory argument <exadatainfrastructureId>")
            return

        objJson = None
        with open(inputJson) as json_file:
            objJson = json.load(json_file)

        data = json.dumps(objJson)
        retObj = self.HTTP.post(data, "iorm", "{0}/exadatainfrastructure/{1}/iorm/clusterplan".format(host, line))
        retObjJson = json.dumps(retObj,ensure_ascii=False)

        cl.prt("b",retObjJson)

    def do_get_clusterplan(self, ecli, line, host):
        if len(line.split()) != 1:
            cl.perr("get_dbplan takes one mandatory argument <exadatainfrastructureId>")
            return

        ecli.issue_get_request("{0}/exadatainfrastructure/{1}/iorm/clusterplan".format(host, line))
