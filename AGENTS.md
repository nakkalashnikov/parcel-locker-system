# AGENTS.md

This file is the single source of engineering rules for the Transactional Parcel Locker Delivery System. It applies to people and to every AI agent. Do not copy these rules into other files; link to them.

Read before changing anything:

1. This file.
2. The `AGENTS.md` of the subsystem you are changing: [database](database/AGENTS.md), [C++](cpp-station-controller/AGENTS.md), [Java](java-logistics-hub/AGENTS.md).
3. The [architecture decisions](docs/adr/README.md) that touch your change.
4. The [database contract](contracts/database-api.md) if your change crosses a subsystem boundary.

The goal is showcase code: a student who has never seen this repository must be able to read it, explain it and defend it. Clarity beats feature count.

## Repository map

| Path | Contents |
| :--- | :--- |
| `contracts/` | What the subsystems promise each other: procedures, views, roles, errors, vocabulary |
| `database/` | PostgreSQL schema, procedures, triggers, views, demos |
| `cpp-station-controller/` | C++20 edge terminal and hardware simulator |
| `java-logistics-hub/` | Java 21 logistics and notification hub |
| `docs/adr/` | Architecture decisions with their reasons and rejected alternatives |
| `requirements/` | Course rubrics and the team plan |

## Invariants

1. **No comments in source code.** No `//`, `/* */`, `--`, `#` comments, docstrings, header blocks or TODOs in `.hpp`, `.cpp`, `.java` or `.sql` files. Intent lives in names, tests and ADRs. See [ADR-0003](docs/adr/0003-no-comments-in-source-code.md).
2. **Under 350 lines per file.** At 300 lines, split the file by responsibility.
3. **One primary class per file.**
4. **Subsystems talk only through the database contract.** C++ and Java never call each other and never touch tables directly. See [ADR-0001](docs/adr/0001-database-as-source-of-truth.md).
5. **Dependencies point inward.** Domain code knows nothing about the database, the console or the network. See [ADR-0002](docs/adr/0002-hexagonal-layers.md).
6. **No setters for business state.** Objects change through methods that name the business event and enforce their own rules. See [ADR-0005](docs/adr/0005-rich-domain-model.md).
7. **Shared names come from one file.** Statuses, states, tiers and error codes are defined in [`contracts/domain_vocabulary.json`](contracts/domain_vocabulary.json). See [ADR-0004](docs/adr/0004-shared-domain-vocabulary.md).

## Design rules

- Use a pattern only when it solves a problem this code actually has. [ADR-0006](docs/adr/0006-design-patterns.md) lists what we use and what we rejected. Propose a new ADR before adding another pattern.
- Extend behaviour through polymorphism, not through a growing `switch` on a type.
- Depend on small interfaces. Build concrete objects in one composition root per application.
- No singletons, global state or dependency injection frameworks.

## Naming

- Names are descriptive and pronounceable, without abbreviations: `targetCompartment`, not `tc`.
- Methods are verb phrases: `assignParcel`, `verifyPin`. Never `handle`, `process`, `doStuff`.
- Booleans read as assertions: `isOccupied`, `hasAvailableCapacity`, `canAccommodate`.
- Avoid classes named `Manager`, `Helper` or `Utils`. They hide what the class is responsible for.

## Workflow

See [ADR-0007](docs/adr/0007-pull-request-workflow.md).

1. Work from a GitHub issue that states scope and acceptance criteria.
2. Branch from `main`. Never commit to `main` directly.
3. Make small commits that each do one thing, in the form `type(scope): summary`.
4. Open a pull request from your own account, using the template.
5. Another team member reviews. You must be able to explain every line, including lines written by an agent.

## Definition of done

- [ ] All invariants hold.
- [ ] The code builds without warnings.
- [ ] Tests exist for the new behaviour and pass.
- [ ] No debug output is left in production code.
- [ ] Any new architectural decision has an ADR.
- [ ] Agents report what they actually ran and what they could not verify.
