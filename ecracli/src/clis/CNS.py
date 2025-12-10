"""
 Copyright (c) 2015, 2018, Oracle and/or its affiliates. All rights reserved.

NAME:
    CNS - CLIs for sub-operations under cns( cloud notification service)

FUNCTION:
    Provides the clis for "cns run: and "cns post"

NOTE:
    None

History:
    srtata      02/12/2017 - bug 27550083: receive events
    srtata      10/30/2017 - enable/disable cns at rack level
    srtata      08/21/2017 - add cnssetup
    srtata      07/14/2017 - Create file
"""
from formatter import cl
import json
 
class CNS:

    def __init__(self, HTTP, host):
        self.HTTP = HTTP
        self.host = host

    def do_runcns(self, line):
        if len(line.split()) != 0:
            cl.perr("cns run does not take arguments")
            return

        runcns_url = "{0}/cns/runcns".format(self.host)
        cl.prt("c","POST {0}".format(runcns_url))
        retObj = self.HTTP.post("", "cns", runcns_url)
        cl.prt("c",json.dumps(retObj))

    def do_setupcns(self, line):
        if len(line.split()) != 1:
            cl.perr("cns setup takes mandatory exaunit ID")
            return
        exaunitId = line;
        cl.prt("c",exaunitId)
        setupcns_url = "{0}/cns/setupcns/exaunit/{1}".format(self.host, exaunitId)
        cl.prt("c","POST {0}".format(setupcns_url))
        retObj = self.HTTP.post("", "cns", setupcns_url)
        cl.prt("c",json.dumps(retObj))

    def do_disablerackcns(self, line):
        if len(line.split()) != 1:
            cl.perr("cns disablerack takes mandatory exaunit ID")
            return
        exaunitId = line;
        disablerackcns_url = "{0}/cns/disablecns/exaunit/{1}".format(self.host, exaunitId)
        cl.prt("c","PUT {0}".format(disablerackcns_url))
        retObj = self.HTTP.put(disablerackcns_url, "", "cns")
        cl.prt("c",json.dumps(retObj))

    def do_enablerackcns(self, line):
        if len(line.split()) != 1:
            cl.perr("cns enablerack takes mandatory exaunit ID")
            return
        exaunitId = line;
        enablerackcns_url = "{0}/cns/enablecns/exaunit/{1}".format(self.host, exaunitId)
        cl.prt("c","PUT {0}".format(enablerackcns_url))
        retObj = self.HTTP.put(enablerackcns_url,"", "cns")
        cl.prt("c",json.dumps(retObj))

    def do_getrackstatuscns(self, line):
        if len(line.split()) != 1:
            cl.perr("cns getrackstatus takes mandatory exaunit ID")
            return
        exaunitId = line;
        getrackstatuscns_url = "{0}/cns/statuscns/exaunit/{1}".format(self.host, exaunitId)
        cl.prt("c","GET {0}".format(getrackstatuscns_url))
        retObj = self.HTTP.get(getrackstatuscns_url)
        cl.prt("c",json.dumps(retObj))

    def do_setupcnsinterval(self, line):
        if len(line.split()) != 1:
            cl.perr("cns setup interval takes mandatory interval in seconds ")
            return
        interval = line;
        cl.prt("c",interval)
        query_str = "?"
        query_str = query_str +"interval="+interval+"&"
        query_str = query_str[:-1]
        setupcnsinterval_url = "{0}/cns/setupcnsinterval{1}".format(self.host,query_str)
        cl.prt("c","POST {0}".format(setupcnsinterval_url))
        retObj = self.HTTP.post(interval, "cns", setupcnsinterval_url)
        cl.prt("c",json.dumps(retObj))

    def do_enablecns(self, line):
        if len(line.split()) != 0:
            cl.perr("cns enable does not take arguments")
            return

        enablecns_url = "{0}/cns/enablecns".format(self.host)
        cl.prt("c","POST {0}".format(enablecns_url))
        retObj = self.HTTP.post("", "cns", enablecns_url)
        cl.prt("c",json.dumps(retObj))

    def do_disablecns(self, line):
        if len(line.split()) != 0:
            cl.perr("cns run does not take arguments")
            return

        disablecns_url = "{0}/cns/disablecns".format(self.host)
        cl.prt("c","POST {0}".format(disablecns_url))
        retObj = self.HTTP.post("", "cns", disablecns_url)
        cl.prt("c",json.dumps(retObj))


    def do_postcns(self, ecli, line):
        if len(line.split()) != 1:
            cl.perr("cns post takes mandatory event file name")
            return
        eventFile = line;

        postcns_url = "{0}/cns/postcns".format(self.host)
        cl.prt("c","POST {0}".format(postcns_url))
        cnspayloadfile = eventFile
        with open (cnspayloadfile, "r") as myfile:
            data=myfile.read().replace('\n', '')
        retObj = self.HTTP.post(data, "cns", postcns_url)
        cl.prt("c",json.dumps(retObj))

    def do_receivecns(self, line):
        if len(line.split()) != 1:
            cl.perr("cns receive takes mandatory event file name")
            return
        params  = line.split(' ')
        eventFile = params[0]

        receivecns_url = "{0}/events/receive".format(self.host)
        cl.prt("c","POST {0}".format(receivecns_url))
        with open (eventFile, "r") as myfile:
            data=myfile.read().replace('\n', '')
        retObj = self.HTTP.post(data, "cns", receivecns_url)
        cl.prt("c",json.dumps(retObj))


