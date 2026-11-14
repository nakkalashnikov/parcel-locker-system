# Machine setup

What to install to work on each part of the project, and how to check that it works. You only need the tools for the part you work on. The database needs only Docker, and nobody needs a local PostgreSQL or `psql`.

| Part | Tools | Check |
| :--- | :--- | :--- |
| Database | Docker with Compose v2 (Docker Desktop, OrbStack or Docker Engine) | `docker compose version` |
| C++ station | C++20 compiler (Apple clang 15+, GCC 11+ or MSVC 2022), CMake 3.20+, libpqxx 7 | `cmake --version`, `c++ --version` |
| Java hub | JDK 21, Maven 3.6.3+ | `java -version`, `mvn -version` |
| UI, later | Node.js 20+ | `node --version` |

## Install commands

macOS with Homebrew:

```bash
brew install cmake libpqxx openjdk@21 maven
```

Homebrew prints a command that links the JDK into the system location. Run it, then check `java -version` shows 21.

Ubuntu or Debian:

```bash
sudo apt install build-essential cmake libpqxx-dev openjdk-21-jdk maven
```

Windows: install Docker Desktop with the WSL 2 backend and run the scripts from WSL or Git Bash. For C++, use Visual Studio 2022 with CMake and install libpqxx through vcpkg.

GoogleTest is added through CMake when the tests appear, so it needs no separate install.

The database commands below were run on macOS with OrbStack. The C++ and Java package names are the standard ones and are confirmed when each part gets its build.

## Database

Start the database and install everything from an empty state:

```bash
scripts/db_reset.sh
```

The script starts the container, drops and recreates the `parcel_locker` database, installs the files listed in `database/install_order.txt` in that order, and ends with the smoke check. It is safe to run again at any time, and it destroys all data in that database each time.

Check that the database answers, without changing anything:

```bash
scripts/db_smoke_check.sh
```

Connection details for the applications:

| Setting | Value |
| :--- | :--- |
| Host | `localhost` |
| Port | `5433` |
| Database | `parcel_locker` |
| User | `locker_owner` |
| Password | in `docker-compose.yml`, for development only |

Stop the container and keep the data, or stop it and delete the data:

```bash
docker compose down
docker compose down -v
```

If port 5433 is taken, choose another one for the container and use the same number in the application settings:

```bash
LOCKER_DB_PORT=5434 scripts/db_reset.sh
```

Demo and test scripts, such as the rollback demo, are not part of the install order. Run them by hand after a reset.
