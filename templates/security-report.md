---
artifact: security_report
task_id: TASK-YYYYMMDD-slug
version: 1
status: final
author_role: security-reviewer
author_agent: <session id — independent of the author>
author_model: UNKNOWN
risk: <HIGH|CRITICAL|…>
created: YYYY-MM-DD
inputs: [implementation_plan, implementation_report, test_report]
handoff_to: human
---

# Security Report: <title>

Reference: `governance/security/security-policy.md`, `checklists/security.md`

## 1. Scope and data

- Changed components: <…>
- Data sensitivity: <public|internal|confidential|restricted>
- Trust boundaries crossed: <…>

## 2. Threats considered

| Category | Relevant? | Notes |
|---|---|---|
| Spoofing / authentication | | |
| Tampering / integrity | | |
| Repudiation / audit | | |
| Information disclosure / secrets / personal data | | |
| Denial of service | | |
| Elevation of privilege / authorization | | |
| Injection (SQL, command, template, path) | | |
| Supply chain / dependencies | | |
| AI-specific (prompt injection, unsafe execution, permissions) | | |

## 3. Findings

| # | Severity | Location | Scenario | Remediation |
|---|---|---|---|---|
| 1 | blocker/major/minor/note | | | |

Do not include secret values. Reference locations only.

## 4. Checks performed

| Check | Method | Executed | Result |
|---|---|---|---|
| <e.g. dependency audit> | `<command>` / manual reading | yes/no | |

## 5. Not checked

- <area> — <reason>

## 6. Residual risk

<What remains; requires human acceptance for HIGH/CRITICAL.>

## 7. Gate status

| Gate | Status | Evidence |
|---|---|---|
| security | passed/failed/not_run/not_applicable/waived_with_approval | |
