# Java logistics hub rules

Java 21. The global rules in the [root AGENTS.md](../AGENTS.md) apply.

The hub orchestrates parcels and couriers, sends notifications and produces reports. It calls the database through the [contract](../contracts/database-api.md).

## Target layout

Existing code moves into this layout in a later pull request.

```text
com.parcellocker
├── domain        entities, value objects, enums, domain exceptions
├── application   use cases such as AssignCourierUseCase
├── port          interfaces the application needs
├── adapter       JDBC implementations and notification channels
└── console       menu commands and the composition root
```

Tests mirror this layout under `src/test/java` and use JUnit 5 with AssertJ. `domain` and `application` must not import `java.sql` or anything from `adapter`. ArchUnit enforces this.

## Language

- Use `record` for immutable value objects and DTOs.
- Mark fields `final` wherever possible.
- Never return `null`. Return `Optional<T>`, or a sealed `Result<T, E>` when failure carries information.
- Use try-with-resources for every `AutoCloseable`.
- Use `@Override` on every overriding method.
- Use streams for readable transformations. Switch to a loop past three pipeline stages.
- Domain failures are typed exceptions, such as `LockerFullException`.
