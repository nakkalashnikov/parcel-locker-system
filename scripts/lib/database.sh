#!/usr/bin/env bash

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
database_directory="${repository_root}/database"
compose_file="${repository_root}/docker-compose.yml"
database_name="parcel_locker"
database_owner="locker_owner"

compose() {
    docker compose -f "${compose_file}" "$@"
}

run_psql() {
    compose exec -T postgres psql -v ON_ERROR_STOP=1 -U "${database_owner}" "$@"
}

require_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "Docker is not installed. See docs/SETUP.md." >&2
        exit 1
    fi
    if ! docker info >/dev/null 2>&1; then
        echo "Docker is installed but not running. Start it and try again." >&2
        exit 1
    fi
}
