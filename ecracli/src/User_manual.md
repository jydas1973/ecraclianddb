# ECRACLI User Manual

## Description

*This document has the purpose of providing users with essential information regarding ECRACLI's available commands, its main usages, arguments and examples (if needed). Any developer is welcome to add and/or modify commands in order to help in making a more visual guide for the team.*

# ErrorCode

## get 

### Description
*Returns all the information for the given code.*

### Usages
`errorcode get code=<CODE>`

#### Values
`  <CODE> : Error code`

### Examples:
```json
ecra> errorcode get code=0x0201000F
* {
    "errorCode": "0x0201000F",
    "errorName": "ERROR_USAGE_SIZE_MORE",
    "description": "Failed to resize as available space is smaller than current utilisation",
    "errorAction": "RETRY_WITH_SAME_TOKEN",
    "resolution": "Run exadatainfrastructure restorecluster command and once it finishes successfully, perform workflows abort for the failed workflow.",
    "status": 200,
    "op": "error_codes_get",
    "status-detail": "success"
}
```

## category

### Description
*Returns the category description for the given code.*

### Usages
`errorcode category code=<CODE>`

#### Values
` <CODE> : Error code `

### Examples:
```json
ecra> errorcode category code=0x0201000F
* {
    "name": "Exacloud - HealthCheck",
    "code": "0x0201",
    "status": 200,
    "op": "error_codes_category_get",
    "status-detail": "success"
}
```

## endpoint

### Description
*Returns all the errors that a particular endpoint could have, in case you want to list all, use _all_ as value.*

### Usages
`errorcode endpoint name=<NAME>`

#### Values
` <NAME> : Name of the endpoint (To get all endpoints use _all_)`

### Examples:
```json
ecra> errorcode endpoint name=getTenancySlaAverage
* {
    "result": [
        {
            "getTenancySlaAverage": "[0x01001,0x02003]"
        }
    ],
    "status": 200,
    "op": "error_codes_endpoint_get",
    "status-detail": "success"
}
```

# Exacompute 

## ports

### Description
*Get the smartnic information associated to the given oracle hostname or hw_id or smartnic_id*

### Usages
`exacompute ports [hostname=<HOSTNAME>|hwid=<HW_ID>|smartnicid=<SMARTNIC_ID>]`

#### Values
` <HOSTNAME>  : The oracle hostname`
` <HW_ID>     : The ID value related to the oracle hostname`
` <SMARTNIC_ID> : The value should be the smartnic id you are looking for`

### Examples:
```json
ecra> exacompute ports hostname=sea201109exdd002
* {
    "ports": [
        {
            "caviumId": "4.0G1943-GBC002299",
            "caviumIp": "10.9.150.13",
            "dom0OracleName": "sea201109exdd002",
            "domUOracleName": "sea201109exddu0201",
            "etherface": "eth1",
            "etherfaceType": "client",
            "mac": "00:10:5e:33:03:b2"
        },
        {
            "caviumId": "4.0G1943-GBC002299",
            "caviumIp": "10.9.150.14",
            "dom0OracleName": "sea201109exdd002",
            "domUOracleName": "sea201109exddu0201",
            "etherface": "eth1",
            "etherfaceType": "backup",
            "mac": "02:00:17:01:ba:18"
        },
        {
            "caviumId": "4.0G1943-GBC002262",
            "caviumIp": "10.9.150.15",
            "dom0OracleName": "sea201109exdd002",
            "domUOracleName": "sea201109exddu0201",
            "etherface": "eth2",
            "etherfaceType": "client",
            "mac": "00:10:5d:93:d0:a1"
        },
        {
            "caviumId": "4.0G1943-GBC002262",
            "caviumIp": "10.9.150.16",
            "dom0OracleName": "sea201109exdd002",
            "domUOracleName": "sea201109exddu0201",
            "etherface": "eth2",
            "etherfaceType": "backup",
            "mac": "02:00:17:01:86:65"
        }
    ],
    "status": 200,
    "op": "exacompute_oracle_hostname_ports_get",
    "status-detail": "success"
}
```        

## activecard

### Description
*The API will return the active cavium for the provided oracle hostname*

### Usages
`exacompute activecard oraclehostname=<ORACLEHOSTNAME>`

#### Values
` <ORACLEHOSTNAME>  : Oracle hostname`

### Examples:
```json
ecra> exacompute activecard oraclehostname=iad103709exdd013
* {
    "caviumId": "4.0G1950-GBC001922",
    "etherface": "eth1"
}
```

## getfleetstateid

### Description
*The API will return he latest fleet state handle and lock handle*

### Usages
`exacompute getfleetstateid`

### Examples:
```json
ecra> exacompute getfleetstateid
      * {
        "fleetStateHandle": 100080,
        "fleetLockHandle": 80,
        "status": 200,
        "op": "chaine_fleetstateid_latest_get",
        "status-detail": "success"
      }
```
## info

#Description
Displays a list of current settings and connect to endpoint to pull the ecra version information. If parameter  hide_clusters=True is used then the list of cluster is hidden. If parameter showongoingops is used, ongoing operations in cluster/cabinets non provisioned is shown. Parameters rackname and rackstate can be used to filter output from command.


### Usages
ecra> info
                        or
             info display=cei
             or
             info showongoingops=True
             or
             info showongoingops=True
             or
             info rackname=iad
             or
             info rackstate="PROVISIONERR"
             or
             info verbose=yes
             or
             info ecraonly=yes
             or
       ./ecracli info

### Examples
```json
ecra> info
* Ecracli -17.134
* username : sdi
* host     : http://den01gpy.us.oracle.com:9001/ecra/endpoint
* created exaunits
*  <id> : <rackname>          : <rackstate> : <ongoing op> : <dbSIDs>
*  1    : slcqab02adm0506clu5 : PROVISIONED :              : dbd773a9(CREATED)
* Connecting to endpoint and getting version info...
* status : 200
* exacloud_version : main(17.133)
* status-detail : success
* label : ECS_MAIN_LINUX.X64_170513.0900
* dbaas_version : dbaastools_exa-1.0-1+16.2.0.0.0_170511.2001
* oeda_version : 17.089.19:00
* op : version_get
* dborch_version : 4.0.132.17.37

ecra> info display=cei
* Ecracli -23.176
* host              : http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint
* username          : ops
* password          : ****
* created exaunits
*  <id> : <rackname>                                             : <exaname> : <rackstate>  : <ongoing op>   : <workflowId>                         : <dbSIDs>
*  161  : iad1-d4-cl3-340409f5-b0a2-4573-a599-aa9041a7f5a2-clu01 :           : PROVISIONERR : create-service : 6ec316fc-c163-4a92-8d21-09286d9bb6e8 : 
* ExadataInfra Info...
*  <infrastructure> : <rackname>                                             : <state>              : <clusters> : <model>
*  flowtesterInfra : iad1-d4-cl3-340409f5-b0a2-4573-a599-aa9041a7f5a2-clu01 : PROVISIONED          : 2          : X8M-2   
* Connecting to endpoint and getting version info...
* dbaas_version : dbaastools_exa-1.0-MAIN_230517.0101
* dbcs_agent_ol6 : dbcs-2.8OL6-MAIN_230517.0101
* dbcs_agent_ol7 : dbcs-2.8OL7-MAIN_230517.0101
* oeda_build : OSS_23.1.0.0.0OEDA_LINUX.X64_230412.1
* oci_sdk_version : 2.61.0
* exacloud_version : main(23.137)
* oeda_version : 230412
* comment : test3
* label : ECS_MAIN_LINUX.X64_230703.1131
* workflow_api_version : 0.1_mainline_2023-04-24T10:02:13Z
* dborch_version : ECS_MAIN_LINUX.X64_230703.1131

ecra> info hide_clusters=True
* Ecracli -20.234
* host              : http://slc17ubh.us.oracle.com:9001/ecra/endpoint
* username          : ops
* password          : ****
* Connecting to endpoint and getting version info...
* dbaas_version : dbaastools_exa-1.0-1+MAIN_200812.0101
* dbcs_agent_ol6 : dbcs-2.8OL6-MAIN_200812.0101
* dbcs_agent_ol7 : dbcs-2.8OL7-MAIN_200812.0101
* exacloud_version : main(20.225)
* oeda_version : 200624
* label : ECS_MAIN_LINUX.X64_200819.0900
* workflow_api_version : 0.1_mainline_2020-06-16T10:58:32Z
* dborch_version : ECS_MAIN_LINUX.X64_200819.0900
* status : 200
* op : version_get
* status-detail : success

ecra> info rackstate=PROVISIONED
* Ecracli -22.018
* host              : http://slc16ccl.us.oracle.com:9001/ecra/endpoint
* username          : ops
* password          : ****
* created exaunits
*  <id> : <rackname>                           : <exaname> : <rackstate> : <ongoing op> : <workflowId> : <dbSIDs>
*  176  : iad103714_cluster_name_16            : exaclu    : PROVISIONED :              :              : 
*  177  : sea201109exd-d0-01-02-cl-01-03-clu01 : myclu1    : PROVISIONED :              :              : 
*  178  : iad103714exd-d0-05-06-cl-07-09-clu01 : myclu1    : PROVISIONED :              :              : 
* Connecting to endpoint and getting version info...
* dbaas_version : dbaastools_exa-1.0-1+MAIN_220114.0101
* dbcs_agent_ol6 : dbcs-2.8OL6-MAIN_220114.0101
* dbcs_agent_ol7 : dbcs-2.8OL7-MAIN_220114.0101
* oci_sdk_version : 2.10.0
* exacloud_version : main(22.018)
* oeda_version : 211217
* label : ECS_MAIN_LINUX.X64_220118.2038
* workflow_api_version : 0.1_log4j_2.17.1_2021-12-20T06:27:20Z
* dborch_version : ECS_MAIN_LINUX.X64_220118.2038
* status : 200
* op : version_get
* status-detail : success

ecra> info rackname=sea
* Ecracli -22.018
* host              : http://slc16ccl.us.oracle.com:9001/ecra/endpoint
* username          : ops
* password          : ****
* created exaunits
*  <id> : <rackname>                           : <exaname> : <rackstate> : <ongoing op> : <workflowId> : <dbSIDs>
*  177  : sea201109exd-d0-01-02-cl-01-03-clu01 : myclu1    : PROVISIONED :              :              : 
* Connecting to endpoint and getting version info...
* dbaas_version : dbaastools_exa-1.0-1+MAIN_220114.0101
* dbcs_agent_ol6 : dbcs-2.8OL6-MAIN_220114.0101
* dbcs_agent_ol7 : dbcs-2.8OL7-MAIN_220114.0101
* oci_sdk_version : 2.10.0
* exacloud_version : main(22.018)
* oeda_version : 211217
* label : ECS_MAIN_LINUX.X64_220118.2038
* workflow_api_version : 0.1_log4j_2.17.1_2021-12-20T06:27:20Z
* dborch_version : ECS_MAIN_LINUX.X64_220118.2038
* status : 200
* op : version_get
* status-detail : success

ecra> info verbose=yes
* Ecracli -22.018
* host              : http://slc16ccl.us.oracle.com:9001/ecra/endpoint
* username          : ops
* password          : ****
* created exaunits
*  <id> : <rackname>                           : <exaname> : <rackstate> : <ongoing op> : <workflowId> : <dbSIDs>
*  177  : sea201109exd-d0-01-02-cl-01-03-clu01 : myclu1    : PROVISIONED :              :              : 
* Connecting to endpoint and getting version info...
* dbaas_version : dbaastools_exa-1.0-MAIN_231024.0100
* bin/diagnosticcli.py : 20230920
* oeda_build : OSS_23.1.5.0.0OEDA_LINUX.X64_230919
* helidon_version : 2.6.3
* exacd_netchk.tar.gz : 20230920
* exacloud_version : main(23.297)
* oeda_version : 230919
* exacd_plgmon : 20230920
* label : ECS_MAIN_LINUX.X64_231210.0901
* rsyslog : 20230920
* workflow_api_version : 0.1_mainline_2023-11-24T05:15:31Z
* exa_infra_events : 20230920
* dbcs_agent_ol6 : dbcs-2.8OL6-MAIN_231024.0100
* dbcs_agent_ol7 : dbcs-2.8OL7-MAIN_231024.0100
* oci_sdk_version : 3.23.0
* exacd_cpcheck : 20230920
* dborch_version : ECS_MAIN_LINUX.X64_231210.0901
* exacd_logcol : 20230920
* sanitycheck : 20230920
* status : 200
* op : version_get
* status-detail : success

ecra> info ecraonly=yes
* Ecracli -24.073
* host           : http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint
* username       : ops
* password       : ****
* created exaunits
*  <id> : <rackname>                                             : <exaname>           : <rackstate> : <ongoing op> : <workflowId> : <serverName> : <dbSIDs>
*  405  : iad1-d4-cl3-7e5c8453-ac02-43cf-8269-536cb8f41372-clu01 : MVM-flowtester-TST1 : PROVISIONED :              :              :              : 
* Connecting to endpoint and getting version info...
* dbaas_version : dbaastools_exa-1.0-MAIN_240130.0101
* dbcs_agent_ol6 : dbcs-2.8OL6-MAIN_240130.0101
* dbcs_agent_ol7 : dbcs-2.8OL7-MAIN_240130.0101
* oeda_build : version not fetched
* helidon_version : 2.6.5
* oci_sdk_version : 3.23.0
* exacloud_version : version not fetched
* oeda_version : version not fetched
* label : ECS_MAIN_LINUX.X64_240320.0901
* workflow_api_version : 0.1_mainline_2024-01-24T10:16:48Z
* dborch_version : ECS_MAIN_LINUX.X64_240320.0901
* status : 200
* op : version_get
* status-detail : success
```


## vm

### Description
*This API will execute ExaCompute VM actions on a particular VM*

### Usages
`exacompute vm [action="moveSanityCheck|movePrepare|move" exaUnitId=<VM Cluster ExaUnitId> vmName=<VM internal name> sourceDom0=<source DOM0> targetDom0=<target DOM0>]`

### Examples:
```json
ecra> exacompute vm action=moveSanityCheck exaUnitId=2 vmName=sea301112exddu0101 sourceDom0=sea301112exdd001 targetDom0=sea301112exdd002
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "exacompute_vm_operation_post",
    "op_start_time": "2022-09-16T02:49:10+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/79b5e84b-26fb-4e1e-84e8-d988eb942496"
}

ecra> exacompute vm action=movePrepare exaUnitId=2301 vmName=iad103709exddu0901 sourceDom0=iad103709exdd009 targetDom0=iad103709exdd007
* {
    "est_op_end_time": "",
    "exaunit_id": 2301,
    "message": "processing",
    "op": "exacompute_vm_operation_post",
    "op_start_time": "2023-07-27T18:26:42+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/4c15bba7-c4f4-41e0-b1fc-7ee0be89dd6b"
}

ecra> exacompute vm action=move exaUnitId=2 vmName=sea301112exddu0101 sourceDom0=sea301112exdd001 targetDom0=sea301112exdd002
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "exacompute_vm_operation_post",
    "op_start_time": "2022-09-16T02:49:10+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/79b5e84b-26fb-4e1e-84e8-e899fc053507",
    "xml": "/scratch/rmavilla/ecra_installs/ecra/mw_home/user_projects/domains/PODREPO/XMLTransientStorage__1234.xml"
}
ecra>
```
## createmaintenancedomain

### Description
*The API will create a maintenance domain in ECRA*

### Usages
`exacompute createmaintenancedomain json_path=<payload path>`

#### Values
` <json_path>  : Payload path`

### Examples:
```json
ecra> exacompute createmaintenancedomain json_path=/scratch/rgmurali/ecra_installs/ecrastack/ecracli/tmpl/createmd.json
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "md_create",
    "op_start_time": "2022-10-15T17:10:20+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/0a294a0d-bae4-4303-a754-38eb8783f99d"
}
```

## listmaintenancedomain

### Description
*The API will list all the maintenance domains in a particular QFAB*

### Usages
`exacompute listmaintenancedomain <fabricname=<QFABNAME>>`

#### Values
` <fabricname>  : Name of the fabric`

### Examples:
```json
ecra>  exacompute listmaintenancedomain fabricname=SEA200041QFAB
* {
    "items": [
        {
            "fabricName": "SEA200041QFAB",
            "maintenanceDomain": [
                {
                    "endDay": 214,
                    "id": 6,
                    "nodeIds": [],
                    "startDay": 200,
                    "totalResources": []
                },
                {
                    "endDay": 214,
                    "id": 5,
                    "nodeIds": [],
                    "startDay": 200,
                    "totalResources": []
                },
                {
                    "endDay": 214,
                    "id": 1,
                    "nodeIds": [],
                    "startDay": 200,
                    "totalResources": [
                        {
                            "hwModel": "X8M-2",
                            "resources": {
                                "cpu": {
                                    "className": "CpuResource",
                                    "used": 0,
                                    "value": 52
                                },
                                "memory": {
                                    "className": "MemoryResource",
                                    "used": null,
                                    "value": 1621469691904
                                },
                                "network": null,
                                "storageLocal": {
                                    "className": "StorageLocalResource",
                                    "used": null,
                                    "value": 8356288371097
                                }
                            }
                        }
                    ]
                },
                {
                    "endDay": 128,
                    "id": 2,
                    "nodeIds": [],
                    "startDay": 115,
                    "totalResources": [
                        {
                            "hwModel": "X8M-2",
                            "resources": {
                                "cpu": {
                                    "className": "CpuResource",
                                    "used": 0,
                                    "value": 52
                                },
                                "memory": {
                                    "className": "MemoryResource",
                                    "used": null,
                                    "value": 1621469691904
                                },
                                "network": null,
                                "storageLocal": {
                                    "className": "StorageLocalResource",
                                    "used": null,
                                    "value": 8356288371097
                                }
                            }
                        }
                    ]
                },
                {
                    "endDay": 214,
                    "id": 3,
                    "nodeIds": [],
                    "startDay": 200,
                    "totalResources": []
                },
                {
                    "endDay": 113,
                    "id": 0,
                    "nodeIds": [],
                    "startDay": 99,
                    "totalResources": []
                }
            ]
        }
    ]
}
```

## getmaintenancedomain

### Description
*The API will get the details of a specific maintenance domain in a QFAB*

### Usages
`exacompute getmaintenancedomain <fabricname=QFABNAME> <maintenancedomainid=mdid>`

#### Values
` <fabricname>  : Name of the QFAB
  <maintenancedomainid> : Maintenance Domain ID`

### Examples:
```json
ecra> exacompute getmaintenancedomain fabricname=SEA200041QFAB maintenancedomainid=2
* {
    "endDay": 128,
    "id": 2,
    "nodeIds": [],
    "startDay": 115,
    "totalResources": [
        {
            "hwModel": "X8M-2",
            "resources": {
                "cpu": {
                    "className": "CpuResource",
                    "used": 0,
                    "value": 52
                },
                "memory": {
                    "className": "MemoryResource",
                    "used": null,
                    "value": 1621469691904
                },
                "network": null,
                "storageLocal": {
                    "className": "StorageLocalResource",
                    "used": null,
                    "value": 8356288371097
                }
            }
        }
    ]
}
```
## updatemaintenancedomain

### Description
*The API will update the attributes of a maintenance domain*

### Usages
`exacompute updatemaintenancedomain <fabricname=QFABNAME> <maintenancedomainid=mdid> <json_path=<payload path>>`

#### Values
` <fabricname>  : Name of the QFAB
  <maintenancedomainid> : Maintenance Domain ID
  <json_path>  : File path containing the payload`

### Examples:
```json
ecra> exacompute updatemaintenancedomain fabricname=SEA200041QFAB maintenancedomainid=1 json_path=/scratch/rgmurali/ecra_installs/ecrastack/ecracli/tmpl/updatemd.json
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "md_put",
    "op_start_time": "2022-10-15T20:34:45+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/f12c870b-0b0b-45d2-8aae-c1ddbf1b9077"
}
```

## deletemaintenancedomain

### Description
*The API will delete a maintenance domain in ECRA*

### Usages
`exacompute deletemaintenancedomain <fabricname=QFABNAME> <maintenancedomainid=mdid>`

#### Values
` <fabricname>  : Name of the QFAB
  <maintenancedomainid> : Maintenance Domain ID`

### Examples:
```json
ecra> exacompute deletemaintenancedomain fabricname=SEA200041QFAB maintenancedomainid=6
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "md_delete",
    "op_start_time": "2022-10-15T17:16:43+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/2501cf1b-184e-4453-8dd9-587f18fd2493"
}
```

## getmdnodes

### Description
*The API will get all the nodes of a maintenance domain in ECRA*

### Usages
`exacompute getmdnodes <fabricname=QFABNAME> <maintenancedomainid=mdid>`

#### Values
` <fabricname>  : Name of the QFAB
  <maintenancedomainid> : Maintenance Domain ID`

### Examples:
```json
ecra> exacompute getmdnodes fabricname=SEA200041QFAB maintenancedomainid=1 
* {
    "items": [
        {
            "imageVersion": "19.2.6.0.0.190911.1",
            "nodeId": "sea303716exdd017.iad103716exd.adminiad1.oraclevcn.com",
            "nodeState": "INNOTIFICATION"
        }
    ]
}
```

## createmdcontext

### Description
*The API will create a maintenance domain context in ECRA*

### Usages
`exacompute createmdcontext json_path=<payload path>`

#### Values
` <json_path>  : File path containing the payload`

### Examples:
```json
ecra> exacompute createmdcontext json_path=/scratch/rgmurali/ecra_installs/ecrastack/ecracli/tmpl/createmdcontext.json
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "mdcontext_post",
    "op_start_time": "2022-10-17T04:29:34+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/355137ca-d0bb-4678-9b44-80926b28e7ca"
}
```

## updatemdcontext

### Description
*The API will update a maintenance domain context in ECRA*

### Usages
`exacompute updatemdcontext <fabricname=QFABNAME> json_path=<payload path>`

#### Values
` <fabricname> : Name of the QFAB
  <json_path>  : File path containing the payload`

### Examples:
```json
ecra> exacompute updatemdcontext fabricname=SEA200041QFAB json_path=/scratch/rgmurali/ecra_installs/ecrastack/ecracli/tmpl/updatemdcontext.json
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "mdcontext_put",
    "op_start_time": "2022-10-17T17:24:27+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/f5135622-8514-4643-b8e5-9d888e2a3560"
}
```

## deletemdcontext

### Description
*The API will delete a maintenance domain context in ECRA*

### Usages
`exacompute deletemdcontext <fabricname=QFABNAME>`

#### Values
` <fabricname>  : Name of the QFAB`

### Examples:
```json
ecra> exacompute deletemdcontext fabricname=SEA200041QFAB
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "mdcontext_delete",
    "op_start_time": "2022-10-17T17:33:44+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://slc10xfq.us.oracle.com:9001/ecra/endpoint/statuses/0b43537c-f3e4-4aac-8823-428f61529854"
}
```

## getmdcontext

### Description
*The API will get the details of a maintenance domain context in ECRA*

### Usages
`exacompute getmdcontext <fabricname=QFABNAME>`

#### Values
` <fabricname>  : Name of the QFAB`

### Examples:
```json
ecra> exacompute getmdcontext fabricname=SEA200041QFAB
* {
    "currentMdId": 0,
    "mdResourceThreshold": [
        {
            "hwModel": "X8M-2",
            "resources": {
                "cpu": {
                    "className": "CpuResource",
                    "used": 0,
                    "value": 500
                },
                "memory": {
                    "className": "MemoryResource",
                    "used": 0,
                    "value": 1195376640
                },
                "network": {
                    "backupNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    },
                    "clientNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    },
                    "vipNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    }
                },
                "storageLocal": {
                    "className": "StorageLocalResource",
                    "used": 0,
                    "value": 0
                }
            }
        },
        {
            "hwModel": "X9M-2",
            "resources": {
                "cpu": {
                    "className": "CpuResource",
                    "used": 0,
                    "value": 500
                },
                "memory": {
                    "className": "MemoryResource",
                    "used": 0,
                    "value": 1195376640
                },
                "network": {
                    "backupNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    },
                    "clientNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    },
                    "vipNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    }
                },
                "storageLocal": {
                    "className": "StorageLocalResource",
                    "used": 0,
                    "value": 0
                }
            }
        },
        {
            "hwModel": "X10M-2",
            "resources": {
                "cpu": {
                    "className": "CpuResource",
                    "used": 0,
                    "value": 1000
                },
                "memory": {
                    "className": "MemoryResource",
                    "used": 0,
                    "value": 1195376640
                },
                "network": {
                    "backupNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    },
                    "clientNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    },
                    "vipNetwork": {
                        "dom0OracleName": null,
                        "domUOracleName": null,
                        "domainName": "",
                        "gateway": null,
                        "hostName": "",
                        "ip": "",
                        "macAddress": null,
                        "netmask": null,
                        "standbyVnicMac": null,
                        "vlantag": 0
                    }
                },
                "storageLocal": {
                    "className": "StorageLocalResource",
                    "used": 0,
                    "value": 15000
                }
            }
        }
    ],
    "mds": [],
    "notificationDuration": 30,
    "totalDuration": 90,
    "totalMds": 0
}
```

## updatenodemdmapping

### Description
*The API will update the MD ID for the given node name, for a given list of these mappings*

### Usages
`exacompute updatenodemdmapping json_path=<filepath>`

#### Values
` <json_path>  : File path having the payload`

### Examples:
```json
ecra> exacompute updatenodemdmapping json_path=/scratch/rgmurali/ecra_installs/activeecra/ecracli/tmpl/nodemapping.json
* {"status": 200, "status-detail": "success", "op": "exacompute_node_to_md_mapping_put"}
```

## fleetstateunlock

### Description
*The API will release the lock on the state store*

### Usages
`exacompute fleetstateunlock fleetstatehandle=<statehandle> fleetlockhandle=<lockhandle>`

#### Values
` <fleetstatehandle>  : fleet state handle
  <fleetlockhandle>   : fleet lock handle `

### Examples:
```json
ecra> exacompute fleetstateunlock fleetstatehandle=100088 fleetlockhandle=91
    * {"fleetStateHandle": 100088, "lockstatus": 1}
```

## add_cluster

### Description
Creates an exacompute rack based on the provided information

### Usages
`exacompute addcluster json_path=<PATH> hostnames=<HOSTNAMES>`

#### Values
` <PATH>  : Path for the add cluster`
` <HOSTNAMES> : Hostnames comma separated`

### Examples
```json
ecra> exacompute addcluster json_path=/scratch/illamas/ecra_installs/irving1/exacompute_add_cluster_2computes.json
        * {"status": 202, "status_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/statuses/4f30b73d-65f2-4c2f-8529-52c2a716628e", "op": "exacompute_addcluster_put", "op_start_time": "2021-12-10T21:05:53+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 999, "target_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/exaunit/999"}

ecra> exacompute addcluster json_path=/ade/illamas_ECS_MAIN_LINUX.X64_new/ecs/ecra/test/scenarios/exacompute/payloads/addcluster.json hostnames=iad103709exdd008,iad103709exdd007
```

## computedetail

### Description
Returns the list of racks associated with the provided parameter, this could be an oracle hostname or a smartnicid.

### Usages
`exacompute computedetail hostname=<HOSTNAME>`

#### Values
` <HOSTNAME> : An oracle hostname or smartnicid`

### Examples
```json
ecra> exacompute computedetail hostname=iad103709exdd004
* {
    "op": "exacompute_listracks_get",
    "racks": [
        {
            "atp": "N",
            "clustermodel": "X8M-2",
            "clustername": "MvM-c1",
            "clusterstatus": "PROVISIONED",
            "compartmentid": "ocid1.compartment.region1..aaaaaaaarwmgoyrgulkmkjhwivx5ww3vtmxfuiuitgqoaiyh5dps7xyk5lpq ",
            "exaocid": "ocid1.cloudexadatainfrastructure.region1.sea.anzwkljsinjoekaa653avxwdmuczr75j3ufk5w5hy5rqtavjm4cywvny37bq",
            "exaunitid": "1921",
            "rackname": "iad103714exd-d0-01-02-cl-01-03-clu01",
            "tenancyname": "dbaasnm",
            "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq"
        }
    ],
    "status": 200,
    "status-detail": "success"
}

ecra> exacompute computedetail hostname=4.0G1950-GBC001018
* {
    "op": "exacompute_listracks_get",
    "racks": [
        {
            "atp": "N",
            "clustermodel": "X8M-2",
            "clustername": "MvM-c1",
            "clusterstatus": "PROVISIONED",
            "compartmentid": "ocid1.compartment.region1..aaaaaaaarwmgoyrgulkmkjhwivx5ww3vtmxfuiuitgqoaiyh5dps7xyk5lpq ",
            "exaocid": "ocid1.cloudexadatainfrastructure.region1.sea.anzwkljsinjoekaa653avxwdmuczr75j3ufk5w5hy5rqtavjm4cywvny37bq",
            "exaunitid": "1921",
            "rackname": "iad103714exd-d0-01-02-cl-01-03-clu01",
            "tenancyname": "dbaasnm",
            "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq"
        }
    ],
    "status": 200,
    "status-detail": "success"
}
```

## reshapecluster

### Description
*Performs the reshapecluster operation over the provided vmclusterid.*

### Usages
`exacompute reshapecluster  vmclusterid=<VMCLUSTERID> [cores=<CORES> memoryGb=<MEMORY> ohomeSizeGb=<OHSIZE> filesystem=<montpoint:size, etc>] volumes=<montpoint:size, etc>]`

#### Values
` <VMCLUSTERID>    : VM cluster ocid of the rack
  <CORES>          : #of Cores
  <MEMORY>         : Memory in GB
  <OHSIZE>         : Oracle home in GB
  <FILESYSTEM>     : A comma separated array of [name of the mountpoint: size in GB]. e.g. filesystem=/u01:50,/var:15
  <VOLUMES>        : For filesystem reshape in exacompute is also required a required a comma separated array of [name of the volume type: size in GB]. e.g. volumes=u01:50,system:15`

### Examples:
```json
ecra> exacompute reshapecluster vmclusterid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d48 memoryGb=100
    * {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d155c878-a3c5-4727-bc0c-aa752aaf6634", "op": "exacompute_updatecluster_put", "op_start_time": "2023-03-11T18:14:46+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 1544}
```

## reshapecluster precheck

### Description
*Performs the Precheck of reshapecluster operation over the provided vmclusterid.*

### Usages
`exacompute reshapecluster_precheck  vmclusterid=<VMCLUSTERID> [cores=<CORES> memoryGb=<MEMORY> ohomeSizeGb=<OHSIZE>]`

#### Values
` <VMCLUSTERID>    : VM cluster ocid of the rack
  <CORES>          : #of Cores
  <MEMORY>         : Memory in GB
  <OHSIZE>         : Oracle home in GB`
### Examples:
```json
ecra> exacompute reshapecluster_precheck
vmclusterid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d294
cores=8
* {"idemToken": "b1af0eb9-c6ef-41c8-a26b-e349874c393f", "vmClusterOcid":
"ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d294",
"status": 200, "op": "exacompute_updateclusterPrecheck_post", "status-detail":
"success"}
```


## initiator

### Description
*Request initiator to Exacloud for the given node*

### Usages
`exacompute initiator nodefqdn=<HOSTNAME>`

#### Values
` <HOSTNAME> : This value could be the hostname with or without the domain. `

### Examples:
```json
ecra> exacompute initiator nodefqdn=iad103716exdd008
* {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d95879c8-0252-4881-8621-e7234154ba94", "op": "exacompute_initialingestion_post", "op_start_time": "2023-05-15T18:37:53+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}

ecra> status d95879c8-0252-4881-8621-e7234154ba94
* {"start_time": "2023-05-15T18:37:53+0000", "end_time": "2023-05-15T18:37:58+0000", "resource_id": "iad103716exdd008", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-05-15T18:37:53+0000", "status": 200, "message": "Done", "op": "exacompute-init", "atp_enabled": "Y", "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d95879c8-0252-4881-8621-e7234154ba94", "status-detail": "success"}
```
## updateocid

### Description
*Updates the node ocid for the provided hostname*

### Usages
`exacompute updateocid nodefqdn=<HOSTNAME> nodeocid=<OCID>`

#### Values
` <HOSTNAME>  : This value could be the hostname with or without the domain.
  <OCID>      : ocid of the hostname `

### Examples:
```json
ecra> exacompute updateocid nodefqdn=iad103716exdd008 nodeocid=ocid.dom0.abc1
* {"status": 200, "op": "exacompute_initialingestion_put", "status-detail": "success"}
```

## gettemplate

### Description
*Based on the provided parameters, command will return a template.*

### Usages
`exacompute gettemplate type=<TYPE> [vmclusterocid=<VMCLUSTEROCID>]`

#### Values
` <TYPE>  : Type of the system, for example: exacsexacompute`
`<VMCLUSTEROCID> : vm cluster ocid of the rack that you want to get the template`

### Examples:
```json
ecra> exacompute gettemplate type=exacsexacompute
* {
    "platformtype": "exacsexacompute",
    "values": [
        {
            "volumesizegb": "50",
            "volumetype": "gi"
        },
        {
            "volumesizegb": "32",
            "volumetype": "gcv"
        },
        {
            "volumesizegb": "900",
            "volumetype": "u02"
        },
        {
            "volumesizegb": "3500",
            "volumetype": "system"
        }
    ]
}
```

## postvolumes

### Description
*Stores volumes information in ecra DB*

### Usages
`exacompute postvolumes jsonpath=<JSONPATH>`

#### Values
` <JSONPATH> : Path to the json that contains all the volumes information`

### Examples:
```json
ecra> exacompute postvolumes jsonpath=/scratch/illamas/payloads/exacompute/postvolumes.json
        * {"status": 200, "op": "exacompute_volumes_post", "status-detail": "success"}
```

## getvolumes

### Description
*This API returns the volumes associated with the provided parameter*

### Usages
`exacompute getvolumes rackname=<RACKNAME> hostname=<hostname> [guestname=<guestname> edvvolume=<edvvolume>]`

#### Values
` <RACKNAME> the rackname could be the name of the rack or the ocid of the rack`
` <hostname> oracle hostname, this can't be used with rackname, use either one`
` <guestname> client hostname for domu filter`
` <edvvolume> edvvolume (device path) filter, can use comma to send multiple volumes`

### Examples:
```json
ecra> exacompute getvolumes rackname=exacompute-iad1-d2-a863a3a8-691a-43f2-8472-2f8caaf90757-clu01
* {
    "vaultid": "oracle-vault",
    "nodes": [
        {
            "oraclehostname": "iad103709exdd008",
            "clienthostname": "testVmclusterDemo009client1-vip166.exacomputecusto.jboduvcn.oraclevcn.com",
            "volumes": [
                {
                    "volumeid": "1ghi",
                    "volumetype": "gcv",
                    "volumename": "CPGCV1",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "32"
                },
                {
                    "volumeid": "1def",
                    "volumetype": "gi",
                    "volumename": "cpGi1",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "50"
                },
                {
                    "volumeid": "1abc",
                    "volumetype": "system",
                    "volumename": "cpSystem1",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "3420"
                },
                {
                    "volumeid": "1jkl",
                    "volumetype": "u02",
                    "volumename": "CPu021",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "900"
                }
            ]
        },
        {
            "oraclehostname": "iad103709exdd007",
            "clienthostname": "testVmclusterDemo009client2-vip283.exacomputecusto.jboduvcn.oraclevcn.com",
            "volumes": [
                {
                    "volumeid": "2ghi",
                    "volumetype": "gcv",
                    "volumename": "CPGCV2",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "32G"
                },
                {
                    "volumeid": "2def",
                    "volumetype": "gi",
                    "volumename": "cpGi2",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "50G"
                },
                {
                    "volumeid": "2abc",
                    "volumetype": "system",
                    "volumename": "cpSystem2",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "3.42T"
                },
                {
                    "volumeid": "2jkl",
                    "volumetype": "u02",
                    "volumename": "CPu022",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "900G"
                }
            ]
        }
    ],
    "status": 200,
    "op": "exacompute_volumes_get",
    "status-detail": "success"
}
```

## validatevolumes

### Description
*This will call the validate volumes API and the GET result API, Volume Validation calls exacloud to check on attached volumes*

### Usages
`exacompute validatevolumes rackname=<RACKNAME> hostname=<hostname> [guestname=<guestname> edvvolume=<edvvolume>]`

#### Values
` <RACKNAME> the rackname could be the name of the rack or the ocid of the rack`
` <hostname> oracle hostname, this can't be used with rackname, use either one`
` <guestname> client hostname for domu filter`
` <edvvolume> edvvolume (device path) filter, can use comma to send multiple volumes`

### Examples:
```json
ecra> exacompute validatevolumes
rackname=exacompute-iad1-d2-595b8f27-a42f-46bb-93b4-68c2767ceef0-clu01 wait
* {"status": 202, "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/43ab601c-f968-482d-9653-8b6e729051d1",
"op": "exacompute_volumes_val_post", "op_start_time":
"2025-08-14T21:20:57+0000", "est_op_end_time": "", "message": "processing",
"status-detail": "processing"}
* Status UUID: 43ab601c-f968-482d-9653-8b6e729051d1
* {
    "attached_volumes": [],
    "unattached_volumes": [],
    "stale_volumes": [],
    "status": 200,
    "op": "exacompute_volumes_val_get",
    "status-detail": "success"
}

ecra> exacompute validatevolumes
rackname=exacompute-iad1-d2-595b8f27-a42f-46bb-93b4-68c2767ceef0-clu01
* {"status": 202, "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/fb463def-cf2c-4331-9e3d-0f0fcf1bb68b",
"op": "exacompute_volumes_val_post", "op_start_time":
"2025-08-14T21:20:12+0000", "est_op_end_time": "", "message": "processing",
"status-detail": "processing"}
ecra> status fb463def-cf2c-4331-9e3d-0f0fcf1bb68b
* {"progress_percent": 0, "start_time_ts": "2025-08-14 21:20:12.0", "end_time":
"2025-08-14T21:20:22+0000", "ecra_server": "EcraServer1", "wf_uuid":
"c2a631e2-7778-4cec-b132-c4099384c4a1", "start_time":
"2025-08-14T21:20:12+0000", "last_heartbeat_update": "2025-08-14T21:20:12+0000",
"status": 200, "message": "Done", "op": "EXACOMPUTE_PRECHECKS", "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/fb463def-cf2c-4331-9e3d-0f0fcf1bb68b",
"status-detail": "success"}
ecra> workflows describe workflowId=c2a631e2-7778-4cec-b132-c4099384c4a1
* {
    "workflowName": "exacompute-volume-validation-wfd",
    "workflowId": "c2a631e2-7778-4cec-b132-c4099384c4a1",
    "workflowStatus": "Completed",
    "workflowStartTime": "14 Aug 2025 21:20:12 UTC",
    "workflowEndTime": "14 Aug 2025 21:20:22 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "VolumeValidationTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Aug 14 21:20:12 UTC 2025",
            "taskEndTime": "Thu Aug 14 21:20:22 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:10"
        },
        {
            "taskName": "EndWf",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Aug 14 21:20:22 UTC 2025",
            "taskEndTime": "Thu Aug 14 21:20:22 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "EndWf",
            "lastOperationDetails": {
                "lastTaskLastOperationId":
"031a6d62-76be-43db-a5cd-1ab57e7b4804",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "14 Aug 2025 21:20:22 UTC",
                "lastTaskLastOperationEndTime": "14 Aug 2025 21:20:22 UTC"
            }
        }
    ],
    "workflowElapsed": "00:00:10",
    "workflowRuntime": "00:00:10",
    "exaOCID": "",
    "requestId": "fb463def-cf2c-4331-9e3d-0f0fcf1bb68b",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
```

## generatesshkeys

### Description:
*Generate an SSH key pair for the indicated node and store it.
      
### Usages:
    `exacompute generatesshkeys hostname=<HOSTNAME>`
#### Values:
`<HOSTNAME> : Name of the node`

### Examples:
```
ecra> exacompute generatesshkeys hostname=iad103709exdd011
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "exacompute_generate_ssh_keys",
     "op_start_time": "2023-05-12T21:47:36+0000",
     "status": 202,
     "status-detail": "processing",
     "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d2950bc8-985a-418a-b7da-eb1515bcce1a"
}
ecra> status d2950bc8-985a-418a-b7da-eb1515bcce1a
* {"start_time": "2023-05-12T21:47:36+0000", "end_time": "2023-05-12T21:47:41+0000", "resource_id": "iad103709exdd011", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-05-12T21:47:36+0000", "status": 200, "message": "Done", "op": "exacompute-generatesshkeys", "atp_enabled": "Y", "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d2950bc8-985a-418a-b7da-eb1515bcce1a", "status-detail": "success"}
```
## getpublickey

### Description:
* Retreive the stored public key of the indicated node.
### Usage:
`exacompute getpublickey hostnames=<HOSTNAME>`
#### Values:
`<HOSTNAME> : Name of the node`

### Examples:
```
ecra>  exacompute getpublickey hostname=iad103709exdd011
* {
   "oracle_hostname": "iad103709exdd011",
   "sshkey": "initiator.xyz.123",
   "status": "200"
}
```

## getvaultaccess

### Description:
* Retreive the stored vault access information of the indicated OCID 
### Usage:
`exacompute vaultaccessid=<VAULTACCESSID>
#### Values:
`<VAULTACCESSID> :  OCID of the vault access registry

### Examples:
```
ecra>  exacompute getvaultaccess vaultaccessid=ThisIsAnExample
* {
    "driverversion": "Example20.5.2",
    "exarootaddress": "AddressHere",
    "exarootusername": "UserHere",
    "issystemgenerated": "true",
    "lifecyclestate": "Starting",
    "node_id": "Examplenode",
    "nodeaccessid": "ExampleId",
    "op": "exacompute_get_vault_access",
    "publickkey": "ThisIsAkEy123.ABC",
    "status": 200,
    "status-detail": "success",
    "vaultaccesscompartmentid": "ExampleComp",
    "vaultaccessid": "ThisIsAnExample",
    "vaultaccessname": "ExampleName",
    "vaultaccesstype": "ExampleType",
    "vaultid": "no_vault_ID",
    "vaultreferenceidentifier": "ExampleRef"
}
```
## updatevaultaccessdetals

### Description:
* Retreive and store the vault acces details.
### Usage:
`exacompute updatevaultaccessdetals hostname=<HOSTNAME> exarootuser=<USERNAME> exarooturl=<URL> vaultaccess=<VAULTACCESS> vaultid=<VAULTID> trustcertificates=<TRUSTCERTIFICATES>`
#### Values:
`<HOSTNAME>  : Name of the node to be used.`
`<USERNAME> : Value of the exaroot username.`
`<URL>: Value of the exaroot url.`
`<VAULTACCESS>: Access value to the vault.`
`<VAULTID>: Identificator of the vault`
`<TRUSTCERTIFICATES>: Path of json file where the JSONArray of certificates are stored.`

### Examples:
```
ecra> exacompute updatevaultaccessdetails hostname=iad103709exdd013 exarootuser=user1 exarooturl=user1.com vaultaccess=access1 vaultid=id1 trustcertificates=cert1,cert2,cert3
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "exacompute_update_access_vault_details",
    "op_start_time": "2023-05-17T16:21:31+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/0dd3f609-cf7c-4fdc-ae26-80000dfa04b8"
}
ecra> status 0dd3f609-cf7c-4fdc-ae26-80000dfa04b8
* {"start_time": "2023-05-17T16:21:31+0000", "end_time": "2023-05-17T16:21:36+0000", "resource_id": "user1", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-05-17T16:21:31+0000", "status": 200, "message": "Done", "op": "exacompute-getvaultaccessdetails", "atp_enabled": "Y", "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/0dd3f609-cf7c-4fdc-ae26-80000dfa04b8", "status-detail": "success"}
ecra> 
```
## deletevaultaccessdetails

### Description:
* Deletes the VaultAccess details for the indicated dom0
### Usage:
`exacompute deletevaultaccessdetails [hostname=<HOSTNAME>| vaultaccessid=<OCID>]`
#### Values:
`<HOSTNAME> : Name of the node`
`<OCID> : Identifier ocid of the vault access`

### Examples:
```
ecra> exacompute deletevaultaccessdetails hostname=iad103709exdd011
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "exacompute_update_access_vault_details",
    "op_start_time": "2023-09-07T23:38:23+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri":
"http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/5d4936cc-cb67-41b2-a4b3-bcdec268d0c1"
}

ecra> status 5d4936cc-cb67-41b2-a4b3-bcdec268d0c1
* {"start_time": "2023-09-07T23:38:23+0000", "progress_percent": 0,
"ecra_server": "EcraServer1", "last_heartbeat_update":
"2023-09-07T23:38:23+0000", "wf_uuid": "71d3e311-a959-4ee3-b0e2-afb9fc96e29a",
"status": 202, "message": "Pending", "op": "exacompute-deletedetails",
"completion_percentage": 0, "status_uri":
"http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/5d4936cc-cb67-41b2-a4b3-bcdec268d0c1",
"op_start_time": "2023-09-07T23:38:34+0000", "est_op_end_time": ""}

ecra> workflows describe workflowId=71d3e311-a959-4ee3-b0e2-afb9fc96e29a
* {
    "workflowName": "exacompute-vaultaccessdelete-wfd",
    "workflowId": "71d3e311-a959-4ee3-b0e2-afb9fc96e29a",
    "workflowStatus": "Completed",
    "workflowStartTime": "07 Sep 2023 23:38:23 UTC",
    "workflowEndTime": "07 Sep 2023 23:39:32 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "DeleteVaultAccessDetails",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Sep 07 23:38:23 UTC 2023",
            "taskEndTime": "Thu Sep 07 23:39:31 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:01:08"
        },
        {
            "taskName": "PostDeleteVaultAccessDetails",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Sep 07 23:39:32 UTC 2023",
            "taskEndTime": "Thu Sep 07 23:39:32 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "PostDeleteVaultAccessDetails",
            "lastOperationDetails": {
                "lastTaskLastOperationId":
"0c20fbf5-e144-4396-83fc-99b9d9d807f5",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "07 Sep 2023 23:39:32 UTC",
                "lastTaskLastOperationEndTime": "07 Sep 2023 23:39:32 UTC"
            }
        }
    ],
    "exaOCID": "",
    "requestId": "5d4936cc-cb67-41b2-a4b3-bcdec268d0c1",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
```


## precheckedvvolumes

### Description:
* Perform EDV volumeMountNames Precheck.
### Usage:
`exacompute precheckedvvolumes jsonpath=<JSONPATH>`
#### Values:
` <JSONPATH> : Path to the json that contains all the volumes information`

### Examples:
```
ecra> exacompute precheckedvvolumes jsonpath=/home/ybansod/Documents/edv_precheck_input_payload.json
    * {"status":500,"message":"Exacloud response do not have uuid requestId:0f69560c-95a2-41a2-8f2e-b6517c89a756 exacloud_response: {\"wf_uuid\":\"3e523fc1-a1aa-4d59-98fb-018d3f3c5ccd\",\"status\":\"Pending\",\"success\":\"True\"}","status-detail":"Exacloud response do not have uuid requestId:0f69560c-95a2-41a2-8f2e-b6517c89a756 exacloud_response: {\"wf_uuid\":\"3e523fc1-a1aa-4d59-98fb-018d3f3c5ccd\",\"status\":\"Pending\",\"success\":\"True\"}","op":"edv_volume_mount_names_precheck_post"}
```
## snapshotmount

### Description
*Sends information to exacloud for vm snapshot mount operation*

### Usages
`exacompute snapshotmount jsonpath=<JSONPATH> idemtoken=<IDEMTOKEN> vminstanceid=<VMINSTANCEID>`

#### Values
` <JSONPATH> : Path to the JSON file that contains all the parameters for vm snapshot mount operation`
` <IDEMTOKEN> : Idemtoken for the operation, this can be provided also inside of the input payload`
` <VMINSTANCEID> :  Ocid of the domu where snapshot will be mounted `

### Examples:
```json
ecra> exacompute snapshotmount jsonpath=/ade/illamas_ECS_MAIN_LINUX.X64_new/ecs/ecra/test/scenarios/exacompute/payloads/vmrestore.json
* {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/767d29d4-05ad-472e-95bd-7eee63de2379", "op": "exacomputemsnapshot_post", "op_start_time": "2023-07-04T21:57:26+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}
```

## snapshotunmount

### Description
*Sends information to exacloud for vm snapshot unmount operation*

### Usages
`exacompute snapshotunmount jsonpath=<JSONPATH> idemtoken=<IDEMTOKEN> vminstanceid=<VMINSTANCEID>`

#### Values
` <JSONPATH> : Path to the JSON file that contains all the parameters for vm snapshot unmount operation`
` <IDEMTOKEN> : Idemtoken for the operation, this can be provided also inside of the input payload`
` <VMINSTANCEID> :  Ocid of the domu where snapshot will be unmounted `

### Examples:
```json
ecra> exacompute snapshotunmount jsonpath=/ade/illamas_ECS_MAIN_LINUX.X64_new/ecs/ecra/test/scenarios/exacompute/payloads/vmrestore.json
* {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/767d29d4-05ad-472e-95bd-7eee63de2379", "op": "exacomputeusnapshot_put", "op_start_time": "2023-07-04T21:57:26+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}
```

## listsystemvault

### Description:
* List registered system vaults

### Usages:
`exacompute listsystemvault vaultid=<VAULT_ID>`

### Arguments
- **vaultid**: [Optional] List system vault with matching vaultId

### Examples:
```json
ecra> exacompute listsystemvault
* {
    "system_vaults": [
        {
            "vaultId": "yashp",
            "fabricId": "IAD1FABRIC1",
            "referenceIdentifier": "cad",
            "vaultName": "yashvaultasd",
            "vaultCompartmentId": "cs",
            "lifecycleState": "running",
            "isSystemGenerated": true,
            "infrastructureType": "type",
            "extremeFlashSizeInGBs": "234",
            "highCapacitySizeInGBs": "234",
            "extremeFlashIops": "cad",
            "highCapacityIops": "cad"
        },
        {
            "vaultId": "yashs",
            "fabricId": "IAD1FABRIC1",
            "referenceIdentifier": "abc",
            "vaultName": "yashvaultabc",
            "vaultCompartmentId": "cstest",
            "lifecycleState": "running",
            "isSystemGenerated": true,
            "infrastructureType": "typeA",
            "extremeFlashSizeInGBs": "234",
            "highCapacitySizeInGBs": "234",
            "extremeFlashIops": "123",
            "highCapacityIops": "123"
        }
    ],
    "status": 200,
    "op": "system_vault_get",
    "status-detail": "success"
}

ecra> exacompute listsystemvault vaultid=yashs
* {
    "system_vaults": [
        {
            "vaultId": "yashs",
            "fabricId": "IAD1FABRIC1",
            "referenceIdentifier": "abc",
            "vaultName": "yashvaultabc",
            "vaultCompartmentId": "cstest",
            "lifecycleState": "running",
            "isSystemGenerated": true,
            "infrastructureType": "typeA",
            "extremeFlashSizeInGBs": "234",
            "highCapacitySizeInGBs": "234",
            "extremeFlashIops": "123",
            "highCapacityIops": "123"
        }
    ],
    "status": 200,
    "op": "system_vault_get",
    "status-detail": "success"
}
```

## updatesystemvault

### Description:
* Update system vault, given vaultId

### Usages:
`exacompute updatesystemvault vaultid=<VAULT_ID>` jsonpath=<JSON_PATH>

### Arguments
- **vaultid**: Update system vault associated with given vaultId
- **jsonpath**: Payload where update values are stored

### Examples:
```json
ecra> exacompute updatesystemvault vaultid=yashp jsonpath=/home/ybansod/Documents/updatesystemvault_payload.json
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "system_vault_update_put",
    "op_start_time": "2023-07-25T09:11:24+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d10259ad-801e-4739-97b4-1100b94836e5"
}
ecra> status d10259ad-801e-4739-97b4-1100b94836e5
* {"remote_user": "ops", "start_time": "2023-07-25T09:11:24+0000", "progress_percent": 0, "end_time": "2023-07-25T09:11:37+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-07-25T09:11:24+0000", "wf_uuid": "9ae34a0d-cf49-4565-82fb-a1946d10aa84", "status": 200, "message": "Done", "op": "systemvault-updation", "completion_percentage": 0, "atp_enabled": "N", "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d10259ad-801e-4739-97b4-1100b94836e5", "status-detail": "success"}
```

## deletesystemvault

### Description:
* Delete system vault, given vaultId

### Usages:
`exacompute Deletesystemvault vaultid=<VAULT_ID>`

### Arguments
- **vaultid**: Delete system vault associated with given vaultId

### Examples:
```json
ecra> exacompute deletesystemvault vaultid=yashp
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "system_vault_delete",
    "op_start_time": "2023-07-25T10:16:39+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/7149dcea-c81e-4aca-9ff8-f8005a59e268"
}
ecra> status 7149dcea-c81e-4aca-9ff8-f8005a59e268
* {"remote_user": "ops", "start_time": "2023-07-25T10:16:39+0000", "progress_percent": 0, "end_time": "2023-07-25T10:16:52+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-07-25T10:16:39+0000", "wf_uuid": "6419f046-7b9e-4e84-a907-98bf5bac844d", "status": 200, "message": "Done", "op": "systemvault-deletion", "completion_percentage": 0, "atp_enabled": "N", "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/7149dcea-c81e-4aca-9ff8-f8005a59e268", "status-detail": "success"}
```

## createsystemvault

### Description:
* Register system vault

### Usages:
`exacompute createsystemvault jsonpath=<JSON_PATH>`

### Arguments
- **jsonpath**: Payload path for registration API for system vault

### Examples:
```json
ecra> exacompute createsystemvault jsonpath=/home/ybansod/Documents/createsystemvault_payload.json
* {"status": 202, "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/9e5dc1c5-c4e6-4bd2-bea7-3274e2128f43", "op": "system_vault_create_post", "op_start_time": "2023-07-25T09:55:59+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}
* ecra> status 9e5dc1c5-c4e6-4bd2-bea7-3274e2128f43
* * {"remote_user": "ops", "start_time": "2023-07-25T09:55:59+0000", "progress_percent": 0, "end_time": "2023-07-25T09:56:12+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-07-25T09:55:59+0000", "wf_uuid": "dbc8dc22-446f-423b-888e-b57c16fde689", "status": 200, "message": "Done", "op": "systemvault-creation", "completion_percentage": 0, "atp_enabled": "N", "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/9e5dc1c5-c4e6-4bd2-bea7-3274e2128f43", "status-detail": "success"}
```

## getnathostnames

### Description
Returns the list of nat ips associated with the provided parameter, this could be an oracle hostname or a smartnicid.

### Usages
`exacompute getnathostnames hostname=<HOSTNAME>`

#### Values
` <HOSTNAME> : An oracle hostname or smartnicid`

### Examples
```json
ecra> exacompute getnathostnames hostname=iad103709exdd014
* {
    "nat_hostnames": [
        {
            "admin_nat_host_name": "iad103709exddu1401",
            "admin_nat_ip": "10.0.6.60",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1402",
            "admin_nat_ip": "10.1.1.232",
            "admin_vlan_tag": "100",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1403",
            "admin_nat_ip": "10.1.1.251",
            "admin_vlan_tag": "101",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1404",
            "admin_nat_ip": "10.1.2.14",
            "admin_vlan_tag": "102",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1405",
            "admin_nat_ip": "10.1.2.33",
            "admin_vlan_tag": "103",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1406",
            "admin_nat_ip": "10.1.2.52",
            "admin_vlan_tag": "104",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1407",
            "admin_nat_ip": "10.1.2.71",
            "admin_vlan_tag": "105",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1408",
            "admin_nat_ip": "10.1.2.90",
            "admin_vlan_tag": "106",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1409",
            "admin_nat_ip": "10.1.2.109",
            "admin_vlan_tag": "107",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1410",
            "admin_nat_ip": "10.1.2.128",
            "admin_vlan_tag": "108",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1411",
            "admin_nat_ip": "10.1.2.147",
            "admin_vlan_tag": "109",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1412",
            "admin_nat_ip": "10.1.2.166",
            "admin_vlan_tag": "110",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        }
    ],
    "op": "exacompute_getnathostnames_get",
    "status": 200,
    "status-detail": "success"
}

ecra> exacompute getnathostnames hostname=4.0G2001-GBC001453
* {
    "nat_hostnames": [
        {
            "admin_nat_host_name": "iad103709exddu1401",
            "admin_nat_ip": "10.0.6.60",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1402",
            "admin_nat_ip": "10.1.1.232",
            "admin_vlan_tag": "100",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1403",
            "admin_nat_ip": "10.1.1.251",
            "admin_vlan_tag": "101",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1404",
            "admin_nat_ip": "10.1.2.14",
            "admin_vlan_tag": "102",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1405",
            "admin_nat_ip": "10.1.2.33",
            "admin_vlan_tag": "103",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1406",
            "admin_nat_ip": "10.1.2.52",
            "admin_vlan_tag": "104",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1407",
            "admin_nat_ip": "10.1.2.71",
            "admin_vlan_tag": "105",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1408",
            "admin_nat_ip": "10.1.2.90",
            "admin_vlan_tag": "106",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1409",
            "admin_nat_ip": "10.1.2.109",
            "admin_vlan_tag": "107",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1410",
            "admin_nat_ip": "10.1.2.128",
            "admin_vlan_tag": "108",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1411",
            "admin_nat_ip": "10.1.2.147",
            "admin_vlan_tag": "109",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        },
        {
            "admin_nat_host_name": "iad103709exddu1412",
            "admin_nat_ip": "10.1.2.166",
            "admin_vlan_tag": "110",
            "db_backup_mac": "02:00:17:01:de:be",
            "db_client_mac": "00:10:21:fc:51:6f"
        }
    ],
    "op": "exacompute_getnathostnames_get",
    "status": 200,
    "status-detail": "success"
}
```

## updatefleetnode

### Description:
* Update metadata in ecs_hw_nodes table of corresponding hostname with values from payload and update fleet state-store

### Usage:
`exacompute updatefleetnode hostname=<ORACLE_HOSTNAME> jsonpath=<JSONPATH>`

### Arguments:
- **hostname**: oracle_hostname of node from ecs_hw_nodes to be updated
- **jsonpath**: Payload containing values to be updated

### Examples:
```json
 ecra> exacompute updatefleetnode hostname=sea201108exdd005 jsonpath=/home/ybansod/Documents/nodeaddition_payload.json
 * {
     "est_op_end_time": "",
     "message": "processing",
     "op": "fleet_hardware_node_put",
     "op_start_time": "2023-10-23T11:59:37+0000",
     "status": 202,
     "status-detail": "processing",
     "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d6cf2254-1130-498a-9e84-ddc1c0ef12f0"
 }
 ecra> status d6cf2254-1130-498a-9e84-ddc1c0ef12f0
 * {"remote_user": "ops", "start_time": "2023-10-23T11:59:37+0000", "progress_percent": 0, "end_time": "2023-10-23T11:59:51+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-10-23T11:59:37+0000", "wf_uuid": "aa58effe-5316-4539-8a1a-5a03fa274b68", "status": 200, "message": "Done", "op": "node-update-fleet-add", "completion_percentage": 0, "status_uri": "http://phoenix121588.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d6cf2254-1130-498a-9e84-ddc1c0ef12f0", "status-detail": "success"}
 ecra> workflows describe workflowId=aa58effe-5316-4539-8a1a-5a03fa274b68
 * {
     "workflowName": "hardware-nodes-mgmt-wfd",
     "workflowId": "aa58effe-5316-4539-8a1a-5a03fa274b68",
     "workflowStatus": "Completed",
     "workflowStartTime": "23 Oct 2023 11:59:37 UTC",
     "workflowEndTime": "23 Oct 2023 11:59:37 UTC",
     "wfRollbackMode": false,
     "wfErrorMessage": "",
     "tasks": [
         {
             "taskName": "HardwareNodesEcraUpdate",
             "taskStatus": "COMPLETE",
             "taskStartTime": "Mon Oct 23 11:59:37 UTC 2023",
             "taskEndTime": "Mon Oct 23 11:59:37 UTC 2023",
             "taskErrorMessage": "",
             "taskElapsed": "00:00:00"
         },
         {
             "taskName": "HardwareNodesStateStoreUpdate",
             "taskStatus": "COMPLETE",
             "taskStartTime": "Mon Oct 23 11:59:37 UTC 2023",
             "taskEndTime": "Mon Oct 23 11:59:37 UTC 2023",
             "taskErrorMessage": "",
             "taskElapsed": "00:00:00"
         },
         {
             "lastTaskName": "HardwareNodesStateStoreUpdate",
             "lastOperationDetails": {
                 "lastTaskLastOperationId": "256f552a-40d9-4f62-b66e-a991bf028a39",
                 "lastTaskLastOperationName": "EXECUTE",
                 "lastTaskLastOperationStatus": "SUCCESS",
                 "lastTaskLastOperationStartTime": "23 Oct 2023 11:59:37 UTC",
                 "lastTaskLastOperationEndTime": "23 Oct 2023 11:59:37 UTC"
             }
         }
     ],
     "exaOCID": "",
     "requestId": "d6cf2254-1130-498a-9e84-ddc1c0ef12f0",
     "isWorkflowsPaused": false,
     "WFServerOwner": "EcraServer1",
     "status": 200,
     "op": "wf_describe",
     "status-detail": "success"
 }
```

## clusterdetail

### Description:
* Returns the detailed information about vm instances in the cluster

### Usage:
`exacompute clusterdetail vmclusterid=<VMCLUSTERID>`

### Arguments:
- **vmclusterid**: OCID from CP that points to the rack

### Examples:
```json
 ecra> exacompute clusterdetail vmclusterid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d235
* {
    "op": "exacompute_detail_vmclusters_get",
    "status": 200,
    "status-detail": "success",
    "vms": [
        {
            "cpu": {
                "className": "CpuResource",
                "reservedCores": 6,
                "used": 5,
                "value": 50
            },
            "extremeFlashStorage": {
                "className": "ExtremeFlashStorageResource",
                "used": 0,
                "value": 0
            },
            "highCapacityStorage": {
                "className": "HighCapacityStorageResource",
                "used": 4402,
                "value": 0
            },
            "id": "Exacomp-vm-instance-8922a56af033464ca9ff952649a9525a199",
            "memory": {
                "className": "MemoryResource",
                "reservedMemory": 17000000000,
                "used": 16000000000,
                "value": 1390000000000
            },
            "network": {
                "backupNetwork": {
                    "dom0OracleName": "iad103709exdd018",
                    "domUOracleName": "iad103709exddu1802.sea2mvm01roce.adminsea2.oraclevcn.com",
                    "domainName": "exacomputebacku.jboduvcn.oraclevcn.com",
                    "gateway": "10.0.11.1",
                    "hostName": "testVmclusterDemo009backup1-vip145",
                    "ip": "10.0.11.85",
                    "macAddress": "00:00:17:01:55:1C",
                    "netmask": "255.255.255.0",
                    "standbyVnicMac": "00:00:17:01:04:4A",
                    "vlantag": 2
                },
                "clientNetwork": {
                    "dom0OracleName": "iad103709exdd018",
                    "domUOracleName": "iad103709exddu1802.sea2mvm01roce.adminsea2.oraclevcn.com",
                    "domainName": "exacomputecusto.jboduvcn.oraclevcn.com",
                    "gateway": "10.0.10.1",
                    "hostName": "testVmclusterDemo009client1-vip145",
                    "ip": "10.0.10.85",
                    "macAddress": "00:00:17:01:6F:C4",
                    "netmask": "255.255.255.0",
                    "standbyVnicMac": "02:00:17:01:10:9A",
                    "vlantag": 1
                },
                "vipNetwork": {
                    "dom0OracleName": null,
                    "domUOracleName": null,
                    "domainName": "exacomputecusto.jboduvcn.oraclevcn.com",
                    "gateway": null,
                    "hostName": "testVmclusterDemo0091-vip",
                    "ip": "10.0.10.83",
                    "macAddress": null,
                    "netmask": null,
                    "standbyVnicMac": null,
                    "vlantag": 0
                }
            },
            "state": "RUNNING",
            "storageLocal": {
                "className": "StorageLocalResource",
                "used": 10000000000,
                "value": 2340000000000
            },
            "vmClusterId": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d235",
            "volumes": [
                {
                    "volumedevicepath": "system_xyz1",
                    "volumeid": "1ghi",
                    "volumename": "CPGCV1",
                    "volumesizegb": "32",
                    "volumetype": "gcv"
                },
                {
                    "volumedevicepath": "system_xyz1",
                    "volumeid": "1def",
                    "volumename": "cpGi1",
                    "volumesizegb": "50",
                    "volumetype": "gi"
                },
                {
                    "volumedevicepath": "system_xyz1",
                    "volumeid": "1abc",
                    "volumename": "cpSystem1",
                    "volumesizegb": "3420",
                    "volumetype": "system"
                },
                {
                    "volumedevicepath": "system_xyz1",
                    "volumeid": "1jkl",
                    "volumename": "CPu021",
                    "volumesizegb": "900",
                    "volumetype": "u02"
                }
            ]
        },
        {
            "cpu": {
                "className": "CpuResource",
                "reservedCores": 6,
                "used": 5,
                "value": 50
            },
            "extremeFlashStorage": {
                "className": "ExtremeFlashStorageResource",
                "used": 0,
                "value": 0
            },
            "highCapacityStorage": {
                "className": "HighCapacityStorageResource",
                "used": 4407,
                "value": 0
            },
            "id": "Exacomp-vm-instance-00098470a9964abe9a6609fd8a9042c4135",
            "memory": {
                "className": "MemoryResource",
                "reservedMemory": 17000000000,
                "used": 16000000000,
                "value": 1390000000000
            },
            "network": {
                "backupNetwork": {
                    "dom0OracleName": "iad103709exdd013",
                    "domUOracleName": "iad103709exddu1302.sea2mvm01roce.adminsea2.oraclevcn.com",
                    "domainName": "exacomputebacku.jboduvcn.oraclevcn.com",
                    "gateway": "10.0.11.1",
                    "hostName": "testVmclusterDemo009backup2-vip116",
                    "ip": "10.0.11.45",
                    "macAddress": "00:00:17:01:F2:71",
                    "netmask": "255.255.255.0",
                    "standbyVnicMac": "00:00:17:01:BE:9B",
                    "vlantag": 2
                },
                "clientNetwork": {
                    "dom0OracleName": "iad103709exdd013",
                    "domUOracleName": "iad103709exddu1302.sea2mvm01roce.adminsea2.oraclevcn.com",
                    "domainName": "exacomputecusto.jboduvcn.oraclevcn.com",
                    "gateway": "10.0.10.1",
                    "hostName": "testVmclusterDemo009client2-vip116",
                    "ip": "10.0.10.215",
                    "macAddress": "00:00:17:01:89:05",
                    "netmask": "255.255.255.0",
                    "standbyVnicMac": "00:00:17:01:F9:7F",
                    "vlantag": 1
                },
                "vipNetwork": {
                    "dom0OracleName": null,
                    "domUOracleName": null,
                    "domainName": "exacomputecusto.jboduvcn.oraclevcn.com",
                    "gateway": null,
                    "hostName": "testVmclusterDemo0092-vip",
                    "ip": "10.0.10.154",
                    "macAddress": null,
                    "netmask": null,
                    "standbyVnicMac": null,
                    "vlantag": 0
                }
            },
            "state": "RUNNING",
            "storageLocal": {
                "className": "StorageLocalResource",
                "used": 10000000000,
                "value": 2340000000000
            },
            "vmClusterId": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d235",
            "volumes": [
                {
                    "volumedevicepath": "system_xyz2",
                    "volumeid": "2ghi",
                    "volumename": "CPGCV2",
                    "volumesizegb": "32",
                    "volumetype": "gcv"
                },
                {
                    "volumedevicepath": "system_xyz2",
                    "volumeid": "2def",
                    "volumename": "cpGi2",
                    "volumesizegb": "50",
                    "volumetype": "gi"
                },
                {
                    "volumedevicepath": "system_xyz2",
                    "volumeid": "2abc",
                    "volumename": "cpSystem2",
                    "volumesizegb": "3425",
                    "volumetype": "system"
                },
                {
                    "volumedevicepath": "system_xyz2",
                    "volumeid": "2jkl",
                    "volumename": "CPu022",
                    "volumesizegb": "900",
                    "volumetype": "u02"
                }
            ]
        }
    ]
}
```
## securevms

### Description
*The API remove access keys for provided vm*

### Usages
`exacompute securevms vmclusterid=<VMCLUSTERID>`

#### Values
` <VMCLUSTERID>  : OCID from CP that points to the rack`
` payload : payload path`
` idemtoken  : idemtoken`

### Examples:
```json
ecra> exacompute securevms vmclusterid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d185
        * {
            "est_op_end_time": "",
            "exaunit_id": 37,
            "message": "processing",
            "op": "exacompute_securevms_post",
            "op_start_time": "2024-02-14T16:26:42+0000",
            "status": 202,
            "status-detail": "processing",
            "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/2229893d-d290-4fa1-8945-caecf1c57f78"
        }

        ecra> status 2229893d-d290-4fa1-8945-caecf1c57f78
        * {"start_time": "2024-02-14T16:26:42+0000", "progress_percent": 0, "exaunit_id": 37, "start_time_ts": "2024-02-14 16:26:42.0",
        "ecra_server": "EcraServer1", "last_heartbeat_update": "2024-02-14T16:26:42+0000", "wf_uuid": "a90ea8a3-4c3e-4140-b326-f72ec225a5ee",
        "status": 202, "message": "Pending", "op": "SecureVMs", "completion_percentage": 0,
        "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/2229893d-d290-4fa1-8945-caecf1c57f78",
        "op_start_time": "2024-02-14T16:26:59+0000", "est_op_end_time": ""}

        ecra> exacompute securevms vmclusterid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d185 payload=/ade/zpallare_ztest_2/ecs/ecra/test/scenarios/mvm/create_infra.json
        * {
            "est_op_end_time": "",
            "exaunit_id": 37,
            "message": "processing",
            "op": "exacompute_securevms_post",
            "op_start_time": "2024-02-14T20:14:46+0000",
            "status": 202,
            "status-detail": "processing",
            "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/c4a81d9d-3b96-4ed3-9b74-cb8f0cc1a88e"
        }


```

## removenodexml

### Description
*Removes information in the rack updated XML, related to the provided dom0.*

### Usages
`exacompute removenodexml rackname=<RACKNAME> dom0=<Dom0>`

#### Values
` <RACKNAME>  : Name of the rack that you want to remove the dom0 information`
` <Dom0>      : oracle_hostname of the dom0 that you want to remove from the XML`

### Examples:
```json
	ecra> exacompute removenodexml rackname=exacompute-sea2-d2-33cdb0c4-6c49-4a75-a653-c7a5e6c98fac-clu01 dom0=sea201610exdd009
        * {
            "status": 202,
            "status_uri": "http://atp-ecra6.emmgmt.adminsea2.oraclevcn.com:9080/ecra/endpoint/statuses/bb27c009-71a2-4a80-8ff2-5ac6fe7ca746",
            "op": "exacomputeremovexml_put",
            "op_start_time": "2024-07-19T19:02:32+0000",
            "est_op_end_time": "",
            "message": "processing",
            "status-detail": "processing"
        }

```

## configureroceips

### Description
*Configure RoCE IPs on the KVM host.*

### Usages
`exacompute configureroceips hostname=<HOSTNAME> [idemtoken=token]`

#### Values
` <HOSTNAME> : Name of the node
  [idemtoken] : Optional idemtoken value`

### Examples:
```json
ecra> exacompute configureroceips hostname=iad103496exdd012
       * {
          "est_op_end_time": "",
          "message": "processing",
          "op": "exascale_roceip_configure_post",
          "op_start_time": "2024-08-05T23:30:10+0000",
          "status": 202,
          "status-detail": "processing",
          "status_uri": "http://iad1pprdedcsecra1.ecramgmt.adminiad1.oraclevcn.com:9149/ecra/endpoint/statuses/9af7a0cb-8c4a-41d1-88db-1bfae37919e1"
         } 

```

## deconfigureroceips

### Description
*Deconfigures RoCE IPs on the KVM hosts.*

### Usages
`exacompute deconfigureroceips hostname=<HOSTNAME> [idemtoken=<IDEMTOKEN>]`

#### Values
`<HOSTNAME> : Name of the node`
`<IDEMTOKEN>: Optional idemtoken value`

### Examples:
```json
	ecra> exacompute deconfigureroceips hostname=iad103709exdd007
    * {
        "est_op_end_time": "",
        "message": "processing",
        "op": "exa_roceip_deconf_post",
        "op_start_time": "2024-08-07T23:28:11+0000",
        "status": 202,
        "status-detail": "processing",
        "status_uri": "http://localhost:9067/ecra/endpoint/statuses/a5503e3c-3476-4ca9-8d7e-4fcff8ef1f12"
    }
```


## nodedetail 

### Description
*Display all information about the kvm host on exacompute fleet*

### Usages
`exacompute nodedetail [page=<page> pagesize=<page size> servicetype=<exacompute>]`

#### Values
`<page> : number of page for pagination, 0 disables the pagination`
`<pagesize> : number of dom0 in the page`
`<servicetype> : service type on dom0

### Examples:
```json
ecra> exacompute nodedetail
* {
  "computes": [
    {
      "hostname": "iad103709exdd018",
      "imageversion": "19.2.6.0.0.190911.1",
      "maintenancedomainid": 1,
      "clustertag": "ALL",
      "nodemodel": "X8M-2",
      "fabricname": "SEAFABRIC1",
      "totalecpu": 60,
      "allocatedecpu": 48,
      "activevmslots": 1,
      "vms": [
        {
          "clustername": "testVmclusterDemo01014",
          "clusterocid": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d207",
          "rackname": "exacompute-iad1-d2-7381df85-d9d6-4057-a165-e134106d2a04-clu01",
          "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq",
          "domuversion": "3.1.9.0.0.231214.2",
          "totalecpu": 60,
          "enabledecpu": 48,
          "vminstanceocid": "Exacomp-vm-instance-8922a56af033464ca9ff952649a9525a300",
          "gcv": 2,
          "system": 114,
          "u01": 42,
          "u02": 62
        }
      ]
    },
    {
      "hostname": "iad103709exdd017",
      "imageversion": "19.2.6.0.0.190911.1",
      "maintenancedomainid": 1,
      "clustertag": "ALL",
      "nodemodel": "X8M-2",
      "fabricname": "SEAFABRIC1",
      "totalecpu": 60,
      "allocatedecpu": 48,
      "activevmslots": 1,
      "vms": [
        {
          "clustername": "testVmclusterDemo01014",
          "clusterocid": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d207",
          "rackname": "exacompute-iad1-d2-7381df85-d9d6-4057-a165-e134106d2a04-clu01",
          "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq",
          "domuversion": "3.1.9.0.0.231214.2",
          "totalecpu": 60,
          "enabledecpu": 48,
          "vminstanceocid": "Exacomp-vm-instance-00098470a9964abe9a6609fd8a9042c488",
          "gcv": 2,
          "system": 114,
          "u01": 42,
          "u02": 62
        }
      ]
    },
    {
      "hostname": "iad103709exdd016",
      "imageversion": "19.2.6.0.0.190911.1",
      "maintenancedomainid": 1,
      "clustertag": "ALL",
      "nodemodel": "X8M-2",
      "fabricname": "SEAFABRIC1",
      "totalecpu": 60,
      "allocatedecpu": 48,
      "activevmslots": 1,
      "vms": [
        {
          "clustername": "testVmclusterDemo01014",
          "clusterocid": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d207",
          "rackname": "exacompute-iad1-d2-7381df85-d9d6-4057-a165-e134106d2a04-clu01",
          "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq",
          "domuversion": "3.1.9.0.0.231214.2",
          "totalecpu": 60,
          "enabledecpu": 48,
          "vminstanceocid": "Exacomp-vm-instance-8922a56af033464ca9ff952649a9525abc1",
          "gcv": 2,
          "system": 114,
          "u01": 42,
          "u02": 62
        }
      ]
    }
  ],
  "status": 200,
  "op": "exacomputenodedetail_get",
  "status-detail": "success"
}
```

## updatefabricfleet

### Description
*Updates fabrics in fleet JSON. This command helps you to add or delete a fabric in the fleet JSON.*

### Usages
`exacompute updatefabricfleet fabricname=<FABRICID> operation=<OPERATION> [cloudvendor=<name> cloudproviderregion=<region> cloudproviderbuilding=<building> cloudprovideraz=<az> sitegroup=<sitegroup>]`

#### Values
`<HOSTNAME> : Name of the fabric`
`<IDEMTOKEN>: add or delete`
`cloudvendor: name of vendor`
`cloudproviderregion: region` 
`cloudproviderbuilding: building` 
`cloudprovideraz: az`
`sitegroup: sitegroup`

### Examples:
```json
	ecra> exacompute updatefabricfleet fabricname=IAD1FABRIC3 operation=add
        * {
            "est_op_end_time": "",
            "message": "processing",
            "op": "exacomputeupdatesfabric_post",
            "op_start_time": "2024-11-06T16:52:30+0000",
            "status": 202,
            "status-detail": "processing",
            "status_uri": "http://localhost:9067/ecra/endpoint/statuses/b512ade3-316e-4d0f-85ad-f2134be9c7f6"
        }
        ecra> exacompute updatefabricfleet fabricname=IAD1FABRIC3 operation=delete
        * {
            "est_op_end_time": "",
            "message": "processing",
            "op": "exacomputeupdatesfabric_post",
            "op_start_time": "2024-11-06T17:01:34+0000",
            "status": 202,
            "status-detail": "processing",
            "status_uri": "http://localhost:9067/ecra/endpoint/statuses/10cc9454-e981-44e8-97b8-347fb787a145"
        }
```


## clusterhistory
### Description
Displays all the information about the cluster deleted for exacompute racks

### Usage 
    exacompute clusterhistory rackname=<RACKNAME>
### Values
- rackname: name of the rack already deleted
### Example:

```json
ecra> exacompute clusterhistory rackname=exacompute-iad1-d2-1bf82b80-bb67-4d74-ad3a-781b1964e989-clu01
* {
  "computes": [
    {
      "hostname": "iad103709exdd018",
      "imageversion": "19.2.6.0.0.190911.1",
      "maintenancedomainid": 1,
      "clustertag": "ALL",
      "nodemodel": "X8M-2",
      "fabricname": "SEAFABRIC1",
      "totalecpu": 60,
      "allocatedecpu": 48,
      "activevmslots": 1,
      "vms": [
        {
          "clustername": "testVmclusterDemo010150",
          "clusterocid": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d18",
          "rackname": "exacompute-iad1-d2-1bf82b80-bb67-4d74-ad3a-781b1964e989-clu01",
          "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq",
          "domuversion": "3.1.9.0.0.231214.2",
          "totalecpu": 60,
          "enabledecpu": 48,
          "vminstanceocid": "Exacomp-vm-instance-8922a56af033464ca9ff952649a9525a226",
          "gcv": 2,
          "system": 114,
          "u01": 42,
          "u02": 62
        }
      ]
    },
    {
      "hostname": "iad103709exdd017",
      "imageversion": "19.2.6.0.0.190911.1",
      "maintenancedomainid": 1,
      "clustertag": "ALL",
      "nodemodel": "X8M-2",
      "fabricname": "SEAFABRIC1",
      "totalecpu": 60,
      "allocatedecpu": 48,
      "activevmslots": 1,
      "vms": [
        {
          "clustername": "testVmclusterDemo010150",
          "clusterocid": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d18",
          "rackname": "exacompute-iad1-d2-1bf82b80-bb67-4d74-ad3a-781b1964e989-clu01",
          "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq",
          "domuversion": "3.1.9.0.0.231214.2",
          "totalecpu": 60,
          "enabledecpu": 48,
          "vminstanceocid": "Exacomp-vm-instance-00098470a9964abe9a6609fd8a9042c4149",
          "gcv": 2,
          "system": 114,
          "u01": 42,
          "u02": 62
        }
      ]
    },
    {
      "hostname": "iad103709exdd016",
      "imageversion": "19.2.6.0.0.190911.1",
      "maintenancedomainid": 1,
      "clustertag": "ALL",
      "nodemodel": "X8M-2",
      "fabricname": "SEAFABRIC1",
      "totalecpu": 60,
      "allocatedecpu": 48,
      "activevmslots": 1,
      "vms": [
        {
          "clustername": "testVmclusterDemo010150",
          "clusterocid": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d18",
          "rackname": "exacompute-iad1-d2-1bf82b80-bb67-4d74-ad3a-781b1964e989-clu01",
          "tenancyocid": "ocid1.tenancy.oc1..aaaaaaaa5wztl2qlgueiumbtn52zx5lzgwur2ixkmpjdmib2o6nuhj6kfksq",
          "domuversion": "3.1.9.0.0.231214.2",
          "totalecpu": 60,
          "enabledecpu": 48,
          "vminstanceocid": "Exacomp-vm-instance-8922a56af033464ca9ff952649a9525abc1",
          "gcv": 2,
          "system": 114,
          "u01": 42,
          "u02": 62
        }
      ]
    }
  ],
  "status": 200,
  "op": "exacomputeclusterhistory_get",
  "status-detail": "success"
}
```

## computecleanup
### Description
Clean up all related data left by exacloud on the compute

### Usage 
    exacompute computecleanup hostname=<compute hostname>
### Values
- hostname: dom0 admin hostname
### Example:

```json
ecra> exacompute computecleanup hostname=iad103709exdd010
* {"status": 202, "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/2d59586f-4de7-4bce-bef0-18eddfa10062",
"op": "exacomputecomputecleanup", "op_start_time": "2025-03-04T18:32:05+0000",
"est_op_end_time": "", "message": "processing", "status-detail": "processing"}
ecra> status 2d59586f-4de7-4bce-bef0-18eddfa10062
* {"progress_percent": 0, "start_time": "2025-03-04T18:32:05+0000",
"start_time_ts": "2025-03-04 18:32:05.0", "end_time":
"2025-03-04T18:32:06+0000", "ecra_server": "EcraServer1",
"last_heartbeat_update": "2025-03-04T18:32:05+0000", "wf_uuid":
"ce739303-cee1-4036-9968-4939fa2fc958", "status": 200, "message": "Done", "op":
"exacomputecomputecleanup", "completion_percentage": 0, "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/2d59586f-4de7-4bce-bef0-18eddfa10062",
"status-detail": "success"}
ecra> workflows describe workflowId=ce739303-cee1-4036-9968-4939fa2fc958
* {
    "workflowName": "exacompute-compute-cleanup-wfd",
    "workflowId": "ce739303-cee1-4036-9968-4939fa2fc958",
    "workflowStatus": "Completed",
    "workflowStartTime": "04 Mar 2025 18:32:06 UTC",
    "workflowEndTime": "04 Mar 2025 18:32:06 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "LoadComputeToCleanupTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Tue Mar 04 18:32:06 UTC 2025",
            "taskEndTime": "Tue Mar 04 18:32:06 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "taskName": "ComputeCleanupTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Tue Mar 04 18:32:06 UTC 2025",
            "taskEndTime": "Tue Mar 04 18:32:06 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "taskName": "EndWf",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Tue Mar 04 18:32:06 UTC 2025",
            "taskEndTime": "Tue Mar 04 18:32:06 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "EndWf",
            "lastOperationDetails": {
                "lastTaskLastOperationId":
"b27d4e53-8741-4823-8301-61fc87e30551",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "04 Mar 2025 18:32:06 UTC",
                "lastTaskLastOperationEndTime": "04 Mar 2025 18:32:06 UTC"
            }
        }
    ],
    "workflowElapsed": "00:00:00",
    "workflowRuntime": "00:00:00",
    "exaOCID": "",
    "requestId": "2d59586f-4de7-4bce-bef0-18eddfa10062",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
```

## dbvolumes
### Description
Execute dbvolume operations on the vm cluster

### Usage
    exacompute dbvolumes vmclusterocid=<vm cluster ocid> operation=<attach|detach|resize> jsonpath=<Path to payload>
### Values
- vmclusterocid: vm cluster ocid
- operation: operations on the dbvolumes, attach, detach, resize
- jsonpath: payload for the operation
### Example:

```json
ecra> exacompute dbvolumes operation=attach
jsonpath=/scratch/jzandate/scripts/exacompute/attachdb.json
vmclusterocid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d67
* {"status": 202, "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/7ba5f3cf-a7aa-40a2-bb8f-ba93a8ea2a09",
"op": "exacompute_volume_post", "op_start_time": "2025-05-15T18:08:00+0000",
"est_op_end_time": "", "message": "processing", "status-detail": "processing",
"exaunit_id": 1796}
ecra> status 7ba5f3cf-a7aa-40a2-bb8f-ba93a8ea2a09
* {"progress_percent": 0, "exaunit_id": 1796, "start_time_ts": "2025-05-15
18:08:00.0", "end_time": "2025-05-15T18:08:06+0000", "ecra_server":
"EcraServer1", "wf_uuid": "5a4dacba-3a70-4344-ae64-3175c822e056", "start_time":
"2025-05-15T18:08:00+0000", "last_heartbeat_update": "2025-05-15T18:08:00+0000",
"status": 200, "message": "Done", "op": "exacompute_volume_post",
"completion_percentage": 0, "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/7ba5f3cf-a7aa-40a2-bb8f-ba93a8ea2a09",
"status-detail": "success"}
ecra> workflows describe workflowId=5a4dacba-3a70-4344-ae64-3175c822e056
* {
    "workflowName": "dbvol-attach-dettach-resize-wdf",
    "workflowId": "5a4dacba-3a70-4344-ae64-3175c822e056",
    "workflowStatus": "Completed",
    "workflowStartTime": "15 May 2025 18:08:00 UTC",
    "workflowEndTime": "15 May 2025 18:08:06 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "InitDBVolume",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu May 15 18:08:00 UTC 2025",
            "taskEndTime": "Thu May 15 18:08:00 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "taskName": "ATTACH",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu May 15 18:08:00 UTC 2025",
            "taskEndTime": "Thu May 15 18:08:06 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:06"
        },
        {
            "taskName": "EndWf",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu May 15 18:08:06 UTC 2025",
            "taskEndTime": "Thu May 15 18:08:06 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "EndWf",
            "lastOperationDetails": {
                "lastTaskLastOperationId":
"c1450dd9-5daa-45d1-a975-7eae28bd80a6",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "15 May 2025 18:08:06 UTC",
                "lastTaskLastOperationEndTime": "15 May 2025 18:08:06 UTC"
            }
        }
    ],
    "workflowElapsed": "00:00:06",
    "workflowRuntime": "00:00:06",
    "exaOCID": "",
    "requestId": "7ba5f3cf-a7aa-40a2-bb8f-ba93a8ea2a09",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
ecra> exacompute getvolumes
rackname=exacompute-iad1-d2-0071c367-35be-47ce-8a79-981d0e2f6db2-clu01
* {
    "nodes": [
        {
            "oraclehostname": "iad103709exdd018",
            "clienthostname":
"testVmclusterDemo009client1-vip227.exacomputecusto.jboduvcn.oraclevcn.com",
            "volumes": [
                {
                    "volumeid": "1mno",
                    "volumetype": "DBVOLUME",
                    "volumename": "givol",
                    "volumedevicepath": "system_xyz1",
                    "guestdevicename": "dbvolume_system_xyz1-givol",
                    "volumesizegb": "104"
                },
                {
                    "volumeid": "1ghi",
                    "volumetype": "GCV",
                    "volumename": "gcv",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "2"
                },
                {
                    "volumeid": "1abc",
                    "volumetype": "SYSTEM",
                    "volumename": "system",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "114"
                },
                {
                    "volumeid": "1def",
                    "volumetype": "U01",
                    "volumename": "u01",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "42"
                },
                {
                    "volumeid": "1jkl",
                    "volumetype": "U02",
                    "volumename": "u02",
                    "volumedevicepath": "system_xyz1",
                    "volumesizegb": "124"
                },
                {
                    "volumetype": "dbvolume",
                    "volumename": "dbvolume-DB0425-kaommq-datavol",
                    "volumedevicepath":
"dbvolume-DB0425-kaommq-datavol_Vmfoyxy_1",
                    "guestdevicename": "dbvolume-DB0425-kaommq-datavol",
                    "volumesizegb": "400"
                }
            ]
        },
        {
            "oraclehostname": "iad103716exdd017",
            "clienthostname":
"testVmclusterDemo009client2-vip127.exacomputecusto.jboduvcn.oraclevcn.com",
            "volumes": [
                {
                    "volumeid": "2ghi",
                    "volumetype": "GCV",
                    "volumename": "gcv",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "2"
                },
                {
                    "volumeid": "2abc",
                    "volumetype": "SYSTEM",
                    "volumename": "system",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "114"
                },
                {
                    "volumeid": "2def",
                    "volumetype": "U01",
                    "volumename": "u01",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "42"
                },
                {
                    "volumeid": "2jkl",
                    "volumetype": "U02",
                    "volumename": "u02",
                    "volumedevicepath": "system_xyz2",
                    "volumesizegb": "124"
                },
                {
                    "volumetype": "dbvolume",
                    "volumename": "dbvolume-DB0425-kaommq-datavol",
                    "volumedevicepath":
"dbvolume-DB0425-kaommq-datavol_Vmfoyxy_2",
                    "guestdevicename": "dbvolume-DB0425-kaommq-datavol",
                    "volumesizegb": "400"
                }
            ]
        }
    ],
    "status": 200,
    "op": "exacompute_volumes_get",
    "status-detail": "success"
}
```
## runfleetjsoncheck
### Description
Execute a sanity check on the latest fleet json state

### Usage
    exacompute runfleetjsoncheck
### Values
### Example:

```json
ecra> exacompute runfleetjsoncheck
* {"status": 200, "status_uri": "http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/1e4b1b84-15de-45dd-9ce9-51799a01a463", "op": "fleetstate_sanitycheck", "op_start_time": "2025-06-27T16:11:21+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}
ecra> status 1e4b1b84-15de-45dd-9ce9-51799a01a463
* {"progress_percent": 0, "start_time": "2025-06-27T16:11:21+0000", "start_time_ts": "2025-06-27 16:11:21.0", "end_time": "2025-06-27T16:11:39+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2025-06-27T16:11:21+0000", "wf_uuid": "bdafc384-ee28-435e-bdca-c49b89f69548", "status": 200, "message": "Done", "op": "fleetstate_sanitycheck", "status_uri": "http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/1e4b1b84-15de-45dd-9ce9-51799a01a463", "status-detail": "success", "progress": 0, "progress_details": {"job_id": "1e4b1b84-15de-45dd-9ce9-51799a01a463", "wf_details": {"total_tasks": 2, "completed_tasks": 1, "current_task": "EndWf", "current_task_completion_percentage": 0, "current_task_state": "DONE", "last_updated": "2025-06-27 16:11:39"}}}
ecra> workflows describe workflowId=bdafc384-ee28-435e-bdca-c49b89f69548
* {
    "workflowName": "fleet-state-sanity-check-wfd",
    "workflowId": "bdafc384-ee28-435e-bdca-c49b89f69548",
    "workflowStatus": "Completed",
    "workflowStartTime": "27 Jun 2025 16:11:21 UTC",
    "workflowEndTime": "27 Jun 2025 16:11:39 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "FleetStateSanityCheckTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Fri Jun 27 16:11:21 UTC 2025",
            "taskEndTime": "Fri Jun 27 16:11:39 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:18"
        },
        {
            "taskName": "EndWf",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Fri Jun 27 16:11:39 UTC 2025",
            "taskEndTime": "Fri Jun 27 16:11:39 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "EndWf",
            "lastOperationDetails": {
                "lastTaskLastOperationId": "20e0342b-ba70-4c28-ab9f-9aa921f36249",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "27 Jun 2025 16:11:39 UTC",
                "lastTaskLastOperationEndTime": "27 Jun 2025 16:11:39 UTC"
            }
        }
    ],
    "workflowElapsed": "00:00:18",
    "workflowRuntime": "00:00:18",
    "exaOCID": "",
    "requestId": "1e4b1b84-15de-45dd-9ce9-51799a01a463",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
```

## getdomus
### Description
*Be able to get a report for each DomU that is on a exacompoute Dom0 and which type they are.*

### Usage
`exacompute getdomus hostname=<HOSTNAME>`
### Values
### Example
```json
ecra> exacompute getdomus hostname=iad103709exdd004
* {
    "total": 2,
    "total19c": 1,
    "total23ai": 1,
    "totalggcs": 0,
    "totalbasedb": 0,
    "guests": [
        {
            "clienthostname": "testVmclusterDemo009client2-vip172",
            "nathostname": "iad103709exddu0402",
            "adminvlan": "100"
        },
        {
            "clienthostname": "testVmclusterDemo009client2-vip287",
            "nathostname": "iad103709exddu0401"
        }
    ],
    "status": 200,
    "op": "exacomputenodecomposition_get",
    "status-detail": "success"
}
```

## getvmclusterdetails
### Description
*Be able to get the details from a exacompute vmcluster, like the filesystem file*

### Usage
`exacompute getvmclusterdetails vmclusterocid=<VMCLUSTEROCID>`
### Values
### Example
```json
ecra> exacompute getvmclusterdetails vmclusterocid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d99
* {
    "vms": [
        {
            "id": "Exacomp-vm-instance-8922a56af033464ca9ff952649a9525a121",
            "vmClusterId": "ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d99",
            "volumes": [
                {
                    "volumetype": "u01",
                    "volumesizegb": "42",
                    "filesystems": [
                        {
                            "fstype": "/u01",
                            "currfsgb": "40"
                        }
                    ]
                },
                {
                    "volumetype": "gcv",
                    "volumesizegb": "2"
                },
                {
                    "volumetype": "u02",
                    "volumesizegb": "62",
                    "filesystems": [
                        {
                            "fstype": "/u02",
                            "currfsgb": "60"
                        }
                    ]
                },
                {
                    "volumetype": "system",
                    "volumesizegb": "114",
                    "filesystems": [
                        {
                            "fstype": "/",
                            "currfsgb": "15"
                        },
                        {
                            "fstype": "/home",
                            "currfsgb": "4"
                        },
                        {
                            "fstype": "/tmp",
                            "currfsgb": "10"
                        },
                        {
                            "fstype": "/var",
                            "currfsgb": "5"
                        },
                        {
                            "fstype": "/var/log",
                            "currfsgb": "18"
                        },
                        {
                            "fstype": "/var/log/audit",
                            "currfsgb": "2"
                        }
                    ]
                }
            ]
        },
...
}
```

## rackreserve
### Description
*Reserve a rack for exacompute cluster*

### Usage
`exacompute rackreserve vmclusterid=<VMCLUSTEROCID> hostnames=<comma separated dom0 hostnames>`
### Values
`vmclusterid: the vm cluster ocid`
`hostnames: comma separated dom0 hostnames`
### Example
```json
ecra> exacompute rackreserve hostnames=iad103709exdd015,iad103709exdd014 vmclusterid=cluster_rack_reserve
* {
    "status": 202,
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/e27b6b6e-3684-45a1-876a-c7571a24d5d8",
    "op": "exacompute_rackreserve",
    "op_start_time": "2025-10-17T19:54:46+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing",
    "target_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/racks?vm_cluster_ocid=cluster_rack_reserve"
}
ecra> status e27b6b6e-3684-45a1-876a-c7571a24d5d8
* {"progress_percent": 0, "end_time": "2025-10-17T19:54:46+0000", "ecra_server": "EcraServer1",
 "wf_uuid": "32f84893-73f9-4c65-988f-04f69eea2028", "start_time": "2025-10-17T19:54:46+0000",
  "target_uri": "exacompute-iad1-d2-d43f6625-3b5f-4b54-a827-f75b7b8d6d83-clu01",
   "last_heartbeat_update": "2025-10-17T19:54:46+0000", "status": 200, "message": "Done",
    "op": "exacompute_rackreserve",
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/e27b6b6e-3684-45a1-876a-c7571a24d5d8",
    "status-detail": "success", "start_time_ts": "2025-10-17 19:54:46.0"}
```


## guestreserve
### Description
*Reserve a guest for the provided vmclusterocid*

### Usage
`exacompute guestreserve vmclusterid=<VMCLUSTEROCID> hostnames=<comma separated dom0 hostnames>`
### Values
`vmclusterid: the vm cluster ocid`
`hostnames: comma separated dom0 hostnames`
### Example
```json
ecra> exacompute guestreserve vmclusterid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d169 hostnames=iad103709exdd008
* {
    "status": 202,
    "status_uri": "http://localhost:9067/ecra/endpoint/statuses/0a1f7c41-f371-4bd2-bb22-b3e5c0ad89c8",
    "op": "exacompute_guestreserve",
    "op_start_time": "2025-10-30T20:30:25+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
ecra> status 0a1f7c41-f371-4bd2-bb22-b3e5c0ad89c8
* {
    "progress_percent": 0,
    "end_time": "2025-10-30T23:02:13+0000",
    "ecra_server": "EcraServer2",
    "wf_uuid": "36a84c4f-1f44-40d4-9af3-32527560bfca",
    "start_time": "2025-10-30T20:30:25+0000",
    "last_heartbeat_update": "2025-10-30T20:30:25+0000",
    "status": 200,
    "message": "Done",
    "op": "exacompute_guestreserve",
    "status_uri": "http://localhost:9067/ecra/endpoint/statuses/0a1f7c41-f371-4bd2-bb22-b3e5c0ad89c8",
    "status-detail": "success",
    "start_time_ts": "2025-10-30 20:30:25.0"
}
```

## guestrelease
### Description
*Release a guest for the provided vmclusterocid*

### Usage
`exacompute guestrelease vmclusterid=<VMCLUSTEROCID> hostnames=<comma separated dom0 hostnames>`
### Values
`vmclusterid: the vm cluster ocid`
`hostnames: comma separated dom0 hostnames`
### Example
```json
ecra>  exacompute guestrelease vmclusterid=ocid1.exacomputevmcluster.oc1.iad.0frdr58lry8qeb20o709vhnnqyrfmoruzb93aurtkuxjytoc4wreone2ch0d169 hostnames=sea202123exdd014
* {
    "status": 202,
    "status_uri": "http://localhost:9067/ecra/endpoint/statuses/42908fdd-c01d-4e93-9447-197709dc22cd",
    "op": "exacompute_guestrelease",
    "op_start_time": "2025-11-04T22:05:20+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}

ecra> status 42908fdd-c01d-4e93-9447-197709dc22cd
* {
    "progress_percent": 0,
    "end_time": "2025-11-04T22:05:20+0000",
    "ecra_server": "EcraServer2",
    "wf_uuid": "76798dbf-47bb-40c5-925a-4c2d89a938df",
    "start_time": "2025-11-04T22:05:20+0000",
    "last_heartbeat_update": "2025-11-04T22:05:20+0000",
    "status": 200,
    "message": "Done",
    "op": "exacompute_guestrelease",
    "status_uri": "http://localhost:9067/ecra/endpoint/statuses/42908fdd-c01d-4e93-9447-197709dc22cd",
    "status-detail": "success",
    "start_time_ts": "2025-11-04 22:05:20.0"
}
```

# ExadataInfra

## info

### Description
*Provide a view of general information about all the infrastructures created*

### Usages
`exadatainfrastructure info`

### Examples
`ecra> exadatainfrastructure info`
```*  <infrastructure> : <rackname>                                             :<state>              : <clusters> : <model>
*  flowtesterInfra2 : iad1-d4-cl3-681b4182-f19e-4263-b6bb-66a3a9ede305-clu01 :PROVISIONED          : 0          : --      
```

## reshapecluster

### Description
*Performs the reshapecluster operation over the provided exaunitid.*

### Usages
`exadatainfrastructure reshapecluster exadataInfrastructureId=<exainfraocid> exaunitId=<exaunitid> [cores=<CORES> memoryGb=<MEMORY> ohomeSizeGb=<OHSIZE> storageTb=<STORAGETB> filesystem=<FILESYSTEMS>]`

### Examples
```
        ecra> exadatainfrastructure reshapecluster exaunitId=1021 exadataInfrastructureId=testdbsystem3 ohomeSizeGb=600
        * {"status": 202, "status_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/statuses/0d9533d0-3407-4778-881b-7c6a609e35cd", "op": "reshape-service", "op_start_time": "2022-01-04T23:48:35+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 1021, "target_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/exaunit/1021"}

        ecra> exadatainfrastructure reshapecluster exadataInfrastructureId=flowtesterInfra exaunitId=583 filesystems=/u01:150,/:50
        * {"status": 202, "status_uri": "http://phoenix94112.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f89e0e4f-7bf0-4e3d-90f4-7194a00ef3bb", "op": "reshape-service", "op_start_time": "2023-07-07T17:54:52+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 583, "target_uri": "http://phoenix94112.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/ 
```

## rack_reserve

### Descrption
*Create a slot for the given ocid and based on the compute aliases*

### Usage:
`exadatainfrastructure rack_reserve exadataInfrastructureId=<exainfraocid> nodeComputeAliases=<list-of-aliases> vmclusterid=<vmclusterid> rackname=<rackname> [provisionType=<preprovision>]`

#### Values:
```*
            exainfraocid   : OCID for the CEI
            list-of-aliases: List of aliases, in comma separated
            vmclusterid : OCID of the rack
            rackname: Name of the rack that you want to reserve
            provisionType <preprovision>: If OCI Preprovision fueature is enabled and <preprovision> value is provided then PREPROVISIONED racks will be ignored and a new slot will be created.

```

### Examples:
```json
ecra> exadatainfrastructure rack_reserve exadataInfrastructureId=testdbsystem3 nodeComputeAliases=dbserver-01,dbserver-02
* {"status": 202, "status_uri":
"http://slc16lme.us.oracle.com:9001/ecra/endpoint/statuses/a69997d3-1352-4732-a8da-803b77fab042",
"op": "elastic_cei_get", "op_start_time": "2021-08-16T22:07:59+0000",
"est_op_end_time": "", "message": "processing", "status-detail": "processing"}
ecra> status a69997d3-1352-4732-a8da-803b77fab042
* {"start_time": "2021-08-16T22:07:59+0000", "target_uri":
"http://slc16lme.us.oracle.com:9001/ecra/endpoint/racks?name=slot_iad1-d4-cl4-9cae053c-df85-436c-a141-d3a48415b469-clu01",
"end_time": "2021-08-16T22:08:04+0000", "ecra_server": "EcraServer1",
"last_heartbeat_update": "2021-08-16T22:07:59+0000", "status": 200, "message":
"Done", "op": "ExadataInfraReserveRackOperation", "atp_enabled": "Y",
"status_uri":
"http://slc16lme.us.oracle.com:9001/ecra/endpoint/statuses/a69997d3-1352-4732-a8da-803b77fab042",
"status-detail": "success"}

ecra> exadatainfrastructure rack_reserve exadataInfrastructureId=testdbsystem5 rackname=iad1-d4-cl4-180fae64-346f-4223-b8d3-34ef70af45b4-clu07
* {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f21618b0-2abd-4501-b902-94868c5c5dd6", "op": "elastic_rack_reserve", "op_start_time": "2023-02-08T17:57:20+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}
ecra> status f21618b0-2abd-4501-b902-94868c5c5dd6
* {"start_time": "2023-02-08T17:57:20+0000", "target_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/racks?name=iad1-d4-cl4-180fae64-346f-4223-b8d3-34ef70af45b4-clu07", "resource_id": "iad1-d4-cl4-180fae64-346f-4223-b8d3-34ef70af45b4-clu07", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-02-08T17:57:20+0000", "status": 200, "message": "Done", "op": "ExadataInfraReserveRackOperation", "atp_enabled": "Y", "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f21618b0-2abd-4501-b902-94868c5c5dd6", "status-detail": "success"}
```

## add_cluster

### Descrption
*Performe the create_service operation over the provided slot.*   

### Usage:
`exadatainfrastructure add_cluster exadataInfrastructureId=<exainfraocid> rackname=<rackname> json_path=<Path to the JSON payload> [cores=<CORES> memorygb=<MEMORY> ohomesizegb=<OHSIZE> storagetb=<STORAGETB>]`
         
#### Values:
```*
            exainfraocid   : OCID for the CEI
            rackname       : Name of the slot that will be provisioned
            json_path      : The Path to the JSON payload
            cores          : Specify the number of cores for the cluster
            memorygb       : Specify the memory in Gb for this cluster
            storagetb      : Specify the storage in Tb for this cluster
            ohomesizegb    : Specify the size of home in this cluster
```

### Examples:
`ecra> exadatainfrastructure add_cluster exadataInfrastructureId=ocid.infa.test json_path=temp/mvm_add_cluster.json rackname=slot_iad1-d4-cl4-9cae053c-df85-436c-a141-d3a48415b469-clu02 cores=200 memorygb=5560 storagetb=153276 ohomesizegb=2000`

```*  
<id> : <rackname>                                             : <exaname> : <rackstate> : <ongoing op>   : <workflowId>                         : <dbSIDs>
  905  : iad1-d4-cl3-315ab2c7-6fec-44bb-9263-3b30aace29ea-clu01 :           : RESERVED    : create-service : 41523164-0412-45e5-a64b-cb2a06d73c7c : 
```


## computevms

### Description
*The API will return the VMs for the provided oracle hostname*

### Usages
`exadatainfrastructure computevms oraclehostname=<ORACLEHOSTNAME>`

#### Values
` <ORACLEHOSTNAME>  : Oracle hostname`

### Examples:
```json
ecra> exadatainfrastructure computevms oraclehostname=iad103709exdd013
* {
    "vms": [
        {
            "adminhostname": "iad103709exddu1301.sea2mvm01roce.adminsea2.oraclevcn.com",
            "adminip": "10.0.6.59",
            "adminvlanid": "1337",
            "clienthostname": "3709exd13c.clientsubnet.devx8melastic.oraclevcn.com",
            "rackname": "exacompute-iad1-d2-95c2ebae-cd53-4523-ab2a-4c2599a41738-clu01",
            "vmocid": "Exacomp-vm-instance-8922a56af033464ca9ff952649a9525a"
        }
    ]
}
```

## deletestorage

### Description
*Perform a deletion of cells on each cluster that belongs to an infractructure, in case the infrastucture has no clusters, disables the cell for provisioning or releases them.*

### Usages
`ecra> exadatainfrastructure deletestorage exadataInfrastructureId=<exainfraocid> servers=<cell1,cell2,...> [releaseservers=<true|false>]`

#### Values
`<exainfraocid> : The OCID of the infra to be cleaned up`
`<cells,...> : cell name or FQDN separated by commas`
`relaseservers: At the end of the delete it will release the cell from the infrastructure, by default this option is true.`

### Examples:
```
ecra> exadatainfrastructure deletestorage exadataInfrastructureId=testdbsystem  servers=iad103712exdcl14.iad103712exd.adminiad1.oraclevcn.com
* {"status": 202, "status_uri": "http://iad1devecra1.ecramgmt.adminiad1.oraclevcn.com:9001/ecra/endpoint/statuses/55658306-4dd6-43e2-93aa-ea4a66be2885", "op": "cei_storage_post", "op_start_time": "2023-11-16T15:44:48+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 184}

ecra> status 55658306-4dd6-43e2-93aa-ea4a66be2885
* {"progress_percent": 0, "exaunit_id": 184, "ecra_server": "EcraServer1", "wf_uuid": "02a37922-4b35-4e59-b0b4-eeb20de99d3a", "start_time": "2023-11-16T15:44:48+0000", "parent_req_id": "parent_sequential", "exa_ocid": "testdbsystem", "last_heartbeat_update": "2023-11-16T15:44:48+0000", "status": 202, "message": "Pending", "op": "mvm-delete-storage", "completion_percentage": 0, "status_uri": "http://iad1devecra1.ecramgmt.adminiad1.oraclevcn.com:9001/ecra/endpoint/statuses/55658306-4dd6-43e2-93aa-ea4a66be2885", "op_start_time": "2023-11-16T15:44:59+0000", "est_op_end_time": ""}

ecra> workflows describe workflowId=02a37922-4b35-4e59-b0b4-eeb20de99d3a
* {
    "workflowName": "delete-elastic-cell-wfd",
    "workflowId": "02a37922-4b35-4e59-b0b4-eeb20de99d3a",
    "workflowStatus": "Completed",
    "workflowStartTime": "16 Nov 2023 15:44:48 UTC",
    "workflowEndTime": "16 Nov 2023 16:06:05 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "GetXMLForDeleteTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Nov 16 15:44:48 UTC 2023",
            "taskEndTime": "Thu Nov 16 15:44:48 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "taskName": "PrepareReshape",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Nov 16 15:44:48 UTC 2023",
            "taskEndTime": "Thu Nov 16 15:44:49 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:01"
        },
        {
            "taskName": "DeleteCellTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Nov 16 15:44:49 UTC 2023",
            "taskEndTime": "Thu Nov 16 16:06:04 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:21:15"
        },
        {
            "taskName": "UpdateCellDataTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Nov 16 16:06:04 UTC 2023",
            "taskEndTime": "Thu Nov 16 16:06:04 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "taskName": "LaunchNextWorkflow",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Thu Nov 16 16:06:04 UTC 2023",
            "taskEndTime": "Thu Nov 16 16:06:05 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:01"
        },
        {
            "lastTaskName": "LaunchNextWorkflow",
            "lastOperationDetails": {
                "lastTaskLastOperationId": "6c8270bc-c6c6-45bc-bdbc-2aea002f671f",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "16 Nov 2023 16:06:04 UTC",
                "lastTaskLastOperationEndTime": "16 Nov 2023 16:06:05 UTC"
            }
        }
    ],
    "exaOCID": "",
    "requestId": "55658306-4dd6-43e2-93aa-ea4a66be2885",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
```
## getinitialpayload

### Description
*Retrieves the initial payload for the exadata infrastructure.*

### Usages
`exadatainfrastructure getinitialpayload ceiocid=<ceiocid> | rackname=<rackname>`

#### Values
`ceiocid   : OCID for the CEI`
`rackname  : The rackname such as iad1-d4-cl3-f8536645-8939-401d-8471-16e195f62dcb-clu01`

### Examples:
```json
ecra> exadatainfrastructure getinitialpayload rackname=iad1-d4-cl3-f8536645-8939-401d-8471-16e195f62dcb-clu02
* {
    "elasticNodes": [
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd014",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd015",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd016",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd017",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103712exd.adminiad1.oraclevcn.com",
            "hostname": "iad103712exdcl01",
            "hw_type": "CELL"
        },
        {
            "domainname": "iad103712exd.adminiad1.oraclevcn.com",
            "hostname": "iad103712exdcl02",
            "hw_type": "CELL"
        },
        {
            "domainname": "iad103712exd.adminiad1.oraclevcn.com",
            "hostname": "iad103712exdcl03",
            "hw_type": "CELL"
        }
    ],
    "exadataInfrastructureId": "ZeusInfra",
    "fabricname": null,
    "faultdomain": null,
    "idemtoken": "488ba284-96fd-40e2-9853-6da4ac83830f",
    "multiVM": true,
    "provisionType": null,
    "requestId": "8240b9b2-9715-4c99-84f0-fe764a0a5dd1",
    "servers": [
        {
            "hw_type": "CELL",
            "model": "X8M-2",
            "model_subtype": "STANDARD",
            "quantity": 3
        },
        {
            "dom0_bonding": true,
            "hw_type": "COMPUTE",
            "model": "X8M-2",
            "model_subtype": "STANDARD",
            "quantity": 4
        }
    ],
    "tenantName": "dbaasnm",
    "tenantOcid": "ocid1.cloudexadatainfrastructure.region1.sea.anzwkljsinjoekaaep2yyhfkxoyejr4ijamds2oidrdu7untvshgpcmcvbla"
}

ecra> exadatainfrastructure getinitialpayload ceiocid=ZeusInfra
* {
    "elasticNodes": [
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd014",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd015",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd016",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "hostname": "iad103709exdd017",
            "hw_type": "COMPUTE"
        },
        {
            "domainname": "iad103712exd.adminiad1.oraclevcn.com",
            "hostname": "iad103712exdcl01",
            "hw_type": "CELL"
        },
        {
            "domainname": "iad103712exd.adminiad1.oraclevcn.com",
            "hostname": "iad103712exdcl02",
            "hw_type": "CELL"
        },
        {
            "domainname": "iad103712exd.adminiad1.oraclevcn.com",
            "hostname": "iad103712exdcl03",
            "hw_type": "CELL"
        }
    ],
    "exadataInfrastructureId": "ZeusInfra",
    "fabricname": null,
    "faultdomain": null,
    "idemtoken": "488ba284-96fd-40e2-9853-6da4ac83830f",
    "multiVM": true,
    "provisionType": null,
    "requestId": "8240b9b2-9715-4c99-84f0-fe764a0a5dd1",
    "servers": [
        {
            "hw_type": "CELL",
            "model": "X8M-2",
            "model_subtype": "STANDARD",
            "quantity": 3
        },
        {
            "dom0_bonding": true,
            "hw_type": "COMPUTE",
            "model": "X8M-2",
            "model_subtype": "STANDARD",
            "quantity": 4
        }
    ],
    "tenantName": "dbaasnm",
    "tenantOcid": "ocid1.cloudexadatainfrastructure.region1.sea.anzwkljsinjoekaaep2yyhfkxoyejr4ijamds2oidrdu7untvshgpcmcvbla"
}

```

## recoverclunodes_sop

### Description
*Performs the node recovery sop over the provided exadataInfrastructureId.*

### Usages
exadatainfrastructure recoverclunodes_sop exadataInfrastructureId=[exainfraocid] jsonpayload=[PATH_TO_INPUT_JSON_FILE]

### Examples
```
        ecra> exadatainfrastructure recoverclunodes_sop exadataInfrastructureId=testdbsystem3 jsonpayload=/tmp/input.json
        * {"status": 202, "status_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/statuses/0d9533d0-3407-4778-881b-7c6a609e35cd", "op": "reshape-service", "op_start_time": "2022-01-04T23:48:35+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 1021, "target_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/exaunit/1021"}

```

## dropclunodes_sop

### Description
*Performs the drop nodes for node recovery sop over the provided exadataInfrastructureId.*

### Usages
exadatainfrastructure dropclunodes_sop exadataInfrastructureId=[exainfraocid] jsonpayload=[PATH_TO_INPUT_JSON_FILE]

### Examples
```
        ecra> exadatainfrastructure dropclunodes_sop exadataInfrastructureId=testdbsystem3 jsonpayload=/tmp/input.json
        * {"status": 202, "status_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/statuses/0d9533d0-3407-4778-881b-7c6a609e35cd", "op": "reshape-service", "op_start_time": "2022-01-04T23:48:35+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 1021, "target_uri": "http://slc16lme.us.oracle.com:9001/ecra/endpoint/exaunit/1021"}

```


## secureerase:

### Description
* On demand executes secure erase of cells provided or all existing in an infra *

### Arguments:
- `exadataInfrastructureId: Infra ID (CEIOCID)`
- `idemtoken: required for concurrency`
- `cellnodes: comma separated values of cell hostnames to target secure erase`

### Usages
`./ecracli exadatainfrstructure secureerase exadataInfrastructureId=<> cellnodes<> idemtoken=<>`

### Examples
```json
ecra>  exadatainfrastructure secureerase exadataInfrastructureId=testdbsystem idemtoken=0c73d6d0-1992-4bcf-b86b-91fe853a574c
* {"status": 202, "status_uri": "http://iad1devecra1.ecramgmt.adminiad1.oraclevcn.com:9001/ecra/endpoint/statuses/b0ee2e9d-19ff-4da0-b10d-14151de81812", "op": "cei_secure_erase_post", "op_start_time": "2024-08-16T21:38:50+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}
```

## getsecureerasecert

### Description
* This command will download the generated certificates for the secure erase operation that happend on delete infra, delete storage or on demand secure erase *

### Arguments:
- `exadataInfrastructureId: CEIOCID`
- `path: path to save the generated certs`
- `operationtype: used to filter to a single operation type (INFRA_DELETE, STORAGE_DELETE, SECURE_ERASE)`
- `cellnode: used to filter a single or multiple cell nodes (works only with delete storage and secure erase using specific nodes)`
- `downloadtype: this defines the type of the response use FILE to save response in a file using "path" or DIRECT to download the file to user request, use OSSFILE or OSSDIRECT to download certificate files from OSS, GENERATE_URL will generate a PAR URL`


### Usages
`./ecracli exadatainfrastructure getsecureerasecert exadataInfrastructureId=<> [path=<> operationtype=<> cellnode=<> downloadtype=<>]`

### Examples
```json
ecra> exadatainfrastructure getsecureerasecert exadataInfrastructureId=testdbsystem path=/u01/ecra_preprov/oracle/ecra_installs/ecra2341/certs2.zip operationtype=INFRA_DELETE
* Using path: /u01/ecra_preprov/oracle/ecra_installs/ecra2341/certs2.zip
* {"file": "/u01/ecra_preprov/oracle/ecra_installs/ecra2341/certs2.zip", "status": 200, "op": "exainfra_secureerase_get", "status-detail": "success"}
```

## getkeys

### Description
*Retrieve the ssh keys for the infra components.*

### Usages
`exadatainfrastructure getkeys <exainfraocid> [host=<hostname of machine/all>] [user=<username for which you need key root/oracle>] [nodetype=<dom0/domu/ibswitch/cell/all_nodes>]`

#### Values
`exainfraocid: The ocid from the infra`
`host: The hostname of the machine`
`user: The user for which you need the key`
`nodetype: The type of the node for which the key is required`


### Examples:
```json
ecra> exadatainfrastructure getkeys ZeusInfraTesting18
* {
    "est_op_end_time": "",
    "message": "processing",
    "op": "exadatainfra_keys_post",
    "op_start_time": "2025-01-06T15:43:21+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/0a2109b1-25ac-4eaf-953e-a44fbdc0b928"
}

ecra> status 0a2109b1-25ac-4eaf-953e-a44fbdc0b928
* {"step_progress_details": "{\"data\":{\"error\":\"\",\"output\":{\"dom0\":{\"sea202123exdd002.sea2xx2xx0111qf.adminsea2.oraclevcn.com\":{\"key\":\"mock key 1\"},
\"sea202123exdd003.sea2xx2xx0111qf.adminsea2.oraclevcn.com\":{\"key\":\"mock key 2\"},\"sea202123exdd014.sea2xx2xx0111qf.adminsea2.oraclevcn.com\":{\"key\":\"mock key 3\"}}},\"success\":\"True\"}}",
 "progress_percent": 0, "start_time_ts": "2025-01-06 15:43:21.0", "end_time": "2025-01-06T15:43:50+0000", "ecra_server": "EcraServer1", "wf_uuid": "3a7b167f-474b-4a8a-b8df-17d7981eee21",
  "start_time": "2025-01-06T15:43:21+0000", "last_heartbeat_update": "2025-01-06T15:43:21+0000", "status": 200, "message": "Done", "op": "exadatainfra_keys_post", "completion_percentage": 0,
   "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/0a2109b1-25ac-4eaf-953e-a44fbdc0b928", "status-detail": "success"}

```

# Bonding 


## getInfo

### Description
*Provide bonding related info associated with the rack or hostname from ecs_bonding table*

### Arguments
-`rackname : rackname for which bonding info needs to be found`
-`hostname : hostname for which bonding info needs to be found`

### Examples:
```json
ecra> bonding getInfo rackname=sea201109exd-d0-01-02-cl-01-03-clu01

{   "status":200,
   "status-detail":"success",
   "nodes":[
      {
       "sea201109exdd002":{
            "control_vip":"10.0.3.58",
            "control_netmask":"255.255.255.128",
            "control_vlantag":0,
            "control_ip1":"10.0.3.27 ",
            "control_ip2":"10.0.3.28"

        }

      },

      {
      "sea201109exdd001":{
            "control_vip":"10.0.3.55",
            "control_netmask":"255.255.255.128",
            "control_vlantag":0,
            "control_ip1":"10.0.3.25",
            "control_ip2":"10.0.3.26"

        }
      }

   ],
   "op":"bonding_info_get"
}

ecra> bonding getInfo hostname=iad103716exdd013
"*"{
   "nodes":[
      {
         "iad103716exdd013":{
            "control_ip1":"192.168.0.44",
            "control_ip2":"192.168.3.125",
            "control_vip":"192.168.1.123",
            "control_netmask":"255.255.252.0",
            "control_vlantag":0
         }
      }
   ],
   "status":200,
   "op":"bonding_info_get",
   "status-detail":"success"
}
```

##setupMonitoringBond

### Description
*Creates/updates the monitoring bond*

### Arguments
-`json_path: Information related to bonding`

### Examples
```json
ecra> bonding setupMonitoringBond json_path=/scratch/rgmurali/ecra_installs/bonding/ecracli/tmpl/dbcp_bonding.json
* {"status": 202, "est_op_end_time": "", "status-detail": "processing", "status_uri": "http://den00uew.us.oracle.com:9001/ecra/endpoint/statuses/09f366b8-5bfa-4c05-b253-84c1c1488275", "op_start_time": "2020-07-27T08:44:32+0000", "message": "processing", "op": "bonding_setup_post"}

{
    "rackname" : "sea201109exd-d0-01-02-cl-01-03-clu01",
    "racktype" : "QUARTER",
    "nodes":[
      {
       "sea201109exdd001" : {
            "control_ip1":"10.0.3.53",
            "control_ip2":"10.0.3.54",
            "control_vip":"10.0.3.55",
            "control_netmask":"255.255.255.128",
            "control_vlantag":0
        }
      },
      {
      "sea201109exdd002":{
            "control_ip1":"10.0.3.56",
            "control_ip2":"10.0.3.57",
            "control_vip":"10.0.3.58",
            "control_netmask":"255.255.255.128",
            "control_vlantag":0
        }
      }

   ]
}
```

## deleteMonitoringBond

### Description
*Deletes the monitoring bond*

### Arguments
-`json_path: Information related to bonding`

### Examples
```json
ecra> bonding deleteMonitoringBond json_path=/scratch/rgmurali/ecra_installs/bonding/ecracli/tmpl/dbcp_bonding.json
* {"status": 202, "est_op_end_time": "", "status-detail": "processing", "status_uri": "http://den00uew.us.oracle.com:9001/ecra/endpoint/statuses/8fe8c1d9-130d-4083-9bb6-4730d8c0d455", "op_start_time": "2020-07-27T08:46:43+0000", "message": "processing", "op": "bonding_setup_delete"}
```

## getpayload

### Description
*Get the DBCP payload for bonding from ecra_clobs table*

### Arguments
-`rackname: Information needed about a rack`
-`hostname: Information needed about a compute`

### Examples
```json
ecra> bonding getpayload rackname=sea201109exd-d0-01-02-cl-01-03-clu01
* {
    "nodes": [
        {
            "control_monitor": [
                {
                    "cavium_ids": [
                        {
                            "id": "id1",
                            "interface": "eth1"
                        },
                        {
                            "id": "id2",
                            "interface": "eth2"
                        }
                    ],
                    "control_ip1": "10.0.3.53",
                    "control_ip2": "10.0.3.54",
                    "control_netmask": "255.255.255.128",
                    "control_type": "bond0",
                    "control_vip": "10.0.3.55",
                    "control_vlantag": 0,
                    "preferred_interface": "eth1"
                },
                {
                    "cavium_ids": [
                        {   
                            "id": "id3", 
                            "interface": "eth1"
                        },
                        {
                            "id": "id3", 
                            "interface": "eth2"
                        }
                    ],
                    "control_ip1": "10.0.3.59",
                    "control_ip2": "10.0.3.60",
                    "control_netmask": "255.255.255.128",
                    "control_type": "bond1",
                    "control_vip": "10.0.3.61",
                    "control_vlantag": 0,
                    "preferred_interface": "eth1"
                }
            ],
            "hostname": "sea201109exdd001"
        },
        {
            "control_monitor": [
                {
                    "cavium_ids": [
                        {
                            "id": "id5",
                            "interface": "eth1"
                        },
                        {
                            "id": "id6",
                            "interface": "eth2"
                        }
                    ],
                    "control_ip1": "10.0.3.56",
                    "control_ip2": "10.0.3.57",
                    "control_netmask": "255.255.255.128",
                    "control_type": "bond0",
                    "control_vip": "10.0.3.58",
                    "control_vlantag": 0,
                    "preferred_interface": "eth2"
                },
                {
                    "cavium_ids": [
                        {
                            "id": "id7",
                            "interface": "eth1"
                        },
                        {
                            "id": "id8",
                            "interface": "eth2"
                        }
                    ],
                    "control_ip1": "10.0.3.62",
                    "control_ip2": "10.0.3.63",
                    "control_netmask": "255.255.255.128",
                    "control_type": "bond1",
                    "control_vip": "10.0.3.64",
                    "control_vlantag": 0,
                    "preferred_interface": "eth2"
                }
            ],
            "hostname": "sea201109exdd002"
        }
    ],
    "op": "bonding_payload_get",
    "rackname": "sea201109exd-d0-01-02-cl-01-03-clu01",
    "racktype": "QUARTER",
    "status": 200,
    "status-detail": "success"
}

ecra> bonding getpayload hostname=iad103716exdd013
* {
    "mvmbonding": true,
    "nodes": [
        {
            "control_monitor": [
                {
                    "cavium_ids": [
                        {
                            "id": "FPC2251824F",
                            "networkinterface": "eth2"
                        },
                        {
                            "id": "FPC22520272",
                            "networkinterface": "eth1"
                        }
                    ],
                    "control_ip1": "192.168.0.44",
                    "control_ip2": "192.168.3.125",
                    "control_netmask": "255.255.252.0",
                    "control_type": "bond0",
                    "control_vip": "192.168.1.123",
                    "control_vlantag": "0",
                    "preferred_interface": "eth2"
                }
            ],
            "hostname": "iad103716exdd013"
        }
    ],
    "op": "bonding_payload_get",
    "operationtype": null,
    "rackname": "IAD103716",
    "racktype": "COMPUTE-ONLY",
    "status": 200,
    "status-detail": "success"
}
```

## linkfailover

### Description
*The API will fail over the link on the interfaces of a indicated bonded node*

### Usages
`bonding linkfailover components=<list of names> newactive=<interface>`

#### Values
` <list of names>  : list of one or more components names (Infra, rack or dom0)`
` <interface>  : link that will be restarted first`

### Examples:
```json

ecra> bonding linkfailover components=SEA201112 newactive=eth1
* {
    "status": 202, 
    "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f103509f-56b3-4920-8983-e2e77a076eac", 
    "op": "bonding_linkfailover_post", 
    "op_start_time": "2023-03-16T16:37:46+0000", 
    "est_op_end_time": "", 
    "message": "processing", 
    "status-detail": "processing"
  }

ecra> bonding linkfailover components=sea201112exd-d0-03-04-cl-04-06-clu01 newactive=eth1
* {
    "status": 202, 
    "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/566979da-9463-493d-aaa0-292b7b0d2455", 
    "op": "bonding_linkfailover_post", 
    "op_start_time": "2023-03-16T16:58:08+0000", 
    "est_op_end_time": "", 
    "message": "processing", 
    "status-detail": "processing"
  }

ecra> bonding linkfailover components=sea201112exdd004,sea201112exdd003 newactive=eth1
* {
    "status": 202, 
    "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/05e0a720-8abf-4e50-8399-d36590d1d7d7", 
    "op": "bonding_linkfailover_post", 
    "op_start_time": "2023-03-16T16:13:04+0000",
    "est_op_end_time": "", 
    "message": "processing", 
    "status-detail": "processing"
  }

```
## rpmupdate
### Description
Endpoint to update bondingmonitor rpm into a rackname or hostnames.

### Usages
```ecra> bonding rpmupdate rackname=<cluster> hostnames=<hostname1,hostnameN>```

### Arguments 
- **rackname**: [Optional] Clustername where rpm needs to be updated.
- **hostnames**: [Optional] Comma separated hostnames (dom0).

### Examples
```ecra> bonding rpmupdate rackname=sea101111exd-d0-03-04-cl-04-06-clu01
* {"status": 202, "status_uri": "http://slc17ukd.us.oracle.com:9030/ecra/endpoint/
statuses/6e749a18-12ea-4431-b44f-eb140a785105", "op": "bonding_rpmupdate_put", "op_start_time": 
"2021-08-10T01:31:38+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}

ecra> bonding rpmupdate hostnames=sea201610exdd007,sea201610exdd005
```

## consistencycheck

### Description
*Execute the Bonding consistency check over the provided cluster*

### Usages
`bonding consistencycheck rackname=<rack name> [hostname=<dom0 hostname>]`

#### Values
` <rackname>  : Target a single cluster`
` <hostname>  : Limit check to a single node`

### Examples:
```json
ecra> bonding consistencycheck rackname=iad1-d3-cl3-40543193-045e-401f-99fe-8b9a9d5d5104-clu01
* {
    "status": 202,
    "status_uri": "http://phoenix93588.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/af303ff9-3ac9-49a4-b6ca-ddf2260d5f40",
    "op": "bonding_consistencycheck_post",
    "op_start_time": "2023-01-06T18:29:05+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
```
## restartmonitor

### Description
*Restarts the bond monitor based on the provided information*

### Usages
`bonding restartmonitor component=<COMPONENT>`

#### Values
` <COMPONENT>: The component could be exadatainfrastructureId, rackname (provisioned or not), hostname and cabinet name.`

### Examples:
```json
    ecra> bonding restartmonitor component=testdbsystem5
    * {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/441b051a-6dd5-4480-abbd-7c6f2ed5a251", "op": "bonding_restartmonitor_put", "op_start_time": "2023-01-20T00:10:00+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}

    ecra> bonding restartmonitor component=iad1-d4-cl4-ec510a34-47ba-4687-8340-8f21fe5961f0-clu02
    * {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/543613cb-8292-4e78-afda-00bc77a375bb", "op": "bonding_restartmonitor_put", "op_start_time": "2023-01-20T00:23:02+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}

    ecra> bonding restartmonitor component=IAD101608
    * {"status": 202, "status_uri": "http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/2efafe05-aef4-4be4-b8b9-11062e3ebc6e", "op": "bonding_restartmonitor_put", "op_start_time": "2023-01-20T00:25:24+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing"}
```

## status 

### Description
*Check the status for bondmonitor & networking connectivity*

### Usages
`bonding status component=<COMPONENT> [id=<OPERATION_ID>]`

#### Values
` <COMPONENT>: The component could be exadatainfrastructureId, rackname (provisioned or not), hostname and cabinet name.`
` <OPERATION_ID>: The usage of component returns an Id: <OPERATION_ID> use the OPERATION_ID to get the response rom exacloud.`

### Examples:
```json
    ecra> bonding status component=iad1-d3-cl3-0b7e01e7-d7e9-4156-b05b-2ae9e4363242-clu01
* Id: c458fba1-e6fb-40c6-b91d-d167311cf5e8
* STATUS URI : http://phoenix112400.dev3sub3phx.databasede3phx.oraclevcn.com:9037/ecra/endpoint/statuses/c458fba1-e6fb-40c6-b91d-d167311cf5e8
* Request issued. Wait for completion. Pulling Status.
* Status: processing...

* Request bonding successfully completed
* {
    "nodes": [
        {
            "eth1_link": true,
            "eth2_link": false,
            "eth1_ifstatus": true,
            "eth2_ifstatus": false,
            "bondmonitor": false,
            "bondmonitor_json": true,
            "dom0": "iad103709exdd011.iad103709exd.adminiad1.oraclevcn.com"
        },
        {
            "eth1_link": true,
            "eth2_link": false,
            "eth1_ifstatus": true,
            "eth2_ifstatus": false,
            "bondmonitor": false,
            "bondmonitor_json": true,
            "dom0": "iad103709exdd014.iad103709exd.adminiad1.oraclevcn.com"
        },
        {
            "eth1_link": true,
            "eth2_link": false,
            "eth1_ifstatus": true,
            "eth2_ifstatus": false,
            "bondmonitor": false,
            "bondmonitor_json": true,
            "dom0": "iad103709exdd004.iad103709exd.adminiad1.oraclevcn.com"
        },
        {
            "eth1_link": true,
            "eth2_link": false,
            "eth1_ifstatus": true,
            "eth2_ifstatus": false,
            "bondmonitor": false,
            "bondmonitor_json": true,
            "dom0": "iad103709exdd015.iad103709exd.adminiad1.oraclevcn.com"
        }
    ],
    "overall_health": false,
    "status": 200,
    "op": "bonding_statusmonitor_get",
    "status-detail": "success"
} 
    ```
# Inventory

## summary

### Description

*Endpoint that returns a visualization of all the free nodes organized by fabric, fault domain, model, etc. Optionally, a node state can be specified so the matching nodes are displayed.*

### Usages
`inventory summary`
`inventory summary nodestate=ALLOCATED`
`inventory summary nodestate=`

### Optional Arguments
- **nodestate:** *FREE | ALLOCATED | ERROR | RESERVED | ALL*

### Examples:

`ecra> inventory summary`

```json
sea2xx2xx0051qf
        1
                X9M-2 Elastic
                        COMPUTE
                                ALL
                                        14comp2rocesw2pdu1ethsw
                                                19.2.15.0.0.200724
                                                        N N (14)
                                                                sea201610exdd012        FREE
                                                                sea201610exdd011        FREE
                                                                sea201610exdd014        FREE
                                                                sea201610exdd001        FREE
                                                                sea201610exdd002        FREE
                                                                sea201610exdd003        FREE
                                                                sea201610exdd013        FREE
                                                                sea201610exdd005        FREE
                                                                sea201610exdd006        FREE
                                                                sea201610exdd007        FREE
                                                                sea201610exdd008        FREE
                                                                sea201610exdd009        FREE
                                                                sea201610exdd010        FREE
                                                                sea201610exdd004        FREE
                        CELL
                                ALL
                                        15cell2rocesw2pdu1ethsw
                                                21.2.2.0.0.210720
                                                        N N (15)
                                                                sea201507exdcl10        FREE
                                                                sea201507exdcl12        FREE
                                                                sea201507exdcl09        FREE
                                                                sea201507exdcl11        FREE
                                                                sea201507exdcl13        FREE
                                                                sea201507exdcl14        FREE
                                                                sea201507exdcl15        FREE
                                                                sea201507exdcl01        FREE
                                                                sea201507exdcl02        FREE
                                                                sea201507exdcl03        FREE
                                                                sea201507exdcl04        FREE
                                                                sea201507exdcl05        FREE
                                                                sea201507exdcl06        FREE
                                                                sea201507exdcl07        FREE
                                                                sea201507exdcl08        FREE
IAD1FABRIC1
        IAD1FD2
                X8M-2 Elastic
                        COMPUTE
                                ALL
                                        18comp2rocesw2pdu1ethsw
                                                19.2.6.0.0.190911.1
                                                        Y N (1)
                                                                iad103709exdd001        FREE
                                                        N N (17)
                                                                iad103709exdd013        FREE
                                                                iad103709exdd017        FREE
                                                                iad103709exdd012        FREE
                                                                iad103709exdd011        FREE
                                                                iad103709exdd010        FREE
                                                                iad103709exdd009        FREE
                                                                iad103709exdd008        FREE
                                                                iad103709exdd007        FREE
                                                                iad103709exdd006        FREE
                                                                iad103709exdd005        FREE
                                                                iad103709exdd004        FREE
                                                                iad103709exdd003        FREE
                                                                iad103709exdd002        FREE
                                                                iad103709exdd015        FREE
                                                                iad103709exdd016        FREE
                                                                iad103709exdd018        FREE
                                                                iad103709exdd014        FREE
                        CELL
                                ALL
                                        15cell2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (14)
                                                                iad103712exdcl13        FREE
                                                                iad103712exdcl15        FREE
                                                                iad103712exdcl12        FREE
                                                                iad103712exdcl11        FREE
                                                                iad103712exdcl10        FREE
                                                                iad103712exdcl09        FREE
                                                                iad103712exdcl08        FREE
                                                                iad103712exdcl07        FREE
                                                                iad103712exdcl06        FREE
                                                                iad103712exdcl03        FREE
                                                                iad103712exdcl04        FREE
                                                                iad103712exdcl05        FREE
                                                                iad103712exdcl02        FREE
                                                                iad103712exdcl01        FREE
                                JUNIT
                                        15cell2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (1)
                                                                iad103712exdcl14        FREE
```

`ecra> inventory summary nodestate=ALLOCATED`

```json
IAD1FABRIC1
        IAD1FD2
                X8M-2 Elastic
                        COMPUTE
                                ALL
                                        3cell2comp2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (6)
                                                                iad103714exdd006        ALLOCATED
                                                                iad103714exdd005        ALLOCATED
                                                                iad103714exdd001        ALLOCATED
                                                                iad103714exdd002        ALLOCATED
                                                                iad103714exdd003        ALLOCATED
                                                                iad103714exdd004        ALLOCATED
                        CELL
                                ALL
                                        3cell2comp2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (9)
                                                                iad103714exdcl01        ALLOCATED
                                                                iad103714exdcl03        ALLOCATED
                                                                iad103714exdcl04        ALLOCATED
                                                                iad103714exdcl05        ALLOCATED
                                                                iad103714exdcl06        ALLOCATED
                                                                iad103714exdcl07        ALLOCATED
                                                                iad103714exdcl08        ALLOCATED
                                                                iad103714exdcl09        ALLOCATED
                                                                iad103714exdcl02        ALLOCATED
```

`ecra> inventory summary nodestate=ALL`

```json
sea2xx2xx0051qf
        1
                X9M-2 Elastic
                        COMPUTE
                                ALL
                                        14comp2rocesw2pdu1ethsw
                                                19.2.15.0.0.200724
                                                        N N (14)
                                                                sea201610exdd014        FREE
                                                                sea201610exdd013        FREE
                                                                sea201610exdd012        FREE
                                                                sea201610exdd011        FREE
                                                                sea201610exdd010        FREE
                                                                sea201610exdd009        FREE
                                                                sea201610exdd008        FREE
                                                                sea201610exdd007        FREE
                                                                sea201610exdd006        FREE
                                                                sea201610exdd005        FREE
                                                                sea201610exdd001        FREE
                        CELL
                                ALL
                                        15cell2rocesw2pdu1ethsw
                                                21.2.2.0.0.210720
                                                        N N (15)
                                                                sea201507exdcl15        FREE
                                                                sea201507exdcl14        FREE
                                                                sea201507exdcl13        FREE
                                                                sea201507exdcl12        FREE
                                                                sea201507exdcl11        FREE
                                                                sea201507exdcl10        FREE
                                                                sea201507exdcl09        FREE
                                                                sea201507exdcl08        FREE
                                                                sea201507exdcl07        FREE
                                                                sea201507exdcl06        FREE
                                                                sea201507exdcl05        FREE
                                                                sea201507exdcl04        FREE
                                                                sea201507exdcl03        FREE
                                                                sea201507exdcl02        FREE
                                                                sea201507exdcl01        FREE
IAD1FABRIC1
        IAD1FD2
                X8M-2 Elastic
                        COMPUTE
                                ALL
                                        3cell2comp2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (6)
                                                                iad103714exdd006        ALLOCATED
                                                                iad103714exdd005        ALLOCATED
                                                                iad103714exdd001        ALLOCATED
                                                                iad103714exdd002        ALLOCATED
                                                                iad103714exdd003        ALLOCATED
                                                                iad103714exdd004        ALLOCATED
                                        18comp2rocesw2pdu1ethsw
                                                19.2.6.0.0.190911.1
                                                        Y N (1)
                                                                iad103709exdd001        RESERVED
                                                        N N (17)
                                                                iad103709exdd003        RESERVED
                                                                iad103709exdd002        RESERVED
                                                                iad103709exdd004        ERROR
                                                                iad103709exdd005        FREE
                                                                iad103709exdd006        FREE
                                                                iad103709exdd007        FREE
                                                                iad103709exdd008        FREE
                                                                iad103709exdd009        FREE
                                                                iad103709exdd010        FREE
                                                                iad103709exdd011        FREE
                                                                iad103709exdd012        FREE
                                                                iad103709exdd013        FREE
                                                                iad103709exdd014        FREE
                                                                iad103709exdd015        FREE
                                                                iad103709exdd016        FREE
                                                                iad103709exdd018        FREE
                                                                iad103709exdd017        FREE
                        CELL
                                ALL
                                        3cell2comp2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (9)
                                                                iad103714exdcl01        ALLOCATED
                                                                iad103714exdcl03        ALLOCATED
                                                                iad103714exdcl04        ALLOCATED
                                                                iad103714exdcl05        ALLOCATED
                                                                iad103714exdcl06        ALLOCATED
                                                                iad103714exdcl07        ALLOCATED
                                                                iad103714exdcl08        ALLOCATED
                                                                iad103714exdcl09        ALLOCATED
                                                                iad103714exdcl02        ALLOCATED
                                        15cell2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (14)
                                                                iad103712exdcl05        FREE
                                                                iad103712exdcl04        FREE
                                                                iad103712exdcl03        FREE
                                                                iad103712exdcl02        FREE
                                                                iad103712exdcl01        FREE
                                                                iad103712exdcl15        FREE
                                                                iad103712exdcl13        FREE
                                                                iad103712exdcl12        FREE
                                                                iad103712exdcl11        FREE
                                                                iad103712exdcl10        FREE
                                                                iad103712exdcl09        FREE
                                                                iad103712exdcl08        FREE
                                                                iad103712exdcl07        FREE
                                                                iad103712exdcl06        FREE
                                JUNIT
                                        15cell2rocesw2pdu1ethsw
                                                12.2.0.1.0_18032017
                                                        N N (1)
                                                                iad103712exdcl14        FREE
```
## updatestatuscomment

### Description

*Endpoint that updates the field of STATUS_COMMENT for a node or cabinet as indicated.

### Usages
`inventory updatestatuscomment component=<node|cabinet> name=<componentName> content=<message>`

### Examples:
``` ecra> inventory updatestatuscomment component=node name=iad103709exdd011 content="Last modified 10/05 2:52pm"
* {
    "status": 200,
    "op": "inventory_update_status_comment",
    "status-detail": "success"
}
```

## getstatuscomment

### Description

*Endpoint that retreives the field of STATUS_COMMENT for a node or cabinet as indicated.

### Usages
`inventory getstatuscomment component=<node|cabinet> name=<componentName>`


### Examples:
```
ecra> inventory getstatuscomment component=node name=iad103709exdd011
* {
    "status": 200,
    "op": "inventory_update_status_comment",
    "status-detail": "success",
    "Current_Status_Comment": "This component does not have a previous status comment."
}
ecra> inventory getstatuscomment component=node name=iad103709exdd011
* {
    "status": 200,
    "op": "inventory_update_status_comment",
    "status-detail": "success",
    "Current_Status_Comment": "Last modified 10/05 2:52pm"
}
```
## resetilomdefaultpassword:

### Description

*Reset ilom pwd to default one from the indicated node(s) (multiple values are allowed using comma).*

### Usages
`inventory resetilomdefaultpassword listofnodes=value1,value2,...,valueN`

### Examples:
`ecra> inventory resetilomdefaultpassword listofnodes=iad103714exdd003,iad103714exdd004,iad103714exdd005`
```json
* {
    "status": 202,
    "status_uri":
"http://phoenix94477.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/9eb9e523-7fce-4854-a074-e023dfba653f",
    "op": "inventory_reset_ilom_password",
    "op_start_time": "2025-06-27T02:51:20+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing",
    "exaunit_id": -1
}


## resetilomvaultpassword:

### Description

*Reset ilom pwd to default one from the indicated node(s) (multiple values are allowed using comma).*

### Usages
`inventory resetilomvaultpassword listofnodes=value1,value2,...,valueN`

### Examples:
`ecra> inventory resetilomvaultpassword listofnodes=iad103714exdd003,iad103714exdd004,iad103714exdd005`
```json
* {
    "status": 202,
    "status_uri":
"http://phoenix94477.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/9eb9e523-7fce-4854-a074-e023dfba653f",
    "op": "inventory_reset_ilom_password",
    "op_start_time": "2025-06-27T02:51:20+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing",
    "exaunit_id": -1
}

## hardware configurefeaturetenancy
        
### Description 
        
         Update configured features in the tenancy(tenancies) selected
        
### Usages 


ecra> help hardware configurefeaturetenancy
hardware configurefeaturetenancy tenancyid=<comma separated values> feature=<ALL|VMBOSS> value=<ENABLED|DISABLED> 
 Update configured features in the tenancy(tenancies) selected
        
### Examples
        
        Error cases 

ecra> hardware configurefeaturetenancy 
* Error: Please provide all mandatory parameters. Missing mandatory parameters are: ['tenancyid', 'feature', 'value']
ecra> hardware configurefeaturetenancy tenancyid=tenancy.ocid1 feature=VMBOSS value=ENABLED
* Error: Available features are: ['vmboss']


Enable property 
ecra> hardware configurefeaturetenancy tenancyid=tenancy.ocid1 feature=vmboss  value=ENABLED
* {
    "status": 200,
    "op": "tenancy_configure_feature_vmboss",
    "status-detail": "success"
}
ecra> 


List property 

ecra>  hardware tenancypropertylist
* {
    "tenancyproperties": [
        {
            "user_group": "EXACS",
            "tenancy_id": "__default_tenancy__",
            "cloud_vnuma": "enabled_with_dom0_overlap",
            "memoryconfig": "STANDARD",
            "EARLY_ADOPTER": "N",
            "skipresizedg": "no"
        },
        {
            "user_group": "ADB-S",
            "tenancy_id": "tenancy.ocid1",
            "cloud_vnuma": "disabled",
            "jumbo_frames": "both",
            "memoryconfig": "standard",
            "EARLY_ADOPTER": "N",
            "skipresizedg": "no",
            "configured_features": "ALL,VMBOSS"
        }
    ],
    "status": 200,
    "op": "tenancy_property_get",
    "status-detail": "success"
}
ecra> 

Disable property 


ecra> hardware configurefeaturetenancy tenancyid=tenancy.ocid1 feature=vmboss  value=DISABLED
* {
    "status": 200,
    "op": "tenancy_configure_feature_vmboss",
    "status-detail": "success"
}
ecra> 
ecra> 

List 

ecra>  hardware tenancypropertylist
* {
    "tenancyproperties": [
        {
            "user_group": "EXACS",
            "tenancy_id": "__default_tenancy__",
            "cloud_vnuma": "enabled_with_dom0_overlap",
            "memoryconfig": "STANDARD",
            "EARLY_ADOPTER": "N",
            "skipresizedg": "no"
        },
        {
            "user_group": "ADB-S",
            "tenancy_id": "tenancy.ocid1",
            "cloud_vnuma": "disabled",
            "jumbo_frames": "both",
            "memoryconfig": "standard",
            "EARLY_ADOPTER": "N",
            "skipresizedg": "no",
            "configured_features": "ALL,-VMBOSS"
        }
    ],
    "status": 200,
    "op": "tenancy_property_get",
    "status-detail": "success"
}
ecra> 


## hardware tenancypropertyput

### Description

*Adds a record to the cloud vnuma tenancy database

### Usages
`ecra> hardware tenancypropertyput user_group=<user_group> tenancy_id=<tenancy_id> cloud_vnuma=<cloud_vnuma> jumbo_frames=<jumbo_frames> skipresizedg=yes | no memoryconfig=large | extralarge | standard [ customids=true | false usersdata=<user 1>:<uid>|<user N>:<uid> groupsdata=<group name 1>:<gid>|<group name N>:<gid>`


### Examples:
```
ecra> hardware tenancypropertyput user_group=my_user_grp tenancy_id=test_tenancy23 cloud_vnuma=test_vnuma jumbo_frames=both memoryconfig=large customids=true usersdata=oracle:100|grid:200 groupsdata=oinstall:5000|asmcustom:6000
* {
    "status": 200,
    "op": "tenancy_property_post",
    "status-detail": "success"
}
```

## resetcavium

### Description

Endpoint to start, stop or reset T93 cavium

### Usages
`inventory resetcavium <caviumid>=<cavium_id>`  
`inventory resetcavium <caviumid>=<cavium_id> action=<start | stop | reset>`  
`inventory resetcavium <caviumid>=<cavium_id> ignorenodestate=<true | false>` 
`inventory resetcavium <caviumid>=<cavium_id> targetdevice=< ilom | dom0 >` 

### Mandatory Arguments
- **caviumid:** *cavium_id*

### Optional Arguments
- **ignorenodestate:** *true | false*
- **action:** *start | stop | reset*
- **targetdevice=:** * ilom | dom0 * 

---
## update_node_detail
### Description
Endpoint to update serial number and admin mac of the provided dom0.
### Usages
```
ecra> inventory update_node_detail rackname=iad1-d2-cl3-afc40582-3083-4a21-ba8c-7e0b523eed62-clu01
```

### Optional Arguments
- **hostnames:** list of hostnames separated by a comma
- **cabinetname:** a cabinet name to update all dom0 details 
- **rackname:** a rackname to update all dom0 details

## reserve

### Description
Returns the list of racks associated with the provided parameter, this could be an oracle hostname or a smartnicid.

### Usages
`inventory reserve json_path=<json file path> hostnames=<hostnames>`

#### Values
`json_path: keys pertaining to the inventory`
`hostnames: List of hostnames separated by commas.`

### Examples
```json
ecra> inventory reserve
json_path=/scratch/rgmurali/ecra_installs/deletetest/ecracli/tmpl/inventory_reserve.json
* {"status": 200, "status-detail": "success", "op": "inventory_reserve",
* "servers": [{"hostname": "sea201109exdd005", "hw_type": "COMPUTE",
* "domainname": "sea201109exd.adminsea2.oraclevcn.com"}, {"hostname":
* "sea201109exdd006", "hw_type": "COMPUTE", "domainname":
* "sea201109exd.adminsea2.oraclevcn.com"}]}

{
    "rackname": "sea201109exd-d0-01-02-cl-01-03-clu01", 
    "idemtoken": "b2481cab-3b73-4284-9725-4f8a125d7190",
    "exadataInfrastructureId": "testdbsystem",
    "servers": [
        {
        "hw_type": "COMPUTE", 
        "model": "X8M-2", 
        "quantity" : 2
    }
    ]
}

ecra> inventory reserve json_path=/scratch/rgmurali/ecra_installs/deletetest/ecracli/tmpl/inventory_reserve.json
* {"status": 200, "status-detail": "success", "op": "inventory_reserve", "servers": [{"hostname": "sea203416exdcl04",
"hw_type": "CELL", "domainname": "iad103416exd.adminiad1.oraclevcn.com"}, {"hostname": "sea201109exdd005", 
"hw_type": "COMPUTE", "domainname": "sea201109exd.adminsea2.oraclevcn.com"}]}

[rgmurali@den01gpy tmpl]$ cat inventory_reserve.json 
{
    "rackname": "sea201109exd-d0-01-02-cl-01-03-clu01", 
    "idemtoken": "645d5a10-56ed-4b43-96ab-ea9a91a4c43d",
    "exadataInfrastructureId": "testdbsystem",
    "hostnames" : ["sea203416exdcl04", "sea201109exdd005"]
}
```

## get_hardware

### Description

*Get all inventory for the specified hardware, this also gets data from hw_nodes tables*

### Usages
`inventory get_hardware <hw_type=(CELL|COMPUE)> <stauts=value> <model=value> <fabric_name=value> <servicetype=value>`


### Examples:

ecra> inventory get_hardware
* {"servers": [{"status": "PROVISIONED", "hw_type": "COMPUTE", "domainname": "sea201207exd.adminsea2.oraclevcn.com", "fabric_name": "1", "hostname": "sea201207exdd001", "inventory_id": "sea201207exdd001", "model": "X7-2", "cabinet_id": "1"}, {"status": "PROVISIONED", "hw_type": "COMPUTE", "domainname": "sea201207exd.adminsea2.oraclevcn.com", "fabric_name": "1", "hostname": "sea201207exdd002", "inventory_id": "sea201207exdd002", "model": "X7-2", "cabinet_id": "1"}, {"status": "FREE", "hw_type": "COMPUTE", "domainname": "sea201207exd.adminsea2.oraclevcn.com", "fabric_name": "1", "hostname": "sea201207exdd003", "inventory_id": "sea201207exdd003", "model": "X7-2", "cabinet_id": "1"}, {"status": "FREE", "hw_type": "COMPUTE", "domainname": "sea201207exd.adminsea2.oraclevcn.com", "fabric_name": "1", "hostname": "sea201207exdpd01", "inventory_id": "sea201207exdpd01", "model": "X7-2", "cabinet_id": "1"}, {"status": "FREE", "hw_type": "PDU", "domainname": "sea201207exd.adminsea2.oraclevcn.com", "fabric_name": "1", "hostname": "sea201207exdpd02", "inventory_id": "sea201207exdpd02", "model": "X7-2", "cabinet_id": "1"}]}

ecra> inventory get_hardware hw_type=COMPUTE servicetype=exacompute fabric_name=IAD1FABRIC1
* {
    "servers": [
        {
            "cabinetname": "IAD103709",
            "availability_domain": "IAD1",
            "fault_domain": "IAD1FD2",
            "cluster_size_constraint": "18comp2rocesw2pdu1ethsw",
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "eth0": "Y",
            "cabinet_id": "17",
            "hw_type": "COMPUTE",
            "model": "X8M-2",
            "sw_version": "21.1.0.0.0.210319",
            "creation_date": "2022-03-29 22:39:44.367911",
            "ip": "10.0.6.9",
            "hostname": "iad103709exdd008",
            "ilom_ip": "10.0.6.27",
            "ilom_hostname": "iad103709exdd008lo",
            "status": "FREE",
            "dom0_bonding": "N",
            "clustertag": "ALL",
            "servicetype": "exacompute",
            "mvmbonding": "N",
            "model_subtype": "STANDARD",
            "fabric_name": "IAD1FABRIC1"
        },
        {
            "cabinetname": "IAD103709",
            "availability_domain": "IAD1",
            "fault_domain": "IAD1FD2",
            "cluster_size_constraint": "18comp2rocesw2pdu1ethsw",
            "domainname": "iad103709exd.adminiad1.oraclevcn.com",
            "eth0": "Y",
            "cabinet_id": "17",
            "hw_type": "COMPUTE",
            "model": "X8M-2",
            "sw_version": "21.1.0.0.0.210319",
            "creation_date": "2022-03-29 22:39:44.374407",
            "ip": "10.0.6.8",
            "hostname": "iad103709exdd007",
            "ilom_ip": "10.0.6.26",
            "ilom_hostname": "iad103709exdd007lo",
            "status": "FREE",
            "dom0_bonding": "N",
        [...]}

## capacityreview
### Usage:
* ./ecracli inventory reviewcapacity <hw_type=(CELL|COMPUE)> <stauts=value> <model=value> <fabric_name=value> <servicetype=value>

### Purpose:
*    Get a boolean that will tell if exists HW with given spec

### Examples:

*ecra> help inventory reviewcapacity
inventory reviewcapacity  [status=<status> | model=<model> | hw_type=<COMPUTE|CELL>] | fabric_name=<value> | servicetype=<value> | <param=value>
 Get true/false depending if there's hw info  for given parameters spec

ecra> inventory reviewcapacity status=FREE
* {
    "capacityavailable": false,
    "status": 200,
    "op": "review_capacity",
    "status-detail": "success"
}

ecra> inventory reviewcapacity status=RESERVED hw_type=CELL mode=X9M-2
* {
    "capacityavailable": true,
    "status": 200,
    "op": "review_capacity",
    "status-detail": "success"
}


# KvmRoce

## getfaultdomains

### Description

Gets all fault domains and fabrics within them

### Usages

`kvmroce getallfaultdomains`

### Mandatory Arguments

None

### Optional Arguments

None


## Examples 
<details>
	<summary>List fault domains</summary>

`ecra> kvmroce listfaultdomains`

```json
  {
    "Fault-Domains": [
        "IADFD1", "SEAFD2"
    ],
    "op": "fault_domain_all_get",
    "status": 200,
    "status-detail": "success"
}
```

</details>

---

## updatefaultdomain:

### Description

Updates fault domain of given fabric

### Usage:
`ecracli kvmroce updatefaultdomain`
  

### Mandatory arguments

- **fabricname:** *fabric_name*
- **faultdomain:** *new_fault_domain*

## Examples 
<details>
    <summary>Update fault domain</summary>

`ecra> kvmroce updatefaultdomain fabricname=IAD1FABRIC1 faultdomain=2`

```json
  {
    "op": "update_fabric_fault_domain_put",
    "status": 200,
    "status-detail": "success"
}
```

</details>

---

## updatefaultdomain:

### Description

Runs sanity check for X8M

### Usage:
`ecracli kvmroce runsanitycheck json_path=<payload path> | operationtype=<check type> rackname=<rackname> exadataInfrastructureId=<infra ocid> [elasticnodes=<commma separated hostnames>]`
  

### Mandatory arguments
- **json_path:** File containing nodes/rack information.
- **operationtype:** ADD_COMPUTE|ADD_CELL|CEI_PRECHECK|INVENTORY_RESERVE|CEI_RESERVE
- **rackname:** Rack name
- **exadataInfrastructureId:** Exadata Infrastrucutre OCID
- **elasticnodes:** List of elastic nodes separated by comma.
- **serverscount:** Number of servers to delete for delete cell operationtype

## Examples 

```json
ecra> kvmroce runsanitycheck json_path=/scratch/rgmurali/ecra_installs/fabric1/ecracli/tmpl/sanity_check.json
* Idemtoken used is: 2b498fdb-a02c-45e7-88d8-3a335372e763

ecra> kvmroce runsanitycheck exadataInfrastructureId=ocid1.cloudexadatainfrastructure.mvm.check_el.005 operationtype=ADD_COMPUTE rackname=iad1-d5-cl3-68f9850c-041e-4d59-b0d2-4d32de2764b6-clu02 elasticnodes=iad103709exdd007

* {"status": 202, "status_uri": "http://slc17ukd.us.oracle.com:9030/ecra/endpoint/statuses/4c5ef4ba-a08f-4c67-bc75-db65bbd1253c", 
"op": "sanity_check_post", "op_start_time": "2021-02-28T02:35:54+0000", "est_op_end_time": "", "message": "processing", 
"status-detail": "processing"}

ecra> kvmroce runsanitycheck exadataInfrastructureId=testinfra operationtype=DELETE_CELL rackname=iad1-d2-cl3-56c4816e-ddc5-4ce4-871d-b3c57ee8e92c-clu01 serverscount=3
* Idemtoken used is: de7b363d-9b13-4fec-89fb-8660730804f4
* {"status": 202, "status_uri": "http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/9bb9f395-51fa-4f4d-929a-5160d806cc9d", "op": "sanity_check_post", "op_start_time": "2023-11-10T20:47:13+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 608}

ecra> status 9bb9f395-51fa-4f4d-929a-5160d806cc9d
* {"start_time": "2023-11-10T20:47:12+0000", "progress_percent": 0, "exaunit_id": 608, "end_time": "2023-11-10T20:48:10+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-11-10T20:47:12+0000", "wf_uuid": "c94b19c2-e78f-4635-bc58-f8d16c165060", "status": 200, "message": "Done", "op": "SANITY_CHECK", "resources": ["sea201507exdcl02.sea2xx2xx0051qf.adminsea2.oraclevcn.com", "sea201507exdcl03.sea2xx2xx0051qf.adminsea2.oraclevcn.com", "sea201507exdcl01.sea2xx2xx0051qf.adminsea2.oraclevcn.com"], "completion_percentage": 0, "status_uri": "http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/9bb9f395-51fa-4f4d-929a-5160d806cc9d", "status-detail": "success"}

ecra> kvmroce runsanitycheck operationtype=DELETE_CELL  rackname=sea2-d4-cl3-1de3f06c-dfa7-4860-984b-15b5b84205c2-clu01 exadataInfrastructureId=flowtesterInfra serverscount=1
* Idemtoken used is: 305a2197-5996-4cea-bb37-3ab166b6f41e
* {"status": 202, "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/55895d26-16a9-494a-9f74-cff4961d8717", "op": "sanity_check", "op_start_time": "2024-08-05T19:45:22+0000", "est_op_end_time": "", "message": "processing", "status-detail": "processing", "exaunit_id": 2114}

ecra> status 55895d26-16a9-494a-9f74-cff4961d8717
* {"progress_percent": 0, "exaunit_id": 2114, "start_time_ts": "2024-08-05 19:45:22.0", "end_time": "2024-08-05T19:45:29+0000", "ecra_server": "EcraServer1", "wf_uuid": "3395aa02-db3b-480b-ba54-d2134d699fc3", "start_time": "2024-08-05T19:45:22+0000", "last_heartbeat_update": "2024-08-05T19:45:22+0000", "status": 200, "message": "Done", "op": "SANITY_CHECK", "resources": [{"type": "cell", "name": "sea201507exdcl01.sea2xx2xx0051qf.adminsea2.oraclevcn.com", "success": true}], "completion_percentage": 0, "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/55895d26-16a9-494a-9f74-cff4961d8717", "status-detail": "success"}
```

## isexascalepoolcreated

### Description

Return if exacscale pool has already been created or not.

### Usages

`kvmroce isexascalepoolcreated <fabricname=name>`

### Mandatory Arguments

fabricname

### Optional Arguments

None


## Examples 
<details>
    <summary>Return if exacscale pool has been created</summary>

`ecra>  kvmroce isexascalepoolcreated fabricname=iad1xx4xx0301qf`

```json
  {
    "exascalepoolcreated": true,
    "status": 200,
    "op": "ipaddress_get_exascalepool",
    "status-detail": "success"
}
```

</details>


# Rack
## drop  

### Description

*Used to remove all associated records to a SVM rack. This will restore the state for the hw nodes.

### Usages
`rack drop <rack_name>`
`rack drop rackname=<rackname>`

### Mandatory Arguments
- **rackname:** *rack_name*
### Optional Arguments
### Examples:
**Using rackname:**

`ecra> rack drop iad103714exd-d0-05-06-cl-07-09-clu01A`

```json 
* {
TDB
}
---

## register

### Description

*Register a rack in ecra with the given rack name or xml file path.*

### Usages
`rack register <rack_name>`
`rack register rackname=<rack_name>`
`rack register rackxmlpath=<xml_path>`
`rack register rackname=<rackname> racksize=<full | half | quarter | eighth | elastic>`

### Mandatory Arguments
- **rackname:** *rack_name*
### Optional Arguments
- **rackxmlpath:** *xml_file_path*
- **racksize:** *full | half | quarter | eighth | elastic*

---

## getxmlinfo

### Description

*Get node information from an original, updated or external rack given a rack's name or the path to its XML file.*

### Usages

`rack getxmlinfo <rack_name>`
`rack getxmlinfo rackname=<rack_name>`
`rack getxmlinfo filepath=<xml_path>`

### Optional Arguments

- **rackname**: *rack_name*
- **filepath**: *xml_path*

### Examples:
**Using rackname:**

`ecra> rack getxmlinfo iad103714exd-d0-05-06-cl-07-09-clu01A`

```json 
* {
    "original": {
        "computes": {
            "count": 2,
            "nodes": [
                {
                    "clientHostname": "scaqan01dv0101.us.oracle.com",
                    "hostname": "iad103714exdd005.iad103714exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103714exddu0501.iad103714exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "scaqan01dv0201.us.oracle.com",
                    "hostname": "iad103714exdd006.iad103714exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103714exddu0601.iad103714exd.adminiad1.oraclevcn.com"
                }
            ]
        },
        "cells": {
            "count": 3,
            "nodes": [
                {
                    "hostname": "iad103714exdcl07.iad103714exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103714exdcl08.iad103714exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103714exdcl09.iad103714exd.adminiad1.oraclevcn.com"
                }
            ]
        }
    },
    "updated": {
        "computes": {
            "count": 2,
            "nodes": [
                {
                    "clientHostname": "scaqan01dv0101.us.oracle.com",
                    "hostname": "iad103714exdd005.iad103714exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103714exddu0501.iad103714exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "scaqan01dv0201.us.oracle.com",
                    "hostname": "iad103714exdd006.iad103714exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103714exddu0601.iad103714exd.adminiad1.oraclevcn.com"
                }
            ]
        },
        "cells": {
            "count": 3,
            "nodes": [
                {
                    "hostname": "iad103714exdcl07.iad103714exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103714exdcl08.iad103714exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103714exdcl09.iad103714exd.adminiad1.oraclevcn.com"
                }
            ]
        }
    },
    "rackname": "iad103714exd-d0-05-06-cl-07-09-clu01"
}
```

**Using filepath:**

`ecra> rack getxmlinfo xmlpath=/scratch/ririgoye/scripts/raultest.xml`

```json
* {
    "external": {
        "computes": {
            "count": 7,
            "nodes": [
                {
                    "clientHostname": "iad103709exddu0701.us.oracle.com",
                    "hostname": "iad103709exdd007.iad103709exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103709exddu0701.iad103709exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "iad103709exddu0201.us.oracle.com",
                    "hostname": "iad103709exdd002.iad103709exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103709exddu0201.iad103709exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "iad103709exddu0301.us.oracle.com",
                    "hostname": "iad103709exdd003.iad103709exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103709exddu0301.iad103709exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "iad103709exddu0101.us.oracle.com",
                    "hostname": "iad103709exdd001.iad103709exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103709exddu0101.iad103709exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "iad103709exddu0401.us.oracle.com",
                    "hostname": "iad103709exdd004.iad103709exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103709exddu0401.iad103709exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "iad103709exddu0601.us.oracle.com",
                    "hostname": "iad103709exdd006.iad103709exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103709exddu0601.iad103709exd.adminiad1.oraclevcn.com"
                },
                {
                    "clientHostname": "iad103709exddu0501.us.oracle.com",
                    "hostname": "iad103709exdd005.iad103709exd.adminiad1.oraclevcn.com",
                    "natHostname": "iad103709exddu0501.iad103709exd.adminiad1.oraclevcn.com"
                }
            ]
        },
        "cells": {
            "count": 7,
            "nodes": [
                {
                    "hostname": "iad103712exdcl07.iad103712exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103712exdcl02.iad103712exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103712exdcl06.iad103712exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103712exdcl01.iad103712exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103712exdcl05.iad103712exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103712exdcl04.iad103712exd.adminiad1.oraclevcn.com"
                },
                {
                    "hostname": "iad103712exdcl03.iad103712exd.adminiad1.oraclevcn.com"
                }
            ]
        }
    },
    "rackname": null
}
```

## updatexml  

### Description

*Updates the xml for the specified rack with the xml in the provided path.

### Usages
`rack updatexml rackname=<rack name> xml=<original|updated> path=<xml_path>`

### Mandatory Arguments

`rackname: the rackname`
`xml: the xml column to update`
`path: the location of the xml to be used`

### Examples:

```json 
ecra> rack updatexml xml=original path=/scratch/zpallare/xmls/zeus.xml rackname=iad1-d4-cl3-651a1d66-1326-43ad-b350-6e3f310e4272-clu01
    * {
    "status": 200,
    "op": "rack_xml_update",
    "status-detail": "success"
    }
    ecra> rack updatexml xml=updated path=/scratch/zpallare/xmls/zeus.xml rackname=iad1-d4-cl3-651a1d66-1326-43ad-b350-6e3f310e4272-clu01
    * {
    "status": 200,
    "op": "rack_xml_update",
    "status-detail": "success"
    }

```

# Exaunit
## Delete compute
### Description
Deletes a compute from a provisioned rack.
### Usage
```
ecra> exaunit deletecompute <exaunit_id> [jsonPayload=<payloadPath>] [hostnames=hostnames] [force=true|false]
```
### Example
```
```
### Arguments
#### Mandatory
- **exaunit_id:** The exaunit-id is a mandatory numeric value
#### Optional
- **jsonPayload:** The path to the json payload for this particular operation
- **hostnames:** A list of hostnames separated by commas
- **force:** A boolean indicating whether to force the operation to be performed or not.

## detail_update:

### Description
Update the detailed parameters for the given exaunit.

### Usage
```
ecra> exaunit detail_update <exaunit_id> <key>=<value>
```
### Arguments
 #### Mandatory
- **exaunit_id:** The exaunit-id is a mandatory numeric value
#### Optional
- **key :** initial_cores, grid_version, customer_name, reserved_cores, reserved_memory, filesystem,
                 gb_memory, tb_storage, gb_storage, gb_ohsize, atp, jumbo_frames, monitoring_enabled,
                 total_cores, fsconfig, ecpufactor

### Example
```
ecra> exaunit detail_update 82 reserved_memory=12
* {
    "status": 200,
    "op": "exaunit_update",
    "status-detail": "success"
}
```


## Add compute

### Description
Add a set of compute(s) to the specified exaunit using the given payload.

### Usages
`exaunit addcompute <exaunitId> jsonPayload=<payloadPath> hostname=<hostname>`

#### Values
`jsonPayload: Payload with the compute information, client, backup and vips for the new computes`
`hostname: hostname of the compute node`

### Examples
```json
ecra>  exaunit addcompute 1 jsonPayload=myecra/ecracli/tmpl/elastic_oci_addcompute.json
```

## Suspend

### Description
Suspend all the vms in the exaunit

### Usages
`exaunit suspend <exaunitId>`

#### Values
`exaunitId: id of the exaunit`

### Examples
```json
ecra> exaunit suspend 41
* Performing exaunit suspend operation
http://iad1devecra1.ecramgmt.adminiad1.oraclevcn.com:9001/ecra/endpoint/statuses/388da5f7-0b12-4104-a1ef-3e8f22191bb4
```

## GetDGInfo 

### Description
This command will return the disk group information about the exaunit provided.

### Usages
`exaunit getdginfo exaunitid=<exaunitid>

#### Values
`exaunitid: exaunit id to get the disk group info`


### Examples
```json
ecra> exaunit getdginfo exaunitid=694
* {
    "diskGroups": [
        {
            "name": "DATAC1",
            "size": "612G",
            "usage": "50"
        },
        {
            "name": "RECOC1",
            "size": "612G",
            "usage": "50"
        }
    ],
    "backupDisk": false,
    "status": 200,
    "op": "exaunit_list",
    "status-detail": "success"
}
```
## Securevms

### Description
This command will rase all the keys in all the vms of the exaunit

### Usages
`./ecracli exaunit secuervms exaunitid=<exaunit_id> [opcrequestid=<opcrequestid>] [idemtoken=<idemtoken>] [payload=<json_path>]`

#### Values
`exaunit_id : The id of the exaunit`

### Examples:
```
ecra> exaunit securevms exaunitid=2194
* {
  "status": 202,
  "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/8e08bce7-0ff9-4e3b-9bea-10172f90d732",
  "op": "exaunit_securevms_post",
  "op_start_time": "2024-09-11T21:40:31+0000",
  "est_op_end_time": "",
  "message": "processing",
  "status-detail": "processing",
  "exaunit_id": 2194
}
ecra> status 8e08bce7-0ff9-4e3b-9bea-10172f90d732
* {"progress_percent": 0, "start_time": "2024-09-11T21:40:31+0000", "exaunit_id": 2194, "start_time_ts": "2024-09-11 21:40:31.0", "ecra_server": "EcraServer1", "last_heartbeat_update": "2024-09-11T21:40:31+0000", "wf_uuid": "0cea5964-eaaa-4717-a82c-d99acc01eddb", "status": 202, "message": "Pending", "op": "SecureVMs", "completion_percentage": 0, "status_uri": "http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/8e08bce7-0ff9-4e3b-9bea-10172f90d732", "op_start_time": "2024-09-11T21:40:41+0000", "est_op_end_time": ""}
```

## Generatecspayload

### Description
Generates the create service paylaod.
If workflowid is provided the payload will be generated
with values from workflow and the new payload will replace
the one that has been generated during workflow run.
If payload and filename are provided the payload
will be generated with values from the provided payload
and the new payload will be saved in the POD repo with 
the specified filename.

### Usages
`exaunit generatecspayload [workflowid=<workflow uuid>] [payload=<base cspayload> filename=<filename for new cspayload>]`

#### Values
`workflowid: wf_uuid from create-service workflow`
`payload: path to the json file with create-service payload from CP`
`filename: name for the cspayload that will be generated`


### Examples
```json
ecra> exaunit generatecspayload workflowid=704a1b26-70c1-4166-84d3-e5d50cb77328
* {
  "status": 202,
  "status_uri": "http://localhost:9001/ecra/endpoint/statuses/84ccdce5-5494-4b64-adbe-921ce54443ee",
  "op": "exaunit_generate_cspayload",
  "op_start_time": "2023-12-05T20:32:31+0000",
  "est_op_end_time": "",
  "message": "processing",
  "status-detail": "processing"
}

ecra> exaunit generatecspayload payload=/scratch/zpallare/payloads/csbasepayload.json filename=ZeusTest.json
* {
  "status": 202,
  "status_uri": "http://localhost:9001/ecra/endpoint/statuses/6a13791e-74c1-499d-8c75-381dac64976f",
  "op": "exaunit_generate_cspayload",
  "op_start_time": "2023-12-05T20:29:29+0000",
  "est_op_end_time": "",
  "message": "processing",
  "status-detail": "processing"
}
```

## Update timezone

### Description
Updates the time zone in the xml for the exaunit.

### Usages
`exaunit updatetimezone exaunitid=<exaunitId> timezone=<new timezone>`

#### Values
`exaunitid: the id of the exaunit to update`
`timezone: the new timezone to put into the xml`

### Examples
```json
ecra> exaunit updatetimezone exaunitid=434 timezone=America/belem
* {
  "status": 202,
  "status_uri":
"http://localhost:9001/ecra/endpoint/statuses/e8840c00-4c1f-4386-8cc8-7d816d85f434",
  "op": "exaunit_time_zone_put",
  "op_start_time": "2024-01-05T18:15:29+0000",
  "est_op_end_time": "",
  "message": "processing",
  "status-detail": "processing"
}

ecra> status e8840c00-4c1f-4386-8cc8-7d816d85f434
* {"start_time": "2024-01-05T18:15:29+0000", "progress_percent": 0, "end_time":
"2024-01-05T18:15:36+0000", "ecra_server": "EcraServer1",
"last_heartbeat_update": "2024-01-05T18:15:29+0000", "wf_uuid":
"0cf4e76d-aec5-4493-9112-57d6eb9d9925", "status": 200, "message": "Done", "op":
"UpdateTimeZone", "completion_percentage": 0, "status_uri":
"http://localhost:9001/ecra/endpoint/statuses/e8840c00-4c1f-4386-8cc8-7d816d85f434",
"status-detail": "success"}

```
## ASM Rebalance

### Description
Update the ASM rebalance power value, this value is used during the rebalance process when a elastic cell is added to the disk group.

### Usages
`./ecracli exaunit asmrebalance <exaunitid> rebalancepower=<rebalance power>`

#### Values
`exaunitid: The exaunit id to be used`
`rebalancepower: The new value for asm_power_limit`

### Examples
```json
ecra> exaunit asmrebalance 695 rebalancepower=15
* {
    "status": 202,
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d354aff3-94d6-449d-86c8-441e3bb9593e",
    "op": "asm_rebalance",
    "op_start_time": "2024-05-03T05:50:39+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing",
    "exaunit_id": 695
}
ecra> status d354aff3-94d6-449d-86c8-441e3bb9593e
* {"progress_percent": 0, "exaunit_id": 695, "start_time_ts": "2024-05-03 05:50:39.0",
 "end_time": "2024-05-03T05:51:02+0000", "ecra_server": "EcraServer1", "wf_uuid": "dedec35f-21ce-4967-b06b-3c74ab12a355",
 "start_time": "2024-05-03T05:50:39+0000", "last_heartbeat_update": "2024-05-03T05:50:39+0000", "status": 200, 
 "message": "Done", "op": "asm_rebalance", "completion_percentage": 0, 
 "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d354aff3-94d6-449d-86c8-441e3bb9593e",
 "status-detail": "success"}
```
## Get operations

### Description
Get the operations that are currently running in the cluster

### Usages
`exaunit getoperations <exaunit_id>`

#### Values
`exaunit_id: The id such as 1, 2 etc`

### Examples
```json
ecra> exaunit getoperations 15367
* {
    "operations": [
        {
            "operation": "create-service",
            "requestid": "7540f949-01f1-4cb5-b8fe-bca66e9272da"
        }
    ],
    "status": 200,
    "op": "exaunit_operations_get",
    "status-detail": "success"
}
```

## Update NTP DNS details

### Description
Update NTP DNS details for the given exaunit ID

### Usages
`exaunit updatentpdns <exaunit_id>`

#### Values
`exaunit_id: The id such as 1, 2 etc`

### Examples
```json
ecra> exaunit updatentpdns exaunitid=2194
* {
  "status": 200,
  "op": "exaunit_updatentpdns_post",
  "message": "success"
}
```

## Rotate keys

### Description
Rotate ssh keys from exacloud

### Usages
`exaunit rotatekeys [exaunitid=<exaunitId>] [rackname=<rackname>] [idemtoken=<idemtoken>] [force=true/false]`

#### Values
`exaunit_id : The id such as 1, 2 etc`
`rackname : the name of the rack`
`idemtoken : the idemtoken for this request`
`force : true/false to run the operation even if there are ongoing operations in the cluster`

### Examples
```json
ecra> exaunit rotatekeys rackname=sea201108exd-d0-03-04-cl-04-06-clu01 force=false
* {
    "status": 202,
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/92d60fb9-fc77-4c4c-abe2-279da8e3611c",
    "op": "exaunit_rotatekeys_post",
    "op_start_time": "2025-01-13T04:56:53+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
ecra> status 92d60fb9-fc77-4c4c-abe2-279da8e3611c
* {"progress_percent": 0, "start_time": "2025-01-13T04:56:53+0000", "start_time_ts": "2025-01-13 04:56:53.0", "end_time": "2025-01-13T04:56:57+0000", 
"ecra_server": "EcraServer1", "last_heartbeat_update": "2025-01-13T04:56:53+0000", "wf_uuid": "2065307e-dfc3-40a9-a9fc-981863bfee2d", "status": 200, 
"message": "Done", "op": "exaunit_rotatekeys_post", "completion_percentage": 0, 
"status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/92d60fb9-fc77-4c4c-abe2-279da8e3611c", 
"status-detail": "success"}
```

## Get compute sizes

### Description
Get the disk usage of each dom0 from a given exaunit. 

### Usages
`exaunit getcomputesizes <exaunit_id> [dom0s=<dom0_1>,<dom0_2>,...,<dom0_n>] [ignorexml=<true|false>]`

#### Values
`exaunit_id : The id such as 1, 2 etc.`
`dom0s : The additional dom0s to be listed (aside from the ones in the exaunit's XML).`
`ignorexml : Whether to list the computes in the exaunit's XML (false) or not (true).`

### Examples
```json
    1) ecra> exaunit getcomputesizes 1867 wait=false
    * GET http://den01gpy.us.oracle.com:9001/ecra/endpoint/exaunit/1765/exaunit/computesizes
    * {"status": 202, "status-detail": "success", "compute_sizes": {"scas07adm07.us.oracle.com": "197.0 GB"}, "op": "racks_get"}

    2) ecra> exaunit getcomputesizes 1867 dom0s=scas07adm08.us.oracle.com 
    * GET http://den01gpy.us.oracle.com:9001/ecra/endpoint/exaunit/1765/exaunit/computesizes?dom0s=scas07adm08.us.oracle.com
    * {"status": 202, "status-detail": "success", "compute_sizes": {"scas07adm07.us.oracle.com": "197.0 GB", "scas07adm08.us.oracle.com": "197.0 GB"}, "op": "racks_get"}

    3) ecra> exaunit getcomputesizes 1867 dom0s=scas07adm08.us.oracle.com ignorexml=true wait=false
    * GET http://den01gpy.us.oracle.com:9001/ecra/endpoint/exaunit/1765/exaunit/computesizes?dom0s=scas07adm08.us.oracle.com&ignorexml=true
    * {"status": 202, "status-detail": "success", "compute_sizes": {"scas07adm08.us.oracle.com": "197.0 GB"}, "op": "racks_get"}

    4) ecra> exaunit getcomputesizes 1867
    * Fetching VM sizes...
    * Waiting for Exacloud endpoint to complete. Will retry in 15 seconds...
    * Got 200 status from Exacloud
    * HOSTNAME                                              | MAX VM SIZE
    * sea201602exdd001.sea201602exd.adminsea2.oraclevcn.com | 1347.9 GB
    * sea201602exdd002.sea201602exd.adminsea2.oraclevcn.com | 1347.9 GB
```


## Collect VM core logs

### Description
Calls Exacloud to start the collection of the VM core logs for a given VM. Once in status 200, the status details will contain the OSS URL where the logs can be found.

### Usages
`exaunit collectvmcorelogs <exaunitId> vmName=<vm_name> [idemtoken=<idemtoken>]`

#### Values
`exaunit_id : The id of the exaunit (such as 1, 2...)`
`vmName : the name of the VM where the logs will be collected from`
`idemtoken : the idemtoken for this request`}

### Examples
```json
ecra> exaunit collectvmcorelogs 1869 vmName=atpd-exa-lnsk01.client.exaclouddev.oraclevcn.com 
* {
    "status": 202,
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/92d60fb9-fc77-4c4c-abe2-279da8e3611c",
    "op": "exaunit_vmcorecollect_post",
    "op_start_time": "2025-03-03T03:41:07+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
ecra> status 12e40fh7-fg80-3e3e-dca1-173df8a1520b
* {"progress_percent": 0, "start_time": "2025-03-03T03:41:07+0000", "start_time_ts": "2025-03-03 03:41:07.0", "end_time": "2025-03-03T04:35:58+0000", 
"ecra_server": "EcraServer2", "last_heartbeat_update": "2025-03-03T04:35:58+0000", "wf_uuid": "3164389d-agn6-14a2-b8fc-122852agee2d", "status": 200, 
"message": "Done", "op": "exaunit_vmcorecollect_post", "completion_percentage": 0, 
"step_progress_details": "{\"bucket\": \"vmcore-mos-logs-bucket\", \"object_name\": \"atpd-exa-lnsk01.client.exaclouddev.oraclevcn.com\"}",
"status_uri": "http://atp-ecra6.emmgmt.adminsea2.oraclevcn.com:9013/ecra/endpoint/statuses/12e40fh7-fg80-3e3e-dca1-173df8a1520b", 
"status-detail": "success"}
```

# VM
## Start 
### Description
Stop the given vm on the given exaunit.
### Usage
```
ecra> vm start <exaunit-id> <vm-name|_all_> [env=<env-value>]
```
### Example
```
ecra> vm start 8 slcqab02adm05vm05.us.oracle.com
* Starting vm slcqab02adm05vm05.us.oracle.com on exaunit 8
* STATUS URI : http://den01gpy.us.oracle.com:9001/ecra/endpoint/statuses/ff9ab45c-6362-11e7-9030-fa163ed5ac29
* TARGET URI : http://den01gpy.us.oracle.com:9001/ecra/endpoint/vms/slcqab02adm05vm05.us.oracle.com
* Request issued. Wait for completion. Pulling Status.
* Status: processing... ...... ...... ...... ...... ...... ...... ......
* Request start_vm successfully completed

ecra> vm start 41 _all_ env=gen2
* Starting vm _all_ on exaunit 41
http://iad1devecra1.ecramgmt.adminiad1.oraclevcn.com:9001/ecra/endpoint/statuses/cc503f11-654c-4123-92cb-7bae1711578a
```
### Arguments
#### Mandatory
- **exaunit-id**: The exaunit-id is a mandatory numeric value
- **vm-name**: The FQDN of the VM
#### Optional
- **env**: The env values - gen1, gen2 are the allowed values


## Stop 
### Description
Stop the given vm on the given exaunit.
### Usage
```
ecra> vm stop <exaunit-id> <vm-name|_all_> [env=<env-value>]
```
### Example
```
ecra> vm stop 8 slcqab02adm05vm05.us.oracle.com
* Stoping vm slcqab02adm05vm05.us.oracle.com on exaunit 8
* STATUS URI : http://den01gpy.us.oracle.com:9001/ecra/endpoint/statuses/086434b0-6362-11e7-9030-fa163ed5ac29
* TARGET URI : http://den01gpy.us.oracle.com:9001/ecra/endpoint/vms/slcqab02adm05vm05.us.oracle.com
* Request issued. Wait for completion. Pulling Status.
* Status: processing... ...... ...... ...... ......
* Request stop_vm successfully completed

ecra> vm stop 41 _all_ env=gen2
* Stoping vm _all_ on exaunit 41
http://iad1devecra1.ecramgmt.adminiad1.oraclevcn.com:9001/ecra/endpoint/statuses/628a96b1-f906-4db5-8c74-4bf0fdc3c598
```
### Arguments
#### Mandatory
- **exaunit-id**: The exaunit-id is a mandatory numeric value
- **vm-name**: The FQDN of the VM
#### Optional
- **env**: The env values - gen1, gen2 are the allowed values

## Restart 
### Description
Restart the given VM on the given exaunit
### Usage
```
ecra> vm restart <exaunit-id> <vm-name|_all_> [env=<env-value>]
```
### Example
```
ecra> vm restart 8 slcqab02adm05vm05.us.oracle.com
* Restarting vm slcqab02adm05vm05.us.oracle.com on exaunit 8
* STATUS URI : http://den01gpy.us.oracle.com:9001/ecra/endpoint/statuses/d3330638-6364-11e7-9030-fa163ed5ac29
* TARGET URI : http://den01gpy.us.oracle.com:9001/ecra/endpoint/vms/slcqab02adm05vm05.us.oracle.com
* Request issued. Wait for completion. Pulling Status.
* Status: processing... ...... ...... ......
* Request restart_vm successfully completed

ecra> vm restart 41 _all_
* Warning: The <vm_name> given may be wrong.
* Restarting vm _all_ on exaunit 41
http://iad1devecra1.ecramgmt.adminiad1.oraclevcn.com:9001/ecra/endpoint/statuses/a37aea96-6416-11ee-ad4c-000017006322
```
### Arguments
#### Mandatory
- **exaunit-id**: The exaunit-id is a mandatory numeric value
- **vm-name**: The FQDN of the VM
#### Optional
- **env**: The env values - gen1, gen2 are the allowed values

## Status
### Description
VM Status shows the status of a given VM of a given exaunit
### Usage
```
ecra> vm status <exaunit-id> <vm-name>
```
### Example
```
ecra> vm status 309 sea201323exddu0901.us.oracle.com
* {
    "message": "VM sea201323exddu0901.us.oracle.com is up",
    "op": "exaunit_vmcmd_get",
    "status": 200,
    "status-detail": "success",
    "vmstatus": "up"
}
```
### Arguments
#### Mandatory
- **exaunit-id**: The exaunit-id is a mandatory numeric value
- **vm-name**: The FQDN of the VM

## Relation 
### Description
Shows the information about all the vms that are in the same cluster than the provided one.
### Usage
```
ecra> vm relation <domu=admin hostname>
```
### Example
```
Examples:
ecra> vm relation domu=sea201733exddu0201
* {
    "vms": [
        {
            "adminhostname": "sea201733exddu0101.sea2xx2xx0071qf.adminsea2.oraclevcn.com",
            "clienthostname": "sea201733exddu0101-client1.client.customer2.oraclevcn.com",
            "adminip": "10.0.160.175",
            "rackname": "iad1-d4-cl3-c2fea12a-7b24-407d-8917-f28395a76aad-clu01"
        },
        {
            "adminhostname": "sea201733exddu0201.sea2xx2xx0071qf.adminsea2.oraclevcn.com",
            "clienthostname": "sea201733exddu0201-client2.client.customer2.oraclevcn.com",
            "adminip": "10.0.160.176",
            "rackname": "iad1-d4-cl3-c2fea12a-7b24-407d-8917-f28395a76aad-clu01"
        },
        {
            "adminhostname": "sea201733exddu0301.sea2xx2xx0071qf.adminsea2.oraclevcn.com",
            "clienthostname": "sea201733exddu0301-client3.client.customer2.oraclevcn.com",
            "adminip": "10.0.160.177",
            "adminvlanid": "10",
            "rackname": "iad1-d4-cl3-c2fea12a-7b24-407d-8917-f28395a76aad-clu01",
            "vmocid": "Testing vm"
        },
        {
            "adminhostname": "sea201733exddu0401.sea2xx2xx0071qf.adminsea2.oraclevcn.com",
            "clienthostname": "sea201733exddu0401-client4.client.customer2.oraclevcn.com",
            "adminip": "10.0.160.178",
            "rackname": "iad1-d4-cl3-c2fea12a-7b24-407d-8917-f28395a76aad-clu01"
        }
    ],
    "status": 200,
    "op": "vm_relation_get",
    "status-detail": "success"
}

```
### Arguments
#### Mandatory
- **domu**: Admin hostname of the vm without domainname

# DOMU
## Get
### Description
Finds the domu by the given name and prints all its values from the current status.
### Usage
```commandline
ecra> domu get name=<ADMIN_HOST_NAME> resumelevel=<RESUME_LEVEL>
```
### Example
```commandline
ecra> domu get name=iad103709exddu0401
* {
    "status": 200,
    "message": "Successful DomU fetch",
    "status-detail": "Successful DomU fetch",
    "op": "domu_name_data",
    "domu": {
        "ecs_racks_name": "iad1-d4-cl3-fcdb8f7d-362d-45be-9c51-fb858901362d-clu01",
        "hw_node_id": "439",
        "db_client_mac": "00:10:45:15:ba:d5",
        "db_backup_mac": "02:00:17:01:af:fe",
        "gateway_adapter": "CLIENT",
        "hostname_adapter": "CLIENT",
        "admin_ip": "10.0.6.50",
        "admin_host_name": "iad103709exddu0401",
        "admin_netmask": "255.255.255.128",
        "admin_domianname": "iad103709exd.adminiad1.oraclevcn.com",
        "admin_vlan_tag": "",
        "admin_gateway": "10.0.6.1",
        "admin_network_type": "NAT",
        ...
        "customer_client_mac": "",
        "customer_client_vlantag": "",
        "customer_client_mtu": "",
        "customer_client_standby_vnic_mac": "",
        "customer_backup_mac": "",
        "customer_backup_vlantag": "",
        "customer_backup_mtu": "",
        "customer_backup_standby_vnic_mac": ""
    }
}
```
### Arguments
#### Mandatory
- **name**: The **_admin_host_name_** for the given domU, as it is unique. 
#### Optional
- **resumelevel**: Returns a complete or a partial list of fields, 0 is all and 2 is the minimum

## Search 
### Description
Search for a domu by the given parameters. Using the nathostname or the clienthostname as parameter will also print the exaunit detail info the domu belongs to.
### Usage
```commandline
ecra> domu search cabinetid=<CABINET_ID> exaunitid=<EXAUNIT_ID> rackname=<RACKNAME> hwid=<HW_ID> computehostname=<COMPUTE_HOSTNAME> vmid=<VMID> nathostname=<NAT_HOSTNAME> clienthostname=<CLIENT_HOSTNAME> adminip=<ADMIN_IP> dbclientvlantag=<DB_CLIENT_VLAN_TAG> resumelevel=<RESUME_LEVEL> 
```
### Example
```commandline
ecra> domu search cabinetid=32 hwid=439 exaunitid=603 computehostname=iad103709exdd004 resumelevel=2 
* {
     "status": 200,
     "message": "Successful DomU fetch",
     "status-detail": "Successful DomU fetch",
     "op": "domu_name_composed_data",
     "domus": [
         {
             "ecs_racks_name": "iad1-d4-cl3-fcdb8f7d-362d-45be-9c51-fb858901362d-clu01",
             "hw_node_id": "439",
             "gateway_adapter": "CLIENT",
             "hostname_adapter": "CLIENT",
             "admin_ip": "10.0.6.50",
             "admin_host_name": "iad103709exddu0401",
             "admin_domianname": "iad103709exd.adminiad1.oraclevcn.com",
             "db_client_mac": "00:10:45:15:ba:d5",
             "db_client_ip": "10.0.0.2",
             "db_client_host_name": "iad103709exdd004-client",
             "db_client_domianname": "backup.customer2.oraclevcn.com",
             "db_backup_mac": "02:00:17:01:af:fe",
             "db_backup_ip": "10.0.1.2",
             "db_backup_host_name": "iad103709exdd004-backup",
             "db_backup_domianname": "data.customer2.oraclevcn.com"
         }
     ]
 }
```
### Arguments
#### Optional
- **CABINET_ID**: Indicates a search for all domus from a given cebinet id
- **EXAUNIT_ID**: Indicates a search for all domus from a given exaunit id
- **RACKNAME**: Indicates a search for all domus from a given exaunit id
- **HW_ID**: Indicates a search for all domus from a given hardware node id
- **VMID**: Indicates a search for all domus from a given hardware node id
- **COMPUTE_HOSTNAME**: Indicates a search for all domus from a given compute hostname
- **RESUME_LEVEL**: Indicates how many fields will be returned 0 is for all fields 2 for minimum
- **resumelevel**: Returns a complete or a partial list of fields, 0 is all and 2 is the minimum

## deletebadhostname 
### Description
Deletes the domu record associated with the provided nathostname and the badnathostname rack.
### Usage
```commandline
ecra> domu deletebadhostname nathostname=<NATHOSTNAME>
```
### Example
```commandline
ecra> domu deletebadhostname nathostname=iad103709exddu1701
* {
    "status": 200,
    "message": "Successful deletion",
    "status-detail": "Successful deletion",
    "op": "domu_delete_badnathostname",
    "result": "Successful deletion of badnathostname with nathostname[iad103709exddu1701]"
}
```
### Arguments
#### Mandatory
- **NATHOSTNAME**: Nat hostname that is associated with the badhostname rack. 

# Analytics

## getoperationdetails
### Description
Display the full details of all the operations matching the specified operation name.
### Usage
```commandline
ecra> analytics getoperationdetails operation=<OP_NAME> start_date=<START_DATE> end_date=<END_DATE>
```
### Example
```commandline
ecra> analytics getoperationdetails property_put
* {
    "result": [
        {
            "id": 1,
            "operation": "upgrade_history_post",
            "status": "200",
            "start_time": "2022-06-28T16:48:50+0000",
            "end_time": "2022-06-28T16:48:51+0000"
        }
    ],
    "status": 200,
    "op": "analyticsFullOperation_get",
    "status-detail": "success"
}
```
### Arguments
#### Mandatory
- **OP_NAME:** Indicates the operation name to be matched.

#### Optional
- **START_DATE:** Finds records starting from this particular date on.
- **END_DATE:** Finds recors up until this particular date.

## Info

### Description
Based on the rackname, exaunitid or exadatainfrastructure, the command will show the operations stored in ecs_analytics table   

### Usages
`analytics info [rackname=<RACKNAME>] [exaunitid=<EXAUNITID>] [exadatainfrastructure=<EXADATAINFRASTRUCTURE>] [start_date=<YYYY-MM-DD>] [end_date=<YYYY-MM-DD>] [interval=<DAYSINTERVAL>]`

#### Values
` <RACKNAME> : The name of the rack that will be used for the report`
` <EXAUNITID> : The id of the exaunit that will be used for the report`
` <EXADATAINFRASTRUCTURE> : The exadatainfrastructure that will be used for the report`
` <Interval> : if no value is provided profiling will retrieve information since 365 days in the past from current date`
` <Start_date> : Start date default value is 365 days in past from current date`
` <End_date> : Default value will be current date`

### Examples
```json
ecra> analytics info rackname=iad103714exd-d0-01-02-cl-01-03-clu01
* {
    "op": "analytics_info_post",
    "results": [
        {
            "ceiocid": "flowtesterInfra",
            "end_time": "2023-08-17T16:08:31+0000",
            "exaunitid": 123,
            "id": 33,
            "idemtoken": "815badf2-3623-4cbd-8147-0a9abd19112b",
            "operation": "elastic_cei_post",
            "rackname": "iad103714exd-d0-01-02-cl-01-03-clu01",
            "start_time": "2023-08-17T16:08:31+0000"
        }
    ],
    "status": 200,
    "status-detail": "success"
}

ecra> analytics info exaunitid=123
* {
    "op": "analytics_info_post",
    "results": [
        {
            "ceiocid": "flowtesterInfra",
            "end_time": "2023-08-17T16:08:31+0000",
            "exaunitid": 123,
            "id": 33,
            "idemtoken": "815badf2-3623-4cbd-8147-0a9abd19112b",
            "operation": "elastic_cei_post",
            "rackname": "iad103714exd-d0-01-02-cl-01-03-clu01",
            "start_time": "2023-08-17T16:08:31+0000"
        }
    ],
    "status": 200,
    "status-detail": "success"
}

ecra> analytics info exadatainfrastructure=flowtesterInfra
* {
    "op": "analytics_info_post",
    "results": [
        {
            "ceiocid": "flowtesterInfra",
            "end_time": "2023-08-17T16:07:16+0000",
            "id": 32,
            "idemtoken": "b8c51505-9185-415f-92df-56af4ba91db3",
            "operation": "elastic_cei_post",
            "start_time": "2023-08-17T16:07:16+0000"
        },
        {
            "ceiocid": "flowtesterInfra",
            "end_time": "2023-08-17T16:08:31+0000",
            "exaunitid": 123,
            "id": 33,
            "idemtoken": "815badf2-3623-4cbd-8147-0a9abd19112b",
            "operation": "elastic_cei_post",
            "rackname": "iad103714exd-d0-01-02-cl-01-03-clu01",
            "start_time": "2023-08-17T16:08:31+0000"
        },
        {
            "ceiocid": "flowtesterInfra",
            "end_time": "2023-08-17T16:09:06+0000",
            "id": 34,
            "idemtoken": "30cb7365-fdb8-43ef-a152-1b4d48fa1e92",
            "operation": "elastic_cei_post",
            "start_time": "2023-08-17T16:09:06+0000"
        },
        {
            "ceiocid": "flowtesterInfra",
            "end_time": "2023-08-17T16:10:36+0000",
            "id": 35,
            "idemtoken": "4231a361-a91d-49ea-b4e1-c8ba67cc9784",
            "operation": "elastic_cei_post",
            "start_time": "2023-08-17T16:10:36+0000"
        }
    ],
    "status": 200,
    "status-detail": "success"
}
```

## Get payload

### Description
Based on the id the command will show the payload stored in ecs_analytics table   

### Usages
`analytics getpayload [id=<ANALYTICS_ID>]`

#### Values
` <ID> : The id of the operation in ecs_analytics`

### Examples
```json
ecra> analytics getpayload id=35
* {
    "op": "analytics_get_payload_post",
    "payload": {
        "exadataInfrastructureId": "flowtesterInfra",
        "fabricname": null,
        "faultdomain": null,
        "idemtoken": "4231a361-a91d-49ea-b4e1-c8ba67cc9784",
        "multiVM": true,
        "provisionType": null,
        "servers": [
            {
                "hw_type": "CELL",
                "model": "X8M-2",
                "quantity": 3
            },
            {
                "dom0_bonding": true,
                "hw_type": "COMPUTE",
                "model": "X8M-2",
                "quantity": 4
            }
        ],
        "tenantName": "dbaasnm",
        "tenantOcid": "ocid1.cloudexadatainfrastructure.region1.sea.anzwkljsinjoekaaep2yyhfkxoyejr4ijamds2oidrdu7untvshgpcmcvbla"
    },
    "status": 200,
    "status-detail": "success"
}
```

# Profiling 

## Profiling report

### Description
*The use of profiling is to allow reviewing information about the operations that are carried out at rack or general information*

### Usages
`profiling report [start_date=<YYYY-MM-DD>] [end_date=<YYYY-MM-DD>] [interval=<DAYSINTERVAL>] [rackname=<RACKNAME>]
    -This parameters are excluyent so if start/end date are provided interval should not be provided and vice versa"
    -If start-end dates provided are non valid will use default values for corresponding value`

#### Values
` Interval    : if non value is provided profiling will retrieve information since 365 days in the past from current date`
` Start_date  : Start date default value is 365 days in past from current date`
` End_date    : Default value will be current date`
` alloperations: this parameter is for display only operations included in a white list. The Default value is false and show the operation in white list.`

### Examples:
```json
ecra> profiling report
* {
    "adbd": {},
    "exacs": {
        "task": [
            {
                "Max": 1,
                "Min": 0,
                "Avg": 0,
                "taskName: ": "reshapeService",
                "totalRequests": 260,
                "totalSuccessRequests": 260,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "taskName: ": "Patching",
                "totalRequests": 0,
                "totalSuccessRequests": 0,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "Max": 2,
                "Min": 0,
                "Avg": 1,
                "taskName: ": "mvmAttachStorage",
                "totalRequests": 11,
                "totalSuccessRequests": 11,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "Max": 0,
                "Min": 0,
                "Avg": 0,
                "taskName: ": "ElasticCreation",
                "totalRequests": 334,
                "totalSuccessRequests": 334,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "Max": 2586,
                "Min": 6,
                "Avg": 39,
                "taskName: ": "DeleteNode",
                "totalRequests": 82,
                "totalSuccessRequests": 81,
                "totalInprogressRequests": 1,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "Max": 1,
                "Min": 0,
                "Avg": 0,
                "taskName: ": "exaunitAttachCell",
                "totalRequests": 48,
                "totalSuccessRequests": 48,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "Max": 19,
                "Min": 0,
                "Avg": 0,
                "taskName: ": "DeletePod",
                "totalRequests": 470,
                "totalSuccessRequests": 469,
                "totalInprogressRequests": 1,
                "totalFailedRequests": 0,
                "retry": 8,
                "undo": 8
            },
            {
                "Max": 13,
                "Min": 7,
                "Avg": 9,
                "taskName: ": "CreateService",
                "totalRequests": 452,
                "totalSuccessRequests": 447,
                "totalInprogressRequests": 5,
                "totalFailedRequests": 0,
                "retry": 61,
                "undo": 40
            },
            {
                "Max": 1,
                "Min": 0,
                "Avg": 0,
                "taskName: ": "ElasticDeletion",
                "totalRequests": 322,
                "totalSuccessRequests": 322,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "Max": 1,
                "Min": 0,
                "Avg": 0,
                "taskName: ": "exaunitDeleteCell",
                "totalRequests": 17,
                "totalSuccessRequests": 17,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            },
            {
                "Max": 2,
                "Min": 0,
                "Avg": 0,
                "taskName: ": "ociAttachCell",
                "totalRequests": 23,
                "totalSuccessRequests": 23,
                "totalInprogressRequests": 0,
                "totalFailedRequests": 0,
                "retry": 0,
                "undo": 0
            }
        ]
    },
    "StartDate": "2021-12-09",
    "EndDate": "2022-12-09",
    "UsedTimeUnit": "Minutes",
    "status": 200,
    "op": "profiling_put",
    "status-detail": "success"
}

```
## Profiling operation

### Description
*It will give a report for specific given operations. For example, timmings for create-starter-db on ecs_request table. 
    
    -The parameters are mutually exclusive - if start/end date are provided interval should not be provided and vice versa
    -If start-end dates provided are non valid will use default values for corresponding value*

### Usages
`profiling operation taskId=<Operation_ID> [start_date=<YYYY-MM-DD>] [end_date=<YYYY-MM-DD>] [interval=<DAYSINTERVAL>] [subtask=<True>]`

#### Values
` Interval    : if non value is provided profiling will retrieve information since 365 days in the past from current date`
` Start_date  : Start date default value is 365 days in past from current date`
` End_date    : Default value will be current date`
` TaskID      : Specific task to profile`
` subtask     : if subtask is true the result show the sub-task of the operation given`

### Examples:
```json
ecra> profiling operation taskId=CreateService subtask=True
* {
    "Max": 13,
    "Min": 7,
    "Avg": 9,
    "subtask:": [
        {
            "subtaskname": "PostGINID",
            "total": 447,
            "Min": "00:00:20.856",
            "Max": "00:01:20.232",
            "Avg": "00:00:55.197"
        },
        {
            "subtaskname": "FetchUpdatedXmlFromExacloud",
            "total": 447,
            "Min": "00:00:14.266",
            "Max": "00:00:46.052",
            "Avg": "00:00:23.758"
        },
        {
            "subtaskname": "PostCreateService",
            "total": 447,
            "Min": "00:00:00.056",
            "Max": "00:02:31.131",
            "Avg": "00:00:24.150"
        },
        {
            "subtaskname": "CreateVM",
            "total": 447,
            "Min": "00:00:16.598",
            "Max": "00:01:20.555",
            "Avg": "00:00:55.372"
        },
        {
            "subtaskname": "PostGIInstall",
            "total": 447,
            "Min": "00:00:30.164",
            "Max": "00:01:20.143",
            "Avg": "00:00:55.417"
        },
        {
            "subtaskname": "PreVMChecks",
            "total": 447,
            "Min": "00:00:07.328",
            "Max": "00:01:24.238",
            "Avg": "00:00:43.125"
        },
        {
            "subtaskname": "EcraMetadataUpdateElasticCompose",
            "total": 314,
            "Min": "00:00:00.001",
            "Max": "00:00:00.485",
            "Avg": "00:00:00.069"
        },
        {
            "subtaskname": "EcraMetaDataUpdate",
            "total": 447,
            "Min": "00:00:00.003",
            "Max": "00:00:01.744",
            "Avg": "00:00:00.383"
        },
        {
            "subtaskname": "FetchCreatedComposeXml",
            "total": 314,
            "Min": "00:00:00.003",
            "Max": "00:00:54.473",
            "Avg": "00:00:15.609"
        },
        {
            "subtaskname": "CreateUser",
            "total": 447,
            "Min": "00:00:25.303",
            "Max": "00:01:20.799",
            "Avg": "00:00:55.473"
        },
        {
            "subtaskname": "CreateStorage",
            "total": 447,
            "Min": "00:00:36.039",
            "Max": "00:01:22.994",
            "Avg": "00:00:55.494"
        },
        {
            "subtaskname": "PostVMInstall",
            "total": 447,
            "Min": "00:00:30.599",
            "Max": "00:01:20.406",
            "Avg": "00:00:55.469"
        },
        {
            "subtaskname": "InstallCluster",
            "total": 447,
            "Min": "00:00:30.486",
            "Max": "00:01:20.396",
            "Avg": "00:00:55.505"
        },
        {
            "subtaskname": "PreVMSetup",
            "total": 447,
            "Min": "00:00:29.852",
            "Max": "00:01:20.202",
            "Avg": "00:00:55.540"
        },
        {
            "subtaskname": "ATPExacloudJSONCreation",
            "total": 447,
            "Min": "00:00:00.005",
            "Max": "00:07:10.845",
            "Avg": "00:00:21.257"
        }
    ],
    "StartDate": "2021-12-09",
    "EndDate": "2022-12-09",
    "UsedTimeUnit": "Minutes",
    "operationId": "CreateService",
    "status": 200,
    "op": "profiling_operation_put",
    "status-detail": "success"
}

```
## Profiling infrastructure

### Description
*It will give a report for specific given infrastructure. For example, timmings for create-starter-db on ecs_wf_request table. 
    
    -The parameters are mutually exclusive - if start/end date are provided interval should not be provided and vice versa
    -If start-end dates provided are non valid will use default values for corresponding value*

### Usages
`profiling infrastructure ceiocid=<ceiocid> [start_date=<YYYY-MM-DD>] [end_date=<YYYY-MM-DD>] [interval=<DAYSINTERVAL>]`

#### Values
` Interval    : if non value is provided profiling will retrieve information since 365 days in the past from current date`
` Start_date  : Start date default value is 365 days in past from current date`
` End_date    : Default value will be current date`
` ceiocid      : Specific task to profile`
` subtask     : if subtask is true the result show the sub-task of the operation given`

### Examples:
```json
ecra> ecracli profiling infrastructure ceiocid=testdbsystem2mvm
{
    "Max": 50,
    "Min": 50,
    "Avg": 50,
    "StdDeviation": 0,
    "StartDate": "2020-12-12",
    "EndDate": "2021-01-11",
    "UsedTimeUnit": "Minutes",
    "operationId": "create-starter-db",
    "status": 200,
    "op": "profiling_operation_put",
    "status-detail": "success"
}

```

# Ecra

## getfile

### Description
*Retrieves and downloads the specified file from the ECRA_FILES table in the database to the corresponding file system directory.*

### Usages
`errorcode getfile <filename>`

### Examples:
```json
ecra> ecra getfile ../json/delete_service_input_exa_205.json
* {   
    "file_path": "../json/delete_service_input_exa_205.json",
    "status": 200,
    "op": "ecra_file_get",
    "status-detail": "success"
}
```

## check

### Description
*Performs a series of operations to verify the status of each ECRA component (WLS, DB, ExaCloud, Managed Servers).*

### Usages
`ecra check`

### Examples:
```json
ecra> ecra check
* {
    "weblogic": {
        "healthy": true
    },
    "database": {
        "healthy": true
    },
    "managedServers": [
        {
            "hostname": "http://phoenix109261.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/",
            "healthy": true
        },
        {
            "hostname": "http://phoenix109261.dev3sub3phx.databasede3phx.oraclevcn.com:9062/ecra/endpoint/",
            "details": "Server unreachable.",
            "healthy": false
        }
    ],
    "exacloud": {
        "healthy": true
    }
}
```

## connect

### Description
*Connect ECRACLI to the specified ECRA host. All the following operations will be executed using the new host.*

### Usages
`ecra connect`

### Examples:
```json
ecra> ecra connect http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/
* {
    "status": 200,
    "hostname": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/",
    "message": "The ECRA host has been set to: http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/"
}
```
## updatefile

### Description
*Updates a the file contents on a file on the database using the filename
             as destination and content path as the information to update*

### Usages
`./ecracli ecra updatefile filename=<filename> contentpath=<path of new content file>`

### Examples:
```json
ecra> ecra updatefile filename=../PodRepo/new_xml_rack_payload_sea2-d4-cl3-6eeb66d9-2655-44ed-b007-22a5df51c0ba-clu01_fbab3d31-fd45-4c15-8f44-cb0709a093e4.json contentpath=/scratch/gvalderr/ecra_installs/myecra/mw_home/user_projects/domains/PodRepo/newcontentfile.json
* {"updated_file": "../PodRepo/new_xml_rack_payload_sea2-d4-cl3-6eeb66d9-2655-44ed-b007-22a5df51c0ba-clu01_fbab3d31-fd45-4c15-8f44-cb0709a093e4.json", "status": 200, "op": "ecra_file_update_put", "status-detail": "success"}

```

## listfiles

### Description
* Retrieves a list of files related to the rackname or exaunit id indicated *

### Usages
`./ecracli ecra listfiles [rackname=<filename>|exaunitid=<exaunitid>] [maxfiles=<number of max files to display>]`

### Examples:
```json
ecra> ecra listfiles rackname=sea2-d4-cl3-6eeb66d9-2655-44ed-b007-22a5df51c0ba-clu01 maxfiles=5
* {
    "filelist": [
        {
            "filename": "../PodRepo/new_xml_rack_created_sea2-d4-cl3-6eeb66d9-2655-44ed-b007-22a5df51c0ba-clu01_09b852ec-6479-4b38-8b00-0acd0da3eb40.xml",
            "date": "2024-11-25 20:37:09"
        },
        {
            "filename": "../PodRepo/new_xml_rack_payload_sea2-d4-cl3-6eeb66d9-2655-44ed-b007-22a5df51c0ba-clu01_fbab3d31-fd45-4c15-8f44-cb0709a093e4.json",
            "date": "2024-11-25 20:36:49"
        },
        {
            "filename": "../PodRepo/rack_sea2-d4-cl3-6eeb66d9-2655-44ed-b007-22a5df51c0ba-clu01_updated_xml.xml",
            "date": "2024-11-25 20:36:18"
        },
        {
            "filename": "../json/delete_service_input_exa_2654.json",
            "date": "2024-11-25 20:36:17"
        },
        {
            "filename": "../PodRepo/XMLTransientStorage__337_ccdb2654-c323-4d39-a074-4430c66b02a5.xml",
            "date": "2024-11-25 20:35:30"
        }
    ],
    "status": 200,
    "op": "ecra_file_list_get",
    "status-detail": "success"
}
```

# Cache

## purge

### Description
*Performs a cleanup on a specific cache instance.*

### Usages
`cache purge type=<purge_type>`

### Examples
```
ecra> cache purge type=cspostchecks
* {
    "msg": "ConfigCSHandler singleton has been purged",
    "status": 200,
    "op": "analytics_cs_config_delete",
    "status-detail": "success"
}
```

# Ingestion

## import

### Description
* Import a cabinet into ECRA as a part of ingestion *

### Usages
`ingestion import action=<IMPORT_ACTION> cabinetname=<CABINET_NAME> cabinetjson=<CABINET_JSON>`

#### Values
`  <IMPORT_ACTION>: Import actions such as updatecabinet. Actions that will be supported in the future are import, delete etc.`
`  <CABINET_NAME>: Name of the cabinet being imported.`
`  <CABINET_JSON>: Cabinet details in a json format.`

### Examples:
```
ecra> ingestion import action=updatecabinet cabinetname=sea201605 cabinetjson=/path/to/payloads/sea201605.json
* TODO
```


# Preprov

## jobs get

### Description
*Retrieves the metadata of a pre-prov job or a list of all pre-prov jobs.*

### Arguments
**job:** The job that will return its metadata. If left empty, a list of all jobs will be provided instead.

### Usages
`preprov jobs get`

`preprov jobs get <job>`

### Examples
```
ecra> preprov jobs get
* {
    "jobs": [
        {
            "job_class": "oracle.exadata.ecra.preprovision.jobs.SetupOracleNetworkJob",
            "job_category": "PREPROV"
        }
    ]
}

ecra> preprov jobs get oracle.exadata.ecra.preprovision.jobs.SetupOracleNetworkJob
* {
    "vcn": {
        "cidr": "10.0.0.0/16",
        "label": "preprovvcn"
    },
    "subnets": [
        {
            "type": "client",
            "cidr": "10.0.0.0/18"
        },
        {
            "type": "backup",
            "cidr": "10.0.64.0/18"
        }
    ],
    "securityRules": {
        "ingress": [
            {
                "protocol": "TCP",
                "stateless": false,
                "destinationMinPort": -1,
                "destinationMaxPort": -1,
                "sourceMinPort": -1,
                "sourceMaxPort": -1,
                "allOpen": true
            },
            {
                "protocol": "ICMP",
                "stateless": false,
                "icmpCode": -1,
                "icmpType": -1,
                "allOpen": true
            }
        ],
        "egress": [
            {
                "protocol": "ALL",
                "stateless": false,
                "destinationMinPort": -1,
                "destinationMaxPort": -1,
                "sourceMinPort": -1,
                "sourceMaxPort": -1,
                "allOpen": true
            }
        ]
    },
    "timeout": 86400
}
```

## jobs update

### Description
*Updates the metadata field of a specific job*

### Arguments
**job**: The job to be updated
**configuration**: The path to the file which content will replace the old metadata from the job

### Usages
`preprov jobs update <job> configuration=<config_path>`

### Example:
```
ecra> preprov jobs update oracle.exadata.ecra.preprovision.jobs.SetupOracleNetworkJob configuration=/scratch/ririgoye/scripts/testConfig.json
* {
    "status": 200,
    "op": "preprov_job_put",
    "status-detail": "success"
}
```

## scheduler

### Description
*Controls the pre-prov jobs scheduler and retrieves its info*

### Arguments:
**operation**: The action for the scheduler to perform

### Usages
`preprov scheduler <start|stop|get>`

### Examples:
```
ecra> preprov scheduler list
* {
    "schedulers": [],
    "status": 200,
    "op": "preprov_scheduler_get",
    "status-detail": "success"
}

ecra> preprov scheduler stop
* {
    "message": "Successfully shut down pre provisioning scheduler.",
    "status": 200,
    "op": "preprov_scheduler_shutdown",
    "status-detail": "success"
}

ecra> preprov scheduler start
* {
    "message": "Succesfully started pre provisioning scheduler.",
    "status": 200,
    "op": "preprov_scheduler_start",
    "status-detail": "success"
}
```

## deleterackresources

### Description
*Performs async delete operation in a rack and removes related resources*

### Arguments
**rackname**: Rack where the operation is to be performed<br>
**keepvnic**: [Optional] true or false. Either keep or delete vnic<br>
**keepcompute**: [Optional] true or false. Either keep or delete compute<br>
**keepdns**: [Optional] true or false. Either keep or delete dns records<br>

### Usages
`preprov deleterackresources rackname=<rackname>`

`preprov deleterackresources rackname=<rackname> keepvnic=<true|false> keepcompute=<true|false>`

### Examples
<details>
    <summary>deleterackresources with no options</summary>

```
ecra> preprov deleterackresources iad1-d4-cl4-07bb6908-d078-4b8a-a989-190f6aa9b6f5-clu01
* {
    "status": 202,
    "status_uri": "http://phoenix94112.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/2a647f7f-49a8-4c3c-affc-ef8be9412f60",
    "op": "rack_preprov_resources_delete",
    "op_start_time": "2023-02-24T16:23:02+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
```
## vcn get

### Description
*Retrieves a list with all the VCNs.*

### Arguments

### Usages
`preprov vcn get`

### Example:
```
ecra> preprov vcn get
* {
    "vcn": [
        {
            "vcn_id": "ocid1.vcn.region1.sea.5a7a628e32454c819253bafd3c8dd3b8",
            "vcn_fsm": "CREATED",
            "compartmentocid": "ocid1.compartment.oc1..aaaaaaaa6ogkvtvysivo3wnipdfvtptukofwlkcuztdkifzurhe7r3itymha",
            "cidrblock": "10.0.0.0/16"
        }
    ],
    "status": 200,
    "op": "preprov_vcn_get",
    "status-detail": "success"
}
```

## subnet get

### Description
*Retrieves a list with all the subnets.*

### Arguments

### Usages
`preprov subnet get`

### Example:
```
ecra> preprov subnet get
* {
    "subnet": [
        {
            "name": "preprovclient",
            "vcnocid": "ocid1.vcn.region1.sea.5a7a628e32454c819253bafd3c8dd3b8",
            "ocid": "ocid1.subnet.region1.sea.1a9baddc198a4e6380bbc89ae282f4f2",
            "cidrblock": "10.0.0.0/18",
            "subnettype": "CLIENT",
            "availabilitydomain": "hmAF:SEA-AD-2",
            "domain": "client.preprovvcnmain.oraclevcn.com"
        },
        {
            "name": "preprovbackup",
            "vcnocid": "ocid1.vcn.region1.sea.5a7a628e32454c819253bafd3c8dd3b8",
            "ocid": "ocid1.subnet.region1.sea.90d2edd1a8204dae9d480f930c0e5850",
            "cidrblock": "10.0.64.0/18",
            "subnettype": "BACKUP",
            "availabilitydomain": "hmAF:SEA-AD-2",
            "domain": "client.preprovvcnmain.oraclevcn.com"
        }
    ],
    "status": 200,
    "op": "preprov_subnet_get",
    "status-detail": "success"
}
```

## vnics get

### Description
*Retrieves a list with all the vnics.*

### Arguments
**rackname:** Rack where the operation is to be performed

### Usages
`preprov vnics get`

### Example:
```
ecra> preprov vnics get
* {
    "vnics": [
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.ODE5Njc0YWUtNDE1Yi00YjIzLWI4MjUtMGQzNDYyNTc2YzA0",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.MzU1YmM2MDktOTRmMC00OTc2LTliMDQtNDNkZDdhNDdhMTA5",
            "hostnamelabel": "c3709n18c1-v-ac"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.Njk2MTk0ZjctNDlmNC00ZTQ5LTg0NmMtMjVkNzg0ZDIwYzhk",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.MzU1YmM2MDktOTRmMC00OTc2LTliMDQtNDNkZDdhNDdhMTA5",
            "hostnamelabel": "c3709n18b1-v-ac"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.MmM3NzViNGQtMTIwYS00M2ViLWJiMWUtNDM0YjAwYjEyZTgz",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.NGYxZGJkMWQtOTQ2MC00MWMyLThlZjAtZTM2Y2RkOWFjMWQx",
            "hostnamelabel": "c3709n18c1-v-sb"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.OTU4MTY3ODctZTIzZS00ZmY4LWEzZmYtZjY2ZTA3OTA5MDBk",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.NGYxZGJkMWQtOTQ2MC00MWMyLThlZjAtZTM2Y2RkOWFjMWQx",
            "hostnamelabel": "c3709n18b1-v-sb"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.NGU2ODFiMWYtNjU3Ni00ZTc3LTlmMDYtYmE1YjdjMzQ3ZWJh",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.ZmEzYWNmYTctYWUwNi00ZjExLTk3ZTctZDRiZDQyMDY2NTJh",
            "hostnamelabel": "c3709n17c1-v-ac"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.ZDJlNjc4ZDMtNDVjNy00MjZmLWIzODQtNGNkYjMwMjdhOGIz",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.ZmEzYWNmYTctYWUwNi00ZjExLTk3ZTctZDRiZDQyMDY2NTJh",
            "hostnamelabel": "c3709n17b1-v-ac"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.MzNjMDZkYjAtNWE3My00MDM2LThmYzEtNmQyY2I2ZWM4Nzg4",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.YzNlOWM1ZGYtYjExMC00MzJiLTk4NTgtODc1YmVjYzU2YWRl",
            "hostnamelabel": "c3709n17c1-v-sb"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.YjBhMzI3YmEtNWFlZi00MzI4LTgxMDUtMjNkNDA1ZTQ2OTE4",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.YzNlOWM1ZGYtYjExMC00MzJiLTk4NTgtODc1YmVjYzU2YWRl",
            "hostnamelabel": "c3709n17b1-v-sb"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.MTA5M2EyYTktMTAyNC00ZWVkLWE2MGUtMzFmNDUwOWNkY2Jl",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.YjAxNmMyYTEtOWI4Ni00ZDAxLTkxZDMtYTY3YzJkOThjMzFl",
            "hostnamelabel": "c3709n16c1-v-ac"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.OWRhNGU1ZTgtZTk5ZC00Mjk5LTk0ZjctNTNkYWM3YTdjMzhh",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.YjAxNmMyYTEtOWI4Ni00ZDAxLTkxZDMtYTY3YzJkOThjMzFl",
            "hostnamelabel": "c3709n16b1-v-ac"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.NGZjYzg4Y2UtZWIxMS00NjFiLWJmODAtOGNkZmZkY2ViMDQ5",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.NjI1OTQyZjItNmUxNi00MzM2LThlYTUtYzIxMmJlYmI5NDBh",
            "hostnamelabel": "c3709n16c1-v-sb"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.M2IwYjg1YzUtNGUxYy00MTIxLWI3NzAtN2E4MmI0MjQ3MzIz",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.NjI1OTQyZjItNmUxNi00MzM2LThlYTUtYzIxMmJlYmI5NDBh",
            "hostnamelabel": "c3709n16b1-v-sb"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.NTUyY2FiZjAtNzdkYi00NjhlLWFmY2MtNDQ2MjVmMjdkNTc4",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.ZjA2MzA3MjEtZDFjZC00OWZlLTg3NjctMWFkNGYxOWI5OTc4",
            "hostnamelabel": "c3709n15c1-v-ac"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.NWY3ZGE3YzctMGVlOC00ZDc5LThiYjktNDFkODczNWUyN2I0",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.ZjA2MzA3MjEtZDFjZC00OWZlLTg3NjctMWFkNGYxOWI5OTc4",
            "hostnamelabel": "c3709n15b1-v-ac"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.ZmU2YTE4ZWYtNzFiYi00MzNhLTlmOWEtZjY5NzQ5MTliYWM4",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.YzdhN2M1ZTItYzg3Yy00ZWJiLWE3ZjEtOWQwNzdhY2JhMDUz",
            "hostnamelabel": "c3709n15c1-v-sb"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-ee8c776b-9c91-40cf-94ff-c943e1dbcde0-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.Mjk4MjVmNzUtZDFjZS00ZDA5LWJmNTUtMGI5ZDUwMGU4MzZl",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.YzdhN2M1ZTItYzg3Yy00ZWJiLWE3ZjEtOWQwNzdhY2JhMDUz",
            "hostnamelabel": "c3709n15b1-v-sb"
        }
    ],
    "status": 200,
    "op": "preprov_vnic_get",
    "status-detail": "success"
}

ecra> preprov vnics get rackname=iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01
* {
    "vnics": [
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.ODE5Njc0YWUtNDE1Yi00YjIzLWI4MjUtMGQzNDYyNTc2YzA0",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.MzU1YmM2MDktOTRmMC00OTc2LTliMDQtNDNkZDdhNDdhMTA5",
            "hostnamelabel": "c3709n18c1-v-ac"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.Njk2MTk0ZjctNDlmNC00ZTQ5LTg0NmMtMjVkNzg0ZDIwYzhk",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.MzU1YmM2MDktOTRmMC00OTc2LTliMDQtNDNkZDdhNDdhMTA5",
            "hostnamelabel": "c3709n18b1-v-ac"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.MmM3NzViNGQtMTIwYS00M2ViLWJiMWUtNDM0YjAwYjEyZTgz",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.NGYxZGJkMWQtOTQ2MC00MWMyLThlZjAtZTM2Y2RkOWFjMWQx",
            "hostnamelabel": "c3709n18c1-v-sb"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.OTU4MTY3ODctZTIzZS00ZmY4LWEzZmYtZjY2ZTA3OTA5MDBk",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.NGYxZGJkMWQtOTQ2MC00MWMyLThlZjAtZTM2Y2RkOWFjMWQx",
            "hostnamelabel": "c3709n18b1-v-sb"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.NGU2ODFiMWYtNjU3Ni00ZTc3LTlmMDYtYmE1YjdjMzQ3ZWJh",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.ZmEzYWNmYTctYWUwNi00ZjExLTk3ZTctZDRiZDQyMDY2NTJh",
            "hostnamelabel": "c3709n17c1-v-ac"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.ZDJlNjc4ZDMtNDVjNy00MjZmLWIzODQtNGNkYjMwMjdhOGIz",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.ZmEzYWNmYTctYWUwNi00ZjExLTk3ZTctZDRiZDQyMDY2NTJh",
            "hostnamelabel": "c3709n17b1-v-ac"
        },
        {
            "vlantag": "500",
            "subnetocid": "ocid1.subnet.region1.sea.e2150b55196a418998560097b9cf1c0d",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.MzNjMDZkYjAtNWE3My00MDM2LThmYzEtNmQyY2I2ZWM4Nzg4",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 1,
            "instanceocid": "ocid1.instance.oc1.phx.YzNlOWM1ZGYtYjExMC00MzJiLTk4NTgtODc1YmVjYzU2YWRl",
            "hostnamelabel": "c3709n17c1-v-sb"
        },
        {
            "vlantag": "501",
            "subnetocid": "ocid1.subnet.region1.sea.9052e92e0f21402f8c60d63a2b5c4547",
            "rackname": "iad1-d2-cl3-0c191e75-ad14-48e2-a5cc-0d41096bfca3-clu01",
            "primaryip": "192.168.173.22",
            "ocid": "ocid1.vnic.oc1.phx.YjBhMzI3YmEtNWFlZi00MzI4LTgxMDUtMjNkNDA1ZTQ2OTE4",
            "macaddress": "02:00:17:17:6A:AE",
            "isprimary": 0,
            "instanceocid": "ocid1.instance.oc1.phx.YzNlOWM1ZGYtYjExMC00MzJiLTk4NTgtODc1YmVjYzU2YWRl",
            "hostnamelabel": "c3709n17b1-v-sb"
        }
    ],
    "status": 200,
    "op": "preprov_vnic_get",
    "status-detail": "success"
}
```

Status pull
```
ecra> status 02db312f-a0ba-496d-8654-029d3958c46c
* {"start_time": "2023-02-24T13:21:40+0000", "end_time":
"2023-02-24T13:21:45+0000", "resource_id":
"iad1-d4-cl4-07bb6908-d078-4b8a-a989-190f6aa9b6f5-clu01", "ecra_server":
"EcraServer1", "last_heartbeat_update": "2023-02-24T13:21:40+0000", "status":
200, "message": "Done", "op":
"oracle.exadata.ecra.operations.DeletePreprovResourcesOperation", "atp_enabled":
"Y", "status_uri":
"http://phoenix94112.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/02db312f-a0ba-496d-8654-029d3958c46c",
"status-detail": "success"}
```
</details>

## capacitymove 

### Description
*Performs a exaInfra cleaning for preprov resources, it will delete all clusters, oci resources and finally delete the exaInfra*

### Arguments
**exadatainfrastructureid**: ExadataInfrastructureId to be cleared

### Usages
`preprov capacitymove exadatainfrastructureid<EXAINFRAID>`


### Examples
<details>
    <summary>deleterackresources with no options</summary>

```
ecra> preprov capacitymove exadatainfrastructureid=flowtesterInfra
* {
    "status": 200,
    "status_uri":
"http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f42a9999-f413-4ef2-96fe-9b3d957b4be7",
    "op": "preprov_scheduler_get",
    "op_start_time": "2023-06-30T20:30:39+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
```

Status pull
```
ecra> status f42a9999-f413-4ef2-96fe-9b3d957b4be7
* {"remote_user": "ops", "start_time": "2023-06-30T20:30:39+0000", "progress_percent": 0, "end_time": "2023-06-30T22:41:04+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2023-06-30T20:30:39+0000", "wf_uuid": "82fb9f2f-afca-4855-838d-610de200880d", "status": 200, "message": "Done", "op": "preprov-capacity-move-op", "completion_percentage": 0, "atp_enabled": "N", "status_uri": "http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f42a9999-f413-4ef2-96fe-9b3d957b4be7", "status-detail": "success"}

ecra> workflows describe workflowId=82fb9f2f-afca-4855-838d-610de200880d
* {
    "workflowName": "preprov-capacity-move",
    "workflowId": "82fb9f2f-afca-4855-838d-610de200880d",
    "workflowStatus": "Completed",
    "workflowStartTime": "30 Jun 2023 20:30:39 UTC",
    "workflowEndTime": "30 Jun 2023 20:34:02 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "DeletePreprovClusters",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Fri Jun 30 20:30:39 UTC 2023",
            "taskEndTime": "Fri Jun 30 20:33:21 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:02:42"
        },
        {
            "taskName": "UpdateHwNodesClusterTag",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Fri Jun 30 20:33:21 UTC 2023",
            "taskEndTime": "Fri Jun 30 20:33:21 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "taskName": "DeleteInfraEC",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Fri Jun 30 20:33:21 UTC 2023",
            "taskEndTime": "Fri Jun 30 20:34:02 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:41"
        },
        {
            "taskName": "DeleteInfraMetadata",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Fri Jun 30 20:34:02 UTC 2023",
            "taskEndTime": "Fri Jun 30 20:34:02 UTC 2023",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "DeleteInfraMetadata",
            "lastOperationDetails": {
                "lastTaskLastOperationId":
"e915f52c-8d22-4081-a5de-e3a28782a1b0",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "30 Jun 2023 20:34:02 UTC",
                "lastTaskLastOperationEndTime": "30 Jun 2023 20:34:02 UTC"
            }
        }
    ],
    "exaOCID": "",
    "requestId": "f42a9999-f413-4ef2-96fe-9b3d957b4be7",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}


ecra> exadatainfrastructure get
* {
    "infras": []
}
```
</details>

# VM Backup

## enable

### Description
*Enables vmbackup on the chosen exadata machine (exadata_id)*

### Arguments

### Usages
`ecra> vmbackup enable <exadata_id>`
`./ecracli vmbackup enable <exadata_id>`

### Examples
<details>
    <summary>vmbackup enable with given exadata_id</summary>

```
ecracli> vmbackup enable slcs08adm0506
  {u'Exacloud Cmd Status': u'Pass', u'status': 200, u'Log': [u'Turned VM backup ON on Dom0
  slcs08adm05.usdv1.oraclecloud.com', u'Turned VM backup ON on Dom0
  slcs08adm06.usdv1.oraclecloud.com'], u'status-detail': u'success',
  u'slcs08adm06.usdv1.oraclecloud.com': {u'Exacloud Cmd Status': u'Pass', u'Log': u'Turned VM
  backup ON on Dom0 slcs08adm06.usdv1.oraclecloud.com'},
  u'slcs08adm05.usdv1.oraclecloud.com': {u'Exacloud Cmd Status': u'Pass', u'Log': u'Turned VM
  backup ON on Dom0 slcs08adm05.usdv1.oraclecloud.com'}, u'Command': u'enable',
  u'op': u'vmbackup_properties_set'}
```
</details>

## disable

### Description
*Disables vmbackup on the chosen exadata machine (exadata_id)*

### Arguments

### Usages
`ecra> vmbackup disable <exadata_id>`
`./ecracli vmbackup disable <exadata_id>`

### Examples
<details>
    <summary>vmbackup disable with given exadata_id</summary>

```
ecracli> vmbackup disable slcs08adm0506
  {u'Exacloud Cmd Status': u'Pass', u'status': 200, u'Log': [u'Turned VM backup OFF on Dom0
  slcs08adm05.usdv1.oraclecloud.com', u'Turned VM backup OFF on Dom0
  slcs08adm06.usdv1.oraclecloud.com'], u'status-detail': u'success',
  u'slcs08adm06.usdv1.oraclecloud.com': {u'Exacloud Cmd Status': u'Pass', u'Log': u'Turned
  VM backup OFF on Dom0 slcs08adm06.usdv1.oraclecloud.com'},
  u'slcs08adm05.usdv1.oraclecloud.com': {u'Exacloud Cmd Status': u'Pass', u'Log': u'Turned
  VM backup OFF on Dom0 slcs08adm05.usdv1.oraclecloud.com'}, u'Command':
  u'disable', u'op': u'vmbackup_properties_set'}
```
</details>

## set_param

### Description
*Sets the vmbackup parameter to a value in the vmbackup configuration file in the chosen exadata machine (exadata_id), available commands through ecracli are
  ["remotebackup", "ossbackup", "maxremotebackups" , "deletelocalbackup", "activeblockcommit", "materializedlocalcopy", "ossbucket", "ossgoldbucket", "ossnumbackups"]*

### Arguments

### Usages
`ecra> vmbackup set_param <exadata_id> <parameter>=<value>`
`./ecracli vmbackup set_param <exadata_id> <parameter>=<value>`

### Examples
<details>
    <summary>vmbackup set_param</summary>

```
ecracli> vmbackup set_param slcs08adm0506 remotebackup=disabled 
  {u'Exacloud Cmd Status': u'Pass', u'status': 200, u'Log': u'Setting REMOTE_BACKUP to
  disabled in vmbackup configuration.', u'status-detail': u'success', u'Command':
  u'setparam', u'op': u'vmbackup_properties_set'}
```
</details>

## get_param

### Description
*Gets the vmbackup parameter value from the vmbackup configuration file in the chosen exadata machine (exadata_id)*

### Arguments

### Usages
`ecra> vmbackup get_param <exadata_id> <parameter>`
`./ecracli vmbackup get_param <exadata_id> <parameter>`

### Examples
<details>
    <summary>vmbackup get_param</summary>

```
ecracli> vmbackup get_param slcs08adm0506 REMOTE_BACKUP
  {u'Exacloud Cmd Status': u'Pass', u'status': 200, u'Log': u'Value of vmbackup
  parameter(REMOTE_BACKUP) obtained from configuration file is disabled',
  u'status-detail': u'success', u'REMOTE_BACKUP': u'disabled', u'Command':
  u'getparam', u'op': u'vmbackup_properties_get'}
```
</details>

## install

### Description
*Copy the vmbackup bits to dom0's, fails if the bits are already there*

### Arguments
`rackname: rackname to use during the operation`
`clusterless: yes for compute-only elastic racks`
`Defaul values:`
    `skipchecksum=True`
    `deletelocalbackup=False`
    `remotebackup=disabled`
    `ossbackup=disabled`
    `skipchecksum=True`
    `skipimg=False`
    `materializedlocalcopy`
    `activeblockcommit`

### Usages
`ecra> vmbackup install rackname=<rack_name> stauth=<auth uri> stuser=<user> stkey=<password> [skipchecksum=True|False] [deletelocalbackup=True|False] [remotebackup=enabled|disabled] [ossbackup=enabled|disabled <stauth=<auth uri>> <stuser=<user>> <stkey=<password>>] [skipimg=True|False] [materializedlocalcopy=True|False] [activeblockcommit=True|False] [clusterless=yes|no]`
`./ecracli vmbackup install rackname=<rack_name> stauth=<auth uri> stuser=<user> stkey=<password> [skipchecksum=True|False] [deletelocalbackup=True|False] [remotebackup=enabled|disabled] [ossbackup=enabled|disabled <stauth=<auth uri>> <stuser=<user>> <stkey=<password>>] [skipimg=True|False] [materializedlocalcopy=True|False] [activeblockcommit=True|False] [clusterless=yes|no]`

### Examples
<details>
    <summary>vmbackup install</summary>

```
ecra> vmbackup install rackname=SEA203709 clusterless=yes
* {"status": 200, "op": "vmbackup_install_post", "status-detail": "success"}

ecra> vmbackup install rackname=iad103714exd-d0-03-04-cl-04-06-clu01
* {"status": 200, "op": "vmbackup_install_post", "status-detail": "success"}
```
</details>

## schedulerstatus 

### Description
*Displays information on the status of the internal VMBackup Scheduler job and node states*

### Arguments
- exaunitid: Numeric value to limit the search for node states
- detailed: Only for ecracli use, will display the full response from ECRA API

### Usages
`ecra> vmbackup schedulerstatus [exaunitid=<> detailed=true]`

### Examples
<details>
    <summary>Get Status for exaunitid=626</summary>

```
ecra> vmbackup schedulerstatus exaunitid=626
* Property concurrent backup is not valid
VMBackupJob Job is not enabled
VMBackupStatusTrackerJob Job is not enabled
* VM_BACKUP_IN_PROGRESS: ['iad103709exddu0102', 'iad103709exddu0202',
'sea201610exddu0302']
* VM_BACKUP_COMPLETED: ['sea201610exddu0102']
* VM_BACKUP_SKIPPED_FOR_INFRAPATCHING: ['sea201610exddu0202']
* VM_BACKUP_ERROR: ['sea201610exddu0402']
```
</details>


## schedulerhistory 

### Description
*Returns the history information about the given exaunitid*

### Arguments
- exaunitid: Numeric value to limit the search for node states
- page: Select which page to display
- pagesize: Limit how many items in a page

### Usages
`ecra> vmbackup schedulerstatus exaunitid=<> [page=1 pagesize=20]`

### Examples
<details>
    <summary>Get history for exaunitid=626</summary>

```
ecra> vmbackup schedulerhistory exaunitid=626 page=1 pagesize=2
* {
    "records": [
        {
            "id": "f6b6dab6-341f-43d4-b597-93304cd3461e",
            "backup_trigger_time": "2024-10-18T01:33:02+0000",
            "backup_complete_time": "2024-10-18T01:37:22+0000",
            "target_id": "sea201610exdd001",
            "rackname": "iad1-d2-cl3-56c4816e-ddc5-4ce4-871d-b3c57ee8e92c-clu02",
            "vm_gold_backup": "ENABLED",
            "vm_oss_backup": "ENABLED",
            "tracker_last_update": "2024-10-18T01:37:22+0000",
            "tracker_retry_count": 1,
            "status": "VM_BACKUP_COMPLETED"
        },
        {
            "id": "92f78332-5975-4dab-b9e0-2ffa96c83f26",
            "backup_trigger_time": "2024-10-18T01:33:02+0000",
            "backup_complete_time": "2024-10-18T01:35:41+0000",
            "target_id": "iad103709exdd001",
            "rackname": "iad1-d2-cl3-56c4816e-ddc5-4ce4-871d-b3c57ee8e92c-clu02",
            "vm_gold_backup": "ENABLED",
            "vm_oss_backup": "ENABLED",
            "tracker_last_update": "2024-10-18T01:35:41+0000",
            "tracker_retry_count": 1,
            "status": "VM_BACKUP_COMPLETED"
        }
    ],
    "status": 200,
    "op": "vmbackup_history_get",
    "status-detail": "success"
}
```
</details>


## backup

### Description
*Create a vm backup of all VM's.*

### Arguments
**exaunitid**: exaunitid where the operation is to be performed<br>
**dom0**: dom0 where the operation is to be performed<br>

### Usages
`vmbackup osslist rackname=<rackname>`

### Examples
```
<details>
    <summary>vmbackup backup</summary>
```
</details>

## status 

### Description
*Get the status of the ongoing backup operation*

### Arguments
**exaunitid**: exaunitid status check for all dom0s of the cluster<br>
**dom0**: hostname of the node to check status<br>

### Usages
`vmbackup backup dom0=<hostname>`

### Examples
<details>

```
curl -u "u:p" http://ecra.com:9070/ecra/endpoint/vmbackup/backup/1/status?dom0=sea201602exdd001
{"status":200,"op":"vmbackup_action_post","status-detail":"success"}

ecra> vmbackup status dom0=sea201610exdd006
* {"backup": "Completed", "status": 200, "op": "vmbackup_action_get",
"status-detail": "success"}

```
</details>

## osslist

### Description
*Get the list of oss backups associated to a cluster*

### Arguments
**rackname**: Rack where the operation is to be performed<br>

### Usages
`vmbackup osslist rackname=<rackname>`

### Examples
<details>
    <summary>vmbackup osslist with given rackname</summary>

```
vmbackup osslist
ecra> vmbackup osslist rackname=iad1-d4-cl4-646df35a-90da-4182-9f96-df7b940378e9-clu01
*** Available Backups on: iad103716exdd001.iad103716exd.adminiad1.oraclevcn.com
 
Version : ECS_MAIN_LINUX.X64_230408.0900

---------------------------------------------------------------------
OSS Backup (On objectstorage.r1.oracleiaas.com)
---------------------------------------------------------------------
{
    "iad103716exddu0101-client1.domclient": [
        [
            "iad103716exddu0101-client1.domclient_SEQ1.tar",
            "2023-04-11-22-10-41"
        ],
        [
            "iad103716exddu0101-client1.domclient_SEQ2.tar",
            "2023-04-11-22-20-36"
        ]
    ]
}
```
</details>

## list

### Description
*Get the list of the current backedup vms.*

### Arguments
**rackname**: Rack where the operation is to be performed<br>
**clusterless**: yes for expansion cabinets<br>

### Usages
`vmbackup list rackname=<rackname>`
`vmbackup list exaOcid=<exaOcid>`

### Examples
<details>
    <summary>vmbackup list with given rackname</summary>

```
ecra>  vmbackup list rackname=SEA203709 clusterless=yes
* {"status": 200, "op": "vmbackup_action_get", "status-detail": "success"}
* No details info.

ecra>  vmbackup list exaOcid=1
* {"status": 200, "op": "vmbackup_action_get", "status-detail": "success"}
* No details info.
```
</details>

## download

### Description
*Downloads a backup from oss to a chosen destination in the vm*

### Arguments
**exaunitid**: exaunit where the vm lives<br>
**vmname**: name of the vm<br>
**seq**: seq number representing a vm backup<br>

### Usages
`vmbackup download <exaunitid> <vmname> <seq> <destdir>`

### Examples
<details>
    <summary>vmbackup download of a given seq</summary>

```
vmbackup download 
ecra> vmbackup download exaunitid=316 vmname=iad103716exddu0101-client1.domclient
seq=1 destdir=u01/tmp
* {'status': 202, 'status_uri':
'http://phoenix94112.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/16540835-e0dc-427c-afa5-4e6430c995fb',
'op': 'vmbackup_action_post', 'op_start_time': '2023-04-17T16:52:01+0000',
'est_op_end_time': '', 'message': 'processing', 'status-detail': 'processing'}
```
</details>


## restorelocal 

### Description
*Restores a specific file system for a specific vm (domu)*

### Arguments
**exaunitid**: exaunit where the vm lives<br>
**vmname**: name of the vm<br>
**seq**: seq number representing a vm backup<br>
**image**: image to be restored, currently we support: u01, u02, System, grid, pv1_vgexadb<br>
**restartvm**: After the restore vm should restart, this can cause problems to the customer. We expect True|False<br>

### Usages
`vmbackup restorelocal <exaunitid> <vmname> <seq> [<image> <restartvm>]`

### Examples
<details>
    <summary>vmbackup restore of a given seq</summary>

```
ecra> vmbackup restorelocal exaunitid=608 vmname=iad103709exddu0102-client1.data.customer2.oraclevcn.com seq=1 image=u02
* {'status': 202, 'status_uri': 'http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/b3a15410-52dc-48e3-a47c-5102b176b297', 'op': 'vmbackup_restore_post', 'op_start_time': '2024-05-28T23:05:20+0000', 'est_op_end_time': '', 'message': 'processing', 'status-detail': 'processing'}
ecra> status b3a15410-52dc-48e3-a47c-5102b176b297
* {"progress_percent": 0, "start_time": "2024-05-28T23:05:20+0000", "start_time_ts": "2024-05-28 23:05:20.0", "end_time": "2024-05-28T23:05:23+0000", "ecra_server": "EcraServer1", "last_heartbeat_update": "2024-05-28T23:05:20+0000", "wf_uuid": "2f9a2da4-7e87-4a56-bdac-0a2a9cbf0da3", "status": 200, "message": "Done", "op": "vmbackup_restore_post", "completion_percentage": 0, "status_uri": "http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/b3a15410-52dc-48e3-a47c-5102b176b297", "status-detail": "success"}
ecra> workflows describe workflowId=2f9a2da4-7e87-4a56-bdac-0a2a9cbf0da3
* {
    "workflowName": "vmbackup-restore-wfd",
    "workflowId": "2f9a2da4-7e87-4a56-bdac-0a2a9cbf0da3",
    "workflowStatus": "Completed",
    "workflowStartTime": "28 May 2024 23:05:20 UTC",
    "workflowEndTime": "28 May 2024 23:05:23 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "RestoreBackup",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Tue May 28 23:05:20 UTC 2024",
            "taskEndTime": "Tue May 28 23:05:23 UTC 2024",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:03"
        },
        {
            "taskName": "PostBackup",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Tue May 28 23:05:23 UTC 2024",
            "taskEndTime": "Tue May 28 23:05:23 UTC 2024",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "PostBackup",
            "lastOperationDetails": {
                "lastTaskLastOperationId": "9d282c40-f6eb-4c3b-9452-99040d707674",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "28 May 2024 23:05:23 UTC",
                "lastTaskLastOperationEndTime": "28 May 2024 23:05:23 UTC"
            }
        }
    ],
    "workflowElapsed": "00:00:03",
    "workflowRuntime": "00:00:03",
    "exaOCID": "",
    "requestId": "b3a15410-52dc-48e3-a47c-5102b176b297",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
```
</details>


## restorepath 

### Description
*After  a complete workflow operation for restorelocal or download operation this is use to get the location of the backup objects*

### Arguments
- <Status UUID> : Status UUID or Request Id for the original restorelocal or download operation

### Usages
`vmbackup restorepath <status uuid>`

### Examples
<details>
    <summary>vmbackup restorepath of a given status uuid</summary>

```
ecra> vmbackup restorepath 2eacbd44-95fc-4694-9157-2b2dac166839
* {
    "status": 200,
    "type": "vmbackup_restore_post",
    "location": "/EXAVMIMAGES/Restore/222a5d70-4a0a-11ef-8652-020017013570",
    "op": "vmbackup_restorepath_get",
    "status-detail": "success"
}
```
</details>

## configurecronjob

### Description
*Enables/disables vmbackup cronjob on the compute node*


## Arguments

**hostname**: hostname of the compute host
**action**: enable/disable

### Usages

`vmbackup configurecronjob hostname=<hostname> action=<enable/disable>`

### Examples:

<details>
    <summary>vmbackup cronjob to be enabled/disabled</summary>

```
vmbackup configurecronjob
ecra> vmbackup configurecronjob hostname=iad103494exdd005 action=enable
* {
    "status": 202,
    "status_uri": "http://ashburn176989.dev2sub1iad.databasede2iad.oraclevcn.com:9015/ecra/endpoint/statuses/dd258b86-b899-4580-9921-e3fba51e52ca",
    "op": "vmbackup_cronjob_put",
    "op_start_time": "2024-09-18T02:02:16+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
```
</details>


## suconfig

### Description
*Stores superuser to be used in vmbackup to oss*


## Arguments

**user**P: superuser ocid
**tenancy**: admin tenancy ocid
**fingerprint**: fingerprint
**region**: region
**keyfile** | keycontent: path of key file or key content

### Usages

`suconfig <user> <tenancy> <fingerprint> <region> [keyfile | keycontent]`

### Examples:

<details>
    <summary>vmbackup super user storage</summary>

```
vmbackup suconfig
ecra> vmbackup suconfig user=ocid1.user.region1..aaaaaaaarztjjzuesnysc5onko3ntargsc3jfaos6lnutztene4x6ekrgzyq fingerprint=a6:94:26:97:c5:4c:fc:ff:c0:7e:ca:ea:b9:28:d9:c2 tenancy=ocid1.tenancy.oc1..aaaaaaaajl3p2iquu45w7kfydtigbkmwcoshrlyxjjv5yn3deux3fa6cyxda keyfile=/opt/oracle/vmbackup/ociconf region='us-seattle-1'
* {'superuser': 'ocid1.user.region1..aaaaaaaarztjjzuesnysc5onko3ntargsc3jfaos6lnutztene4x6ekrgzyq', 'fingerprint': 'a6:94:26:97:c5:4c:fc:ff:c0:7e:ca:ea:b9:28:d9:c2', 'tenancy': 'ocid1.tenancy.oc1..aaaaaaaajl3p2iquu45w7kfydtigbkmwcoshrlyxjjv5yn3deux3fa6cyxda', 'key': '/opt/oracle/vmbackup/ociconf', 'key_field_type': 'file', 'status': 200, 'op': 'notset', 'status-detail': 'success'}
```
</details>



# SOP
Intention of this code is to enable SOP Calls on the ECRA layer, making possible execution of given scripts on hardware and being able to provide tracking on them through ecracli, and CP/Oneview portal

## List

### Description
*List all the available scripts along with their versions
### Usages
`sop list`

### Examples
```
ecra> sop list
* {
    "response": {
        "uuid": "c836c180-a6ba-11ed-9270-00001701c4ba",
        "status": "Done",
        "start_time": "Tue Feb  7 07:41:07 2023",
        "end_time": "Tue Feb  7 07:41:10 2023",
        "cmd": "sop.scriptslist",
        "params": "{\"jsonconf\": {\"cmd\": \"scriptslist\", \"scriptname\": \"scriptname\"}}",
        "error": "0",
        "error_str": "No Errors",
        "body": "",
        "xml": "../PodRepo/XMLTransientStorage__60.xml",
        "statusinfo": "000:: No status info available",
        "na1": "Undef",
        "na2": "0",
        "ec_details": "{\"script2.py\": {\"support_parallel_execution\": true, \"version\": \"1\", \"sha256sum\": \"0f14e5fd7387c8737766605cbbea2e88f88a426a2a35633b7b3ec88d2f5ea64d\", \"script_exec\": \"python\", \"return_json_support\": true, \"script_name\": \"script2.py\", \"script_path\": \"/u01/ecra_preprov/oracle/ecra_installs/ecramain/mw_home/user_projects/domains/sopscripts/script2.py\"}, \"script1.sh\": {\"support_parallel_execution\": false, \"version\": \"1\", \"sha256sum\": \"deb416f63eff01d23d078844f0b867c440acbb5e16f3de63103a9d9c2bf695a5\", \"script_exec\": \"/bin/sh\", \"return_json_support\": true, \"script_name\": \"script1.sh\", \"script_path\": \"/u01/ecra_preprov/oracle/ecra_installs/ecramain/mw_home/user_projects/domains/sopscripts/script1.sh\"}}",
        "errorObject": {},
        "patch_list": {},
        "success": "True"
    },
    "status": 200,
    "op": "sop_scripts",
    "status-detail": "success"
}

ecra> sop list
exaocid=ocid1.exadatainfrastructure.region1.sea.anzwkljsjajnm5iat3uyeejm34vnzwkfgukafk3ghrluspxmhr3a2k7y7kxq
* {
    "scripts": [
        {
            "comments": "Script for command execution in dom0 and cell",
            "support_parallel_execution": true,
            "version": "2",
            "sha256sum":
"37b2be0e4b33aa07e315fab258e976d1e7d79ec3aa870fc8793847b3af0a82ee",
            "script_exec": "python3",
            "return_json_support": true,
            "script_name": "sop_cmd_executor.py",
            "script_path": "/u01/oadt/sop_re_scripts/sop_cmd_executor.py"
        }
    ],
    "status": 200,
    "op": "sop_scripts",
    "status-detail": "success"
}
ecra>
```

## Request

### Description
* Executes new command from given parameters on payload
### Usages
`sop request jsonpayload=<JSON_PAYLOAD>`

### Examples
```
ecra> sop request jsonpayload=/u01/ecra_preprov/oracle/ecra_installs/ecramain/mw_12214/user_projects/domains/sop_payload.json
{'cmd': 'start', 'nodes': ['sea200120exdd001.sea200120exd.adminsea2.oraclevcn.com', 'sea200120exdd002.sea200120exd.adminsea2.oraclevcn.com'], 'scriptname': 'script1.sh', 'version': '1', 'scriptparams': '', 'script_payload': {}}
* {
    "status": 202,
    "status_uri": "http://ecratst.ecramgmt.adminsea2.oraclevcn.com:9053/ecra/endpoint/statuses/0ad3f1c6-f39c-4061-bef0-0a61621d038b",
    "op": "sop_request",
    "op_start_time": "2023-02-07T10:49:03+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
ecra>

ecra> sop request jsonpayload=/u01/oracle/ecra_installs/inst6b/sop_payload.json
exaocid=ocid1.exadatainfrastructure.region1.sea.anzwkljsjajnm5iat3uyeejm34vnzwkfgukafk3ghrluspxmhr3a2k7y7kxq
* {
    "status": 202,
    "status_uri":
"http://seaexaccecra6.ecramgmt.adminsea.oraclevcn.com:9001/ecra/endpoint/statuses/4665be62-9473-4952-9ece-7b5d9f520bec",
    "op": "sop_request",
    "op_start_time": "2024-07-17T11:53:55+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
ecra>
```
#### Payload Sample
```
[oracle@ecratst u01]$ cat /u01/ecra_preprov/oracle/ecra_installs/ecramain/mw_12214/user_projects/domains/sop_payload.json
{"cmd": "start", "nodes": ["sea200120exdd001.sea200120exd.adminsea2.oraclevcn.com", "sea200120exdd002.sea200120exd.adminsea2.oraclevcn.com"], "scriptname": "script1.sh", "version": "1", "scriptparams": "", "script_payload": {} }
[oracle@ecratst u01]$

```
## Cancel

### Description
*Cancel given Sop request
### Usages
`sop cancel jsonpayload=<JSON_PAYLOAD>`

### Examples
```
ecra>  sop cancel  jsonpayload=/u01/ecra_preprov/oracle/ecra_installs/ecramain/mw_12214/user_projects/domains/sop_payload_cancel.json
* {
    "status": 202,
    "status_uri": "http://ecratst.ecramgmt.adminsea2.oraclevcn.com:9053/ecra/endpoint/statuses/13057a68-e752-44c2-9a55-74dd4050b09d",
    "op": "sop_cancel",
    "op_start_time": "2023-02-07T11:33:09+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
```
#### Payload Sample
```
{"uuid":"09e8e666-a6d5-11ed-9270-00001701c4ba", "cmd": "delete"}
```

# Cabinet

##ingestion:
Usage: ./ecracli cabinet ingestion <xml=path to XML file> <flatfile=Path to Flatfile>

### Description
*Ingest a new Cabinet or Add new nodes to present Cabinets that are Elastic Flex Cabinets.
NOTE: For Elastic Flex Cabinet, XML and Flatfile should contains all the nodes, old and new ones.*

### Arguments:
*xml: Full path where the XML file is
*flatfile: Full path where the Flatfile is.

### Examples
```
ecra> cabinet ingestion
xml=/scratch/caborbon/flatfiles/fake_x11m/5088_flexrack_phase1.xml
flatfile=/scratch/caborbon/flatfiles/fake_x11m/5088_flexrack_phase1.flat
* {
    "status": 202,
    "status_uri":
"http://phoenix94477.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/d2a7b9d9-68b6-4d94-bbb1-b2dad244998c",
    "op": "cabinet_ingestion_post",
    "op_start_time": "2025-09-17T18:30:21+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}
```

## modelsubtype

### Description
*API to consult and convert the model subtype in the nodes, so they can be removed from the physical rack, upgraded them, 
and set it back to be used again by ECRA*

### Arguments:
* convert: This is the main command that will convert the nodes to the required spec and put it in HW_REPAIR state to avoid its used during the upgrade process
* convertlarge: This is a wrapper for convert command to define the model subtype as LARGE
* convertextralarge: This is a wrapper for convert command to define the model subtype as EXTRALARGE
* convertstandard: This is a wrapper for convert command to define the model subtype as STANDARD
* getreport: This will generate a report for the available cabinets to be used for the convertion
* releasenodes: This will release the nodes to be used by ECRA, this means set the state back to FREE
### Examples
```
ecra> cabinet modelsubtype convertlarge model=X10M-2 amount=14
* {
    "model": "X10M-2",
    "nodetype": "COMPUTE",
    "amount": "14",
    "modelsubtype": "LARGE"
}
* {
    "nodes": [
        "sea201391exdd014",
        "sea201391exdd013",
        "sea201391exdd012",
        "sea201391exdd011",
        "sea201391exdd010",
        "sea201391exdd009",
        "sea201391exdd008",
        "sea201391exdd007",
        "sea201391exdd006",
        "sea201391exdd005",
        "sea201391exdd004",
        "sea201391exdd003",
        "sea201391exdd002",
        "sea201391exdd001"
    ],
    "nodetype": [
        "COMPUTE"
    ],
    "modelsubtype": [
        "ELASTIC_LARGE"
    ],
    "UUID": "8c3fbf40-cf04-4a9c-a4a3-18afbe3f3663",
    "status": 200,
    "op": "cabinet_modelsubtype_put",
    "status-detail": "success"
}
ecra> cabinet modelsubtype releasenodes
requestid=8c3fbf40-cf04-4a9c-a4a3-18afbe3f3663
* {
    "nodes": [
        "sea201391exdd014",
        "sea201391exdd013",
        "sea201391exdd012",
        "sea201391exdd011",
        "sea201391exdd010",
        "sea201391exdd009",
        "sea201391exdd008",
        "sea201391exdd007",
        "sea201391exdd006",
        "sea201391exdd005",
        "sea201391exdd004",
        "sea201391exdd003",
        "sea201391exdd002",
        "sea201391exdd001"
    ],
    "status": 200,
    "op": "cabinet_modelsubtype_put",
    "status-detail": "success"
}
```

## domu get

### Description
*API to retrieve the MVM domu information from the specified Dom0*

### Arguments:
* dom0: The parent Dom0 

### Example
```
ecra> cabinet domu get sea201610exdd003
*  <admin_nat_host_name> : <admin_nat_ip> : <db_client_mac>   : <db_backup_mac>   : <admin_vlan_tag>
*  sea201610exddu0301    : 10.0.132.49    : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 :   
*  sea201610exddu0302    : 10.1.0.105     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 99               
*  sea201610exddu0303    : 10.1.0.120     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 101              
*  sea201610exddu0304    : 10.1.0.135     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 102              
*  sea201610exddu0305    : 10.1.0.150     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 103              
*  sea201610exddu0306    : 10.1.0.165     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 104              
*  sea201610exddu0307    : 10.1.0.180     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 105              
*  sea201610exddu0308    : 10.1.0.195     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 106              
*  sea201610exddu0309    : 10.1.0.210     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 107              
*  sea201610exddu0310    : 10.1.0.225     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 108              
*  sea201610exddu0311    : 10.1.0.240     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 109              
*  sea201610exddu0312    : 10.1.0.255     : 00:10:fd:95:a0:3f : 02:00:17:01:08:74 : 110   
```

## domu update 

### Description 
*API to update the specified DomU

### Arguments:
*hostname: The domU hostname to update
*admin_nat_ip: Optional parameter, value will be updated in the DB if provided. 
*db_client_mac: Optional parameter, value will be updated in the DB if provided.
*db_backup_mac: Optional parameter, value will be updated in the DB if provided.
*admin_vlan_tag: Optional parameter, value will be updated in the DB if provided.

### Example

```
ecra> cabinet domu update sea201610exddu0302  admin_nat_ip=10.1.0.105 admin_vlan_tag=99
* {
    "status": 200,
    "op": "cabinet_domu_put",
    "status-detail": "success"
}
```

## list

### Description
*List all the cabinets managed by the ECRA. If filters are not specified all the cabinets will be retrieved*

### Arguments:
*[filters]: add the column name and the value to apply filters. <column_name>=<value>. Example name=IAD103712*

### Usages
`./ecracli cabinet list [<filter_column>=<value>]`

### Examples
```
ecra> cabinet list
{
    "cabinets": [
        {
            "cabinetid": "7",
            "cabinetname": "SEA203416",
            "cabinettype": "STORAGE-ONLY",
            "model": "X8M-2"
        },
        {
            "cabinetid": "8",
            "cabinetname": "IAD103317",
            "cabinettype": "COMPUTE-ONLY",
            "model": "X8M-2"
        },
        {
            "cabinetid": "1",
            "cabinetname": "SEA201109",
            "cabinettype": "6:9",
            "model": "X8M-2"
        },
        {
            "cabinetid": "3",
            "cabinetname": "SEA200220",
            "cabinettype": "FIXED",
            "model": "X7-2"
        }
    ],
    "op": "cabinet_list_get",
    "status": 200,
    "status-detail": "success"
}

ecra> cabinet list name=IAD103712
* {
    "cabinets": [
        {
            "cabinetid": "1119",
            "cabinetname": "IAD103712",
            "cabinetstatus": "READY",
            "eth0": "Y",
            "model": "X8M-2 Elastic",
            "cabinettype": "STORAGE-ONLY"
        }
    ],
    "status": 200,
    "op": "cabinet_list_get",
    "status-detail": "success"
}

ecra> cabinet list model=X10M-2
* {
    "cabinets": [
        {
            "cabinetid": "1127",
            "cabinetname": "SEA201732",
            "cabinetstatus": "READY",
            "eth0": "Y",
            "model": "X10M-2 Elastic",
            "cabinettype": "STORAGE-ONLY"
        },
        {
            "cabinetid": "1128",
            "cabinetname": "SEA201733",
            "cabinetstatus": "READY",
            "eth0": "Y",
            "model": "X10M-2 Elastic",
            "cabinettype": "COMPUTE-ONLY"
        }
    ],
    "status": 200,
    "op": "cabinet_list_get",
    "status-detail": "success"
}
```

## getxml

### Description
*Retreive the xml and save it to the file system of teh indicated cabinet.*

### Arguments:
*cabinetname: Name of the cabinet to operate on.*

### Usages
`./ecracli cabinet getxml cabinetname=<NAME>`
`./ecracli cabinet getxml <NAME>`

### Examples
```
ecra> cabinet getxml IAD103712
* {
    "op": "rack_xml_get",
    "status": 200,
    "status-detail": "success",
    "xml": "../PodRepo/cabinet_IAD103712_xml_downloaded.xml"
}
```

## updatexml

### Description
*Updates the xml stored in the database of the indicated cabinet.*

### Arguments:
*cabinetname: Name of the cabinet to operate on.*

*newxmlpath: Path of the new version of the xml file.*

### Usages
`./ecracli cabinet updatexml cabinetname=<NAME> newxmlpath=<NAME>`

### Examples
```
ecra> cabinet updatexml cabinetname=SEA201207 newxmlpath=/scratch/gvalderr/ecra_installs/myecra/mw_home/user_projects/domains/PodRepo/cabinet_SEA201207_xml_downloaded.xml
* {"status": 200, "op": "cabinet_updatexml_put", "status-detail": "success"}
```

## composexml

### Description
*Generates the xml for the cabinet and stores it in cabinet registry.*

### Arguments:
*cabinetname: Name of the cabinet to operate on.*

*force: Indicates if xml should be replaced if already exists.*

### Usages
`./ecracli cabinet composexml <cabinetname=cabinetname> [force=true/false]`

### Examples
```
ecra> cabinet composexml cabinetname=IAD103714
* {
    "status": 202,
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/b5fc7e18-6b8a-4ab6-aa16-11b834d10c30",
    "op": "cabinet_compose_xml_post",
    "op_start_time": "2024-04-03T02:25:48+0000",
    "est_op_end_time": "",
    "message": "processing",
    "status-detail": "processing"
}

ecra> status b5fc7e18-6b8a-4ab6-aa16-11b834d10c30
* {"start_time": "2024-04-03T02:25:48+0000", "progress_percent": 0, "start_time_ts": "2024-04-03 02:25:48.0", "end_time": "2024-04-03T02:26:09+0000",
 "ecra_server": "EcraServer1", "last_heartbeat_update": "2024-04-03T02:25:48+0000", "wf_uuid": "e7613560-5449-43c0-8c0b-b5af8c052c3d", "status": 200, 
 "message": "Done", "op": "CabinetComposeXml", "completion_percentage": 0, "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/b5fc7e18-6b8a-4ab6-aa16-11b834d10c30", 
 "status-detail": "success"}
```

## softdeletenode

### Description
* Retrieves all the information of the node and archives it on ECS_HW_ELASTIC_NODES, then erase it from ECS_HW_NODES

### Arguments:
* cabinetname: Name of the cabinet to operate on. 
* hostname: Name of the noud that will be archived.
* servicetype: Service to which capacity is being given

### Usages
`./ecracli cabinet softdeletenode cabinetname=<cabinetname> hostname=<hostname> [servicetype=<service to which capacity is being given>]`

### Examples:
```
ecra> cabinet softdeletenode cabinetname=SEA201605 hostname=sea201605exdd001
* {
    "status": 200,
    "op": "cabinet_softdelete_node_put",
    "status-detail": "success"
}
ecra> cabinet softdeletenode cabinetname=SEA201605 hostname=sea201605exdd002
* {
    "status": 200,
    "op": "cabinet_softdelete_node_put",
    "status-detail": "success"
}

ecra> cabinet softdeletenode hostname=iad103496exdd008 cabinetname=IAD103496 servicetype=exacompute-cp
* {
    "status": 200,
    "op": "cabinet_softdelete_node_put",
    "status-detail": "success"
}
```


## getnodes

### Description
* Get a report of the current status of the nodes, whether they are active or archived.

### Arguments:
* cabinetname: Name of the cabinet to operate on.

### Usages
`./ecracli cabinet getnodes cabinetname=<cabinetname>`

### Examples:
```
ecra> cabinet getnodes cabinetname=SEA201605
* {
    "cabinetinfo": {
        "id": 18,
        "name": "SEA201605",
        "node_status": "SHARED"
    },
    "currentnodes": [
        {
            "oracle_hostname": "sea201605exdd014",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd014.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd013",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd013.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd012",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd012.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd011",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd011.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd010",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd010.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd009",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd009.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd008",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd008.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd007",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd007.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd006",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd006.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd005",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd005.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd004",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd004.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd003",
            "node_type": "COMPUTE",
            "node_state": "FREE",
            "fqdn": "sea201605exdd003.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdre02",
            "node_type": "ROCESW",
            "node_state": "FREE",
            "fqdn": "sea201605exdre02.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdre01",
            "node_type": "ROCESW",
            "node_state": "FREE",
            "fqdn": "sea201605exdre01.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdpd02",
            "node_type": "PDU",
            "node_state": "FREE",
            "fqdn": "sea201605exdpd02.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdpd01",
            "node_type": "PDU",
            "node_state": "FREE",
            "fqdn": "sea201605exdpd01.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        }
    ],
    "archivednodes": [
        {
            "oracle_hostname": "sea201605exdd001",
            "node_type": "COMPUTE",
            "node_state": "ARCHIVED",
            "fqdn": "sea201605exdd001.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        },
        {
            "oracle_hostname": "sea201605exdd002",
            "node_type": "COMPUTE",
            "node_state": "ARCHIVED",
            "fqdn": "sea201605exdd002.sea2xx2xx0051qf.adminsea2.oraclevcn.com"
        }
    ]
}

```

## recovernode

### Description
* Recovers all the information of the node/nodes from ECS_HW_ELASTIC_NODES and saves it on ECS_HW_NODES

### Arguments:
* cabinetname: Name of the cabinet to operate on. 
* hostname: Name of the node that will be archived. "all" option will retreive all the nodes taht are currently archived

### Usages
`./ecracli cabinet recovernode cabinetname=<cabinetname> hostname=[<hostname>|all]`

### Examples:
```
ecra> cabinet recovernode cabinetname=SEA201605 hostname=sea201605exdd002
* {
    "status": 200,
    "op": "cabinet_restore_node_put",
    "status-detail": "success"
}

```

## purgenode

### Description
* Checks all the information is in order (ECS_TEMP_DOMUS, ECS_CAVIUMS and ECS_HW_NODES) and erases the archive record of the node in case of existing

### Arguments:
* cabinetname: Name of the cabinet to operate on. 
* hostname: Name of the node that will be archived. 
* 
### Usages
`./ecracli cabinet purgenode cabinetname=<cabinetname> hostname=[<hostname>|all]`

### Examples:
```
ecra> cabinet purgenode cabinetname=SEA201605 hostname=sea201605exdd002
* {
    "status": 200,
    "op": "cabinet_purge_node_put",
    "status-detail": "success"
}

```

## getnodestatusreport

### Description
* Get a report of all the cabinets, if they are DEDICATED or SHARED and the archived nodes they have, if any.

### Arguments:
* None

### Usages
`./ecracli cabinet getnodestatusreport`

### Examples:
```
ecra> cabinet getnodestatusreport
* {
    "cabinets": [
        {
            "cabinetid": "17",
            "cabinetname": "SEA201207",
            "opstate": "DEDICATED",
            "cabinettype": "FIXED",
            "activeNodesCount": 24,
            "archivedNodesCount": 0,
            "archivedNodes": []
        },
...
        {
            "cabinetid": "30",
            "cabinetname": "SEA202223",
            "opstate": "DEDICATED",
            "cabinettype": "STORAGE-ONLY",
            "activeNodesCount": 19,
            "archivedNodesCount": 0,
            "archivedNodes": []
        }
    ]
}
```

## getnodearchivedreason

### Description
* Gets the reason a node was archived

### Arguments:
* hostname: Name of the node that will be retieved.

### Usages
`./ecracli cabinet getnodearchivedreason hostname=<hostname>

### Examples:
```
ecra> cabinet getnodearchivedreason hostname=sea201323exdd001
* {
    "hostname": "sea201323exdd001",
    "status": "ARCHIVED",
    "cabinet": "SEA201323",
    "archivedreason": "THE NODE WAS ARCHIVED BECAUSE IT WAS BROKEN"
}
```

## updatenodearchivedreason

### Description
*  Updates or sets the reason a node was archived

### Arguments:
* hostname: Name of the node that will be updated.
* archivedreason: Reason the node was archived.

### Usages
`./ecracli cabinet updatenodearchivedreason hostname=<hostname> archivedreason=<'archived reason'>`

### Examples:
```
ecra> cabinet updatenodearchivedreason hostname=sea201323exdd001 archivedreason='THE NODE WAS ARCHIVED BECAUSE IT WAS BROKEN'
* {
    "status": 200,
    "op": "cabinet_node_archive_info_put",
    "status-detail": "success"
}

```

## getnodearchivedextrainfo

### Description
* Gets the extra information stored of an archived node

### Arguments:
* hostname: Name of the node that will be used to retrieve archived extra information.

### Usages
`./ecracli cabinet getnodearchivedextrainfo hostname=<hostname>`

### Examples:
```
ecra> cabinet getnodearchivedextrainfo hostname=sea201323exdd001
* {
    "id": "130",
    "ib_fabric_id": "26",
    "sw_version": "24.1.90.0.0.240715",
    "node_type_order_bottom_up": "1",
    "cluster_size_constraint": "14comp2rocesw2pdu1ethsw",
    "node_state": "FREE",
    "dom0_bonding": "N",
    "mvmbonding": "N",
    "clustertag": "ALL",
    "ingestion_status": "INGESTION_IN_PROGRESS",
    "model_subtype": "STANDARD",
    "localbackupenabled": "Y",
    "ossbackupenabled": "Y",
    "servicetype": "exacs",
...
    "archivedreason": "THE NODE WAS ARCHIVED BECAUSE IT WAS BROKEN"
}

```

## updatenodearchivedextrainfo

### Description
*  Updates  the extra information stored of a archived node using the new json file

### Arguments:
* hostname: Name of the node that will be updated.
* extrainfojsonpath: Path of the json that contains the new extra information.

### Usages
`./ecracli cabinet updatenodearchivedextrainfo hostname=<hostname> extrainfojsonpath=<jsonpath>`

### Examples:
```
ecra> cabinet updatenodearchivedextrainfo hostname=sea201323exdd001 extrainfojsonpath=/scratch/user/payloads/extrainfojson.json
* {
    "status": 200,
    "op": "cabinet_node_extra_info_put",
    "status-detail": "success"
}

```


## ports

### Description
*Get all the ports and cavium info for a given cabinet*

### Arguments:
*cabinetid: CabinetID which is a number*
*cabinetname: Cabinet name which is a string*

### Usages
`./ecracli cabinet ports cabinetid=<cabinet_id>`
`./ecracli cabinet ports cabinetname=<cabinet_name>`

### Examples
```
ecra> cabinet ports cabinetid=1
{
    "cabinetid": 1,
    "cabinetname": "SEA201109",
    "op": "cabinet_ports_get",
    "ports": [
        {
            "cavium_id": "4.0G1944-GBC000855",
            "cavium_ip": "10.193.47.1",
            "dom0_oracle_name": "sea201109exdd001",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "1",
            "mac": "00:10:51:57:8f:fc"
        },
        {
            "cavium_id": "4.0G1944-GBC000855",
            "cavium_ip": "10.193.47.1",
            "dom0_oracle_name": "sea201109exdd001",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "1",
            "mac": "02:00:17:01:d2:41"
        },
        {
            "cavium_id": "4.0G1943-GBC002604",
            "cavium_ip": "10.193.61.1",
            "dom0_oracle_name": "sea201109exdd001",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "1",
            "mac": "00:10:69:67:de:0a"
        },
        {
            "cavium_id": "4.0G1943-GBC002604",
            "cavium_ip": "10.193.61.1",
            "dom0_oracle_name": "sea201109exdd001",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "1",
            "mac": "02:00:17:01:e3:78"
        },
        {
            "cavium_id": "4.0G1943-GBC002299",
            "cavium_ip": "10.193.61.3",
            "dom0_oracle_name": "sea201109exdd002",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "2",
            "mac": "00:10:5e:33:03:b2"
        },
        {
            "cavium_id": "4.0G1943-GBC002299",
            "cavium_ip": "10.193.61.3",
            "dom0_oracle_name": "sea201109exdd002",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "2",
            "mac": "02:00:17:01:ba:18"
        },
        {
            "cavium_id": "4.0G1943-GBC002262",
            "cavium_ip": "10.193.47.3",
            "dom0_oracle_name": "sea201109exdd002",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "2",
            "mac": "00:10:5d:93:d0:a1"
        },
        {
            "cavium_id": "4.0G1943-GBC002262",
            "cavium_ip": "10.193.47.3",
            "dom0_oracle_name": "sea201109exdd002",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "2",
            "mac": "02:00:17:01:86:65"
        },
        {
            "cavium_id": "4.0G1943-GBC002503",
            "cavium_ip": "10.193.47.5",
            "dom0_oracle_name": "sea201109exdd003",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "3",
            "mac": "00:10:62:6f:01:64"
        },
        {
            "cavium_id": "4.0G1943-GBC002503",
            "cavium_ip": "10.193.47.5",
            "dom0_oracle_name": "sea201109exdd003",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "3",
            "mac": "02:00:17:01:ff:d7"
        },
        {
            "cavium_id": "4.0G1943-GBC002665",
            "cavium_ip": "10.193.61.5",
            "dom0_oracle_name": "sea201109exdd003",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "3",
            "mac": "00:10:b2:27:4d:c9"
        },
        {
            "cavium_id": "4.0G1943-GBC002665",
            "cavium_ip": "10.193.61.5",
            "dom0_oracle_name": "sea201109exdd003",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "3",
            "mac": "02:00:17:01:5a:37"
        },
        {
            "cavium_id": "4.0G1947-GBC001953",
            "cavium_ip": "10.193.61.7",
            "dom0_oracle_name": "sea201109exdd004",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "4",
            "mac": "00:10:5c:eb:29:e5"
        },
        {
            "cavium_id": "4.0G1947-GBC001953",
            "cavium_ip": "10.193.61.7",
            "dom0_oracle_name": "sea201109exdd004",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "4",
            "mac": "02:00:17:01:01:28"
        },
        {
            "cavium_id": "4.0G1947-GBC001990",
            "cavium_ip": "10.193.47.7",
            "dom0_oracle_name": "sea201109exdd004",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "4",
            "mac": "00:10:38:94:c8:a2"
        },
        {
            "cavium_id": "4.0G1947-GBC001990",
            "cavium_ip": "10.193.47.7",
            "dom0_oracle_name": "sea201109exdd004",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "4",
            "mac": "02:00:17:01:7c:2a"
        },
        {
            "cavium_id": "4.0G1944-GBC000974",
            "cavium_ip": "10.193.47.9",
            "dom0_oracle_name": "sea201109exdd005",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "5",
            "mac": "00:10:ae:94:f7:16"
        },
        {
            "cavium_id": "4.0G1944-GBC000974",
            "cavium_ip": "10.193.47.9",
            "dom0_oracle_name": "sea201109exdd005",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "5",
            "mac": "02:00:17:01:9f:93"
        },
        {
            "cavium_id": "4.0G1947-GBC001150",
            "cavium_ip": "10.193.61.9",
            "dom0_oracle_name": "sea201109exdd005",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "5",
            "mac": "00:10:62:2f:f0:d5"
        },
        {
            "cavium_id": "4.0G1947-GBC001150",
            "cavium_ip": "10.193.61.9",
            "dom0_oracle_name": "sea201109exdd005",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "5",
            "mac": "02:00:17:01:5c:ef"
        },
        {
            "cavium_id": "4.0G1944-GBC000963",
            "cavium_ip": "10.193.61.11",
            "dom0_oracle_name": "sea201109exdd006",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "6",
            "mac": "00:10:b4:21:49:04"
        },
        {
            "cavium_id": "4.0G1944-GBC000963",
            "cavium_ip": "10.193.61.11",
            "dom0_oracle_name": "sea201109exdd006",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "6",
            "mac": "02:00:17:01:41:29"
        },
        {
            "cavium_id": "4.0G1947-GBC001954",
            "cavium_ip": "10.193.47.11",
            "dom0_oracle_name": "sea201109exdd006",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "6",
            "mac": "00:10:65:05:41:7e"
        },
        {
            "cavium_id": "4.0G1947-GBC001954",
            "cavium_ip": "10.193.47.11",
            "dom0_oracle_name": "sea201109exdd006",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "6",
            "mac": "02:00:17:01:53:e5"
        }
    ],
    "status": 200,
    "status-detail": "success"
}

ecra> cabinet ports cabinetname=IAD102036
* {
    "cabinetid": 1121,
    "cabinetname": "IAD102036",
    "eth0": "Y",
    "message": "Operation to get port information is successful",
    "op": "cabinet_ports_get",
    "ports": [
        {
            "cavium_id": "JCN2215A52767",
            "cavium_ip": "10.52.10.27",
            "dom0_oracle_name": "iad102036exdd014",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12201",
            "mac": "00:10:8a:21:22:6a"
        },
        {
            "cavium_id": "JCN2215A52767",
            "cavium_ip": "10.52.10.27",
            "dom0_oracle_name": "iad102036exdd014",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12201",
            "mac": "02:00:17:01:05:e8"
        },
        {
            "cavium_id": "JCN2213A50682",
            "cavium_ip": "10.52.11.27",
            "dom0_oracle_name": "iad102036exdd014",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12201",
            "mac": "00:10:38:ef:b3:69"
        },
        {
            "cavium_id": "JCN2213A50682",
            "cavium_ip": "10.52.11.27",
            "dom0_oracle_name": "iad102036exdd014",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12201",
            "mac": "02:00:17:01:7f:e8"
        },
        {
            "cavium_id": "NCN2212A20070",
            "cavium_ip": "10.52.10.25",
            "dom0_oracle_name": "iad102036exdd013",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12202",
            "mac": "00:10:85:87:3e:c5"
        },
        {
            "cavium_id": "NCN2212A20070",
            "cavium_ip": "10.52.10.25",
            "dom0_oracle_name": "iad102036exdd013",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12202",
            "mac": "02:00:17:01:02:fe"
        },
        {
            "cavium_id": "NCN2215A34055",
            "cavium_ip": "10.52.11.25",
            "dom0_oracle_name": "iad102036exdd013",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12202",
            "mac": "00:10:3d:66:70:6e"
        },
        {
            "cavium_id": "NCN2215A34055",
            "cavium_ip": "10.52.11.25",
            "dom0_oracle_name": "iad102036exdd013",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12202",
            "mac": "02:00:17:01:77:8b"
        },
        {
            "cavium_id": "JCN2211A45677",
            "cavium_ip": "10.52.10.23",
            "dom0_oracle_name": "iad102036exdd012",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12203",
            "mac": "00:10:e0:ea:ec:78"
        },
        {
            "cavium_id": "JCN2211A45677",
            "cavium_ip": "10.52.10.23",
            "dom0_oracle_name": "iad102036exdd012",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12203",
            "mac": "02:00:17:01:c3:a0"
        },
        {
            "cavium_id": "JCN2209A42265",
            "cavium_ip": "10.52.11.23",
            "dom0_oracle_name": "iad102036exdd012",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12203",
            "mac": "00:10:57:f6:28:27"
        },
        {
            "cavium_id": "JCN2209A42265",
            "cavium_ip": "10.52.11.23",
            "dom0_oracle_name": "iad102036exdd012",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12203",
            "mac": "02:00:17:01:a5:9d"
        },
        {
            "cavium_id": "JCN2213A51653",
            "cavium_ip": "10.52.10.21",
            "dom0_oracle_name": "iad102036exdd011",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12204",
            "mac": "00:10:f7:65:5c:2a"
        },
        {
            "cavium_id": "JCN2213A51653",
            "cavium_ip": "10.52.10.21",
            "dom0_oracle_name": "iad102036exdd011",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12204",
            "mac": "02:00:17:01:4b:07"
        },
        {
            "cavium_id": "JCN2215A52944",
            "cavium_ip": "10.52.11.21",
            "dom0_oracle_name": "iad102036exdd011",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12204",
            "mac": "00:10:1a:c5:11:dc"
        },
        {
            "cavium_id": "JCN2215A52944",
            "cavium_ip": "10.52.11.21",
            "dom0_oracle_name": "iad102036exdd011",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12204",
            "mac": "02:00:17:01:82:c6"
        },
        {
            "cavium_id": "JCN2205A37872",
            "cavium_ip": "10.52.10.19",
            "dom0_oracle_name": "iad102036exdd010",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12205",
            "mac": "00:10:0e:4f:bf:f1"
        },
        {
            "cavium_id": "JCN2205A37872",
            "cavium_ip": "10.52.10.19",
            "dom0_oracle_name": "iad102036exdd010",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12205",
            "mac": "02:00:17:01:c6:2c"
        },
        {
            "cavium_id": "JCN2205A36699",
            "cavium_ip": "10.52.11.19",
            "dom0_oracle_name": "iad102036exdd010",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12205",
            "mac": "00:10:3e:74:e6:f6"
        },
        {
            "cavium_id": "JCN2205A36699",
            "cavium_ip": "10.52.11.19",
            "dom0_oracle_name": "iad102036exdd010",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12205",
            "mac": "02:00:17:01:e6:70"
        },
        {
            "cavium_id": "NCN2212A18609",
            "cavium_ip": "10.52.10.17",
            "dom0_oracle_name": "iad102036exdd009",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12206",
            "mac": "00:10:cd:36:b2:eb"
        },
        {
            "cavium_id": "NCN2212A18609",
            "cavium_ip": "10.52.10.17",
            "dom0_oracle_name": "iad102036exdd009",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12206",
            "mac": "02:00:17:01:53:41"
        },
        {
            "cavium_id": "NCN2213A20311",
            "cavium_ip": "10.52.11.17",
            "dom0_oracle_name": "iad102036exdd009",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12206",
            "mac": "00:10:13:11:e8:7a"
        },
        {
            "cavium_id": "NCN2213A20311",
            "cavium_ip": "10.52.11.17",
            "dom0_oracle_name": "iad102036exdd009",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12206",
            "mac": "02:00:17:01:03:d8"
        },
        {
            "cavium_id": "JCN2203A33553",
            "cavium_ip": "10.52.10.15",
            "dom0_oracle_name": "iad102036exdd008",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12207",
            "mac": "00:10:b0:26:5b:e5"
        },
        {
            "cavium_id": "JCN2203A33553",
            "cavium_ip": "10.52.10.15",
            "dom0_oracle_name": "iad102036exdd008",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12207",
            "mac": "02:00:17:01:b7:9e"
        },
        {
            "cavium_id": "NCN2234A82647",
            "cavium_ip": "10.52.11.15",
            "dom0_oracle_name": "iad102036exdd008",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12207",
            "mac": "00:10:fd:b0:39:5e"
        },
        {
            "cavium_id": "NCN2234A82647",
            "cavium_ip": "10.52.11.15",
            "dom0_oracle_name": "iad102036exdd008",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12207",
            "mac": "02:00:17:01:a8:93"
        },
        {
            "cavium_id": "JCN2203A35517",
            "cavium_ip": "10.52.10.13",
            "dom0_oracle_name": "iad102036exdd007",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12208",
            "mac": "00:10:3c:ff:72:07"
        },
        {
            "cavium_id": "JCN2203A35517",
            "cavium_ip": "10.52.10.13",
            "dom0_oracle_name": "iad102036exdd007",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12208",
            "mac": "02:00:17:01:be:78"
        },
        {
            "cavium_id": "NCN2116A36101",
            "cavium_ip": "10.52.11.13",
            "dom0_oracle_name": "iad102036exdd007",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12208",
            "mac": "00:10:cf:7e:9f:3f"
        },
        {
            "cavium_id": "NCN2116A36101",
            "cavium_ip": "10.52.11.13",
            "dom0_oracle_name": "iad102036exdd007",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12208",
            "mac": "02:00:17:01:50:fc"
        },
        {
            "cavium_id": "JCN2205A36107",
            "cavium_ip": "10.52.10.11",
            "dom0_oracle_name": "iad102036exdd006",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12209",
            "mac": "00:10:e5:f2:b8:82"
        },
        {
            "cavium_id": "JCN2205A36107",
            "cavium_ip": "10.52.10.11",
            "dom0_oracle_name": "iad102036exdd006",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12209",
            "mac": "02:00:17:01:01:90"
        },
        {
            "cavium_id": "JCN2205A37057",
            "cavium_ip": "10.52.11.11",
            "dom0_oracle_name": "iad102036exdd006",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12209",
            "mac": "00:10:52:c8:ee:ee"
        },
        {
            "cavium_id": "JCN2205A37057",
            "cavium_ip": "10.52.11.11",
            "dom0_oracle_name": "iad102036exdd006",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12209",
            "mac": "02:00:17:01:ef:dc"
        },
        {
            "cavium_id": "NCN2213A21453",
            "cavium_ip": "10.52.10.9",
            "dom0_oracle_name": "iad102036exdd005",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12210",
            "mac": "00:10:d6:3d:7c:22"
        },
        {
            "cavium_id": "NCN2213A21453",
            "cavium_ip": "10.52.10.9",
            "dom0_oracle_name": "iad102036exdd005",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12210",
            "mac": "02:00:17:01:a5:af"
        },
        {
            "cavium_id": "NCN2213A21918",
            "cavium_ip": "10.52.11.9",
            "dom0_oracle_name": "iad102036exdd005",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12210",
            "mac": "00:10:80:1a:d9:ba"
        },
        {
            "cavium_id": "NCN2213A21918",
            "cavium_ip": "10.52.11.9",
            "dom0_oracle_name": "iad102036exdd005",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12210",
            "mac": "02:00:17:01:08:ec"
        },
        {
            "cavium_id": "NCN2213A21354",
            "cavium_ip": "10.52.10.7",
            "dom0_oracle_name": "iad102036exdd004",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12211",
            "mac": "00:10:e2:7d:0e:d9"
        },
        {
            "cavium_id": "NCN2213A21354",
            "cavium_ip": "10.52.10.7",
            "dom0_oracle_name": "iad102036exdd004",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12211",
            "mac": "02:00:17:01:c5:a1"
        },
        {
            "cavium_id": "NCN2215A30501",
            "cavium_ip": "10.52.11.7",
            "dom0_oracle_name": "iad102036exdd004",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12211",
            "mac": "00:10:aa:a6:b9:07"
        },
        {
            "cavium_id": "NCN2215A30501",
            "cavium_ip": "10.52.11.7",
            "dom0_oracle_name": "iad102036exdd004",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12211",
            "mac": "02:00:17:01:69:32"
        },
        {
            "cavium_id": "NCN2212A17478",
            "cavium_ip": "10.52.10.5",
            "dom0_oracle_name": "iad102036exdd003",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12212",
            "mac": "00:10:00:b1:f1:5c"
        },
        {
            "cavium_id": "NCN2212A17478",
            "cavium_ip": "10.52.10.5",
            "dom0_oracle_name": "iad102036exdd003",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12212",
            "mac": "02:00:17:01:f1:f2"
        },
        {
            "cavium_id": "NCN2212A18571",
            "cavium_ip": "10.52.11.5",
            "dom0_oracle_name": "iad102036exdd003",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12212",
            "mac": "00:10:61:35:f1:ae"
        },
        {
            "cavium_id": "NCN2212A18571",
            "cavium_ip": "10.52.11.5",
            "dom0_oracle_name": "iad102036exdd003",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12212",
            "mac": "02:00:17:01:0c:1b"
        },
        {
            "cavium_id": "NCN2218A52844",
            "cavium_ip": "10.52.10.3",
            "dom0_oracle_name": "iad102036exdd002",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12213",
            "mac": "00:10:1b:6d:26:de"
        },
        {
            "cavium_id": "NCN2218A52844",
            "cavium_ip": "10.52.10.3",
            "dom0_oracle_name": "iad102036exdd002",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12213",
            "mac": "02:00:17:01:0f:25"
        },
        {
            "cavium_id": "NCN2219A61593",
            "cavium_ip": "10.52.11.3",
            "dom0_oracle_name": "iad102036exdd002",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12213",
            "mac": "00:10:be:43:32:a5"
        },
        {
            "cavium_id": "NCN2219A61593",
            "cavium_ip": "10.52.11.3",
            "dom0_oracle_name": "iad102036exdd002",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12213",
            "mac": "02:00:17:01:ce:79"
        },
        {
            "cavium_id": "NCN2215A31495",
            "cavium_ip": "10.52.10.1",
            "dom0_oracle_name": "iad102036exdd001",
            "etherface": "eth1",
            "etherface_type": "client",
            "hw_node_id": "12214",
            "mac": "00:10:bc:9f:e4:14"
        },
        {
            "cavium_id": "NCN2215A31495",
            "cavium_ip": "10.52.10.1",
            "dom0_oracle_name": "iad102036exdd001",
            "etherface": "eth1",
            "etherface_type": "backup",
            "hw_node_id": "12214",
            "mac": "02:00:17:01:43:5d"
        },
        {
            "cavium_id": "NCN2215A31429",
            "cavium_ip": "10.52.11.1",
            "dom0_oracle_name": "iad102036exdd001",
            "etherface": "eth2",
            "etherface_type": "client",
            "hw_node_id": "12214",
            "mac": "00:10:a1:18:55:2f"
        },
        {
            "cavium_id": "NCN2215A31429",
            "cavium_ip": "10.52.11.1",
            "dom0_oracle_name": "iad102036exdd001",
            "etherface": "eth2",
            "etherface_type": "backup",
            "hw_node_id": "12214",
            "mac": "02:00:17:01:bc:bf"
        }
    ],
    "status": 200,
    "status-detail": "success"
}
```

# OCI 
## connectivity 
### Description
This command checks if there is access to oci apis

### Arguments
**compartmentid**: [Optional] Used to filter internal results

### Usages
`oci connectivity check`

`oci connectiviy check compartmentid=ocid1.tenancy.id.1234` 

### Examples
> oci connectivity check compartmentid=ocid1.tenancy.oc1..aaaaaaaakqhkiuvchkoxuxgpax4zcieeizobkzmszhegyaaqx3fkiyjzwkrq
* {
  "computeConnectivity": "OkConnectivity",
  "vnicConnectivity": "OkConnectivity",
  "overallConnectivity": "OkConnectivity",
  "status": 200
}
ecra> oci connectivity check compartmentid=
* {
  "computeConnectivityDetail": "ErrConnectivity",
  "computeConnectivityError": "{\"code\":\"MissingParameter\",\"message\":\"Missing compartmentId\"}",
  "vnicConnectivityDetail": "ErrConnectivity",
  "vnicConnectivityError": "{\"code\":\"MissingParameter\",\"message\":\"Missing compartmentId\"}",
  "overallConnectivity": "ErrConnectivity",
  "status": 200
}
ecra> oci connectivity check compartmentid=1234
* {
  "computeConnectivityDetail": "ErrConnectivity",
  "computeConnectivityError": "{\"code\":\"InvalidParameter\",\"message\":\"Invalid compartmentId\"}",
  "vnicConnectivityDetail": "ErrConnectivity",
  "vnicConnectivityError": "{\"code\":\"InvalidParameter\",\"message\":\"Invalid compartmentId\"}",
  "overallConnectivity": "ErrConnectivity",
  "status": 200
}

# patchmetadata
*This command is used to update infrapatch metadata which is used for various infrapatch operation*
## registerlaunchnodes

### Description
*Register launchnodes for an infra to perform infra patching*

### Usages
`patchmetadata registerlaunchnodes infraName=<Name of the infra>
                 infraType=<Type of infra CLUSTER|CABINET|QFAB>
                 launchNodes=<comma seperated list of launch nodes>
                 launchNodeType=<MANAGEMENT_HOST|COMPUTE>
   Arguments:
     infraName(Optional): Name of the infra
     infraType(Mandatory): Type of infra CLUSTER|CABINET|QFAB
     launchNodes(Mandatory): comma separated list of launch nodes
     launchNodeType(Optional): Valid values are MANAGEMENT_HOST and COMPUTE. This attribute is optional in case of SINGLE_VM_CLUSTER and it will be defaulted to MANAGEMENT_HOST. For clusterless cabinets it will be defaulted to COMPUTE
`
### Examples:
```json
patchmetadata registerlaunchnodes infraName=qfab_name infraType=CABINET launchNodes=FQDN_of_Launchnode launchNodeType=COMPUTE
patchmetadata registerlaunchnodes infraName=qfab_name infraType=QFAB launchNodes=FQDN_of_Management_Host launchNodeType=MANAGEMENT_HOST
patchmetadata registerlaunchnodes infraName=cabinet_name infraType=CABINET launchNodes=FQDN_of_Management_Host launchNodeType=MANAGEMENT_HOST
```
## deregisterlaunchnode

### Description
*Deregister all the launchnodes of an infra for infra patching*

### Usages
`patchmetadata deregisterlaunchnodes infraName=<Name of the infra>
   Arguments:
     infraName(Optional):  Name of the infra
     infraType(Mandatory):  Name of the infratype
     launchNodes(Optional): Comma seperated list of launch node names

`
### Examples:
```json
patchmetadata deregisterlaunchnodes infraName=slcs27 infraType=SINGLE_VM_CLUSTER
patchmetadata deregisterlaunchnodes infraType=SINGLE_VM_CLUSTER
patchmetadata deregisterlaunchnodes infraName=slcs27 infraType=SINGLE_VM_CLUSTER launchNodes=slcs27adm03,slcs27adm04
patchmetadata deregisterlaunchnodes infraName=slcs27 infraType=SINGLE_VM_CLUSTER launchNodes=slcs27adm03
patchmetadata deregisterlaunchnodes infraType=SINGLE_VM_CLUSTER launchNodes=slcs27adm03,slcs27adm04
patchmetadata deregisterlaunchnodes infraType=SINGLE_VM_CLUSTER launchNodes=slcs27adm03
```
## getlaunchnodes

### Description
*Get the registered launch nodes for an infra*

### Usages
`patchmetadata registerlaunchnode infraName=<Name of the infra>
   Arguments:
     infraName: Name of the infra
     infraType: Type of infra CLUSTER|CABINET|QFAB
`
### Examples:
```json
    patchmetadata getlaunchnodes infraName=slcs27 infraType=CLUSTER
    patchmetadata getlaunchnodes infraName=slcs27
    patchmetadata getlaunchnodes
```
## registerpluginscript

### Description
*Register a plugin script for a particular PluginTarget with a specific PluginType with all other metadata about the script*

### Usages
`patchmetadata registerpluginscript PluginTarget=<Name of the PluginTarget dom0|cell>
                 PluginType=<PluginType exacloud|oneff>
     			 ScriptAlias=<Alias name for the script to be executed>
				 ScriptName=<Script Path Name>
                                 ScriptBundleName=<Script Bundle Name>
                                 ScriptBundleHash=<ScriptBundle Checksum>
				 ChangeRequestId=<ChangeRequestId>
				 Description-<Brief description about the script>
				 IsEnabled = < Script is enabled to run or not Yes|No>
				 FailOnError= Fail the execution flow or not upon error Yes|No
				 Phase=<Stage Pre|Post>
   Arguments:
     PluginTarget: Name of the PluginTarget
     PluginType: PluginType exacloud|oneff
     ScriptAlias: Alias name for the script to be executed
	 Description: Brief description about the script
         ScriptBundleName: The name of the tarball, which follows the .tar.gz format
         ScriptBundleHash: ScriptBundle Checksum
	 IsEnabled: Script is enabled to run or not Yes|No
	 FailOnError: Fail the execution flow or not upon error Yes|No
	 Phase: Stage Pre|Post	 
`
### Examples:
```json
patchmetadata registerpluginscript ScriptPathName=syslens.sh ScriptAlias=syslens_upgrade_script
				ChangeRequestId=CRID-1234 Description="syslens.sh upgrades syslens rpm on the dom0 node"
				PluginType=oneoff PluginTarget=dom0
                                ScriptBundleName=syslens.tar.gz
                                ScriptBundleHash=754cc5fc57ac2060e7208b6403ae93302cb5d36cbaefbd7cfce19e16ae2c5c53
```
## listpluginscripts

### Description
*Get the registered plugin scripts*

### Usages
`patchmetadata listpluginscripts PluginTarget=<Name of the PluginTarget dom0|cell>
                 PluginType=<PluginType exacloud|oneff>
     			 ScriptAlias=<Alias name for the script to be executed>
   Arguments:
     PluginTarget: Name of the PluginTarget
     PluginType: PluginType exacloud|oneff
     ScriptAlias: Alias name for the script to be executed	 
`
### Examples:
```json
ecra> patchmetadata listpluginscripts
* {"InfraPatchPluginMetaData": [{"ScriptPathName": "syslens_deployer.sh", "ScriptBundleName": "syslens.tar.gz", "ScriptBundleHash": "f2a4a38333e66e369c4089a70a29ab371431e68dc05a2b598c732e9bf91e38fc", "ScriptAlias": "syslens_deployer", "ChangeRequestID": "CRID-123456", "Description": "This upgrades the syslens rpm on the dom0. DBCF syslens team owns this script", "PluginType": "exacloud", "PluginTarget": "dom0", "ScriptOrder": "1000", "IsEnabled": "Yes", "Phase": "Post", "RebootNode": "No", "FailOnError": "No"}], "status": 200, "op": "infrapatchpluginscripts_register_get", "status-detail": "success"}
ecra>
ecra>  patchmetadata listpluginscripts PluginTarget=dom0 PluginType=exacloud
* {"InfraPatchPluginMetaData": [{"ScriptPathName": "syslens_deployer.sh",  "ScriptBundleName": "syslens.tar.gz", "ScriptBundleHash": "f2a4a38333e66e369c4089a70a29ab371431e68dc05a2b598c732e9bf91e38fc", "ScriptAlias": "syslens_deployer", "ChangeRequestID": "CRID-123456", "Description": "This upgrades the syslens rpm on the dom0. DBCF syslens team owns this script", "PluginType": "exacloud", "PluginTarget": "dom0", "ScriptOrder": "1000", "IsEnabled": "Yes", "Phase": "Post", "RebootNode": "No", "FailOnError": "No"}], "status": 200, "op": "infrapatchpluginscripts_register_get", "status-detail": "success"}
ecra>
ecra>  patchmetadata listpluginscripts PluginTarget=dom0 PluginType=exacloud ScriptAlias=syslens_deployer
* {"InfraPatchPluginMetaData": [{"ScriptPathName": "syslens_deployer.sh", "ScriptBundleName": "syslens.tar.gz", "ScriptBundleHash": "f2a4a38333e66e369c4089a70a29ab371431e68dc05a2b598c732e9bf91e38fc", "ScriptAlias": "syslens_deployer", "ChangeRequestID": "CRID-123456", "Description": "This upgrades the syslens rpm on the dom0. DBCF syslens team owns this script", "PluginType": "exacloud", "PluginTarget": "dom0", "ScriptOrder": "1000", "IsEnabled": "Yes", "Phase": "Post", "RebootNode": "No", "FailOnError": "No"}], "status": 200, "op": "infrapatchpluginscripts_register_get", "status-detail": "success"}
ecra>
```
## updatepluginscript

### Description
*Update metadata of a registered plugin script for a particular PluginTarget with a specific PluginType having a specific ScriptAlias*

### Usages
`patchmetadata updatepluginscript PluginTarget=<Name of the PluginTarget dom0|cell>
                 PluginType=<PluginType exacloud|oneff>
     			 ScriptAlias=<Alias name for the script to be executed>
				 ChangeRequestId=<ChangeRequestId>
				 Description-<Brief description about the script>
                                 ScriptBundleName=<Script Bundle Name>
                                 ScriptBundleHash=<ScriptBundle Checksum>
				 ScriptPathName=<Script Path Name>
				 IsEnabled = < Script is enabled to run or not Yes|No>
				 FailOnError= Fail the execution flow or not upon error Yes|No
				 Phase=<Stage Pre|Post>
   Arguments:
     PluginTarget: Name of the PluginTarget
     PluginType: PluginType exacloud|oneff
     ScriptAlias: Alias name for the script to be executed
	 Description: Brief description about the script
         ScriptBundleName: The name of the tarball, which follows the .tar.gz format
         ScriptBundleHash: ScriptBundle Checksum
	 IsEnabled: Script is enabled to run or not Yes|No
	 FailOnError: Fail the execution flow or not upon error Yes|No
	 Phase: Stage Pre|Post		 
`
### Examples:
```json
patchmetadata updatepluginscript ScriptAlias=syslens_upgrade_script
	            PluginType=oneoff 
				PluginTarget=dom0
				IsEnabled=No FailOnError=Yes
```
## deregisterpluginscript

### Description
*Deregister metadata of a registered plugin script*

### Usages
`patchmetadata deregisterpluginscript PluginTarget=<Name of the PluginTarget dom0|cell>
                 PluginType=<PluginType exacloud|oneff>
     			 ScriptAlias=<Alias name for the script to be executed>
   Arguments:
     PluginTarget: Name of the PluginTarget
     PluginType: PluginType exacloud|oneff
     ScriptAlias: Alias name for the script to be executed	 
`
### Examples:
```json
patchmetadata deregisterpluginscript ScriptAlias=syslens_upgrade_script
	            PluginType=oneoff 
				PluginTarget=dom0
				IsEnabled=No FailOnError=Yes
```
# Capacity

## getavailability 

### Description
*Get a report for all the availability of racks or nodes according of its type, size and model.*

### Usages
`capacity getavailability [type=<rack|elastic|all>] [detailed=<true|false>] [raw=<true|false>]`

#### Values
`  type=<rack|elastic|all> : Value between elastic and rack for determining which report to generate (default=all)`
`  detailed=<true|false> :Value for rack type for obtaining values per model (default=false)`
`  raw=<true|false>: Returns a the json responss if enabled (default=true)`

### Examples:
```
ecra> capacity getavailability type=elastic
*
TYPE        USED        FREE        TOTAL
CELL        30          45          75
COMPUTE     23          43          66

ecra> capacity getavailability type=rack
*
TYPE        USED        FREE        TOTAL
elastic     0           1           1
half        0           1           1
full        0           1           1
quarter     2           6           8

ecra> capacity getavailability type=rack detailed=true 
* 
TYPE        MODEL       USED        FREE        TOTAL       TOTAL COMPUTES  
elastic     X9M-2       0           1           1           Elastic size  
full        X8M-2       0           1           1           8           
half        X8M-2       0           1           1           4           
quarter     X7-2        1           2           3           6           
quarter     X8M-2       1           4           5           10      

ecra> capacity getavailability
* 

TYPE        USED        FREE        OTHER_STATES     TOTAL       
quarter     3           3           0                6           

TYPE        USED        FREE        OTHER_STATES     TOTAL       
CELL        16          61          1                78          
COMPUTE     13          84          12               109 
```
## getfilesystemdefinitions:

### Usage: 
* ecra>capacity getfilesystemdefinitions model=(RACK MODEL) `[exa0cid=<EXAOCID> rackname=<rackname> adbd=<yes|no> svm=<yes|no>]`

### Description :
`Returns the minimum and maximum size for each mount of the filesystem for the indicated model and the extra parameters.`

#### Values:
`model : Value that indicates the model of the rack from which extract the information.`
`exaocid : Name of Infra that will help obtain all extra parameters for the request`
`rackname: Optional, name of the rack`
`adbd: Optional, helps determine if the mounts required are adbd or not`
`svm: Optional, helps determine if the mounts required are svm or mvm`

### Examples:
```
ecra> capacity getfilesystemdefinitions model=X8M-2
* {
    "filesystem": [
        {
            "mountpoint": "/tmp",
            "minsizegb": 10,
            "maxsizegb": 900
        },
        {
            "mountpoint": "/u01",
            "minsizegb": 250,
            "maxsizegb": 900
        },
        {
            "mountpoint": "/var",
            "minsizegb": 10,
            "maxsizegb": 900
        },
        {
            "mountpoint": "/var/log",
            "minsizegb": 30,
            "maxsizegb": 900
        },
        {
            "mountpoint": "/var/log/audit",
            "minsizegb": 3,
            "maxsizegb": 900
        }
    ],
    "status": 200,
    "op": "capacity_filesystem_definitions",
    "status-detail": "success"
}

```

## gioperation

### Description
*Send a request to EC to add/update/delete a GI, the operation comes inside the payload in the type attribute.*

### Usages
` capacity gioperation jsonpath=<JSONPATH> `

#### Values
`    JSONPATH : JSON that contains the operation and the information for the GI`

### Examples:
```
ecra> capacity gioperation jsonpath=/scratch/illamas/payloads/gi/deleteGi.json
* {"status":202,"status_uri":"http://phoenix94089.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/6cb6722c-4121-41f1-bd46-a2eb1a04338d","op":"gi_operation_post","op_start_time":"2023-09-08T23:09:58+0000","est_op_end_time":"","message":"processing","status-detail":"processing"}
```

# Cluster

## details 

### Description
*Provide cluster details such as dom), domU, cells, ibswitches, ILOM information*

### Usages
`cluster details [rackname=<name>][exaunitid=<id>][domu=<domuname>][subscriptionid=<id>][dbsid=<dbsid>][resourceocid=<resourceocid>][resourcetype=<adb|cdb|pdb>]] [shortresponse=<true|false>] `

#### Values
`    rackname: rackname such as slcqab02adm0506clu5`
`    exaunitid: exaunitid to get the details about.`
`    domu     : domU name of the exadata VM`
`    subscriptionid : subscriptionid associated with the customer VM`
`    dbsid : Database SID for which you need the information of the corresponding exadata`
`    resourceid : OCID of the Db system, CDB or PDB`
`    resourcetype : type of the resource - ADB, CDB or PDB`
`    shortresponse: By default is false. In case it is provided with true, this will not go to Exacloud nor include the exacloud response cached.`

### Examples:
```
ecra> cluster details rackname=scaqab10adm0102clu7
* {
    "status": 200, 
    "dbsystemid": "ocid1.autonomousdbsystem.oc1.iad.abuwcljr6d575vcsio5wdbosleye23jc4ssaxmop2piodbet3aepz5hx66pa",
    "DatabaseSID": "db122,db1901", 
    "rackname": "scaqab10adm0102clu7", 
    "exadataInfrastructureOCID": "ocid1.autonomousexainfrastructure.oc1.sea.abzwkljsz4vrvpumza7fahsjly2pwodupaqvoch7dscaqak01adm0102clu4",
    "rackType": "X6-2 Quarter Rack HC 8TB", 
    "exaunitid": 1,
    "dom0s": [
        {
            "VMSize": null, 
            "HostName": "scaqab10adm01.us.oracle.com", 
            "Virtual": "false", 
            "GateWay": null, 
            "SubType": "Undefined", 
            "OsType": "LinuxDom0", 
            "TimeZone": "America/Los_Angeles", 
            "Id": "scaqab10adm01.us.oracle.com_id", 
            "Type": "compute", 
            "Networks": [
                "scaqab10adm01.us.oracle.com_admin", 
                "scaqab10adm01.us.oracle.com_priv1", 
                "scaqab10adm01.us.oracle.com_priv2"
            ], 
            "Machines": [
                "scaqab10adm01vm01.us.oracle.com_id", 
                "scaqab10adm01vm02.us.oracle.com_id", 
                "scaqab10adm01vm03.us.oracle.com_id", 
                "scaqab10adm01vm04.us.oracle.com_id", 
                "scaqab10adm01vm05.us.oracle.com_id", 
                "scaqab10adm01vm06.us.oracle.com_id", 
                "scaqab10adm01vm07.us.oracle.com_id", 
                "scaqab10adm01vm08.us.oracle.com_id"
            ]
        }, 
        {
            "VMSize": null, 
            "HostName": "scaqab10adm02.us.oracle.com", 
            "Virtual": "false", 
            "GateWay": null, 
            "SubType": "Undefined", 
            "OsType": "LinuxDom0", 
            "TimeZone": "America/Los_Angeles", 
            "Id": "scaqab10adm02.us.oracle.com_id", 
            "Type": "compute", 
            "Networks": [
                "scaqab10adm02.us.oracle.com_admin", 
                "scaqab10adm02.us.oracle.com_priv1", 
                "scaqab10adm02.us.oracle.com_priv2"
            ], 
            "Machines": [
                "scaqab10adm02vm01.us.oracle.com_id", 
                "scaqab10adm02vm02.us.oracle.com_id", 
                "scaqab10adm02vm03.us.oracle.com_id", 
                "scaqab10adm02vm04.us.oracle.com_id", 
                "scaqab10adm02vm05.us.oracle.com_id", 
                "scaqab10adm02vm06.us.oracle.com_id", 
                "scaqab10adm02vm07.us.oracle.com_id", 
                "scaqab10adm02vm08.us.oracle.com_id"
            ]
        }
    ], 
    "status-detail": "success", 
    "ATPOcids": {
        "pdbocid": [
            "pdb1ocid", 
            "pdb2ocid"
        ], 
        "cdbocid": [
            "cdbocid1", 
            "cdbocid2"
        ], 
        "dbsystemocid": "6666"
    },
    "cells": [
        {
            "VMSize": null, 
            "HostName": "scaqab10celadm03.us.oracle.com", 
            "Virtual": "false", 
            "GateWay": null, 
            "SubType": "Undefined", 
            "OsType": "LinuxPhysical", 
            "TimeZone": "America/Los_Angeles", 
            "Id": "scaqab10celadm03.us.oracle.com_id", 
            "Type": "storage", 
            "Networks": [
                "scaqab10celadm03.us.oracle.com_admin", 
                "scaqab10celadm03.us.oracle.com_priv1", 
                "scaqab10celadm03.us.oracle.com_priv2"
            ], 
            "Machines": []
        }, 
        {
            "VMSize": null, 
            "HostName": "scaqab10celadm02.us.oracle.com", 
            "Virtual": "false", 
            "GateWay": null, 
            "SubType": "Undefined", 
            "OsType": "LinuxPhysical", 
            "TimeZone": "America/Los_Angeles", 
            "Id": "scaqab10celadm02.us.oracle.com_id", 
            "Type": "storage", 
            "Networks": [
                "scaqab10celadm02.us.oracle.com_admin", 
                "scaqab10celadm02.us.oracle.com_priv1", 
                "scaqab10celadm02.us.oracle.com_priv2"
            ], 
            "Machines": []
        }, 
               {
            "VMSize": null, 
            "HostName": "scaqab10celadm01.us.oracle.com", 
            "Virtual": "false", 
            "GateWay": null, 
            "SubType": "Undefined", 
            "OsType": "LinuxPhysical", 
            "TimeZone": "America/Los_Angeles", 
            "Id": "scaqab10celadm01.us.oracle.com_id", 
            "Type": "storage", 
            "Networks": [
                "scaqab10celadm01.us.oracle.com_admin", 
                "scaqab10celadm01.us.oracle.com_priv1", 
                "scaqab10celadm01.us.oracle.com_priv2"
            ], 
            "Machines": []
        }
    ], 
    "iloms": [
        {
            "ntp_ip": [
                "10.210.176.28", 
                "10.132.0.122"
            ], 
            "ilomnetid": "scaqab10celadm03.us.oracle.com_ilom", 
            "ilomname": "scaqab10celadm03.us.oracle.com ILOM", 
            "dns_ip": [
                "10.210.255.250", 
                "10.231.225.65", 
                "192.135.82.4"
            ], 
            "ilomver": "12", 
            "ilomid": "scaqab10celadm03.us.oracle.com_ilom", 
            "ilomtz": "America/Los_Angeles"
        }, 
        {
            "ntp_ip": [
                "10.210.176.28", 
                "10.132.0.122"
            ], 
            "ilomnetid": "scaqab10adm01.us.oracle.com_ilom", 
            "ilomname": "scaqab10adm01.us.oracle.com ILOM", 
            "dns_ip": [
                "10.210.255.250", 
                "10.231.225.65", 
                "192.135.82.4"
            ], 
            "ilomver": "12", 
            "ilomid": "scaqab10adm01.us.oracle.com_ilom", 
            "ilomtz": "America/Los_Angeles"
        }, 
        {
            "ntp_ip": [
                "10.210.176.28", 
                "10.132.0.122"
            ], 
            "ilomnetid": "scaqab10adm02.us.oracle.com_ilom", 
            "ilomname": "scaqab10adm02.us.oracle.com ILOM", 
            "dns_ip": [
                "10.210.255.250", 
                "10.231.225.65", 
                "192.135.82.4"
            ], 
            "ilomver": "12", 
            "ilomid": "scaqab10adm02.us.oracle.com_ilom", 
            "ilomtz": "America/Los_Angeles"
        }, 
        {
            "ntp_ip": [
                "10.210.176.28", 
                "10.132.0.122"
            ], 
            "ilomnetid": "scaqab10celadm02.us.oracle.com_ilom", 
            "ilomname": "scaqab10celadm02.us.oracle.com ILOM", 
            "dns_ip": [
                "10.210.255.250", 
                "10.231.225.65", 
                "192.135.82.4"
            ], 
            "ilomver": "12", 
            "ilomid": "scaqab10celadm02.us.oracle.com_ilom", 
            "ilomtz": "America/Los_Angeles"
        }, 
        {
            "ntp_ip": [
                "10.210.176.28", 
                "10.132.0.122"
            ], 
            "ilomnetid": "scaqab10celadm01.us.oracle.com_ilom", 
            "ilomname": "scaqab10celadm01.us.oracle.com ILOM", 
            "dns_ip": [
                "10.210.255.250", 
                "10.231.225.65", 
                "192.135.82.4"
            ], 
            "ilomver": "12", 
            "ilomid": "scaqab10celadm01.us.oracle.com_ilom", 
            "ilomtz": "America/Los_Angeles"
        }
    ], 
     "ibswitches": [
        {
            "swid": "scaqab10sw-iba0.us.oracle.com_id", 
            "swmship": "both", 
            "swnetid": "scaqab10sw-iba0.us.oracle.com_admin", 
            "swver": "version2", 
            "swdesc": "Exadata Leaf Switch"
        }, 
        {
            "swid": "scaqab10sw-ibs0.us.oracle.com_id", 
            "swmship": "both", 
            "swnetid": "scaqab10sw-ibs0.us.oracle.com_admin", 
            "swver": "version2", 
            "swdesc": "Exadata Spine Switch"
        }, 
        {
            "swid": "scaqab10sw-ibb0.us.oracle.com_id", 
            "swmship": "both", 
            "swnetid": "scaqab10sw-ibb0.us.oracle.com_admin", 
            "swver": "version2", 
            "swdesc": "Exadata Leaf Switch"
        }
    ], 
        "domUs": [
        {
            "VMSize": "Small", 
            "HostName": "scaqab10adm01vm07.us.oracle.com", 
            "Virtual": "true", 
            "GateWay": null, 
            "SubType": "Undefined", 
            "OsType": "LinuxGuest", 
            "TimeZone": "America/Los_Angeles", 
            "Id": "scaqab10adm01vm07.us.oracle.com_id", 
            "Type": "compute", 
            "Networks": [
                "c6_scaqab10adm01vm07-bk.us.oracle.com_backup", 
                "c6_scaqab10adm01vm07.us.oracle.com_admin", 
                "c6_scaqab10adm01vm07.us.oracle.com_client", 
                "c6_scaqab10adm01vm07.us.oracle.com_priv1", 
                "c6_scaqab10adm01vm07.us.oracle.com_priv2", 
                "c6_scaqab10db01vmclu07-priv.us.oracle.com_clusterpriv1", 
                "c6_scaqab10db01vmclu07-priv.us.oracle.com_clusterpriv2"
            ], 
            "Machines": []
        }, 
         {
            "VMSize": "Small", 
            "HostName": "scaqab10adm02vm07.us.oracle.com", 
            "Virtual": "true", 
            "GateWay": null, 
            "SubType": "Undefined", 
            "OsType": "LinuxGuest", 
            "TimeZone": "America/Los_Angeles", 
            "Id": "scaqab10adm02vm07.us.oracle.com_id", 
            "Type": "compute", 
            "Networks": [
                "c6_scaqab10adm02vm07-bk.us.oracle.com_backup", 
                "c6_scaqab10adm02vm07.us.oracle.com_admin", 
                "c6_scaqab10adm02vm07.us.oracle.com_client", 
                "c6_scaqab10adm02vm07.us.oracle.com_priv1", 
                "c6_scaqab10adm02vm07.us.oracle.com_priv2", 
                "c6_scaqab10db02vmclu07-priv.us.oracle.com_clusterpriv1", 
                "c6_scaqab10db02vmclu07-priv.us.oracle.com_clusterpriv2"
            ], 
            "Machines": []
        }
    ], 
     "DbSystemDetails": {
        "dsl_ocid": "ocid1.securitylist.oc1.iad.aaaaaaaandonibmqfm64yhr5hrp4rx5kpeooty4svtogcpoeyrcelhqpwu7q", 
        "cust_region": "us-ashburn-1", 
        "subnet_ocid": "ocid1.subnet.oc1.iad.aaaaaaaanqprt47nrq6bzbfb77iprl7ddfjf5iotaplg4hbmmiu2probmkmq", 
        "dbsystem_id": "1", 
        "custTenantId": "1234", 
        "shape": "quarter", 
        "subnet_cidr": "10.0.0.112/29", 
        "rackname": "scaqab10adm0102clu7", 
        "vnics": [
            {
                "macaddress": "00:23:45:56:78:89", 
                "vnicprivateip": "10.0.0.115", 
                "scan_hostname": "scanhostname", 
                "vnic_ocid": "vnic_ocid1", 
                "vnic_hostname": "vnichostname", 
                "scanip": "10.0.0.114", 
                "vnic_nodevip": "10.0.0.116", 
                "subnet_fdqn": "subnetfqdn", 
                "vip_hostname": "viphostname", 
                "vmname": "scaqab10adm02vm07.us.oracle.com"
            }, 
            {
                "macaddress": "00:23:45:56:78:90", 
                "vnicprivateip": "10.0.0.117", 
                "vnic_ocid": "vnic_ocid2", 
                "vnic_hostname": "vnichost2", 
                "vnic_nodevip": "10.0.0.118", 
                "subnet_fdqn": "subnetfqdn", 
                "vip_hostname": "viphost2", 
                "vmname": "scaqab10adm01vm07.us.oracle.com"
            }
        ], 
        "cust_ad": "eGJB:US-ASHBURN-AD-1"
    }, 
    "DatabaseMapping": {
        "cdbs": [
            {
                "cdbname": "dbsid1", 
                "cdbocid": "cdb1ocid", 
                "dbUniqueName": "cdbunique1",
                "pdbs": [
                    {
                        "pdbocid": "cdb1pdbocid1", 
                        "pdbname": "cdb1pdb1"
                    }, 
                    {
                        "pdbocid": "cdb1pdbocid2", 
                        "pdbname": "cdb1pdb2"
                    }
                ]
            }, 
            {
                "cdbname": "dbsid2", 
                "cdbocid": "cdb2ocid", 
                "dbUniqueName": "cdbunique2",
                "pdbs": [
                    {
                        "pdbocid": "cdb2pdbocid1", 
                        "pdbname": "cdb2pdb1"
                    }, 
                    {
                        "pdbocid": "cdb2pdbocid2", 
                        "pdbname": "cdb2pdb2"
                    }
                ]
            }
        ]
    }, 
    "op": "cluster_details_post"
}
```

## compatibility

### Description
*Create/Update/Get Matrix records*

### Usages
`capacity compatibility [ list | addmatrix | addexclusion | updatematrix | enablematrix | disablematrix ]`

### Values
`  id : Matrix id`
`  osversion : Version of Oracle Linux compatible`
`  exaversion : Versions of the exadata`
`  hwmodel : Cabinet Model compatible`
`  giversion : Versions of the Grid`
`  status : ENABLED or DISABLED or EXCLUDED`
`  servicetype : The define the service type of this entry`
`  dom0version: Filter exadata image versions to the same or older versions of this value`

### Examples
```
        ecra> capacity compatibility list
        ecra> capacity compatibility addmatrix osversion=ol9 exaversion=24.1.x hwmodel=X11M-2,X10M-2 giversion=19c,23c status=ENABLED servicetype=EXACS
        ecra> capacity compatibility addexclusion osversion=ol9 exaversion=24.1.x hwmodel=X11M-2 giversion=19c,23c servicetype=EXACS
        ecra> capacity compatibility enablematrix id=2
        ecra> capacity compatibility disablematrix id=2
        ecra> capacity compatibility updatematrix id=2 osversion=ol9 exaversion=24.1.x hwmodel=X11M-2,X10M-2 giversion=19c,23c status=ENABLED servicetype=EXACS
        ecra> capacity compatibility catalog model=X9M-2 servicetype=exacs giversion=19 dom0version=23.1.1.1.311223
```
# ECRA 
## Deletepayloads
### Description
*Delete Files*

### Usages
`ecra deletepayloads olderthan=<DATE|INTERVAL> [onlycheck=<true|false>]`

### Values
`  olderthan: Interval expected to be 1D-30D or 1M-12M or 1Y-9Y, Date is expected to be in the format YYYY-MM-DD HH24:MI:SS`
`  onlycheck: The define the service type of this entry`

### Examples
```
        ecra> ecra deletapayloads oltherthan=1M onlycheck=false
        * {
            "recordsFound": 871,
            "status": 200,
            "op": "ecra_file_get",
            "status-detail": "success"
        }
        ecra> ecra deletepayloads olderthan=2M onlycheck=false
        * {
            "recordsFound": 595,
            "recordsDeleted": 595,
            "status": 200,
            "op": "ecra_file_get",
            "status-detail": "success"
        }
```


#Backfill updatesitegroup 

##Usage 


ecra> help backfill updatesitegroup
backfill updatesitegroup grouptype=[fabric|cabinet|faultdomain] groupidentifier=<Group name for selected type> sitegroup=<sitegroup>
 Update the sitegroup values for CPG on selected group of Cabinets/Fabric or Fault domain
ecra> 


##Samples 

## mvmsubnetinfo 

### Description
*Provide the ability to backfill the multivm subnet information for ExaCS*

### Usages
`backfill mvmsubnetinfo [flatfile=<FLATFILE>] [jsonpayload=<json path>] [force=<true>] [cabinetname=<CABINETNAME>]`

### Values
`    <FLATFILE>    : A flat file that has the details for the mvm network information and also the information for the new vlan`
`    <CABINETNAME> : Caibnet ID or name of cabinet where to store the new information`
`    <SUBNETMASK>  : Subnet mask of the new mvm subnet.`
`    <GATEWAY>     : Gateway of new mvm subnet.`
`    <DOMAIN>      : Admin domain of new subnet.`
`    <FORCE>       : If true, skip the IP validations.`
`    <JSONPAYLOAD> : The path to the json payload for admin subnets`

### Examples
```
    ecra>  backfill mvmsubnet_info  subnetmask=10.10.0.0 gateway=10.0.0.0 domain=aaa.com cabinetname=IAD103712
    * {"status": 200, "op": "cabinet_mvmsubnettinfo_put", "status-detail": "success"}
     or
    ecra>  backfill mvmsubnetinfo flatfile=/scratch/illamas/flatfiles/testfile.flat cabinetname=IAD103712 force=true
    * {"status": 200, "op": "cabinet_mvmsubnettinfo_put", "status-detail": "success"}

    ecra> backfill mvmsubnetinfo jsonpayload=/scratch/zpallare/payloads/adminsubnets.json
    * {"status": 200, "op": "cabinet_mvmsubnetinfo_put", "status-detail": "success"}
```

###backfill cabinet 

ecra> backfill  updatesitegroup grouptype=cabinet groupidentifier=SEA201607  sitegroup=sg001 restricted=false
* {"status": 200, "op": "cabinet_updatesitegroup_put", "status-detail": "success"}
ecra> 

SQL> select name, NVL(RESTRICTED_SITEGROUP, 'null'), NVL(SITEGROUP, 'null') from ecs_hw_cabinets;

SEA201607
N     sg001

SEA201606
null  null


SQL> 

###backfill fabric 

ecra> backfill  updatesitegroup grouptype=fabric groupidentifier=IAD1FABRIC1  sitegroup=sg003 restricted=false
* {"status": 200, "op": "cabinet_updatesitegroup_put", "status-detail": "success"}
ecra> 


SQL> select name, NVL(RESTRICTED_SITEGROUP, 'null'), NVL(SITEGROUP, 'null') from ecs_hw_cabinets;

SEA201607
N     sg003

SEA201606
N     sg003


SQL> 



###backfill fault domain 

ecra> backfill  updatesitegroup grouptype=faultdomain groupidentifier=1  sitegroup=sg002 restricted=false
* {"status": 200, "op": "cabinet_updatesitegroup_put", "status-detail": "success"}
ecra> 


SQL> select name, NVL(RESTRICTED_SITEGROUP, 'null'), NVL(SITEGROUP, 'null'), fault_domain from ecs_hw_cabinets;

SEA201607
N     sg002
1

SEA201606
N     sg002
1


SQL>


###Add registry for site group

if you include the parameter backfill equals to Y the information about the site group into the table ecs_hw_cabinet will be updated
Note: to the backfill It is necessary that all the nodes that make up the cabinet are in FREE or in case of a QR that the rack is in a ready status.

ecra>sitegroup add name=iad13.c1 building=iad13 restricted=[y|n] ad=ad1 region=us-ashburn-1 cloudvendor=<OCI/Indigo/Oasis> oudproviderregion=<region>  cloudprovideraz=<value>  cloudproviderbuilding=<value> [mtu=<value>] [farchildsite=<[N]/Y>] [overlaybridgeused=<[N]/Y>]
{
    "region": "IAD1",
    "name": "iad13.c1",
    "building": "iad13",
    "restricted": "y",
    "ad": "ad1",
    "cloudvendor":"OCI",
    "cloudprovideraz": "AZ1",
    "cloudproviderbuilding": "building1",
    "cloud_provider_region": "region-01"
    "status": 200,
    "op": "backfillsitegrouppost",
    "status-detail": "success"
}


ecra> sitegroup add building=iad1 name=TEST.iad1 restricted=Y ad=IAD1 region=iad1.region cloudvendor=Indigo backfill=Y cloudproviderregion=region-01 cloudprovideraz=AZ1  cloudproviderbuilding=building1
* {
    "ad": "IAD1",
    "backfill": "Y",
    "building": "iad1",
    "cloudvendor":"Indigo",
    "cloud_provider_region": "region-01",
    "name": "TEST.iad1",
    "region": "iad1.region",
    "restricted": "Y",
    "status": 200,
    "op": "sitegroupaddpost",
    "status-detail": "success"
}


###list information about site group
ecra>sitegroup list
* {
    "sitegroup": [
        {
            "region": "IAD12",
            "name": "iad13.c1",
            "ad": "ad1",
            "building": "iad13",
            "restricted": "Y"
        },
        {
            "region": "iad13.c2",
            "ad": "ad1",
            "building": "iad14",
            "restricted": "N"
        },
        {
            "region": "iad1.region12",
            "name": "tstName.ind",
            "ad": "IAD1",
            "building": "iadct3.id1",
            "restricted": "N"
        }
    ],
    "status": 200,
    "op": "sitegrouplistget",
    "status-detail": "success"
}


ecra> sitegroup list building=iad13
* {
    "sitegroup": [
        {
            "region": "iad1.region16",
            "name": "NAME.iad3",
            "ad": "IAD3",
            "building": "tstry",
            "restricted": "Y"
        }
    ],
    "status": 200,
    "op": "sitegrouplistget",
    "status-detail": "success"
}

ecra> sitegroup list cloudvendor=Azure
* {
    "sitegroup": [
        {
            "region": "region",
            "name": "name4",
            "ad": "ad",
            "building": "building2",
            "restricted": "Y",
            "cloud_vendor": "Azure",
            "cloud_provider_region": "region-01"
        }
    ],
    "status": 200,
    "op": "sitegrouplistget",
    "status-detail": "success"
}
ecra> 



ecra> sitegroup list cloudproviderregion=region-01
* {
    "sitegroup": [
        {
            "region": "region",
            "name": "name4",
            "ad": "ad",
            "building": "building2",
            "restricted": "Y",
            "cloud_vendor": "Azure",
            "cloud_provider_region": "region-01"
        }
    ],
    "status": 200,
    "op": "sitegrouplistget",
    "status-detail": "success"
}

## update two or more params at same time

ecra> sitegroup update name=ad16.c1  cloudproviderbuilding=building16b region=R2
* {
    "status": 200,
    "op": "cabinet_update_put",
    "status-detail": "success"
}
ecra> sitegroup list  sitegroupname=ad16.c1  cloudproviderbuilding=building16b region=R2
* {
    "sitegroup": [
        {
            "region": "R2",
            "name": "ad16.c1",
            "ad": "AD1",
            "building": "ad16",
            "restricted": "Y",
            "cloud_vendor": "Azure",
            "cloud_provider_region": "regionAZ1",
            "cloud_provider_az": "AZ2",
            "cloud_provider_building": "building16b"
        }
    ],
    "status": 200,
    "op": "sitegrouplistget",
    "status-detail": "success"
}

###Update information about site group

To update information in the site group provide the parameters to update and the new values for them

Usage:
ecra sitegroup update <sitegroupname> [key=value]*

Examples:
ecra> sitegroup update tstName.ind cloudvendor=newvendor
* {
    "status": 200,
    "op": "cabinet_update_put",
    "status-detail": "success"
}

ecra> sitegroup update tstName.ind cloudvendor=newvendor cloudproviderregion=newcloudproviderregion
* {
    "status": 200,
    "op": "cabinet_update_put",
    "status-detail": "success"
}

ecra> sitegroup update sitegroupname=ad16.c1  cloudproviderbuilding=building16A
* {
    "status": 200,
    "op": "cabinet_update_put",
    "status-detail": "success"
}


# SITEGROUP UPDATERPM #

 
## Description
Updates information about site group rpm for the entire Cloud vendor
ecra>sitegroup update

## Usages
`ecra sitegroup updaterpm  cloudvendor=<value> dbaastoolsrpm=<name> dbaastoolsrpmchecksum=<sha256 checksum>`

## Values
`  cloudvendor: specify the name of the cloudvendor to update`
`  dbaastoolsrpm: specify the dbaas tools rpm that will be used for the specific cloud vendor`
`  dbaastoolsrpmchecksum: Specify the dbaas tools rpm checksum for the given rpm`

## Examples


ecra> help sitegroup updaterpm
sitegroup updaterpm cloudvendor=<value> dbaastoolsrpm=<name>
dbaastoolsrpmchecksum=<SHA256 value>
 Update default RPM used into cloud vendor in case is not the default one


ecra> sitegroup updaterpm cloudvendor=Azure dbaastoolsrpm=Azure.rpm
dbaastoolsrpmchecksum=d1ae43a9922c2698186a16e396ab26ac36d9a18d3ecf5c4de03f76f8f4535850
* {
    "status": 200,
    "op": "cabinet_update_put",
    "status-detail": "success"
}
ecra> sitegroup list
* {
    "sitegroup": [
        {
            "region": "iad1.region1",
            "name": "tstName4.ind",
            "ad": "IAD1",
            "building": "iadct4.id1",
            "restricted": "Y",
            "cloud_vendor": "Azure",
            "cloud_provider_region": "test2",
            "cloud_provider_az": "AZ1",
            "cloud_provider_building": "building1",
            "mtu": 9000,
            "far_child_site": "N",
            "overlay_bridge_used": "N",
            "dbaastoolsrpm": "Azure.rpm",
            "dbaastoolsrpm_checksum":
"d1ae43a9922c2698186a16e396ab26ac36d9a18d3ecf5c4de03f76f8f4535850"
        },
        {
            "region": "iad1.region1",
            "name": "tstName.ind",
            "ad": "IAD1",
            "building": "iadct3.id1",
            "restricted": "N",
            "cloud_vendor": "OCI",
...
}


##configurefeature
###Description
Update configured features

###Usages
`ecra> sitegroup configurefeature name=tstNameindu8Ju57gVUj feature=vmboss value=enabled`

###Values
* name: specify the name of the sitegroup to update
* feature: name of the feature to update
* value: enabled or disabled

###Examples
```
ecra> sitegroup configurefeature name=tstNameindu8Ju57gVUj feature=vmboss value=enabled
* {
    "status": 200,
    "op": "sitegroup_vmboss_put",
    "status-detail": "success"
}

ecra> sitegroup list name=tstNameindu8Ju57gVUj
* {
    "sitegroup": [
        {
            "region": "iad1.region1",
            "name": "tstNameindu8Ju57gVUj",
            "ad": "IAD1",
            "building": "building",
            "restricted": "N",
            "cloud_vendor": "testvendor",
            "cloud_provider_region": "testproviderregion",
            "cloud_provider_az": "testcloudprovideraz",
            "cloud_provider_building": "testcloudproviderbuilding",
            "mtu": 9000,
            "far_child_site": "N",
            "overlay_bridge_used": "N",
            "configured_features": "ALL,-VMBOSS"
        }
    ],
    "status": 200,
    "op": "sitegrouplistget",
    "status-detail": "success"
}
```

#Backfill adminsmartnics

##Usage

ecra> help backfill adminsmartnics
payload=<filepath>
Backfill admin network info for specific cabinet


##Samples


###backfill adminsmartnics

cat /admin.json
```json
{
  "ad": "IAD",
  "cabinetNumber": "103709",
  "model": "X8M Elastic",
  "adminSmartnics": [
    {
      "smartnicId": "smartnic serial",
      "vnicId": "ocid.xxxxxxx",
      "active": true,
      "mac": "00:10:37:af:4f:b2",
      "caviumIp": "10.193.200.27"
    },
    {
      "smartnicId": "smartnic serial2",
      "vnicId": "ocid.xxxxxxx2",
      "active": false,
      "mac": "00:10:37:af:4f:b2",
      "caviumIp": "10.193.200.27"
    }
  ]
}
```

ecra> backfill adminsmartnics payload=/admin.json
* {"updatedRecords": 0, "insertedRecords": 2, "status": 200, "op": "cavium_adminsmartnic_post", "status-detail": "success"}


#Backfill update_cavium

##Usage

ecra> help backfill update_cavium
backfill update_cavium <current_cavium_id=current id> <current_etherface_type=DB_CLIENT|DB_BACKUP> <new_cavium_id=id> <new_cavium_ip=ip> <new_mac=mac>
 This API can be used to update multiple cavium properties like ip, mac, id for a given cavium ID. current_cavium_id is a mandatory input. current_etherface_type is mandatory if new_mac parameter is used.


##Samples


###backfill update_cavium

ecra> backfill update_cavium current_cavium_id=4.0G1949-GBC000073 new_cavium_id=4.0G1949-GBC000073_new  current_etherface_type=DB_CLIENT new_mac=00:10:8a:09:d0:b3_new new_cavium_ip=10.9.127.430 
{"status": 200, "op": "cavium_put", "status-detail": "success"}

SQL> select  hw_node_id || ' '|| cavium_id||' '||etherface||' '||mac||'
'||etherface_type||' '||cavium_ip from ecs_caviums where hw_node_id='1';

HW_NODE_ID||''||CAVIUM_ID||''||ETHERFACE||''||MAC||''||ETHERFACE_TYPE||''||CAVIUM_IP
------------------------------------------------------------------------------------------------------------------------
1 4.0G1949-GBC000073_new eth1 00:10:8a:09:d0:b4 DB_CLIENT 10.9.127.430

# Properties

## Put

### Description
*Update the property value and description.*

### Arguments:
`<property_name> : Name of the property you want to modify or add`
`value : Value you want to assign to the property`
`description: Description you want to assign to the property`

### Usages
`./ecracli properties put <property_name> [value=<new value>] [description=<new description>]`

### Examples
```json
./ecracli properties put FIREWALL_RULES_PER_GROUP value=9
				or
ecra> properties put FIREWALL_RULES_PER_GROUP value=9

{"status": 200, "message": "Update Successful", "op": "property_put"}

ecra> properties put ECRA_ENV description="Testing description"
* {"message": "1 columns were successfully updated.", "status": 200, "op": "property_put", "status-detail": "success"}

```

## Gettypes

### Description
*Get all the property types that are in the env.*

### Arguments:

### Usages
`./ecracli properties gettypes`

### Examples
```json
ecra> properties gettypes
* {
    "op": "properties_gettypes",
    "status": 200,
    "status-detail": "success",
    "types": [
        "ATP",
        "ATP_FP",
        "AUTORETRY",
        "BDCS",
        "BONDING",
        "CERTROTATION",
        "CLUSTERPOOL",
        "CLUSTER_LIFE_CYCLE",
        "CNS",
        "COMPLIANCE",
        "CORE_BURST",
        "CPS",
        "DEBUG",
        "DIAG",
        "DIAGNOSTIC",
        "DIAG_PRE_LOGCOL",
        "ECRA",
        "ECRA_ASYNC",
        "ECRA_RESILIENCE",
        "ECRA_WF",
        "ELASTIC",
        "ELASTICSHAPE",
        "EM",
        "EXACC",
        "EXACC_INVENTORY",
        "EXACC_NETWORK",
        "EXACLOUD",
        "EXACOMPUTE",
        "EXACS",
        "EXADATA",
        "EXASERVICE",
        "EXAUNIT",
        "FA",
        "FEATURE",
        "FEDRAMP",
        "FIREWALL",
        "HEARTBEAT",
        "HIGGS",
        "IAAS",
        "IDEMTOKEN",
        "INGESTION",
        "INT",
        "KMS",
        "KVMROCE",
        "LOCATION_DETAILS",
        "MDBCS",
        "MVM",
        "NODE_SUBSET",
        "NOSDI",
        "OCI",
        "OCI_REHOME",
        "OCI_UPGRADE",
        "OPENSSL",
        "OPERATION_TIMEOUT",
        "ORDS",
        "PAAS",
        "PATCHING",
        "PREPROV",
        "PREPROVISION",
        "REG_JOB_MANAGER",
        "REMOTEEXACLOUD",
        "SLA",
        "STATUS_TRACKER",
        "STIG",
        "TEST",
        "UIIMPACTING_FEATURES",
        "VMCONSOLE",
        "WSS",
        "ZDLRA"
    ]
}
```

# Requests

## Get

### Description
*Retrieves data related to the request. Use fields to add the extra columns to be retrieved*

### Arguments:
`id: The request id`
`fields: Comma splitted fields to be retrieved`
### Usages
`./ecracli requests get id<request_id> [fields=<comma splitted fields to retrieve>]` 

### Examples
```json
ecra> requests get id=11299d69-cdf3-4aee-9bc5-657803ffe65a fields=body,details,errors,resource_id
* {
    "result": {
        "details": {
            "operations": [
                {
                    "exaunit_id": 412,
                    "resource_id": "sea201507exdcl08",
                    "operation": "exaunit-delete-cell",
                    "details": "{\"cellnodes\":[\"sea201507exdcl08\"],\"releaseservers\":true,\"inventoryId\":[\"sea201507exdcl08\"],\"exaunitId\":412,\"rackname\":\"iad1-d4-cl3-559310b4-f51e-40e3-9840-e77430899e0f-clu02\",\"rack\":\"iad1-d4-cl3-559310b4-f51e-40e3-9840-e77430899e0f-clu02\",\"formationId\":\"412\"}",
                    "enabled": true
                },
                {
                    "exaunit_id": 411,
                    "resource_id": "sea201507exdcl08",
                    "operation": "exaunit-delete-cell",
                    "details": "{\"cellnodes\":[\"sea201507exdcl08\"],\"releaseservers\":true,\"inventoryId\":[\"sea201507exdcl08\"],\"exaunitId\":411,\"rackname\":\"iad1-d4-cl3-559310b4-f51e-40e3-9840-e77430899e0f-clu01\",\"rack\":\"iad1-d4-cl3-559310b4-f51e-40e3-9840-e77430899e0f-clu01\",\"formationId\":\"411\"}",
                    "enabled": true
                }
            ],
            "step": 1,
            "child_details": {
                "0": {
                    "wf_uuid": "33148737-e466-4ef2-88d4-884fb35b1a99"
                },
                "1": {
                    "wf_uuid": "2c5f64b2-20d5-49e7-b00e-dc61539a4fc3"
                }
            },
            "deleted_cells": [
                "sea201507exdcl08"
            ],
            "payload": {
                "idemtoken": "81d41657-162c-4449-a389-a680ca1b7cc0",
                "servers": "sea201507exdcl08",
                "releaseservers": "true"
            },
            "cdb_response": [
                {
                    "type": "rack",
                    "name": "iad1-d4-cl3-559310b4-f51e-40e3-9840-e77430899e0f-clu02",
                    "ocid": "test.vmocid1",
                    "message": "done",
                    "success": true
                },
                {
                    "type": "rack",
                    "name": "iad1-d4-cl3-559310b4-f51e-40e3-9840-e77430899e0f-clu01",
                    "ocid": "test.vmocid1",
                    "message": "done",
                    "success": true
                }
            ]
        },
        "resource_id": "sea201507exdcl08",
        "id": "11299d69-cdf3-4aee-9bc5-657803ffe65a",
        "status": "200",
        "wf_uuid": "2c5f64b2-20d5-49e7-b00e-dc61539a4fc3",
        "start_time": "2024-03-22T06:12:19+0000",
        "end_time": "2024-03-22T06:14:31+0000"
    },
    "status": 200,
    "op": "requests_get",
    "status-detail": "success"
}

ecra> requests get id=11299d69-cdf3-4aee-9bc5-657803ffe65a
* {
    "result": {
        "id": "11299d69-cdf3-4aee-9bc5-657803ffe65a",
        "status": "200",
        "wf_uuid": "2c5f64b2-20d5-49e7-b00e-dc61539a4fc3",
        "start_time": "2024-03-22T06:12:19+0000",
        "end_time": "2024-03-22T06:14:31+0000"
    },
    "status": 200,
    "op": "requests_get",
    "status-detail": "success"
}
```

## addregistry

### Description
* Generate a registry record with the information provided.

### Arguments:
`requestid: The request id`
`rackname: The rack which request belongs to`
`operationname: The operation running on the rack`
### Usages
`./ecracli requests addregistry requestid=<request id> rackname=<>rackname operationname=<operation name>` 

### Examples
```
ecra> requests addregistry requestid=60f4fabb-8a4e-4234-a537-57d6b5f9d753 rackname=sea2-d4-cl3-3eec8336-93ba-44f2-98e9-e990b57a8a71-clu01 operationname=mvm_attach_storage
* PUT http://phoenix131877.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/requests/addregistry/60f4fabb-8a4e-4234-a537-57d6b5f9d753
* {
    "op": "add_registry_put",
    "status": 200,
    "status-detail": "success"
}
```
# Idemtoken

## Renew

### Description
*Renew the idemtoken to be usable again*

### Arguments:
`idemtoken: The idemtoken to renew`

### Usages
`./ecracli idemtoken renew idemtoken=<idemtoken>` 

### Examples
```json
ecra> idemtoken renew idemtoken=56ab78f4-bd51-4d83-ae9c-9f4adfad8f5c
* {
    "op": "idem_token_renew",
    "status": 200,
    "status-detail": "success"
}
```

# Artifacts 

## deliver 

### Description
* Send a compressed file with instructions on how to install the binaries on the dom0, deliver rpm or other installables *

### Arguments:
`artifact: Artifact name`
`source: Full path location of the artifact`
`target: Type of the target (infra, rack, node)`
`state: State of the target (FREE, PROVISIONED)`

### Usages
`./ecracli artifact deliver artifact=<> source=<> target=<> state=<>` 

### Examples
```json
ecra> artifact deliver artifactname=sample01 source=/scratch/jzandate/artifacts/sample01.zip target=node state=FREE
* {
  "est_op_end_time": "",
  "message": "processing",
  "op": "artifact_deliver_post",
  "op_start_time": "2024-05-14T01:17:54+0000",
  "status": 202,
  "status-detail": "processing",
  "status_uri": "http://phoenix284828.dev3sub3phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/c9c98e20-8ef3-4a55-9bec-d2c8ea99a1c2"
}
```

## deliver_status

### Description
* Gets the status of the deliver process *

### Arguments:
`statusid: status uuid`

### Usages
`./ecracli artifact deliver_status statusid=<> `

### Examples
```json
ecra> artifact deliver_status statusid=c9c98e20-8ef3-4a55-9bec-d2c8ea99a1c2
* {
  "op": "requests_get",
  "result": {
    "component_response": {
      "dom0": [
        {
          "error_code": "0x02030007",
          "error_details": "ls: cannot access 'dom0monitor.rpm': No such file or directory",
          "hostname": "iad103714exdd005.iad103714exd.adminiad1.oraclevcn.com",
          "status": "fail"
        },
        {
          "error_code": "0x00000000",
          "error_details": "",
          "hostname": "iad103714exdd006.iad103714exd.adminiad1.oraclevcn.com",
          "status": "success"
        }
      ]
    },
    "end_time": "2024-05-14T01:17:55+0000",
    "id": "c9c98e20-8ef3-4a55-9bec-d2c8ea99a1c2",
    "start_time": "2024-05-14T01:17:54+0000",
    "status": "200",
    "wf_uuid": "7352c4a3-c2be-48a8-802e-5f6db09751f6"
  },
  "status": 200,
  "status-detail": "success"
}
```

# Exadata
## models

### Usage 
ecra> exadata models [model=<model name>] 
    or
./ecracli exadata models [model=<model name>] 

### Purpose
     Describe the models available, and details

### Argument
- model: filter the result by one single model name

### Example:

```json
ecra> exadata models
* {
    "models": [
        {
            "ilomtype": "OVERLAY",
            "model": "X10M-2",
            "support_status": "ACTIVE"
        },
        {
            "ilomtype": "SUBSTRATE",
            "model": "X11M-2",
            "support_status": "PENDING-RELEASE"
        },
        {
            "ilomtype": "OVERLAY",
            "model": "X8M-2",
            "support_status": "ACTIVE"
        },
        {
            "ilomtype": "OVERLAY",
            "model": "X9M-2",
            "support_status": "ACTIVE"
        }
    ],
    "op": "exadata-models-get",
    "status": 200,
    "status-detail": "success"
}
ecra> exadata models model=X9M-2
* {
    "models": [
        {
            "ilomtype": "OVERLAY",
            "model": "X9M-2",
            "support_status": "ACTIVE"
        }
    ],
    "op": "exadata-models-get",
    "status": 200,
    "status-detail": "success"
}

```

# Security

## Add filesystem encryption

### Description:
*Add new record in ecs_fs_encryption table to include info in Create Service Flow.*

### Arguments
`kms_id`
`customer_tenancy_id`
`bucket_id`
`bucket_name`
`bucket_namespace`
`kms_key_endpoint`
`infra_component`
`target_filesystems`
`key_source`
`encryption_mode`
`customer_tenancy_name`
`secret_compartment_id`
`vault_id`

### Usages
      security add_fsencryption  customer_tenancy_id=<customer_tenancy_id> infra_component=<infra_component> encryption_mode=<encryption_mode> key_source=<key_source> secret_compartment_id=<secret_compartment_id> vault_id=<vault_id> kms=<kms_id123>

### Examples
```json
ecra> security add_fsencryption customer_tenancy_id=tenancy.ocid infra_component=dom0 key_source=SiV encryption_mode=enabled secret_compartment_id=compartment.id vault_id=vault.id kms_id=kms_id.123
* {
     "status": 200,
     "op": "filesystem_encryption_PUT",
     "status-detail": "success"
}
ecra> security add_fsencryption infra_component=dom0 key_source=SiV encryption_mode=enabled secret_compartment_id=compartment.id vault_id=vault.id kms_id=kms_id.123
* {
     "status": 200,
     "op": "filesystem_encryption_PUT",
     "status-detail": "success"
}
```


## Remove filesystem encryption

### Description
*Remove record from ecs_fs_encryption table.*

### Arguments
`customer_tenancy_id`

### Usages
`security remove_fsencryption customer_tenancy_id=<customer_tenancy_id>`

### Examples:
```json
ecra> security remove_fsencryption customerTenancyId=tenancy.ocid1
* {
     "status": 200,
     "op": "filesystem_encryption_delete",
     "status-detail": "success"
  }
```

## List filesystem encryption

### Description
*List records from ecs_fs_encryption table.*

### Arguments
`rackname`

### Usage
`security list_fsencryption rackname=<rackname>`

### Examples:
```json
ecra> security list_fsencryption rackname=iad105413_cluster_name_14
* {
    "kms_id": "kms_id.123",
    "kms_key_endpoint": "https://",
    "bucket_name": "bucket1",
    "bucket_id": "kms_bucket_id.234",
    "customer_tenancy_id": "tenancy.ocid",
    "bucket_namespace": "exadata",
    "infraComponent": [
    {
        "encryption_mode": "enabled",
        "infra_component": "dom0",
        "target_filesystems": "all",
        "key_source": "KMS"
    },
    {
        "encryption_mode": "enabled",
        "infra_component": "domu",
        "target_filesystems": "all",
        "key_source": "KMS"
    },
    {
        "encryption_mode": "enabled",
        "infra_component": "cell",
        "target_filesystems": "all",
        "key_source": "KMS"
    }
 ],
    "status": 200,
    "op": "filesystem_encryption_get",
    "status-detail": "success"
 }
```

# PasswordManagement

## validatepassword

### Description
* Validate password stored in SIV with that in ECRA DB for all/given user

### Usages
`./ecracli passwordmanagement validatepassword [username=<username>]`

## Examples
```json
ecra> passwordmanagement validatepassword
* {
    "validationResult": [
        {
            "user": "admin",
            "result": "success"
        },
        {
            "user": "sdi",
            "result": "success"
        },
        {
            "user": "dod",
            "result": "success"
        },
        {
            "user": "ops",
            "result": "success"
        },
        {
            "user": "mdbcs",
            "result": "success"
        },
        {
            "user": "srguser",
            "result": "success"
        }
    ],
    "status": 200,
    "op": "passwordmanagement_validate_all_get",
    "status-detail": "success"
}

ecra> passwordmanagement validatepassword username=admin
* {
    "validationResult": "success",
    "status": 200,
    "op": "passwordmanagement_validate_get",
    "status-detail": "success"
}
```

# Operations Compatibility

## Add

### Description
* Add compatibility between the specified operations

### Usages
`./ecracli compatibility add operationname=<operation name> secondoperation=<operation name>`

## Examples
```json
ecra> compatibility add operationname=reshape-cores secondoperation=exaunit-delete-cell
* {
    "message": "Compatibility has been added successfully",
    "op": "compatibility_add_put",
    "status": 200,
    "status-detail": "success"
}
```

## Check

### Description
* Verify if the two specified operations are compatible

### Usages
`./ecracli compatibility check operationname=<operation name> secondoperation=<operation name>`

## Examples
```json
ecra> compatibility check operationname=reshape-cores secondoperation=reshape-storage
* {
    "compatibility": "true",
    "message": "The operations are compatible",
    "op": "compatibility_check_post",
    "status": 200,
    "status-detail": "success"
}
```

## List

### Description
* List the compatibility between operations

### Usages
`./ecracli compatibility list [operationname=<operation name>]`

## Examples
```json
ecra> compatibility list
* {
    "op": "compatibility_list_get",
    "result": [
        {
            "compatibility": [
                "reshape-cores"
            ],
            "operationname": "reshape-storage"
        },
        {
            "compatibility": [
                "reshape-cores"
            ],
            "operationname": "exaunit-attach-cell"
        },
        {
            "compatibility": [
                "reshape-storage",
                "exaunit-attach-cell",
                "exaunit-delete-cell",
                "oci-attach-cell"
            ],
            "operationname": "reshape-cores"
        },
        {
            "compatibility": [
                "reshape-cores"
            ],
            "operationname": "exaunit-delete-cell"
        },
        {
            "compatibility": [
                "reshape-cores"
            ],
            "operationname": "oci-attach-cell"
        }
    ],
    "status": 200,
    "status-detail": "success"
}

ecra> compatibility list operationname=reshape-cores
* {
    "op": "compatibility_get",
    "result": [
        {
            "compatibility": [
                "reshape-storage",
                "exaunit-attach-cell",
                "exaunit-delete-cell",
                "oci-attach-cell"
            ],
            "operationname": "reshape-cores"
        }
    ],
    "status": 200,
    "status-detail": "success"
}

```

## Remove

### Description
* Removes the compatibility between the specified operations

### Usages
`./ecracli compatibility remove operationname=<operation name> secondoperation=<operation name>`

## Examples
```json
ecra> compatibility remove operationname=reshape-cores secondoperation=exaunit-delete-cell
* {
    "message": "Compatibility has been removed successfully",
    "op": "compatibility_remove_post",
    "status": 200,
    "status-detail": "success"
}
```

## Valid Operations

### Description
* List the valid operations that can be used in compatibility

### Usages
`./ecracli compatibility validoperations`

## Examples
```json
ecra> compatibility validoperations
* {
    "op": "compatibility_valid_operations_get",
    "status": 200,
    "status-detail": "success",
    "validoperations": [
        "PATCHING",
        "capacity_tenant_attcells",
        "create-addi-db",
        "create-data-diskgroup",
        "create-service",
        "create-sparse-diskgroup",
        "create-starter-db",
        "createATPDbSystem",
        "createDatabase",
        "db_backup",
        "db_listbackups",
        "dbaas_patch",
        "dbpatch",
        "delete-addi-db",
        "delete-exaservice",
        "delete-pod",
        "delete-starter-db",
        "dg_configure",
        "dg_deleteconn",
        "dg_failover",
        "dg_fresh_setup",
        "dg_reinstate",
        "dg_repeat_setup",
        "dg_state",
        "dg_switchover",
        "dg_verifyconn",
        "drop-diskgroup",
        "exaunit-attach-cell",
        "exaunit-delete-cell",
        "exaunit_resume",
        "exaunit_suspend",
        "exaunit_vmcmd_put",
        "fetch-info-diskgroup",
        "healthcheck_rackexachk",
        "oci-attach-cell",
        "rebalance-diskgroup",
        "reconfigure-connectivity",
        "recreate-create",
        "recreate-delete",
        "recreate-grid-create-db",
        "recreate-service",
        "reshape-cores",
        "reshape-service",
        "reshape-storage",
        "resize-data-diskgroup",
        "resize-sparse-diskgroup",
        "resume-updatecores",
        "reverify-connectivity",
        "snap-create",
        "snap-delete",
        "tm-create",
        "tm-delete",
        "update-cores",
        "update-service",
        "vm_command",
        "vm_sshcommand"
    ]
}
```

# Workflows

## getinput

### Description
* Fetch the input payload a task on the workflow received and save it on the filesystem

### Arguments
`workflowId`
`taskname`

### Usages
`ecra>workflows getinput workflowId=<workflowid> taskname=<taskname>`

## Examples
```json
ecra> workflows getinput workflowId=2c1fa3c3-c00d-4e0e-a8b9-d82bd1846a38
taskname=ConfigCell
* {"jsoninput":
"../PodRepo/2c1fa3c3-c00d-4e0e-a8b9-d82bd1846a38_ConfigCell_taskinputpayload.json",
"status": 200, "op": "wf_fetch_json_input_get", "status-detail": "success"}

ecra> workflows getinput workflowId=c8c415d1-3759-46aa-a725-6e4fc355e2a9
* {"jsoninput": "../PodRepo/c8c415d1-3759-46aa-a725-6e4fc355e2a9_inputpayload.json", "status": 200, "op": "wf_fetch_json_input_get", "status-detail": "success"}
```

## updateinput

### Description
* Update the input payload a task on the workflow uses.

### Arguments
`workflowId`
`taskname`
`jsonpath`

### Usages
`ecra>workflows updateinput workflowId=<workflowid> taskname=<taskname> jsonpath=<path>`

## Examples
```json
ecra> workflows updateinput workflowId=2c1fa3c3-c00d-4e0e-a8b9-d82bd1846a38
taskname=ConfigCell
jsonpath=/scratch/gvalderr/ecra_installs/myecra/mw_home/user_projects/domains/PodRepo/updatedworkflowpayload2.json
* {"status": 200, "op": "wf_update_json_input_post", "status-detail": "success"}

ecra> workflows updateinput workflowId=c8c415d1-3759-46aa-a725-6e4fc355e2a9 jsonpath=../PodRepo/c8c415d1-3759-46aa-a725-6e4fc355e2a9_inputpayload.json
* {"status": 200, "op": "wf_update_json_input_post", "status-detail": "success"}
```
# Sshkey

## createdomukey

### Description
* Crea a new temporal SSH Key pair to get access to DomU

### Arguments
`exaunit_id: the exaunit id`
`domu: if not provided, a domU will be taken from the ECS_CORES table.`
`user: if not provided, the default user will be 'ops'`
`wait: use false to return the response from async api, use true to wait until the async call finishes`

### Usages
` ecra> sshkey createdomukey <exaunit id> [domu=<domu>] [user=<user>] [wait=<true/false>]`

## Examples
```json
ecra> sshkey createdomukey exaunit_id=17051
* {
    "domu": "_all_",
    "public_key": "zeuskey",
    "user": "opc"
}

ecra> sshkey createdomukey exaunit_id=17051 wait=false
* {
    "est_op_end_time": "",
    "exaunit_id": 17051,
    "message": "processing",
    "op": "generate-vm-public-key",
    "op_start_time": "2025-03-10T18:24:37+0000",
    "status": 202,
    "status-detail": "processing",
    "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/154d67d7-7d87-49ff-bc40-3776334c5967",
    "target_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/exaunit/17051/vms/sshkey/154d67d7-7d87-49ff-bc40-3776334c5967"
}
ecra> status 154d67d7-7d87-49ff-bc40-3776334c5967
* {"progress_percent": 0, "exaunit_id": 17051, "start_time_ts": "2025-03-10 18:24:37.0", "end_time": "2025-03-10T18:24:44+0000", "ecra_server": "EcraServer1", "wf_uuid": "95a07457-843a-42da-bb59-bc8d1227cd70", "start_time": "2025-03-10T18:24:37+0000", "exa_ocid": "flowtesterInfra", "target_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/exaunit/17051/vms/sshkey/154d67d7-7d87-49ff-bc40-3776334c5967", "last_heartbeat_update": "2025-03-10T18:24:37+0000", "status": 200, "message": "Done", "op": "generate-vm-public-key", "completion_percentage": 0, "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/154d67d7-7d87-49ff-bc40-3776334c5967", "status-detail": "success"}
ecra> workflows describe workflowId=95a07457-843a-42da-bb59-bc8d1227cd70
* {
    "workflowName": "ssh-temporal-key-create-wfd",
    "workflowId": "95a07457-843a-42da-bb59-bc8d1227cd70",
    "workflowStatus": "Completed",
    "workflowStartTime": "10 Mar 2025 18:24:37 UTC",
    "workflowEndTime": "10 Mar 2025 18:24:44 UTC",
    "wfRollbackMode": false,
    "wfErrorMessage": "",
    "tasks": [
        {
            "taskName": "InvokeECForCreateDomUPublicKeyTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Mon Mar 10 18:24:37 UTC 2025",
            "taskEndTime": "Mon Mar 10 18:24:43 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:06"
        },
        {
            "taskName": "UpdateMetadataCreateDomUPublicKeyTask",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Mon Mar 10 18:24:43 UTC 2025",
            "taskEndTime": "Mon Mar 10 18:24:43 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "taskName": "EndWf",
            "taskStatus": "COMPLETE",
            "taskStartTime": "Mon Mar 10 18:24:43 UTC 2025",
            "taskEndTime": "Mon Mar 10 18:24:43 UTC 2025",
            "taskErrorMessage": "",
            "taskElapsed": "00:00:00"
        },
        {
            "lastTaskName": "EndWf",
            "lastOperationDetails": {
                "lastTaskLastOperationId": "58f43f09-abfb-4147-8849-0ea97d0fa3fb",
                "lastTaskLastOperationName": "EXECUTE",
                "lastTaskLastOperationStatus": "SUCCESS",
                "lastTaskLastOperationStartTime": "10 Mar 2025 18:24:43 UTC",
                "lastTaskLastOperationEndTime": "10 Mar 2025 18:24:44 UTC"
            }
        }
    ],
    "workflowElapsed": "00:00:07",
    "workflowRuntime": "00:00:06",
    "exaOCID": "",
    "requestId": "154d67d7-7d87-49ff-bc40-3776334c5967",
    "isWorkflowsPaused": false,
    "WFServerOwner": "EcraServer1",
    "status": 200,
    "op": "wf_describe",
    "status-detail": "success"
}
```

## addadbskey

### Description
* Add the adbs key to KMS.

### Arguments
`exaunitid: the exaunit id`
`idemtoken: the idemtoken for the operation`

### Usages
`ecra> sshkey addadbskey <exaunitid> [idemtoken=<idemtoken>]`

## Examples
```json
ecra> sshkey addadbskey 20068
* {"status": 202, 
"status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f886f3ed-f3a0-432f-a326-6525b20bb1a0", 
"op": "add_adbs_key_post", "op_start_time": "2025-05-27T16:46:43+0000", "est_op_end_time": "", "message": "processing", 
"status-detail": "processing", "exaunit_id": 20068}

ecra> status f886f3ed-f3a0-432f-a326-6525b20bb1a0
* {"progress_percent": 0, "exaunit_id": 20068, "start_time_ts": "2025-05-27 16:46:43.0",
 "end_time": "2025-05-27T16:46:44+0000", "ecra_server": "EcraServer1", 
 "wf_uuid": "a595150d-11e4-4028-8de1-c921855aa86b", "start_time": "2025-05-27T16:46:43+0000", 
 "last_heartbeat_update": "2025-05-27T16:46:43+0000", "status": 200, "message": "Done", 
 "op": "add_adbs_key_post", "completion_percentage": 0, 
 "status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/f886f3ed-f3a0-432f-a326-6525b20bb1a0", 
 "status-detail": "success"}
```

## removeadbskey

### Description
* Delete the adbs key from KMS.

### Arguments
`exaunitid: the exaunit id`
`idemtoken: the idemtoken for the operation`

### Usages
`ecra> sshkey removeadbskey <exaunitid> [idemtoken=<idemtoken>]`

## Examples
```json
ecra> sshkey removeadbskey 20068
* {"status": 202, 
"status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/159fe8da-17cb-4f14-80a9-728731ef6e28", 
"op": "remove_adbs_key_post", "op_start_time": "2025-05-28T01:05:55+0000", "est_op_end_time": "", 
"message": "processing", "status-detail": "processing", "exaunit_id": 20068}

ecra> status 159fe8da-17cb-4f14-80a9-728731ef6e28
* {"progress_percent": 0, "exaunit_id": 20068, "start_time_ts": "2025-05-28 01:05:55.0", 
"end_time": "2025-05-28T01:06:01+0000", "ecra_server": "EcraServer1", 
"wf_uuid": "af2ffe83-bc00-4965-b7d4-151962e5384f", "start_time": "2025-05-28T01:05:55+0000", 
"last_heartbeat_update": "2025-05-28T01:05:55+0000", "status": 200, "message": "Done", 
"op": "remove_adbs_key_post", "completion_percentage": 0, 
"status_uri": "http://phoenix310481.dev3sub2phx.databasede3phx.oraclevcn.com:9001/ecra/endpoint/statuses/159fe8da-17cb-4f14-80a9-728731ef6e28", 
"status-detail": "success"}
```

# ResourceBlackout

## Get Latest

### Description
*Get latest entry from blackouts table with given resourcename*

### Arguments
`resourcename: the resourcename to get`

###  Usages
`ecracli resourceblackout getlatest resourcename=<resourceName>`

###  Examples
```json
  ecra> resourceblackout getlatest resourcename=testresource4
* {
    "blackout": {
        "resourceName": "testresource4",
        "resourceType": "typeC",
        "creationTime": "2025-03-18 12:32:30.40326",
        "startTime": "2025-03-18T12:32:30+0000",
        "endTime": "2025-03-18T13:32:30+0000",
        "blackoutType": "typeX",
        "status": "ENABLED",
        "source": "abc",
        "comments": "abc",
        "alert": "abc",
        "operationAllowed": "abc",
        "id": 13
    },
    "status": 200,
    "op": "blackout_resource_get",
    "status-detail": "success"
}
```

## Get History

### Description
*Get list of history of blackouts with given resourcename*

### Arguments
`resourcename: the resourcename to get`

### Usages
`ecracli resourceblackout gethistory resourcename=<resourceName>`

### Examples
```json
ecra> resourceblackout gethistory resourcename=testresource4
* {
    "blackouts": [
        {
            "resourceName": "testresource4",
            "resourceType": "typeC",
            "creationTime": "2025-03-18 12:32:30.40326",
            "startTime": "2025-03-18T12:32:30+0000",
            "endTime": "2025-03-18T13:32:30+0000",
            "blackoutType": "typeX",
            "status": "ENABLED",
            "source": "abc",
            "comments": "abc",
            "alert": "abc",
            "operationAllowed": "abc",
            "id": 13
        }
    ],
    "status": 200,
    "op": "blackout_history_get",
    "status-detail": "success"
}
```

## Get Enabled

### Description
*Get list of all enabled blackouts*

### Usages
`ecracli resourceblackout getenabled`

### Examples
```json
ecra> resourceblackout getenabled
* {
    "blackouts": [
        {
            "resourceName": "testresource4",
            "resourceType": "typeC",
            "creationTime": "2025-03-18 12:32:30.40326",
            "startTime": "2025-03-18T12:32:30+0000",
            "endTime": "2025-03-18T13:32:30+0000",
            "blackoutType": "typeX",
            "status": "ENABLED",
            "source": "abc",
            "comments": "abc",
            "alert": "abc",
            "operationAllowed": "abc",
            "id": 13
        }
    ],
    "status": 200,
    "op": "blackout_enabled_get",
    "status-detail": "success"
}
```

## Create

### Description
*Create entry in ecs_resource_blackout table*

### Arguments
`payload: path to payload`

### Usages:
`ecracli resourceblackout create payload=<path to payload>`

### Example
```json
ecra> resourceblackout create payload=/tmp/resourceblackout.json
* {
    "status": 200,
    "op": "blackout_create_post",
    "status-detail": "success"
}
```

## Update

### Description
*Update latest enabled/pending blackout entry of given resourcename*

### Arguments
`resourcename: ResourceName to be updated`
`payload: path to payload`

### Usages
`ecracli resourceblackout update resourcename=<resourceName> payload=<path to payload>`

### Examples
```json
ecra> resourceblackout update resourcename=testresource4 payload=/tmp/updateblackout.json
* {
    "status": 200,
    "op": "blackout_update_put",
    "status-detail": "success"
}
```

## Refresh

### Description
*Refresh the status of latest enabled/pending blackout entry according to start time and end time*

### Arguments
`resourcename: resourcename of entry to be refreshed`

### Usages
`ecracli resourceblackout refresh resourcename=<resourceName>`

### Example
```json
ecra> resourceblackout refresh resourcename=testresource4
* {
    "status": 200,
    "op": "blackout_refresh_put",
    "status-detail": "success"
}
```

## Disable

### Description
*Disable status of latest blackout entry given resourceName*

### Arguments
`resourcename: resourcename of blackout to be disabled`

### Usages
`ecracli resourceblackout disable resourcename=<resourceName>`

### Examples
```json
ecra> resourceblackout disable resourcename=testresource4
* {
    "status": 200,
    "op": "blackout_update_put",
    "status-detail": "success"
}
```

# Exascale

## ersip register

### Description
* Register an single ERS IP, or all the ERS IPs in the provided flat file 

### Arguments
`ocid`
`ip`
`cabinet_name`
`ip_state`
`flat_file `

### Usages
`exascale ersip register [ocid=<floating ip ocid> ip=<ip address> cabinet_name=<cabinet name> ip_state=<AVAILABLE|ASSIGNED>] | [flat_file=<path>]`

## Examples

```json
ecra> exascale ersip register ocid=ocid.cli.test.0002 ip=1.1.1.2 cabinet_name=SEA201610 ip_state=AVAILABLE
* {"ocid": "ocid.cli.test.0002", "ip": "1.1.1.2", "ip_state": "AVAILABLE", "cabinet_name": "SEA201610", "status": 200, "op": "ip_free_compute_delete", "status-detail": "success"}
```

```json
ecra> exascale ersip register flat_file=/scratch/llmartin/home/Documents/flatfiles/flatfile_ers.test
* {"ocid": "ocid1.privateip.oc1.us-chicago-1.abxxeljrx34vrz6phzx7ncw5joqees4pscbe5dfsafasdfasdfdsfadsfsd2", "ip": "10.0.128.238", "ip_state": "AVAILABLE", "cabinet_name": "SEA201610", "status": 200, "op": "ip_free_compute_delete", "status-detail": "success"}
* {"ocid": "ocid1.privateip.oc1.us-chicago-1.abxxeljrx34vrz6phzx7ncw5joqees4pscbe5dafdasfadsfwefasdfgargd", "ip": "10.0.128.239", "ip_state": "AVAILABLE", "cabinet_name": "SEA201610", "status": 200, "op": "ip_free_compute_delete", "status-detail": "success"}
* {"ocid": "ocid1.privateip.oc1.us-chicago-1.abxxeljrx34vrz6phzx7ncw5joqees4pscbe5gshsthftrujwytewt34st34", "ip": "10.0.128.240", "ip_state": "AVAILABLE", "cabinet_name": "SEA201610", "status": 200, "op": "ip_free_compute_delete", "status-detail": "success"}
* {"ocid": "ocid1.privateip.oc1.us-chicago-1.abxxeljrx34vrz6phzx7ncw5joqees4pscbe53yywhre54hyw5432g43ysd4", "ip": "10.0.128.241", "ip_state": "AVAILABLE", "cabinet_name": "SEA201610", "status": 200, "op": "ip_free_compute_delete", "status-detail": "success"}
* {"ocid": "ocid1.privateip.oc1.us-chicago-1.abxxeljrx34vrz6phzx7ncw5joqees4pscbe5fgy54213qtfahe457y54qw4", "ip": "10.0.128.242", "ip_state": "AVAILABLE", "cabinet_name": "SEA201610", "status": 200, "op": "ip_free_compute_delete", "status-detail": "success"}
```

