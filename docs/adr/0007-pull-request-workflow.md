# ADR-0007: All work reaches `main` through pull requests

Status: Accepted

## Context

Version control is worth 10 points and looks for collaboration evidence, while the defense is worth 24 points and is individual. So far, everything has been committed directly to `main`. Agents can produce a lot of code that nobody on the team has really read.

## Decision

- Every change reaches `main` through a pull request linked to an issue.
- Each person runs their own agents and opens pull requests from their own account.
- Another team member reviews. The lead reviews anything that changes a contract, an ADR or a rule file.
- The author explains the design in their own words in the pull request.
- Checks in CI must pass once CI exists. Guardrails come before large amounts of generated code.
- Each subsystem gets one exemplary vertical slice, reviewed by a person, before agents build the rest from it.

## Why

- History shows who did what, which is the evidence the rubric asks for.
- Explaining and reviewing force people to understand agent-written code before the defense.
- Agents copy existing code, so the first example sets the standard for everything after it.

## Rejected

- **Trunk-based commits to `main`.** Fast, but leaves no review evidence and lets mistakes spread.
- **The lead's agents writing everything.** Quick at first, but three people would then have nothing to defend.

## Consequences

- Work waits for reviews, so keep pull requests small.
- `main` should be protected in the GitHub settings. The lead decides when to enable this.
