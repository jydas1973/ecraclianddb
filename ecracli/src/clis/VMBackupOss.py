#!/usr/bin/env python
#
# $Header: ecs/ecra/ecracli/src/clis/VMBackupOss.py /main/3 2022/01/13 13:33:01 aadavalo Exp $
#
# VMBackupOss.py
#
# Copyright (c) 2021, Oracle and/or its affiliates.
#
#    NAME
#      VMBackupOss.py - CLIs to support Vmbackup to OSS
#
#    DESCRIPTION
#      Provides clis for taking vmbackups to OSS and restoring, listing etc
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    aadavalo    12/14/21 - Enh 33612595 - VM-BACKUP: OS VM BACKUP TOOL NEEDS
#                           TO PROVIDE SUPPORT FOR FAILED BACKUPS
#    rgmurali    08/23/21 - Er 33250690 - Add delete endpoint for vmbackuposs
#    rgmurali    01/26/21 - Creation
#
from formatter import cl
import json
from os import path

class VMBackupOss:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_backup_vmbackuposs(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('vmbackuposs', 'backup', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "vmbackuposs", "{0}/vmbackuposs/backup".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_restore_vmbackuposs(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('vmbackuposs', 'restore', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.post(data, "vmbackuposs", "{0}/vmbackuposs/restore".format(host))
        if response:
            cl.prt("n", json.dumps(response))

    def do_list_vmbackuposs(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('vmbackuposs', 'list', params)
        except Exception as e:
            cl.perr(str(e))
            return

        exaunitid = params.pop("exaunitid")

        response = ecli.issue_get_request("{0}/vmbackuposs/{1}".format(host, exaunitid), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))

    def do_delete_vmbackuposs(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('vmbackuposs', 'delete', params)
        except Exception as e:
            cl.perr(str(e))
            return

        data = json.dumps(params, sort_keys=True, indent=4)
        response = self.HTTP.delete("{0}/vmbackuposs/delete".format(host), data)
        if response:
            cl.prt("n", json.dumps(response))

    def do_lsfailed_vmbackuposs(self, ecli, line, host):
        params = ecli.parse_params(line, None)

        # Validate the parameters
        try:
            ecli.validate_parameters('vmbackuposs', 'listfailed', params)
        except Exception as e:
            cl.perr(str(e))
            return

        response = self.HTTP.get("{0}/vmbackuposs/lsfailed".format(host), False)

        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))