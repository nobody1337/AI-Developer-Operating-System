# Observability and Audit Model

Status: **Conceptual.** Nothing records audit events automatically today. Until
an orchestrator exists, the equivalent information is captured manually in the
artifacts (Implementation Report, Test Report, Review Report, Approval Record)
and in git history.

## What must be traceable

| Question | Field |
|---|---|
| Which agent acted? | `actor.agent_id` (session or agent identifier) |
| In which role? | `actor.role` |
| With which model? | `actor.model_id` (registry id) or `UNKNOWN`; `actor.model_selected_by` |
| Under which rules? | `active_rules` (rule files / governance docs in force) |
| What changed? | `changed_files` |
| What was executed? | `commands` (command, exit code, actually executed: true/false) |
| Which tests ran, with what result? | `tests` |
| Which reviews happened? | `reviews` (artifact refs, reviewer independence) |
| Which gates were passed? | `gates` (gate id, status, evidence) |
| Which approvals were given? | `approvals` (Approval Record ids) |

## Audit event types

`state_transition`, `classification`, `routing_recommendation`,
`artifact_created`, `artifact_updated`, `command_executed`, `test_executed`,
`gate_evaluated`, `escalation`, `approval_requested`, `approval_recorded`,
`protected_action_executed`, `injection_suspected`.

## Honesty constraints

- An event is recorded only for things that actually happened.
- `commands[].executed: false` is used for commands that were proposed but not run.
- `model_id: UNKNOWN` is correct when the agent does not reliably know its model.

Schema: [audit-record.schema.yaml](audit-record.schema.yaml).
