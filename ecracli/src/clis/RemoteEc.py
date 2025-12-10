
"""
 Copyright (c) 2014, 2025, Oracle and/or its affiliates.

NAME:
    RemoteMgntCli - Basic functionality

FUNCTION:
    RemoteMgnt Client

NOTE:
    None    

History:
    cagaray     12/03/2025 - 34807833 - Dont force payload argument 
                             for image_management list op
    hgaldame    02/09/2023 - 35069605 - oci/exacc: ecracli support 
                             for remote manager dynamic tasks
    rajsag      05/27/2021 - remoteec not working for file transfer 
    jesandov    06/04/2020 - Add alias and parameter validation
    jesandov    26/03/2019 - File Creation
"""

from __future__ import print_function

import os
import re
import sys
import time
import json
import base64
import urllib.request, urllib.parse, urllib.error

from formatter import cl

class RemoteEc(object):

    def __init__(self, aEcracli):

        self.HTTP = aEcracli.HTTP
        self.host = aEcracli.host
        self.ecracli = aEcracli

        self.__httpClient = None
        self.__commands   = {}
        self.__help       = {}

        self.__defaultReload = {
            "exaccocid": "optional",
            "exaunitid": "optional",
            "hostname": "optional",
            "port": "optional",
            "auth": "optional",
            "track": "optional"
        }

        self.__commands["reload"] = self.__defaultReload
        self.__help['reload'] = "Reload Remote EC Endpoints"

        self.__notPersistParams = ["track"]
        self.__persistParams = {}

    def mInitArgs(self, aArgs):

        _host = "localhost"
        self.__commands = {}
        self.__help     = {}

        self.__persistParams = {}
        for _idx in range(0, len(aArgs)):
            _argu = aArgs[_idx]
            _split = _argu.split("=")

            if _split[0] == "auth":
                _split[1] = base64.b64encode(_split[1].encode("utf-8")).decode("utf-8")

            if _split[0] == "hostname":
                _host = _split[1].split(".")[0]

            if _split[0] not in self.__notPersistParams and _split[0] in list(self.__defaultReload.keys()):
                self.__persistParams[_split[0]] = "=".join(_split[1:])

        try:
            _result = self.mCommandCall("help", ["list"], aReloadCall=True)["text"]

            if "help" in list(_result.keys()):
                _result['reload'] = _result.pop("help")

            if "hostname" in list(_result.keys()):
                _host = _result.pop("hostname")

            for _endpoint in list(_result.keys()):
                if "help" in list(_result[_endpoint].keys()):
                    self.__help[_endpoint] = _result[_endpoint].pop("help")

            self.__commands = _result
            self.__commands['reload'] = self.__commands['reload']['list']['params']

            self.ecracli.prompt = "ecra {{{0}}}> ".format(_host)

            return True

        except Exception as e:

            self.__commands["reload"] = self.__defaultReload
            self.__help['reload'] = "Reload Remote EC Endpoints"
            cl.perr("Could not load remoteec information")
            cl.perr(str(e))
            self.ecracli.prompt = "ecra> "

            return False


    def mParseLine(self, aLine):

        _status  = 0
        _carring = ""
        _token   = ""
        _split   = []
        _line = "{0} ".format(aLine)

        for _letter in _line:
        
            if _status == 0:
                if re.match("[a-zA-Z0-9\_]", _letter) is not None:
                    _carring += _letter
                    _status = 1

            elif _status == 1:
                if _letter == " ":
                    _status = 2
                elif re.match("[a-zA-Z0-9\_\-]", _letter) is not None:
                    _carring += _letter
                elif _letter == "=":
                    _carring += _letter
                    _status = 3

            elif _status == 2:
                if re.match("[a-zA-Z0-9\_]", _letter) is not None:
                    _split.append(_carring)
                    _carring = _letter
                    _status = 1

            elif _status == 3:
                if re.match("[a-zA-Z0-9\+\-\/]", _letter) is not None:
                    _carring += _letter
                    _status = 4
                elif _letter == "'" or _letter == '"':
                    _token = _letter
                    _status = 5

            elif _status == 4:
                if _letter != " ":
                    _carring += _letter
                else:
                    _split.append(_carring)
                    _carring = ""
                    _status = 1

            elif _status == 5:

                if _letter == '\\':
                    _status = 6

                elif _letter == _token:
                    _split.append(_carring)
                    _carring = ""
                    _status = 1
                    _token = ""

                else:
                    _carring += _letter

            elif _status == 6:
                _carring += "\{0}".format(_letter).decode('string_escape')
                _status = 5

        if _carring != "":
            _split.append(_carring)

        _split = [x for x in _split if x != ""]
        return _split

    def mValidateCommand(self, aEndpointName, aArgs):

        if aEndpointName not in list(self.__commands.keys()):
            cl.perr("*** Invalid endpoint name: {0}".format(aEndpointName))
            return False

        _error = False
        if aArgs == []:
            cl.perr("*** No subcommand found")
            cl.perr("Try use: {0}".format(list(self.__commands[aEndpointName].keys())))
            return False

        else:

            _subcommand = aArgs[0]
            _subargs    = aArgs[1:]

            if _subcommand not in list(self.__commands[aEndpointName].keys()):
                cl.perr("*** Invalid subcommand (( {0} ))".format(_subcommand))
                cl.perr("Try use: {0}".format(list(self.__commands[aEndpointName].keys())))
                return False
            else:

                # Detect alias command
                if "alias" in list(self.__commands[aEndpointName][_subcommand].keys()):
                    _aliasInfo = self.__commands[aEndpointName][_subcommand]['alias']

                    _subargs.insert(0, _aliasInfo['subendpoint'])
                    return self.mValidateCommand(_aliasInfo['endpoint'], _subargs)

                # In case of normal command
                _params = self.__commands[aEndpointName][_subcommand]['params']

                for _subarg in _subargs:
                    if _subarg.find("=") == -1:
                        cl.perr("*** Mising '=' on sub-argument: (( {0} ))".format(_subarg))
                        return False
                    else: 
                        xparams = list(_params.keys()) + list(self.__commands['reload'].keys())
                        if _subarg.split("=")[0] not in xparams:
                            cl.perr("*** Sub-argument not valid: (( {0} ))".format(_subarg))
                            return False

                for _mandatory in _params:
                    if _params[_mandatory] not in ["optional", "hidden"]:
                        # The payload for imagemgmt list operation should be optional only for list operation
                        if aEndpointName == "image_management" and _subcommand == "execute" and _mandatory == "payload" and "op=list" in _subargs:
                            continue

                        if _mandatory not in [x.split("=")[0] for x in _subargs]:
                            cl.perr("*** Missing mandatory sub-argument: (( {0} ))".format(_mandatory))
                            return False

        return True

    def mBase64EncodeFileArg (self, aArgs, aArgName, aAbsoluteFilePath=True, aWorkDir=None, aIsBinary=False):
        try:
            if aAbsoluteFilePath is True:
                _file = aArgs[aArgName]
            else:
                _file = "{0}/{1}".format(aWorkDir, aArgs[aArgName])

            if aIsBinary:
                with open(_file,"rb") as f:
                    _fileC = f.read()
                    aArgs[aArgName]=  base64.b64encode(_fileC).decode('utf-8')
            else:
                with open(_file, "r") as f:
                    _fileC = f.read()
                    aArgs[aArgName] = base64.b64encode(_fileC.encode("utf-8")).decode("utf-8")

        except Exception as e:
            cl.perr(str(e))
            pass

    def mBeginWorkArounds(self, aEndpoint, aSubargs, aArgs, aWorkDir):

        # Detect alias command
        if "alias" in list(self.__commands[aEndpoint][aSubargs].keys()):
            _aliasInfo = self.__commands[aEndpoint][aSubargs]['alias']

            # refresh endpoints name and arguments
            aEndpoint = _aliasInfo['endpoint']
            aSubargs = _aliasInfo['subendpoint']

            for inmutableName, inmutableValue in (list(_aliasInfo['inmutable_params'].items())):
                aArgs[inmutableName] = inmutableValue

        #Special case of optional base64 payload file for imagemgmt list operation, will return encoded '{}' 
        if aEndpoint == "image_management" and aSubargs == "execute" and aArgs['op'] == "list" and "payload" not in aArgs:
           aArgs["payload"] = base64.b64encode(b'{}').decode('utf-8') 
           return aEndpoint, aSubargs, aArgs 

        # Begin workaround to transform the file into base64
        _params = self.__commands[aEndpoint][aSubargs]['params']
        for _paramName, _paramType in list(_params.items()):
            if _paramType == "base64_file":
                self.mBase64EncodeFileArg(aArgs, _paramName)

        # Special case of upload
        if aEndpoint == "editor" and aSubargs == "transfer" and aArgs['mode'] == "upload":
            self.mBase64EncodeFileArg(aArgs, 'local', False, aWorkDir)
        elif aEndpoint == "dyntasks" and aSubargs == "execute" and aArgs['op'] == "execute":
            self.mBase64EncodeFileArg(aArgs, 'local', False, aWorkDir, aIsBinary=True)
        return aEndpoint, aSubargs, aArgs

    def mGetWorkdirArgs(self, aEndpoint, aArgs):

        if self.mValidateCommand(aEndpoint, aArgs):
            #Configure the workdir
            _workdir = "ecmanagment"

            if _workdir[0] != "/":
                _workdir = os.path.abspath(_workdir)

            if not os.path.exists(_workdir):
                os.makedirs(_workdir)

            #Parse the args
            _subcommand = aArgs[0]

            _dict = {}
            for _idx in self.__persistParams:
                _dict[_idx] = self.__persistParams[_idx]

            for _idx in range(1, len(aArgs)):
                _argu = aArgs[_idx]
                _split = _argu.split("=")
                _dict[_split[0]] = "=".join(_split[1:])

            return _workdir, _dict, _subcommand

        else:
            return None, None, None

    def mCommandCall(self, aEndpoint, aArgs, aReloadCall=False):

        if aReloadCall:

            _url  = "{0}/ecmanagment/{1}".format(self.host, aEndpoint)

            if self.__persistParams is not None and self.__persistParams != {}:
                _url += "?" + urllib.parse.urlencode(self.__persistParams)

            _call = self.HTTP.get(_url)

            return _call

        else:

            if self.mValidateCommand(aEndpoint, aArgs):

                #Prepare te workdir and parse the args to a dict
                _workdir, _dict, _subcommand = self.mGetWorkdirArgs(aEndpoint, aArgs)

                #Execute Workaround to specific commands
                _endpoint, _subcommand, _dict = self.mBeginWorkArounds(aEndpoint, _subcommand, _dict, _workdir)

                #Do the HTTP Call
                _call = None

                _url = "{0}/ecmanagment/{1}".format(self.host, _endpoint)
                _method = self.__commands[_endpoint][_subcommand]['method']

                if _method == "GET":

                    if _dict is not None and _dict != {}:
                        _url += "?" + urllib.parse.urlencode(_dict)

                    _call = self.HTTP.get(_url)

                else:
                    _dict['HTTP_METHOD'] = _method
                    _call = self.HTTP.post(json.dumps(_dict), "ecmanagment", _url)

                return _call

            else:
                return None


    def mProcessResponse(self, aCall, aEndpoint, aArgs):

        #Prepare te workdir and parse the args to a dict
        _workdir, _dict, _subcommand = self.mGetWorkdirArgs(aEndpoint, aArgs)
        _call = aCall

        if _call is None:
            cl.perr("*** No request done")
            print("")

        elif str(_call['http_status']) != "200":
            cl.perr("*** Error on HTTP Call: ({0})".format(_call['http_status']))
            cl.perr(_call['error'])
            print("")

        else:

            #Display the response
            if _call['ctype'] == "application/json":
                _data = _call['text']

                if isinstance(_data, dict) and 'reqtype' in list(_data.keys()) and _data['reqtype'] == "async call":
                    if "track" in list(_dict.keys()) and "false" == _dict['track'].strip().lower():
                        print(json.dumps(_data, indent=2, sort_keys=True))
                        print("")
                    else:
                        self.mAsynWorkAround(_call, aEndpoint)
                else:
                    #cl.prt("c", "Command execution succesfull")
                    print(json.dumps(_data, indent=2, sort_keys=True))
                    print("")

            else:

                if 'local' in list(_dict.keys()) and _dict['local'].strip() != "":

                    _path = "{0}/{1}".format(_workdir, _dict['local'])

                    with open(_path, "w+") as _f:
                        _text = _call['text']
                        _text = base64.b64decode(_text).decode("utf-8")
                        _f.write(_text)

                    cl.prt("c", "Download File on: {0}".format(_path))

                else:
                    cl.prt("c", "Show file content\n")
                    cl.prt("c", "+"*60)
                    print(_call['data'], end="")
                    cl.prt("c", "+"*60)

                print("")

    def mAsynWorkAround(self, aTrackResponse, aEndpoint):

        _lastCall   = {"content": {"0": "0"}, "alive": True}
        _track      = aTrackResponse['text']
        _lastOffset = -7777

        if "offset" in list(_track.keys()):
            _lastOffset = int(_track['offset'])

        #Print command delimitator
        cl.prt("c", "+"*60)
        print("")

        if "content" in list(_track.keys()) and len(list(_track['content'].keys())) != 0:
            _keys = sorted(_track['content'].keys())
            _lastLine = _track['content'].pop(_keys[-1])

            for _key in sorted(_track['content'].keys()):
                print("\r{0}".format(_track['content'][_key]))

            print("\r{0}".format(_lastLine), end="")

        #configure retries and log
        _retries = 0
        _maxRetries = 10
        self.HTTP.verbose = ""

        #Make the async track
        while _lastCall['alive']:

            time.sleep(1)

            #Build the request
            _args = []
            _args.append("resume")
            _args.append("id={0}".format(_track['id']))

            if _lastOffset == -7777: 
                _args.append("offset=0")
            else:
                _args.append("offset={0}".format(_lastOffset))

            _tmpCall = self.mCommandCall("async", _args)

            if _tmpCall is None:
                _retries += 1

                if _retries == _maxRetries-1:
                    self.HTTP.verbose = False

                if _retries >= _maxRetries:
                    break
                else:
                    continue

            else:
                _retries = 0
                self.HTTP.verbose = ""

            _lastCall = _tmpCall

            if str(_lastCall['http_status']) != "200":
                cl.perr("Error ({0}): {1}".format(_lastCall['http_status'], _lastCall['error']))
                break
            else:

                #Fetch and print new content
                _lastCall = _lastCall['text']
                try:
                    _newLastOffset = int(max([int(x) for x in list(_lastCall['content'].keys())]))

                    if _newLastOffset > _lastOffset:

                        _lastOffset = _newLastOffset

                        _keys = sorted(_lastCall['content'].keys())
                        _lastLine = _lastCall['content'].pop(_keys[-1])

                        for _key in sorted(_lastCall['content'].keys()):
                            print("\r{0}".format(_lastCall['content'][_key]))

                        print("\r{0}".format(_lastLine), end="")

                    elif _newLastOffset == _lastOffset:

                        if _newLastOffset != -1:

                            _keys = sorted(_lastCall['content'].keys())
                            _lastLine = _lastCall['content'].pop(_keys[-1])
                            sys.stdout.flush()
                            print("\r{0}".format(_lastLine), end="")

                except ValueError:
                    _newLastOffset = -1

        print("\n")
        cl.prt("c", "+"*60)
        self.HTTP.verbose = False

    def mProcessHelp(self, aArgs):

        _args = self.mParseLine(aArgs)

        if len(_args) == 1:
            cl.prt("c", "Remote EC utility")

        else:

            _principalCmd = _args[1]

            if _principalCmd in list(self.__commands.keys()):

                _help = "\n### {0} ###\n\n".format(self.__help[_principalCmd])

                _endpoints = sorted(list(self.__commands[_principalCmd].keys()), key=len)

                if len(_endpoints) > 0:
                    _maxPadding = max([len(x) for x in _endpoints])

                for _endpoint in _endpoints:
                    _endpointC = self.__commands[_principalCmd][_endpoint]
                    if "help" in list(_endpointC.keys()):
                        _padding = " "*(_maxPadding-len(_endpoint)+1)
                        _help += "{0}){1}{2}\n".format(_endpoint, _padding, _endpointC['help'])

                cl.prt("c", _help)

            else:
                cl.perr("No help entry found for {0}".format(_principalCmd))


    def mExecute(self, aArgs):

        _args = self.mParseLine(aArgs)

        if _args is None or _args == []:
            cl.prt("c", "Valid sub operations: {0}".format(list(self.__commands.keys())))

        else:
            _endpoint = _args.pop(0)

            if _endpoint == "reload":

                if self.mInitArgs(_args):
                    cl.prt("c", "Reload Complete")

            else:

                #Re-reload if necessary
                xargs = [x.split("=")[0] for x in _args[1:]]
                for _authParam in list(self.__commands["reload"].keys()):
                    if _authParam in xargs:
                        self.mInitArgs(_args[1:])
                        break

                _call = self.mCommandCall(_endpoint, _args)

                if _call is not None:
                    self.mProcessResponse(_call, _endpoint, _args)


    def mCompleteEndpoint(self, aCmd):

        _completions = []

        for _cmd in list(self.__commands.keys()):
            if _cmd.startswith(aCmd):
                _completions.append(_cmd)

        return ["{0} ".format(x) for x in _completions]


    def mCompleteSubs(self, aCmd, aText):

        _completions = []

        if aCmd in list(self.__commands.keys()):
            for _subCommand in list(self.__commands[aCmd].keys()):
                if _subCommand.startswith(aText):
                    _completions.append(_subCommand)

        return ["{0} ".format(x) for x in _completions]

    def mCompleteArgs(self, aCmd, aSubCmd, aText):

        _completions = []

        if aCmd in list(self.__commands.keys()) and aSubCmd in list(self.__commands[aCmd].keys()):

            _subcommands = {}

            # detect completion of alias
            if "alias" in list(self.__commands[aCmd][aSubCmd].keys()):
                _aliasInfo = self.__commands[aCmd][aSubCmd]['alias']
                _subcommands = _aliasInfo['params']

            else:
                _subcommands = self.__commands[aCmd][aSubCmd]['params']

            for _subcommandName, _subcommandType in list(_subcommands.items()):
                if _subcommandType not in ["hidden"]:
                    if _subcommandName.startswith(aText):
                        _completions.append(_subcommandName)

            for _subCommand in list(self.__commands['reload'].keys()):
                if _subCommand.startswith(aText):
                    _completions.append(_subCommand)

        return list(["{0}=".format(x) for x in _completions])

    def mCompletePrimaryArgs(self, aEndpoint, aText):

        _completions = []

        for _subCommand in self.__commands[aEndpoint]:
            if _subCommand.startswith(aText):
                _completions.append(_subCommand)

        return ["{0}=".format(x) for x in _completions]


    def mComplete(self, aLine, aText):

        _args = self.mParseLine(aLine)
        _args.pop(0)

        if len(_args) == 0:
            return self.mCompleteEndpoint("")

        if _args[0] == "reload":
            return self.mCompletePrimaryArgs(_args[0], aText)

        else:

            if len(_args) == 1:
                if "{0} ".format(_args[0]) in self.mCompleteEndpoint(_args[0]):
                    return self.mCompleteSubs(_args[0], "")
                else:
                    return self.mCompleteEndpoint(_args[0])

            elif len(_args) == 2:
                if "{0} ".format(_args[1]) in self.mCompleteSubs(_args[0], _args[1]):
                    return self.mCompleteArgs(_args[0], _args[1], "")
                else:
                    return self.mCompleteSubs(_args[0], _args[1])

            else:
                return self.mCompleteArgs(_args[0], _args[1], aText)

#end of file
