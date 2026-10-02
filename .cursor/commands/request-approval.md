# /request-approval

Prepare a human approval request for a gate or protected action, then stop and wait.

1. Read `governance/policies/human-approval.md`.
2. State exactly: the action or artifact (with version), scope (files, environments, time window),
   risk level, risks, rollback, and any governance conflict with its consequences.
3. Ask a specific yes/no question. Do not proceed on silence or earlier generic consent.
4. After the human answers, fill `templates/approval-record.md` with the decision, approver,
   timestamp and evidence (e.g. "chat message in this session").
5. Proceed only within the approved scope; anything beyond needs a new approval.
