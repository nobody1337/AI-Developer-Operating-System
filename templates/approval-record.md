---
artifact: approval_record
task_id: TASK-YYYYMMDD-slug
version: 1
status: final
author_role: <role that requested approval>
author_agent: <session id>
author_model: UNKNOWN
risk: <LOW|MEDIUM|HIGH|CRITICAL>
created: YYYY-MM-DD
inputs: [<artifact ids presented for approval>]
handoff_to: <next role>
---

# Approval Record: APR-YYYYMMDD-NNN

Reference: `governance/policies/human-approval.md`

```yaml
approval_id: APR-YYYYMMDD-NNN
task_id: TASK-YYYYMMDD-slug
gate: <plan | implementation | security | release | protected_action | waiver>
decision: <approved | rejected | approved_with_conditions>
approved_action: "<exact action or artifact + version approved>"
scope: "<files, environments, time window>"
risk: <LOW|MEDIUM|HIGH|CRITICAL>
approver: "<human name or handle>"          # never an AI agent
approved_at: <ISO 8601 datetime with offset>
evidence: "<chat message reference, PR approval link, ticket>"
conditions: []
waived_check: null                          # required when gate = waiver
```

## What was presented to the approver

- Action and scope: <…>
- Risks stated: <…>
- Conflicts with governance (if any) and their consequences: <…>

## Notes

<Anything the approver added.>
