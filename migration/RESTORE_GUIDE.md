# Formula1 workspace restore guide

This repository contains the assets needed to rebuild most of the Formula1 project in a new Databricks workspace.

## What is already portable in this repo

### Notebooks and project code
* `formula1-project/`
* `formula1-project-incremental-load/`
* `introduction-to-delta-lake/`
* `introduction-to-unity-catalog/`

### Jobs as Declarative Automation Bundle resources
* `resources/job_formula1_lakehouse_full_refresh.yml`
* `resources/jobs/job_formula1_lakehouse_incremental_refresh.yml`
* `resources/jobs/job_formula1_incremental_batch_orchestration.yml`
* `databricks.yml`

### Dashboard backups
* `dashboard_exports/Formula1 Demo Dashboard.json`
* `dashboard_exports/Formula1 Analytics Dashboard.export.json`

### Migration helpers added for rebuild
* `migration/bootstrap_formula1.sql`
* `migration/bootstrap_formula1_incr.sql`
* `migration/formula1_views.sql`
* `migration/asset_inventory.md`

## Restore order in a new workspace

1. Clone this repository into the new workspace.
2. Update storage locations, external location names, and storage credential names in the bootstrap SQL files.
3. Run `migration/bootstrap_formula1.sql` to create the `formula1` catalog, schemas, and volume.
4. Run `migration/bootstrap_formula1_incr.sql` to create the `formula1_incr` catalog, schemas, control schema, and volume.
5. Load the raw landing files into the volumes expected by the notebooks.
6. Recreate jobs from the bundle YAML files and run the full refresh job first.
7. Run the analytics notebooks in `formula1-project/05-analytics/` to recreate the standings views.
8. If you want the incremental project too, run the incremental orchestration job after seeding its landing files.
9. Rebuild/import dashboards using the JSON backups in `dashboard_exports/`.

## Current table inventory captured from this workspace

### formula1
* bronze: `circuits`, `constructors`, `drivers`, `races`, `results`, `sprints`
* silver: `circuits`, `constructors`, `drivers`, `races`, `results`, `sprints`
* gold managed tables: `dim_constructors`, `dim_drivers`, `dim_races`, `fact_session_results`, `ref_nationality_region`
* gold views: `v_constructor_standing`, `v_driver_standing`

### formula1_incr
* bronze: `circuits`, `constructors`, `drivers`, `races`, `results`, `sprints`
* silver: `circuits`, `constructors`, `drivers`, `races`, `results`, `sprints`
* gold managed tables: `dim_constructors`, `dim_drivers`, `dim_races`, `ref_nationality_region`
* control managed tables: `batch_batch`, `batch_control`

## What is not automatically portable

These items are not fully recreated just by cloning the repo:
* managed table data, unless you reload it from source files or export/import the data separately
* secrets, linked accounts, storage credentials, and service principals
* permissions and grants on catalogs, schemas, tables, jobs, and dashboards
* job run history, dashboard subscriptions, favorites, and workspace-specific history
* exact raw Lakeview draft JSON for the analytics dashboard; the repo contains a structured export of its datasets, SQL, pages, and widgets instead

## Practical recommendation

If you want the closest possible migration, keep this repo, keep a backup of the landing/source files outside the trial workspace, and recreate the environment from the bootstrap SQL plus the bundle job definitions.
