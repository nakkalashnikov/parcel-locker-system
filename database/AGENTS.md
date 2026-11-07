# Database rules

PostgreSQL 15+. The global rules in the [root AGENTS.md](../AGENTS.md) apply. This subsystem implements the [database contract](../contracts/database-api.md).

## Target layout

```text
database/
├── schema.sql
├── seed_data.sql
├── rules/           triggers and constraints for BR1-BR8
├── transactions/    sp_deposit_parcel, commit demo, rollback demo
├── procedures/      the remaining contract procedures
├── concurrency/     session1.sql, session2.sql
├── analytics/       views, indexes, EXPLAIN ANALYZE evidence
└── security/        roles and grants
```

## Style

- SQL keywords in UPPERCASE, identifiers in `snake_case`.
- Schema in 3NF, with primary keys, foreign keys, check and unique constraints.
- Procedures are named `sp_<verb>_<noun>` and views `v_<subject>`.
- Parameters start with `p_`, output parameters with `out_`, local variables with `v_`.

## Behaviour

- Lock contested rows with `SELECT ... FOR UPDATE` before reading their state.
- Lock in this order to prevent deadlocks: compartment, then parcel.
- Report business failures with `RAISE EXCEPTION` and an `LK` error code from the vocabulary.
- An outcome that must survive the call is a return value, not an exception. An exception would roll back the failed PIN counter.
- Procedures do not issue `COMMIT`. The caller owns the transaction boundary.
- Every status change and access attempt writes to `audit_event_log`, which is append-only.
- Scripts are repeatable from an empty database.
