"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    ExaCC - CLIs for OCI ExaCC: Network resources

FUNCTION:
    Provides the clis to manage the OCI EXA.

NOTE:
    None

History:
    rgmurali    08/15/2020 - Bug 31536477 - Fix fortify issues
    llmartin    04/12/19  Create file.

"""

from formatter import cl
import json
import base64

class ExaCC:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_createNetwork(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "createNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = json.load(open(params["json_path"]))
        payload["idemtoken"] = params["idemtoken"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        retObj = self.HTTP.post(data, "network","{0}/capacity/network".format(host))
        cl.prt("c", json.dumps(retObj) )

    def do_listNetworks(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "listNetworks", params)
        except Exception as e:
            cl.perr(str(e))
            return

        queryUri = "{0}/capacity/network?exa_ocid={1}".format(host,params["exa_ocid"])
        
        if "status" in params:
            queryUri= queryUri + "&status={0}".format(params["status"])

        retObj = self.HTTP.get(queryUri)
        printData = json.dumps(retObj, indent=4)
        cl.prt("c", str(printData))



    def do_updateNetwork(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "updateNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = json.load(open(params["json_path"]))
        payload["idemtoken"] = params["idemtoken"]
        network_ocid = payload["network"]["network_ocid"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        retObj = self.HTTP.put("{0}/capacity/network/{1}".format(host,network_ocid),data, "network")
        cl.prt("c", json.dumps(retObj) )


    def do_getNetwork(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "getNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        retObj = self.HTTP.get("{0}/capacity/network/{1}".format(host,params["network_ocid"]))
        printData = json.dumps(retObj, indent=4)
        cl.prt("c", str(printData))

    def do_deleteNetwork(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "deleteNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        retObj = self.HTTP.delete("{0}/capacity/network/{1}".format(host,params["network_ocid"]),None)
        printData = json.dumps(retObj, indent=4)
        cl.prt("c", str(printData))

    def do_validateNetwork(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "validateNetwork", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["idemtoken"] = params["idemtoken"]

        data = json.dumps(payload, sort_keys=True, indent=4)
        retObj = self.HTTP.put("{0}/capacity/network/{1}/validate".format(host,params["network_ocid"]),data, "network")
        cl.prt("c", json.dumps(retObj) )

    def do_getNwValidationReport(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "networkValidationReport", params)
        except Exception as e:
            cl.perr(str(e))
            return
        
        retObj = self.HTTP.get("{0}/capacity/networkValidationReport/{1}".format(host,params["network_ocid"]))
        printData = json.dumps(retObj, indent=4)
        cl.prt("c", str(printData))


    def do_activate(self, ecli, line, host):
        params = ecli.parse_params(line, None, warning=False)
        try:
            ecli.validate_parameters("exacc", "activate", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        file = params["activation_file"] 
        with open(file, "rb") as f:
           bytes = f.read()
           encoded = base64.b64encode(bytes)
           payload  = {'activationFile':encoded.decode('utf-8')}

        data = json.dumps(payload, sort_keys=True, indent=4)
        retObj = self.HTTP.put("{0}/capacity/exadata/{1}/activate".format(host,params["exacc_ocid"]),data, "network", params["idemtoken"])
        cl.prt("c", json.dumps(retObj) )

    def do_certificate_rotation(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("exacc", "certificateRotation", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["rotationType"] = params["rotationType"]
        rotationTypes =['CLIENT','CPSPROXY','EXACLOUD', 'REMOTEMANAGER','DBCS']
        if payload["rotationType"] in rotationTypes:
           payload["exaOcid"] = params["exaOcid"]
        data = json.dumps(payload, sort_keys=True, indent=4)
        # Rotate the Cipher psswd for the ECRA instance
        url = "{0}/certificate/rotation".format(host)
        cl.prt("c", "POST " + url)
        response = self.HTTP.post(data, "network", url)

        # Print response obtained from ECRA
        cl.prt("c", json.dumps(response) )

    def do_secretservice_compartment(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("exacc", "secretServiceCompartment", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        data = json.dumps(payload, sort_keys=True, indent=4)
        # Get compartment id and vault id used for the secret service
        url = "{0}/dbcs/secretservice/compartment/details".format(host)
        retObj = self.HTTP.get(url)
        printData = json.dumps(retObj, indent=4)
        cl.prt("c", str(printData))


    def do_secretservice_rotation(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("exacc", "secretServiceRotation", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        payload["rotationType"] = params["rotationType"]
        if payload["rotationType"] == "DBCS":
           payload["exaOcid"] = params["exaOcid"]
           if "userName" in params:
               payload["userName"] = params["userName"]
               if "password" in params:
                   payload["password"] = params["password"]
        if "force" in params:
           payload["force"] = params["force"]
        if "rackName" in params:
           payload["rackName"] = params["rackName"]
        if "listDomUs" in params:
           payload["listDomUs"] = [x.strip() for x in params["listDomUs"].split(",") if x.strip()]

        data = json.dumps(payload, sort_keys=True, indent=4)
        # Rotate the Cipher psswd for the ECRA instance
        url = "{0}/secretservice/rotate/password".format(host)
        cl.prt("c", "PUT " + url)
        response = self.HTTP.put(url, data, "network")

        # Print response obtained from ECRA
        cl.prt("c", json.dumps(response) )


    def do_wssIngestion(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("exacc", "wssIngestion", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = json.load(open(params["jsonconf"]))

        data = json.dumps(payload, sort_keys=True, indent=4)
        retObj = self.HTTP.post(data, "network","{0}/ocicpinfra/wsserver".format(host))
        cl.prt("c", json.dumps(retObj) )

