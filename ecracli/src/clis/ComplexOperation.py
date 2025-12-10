#!/usr/bin/env python
# -*- coding: utf-8 -*-
# THIS FILE CONTAINS ECRACLI FUNCTIONALITY
#
# Copyright (c) 2013, 2023, Oracle and/or its affiliates.
#
#    NAME
#      Ecracli cli to handle complex operations.
#
#    DESCRIPTION
#      Official CLI for ECS
#
#    NOTES
#      ecracli
#
#    MODIFIED   (MM/DD/YY)
#    llmartin    01/26/23 - Enh 34983738 - Attach storage stepwise for ExaCS
#                           MVM
#    llmartin    10/21/21 - Enh 33318820 - Update task feature
#    llmartin    10/15/20 - Enh 31944421 - MultipleOperations cancel task
#                           feature
#    jreyesm     04/16/19 - Creation

from formatter import cl
import json

class ComplexOperation:

    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_details(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        
        try:
            ecli.validate_parameters("requests", "multiop_details", params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        reqs = ecli.issue_get_request("{0}/multiop/{1}".format(host, params["id"]), False)

        if not reqs:
            return

        cl.prt("c", "\n\nExecution plan")
        stepList = reqs["operations"]
        for req in stepList:
            cl.prt("n", "-" * 10)
            self.print_request(req)

        if len(reqs["child_requests"]) > 0:
            cl.prt("n", "\n\nlist of found requests/workflows")
            childReqs = reqs["child_requests"]
            for req in childReqs:
                self.print_request(req)

    def print_request(self, req, parent=None):
        fields = ["step", "enabled", "sub_req_id", "operation", "status", "exaunit_id", "resource_id","status_uuid", "start_time","end_time","details","wf_uuid","wf_name","current_state"]
        
        if "id" in req:
            req_str = "request id  " + req["id"]
            cl.prt("n", "-" * len(req_str))
            cl.prt("c", req_str)

        if "wf_uuid" in req:
            req_str = "workflow uuid  " + req["wf_uuid"]
            cl.prt("n", "-" * len(req_str))
            cl.prt("c", req_str)

        if parent != None:
            cl.prt("n", "This is a children request from " + parent)
        for field in fields:
            if field in req:
                cl.prt("n", "{0:<11} {1}".format(field, req[field]))

    def do_recover(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        ecli.validate_parameters("requests", "multiop_recover", params)
        retObj = self.HTTP.post("", "cns", "{0}/multiop/recover/{1}".format(host, params["id"]))
        if retObj:
            cl.prt("n", json.dumps(retObj))

    def do_update_step(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("requests", "multiop_update_step", params)
        except Exception as e:
            cl.perr(str(e))
            return

        request_id = params.pop("id")
        data = {"operations":[params]}
        response = self.HTTP.put("{0}/multiop/{1}".format(host, request_id), json.dumps(data), "requests" )
        if response:
            cl.prt("n", json.dumps(response))

