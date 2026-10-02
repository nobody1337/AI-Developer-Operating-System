# Workflow: Refactoring (`refactoring`)

Status: Governance Definition.

## Trigger

A request to improve structure without changing behaviour, or technical debt
identified in a report.

## Input

- Target area, motivation (concrete problem, not theory), constraints

## Classification

- Local refactoring: `LOW`. Cross-module or public API refactoring: `MEDIUM`+.
  "Large refactoring" is an [escalation trigger](../routing/escalation.md#escalation-triggers).
- Behaviour changes are not refactoring — use [feature](feature.md) or [bugfix](bugfix.md).

## Roles

| Step | Role |
|---|---|
| Scope and plan | `planner`; `architect` if module boundaries change |
| Refactor | developer role of the domain |
| Safety net, verification | `tester` |
| Review | `code-reviewer` |

## Model Selection

- A model capable of refactoring ≥ good, coding ≥ good; context handling ≥ strong for multi-file refactorings.

## Steps

1. **Justify** — name the concrete problem; reject refactoring "for best practice".
2. **Safety net** — ensure tests cover current behaviour; add characterization tests if missing.
3. **Plan small steps** — each step keeps the build and tests green.
4. **Refactor** — one step at a time ([refactoring skill](../../skills/refactoring/SKILL.md)).
5. **Validate after each step** — build + tests.
6. **Review** — diff must show no behaviour change; no unrelated edits.

## Validation

- Same tests pass before and after; no test assertions changed (except
  mechanical renames, which must be listed).

## Review

- Per risk level; reviewer checks behaviour preservation explicitly.

## Approval

- Per risk level; public API refactoring follows [architecture governance](../../governance/architecture/architecture-governance.md).

## Output

- Refactored code, `implementation_report` (steps, validation per step).
