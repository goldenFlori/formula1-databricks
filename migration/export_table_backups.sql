-- Replace <backup-root-url> before running.
-- This script exports snapshots of managed tables so data is preserved outside the workspace.

CREATE CATALOG IF NOT EXISTS formula1_backup;
CREATE SCHEMA IF NOT EXISTS formula1_backup.snapshots;

CREATE OR REPLACE TABLE formula1_backup.snapshots.bronze_circuits
DEEP CLONE formula1.bronze.circuits;
CREATE OR REPLACE TABLE formula1_backup.snapshots.bronze_constructors
DEEP CLONE formula1.bronze.constructors;
CREATE OR REPLACE TABLE formula1_backup.snapshots.bronze_drivers
DEEP CLONE formula1.bronze.drivers;
CREATE OR REPLACE TABLE formula1_backup.snapshots.bronze_races
DEEP CLONE formula1.bronze.races;
CREATE OR REPLACE TABLE formula1_backup.snapshots.bronze_results
DEEP CLONE formula1.bronze.results;
CREATE OR REPLACE TABLE formula1_backup.snapshots.bronze_sprints
DEEP CLONE formula1.bronze.sprints;

CREATE OR REPLACE TABLE formula1_backup.snapshots.silver_circuits
DEEP CLONE formula1.silver.circuits;
CREATE OR REPLACE TABLE formula1_backup.snapshots.silver_constructors
DEEP CLONE formula1.silver.constructors;
CREATE OR REPLACE TABLE formula1_backup.snapshots.silver_drivers
DEEP CLONE formula1.silver.drivers;
CREATE OR REPLACE TABLE formula1_backup.snapshots.silver_races
DEEP CLONE formula1.silver.races;
CREATE OR REPLACE TABLE formula1_backup.snapshots.silver_results
DEEP CLONE formula1.silver.results;
CREATE OR REPLACE TABLE formula1_backup.snapshots.silver_sprints
DEEP CLONE formula1.silver.sprints;

CREATE OR REPLACE TABLE formula1_backup.snapshots.gold_dim_constructors
DEEP CLONE formula1.gold.dim_constructors;
CREATE OR REPLACE TABLE formula1_backup.snapshots.gold_dim_drivers
DEEP CLONE formula1.gold.dim_drivers;
CREATE OR REPLACE TABLE formula1_backup.snapshots.gold_dim_races
DEEP CLONE formula1.gold.dim_races;
CREATE OR REPLACE TABLE formula1_backup.snapshots.gold_fact_session_results
DEEP CLONE formula1.gold.fact_session_results;
CREATE OR REPLACE TABLE formula1_backup.snapshots.gold_ref_nationality_region
DEEP CLONE formula1.gold.ref_nationality_region;

CREATE CATALOG IF NOT EXISTS formula1_incr_backup;
CREATE SCHEMA IF NOT EXISTS formula1_incr_backup.snapshots;

CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.bronze_circuits
DEEP CLONE formula1_incr.bronze.circuits;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.bronze_constructors
DEEP CLONE formula1_incr.bronze.constructors;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.bronze_drivers
DEEP CLONE formula1_incr.bronze.drivers;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.bronze_races
DEEP CLONE formula1_incr.bronze.races;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.bronze_results
DEEP CLONE formula1_incr.bronze.results;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.bronze_sprints
DEEP CLONE formula1_incr.bronze.sprints;

CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.silver_circuits
DEEP CLONE formula1_incr.silver.circuits;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.silver_constructors
DEEP CLONE formula1_incr.silver.constructors;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.silver_drivers
DEEP CLONE formula1_incr.silver.drivers;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.silver_races
DEEP CLONE formula1_incr.silver.races;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.silver_results
DEEP CLONE formula1_incr.silver.results;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.silver_sprints
DEEP CLONE formula1_incr.silver.sprints;

CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.gold_dim_constructors
DEEP CLONE formula1_incr.gold.dim_constructors;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.gold_dim_drivers
DEEP CLONE formula1_incr.gold.dim_drivers;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.gold_dim_races
DEEP CLONE formula1_incr.gold.dim_races;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.gold_ref_nationality_region
DEEP CLONE formula1_incr.gold.ref_nationality_region;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.control_batch_batch
DEEP CLONE formula1_incr.control.batch_batch;
CREATE OR REPLACE TABLE formula1_incr_backup.snapshots.control_batch_control
DEEP CLONE formula1_incr.control.batch_control;
