"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    cl - Eye candy format

FUNCTION:
    Provides the eye candy format

NOTE:
    None

History:
    jvaldovi    04/30/19   - Adding valitation for response data to set proper exitCode
    rgmurali    05/15/2017 - Create file
"""
import logging
import logging.handlers
import os
from os import path
import sys

mydir = path.os.path.dirname(path.abspath(__file__))
mylogdir = path.join(mydir, "log")

if not os.path.exists(mylogdir):
    os.makedirs(mylogdir)

mylog = path.join(mylogdir, "ecracli.log")

logger = logging.getLogger("ECRACLI")
handler = logging.handlers.RotatingFileHandler(mylog, maxBytes=50000, backupCount=10)

FORMAT = "%(asctime)-15s - " + str(os.getpid()) + " - %(message)s"
fmt = logging.Formatter(FORMAT,datefmt='%Y-%m-%d %H:%M:%S')

handler.setFormatter(fmt)
logger.addHandler(handler)
logger.setLevel(logging.INFO)

#global variable which contains Exit Code of the script bug 27816733
ExitCode = [0]

###################################################
#    EYE CANDY - FORMAT                           #
###################################################

class cl:
    
    interactive = False
    colors = {
        'n': '0',  # none
        'r': '31', # red
        'g': '32', # green
        'b': '34', # blue
        'p': '35', # purple
        'c': '36', # cyian
        'w': '37'  # white
    }

    @staticmethod
    def prt(c, msg, highlight=False):
        if not msg:
            return

        if cl.interactive:
            cf = ""
            if highlight:
                cf = "1;"
            cf +=  cl.colors[c]
            print(("\033[" + cf + "m* " + msg + "\033[0m"))
            sys.stdout.flush()
        else:
            print(msg)
            sys.stdout.flush()
        logger.info(msg)

    @staticmethod
    def inv(msg):
        if not msg:
            return

        if cl.interactive:
            cf = "7"
            print(("\033[" + cf + "m* " + msg + "\033[27m"))
            sys.stdout.flush()
        else:
            print(msg)
            sys.stdout.flush()
        logger.info(msg)

    @staticmethod
    def perr(msg):
        cl.prt("r", "Error: " + msg)
        #if there is any error on code set proper exit code
        global ExitCode
        ExitCode[0] = 1
        


