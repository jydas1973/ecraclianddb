#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Oci.py /main/9 2025/06/25 17:35:48 llmartin Exp $
#
# Oci.py
#
# Copyright (c) 2023, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Oci.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      This cli includes operations for oci resources like compute instances,
#      vnics, subnets, floating ips, etc.
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    llmartin    06/23/25 - Enh 38052083 - Add Map, unmap and update
#    ddelgadi    10/10/23 - Enh 35645579 - improvement was added to read json
#    jzandate    08/31/23 - Enh 35757125 - Adding compartment id to compute
#                           client
#    jzandate    07/14/23 - Enh 35606126 - ECRA PREPROV - OCI IAD 2 ENV
#                           ENHANCEMENTS
#    jzandate    05/05/23 - Enh 35108484 - Adding get,delete,create DNS methods
#                           to OciResource
#    jzandate    04/20/23 - Enh 35161257 - Adding oci conectivity check
#    jzandate    03/24/23 - Enh 35064903 - Add compute oci apis
#    jzandate    03/21/23 - Enh 35108484 - Adding Network wrapper for oci apis
#    jzandate    03/08/23 - Enh 35048451 - adding api calls for oci compute
#                           client
#    aadavalo    02/23/23 - Creation
#

from formatter import cl
import json

class Oci:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_create_compute_instance(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "create"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "oci", "{0}/oci/compute/instance".format(host))
        if response:
            self.oci_pretty_print(response)

    def do_delete_compute_instance(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "delete"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        instanceId = params["instanceid"]
        response = self.HTTP.delete("{0}/oci/compute/instance/{1}".format(host, instanceId))
        if response:
            self.oci_pretty_print(response)

    def do_get_compute_instance(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "get"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        instance_id= params["instanceid"] if "instanceid" in params else None
        cavium_id = params["caviumid"] if "caviumid" in params else None
        compartment_id = params["compartmentid"] if "compartmentid" in params else ""

        response = ecli.issue_get_request(
            "{0}/oci/compute/instance?instanceId={1}&caviumId={2}&compartmentId={3}"
            .format(host, instance_id, cavium_id, compartment_id), False)
        self.oci_pretty_print(response)

    def do_create_oci_vnic(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        response = None
        try:
            ecli.validate_parameters("oci", ["compute", "createvnic"], params, False)
            response = self.HTTP.post(json.dumps(params), "oci", "{0}/oci/vcn/vnic".format(host))
        except Exception as e:
            cl.perr(str(e))
            return


        if response:
            self.oci_pretty_print(response)

    def do_get_oci_vnic(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "getvnic"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        vnicId = params["vnicid"] if "vnicid" in params else ""
        compartment_id = params["compartmentid"] if "compartmentid" in params else ""

        response = ecli.issue_get_request("{0}/oci/vcn/vnic/{1}?compartmentId={2}"
                      .format(host, vnicId, compartment_id), False)
        if response:
            self.oci_pretty_print(response)

    def do_delete_oci_vnic(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "deletevnic"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        vnicId = params["vnicid"]
        response = self.HTTP.delete("{0}/oci/vcn/vnic/{1}".format(host, vnicId))
        if response:
            self.oci_pretty_print(response)

    def do_attach_oci_vnic(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "attachvnic"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        instanceId, vnicId = params["instanceid"], params["vnicid"]

        response = self.HTTP.post(json.dumps(params), "oci", "{0}/oci/compute/instance/{1}/vnic/{2}/attach".format(host, instanceId, vnicId))
        if response:
            self.oci_pretty_print(response)

    def do_detach_oci_vnic(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "detachvnic"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        instance_id = params["instanceid"] if "instanceid" in params else None
        vnic_attachment_id = params["vnicattachmentid"] if "vnicattachmentid" in params else None
        compartment_id = params["compartmentid"] if "compartmentid" in params else None

        # for this endpoint preserveVnic is handled by ecra api
        response = self.HTTP.post(
            json.dumps(params),
            "oci",
            "{0}/oci/compute/instance/{1}/vnic/{2}/detach?compartmentId={3}"
            .format(host, instance_id, vnic_attachment_id, compartment_id))
        if response:
            self.oci_pretty_print(response)

    def do_create_floatingip(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "createfloatingip"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        vnicId = params["vnicid"]
        response = self.HTTP.post(json.dumps(params), None, "{0}/oci/vcn/vnic/{1}/floatingip".format(host, vnicId))
        if response:
            self.oci_pretty_print(response)


    def do_get_floatingip(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "getFloatingip"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        ipId = params["ipId"]
        response = self.HTTP.get("{0}/oci/vcn/floatingip/{1}".format(host, ipId),  None)
        if response:
            self.oci_pretty_print(response)

    def do_update_floatingip(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "updateFloatingip"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        ipId = params["ipId"]
        response = self.HTTP.put("{0}/oci/vcn/floatingip/{1}".format(host, ipId), json.dumps(params), None, None)
        if response:
            self.oci_pretty_print(response)



    def do_map_floatingip(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "mapFloatingip"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        ipId = params["ipId"]
        vnicId = params["vnicid"]
        response = self.HTTP.put("{0}/oci/vcn/floatingip/{1}/map?vnicId={2}".format(host, ipId, vnicId), json.dumps(params), None, None)
        if response:
            self.oci_pretty_print(response)

    def do_unmap_floatingip(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "unmapFloatingip"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        floatingIpId = params["ipId"]
        response = self.HTTP.delete("{0}/oci/vcn/floatingip/{1}/map".format(host, floatingIpId))
        if response:
            self.oci_pretty_print(response)


    def do_delete_floatingip(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "deletefloatingip"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        floatingIpId = params["floatingipid"]
        response = self.HTTP.delete("{0}/oci/vcn/vnic/0/floatingip/{1}".format(host, floatingIpId))
        if response:
            self.oci_pretty_print(response)

    def do_list_vnics(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "listvnics"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        compartment_id = params["compartmentid"]
        response = ecli.issue_get_request(
            "{0}/oci/vcn/vnic/list/compartment/{1}".format(host, compartment_id), False)
        self.oci_pretty_print(response)

    def do_list_ips(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["compute", "listips"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        vnic_id = params["vnicid"]
        response = ecli.issue_get_request(
            "{0}/oci/vcn/vnic/{1}/ips".format(host, vnic_id), False)
        self.oci_pretty_print(response)

    def do_conectivity_check(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["connectivity", "check"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        compartment_id = params["compartmentid"] if "compartmentid" in params else None
        query = "compartmentid=" + compartment_id if compartment_id is not None else ""
        response = ecli.issue_get_request(
            "{0}/oci/connectivity/check?{1}".format(host, query), False)
        self.oci_pretty_print(response)

    def do_configuredns(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["network", "configuredns"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "oci", "{0}/oci/dns".format(host))
        if response:
            self.oci_pretty_print(response)


    def do_get_dns(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["network", "getdns"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        subnet_id = params["subnetid"] if "subnetid" in params else None
        fqdn = params["fqdn"] if "fqdn" in params else None

        query = "subnetid=" + subnet_id if subnet_id is not None else ""
        query += "&fqdn=" + fqdn if fqdn is not None else ""

        response = ecli.issue_get_request(
            "{0}/oci/dns?{1}".format(host, query), False)
        self.oci_pretty_print(response)


    def do_delete_dns(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("oci", ["network", "deletedns"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return
        subnet_id = params["subnetid"] if "subnetid" in params else None
        fqdn = params["fqdn"] if "fqdn" in params else None

        query = "subnetid=" + subnet_id if subnet_id is not None else ""
        query += "&fqdn=" + fqdn if fqdn is not None else ""

        response = self.HTTP.delete("{0}/oci/dns?{1}".format(host, query))
        self.oci_pretty_print(response)

    def oci_pretty_print(self, response):
        if "response" in response:
            if type(response["response"]) is not dict:
                response["response"] = json.dumps(response["response"])

        cl.prt("n", json.dumps(response, indent=2, sort_keys=False))
