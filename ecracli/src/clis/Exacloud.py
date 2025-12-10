#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/Exacloud.py /main/1 2020/08/20 05:39:37 marcoslo Exp $
#
# Exacloud.py
#
# Copyright (c) 2020, Oracle and/or its affiliates. 
#
#    NAME
#      Exacloud.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    illamas     08/03/20 - Enh 31657170 -  Exassh endpoint to update records in exassh table
#

from formatter import cl
import json

class Exacloud:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_setexassh(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('exacloud', 'setexassh', params)
        except Exception as e:
            return cl.perr(str(e))

        url  = "{0}/exacloud/setexassh".format(host)
        payload = dict()
        payload["rack"] = { "ecra_db_rack_name" : params['rackname'] }
        data = json.dumps(payload, sort_keys=True, indent=4)
        response = self.HTTP.put(url, data, "exacloud");
        if response:
            cl.prt("n", json.dumps(response))
