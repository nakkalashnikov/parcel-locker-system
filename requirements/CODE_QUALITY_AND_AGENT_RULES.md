# Code Quality & AI Agent Directives

## 1. Prime Directive: "Code is King"
The primary goal of this repository is academic and engineering excellence. The clarity, readability, and structural elegance of the code take precedence over unnecessary feature accumulation.

Any AI agent contributing to this repository MUST strictly follow the directives outlined in this document.

---

## 2. Hard Constraints

1. **Maximum 350 Lines Per File**:
   - Every source file (`.hpp`, `.cpp`, `.java`, `.sql`) MUST NOT exceed 350 lines.
   - If a class or file approaches 300 lines, immediately decompose it by extracting collaborators or sub-components.
2. **One Primary Class Per File**:
   - Each domain entity, service, or controller belongs in its own dedicated file.
3. **Strict SOLID & OOP Principles**:
   - **Single Responsibility (SRP)**: A class has only one reason to change.
   - **Open/Closed (OCP)**: Extend behavior through polymorphism and interfaces, not giant `switch` statements.
   - **Liskov Substitution (LSP)**: Derived classes must remain substitutable for base types without breaking invariants.
   - **Interface Segregation (ISP)**: Create small, focused interfaces.
   - **Dependency Inversion (DIP)**: Depend on abstractions, never on concrete implementations.
4. **No Anemic Domain Models**:
   - Domain objects must encapsulate business invariants and validate their own state.
   - Do NOT create mindless getter/setter dumb data structures for core business logic.

---

## 3. Human-Readable Code Standards

### Naming Conventions
- Names must be descriptive and pronounceable. Avoid abbreviations:
  - Good: `targetCompartment`, `allocationTimestamp`, `customerVerificationToken`
  - Bad: `tc`, `ts`, `tok`, `mgr`, `proc_data`
- Methods must be active verbs or verb phrases:
  - Good: `assignParcel()`, `verifyPin()`, `calculateOptimalRoute()`
  - Bad: `data()`, `handle()`, `doStuff()`
- Boolean methods/variables must read as assertions:
  - Good: `isOccupied()`, `hasAvailableCapacity()`, `canAccommodate()`
  - Bad: `status()`, `flag()`, `check()`

### Comments & Documentation Policy
- **Zero Noise Comments**: Do not write comments that reiterate syntax.
  - FORBIDDEN: `// constructor`, `// getter for id`, `// increment i by 1`
- **Explain Intent ("Why", Not "What")**:
  - ONLY comment to explain critical invariants, mathematical formulas, concurrency ordering (lock order to prevent deadlocks), or domain rationale.
- Use language-native docstrings (`/** ... */` for Java, `///` Doxygen format for C++).

---

## 4. Modern Language Standards

### Modern C++ (C++20)
- **RAII First**: Resources (memory, mutexes, file handles, DB connections) must be strictly managed via RAII.
- **Smart Pointers**: Never use raw `new` or `delete`. Prefer `std::unique_ptr` for exclusive ownership, and `std::shared_ptr` only when ownership is genuinely shared.
- **Header/Source Split**: Declarations go into `.hpp`, definitions go into `.cpp`. Templates remain in `.hpp` or `.inl`.
- **String Views**: Pass read-only strings as `std::string_view` rather than `const std::string&` where appropriate.
- **Exceptions**: Throw domain exceptions derived from `std::runtime_error` or `std::exception`.

### Modern Java (Java 17/21)
- **Records**: Use `record` for immutable Data Transfer Objects (DTOs) and Value Objects.
- **Null Safety**: Avoid returning `null`. Use `java.util.Optional<T>` for optional values.
- **Immutability**: Mark fields `final` wherever possible.
- **Clean Resources**: Always use `try-with-resources` for `AutoCloseable` types.
- **Streams & Lambdas**: Use Java Streams for readable collection transformations, but prefer standard loops if stream logic exceeds 3 pipeline stages.

---

## 5. Agent Workflow & Verification
Before marking any task as complete, an AI agent must verify:
- [ ] No file exceeds 350 lines.
- [ ] Code compiles without warnings.
- [ ] Relevant unit tests exist and pass.
- [ ] No temporary debug print statements remain in production code.
