# Formula1 asset inventory

## Jobs captured in repo
* `job_formula1_lakehouse_full_refresh`
* `job_formula1_lakehouse_incremental_refresh`
* `job_formula1_incremental_batch_orchestration`

## Dashboard backup files in repo
* `dashboard_exports/Formula1 Demo Dashboard.json`
* `dashboard_exports/Formula1 Analytics Dashboard.export.json`

## Current workspace table inventory

### formula1
* bronze.circuits
* bronze.constructors
* bronze.drivers
* bronze.races
* bronze.results
* bronze.sprints
* silver.circuits
* silver.constructors
* silver.drivers
* silver.races
* silver.results
* silver.sprints
* gold.dim_constructors
* gold.dim_drivers
* gold.dim_races
* gold.fact_session_results
* gold.ref_nationality_region
* gold.v_constructor_standing
* gold.v_driver_standing

### formula1_incr
* bronze.circuits
* bronze.constructors
* bronze.drivers
* bronze.races
* bronze.results
* bronze.sprints
* silver.circuits
* silver.constructors
* silver.drivers
* silver.races
* silver.results
* silver.sprints
* gold.dim_constructors
* gold.dim_drivers
* gold.dim_races
* gold.ref_nationality_region
* control.batch_batch
* control.batch_control

## Important note
The managed tables listed above are not stored in Git as data. They are recreated by rerunning the notebooks/jobs after the landing files and catalog setup have been restored.
