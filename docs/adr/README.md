# Architecture decisions

Each record states one decision, why we made it and what we rejected. They stop people and agents from reopening settled questions, and they are preparation for the defense.

| ADR | Decision |
| :--- | :--- |
| [0001](0001-database-as-source-of-truth.md) | The database is the source of truth and its procedures are the integration API |
| [0002](0002-hexagonal-layers.md) | Each application uses hexagonal layers |
| [0003](0003-no-comments-in-source-code.md) | Source code contains no comments |
| [0004](0004-shared-domain-vocabulary.md) | Shared names come from one file, checked by contract tests |
| [0005](0005-rich-domain-model.md) | Domain objects change through business methods and a transition table |
| [0006](0006-design-patterns.md) | The patterns we use and the ones we rejected |
| [0007](0007-pull-request-workflow.md) | All work reaches `main` through pull requests |

To change a decision, add a new ADR that replaces the old one and mark the old one `Superseded by ADR-XXXX`.

## Template

```markdown
# ADR-XXXX: Decision as a short sentence

Status: Proposed | Accepted | Superseded by ADR-XXXX

## Context
The problem and the constraints.

## Decision
What we do.

## Why
The reasons this option wins.

## Rejected
Each alternative and why it lost.

## Consequences
What becomes easier, what becomes harder.
```
