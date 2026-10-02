---
artifact: implementation_report
task_id: TASK-YYYYMMDD-slug
version: 1
status: final
author_role: <developer role id>
author_agent: <session id>
author_model: UNKNOWN
risk: <LOW|MEDIUM|HIGH|CRITICAL>
created: YYYY-MM-DD
inputs: [implementation_plan]
handoff_to: tester
---

# Implementation Report: <title>

## 1. Summary

<What was implemented.>

## 2. Changed files

| File | Change | Plan step |
|---|---|---|
| <path> | added/modified/deleted | <#> |

Out-of-plan changes: <none | list with reason>

## 3. Decisions taken during implementation

- DECISION: <…>

## 4. Validation (real results only)

| Check | Command | Executed | Result |
|---|---|---|---|
| Build | `<command>` | yes/no | passed/failed/not_run |
| Lint / type-check | `<command>` | yes/no | |
| Tests | `<command>` | yes/no | |

VALIDATION: <one-line honest summary>

## 5. Technical debt / known limitations

- <…>

## 6. Risks and open questions

- RISK: <…>
- OPEN QUESTION: <…>

## 7. Gate status

| Gate | Status | Evidence |
|---|---|---|
| implementation | passed/failed/not_run/not_applicable/waived_with_approval | |
