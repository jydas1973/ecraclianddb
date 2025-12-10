"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    RackSlot - CLIs for rack slots management

FUNCTION:
    Provides the clis for rack slot management

NOTE:
    None

History:
    sachikuk    11/08/2017 - Bug - 27086265 : Enhance rack slot registration
    sachikuk    11/08/2017 - Creation
"""
from formatter import cl
import json
import os

class RackSlot:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def print_success_response(self, response):
        if response is not None and response['status'] == 200:
            cl.prt("n", "Response data")
            for key, value in response.items():
                cl.prt("p", "{0} : {1}".format(key, value))

    def do_list_rackslot(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("rackslot", "list", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get rack slot lists
        exadata_id = params["exadata_id"]
        if ecli.interactive:
           cl.prt("c", "Getting rack slots list for exadata: " + exadata_id)

        url = "{0}/capacity/rackslot?exadataid={1}".format(host, exadata_id)
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)

        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_get_rackslot(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("rackslot", "get", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to get rack slot details
        rackname = params["rackname"]
        if ecli.interactive:
           cl.prt("c", "Getting rack slot details for rack: " + rackname)

        url = "{0}/capacity/rackslot?rackname={1}".format(host, rackname)
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)

        # Print response obtained from ECRA
        self.print_success_response(response)
       
    def read_from_file(self, file_path):
        data = None
        # File must exist
        if not os.path.isfile(file_path):
           cl.perr("File path: %s does not exist." % file_path)
           return

        # Read file
        with open(file_path, 'r') as file:
             data = file.read()
             file.close()

        return data    

    def do_register_rackslot(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("rackslot", "register", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = dict(params)

        # Add rack slot details to the payload
        details_present = False
        if "networkinfo" in payload:
            file_path = payload["networkinfo"]
            data = self.read_from_file(file_path)
            if data is None:
               cl.perr("Error while loading network info.")
               return
            payload["networkinfo"] = data
            details_present = True
        if "xml" in payload:
            file_path = payload["xml"]
            data = self.read_from_file(file_path)
            if data is None:
               cl.perr("Error while loading xml.")
               return
            payload["xml"] = data
            details_present = True

        if not details_present:
           cl.perr("Rack slot details missing. Please provide networkinfo and/or xml.")
           return

        # Register rack slot with ECRA
        exadata_id = payload["exadata_id"]
        if ecli.interactive:
           cl.prt("c", "Registering rack slot with exadata id: " + exadata_id)
       
        url = "{0}/capacity/rackslot/register".format(host)
        response = self.HTTP.post(json.dumps(payload), "capacity", url)

        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_deregister_rackslot(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("rackslot", "deregister", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Deregister rack slot with ECRA
        rackname = params["rackname"]
        if ecli.interactive:
           cl.prt("c", "Deregistering rack slot associated with rack name: {0}".format(rackname))
   
        url = "{0}/capacity/rackslot/{1}/deregister".format(host, rackname)
        response = self.HTTP.delete(url)

        # Print response obtained from ECRA
        self.print_success_response(response) 
