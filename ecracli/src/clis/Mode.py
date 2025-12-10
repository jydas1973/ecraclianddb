"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Mode - CLIs for managing ecracli mode

FUNCTION:
    Provides the clis for ecracli mode management

NOTE:
    None

History:
    sachikuk    09/13/2018 - Bug 28643725 - ecracli changes for brokerproxy
    sachikuk    09/13/2018 - Creation
"""

import re
from copy import deepcopy

from formatter import cl
from util.constants import ECRACLI_MODES

class Mode:
    def __init__(self):
        self.valid_modes = list(ECRACLI_MODES.reverse_mapping().values())

    def validate_switchmode_params(self, params):
        # 'mode' is a mandatory parameter for switchmode command
        if ("mode" not in params):
            cl.perr("Please specify new mode using 'mode' parameter.")
            return False

        new_mode = params["mode"]

        # Check that new mode is valid
        if (new_mode not in self.valid_modes):
            cl.perr("'%s' is not a valid mode. Please select from: %s." %
                    (new_mode, self.valid_modes))
            return False

        # For brokerproxy mode, 'cimid' is a mandatory parameter
        if (new_mode == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy) and
            "cimid" not in params):
            cl.perr("For 'brokerproxy' mode, 'cimid' is a mandatory parameter.")
            cl.perr("Please specify CIM ID of a service instance using 'cimid' parameter.")
            return False
         
        return True

    def get_base_endpoint_url(self, url):
        regex = re.compile(r'(.*/ecra/endpoint)')
        regex_matches = regex.match(url)
        if not regex_matches:
            return None
        return regex_matches.groups()[0]

    def do_switchmode(self, ecli, line):
        params = ecli.parse_params(line, None)
        if (not self.validate_switchmode_params(params)):
            cl.perr("Failed to validate switchmode command parameters.")
            return

        # If new mode is same as current mode, skip mode switch
        new_mode = params["mode"]
        cur_mode = ecli.startup_options["mode"]
        brokerproxy_mode = ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)
        if ((new_mode == cur_mode and new_mode != brokerproxy_mode) or
            (new_mode == brokerproxy_mode and params["cimid"] == ecli.startup_options["cimid"])):
            cl.prt("p", "New mode is same as current mode, skipping mode switch.")
            return


        new_startup_options = deepcopy(ecli.startup_options)
        new_startup_args = ecli.startup_args

        cur_host = ecli.host
        base_url = self.get_base_endpoint_url(cur_host)
        if (base_url is None):
            cl.perr("Failed to extract base endpoint url from current host: %s." % cur_host)
            return

        new_startup_options["mode"] = new_mode
        new_startup_options["host"] = base_url
        if (new_mode == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.brokerproxy)):
            new_startup_options["cimid"] = params["cimid"]
        elif (new_mode == ECRACLI_MODES.reverse_mapping(ECRACLI_MODES.default)):
            new_startup_options["cimid"] = None
        else:
            cl.perr("switchmode command is not yet supported for '%s' mode." % new_mode)
            return

        ecli.init_ecracli(new_startup_options, new_startup_args, True) 
