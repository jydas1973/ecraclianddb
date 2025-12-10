#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/SiteGroup.py /main/10 2025/08/16 00:21:50 jvaldovi Exp $
#
# SiteGroup.py
#
# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
#
#    NAME
#      SiteGroup.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      This code it's used to define the site group functionality
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    jvaldovi    08/13/25 - Enh 38266898 - Vmboss_Scheduler | Need A Api
#                           Command For Configured_Features Update
#    jvaldovi    06/22/25 - Enh 37985641 - Exacs Ecra - Ecra To Configure Dbaas
#                           Tools Name Rpm Basd On Cloud Vendor
#    jzandate    05/09/25 - Enh 37647220 - Adding tenancy config on cascade by
#                           sitegroup config
#    jzandate    03/18/25 - Enh 37525577 - Adding configured features
#    jvaldovi    01/09/25 - Bug 37331575 - Ecra:Ecracli: Sitegroup Apis To Have
#                           Unified Field Names In Add Vs Update Endpoints
#    jvaldovi    10/17/24 - Enh 37181642 - Add Cloud_Provider_Az And
#                           Cloud_Provider_Building To Site Groups Table In
#                           Ecra
#    zpallare    08/26/24 - Bug 36959599 - EXACS: Indigo feature needs an
#                           ecracli command to update sitegrp information
#    jvaldovi    07/26/24 - Enh 36858584 - Ecra: Multicloud: Add Site Group
#                           Data To Ecra
#    ddelgadi    11/16/23 - Functionality to Backfill Site group
#    ddelgadi    11/16/23 - Creation
#
import json

from formatter import cl


class SiteGroup:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_sitegroup_list(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sitegroup', 'list', params, strict=False)
        except Exception as e:
            cl.perr(str(e))
            return

        url="{0}/sitegroup"

        # Add query parameters if needed
        if params is not None and len(params)> 0:
            url += "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()])

        response = ecli.issue_get_request(url.format(self.HTTP.host), printResponse=False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
   
    def do_sitegroup_add(self, ecli, line):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('sitegroup', 'add', params)
        except Exception as e:
            cl.perr(str(e))
            return
        data = json.dumps(params, sort_keys=True, indent=4)
        
        url="{0}/sitegroup"

        response = self.HTTP.post(data, None, url.format(self.HTTP.host))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_sitegroup_update(self, ecli, line):
        params = ecli.parse_params(line, None, optional_key="name")
        try:
            ecli.validate_parameters('sitegroup', 'update', params, strict=False)
        except Exception as e:
            cl.perr(str(e))
            return
        sitegroup = params.pop("name")
        data = json.dumps(params, sort_keys=True, indent=4)
        
        url="{0}/sitegroup/{1}"

        response = self.HTTP.put(url.format(self.HTTP.host,sitegroup), data, None)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_sitegroup_updaterpm(self, ecli, line):
        params = ecli.parse_params(line, None, optional_key="cloudvendor")
        try:
            ecli.validate_parameters('sitegroup', 'updaterpm', params, strict=False)
        except Exception as e:
            cl.perr(str(e))
            return
        cloudvendor = params.pop("cloudvendor")
        data = json.dumps(params, sort_keys=True, indent=4)

        url="{0}/sitegroup/rpm/{1}"

        response = self.HTTP.put(url.format(self.HTTP.host, cloudvendor), data, None)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_sitegroup_configurefeature(self, ecli, line):
            params = ecli.parse_params(line, None, optional_key="name")
            try:
                ecli.validate_parameters('sitegroup', 'configurefeature', params, strict=False)
            except Exception as e:
                cl.perr(str(e))
                return
            sitegroup_name = params.pop("name")
            feature = params.pop("feature")
            value = params.pop("value").lower() == "enabled"


            if feature != "vmboss":
                cl.perr("Available features are: [vmboss]")
                return
            sitegroups = []
            if "," in sitegroup_name:
                sitegroups = sitegroup_name.split(",")
            else:
                sitegroups = [sitegroup_name]
            params["vmbossEnabled"] = value

            for sitegroup in sitegroups:

                data = json.dumps(params, sort_keys=True, indent=4)

                url = "{0}/sitegroup/{1}/vmboss"

                response = self.HTTP.put(url.format(self.HTTP.host, sitegroup), data, None)
                if response:
                    cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

