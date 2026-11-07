# ADR-0004: Shared names come from one file, checked by contract tests

Status: Accepted

## Context

Parcel statuses and compartment states appear as PostgreSQL enums, C++ enums and Java enums. The rubric requires native enums in each language, so they cannot simply be removed. Nothing currently stops them from drifting apart, and the requirements already use `IN_LOCKER` where the schema says `STORED_IN_LOCKER`.

## Decision

[`contracts/domain_vocabulary.json`](../../contracts/domain_vocabulary.json) defines the shared statuses, states, tiers, event types, allowed transitions and error codes. Each subsystem keeps its native types, and a test in each subsystem fails if they differ from this file:

| Subsystem | Check |
| :--- | :--- |
| Database | CI compares `pg_enum` and the installed error codes with the file |
| C++ | A Google Test compares the `toString` values with the file |
| Java | A JUnit test compares the enum constants with the file |

`STORED_IN_LOCKER` is the canonical name. `IN_LOCKER` in BR7 of the requirements means this status.

## Why

- Native enums stay, so the rubric items are met and the code reads naturally.
- Drift becomes a failing test instead of a surprise during the demo.
- No generation step for a student to explain or debug.

## Rejected

- **Generating the enums from the file.** It removes duplication completely, but adds a tool to the build, and generated code is harder to read and defend.
- **Strings instead of enums.** Loses type safety and fails the rubric.
- **Discipline and code review alone.** This is what let the drift appear.

## Consequences

- Adding a status means changing four places. The tests point to any that were forgotten.
