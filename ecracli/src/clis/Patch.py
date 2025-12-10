"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    Patch - CLIs for patching operations
FUNCTION:
    Provides the clis to perform patch operations
NOTE:
    None

History:
    antamil     03/26/24   - Enh 37511230 - LaunchNodeType support on cli 
    araghave    09/13/24   - Enh 36923844 - INFRA PATCHING CHANGES TO SUPPORT
                             PATCHING ADMIN SWITCH
    sdevasek    05/03/24   - ENH 36578549 CONTROL EXECUTION OF DB HEALTH CHECK
                             BASED ON ENABLEDBHEALTHCHECKS FLAG IN ADDITIONAL
                             OPTIONS OF INFRAPATCHING PAYLOAD
    antamil     03/14/23   - Enh 36065371 During qfab patching, skip nodes with
                             clustertag DECOM or EXAINGEST 
    antamil     03/14/23   - Enh 35108948 cli support for qfab patch
    ddelgadi    01/18/23   - Enh 34687393 add force response for flowtester
    josedelg    12/01/22   - Enh 32109602 Verify cps version for master/standby
    diguma      11/13/22   - ER 34444560 - adding parameter
                             --skip_gi_db_validation for patchmgr
    jyotdas     06/08/22   - 34203244 - CURL endpoint to return debug and log
                             metadata on patching
    sdevasek    02/04/2022 - Enh 32509673 - Require ability to specify Cell
                             nodes to include as part of Patching process
    araghave    01/19/2021 - Enh 30646084 - Require ability to specify compute 
                             nodes to include as part of Patching process
    araghave    11/22/2021 - Enh 33338757 - REMOVE MODIFY_AT_PREREQ AND MODIFY
                             INFRA PATCHING CONF CHANGES IN CPS OS UPGRADER SCRIPT
    sdevasek    09/30/2021 - ENH 33400429 - CLEAN UP OF MODIFY AT PREREQ FROM
                             ADDITIONAL OPTIONS
    sdevasek    09/22/2021 - Bug 32799615 - EXADATA VM CLUSTER OS IMAGE UPDATE
                             MISSING FLAG ALLOW_ACTIVE_NETWORK_MOUNTS
    nmallego    03/18/2021 - ER 32581076: Add option SkipDomuCheck  
    araghave    01/12/2021 - Enh 31446326 - SUPPORT OF SWITCH OPTION AS TARGET
                             TYPE THAT TAKES CARE OF BOTH IB AND ROCESWITCH
    jyotdas     02/09/2021 - ER 32392270 - handle patch registration for exacc
    nmallego    10/27/2020 - Bug31684959 - Add exasplice, exaOcid, exaunitId 
                             and serviceType
    jyotdas     08/16/2020 - Bug 31869208 - ECRA Interface for CPS OS Patching
    jyotdas     08/08/2020 - Bug 31678541 - Addressed Clusterless patching
    marcoslo    08/08/2020 - ER 30613740 Update code to use python 3
    nmallego    21/10/2019 - Bug30208385 - Accept additional params in ecracli
    pnkrishn    08/08/2019 - Bug30125683 - force to disable
                             interactive prompt for additional options
    araghave    15/03/2019 - ENH Bug29486325 - Additional options added for 
			     custom patching operations involves removing 
			     custom RPM and Ignoring known Hardware issues.
    nmallego    13/03/2019 - ER Bug29305666 - add single node upgrade params 
    nmallego    25/01/2019 - ER Bug29052011 - add plugins params 
    nmallego    28/06/2018 - ER Bug28155938 - Pass Additional option and 
                             also integrate of ibswitch upgrade per rack basis 
    rgmurali    12/07/2017 - Bug 27195870 - Fix pylint errors
    rgmurali    07/14/2017 - Create file
"""
from formatter import cl
import json
from os import path
import re
import time
class Patch:
    patch_ops  = [ "dom0", "cell", "ibswitch", "domu", "cps", "switch", "qfab" ]

    # The additional params should be the order in which we wanted to read and validate 
    patch_additional_opt_keys  = ["RackSwitchesOnly", "AllowActiveNfsMounts", "RunPlugins",
                                  "IncludeNodeList", "IgnoreAlerts", "EnvType",
                                  "isSingleNodeUpgrade", "SingleUpgradeNodeName",
                                  "ForceRemoveCustomRpms", "ClusterLess", "LaunchNode", 
                                  "exasplice", "serviceType", "SkipDomuCheck", "SkipGiDbValidation",
                                  "EnableDBHealthChecks","ELUOptions"]
    additional_option_dict = {
               'RackSwitchesOnly' : {
                    "value"   : "no",
                    "target"  : ["ibswitch", "switch"],
                    "warn"    : "Warning: The 'RackSwitchesOnly' allows to upgrade leaf switches of cluster {0} only. Specified value is '{1}'.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "Proceed to upgrade leaf switches of cluster {0} only.",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                   },
               'ELUOptions': {
                    "value": "",
                    "target": ["domu"],
                    "warn": "Warning: Exadata Live Upgrade Options during Domu patching. Specified value is '{1}'.",
                    "prompt": "Do you want to continue? y/n",
                    "proceed": "Proceed to perform  Exadata Live update on cluster {0} only.",
                    "error": "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                },
               'AllowActiveNfsMounts' : {
                    "value"   : "yes",
                    "target"  : ["domu", "dom0"],
                    "warn"    : "Warning: The 'AllowActiveNfsMounts' allows Active Network Mounts with infra patching on cluster {0}." 
                                "Specified value is '{1}'.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "The option 'allow_active_network_mounts' is not used with infra patching on cluster {0}.",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                   },
               'RunPlugins' : {
                    "value"   : "no",
                    "target"  : ["domu", "dom0"],
                    "warn"    : "Warning: The 'RunPlugins' allows to run customs scripts on cluster {0} nodes. Specified value is '{1}'.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "Proceeding to run custom plugins scripts on cluster {0} nodes. ",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                   },
               'EnvType' : {
                    "value"   : "ecs",
                    "target"  : ["domu", "dom0"],
                    "warn"    : "Warning: Choosing non default environment type (ecs) for {0}. Specified value is '{1}'.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "Proceeding with non default (ecs) env type for {0}.",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                   },
               'IgnoreAlerts' : {
                    "value"   : "no",
                    "target"  : ["domu", "dom0", "cell"],
                    "warn"    : "Warning: The 'IgnoreAlerts' forces infra patching to ignore the hardware alerts. Run prereq-check and fix the hardware alerts or understand the implication of removing alerts on cluster {0}. Specified value is '{1}'.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "Proceed to use 'IgnoreAlerts' with infra patching on cluster {0}.",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
               },
                'ForceRemoveCustomRpms' : {
                        "value"   : "no",
                        "target"  : ["domu", "dom0"],
                        "warn"    : "Warning:  The 'ForceRemoveCustomRpms' forces infra patching to remove custom RPMs installed on cluster {0} in case there is a major upgrade. Specified value is '{1}'.",
                        "prompt"  : "Do you want to continue? y/n",
                        "proceed" : "Proceed to use 'ForceRemoveCustomRpms' with infra patching on cluster {0}.",
                        "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                },
               'isSingleNodeUpgrade' : {
                    "value"   : "no",
                    "target"  : ["domu", "dom0", "cell"],
                    "warn"    : "Warning: Enable to upgrade single node at a time for {0}. Specified value is '{1}'.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "Proceeding to upgrade single node at a time for {0}.",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                   },
               'SingleUpgradeNodeName' : {
                    "value"   : "none",
                    "target"  : ["domu", "dom0", "cell"],
                    "warn"    : "Warning: Upgrade single node at a time for cluster {0} node '{1}' chosen. Please note,"
                                "the node name that you specify should be having complete domain name and it can be"
                                "obtained from cluster xml. Also, ensure to upgrade all other nodes within the cluster.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "Proceeding to upgrade single node at a time for cluster {0}.",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                   },
               'IncludeNodeList' : {
                    "value"   : "none",
                    "target"  : ["domu", "dom0", "cell"],
                    "warn"    : "Warning: Perform patch operations on Include node list for cluster {0} node list '{1}' chosen. Please note,"
                                "the node names that you see here must contain complete FQDN and can be obtained from cluster "
                                "xml. Also, ensure to upgrade all other nodes within the cluster to the same version.",
                    "prompt"  : "Do you want to continue? y/n",
                    "proceed" : "Proceeding to perform patch operations on include node list for cluster {0}.",
                    "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                   },
               'ClusterLess' : {
                    "value"  : "no",
                    "target" : ["dom0", "cell"],
                    "warn"   : "Warning: This allows patchmgr to upgrade dom0 or cell in a clusterless cabinet {0}. Specified value is'{1}'",
                    "prompt" : "Do you want to continue? y/n",
                    "proceed": "Proceeding to perform infra patching on clusterless cabinet {0}.",
                    "error"  : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
               },
               'LaunchNode'  : {
                    "value"  : "none",
                    "target" : ["dom0", "cell", "qfab"],
                    "warn"   : "Warning: Specifies the launch node for performing infra patching.",
                    "prompt" : "Do you want to continue? y/n",
                    "proceed": "Proceeding to perform infra patching on {0}.",
                    "error"  : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
               },
               'LaunchNodeType'  : {
                    "value"  : "none",
                    "target" : ["dom0", "cell", "qfab"],
                    "warn"   : "Warning: Specifies the type of launch node for performing infra patching.",
                    "prompt" : "Do you want to continue? y/n",
                    "proceed": "Proceeding to perform infra patching on {0}.",
                    "error"  : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
               },
               'exasplice'   : {
                    "value"  : "no",
                    "target" : ["dom0", "cell"],
                    "warn"   : "Warning:  Requested monthly patching. Ensure to have target version registered in ecra db.",
                    "prompt" : "Do you want to continue? y/n",
                    "proceed": "Proceeding to perform monthly patching on cluster {0}.",
                    "error"  : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
               },
               'serviceType' : {
                    "value"  : "EXACS",
                    "target" : ["dom0", "cell", "domu", "ibswitch", "switch"],
                    "warn"   : "Warning:  Service type is specified.",
                    "prompt" : "Do you want to continue? y/n",
                    "proceed": "Proceeding to perform patching on cluster {0}.",
                    "error"  : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
               },
                'SkipDomuCheck' : {
                        "value"   : "no",
                        "target"  : ["dom0"],
                        "warn"    : "Warning:  The 'SkipDomuCheck' forces infra patching to ignore domu availability check on dom0s. Specified value is '{1}'.",
                        "prompt"  : "Do you want to continue? y/n",
                        "proceed" : "Proceed to use 'SkipDomuCheck' with infra patching on cluster {0}.",
                        "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                },
                'SkipGiDbValidation' : {
                        "value"   : "no",
                        "target"  : ["domu"],
                        "warn"    : "Warning:  The 'SkipGiDbValidation' indicates to patchmgr to skip GI/DB version validation. Specified value is '{1}'.",
                        "prompt"  : "Do you want to continue? y/n",
                        "proceed" : "Proceed to use 'SkipGiDbValidation' with infra patching on cluster {0}.",
                        "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                },
                'EnableDBHealthChecks' : {
                        "value"   : "no",
                        "target"  : ["domu"],
                        "warn"    : "Warning:  This 'EnableDBHealthChecks' makes infra patching to execute db health checks during patching. Specified value is '{1}'.",
                        "prompt"  : "Do you want to continue? y/n",
                        "proceed" : "Proceed to use 'EnableDBHealthChecks' with infra patching on cluster {0}.",
                        "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                },
                'PatchSwitchType' : {
                        "value"   : "no",
                        "target"  : ["ibswitch", "switch"],
                        "warn"    : "Warning:  This 'PatchSwitchType' patches only the admin switches when the value is set to admin.", 
                        "warn"    : "Warning:  This 'PatchSwitchType' patches only the IB or Roce switches when the value is not set",
                        "warn"    : "Warning:  This 'PatchSwitchType' patches both IB/Roce and admin switches when the value is set to all. Specified value is '{1}'.",
                        "prompt"  : "Do you want to continue? y/n",
                        "proceed" : "Proceed to use 'PatchSwitchType' with infra patching on cluster {0}.",
                        "error"   : "Infra Patching Operation stopped. Check exadata_infra_patch_extra_params.json for detail."
                }

    }

    def __init__(self, HTTP):
        self.HTTP = HTTP

    def issue_patch(self, ecli, line, host, mytmpldir):
        clusters = []
        patchcluster = True

        if not line:
            cl.perr("please specify the parameters for patching")
            for i in ecli.sub_ops_help["patch"]:
                print(i)
            return
        # Parsing parameters
        # Fetch params before getting action and clusters
        params   = [option.split("=",1) for option in line.split() if "=" in option]
        # -> valid_patch modes
        action  = line.split(' ').pop(0)
        line = line.replace(action,"")
        actions = action.split("+")
        if '' in actions: actions.remove('')
        for a in actions:
            if a not in self.patch_ops:
                cl.perr("unknown target '{0}'".format(a))
                cl.perr("valid patch targets: {0}".format(self.patch_ops))
                return
        # -> ibswitch,switch,domu are standalone actions otherwise it will fail
        if "ibswitch" in actions or "domu" in actions or "switch" in actions:
            if len(actions) != 1:
                cl.perr("ibswitch or domu or switch operation is standalone")
                cl.perr("cannot execute {0}".format(actions))
                return
        # Getting parameters

        # -> once actions are done getting the cluster
        # -> cluster validation
        clusters = [cluster for cluster in line.split() if "=" not in cluster]
        params = dict(params)

        # mapping for lowercase commands
        mapper = {"op":"Operation", "exaocid":"exaOcid", "exaunit":"exaunitId"}
        for mapkey in list(mapper.keys()):
            if mapkey in list(params.keys()) and mapper[mapkey] in list(params.keys()):
                cl.perr("Error: use only {0} or {1} not both".format(mapkey, mapper[mapkey]))
                return
            if mapkey in list(params.keys()):
                paramValue = params[mapkey]
                params[mapper[mapkey]] = paramValue
                del params[mapkey]

        if not clusters:
            cl.perr("cluster name not specified")
            ecli.sub_ops_help["patch"]
            return

        for p in list(params.keys()):
            if p == 'ClusterLess' and "yes".upper() == params[p].upper():
                patchcluster = False
                break

        # GETTING THE LIST OF RACKS ON THIS ECRA
        #No need to perform this racks check for clusterless patching of Nodes
        if patchcluster:
            response = self.HTTP.get("{0}/racks".format(host))
            if not response:
                cl.perr("Error: cannot continue, unable to query list of Cluster racks on ECRA")
                return
            # required elements in response
            for req in ["status", "racks"]:
                if req not in list(response.keys()):
                    cl.perr("Missing parameter in ECRA response {0}".format(req))
                    return

            if response["status"] != 200:
                cl.perr("Error: invalid status response getting the racks on ECRA {0}".format(response["status"]))
                return

            if len(response["racks"]) < 1:
                cl.perr("Error: ECRA has no clusters registered, please add first the Rack cluster to ecra")
                return

            # validating cluster names in ECRA
            ecraClusters = [cluster["name"] for cluster in response["racks"]]

            if "all" in clusters:
                clusters = ecraClusters
                print("Cluster racks to patch {0}".format(clusters))

        # Read additional parameters from input json
        inputJson = path.join(mytmpldir, "exadata_infra_patch_extra_params.json")
        objJson = None
        try:
            with open(inputJson) as json_file:
                objJson = json.load(json_file)
        except Exception as e: 
            cl.prt ("r", "File Load Error: {0}".format(inputJson)) 
            cl.prt ("r", "Error: " + str(e))
            return

        # Once we have all the cluster information let's
        # start building the json request
        # -> Parsing options
        patchParams = dict(ecli.config.items("clusterPatching"))
        for p in list(params.keys()):
            # Parameter should not contain either single or double quote
            if params[p].find('"') != -1 or params[p].find("'") != -1:
                cl.perr("Parameter {0} should not contain quote: {1}".format(p, params[p]))
                return 
              
            # Overwrite extra params with specified value in ecracli
            if p in list(objJson.keys()):
                cl.prt("p", "Reading additional parameter from ecracli prompt: key '{0}' value '{1}'".format(p, params[p]))
                if p == 'LaunchNodeType' and  params[p] not in ['COMPUTE', 'MANAGEMENT_HOST']:
                    cl.perr("Parameter {0} should be either COMPUTE or MANAGEMENT_HOST : {1}".format(p, params[p]))
                objJson[p] = params[p]
                continue
            if p not in list(patchParams.keys()):
                cl.perr("Warning: unknown parameter: {0}".format(p))
                cl.perr("Warning: bypassing parameter")
            patchParams[p] = params[p]

        # It's important to get confirmation from user if it's not default
        # option for patchmgr so that don't get into unhealthy state. 
        # If user given "force=yes", then don't prompt
        for option in self.patch_additional_opt_keys:
            if option in self.additional_option_dict and option in objJson:
                # check given option is applicable to specified target/action
                found = False
                for item in self.additional_option_dict[option]['target']:
                    if item in actions: 
                        found = True
                        break
                # check if we need to validate and confirm the default opts
                # and prompt if required.
                if found and objJson[option] != self.additional_option_dict[option]['value'] and params.get("force",'') == 'yes':
                    cl.prt("r", self.additional_option_dict[option]['warn'].format(clusters, objJson[option]))
                    continue
                if found and objJson[option] != self.additional_option_dict[option]['value']:
                    cl.prt("r", self.additional_option_dict[option]['warn'].format(clusters, objJson[option]))
                    cl.prt("r", self.additional_option_dict[option]['prompt'])

                    if 'ignore_user_prompt' in params and params['ignore_user_prompt']=='yes':
                        response = params['ignore_user_prompt']
                    else:
                        response = input()
                    
                    if response == 'yes' or response == 'y':
                        cl.prt("p", self.additional_option_dict[option]['proceed'].format(clusters))
                    else:
                        cl.perr(self.additional_option_dict[option]['error'])
                        return 

        extraParams = dict()
        extraParams = objJson
        if 'LaunchNodeType' in extraParams and extraParams['LaunchNodeType'] == "":
            del extraParams['LaunchNodeType']
            
        #If only LaunchNode is passed and LaunchNodeType not passed , LaunchNodeType will
        #be defaulted to COMPUTE
        if 'LaunchNodeType' not in extraParams and 'LaunchNode' in extraParams:
            extraParams['LaunchNodeType']='COMPUTE'

        patchParams["AdditionalOptions"] = [extraParams]

        # -> doing put request
        data = dict()
        patchParams["TargetType"] = actions
        patchParams["Clusters"]   = clusters
        data["Params"]            = [patchParams]
        data = json.dumps(data, sort_keys=True, indent=4)
       
        return self.HTTP.put("{0}/racks/patching".format(host), data, "racks")

    # Patching code interface
    def do_patch(self, ecli, line, host, mytmpldir):
        response = self.issue_patch(ecli, line, host, mytmpldir)
        ecli.waitForCompletion(response,"patching")
        return

    """
    This function internally identifies the compute and cell targets
    belonging to a Qfab and triggers patch for the corresponding 
    target types. 
    
    """
    def issue_qfab_patch(self, host, qfabs, patchParams, ecli):
        cabinets = []
        consolidated_status = []
        cabinet_dict = {}
        _target_type = ""
        created_exaunit = ""
        params = {}
        cl.prt("r", "Triggering patch for qfab: " + qfabs[0])
        params['fabric_name'] = qfabs[0]
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/inventory/hardware{1}".format(host, query), False)
        if response and 'servers' in response:
            _servers = response['servers']
            for _server in _servers:
                _cname = None
                _hw_type = None
                _cluster_tag = None
                if 'cabinetname' in _server:
                    _cname = _server['cabinetname']
                if 'hw_type' in _server:
                    _hw_type = _server['hw_type']
                if _hw_type != "COMPUTE" and _hw_type != "CELL":
                    continue
                if 'clustertag' in _server:
                    _cluster_tag = _server['clustertag']
                if _cluster_tag in ['DECOM', 'EXAINGEST']:
                    continue
                if _cname != None and _hw_type != None:
                    cabinet_dict[_cname] = _hw_type
        else:
            cl.prt("c", "No cabinets found for qfab" + qfabs[0])
        cl.prt("c", "Cabinets " + str(cabinet_dict))
        size = len(cabinet_dict.keys())
        count = 0
        for _cabinet_name in cabinet_dict.keys():
            count = count +1
            _type = cabinet_dict[_cabinet_name]
            created_exaunit = None
            _status_of_call = dict()
            if _type == "COMPUTE":
                _target_type = "dom0"
            else:
                _target_type = "cell"
            data = dict()
            patchParams["TargetType"] = [_target_type]
            patchParams["Clusters"] = [_cabinet_name]
            patchParams["AdditionalOptions"][0]["ClusterLess"] ="yes"
            data["Params"] = [patchParams]
            cl.prt("r", "Submitting patch request for cabinet: "+ _cabinet_name + " target type:" + _target_type)
            data = json.dumps(data, sort_keys=True, indent=4)
            response = self.HTTP.put("{0}/racks/patching".format(host), data, "racks")
            if (response == None) \
                    or ( response != None and "errorCode" in response and response["errorCode"] != 0x00000000):
                if response == None:
                    _status_of_call['Error'] = "Patch request failed for cabinet "+_cabinet_name+\
                                               " target type "+_target_type
                else:
                    _status_of_call['Error'] = response
            else:
                ecli.waitForCompletion(response, "patching")
                try:
                    created_exaunit = \
                        (self.HTTP.get(response["status_uri"], ignoreError=True))["status_uri"].split("/")[-1]
                except Exception as e:
                    cl.prt("c", "unable to fetch exaunit id from target_uri: " + str(e))
            _status_of_call['CabinetName']=_cabinet_name
            _status_of_call['TargetType'] = _target_type
            _status_of_call['StatusUuid'] = created_exaunit
            consolidated_status.append(_status_of_call)
            if count < size:
                cl.prt("c", "Sleeping for 60 seconds to trigger patch on next cabinet....")
                time.sleep(60)
        consolidated_status = json.dumps(consolidated_status, sort_keys=True, indent=4)
        cl.prt("c", "Consolidated Status:")
        cl.prt("n", str(consolidated_status))
        return


    def get_registered_launch_node(self, ecli, host, infraname):
        launch_node = None
        params = dict()
        params['infraName'] = infraname
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/infrapatch/launchNode{1}".format(host, query), False)
        if response != None and 'InfraPatchLaunchNodes' in response:
            resource = response['InfraPatchLaunchNodes'][0]
            if 'launch_nodes' in resource:
                launch_nodes = resource['launch_nodes']
                launch_node = launch_nodes.split(',')[0]
        return launch_node

    def do_qfab_patch(self, ecli, line, host, mytmpldir):
        qfabs = []
        if not line:
            Patch.patch_qfab_help()
            return
        # Parsing parameters
        # Fetch params before getting action and qfab
        params   = [option.split("=",1) for option in line.split() if "=" in option]
        # -> valid_patch modes
        # -> valid_patch modes
        action  = line.split(' ').pop(0)
        if action not in self.patch_ops:
            cl.perr("unknown target '{0}'".format(action))
            cl.perr("valid patch targets: {0}".format(self.patch_ops))
            return
        line = re.sub(rf'\b{action}\b', '', line)
        qfabs = [word for word in line.split() if "=" not in word]
        if not qfabs:
            cl.perr("qfab id not specified")
            Patch.patch_qfab_help()
            return

        params = dict(params)

        # mapping for lowercase commands
        mapper = {"op": "Operation"}
        for mapkey in list(mapper.keys()):
            if mapkey in list(params.keys()) and mapper[mapkey] in list(params.keys()):
                cl.perr("Error: use only {0} or {1} not both".format(mapkey, mapper[mapkey]))
                return
            if mapkey in list(params.keys()):
                paramValue = params[mapkey]
                params[mapper[mapkey]] = paramValue
                del params[mapkey]

        # Read additional parameters from input json
        inputJson = path.join(mytmpldir, "exadata_infra_patch_extra_params.json")
        objJson = None
        try:
            with open(inputJson) as json_file:
                objJson = json.load(json_file)
        except Exception as e:
            cl.prt("r", "File Load Error: {0}".format(inputJson))
            cl.prt("r", "Error: " + str(e))
            return

        # -> Parsing options
        patchParams = dict(ecli.config.items("clusterPatching"))
        for p in list(params.keys()):
            # Parameter should not contain either single or double quote
            if params[p].find('"') != -1 or params[p].find("'") != -1:
                cl.perr("Parameter {0} should not contain quote: {1}".format(p, params[p]))
                return
            # Overwrite extra params with specified value in ecracli
            if p in list(objJson.keys()):
                cl.prt("p", "Reading additional parameter from ecracli prompt: key '{0}' value '{1}'".
                    format(p,params[p]))
                objJson[p] = params[p]
                continue
            if p not in list(patchParams.keys()):
                cl.perr("Warning: unknown parameter: {0}".format(p))
                cl.perr("Warning: bypassing parameter")
            patchParams[p] = params[p]

        # It's important to get confirmation from user if it's not default
        # option for patchmgr so that don't get into unhealthy state.
        # If user given "force=yes", then don't prompt
        for option in self.patch_additional_opt_keys:
            if option in self.additional_option_dict and option in objJson:
                # check given option is applicable to specified target/action
                found = False
                for item in self.additional_option_dict[option]['target']:
                    if item in action:
                        found = True
                        break
                # check if we need to validate and confirm the default opts
                # and prompt if required.
                if found and objJson[option] != self.additional_option_dict[option]['value'] \
                        and params.get("force", '') == 'yes':
                    cl.prt("r", self.additional_option_dict[option]['warn'].format(qfabs, objJson[option]))
                    continue
                if found and objJson[option] != self.additional_option_dict[option]['value']:
                    cl.prt("r", self.additional_option_dict[option]['warn'].format(qfabs, objJson[option]))
                    cl.prt("r", self.additional_option_dict[option]['prompt'])

                    if 'ignore_user_prompt' in params and params['ignore_user_prompt'] == 'yes':
                        response = params['ignore_user_prompt']
                    else:
                        response = input()

                    if response == 'yes' or response == 'y':
                        cl.prt("p", self.additional_option_dict[option]['proceed'].format(qfabs))
                    else:
                        cl.perr(self.additional_option_dict[option]['error'])
                        return
        extraParams = dict()
        extraParams = objJson
        if extraParams['LaunchNode'] == 'none':
            cl.prt("p", "Checking whether any launch node is registered for "+qfabs[0])
            launch_node = self.get_registered_launch_node(ecli, host, qfabs[0])
            if launch_node != None:
                cl.prt("p", "Using the registered launch node: " + launch_node +" for patch operation")
                extraParams['LaunchNode'] = launch_node
        patchParams["AdditionalOptions"] = [extraParams]
        self.issue_qfab_patch(host, qfabs, patchParams, ecli)

    def do_cps_patch(self, ecli, line, host):
        line = line.split(' ', 1)
        target, rest = line[0], line[1] if len(line) > 1 else None

        if not rest:
            cl.perr("Please specify the parameters for patching cps")
            Patch.cps_help()
            return

        params = ecli.parse_params(rest, None)
        #cl.prt("n", "params %s " % params)

        op = None
        targetVersion = None
        exaOcid = None
        payload = dict()
        valid_operations = ["patch", "rollback", "patch_prereq_check", "post_check", "backup_image"]
        if 'op' in params:
            op = params['op']
        else:
            cl.perr("Missing parameter: op.\n")
            Patch.cps_help()
            return
     
        if op not in valid_operations:
            cl.perr("Valid operations are : patch, rollback, patch_prereq_check, post_check, backup_image. \n")
            Patch.cps_help()
            return

        if 'TargetVersion' in params:
            payload["TargetVersion"] = params['TargetVersion']
        else:
            payload["TargetVersion"] = 'LATEST'

        if 'exaocid' in params:
            exaOcid = params['exaocid']
        else:
            cl.perr("Missing parameter: exaocid.\n")
            Patch.cps_help()
            return

        cps_additional_opt_keys = ["AllowActiveNfsMounts", "IgnoreAlerts",
                                     "ForceRemoveCustomRpms", "exasplice","serviceType"]
        # Form the Additional options
        addlParams = dict()
        for key, value in params.items():
            # cl.prt("c", "{0} : {1}".format(key, value))
            foundAdditionalOptions = False
            for option in cps_additional_opt_keys:
                 if option in params and key == option:
                    addlParams[option] = value
                    foundAdditionalOptions = True
                    break

            if not foundAdditionalOptions:
                if 'exaocid' in params and key == 'exaocid':
                    payload["exaOcid"] = value
                elif 'op' in params and key == 'op':
                    payload["Operation"] = value
                else:
                    payload[key] = value

        if "idemtoken" in params:
            payload["idemtoken"] = params["idemtoken"]
        else:
            payload["idemtoken"] = self._get_new_ecra_idemtoken()

        if addlParams and len(addlParams) > 0:
            payload["AdditionalOptions"] = [addlParams]
        payload["TargetType"] = [target]
        data = dict()
        data["Params"] = [payload]
        data = json.dumps(data, sort_keys=True, indent=4)
        #cl.prt("n", "Final Request %s " % data)
        response = self.HTTP.put("{0}/racks/patching".format(host), data, "racks")
        ecli.waitForCompletion(response, "patching")
        return

    def do_get_patch_debug_info(self, ecli, line, host):
        line = line.split(' ', 1)
        _, rest = line[0], line[1] if len(line) > 1 else None

        if not rest:
            cl.perr("Please specify the parameters for patch debugging")
            Patch.patch_debug_help()
            return

        params = ecli.parse_params(rest, None)
        # cl.prt("n", "params %s " % params)

        if 'workflowId' in params:
            workflowId = params['workflowId']
            if workflowId is None:
                cl.perr("Missing parameter: op.\n")
                Patch.patch_debug_help()
                return
        elif 'ecraRequestId' in params:
            ecraRequestId = params['ecraRequestId']
            if ecraRequestId is None:
                cl.perr("Missing parameter: op.\n")
                Patch.patch_debug_help()
                return
        #days parameter comes only with rackName
        elif 'rackName' in params:
            rackName = params['rackName']
            if rackName is None:
                cl.perr("Missing parameter: op.\n")
                Patch.patch_debug_help()
                return

            if 'days' in params:
                days = params['days']

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        response = ecli.issue_get_request("{0}/racks/patching/debuginfo/{1}".format(host, query), False)
        if response:
            cl.prt("c", json.dumps(response, indent=4, sort_keys=True))

    def _get_new_ecra_idemtoken(self):
        retObj = self.HTTP.post("", "idemtokens", "{0}/idemtokens".format(self.HTTP.host))
        if retObj is None or retObj['status'] != 200:
            cl.perr("Could not get token from ECRA")
            cl.prt("n", "Response data")
            for key, value in retObj.items():
                cl.prt("p", "{0} : {1}".format(key, value))
            return
        return retObj["idemtoken"]

    @staticmethod
    def patch_debug_help():
        helptext = {
            "patchDebug": [
                "\npatch getDebugInfo workflowId=<workflowId>",
                "*) Examples of patch getDebugInfo CLI with workflowId specified:",
                "    patch getDebugInfo workflowId=b41870a6-4d02-4a0d-9523-00d95ffd0567",
                "*) Mandatory Parameters:",
                "    -> workflowId [where workflowId is the id of the workflow]\n",
                "patch getDebugInfo ecraRequestId=<Request Id in ECRA DB>",
                "*) Examples of patch getDebugInfo CLI with ECRA Request ID specified:",
                "    patch getDebugInfo ecraRequestId=fe4ca038-557d-498b-b440-eb4409d1d2f9",
                "*) Mandatory Parameters:",
                "    -> ecraRequestId [where ecraRequestId is the id of the Request in ECRA DB]\n",
                "patch getDebugInfo rackName=<rackName> days=<debug info for operations on this rack for the last n days>",
                "*) Examples of patch getDebugInfo CLI with rackName specified:",
                "    patch getDebugInfo rackName=slcs27adm0102clu7 ",
                "    patch getDebugInfo rackName=slcs27adm0102clu7 days=5",
                "*) Mandatory Parameters:",
                "    -> rackName [rackName on which you want to debug]",
                "*) Optional Parameters:",
                "    -> days [debug info for all operations on this rack for the last n days, If not specified, default value is 7]"
            ]
        }

        for substring in helptext.get('patchDebug'):
            print(substring)

    @staticmethod
    def cps_help():
        helptext = {
                "cps": [
                             "<target> [exaocid=<exaocid>] [op=<operations>] [TargetVersion=<targetVersion>] [serviceType=EXACC] with TargetVersion value specified",
                             "<target> [exaocid=<exaocid>] [op=<operations>] [serviceType=EXACC] with no TargetVersion specified",
                             "Apply Exadata patch operation on CPS.",
                             "*) exaocid should be specified in the form [exaocid=<exaocid>]:",
                             "    -> [exaocid=<exaocid>] -> in case of a cps patching",
                             "*) serviceType should be specified in the form [serviceType=<serviceType>]:",
                             "    -> [serviceType=EXACC] -> in case of a cps patching",
                             "*) TargetVersion is optional or can be specified in the form [TargetVersion=<targetVersion>]:",
                             "    -> [TargetVersion=20.1.2.0.0.200930] -> in case target version is specified",
                             "    -> [TargetVersion=LATEST] -> this will be the value of TargetVersion in case no TargetVersion is specified",
                             "*) Examples of cps patching:",
                             "    patch cps exaocid=ocid1.exadatainfrastructure.oc1.eu-frankfurt-1 op=patch serviceType=EXACC TargetVersion=20.1.2.0.0.200930",
                             "    patch cps exaocid=ocid1.exadatainfrastructure.oc1.eu-frankfurt-1 op=patch serviceType=EXACC",
                             "    patch cps exaocid=ocid1.exadatainfrastructure.oc1.eu-frankfurt-1 op=patch_prereq_check serviceType=EXACC TargetVersion=LATEST",
                             "    patch cps exaocid=ocid1.exadatainfrastructure.oc1.eu-frankfurt-1 op=patch serviceType=EXACC TargetVersion=LATEST idemtoken=b41870a6-4d02-4a0d-9523-00d95ffd0567",
                             "    patch cps exaocid=ocid1.exadatainfrastructure.oc1.eu-frankfurt-1 op=patch serviceType=EXACC TargetVersion=LATEST ForceRemoveCustomRpms=yes",
                             "    patch cps exaocid=ocid1.exadatainfrastructure.oc1.eu-frankfurt-1 op=patch serviceType=EXACC TargetVersion=LATEST AllowActiveNfsMounts=no",
                             "    patch cps exaocid=ocid1.exadatainfrastructure.oc1.eu-frankfurt-1 op=patch serviceType=EXACC TargetVersion=LATEST IgnoreAlerts=no",
                             "*) Mandatory Parameters:",
                             "    -> target [value is always cps]",
                             "    -> exaocid",
                             "    -> op",
                             "    -> serviceType [value specified should be EXACC for cps patching]",
                             "*) Optional Parameters:",
                             "    -> idemtoken=<value> will be automatically generated for envs: [exacm, bm, ociexacc] and no need to specify at prompt.Needs to be generated for env edcs and pass through this parameter",
                             "    -> TargetVersion=<value> (value will be LATEST if TargetVersion is not specified at CLI prompt)",
                             "    -> ForceRemoveCustomRpms (default value=no)",
                             "    -> AllowActiveNfsMounts (default value=no)",
                             "    -> IgnoreAlerts (default value=no)",
                             "    -> SkipGiDbValidation (default value=no)",
                             "    -> BackupMode (default value=no)",
                             "*) valid patching target:",
                             "    -> cps",
                             "*) operations available with op parameter",
                             "    -> patch                 [default]",
                             "    -> rollback              [rollback the patches ]",
                             "    -> patch_prereq_check    [precheck for patching]",
                             "    -> backup_image          [image backup on cps]"
                         ]
                }

        for substring in helptext.get('cps'):
            print(substring)


    @staticmethod
    def patch_qfab_help():
        helptext = {
            "patchQfab": [
                "\npatch qfab <qfabid> op=patch serviceTpe=<service_type> LaunchNode=<optional>",
                "This cli will patch all cabinets within a qfab and it will return a consolidated",
                "list of job status url for all patch operation triggered on all the cabinets",
                "*) Example for patching qfab:",
                "    patch qfab sea2xx2xx0061 op=patch serviceType=EXACS LaunchNode=slcs27adm04.us.oracle.com",
                "*) Mandatory Parameters:",
                "    -> qfabId [where qfabId is the id of the Qfab]",
                "    -> op [Operation type 'patch']",
                "*) Optional Parameters:",
                "    -> LaunchNode launch node for performing infra patching operation\n"
                "    -> serviceType should be specified in the form [serviceType=<serviceType>]:",

            ]
        }
        for substring in helptext.get('patchQfab'):
            print(substring)
