"""
 Copyright (c) 2015, 2017, Oracle and/or its affiliates. All rights reserved.

NAME:
    Zone - CLIs for adding, deleting and querying info about a zone

FUNCTION:
    Provides the clis to add/delete zones etc

NOTE:
    None

History:
    rgmurali    04/20/2017 - Create file
"""
from formatter import cl
import json
from os import path

class Zone:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_add_zone(self, ecli, line, host, mytmpldir):
        region = None
        dc = None
        zone = None
        uri = None
        location = None
        username = None
        passwd = None
        line = line.split(' ', 1)
        zone, rest = line[0], line[1] if len(line) > 1 else None
        if not zone:
            cl.perr("Mandatory param zone not specified")
            return

        params = ecli.parse_params(rest, None)

        try:
            ecli.validate_parameters('zone', 'add', params)
        except Exception as e:
            cl.perr(str(e))

        if 'region' in params:
            region = params['region'] = params['region'].lower()
        if 'dc' in params:
            dc = params['dc'] = params['dc'].lower()
        if 'location' in params:
            location = params['location'] = params['location'].upper()
        else:
            location = "REMOTE"
        if 'uri' in params:
            uri = params['uri']
        if not uri:
            cl.perr("Missing parameter: uri.")
            return

        if location == 'REMOTE':
            if not region:
                cl.perr("Location is REMOTE but region not defined")
                return
            if not dc:
                cl.perr("Location is REMOTE but dc not defined")
                return
        elif location == 'LOCAL':
            if not region:
                cl.prt("n", "Zone is LOCAL but region not specified. Will use default from template.")
            if not dc:
                cl.prt("n", "Zone is LOCAL but dc not specified. Will use default from template.")
        else:
            cl.perr("Invalid value for location specified. Should be one of: LOCAL, REMOTE")
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

        params['zone'] = zone.lower()
        inputJson = path.join(mytmpldir, "addzone.json")
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
        response = self.HTTP.post(data, "zones", "{0}/zones/add".format(host))
        cl.prt("n", json.dumps(response))

    def do_list_zone(self, ecli, line, host):
        region = None
        dc = None
        racksize = None
        hwmodel = None
        # Set to true if this is not a simple list request but a query for capacity
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('zone', 'list', params)
        except Exception as e:
            cl.perr(str(e))
            return

        if 'region' in params:
            region = params['region'] 
        if 'dc' in params:
            dc = params['dc']
        if 'racksize' in params:
            racksize = params['racksize']
        if 'hwmodel' in params:
            hwmodel = params['hwmodel']

        if not region and not dc and not racksize and not hwmodel:
            # Execute plain list
            response = self.HTTP.get("{0}/zones".format(host))
        else:
          # Execute list with query params - racksize is mandatory as this API is to determine if a certain rack 
          # size is available in which zones of a DC
          if not racksize:
            cl.perr("Param racksize is mandatory if one of the following params is specified: dc, region, hwmodel")
            return
          uri = "{0}/broker/exaunits/zone/capacity?"
          amp=""
          if region:
            uri += "region={0}".format(region)
            amp='&'
          if dc:
            uri += "{0}dc={1}".format(amp, dc)
            amp='&'
          if racksize:
            uri += "{0}racksize={1}".format(amp, racksize)
            amp='&'
          if hwmodel:
            uri += "{0}hwmodel={1}".format(amp, hwmodel)
          response = self.HTTP.get(uri.format(host))
        if not response:
            cl.perr("Error: Unable to fetch zone list")
            return

        if response["status"] != 200:
            cl.perr("Error: Invalid status response {0} from ECRA for list zones request".format(response["status"]))
            return

        if isinstance(response["zones"], list):
          cl.prt("n", json.dumps(response["zones"], sort_keys=True, indent=4))
        else:
          cl.prt("n", json.dumps(json.loads(response["zones"]), sort_keys=True, indent=4))

    def do_delete_zone(self, ecli, line, host):

        if len(line.split()) != 1:
            cl.perr("delete_zone takes only one mandatory argument <zone_name>")
        else:
            cl.prt("c", "Delete zone: {0}".format(line))
            response = self.HTTP.delete("{0}/zones/{1}".format(host, line))
            if not response:
                cl.perr("Error: Unable to delete zone")
                return
            if response["status"] != 200:
                cl.perr("Error: Invalid status response {0} from ECRA for delete zones request".format(response["status"]))
                return

            cl.prt("n", json.dumps(response))
