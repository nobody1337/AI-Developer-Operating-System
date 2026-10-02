# Workflow: Feature (`feature`)

Status: Governance Definition.

## Trigger

A request for new functionality ([templates/feature.md](../../templates/feature.md)).

## Input

- Feature request with goal, users, acceptance criteria (may be incomplete)

## Classification

- Typically `MEDIUM` risk. Raise to `HIGH`/`CRITICAL` if it touches
  authentication, authorization, migrations, infrastructure, secrets or
  payments ([risk classification](../../governance/policies/risk-classification.md)).
- Domain-heavy features use [frontend](frontend.md), [backend](backend.md) or
  [fullstack](fullstack.md) as refinements.

## Roles

| Step | Role |
|---|---|
| Clarification, classification, plan | `planner` |
| Architecture | `architect` |
| Implementation | `frontend-developer` / `backend-developer` / `database-engineer` / `devops-engineer` |
| Tests | `tester` |
| Code review | `code-reviewer` (independent) |
| Security review | `security-reviewer` (if required) |

## Model Selection

Per step, by capability ([selection policy](../models/selection-policy.md)):

- Planning: a model capable of planning ≥ strong, reasoning ≥ strong, good context handling.
- Implementation: profile by complexity ([escalation](../routing/escalation.md#complexity-based-profiles)).
- Review: `independent_review` profile; for `HIGH`/`CRITICAL` a different model than the author.

## Steps

```text
Feature Request → Clarification → Task Classification → Risk Assessment → Planner
→ Architect → Human Approval (if required) → Developer → Tests → Code Review
→ Security Review (if required) → Human Approval (if required) → Complete
```

1. **Clarification** — resolve ambiguities (`OPEN QUESTION`) → `task_specification`.
2. **Task classification** — [task classification](../routing/task-classification.md).
3. **Risk assessment** — `risk_assessment` for `MEDIUM`+.
4. **Planning** — `implementation_plan` (scope, steps, test analysis, security section).
5. **Architecture** — `architecture_decision` if affected, else "no architecture impact".
6. **Human approval** — plan approval for `HIGH`/`CRITICAL` (`approval_record`).
7. **Implementation** — code + `implementation_report`.
8. **Tests** — `test_report`.
9. **Code review** — `review_report`.
10. **Security review** — `security_report` if required.
11. **Human approval** — merge/completion for `MEDIUM`+.
12. **Complete** — [Definition of Done](../../governance/quality/definition-of-done.md).

## Validation

- Build, lint/type-check and tests executed with real results; `not_run` documented.

## Review

- Per risk level; [checklists/code-review.md](../../checklists/code-review.md).

## Approval

- `HIGH`/`CRITICAL`: plan approval; all `MEDIUM`+: approval before merge.

## Output

- Code, tests, the artifacts above, updated documentation where required.
