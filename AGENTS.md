# AGENTS.md — Global AI Assistant Directives

Welcome, AI Agent! You are working on the **Transactional Parcel Locker Delivery System**.
This repository has strict engineering standards designed for university project defense (OOP + Databases).

Please read and adhere to all instructions below before writing or modifying any code.

---

## 1. Prime Constraints
- **File Length Limit**: Strictly **under 350 lines per file**. If a file exceeds 300 lines, refactor by splitting into cohesive sub-classes or helper modules.
- **Languages**: 
  - **C++ (C++20)**: Located in `cpp-station-controller/`.
  - **Java (Java 21)**: Located in `java-logistics-hub/`.
  - **PostgreSQL / SQL**: Located in `database/`.
- **Architectural Style**: Clean Architecture, strict SOLID principles, rich domain model (no anemic getter/setter objects).

---

## 2. Senior Database Engineering Rules (PostgreSQL)

When writing or modifying SQL, DDL, DML, or PL/pgSQL stored procedures:
1. **Formatting & Casing**:
   - SQL Keywords in **UPPERCASE** (`SELECT`, `INSERT`, `UPDATE`, `BEGIN`, `COMMIT`, `ROLLBACK`).
   - Identifiers (tables, columns, functions) in **snake_case** (`compartment_id`, `audit_event_log`).
   - Explicit `AS` keyword for aliases. No single-letter aliases (`c`, `p`); use meaningful abbreviations (`cmp`, `prc`).
   - Always specify explicit column lists in `SELECT` and `INSERT`. Never use `SELECT *` in procedures.
   - Always use explicit `JOIN` syntax (`INNER JOIN`, `LEFT JOIN`). Never use comma joins in `FROM`.
2. **Transaction Management & ACID**:
   - Keep transactions short: perform heavy computation outside the transaction block.
   - PL/pgSQL procedures must have explicit `EXCEPTION` handlers and record failures in `audit_event_log`.
   - Always provide dedicated demo scripts for both successful `COMMIT` and deliberate `ROLLBACK`.
3. **Concurrency & Deadlock Prevention**:
   - Prevent lost updates: Never "read-then-write" without row locks or atomic updates.
   - Use pessimistic row locking: `SELECT ... FOR UPDATE` (or `FOR UPDATE NOWAIT` / `SKIP LOCKED`).
   - **Lock Ordering**: If locking multiple rows, always enforce a deterministic lock order (e.g. `ORDER BY compartment_id`) to mathematically prevent deadlocks.
4. **Idempotency**:
   - All migration and seed scripts must be idempotent (`CREATE TABLE IF NOT EXISTS`, `ON CONFLICT DO NOTHING`).

---

## 3. Modern Language Standards

### Modern C++ (`cpp-station-controller/`)
- Standard: **C++20** with warnings enabled (`-Wall -Wextra -Wpedantic`).
- Separate all classes into `.hpp` (header) and `.cpp` (implementation).
- Memory Management: Zero raw `new` / `delete`. Use `std::make_unique` and `std::make_shared`.
- Namespace Hygiene: STRICTLY FORBIDDEN to write `using namespace std;` (especially in headers). Always use explicit `std::` (`std::make_unique`, `std::vector`, `std::string_view`). Rationale: Prevents namespace pollution, identifier collisions (e.g., `count`, `size`, `byte`), and satisfies senior academic grading standards. Inside local `.cpp` function bodies, selective symbol imports (e.g., `using std::make_unique;`) are permitted if agreed by team.
- Concurrency: Standard library primitives (`std::thread`, `std::mutex`, `std::unique_lock`, `std::condition_variable`).
- Naming:
  - Classes/Structs/Enums: `PascalCase` (`LockerStation`, `ParcelSize`).
  - Functions/Methods: `camelCase` (`assignParcel`, `verifyPickupPin`).
  - Member Variables: `snake_case_` with trailing underscore (`compartment_id_`, `door_locked_`).
  - Enums: Strongly typed `enum class`.

### Modern Java (`java-logistics-hub/`)
- Standard: **Java 21**.
- Use `record` for immutable value objects and DTOs.
- Mark fields `final` to guarantee immutability wherever possible.
- Avoid returning `null`; return `java.util.Optional<T>` instead.
- Use `try-with-resources` for all I/O and database sessions (`AutoCloseable`).
- Naming follows standard Java conventions: `camelCase` methods/fields, `PascalCase` classes.

---

## 4. Human Readability & Anti-Spaghetti Rules
- **No Boilerplate Comments**: Never write `// constructor`, `// getter for status`, `// loop through items`.
- **Comment "Why", Not "What"**: Only write comments that explain non-obvious business rules or concurrency invariants.
- **No Dead Code**: Remove all commented-out code, temporary debug logs, or unused imports before finishing a task.

---

## 5. Requirements Directory Map
- [OOP_COURSE_REQUIREMENTS.md](requirements/OOP_COURSE_REQUIREMENTS.md): 140-point rubric for C++ and Java.
- [DATABASE_COURSE_REQUIREMENTS.md](requirements/DATABASE_COURSE_REQUIREMENTS.md): 8 business rules, central transaction, and concurrency specs.
- [UNIFIED_ARCHITECTURE_PLAN.md](requirements/UNIFIED_ARCHITECTURE_PLAN.md): Subsystems, responsibilities, and team roadmap.
- [CODE_QUALITY_AND_AGENT_RULES.md](requirements/CODE_QUALITY_AND_AGENT_RULES.md): Deep-dive into architectural principles.
