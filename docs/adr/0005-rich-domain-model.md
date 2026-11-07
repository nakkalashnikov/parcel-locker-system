# ADR-0005: Domain objects change through business methods and a transition table

Status: Accepted

## Context

`Parcel::setStatus` in C++ lets any caller move a parcel to any status, so a `DELIVERED` parcel can return to `CREATED`. Every caller would have to remember the rules, which leads to duplicated checks and an anemic model.

## Decision

- Remove `setStatus`. Status changes through methods that name the event: `markDeposited`, `markDelivered`, `lockForSecurity`, `markExpired`.
- Each method checks one transition table, whose content matches `parcel_status_transitions` in the [vocabulary](../../contracts/domain_vocabulary.json).
- An illegal transition throws `InvalidParcelTransitionException` in C++ and the Java equivalent.
- Constructors reject invalid values, so an object that exists is valid.
- Plain data carriers remain acceptable at boundaries, such as Java records used as DTOs.

## Why

- The code reads like the business: `parcel.markDelivered()` says what happened.
- Each rule lives in exactly one place per language.
- The table can be tested exhaustively, every pair of statuses in a few lines.

## Rejected

- **State pattern with a class per status.** Statuses differ only in which transitions they allow, not in behaviour. Seven nearly empty classes would add reading effort with no gain. We would reconsider if statuses gained real behaviour.
- **Validation in a service class.** The object could still be changed without the service, and the model stays anemic.
- **Database checks only.** The domain could hold illegal states between calls, and the graded unit tests would have nothing to test.

## Consequences

- The transition rules exist in three languages, kept equal by the tests from [ADR-0004](0004-shared-domain-vocabulary.md).
- Existing code using `setStatus` must be changed.
