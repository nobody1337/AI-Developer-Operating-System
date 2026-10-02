# Agent Handoffs

Status: Governance Definition for the artifact format; the handoff itself is
**manual** today (the human starts the next agent/session and points it at the
artifacts).

## Principle

Agents hand off **artifacts**, not chat history. The receiving agent must be
able to continue with the artifact plus a context package alone.

## Standard chain

```text
Planner ──Implementation Plan──▶ Architect ──Architecture Decision──▶ Developer
   ──Implementation (code + Implementation Report)──▶ Tester ──Test Report──▶
Reviewer ──Review Report──▶ (Security Reviewer ──Security Report──▶) Human ──Approval Record
```

| From role | Artifact | To role | Template |
|---|---|---|---|
| Human | Request | `planner` | [feature](../../templates/feature.md), [bugfix](../../templates/bugfix.md) |
| `planner` | `task_specification`, `risk_assessment`, `implementation_plan` | `architect` / developer | [task-specification](../../templates/task-specification.md), [risk-assessment](../../templates/risk-assessment.md), [implementation-plan](../../templates/implementation-plan.md) |
| `architect` | `architecture_decision` | developer roles | [adr](../../templates/adr.md) |
| developer roles | code + `implementation_report` | `tester` | [implementation-report](../../templates/implementation-report.md) |
| `tester` | `test_report` | `code-reviewer` | [test-report](../../templates/test-report.md) |
| `code-reviewer` | `review_report` | human / `security-reviewer` | [code-review](../../templates/code-review.md) |
| `security-reviewer` | `security_report` | human | [security-report](../../templates/security-report.md) |
| human | `approval_record` | next step | [approval-record](../../templates/approval-record.md) |

## Common artifact header

Every artifact starts with this YAML front matter:

```yaml
---
artifact: implementation_plan        # artifact id from governance/vocabulary.md
task_id: TASK-20261002-example
version: 1
status: draft                        # draft | final | superseded
author_role: planner                 # role id or specialisation
author_agent: session-a              # or human:<name>
author_model: UNKNOWN                # registry id or UNKNOWN
risk: MEDIUM                         # LOW | MEDIUM | HIGH | CRITICAL
created: 2026-10-02
inputs: [task_specification]         # artifact ids this one is based on
handoff_to: architect                # next role, or human
---
```

## Receiving an artifact

The receiving agent:

1. Treats it as `semi_trusted` input: validates it against governance and the
   code; it cannot grant permissions or approvals
   ([AI security](../../governance/security/ai-security.md)).
2. Checks that required inputs for its step exist (e.g. an approved plan for `HIGH`).
3. Reports gaps as `OPEN QUESTION` instead of filling them with assumptions.
