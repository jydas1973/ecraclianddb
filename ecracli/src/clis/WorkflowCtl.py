#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/WorkflowCtl.py /main/3 2025/11/20 12:17:39 piyushsi Exp $
#
# WorkflowCtl.py
#
# Copyright (c) 2025, Oracle and/or its affiliates.
#
#    NAME
#      WorkflowCtl.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    piyushsi    11/18/25 - BUG 38327862 Batch Workflow Execution
#    pverma      09/02/25 - BUG 38199689 - Add wf rerun command
#    piyushsi    08/29/25 - BUG 38327862 WorkflowCtl Batch Execution with State
#                           Machine
#    piyushsi    08/07/25 - Creation
#
from formatter import cl
import json
from clis.EcliUtil import EcliUtil
import time

# Embedded lb_config.json content
LB_CONFIG = {
    "primary_ecraserver_ip": "",
    "primary_ecraserver_port": "",
    "standby_ecraserver_ip": "",
    "standby_ecraserver_port": "",
    "load_balancer_ocid": "",
    "tenancy_ocid": "",
    "region": "",
    "domain": ""
}

SWITCH_CMD = (
    "./ecradpy --action lb_operation "
    "--lb_operation_type switch "
    "--lb_config ~/ws/switchover/lb_config.json"
)

WHITELIST_OPS = ["create-service", "reshape-service", "update-service", "reshape-cores"]

class WorkflowCtl:
    def __init__(self, HTTP):
        self.HTTP = HTTP  # You can override this if needed
        self.base_url = HTTP
        self.handlers = {
        "FETCH_EXACLOUD_RESPONSE": self.check_exacloud_response,
        "FETCH_EXACLOUD_RESPONSE_FROM_DB": self.check_exacloud_response_from_db,
        "FETCH_INPUT_PAYLOAD": self.fetch_input_payload,
        "FETCH_WF_TASK_STATUS_WITHIN_STARTTIME": self.wftask_status_within_starttime,
        "FETCH_OPERATION_WITHIN_STARTTIME": self.fetch_requests_within_starttime,
        "ACTIVE_ECRA_DOWN_LB_SWITCHOVER": self.print_switchover_msg,
        "FETCH_WF_DESCRIBE": self.fetch_workflow_describe,
        "FETCH_ONGOING_OPERATION": self.do_ongoing_operation,
        "ACTION_WF_RETRY": self.perform_workflow_retry,
        "ACTION_WF_UNDO": self.perform_workflow_undo,
        "ACTION_UNDO_RETRY": self.perform_workflow_undo,
        "ACTION_RELOAD": self.perform_workflows_reload,
        "ACTION_RERUN": self.perform_workflows_rerun,
        "FETCH_CURRENT_LB_CONFIG": self.fetch_current_lb_config,
        "FETCH_AND_DEBUG_REQUEST":self.fetch_and_debug_request,
        "BATCH_WF_OPERATIONS":self.batch_wf_operations,
        "FETCH_WORKFLOWCTL_CATALOG":self.fetch_active_workflow_catelog_data
        }

        self.EXTERNAL_STATES = {
            1: {"label": "FETCH_CURRENT_LB_CONFIG", "description": "Fetch current LB configuration"},
            2: {"label": "ACTIVE_ECRA_DOWN_LB_SWITCHOVER", "description": "Switch LB to standby"}

        }
        # Categories
        self.READ_ONLY_STATES = {
            3: {"label": "FETCH_ONGOING_OPERATION", "description": "Fetch ongoing operations"},
            4: {"label": "FETCH_OPERATION_WITHIN_STARTTIME", "description": "Get all operations in time range"},
            5: {"label": "FETCH_WF_TASK_STATUS_WITHIN_STARTTIME", "description": "Get last wf task status in time range"},
            6: {"label": "FETCH_WF_DESCRIBE", "description": "Describe a workflow"},
            7: {"label": "FETCH_INPUT_PAYLOAD", "description": "ECRA Request Payload"},
            8: {"label": "FETCH_EXACLOUD_RESPONSE", "description": "Fetch Exacloud Response directly"},
            9: {"label": "FETCH_EXACLOUD_RESPONSE_FROM_DB", "description": "Fetch Exacloud Response from DB"},
           10: {"label": "FETCH_AND_DEBUG_REQUEST", "description": "Debug ECRA Request till Exacloud"},
        }

        self.MUTATING_STATES = {
            11: {"label": "ACTION_WF_RETRY", "description": "Retry workflow(s)"},
            12: {"label": "ACTION_WF_UNDO", "description": "Undo workflow(s)"},
            13: {"label": "ACTION_UNDO_RETRY", "description": "Undo then retry workflow(s)"},
            14: {"label": "ACTION_RELOAD", "description": "Reload workflow to another server"},
            15: {"label": "ACTION_RERUN", "description": "Rerun the operation from the backend"}
        }

        self.BATCH_STATES = {
            16: {"label": "BATCH_WF_OPERATIONS", "description": "Batch workflow operations like undo, retry, reload etc..."},
            17: {"label": "FETCH_WORKFLOWCTL_CATALOG", "description": "Fetch workflow catalog active workflow"}
        }


    def run_menu(self, title, states, host):
        while True:
            print(f"\n=== {title} ===")
            for num, state in states.items():
                print(f"{num}. {state['label']} - {state['description']}")
            print("0. Back")

            choice = input("\nEnter choice: ").strip()
            if choice == "0":
                return
            if not choice.isdigit() or int(choice) not in states:
                print("Invalid selection")
                continue

            state = states[int(choice)]
            self.call_api(state["label"], host)

    def run(self, host):
        while True:
            cl.prt("c", "\n" + "=" * 130)
            cl.prt("c", "WorkflowCtl Menu".center(120))
            cl.prt("c", "Execute, manage, and monitor workflows with ease".center(120))
            cl.prt("c", "=" * 128)

            cl.prt("c", "\nExternal Verification")
            cl.prt("c", "-" * 60)
            for num, state in self.EXTERNAL_STATES.items():
                cl.prt("c", f" {num:<3} {state['label']:<35} - {state['description']}")

            cl.prt("c", "\n Read-only operations")
            cl.prt("c", "-" * 60)
            for num, state in self.READ_ONLY_STATES.items():
                cl.prt("c", f" {num:<3} {state['label']:<35} - {state['description']}")

            cl.prt("c", "\n Input Driven Bulk/Single WF Actions (Mutating)")
            cl.prt("c", "-" * 60)
            for num, state in self.MUTATING_STATES.items():
                cl.prt("c", f" {num:<3} {state['label']:<35} - {state['description']}")

            cl.prt("c", "\n Batch Actions (Mutating)")
            cl.prt("c", "-" * 60)
            for num, state in self.BATCH_STATES.items():
                cl.prt("c", f" {num:<3} {state['label']:<35} - {state['description']}")
            cl.prt("c", "\n  0. Exit")
            cl.prt("c", "=" * 130)

            choice = input("\nEnter your choice: ").strip()

            if choice == "0":
               print("Exiting.")
               break
            if not choice.isdigit():
               print("Invalid selection.")
               continue

            choice_num = int(choice)
            if choice_num in self.EXTERNAL_STATES:
                self.call_api(self.EXTERNAL_STATES[choice_num]["label"], host)
            elif choice_num in self.READ_ONLY_STATES:
                self.call_api(self.READ_ONLY_STATES[choice_num]["label"], host)
            elif choice_num in self.MUTATING_STATES:
                self.call_api(self.MUTATING_STATES[choice_num]["label"], host)
            elif choice_num in self.BATCH_STATES:
                self.call_api(self.BATCH_STATES[choice_num]["label"], host)
            else:
                print("Invalid selection.")

            if choice == "0":
                print("Exiting.")
                break

    def call_api(self, label, host):
        try:
            handler = self.handlers.get(label)
            if handler:
                handler(host)
            else:
                print(f"No handler for {label}")
            input("\nPress Enter to return to menu...")
            time.sleep(1)
        except Exception as e:
            print(f"\nAPI call failed for '{label}': {e}")
            import traceback
            traceback.print_exc() 
            time.sleep(2)

    # describe workflows
    def do_workflow_describe(self, host, wfId, resultprint=True):
        urlStr = "{0}/workflows"
        if (len(wfId.strip()) == 0):
            wfId="no-wfId-passed"
        urlStr += '/' + wfId
        response = self.HTTP.get_json_with_same_key_order(urlStr.format(host))

        if response:
            if resultprint:
                cl.prt("n", json.dumps(response,indent=4))
            return response
        return 

    def do_workflow_list(self, host, wfId, resultprint=True):
        if (len(wfId.strip()) == 0):
            wfId="no-wfId-passed"
        
        params = {'workflowId': wfId}
        urlStr = "{0}/workflows" 
        urlStr += "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else "" 
        response = self.HTTP.get(urlStr.format(host))
        if response:
            if resultprint:
                cl.prt("n", json.dumps(response,indent=4))
            return response
        return 


    # describe workflows
    def fetch_workflow_describe(self, host):
        wfId = input("\nEnter your workflowId: ").strip()
        urlStr = "{0}/workflows"
        if (len(wfId.strip()) == 0):
            wfId="no-wfId-passed"
        urlStr += '/' + wfId
        response = self.HTTP.get_json_with_same_key_order(urlStr.format(host))

        if response:
            cl.prt("n", json.dumps(response,indent=4))
            return response
 
    # workflow catelog data
    def fetch_active_workflow_catelog_data(self, host):
        urlStr = "{0}/workflowctl/catalog/active"
        response = self.HTTP.get(urlStr.format(host))
        if response:
            data = response.get("workflows", {})
            if len(data) == 0:
                print("No data register in workflowctl")
            else:
                self.display_active_workflow_catelog_data(response)
            return response
   
    # print workflow catelog data
    def display_active_workflow_catelog_data(self, workflows_data):
        # Define headers
        workflows = workflows_data.get("workflows", {})
        headers = [
            "Start Time", "WF UUID", "Last Task Name",
            "Last Operation ID", "Last Task Status",
            "Action", "Result"
        ]

        # Compute column widths dynamically
        col_widths = [len(h) for h in headers]
        for wf_id, wf in workflows.items():
            values = [
                wf.get("starttime", ""),
                wf_id,
                wf.get("lasttaskname", ""),
                wf.get("lastoperationid", ""),
                wf.get("lasttaskstatus", ""),
                wf.get("action", ""),
                wf.get("result", "")
            ]
            for i, v in enumerate(values):
                col_widths[i] = max(col_widths[i], len(str(v)))

        # Function to format a row
        def format_row(row):
            return " | ".join(f"{str(val):<{col_widths[i]}}" for i, val in enumerate(row))

        # Print table header
        print(format_row(headers))
        print("-" * (sum(col_widths) + (3 * (len(headers) - 1))))
        for wf_id, wf in workflows.items():
            row = [
                wf.get("starttime", ""),
                wf_id,
                wf.get("lasttaskname", ""),
                wf.get("lastoperationid", ""),
                wf.get("lasttaskstatus", ""),
                wf.get("action", ""),
                wf.get("result", "")
            ]
            print(format_row(row))
        
        

    # workflow catelog data
    def post_active_workflow_catelog_data(self, host, params):
        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflowctl/register".format(host))

        if response:
            #cl.prt("n", json.dumps(response,indent=4))
            return response

    def prepare_paramlist_for_wfs(self, host, wfIds):
        paramslist = []
        print(f"{'wfuuid':<36} {'lasttaskname':<40} {'lasttaskoperationid':<40} {'taskStatus':<15}")
        for wf in wfIds:
            describe_output = self.do_workflow_describe(host, wf, resultprint=False)
            taskName = self.get_last_task_name(describe_output) 
            taskStatus = self.get_last_task_status_value(describe_output)
            lasttaskoperationid = self.get_last_task_operationid(describe_output)
            params = {'workflowId': wf, 'taskName': taskName}
            paramslist.append(params)
            print("-" * 140)
            print(f"{str(wf):<36} {str(taskName):<40} {str(lasttaskoperationid):<40} {str(taskStatus):<15}")
        print("-" * 140)
        return paramslist

    def print_prepared_list(self, host, wfIds, filter_wfIds, allparams):
        paramslist = []
        cl.prt("c", "########################################### All running workflows for the given time period ###########################################")
        print(f"{'wfuuid':<36} {'lasttaskname':<40} {'lasttaskoperationid':<40} {'taskStatus':<15} {'operation':<15} {'workflowName':<15}")
        for wf in wfIds:
            output = allparams.get(wf)
            taskName = output.get("lasttaskname")
            taskStatus = output.get("lasttaskstatus")
            operation = output.get("operation")
            wfname = output.get("wfname")
            lasttaskoperationid = output.get("lasttaskoperationid")
            print("-" * 170)
            print(f"{str(wf):<36} {str(taskName):<40} {str(lasttaskoperationid):<40} {str(taskStatus):<15} {str(operation):<15} {str(wfname):<15}")
        print("-" * 140)
        
        print("Current White List operations: " + str(WHITELIST_OPS))
        cl.prt("c", "########################################### Workflows running as per the current white list operation ###########################################")
        print(f"{'wfuuid':<36} {'lasttaskname':<40} {'lasttaskoperationid':<40} {'taskStatus':<15} {'operation':<15} {'workflowName':<15}")
        for wf in filter_wfIds:
            output = allparams.get(wf)
            taskName = output.get("lasttaskname")
            taskStatus = output.get("lasttaskstatus")
            lasttaskoperationid = output.get("lasttaskoperationid")
            operation = output.get("operation")
            wfname = output.get("wfname")
            print("-" * 170)
            print(f"{str(wf):<36} {str(taskName):<40} {str(lasttaskoperationid):<40} {str(taskStatus):<15} {str(operation):<15} {str(wfname):<15}")
        print("-" * 170)
        
        return paramslist
    

    def batch_wf_operations(self, host):
        cl.prt("c", "########################################### Fetching all the active workflows register in ECRA DB ###########################################")
        response = self.fetch_active_workflow_catelog_data(host)
        if "workflows" in response:
            data = response["workflows"]
            if (len(data) > 0):
                print("There are already active workflows are registered in the db for batch operations")
                action = input("Do you want to delete these workflows from DB and register the new workflows (y/n): ")
                if (action =="y"):
                    print("Deleting the batch data from db...")
                    self.delete_workflowcatalog(host)
                    response = self.fetch_active_workflow_catelog_data(host)
                    if "workflows" in response:
                        data = response["workflows"]
            if (len(data) <= 0):
                cl.prt("c", "########################################### Collecting Batch Operations Workflows ###########################################")
                wfIds, filter_wfIds, allparams, data = self.prepare_reqs_data_for_batch_operation(host)

                action = input("Do you want to lock these workflows for batch operation (y/n): ")
                if (action =="y"):
                    print("Lock the workflows")
                    register_data = {}
                    register_data["workflows"] = data
                    self.post_active_workflow_catelog_data(host, register_data)
                response = self.fetch_active_workflow_catelog_data(host)
                if "workflows" in response:
                    data = response["workflows"]
            if (len(data) > 0):
                self.perform_batch_operation_from_locked_data(host, data)

    def delete_workflowcatalog(self, host):
        urlStr = "{0}/workflowctl/deregister"
        response = self.HTTP.delete(urlStr.format(host))
        if response:
            cl.prt("n", json.dumps(response))


    def prepare_reqs_data_for_batch_operation(self, host):
        reqs = self.fetch_requests_within_starttime(host, resultprint=False)
        wfIds = []
        filter_wfIds = []
        allparams = {}
        data = []
        data_with_wfid = {}
        for req in reqs["requests"]:
            if "wf_uuid" in req:
                wfId = req["wf_uuid"]
                wfIds.append(wfId)
                if "operation" in req and req["operation"] in WHITELIST_OPS:
                    filter_wfIds.append(wfId)
                result = self.get_last_task_details(host, wfId, req)
                allparams.update(result)
                data.append(result[wfId])
                data_with_wfid[wfId] = result[wfId]

        self.print_prepared_list(host, wfIds, filter_wfIds, allparams)
        while True:
            cl.prt("c", "------------------------Add, Delete workflow from the filter list----------------------------")
            action = input("Enter 'add' to add workflow, 'del' to delete workflow, or 'done' to finish: ").strip().lower()

            if action == "done":
                break

            elif action == "del":
                del_wf = input("Enter wfuuid to delete: ").strip()
                if del_wf in filter_wfIds:
                    filter_wfIds.remove(del_wf)
                    print(f"Removed {del_wf} from filter list.")
                else:
                    print(f"{del_wf} not found in filter list.")

            elif action == "add":
                add_wf = input("Enter wfuuid to add: ").strip()
                if add_wf not in allparams:
                    print(f"{add_wf} does not exist in allparams — cannot add.")
                elif add_wf in filter_wfIds:
                    print(f"{add_wf} already exists in filter list.")
                else:
                    filter_wfIds.append(add_wf)
                    print(f"Added {add_wf} to filter list.")

            else:
                print("Invalid input. Type 'add', 'del', or 'done'.")

        d = []
        for wfId in filter_wfIds:
            d.append(data_with_wfid[wfId])

        return wfIds, filter_wfIds, allparams, d


    def perform_batch_operation_from_locked_data(self, host, data):
        print("Perform Batch operation: Data fetched from the DB")
        while True:
            final_db_update_data = []
            action = input("What you want to perform (undo/retry/reload/show/status/exit): ")
            if action == "retry":
                for wf, details in data.items():
                    if (details["result"] == True and details["action"] == "retry"):
                        print(f"Skipping the workflow retry for {wf} as it was successful already")
                        continue

                    params = {'workflowId': wf, 'taskName': details["lasttaskname"]}
                    isSuccess = self.do_workflow_retry(host, wf, params)
                    details["action"] = "retry"
                    details["result"] = isSuccess
                    details["wfuuid"] = wf
                    final_db_update_data.append(details)
            if action == "undo":
                for wf, details in data.items():
                    if (details["result"] == True and details["action"] == "undo"):
                        print(f"Skipping the workflow undo for {wf} as it was successful already")
                        continue
                    params = {'workflowId': wf, 'taskName': details["lasttaskname"]}
                    isSuccess = self.do_workflow_undo(host, wf, params)
                    details["action"] = "retry"
                    details["result"] = isSuccess
                    details["wfuuid"] = wf
                    final_db_update_data.append(details)
            if action == "reload":
                newserver = input("\nEnter EcraServer where you want to reload, (EcraServer1/EcraServer2...): ").strip()
                print("current host info: " + host)
                newserverhost = input("\nEnter " + newserver + " endpoint url like, (http://<host>:<port>/ecra/endpoint): ").strip()
                for wf, details in data.items():
                    if (details["result"] == True and details["action"] == "reload"):
                        print(f"Skipping the workflow reload for {wf} as it was successful already")
                        continue
                    describe_output = self.do_workflow_describe(host, wf, resultprint=False)
                    oldserver = self.get_server_name(describe_output)
                    params = {'wfuuid': wf, 'oldserver': oldserver}
                    self.do_workflows_reload(newserverhost, params)
                    details["action"] = "reload"
                    details["result"] = isSuccess
                    details["wfuuid"] = wf
                    final_db_update_data.append(details)
            if action == "show":
                workflows = self.fetch_active_workflow_catelog_data(host) 
            if action == "status":
                wfIds = []
                for wf, details in data.items():
                    wfIds.append(wf)
                self.prepare_paramlist_for_wfs(host, wfIds)
            if action == "exit":
                break
            if (len(final_db_update_data) > 0):
                register_data = {}
                register_data["workflows"] = final_db_update_data
                self.post_active_workflow_catelog_data(host, register_data)
            input("\nPress Enter to return to Batch mode...")
        
    
    def show_wfs(self, host, wfIds): 
        paramslist = []
        print(f"{'wfuuid':<36} {'lasttaskname':<40} {'lasttaskoperationid':<40} {'taskStatus':<15}")
        for wf in wfIds:
            describe_output = self.do_workflow_describe(host, wf, resultprint=False)
            taskName = self.get_last_task_name(describe_output) 
            taskStatus = self.get_last_task_status_value(describe_output)
            lasttaskoperationid = self.get_last_task_operationid(describe_output)
            params = {'workflowId': wf, 'taskName': taskName}
            paramslist.append(params)
            print("-" * 140)
            print(f"{str(wf):<36} {str(taskName):<40} {str(lasttaskoperationid):<40} {str(taskStatus):<15}")
        print("-" * 140)
        return paramslist
        
    def perform_workflow_undo(self, host):
        wfIds_input = input("\nEnter your workflowId(s), separated by commas: ").strip()
        wfIds = [wf.strip() for wf in wfIds_input.split(",") if wf.strip()]
        print("You entered the following workflow IDs:")
        for wf in wfIds:
            print(f"workflowId - {wf}")
        for wf in wfIds:
            describe_output = self.do_workflow_describe(host, wf, resultprint=False)
            taskName = self.get_last_task_name(describe_output) 
            params = {'workflowId': wf, 'taskName': taskName}
            self.do_workflow_undo(host, wf, params)

    # retry workflows
    def do_workflow_undo(self, host, wfId, params):
        isSuccess = False
        try:
            urlStr = "{0}/workflows/undo"
            urlStr += '/' + wfId
            response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/undo".format(host))
            
            if response:
                cl.prt("n", json.dumps(response,indent=4))
                isSuccess = True
            else:
                cl.prt("n", f"No response received for workflow ID: {wfId}")
        except Exception as e:
            cl.prt("e", f"Error retrying workflow {wfId}: {str(e)}")
        return isSuccess

    def perform_workflows_reload(self, host):
        wfIds_input = input("\nEnter your workflowId(s), separated by commas: ").strip()
        wfIds = [wf.strip() for wf in wfIds_input.split(",") if wf.strip()]
        print("You entered the following workflow IDs:")
        for wf in wfIds:
            print(f"WorkflowId - {wf}")
        newserver = input("\nEnter EcraServer where you want to reload, (EcraServer1/EcraServer2...): ").strip()
        print("current host info: " + host)
        newserverhost = input("\nEnter " + newserver + " endpoint url like, (http://<host>:<port>/ecra/endpoint): ").strip()
        for wf in wfIds:
            describe_output = self.do_workflow_describe(host, wf, resultprint=False)
            oldserver = self.get_server_name(describe_output)
            params = {'wfuuid': wf, 'oldserver': oldserver}
            self.do_workflows_reload(newserverhost, params)

    # reload workflows
    def do_workflows_reload(self, host, params):
        print(params)
        response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/reloadwf".format(host))
        if response:
            cl.prt("n", json.dumps(response))


    def perform_workflow_retry(self, host):
        wfIds_input = input("\nEnter your workflowId(s), separated by commas: ").strip()
        wfIds = [wf.strip() for wf in wfIds_input.split(",") if wf.strip()]
        print("You entered the following workflow IDs:")
        for wf in wfIds:
            print(f"WorkflowId - {wf}")
        for wf in wfIds:
            describe_output = self.do_workflow_describe(host, wf, resultprint=False)
            taskName = self.get_last_task_name(describe_output) 
            params = {'workflowId': wf, 'taskName': taskName}
            self.do_workflow_retry(host, wf, params)

    def perform_workflows_rerun(self, host):
        wfIds_input = input("\nEnter your workflowId(s), separated by commas: ").strip()
        wfIds = [wf.strip() for wf in wfIds_input.split(",") if wf.strip()]
        print("You entered the following workflow IDs:")
        for wfId in wfIds:
            print(f"WorkflowId - {wfId}")
            params = {}
            response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/{1}/rerun".format(host, wfId))
            if response:
                cl.prt("n", json.dumps(response))

    # retry workflows
    def do_workflow_retry(self, host, wfId, params):
        isSuccess = False
        try:
            urlStr = "{0}/workflows/retry"
            urlStr += '/' + wfId
            response = self.HTTP.post(json.dumps(params), "workflows", "{0}/workflows/retry".format(host))
            
            if response:
                cl.prt("n", json.dumps(response,indent=4))
                isSuccess = True
            else:
                cl.prt("n", f"No response received for workflow ID: {wfId}")
        except Exception as e:
            cl.prt("e", f"Error retrying workflow {wfId}: {str(e)}")
        return isSuccess

    
    def do_ongoing_operation(self, host):
        urlStr = "{0}/exaunits"
        response = self.HTTP.get_json_with_same_key_order(urlStr.format(host))
        rows = []
        if response:
            print(f"{'exaunit_id':<6} {'rackname':<25} {'request_id':<36} {'workflowId':<36} {'serverName':<14} {'operation':<14} {'clusterType':14}")

            # Print rows
            for unit in response["exaunits"]:
                operation = unit.get("operation", "").strip()
                if not operation:
                    continue
                print(f"{unit.get('exaunit_id', ''):<6} "
                      f"{unit.get('rackname', ''):<25} "
                      f"{unit.get('request_id', ''):<36} "
                      f"{unit.get('workflowId', ''):<36} "
                      f"{unit.get('serverName', ''):<14} "
                      f"{unit.get('operation', ''):<14}",
                      f"{unit.get('clusterType', ''):<14}")
                rows.append((
                     unit.get("exaunit_id", ""),
                     unit.get("rackname", ""),
                     unit.get("request_id", ""),
                     unit.get("workflowId", ""),
                     unit.get("serverName", ""),
                     unit.get("operation", ""),
                     unit.get("clusterType", "")
                ))

    def get_last_task_name(self, describe_output):
        for task in describe_output.get("tasks", []):
            if "lastTaskName" in task:
                return task["lastTaskName"]
        return None 
    
    def get_last_task_operationid(self, describe_output):
        for task in describe_output.get("tasks", []):
            if "lastOperationDetails" in task: 
                return task["lastOperationDetails"]["lastTaskLastOperationId"]
        return ""

    def get_last_task_status(self, describe_output):
        for task in describe_output.get("tasks", []):
            if "lastTaskName" in task:
                return task
        return None
 
    def get_last_task_status_value(self, describe_output):
        for task in describe_output.get("tasks", []):
            if "lastOperationDetails" in task: 
                return task["lastOperationDetails"]["lastTaskLastOperationStatus"]
        return ""
 
    def get_last_task_details(self, host, wf, req):
        describe_output = self.do_workflow_describe(host, wf, resultprint=False)
        wf_last_task_data = {}
        wf_last_task_data["servername"] = describe_output.get("WFServerOwner")
        wf_last_task_data["wfname"] = describe_output.get("workflowName")
        last_task_details_updated = False
        for task in describe_output.get("tasks", []):
            if "lastTaskName" in task:
                wf_last_task_data["lasttaskname"] = task["lastTaskName"]
                if "lastOperationDetails" in task: 
                    wf_last_task_data["lasttaskstatus"] = task["lastOperationDetails"]["lastTaskLastOperationStatus"]
                    wf_last_task_data["lastoperationid"] = task["lastOperationDetails"]["lastTaskLastOperationId"]
                    last_task_details_updated = True
        if last_task_details_updated == False:
            wf_last_task_data["lasttaskname"]  = ""
            wf_last_task_data["lasttaskstatus"] =  ""
            wf_last_task_data["lastoperationid"] = ""
        wf_last_task_data["wfuuid"] = wf
        wf_last_task_data["operation"] = req["operation"]
        wf_last_task_data["starttime"] = req["start_time"]
        wf_last_task_data["action"] = "NA"
        wf_last_task_data["result"] = "NA"
        wf_last_task_data["status"] = "active"
        result = {}
        result[wf] = wf_last_task_data
        
        return result
 

    def get_server_name(self, describe_output):
        return describe_output.get("WFServerOwner")

    def print_switchover_msg(self, host):
        print("\n Active ECRA is not healthy, first thing needs to be switch the LB to Standby")
        print("\n Please execute the switchover using the deployer command:\n")
        print(f"  {SWITCH_CMD}\n")

        print("Switchover Config:")
        print(json.dumps(LB_CONFIG, indent=4))
        
        print("ECRA API to fetch LB Config")
        print("📄Curl -x GET -u ****:**** http://<host:port/ecra/endpoint/atp/adminidentity")
        
        print("\n Blue-Green Switchover command")
        print("./ecradpy/ecradpy --action switchover")

    def fetch_requests_within_starttime(self, host, resultprint=True):
        print("Enter your range in this format 2025-08-08T08:47")
        start_time_gt = input("\nstart_time: ").strip()
        start_time_lt = input("end_time: ").strip()
        query = "?start_time-gt="+start_time_gt + "&start_time-lt="+start_time_lt
        fields = ["operation", "status", "exaunit_id", "resource_id", "status_uuid", "start_time", "end_time", "wf_uuid","parent_req_id"]
        urlStr = "{0}/statuses" + query
        reqs = self.HTTP.get_json_with_same_key_order(urlStr.format(host))
        if resultprint == False:
            return reqs
        for req in reqs["requests"]:
            req_str = "request id  " + req["id"]
            cl.prt("n", "-"*len(req_str))
            cl.prt("c", req_str)
            for field in fields:
                if field in req:
                    cl.prt("n", "{0:<11} {1}".format(field, req[field]))

    def wftask_status_within_starttime(self, host):
        print("Enter your range in this format 2025-08-08T08:47")
        start_time_gt = input("\nstart_time: ").strip()
        start_time_lt = input("end_time: ").strip()
        query = "?start_time-gt="+start_time_gt + "&start_time-lt="+start_time_lt
        fields = ["operation", "status", "exaunit_id", "resource_id", "status_uuid", "start_time", "end_time", "wf_uuid","parent_req_id"]
        urlStr = "{0}/statuses" + query
        reqs = self.HTTP.get_json_with_same_key_order(urlStr.format(host))
        wf_uuids = [req["wf_uuid"] for req in reqs["requests"] if "wf_uuid" in req]

        print("Extracted wf_uuid values:")
        for uuid in wf_uuids:
            print("------------------------------------")
            print("wfuuid: " + uuid)
            describe_output = self.do_workflow_describe(host, uuid, resultprint=False)
            taskstatus = self.get_last_task_status(describe_output) 
            print(json.dumps(taskstatus, indent=4))
            print("------------------------------------")

    def fetch_input_payload(self, host):
        print("Enter ecra requestId to debug:")
        analyticsId = input("\nrequestId: ").strip()
        url = "{0}/analytics/getpayload/{1}".format(host, analyticsId)
        params = {'id': analyticsId}
        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data,"analytics",uri=url)
        if response:
            try:
                # dumping json
                dataResponse = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", dataResponse)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def check_exacloud_response(self, host):
        print("Enter exacloud status uuid to debug:")
        status_uuid = input("\nstatus_uuid: ").strip()
        urlStr = "{0}/statuses/{1}"
        response = self.HTTP.get_json_with_same_key_order("{0}/statuses/{1}".format(host, status_uuid))
        if response:
            try:
                # dumping json
                dataResponse = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", dataResponse)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def check_exacloud_response_from_db(self, host):
        print("Enter workflow task operation uuid::")
        operationid = input("\noperationid: ").strip()
        urlStr = "{0}/workflowctl/exacloud/response/{1}"
        response = self.HTTP.get_json_with_same_key_order("{0}/workflowctl/exacloud/response/{1}".format(host, operationid))
        if response:
            try:
                # dumping json
                dataResponse = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", dataResponse)
            except Exception as e:
                cl.perr("Error: {0}".format(e))

    def get_status_response(self, host, requestid):
        urlStr = "{0}/statuses/{1}"
        response = self.HTTP.get_json_with_same_key_order("{0}/statuses/{1}".format(host, requestid))
        if response:
            try:
                # dumping json
                dataResponse = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", dataResponse)
            except Exception as e:
                cl.perr("Error: {0}".format(e))
        return response    
 
    def fetch_and_debug_request(self, host):
        print("Enter Ecra Request ID:")
        requestid = input("\nrequestid: ").strip()
        urlStr = "{0}/statuses/{1}"
        response = self.HTTP.get_json_with_same_key_order("{0}/statuses/{1}".format(host, requestid))
        if response:
            try:
                # dumping json
                dataResponse = json.dumps(response, sort_keys=True, indent=4)
                cl.prt("c", dataResponse)
            except Exception as e:
                cl.perr("Error: {0}".format(e))
        if "wf_uuid" in response:
            wfuuid = response["wf_uuid"]
            isworkflowdes = input("Do you want to see the workflow describe status:(y/n)")
            if (isworkflowdes == "y"):
                describe_output = self.do_workflow_describe(host, wfuuid)
                print("Last workflow task status:")
                taskstatus = self.get_last_task_status(describe_output) 
                print(json.dumps(taskstatus, indent=4))
                lasttaskname = self.get_last_task_name(describe_output)
                lasttaskoperationid = self.get_last_task_operationid(describe_output)
                listresponse = self.do_workflow_list(host, wfuuid, False) 
                exacloudid = self.get_status_uuid(listresponse, lasttaskname, lasttaskoperationid)
                last_heartbeat_update = self.get_last_heartbeat_update(listresponse, lasttaskname, lasttaskoperationid)
                print(f"{'lasttaskname':<20} {'lasttaskoperationid':<40} {'Exacloud Status id':<40} {'Status Tracker Heartbeat':<40}")
                print(f"{lasttaskname or '':<20} {lasttaskoperationid or '':<40} {exacloudid or '':<40} {(last_heartbeat_update or 'N/A'):<40}")
                
                if exacloudid:
                    print("Fetching Status from Exacloud : " + exacloudid)
                    self.get_status_response(host, exacloudid)
                else:
                    print("Exacloud id is not present, so no op")


    def get_status_uuid(self, data, task_name, operation_id):
        for task in data.get("tasks", []):
            if task.get("task_name") == task_name and task.get("operation_id") == operation_id:
                return task.get("status_uuid")
        return None

    def get_last_heartbeat_update(self, data, task_name, operation_id):
        for task in data.get("tasks", []):
            if task.get("task_name") == task_name and task.get("operation_id") == operation_id:
                return task.get("last_heartbeat_update")
        return None


    def fetch_current_lb_config(self, host):
        active_server = self.HTTP.get_json_with_same_key_order("{0}/properties/CURRENT_ACTIVE_SERVER".format(host), False)
        print("CURRENT_ACTIVE_SERVER: " + active_server.get("property_value"))
        active_backendset = self.HTTP.get_json_with_same_key_order("{0}/properties/CURRENT_ACTIVE_BACKEND".format(host), "ecra-blue")
        print("CURRENT_ACTIVE_BACKEND: " + active_backendset.get("property_value"))
        response = self.HTTP.get_json_with_same_key_order("{0}/ecra/ecralb".format(host))
        if response:
            try:
                # dumping json
                servers = response.get("servers", {})
                # Print header
                print(f"{'BackendSet':<20} {'ServerName':<15} {'IP Address':<15} {'Port':<6} {'Backup':<8} {'Drain':<8} {'LB Offline':<10} {'Weight':<8} {'Backend Name'}")

                # Print rows
                for backend_set, server_list in servers.items():
                    for s in server_list:
                        print(f"{backend_set:<20} "
                        f"{s.get('servername', ''):<15} "
                        f"{s.get('ipaddress', ''):<15} "
                        f"{s.get('port', ''):<6} "
                        f"{s.get('backup', ''):<8} "
                        f"{s.get('drain', ''):<8} "
                        f"{s.get('lboffline', ''):<10} "
                        f"{s.get('weight', ''):<8} "
                        f"{s.get('backendname', '')}")
            except Exception as e:
                cl.perr("Error: {0}".format(e))


    def print_banner(self):
        print("=" * 60)
        print("workflowctl".center(60))
        print("🔁Execute, manage, and monitor workflows with ease".center(60))
        print("=" * 60)
    def do_workflowctl(self, ecli, line, host):
        self.run(host)


