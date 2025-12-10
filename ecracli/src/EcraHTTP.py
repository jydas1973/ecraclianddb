"""
 Copyright (c) 2015, 2025, Oracle and/or its affiliates.

NAME:
    EcraHTTP - Defines the HTTP class

FUNCTION:
    Defines the HTTP class and provides methods such as get/post/put/delete etc

NOTE:
    None

History:
#    MODIFIED   (MM/DD/YY)
    llmartin    04/28/25   - Enh 37783329 - Accept headers on post method
    jreyesm     09/27/24   - Bug 37092339. added b64encode function.
    zpallare    09/10/24   - Enh 34972266 - EXACS Compatibility - create new
                             tables to support compatibility on operations
    jyotdas     07/16/24   - Enh 36799146 - CLI to sync ecra metadata for vm
                             state with actual state of the vm in infra
    zpallare    03/16/24   - Bug 36268401 - EXACS-EXACLOUD: ECRACLI hung at
                             connecting to endpoint and getting version info...
    nitishgu    02/21/24   - BUG 36318373: remove references of private key
                             ecra https support
    jzandate    02/16/24   - Enh 36192008 - Adding pagination headers to
                             response output
    cgarud      01/19/24   - "ingestion" needs content type 
    jzandate    03/08/23   - Enh 35048451 - adding api calls for oci compute client
    illamas     05/20/22   - Enh 34165620 - Adding support to purge singleton 
    rgmurali    01/26/21   - ER 32416102 - VMbackup support with OSS
    rgmurali    01/02/21   - ER 32133333 - Support Elastic shapes
    rgmurali    12/08/20   - ER 31416683 - Add the backfill API
    illamas     09/09/20   - Enh 31783059 - Analytics for all endpoints
    nisrikan.   08/25/20.  - Bug 31791748 - BACKPORT OPCTL FIXES TO MAIN
    rgmurali    08/23/20   - ER 31789990 - Cabinet level clis
    marcoslo    08/12/20   - Bug 31657170 - Add http headers for new exacloud resource
    marcoslo    08/08/20   - ER 30613740 Update code to use python 3
    sdeekshi    01/07/20   - Bug 31564449: CLEANUP NON USEFUL XIMAGES CODE
    rgmurali    06/23/20   - Bug 31522598 - Security issue for password in comment
    rgmurali    06/04/20   - ER 31334566 - Bonding info API
    nisrikan    04/23/20   - Bug 31169019 - Add CCA operations
    illamas     10/11/19   - Bug 29785842 - Added metadata operation
    jvaldovi    09/11/19   - Adding ECRA group of cli commands 
    jvaldovi    07/19/19   - Adding profiling operation
    bshenoy     07/26/19   - Bug 29875966: New endpoint for getting applied 
                             and available patches
    sachikuk    07/02/19   - Bug 29216924: Remove ecracli_key_passwd from ecracl.cfg
    jvaldovi    05/28/19   - fixing issue with exit code on method check_status_response
    sringran    05/27/19   - ER 29621627 Maintain the order of json content order while displaying
    jvaldovi    04/30/19   - Adding valitation for response data to set proper exitCode
    sringran    04/16/19   - ERs 29466791, 29466828, 29447581 exaccoci workflow management 
    sdeekshi    06/08/18   - Bug 28189332 : Add ecra ximages image management apis
    dekuckre    04/04/18   - 27703864: Add vmbackup command support
    sachikuk    11/22/2018 - Bug 28943104: Support mTLS authentication 
                             between ecracli and ECRA
    brsudars    11/14/2017 - Add exaservice to HEADERS
    aanverma    09/13/2017 - Bug #26819554: Add Jumbo Framework support
    byyang      08/19/2017 - bug 26624287: add scheduler
    srtata      07/11/2017 - bug 26309263: add cns
    rgmurali    04/20/2017 - Create file
"""
import urllib.request, urllib.error, urllib.parse
from formatter import cl
import json
import ssl
import sys
import base64
try:
    from base64 import encodestring
except Exception:
    from base64 import b64encode as encodestring

import os
from formatter import ExitCode
from collections import OrderedDict


#######################################################
#  HTTP CLASS HANDLER TO INTERFACE WITH ECRA          #
#######################################################

class HTTP:
    SDI_ROOT = "application/vnd.com.oracle.oracloud.provisioning.{0}+json"
    HEADERS = {
        "exaunits"         : {"Content-Type" : SDI_ROOT.format("Pod"), "Accept" : SDI_ROOT.format("Status")},
        "services"         : {"Content-Type" : SDI_ROOT.format("Service"), "Accept" : SDI_ROOT.format("Status")},
        "security"         : {"Content-Type": "application/json", "Accept": "application/json"},
        "exaservice"       : {"Content-Type": "application/json", "Accept": "application/json"},
         "exacloud"        : {"Content-Type": "application/json", "Accept": "application/json"},
        "databases"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "vms"              : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "zones"            : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "location"         : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "regionecra"       : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "racks"            : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "capacity"         : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "idemtokens"       : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "iorm"             : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "health_check"     : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "snapclone"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "ecsproperties"    : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "higgs"            : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "atp"              : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "kvmroce"          : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "backfill"         : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "syncvmstate"      : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "exadatainfrastructure" : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "bonding"          : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "refreshcredentials" : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "cabinet"          : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "cluster"          : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "dataguard"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "schedule"         : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "diagnosis"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "formation"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "inventory"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "ingestion"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "em"               : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "reset_dbplan"     : {"Content-Type" : "application/json"},
        "ebtables"         : {"Content-Type" : "application/json"},
        "cns"              : {"Content-Type" : "application/json"},
        "jumbo"            : {"Content-Type" : "application/json"},
        "vmbackup"         : {"Content-Type" : "application/json"},
        "vmbackuposs"      : {"Content-Type" : "application/json"},
        "userconfig"       : {"Content-Type" : "application/json"},
        "workflows"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "network"          : {"Content-Type" : "application/json"},
        "requests"         : {"Content-Type" : "application/json"},
        "ecmanagment"      : {"Content-Type" : "application/json"},
        "ocicpinfra"       : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "profiling"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "compliance"       : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "ecspatchversion"  : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "ecra"             : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "metadata"         : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "analytics"        : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "exadata"          : {"Content-Type": "application/json", "Accept": "application/json"},
        "opctl"              : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "hardware"         : {"Content-Type" : "application/json", "Accept" : "application/json"},
        "exaversion"       : {"Content-Type": "application/json", "Accept": "application/json"},
        "exacompute"       : {"Content-Type": "application/json", "Accept": "application/json"},
        "cache"            : {"Content-Type": "application/json", "Accept": "application/json"},
        "errorcode"        : {"Content-Type": "application/json", "Accept": "application/json"},
        "oci"        : {"Content-Type": "application/json", "Accept": "application/json"},
        "preprov" : {"Content-Type": "application/json", "Accept": "application/json"},
        "sop": {"Content-Type": "application/json", "Accept": "application/json"},
        "artifact"        : {"Content-Type": "application/json", "Accept": "application/json"},
        "compatibility"    : {"Content-Type": "application/json", "Accept": "application/json"},
        None               : {}
    }

    def create_ssl_context(self, api_params_dict):
        # If given api param has not been configured, reinitialize it to None
        for param in api_params_dict:
            if (api_params_dict[param] is not None and api_params_dict[param].strip() == ""):
                api_params_dict[param] = None

        # - Both ECRA and ecracli's certificates must be present.
        # - If 'ecracli_key_file' is None, then ecracli's private key 
        #   must be present in ecracli's cert file.
        # - If pswd is required to decrypt the ecracli's private key, then OpenSSL's built-in
        #   pswd prompting mechanism will be used to get the pswd.
        if (not api_params_dict["ecra_cert_file"]):
            cl.prt("r", "ECRA certificates must be configured.")
            sys.exit(1)
  
        # Once integration with KMS has been done and we stop storing certificates 
        # locally, below certificate path validation will have to be replaced with
        # KMS based validation.
        path_params = ["ecra_cert_file"]
        for param in api_params_dict:
            if (param not in path_params or not api_params_dict[param]):
                continue
            if (not os.path.isfile(api_params_dict[param])):
                cl.prt("r", "File path: %s given for ecracli param: %s does not exist." % 
                    (api_params_dict[param], param))
                sys.exit(1)
 
        context = None
        try:
            context = ssl.create_default_context(cafile=api_params_dict["ecra_cert_file"])

            # Disable SSLv2, SSLv3 and TLSv1 connections from peers
            context.options |= ssl.OP_NO_SSLv2
            context.options |= ssl.OP_NO_SSLv3
            context.options |= ssl.OP_NO_TLSv1

            # Request certificates from peers and verify them
            context.verify_mode = ssl.CERT_REQUIRED

            # To enforce peers' hostname verification, set context.check_hostname to 
            # True. Disabling it for now, since ECRA's certificate will be generated 
            # with Load Balancer's hostname, whereas ecracli will communicate directly 
            # with ECRA running on localhost
            context.check_hostname = False
        except ssl.SSLError as e:
            cl.prt("r", "Failure occurred while creating SSL context.")
            cl.prt("r", str(e))
            sys.exit(1)
        return context

    def create_https_handler(self, api_params_dict):
        # Initialize HTTPS handler with SSL context
        ssl_context = self.create_ssl_context(api_params_dict)
        https_handler = urllib.request.HTTPSHandler(context=ssl_context)
        return https_handler

    # Constructor
    # Sets the basic authentication
    def __init__(self, api_params_dict, ssl_params, verbose=False):
        self.host = api_params_dict["host"]
        self.verbose = verbose

        # Create Base64 encoded authorization header
        user_passwd_str = ('%s:%s' % (api_params_dict["username"], api_params_dict["password"]))
        encoded_auth = encodestring(user_passwd_str.encode()).decode().strip()
        self.auth_header = "Basic %s" % encoded_auth
        
        # Check if SSL is configured
        configured_ssl_params = list()
        for param in api_params_dict:
            param_configured = (api_params_dict[param] is not None and api_params_dict[param].strip() != "")
            if (param_configured and param in ssl_params):
                configured_ssl_params.append(param)

        # Set URL opener
        if (len(configured_ssl_params) != 0 and self.host.startswith("http://")):
            cl.prt("r", "SSL params: %s have been configured in ecracli.cfg, cannot use HTTP based endpoint: %s" %
                (str(configured_ssl_params), self.host))
            sys.exit(1)
        elif (len(configured_ssl_params) == 0 and self.host.startswith("https://")):
            cl.prt("r", "In order to use HTTPS based endpoint: %s, please configure SSL params: %s in ecracli.cfg" %
                (self.host, str(ssl_params)))
            sys.exit(1)
        elif (len(configured_ssl_params) == 0 and self.host.startswith("http://")):
            self.opener = urllib.request.build_opener()
        elif (len(configured_ssl_params) != 0 and self.host.startswith("https://")):
            https_handler = self.create_https_handler(api_params_dict)
            self.opener = urllib.request.build_opener(https_handler)
        else:
            cl.prt("r", "Unsupported combination for initializing HTTP client, configured_ssl_params: %s, host: %s" %
                (str(configured_ssl_params), self.host))
            sys.exit(1)

    #function that check response_data and sets exit code 
    def check_status_response(self, response_data):
        global ExitCode
        #validate response to set proper exit code
        if not response_data:
            ExitCode[0] = 1
        elif not "status" in response_data:
            ExitCode[0] = 0
        elif type(response_data["status"]) == int and int(response_data["status"]) >= 400:
            ExitCode[0] = 1
    
    def post(self, data, resource, uri=None, header=None):
        if header is None:
            header = HTTP.HEADERS[resource]
        if not uri:
            uri = "{0}/{1}".format(self.host, resource)
        if self.verbose:
            cl.prt("c", "POST {0}".format(uri))
        try:
            header["Authorization"] = self.auth_header
            header["content-type"] = 'application/json'
            binary_data = None
            if data:
                binary_data = data.encode("utf-8") 

            req = urllib.request.Request(uri, binary_data, header, method='POST')
            response = self.opener.open(req)
            del header["content-type"]
            response_data = json.loads(response.read())
            self.check_status_response(response_data)
            return response_data

        except urllib.error.HTTPError as e :
            if self.verbose != "":
                cl.perr("POST request to {0} failed".format(uri))
                cl.prt("r", "{0}".format(str(e)))
                if hasattr(e, "read"):
                    cl.prt("r", "{0}".format(e.read()))

        return None

    def get(self, uri, ignoreError=False, printPaginationHeaders=False):
        try:
            header = {}
            header["Authorization"] = self.auth_header
            req = urllib.request.Request(uri, None, header)
            response = self.opener.open(req)
            if printPaginationHeaders:
                pagination_headers = { k:v for (k,v) in dict(response.headers).items() if "Pagination" in k }
                if len(pagination_headers.items()) > 0 and pagination_headers["X-Pagination-Page"] != "0":
                    self.print_pagination_headers(pagination_headers)
            response_data = json.loads(response.read())
            self.check_status_response(response_data)
            return response_data

        except urllib.error.HTTPError as e:
            if not ignoreError:
                cl.perr("GET request to {0} failed".format(uri))
                cl.prt("r", "{0}".format(str(e)))
                if hasattr(e, "read"):
                    cl.prt("r", "{0}".format(e.read()))
            else:
                return json.loads(e.read())

        return None

    def print_pagination_headers(self, pagination_headers):
        result_out = "[{0}]".format(", ".join(["{0}={1}".format(k, v) for (k, v) in pagination_headers.items()]))
        cl.prt("p", result_out)

    def query(self, url, data):
        url_values = urllib.parse.urlencode(data)
        full_url = url +  '?' + url_values if url_values else url
        return self.get(full_url)

    def get_version(self,verbose=False,ecraonly=False):
        uri = "{0}/version".format(self.host)
        params = ""
        if verbose:
            params+="verbose=yes&"
        if ecraonly:
            params+="ecraonly=yes&"
        if len(params)>0:
            uri += "?"
            uri += params
            uri = uri[:-1]
        return self.get(uri)

    def put(self, uri, data, resource, idemtoken=None):
        if self.verbose:
            cl.prt("c", "PUT {0}".format(uri))
        try:
            header = HTTP.HEADERS[resource] 
            header["Authorization"] = self.auth_header
            if (idemtoken is not None):
               header["idemtoken"] = idemtoken
               
            header["content-type"] = 'application/json'
            binary_data = None
            if data:
                binary_data = data.encode("utf-8")
            req = urllib.request.Request(uri, binary_data, header)
            req.get_method = lambda: 'PUT'
            response = self.opener.open(req)
            del header["content-type"]
            response_data = json.loads(response.read())
            self.check_status_response(response_data)
            return response_data
        except urllib.error.HTTPError as e:
            cl.perr("PUT request to {0} failed".format(uri))
            cl.prt("r", "{0}".format(str(e)))
            if hasattr(e, "read"):
                cl.prt("r", "{0}".format(e.read()))

        return None

    def delete(self, uri, data=None, header=None):
        if self.verbose:
            cl.prt("c", "DELETE {0}".format(uri))
        try:
            if header is None:
               header = {}
            header["Authorization"] = self.auth_header
            binary_data = None
            if data:
                binary_data = data.encode("utf-8")            
            req = urllib.request.Request(uri, binary_data, header)
            req.get_method = lambda: 'DELETE'
            response = self.opener.open(req)
            response_data = json.loads(response.read())
            self.check_status_response(response_data)
            return response_data
        except urllib.error.HTTPError as e:
            cl.perr("Delete request to {0} failed".format(uri))
            cl.prt("r", "{0}".format(str(e)))
            if hasattr(e, "read"):
                cl.prt("r", "{0}".format(e.read()))

        return None
        
    def issue_http_request(self, http_method, url, data=None):
        cl.prt('c','{0} {1}'.format(http_method, url))
        if http_method == 'DELETE':
            res = self.delete(url)
        elif http_method == 'POST':
            res = self.post(data, 'requests', url)
        elif http_method == 'PUT':
            res = self.put(url, data, 'requests')
        else:
            res = self.get(url)

        if not res:
            cl.perr('Failed to get ' + url)
            return
        cl.prt('n',json.dumps(res, sort_keys=True, indent=4, separators=(',', ': ')))

    def patch(self, data, resource, uri=None):
        header = HTTP.HEADERS[resource]
        if not uri:
            uri = "{0}/{1}".format(self.host, resource)
        if self.verbose:
            cl.prt("c", "PATCH {0}".format(uri))
        try:
            header["Authorization"] = self.auth_header
            req = urllib.request.Request(uri, data, header)
            req.get_method = lambda: 'PATCH'
            response = self.opener.open(req)
            response_data = json.loads(response.read())
            self.check_status_response(response_data)
            return response_data

        except urllib.error.HTTPError as e :
            if self.verbose != "":
                cl.perr("PATCH request to {0} failed".format(uri))
                cl.prt("r", "{0}".format(str(e)))
                if hasattr(e, "read"):
                    cl.prt("r", "{0}".format(e.read()))

    #This is similar to get_json but maintains the json content order from rest call result
    def get_json_with_same_key_order(self, uri, ignoreError=False):
        try:    
            header = {}
            header["Authorization"] = self.auth_header
            req = urllib.request.Request(uri, None, header) 
            response = self.opener.open(req)
            response_data = json.loads(response.read(),object_pairs_hook=OrderedDict)
            self.check_status_response(response_data)
            return response_data

        except urllib.error.HTTPError as e:
            if not ignoreError:
                cl.perr("GET request to {0} failed".format(uri))
                cl.prt("r", "{0}".format(str(e)))
                if hasattr(e, "read"):
                    cl.prt("r", "{0}".format(e.read()))
            else:   
                return json.loads(e.read())

        return None
