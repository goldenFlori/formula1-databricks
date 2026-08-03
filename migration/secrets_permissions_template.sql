-- Rendered by restore_project.sh.
-- Secret scopes, service principals, and storage credential secrets still need to be created outside Git.

GRANT USE CATALOG ON CATALOG __FORMULA1_CATALOG__ TO `__ENGINEER_GROUP__`;
GRANT USE SCHEMA ON SCHEMA __FORMULA1_CATALOG__.bronze TO `__ENGINEER_GROUP__`;
GRANT USE SCHEMA ON SCHEMA __FORMULA1_CATALOG__.silver TO `__ENGINEER_GROUP__`;
GRANT USE SCHEMA ON SCHEMA __FORMULA1_CATALOG__.gold TO `__ENGINEER_GROUP__`;
GRANT SELECT ON TABLE __FORMULA1_CATALOG__.gold.dim_drivers TO `__CONSUMER_GROUP__`;
GRANT SELECT ON TABLE __FORMULA1_CATALOG__.gold.dim_constructors TO `__CONSUMER_GROUP__`;
GRANT SELECT ON TABLE __FORMULA1_CATALOG__.gold.dim_races TO `__CONSUMER_GROUP__`;
GRANT SELECT ON TABLE __FORMULA1_CATALOG__.gold.fact_session_results TO `__CONSUMER_GROUP__`;
GRANT SELECT ON VIEW __FORMULA1_CATALOG__.gold.v_driver_standing TO `__CONSUMER_GROUP__`;
GRANT SELECT ON VIEW __FORMULA1_CATALOG__.gold.v_constructor_standing TO `__CONSUMER_GROUP__`;

GRANT USE CATALOG ON CATALOG __FORMULA1_INCR_CATALOG__ TO `__ENGINEER_GROUP__`;
GRANT USE SCHEMA ON SCHEMA __FORMULA1_INCR_CATALOG__.bronze TO `__ENGINEER_GROUP__`;
GRANT USE SCHEMA ON SCHEMA __FORMULA1_INCR_CATALOG__.silver TO `__ENGINEER_GROUP__`;
GRANT USE SCHEMA ON SCHEMA __FORMULA1_INCR_CATALOG__.gold TO `__ENGINEER_GROUP__`;
GRANT USE SCHEMA ON SCHEMA __FORMULA1_INCR_CATALOG__.control TO `__ENGINEER_GROUP__`;

-- Manual prerequisites that remain outside Git:
-- * create secret scopes and populate secret values
-- * create or rotate the storage credential identity and cloud-side IAM assignments
-- * assign dashboard, job, and workspace object permissions that are not covered by SQL grants
