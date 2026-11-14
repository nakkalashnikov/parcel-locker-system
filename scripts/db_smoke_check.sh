#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/database.sh"

require_docker

if ! compose ps --status running --quiet postgres | grep -q .; then
    echo "The database container is not running. Run scripts/db_reset.sh first." >&2
    exit 1
fi

server_version="$(run_psql -d "${database_name}" -tA -c 'SELECT version()')"
table_count="$(run_psql -d "${database_name}" -tA -c "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'")"
connected_role="$(run_psql -d "${database_name}" -tA -c 'SELECT current_user')"

echo "Connected as ${connected_role} to ${database_name}"
echo "Server: ${server_version}"
echo "Tables in public schema: ${table_count}"
