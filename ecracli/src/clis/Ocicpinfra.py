"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Ocicpinfra - CLIs for handling CPS (control plane server : OCI-ExaCC)
                 infra related actions on the control plane side

FUNCTION:
    Provides the clis to manage CPS infra 

NOTE:
    None

History:
    hcheon    09/28/2020 - Bug 31942864 - Fixed pylint errors.
    rgmurali  08/15/2020 - Bug 31536477 - Fix fortify issues
    pverma    06/12/2019 - Create file
"""
from formatter import cl
import json
import os

class Ocicpinfra:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def print_success_response(self, response):
        if response is not None and response['status'] == 200:
            cl.prt("n", "Response data")
            for key, value in response.items():
                cl.prt("p", "{0} : {1}".format(key, value))
    
    def do_save_vpn_server_details_ocicpinfra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "savevpnserverdetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonconf"]
        if not os.path.isfile(input_json_path):
            cl.perr("OCI VPN server details JSON: " + input_json_path + " does not exist.")
            return 

        # Read input JSON
        with open(input_json_path, 'r') as input_json_file:
            payload = json.load(input_json_file)
            input_json_file.close()
            
        data = json.dumps(payload)

        # Register capacity with ECRA
        url = "{0}/ocicpinfra/vpnserver".format(host)
        cl.prt("c", "POST " + url)
        if ecli.interactive:
            cl.prt("c", "Inserting VPN server record for new AD with details: " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.post(data, "ocicpinfra", url)
   
        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_get_vpn_server_details_ocicpinfra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "getvpnserverdetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to VPN server details
        if ecli.interactive:
            cl.prt("c", "Get OCI VPN server details with parameter(s):")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))
                
        url = "{0}/ocicpinfra/vpnserver/{1}".format(host, params["ad"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        # Print response obtained from ECRA
        self.print_success_response(response)
        
    def do_update_vpn_server_details_ocicpinfra(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "updatevpnserverdetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonconf"]
        if not os.path.isfile(input_json_path):
            cl.perr("OCI Capacity Register input JSON: " + input_json_path + " does not exist.")
            return 

        # Read input JSON
        with open(input_json_path, 'r') as input_json_file:
            payload = json.load(input_json_file)
            input_json_file.close()
        
        payload["idemtoken"] = params["idemtoken"]
        data = json.dumps(payload)
            
        # Call ECRA to update OCI Exadata Details
        ad = params["ad"]
        url = "{0}/ocicpinfra/vpnserver/{1}".format(host, ad)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c", "Update VPN server record AD : " + ad + " details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "ocicpinfra")
        # Print response obtained from ECRA
        self.print_success_response(response)
        
    def do_rotate_cipher_passwd(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "rotatecipherpasswd", params)
        except Exception as e:
            cl.perr(str(e))
            return

        payload = {}
        data = json.dumps(payload)
        # Rotate the Cipher psswd for the ECRA instance
        url = "{0}/ocicpinfra/rotate-cipher-passwd".format(host)
        cl.prt("c", "POST " + url)
        response = self.HTTP.post(data, "ocicpinfra", url)

        # Print response obtained from ECRA
        self.print_success_response(response)

    def do_get_ecra_cipher_passwd(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "getecracipherpasswd", params)
        except Exception as e:
            cl.perr(str(e))
            return

        save_location = params["saveloc"]
        while save_location.endswith('/'):
            save_location = save_location[:-1]
        
        # Save location file must NOT exist
        if os.path.isfile(save_location):
            cl.perr("File already exists: " + save_location)
            return
        
        # Call ECRA to get current Cipher psswd active in the ECRA instance
        url = "{0}/ocicpinfra/ecra-cipher-passwd".format(host)
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        open(save_location, 'wb').write(json.dumps(response, sort_keys=True, indent=4))
        cl.prt("c", "Saved requested file")
        
    def do_get_ecra_all_cipher_passwds(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "geteallcipherpasswds", params)
        except Exception as e:
            cl.perr(str(e))
            return

        save_location = params["saveloc"]
        while save_location.endswith('/'):
            save_location = save_location[:-1]
        
        # Save location file must NOT exist
        if os.path.isfile(save_location):
            cl.perr("File already exists: " + save_location)
            return
        
        # Call ECRA to get all Cipher psswds for the ECRA instance
        url = "{0}/ocicpinfra/ecra-all-cipher-passwds".format(host)
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        open(save_location, 'wb').write(json.dumps(response, sort_keys=True, indent=4))
        cl.prt("c", "Saved requested file")

    def do_add_new_vpn_he_record(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "registervpnhe", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonconf"]
        if not os.path.isfile(input_json_path):
            cl.perr("OCI VPN HE details JSON: " + input_json_path + " does not exist.")
            return 

        # Read input JSON
        with open(input_json_path, 'r') as input_json_file:
            payload = json.load(input_json_file)
            input_json_file.close()
            
        data = json.dumps(payload)

        # Register capacity with ECRA
        url = "{0}/ocicpinfra/vpn-he".format(host)
        cl.prt("c", "POST " + url)
        if ecli.interactive:
            cl.prt("c", "Inserting VPN HE record with details: " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.post(data, "ocicpinfra", url)
   
        # Print response obtained from ECRA
        self.print_success_response(response)
    
    def do_update_vpn_he_record(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "updatevpnhe", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Input JSON file must exist
        input_json_path = params["jsonconf"]
        if not os.path.isfile(input_json_path):
            cl.perr("OCI update VPN HE details JSON: " + input_json_path + " does not exist.")
            return 

        # Read input JSON
        with open(input_json_path, 'r') as input_json_file:
            payload = json.load(input_json_file)
            input_json_file.close()
        
        data = json.dumps(payload)
            
        # Call ECRA to update OCI Exadata Details
        ip = params["ip"]
        url = "{0}/ocicpinfra/vpn-he/{1}".format(host, ip)
        cl.prt("c", "PUT " + url)
        if ecli.interactive:
            cl.prt("c", "Update VPN HE record with IP Address : " + ip + " details : " + json.dumps(payload, indent=4, sort_keys=True))
        response = self.HTTP.put(url, data, "ocicpinfra")
        # Print response obtained from ECRA
        self.print_success_response(response)
    
    def do_get_vpn_he_details(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "getvpnhedetails", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to VPN server details
        if ecli.interactive:
            cl.prt("c", "Get OCI VPN HE details with parameter(s):")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))
                
        url = "{0}/ocicpinfra/vpn-he/{1}".format(host, params["ip"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        # Print response obtained from ECRA
        self.print_success_response(response)
    
    def do_get_vpn_he_list(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters("ocicpinfra", "getvpnhelist", params)
        except Exception as e:
            cl.perr(str(e))
            return

        # Call ECRA to VPN server details
        if ecli.interactive:
            cl.prt("c", "Get OCI VPN HE details with parameter(s):")
            for key, value in params.items():
                cl.prt("c", "{0} : {1}".format(key, value))
                
        url = "{0}/ocicpinfra/{1}/vpn-he-list".format(host, params["ad"])
        cl.prt("c", "GET " + url)
        response = ecli.issue_get_request(url, False)
        # Print response obtained from ECRA
        self.print_success_response(response)
        
