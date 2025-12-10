"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Iorm - CLIs for cores update

FUNCTION:
    Provides the clis to update cores

NOTE:
    None

History:
    marcoslo    08/08/2020 - ER 30613740 Update code to use python 3
    rgmurali    12/07/2017 - Bug 27195870 - Fix pylint errors
    rgmurali    07/10/2017 - Create file
"""
from formatter import cl
import json
import os
from os import path
import base64
from clis.EcliUtil import EcliUtil

class Cores:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_update_cores(self, ecli, line, host, mytmpldir):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        cores = self.HTTP.get("{0}/exaunit/{1}/cores".format(host, exaunit_id))
        if not cores:
            cl.perr("Unable to fetch current cores information from ecra. Update cores failed")
            return
        
        params = ecli.parse_params(rest, None)

        try:
            ecli.validate_parameters('cores', 'update', params)
        except Exception as e:
            cl.perr(str(e))

        if type(params) is str:
            cl.perr(params)
            return

        options = ["subscriptionOcpu", "meteredOcpu", "burstOcpu"]
        ingest_json = False
        if "json_path" in params and params["json_path"] != "":
            # If json_path is passed rest of the options are not expected
            # and vice-versa, to avoid ambiguity of values
            for opt in options:
                if opt in params:
                    cl.perr("Params {0} are not allowed when passing json_path param".format(options))
                    return
            #load Json data
            data = EcliUtil.load_json(params["json_path"])
            if data == False:
                return
            ingest_json = True


        env = "gen1"
        if "env" in params:
            env = params.pop("env")
            if (env != "gen1" and env != "gen2" and env != "nosdi"):
                cl.perr("Env value can be gen1/gen2/nosdi, supplied value: " + env)
                return


        if not params:
            cl.perr("Please specify the ocpus per vm that you want to update with <ocpu>=number. Available options are " + str(options))
            return

        exaunit_info = self.HTTP.get("{0}/exaunit/{1}".format(host, exaunit_id))

        if (env == "nosdi"):
            if not exaunit_info :
                cl.perr("Unable to fetch current exaunit information from ecra. Update cores failed")
                return

            sspName = exaunit_info["service_specific_payload"][0]["name"]
            if(sspName != "PSM_CLOB"):
                cl.perr("Unable to fetch current exaunit information from ecra. Missing PSM_CLOB field")
                return
            ssp = exaunit_info["service_specific_payload"][0]["value"]
            exaunit_info = json.loads(base64.b64decode(ssp.encode("utf-8")).decode("utf-8"))

        numPermanentOcpu = None
        numBurstOcpu = None

        if ingest_json:
            for host_cores in cores["ocpuAllocations"]:
                new_cores_type = ""
                new_cores_value = ""
                # Get specific Values for VM
                for vm in data.get("vms"):
                    if vm.get("hostname") == host_cores.get("hostName"):
                        for opt in options:
                            if opt in vm:
                                new_cores_type = opt
                                new_cores_value = vm[opt]

                if new_cores_type == None or new_cores_type == "":
                    continue

                # Check values
                try:
                    int(new_cores_value)
                except ValueError:
                    cl.perr("Please specify a valid core number for hostname {0}".format(host_cores.get("hostName")))
                    return

                if (new_cores_type == "subscriptionOcpu") or (new_cores_type == "meteredOcpu") :
                  numPermanentOcpu = new_cores_value
                elif ( new_cores_type == "burstOcpu") :
                  numBurstOcpu = new_cores_value

                if new_cores_type in host_cores:
                    host_cores[new_cores_type] = new_cores_value
        else:
            for host_cores in cores["ocpuAllocations"]:
                for key, value in params.items():
                    if key not in options:
                        cl.perr("Please specify the ocpus per vm that you want to update with <ocpu>=number. Available options are " + str(options))
                        return

                    try:
                        int(value)
                    except ValueError:
                        cl.perr("Please specify a valid core number")
                        return
                    if (key == "subscriptionOcpu") or (key == "meteredOcpu") :
                      numPermanentOcpu = value
                    elif ( key == "burstOcpu") :
                      numBurstOcpu = value

                    if key in host_cores:
                        host_cores[key] = value
        resizeJson = {}
        if env == "gen1" :
            if not exaunit_info or "pod_guid" not in exaunit_info:
                cl.perr("Unable to fetch current exaunit information from ecra. Update cores failed")
                return
            service_uuid = exaunit_info["services"][0]["id"]
            burst_payload = os.path.join(mytmpldir,"burst_ssp.xml")
            ssp = open(burst_payload)
            data_ssp = ssp.read().strip()
            data_ssp = data_ssp.replace('%ENCODEDCORES%', base64.b64encode(json.dumps(cores, sort_keys=True, indent=4).encode("utf-8")).decode("utf-8"))
            data_ssp = data_ssp.replace('%DBAASUPDATEPAYLOAD%', "")
            essp = base64.b64encode(data_ssp.encode("utf-8")).decode("utf-8")
            resizeJson = {
                "id" : service_uuid,
                "identity_domain_name" : "exatest1",
                "name" : "upsizetest",
                "service_specific_payload" : essp,
                "trial" : False
            }
            data = json.dumps(resizeJson, sort_keys=True, indent=4)
            response = self.HTTP.put("{0}/services/{1}".format(host, service_uuid), data, "services")
            ecli.waitForCompletion(response, "resize_exaunit")
        elif env == "nosdi" :
            service_uuid = exaunit_info["services"][0]["id"]
            ocpu_allocations = base64.b64encode(json.dumps(cores, sort_keys=True, indent=4).encode("utf-8")).decode("urf-8")
            # Values below for AdditionalNumOfCoresHourly and AdditionalNumOfCores are not the delta that is expected by PSM 
            # but is ok here as ecracli is not used by PSM. In the real end to end flow CIM/TAS will set this. ECRA doesn't use these values
            if numBurstOcpu :
              resizeJson = {
              "id": service_uuid,
              "size": "CUSTOM",
              "service_specific_payload": [
                 {
                  "name": "OCPU_ALLOCATIONS",
                  "value": ocpu_allocations
                 },
                 {
                  "name": "AdditionalNumOfCoresHourly",
                  "value": numBurstOcpu
                 }
                ]
              }
            elif numPermanentOcpu:
              resizeJson = {
              "id": service_uuid,
              "size": "CUSTOM",
              "service_specific_payload": [
                 {
                  "name": "OCPU_ALLOCATIONS",
                  "value": ocpu_allocations
                 },
                 {
                  "name": "AdditionalNumOfCores",
                  "value": numPermanentOcpu
                 }
                ]
              }
            else:
               cl.perr("One of subscriptionOcpu, meteredOcpu, burstOcpu has to be set")
               return

            data = json.dumps(resizeJson, sort_keys=True, indent=4)
            response = self.HTTP.put("{0}/services/{1}".format(host, service_uuid), data, "services")
            ecli.waitForCompletion(response, "resize_exaunit")
        else:
            # Gen2
            if not exaunit_info:
                cl.perr("Unable to fetch current exaunit information from ecra. Update cores failed")
                return
            svcuri = exaunit_info["svcuri"]
            if "idemtoken" in params and params["idemtoken"]:
                idemtoken = params["idemtoken"]
            else:
                # Get token to send service update request
                retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
                if retObj is None or retObj['status'] != 200:
                    cl.perr("Could not get token to provision rack")
                    cl.prt("n", "Response data")
                    for key, value in retObj.items():
                        cl.prt("p", "{0} : {1}".format(key, value))
                    return
                idemtoken = retObj["idemtoken"]
            resizeJson = cores
            resizeJson ["idemtoken"] = idemtoken
            data = json.dumps(resizeJson, sort_keys=True, indent=4)
            response = self.HTTP.put(svcuri, data, "services")
            ecli.waitForCompletion(response, "resize_exaunit")
