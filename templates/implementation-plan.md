---
artifact: implementation_plan
task_id: TASK-YYYYMMDD-slug
version: 1
status: draft
author_role: planner
author_agent: <session id or human:name>
author_model: UNKNOWN
risk: <LOW|MEDIUM|HIGH|CRITICAL>
created: YYYY-MM-DD
inputs: [task_specification, risk_assessment]
handoff_to: <architect | developer role>
---

# Implementation Plan: <title>

## 1. Summary

<What will be done, in 2–4 sentences.>

## 2. Current state (inspected)

- FACT: <what was read and found>

## 3. Architecture impact

<None (reason) | see ADR-NNN | contract changes>

## 4. Steps

| # | Step | Files (change/read) | Role | Validation |
|---|---|---|---|---|
| 1 | <…> | <path (change)> | <role id> | <command/check> |

Files not listed are out of scope.

## 5. Security

<Trust boundaries, authn/authz, input handling, data sensitivity, secrets —
or "no security-relevant aspects identified" with reason.>

## 6. Test analysis

1. Existing tests: <…>
2. Tests to adapt (and why): <…>
3. New tests: <…>
4. Edge cases: <…>
5. Regression risk: <…>

## 7. Dependencies

<None | proposed dependency with verification (`checklists/dependency.md`)>

## 8. Routing recommendation

```yaml
- step: implementation
  role: <role id>
  profile: <fast_implementation|strong_reasoning|advanced_reasoning>
  required_capabilities: { <capability>: <level> }
  model: UNKNOWN   # selected by human
```

## 9. Rollback

<How to revert. Required for CRITICAL.>

## 10. Approval

- Required: <yes (HIGH/CRITICAL) | no>
- Approval Record: <APR-… or pending>

## 11. Assumptions, risks, open questions

- ASSUMPTION: <…>
- RISK: <…>
- OPEN QUESTION: <…>
