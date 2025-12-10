"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    SysCURL - CLIs to operate on Higgs control plane

FUNCTION:
    Provides methods to execute the linux curl command. 

NOTE:
    None

History:
    llmartin    04/04/18 - Create file
"""

import errno
import json
import inspect
import subprocess
import tempfile
import traceback
from formatter import cl
from subprocess import call

CONTTYPE_HEADER = "Content-Type: application/oracle-compute-v3+json"

def system_curl(request, HTTPmethod, headers, data = None, cookie = None, cookie_jar=None):
    # Build commmand
    command = "curl -k --retry 3 --retry-delay 1 "

    if cookie is not None:
        command += "-b " + cookie

    if cookie_jar is not None:
        command += "-c " + cookie_jar

    if headers is not None:
        for header in headers:
            command += " -H \"" + header + "\""

    command += " -X " + HTTPmethod + " " + request

    if data is not None:
        command += " -d '" + data +"'"

    output = system_cmd([command])
    return output

def auth(params):
    # Get temporal directory to store the cookie
    tmpDir = tempfile.mkdtemp(suffix="ecracli")
    tmpFile = tmpDir+"/higgs_cookie.txt"

    cmd_url = params["higgs_url"]+"authenticate/"
    cmd_headers=[CONTTYPE_HEADER]

    payload = {}
    payload["user"] = "/Compute-{0}/{1}".format(params["subscriptionId"], params["appidUser"])
    payload["password"] = params["appidPwd"]
    strPayload = json.dumps(payload)

    response = system_curl(cmd_url,"POST", cmd_headers, strPayload, cookie_jar=tmpFile)

    if response is not None:
        jsonResponse =json.loads(response)
        raise Exception("Authentication Failed: " + jsonResponse["message"])

    return tmpFile

def system_cmd(cmd_list):
    """ Return the complete output of a system command """
    out = None
    try:
        cmd = cmd_list[0]
        proc = subprocess.Popen(cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE, close_fds=True)
        output = proc.stdout.read()
        error = proc.stderr.read()
        rc = proc.wait()
        if rc:
            cl.perr("Failed to run the cmd: {0}".format(cmd))
            if error:
                out = error
        else:
            cl.prt("n", "Successfully run the command: {0}".format(cmd))
            if output:
                out = output
        return out
    except OSError as e:
        if e.errno == errno.ENOENT:
            cl.perr("Command does not exist: {0}".format(cmd))
        else:
            cl.perr("Failed to run the command: {0}".format(cmd))
            cl.perr("Error code is: {0}}".format(e.errno))
            cl.perr(traceback.format_exc())
        return out
