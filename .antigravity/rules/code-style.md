---
description: Code Style, File Limits, Senior DB & Architecture Rules for Parcel Locker Delivery System
globs: ["**/*"]
---

# Antigravity Agent Guidelines

## 1. Absolute Invariants
- **File Length**: Under NO circumstances should any source file exceed 350 lines. Keep files small, modular, and focused.
- **SOLID Design**: Apply Single Responsibility, Interface Segregation, and Dependency Inversion.
- **Cleanliness**: Self-documenting code. Do not add trivial or obvious comments.

## 2. Senior Database Engineering (PostgreSQL)
- SQL Keywords in UPPERCASE (`SELECT`, `INSERT`, `UPDATE`, `BEGIN`, `COMMIT`, `ROLLBACK`).
- Identifiers in `snake_case`. Explicit `AS` for aliases. No single-letter aliases.
- Explicit `JOIN` syntax only. No comma joins in `FROM`.
- Explicit column lists for all `SELECT` and `INSERT` queries (no `SELECT *` in procedures).
- Explicit row-level locking with deterministic order (`SELECT ... FOR UPDATE ORDER BY ...`) to avoid race conditions and deadlocks.
- Scripts must be idempotent (`CREATE TABLE IF NOT EXISTS`, `ON CONFLICT DO NOTHING`).

## 3. C++ Invariants (C++20)
- RAII for all resources.
- `std::unique_ptr` and `std::shared_ptr` instead of raw pointers.
- Split files into `.hpp` and `.cpp`.
- Custom exception types derived from `std::exception`.

## 4. Java Invariants (Java 21)
- Explicit access modifiers.
- Use `record` for immutable data objects.
- Prefer `java.util.Optional<T>` over `null`.
- Try-with-resources for any stream, socket, or DB connection.
