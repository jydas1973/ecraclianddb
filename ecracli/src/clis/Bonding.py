#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Bonding.py /main/25 2025/08/28 00:46:38 caborbon Exp $
#
# Analytics.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Bonding - CLIs related to bonding 
#
#    DESCRIPTION
#      Provides the clis related to bonding
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    caborbon    08/21/25 - ENH 38320140 - allowing call getPayload and Delete
#                           bondng using just hostname
#    zpallare    12/09/24 - Enh 37144837 - EXACS ECRA - Create an api to do
#                           re-bonding of existing node and update
#                           admin_monitor.json
#    jreyesm     11/28/24 - E.R 37322127. Add hostname support for bonding cli
#    jzandate    07/01/24 - Bug 36199369 - Bring back normal serial mode
#    zpallare    05/28/24 - Bug 36536656 - ECRA - Assign custom vip wf is
#                           failing but custom vip already assigned in backend
#    jzandate    04/10/24 - Bug 36419742 - Adding filter for single dom0
#                           hostname
#    jzandate    01/22/24 - Bug 36207124 - Adding all nodes in the rpmupdateall
#    rmavilla    05/12/23 - exacs-96388 ECRA: Bonding Precheck API should
#                           support async URI functionality for all scenarios.
#    jzandate    05/10/23 - Enh 35242897 - Adding Batching mode with multi
#                           threads
#    gvalderr    03/14/23 - Modifying the failover command.
#    jzandate    02/03/23 - Bug 34863490 - Adding new operation for bonding
#                           status
#    illamas     01/19/23 - Enh 34983763 - Endpoint restart monitor
#    jzandate    09/08/22 - Bug 34649384 - Add support for single dom0 romupdate
#    rgmurali    09/08/22 - ER 34544811 - Support linkfailover for bonding
#    rgmurali    08/24/21 - ER 32256415 - Bonding custom vip support
#    rgmurali    08/03/21 - ER 33027372 - Bond monitor rpm update support
#    rgmurali    05/17/21 - ER 32810345 - Support bonding migration
#    rgmurali    05/16/21 - ER 32893441 - precheck for bonding
#    rgmurali    01/25/21 - ER 32421802 - Store the monitor bonding payload in ECRA
#    rgmurali    09/12/20 - ER 31878447 - Add the PUT endpoint for Bonding
#    rgmurali    07/22/20 - ER 31543012 - Bonding setup APIs
#    rgmurali    10/16/2018 - Create file
#
from formatter import cl
import json
import time


class Bonding:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_getInfo_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'getInfo', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = ""
        if "rackname" in params:
          rackname = params.pop("rackname")
        if "hostname" in params:
          rackname = params.pop("hostname")

        response = ecli.issue_get_request("{0}/bonding/rack/{1}".format(host, rackname),False)


        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

        if not response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_setupMonitoringBond_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        hostname = None
        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'setupMonitoringBond', params)
        except Exception as e:
            cl.perr(str(e))
            return
        paramsCount = 0
        if "hostname" in params:
            paramsCount += 1
            hostname = params["hostname"]
            servers=ecli.issue_get_request("{0}/inventory/hardware?hostname={1}".format(host,hostname), False, printPaginationHeaders=True)
        if "json_path" in params:
            paramsCount += 1
            params = json.load(open(params["json_path"]))

        if paramsCount ==1 and hostname != None:
            params["rebonding"] = "true"
            params["rackname"]=servers["servers"][0].get("cabinetname")
        elif hostname != None:
            for node in params["nodes"]:
                node["hostname"] = hostname
            params["rackname"]=servers["servers"][0].get("cabinetname")

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "bonding", "{0}/bonding/rack/setup".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_deleteMonitoringBond_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        hostname = None
        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'deleteMonitoringBond', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "hostname" in params:
            hostname = params["hostname"]
        if "json_path" in params:
            params = json.load(open(params["json_path"]))
        if hostname != None:
            servers=ecli.issue_get_request("{0}/inventory/hardware?hostname={1}".format(host,hostname), False, printPaginationHeaders=True)
            for node in params["nodes"]:
                node["hostname"] = hostname
            params["rackname"]=servers["servers"][0].get("cabinetname")

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/bonding/rack/setup".format(host), data, "bonding")

        if response:
            cl.prt("n", json.dumps(response))

    def do_getpayload_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        rackname = ""

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'getpayload', params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        if "rackname" in params:
          rackname = params.pop("rackname")
        if "hostname" in params:
          rackname = params.pop("hostname")
        if "cabinetname" in params:
          rackname = params.pop("cabinetname")
        
        response = ecli.issue_get_request("{0}/bonding/payload/{1}".format(host, rackname), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_retrysetup_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'retrysetup', params)
        except Exception as e:
            cl.perr(str(e))
            return
        rackname = params.pop("rackname")

        response = self.HTTP.post("", "bonding", "{0}/bonding/rack/retry/{1}".format(host, rackname))
        if response:
            cl.prt("n", json.dumps(response))

    def do_migrationPrecheck_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'migrationPrecheck', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "idemtoken" not in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to run precheck for bonding")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]

        cl.prt("n", "Idemtoken used is: " + params["idemtoken"])

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "bonding", "{0}/bonding/rack/migrationPrecheck".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_smartnicaction_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'smartnicaction', params)
        except Exception as e:
            cl.perr(str(e))
            return

        actionjson = json.load(open(params["actionjson"]))
        data = json.dumps(actionjson, sort_keys=False, indent=4)
        response = self.HTTP.post(data, "bonding",
                                  "{0}/bonding/{1}/ports/smartNICAction".format(host, params["nodeid"]))
        if response:
            cl.prt("n", json.dumps(response))

    def do_migratevlan_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'migratevlan', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        if "idemtoken" not in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to run precheck for bonding")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]

        cl.prt("n", "Idemtoken used is: " + params["idemtoken"])

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "bonding", "{0}/bonding/rack/vlanmigrate".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_networkupdate_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'networkupdate', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        if "idemtoken" not in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to run precheck for bonding")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]

        cl.prt("n", "Idemtoken used is: " + params["idemtoken"])

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "bonding", "{0}/bonding/rack/networkinfoupdate".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_monitorswitch_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'monitorswitch', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            params = json.load(open(params["json_path"]))

        if "idemtoken" not in params:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to run precheck for bonding")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            params["idemtoken"] = retObj["idemtoken"]

        cl.prt("n", "Idemtoken used is: " + params["idemtoken"])

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "bonding", "{0}/bonding/rack/monitorswitch".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_getelasticcabinets_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'getelasticcabinets', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = ecli.issue_get_request("{0}/bonding/computecabinets".format(host), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

    def do_rpmupdate_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'rpmupdate', params)
        except Exception as e:
            cl.perr(str(e))
            return

        rackname = params["rackname"] if "rackname" in params else None
        if rackname is not None and rackname != "":
            response = self.HTTP.put("{0}/bonding/rpmupdate/{1}".format(host, rackname), None, "bonding")
            if response:
                cl.prt("n", json.dumps(response))
                return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/bonding/rpmupdate".format(host), data, "bonding")
        if response:
            cl.prt("n", json.dumps(response))

    def do_rpmupdateall_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'rpmupdateall', params)
        except Exception as e:
            cl.perr(str(e))
            return

        mode = params["mode"] if "mode" in params else "normal"
        selectnodes = params["selectnodes"] if "selectnodes" in params else None
        if mode and mode == "batch" and selectnodes:
            cl.prt("n", "Using batching mode")
            data = json.dumps(params)
            response = self.HTTP.put("{0}/bonding/rpmupdate".format(host), data, "bonding")
            if response:
                cl.prt("n", json.dumps(response, indent=4, sort_keys=True))

        elif mode and mode == "normal":
            cl.prt("n", "Using normal mode")
            failedracks = []
            query = "?" + "&".join(["{0}={1}".format('dom0_bonding', 'Y')])
            response = ecli.issue_get_request("{0}/racks{1}".format(host, query), False)
            if response:
                for rackcluster in response["racks"]:
                    rackname = rackcluster["name"]
                    cl.prt("c", "Updating rpm for cluster: " + rackname)
                    outputresp = self.HTTP.put("{0}/bonding/rpmupdate/{1}".format(host, rackname), None, "bonding")
                    if outputresp:
                        cl.prt("n", json.dumps(outputresp))
                        statusid = outputresp["status_uri"].split('/')[-1]
                        cl.prt("c", "Status UUID: " + statusid)
                        statusrsp = 202
                        while (statusrsp != 200):
                            statusongoing = ecli.issue_get_request("{0}/statuses/{1}".format(host, statusid), False)
                            statusrsp = statusongoing["status"]
                            if (statusrsp == 500):
                                cl.prt("r", "Rpm update failed on Rack: " + rackname)
                                failedracks.append(rackname)
                                statusrsp = 200
                            time.sleep(30)

            computeResponse = ecli.issue_get_request("{0}/bonding/computecabinets".format(host), False)
            if computeResponse:
                cl.prt("n", json.dumps(computeResponse))
                for cabinet in computeResponse["cabinetnames"]:
                    cl.prt("n", "Updating the rpm for cabinet: " + cabinet)
                    cabinetresp = self.HTTP.put("{0}/bonding/rpmupdate/{1}".format(host, cabinet), None, "bonding")
                    if cabinetresp:
                        cl.prt("n", json.dumps(cabinetresp))
                        cabinetstatusid = cabinetresp["status_uri"].split('/')[-1]
                        cl.prt("c", "Status UUID: " + cabinetstatusid)
                        cabinetstatusrsp = 202
                        while (cabinetstatusrsp != 200):
                            cabinetstatusongoing = ecli.issue_get_request("{0}/statuses/{1}".format(host, cabinetstatusid), False)
                            cabinetstatusrsp = cabinetstatusongoing["status"]
                            if (cabinetstatusrsp == 500):
                                cl.prt("r", "Rpm update failed on cabinet" + cabinet)
                                failedracks.append(cabinet)
                                cabinetstatusrsp = 200
                            time.sleep(30)

            if (len(failedracks) > 0):
                cl.prt("r", "Rpm update failed on " + ", ".join(failedracks))
        return

    def do_addcustomvip_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'customvipadd', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            payload = json.load(open(params["json_path"]))
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        if "rackname" in params:
            payload["rackname"] = params["rackname"]
        if "idemtoken" not in payload:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to reserve CEI for elastic shapes")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            payload["idemtoken"] = retObj["idemtoken"]

        cl.prt("n", "Idemtoken used is: " + payload["idemtoken"])

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "bonding", "{0}/customvip".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_deletecustomvip_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'customvipdelete', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "json_path" in params:
            payload = json.load(open(params["json_path"]))
        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        if "rackname" in params:
            payload["rackname"] = params["rackname"]

        if "idemtoken" not in payload:
            retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(host))
            if retObj is None or retObj['status'] != 200:
                cl.perr("Could not get idemtoken to reserve CEI for elastic shapes")
                cl.prt("n", "Response data")
                for key, value in retObj.items():
                    cl.prt("p", "{0} : {1}".format(key, value))
                return
            payload["idemtoken"] = retObj["idemtoken"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/customvip".format(host), data, "bonding")

        if response:
            cl.prt("n", json.dumps(response))

    def do_linkfailover_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'linkfailover', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "bonding", "{0}/bonding/linkfailover".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_consistencycheck_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'consistencycheck', params)
        except Exception as e:
            cl.perr(str(e))
            return

        query_str = "&".join(["{0}={1}".format(k, v) for (k, v) in params.items()])
        response = self.HTTP.post("", "bonding", "{0}/bonding/consistencycheck/{1}?{2}".format(host, params["rackname"], query_str))
        if response:
            cl.prt("n", json.dumps(response))

    def do_restartmonitor_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'restartmonitor', params)
        except Exception as e:
            cl.perr(str(e))
            return

        component = params["component"]

        response = self.HTTP.put("{0}/bonding/restart/{1}".format(host, component), None, "bonding")
        if response:
            cl.prt("n", json.dumps(response))

    def do_statusmonitor_bonding(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('bonding', 'status', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "component" in params:
            wait_time_secs = 5
            data = json.dumps(params, sort_keys=True, indent=4)
            response = self.HTTP.post(data, "bonding", "{0}/bonding/status".format(host))
            if response:
                id = response["status_uri"] if "status_uri" in response else "No Id."
                id = id.split("/").pop()
                cl.prt("n", "Id: {0}".format(id))
                ecli.waitForCompletion(response, "bonding", True)
                self.get_result_by_id(host, id)

        elif "id" in params:
            id = params["id"]
            self.get_result_by_id(host, id)

    def get_result_by_id(self, host, id):
        response = self.HTTP.get("{0}/bonding/status/{1}".format(host, id))
        if response:
            cl.prt("n", json.dumps(response, indent=4))
# EOF
