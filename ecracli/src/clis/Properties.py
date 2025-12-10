"""
 Copyright (c) 2015, 2024, Oracle and/or its affiliates.

NAME:
    Properties - CLIs for get and set property

FUNCTION:
    Provides the clis to get a property and set a property

NOTE:
    None

History:
    zpallare    06/07/2024 - Enh 36628793 - ECRA EXACS - Add property
                             description column for new properties
    zpallare    12/05/2023 - Enh 35960747 - Add a property get 
                             types to know all the property types 
                             that we have in the env
    rgmurali    05/16/2021 - ER 32893441 - precheck for bonding
    rgmurali    04/20/2017 - Create file
"""
from formatter import cl
import json

class Properties:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    # get property value from the given property name
    def do_get_property(self, ecli, line, host):
        try:
            ecli.validate_parameters('properties', 'get')
        except Exception as e:
            cl.perr(str(e))

        if not line:
            response = ecli.issue_get_request("{0}/properties".format(host), False)
        else:
            if "type" in line:
                response = ecli.issue_get_request("{0}/properties?{1}".format(host, line), False) 
            else:
                response = ecli.issue_get_request("{0}/properties/{1}".format(host, line), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))


    # put property value for a given property name
    def do_put_property(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="name")
        try:
            ecli.validate_parameters('properties', 'put', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        name = params.pop("name")
        if type(params) is str:
            cl.perr(params)
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/properties/{1}".format(host,name), data, "ecsproperties")
        if response:
            cl.prt("n", json.dumps(response))

    # get property types
    def do_properties_gettypes(self, ecli, line, host):
        try:
            ecli.validate_parameters('properties', 'gettypes')
        except Exception as e:
            cl.perr(str(e))

        response = ecli.issue_get_request("{0}/properties/types".format(host), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
