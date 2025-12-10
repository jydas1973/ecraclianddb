# ECRACLI Project Guidelines

## 1. Key File Paths for Code Generation

### 1.1 Entry Point & Main Driver
- `src/ecracli.py` - Main CLI driver (292KB, ~7000+ lines)
  - Command parser and dispatcher
  - Interactive mode handler
  - Configuration loader
  - Command routing to CLI modules

### 1.2 Core Infrastructure Files
- `src/EcraHTTP.py` - HTTP/HTTPS client (get/post/put/delete/patch/query methods)
  - `HTTP.HEADERS` dict for Content-Type/Accept per resource
  - SSL/TLS context, Basic auth, response validation via `check_status_response()`
- `src/formatter.py` - Output/logging: `cl.prt(color, msg)`, `cl.perr(msg)` sets ExitCode[0]=1
  - Logger: `src/log/ecracli.log` (50KB max, 10 backups)
- `src/formatSensitiveData.py` - Log sanitization, masks passwords/credentials
- `src/SysCURL.py` - CURL operations wrapper

### 1.3 Configuration & Documentation
- `src/ecracli.cfg` - Config: host, port, credentials, SSL/TLS cert paths
- `src/User_manual.md` / `.txt` - **READ BEFORE CODING** - Command syntax, params, examples

### 1.4 CLI Modules (src/clis/*.py) - 100+ files
**Key modules:** Ecra.py, Service.py, Vm.py, Database.py, ATP.py, ExadataInfra.py, Hardware.py,
Bonding.py, Patch.py, Workflows.py, Status.py, Healthcheck.py, Security.py, User.py, Info.py

### 1.5 Utilities
- `src/util/constants.py` - Constants: `ECRACLI_MODES` (default, brokerproxy), `CliMode` class

### 1.6 Templates (src/tmpl/) - **CRITICAL: Update when adding commands**
- `help.json` - ALL command help text: `{"resource": {"op": "usage_text"}}` **MUST UPDATE**
- `parameters.json` - Validation: `{"resource": {"op": {"mandatory": [], "optional": []}}}` **MUST UPDATE**
- `*.json` - Payload templates: atp_reconfigpayload.json, dbcs.json, customvip.json, etc.

## 2. Python Coding Practices

### 2.1 File Headers & Class Structure
**Header Template:**
```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright (c) 2015, 2025, Oracle and/or its affiliates.
# NAME: ModuleName - Brief description
# DESCRIPTION: Detailed functionality description
# MODIFIED (MM/DD/YY): username 12/10/25 - Enh 12345678 - Changes
```

**Class Template:**
```python
from formatter import cl
import json

class ResourceName:
    def __init__(self, HTTP):
        self.HTTP = HTTP

    def do_operation_resource(self, ecli, line, host):
        params = ecli.parse_params(line, None)
        try:
            ecli.validate_parameters('resource', 'operation', params)
        except Exception as e:
            return cl.perr(str(e))
        uri = "{0}/resource/{1}".format(host, params['id'])
        response = self.HTTP.get(uri)
        if response:
            cl.prt("n", json.dumps(response, indent=4, sort_keys=False))
```

### 2.2 HTTP, Output & Data
**HTTP:** `self.HTTP.get/post/put/delete/patch/query(...)` | Add new resource to `HTTP.HEADERS` in EcraHTTP.py
**Output:** `cl.prt(color, msg)` - n/c/g/r/p/b | `cl.perr()` sets ExitCode[0]=1
**Data:** `json.dumps(payload, sort_keys=True, indent=4)` | `data.encode("utf-8")` | Check `if response:`
**URI:** `.format()` not f-strings | **Security:** No secrets in logs, validate paths, SSL

### 2.3 New Command Checklist (Update ALL):
1. **Create/Modify:** `src/clis/YourModule.py` - Implementation
2. **Update:** `src/tmpl/help.json` - Add help text for command
3. **Update:** `src/tmpl/parameters.json` - Add parameter validation rules
4. **Update:** `src/ecracli.py` - Register command in dispatcher (if new module)
5. **Update:** `src/EcraHTTP.py` - Add to HEADERS dict (if new resource type)
6. **Update:** `src/User_manual.md` - Document the command usage

## 3. Code Review Checklist

### Documentation
- [ ] Oracle copyright (2015, 2025), history entry (MM/DD/YY, author, bug/enh #, description)
- [ ] Docstring: NAME, DESCRIPTION, NOTES, History sections
- [ ] `src/User_manual.md` updated with command usage and examples

### Code Quality
- [ ] No hardcoded secrets/credentials
- [ ] Try/except with specific errors, `cl.perr()` for exit code
- [ ] Parameter validation via `ecli.validate_parameters()`
- [ ] No dead code, snake_case naming, <120 char lines

### HTTP/API
- [ ] New resources added to `HTTP.HEADERS` in EcraHTTP.py
- [ ] Correct method: GET(read), POST(create), PUT(update), DELETE(remove), PATCH(partial)
- [ ] URI: `"{0}/resource/{1}".format(host, id)`, response checked: `if response:`
- [ ] `src/tmpl/parameters.json` and `src/tmpl/help.json` updated

### Security
- [ ] No SQL/command injection, no directory traversal
- [ ] SSL/TLS for HTTPS, sensitive data filtered from logs
- [ ] No passwords in output/errors



