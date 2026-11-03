# Database Course Requirements (Prof. Baraban)

## Project Topic
- **Topic ID & Title**: `P-LOCKER` — *Transactional Parcel Locker Delivery System*
- **Database Engine**: **PostgreSQL 15+**
- **Repository Reference**: Recorded in `PROJECT.json` and linked to `README.md`.

---

## 1. Core Evaluation Criteria

1. **Conceptual Design**:
   - Crow’s Foot notation ERD (in `docs/ERD.png` and Mermaid format).
   - Cardinality and optionality defined for all entity relationships.
   - All M:N relationships properly resolved via associative entity tables.
2. **Relational Schema & Normalization**:
   - Documented 1NF, 2NF, and 3NF/BCNF normalization justifications.
   - Comprehensive DDL with strict primary keys, foreign keys (`ON DELETE RESTRICT/CASCADE`), check constraints, and unique constraints.
3. **Central Business Transaction & Partial Write Rollback**:
   - Explicit PL/pgSQL stored procedure demonstrating ACID compliance.
   - Intentional partial failure scenario showing atomic rollback without orphaned data.
4. **Contested Resource Concurrency Demonstration**:
   - Reproducible two-session test (`session1.sql` and `session2.sql`).
   - Row-level lock protection (`SELECT ... FOR UPDATE`) preventing double-allocation of lockers.
5. **Database Artifacts**:
   - Performance indexes (B-Tree, composite, partial indexes).
   - Analytical views (daily occupancy rate, courier performance).
   - Realistic synthetic seed dataset (customers, couriers, lockers, parcels, events).

---

## 2. Formal Business Rules (BR1 – BR8)

### BR1: Physical Compartment Fit
- A parcel can only be placed into a compartment whose physical dimensions (width, height, depth) and weight capacity strictly exceed the parcel's dimensions and weight.
- *Boundary Case*: Exact dimension matches without clearance margin are rejected.

### BR2: Mutually Exclusive Compartment Occupancy (Contested Resource)
- A compartment may reside in exactly one state: `AVAILABLE`, `RESERVED`, `OCCUPIED`, `MAINTENANCE`.
- Concurrent allocation attempts MUST execute row-level locking (`SELECT ... FOR UPDATE`) on the target compartment. Exactly one transaction succeeds; competing transactions safely fail or receive an alternate compartment.

### BR3: Pickup PIN Lifecycle and Invalidation
- When a parcel is deposited, an encrypted 6-digit PIN is generated with a strict 72-hour validity window.
- Three consecutive incorrect PIN attempts instantly transition the parcel status to `SECURITY_LOCKED`, requiring manual customer verification.

### BR4: Courier Access Delegation
- A courier may unlock a compartment only if the courier holds an active assignment for that specific parcel and the courier's shift status is `ON_DUTY`.

### BR5: Full Capacity Overflow Redirection
- When a parcel station reaches 100% occupancy for a target compartment tier, the system automatically redirects pending deliveries to the nearest designated fallback station within a 3-kilometer radius.

### BR6: Immutable Audit Trail
- Every physical door sensor event (`DOOR_OPENED`, `DOOR_CLOSED`), status mutation, and access attempt must trigger an automatic, append-only insertion into the `audit_event_log` table. Modifying or deleting audit rows is forbidden by database trigger.

### BR7: Expiry and Return Policy
- If a parcel remains in status `IN_LOCKER` for more than 72 hours without retrieval, a scheduled sweep marks the parcel as `EXPIRED_RETURN_PENDING` and allocates a return courier assignment.

### BR8: Customer Delivery Confirmation
- A parcel cannot transition to `DELIVERED` status without matching customer credentials (PIN or biometric/mobile token) and verified door-closure confirmation by sensor telemetry.

---

## 3. Central Transaction: `sp_deposit_parcel`

### Workflow
1. Start transaction (`BEGIN`).
2. Lock compartment row using `SELECT ... FOR UPDATE`.
3. Verify courier assignment and compartment availability.
4. Record parcel placement: update parcel status to `STORED_IN_LOCKER`.
5. Update compartment state to `OCCUPIED`.
6. Generate pickup token with 72-hour expiry.
7. Record audit log entry.
8. If simulated hardware sensor check fails $\to$ `ROLLBACK`; otherwise $\to$ `COMMIT`.

---

## 4. Concurrency Test Specification
- Two concurrent database client sessions execute simultaneous reservation on the sole available `MEDIUM` compartment at Station `ST-001`.
- Session A begins transaction and locks the row.
- Session B attempts the same reservation and is held or rejected depending on lock policy (`NOWAIT` / `SKIP LOCKED`).
- Session A commits. Session B safely detects the change in state and handles the rejection without data corruption.
