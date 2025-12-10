#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/clis/Ingestion.py /main/2 2024/01/24 23:21:28 cgarud Exp $
#
# Ingestion.py
#
# Copyright (c) 2023, 2024, Oracle and/or its affiliates.
#
#    NAME
#      Ingestion.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    cgarud      01/20/24 - Fix typo. updatecabinet -> updateCabinet
#    rmavilla    02/06/23 - exacs-91468 ALLOW ECRA TO IMPORT A PARTIALLY
#                           INGESTED CABINET
#    rmavilla    02/06/23 - Creation
#

from formatter import cl
import json
import random

class Ingestion:
    UPDATE_CABINET = "updateCabinet"
    ACTION = "action"
    INGESTION = "ingestion"
    IMPORT = "import"
    CABINET_NAME = "cabinetname"
    CABINET_JSON = "cabinetjson"
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_ingestion_import(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        if (params[self.ACTION].lower() == self.UPDATE_CABINET.lower()):
            self.import_cabinet(ecli, params, host)

    def import_cabinet(self, ecli, params, host):
        print_raw = "raw" in params and params.pop("raw").lower() == "true"
        try:
            ecli.validate_parameters(self.INGESTION, self.IMPORT, params)
        except Exception as e:
            return cl.perr(str(e))
        payload   = json.load(open(params[self.CABINET_JSON]))
        action = params[self.ACTION]
        cabinetName = params[self.CABINET_NAME]
        data = json.dumps(payload, sort_keys=False, indent=4)
        response = self.HTTP.put("{0}/ingestion/import/{1}?action={2}".\
                                  format(host, cabinetName, action), \
                                 data, self.INGESTION)
        if response:
            cl.prt("n", json.dumps(response))

