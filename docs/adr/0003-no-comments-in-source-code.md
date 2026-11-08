# ADR-0003: Source code contains no comments

Status: Accepted

## Context

The rule files disagreed: one banned all comments, another allowed them for intent and required docstrings. The rubric penalizes junk and commented-out code. Agents tend to generate comments that repeat the code and go stale.

## Decision

`.hpp`, `.cpp`, `.java` and `.sql` files contain no comments or docstrings. Knowledge that a comment would have carried goes here instead:

| Knowledge | Where it goes |
| :--- | :--- |
| What the code does | Names of classes, methods and variables |
| An expected behaviour or edge case | A named test |
| Why it is built this way | An ADR |
| Lock ordering and other cross-file rules | A subsystem `AGENTS.md` or an ADR |
| A complex expression | An extracted, well-named function or constant |

A script in CI will enforce the rule.

## Why

- A clear rule needs no judgement, so agents and tools can apply it consistently.
- Names and tests are checked or exercised by the build. Comments are not.

## Rejected

- **Comments only for "why".** Reasonable in many teams, but agents use the exception as permission and the line is hard to check automatically.
- **Docstrings on public APIs.** This project is not a published library, and the docstrings would mostly repeat the signatures.

## Consequences

- Hard parts need more care, because no comment can rescue a confusing name.
- A reader must sometimes open an ADR to learn why. Each subsystem `AGENTS.md` and the ADR index point the way.
