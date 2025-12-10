#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Analytics.py /main/10 2024/03/05 15:32:42 zpallare Exp $
#
# Analytics.py
#
# Copyright (c) 2020, 2024, Oracle and/or its affiliates.
#
#    NAME
#      Analytics.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    zpallare    02/26/24 - Enh 36034772 - EXACS: Keep records of deleted
#                           clusters in ecra
#    zpallare    08/14/23 - Enh 35617595 - Get payload for some operation
#    ririgoye    11/25/22 - Enh 33467698 - Added getOperationDetails command
#    illamas     07/12/22 - Enh 34295307 - Improve analytics for
#                           capacity,create infra and rack reserve mvm
#    illamas     05/30/22 - Enh 34165620 - Adding support to show post checks
#                           templates
#    illamas     08/02/21 - Enh 33170748 - Get checks that failed, filter by
#                           mandatory
#    illamas     06/03/21 - Enh 32894712 - Operations for a given rack
#    illamas     10/21/20 - Enh 32048648 - Added resource_id to rack history
#                           and support for history per inventory_id
#    illamas     09/07/20 - Enh 31783059 - Analytics for all endpoints
#
from formatter import cl
import json

class Analytics:
    def __init__(self, HTTP):
        self.HTTP = HTTP 

    def do_analyze(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'analyze', params)
        except Exception as e:
            return cl.perr(str(e))

        operation  = params["operation"]
        complement = ""
        if "interval" in params:
            complement = params["interval"]
        url  = "{0}/analytics/analyze/{1}/{2}".format(host,operation,complement)
        payload = dict()
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                cl.prt("n", json.dumps(response, sort_keys=False, indent=4)) 

    def do_history(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'history', params)
        except Exception as e:
            return cl.perr(str(e))

        rackName    = params.get("rackname") is not None
        inventoryId = params.get("inventoryid") is not None
        exadatainfrastructure = params.get("exadatainfrastructure") is not None
        vmclusterId = params.get("vmclusterid") is not None
        
        paramsCount = (1 if rackName else 0) + (1 if inventoryId else 0)\
             + (1 if exadatainfrastructure else 0) + (1 if vmclusterId else 0)

        if paramsCount != 1:
            return cl.perr(str("You have to provide rackname, inventoryid,"\
                +" exadatainfrastructure or vmclusterid, just one of them"))

        url = "{0}/analytics/history/".format(host)
        if rackName:
            url = "{0}{1}".format(url,params.get("rackname"))
        elif inventoryId:
            url = "{0}inventory/{1}".format(url,params.get("inventoryid"))
        elif vmclusterId:
            url = "{0}cluster/{1}".format(url,params.get("vmclusterid"))
        else:
            url = "{0}exadatainfrastructure/{1}".format(url,params.get("exadatainfrastructure"))
 
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        number_of_objects = 1
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                for item in response["result"]:
                    cl.prt("c", str(number_of_objects))
                    for attribute, value in item.items():
                        cl.prt("n","{0:15} : {1:8}".format(attribute,str(value)))
                    number_of_objects = number_of_objects + 1

    def do_analytics_getpayload(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'getpayload', params)
        except Exception as e:
            return cl.perr(str(e))

        analyticsId = params.get("id")

        url = "{0}/analytics/getpayload/{1}".format(self.HTTP.host, analyticsId)

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        if response:
            try:
                # dumping json
                dataResponse = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", dataResponse)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_analytics_info(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'info', params)
        except Exception as e:
            return cl.perr(str(e))

        rackName = params.get("rackname") is not None
        exaunitid = params.get("exaunitid") is not None
        exadatainfrastructure = params.get("exadatainfrastructure") is not None
        vmclusterId = params.get("vmclusterid") is not None

        paramsCount = (1 if rackName else 0) + (1 if exaunitid else 0) + \
            (1 if exadatainfrastructure else 0) + (1 if vmclusterId else 0)

        if paramsCount != 1:
            return cl.perr(str("You have to provide rackname, exaunitid, "\
                +"exadatainfrastructure or vmclusterid, just one of them"))
        
        url = "{0}/analytics/info".format(self.HTTP.host)

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        if response:
            try:
                # dumping json
                dataResponse = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", dataResponse)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def do_stats(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'stats', params)
        except Exception as e:
            return cl.perr(str(e))

        operation = params["operation"]
        url  = "{0}/analytics/stats/{1}".format(host,operation)
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_cs_check(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'csconfigcheck', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunit = params["exaunitid"]
        url = "{0}/analytics/csconfigcheck/{1}".format(host, exaunit)
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_rack(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'rack', params)
        except Exception as e:
            return cl.perr(str(e))
        rackname  = params.get("rackname")
        operation = params.get("operation") if "operation" in params else "all" 
        url = "{0}/analytics/history/{1}/{2}".format(host,rackname, operation)
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_cs_template(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'csconfigtemplate', params)
        except Exception as e:
            return cl.perr(str(e))
        rackname = params["rackname"]
        url = "{0}/analytics/csconfigcheck/{1}".format(host, rackname)
        response = self.HTTP.get(url)
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_get_op_details(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('analytics', 'getoperationdetails', params)
        except Exception as e:
            return cl.perr(str(e))
        op_name = params.get("operation")
        url = "{0}/analytics/history/opdetails/{1}".format(host, op_name)
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,'analytics',uri=url)
        if response:
            if print_raw:
                cl.prt("n", json.dumps(response))
            else:
                for index, res in enumerate(response.get('result')):
                    cl.prt("n", f"{index}")
                    justify_len = len(max(res.keys(), key=len))
                    for key, val in res.items():
                        cl.prt("n", f"{key.ljust(justify_len, ' ')} : {val}")
                # cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

# EOF
