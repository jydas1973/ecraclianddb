#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/PatchMetadata.py /main/7 2025/06/11 07:00:45 sdevasek Exp $
#
# PatchMetadata.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      PatchMetadata.py - CLI for ECRA metadata registration and metadata listing
#
#    DESCRIPTION
#     CLI for ECRA metadata registration,deregistration and metadata listing
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    sdevasek    06/05/25 - Enh 37987808 - PROVIDE ECRACLI COMMAND TO DELETE
#                           LAUNCHNODE METADATA ABOUT RUNNING PATCHING SESSIONS
#    jyotdas    09/07/24 - ENH 36108574 - API to update ecra with dom0 and
#                          cells version
#    jyotdas    07/16/24 - Enh 36799146 - CLI to sync ecra metadata for vm
#                          state with actual state of the vm in infra
#    antamil    07/09/24 - Bug 35827899 - Changes to make infraName optional
#                          for register launchnode 
#    sdevasek   04/08/24 - Bug 36491151 - PYTHON CODE FAIL IN ECRA_VALIDATOR.SH
#                          FOR ECRACLI CODE
#    sdevasek   03/29/24 - Enh 36316080 - ECRACLI IMPLEMENTATION FOR PLUGIN 
#                          REGISTRATION MANAGEMENT AND EXECUTING OP=ONEOFFV2
#    antamil    04/28/23 - Creation
#

from formatter import cl
import json
import urllib.request, urllib.parse, urllib.error

class PatchMetadata:
      def __init__(self, HTTP):
          self.HTTP = HTTP

      # This method registers a new launch node
      def do_register_launch_node(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'registerlaunchnodes', params)
          except Exception as e:
              cl.perr(str(e))
          data = json.dumps(params, sort_keys=True, indent=4)
          response = self.HTTP.post(data, None, "{0}/infrapatch/launchNode/register".format(host))
          if response:
              cl.prt("n", json.dumps(response))


      # This method gets a list of launch node
      def do_get_launch_node(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'getlaunchnodes', params)
          except Exception as e:
              cl.perr(str(e))
              return
          query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
          ecli.issue_get_request("{0}/infrapatch/launchNode{1}".format(host, query))

      # This method deregisters a launch node
      def do_deregister_launch_node(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'deregisterlaunchnodes', params)
          except Exception as e:
              cl.perr(str(e))
              return
          delete_request = "{0}/infrapatch/launchNode/{1}".format(host, params['infraType'])
          del params['infraType']
          delete_request += "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
          cl.prt("n", delete_request)
          response = self.HTTP.delete(delete_request)
          if response:
              cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

      # This method registers metadata for a plugin script 
      def do_register_pluginscript(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'registerpluginscript', params)
          except Exception as e:
              cl.perr(str(e))
          data = json.dumps(params, sort_keys=True, indent=4)
          response = self.HTTP.post(data, None, "{0}/infrapatchpluginscripts/registration".format(host))
          if response:
              cl.prt("n", json.dumps(response))

      # This method updates metadata of a registered plugin script
      def do_update_pluginscript(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'updatepluginscript', params)
          except Exception as e:
              cl.perr(str(e))
          data = json.dumps(params, sort_keys=True, indent=4)
          response = self.HTTP.put("{0}/infrapatchpluginscripts/registration".format(host), data, None)
          if response:
              cl.prt("n", json.dumps(response))

      # This method gets the registered plugin scripts
      def do_list_pluginscript(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'listpluginscripts', params)
          except Exception as e:
              cl.perr(str(e))
              return
          query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
          ecli.issue_get_request("{0}/infrapatchpluginscripts/registration{1}".format(host, query))

      # This method deregisters metadata of a registered plugin script
      def do_deregister_pluginscript(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'deregisterpluginscript', params)
          except Exception as e:
              cl.perr(str(e))
              return
          data = json.dumps(params, sort_keys=True, indent=4)
          response = self.HTTP.delete("{0}/infrapatchpluginscripts/registration/{1}".format(host, params['ScriptAlias']),data)
          if response:
              cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

      # This method delete metadata about running patch operations on the launchNode
      def do_delete_launchnodemetadata(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'deletelaunchnodemetadata', params)
          except Exception as e:
              cl.perr(str(e))
              return
          delete_metadata_query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
          response = self.HTTP.delete("{0}/infrapatch/launchNode/infrapatchOperations{1}".format(host, delete_metadata_query))
		  
          if response:
              cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

      def do_sync_infra_images(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'syncinfraimages', params)
          except Exception as e:
              cl.perr(str(e))
              return
          jsonBody = {}

          hasRackName  = "rackName" in params
          hastargetType  = "targetType" in params

          if hasRackName:
              jsonBody["rackName"] = params["rackName"]
          if hastargetType:
              jsonBody["targetType"] = params["targetType"]

          data = json.dumps(jsonBody, sort_keys=True, indent=4)
          if data:
              response = self.HTTP.post(data, None, "{0}/infrapatch/syncInfraImageVersions".format(host))

          if response:
              cl.prt("n", json.dumps(response))

      def do_sync_vm_state(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('patchmetadata', 'syncvmstate', params)
          except Exception as e:
              cl.perr(str(e))
              return
          jsonBody = {}
          data = None
          urlToPut = None

          hasRackName  = "rackName" in params
          hasVMCustomerName  = "vmCustomerHostName" in params
          hasVMState = "vmState" in params

          if hasRackName and hasVMCustomerName:
              urlToPut = "{0}/infrapatch/syncvmstate/{1}/{2}".format(host, params['rackName'],params["vmCustomerHostName"])

          if hasVMState:
              jsonBody["vmState"] = params["vmState"]
              data = json.dumps(jsonBody, sort_keys=True, indent=4)

          if data:
              response = self.HTTP.put(urlToPut, data, "syncvmstate")
          else:
               response = self.HTTP.put(urlToPut, None, "syncvmstate")
          if response:
              cl.prt("n", json.dumps(response))

      
