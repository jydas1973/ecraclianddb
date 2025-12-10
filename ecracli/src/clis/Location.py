"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Location - CLIs for adding, deleting and querying info about a Location

FUNCTION:
    Provides the clis to add/delete locations etc

NOTE:
    None

History:
    MODIFIED   (MM/DD/YY)
    aanverma    10/09/18 - Bug #28662168: Add method for location details
                           command
    piyushsi    09/06/18 - Create file
"""

from formatter import cl
import json
from os import path

class Location:
    def __init__(self, HTTP):
        self.HTTP = HTTP
        self.loc_req_params = {"zone" : ["DC"], "site":["subscription_id"], "ad": ["compute_zone"]}
         
    def do_add_location(self, ecli, line, host, mytmpldir):
        region = None
        dc = None
        zone = None
        uri = None
        ecra_location = None
        username = None
        passwd = None
        location_type = None
        compute_zone = None
        ad = None
        site = None
        subscription_id = None
        location_name = None

        line = line.split(' ', 1)
        location_name, rest = line[0], line[1] if len(line) > 1 else None
        if not location_name:
            cl.perr("Mandatory param Location Name not specified")
            return

        params = ecli.parse_params(rest, None)
        try:
            ecli.validate_parameters('location', 'add', params)
        except Exception as e:
            cl.perr(str(e))

        if 'type' in params:
            location_type = params['type'] = params['type'].lower()
        if location_type not in list(self.loc_req_params.keys()):
            cl.perr("Location type should be in :" + str(list(self.loc_req_params.keys())))
            return

        req_param = self.loc_req_params[location_type][0].lower()
        if req_param not in params:
            cl.perr(req_param + " is missing parameter for location type "+ location_type)
            return
        elif not params[req_param]:
            cl.perr(req_param + " value is missing parameter for location type "+ location_type)
            return
        
        if 'region' in params:
            region = params['region'] = params['region'].lower()
        if 'dc' in params:
            dc = params['dc'] = params['dc'].lower()
        if 'compute_zone' in params:
            dc = params['compute_zone'] = params['compute_zone'].lower()
        if 'subscription_id' in params:
            subscription_id = params['subscription_id'] = params['subscription_id'].lower()
        if 'uri' in params:
            uri = params['uri']
        if not uri:
            cl.perr("Missing parameter: uri.")
            return

        if 'username' in params:
            username = params['username']
        if not username:
            cl.perr("Missing parameter: username.")
            return

        if 'passwd' in params:
            passwd = params['passwd']
        if not passwd:
            cl.perr("Missing parameter: passwd.")
            return

        params[location_type] = location_name.lower()
        if location_type == "zone":
            inputJson = path.join(mytmpldir, "addzonelocation.json")
        if location_type == "site":
            inputJson = path.join(mytmpldir, "addsite.json")
        if location_type == "ad":
            inputJson = path.join(mytmpldir, "addad.json")

        objJson = None
        with open(inputJson) as json_file:
            objJson = json.load(json_file)

        for option in params:
            if option in objJson:
                objJson[option] = params[option]
            else:
                cl.perr("{0} is not a valid option".format(option))
                return

        data = json.dumps(objJson)
        response = self.HTTP.post(data, "location", "{0}/location/add".format(host))
        cl.prt("n", json.dumps(response))

    def do_list_locations(self, ecli, line, host):
        region = None
        dc = None
        compute_zone = None
        subscription_id = None
        racksize = None
        location_type = None
        # Set to true if this is not a simple list request but a query for capacity
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('location', 'list', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if 'type' in params:
            location_type = params['type'] = params['type'].lower()
        if location_type not in list(self.loc_req_params.keys()):
            cl.perr("Location type should be in :" + str(list(self.loc_req_params.keys())))
            return
        
        if location_type == "site":
            req_param = self.loc_req_params[location_type][0].lower()
            if req_param not in params:
                cl.perr(req_param + " is missing parameter for location type "+ location_type)
                return
            elif not params[req_param]:
                cl.perr(req_param + "value is missing parameter for location type "+ location_type)
                return
  
        if 'region' in params:
            region = params['region'] 
        if 'dc' in params:
            dc = params['dc']
        if 'compute_zone' in params:
            compute_zone = params['compute_zone']
        if 'subscription_id' in params:
            subscription_id = params['subscription_id']
        if 'type' in params:
            location_type = params['type']

        # Execute plain list
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        print("{0}/location{1}".format(host, query))
        response = ecli.issue_get_request("{0}/location{1}".format(host, query), printResponse=False)

        if response["status"] != 200:
            cl.perr("Error: Invalid status response {0} from ECRA for list zones request".format(response["status"]))
            return

        if isinstance(response["locations"], list):
          cl.prt("n", json.dumps(response["locations"], sort_keys=True, indent=4))
        else:
          cl.prt("n", json.dumps(json.loads(response["locations"]), sort_keys=True, indent=4))

    def do_delete_location(self, ecli, line, host):
        region = None
        dc = None
        compute_zone = None
        location_type = None
        subscription_id = None
        location_name = None

        line = line.split(' ', 1)
        location_name, rest = line[0], line[1] if len(line) > 1 else None
        if not location_name:
            cl.perr("Mandatory param Location Name not specified")
            return

        params = ecli.parse_params(rest, None)
        try:
            ecli.validate_parameters('location', 'delete', params)
        except Exception as e:
            cl.perr(str(e))

        if 'type' in params:
            location_type = params['type'] = params['type'].lower()
        if location_type not in list(self.loc_req_params.keys()):
            cl.perr("Location type should be in :" + str(list(self.loc_req_params.keys())))
            return

        req_param = self.loc_req_params[location_type][0].lower()
        if req_param not in params:
            cl.perr(req_param + " is missing parameter for location type "+ location_type)
            return
        elif not params[req_param]:
            cl.perr(req_param + " value is missing parameter for location type "+ location_type)
            return
        if 'region' in params:
            region = params['region'] = params['region'].lower()
        if 'dc' in params:
            dc = params['dc'] = params['dc'].lower()
        if 'compute_zone' in params:
            dc = params['compute_zone'] = params['compute_zone'].lower()
        if 'subscription_id' in params:
            subscription_id = params['subscription_id'] = params['subscription_id'].lower()

        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()]) if params else ""
        cl.prt("c", "Delete Location: {0}{1}".format(location_name, query))
        response = self.HTTP.delete("{0}/location/{1}{2}".format(host, location_name, query))
        if not response:
            cl.perr("Error: Unable to delete location")
            return
        if response["status"] != 200:
            cl.perr("Error: Invalid status response {0} from ECRA for delete location request".format(response["status"]))
            return

        cl.prt("n", json.dumps(response))

    def do_get_location_details(self, ecli, line, host):
        '''
        Get the details of the location(s) fetched based on the command line
        arguments like subscription id, region, racksize and model.
        '''
        subscription_id = None
        racksize = None
        model = None
        region = None
        params = ecli.parse_params(line, None)

        try:
            ecli.validate_parameters('location', 'details', params)
        except Exception as e:
            cl.perr(str(e))
            return
        # Get parameters
        model = params.pop('model')
        params['racksize'] = params['racksize'] + " " + model
        sub_id = params.pop("subscription_id")
        params.update({"subscriptionid": sub_id})
        # Execute GET call
        query = "?" + "&".join(["{0}={1}".format(key, value) for key, value in params.items()])
        final_uri = "{0}/broker/locations{1}".format(host, query)
        cl.prt("c", final_uri)
        response = ecli.issue_get_request(final_uri, printResponse=False)

        if response["status"] != 200:
            cl.perr("Error: Invalid status response {0} from ECRA for get location details request".format(response["status"]))
            return

        cl.prt("n", json.dumps(response, indent=4, sort_keys=True))
        return

