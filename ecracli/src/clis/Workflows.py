#
# Copyright (c) 2015, 2025, Oracle and/or its affiliates.
#
# NAME:
#    WorkFlow - For WorkFlow operations
#
# FUNCTION:
#    Provide functions for WorkFlow operations
#
# NOTE:
#    None
#
#    MODIFIED   (MM/DD/YY)
#    gvalderr    01/22/25 - Enh 37464170 - Create endpoint for retreiving and
#                           updating json input of a given task
#    piyushsi    12/13/24 - ER 36933899 Workflow mark exacloud task success
#    llmartin    10/22/24 - Enh 37081820 - Add endpoint to complete task
#    pverma      03/15/24 - Bug 36077336: Add support for WF janitor restart
#    piyushsi    02/09/24 - BUG 36269151 Workflows describe empty workflowId
#                           handling and outofboundmemory error
#    piyushsi    02/13/23 - BUG 35076888 Workflows list disable
#    piyushsi    01/24/23 - BUG 3494150 Workflow Reload option for
#                           Active-Active
#    ybansod     10/21/22 - Bug-34613544 Client for wf_server status get
#    piyushsi    02/26/21 - BUG-32548442 Workflows Pause Post Client
#    piyushsi    09/28/20 - BUG-31787586 Worklow list should support workflowID
#                           option
#    piyushsi    09/23/20 - BUG-31753611 Workflows List for ExaunitId
#    piyushsi    09/14/20 - BUG-31862843 mark task fail for workflow
#    marcoslo    08/08/20 - ER 30613740 Update code to use python 3
#    aabharti    06/12/19 - 29859890 ExaccOCI workflow abort API
#    sringran    05/27/19 - ER 29716990 Workflow changes
#    sringran    04/16/19 - Create file

from formatter import cl
import json
from clis.EcliUtil import EcliUtil

class Workflows:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    # list workflows
    def do_workflow_list(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'list', params)
        except Exception as e:
            cl.perr(str(e))
            return


        if "exaunitId" in params or "workflowId" in params:
            urlStr = "{0}/workflows"
            urlStr += "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""

            response = self.HTTP.get(urlStr.format(host))
        else:
            cl.perr("[WorkflowsListError]: Please pass either exaunitId or workflowId parameter. One of these params [exaunitId, workflowId] is mandatory.")
            return

        if response and "exaunitId" in params or "workflowId" in params:
            cl.prt("n", json.dumps(response,indent=4))
            return


        pageSize = None
        noOfWorkflows = None
        pageIndex = None
        noOfPages = None
        isNextPageAvailable = None
        isPreviousPageAvailable = None

        if response.get('paginationDetails'):
            paginationDetails = response['paginationDetails']
            if(not(paginationDetails is None) and len(paginationDetails) > 0):
                pageSize = paginationDetails['pageSize']
                noOfWorkflows = paginationDetails['noOfWorkflows']
                pageIndex = paginationDetails['pageIndex']
                noOfPages = paginationDetails['noOfPages']
                isNextPageAvailable = paginationDetails['isNextPageAvailable']
                isPreviousPageAvailable = paginationDetails['isPreviousPageAvailable']
                cl.prt("c", " size={0} , page={1}, noOfPages={2}".format(noOfWorkflows, pageIndex, noOfPages))

        params=[]
        if response.get('Workflows'): 
            wflist = response['Workflows']
            if len(wflist) >0:
                for i in range(len(wflist)):
                    item=wflist[i]
                    lastTaskDetailsItem=item['lastTaskDetails']
                    lastOpDetailsItem=lastTaskDetailsItem['lastOperationDetails']
                    params = [[item['workflowId'],item['workflowName'],item['workflowStatus'],item['wfRollbackMode'], \
                               item['exaOCID'],lastTaskDetailsItem['lastTaskName'],lastTaskDetailsItem['lastTaskStatus'],lastTaskDetailsItem['lastTaskNodeType'], \
                               lastOpDetailsItem['lastTaskLastOperationId'],lastOpDetailsItem['lastTaskLastOperationName'],lastOpDetailsItem['lastTaskLastOperationStatus']]] \
                              + params


        params = [["<workflowId>","<wfName>","<wfStatus>","<wfRollbk>","<exaOCID>","<lTask>", \
                   "<LTStatus>","<LTNodeType>","<LTLOpId>","<LTLOp>","<LTLOpStatus>"]] + params

        maxLength = [max(map(len, row)) for row in zip(*params)]
        for row in params:
            cl.prt("c", " {0} : {1} : {2} : {3}: {4} : {5} : {6} : {7} : {8} : {9} : {10}".format(row[0].ljust(maxLength[0]),
                                                        row[1].ljust(maxLength[1]),
                                                        row[2].ljust(maxLength[2]),
                                                        row[3].ljust(maxLength[3]),                                                        
                                                        row[4].ljust(maxLength[4]),
                                                        row[5].ljust(maxLength[5]),
                                                        row[6].ljust(maxLength[6]),
                                                        row[7].ljust(maxLength[7]),
                                                        row[8].ljust(maxLength[8]),
                                                        row[9].ljust(maxLength[9]),
                                                        row[10]
                                                        ))

        if(not(isNextPageAvailable is None) and isNextPageAvailable == 'true'):
            if(not(pageSize is None) and pageSize != '' and not(pageIndex is None) and pageIndex != ''):
                cl.prt("c", "To go next page, use : pageSize={0}, page={1}".format(pageSize, int(pageIndex)+1))

        if(not(isPreviousPageAvailable is None) and isPreviousPageAvailable == 'true') :
            if(not(pageSize is None) and pageSize != '' and not(pageIndex is None) and pageIndex != ''):
                cl.prt("c", "To go previous page, use : pageSize={0}, page={1}".format(pageSize, int(pageIndex)-1))


    # describe workflows
    def do_workflow_describe(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'describe', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        urlStr = "{0}/workflows"

        if params :
            for key, value in params.items():
                if (len(value.strip()) == 0):
                    value="no-wfId-passed"
                urlStr += '/' + value 

        response = self.HTTP.get_json_with_same_key_order(urlStr.format(host))

        if response:
            cl.prt("n", json.dumps(response,indent=4))

    # undo workflow task
    def do_workflow_undo(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'undo', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/undo".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    # Cancel workflow task
    def do_workflow_cancel_task(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'cancel_task', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/canceltask".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    # Fail workflow task
    def do_workflows_fail_task(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'fail_task', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/failtask".format(host))
        if response:
            cl.prt("n", json.dumps(response))



    # retry workflow task
    def do_workflow_retry(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'retry', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/retry".format(host))
        if response:
            cl.prt("n", json.dumps(response))


    # abort workflow 
    def do_workflow_abort(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'abort', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/abort".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    # abort workflow 
    def do_workflow_task_complete(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'complete_task', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "task_output_path" in params:
            data = EcliUtil.load_json(params["task_output_path"])
            if data == False:
                return
            params["taskOutput"] = data

        if "force" not in params:
            params["force"] = False

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/complete".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    # enable rollbackmodeon for workflow
    def do_workflow_rollback_mode_on(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'rollback_mode_on', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        workflowId = params['workflowId']
 
        response = self.HTTP.put("{0}/workflows/{1}/rollbackmodeon".format(host,workflowId),"","workflows")
        if response:
             cl.prt("n", json.dumps(response))

    # enable rollbackmodeoff for workflow
    def do_workflow_rollback_mode_off(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'rollback_mode_off', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        workflowId = params['workflowId']
 
        response = self.HTTP.put("{0}/workflows/{1}/rollbackmodeoff".format(host,workflowId),"","workflows")
        if response:
             cl.prt("n", json.dumps(response))



    # rollback workflow task
    def do_workflow_rollback(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'rollback', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/rollback".format(host))
        if response:
            cl.prt("n", json.dumps(response))


    # pause workflows task and new workflows
    def do_workflows_pause(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'pause', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/pause".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    # reload workflows
    def do_workflows_reload(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'reload', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/reloadwf".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    # exacloud success workflow task
    def do_workflow_exacloud_task_success(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'exacloud_success', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/exacloudsuccess".format(host))
        if response:
            cl.prt("n", json.dumps(response))



   # describe operation
    def do_workflow_operation(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:    
            ecli.validate_parameters('workflows', 'operation', params) 
        except Exception as e:
            cl.perr(str(e))
            return  

        urlStr = "{0}/workflows/operation"

        if params :
            for key, value in params.items():
                urlStr += '/' + value 

        response = self.HTTP.get(urlStr.format(host))
 
        if response:
            cl.prt("n", json.dumps(response))


    # get wf_server status
    def do_workflow_server_status(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'server_status', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.get("{0}/workflows/server/status".format(host))

        if response:
            cl.prt("n", json.dumps(response))

    # Restart the WF janitor job
    def do_wf_janitor_restart(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'janitor_restart', params)
        except Exception as e:
            cl.perr(str(e))
            return

        urlStr = "{0}/workflows/operation"

        if params :
            for key, value in params.items():
                urlStr += '/' + value

        response = self.HTTP.put("{0}/workflows/janitor/restart".format(host),"","workflows")
        if response:
             cl.prt("n", json.dumps(response))


    def do_workflow_getinput(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'getinput', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/fetchtaskinput".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_workflow_updateinput(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters('workflows', 'updateinput', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/updatetaskinput".format(host))
        if response:
            cl.prt("n", json.dumps(response))