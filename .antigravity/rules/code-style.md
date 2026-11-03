---
description: Code Style, File Limits and Architecture Rules for Parcel Locker Delivery System
globs: ["**/*"]
---

# Antigravity Agent Guidelines

## 1. Absolute Invariants
- **File Length**: Under NO circumstances should any source file exceed 350 lines. Keep files small, modular, and focused.
- **SOLID Design**: Apply Single Responsibility, Interface Segregation, and Dependency Inversion.
- **Languages**: C++20 (`cpp-station-controller/`) and Java 21 (`java-logistics-hub/`).
- **Cleanliness**: Self-documenting code. Do not add trivial or obvious comments.

## 2. C++ Invariants
- RAII for all resources.
- `std::unique_ptr` and `std::shared_ptr` instead of raw pointers.
- Split files into `.hpp` and `.cpp`.
- Custom exception types derived from `std::exception`.

## 3. Java Invariants
- Explicit access modifiers.
- Use `record` for immutable data objects.
- Prefer `java.util.Optional<T>` over `null`.
- Try-with-resources for any stream, socket, or DB connection.

## 4. Documentation
See `requirements/` directory for full specifications on course rubrics, database rules, and architecture.
