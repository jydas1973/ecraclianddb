"""
 Copyright (c) 2015, 2017, Oracle and/or its affiliates. All rights reserved.

NAME:
    Ebtables - CLIs for sub-operations under Ebtables

FUNCTION:
    Provides the clis to enable/disable/add and delete ebtables and rules

NOTE:
    None

History:
    rgmurali    04/20/2017 - Create file
"""
from formatter import cl

class Ebtables:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_enable_ebtables(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("enable_ebtables takes one mandatory argument")
            return
        try:
            ecli.validate_parameters('ebtables', 'enable')
        except Exception as e:
            cl.perr(str(e))

        retObj = self.HTTP.put("{0}/exaunit/{1}/enableebt".format(host, line), None, "ebtables")
        cl.prt("c", str(retObj))

    def do_disable_ebtables(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("disable_ebtables takes one mandatory argument")
            return
        try:
            ecli.validate_parameters('ebtables', 'disable')
        except Exception as e:
            cl.perr(str(e))

        retObj = self.HTTP.put("{0}/exaunit/{1}/disableebt".format(host, line), None, "ebtables")
        cl.prt("c", str(retObj))

    def do_add_ebtrules(self, ecli, line, host):

        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, None)

        # Validate all the parameters and values
        try:
            ecli.validate_parameters('ebtables', 'add', params)
        except Exception as e:
            cl.perr(str(e))

        if type(params) is str:
            cl.perr(params)
            return

        if not params["ip"]:
            cl.perr("ip not specified. Please do add_ebtrules <exaunit_id> ip=<ip1,ip2,..>")
            return

        ipaddr = params["ip"]

        if ecli.interactive:
            cl.prt("c", "Adding IP rules on exaunit {0} for: {1}".format(exaunit_id, ipaddr))

        retObj = self.HTTP.put("{0}/exaunit/{1}/addebtrule/{2}".format(host, exaunit_id, ipaddr), None, "ebtables")
        cl.prt("c", str(retObj))

    def do_del_ebtrules(self, ecli, line, host):

        line = line.split(' ', 1)
        exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

        params = ecli.parse_params(rest, None)

        # Validate all the parameters and values
        try:
            ecli.validate_parameters('ebtables', 'add', params)
        except Exception as e:
            cl.perr(str(e))

        if type(params) is str:
            cl.perr(params)
            return

        if not params["ip"]:
            cl.perr("ip not specified. Please do del_ebtrules <exaunit_id> ip=<ip1,ip2,..>")
            return

        ipaddr = params["ip"]

        if ecli.interactive:
            cl.prt("c", "Deleting IP rules on exaunit {0} for: {1}".format(exaunit_id, ipaddr))

        retObj = self.HTTP.put("{0}/exaunit/{1}/delebtrule/{2}".format(host, exaunit_id, ipaddr), None, "ebtables")
        cl.prt("c", str(retObj))
