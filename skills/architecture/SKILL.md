---
name: architecture
description: Procedure for analysing architectural impact, comparing options and writing ADRs. Use when a change introduces layers, patterns, frameworks, integrations, breaking API or shared data model changes.
---

# Skill: Architecture

## Purpose

Make architecture decisions explicit, justified by present needs, and consistent
with the existing system.

## When to use

Any change listed in [architecture governance](../../governance/architecture/architecture-governance.md#changes-that-require-an-adr),
or when the impact on module boundaries is unclear.

## Inputs

- Task Specification, Implementation Plan
- Current structure (modules, dependencies), accepted ADRs, constraints

## Procedure

1. **Map the current state** — read the relevant modules and ADRs; describe the
   existing approach in 3–5 sentences (`FACT` only for what you read).
2. **State the forces** — requirements, constraints, quality attributes
   (performance, security, maintainability) that drive the decision.
3. **Generate options** — at least two, including "keep current approach".
4. **Evaluate** — for each: fit with existing architecture, complexity, risk,
   reversibility, migration effort, team familiarity, cost.
5. **Recommend** — one option with reasoning; mark it `RECOMMENDATION`.
6. **Define contracts** — interfaces, data shapes, error semantics, versioning.
7. **Write the ADR** — [templates/adr.md](../../templates/adr.md), status `Proposed`.
8. **Hand to the human** for the decision.

## Outputs

- ADR (`architecture_decision`), contract definitions, plan updates

## Quality criteria

- Decision is traceable to a concrete need.
- Negative consequences are listed.
- Alternatives are genuinely considered, not straw men.
- Consistent with accepted ADRs, or explicitly supersedes one.

## Pitfalls

- Introducing patterns "because best practice" without a present need.
- Designing for hypothetical scale.
- Ignoring migration and operational cost.
- Presenting a recommendation as a decision.

## Related

[checklists/architecture.md](../../checklists/architecture.md) ·
role [architect](../../orchestration/roles/architect.md)
