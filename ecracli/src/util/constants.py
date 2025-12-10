"""
 Copyright (c) 2015, 2020, Oracle and/or its affiliates. 

NAME:
    constants.py - constants

FUNCTION:
    Contains constants used across ecracli

NOTE:
    None

History:
    sachikuk    09/13/2018 - Bug 28643725 - ecracli changes for brokerproxy
    sachikuk    09/13/2018 - Creation
"""

class CliMode(object):
    
    def __init__(self, *modes):
        for i in range(len(modes)):
            setattr(self, modes[i], i)

    def __getattr__(self, name):
        return self.__dict__[name]

    def __setattr__(self, name, value):
        self.__dict__[name] = value

    def __dir__(self):
        return sorted(set(dir(super(CliMode, self)) + list(self.__dict__.keys())))

    def __getitem__(self, key):
        return self.__dict__[key]

    def __setitem__(self, key, value):
        self.__dict__[key] = value

    def reverse_mapping(self, value=None):
        members = list(vars(self).items())
        if value is None:
            return dict((value, key) for key, value in members
                    if not key.startswith('__') and not callable(getattr(self, key)))
        
        for member in members:
            if member[1] == value:
                return member[0]
        return None

ECRACLI_MODES = CliMode('default', 'brokerproxy')
