#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Security.py /main/3 2024/07/02 16:34:01 caborbon Exp $
#
# Security.py
#
# Copyright (c) 2021, 2024, Oracle and/or its affiliates.
#
#    NAME
#      Security.py - Security related commands, used for se linux and more.
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    caborbon    06/25/24 - ENH 36754615 - Adding Global FS Encryption property
#    marislop    08/06/21 - ENH 32941844 Filesystem encryption
#    jreyesm     04/27/21 - E.R 32817912. Adding security module for onsr
#    jreyesm     04/27/21 - Creation
#


from formatter import cl
import json
import os
from os import path
import base64


class Security:
    def __init__(self, HTTP):
        self.HTTP = HTTP


    # post to update exaunit detail
    def do_add_selinuxpolicy(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("security", "add_selinuxpolicy", params)
        except Exception as e:
            cl.perr(str(e))
            return

        #read the file
        policy_file = params['policy_file']
        with open(policy_file, 'rb') as pfile:
            policy_data = pfile.read()           
       
        policy_data =  base64.b64encode(policy_data)
        
        #Encode binary data
        params['policy_data'] = policy_data.decode()
        data = json.dumps(params, sort_keys=True, indent=4)
       
        response = self.HTTP.post(data, "security", "{0}/security/sepolicy".format(host))
       
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
        

    def do_list_selinuxpolicy(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("security", "list_selinuxpolicy", params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        query_str = "?"
        for param in params:
            query_str = query_str + param + "=" + params[param] + "&"
        query_str = query_str[:-1]
        response = ecli.issue_get_request("{0}/security/sepolicy{1}".format(host, query_str), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    
    def do_dump_selinuxpolicy(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("security", "dump_selinuxpolicy", params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/security/sepolicy".format(host), data, "exaunits")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_add_fsencryption(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("security", "add_fsencryption", params)
        except Exception as e:
            cl.perr(str(e))
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/security/fsencryption".format(host), data, "security")
        if response:
           cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_remove_fsencryption(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("security", "remove_fsencryption", params)
        except Exception as e:
            cl.perr(str(e))
            return
        customer_tenancy_id = ""
        if "customerTenancyId" in params:
            customer_tenancy_id = params["customerTenancyId"]
        if "customer_tenancy_id" in params:
            customer_tenancy_id = params["customer_tenancy_id"]
        response = self.HTTP.delete("{0}/security/fsencryption/{1}".format(host, customer_tenancy_id))        
        if response:
           cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_list_fsencryption(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("security", "list_fsencryption", params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        response = self.HTTP.query("{0}/security/fsencryption".format(host), params)
        if response:
           cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

