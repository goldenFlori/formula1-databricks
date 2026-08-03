-- Fill in your principals, secret scope names, and storage credential names.
-- This file is a template only and is intentionally non-executable until customized.

-- Example principals
-- SET `engineer_group` = 'data-engineers';
-- SET `consumer_group` = 'analytics-users';

-- Example grants for the main catalog
GRANT USE CATALOG ON CATALOG formula1 TO `<engineer_group>`;
GRANT USE SCHEMA ON SCHEMA formula1.bronze TO `<engineer_group>`;
GRANT USE SCHEMA ON SCHEMA formula1.silver TO `<engineer_group>`;
GRANT USE SCHEMA ON SCHEMA formula1.gold TO `<engineer_group>`;
GRANT SELECT ON TABLE formula1.gold.dim_drivers TO `<consumer_group>`;
GRANT SELECT ON TABLE formula1.gold.dim_constructors TO `<consumer_group>`;
GRANT SELECT ON TABLE formula1.gold.dim_races TO `<consumer_group>`;
GRANT SELECT ON TABLE formula1.gold.fact_session_results TO `<consumer_group>`;
GRANT SELECT ON VIEW formula1.gold.v_driver_standing TO `<consumer_group>`;
GRANT SELECT ON VIEW formula1.gold.v_constructor_standing TO `<consumer_group>`;

-- Example grants for the incremental catalog
GRANT USE CATALOG ON CATALOG formula1_incr TO `<engineer_group>`;
GRANT USE SCHEMA ON SCHEMA formula1_incr.bronze TO `<engineer_group>`;
GRANT USE SCHEMA ON SCHEMA formula1_incr.silver TO `<engineer_group>`;
GRANT USE SCHEMA ON SCHEMA formula1_incr.gold TO `<engineer_group>`;
GRANT USE SCHEMA ON SCHEMA formula1_incr.control TO `<engineer_group>`;

-- Secret/config placeholders to document outside Git
-- Secret scope: <scope-name>
-- Secret key: <storage-key-or-app-secret>
-- Storage credential: <credential-name>
-- External locations:
--   formula1: <external-location-name>
--   formula1_incr: <external-location-name>

-- Jobs and dashboard permissions are applied in the workspace UI or via workspace APIs after import.
