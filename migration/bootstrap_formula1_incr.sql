-- Update the URL, external location name, and storage credential before running.

CREATE EXTERNAL LOCATION IF NOT EXISTS databricks_course_ext_dl999_formula1_incr
URL 'abfss://formula1-incr@databrickscoursedlflori.dfs.core.windows.net'
WITH (STORAGE CREDENTIAL `databricks-course-sc`)
COMMENT 'External location for the formula1-incr container';

CREATE CATALOG IF NOT EXISTS formula1_incr
MANAGED LOCATION 'abfss://formula1-incr@databrickscoursedlflori.dfs.core.windows.net'
COMMENT 'Main catalog for the incremental formula1 project';

CREATE SCHEMA IF NOT EXISTS formula1_incr.landing;

CREATE SCHEMA IF NOT EXISTS formula1_incr.bronze
MANAGED LOCATION 'abfss://formula1-incr@databrickscoursedlflori.dfs.core.windows.net/bronze';

CREATE SCHEMA IF NOT EXISTS formula1_incr.silver
MANAGED LOCATION 'abfss://formula1-incr@databrickscoursedlflori.dfs.core.windows.net/silver';

CREATE SCHEMA IF NOT EXISTS formula1_incr.gold
MANAGED LOCATION 'abfss://formula1-incr@databrickscoursedlflori.dfs.core.windows.net/gold';

CREATE SCHEMA IF NOT EXISTS formula1_incr.control;

CREATE EXTERNAL VOLUME IF NOT EXISTS formula1_incr.landing.files
LOCATION 'abfss://formula1-incr@databrickscoursedlflori.dfs.core.windows.net/landing';
