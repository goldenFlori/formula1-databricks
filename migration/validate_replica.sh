#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CI_ENV_FILE="$SCRIPT_DIR/.ci.env"

cat > "$CI_ENV_FILE" <<EOF
DATABRICKS_HOST=https://example.cloud.databricks.com
DATABRICKS_TOKEN=dapiPLACEHOLDER
WAREHOUSE_ID=warehouse-placeholder
BUNDLE_TARGET=dev
RESTORE_MODE=backup
RUN_INCREMENTAL_JOB=false
APPLY_PERMISSIONS=false
FORMULA1_CATALOG=formula1
FORMULA1_INCR_CATALOG=formula1_incr
FORMULA1_BACKUP_CATALOG=formula1_backup
FORMULA1_INCR_BACKUP_CATALOG=formula1_incr_backup
FORMULA1_STORAGE_URL=abfss://formula1@storageaccount.dfs.core.windows.net
FORMULA1_INCR_STORAGE_URL=abfss://formula1-incr@storageaccount.dfs.core.windows.net
BACKUP_ROOT_URL=abfss://formula1-backups@storageaccount.dfs.core.windows.net
FORMULA1_EXTERNAL_LOCATION=formula1_external_location
FORMULA1_INCR_EXTERNAL_LOCATION=formula1_incr_external_location
STORAGE_CREDENTIAL_NAME=storage_credential
LANDING_VOLUME_NAME=files
ENGINEER_GROUP=data-engineers
CONSUMER_GROUP=analytics-users
EOF

bash "$SCRIPT_DIR/restore_project.sh" "$CI_ENV_FILE" --dry-run >/dev/null

if grep -R "adb-7405615009528396" "$ROOT_DIR/databricks.yml" "$ROOT_DIR/resources" "$ROOT_DIR/migration" >/dev/null; then
  echo "Found hardcoded trial workspace host in automation files"
  exit 1
fi

if grep -R "databrickscoursedlflori" "$ROOT_DIR/databricks.yml" "$ROOT_DIR/resources" "$ROOT_DIR/migration" >/dev/null; then
  echo "Found hardcoded trial storage account in automation files"
  exit 1
fi

if grep -R "/Workspace/Users/florjanimema@gmail.com/formula1-databricks" "$ROOT_DIR/resources/jobs" >/dev/null; then
  echo "Found hardcoded workspace user path in job definitions"
  exit 1
fi

if command -v databricks >/dev/null 2>&1; then
  export DATABRICKS_HOST=https://example.cloud.databricks.com
  export DATABRICKS_TOKEN=dapiPLACEHOLDER
  (
    cd "$ROOT_DIR"
    databricks bundle validate \
      --target dev \
      --var "warehouse_id=warehouse-placeholder" \
      --var "formula1_catalog=formula1" \
      --var "formula1_incr_catalog=formula1_incr" \
      --var "formula1_gold_schema=gold" \
      --var "formula1_incr_gold_schema=gold" >/dev/null
  )
fi

rm -f "$CI_ENV_FILE"
echo "Replica automation validation passed"
