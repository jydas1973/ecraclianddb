#!/usr/bin/env python
# -*- coding: utf-8 -*-
# THIS FILE CONTAINS ECRACLI FUNCTIONALITY
#
# Copyright (c) 2013, 2024, Oracle and/or its affiliates.
#
#    NAME
#      ecracli Official interface for ecra
#
#    DESCRIPTION
#      Official CLI for ECS
#
#    NOTES
#      ecracli
#
#    MODIFIED   (MM/DD/YY)
#    gvalderr    10/30/24 - Enh 37025137 - Changing operators to be compatible
#                           with python 3.8
#    piyushsi    08/27/24 - Enh 36991930 Database Heartbeat Ecracli Command
#    jvaldovi    04/10/24 - Bug 36483532 - Sscan Issue In File:
#                           Ecs/Ecra/Ecracli/Src/Clis/Database.Py
#    jreyesm     11/01/22 - Fix database return value
#    ddelgadi    06/21/22 - Bug - 32690620 Added parameter to identify that the
#                           case when generete an starter db
#    jreyesm     02/02/22 - Bug 33816958. Using exaunit endpoint for starter.
#    hcheon      09/28/20 - Bug 31942864 - Fixed pylint errors
#    rgmurali    08/15/20 - Bug 31536477 - Fix fortify issues
#    jreyesm     11/28/19 - Enh 30589095. Recreate db flow
#    illamas     11/15/19 - ER 30474917 - Ask for confirmation before a DB
#                           deletion
#    illamas     10/23/19 - ER 30432244 - Added databases/info in order to get
#                           a list of cdbs for a given ATP ExaUnitId
#    jloubet     09/27/18 - Creation

from os import path
from formatter import cl

import uuid
import base64
import getpass
import json
import sys

class Database:
    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host

        # create db on given exaunit
    def do_create_db(self, ecli, line, mytmpldir, interactive):
        response = self.issue_create_db(ecli, line, True, False, mytmpldir, interactive, "additional")
        #ecli.waitForCompletion(response, "create_db")
        if response:
            cl.prt("n", json.dumps(response))


    def issue_create_db(self, ecli, line, new_api, with_dg, mytmpldir, interactive, typeDB):
        dbJson, exaunit_id = ecli.get_dbJson(line);

        if with_dg:
            dg_createPath = path.join(mytmpldir, "dg_setup.json")

            with open(dg_createPath) as json_file:
                dgJson = json.load(json_file)

            dbJson.update(dgJson)

        if interactive:
            cl.prt("c", "Creating database on exaunit {0} with dbSID: {1}".format(exaunit_id, dbJson["dbSID"]))
        dbJson["type"]=typeDB
        data = json.dumps(dbJson, sort_keys=True, indent=4)
        if new_api:
            return self.HTTP.post(data, "databases", uri="{0}/exaunit/{1}/databases".format(self.host, exaunit_id))
        else:
            return self.HTTP.post(data, "databases")

    def do_info_all_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        if interactive:
            cl.prt("c", "Obtaining database information on exaunit {0}".format(exaunit_id))
        
        ecli.issue_get_request("{0}/exaunit/{1}/databases/info".format(self.host, exaunit_id))

    def do_info_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, None, warning=False)
        if type(params) is str:
            cl.perr(params)
            return

        if "dbSID" not in params or not params["dbSID"]:
            cl.perr("dbSID not specified. Please do info_db <exaunit_id> dbSID=<dbSID>")
            return

        dbname = params["dbSID"]

        if interactive:
            cl.prt("c", "Obtaining database information on exaunit {0} with dbSID: {1}".format(exaunit_id, dbname))

        ecli.issue_get_request("{0}/exaunit/{1}/databases/{2}/info".format(self.host, exaunit_id, dbname))

    def do_delete_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, "DBParams", warning=False)
        if type(params) is str:
            cl.perr(params)
            return

        if "dbSID" not in params or not params["dbSID"]:
            cl.perr("dbSID not specified. Please do delete_db <exaunit_id> dbSID=<dbSID>")
            return

        with open(ecli.dbJsonPath) as json_file:
            dbJson = json.load(json_file)

        dbJson["exaunitID"] = exaunit_id

        for name, value in list(params.items()):
            if value:
                dbJson[name] = value

        if interactive:
            cl.prt("c", "Deleting database on exaunit {0} with dbSID: {1}".format(exaunit_id, dbJson["dbSID"]))

        dbSID = params["dbSID"]
        if(ecli.is_required_validation()):
            if(ecli.stop_delete(dbSID ,"dbSID")):
                cl.prt("r", "Skipped db delete command for Database:["+dbSID+"]")
                return

        data = json.dumps(dbJson, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/exaunit/{1}/databases".format(self.host, exaunit_id), data, self.HTTP.HEADERS["databases"])
        ecli.waitForCompletion(response, "delete_db")

    def do_create_starter_db(self, ecli, line, mytmpldir, interactive):
        response = self.issue_create_db(ecli, line, True, False, mytmpldir, interactive, "starterdb")
        ecli.waitForCompletion(response, "create_starter_db")

    def do_rollback_starter_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, "DBParams", warning=False)
        if type(params) is str:
            cl.perr(params)
            return

        if "dbSID" not in params or not params["dbSID"]:
            cl.perr("dbSID not specified. Please do delete_db <exaunit_id> dbSID=<dbSID>")
            return

        with open(ecli.dbJsonPath) as json_file:
            dbJson = json.load(json_file)

        dbJson["exaunitID"] = exaunit_id

        for name, value in list(params.items()):
            if value:
                dbJson[name] = value

        if interactive:
            cl.prt("c", "Rollback starter database on exaunit {0} with dbSID: {1}".format(exaunit_id, dbJson["dbSID"]))

        data = json.dumps(dbJson, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/databases".format(self.host), data, self.HTTP.HEADERS["databases"])
        ecli.waitForCompletion(response, "rollback_starter_db")

    def do_recreate_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, None, warning=False)
        if type(params) is str:
            cl.perr(params)
            return
        ecli.validate_parameters('db', 'recreate', params)

        if interactive:
            cl.prt("c", "Recreating database on exaunit {0} with dbSID: {1}".format(exaunit_id, params["dbSID"]))
        dbJson = {}
        data = json.dumps(dbJson, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "databases",uri="{0}/exaunit/{1}/databases/{2}/recreate".format(self.host, exaunit_id, params["dbSID"]))
        if response:
            cl.prt("n", json.dumps(response))

    # register additional databases created through SM instead of ecra
    # this will only register the db record in ecra but will not actually create any database on rack
    def do_register_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, "DBParams", warning=False)
        if type(params) is str:
            cl.perr(params)
            return

        if not params["dbSID"]:
            params["dbSID"] = "db" + str(uuid.uuid4())[-6:]

        with open(ecli.dbJsonPath) as json_file:
            dbJson = json.load(json_file)

        dbJson["exaunitID"] = exaunit_id

        for name, value in list(params.items()):
            if value:
                dbJson[name] = value

        if not "status" in dbJson:
            dbJson['status'] = 'CREATED'
        if not "dbType" in dbJson:
            dbJson['dbType'] = 'ADDITIONAL'

        if interactive:
            cl.prt("c", "Registering database on exaunit {0} with dbSID: {1}".format(exaunit_id, dbJson["dbSID"]))

        data = json.dumps(dbJson, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "databases",uri="{0}/exaunit/{1}/databases/{2}/registry".format(self.host, exaunit_id, dbJson["dbSID"]))
        cl.prt("n", json.dumps(response))

    #Deregister additional database created outside cloud automation, this DO NOT delete the database on the rack.
    def do_deregister_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, "DBParams", warning=False)
        if type(params) is str:
            cl.perr(params)
            return

        if interactive:
            cl.prt("c", "De-Registering database on exaunit {0} with dbSID: {1}".format(exaunit_id, params["dbSID"]))

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/exaunit/{1}/databases/{2}/registry".format(self.host, exaunit_id, params["dbSID"]), data, self.HTTP.HEADERS["databases"])
        cl.prt("n", json.dumps(response))


    #Get registered info from ECRA, not going to the rack
    def do_registered_info_db(self, ecli, line, interactive):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, "DBParams", warning=False)
        if type(params) is str:
            cl.perr(params)
            return
        if interactive:
            cl.prt("c", "Registered info database on exaunit {0} with dbSID: {1}".format(exaunit_id, params["dbSID"]))
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.get("{0}/exaunit/{1}/databases/{2}/registry".format(self.host, exaunit_id, params["dbSID"]))
        cl.prt("n", json.dumps(response))
        
    # db backup flow
    def do_backup(self, ecli, line):
        response = self.issue_backup(ecli, line)
        if not response:
            return
        # async call
        if response["action"] != "list":
            ecli.waitForCompletion(response["payload"],"backup")
        return


    def issue_backup(self, ecli, line):
        response = dict()
        actions = ["list","start","delete","update"]
        update_options  = ["wallet"]

        params  = line.split(' ')
        params  = list(filter(lambda x: x.strip() != "" and "=" not in x.strip(),params))
        # getting number of actions
        total_actions = list(filter(lambda x: x in actions, params))
        if len(total_actions) != 1:
            cl.perr("Error: only one action per time is allowed total: {0}".format(total_actions))
            for i in ecli.sub_ops_help["db"]["backup"]:
              print(i)
            return
        # options
        options = [op.split("=",1) for op in line.split() if "=" in op]
        options = dict(options)


        action  = total_actions.pop(0)
        params.remove(action)
        exaunit  = ""
        dbname   = ""
        tag      = ""
        password = ""
        update   = ""
        full    = False

        # full backup validation
        if 'content' in options:
            if options['content'] not in ['full', 'incr']:
                cl.perr("content type not supported, available: [full, incr]")
                return

            if options['content'] == "full":
                full = True

        # end validation

        if len(params) < 2 or len(params) > 3:
            cl.perr("Error: invalid argument number {0},{1}".format(len(params), params))
            return

        if len(params) == 3:
            update  = params.pop(0) if action == "update" else ""

        # validations
        if action == "update":
            if not update:
                cl.perr("Error: nothing to update {0}".format(params))
                return
            if update not in update_options:
                cl.perr("Error: valid update options {0}".format(update_options))
                return
            # asking for psswd
            if update == "wallet":
                cl.prt("c", "Please provide your new credentials")
                try:
                    password = getpass.getpass("password:")
                    password = base64.b64encode(password.encode("utf-8")).decode("utf-8")
                    if not password:
                        cl.perr("Error: Please provide a password")
                        return

                    action = "update_" + update
                except getpass.GetPassWarning as f:
                    cl.perr("Security issue: {0}".format(f))
                    return

        if action == "delete":
            cl.prt("c", "Note remember only full backups can be deleted")
            if 'tag' not in options:
                cl.perr("Error: delete requires tag=<tag name> option, please provide it")
                return

            if not options['tag']:
                cl.perr("Error: Empty tag provided ")
                return

            tag = options['tag']



        exaunit = params.pop(0)
        dbname  = params.pop(0)

        # creating the request


        ecrauri = "{0}/exaunit/{1}/databases/{2}/backups".format(self.host, exaunit, dbname)

        if action == "list":
            getOut = self.HTTP.get(ecrauri)
            if not getOut:
                cl.perr("Error: cannot get the list of backups")
                return

            try:
                getOut = json.dumps(getOut,indent=4)
                print(getOut)

            except Exception as e:
                cl.perr("Error: {e}".format(e))

            response["payload"] = getOut
        else:
            # other endpoints
            backupPayload = dict()
            backupPayload["action"] = action
            if tag     : backupPayload["tag"] = tag
            if action == "start": backupPayload["full"] = full
            backupPayload = json.dumps(backupPayload, sort_keys=True, indent=4)
            response["payload"] = self.HTTP.put(ecrauri, backupPayload,"racks")
            if not response["payload"]:
                cl.perr("Error: invalid backup api response through ECRA")
                return

        response["action"] = action
        return response


    def do_recover(self, ecli, line):
        params = line.replace("to=", "to ").split(" ")
        params = [p for p in params if p.strip() != ""]
        if "to" not in params:
            cl.perr("Error: see usage")
            print(ecli.sub_ops_help["recover"])
            return

        params.remove("to")

        if len(params) > 4:
            cl.perr("Error more than one expected parameter")
            print(ecli.sub_ops_help["recover"])
            return
        # case for timestamp
        if len(params) == 4:
            a, b, c, d = params
            params = [a, b, "{0} {1}".format(c,d)]

        if len(params) != 3:
            print(ecli.sub_ops_help["recover"])
            return


        # creating input payload for ECRA
        exaunit, dbname, reco = params
        # verifying just if reco is numeric
        try:
            reco = int(reco)
        except:
            pass

        uri      = "{0}/exaunit/{1}/databases/{2}/backups".format(self.host, exaunit, dbname)
        payload = {"to": reco, "action": "recover"}
        payload = json.dumps(payload, sort_keys=True, indent=4)

        response = self.HTTP.put(uri, payload, "racks")
        if not response:
            cl.perr("Error: empty response from ecra")
        else:
            cl.prt("c", "{0}".format(response))
            ecli.waitForCompletion(response,"recover")

        return

    def do_dbpatch(self, ecli, line):
        response = self.issue_dbpatch(ecli, line)
        if not response:
            return

        if response["action"] != "list":
            ecli.waitForCompletion(response["payload"], "dbpatching")

        return

    # issue dbpatch
    def issue_dbpatch(self, ecli, line):
        response = dict()

        dbops = ["list", "apply", "precheck", "rollback"]
        # command
        # dbpatch <exaunit> list       <dbname>
        # dbpatch <exaunit> apply      <dbname> patchid=<>
        # dbpatch <exaunit> precheck   <dbname> patchid=<>
        # dbpatch <exaunit> rollback   <dbname> patchid=<>
        if not line:
            cl.perr("please specify parameters for dbpatching")
            for i in ecli.sub_ops_help["db"]["patch"]:
                  print(i)
            return

        exaunit = line.split(' ').pop(0)
        line = line.replace(exaunit, "", 1)

        # parsing params
        params   = [option.split("=",1) for option in line.split() if "=" in option]
        args     = [arg for arg in line.split() if "=" not in arg]
        params = dict(params)

        if len(args) != 2:
            cl.perr("required parameters <action> <dbname>")
            for i in ecli.sub_ops_help["db"]["patch"]:
                  print(i)
            return

        actions = [action for action in dbops if action in args]
        dbs     = [dbname for dbname in args if dbname not in actions]

        if len(actions) != 1 and len(dbs) != 1:
            cl.perr("Only 1 action per db allowed [dbs: {0}, actions: {1} ]".format(len(actions), len(dbs)))
            for i in ecli.sub_ops_help["db"]["patch"]:
              print(i)
            return


        db = dbs.pop()
        action = actions.pop()

        # Flow 1 list patches
        if action == "list":
            ecrauri = "{0}/exaunit/{1}/databases/{2}/dbpatches".format(self.host, exaunit,db)
            getOut = self.HTTP.get(ecrauri)
            if not getOut:
                cl.perr("Error: failed dbpatch invalid response from ECRA")
                return

            try:
                if "error" in getOut:
                    if getOut["error"]:
                        cl.perr("{0}".format(getOut["error"]))

                if 'exadbpatch' in getOut:
                    exaJson = json.loads(getOut["exadbpatch"])
                    for param in exaJson:
                        if param.strip() != "patches":
                            cl.prt("c","{0}: {1}".format(param, exaJson[param]))

                    if "patches" in exaJson:
                        if not exaJson["patches"]:
                            cl.prt("g", "not available patches for your database")
                        else:
                            cl.prt("g","list of patches availables: ")
                            for patch in exaJson["patches"]:
                                for desc in patch:
                                    cl.prt("b"," [*] {0}: {1}".format(desc, patch[desc]))

            except Exception as E:
                cl.prt("c", str(getOut))

            response["payload"] = getOut
        else:
            if "patchid" not in params:
               cl.perr("patchid is a required parameter for apply, precheck and rollback")
               for i in ecli.sub_ops_help["db"]["patch"]:
                  print(i)
               return
            # pulling status PUT

            params["op"] = action
            data = json.dumps(params, sort_keys=True, indent=4)
            response["payload"] = self.HTTP.put("{0}/exaunit/{1}/databases/{2}/dbpatch".format(self.host, exaunit, db), data, "racks")
            if not response["payload"]:
                cl.perr("Error: failed dbpatch invalid response from ECRA")
                return

        # returning payload
        response["action"] = action
        return response
    
    # PDB operations
    def do_register_pdb(self, ecli, line):
        params = ecli.parse_params(line, None , warning=False)
        ecli.validate_parameters('pdb', 'register', params)

        exaunit_id =params.pop("exaunit_id")
        cdbSID =params.pop("cdb_sid")

        data = json.dumps(params, sort_keys=True, indent=4)
        response = ecli.HTTP.post(data,"databases" , "{0}/exaunit/{1}/databases/{2}/pdbs".format(ecli.host, exaunit_id, cdbSID))
        cl.prt("n", json.dumps(response))

    def do_deregister_pdb(self, ecli, line):
        params = ecli.parse_params(line, None , warning=False)
        ecli.validate_parameters('pdb', 'deregister', params)

        exaunit_id = params.pop("exaunit_id")
        cdbSID = params.pop("cdb_sid")
        pdbName = params.pop("pdb_name")

        uri = "{0}/exaunit/{1}/databases/{2}/pdbs/{3}".format(ecli.host, exaunit_id, cdbSID, pdbName)
        response = ecli.HTTP.delete(uri, None, ecli.HTTP.HEADERS["databases"])

        cl.prt("n", json.dumps(response))

    def do_info_pdb(self, ecli, line):
        params = ecli.parse_params(line, None , warning=False)
        ecli.validate_parameters('pdb', 'info', params)

        exaunit_id = params.pop("exaunit_id")
        cdbSID = params.pop("cdb_sid")

        pdbName=""
        if "pdb_name" in params:
            pdbName = params.pop("pdb_name")

        uri = "{0}/exaunit/{1}/databases/{2}/pdbs/{3}".format(ecli.host, exaunit_id, cdbSID, pdbName)
        response = ecli.HTTP.get(uri)

        cl.prt("n", json.dumps(response))

    def do_heartbeat_ecra_db(self, ecli, line):
        params = ecli.parse_params(line, None , warning=False)
        ecli.validate_parameters('db', 'update_ecra_heartbeat', params)

        uri = "{0}/database/heartbeat".format(ecli.host)
        response = ecli.HTTP.put(uri, None, None)

        cl.prt("n", json.dumps(response))

