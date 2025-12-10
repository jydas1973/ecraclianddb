"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    Exaunit - CLIs for operations on the exaservice

FUNCTION:
    Ecracli util functions

NOTE:
    None

History:
    brsudars    01/02/2018 - Add a min val for integer
    brsudars    11/22/2017 - Create file
"""
import json

from formatter import cl
import os


class EcliUtil:

    @staticmethod
    def isIntegerParam(p, err_mesg, minVal=1):
        try:
            int(p)
        except ValueError:
            cl.perr(err_mesg + ":please specify an integer number")
            return False
        if int(p) < minVal:
           cl.perr(err_mesg + ":please specify a value greater than or equal to " + str(minVal))
           return False
        return True

    # Method that loads given json file
    # Method fails if given file doesnt exists or if not json compliant
    @staticmethod
    def load_json(file):
        try:
            with open(file) as f:
                data = json.load(f)
        except IOError:
            cl.perr("File {0} not accessible".format(file))
            return False
        except:
            cl.perr("File {0} not valid".format(file))
            return False
        cl.prt("n","Succesfully loaded file {0}".format(file))
        return data

