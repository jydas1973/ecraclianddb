"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

 NAME:
     UserConfig - CLIs for UserConfig resources

 FUNCTION:
     Provides the clis to configure the user in the cells.

 NOTE:
     None

 History:
     dekuckre    03/26/18  : 28060479: Create file.

"""
from formatter import cl
import json
import base64
from os import path

class UserConfig:

    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_create_user(self, ecli, line, host):

        list = dict(s.split('=', 1) for s in line.split())

        if ("user" not in list.keys() or "password" not in list.keys() or "exaunit_id" not in list.keys()):
            cl.perr("Please pass all the parameters (user, password and exaunit_id) as part of the command")
            return

        user_dict={}
        user_dict["user"] = list["user"]
        user_dict["password"] = base64.b64encode(list["password"].encode("utf-8")).decode("utf-8")
        data = json.dumps(user_dict, sort_keys=True, indent=4)

        retObj = self.HTTP.post(data, "userconfig", "{0}/exaunit/{1}/userconfig?action=create_user".format(host, list["exaunit_id"]))
        cl.prt("c", str(retObj))


    def do_alter_user(self, ecli, line, host):

        list = dict(s.split('=', 1) for s in line.split())

        if ("user" not in list.keys() or "password" not in list.keys() or "exaunit_id" not in list.keys()):
            cl.perr("Please pass all the parameters (user, password and exaunit_id) as part of the command")
            return 

        user_dict={}
        user_dict["user"] = list["user"]
        user_dict["password"] = base64.b64encode(list["password"].encode("utf-8")).decode("utf-8")

        data = json.dumps(user_dict, sort_keys=True, indent=4)

        retObj = self.HTTP.put("{0}/exaunit/{1}/userconfig?action=alter_user".format(host, list["exaunit_id"]), data, "userconfig")
        cl.prt("c", str(retObj))

    def do_grant_role(self, ecli, line, host):
    
        list = dict(s.split('=', 1) for s in line.split())

        if ("user" not in list.keys() or "role" not in list.keys() or "exaunit_id" not in list.keys()):
            cl.perr("Please pass all the parameters (user, role and exaunit_id) as part of the command")
            return

        user_dict={}
        user_dict["role"] = list["role"]
        user_dict["user"] = list["user"]
        data = json.dumps(user_dict, sort_keys=True, indent=4)

        retObj = self.HTTP.put("{0}/exaunit/{1}/userconfig?action=grant_role".format(host, list["exaunit_id"]), data, "userconfig")
        cl.prt("c", str(retObj))

    def do_list_user(self, ecli, line, host):

        list = dict(s.split('=', 1) for s in line.split())

        if ("exaunit_id" not in list.keys()):
            cl.perr("Please pass exaunit_id as part of the command")
            return

        ecli.issue_get_request("{0}/exaunit/{1}/userconfig?action=list_user".format(host, list["exaunit_id"]))

    def do_delete_user(self, ecli, line, host):
    
        list = dict(s.split('=', 1) for s in line.split())

        if ("user" not in list.keys() or "exaunit_id" not in list.keys()):
            cl.perr("Please pass all the parameters (user and exaunit_id) as part of the command")
            return

        user_dict={}
        user_dict["user"] = list["user"]
        data = json.dumps(user_dict, sort_keys=True, indent=4)

        retObj = self.HTTP.put("{0}/exaunit/{1}/userconfig?action=delete_user".format(host, list["exaunit_id"]), data, "userconfig")
        cl.prt("c", str(retObj))

    def do_delete_role(self, ecli, line, host):
    
        list = dict(s.split('=', 1) for s in line.split())

        if ("role" not in list.keys() or "exaunit_id" not in list.keys()):
            cl.perr("Please pass all the parameters (role and exaunit_id) as part of the command")
            return

        user_dict={}
        user_dict["role"] = list["role"]
        data = json.dumps(user_dict, sort_keys=True, indent=4)

        retObj = self.HTTP.put("{0}/exaunit/{1}/userconfig?action=delete_role".format(host, list["exaunit_id"]), data, "userconfig")
        cl.prt("c", str(retObj))
