"""
!/usr/bin/env python

$Header: ecs/ecra/ecracli/src/clis/Exaunit.py /main/53 2025/11/19 21:19:15 jzandate Exp $ $

Exaunit.py

 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    Exaunit - CLIs for operations on the exaunit

FUNCTION:
    Provides the clis to query exaunit attributes

NOTE:
    None

History:
    jzandate    11/18/25 - Enh 38618961 - Updating Add compute Payload for admin
                           network
    jreyesm     14/08/25 - Bug 38294786. Fix vms function.
    ririgoye    13/02/25 - Enh 35270020 - CREATE AN API IN ECRA FOR MARS TEAM TO
                           PUSH THE VMCORE TO MOS
    ririgoye    02/05/25 - Bug 35023107 - EXACS ECRA - Create API that returns 
                           computed size of the existing guest
    zpallare    01/08/25 - Enh 37327315 - EXACS ECRA - Create rotatekeys command
                           at exaunit level
    zpallare    12/04/24 - Enh 36754344 - EXACS Compatibility - create new 
                           apis for compatibility matrix and algorithm for locking
    gvalderr    11/09/24 - Enh 36990685 - Adding exaunit securevms command
    zpallare    04/30/24 - Enh 36315071 - EXACS ECRA - create/modify new
                           endpoint to set asm power limit
    zpallare    12/18/23 - Enh 36068362 - Create ecra api to invoke an
                           endpoint for time zone changes
    zpallare    11/30/23 - Bug 35866829 - Allow retry after setting
                           exacloud_cs_skip_swversion_check
    zpallare   08/22/23 - Enh 35665349 - EXACS: normalize the parameter to
                          indicate a dom0 in reserve, addcompute,
                          deletecompute in ecracli
    gvalderr    07/27/23 - Ehn 35621839 - Adding to detail_update filesystem option.
    gvalderr    06/09/23 - Enh 35435659 - Modifying how the exaunit detail output is displayed
    ddelgadi    10/27/22 - Enh 34687382 - Adding hostname to addcell
    ddelgadi    05/05/22 - Bug 34166196 - Controlate variable validate_max_size to 
                           boolean value
    aadavalo    03/27/21 - ER 33817649 - Adding getcspayload command
    caborbon    11/19/21 - Enh 33428084 - Adding hostnames parameter in deletecompute
    marcoslo    11/12/20 - ER 31881281 - Ability to delete elastic compute and storage
    jreyesm     08/28/20 - E.R 31794630  add rackname dynamic on elastic
    llmartin    06/08/20 - Enh 31415724 - Ecracli framework, elastic 
    rgmurali    12/02/19 - ER 30550141 - List domu bonding racks
    jvaldovi    11/20/19 - Bug 30490382  - Adding resizefs command
    llmartin    02/18/19 - ENH 29266406 - Elastic, command to change ASM
                           rebalance power
    sgundra     04/30/18 - Bug 27947099 - Exaunit Suspend/Resume
    jreyesm     02/02/2017 - Bug 27011241. Added vm log extraction
    rgmurali    07/14/2017 - Create file
"""
from formatter import cl
import json
import os
from os import path
import base64
import re
import time

class Exaunit:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    # get network information from rack xml for the given exaunit
    def do_exaunit_info(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        ecli.issue_get_request("{0}/exaunit/{1}/info".format(host, exaunit_id))

    def do_exaunit_logs(self, ecli, line, host, mylogdir):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, None, warning=False)
        #Add default dest if missing
        if not 'dest' in params:
            params['dest']=mylogdir
        
        try:
            ecli.validate_parameters("exaunit", "logs", params)
        except Exception as e:
            cl.perr(str(e))
            return
       
        urlStr = "{0}/exaunit/{1}/logs?dest="+params['dest']
        if 'dbName' in params or 'vmName' in params:
            data=[]
            urlStr+="&"
            if 'dbName' in params:
                data.append('dbName='+params['dbName'])
            if 'vmName' in params:
                data.append('vmName='+params['vmName'])
            urlStr+='&'.join(data)
                

        response = self.HTTP.get(urlStr.format(host, exaunit_id))
        cl.prt("n", json.dumps(response))

    # get cores allocation info for the given exaunit
    def do_exaunit_cores(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        ecli.issue_get_request("{0}/exaunit/{1}/cores".format(host, exaunit_id))

    # list dbSIDs of created databases for the given exaunit
    def do_exaunit_dbs(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        dbs = ecli.issue_get_request("{0}/exaunit/{1}/databases".format(host, exaunit_id),False)
        cl.prt("n", json.dumps(dbs, indent=4, sort_keys=True))

    # get the detailed parameters for the given exaunit
    def do_exaunit_detail(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        data = ecli.issue_get_request("{0}/exaunit/{1}/detail".format(host, exaunit_id), False)
        cl.prt("n", json.dumps(data, indent=4, sort_keys=False))

    # post to update exaunit detail
    def do_exaunit_detail_update(self, ecli, line, host):
    
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)
        try:
             ecli.validate_parameters('exaunit', 'detail_update', params)
        except Exception as e:
            return cl.perr(str(e))

        strFilesystem = "filesystem"
        hasFSupdate = params.get(strFilesystem) is not None

        if hasFSupdate:
            if params.get(strFilesystem):
                resource = strFilesystem
                quantity = [{"mountpoint": mountpoint[0], "sizegb": mountpoint[1]} for mountpoint in [element.split(':') for element in params.get(resource).split(',')]]
                params["filesystem"] = quantity
       
        data = json.dumps(params, sort_keys=True, indent=4)

        response = self.HTTP.put("{0}/exaunit/{1}/details".format(host, exaunit_id), data, "exaunits")
       
        if response:
            if not ecli.interactive and "status_uri" in response:
                cl.prt("n", response["status_uri"])
            else:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_exaunit_hasoperation(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        ecli.issue_get_request("{0}/exaunit/{1}/hasOperation".format(host, exaunit_id))

    def get_exaunit_vms(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        rt = ecli.issue_get_request("{0}/exaunit/{1}/cores".format(host, exaunit_id), False)
        vms = []
        for i in rt["ocpuAllocations"] :
            vms.append(str(i["hostName"]))
        return vms

    def do_exaunit_vms(self, ecli, line, host):
        vms = self.get_exaunit_vms(ecli, line, host)
        cl.prt("n","VM's: {0}".format(str(vms)))


    def do_exaunit_domukeys(self, ecli, line, host):
        self.get_exaunit_domukeys(ecli, line, host)

    def get_exaunit_domukeys(self, ecli, line, host):
        query_str = ""
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)
        if type(params) is str:
            return
        if len(rest) > 1:
            query_str = "?"
            for param in params:
                query_str = query_str + param + "=" + params[param] + "&"
            query_str = query_str[:-1]
        rt = ecli.issue_get_request("{0}/exaunit/{1}/vms/keys{2}".format(host, exaunit_id, query_str), True)
        return rt

    # get exaunit information
    def do_get_exaunit(self, ecli, line, host):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, None, warning=False)
        url = None
        if 'env' in params and params['env'] == 'ocimvm':
            svcEnv = params['env']
            if svcEnv == 'ocimvm':
                if "exaOcid" not in params:
                    cl.prt("r", "Missing mandatory param for delete cluster in ocimvm env : [exaOcid]")
                    return
                cl.prt("c", "Requested ENV is OCI MVM. Attempting Get Cluster Details on exaOcid : [{0}]".format(params["exaOcid"]))
                url = "{0}/exadata/{1}/exaunit/{2}".format(self.HTTP.host, params["exaOcid"], exaunit_id)
        else:
            if ecli.interactive:
                cl.prt("c", "Getting exaunit {0} information".format(exaunit_id))
            url = "{0}/exaunit/{1}".format(host, exaunit_id)

        cl.prt("c", "GET " + url)
        response = self.HTTP.get(url)
        if not response:
            cl.perr("Failed to get exaunit {0} information".format(exaunit_id))
            return
        if 'dom0' in params:
            domuDetails = response['dom0domUDetails']
            newDomuDetails = [ domu  for domu in domuDetails if domu['dom0Hostname'].split('.')[0] == params['dom0'] ]
            response['dom0domUDetails'] = newDomuDetails
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
        #if not ecli.interactive:
        #    cl.prt("n", json.dumps(response))
        #    return
        
        #for key, value in response.items():
        #    key, value = str(key), str(value)
        #    if key != "pod_payload" or ecli.verbose:
        #        cl.prt("p", "{0} : {1}".format(key, value))
        #    else:
        #        cl.prt("p", "{0} : {1}".format(key, value[:75] + "..." if len(value) > 75 else value))

    # get all exaunit (infra level) basic information
    def do_get_allexaunits(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        url = None

        # Validate the parameters
        try:
            ecli.validate_parameters("exaunit", "getallforinfra", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if 'env' in params and params['env'] == 'ocimvm':
            svcEnv = params['env']
            if svcEnv == 'ocimvm':
                if "exaOcid" not in params:
                    cl.prt("r", "Missing mandatory param for getall clusters in ocimvm env : [exaOcid]")
                    return
                cl.prt("c", "Requested ENV is OCI MVM. Attempting GET basic details for all clusters of exaOcid : [{0}]".format(params["exaOcid"]))
                url = "{0}/exadata/{1}/exaunits".format(self.HTTP.host, params["exaOcid"])
        else:
            cl.perr("This command does not support any other infra type yet. Please check help for usage.")
            return

        cl.prt("c", "GET " + url)
        response = self.HTTP.get(url)
        if not response:
            cl.perr("Failed to get exaunits information")
            return
        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    # drop exaunit information
    def do_drop_exaunit(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)

        if ecli.interactive:
            cl.prt("c", "Dropping exaunit: {0}".format(exaunit_id))
        response = self.HTTP.delete("{0}/exaunit/{1}/record".format(host, exaunit_id))
        cl.prt("n", json.dumps(response))
        ecli.pull_exaunits()

    # resize service with given number of cores
    def do_resize_exaunit(self, ecli, line, host, mytmpldir):
        if len(line.split()) < 2:
            cl.perr("resize_exaunit takes two or more parameters. Please check help for usage.")
            return
        line = line.split(' ', 2)
        service_id = line[0]
        cores = line[1]
        rest = line[2] if len(line) > 2 else None
        env="gen1"
        if rest:
            params = ecli.parse_params(rest, None)
            env = params.pop("env")
            if (env != "gen1" and env != "gen2" and env != "nosdi"):
                cl.perr("Env value can be gen1/gen2/nosdi, supplied value: " + env)
                return
        
        if ecli.interactive:
            cl.prt("c", "Resizing exaunit with service id {0}".format(service_id))

        updated_order_components = os.path.join(mytmpldir,"order.updated.components.xml")
        service_specific_payload = os.path.join(mytmpldir,"service_specific_payload.xml")

        with open(updated_order_components) as uoc:
            data_uoc = uoc.read().strip()

        # print adding cores to file
        data_uoc = data_uoc.replace('%CORES_NUMBER%', cores)
        euoc = base64.b64encode(data_uoc)

        resizeJson = {}
        if ((env == "gen1") or (env == "gen2")) :
            with open(service_specific_payload) as ssp:
                data_ssp = ssp.read().strip()
            data_ssp = data_ssp.replace('%DBAASUPDATEPAYLOAD%', euoc)
            essp = base64.b64encode(data_ssp)
            # generating a new json
            resizeJson = {
                "id" : service_id,
                "identity_domain_name" : "exatest1",
                "name" : "upsizetest",
                "service_specific_payload" : essp,
                "trial" : False
            }

        elif(env == "nosdi") :
            resizeJson = {
                "id": service_id,
                "size": "CUSTOM",
                "service_specific_payload": [
                    {
                        "name": "AdditionalNumOfCores",
                        "value": cores,
                    },
                    {
                        "name": "order.updated.components",
                        "value": euoc
                    }
                ]
            }

        data = json.dumps(resizeJson, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/services/{1}".format(host, service_id), data, "services")
        ecli.waitForCompletion(response, "resize_exaunit")

    # suspend/resume cluster
    def exaunit_operation(self, ecli, action, line, host):
        exaunit_id = ecli.exaunit_id_from(line)
        if ecli.interactive:
            cl.prt("c", "Performing exaunit {0} operation".format(action))
        data = {"exaunitID" : exaunit_id}
        data = json.dumps(data, sort_keys=True, indent=4)    
        response = self.HTTP.put("{0}/exaunit/{1}/{2}".format(host, exaunit_id, action), data, "exaunits")
        
        if "status" in response and "message" in response:
            if response["status"] == 200:
                cl.prt("g",  response["message"])
                return
        ecli.waitForCompletion(response, "exaunit {0} operation".format(action))

    # update ASM rebalance power
    def do_exaunit_asmrebalance(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False,optional_key="exaunitid")

        try:
            ecli.validate_parameters("exaunit", "asmrebalance", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = {"rebalance_power":  params['rebalancepower']}
        if "idemtoken" in params:
            data["idemtoken"]=params["idemtoken"]
        data = json.dumps(data, sort_keys=True, indent=4)

        response = self.HTTP.put("{0}/exaunit/{1}/{2}".format(host, params['exaunitid'], 'asmrebalance'), data, "exaunits")
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
        return response
        
    def do_exaunit_resizefs(self, ecli, line, host):
        exaunitId = ecli.exaunit_id_from(line.split(' ', 1)[0])
        params = ecli.parse_params(line.split(' ', 1)[1], None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
             ecli.validate_parameters('exaunit', 'resizefs', params)
        except Exception as e:
            return cl.perr(str(e))

        if not 'filesystems' in params and not 'filesystem' in params:
            return cl.perr("Either filesystems or filesystem has to be set")

        if 'filesystems' in params:
            params['filesystems'] = [{"mountpoint": mountpoint[0], "sizegb": mountpoint[1]} for mountpoint in [ element.split(':') for element in params.get('filesystems').split(',') ]]
        else:
            if (params["validate_max_size"]).lower() == "false":
                params["validate_max_size"] = bool(0)
            else:
                params["validate_max_size"] = bool(1)

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exaunits", "{0}/exaunit/{1}/resizefs".format(host, exaunitId))
        if response:
            cl.prt("n", json.dumps(response))

    def do_exaunit_list(self, ecli, line, host):
        query_str = ""
        params = ecli.parse_params(line, None)

        try:
             ecli.validate_parameters('exaunit', 'list', params)
        except Exception as e:
            return cl.perr(str(e))

        query_str = "?"
        for param in params:
            query_str = query_str + param + "=" + params[param] + "&"
        query_str = query_str[:-1]
        response = ecli.issue_get_request("{0}/exaunit/{1}/list{2}".format(host, 1, query_str), False)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    #elastic commands
    def do_exaunit_addcompute(self,ecli,line,host):
        line = line.split(' ', 1)
        exaunitId, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)
        dom0 = None
        if "hostname" in params:
            dom0 = params.pop("hostname")    
        elif "dom0" in params:
            dom0 = params.pop("dom0") 
        try:
             ecli.validate_parameters('exaunit', 'addcompute', params)
        except Exception as e:
            return cl.perr(str(e))
        #Get rack name to override payload
        rack_info = ecli.issue_get_request("{0}/racks?exaunitID={1}".format(self.HTTP.host, exaunitId), printResponse=False)
        rack_name = None
        if rack_info and len(rack_info["racks"]) == 1:
            rack_name = str(rack_info["racks"][0]["name"])
        else :
            cl.perr("Could not find rack: " + rack_name)
            return

        elasticPayload = None
        with open(params["jsonPayload"]) as json_file:
            elasticPayload = json.load(json_file)

        elasticPayload['idemtoken'] = ecli.getNewIdemtoken()
        elasticPayload['rackname'] = rack_name
        if 'hostname' in elasticPayload:
            elasticPayload['dom0'] = elasticPayload['hostname']
        #patch for dev/mock testing
        if dom0:
            match = re.search(r'clu\d{2,2}$', rack_name)
            if match is None:
                nat = dom0.replace("d0","du") + "01"
            else:
                nat = dom0.replace("d0","du") + rack_name[-2:]

            elasticPayload["customer_network"]["nodes"][0]["client"]["dom0_oracle_name"] = dom0
            elasticPayload["customer_network"]["nodes"][0]["client"]["domu_oracle_name"] = nat
            elasticPayload["customer_network"]["nodes"][0]["client"]["hostname"] = nat + "-client"
            elasticPayload["customer_network"]["nodes"][0]["backup"]["dom0_oracle_name"] = dom0
            elasticPayload["customer_network"]["nodes"][0]["backup"]["domu_oracle_name"] = nat
            elasticPayload["customer_network"]["nodes"][0]["backup"]["hostname"] = nat + "-backup"
            node = elasticPayload["customer_network"]["nodes"][0]
            if "admin" in node and node["admin"] is not None:
                elasticPayload["customer_network"]["nodes"][0]["admin"]["dom0_oracle_name"] = dom0
                elasticPayload["customer_network"]["nodes"][0]["admin"]["domu_oracle_name"] = nat
                elasticPayload["customer_network"]["nodes"][0]["admin"]["hostname"] = nat
            
        data = json.dumps(elasticPayload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exaunits","{0}/exaunit/{1}/addcompute".format(host, exaunitId))
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
        
    def do_exaunit_addcell(self,ecli,line,host):

        line = line.split(' ', 1)
        exaunitId, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        try:
             ecli.validate_parameters('exaunit', 'addcell', params)
        except Exception as e:
            return cl.perr(str(e))
        #Get rack name to override payload
        rack_info = ecli.issue_get_request("{0}/racks?exaunitID={1}".format(self.HTTP.host, exaunitId), printResponse=False)
        rack_name = None
        if rack_info and len(rack_info["racks"]) == 1:
            rack_name = str(rack_info["racks"][0]["name"])
        else :
            cl.perr("Could not find rack: " + rack_name)
            return

        elasticPayload = None
        with open(params["jsonPayload"]) as json_file:
            elasticPayload = json.load(json_file)

        if "hostname" in params and len(params["hostname"])>0:
            elasticPayload["cellnodes"][0]["hostname"] = params["hostname"]

        elasticPayload['idemtoken'] = ecli.getNewIdemtoken()
        elasticPayload['rackname'] = rack_name
        data = json.dumps(elasticPayload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exaunits","{0}/exaunit/{1}/addcell".format(host, exaunitId))

        if response:
            if not ecli.interactive and "status_uri" in response:
                cl.prt("n", response["status_uri"])
            else:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_exaunit_deletecompute(self,ecli,line,host):
        line = line.split(' ', 1)
        exaunitId, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        try:
             ecli.validate_parameters('exaunit', 'deletecompute', params)
        except Exception as e:
            return cl.perr(str(e))

        if not 'jsonPayload' in params and not 'hostnames' in params:
            return cl.perr("Either hostnames or jsonPayload params should be provided")

        elasticPayload = {}
        if 'jsonPayload' in params:
            with open(params["jsonPayload"]) as json_file:
                elasticPayload = json.load(json_file)
        elasticPayload['idemtoken'] = ecli.getNewIdemtoken()
        if 'hostnames' in params:
            elasticPayload['hostnames'] = params["hostnames"].split(",")
        if 'force' in params:
            elasticPayload['force'] = params["force"]
        data = json.dumps(elasticPayload, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/exaunit/{1}/addcompute".format(host, exaunitId),data)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_exaunit_deletecell(self,ecli,line,host):
        line = line.split(' ', 1)
        exaunitId, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)

        try:
             ecli.validate_parameters('exaunit', 'deletecell', params)
        except Exception as e:
            return cl.perr(str(e))
 
        elasticPayload = {}
        elasticPayload['idemtoken'] = ecli.getNewIdemtoken()
        elasticPayload['cellnodes'] = params["cellnodes"].split(',')
        data = json.dumps(elasticPayload, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/exaunit/{1}/deletecell".format(host, exaunitId),data)

        if response:
            if not ecli.interactive and "status_uri" in response:
                cl.prt("n", response["status_uri"])
            else:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_exaunit_reshapeprecheck(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('exaunit', 'reshapeprecheck', params)
        except Exception as e:
            cl.perr(str(e))
            return

        params = json.load(open(params["jsonPayload"]))
        
        if not "exaOcid" in params or not "exaunitId" in params or not "opType" in params:
            cl.prt("r", "Missing mandatory params in jsonPayload for running mvm reshape precheck")
            return
        
        if not "idemtoken" in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to run reshape precheck")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]
        
        cl.prt("n", "Idemtoken used is: " + params["idemtoken"])

        url = "{0}/exadata/{1}/reshapeprecheck".format(self.HTTP.host, params["exaOcid"])
        data = json.dumps(params, sort_keys=True, indent=4)

        response = self.HTTP.put(url, data, "exadata")
        if response:
            cl.prt("c", json.dumps(response))

    def do_exaunit_elasticnodeprecheck(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('exaunit', 'elasticnodeprecheck', params)
        except Exception as e:
            cl.perr(str(e))
            return

        params = json.load(open(params["jsonPayload"]))
        
        if not "exaOcid" in params or not "opType" in params:
            cl.prt("r", "Missing mandatory params in jsonPayload for running add elastic node precheck")
            return
        
        if not "idemtoken" in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to run reshape precheck")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]
        
        cl.prt("n", "Idemtoken used is: " + params["idemtoken"])

        url = "{0}/exadata/{1}/reshapeprecheck".format(self.HTTP.host, params["exaOcid"])
        data = json.dumps(params, sort_keys=True, indent=4)

        response = self.HTTP.put(url, data, "exadata")
        if response:
            cl.prt("c", json.dumps(response))

    def do_exaunit_getelasticnodeprecheck(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('exaunit', 'getelasticprecheck', params)
        except Exception as e:
            cl.perr(str(e))
            return

        idemtoken = params.pop("idemtoken")

        response = ecli.issue_get_request("{0}/kvmroce/sanitycheck/{1}".format(host, idemtoken), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_exaunit_reshape(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        data = None

        error = False;

        if 'env' not in params or params['env'] != 'gen2':
            error = True
        if 'infra' not in params or params['infra'] != 'ocimvm':
            error = True
        if "exaOcid" not in params:
            error = True

        if error:
            cl.prt("r", "Missing mandatory param or wrong value of param for reservation cleanup in ocimvm env")
            return

        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token to reshape rack : ")
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        idemtoken = retObj["idemtoken"]

        updateType = ''
        updateValue = 1
        if 'cores' in params :
           updateType = 'coresPerNode'
           updateValue = params['cores']
           exaUpdatePayload = { updateType : int(updateValue) } 
        elif 'memory' in params :
           updateType = 'memoryGbPerNode'
           updateValue = params['memory']
           exaUpdatePayload = { updateType : int(updateValue) } 
        elif 'storageTb' in params :
           updateType = 'storageTb'
           updateValue = params['storageTb']
           exaUpdatePayload = { updateType : float(updateValue) } 
        elif 'ohomeGb' in params :
           updateType = 'ohomeSizeGbPerNode'
           updateValue = params['ohomeGb']
           exaUpdatePayload = { updateType : int(updateValue) } 
        else:
           cl.prt("r", "Missing mandatory param for reshape cluster in ocimvm env.")
           return

        cl.prt("c", " do_reshape----------------" + updateType  )
        cl.prt("c", " do_reshape------------------" + updateValue )

        payload = {"idemtoken" : idemtoken, "operation" : 'updateAllocation', "exaunitUpdateAllocation" : exaUpdatePayload }
        data = json.dumps(payload, sort_keys=True, indent=4)

        url = None
        cl.prt("c", "ENV is gen2")
        cl.prt("c", "infra is ocimvm")
        url = "{0}/exadata/{1}/exaunit/{2}".format(self.HTTP.host, params["exaOcid"], params["exaunitId"])
        cl.prt("c", "PUT " + url)
        cl.prt("c",
               "Reshape exaunit [" + params["exaunitId"] + "] for OCID: " + params["exaOcid"] + " with details : " + json.dumps(
                   payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "exadata")
        cl.prt("c", json.dumps(response))


    def do_exaunit_cleanreservations(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        data = None

        error = False

        if 'env' not in params or params['env'] != 'gen2':
            error = True
        if 'infra' not in params or params['infra'] != 'ocimvm':
            error = True
        if "exaOcid" not in params:
            error = True

        if error:
            cl.prt("r", "Missing mandatory param or wrong value of param for reservation cleanup in ocimvm env")
            return

        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token to cleanup rack reservartions: ")
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        idemtoken = retObj["idemtoken"]

        requestId = ''
        if 'requestId' in params:
            requestId = params['requestId']
        else:
            cl.prt("r", "Missing mandatory param for reservation cleanup.")
            return

        payload = {"idemtoken": idemtoken, "operation": 'restoreAllocation', "requestId": requestId}

        url = None
        cl.prt("c", "ENV is gen2")
        cl.prt("c", "infra is ocimvm")
        url = "{0}/exadata/{1}/exaunit/{2}".format(self.HTTP.host, params["exaOcid"], params["exaunitId"])
        cl.prt("c", "PUT " + url)
        cl.prt("c",
               "Reservation cleanup for exaunit [" + params["exaunitId"] + "] for OCID: " + params["exaOcid"] + " with details : " + json.dumps(
                   payload, indent=4, sort_keys=True))

        response = self.HTTP.put(url, data, "exadata")
        cl.prt("c", json.dumps(response))

    def do_exaunit_monitoring(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunit")
        try:
             ecli.validate_parameters("exaunit", "monitoring", params)
        except Exception as e:
            return cl.perr(str(e))

        query_params = ""
        if "exaunit" in params:
            query_params="?exaunit={0}".format(params["exaunit"])
        
        ecli.issue_get_request("{0}/monitoring{1}".format(host, query_params))

    def do_exaunit_getcspayload(self, ecli, line, host):
        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""
        params = ecli.parse_params(rest, None)
        try:
             ecli.validate_parameters('exaunit', 'getcspayload', params)
        except Exception as e:
            return cl.perr(str(e))
        
        if not "payloadtype" in params:
            params["payloadtype"] = "ecra"

        url = "{0}/exaunit/{1}/cspayload".format(host, exaunit_id)
        response = self.HTTP.query(url, params)

        if response:
            cl.prt("w", json.dumps(response, indent=2, sort_keys=False))

    def do_exaunit_generatecspayload(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
             ecli.validate_parameters('exaunit', 'generatecspayload', params)
        except Exception as e:
            return cl.perr(str(e))

        payload=None
        if 'workflowid' in params:
            payload=params
        else:
            if 'payload' not in params or 'filename' not in params:
                return cl.perr("You should provide workflowid or payload and filename")
            params['payload'] = json.load(open(params["payload"]))
            payload=params
            payload['filename'] = params['filename']
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"exaunits", "{0}/exaunits/generatecspayload".format(host))

        if response:
            cl.prt("w", json.dumps(response, indent=2, sort_keys=False))

    def do_exaunit_updatetimezone(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
             ecli.validate_parameters('exaunit', 'updatetimezone', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunitId=params.pop('exaunitid')
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exaunit/{1}/timezone".format(host, exaunitId), data, "exaunits")
        if response:
            cl.prt("w", json.dumps(response, indent=2, sort_keys=False))

    def do_exaunit_getdginfo(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exaunit', 'getdginfo', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunitId=params.pop('exaunitid')
        response = ecli.issue_get_request("{0}/exaunit/{1}/dginfo".format(host, exaunitId), printResponse=False)
        if response:
            cl.prt("w", json.dumps(response, indent=4, sort_keys=False))

    def do_exaunit_securevms(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exaunit', 'securevms', params)
        except Exception as e:
            return cl.perr(str(e))

        url = "{0}/exaunit/{1}/securevms"
        exaunit = params["exaunitid"]
        queryParams = ""

        if "payload" in params:
            payload = json.load(open(params["payload"]))
        else:
            payload = {}

        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            if "idemtoken" not in payload:
                idemtoken = ecli.getNewIdemtoken()
                if idemtoken is None:
                    cl.perr("Could not get idemtoken")
                    return
                else:
                    payload["idemtoken"] = idemtoken

        if "opcrequestid" in params:
            queryParams += "&opcrequestid=" + params["opcrequestid"]

        if len(queryParams) > 0:
            url += "?" + queryParams[1:]

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exaunits", url.format(host, exaunit))

        if response:
            cl.prt("w", json.dumps(response, indent=2, sort_keys=False))

    def do_exaunit_getoperations(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('exaunit', 'getoperations', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunit = params["exaunitid"]
        response = self.HTTP.get("{0}/exaunit/{1}/operations".format(host, exaunit))
        if response:
            cl.prt("w", json.dumps(response, indent=4, sort_keys=False))

    def do_exaunit_updatentpdns(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('exaunit', 'updatentpdns', params)
        except Exception as e:
            return cl.perr(str(e))

        exaunit = params["exaunitid"]
        payload = {}
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exaunits", "{0}/exaunit/{1}/updatentpdns".format(host, exaunit))
        if response:
            cl.prt("w", json.dumps(response, indent=4, sort_keys=False))
    def do_migrate_vmbackup_xs (self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('exaunit', 'migrateVmBackupXs', params)
        except Exception as e:
            return cl.perr(str(e))
        exaunitId = params["exaunitId"]
        if "idemtoken" not in params:
            params["idemtoken"] = ecli.getNewIdemtoken()
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/exaunit/{1}/vmbackup/migratetoxs".format(host, exaunitId),data,"exaunits")
        if response:
            cl.prt("w", json.dumps(response, indent=4, sort_keys=False))
        
    def do_exaunit_rotatekeys(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('exaunit', 'rotatekeys', params)
        except Exception as e:
            return cl.perr(str(e))
        exaunitid = 0
        if "exaunitid" in params:
            exaunitid = params["exaunitid"]
            params["exaunitId"] = exaunitid
        elif "rackname" in params:
            params["rackName"] = params["rackname"]
        else:
            cl.perr("You should provide either exaunitid or rackname")
            return
        
        if "idemtoken" not in params:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            else:
                params["idemtoken"] = idemtoken
        
        url = "{0}/exaunit/{1}/rotatekeys"
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exaunits", url.format(host, exaunitid))
        if response:
            cl.prt("w", json.dumps(response, indent=4, sort_keys=False))

    def do_exaunit_getcomputesizes(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('exaunit', 'getcomputesizes', params)
        except Exception as e:
            return cl.perr(str(e))
        
        # Set idemtoken
        idemtoken = None
        if "idemtoken" not in params:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            else:
                params["idemtoken"] = idemtoken

        # Build query string
        exaunit_id = params["exaunitid"]
        query_str = ""

        if "ignorexml" in params:
            query_str += f"?ignorexml={params['ignorexml']}"
        
        if not "dom0s" in params:
            params["dom0s"] = ""

        # Execute retrieval
        url = "{0}/exaunit/{1}/computesizes{2}".format(host, exaunit_id, query_str)
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exaunits", url)

        if not response:
            return

        # Show response immediately then exit if wait param is false
        if "wait" in params and params["wait"] == "false":
            cl.prt("w", json.dumps(response, indent=4, sort_keys=False))
            return

        # Fetch status and wait for 200 to print in pretty format
        requri = response.get("status_uri")
        reqid = requri.split('/')[-1]

        statusurl = "{0}/statuses/{1}".format(host, reqid)
        statusresp = self.HTTP.get(statusurl)
        currstatus = statusresp.get("status")

        retries = 0

        while str(currstatus) == "202" and retries < 10:
            retries += 1
            time.sleep(30)
            statusresp = self.HTTP.get(statusurl)
            currstatus = statusresp.get("status")
        
        if str(currstatus) != "200":
            cl.perr("Got status {0}".format(str(currstatus)))
            return cl.perr(json.dumps(statusresp, indent=4, sort_keys=False))

        # Fetch compute sizes
        details = response.get("step_progress_details")
        if isinstance(details, str):
            details = json.loads(details)
        compsizes = details.get("compute_sizes", [])

        # Set output format
        headers = ["HOSTNAME", "MAX VM SIZE"]
        hostname_space = 1
        vmsize_space = 1

        for compsize in compsizes:
            host = compsize.get("hostname")
            vmsize = compsize.get("max_vm_size")
            hostname_space = max(hostname_space, len(host))
            vmsize_space = max(vmsize_space, len(vmsize))
        
        spaces = [hostname_space, vmsize_space]

        # Print response
        cl.prt("w", headers[0].ljust(spaces[0]) + ' | ' + headers[1].ljust(spaces[1]))
        for compsize in compsizes:
            host = compsize.get("hostname")
            vmsize = compsize.get("max_vm_size")
            cl.prt("w", host.ljust(spaces[0]) + ' | ' + vmsize.ljust(spaces[1]))


    def do_exaunit_collectvmcore(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exaunitid")
        try:
            ecli.validate_parameters('exaunit', 'collectvmcore', params)
        except Exception as e:
            return cl.perr(str(e))
        exaunitid = 0
        if "exaunitid" in params:
            exaunitid = params["exaunitid"]
            params["exaunitId"] = exaunitid
        else:
            cl.perr("You should provide the exaunit's ID")
            return
        
        if "idemtoken" not in params:
            idemtoken = ecli.getNewIdemtoken()
            if idemtoken is None:
                cl.perr("Could not get idemtoken")
                return
            else:
                params["idemtoken"] = idemtoken
        
        url = "{0}/exaunit/{1}/collectvmcore".format(host, exaunitid)
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "exaunits", url)

        if response:
            cl.prt("w", json.dumps(response, indent=4, sort_keys=False))

    def do_acfs_operations(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("exaunit", "acfs", params)
        except Exception as e:
            cl.perr(str(e))
            return
        operation = params.pop("operation").lower()
        if "idemtoken" not in params:
           params["idemtoken"] = ecli.getNewIdemtoken()

        data = json.dumps(params, sort_keys=True, indent=4)
        exaunitId = params.pop("exaunitId")

        if operation not in ["create", "resize", "delete","mount"]:
            cl.perr("Operation invalid. Provide a valide operation: create, resize, delete, mount")

        if "create" == operation:
           if "acfsName" not in params or "sizeGb" not in params:
               cl.perr("acfsName and sizeGb are paramters required")
               return
           response = self.HTTP.post(data,"exaunits","{0}/exaunit/{1}/acfs".format(host, exaunitId))
        elif "resize" == operation:
           acfsOcid = params.pop("acfsOcid")
           if "sizeGb" not in params:
               cl.perr("sizeGb parameter is required")
               return
           response = self.HTTP.put("{0}/exaunit/{1}/acfs/{2}".format(host, exaunitId,acfsOcid),data,"exaunits")
        elif "mount" == operation:
           acfsOcid = params.pop("acfsOcid")
           if "mount" not in params:
               cl.perr("mount parameter is required")
               return
           response = self.HTTP.put("{0}/exaunit/{1}/acfs/{2}/mount".format(host, exaunitId,acfsOcid),data,"exaunits")
        elif "delete" == operation:
           acfsOcid = params.pop("acfsOcid")
           response = self.HTTP.delete("{0}/exaunit/{1}/acfs/{2}".format(host, exaunitId,acfsOcid),data)
        if response:
            cl.prt("w", json.dumps(response, indent=2, sort_keys=False))

