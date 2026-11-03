---
description: Code Style, File Limits, Zero Comments and Architecture Rules
globs: ["**/*"]
---

# Antigravity Agent Guidelines

## 1. Absolute Invariants
- **ZERO Comments in Code**: Do not write any comments (`//`, `/* */`, `--`). Code must be 100% self-documenting.
- **File Length**: Under NO circumstances should any source file exceed 350 lines.
- **Namespace Rule**: `using namespace std;` IS ALLOWED in `.cpp` files. NEVER in `.hpp` files.
- **SOLID Design**: Apply Single Responsibility, Interface Segregation, and Dependency Inversion.

## 2. C++ Invariants (C++20)
- RAII for all resources.
- `std::unique_ptr` and `std::shared_ptr` instead of raw pointers.
- Split files into `.hpp` and `.cpp`.
- Custom exception types derived from `std::exception`.

## 3. Java Invariants (Java 21)
- Explicit access modifiers.
- Use `record` for immutable data objects.
- Prefer `java.util.Optional<T>` over `null`.
- Try-with-resources for any stream, socket, or DB connection.
