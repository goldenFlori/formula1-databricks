# Formula1 workspace restore guide

This repository now supports a one-command replica flow for a new Databricks workspace.

## Primary entrypoint

Run `bash migration/restore_project.sh migration/.env` after copying `migration/.env.example` to `migration/.env` and filling in the environment-specific values.

## Supported restore modes

### `RESTORE_MODE=backup`
Use this when you exported managed-table backups to `BACKUP_ROOT_URL` with `migration/export_table_backups.sql` before the original workspace was shut down.

The script will:
* deploy jobs and dashboards from the bundle
* create the target catalogs, schemas, external locations, and landing volumes
* deep-clone tables back from the backup catalogs
* recreate the analytics views
* optionally apply SQL grants

### `RESTORE_MODE=rebuild`
Use this when you do not have managed-table backups but you do have the raw landing files.

The script will:
* deploy jobs and dashboards from the bundle
* create the target catalogs, schemas, external locations, and landing volumes
* run the full refresh job to rebuild Bronze, Silver, and Gold tables
* recreate the analytics views
* optionally trigger the incremental orchestration job

## Files that drive the replica

* `databricks.yml`
* `resources/jobs/*.yml`
* `resources/dashboards/formula1_dashboards.yml`
* `migration/bootstrap_formula1.sql`
* `migration/bootstrap_formula1_incr.sql`
* `migration/export_table_backups.sql`
* `migration/restore_table_backups.sql`
* `migration/formula1_views.sql`
* `migration/secrets_permissions_template.sql`
* `migration/restore_project.sh`

## Manual prerequisites that still cannot be automated end to end

* create the cloud storage accounts, containers, and network rules
* create or attach the storage credential identity and grant it cloud-side access
* create secret scopes and populate secret values
* provide a SQL warehouse and Databricks token or auth profile for the automation to use
* preserve either the managed-table backups at `BACKUP_ROOT_URL` or the raw landing files needed for rebuild mode
* reapply workspace-level permissions that are not expressible as SQL grants

## Non-automatable items after restore

* historical job runs and task output history
* dashboard subscriptions, favorites, and usage history
* personal workspace preferences and folder-level ACL decisions

## Validation

Run `bash migration/validate_replica.sh` to validate the bundle shape and ensure the automation files no longer contain hardcoded trial workspace references.
