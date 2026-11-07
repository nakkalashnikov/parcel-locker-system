# Database contract

This is the only interface between the database, the C++ station and the Java hub. See [ADR-0001](../docs/adr/0001-database-as-source-of-truth.md). Shared names are defined in [domain_vocabulary.json](domain_vocabulary.json).

Status: approved direction, not implemented yet. Issue #3 and the issues that follow it build the database to match this document. Change the document first if the implementation needs something different.

## Roles

| Role | Used by | Can |
| :--- | :--- | :--- |
| `locker_owner` | Migrations and database demos | Owns all objects |
| `station_app` | C++ station | Execute station procedures, read station views |
| `hub_app` | Java hub | Execute hub procedures, read hub views |

Application roles have no direct `INSERT`, `UPDATE` or `DELETE` on tables. Procedures run as `SECURITY DEFINER` with a fixed `search_path`.

## Station procedures

| Procedure | Input | Output | Rules |
| :--- | :--- | :--- | :--- |
| `sp_reserve_compartment` | `p_tracking_number`, `p_compartment_id`, `p_courier_id` | none | BR1, BR2, BR4 |
| `sp_deposit_parcel` | `p_tracking_number`, `p_compartment_id`, `p_courier_id`, `p_door_closed_confirmed` | `out_pin_expiry` | BR1-BR4, BR6 |
| `sp_verify_pickup_pin` | `p_tracking_number`, `p_pin` | `out_outcome`, `out_compartment_id` | BR3, BR6 |
| `sp_confirm_pickup` | `p_tracking_number`, `p_door_closed_confirmed` | none | BR6, BR8 |
| `sp_collect_returned_parcel` | `p_tracking_number`, `p_courier_id`, `p_door_closed_confirmed` | none | BR4, BR6 |
| `sp_record_door_event` | `p_compartment_id`, `p_event_type` | none | BR6 |

## Hub procedures

| Procedure | Input | Output | Rules |
| :--- | :--- | :--- | :--- |
| `sp_register_parcel` | Sender, recipient, target station, dimensions, weight, refrigeration flag | `out_tracking_number` | |
| `sp_assign_courier` | `p_tracking_number`, `p_courier_id`, `p_purpose` | none | BR4 |
| `sp_start_transit` | `p_tracking_number`, `p_courier_id` | none | BR4 |
| `sp_redirect_to_fallback` | `p_tracking_number` | `out_fallback_station_id` | BR5 |
| `sp_sweep_expired_parcels` | none | `out_expired_count` | BR7 |
| `sp_release_security_lock` | `p_tracking_number` | none | BR3 |
| `sp_claim_notifications` | `p_batch_size` | Claimed rows | Outbox |
| `sp_complete_notification` | `p_notification_id` | none | Outbox |

## Views

| View | Read by | Shows |
| :--- | :--- | :--- |
| `v_station_compartments` | Station | Compartments of a station, with tier, state and capacity |
| `v_station_parcels` | Station | Parcels expected at or stored in a station, without PIN data |
| `v_station_tier_capacity` | Hub | Free compartments per station and tier |
| `v_parcel_tracking` | Hub | Current status and location of parcels, without PIN data |
| `v_daily_occupancy_rate` | Hub | Occupancy per station and day |
| `v_courier_performance` | Hub | Deliveries and timing per courier |

## Errors

Business failures use `RAISE EXCEPTION` with a code from `error_codes` in the vocabulary as the SQLSTATE. Adapters translate the code into a typed exception and never match on message text:

| Code | C++ | Java |
| :--- | :--- | :--- |
| `LK001` | `CompartmentOccupiedException` | `CompartmentUnavailableException` |
| `LK002` | `DimensionExceededException` | `ParcelDoesNotFitException` |
| `LK003`, `LK004` | `CourierAccessDeniedException` | `CourierAccessDeniedException` |
| `LK005` | `InvalidParcelTransitionException` | `InvalidParcelTransitionException` |
| `LK006` | `HardwareFaultException` | Not applicable |
| `LK007` | Not applicable | `LockerFullException` |
| `LK008` | `ParcelNotFoundException` | `ParcelNotFoundException` |
| `LK009` | Not applicable | Not applicable |

## Behaviour both sides rely on

- **Transactions.** Procedures do not commit. Every application call is its own transaction, and a raised error undoes all of it.
- **Rollback demo.** `sp_deposit_parcel` raises `LK006` when `p_door_closed_confirmed` is false, which undoes the status change, the compartment change, the PIN and the audit row. The demo scripts wrap the call in explicit `BEGIN` and `COMMIT`.
- **Choosing a compartment.** The station picks a candidate through polymorphic `canAccommodate`, then calls `sp_reserve_compartment`. On `LK001` it tries the next candidate. This is the "receive an alternate compartment" case of BR2.
- **Fit.** BR1 is strict: a parcel whose dimension exactly equals the compartment's is rejected, in all three languages.
- **Wrong PIN.** `sp_verify_pickup_pin` returns an outcome and does not raise. A raised error would also undo the failed attempt counter.
- **PIN delivery.** The database generates the PIN and stores only its hash on the parcel. `sp_deposit_parcel` writes the PIN to `notification_outbox` in the same transaction, so a rolled-back deposit never notifies anyone. The station never sees the PIN. `sp_complete_notification` erases it from the outbox after sending.
- **Claiming notifications.** `sp_claim_notifications` uses `FOR UPDATE SKIP LOCKED`, so parallel hub workers never send the same notification twice.

## Schema changes this contract needs

These go into issue #3:

- Add `courier_assignments` with purpose and status, and at most one active assignment per parcel. Remove `parcels.courier_id`. BR7 needs a delivery courier and a return courier for one parcel.
- Add `station_fallbacks`, an associative table of station pairs with their distance. BR5 needs it.
- Add `parcels.requires_refrigeration`. The C++ `Parcel` has this and the table does not.
- Replace `couriers.is_on_duty` with `shift_status`, matching BR4.
- Add `RETURNED` to `parcel_status`. Without it, a returned parcel never leaves its compartment.
- Add `notification_outbox`.
- Make `CREATE TYPE` repeatable, so the schema can be reinstalled from a clean script.

## Open questions

1. What happens to a `SECURITY_LOCKED` parcel that nobody verifies? BR7 only sweeps `STORED_IN_LOCKER`.
2. Does `sp_release_security_lock` issue a new PIN and a new 72 hours, or keep the old expiry?
3. Is `pgcrypto` hashing acceptable for BR3, which says "encrypted"? Hashing is the safer design, but the PIN sits readable in the outbox until it is sent.
4. BR8 mentions a biometric or mobile token. The contract covers only the PIN so far.
