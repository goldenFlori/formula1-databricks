#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="${1:-$SCRIPT_DIR/.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE"
  echo "Copy $SCRIPT_DIR/.env.example to $SCRIPT_DIR/.env and fill in the values first."
  exit 1
fi

source "$ENV_FILE"

cat <<EOF
Formula1 restore helper

This script prints the restore sequence and the commands you should run in a new workspace.
It is intentionally safe: it does not create cloud credentials for you.

1. Replace placeholders in:
   * $SCRIPT_DIR/bootstrap_formula1.sql
   * $SCRIPT_DIR/bootstrap_formula1_incr.sql
   * $SCRIPT_DIR/export_table_backups.sql
   * $SCRIPT_DIR/secrets_permissions_template.sql

2. Deploy bundle-defined jobs:
   databricks bundle deploy --target ${BUNDLE_TARGET:-dev}

3. Run bootstrap SQL files in a SQL editor or notebook.

4. Load landing/source files into the landing volume paths.

5. Run the full refresh job first, then the incremental orchestration job if needed.

6. Recreate analytics views:
   * $SCRIPT_DIR/formula1_views.sql

7. Re-import dashboards from:
   * $ROOT_DIR/Formula1 Demo Dashboard.lvdash.json
   * $ROOT_DIR/Formula1 Analytics Dashboard.lvdash.json

8. Apply secrets, grants, and infra placeholders from:
   * $SCRIPT_DIR/secrets_permissions_template.sql

9. Optionally export current managed tables before shutdown using:
   * $SCRIPT_DIR/export_table_backups.sql
EOF
