#!/usr/bin/env python 
import sys
from subprocess import Popen, PIPE
from os import path 
import xml.etree.ElementTree as ET
import logging

file = path.abspath(__file__)
library_path = path.dirname(file)

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(message)s',
                    datefmt='%m-%d %H:%M',
                    filename="ecra.log",
                    filemode='a')

class Populator(object):
    def __init__(self):
        #loading xml file 
        attributes = ["pdb", "tablespace", "username"]
        self.cfg     = {}
        self.scripts = {}

        cfg  = path.join(library_path, 'db.xml')
        tree = ET.parse(cfg) 
        root = tree.getroot()
         
        non_scripts = [child for child in root if child.tag in attributes]

        # expected files 
        for child in non_scripts:
            self.cfg[child.tag] = child.attrib
                  
        # case for password 
            
        for item in ['pdb', 'tablespace']:
            self.cfg[item] = self.cfg[item]["name"]
                    
        self.cfg["password"] = self.cfg["username"]["password"]   
        self.cfg["username"] = self.cfg["username"]["name"]
        # scripts
        
        for sql in root.findall('sql'):
            action = sql.get("action")
            name   = sql.get("name")
            self.scripts[action] = path.join(library_path, name)
    
    def run(self):
        # executing the scripts according to the order  
        # add precheqs 
        #  sqlplus / as sysdba @user.sql pdb1 ecra2 rest welcome1
        print "Creating user"
        cmd = "sqlplus / as sysdba @{0} {1} {2} {3} {4}".format(self.scripts['cuser'], self.cfg['pdb'],self.cfg['tablespace'], self.cfg['username'], self.cfg['password'])
        rt, output, error = shell(cmd)
        for line in output.splitlines():
            logging.info(line)

        print "Creating tables"
        cmd = "sqlplus {0}/{1}@{2} @{3}".format(self.cfg['username'], self.cfg['password'], self.cfg['pdb'], self.scripts['ctables'])
        rt, output, error = shell(cmd)
        for line in output.splitlines():
            logging.info(line)        

        print "Creating PL/SQL package specs"
        cmd = "sqlplus {0}/{1}@{2} @{3}".format(self.cfg['username'], self.cfg['password'], self.cfg['pdb'], self.scripts['cpls'])
        rt, output, error = shell(cmd)
        for line in output.splitlines():
            logging.info(line)        

        print "Creating PL/SQL package bodies"
        cmd = "sqlplus {0}/{1}@{2} @{3}".format(self.cfg['username'], self.cfg['password'], self.cfg['pdb'], self.scripts['cplb'])
        rt, output, error = shell(cmd)
        for line in output.splitlines():
            logging.info(line)        

        print "done"
          


def shell(command):
    process = Popen(command, stdout=PIPE, stderr=PIPE, shell=True, close_fds=True)
    output, error = process.communicate()
    rt = process.returncode
    return rt, output, error


def main():
    rt = False
    dbHandler = Populator()
    dbHandler.run() 
    return True


if __name__=='__main__':
    if main():
        sys.exit(0)

    sys.exit(1)
   
   
