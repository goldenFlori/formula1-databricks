# formula1-databricks

Formula 1 data engineering project built in Databricks while following the course flow, with repo-managed code and bundle-managed job configuration.

## Current project structure

* `formula1-project/00-common`
  * shared environment and helper notebooks
* `formula1-project/01-setup`
  * setup notebook for project environment
* `formula1-project/02-bronze`
  * ingestion notebooks that load raw source data into Bronze tables
* `formula1-project/03-silver`
  * transformation notebooks that clean and standardize Bronze data into Silver tables
* `resources/jobs`
  * Declarative Automation Bundle job definitions
* `databricks.yml`
  * bundle entrypoint for this repo

## Current bundle resource

* `resources/jobs/job_formula1_lakehouse_full_refresh.yml`
  * multi-task job definition for the current Formula 1 refresh workflow

## What belongs in Git

Good to keep in this repo:

* notebooks and workspace files
* job and pipeline bundle YAML
* configuration files
* helper code
* small sample or test data only

Do not keep large operational data in Git:

* landing files
* Bronze, Silver, or Gold datasets
* large CSV or JSON source drops

Those should live in cloud storage, Unity Catalog volumes, or Unity Catalog tables.

## Safe structure decisions taken so far

* kept the Udemy course notebook structure unchanged so `%run` paths and notebook references do not break
* moved bundle job definitions into `resources/jobs`
* kept job configuration in source control through bundle YAML
* avoided renaming notebook folders while the course implementation is still in progress

## Recommended next steps

* validate the bundle from the repo root
* commit and push the new `resources/jobs` layout
* later separate learning or duplicate notebooks from the main Silver path if they are no longer needed
