#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Hardware.py /main/14 2025/08/16 00:21:50 jvaldovi Exp $
#
# ExadataInfra.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Hardware.py - CLIs to get hardware properties
#
#    DESCRIPTION
#      Provides the clis to get hardware properties like cores, number of computes etc
#
#    NOTES:
#      None
#
#    MODIFIED   (MM/DD/YY)
#       jvaldovi 08/13/25 - Enh 38266898 - Vmboss_Scheduler | Need A Api
#                           Command For Configured_Features Update
#       caborbon 03/14/24 - Bug 36380593 - Adding restrictions to allow only
#                           number for uid and gid
#       caborbon 01/30/24 - Bug 36242710 - Custom UID and GID can be sent
#                           separately
#       caborbon 12/11/23 - Bug 36095897 - Adding custom linux groups
#                           information
#       caborbon 11/30/23 - Bug 36063773 - Fixing issue in custom ids output
#                           data in error
#       caborbon 11/28/23 - Bug 35990354 - Adding support for custom linux uid 
#                           and gid
#       marcoslo 08/08/20 - ER 30613740 Update code to use python 3
#       rgmurali 05/08/18 - Create file
#

from formatter import cl
import json
import sys

class Hardware:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_properties_hardware(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('hardware', 'properties', params)
        except Exception as e:
            cl.perr(str(e))
            return

        endport_http_request = "{0}/hardwareinfo?".format(host)
        if 'racksize' in params:
            endport_http_request = endport_http_request + "racksize={0}&".format(params['racksize'])
        if 'model' in params:
            endport_http_request = endport_http_request + "model={0}".format(params['model'])
            
        response = ecli.issue_get_request(endport_http_request, printResponse=False)
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def get_rack_info(self, ecli, host, racksize, model):
        response = ecli.issue_get_request("{0}/hardwareinfo?racksize={1}&model={2}".format(host,
            racksize, model), printResponse=False)
        if response is None:
            cl.perr("Cannot get hardware information for {0} {1} rack".format(racksize, model))
            return
        return response

    def do_tenancyproperty_list(self, ecli, line, host):
        response = ecli.issue_get_request("{0}/hardwareinfo/tenancyproperty".format(host), printResponse=False)
        #print(response)
        if response is None:
            cl.perr("Cannot get cloudvnuma information")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def create_customids_json(self, data, element_type):
        lst = []
        data_array = data.split('|')
        for element in data_array:
            element_array = element.split(':')
            if element_type == "users":
                    lst.append({'user': element_array[0], 'uid': element_array[1]})
            else:
                lst.append({'group': element_array[0], 'gid': element_array[1]})
        return lst

    def do_tenancyproperty_put(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('hardware', 'tenancypropertyput', params)
        except Exception as e:
            cl.perr(str(e))
            return
        if 'customids' in params:
            if params["customids"] == 'false':
                params['CUSTOM_UID_GID'] = None
                params.pop("customids")
            elif any(key in params for key in ('usersdata','groupsdata')):
                custom_ids ={}
                if 'usersdata' in params:
                    custom_ids['users'] = self.create_customids_json(params['usersdata'],"users") 
                    params.pop("usersdata")
                if 'groupsdata' in params: 
                    custom_ids['groups'] = self.create_customids_json(params['groupsdata'],"groups")
                    params.pop("groupsdata")
                params['CUSTOM_UID_GID'] = custom_ids
                params.pop("customids")
            else:
                cl.perr("To set Custom Linux Users Ids you need to provided UID or GID or both")
                return
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "hardware", "{0}/hardwareinfo/tenancyproperty".format(host))
        if response is None:
            cl.perr("Cannot add cloudvnuma record information")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


    def do_tenancyproperty_del(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('hardware', 'tenancypropertydel', params)
        except Exception as e:
            cl.perr(str(e))
            return

        tenancy_id = params["tenancy_id"]
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/hardwareinfo/tenancyproperty/{1}".format(host,tenancy_id))
        if response is None:
            cl.perr("Cannot add cloudvnuma record information")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_configurefeaturetenancy_hardware(self, ecli,
                                            line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('hardware', 'configurefeaturetenancy', params)
        except Exception as e:
            cl.perr(str(e))
            return

        tenancy_name = params.pop("tenancyid")
        feature = params.pop("feature")
        value = params.pop("value").lower() == "enabled"


        available_features = [
            "vmboss"
        ]

        if feature not in available_features:
                cl.perr("Available features are: {0}".format(available_features))
                return

        tenancies = []
        if "," in tenancy_name:
            tenancies = tenancy_name.split(",")
        else:
            tenancies = [tenancy_name]

        params["vmbossEnabled"] = value
        for tenancy in tenancies:
            params["vmbossEnabled"] = value
            data = json.dumps(params, sort_keys=True, indent=4)

            url = "{0}/hardwareinfo/configuretenancy/{1}/vmboss"

            response = self.HTTP.put(url.format(self.HTTP.host, tenancy), data, None)
            if response:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
