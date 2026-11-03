# OOP Course Requirements (Prof. Kutria)

## Overview
- **Team Size**: 2–3 students.
- **Languages Required**: Obligatory use of **both C++ and Java**.
- **Application Type**: Console application with rich domain functionality.
- **Grading Scale**: Total available points = **140 pt**; Maximum final grade = **100 pt**.
- **Deadline**: Final presentation in **January**.

---

## 1. General Assessment Criteria (59 pt)

| Category | Points | Description |
| :--- | :---: | :--- |
| **Presentation** | 10 pt | Live demonstration of a running program, no runtime crashes, clean exit mechanism. |
| **Program Stability** | 10 pt | Absence of unexpected termination, graceful shutdown, robust input parsing. |
| **Project Defense** | 24 pt | Individual ability to explain code, design choices, memory model, and OOP concepts. |
| **Coding Style** | 5 pt | Consistent naming, zero junk/commented-out code, readable self-documenting structure. |
| **File Structure** | 5 pt | Clean header (`.hpp`) and source (`.cpp`) separation in C++; standard package structure in Java. |
| **Version Control** | 10 pt | Meaningful Git commit history, atomic commits, pull requests, collaboration evidence. |
| **UML Diagrams** | 10 pt | Accurate class and sequence diagrams reflecting implemented architecture. |

---

## 2. C++ Technical Requirements (39 pt)

| Requirement | Points | Target Implementation in Project |
| :--- | :---: | :--- |
| **Dynamic Allocation** | 2 pt | Modern smart pointers (`std::unique_ptr`, `std::shared_ptr`) for locker compartments. |
| **Main Program Class** | 2 pt | `LockerStationApplication` coordinator class managing lifecycle and subsystems. |
| **Constructor** | 1 pt | Non-empty constructor initializing hardware configuration, capacity, and credentials. |
| **Destructor** | 1 pt | Explicit RAII cleanup; flushes in-memory transaction logs and safely disconnects. |
| **Encapsulation** | 1 pt | Strict `private` fields; `protected` base members; verified invariants via methods. |
| **Inheritance** | 2 pt | Base `Compartment` inherited by `StandardCompartment`, `RefrigeratedCompartment`, etc. |
| **Virtual Method** | 1 pt | `virtual bool canAccommodate(const Parcel& parcel) const = 0;`. |
| **Polymorphism** | 10 pt | Dynamic dispatch over a collection of polymorphic compartment smart pointers. |
| **Operator Overloading** | 1 pt | `operator<<` for parcel/compartment receipt output; `operator<` for dimension comparison. |
| **Enumeration** | 1 pt | Strongly typed `enum class ParcelStatus`, `enum class CompartmentState`. |
| **File I/O** | 1 pt | `<fstream>` audit log exporter and offline configuration loader. |
| **STL Algorithms** | 1 pt | `std::find_if`, `std::sort`, `std::count_if` for compartment allocation and stats. |
| **Error Handling** | 2 pt | Custom exception hierarchy inheriting from `std::exception` (e.g., `LockerException`). |
| **Generic Template** | 3 pt | Thread-safe generic bounded queue (`SafeQueue<T>`) or generic repository interface. |
| **Unit Tests** | 3 pt | Google Test (`gtest`) test suite testing business rules, validation, and allocators. |
| **Parallel Programming** | 3 pt | `std::thread`, `std::mutex`, `std::condition_variable` simulating concurrent users. |

---

## 3. Java Technical Requirements (42 pt)

| Requirement | Points | Target Implementation in Project |
| :--- | :---: | :--- |
| **Constructor** | 1 pt | Explicit non-empty constructors with parameter validation in domain entities. |
| **Destructor / AutoCloseable** | 1 pt | Implementation of `AutoCloseable` with `close()` method for connection and pool cleanup. |
| **Encapsulation** | 1 pt | Strict private encapsulation with immutable fields (`final`) where applicable. |
| **Inheritance** | 2 pt | Entity and service hierarchies (e.g., notification providers, parcel types). |
| **Interface / Abstract Class**| 1 pt | `LockerAllocationService`, `ParcelRepository`, `NotificationGateway` interfaces. |
| **Overridden Method** | 1 pt | Explicit `@Override` on polymorphic interfaces, `toString()`, `equals()`, `hashCode()`. |
| **Polymorphism** | 10 pt | Service strategy polymorphism (e.g., dispatch strategies, notification channels). |
| **Enumeration** | 1 pt | Java `enum` with methods/fields (e.g., `ParcelSize(maxWeight, maxVolume)`). |
| **File I/O** | 1 pt | Modern `java.nio.file.Files`, `BufferedReader`/`BufferedWriter` for daily report generation. |
| **Collections Framework** | 1 pt | `List`, `Map`, `Set`, Streams API for filtering, grouping, and aggregations. |
| **Error Handling** | 2 pt | Typed domain exceptions (`LockerFullException`, `InvalidPinException`). |
| **Generic Class / Method** | 3 pt | Generic Repository interface (`Repository<T, ID>`) and `Result<T, E>`. |
| **Unit Tests** | 3 pt | JUnit 5 and AssertJ test coverage for domain rules and allocation logic. |
| **Parallel Programming** | 3 pt | `ExecutorService`, `CompletableFuture`, concurrent background notification workers. |
