# C++ station controller rules

C++20. The global rules in the [root AGENTS.md](../AGENTS.md) apply.

The station controls compartment hardware and calls the database through the [contract](../contracts/database-api.md). It owns doors, sensors and how each compartment type behaves.

## Target layout

Existing code moves into this layout in a later pull request.

```text
include/ and src/
├── domain/        Parcel, Compartment hierarchy, Dimensions, enums, exceptions
├── application/   use cases such as DepositParcelUseCase
├── ports/         interfaces the application needs, such as StationGateway
├── adapters/      libpqxx implementations of ports, simulated sensors
├── console/       menu commands
└── concurrency/   SafeQueue and worker threads
tests/             Google Test suites
```

`domain` and `application` must compile without libpqxx. CMake enforces this through separate targets.

## Language

- Declarations go in `.hpp`, definitions in `.cpp`. Only templates and `constexpr` functions stay in headers.
- `using namespace std;` is allowed in `.cpp` files and forbidden in `.hpp` files.
- Manage every resource with RAII. No raw `new` or `delete`.
- Use `std::unique_ptr` by default, and `std::shared_ptr` only for ownership that is really shared.
- Pass read-only strings as `std::string_view` when the callee does not store them.
- Use standard library concurrency: `std::thread`, `std::mutex`, `std::unique_lock`, `std::condition_variable`.
- Exceptions derive from `LockerException`.

## Naming

- Classes, structs and enums use `PascalCase`, and enums are always `enum class`.
- Functions and methods use `camelCase`.
- Member variables use `snake_case_` with a trailing underscore.
