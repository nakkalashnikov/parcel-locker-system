# ADR-0008: The web UI is a separate project built after the backends

Status: Accepted, implementation deferred

## Context

Prof. Baraban requires a UI. The plan is two pages. An admin page shows all five stations, their parcels, couriers, notification queue and audit trail, and offers the operator actions. A station page shows the machine: a square screen and an animated bank of compartments, so a viewer can see where a parcel goes in and where it comes out. It has demo buttons that close a door or fail a sensor, which lets the rollback be shown from the screen.

The backends do not exist yet. A UI built now would compete for the same people and could not be run against anything real.

## Decision

- The UI lives in `ui/` as its own project: React, Vite and TypeScript, one codebase with two entry points, `admin` and `station`.
- The admin page talks only to the Java hub, and the station page only to the C++ station. Neither page ever talks to the database.
- Each application gets a thin HTTP adapter in its presentation layer, next to the console. It calls the same use cases as the console.
- The UI is built after the backends and the end-to-end scenario work. Until then no backend task changes because of it. The only standing rule is the one from [ADR-0002](0002-hexagonal-layers.md): no business logic in the console layer, so a second front end can reuse the use cases.
- The five stations are five instances of the same station program, started with different station identifiers.
- `contracts/ui-api.md` is written when the UI work starts.

## Why

- A front end that depends on stable HTTP endpoints can be built last without touching anyone else's work.
- The hexagonal layers already make an HTTP adapter just another front end of the same use cases.
- TypeScript turns a drift between the API and the pages into a build error.

## Rejected

- **The UI talking to the database.** It breaks [ADR-0001](0001-database-as-source-of-truth.md), and the browser would need database credentials.
- **Server-rendered pages from Java.** It ties the UI to the hub, and the station page needs the C++ program anyway.
- **Spring or another web framework.** [ADR-0006](0006-design-patterns.md) rejects frameworks that hide the wiring.
- **Next.js.** We have no need for server-side rendering.
- **Building the UI now.** It would slow the critical path of schema, procedures and adapters, and could show nothing real.

## Consequences

- Two small tasks appear later: an HTTP adapter in the hub and one in the station.
- The station needs an embedded HTTP library, added through CMake `FetchContent` so a large third-party file does not enter the repository.
- The demo buttons on the station page send hardware events into the station's event queue, so the page acts as the hardware simulator.
- `AGENTS.md` gains rules for `ui/` when the work starts.
