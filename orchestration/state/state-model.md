# Task State Model

Status: **Conceptual.** No tool maintains these states today. Agents and humans
may maintain a state record manually; a future orchestrator would maintain it
automatically ([future orchestrator](../future-orchestrator.md)).

## Principle

Task state must not exist only in chat messages. Chat history is lost,
truncated or summarised; state lives in a file next to the artifacts.

## States

| State | Meaning |
|---|---|
| `NEW` | Request received, not yet classified |
| `CLASSIFIED` | Task and risk classified, workflow and roles selected |
| `PLANNED` | Implementation Plan exists |
| `APPROVED` | Plan approved by a human (required for `HIGH`/`CRITICAL`) |
| `IMPLEMENTING` | Implementation in progress |
| `TESTING` | Tests being written/executed |
| `REVIEW` | Independent code review in progress |
| `SECURITY_REVIEW` | Security review in progress |
| `WAITING_FOR_HUMAN` | Blocked on a human decision or approval |
| `COMPLETED` | Definition of Done satisfied (or deviations accepted) — terminal |
| `BLOCKED` | Cannot proceed due to an external impediment (missing access, failing environment) |
| `FAILED` | Attempt failed; requires re-planning or cancellation |
| `CANCELLED` | Stopped by the human — terminal |

## Allowed transitions

`H` = requires a human decision; `R` = only for the stated risk levels.

| From | To | Condition |
|---|---|---|
| `NEW` | `CLASSIFIED` | Classification recorded |
| `NEW`, any non-terminal | `CANCELLED` | **H** |
| `CLASSIFIED` | `PLANNED` | Plan written (inline plan counts for `LOW`) |
| `CLASSIFIED` | `IMPLEMENTING` | **R** `LOW` only, inline plan stated |
| `PLANNED` | `IMPLEMENTING` | **R** `LOW`/`MEDIUM` |
| `PLANNED` | `WAITING_FOR_HUMAN` | Plan approval requested (`HIGH`/`CRITICAL`) |
| `WAITING_FOR_HUMAN` | `APPROVED` | **H** plan approved (Approval Record) |
| `WAITING_FOR_HUMAN` | `PLANNED`, `IMPLEMENTING`, `TESTING`, `REVIEW`, `COMPLETED` | **H** per decision |
| `APPROVED` | `IMPLEMENTING` | — |
| `IMPLEMENTING` | `TESTING` | Implementation done |
| `TESTING` | `IMPLEMENTING` | Tests reveal defects |
| `TESTING` | `REVIEW` | Tests executed (or `not_run` documented) |
| `TESTING` | `COMPLETED` | **R** `LOW` only, Definition of Done satisfied |
| `REVIEW` | `IMPLEMENTING` | `request_changes` |
| `REVIEW`, `SECURITY_REVIEW` | `COMPLETED` | **R** `LOW` only, review passed, Definition of Done satisfied |
| `REVIEW` | `SECURITY_REVIEW` | Security review required |
| `REVIEW`, `SECURITY_REVIEW` | `WAITING_FOR_HUMAN` | Approval/merge decision needed (`MEDIUM`+) |
| `SECURITY_REVIEW` | `IMPLEMENTING` | Findings to fix |
| any active state | `WAITING_FOR_HUMAN` | Escalation, protected action, material conflict |
| any active state | `BLOCKED` | External impediment |
| `BLOCKED` | previous state | Impediment resolved |
| any active state | `FAILED` | Attempt failed |
| `FAILED` | `CLASSIFIED`, `PLANNED` | Re-plan (re-classify if scope changed) |

Rules:

- `COMPLETED` for `MEDIUM`+ risk is reached only from `WAITING_FOR_HUMAN`
  via a human decision.
- Agents never move a task to `APPROVED` or out of `WAITING_FOR_HUMAN` themselves.
- Raising risk during a task may require going back to `PLANNED`.

## State record

Schema: [task-state.schema.yaml](task-state.schema.yaml);
example: [task-state.example.yaml](task-state.example.yaml).

Proposed location in a consuming project: `.ai-dos/tasks/<task-id>/state.yaml`
next to the task's artifacts. Inside this repository, runtime records belong in
`orchestration/state/runtime/` (git-ignored). Whether projects commit task
records is an open question ([ADR-000](../../governance/decisions/000-initial-ai-dos-architecture.md)).
