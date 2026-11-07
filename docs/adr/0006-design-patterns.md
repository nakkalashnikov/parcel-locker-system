# ADR-0006: The patterns we use and the ones we rejected

Status: Accepted

## Context

Polymorphism is worth 10 points in each language, and the rubric rewards visible design. Agents also tend to add patterns that look impressive but do not solve a real problem. We need a closed list.

## Decision

Use these patterns, in these places:

| Pattern | Where | Problem it solves |
| :--- | :--- | :--- |
| Inheritance with Template Method (non-virtual interface) | C++ `Compartment` and its subclasses | Door and state logic stays in one base class; each subclass adds only what differs |
| Strategy | C++ compartment allocation, Java dispatch and notification channels | Swap a policy without changing its callers, and test it alone |
| Producer-Consumer | C++ sensor events through `SafeQueue` | Sensors never block the user interface |
| Command | Console menus in both languages | Each menu action is a class, so no giant `switch` |
| Composition Root | Application startup in both languages | All wiring is visible in one place; no hidden dependencies |
| Repository | Java read access | Generic data access behind an interface, without SQL in use cases |
| Port and Adapter | Both applications, see [ADR-0002](0002-hexagonal-layers.md) | Application code does not depend on libpqxx or JDBC |
| Result type | Java, sealed `Result<T, E>` | Expected failures are visible in the signature |
| Transition table | Parcel status, see [ADR-0005](0005-rich-domain-model.md) | One place for lifecycle rules |
| Transactional Outbox | Database notifications, see [ADR-0001](0001-database-as-source-of-truth.md) | A notification exists only if its transaction committed |

The compartment classes map to tiers as follows: `StandardCompartment` for `SMALL` and `MEDIUM`, `OversizedCompartment` for `LARGE`, `RefrigeratedCompartment` for `REFRIGERATED`.

The generic Java `Repository<T, ID>` is read-only. A state change goes through a narrow port with a method named after the business action, because it must call a contract procedure. A generic `save` or `deleteById` would suggest direct table writes, which [ADR-0001](0001-database-as-source-of-truth.md) forbids.

## Rejected

| Pattern or tool | Why not |
| :--- | :--- |
| Singleton | Hides dependencies and makes tests share state |
| Service Locator | Same problem as Singleton, with extra steps |
| Spring or another DI framework | Wiring becomes invisible, and the rubric asks us to show and explain our own object design |
| Hibernate or another ORM | Conflicts with procedures as the API, and hides the SQL the database course grades |
| State pattern per status | See [ADR-0005](0005-rich-domain-model.md) |
| CQRS and event sourcing | They solve scale and history problems we do not have. The audit log already covers traceability |
| Abstract Factory, Visitor | No varying family of products and no stable structure to visit |

## Consequences

- A new pattern needs a new ADR, which keeps the design defensible.
- Team members must be able to explain each listed pattern, using its place in our code as the example.
