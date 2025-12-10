"""
 Copyright (c) 2015, 2017, Oracle and/or its affiliates. All rights reserved.

NAME:
    Jumbo - CLIs for sub-operations under Jumbo Framework

FUNCTION:
    Provides the clis to enable/disable/query Jumbo Framework values.

NOTE:
    None

History:
    MODIFIED   (MM/DD/YY)
    aanverma    08/31/17 - Bug #26819554: Add Jumbo Framework clis 
    aanverma    08/31/17 - Create file
"""
from formatter import cl

class Jumbo:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_enable_jumbo(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)

        if len(line.split()) != 1:
            cl.perr("enable_jumbo takes exaunit id as mandatory argument")
            return
        try:
            ecli.validate_parameters('jumbo', 'enable')
        except Exception as e:
            cl.perr(str(e))

        retObj = self.HTTP.put("{0}/exaunit/{1}/enablejmb".format(host, exaunit_id),
                               None, "jumbo")
        cl.prt("c", str(retObj))

    def do_disable_jumbo(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)

        if len(line.split()) != 1:
            cl.perr("disable_jumbo takes exaunit id as mandatory argument")
            return
        try:
            ecli.validate_parameters('jumbo', 'disable')
        except Exception as e:
            cl.perr(str(e))

        retObj = self.HTTP.put("{0}/exaunit/{1}/disablejmb".format(host, exaunit_id),
                               None, "jumbo")
        cl.prt("c", str(retObj))

    def do_query_jumbo(self, ecli, line, host):
        exaunit_id = ecli.exaunit_id_from(line)

        if len(line.split()) != 1:
            cl.perr("query_jumbo takes exaunit id as mandatory argument")
            return
        try:
            ecli.validate_parameters('jumbo', 'query')
        except Exception as e:
            cl.perr(str(e))

        retObj = self.HTTP.get("{0}/exaunit/{1}/queryjmb".format(host, exaunit_id))

        cl.prt("c", str(retObj))

# __eof__
