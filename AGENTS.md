# AGENTS.md — Global AI Assistant Directives

Welcome, AI Agent! You are working on the **Transactional Parcel Locker Delivery System**.
This repository has strict engineering standards.

Please read and adhere to all instructions below before writing or modifying any code.

---

## 1. Absolute Invariants

1. **ZERO Comments in Code**:
   - STRICTLY FORBIDDEN to write any comments in code files (`//`, `/* */`, `--`).
   - The code must be self-documenting through crystal-clear class, method, and variable names.
   - Do NOT add docstrings, header blocks, inline explanations, or todo comments. Write pure, clean code only.
2. **File Length Limit**:
   - Strictly **under 350 lines per file**. If a file exceeds 300 lines, refactor by splitting into cohesive sub-classes or helper modules.
3. **Namespace Rule (`using namespace std;`)**:
   - `using namespace std;` IS ALLOWED and permitted in `.cpp` files.
   - STRICTLY FORBIDDEN to write `using namespace std;` in header files (`.hpp`).

---

## 2. Language Standards

### Modern C++ (`cpp-station-controller/`)
- Standard: **C++20**.
- Separate classes into `.hpp` (declarations) and `.cpp` (implementation).
- `using namespace std;` is permitted in `.cpp` files only. Never in `.hpp`.
- Memory Management: Zero raw `new` / `delete`. Use `std::make_unique` and `std::make_shared`.
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

### Database / PostgreSQL (`database/`)
- Schema in 3NF with foreign keys and integrity check constraints.
- SQL Keywords in UPPERCASE (`SELECT`, `INSERT`, `UPDATE`, `BEGIN`, `COMMIT`, `ROLLBACK`).
- Identifiers in `snake_case`.
- Explicit row-level locking (`SELECT ... FOR UPDATE`) to prevent race conditions during concurrent bookings.

---

## 3. Requirements Directory Map
- [OOP_COURSE_REQUIREMENTS.md](requirements/OOP_COURSE_REQUIREMENTS.md): 140-point rubric for C++ and Java.
- [DATABASE_COURSE_REQUIREMENTS.md](requirements/DATABASE_COURSE_REQUIREMENTS.md): 8 business rules, central transaction, and concurrency specs.
- [UNIFIED_ARCHITECTURE_PLAN.md](requirements/UNIFIED_ARCHITECTURE_PLAN.md): Subsystems, responsibilities, and team roadmap.
