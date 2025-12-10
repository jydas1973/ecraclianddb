# ECRA CLI and Database Utilities Repository

## Overview
- **Purpose:** This repository packages two tightly related toolsets used to provision, operate, and troubleshoot Exadata Cloud at Customer (ExaCC) environments.
  - `ecracli/` implements the ECRA Command Line Interface used by operations teams and automation workflows to interact with the ExaCC REST API.
  - `db/` hosts the PL/SQL packages, SQL scripts, and helper utilities required to bootstrap and maintain the backing ECRA schema.
- **Key Highlights:**
  - 7000+ line Python CLI driver with 100+ subcommand modules and templated payload definitions.
  - Extensive SQL automation for schema creation, upgrades, and data backfill tasks.
  - Rich documentation including a 400k+ word `User_manual.*` and module-specific guides in `examples/`.

## Repository Layout
```text
ecraclianddb/
|-- ecracli/
|   |-- AGENTS.md              # Coding conventions and release checklist
|   |-- examples/              # Contributor guidance and architecture notes
|   |-- src/
|       |-- ecracli            # Bash wrapper ensuring Python runtime availability
|       |-- ecracli.py         # Main CLI dispatcher and interactive shell
|       |-- EcraHTTP.py        # HTTP client with auth, TLS, and response handling
|       |-- clis/              # Feature modules (ATP, Service, Database, ...)
|       |-- tmpl/              # Help text, parameter validation, payload templates
|       |-- util/              # Shared utilities (constants, helpers)
|       |-- User_manual.{md,txt}
`-- db/
    |-- alter_*.sql, upgrade_*.sql   # Schema evolution scripts
    |-- ecra_pkg.{pls,plb}           # Core PL/SQL API package
    |-- scripts/                     # Operational maintenance SQL jobs
    |-- misc/                        # Reporting helpers and utilities
    `-- ecradb.py, db.xml            # Bootstrapper for schema installation
```

## Getting Started
1. **Clone and prepare the workspace**
   ```bash
   git clone <repo-url>
   cd ecraclianddb
   ```
2. **Review policy and coding guidelines**
   - Read `ecracli/AGENTS.md` before changing CLI code.
   - Consult `db/examples/ecracli_framework.md` for module architecture.
3. **Set up Python for the CLI**
   - The wrapper `src/ecracli` will bootstrap a local Python 3 virtual environment (if `ADE` tooling is unavailable).
   - Ensure required third-party modules (e.g., `defusedxml`) are present in the venv.
4. **Configure API access**
   - Copy `ecracli/src/ecracli.cfg` and update `host`, certificate paths, rack definitions, and database defaults for your environment.
5. **Run the CLI**
   ```bash
   cd ecracli/src
   ./ecracli                # interactive shell
   ./ecracli info           # non-interactive command invocation
   ```

## Development Workflow
- **Command Implementation**
  - Create or modify modules under `src/clis/` following the header template described in `AGENTS.md`.
  - Register new commands in `src/ecracli.py` and update `tmpl/help.json` plus `tmpl/parameters.json` to align usage and validation.
  - Provide payload skeletons in `src/tmpl/*.json` when introducing new REST operations.
- **Documentation Updates**
  - Extend `src/User_manual.md` with scenarios, parameter tables, and examples.
  - Keep `examples/` guides in sync when architectural patterns change.

## Database Package Usage
- Run `db/ecradb.py` or the individual SQL scripts to create the `ECRA` schema, PL/SQL packages, and associated metadata tables.
- `db/create_tables.sql` and `db/alter_tables.sql` lay down the schema; `db/ecra_pkg.pls` exposes procedural APIs consumed by the CLI.
- Maintenance scripts in `db/scripts/` address data backfills, metadata cleanup, and fleet-specific adjustments.

## Testing & Validation
- CLI command smoke tests can be executed by invoking subcommands against a staging ECRA endpoint configured in `ecracli.cfg`.
- Database changes should be validated in a non-production schema by running the relevant `create_*.sql` or `upgrade_*.sql` scripts and executing regression queries.
- Review `AGENTS.md` checklist to ensure help text, parameter validation, and user manual entries are updated before committing.

## Troubleshooting
- CLI logs are written to `ecracli/src/log/ecracli.log` (rotating 50KB files) with sensitive data sanitized via `formatSensitiveData.py`.
- HTTP diagnostics, including headers and TLS configuration, reside in `EcraHTTP.py`; enable debug logging in the venv if deeper tracing is required.
- For environment bootstrap issues, inspect `src/ecracli` wrapper output and confirm Python dependencies are installed correctly.

## Contributing
- Follow Oracle copyright headers and history annotations in every touched module.
- Keep changes small and focused; update `src/tmpl/` definitions alongside code adjustments.
- Coordinate schema changes with the database team and document the rollout plan in the associated SQL script headers.
- Before pushing, run targeted CLI or SQL validations and ensure documentation is refreshed.

## Reference Material
- `src/User_manual.md` – authoritative command reference.
- `examples/CLAUDE.md` – workflow checklist for agents collaborating on this codebase.
- Internal wiki: https://stbeehive.oracle.com/teamcollab/wiki/Exadata+PaaS:ecracli (Oracle network access required).
