#!/bin/python
#
# $Header: ecs/ecra/ecracli/src/formatSensitiveData.py /main/2 2024/10/01 03:09:56 jreyesm Exp $
#
# formatSensitiveData.py
#
# Copyright (c) 2023, 2024, Oracle and/or its affiliates.
#
#    NAME
#      formatSensitiveData.py - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    jreyesm     09/27/24 - Bug 37092339. remove not suported regexp.
#    ddelgadi    08/23/23 - file to masked information into logs
#    ddelgadi    08/23/23 - Creation
#
import logging
import logging.config
import re

class formatSensitiveData(logging.Filter):
    patterns = ["\s--user\s\w+:\w+", "w{1}\w+[0-9]{1}"]

    def filter(self, record):
        record.msg = self.mask_sensitive_data(record.msg)
        return True

    def mask_sensitive_data(self, message):
        for pattern in self.patterns:
            rePattern = re.compile(pattern)
            message = rePattern.sub("********", message)
        return message

