#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Preprovision.py /main/6 2023/11/01 14:46:47 zpallare Exp $
#
# Preprovision.py
#
# Copyright (c) 2023, Oracle and/or its affiliates.
#
#    NAME
#      Preprovision.py - Module to execute pre-provision endpoints.
#
#    DESCRIPTION
#      CLI module to perform different pre-provisioning operations.
#
#    MODIFIED   (MM/DD/YY)
#    zpallare    10/25/23 - Enh 35823610 - Preprovisioning:need ecra endpoint
#                           for get compute VNICS
#    zpallare    10/11/23 - Enh 35823587 - EXACS: Preprovisioning need ecra
#                           endpoint for get subnets
#    llmartin    07/04/23 - Enh 34851277 - Preprov, show error on unexpected
#                           command
#    jzandate    06/26/23 - Enh 35156973 - Adding Capacity Move
#    ririgoye    04/18/23 - Creation
#
import os
import json
from formatter import cl

class Preprovision:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_control_scheduler(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="operation")
        try:
             ecli.validate_parameters('preprov', 'scheduler', params)
        except Exception as e:
             return cl.perr(str(e))
        url = "{0}/preprovision/scheduler/".format(host)
        response = None
        operation = params.get("operation")
        if operation == "start":
            response = self.HTTP.post("", "preprov", url)
        elif operation == "stop":
            response = self.HTTP.delete(url)
        elif operation == "get":
            response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, sort_keys=False, indent=4))
 
    def do_scheduler_start(self, ecli, line, host):
        url = "{0}/preprovision/scheduler/".format(host)
        response = self.HTTP.post("", "preprov", url)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))   

    def do_scheduler_stop(self, ecli, line, host):
        url = "{0}/preprovision/scheduler/".format(host)
        response = self.HTTP.delete(url) 
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_scheduler_list(self, ecli, line, host):
        url = "{0}/preprovision/scheduler/".format(host)
        response = self.HTTP.get(url) 
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_fleet_get(self, ecli, line, host):
        url = "{0}/preprovision/fleet/".format(host)
        response = self.HTTP.get(url)
        cl.prt("n", json.dumps(response, sort_keys=False, indent=4))


    def do_get_jobs(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="job")
        try:
            ecli.validate_parameters('preprov', ['jobs', 'get'], params)
        except Exception as e:
            return cl.perr(str(e))
        url = "{0}/preprovision/job/".format(host)
        job_class = params.get("job")
        if job_class:
            url = "{0}/preprovision/job/{1}/".format(host, job_class)
        response = self.HTTP.get(url)
        if response:
            if "configuration" in response:
                cl.prt("n", json.dumps(json.loads(response['configuration']), sort_keys=False, indent=4))
            else:
                cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_update_job(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="job")
        try:
            ecli.validate_parameters('preprov', ['jobs', 'update'], params)
        except Exception as e:
            return cl.perr(str(e))
        job_class = params.get("job")
        
        payload = {}
        data = ""
        if "configuration" in params:
            config_path = params.get("configuration")
            metadata = None
            with open(config_path, 'r') as config_file:
                try:
                    metadata = json.load(config_file)
                except json.JSONDecodeError as e:
                    return cl.perr(f"Couldn't decode JSON file due to the following error: {e.msg}")
            data = json.dumps(metadata, indent=4, sort_keys=False)
            payload["configuration"] = data
        url = "{0}/preprovision/job/{1}/".format(host, job_class)
       
        if "enabled" in params:
            payload["enabled"] = params.get("enabled")

        response = self.HTTP.put(url, json.dumps(payload, indent=4, sort_keys=False), "preprov")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_preprov_delete_rack_resources(self, ecli, line, host):

        params = ecli.parse_params(line, None, optional_key="rackname")
        # Validate the parameters
        try:
            ecli.validate_parameters('preprov', 'deleterackresources', params)
        except Exception as e:
            cl.perr(str(e))
            return
        rackname = params["rackname"]
        url = "{0}/racks/preprovisioning/{1}".format(host, params["rackname"])
        response = self.HTTP.delete(url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_preprov_capacitymove(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        # Validate the parameters
        try:
            ecli.validate_parameters('preprov', 'capacitymove', params)
        except Exception as e:
            cl.perr(str(e))
            return
        data = json.dumps(params, sort_keys=False)
        url = "{0}/preprovision/capacitymove".format(host) 
        response = self.HTTP.post(data, "preprov", url)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
    
    def do_get_vcn(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('preprov', ['vcn', 'get'], params)
        except Exception as e:
            return cl.perr(str(e))
        url = "{0}/preprovision/vcn/".format(host)
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_get_subnet(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('preprov', ['subnet', 'get'], params)
        except Exception as e:
            return cl.perr(str(e))
        url = "{0}/preprovision/subnet/".format(host)
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, sort_keys=False, indent=4))

    def do_get_vnics(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('preprov', ['vnics', 'get'], params)
        except Exception as e:
            return cl.perr(str(e))
        filters = ""
        if "rackname" in params:
            filters+="?rackname="+params["rackname"]
        url = "{0}/preprovision/vnic{1}".format(host,filters)
        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, sort_keys=False, indent=4))
