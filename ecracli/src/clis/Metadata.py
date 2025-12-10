"""
 Copyright (c) 2015, 2022, Oracle and/or its affiliates.

NAME:
    Metadata class give the opportunity to select and update values of the allowed tables

FUNCTION:
    Provides the clis to select and update values of the allowed tables

NOTE:
    None

History:
    marcoslo   08/08/20 - ER 30613740 Update code to use python 3
    illamas    10/10/19 - Bug 29785842 - Create file
"""

from formatter import cl
from os import path
import http.client
import json
import os

class Metadata:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        
    def do_metadata_select(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
             ecli.validate_parameters('metadata', 'select', params)
        except Exception as e:
            return cl.perr(str(e))
        values = params["values"]
        params["values"] = []
        splited_values = values.split(",")
        for value in splited_values:
            params["values"].append(value)
        data = json.dumps(params, sort_keys=True, indent=4)
        url  = "{0}/ecrasql/select/{1}".format(host,params["table"])
        response = self.HTTP.post( data , "metadata", uri=url)
        number_of_objects = 1
        if response:
            if "msg" in response:
                cl.prt("n",str(response))
                return
            for item in response["result"]:
                cl.prt("c", str(number_of_objects))
                for attribute, value in item.items():
                    cl.prt("n","{0:15} : {1:8}".format(attribute,str(value)))
                number_of_objects = number_of_objects + 1
    
    def do_metadata_update(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
             ecli.validate_parameters('metadata', 'update', params)
        except Exception as e:
            return cl.perr(str(e))
        params["set"] = params["set"] + "," + params["pk"]
        params.pop("pk")
        data = json.dumps(params, sort_keys=True, indent=4)
        url  = "{0}/ecrasql/update/{1}".format(host,params["table"])
        response = self.HTTP.post( data , "metadata", uri=url)
        if response:
            cl.prt("n", json.dumps(response))

    def do_metadata_tables(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
             ecli.validate_parameters('metadata', 'tables', params)
        except Exception as e:
            return cl.perr(str(e))
        data = json.dumps(params, sort_keys=True, indent=4)
        url  = "{0}/ecrasql/tables".format(host)
        response = self.HTTP.get( url)
        if response:
            result = response["result"]
            tables = result.split(",")
            for table in tables:
                 cl.prt("n", table)
