# ADR-0002: Each application uses hexagonal layers

Status: Accepted

## Context

The rubric asks for rich object-oriented domains with unit tests in both languages. Agents write most of the code, so they need an unambiguous answer to "where does this go?". Without one, database calls end up inside domain classes and console code.

## Decision

Both applications use the same four layers. Dependencies point only in the direction of the arrows.

```text
console  ->  application  ->  domain
                  |
                  v
                ports  <-  adapters  ->  database
```

| Layer | Responsibility | May depend on |
| :--- | :--- | :--- |
| `domain` | Business objects and their rules | Nothing else in the project |
| `application` | One class per use case, coordinating domain and ports | `domain`, `ports` |
| `ports` | Interfaces the application needs from the outside world | `domain` |
| `adapters` | libpqxx, JDBC, simulated sensors, notification channels | `ports`, `domain` |
| `console` | Menu, input parsing, output, composition root | All layers |

The build enforces this: separate CMake targets in C++, ArchUnit tests in Java.

## Why

- Domain and use cases can be tested without a running database, which makes the graded test suites fast and simple.
- Replacing a real sensor with a simulated one needs only a new adapter.
- The rule is simple enough for an agent to follow and for a tool to check.
- The same structure in both languages means learning it once.

## Rejected

- **Classic layered architecture.** The domain depends on the database layer, so it tends to become plain data with logic in services, the anemic model our rules forbid.
- **Full domain-driven design with aggregates and domain events.** Too much ceremony for this size, and more concepts for a student team to defend.
- **Microservices.** Nothing here needs independent deployment or scaling.
- **No structure, one package per feature only.** Nothing would stop the console from calling SQL.

## Consequences

- A small feature touches several files. In exchange, each file has one clear job.
- Some simple read paths feel over-structured. We accept this for consistency.
