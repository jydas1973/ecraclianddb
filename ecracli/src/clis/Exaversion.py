#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Exaversion.py /main/11 2025/03/14 06:02:44 sdevasek Exp $
#
# Exaversion.py
#
# Copyright (c) 2020, 2025, Oracle and/or its affiliates.
#
#    NAME
#      Exaversion.py - CLI for Exaversion registration and exaversion patches report
#
#    DESCRIPTION
#     CLI for Exaversion registration and exaversion patches report 
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    sdevasek    03/10/25 - Enh 37473003 - ECRA REGISTER BASED ON RACK MODEL
#    jyotdas     02/07/25 - Enh 37267618 - Expose Ecra api to return registered
#                           versions for image series in exacs
#    abherrer    12/05/22 - Enh 33040415 - Added new parameters for patchesreport
#    jyotdas     05/05/22 - Enh 34042024 - Ecra api to display all prior patch
#                           versions
#    abherrer    04/13/22 - added methods to get all service types and to add a
#                           new one
#    jyotdas     12/20/21 - Enh 33095986 - Cleanup exadata bundle patches and
#                           images regularly in EXACS
#    jyotdas     11/10/20 - ENH 31997453 - Ecra API to list patch updates and
#                           validate
#    nmallego    11/01/20 - Bug32098882 - Fixing exaversion registration
#    jyotdas     10/13/20 - Enh 31684095 - Provide option to Register Exadata
#                           Patch Versions
#    josedelg    09/24/20 - Creation
#

from formatter import cl
import json
import urllib.request, urllib.parse, urllib.error

class Exaversion:
      def __init__(self, HTTP):
          self.HTTP = HTTP

      # This method adds a new service type
      def do_add_service_type(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('exaversion', 'addservicetype', params)
          except Exception as e:
              cl.perr(str(e))
          data = json.dumps(params, sort_keys=True, indent=4)
          response = self.HTTP.post(data, "exaversion", "{0}/exaversion/servicetype".format(host))
          if response:
              cl.prt("n", json.dumps(response))

      # This method gets a list of service types
      def do_get_service_type(self, ecli, line, host):
          ecli.issue_get_request("{0}/exaversion/servicetype".format(host))

      # This method gets a list of exaversion patch
      def do_get_exaversion(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters("exaversion", "get")
          except Exception as e:
              cl.perr(str(e))
              return
          query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
          ecli.issue_get_request("{0}/exaversion/registration{1}".format(host, query))

      def do_register_exaversion(self, ecli, line, host):
          params = ecli.parse_params(line, None)

          targetTypes = []
          if "targetTypes" in params:
              targetTypesVal = params["targetTypes"]
              if targetTypesVal.find("+") > -1:
                  targetTypes = targetTypesVal.split("+")
              else:
                  targetTypes.append(targetTypesVal)
              params["targetTypes"] = targetTypes

          # Validate the parameters
          try:
              ecli.validate_parameters('exaversion', 'register', params)
          except Exception as e:
              cl.perr(str(e))
              return

          data = json.dumps(params, sort_keys=True, indent=4)
          #cl.prt("c", "data  %s " % data)
          response = self.HTTP.post(data, "exaversion", "{0}/exaversion/registration".format(host))
          if response:
              cl.prt("n", json.dumps(response))

      # This method deregisters a registered exaversion
      def do_deregister_exaversion(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('exaversion', 'deregisterexaversion', params)
          except Exception as e:
              cl.perr(str(e))
              return
          delete_request_query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""	  
          response = self.HTTP.delete("{0}/exaversion/registration{1}".format(host, delete_request_query))
          if response:
              cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

      # get exaversion patches report
      def do_get_patches_report(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters('exaversion', 'patchesreport', params)
          except Exception as e:
              cl.perr(str(e))

          status = params["status"]
          rack_name = ""
          cabinet_name = ""
          image_version = ""
          patch_type = ""
          operation = ""
          if "rackName" in params:
              rack_name = params["rackName"]
          if "cabinetName" in params:
              cabinet_name = params["cabinetName"]
          if "imageVersion" in params:
              image_version = params["imageVersion"]
          if "patchType" in params:
              patch_type = params["patchType"]
          if "operation" in params:
              operation = params["operation"]


          url = "{0}/exaversion/patchesreport?status={1}&rack_name={2}&cabinet_name={3}&image_version={4}&patch_type={5}&operation={6}".format(host, status, rack_name, cabinet_name, image_version, patch_type, operation)
          # cl.prt("c", "GET " + url)
          response = ecli.issue_get_request(url, False)
          cl.prt("c", json.dumps(response, indent=4, sort_keys=True))

      def do_register_exaversion_imageseries(self, ecli, line, host):
          params = ecli.parse_params(line, None)

          targetTypes = []
          if "targetTypes" in params:
              targetTypesVal = params["targetTypes"]
              if targetTypesVal.find("+") > -1:
                  targetTypes = targetTypesVal.split("+")
              else:
                  targetTypes.append(targetTypesVal)
              params["targetTypes"] = targetTypes

          # Validate the parameters
          try:
              ecli.validate_parameters('exaversion', 'registerimageseries', params)
          except Exception as e:
              cl.perr(str(e))
              return

          data = json.dumps(params, sort_keys=True, indent=4)
          #cl.prt("c", "data  %s " % data)
          response = self.HTTP.post(data, "exaversion", "{0}/exaversion/imageseries".format(host))
          if response:
              cl.prt("n", json.dumps(response))

      def do_get_exaversion_imageseries(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters("exaversion", "getimageseries")
          except Exception as e:
              cl.perr(str(e))
              return
          query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
          ecli.issue_get_request("{0}/exaversion/imageseries{1}".format(host, query))

      def do_list_patches(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          try:
              ecli.validate_parameters("exaversion", "listpatches")
          except Exception as e:
              cl.perr(str(e))
              return
          query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
          ecli.issue_get_request("{0}/exaversion/listpatches{1}".format(host, query))

      def do_list_patchesmetadata(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          params_dict = {}
          try:
              ecli.validate_parameters("exaversion", "listpatchesmetadata")
              for key, value in params.items():
                  params_dict[key] = value
          except Exception as e:
              cl.perr(str(e))
              return

          #urlencode will take care of special characters like + in params e.g dom0+cell
          ecli.issue_get_request("{0}/exaversion/listpatchesmetadata?{1}".format(host, urllib.parse.urlencode(params_dict)))

      def do_purge_patches(self, ecli, line, host):
          params = ecli.parse_params(line, None)
          # Validate the parameters
          try:
              ecli.validate_parameters('exaversion', 'purge', params)
          except Exception as e:
              cl.perr(str(e))
              return

          if "retention" in params or "patchVersion" in params:
              data = json.dumps(params, sort_keys=True, indent=4)
              response = self.HTTP.put("{0}/exaversion/purge".format(host), data, "exaversion")
          else:
              cl.perr("Either patchVersion or retention should be specified as parameter.\n")
              for i in ecli.sub_ops_help["exaversion"]["purge"]:
                  print(i)
              return

          if response:
              cl.prt("n", json.dumps(response))
