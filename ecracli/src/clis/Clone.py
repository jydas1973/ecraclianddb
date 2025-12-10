"""
 Copyright (c) 2015, 2017, Oracle and/or its affiliates. All rights reserved.

NAME:
    Clone - CLIs for creating a clone and testmaster

FUNCTION:
    Provides the clis to create a snapclone and testmaster on the cluster

NOTE:
    None

History:
    rgmurali    05/15/2017 - Create file
"""
from formatter import cl
import json
from os import path

class Clone:
	def __init__(self, HTTP):
		self.HTTP = HTTP

	def do_create_tm(self, ecli, line, host, mytmpldir, snap=False, warning=True):
		line = line.split(' ', 1)
		exaunit_id, rest = ecli.exaunit_id_from(line[0]), line[1] if len(line) > 1 else ""

		if not exaunit_id:
			cl.perr("Missing exaunit ID.")
			return

		params = ecli.parse_params(rest, None)
		if type(params) is str:
			cl.perr(params)
			return
		try:
			if snap:
				ecli.validate_parameters('clone', 'snap', params)
			else:
				ecli.validate_parameters('clone', 'testmaster', params)
		except Exception as e:
			cl.perr(str(e))
			return

		_infile = "snapcreate.json" if snap else "tmcreate.json"
		inputJson = path.join(mytmpldir, _infile)

		objJson = None
		with open(inputJson) as json_file:
			objJson = json.load(json_file)

		for option in params:
			if option in objJson:
				objJson[option] = params[option]
			elif warning:
				cl.perr("{0} is not a valid option".format(option))
				return

		data = json.dumps(objJson)

		if not snap:
			response = self.HTTP.post(data, "snapclone", "{0}/exaunit/{1}/snapclone/testmaster".format(host, exaunit_id))
			ecli.waitForCompletion(response, "create_tm")
		else:
			response = self.HTTP.post(data, "snapclone", "{0}/exaunit/{1}/snapclone/create".format(host, exaunit_id))
			ecli.waitForCompletion(response, "create_snap")
