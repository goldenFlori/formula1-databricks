-- Update the URL, external location name, and storage credential before running.

CREATE EXTERNAL LOCATION IF NOT EXISTS databricks_course_ext_dl999_formula1
URL 'abfss://formula1@databrickscoursedlflori.dfs.core.windows.net'
WITH (STORAGE CREDENTIAL `databricks-course-sc`)
COMMENT 'External location for the formula1 container';

CREATE CATALOG IF NOT EXISTS formula1
MANAGED LOCATION 'abfss://formula1@databrickscoursedlflori.dfs.core.windows.net'
COMMENT 'Main catalog for the formula1 project';

CREATE SCHEMA IF NOT EXISTS formula1.landing;

CREATE SCHEMA IF NOT EXISTS formula1.bronze
MANAGED LOCATION 'abfss://formula1@databrickscoursedlflori.dfs.core.windows.net/bronze';

CREATE SCHEMA IF NOT EXISTS formula1.silver
MANAGED LOCATION 'abfss://formula1@databrickscoursedlflori.dfs.core.windows.net/silver';

CREATE SCHEMA IF NOT EXISTS formula1.gold
MANAGED LOCATION 'abfss://formula1@databrickscoursedlflori.dfs.core.windows.net/gold';

CREATE EXTERNAL VOLUME IF NOT EXISTS formula1.landing.files
LOCATION 'abfss://formula1@databrickscoursedlflori.dfs.core.windows.net/landing';
