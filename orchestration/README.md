# Orchestration

Status: Governance Definition (manual today). Orchestration describes **how**
work is carried out: roles, workflows, model routing, state and handoffs.
**What** must be true is defined in [governance/](../governance/README.md).

Today there is no orchestrator. The human acts as the orchestrator, with
Cursor commands and rules as aids. The target architecture is described in
[future-orchestrator.md](future-orchestrator.md).

## Contents

| Area | Location |
|---|---|
| Roles (base roles, specialisations) | [roles/](roles/README.md) |
| Models (registry, capabilities, selection, lifecycle, evaluation) | [models/](models/README.md) |
| Routing (task classification, routing policy, escalation) | [routing/task-classification.md](routing/task-classification.md), [routing/routing-policy.md](routing/routing-policy.md), [routing/escalation.md](routing/escalation.md) |
| Workflows | [workflows/](workflows/README.md) |
| State, audit, context packages, handoffs (conceptual) | [state/](state/README.md) |
| Future orchestrator architecture | [future-orchestrator.md](future-orchestrator.md) |

## Orchestration flow

```text
Request → Task Classification → Risk Classification → Role Selection → Model Selection
→ Planning → Architecture → Implementation → Testing → Independent Review
→ Security Review → Human Approval → Completion
```

Not every task passes every step. The risk level determines which steps are
mandatory ([risk classification](../governance/policies/risk-classification.md)):

| Step | `LOW` | `MEDIUM` | `HIGH` | `CRITICAL` |
|---|---|---|---|---|
| Task + risk classification | One line | Yes | Yes | Yes |
| Role + model selection | Implicit | Recommendation | Recommendation | Recommendation |
| Planning | Inline plan | Implementation Plan | Plan + Risk Assessment | Plan + Risk Assessment + rollback |
| Plan approval (human) | — | — | Yes | Yes |
| Architecture | If affected | If affected | If affected (ADR) | If affected (ADR) |
| Implementation | Yes | Yes | After plan approval | Prepare only; execute after explicit approval |
| Testing | Existing tests/build | Unit (+ integration) | Unit + integration + regression (+ security) | As `HIGH` + dry run / staging, rollback |
| Independent review | Optional | Required | Required (different model where available) + human | Required + human |
| Security review | If relevant | If relevant | Required for security areas | Required |
| Human approval to complete | Per project merge rules | Yes (merge) | Yes | Yes |

## Who does what today

| Step | Today (manual) | Future (automated) |
|---|---|---|
| Classification | Agent proposes via `/classify-task`; human confirms | Orchestrator classifier |
| Model selection | Human picks model in the IDE based on the recommendation | Router using the registry |
| Handoff | Human starts next session with artifacts | Orchestrator dispatches agents |
| State | Optional manual state file | Orchestrator-maintained state records |
| Approval | Human in chat / PR review | Approval service with authentication |
