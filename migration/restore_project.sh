#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
RENDERED_DIR="$SCRIPT_DIR/.rendered"
DRY_RUN=false
SKIP_BUNDLE_DEPLOY=false
SKIP_FULL_REFRESH=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [env-file] [--dry-run] [--skip-bundle-deploy] [--skip-full-refresh]

Modes are controlled through RESTORE_MODE in the env file:
* backup  - restore managed tables from backup catalogs under BACKUP_ROOT_URL
* rebuild - deploy assets, create storage/catalogs, then run the full refresh job
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --skip-bundle-deploy)
      SKIP_BUNDLE_DEPLOY=true
      shift
      ;;
    --skip-full-refresh)
      SKIP_FULL_REFRESH=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      ENV_FILE="$1"
      shift
      ;;
  esac
done

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE"
  echo "Copy $SCRIPT_DIR/.env.example to $SCRIPT_DIR/.env and fill in the values first."
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

: "${DATABRICKS_HOST:?Set DATABRICKS_HOST in the env file}"
: "${WAREHOUSE_ID:?Set WAREHOUSE_ID in the env file}"
: "${FORMULA1_CATALOG:?Set FORMULA1_CATALOG in the env file}"
: "${FORMULA1_INCR_CATALOG:?Set FORMULA1_INCR_CATALOG in the env file}"
: "${FORMULA1_BACKUP_CATALOG:?Set FORMULA1_BACKUP_CATALOG in the env file}"
: "${FORMULA1_INCR_BACKUP_CATALOG:?Set FORMULA1_INCR_BACKUP_CATALOG in the env file}"
: "${FORMULA1_STORAGE_URL:?Set FORMULA1_STORAGE_URL in the env file}"
: "${FORMULA1_INCR_STORAGE_URL:?Set FORMULA1_INCR_STORAGE_URL in the env file}"
: "${BACKUP_ROOT_URL:?Set BACKUP_ROOT_URL in the env file}"
: "${FORMULA1_EXTERNAL_LOCATION:?Set FORMULA1_EXTERNAL_LOCATION in the env file}"
: "${FORMULA1_INCR_EXTERNAL_LOCATION:?Set FORMULA1_INCR_EXTERNAL_LOCATION in the env file}"
: "${STORAGE_CREDENTIAL_NAME:?Set STORAGE_CREDENTIAL_NAME in the env file}"
: "${LANDING_VOLUME_NAME:?Set LANDING_VOLUME_NAME in the env file}"

RESTORE_MODE="${RESTORE_MODE:-backup}"
RUN_INCREMENTAL_JOB="${RUN_INCREMENTAL_JOB:-false}"
APPLY_PERMISSIONS="${APPLY_PERMISSIONS:-false}"
BUNDLE_TARGET="${BUNDLE_TARGET:-dev}"
ENGINEER_GROUP="${ENGINEER_GROUP:-}"
CONSUMER_GROUP="${CONSUMER_GROUP:-}"

mkdir -p "$RENDERED_DIR"

escape_sed() {
  printf '%s' "$1" | sed 's/[&|]/\\&/g'
}

replace_token() {
  local token="$1"
  local value="$2"
  local file="$3"
  sed -i.bak "s|$token|$(escape_sed "$value")|g" "$file"
  rm -f "${file}.bak"
}

render_template() {
  local source_file="$1"
  local target_file="$2"
  cp "$source_file" "$target_file"
  replace_token "__FORMULA1_CATALOG__" "$FORMULA1_CATALOG" "$target_file"
  replace_token "__FORMULA1_INCR_CATALOG__" "$FORMULA1_INCR_CATALOG" "$target_file"
  replace_token "__FORMULA1_BACKUP_CATALOG__" "$FORMULA1_BACKUP_CATALOG" "$target_file"
  replace_token "__FORMULA1_INCR_BACKUP_CATALOG__" "$FORMULA1_INCR_BACKUP_CATALOG" "$target_file"
  replace_token "__FORMULA1_STORAGE_URL__" "$FORMULA1_STORAGE_URL" "$target_file"
  replace_token "__FORMULA1_INCR_STORAGE_URL__" "$FORMULA1_INCR_STORAGE_URL" "$target_file"
  replace_token "__BACKUP_ROOT_URL__" "$BACKUP_ROOT_URL" "$target_file"
  replace_token "__FORMULA1_EXTERNAL_LOCATION__" "$FORMULA1_EXTERNAL_LOCATION" "$target_file"
  replace_token "__FORMULA1_INCR_EXTERNAL_LOCATION__" "$FORMULA1_INCR_EXTERNAL_LOCATION" "$target_file"
  replace_token "__STORAGE_CREDENTIAL_NAME__" "$STORAGE_CREDENTIAL_NAME" "$target_file"
  replace_token "__LANDING_VOLUME_NAME__" "$LANDING_VOLUME_NAME" "$target_file"
  replace_token "__ENGINEER_GROUP__" "$ENGINEER_GROUP" "$target_file"
  replace_token "__CONSUMER_GROUP__" "$CONSUMER_GROUP" "$target_file"
}

databricks_cmd() {
  if [[ -n "${DATABRICKS_CONFIG_PROFILE:-}" ]]; then
    databricks --profile "$DATABRICKS_CONFIG_PROFILE" "$@"
  else
    databricks "$@"
  fi
}

require_command() {
  local name="$1"
  command -v "$name" >/dev/null 2>&1 || {
    echo "Required command not found: $name"
    exit 1
  }
}

run_sql_file() {
  local sql_file="$1"
  local statement payload response state statement_id
  statement="$(awk 'NF {print}' "$sql_file" | tr '\n' ' ')"
  payload="$(jq -nc --arg warehouse_id "$WAREHOUSE_ID" --arg statement "$statement" '{warehouse_id:$warehouse_id, statement:$statement, wait_timeout:"50s"}')"
  response="$(databricks_cmd api post /api/2.0/sql/statements --json "$payload")"
  state="$(printf '%s' "$response" | jq -r '.status.state')"
  statement_id="$(printf '%s' "$response" | jq -r '.statement_id')"

  while [[ "$state" == "PENDING" || "$state" == "RUNNING" ]]; do
    sleep 5
    response="$(databricks_cmd api get "/api/2.0/sql/statements/${statement_id}")"
    state="$(printf '%s' "$response" | jq -r '.status.state')"
  done

  if [[ "$state" != "SUCCEEDED" ]]; then
    echo "SQL execution failed for $sql_file"
    printf '%s\n' "$response"
    exit 1
  fi
}

render_template "$SCRIPT_DIR/bootstrap_formula1.sql" "$RENDERED_DIR/bootstrap_formula1.sql"
render_template "$SCRIPT_DIR/bootstrap_formula1_incr.sql" "$RENDERED_DIR/bootstrap_formula1_incr.sql"
render_template "$SCRIPT_DIR/export_table_backups.sql" "$RENDERED_DIR/export_table_backups.sql"
render_template "$SCRIPT_DIR/restore_table_backups.sql" "$RENDERED_DIR/restore_table_backups.sql"
render_template "$SCRIPT_DIR/formula1_views.sql" "$RENDERED_DIR/formula1_views.sql"
render_template "$SCRIPT_DIR/secrets_permissions_template.sql" "$RENDERED_DIR/secrets_permissions.sql"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "Rendered SQL files to $RENDERED_DIR"
  ls -1 "$RENDERED_DIR"
  exit 0
fi

require_command databricks
require_command jq

cd "$ROOT_DIR"

if [[ "$SKIP_BUNDLE_DEPLOY" != "true" ]]; then
  databricks_cmd bundle validate \
    --target "$BUNDLE_TARGET" \
    --var "warehouse_id=$WAREHOUSE_ID" \
    --var "formula1_catalog=$FORMULA1_CATALOG" \
    --var "formula1_incr_catalog=$FORMULA1_INCR_CATALOG"

  databricks_cmd bundle deploy \
    --target "$BUNDLE_TARGET" \
    --var "warehouse_id=$WAREHOUSE_ID" \
    --var "formula1_catalog=$FORMULA1_CATALOG" \
    --var "formula1_incr_catalog=$FORMULA1_INCR_CATALOG"
fi

run_sql_file "$RENDERED_DIR/bootstrap_formula1.sql"
run_sql_file "$RENDERED_DIR/bootstrap_formula1_incr.sql"

if [[ "$RESTORE_MODE" == "backup" ]]; then
  run_sql_file "$RENDERED_DIR/restore_table_backups.sql"
else
  if [[ "$SKIP_FULL_REFRESH" != "true" ]]; then
    databricks_cmd bundle run job_formula1_lakehouse_full_refresh --target "$BUNDLE_TARGET"
  fi
fi

run_sql_file "$RENDERED_DIR/formula1_views.sql"

if [[ "$APPLY_PERMISSIONS" == "true" ]]; then
  : "${ENGINEER_GROUP:?Set ENGINEER_GROUP before enabling APPLY_PERMISSIONS}"
  : "${CONSUMER_GROUP:?Set CONSUMER_GROUP before enabling APPLY_PERMISSIONS}"
  run_sql_file "$RENDERED_DIR/secrets_permissions.sql"
fi

if [[ "$RUN_INCREMENTAL_JOB" == "true" ]]; then
  databricks_cmd bundle run job_formula1_incremental_batch_orchestration --target "$BUNDLE_TARGET"
fi

echo "Formula1 replica flow completed using RESTORE_MODE=$RESTORE_MODE"
