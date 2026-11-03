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

## 2. Coding Standards by Language

### Modern C++ (`cpp-station-controller/`)
- Standard: **C++20** with Clang/GCC compiler warnings enabled (`-Wall -Wextra -Wpedantic`).
- Separate all classes into `.hpp` (header) and `.cpp` (implementation).
- Memory Management: Zero raw `new` / `delete`. Use `std::make_unique` and `std::make_shared`.
- Concurrency: Standard library primitives (`std::thread`, `std::mutex`, `std::unique_lock`, `std::condition_variable`).
- Naming:
  - Classes/Structs/Enums: `PascalCase` (`LockerStation`, `ParcelSize`).
  - Functions/Methods: `camelCase` (`assignParcel`, `verifyPickupPin`).
  - Member Variables: `snake_case_` with trailing underscore (`compartment_id_`, `door_locked_`).
  - Enums: Strongly typed `enum class`.

### Modern Java (`java-logistics-hub/`)
- Standard: **Java 21** (Maven or Gradle).
- Use `record` for immutable value objects and DTOs.
- Mark fields `final` to guarantee immutability wherever possible.
- Avoid returning `null`; return `java.util.Optional<T>` instead.
- Use `try-with-resources` for all I/O and database sessions (`AutoCloseable`).
- Naming follows standard Java conventions: `camelCase` methods/fields, `PascalCase` classes.

### Database / PostgreSQL (`database/`)
- Schema must be in 3NF with foreign keys and strict integrity check constraints.
- Transactional procedures must handle errors and demonstrate atomic `ROLLBACK`.
- Explicit row-level locks (`SELECT ... FOR UPDATE`) to prevent race conditions during concurrent bookings.

---

## 3. Human Readability & Anti-Spaghetti Rules
- **No Boilerplate Comments**: Never write `// constructor`, `// getter for status`, `// loop through items`.
- **Comment "Why", Not "What"**: Only write comments that explain non-obvious business rules or concurrency invariants.
- **No Dead Code**: Remove all commented-out code, temporary debug logs, or unused imports before finishing a task.

---

## 4. Requirements Directory Map
Detailed guidelines for each subject are organized in the `requirements/` folder:
- [OOP_COURSE_REQUIREMENTS.md](requirements/OOP_COURSE_REQUIREMENTS.md): Breakdown of the 140-point rubric for C++ and Java.
- [DATABASE_COURSE_REQUIREMENTS.md](requirements/DATABASE_COURSE_REQUIREMENTS.md): 8 business rules, central transaction, and 2-session concurrency specs.
- [UNIFIED_ARCHITECTURE_PLAN.md](requirements/UNIFIED_ARCHITECTURE_PLAN.md): Subsystems, responsibilities, and team roadmap.
- [CODE_QUALITY_AND_AGENT_RULES.md](requirements/CODE_QUALITY_AND_AGENT_RULES.md): Deep-dive into architectural principles.
