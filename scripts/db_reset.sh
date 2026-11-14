#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/lib/database.sh"

install_order_file="${database_directory}/install_order.txt"

recreate_database() {
    run_psql -d postgres -c "DROP DATABASE IF EXISTS ${database_name} WITH (FORCE)"
    run_psql -d postgres -c "CREATE DATABASE ${database_name}"
}

apply_sql_file() {
    local sql_file="$1"
    echo "Applying ${sql_file#"${database_directory}/"}"
    run_psql -d "${database_name}" --single-transaction --quiet <"${sql_file}"
}

apply_install_entry() {
    local entry="$1"
    local matches=()
    local sql_file

    while IFS= read -r sql_file; do
        matches+=("${sql_file}")
    done < <(compgen -G "${database_directory}/${entry}" | sort || true)

    if [ "${#matches[@]}" -eq 0 ]; then
        echo "Skipping ${entry}: not written yet"
        return
    fi

    for sql_file in "${matches[@]}"; do
        apply_sql_file "${sql_file}"
    done
}

require_docker
compose up -d --wait postgres
recreate_database

while IFS= read -r entry || [ -n "${entry}" ]; do
    [ -z "${entry}" ] && continue
    apply_install_entry "${entry}"
done <"${install_order_file}"

"$(dirname "${BASH_SOURCE[0]}")/db_smoke_check.sh"
