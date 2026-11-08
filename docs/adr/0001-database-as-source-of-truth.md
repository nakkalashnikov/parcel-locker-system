# ADR-0001: The database is the source of truth and its procedures are the integration API

Status: Accepted

## Context

Two applications in two languages work on the same parcels and compartments. The database course requires business rules, a central transaction and row-level concurrency control in PostgreSQL. If the rules also lived in application code, they would exist three times and drift apart.

## Decision

- PostgreSQL owns shared state and enforces the business rules that protect it.
- C++ and Java never communicate directly. They call the procedures and read the views listed in the [database contract](../../contracts/database-api.md).
- Each application connects with its own role, which has no direct write access to tables.
- The one flow from station to hub, telling a customer their PIN, goes through a transactional outbox table.

Ownership of everything else:

| Owner | Owns |
| :--- | :--- |
| PostgreSQL | Shared state, locking, business rules, audit trail |
| C++ station | Doors, sensors, compartment behaviour, choosing a compartment |
| Java hub | Registering parcels, assigning couriers, redirects, notifications, reports |

The applications may check a rule early to give a better answer, such as `canAccommodate` when choosing a compartment. The database still has the final word: a losing race or a stale read is rejected there.

## Why

- A rule that sits behind a procedure cannot be bypassed by a bug in either application.
- A transaction that fails leaves nothing behind, including its notification.
- Removing direct table access through roles makes the boundary enforced rather than a convention.
- Both courses are served by one design.

## Rejected

- **REST or gRPC between C++ and Java.** It adds servers, serialization and failure modes, and earns no rubric points. The demo runs on one machine.
- **A message broker.** More infrastructure for one notification flow. The outbox gives the same guarantee with one table.
- **Direct SQL from both applications.** The rules would spread across three languages, which is exactly the spaghetti we want to avoid.
- **Logic only in the applications.** It fails the database course and cannot guarantee exclusive compartment access across two processes.

## Consequences

- Changing the contract touches up to three subsystems, so it needs an explicit pull request.
- Debugging business rules means reading PL/pgSQL.
- Unit tests in C++ and Java cannot prove database rules, so these need their own tests.
