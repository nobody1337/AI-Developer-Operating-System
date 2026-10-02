---
artifact: risk_assessment
task_id: TASK-YYYYMMDD-slug
version: 1
status: draft
author_role: planner
author_agent: <session id or human:name>
author_model: UNKNOWN
risk: <LOW|MEDIUM|HIGH|CRITICAL>
created: YYYY-MM-DD
inputs: [task_specification]
handoff_to: <role id or human>
---

# Risk Assessment: <title>

Reference: `governance/policies/risk-classification.md`

## 1. Risk level

**<LOW|MEDIUM|HIGH|CRITICAL>** — highest applicable level; when unsure, higher.

| Change type present | Level it implies |
|---|---|
| <e.g. authorization check change> | HIGH |

## 2. Data sensitivity

<public|internal|confidential|restricted> — <reason>

## 3. Risks

| # | Risk | Likelihood | Impact | Mitigation | Owner |
|---|---|---|---|---|---|
| 1 | <…> | low/medium/high | low/medium/high | <…> | <role/human> |

## 4. Protected actions required

- [ ] none
- [ ] <action> — approval required (`governance/policies/human-approval.md`)

## 5. Required controls

| Control | Required? | Notes |
|---|---|---|
| Plan approval | yes/no | |
| Independent review (different model) | yes/no | |
| Security review | yes/no | |
| Rollback plan | yes/no | |

## 6. Rollback / recovery

<How to undo the change; what is irreversible.>

## 7. Open questions

- OPEN QUESTION: <…>
