# formula1-databricks

This repository is a self-service handoff for rebuilding the Formula1 Databricks project in a new workspace. It now includes bundle-managed jobs and dashboards, SQL bootstrap and table-restore assets, and a one-command orchestration script for either backup-based restore or notebook-driven rebuild.

## One-command replica

1. Copy `migration/.env.example` to `migration/.env`.
2. Fill in the Databricks host, token, warehouse, storage URLs, storage credential, and catalog names.
3. Run `bash migration/restore_project.sh migration/.env`.

Use `RESTORE_MODE=backup` when you have exported backup catalogs under `BACKUP_ROOT_URL`. Use `RESTORE_MODE=rebuild` when you want the script to provision assets and then run the full refresh job to repopulate tables from landing files.

## What is automated

* Unity Catalog bootstrap for `formula1` and `formula1_incr`
* bundle deployment of jobs and dashboards
* backup export and backup restore SQL for managed tables
* recreation of standings views
* optional permission grants when group names are supplied
* CI validation for bundle and restore automation

## Repository layout

* `formula1-project/` and `formula1-project-incremental-load/`
  * notebook code for the full-refresh and incremental pipelines
* `resources/jobs/`
  * Declarative Automation Bundle job definitions
* `resources/dashboards/`
  * bundle-managed dashboard resources
* `migration/`
  * one-click restore script, SQL bootstrap, backup export and restore SQL, and security templates
* `.github/workflows/validate-replica.yml`
  * GitHub Actions validation for the replica flow

## What still stays outside Git

* secret values, service principal credentials, and cloud IAM assignments
* the cloud storage accounts and containers themselves
* workspace-specific permissions on jobs, dashboards, folders, and users not covered by SQL grants
* job run history, dashboard subscriptions, favorites, and audit history

## Validation

Run `bash migration/validate_replica.sh` from the repo root to validate the rendered SQL, check for hardcoded trial references in automation files, and validate the bundle structure.
