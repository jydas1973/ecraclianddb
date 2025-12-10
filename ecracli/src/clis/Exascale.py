#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Exascale.py /main/4 2025/10/10 17:48:28 abyayada Exp $
#
# Exascale.py
#
# Copyright (c) 2025, Oracle and/or its affiliates.
#
#    NAME
#      Exascale.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    abyayada    09/25/25 - 38366599 : Autoencryption endpoint for XS
#    llmartin    08/20/25 - Enh 38326113 - Consolidate backfills
#    llmartin    07/29/25 - Enh 38247929 - Accept flatfile as input for ERS IPs
#                           ingestion
#    llmartin    07/16/25 - Creation
#

from formatter import cl
import json
import configparser

class Exascale:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_ersip_register(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("exascale", ["ersip", "register"], params, False)
        except Exception as e:
            cl.perr(str(e))
            return

        if "flat_file" in params:
            #read flatfile to get AD and CABINETNUMBER
            config = {}
            input_file = params["flat_file"]
            with open(input_file, 'r') as file:
                for line in file:
                    line = line.strip()
                    if not line or line.startswith('#'):
                        continue
                    if '=' in line:
                        key, value = line.split('=', 1)
                        config[key.strip()] = value.strip()
            
            if "AD" not in config or "CABINETNUMBER" not in config:
                 cl.prt("n","AD or CABINETNUMBER not in flatfile")
                 return
            cabinet_name= config["AD"] + config["CABINETNUMBER"]

            with open(input_file, 'r') as file:
                section_found = False
                for line in file:
                    if section_found:
                        line = line.strip()
                        parts = line.split()
                        if len(parts) == 3:
                            payload = {}
                            payload["cabinet_name"] = cabinet_name
                            payload["ip"] = parts[1]
                            payload["ocid"] = parts[2]
                            payload["ip_state"] = "AVAILABLE"

                            response = self.HTTP.post(json.dumps(payload), "oci", "{0}/exascale/ersip".format(host))
                            if response:
                                cl.prt("n", json.dumps(response))
                        else:
                            cl.prt("n","Skipping unexpected line")
                            cl.prt("n",line)
                    elif line.strip() == '# Exascale ERS IP addresses':
                        section_found = True
        elif "configfile" in params:
            config = configparser.ConfigParser()
            config.read(params["configfile"])

            for section in config.sections():
                cl.prt("n",section)
                if "admin_active_vnic" in config[section] and  "admin_standby_vnic" in config[section] and  "subnet_ocid" in config[section]:
                    vnic_payload = {
                        "cabinets": [{
                            "cabinet-name": section,
                            "admin_active_vnic": config[section]["admin_standby_vnic"],
                            "admin_standby_vnic": config[section]["admin_standby_vnic"],
                            "subnet_ocid": config[section]["subnet_ocid"]
                        }]
                    }
                    data = json.dumps(vnic_payload, sort_keys=True, indent=4)
                    #cl.prt("n",data)
                    response = self.HTTP.post(data, "backfill", "{0}/cabinet/vnics".format(host))
                    cl.prt("n",json.dumps(response))

                #Iterate the keys to find the ERS IPs
                for key, value in config[section].items():
                    if key.startswith("ers_ip"):
                        parts = [item.strip() for item in value.split(',')]
                        ers_payload = {
                            "cabinet_name": section,
                            "ip": parts[0],
                            "ocid": parts[1],
                            "ip_state": "AVAILABLE"
                        }
                        response = self.HTTP.post(json.dumps(ers_payload), "oci", "{0}/exascale/ersip".format(host))
                        cl.prt("n","{}: Response: {} Details: {}".format(parts[0],response["status"],response["status-detail"] ))
                cl.prt("n","")
        else:
            response = self.HTTP.post(json.dumps(params), "oci", "{0}/exascale/ersip".format(host))
            if response:
                cl.prt("n", json.dumps(response))


    def do_ersip_get(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("exascale",["ersip", "get"], params, True)
        except Exception as e:
            cl.perr(str(e))
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/exascale/ersip{1}".format(host,query), False)
        cl.prt("n",json.dumps(response, indent=4, sort_keys=False))


    def do_ersip_delete(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("exascale",["ersip", "delete"], params, True)
        except Exception as e:
            cl.perr(str(e))
            return
        ocid = params["ocid"]
        response = self.HTTP.delete("{0}/exascale/ersip/{1}".format(host, ocid))
        if response:
            cl.prt("n", json.dumps(response))

    def do_autoencryption_config(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        ecra_env = ecli.issue_get_request("{0}/properties/{1}".format(self.HTTP.host, "ECRA_ENV"),False)
        ecra_env = ecra_env["property_value"]
        ecli.validate_parameters("exascale", ["autoencryption", "config"], params, True)
        if "exaocid" not in params:
            cl.perr("Please provide exaocid")
            return
        exaocid = params["exaocid"]
        data = json.dumps({}, sort_keys=True, indent=4)
        if ecra_env == "ociexacc":
            response = self.HTTP.post(data, "oci", f"{host}/exadata/{exaocid}/exascale/configautoencryption")
        else:
            response = self.HTTP.post(data, "oci", f"{host}/exadatainfrastructure/{exaocid}/exascale/configautoencryption")
        cl.prt("n", json.dumps(response) if response else "{}")
