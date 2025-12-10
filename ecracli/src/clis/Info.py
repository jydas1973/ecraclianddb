"""
 Copyright (c) 2015, 2024, Oracle and/or its affiliates.

NAME:
    Info - CLI for getting the information about endpoint

FUNCTION:
    Provides the cli to list the stack information

NOTE:
    None

History:
    zpallare    12/04/24 - Enh 36754344 - EXACS Compatibility - create new apis for 
                           compatibility matrix and algorithm for locking
    zpallare    03/16/24 - Bug 36268401 - EXACS-EXACLOUD: ECRACLI hung at
                             connecting to endpoint and getting version info...
    piyushsi    01/11/24   - Enh 36164991 Servername in Info API Call 
    jzandate    11/07/23   - ENH 35538698 - Adding exadatainfra info to info response when using display=cei
    aadavalo    01/26/22   - ENH 32789578 - ECRA. PROVIDE FUNCIONALITY TO FILTER ECRACLI INFO OUTPUT
    aadavalo    01/24/22   - SUPPRESS ADDITIONAL OUTPUT FROM ECRACLI INFO
    piyushsi    08/02/21   - BUG 33181471 - CLUSTERLESS OPERATION SUPPORT IN
                             ROLLING UPGRADE AND ECRACLI
    marcoslo    08/21/2020 - ER 31753476 Hide list of clusters
    piyushsi    08/14/2020 - BUG 31749639 Workflow ID display issue
    marcoslo    08/08/2020 - ER 30613740 Update code to use python 3
    piyushsi    06/19/2019 - Bug 29860583 - CHANGES IN ECRACLI INFO COMMAND FOR OCI-EXACC
    sachikuk    09/13/2018 - Bug 28643725 - ecracli changes for brokerproxy
    sachikuk    11/22/2018 - Bug 28943104: Support mTLS authentication between
                             ecracli and ECRA
    rgmurali    05/15/2017 - Create file
"""
from formatter import cl
from util.constants import ECRACLI_MODES
from itertools import islice

import urllib.request, urllib.error, urllib.parse
from clis.ExadataInfra import ExadataInfra


class Info:
    WFSupportedEnv = ["OCIExacc", "bm", "edcs"]
    EXACLOUD_SPECIFIC_INFO = ["exacloud_version", "oeda_version", "EXACLOUDMOCK", "dbaas_version", "dbcs_agent_ol6", "dbcs_agent_ol7"]
    WORKFLOW_SPECIFIC_INFO = []

    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_info(self, ecli, line):
        cl.prt("c", ecli.version)
        params = ecli.parse_params(line, None)
        padding = len(max(ecli.api_params, key=len))
        max_db_count = int (ecli.configJson["apiParams"]["maxDbCount"])
        show_ongoing_ops = True if 'showongoingops' in params and params['showongoingops'] == 'True' else False
        rackname = params.get('rackname') # Filtering
        rackstate = params.get('rackstate') # Filtering
        for param in ecli.api_params:
            if param in ecli.ssl_params:
                continue
            value = '****' if (param.lower() == "password") else getattr(ecli, param)
            cl.prt("c", param.ljust(padding) + " : " + value)

        ecraEnv = ""
        if not "hide_clusters" in params or ("hide_clusters" in params and params["hide_clusters"] == "False"):
            
            try:
                ecli.pull_exaunits()
            except urllib.error.URLError as e:
                cl.perr(str(e))
                cl.perr("Unable to communicate with ECRA server. Please make sure ECRA is up and running.")
                return

            cl.prt("c", "created exaunits")
            
            if len(ecli.exaunits) > 0:
                fields = ["rackname", "exaname", "rackstate", "operation", "databases", "workflowId", "serverName", "operationcount"]
   
                params = []
                child_list = []
                for key, value in sorted(ecli.exaunits.items()):
                    child_list.append(str(key))
                    for field in fields:
                        if field in value:
                            child_list.append(value[field])
                        else:
                            child_list.append("")
                    params.append(child_list)
                    child_list = []
                if rackname is not None:
                    params = [exaunit for exaunit in params if rackname.upper() in exaunit[1].upper()] # Filter by rackname
                if rackstate is not None:
                    params = [exaunit for exaunit in params if rackstate.upper() == exaunit[3].upper()] # Filter by rackstate

                if "ecraEnv" in value:
                    ecraEnv = value["ecraEnv"]
                for param in params:
                    db_count = len(param[5])
                    param[5] = ",".join(["%s(%s)" % (db["dbSID"], db["status"] if "status" in db else "UNKNOWN") for db in islice(param[5], 0, max_db_count)])
                    param[5] = param[5] + "..." if db_count > max_db_count else param[5]
                if ecraEnv.lower() in map(str.lower, Info.WFSupportedEnv):
                    params = [["<id>", "<rackname>", "<exaname>", "<rackstate>", "<ongoing op>", "<dbSIDs>", "<workflowId>", "<serverName>", "<# ops>"]] + params
                else:
                    params = [["<id>", "<rackname>", "<exaname>", "<rackstate>", "<ongoing op>", "<dbSIDs>", "<# ops>"]] + params
                maxLength = [max(map(len, row)) for row in zip(*params)]
                for row in params:
                    if ecraEnv.lower() in map(str.lower, Info.WFSupportedEnv):
                        # Columns 5 and 6 swapped to fit databases SIDs
                        cl.prt("c", " {0} : {1} : {2} : {3} : {4} : {6} : {7} : {8} : {5}".format(row[0].ljust(maxLength[0]),
                                                                          row[1].ljust(maxLength[1]),
                                                                          row[2].ljust(maxLength[2]),
                                                                          row[3].ljust(maxLength[3]),
                                                                          row[4].ljust(maxLength[4]),
                                                                          row[5],
                                                                          row[6].ljust(maxLength[6]),
                                                                          row[7].ljust(maxLength[7]),
                                                                          row[8].ljust(maxLength[8])))
                    else:
                        cl.prt("c", " {0} : {1} : {2} : {3} : {4} : {6} : {5}".format(row[0].ljust(maxLength[0]),
                                                                          row[1].ljust(maxLength[1]),
                                                                          row[2].ljust(maxLength[2]),
                                                                          row[3].ljust(maxLength[3]),                                                                                                                                                                          row[4].ljust(maxLength[4]),
                                                                          row[5],
                                                                          row[6].ljust(maxLength[6])))

            if (ecli.startup_options["mode"] == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
                return

            # Ongoing Operation for Cabinet and Cluster
            if len(ecli.ongoingOP) > 0 and show_ongoing_ops:
                cl.prt("n", "Ongoing Operation for Non Provisioned Cluster/Cabinet...")
                params = []        
                child = []
                fields = ["id", "operation", "wf_uuid", "resource_id"]
                for requestItem in ecli.ongoingOP:
                    child = []
                    for field in fields:
                        if field in requestItem:
                            child.append(requestItem[field])
                        else:
                            child.append("")
                    params.append(child)
                    
 
                newparams = [["<id>", "<operation>", "<wf_uuid>", "<resource_id>"]] + params
                maxLength = [max(map(len, row)) for row in zip(*newparams)]
                for row in newparams:
                    cl.prt("b", " {0} : {1} : {2} : {3}".format(row[0].ljust(maxLength[0]),
                                                        row[1].ljust(maxLength[1]),
                                                        row[2].ljust(maxLength[2]),
                                                        row[3].ljust(maxLength[3])))

        user_input = ecli.parse_params(line, None)
        if "display" in user_input and user_input["display"] == "cei":
            cl.prt("n", "ExadataInfra info...")
            cei = ExadataInfra(self.HTTP)
            cei.do_info(ecli, line, ecli.host)

        cl.prt("n", "Connecting to endpoint and getting version info...")
        verbose = False
        ecraonly = False
        if "verbose" in user_input and user_input['verbose'].lower() == "yes":
            verbose = True
        if "ecraonly" in user_input and user_input['ecraonly'].lower() == "yes":
            ecraonly = True
        response = self.HTTP.get_version(verbose,ecraonly)
        if not response:
            cl.prt("n", "Connection failed")
            cl.prt("n", "Please check the l address in ecracli.cfg and make sure ECRA is correctly set up.")
            return

        for key, value in response.items():
            if (ecraEnv.lower() == "ociexacc") and (key in Info.EXACLOUD_SPECIFIC_INFO):
                continue
            elif key in Info.WORKFLOW_SPECIFIC_INFO:
                continue
            else:
                cl.prt("p", "{0} : {1}".format(key, value))


