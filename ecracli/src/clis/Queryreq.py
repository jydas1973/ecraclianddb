"""
 Copyright (c) 2015, 2024, Oracle and/or its affiliates.

NAME:
    Queryrea - CLI for querying the requests

FUNCTION:
    Provides the cli to query the requests

NOTE:
    None

History:
    zpallare    11/25/24   - Enh 34972266 - EXACS: Update addregistry command
    gvalderr    11/06/24   - Enh 37197084 - Adding addRegistry command
    zpallare    03/22/24   - Enh 36390188 - EXACS: Add new endpoint to retrieve
                             request data
    ybansod     12/15/23   - Enh 36192008 - adding pagination to query req
    ybansod     12/15/23   - Bug 35378331 - block the query_requests api if null is passed
    zpallare    09/28/23   - Bug 35853530 - EXACS ECRA - Update Requests API not working
    ddelgadi    28/02/23   - Enh 34833738 - Add exa_ocid in query_requests
    aadavalo    01/27/21   - Bug 34003576 - Adding end_time in query_requests as part of 34003576
    aadavalo    01/27/21   - Bug 32008642 - PROVIDE CONSISTENT SYNTAX FOR ECRACLI COMMANDS
#   jvaldovi    05/26/19   - Addding funcionality for ReqOperations endpoint
    rgmurali    07/14/2017 - Create file
"""
from formatter import cl
from EcraHTTP import HTTP
import json

class Queryreq:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def map_params(self, params):
        # Add here any other params (columns from ecs_requests table) 
        # that need mapping so every ecli params are in lowercase,
        # no dash and no underscores. Params not present in map
        # will be passed as they are given.
        params_map = {
            "exaunitid": "exaunit_id",
            "resourceid": "resource_id",
            "starttime": "start_time",
            "endtime": "end_time",
            "statusuuid": "status_uuid",
            "wfuuid": "wf_uuid",
            "exaocid": "exa_ocid",
            "page": "page",
            "pageSize": "pagesize"
        }

        return  {params_map.get(k, k): v for k, v in params.items()}

    # query requests with options as query params
    def do_query_requests(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        params = self.map_params(params)
        if not params:
            cl.perr("Please provide atleast one parameter from: ['exaunitid','resourceid','starttime','endtime','statusuuid','wfuuid','exaocid']")
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        reqs = ecli.issue_get_request("{0}/statuses{1}".format(host, query), printResponse=False, printPaginationHeaders=True)
        if not reqs:
            return

        if not reqs["requests"]:
            cl.prt("c", "No request found for given query")
            return

        if print_raw:
            cl.prt("n", json.dumps(reqs))
        else:
            fields = ["operation", "status", "exaunit_id", "resource_id", "status_uuid", "start_time", "end_time", "wf_uuid","parent_req_id"]
            cl.prt("n", "list of found requests:")
            for req in reqs["requests"]:
                req_str = "request id  " + req["id"]
                cl.prt("n", "-"*len(req_str))
                cl.prt("c", req_str)
                for field in fields:
                    if field in req:
                        cl.prt("n", "{0:<11} {1}".format(field, req[field]))

    def do_list_async(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("requests", "list_async", params)
        except Exception as e:
            return cl.perr(str(e))
        params = self.map_params(params)

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        requests = ecli.issue_get_request("{0}/requests/async{1}".format(host, query), printResponse=False)
        if not requests:
            return

        if "requests" not in requests or  not requests["requests"]:
            cl.prt("c", "No async calls found for given query")
            return

        fields = ["type", "start_time", "end_time", "status"]
        cl.prt("n", "Async requests:")
        for req in requests["requests"]:
            req_uuid = "uuid " + req["uuid"] 
            cl.prt("n", "-" * len(req_uuid))
            cl.prt("c", req_uuid)
            for field in fields:
                if field in req:
                    cl.prt("n", "{0:<11} {1}".format(field, req[field]))

    def do_abort_async(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters("requests", "abort_async", params)
        except Exception as e:
            return cl.perr(str(e))

        uuid = params["uuid"]
        url = "{0}/requests/async/abort/{1}"

        response = self.HTTP.delete(url.format(host, uuid))
        cl.prt("n", json.dumps(response))

    def do_abort_request(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('requests', 'abort', params)
        except Exception as e:
            return cl.perr(str(e))
        params = self.map_params(params)

        cl.prt("c", "*** Note that this operation only cleans up the metadata in ECRA,"
            " if there is any operation in progress in ExaCloud it needs to be terminated manually ***")

        exaunit_id  = params['exaunit_id']
        operation   = params['operation'].strip('\'"')
        status      = params['status'] if 'status' in params else ""
        url = "{0}/exaunit/{1}/abort/{2}?status={3}"
        if 'resource_id' in params:
            resourceid = params['resource_id']
            url += '&resourceid='+resourceid

        response = self.HTTP.delete(url.format(host, exaunit_id, operation, status))
        cl.prt("n", json.dumps(response))

    # query requests with options as query params
    def do_requests_info(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('requests', 'info', params)
        except Exception as e:
            return cl.perr(str(e))
        params = self.map_params(params)
        if not params:
            cl.perr("Please provide atleast one parameter from: ['zone', 'id', 'operation', 'status', 'exaunitid', 'rackname']")
            return

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        reqs = ecli.issue_get_request("{0}/broker/requests{1}".format(host, query), printResponse=False)

        if not reqs:
            return

        if not reqs["data"]:
            cl.prt("c", str(reqs))
            cl.prt("c", "No request found for given query")
            return

        if print_raw:
            cl.prt("n", json.dumps(reqs, sort_keys=True, indent=4))

        else:
            fields = ["zone", "operation", "status", "exaunit_id", "rackname", "uri", "dc", "region", "status_uuid", "start_time"]
            cl.prt("n", "list of found requests")
            reqs = reqs["data"]
            for item in reqs:
                req1 = item["requests"]
                for req in req1:
                    req_str = "request id  " + req["id"]
                    cl.prt("n", "-"*len(req_str))
                    cl.prt("c", req_str)
                    for field in fields:
                        if field in req:
                            cl.prt("n", "{0:<11} {1}".format(field, req[field]))
                        if field in item and field != "status":
                            cl.prt("n", "{0:<11} {1}".format(field, item[field]))
                            
    # query requests with options as query params
    def do_update_request(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters('requests', 'update', params)
        except Exception as e:
            return cl.perr(str(e))
        params = self.map_params(params)

        url = "{0}/reqoperations/{1}".format(self.HTTP.host, params["request_id"])
        reqJson = self.composeCreateReqOperationsJson(params)
        if not reqJson:
            return None
        data = json.dumps(reqJson, sort_keys=True, indent=4)
        self.HTTP.issue_http_request("PUT",url,data)
            
            
    def composeCreateReqOperationsJson(self, params):
        validParametersAr = ["operation","status","errors","target_uri","details","body","resource_id","status_uuid", "description"]
        
        array= []
        for i in validParametersAr:
            if i in params:
                parameters = {}
                parameters["parameter"] = i
                parameters["value"] = params[i]
                array.append(parameters)
        reqJson = {}
        reqJson["params"] = array
        return reqJson

    # Retrieve requests data based in provided params
    def do_request_get(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('requests', 'get', params)
        except Exception as e:
            return cl.perr(str(e))
        id = params["id"].split("/")[-1]
        url = "{0}/requests/{1}".format(host, id)
        if 'fields' in params:
            url+="?fields="+params['fields']

        response = self.HTTP.get(url)
        if response:
            cl.prt("n", json.dumps(response, sort_keys=True, indent=4))

    # create a new registry record for any request that was aborted
    def do_addregistry(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('requests', 'addregistry', params)
        except Exception as e:
            return cl.perr(str(e))
        params = self.map_params(params)

        url = "{0}/requests/addregistry/{1}".format(self.HTTP.host, params["requestid"])

        data = json.dumps(params, sort_keys=True, indent=4)
        self.HTTP.issue_http_request("PUT",url,data)
