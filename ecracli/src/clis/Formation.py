
"""
 Copyright (c) 2015, 2023, Oracle and/or its affiliates.

NAME:
    Formation - CLIs to operate capacity management

FUNCTION:
    Provides the clis to operate exa formatoin entities adding/deleting new elements into 
    the formation

NOTE:
    None

History:
    marcoslo   08/08/20 - ER 30613740 Update code to use python 3
    jreyesm    07/06/18 - E.R 27926559. Exa formation entities
    jreyesm    04/12/18 - creation
"""


from formatter import cl
import json
import os
from os import path
import re
import sys


try:
    from lxml import etree as et
except ImportError:
    #Code updated for python 3. Assert is not valid anymore.
    #assert sys.version_info[:2] == (2, 7), "please use python 2.7"
    import xml.etree.ElementTree as et

class Formation:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_formation_list(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("formation", "list", params)
        except Exception as e:
            cl.perr(str(e))
            return
        response = None
        if 'formation_id' in params:
            response = ecli.issue_get_request("{0}/formation/{1}".format(host, params['formation_id']), False)
        else:
            response = ecli.issue_get_request("{0}/formation".format(host), False)

        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


    def do_formation_delete(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters("formation", "detach", params)
        except Exception as e:
            cl.perr(str(e))
            return
        formationId=params['formation_id']
        response = self.HTTP.delete("{0}/formation/{1}".format(host,formationId), json.dumps(params))
        cl.prt("n", json.dumps(response, indent=4, sort_keys=False))


