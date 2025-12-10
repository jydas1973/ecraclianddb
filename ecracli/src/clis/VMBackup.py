#!/usr/bin/env python
# $Header: ecs/ecra/ecracli/src/clis/VMBackup.py /main/30 2025/05/26 15:41:06 jzandate Exp $
#
# VMBackup.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
# NAME:
#    VMBackup - CLIs for VMBackup resources

# FUNCTION:
#     Provides the clis to get and set various parameters () associated with vmbackup.
#
# NOTE:
#     None
#
# History:
#     jzandate    10/30/24 - Bug 37274037 - Fix detailed=true argument for scheduler status
#     gvalderr    10/30/24 - Enh 37025137 - Changing operators to be compatible
#                            with python 3.8
#     jzandate    17/10/24 - Enh 37159566 - Adding vmbackup history
#     jzandate    10/24/24 - Enh 37159676 - Adding scheduler nextrun
#     rgmurali    09/10/24 - Enh 36995884 - Configuring vmbackup cronjob on dom0
#     jzandate    18/07/24 - Enh 36870390 - Adding restorepath cmd
#     jzandate    18/07/24 - Bug 36832349 - problem with install command" ecracli/src/clis/VMBackup.py
#     jzandate    12/06/24 - Enh 36816574 - updating vmbackup help
#     jzandate    12/06/24 - Enh 36721694 - Adding scheduler status
#     abyayada    05/13/24 - ER 36428455 -  Ecracli to enhance VMbackup listing using exaocid
#     jzandate    11/29/23 - Bug 36587400 - Adding restorelocal
#     jzandate    11/29/23 - Bug 35993487 - Adding support for underscored params in install, get_param, set_param methods.
#     jzandate    10/18/23 - Bug 35810502 - EXACS Ecracli - Review parameters
#     zpallare    09/19/23 - Bug 35810502 - EXACS Ecracli - Review parameters
#                             in Ecracli VMBackup Tool
#     zpallare    09/19/23 - Bug 35832868 - EXACS:23.4.1:R1 Srg:Vmbackup
#                             Install Failed
#     aadavalo    04/11/23 - EXACS-104356 - Adding vmbackup suconfig creation
#     aadavalo    04/11/23 - Enh 35132786 - vm backup support for dom0 sending
#     aadavalo    03/25/22 - Bug 33983891 - Added materializedlocalcopy and
#                             activeblockcommit params
#     rgmurali    11/03/20 - ER 31990731 - Clusterless support for vmbackup
#     rgmurali    10/26/20 Bug 32034821 - OSS backup params to be made optional
#     dekuckre    03/26/18  27703864: Create file.

from formatter import cl
from datetime import datetime, timedelta
import json
from os import path

class VMBackup:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def map_params(self, params, type="dict", only_remove_snakecase=False):
        # Add here any other params that need mapping so every 
        # ecli params are in lowercase, no dash and
        # no underscores. Params not present in map
        # will be passed as they are given.
        params_map = {
            "remotebackup": "REMOTE_BACKUP",
            "ossbackup": "OSS_BACKUP",
            "maxremotebackups": "MAX_REMOTE_BACKUPS",
            "deletelocalbackup": "DELETE_LOCAL_BACKUP",
            "activeblockcommit": "ACTIVE_BLOCKCOMMIT",
            "materializedlocalcopy": "MATERIALIZED_LOCAL_COPY",
            "ossbucket": "OSS_BUCKET",
            "ossgoldbucket": "OSS_GOLD_BUCKET",
            "ossnumbackups": "OSS_NUM_BACKUPS",
            "osskmsendpoint": "OSS_KMS_ENDPOINT",
            "rack_name": "rackname",
            "skip_img": "skipimg",
            "skip_checksum": "skipchecksum",
            "remote_backup":"remotebackup",
            "oss_backup": "ossbackup",
            "max_remote_backups": "maxremotebackups",
            "delete_local_backup": "deletelocalbackup",
            "active_block_commit": "activeblockcommit",
            "materialized_local_copy": "materializedlocalcopy",
            "oss_bucket": "ossbucket",
            "oss_gold_bucket": "ossgoldbucket",
            "oss_num_backups": "ossnumbackups",
            "oss_kms_endpoint": "osskmsendpoint",
            "ClusterLess": "clusterless"
        }

        def normalize_key(key):
            return key.replace("_", "").lower()

        if only_remove_snakecase and type == "dict":
            return { normalize_key(k): v for k, v in params.items() }

        if only_remove_snakecase and type == "list":
            return [ normalize_key(k) for k in params ]

        if type == "dict":
            return  { params_map.get(normalize_key(k), normalize_key(k)): v for k, v in params.items() }
        elif type == "list":
            return [ params_map.get(normalize_key(k), normalize_key(k)) for k in params ] 

    def do_enable(self, ecli, line, host):

        retObj = self.HTTP.put("{0}/vmbackup/exadata/{1}?action=enable".format(host, line), None, "vmbackup")
        cl.prt("c", str(retObj))

    def do_disable(self, ecli, line, host):

        retObj = self.HTTP.put("{0}/vmbackup/exadata/{1}?action=disable".format(host, line), None, "vmbackup")
        cl.prt("c", str(retObj))

    def do_set_param(self, ecli, line, host):
        params = ecli.parse_params(line, None, optional_key="exadataid")
        try:
            ecli.validate_parameters("vmbackup", "set_param", params)
        except Exception as e:
            cl.perr(str(e))
            return
        if len(params) != 2:
            cl.perr("Please provide exactly one param to set")
            return
        params = self.map_params(params)
        if 'OSS_BACKUP' in params:
            accepted_values = ['enabled', 'disabled']
            if params.get('OSS_BACKUP') not in accepted_values:
                cl.perr("value for OSS_BACKUP not valid, try one of the folllowing: " + ', '.join(accepted_values))
                return
        if 'OSS_NUM_BACKUPS' in params:
            if not params.get('OSS_NUM_BACKUPS').isdigit():
                cl.perr("value for OSS_NUM_BACKUPS not valid, it must be a numeric value ")
                return
        name = params.pop('rackname')
        data = json.dumps(params, sort_keys=True, indent=4)
        retObj = self.HTTP.put("{0}/vmbackup/exadata/{1}?action=setparam".format(host, name), data, "vmbackup")
        cl.prt("c", str(retObj))

    def do_get_param(self, ecli, line, host):

        list = line.split(' ')
        name = list[0]
        param = list[1]
        param = self.map_params([param], "list")[0]
        retObj = self.HTTP.get("{0}/vmbackup/exadata/{1}?action=getparam&param={2}".format(host, name, param))
        cl.prt("c", str(retObj))


    def do_setfrequency_scheduler(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False, optional_key="rackname")

        try:
            ecli.validate_parameters("vmbackup", ["scheduler", "setfrequency"], params)
        except Exception as e:
            cl.perr(str(e))
            return

        job_id = params.pop("id")
        freq_val = int(params.pop("frequencyvalue"))
        freq = params.pop("frequency")
        factor_hour = 60 * 60
        factor_day = factor_hour * 24
        factor_week = factor_day * 7
        factor_map = {"week": factor_week, "day": factor_day, "hour": factor_day}

        if freq not in factor_map:
            cl.perr("frequency not valid, expected values are: hour, day, week")
            return

        interval = factor_map.get(freq) * freq_val
        params_data = {"interval": interval}
        data = json.dumps(params_data, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/vmbackup/scheduler/{1}/update".format(host, job_id), data, "vmbackup")
        cl.prt("g",  json.dumps(response, sort_keys=False, indent=4))


    def do_setnextrun_scheduler(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False, optional_key="rackname")

        try:
            ecli.validate_parameters("vmbackup", ["scheduler", "setnextrun"], params)
        except Exception as e:
            cl.perr(str(e))
            return

        job_id = params.pop("id")

        # todo: get job interval
        interval = self.get_job_interval(host, job_id)
        if interval is None:
            cl.perr("Wrong job id, could not get interval")
            return

        date_time = params.pop("datetime")
        next_run = None
        try:
            next_run = datetime.strptime(date_time, '%Y-%m-%d %H:%M:%S')
        except Exception as e:
            cl.perr("Invalid date format, it should be: YYYY-MM-DD HH:mm:ss")
        delta = timedelta(seconds=interval)
        last_update_date = next_run - delta

        params_data = {"lastupdate": last_update_date.astimezone().strftime('%Y-%m-%dT%H:%M:%S%z')}

        data = json.dumps(params_data, sort_keys=True, indent=4)
        response = self.HTTP.put("{0}/vmbackup/scheduler/{1}/update".format(host, job_id), data, "vmbackup")
        cl.prt("g",  json.dumps(response, sort_keys=False, indent=4))


    def get_job_interval(self, host, job_id):
        retObj = self.HTTP.get("{0}/schedule?scheduledjobkey={1}".format(host, job_id))

        if "jobs" in retObj and len(retObj["jobs"]) == 1 and "interval" in retObj["jobs"][0]:
            return retObj.get("jobs")[0].get("interval")

        return None


    def do_get_schedulestatus(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False, optional_key="rackname")

        try:
            ecli.validate_parameters("vmbackup", "schedulerstatus", params)
        except Exception as e:
            cl.perr(str(e))
            return
        detailed = params["detailed"] if "detailed" in params else None
        params["exaunit_id"] = params.pop("exaunitid") if "exaunitid" in params else None
        query_str = "&".join(["{0}={1}".format(k, v) for (k, v) in params.items()])
        response = self.HTTP.get("{0}/vmbackup/scheduler/status?{1}".format(host, query_str))

        if "scheduler" not in response or "domus" not in response:
            cl.perr("Unable to get details")
            return

        scheduler_msg = response["scheduler"]
        result = {}
        if detailed is None:
            for domu in response["domus"]:
                result.setdefault(domu["status"], []).append(domu["domu"])
        else:
            result = response["domus"]
        cl.prt("w", scheduler_msg)
        if detailed == "true":
                for item in result:
                    for (key, value) in item.items():
                        cl.prt("g", "{0}: {1}".format(key, value))
        else:
            cl.prt("g",  json.dumps(result, sort_keys=True, indent=4))


    def do_get_scheduler_history(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)

        try:
            ecli.validate_parameters("vmbackup", "schedulerhistory", params)
        except Exception as e:
            cl.perr(str(e))
            return

        exaunit_id = params.pop("exaunitid")
        query_str = "&".join(["{0}={1}".format(k, v) for (k, v) in params.items()])
        response = self.HTTP.get("{0}/vmbackup/history/{1}?{2}".format(host, exaunit_id, query_str))

        cl.prt("g",  json.dumps(response, indent=4))


    def do_install(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False, optional_key="rackname")
        
        try:
            ecli.validate_parameters("vmbackup", "install", params)
        except Exception as e:
            cl.perr(str(e))
            return

        rack_name = params.pop("rackname")
        if 'ossbackup' in params and params['ossbackup'] == 'enabled':
            try:
                ecli.validate_parameters("vmbackup", "oss_backup", params)
            except Exception as e:
                cl.perr(str(e))
                return
        params = ecli.parse_params(line, ["vmBackupParams"], warning=False, optional_key="rackname")

        if 'skipchecksum' in params:
            params['skip_checksum'] = params.pop("skipchecksum")
        if 'deletelocalbackup' in params:
            params['delete_local_backup'] = params.pop("deletelocalbackup")
        if 'remotebackup' in params:
            params['remote_backup'] = params.pop("remotebackup")
        if 'ossbackup' in params:
            params['oss_backup'] = params.pop("ossbackup")
        if 'stauth' in params:
            params['st_auth'] = params.pop("stauth")
        if 'stuser' in params:
            params['st_user'] = params.pop("stuser")
        if 'stkey' in params:
            params['st_key'] = params.pop("stkey")
        if 'skipimg' in params:
            params['skip_img'] = params.pop("skipimg")
        if 'clusterless' in params:
            params['ClusterLess'] = params.pop("clusterless")
        
        params =  {k.upper(): v for k, v in list(params.items())}

        data = json.dumps(params, sort_keys=True, indent=4)
        retObj = None
        if rack_name == 'FLEET':
            retObj = self.HTTP.post(data, "vmbackup","{0}/vmbackup/fleet/install".format(host))
        else:
            retObj = self.HTTP.post(data, "vmbackup","{0}/racks/{1}/vmbackup/install".format(host, rack_name))
        cl.prt("c", json.dumps(retObj) )

    def do_patch(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False, optional_key="rackname")
        try:
            ecli.validate_parameters("vmbackup", "patch", params)
        except Exception as e:
            cl.perr(str(e))
            return
        if 'rackname' in params:
            params['rack_name'] = params.pop("rackname")

        data = {}
        data = json.dumps(data, sort_keys=True, indent=4)
        retObj = self.HTTP.post(data, "vmbackup","{0}/racks/{1}/vmbackup/patch".format(host, params['rack_name']))
        cl.prt("c", str(retObj))

    def do_list(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("vmbackup", "list", params)
        except Exception as e:
            cl.perr(str(e))
            return
        if 'rackname' in params:
            query = "?" + "&".join(["{0}={1}".format(key.upper(), value) for key, value in params.items()]) if params else ""
            rackname = params["rackname"]
            retObj = self.HTTP.get(f"{host}/racks/{rackname}/vmbackup{query}")
            details = retObj.pop('Log', 'No details info.')
            cl.prt("n", json.dumps(retObj))
            cl.prt("c", str(details))

        elif 'exaOcid' in params:
            exa_ocid = params["exaOcid"]
            response_json = self.HTTP.get(f"{host}/racks?exa_ocid={exa_ocid}", False)
            retObj = {}
            cluster_dom0_map = {}
            min_cluster_list = []
            all_dom0s = set()
            for rack in response_json.get("racks", []):
                if rack["status"] == "PROVISIONED":
                    rackname = rack["name"]
                    cluster_dom0_map[rackname] = set()
                    cluster_response = self.HTTP.get(f"{host}/cluster/details?rackname={rackname}")
                    for dom0 in cluster_response.get("dom0s", []):
                        cluster_dom0_map[rackname].add(dom0["HostName"])
                        all_dom0s.add(dom0["HostName"])
            uncovered_dom0s = all_dom0s
            while uncovered_dom0s:
                best_cluster = max(cluster_dom0_map, key=lambda k: len(uncovered_dom0s.intersection(cluster_dom0_map[k])))
                min_cluster_list.append(best_cluster)
                uncovered_dom0s -= cluster_dom0_map[best_cluster]
            unique_dom0 = set()
            details = ""
            for rackname in min_cluster_list:
                    response = self.HTTP.get(f"{host}/racks/{rackname}/vmbackup?rackname={rackname}")
                    for entry in response.get("backuplist", []):
                        if 'dom0' in entry:
                            dom0 = entry.get("dom0")
                            if dom0 not in unique_dom0:
                                unique_dom0.add(dom0)
                                if not retObj:
                                    retObj = response
                                    retObj["backuplist"] = []
                                retObj.setdefault("backuplist", []).append(entry)
                    detail = rackname + ":\n" +  response.pop('Log', 'No details info. ')
                    details = details + detail + "\n"
            cl.prt("n", json.dumps(retObj))
            cl.prt("c", str(details))
        else:
            cl.perr("Either rackname or exaOcid should be present in arguments")
            return

    def do_backup(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("vmbackup", "backup", params)
        except Exception as e:
            cl.perr(str(e))
            return

        query = ""
        if 'exaunitid' in params:
            query='exaunit_id={}'.format(params['exaunitid'])
        else:
            cl.perr("Error, expected exaunitid to be provided")
            return

        data = {}
        data = json.dumps(data, sort_keys=True, indent=4)

        retObj = self.HTTP.post(data,"vmbackup", "{0}/vmbackup/backup?{1}".format(host, query))
        cl.prt("n", json.dumps(retObj, indent=4, sort_keys=False))

    def do_status(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("vmbackup", "status", params)
        except Exception as e:
            cl.perr(str(e))
            return
        query = "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""

        retObj = self.HTTP.get("{0}/vmbackup/backup/status?{1}".format(host, query))

        cl.prt("n", json.dumps(retObj))

    def do_rollback(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False,optional_key="exaunitid")
        try:
            ecli.validate_parameters("vmbackup", "rollback", params)
        except Exception as e:
            cl.perr(str(e))
            return

        exaunit_id = params.pop("exaunitid")
        if 'vmname' in params:
            params['vm_name']=params.pop("vmname")
        if 'backupseq' in params:
            params['backup_seq']=params.pop("backupseq")
            
        data = json.dumps(params, sort_keys=True, indent=4)
        retObj = self.HTTP.post(data, "vmbackup", "{0}/vmbackup/{1}/rollback".format(host, exaunit_id))
        cl.prt("n", json.dumps(retObj, indent=4, sort_keys=False))

    def do_osslist(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False, optional_key="rackname")
        try:
            ecli.validate_parameters("vmbackup", "osslist", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if "rackname" in params and "dom0" in params:
            cl.perr("Please specify rackname or dom0 not both")
            return

        if "rackname" not in params and "dom0" not in params:
            cl.perr("Please specify rackname or dom0")
            return

        query = "?" + "&".join(
            ["{0}={1}".format(key.lower(), value) for key, value in params.items()])
        query = "{0}/vmbackup/osslist{1}".format(host, query)

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "vmbackup", query)

        if not response:
            cl.perr("Failed to call vmbackup osslist")
            return
 
        target_uri = ecli.pull_status(response["status_uri"], verbose=False)
        response = self.HTTP.get(target_uri)
        if not response:
            cl.perr("Failed to GET target_uri {0}".format(target_uri))
            return

        if not 'Log' in response:
            cl.perr("Unknown format in response, cannot proceed")
            return

        decoded_response = bytes(response.get('Log'), 'utf-8').decode('unicode_escape')
                                                                                                                                                                                              
        cl.prt("n", decoded_response)


    def do_ossrestore(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("vmbackup", "download", params)
        except Exception as e:
            cl.perr(str(e))
            return

        exaunit_id = params.pop('exaunitid')

        data = json.dumps(params, sort_keys=True, indent=4)
        retObj = self.HTTP.post(data, "vmbackup", "{0}/vmbackup/ossrestore/{1}".format(host, exaunit_id))
        cl.prt("c", str(retObj))


    def do_localrestore(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("vmbackup", "restorelocal", params)
        except Exception as e:
            cl.perr(str(e))
            return

        exaunit_id = params.pop('exaunitid')
        params["vm_name"] = params.pop("vmname") if "vmname" in params else None
        params["restart_vm"] = params.pop("restartvm") if "restartvm" in params else None

        data = json.dumps(params, sort_keys=True, indent=4)
        retObj = self.HTTP.post(data, "vmbackup", "{0}/vmbackup/restore/{1}".format(host, exaunit_id))
        cl.prt("c", str(retObj))


    def do_restorepath(self, ecli, line, host):
        response = self.HTTP.get("{0}/vmbackup/restorepath/{1}".format(host, line))
        cl.prt("c", json.dumps(response, indent=4, sort_keys=False))

    def do_suconfig(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("vmbackup", "suconfig", params)
        except Exception as e:
            cl.perr(str(e))
            return

        if not 'keyfile' in params and not 'keycontent' in params:
            cl.perr("either keyfile or keycontent needs to be set")
            return

        if 'keyfile' in params:
            params['key_file'] = params.pop("keyfile")
            params['key_field_type'] ='file'
        if 'keycontent' in params:
            params['key_content'] = params.pop("keycontent")
            params['key_field_type'] ='content'

        data = json.dumps(params, sort_keys=True, indent=4)
        retObj = self.HTTP.post(data, "vmbackup", "{0}/vmbackup/suconfig".format(host))
        cl.prt("c", json.dumps(retObj, indent=4, sort_keys=False))
    
    def do_configurecronjob_vmbackup(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("vmbackup", "configurecronjob", params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        retObj = self.HTTP.put("{0}/vmbackup/cronjob".format(host), data, "vmbackup")
        cl.prt("c", json.dumps(retObj, indent=4, sort_keys=False))
