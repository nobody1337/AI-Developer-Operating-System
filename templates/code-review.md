---
artifact: review_report
task_id: TASK-YYYYMMDD-slug
version: 1
status: final
author_role: code-reviewer     # or a specialisation, e.g. code-reviewer[api]
author_agent: <session id — must differ from the author's>
author_model: UNKNOWN          # HIGH/CRITICAL: should differ from the author's model
risk: <LOW|MEDIUM|HIGH|CRITICAL>
created: YYYY-MM-DD
inputs: [implementation_plan, implementation_report, test_report]
handoff_to: human
---

# Review Report: <title>

Reference: `governance/quality/code-review.md`, `checklists/code-review.md`

## 1. Independence

- Reviewer session differs from author session: yes/no
- Reviewer model differs from author model: yes/no/UNKNOWN

## 2. Scope

- Diff reviewed: <commit range / PR>
- Unexpected changes: <none | list>

## 3. Dimensions

| Dimension | Result | Notes |
|---|---|---|
| Correctness | ok/finding/not_checked | |
| Architecture | | |
| Security | | |
| Tests | | |
| Error Handling | | |
| Performance | | |
| Maintainability | | |
| Dependencies | | |
| Breaking Changes | | |
| Unexpected Changes | | |

## 4. Findings

| # | Severity | Location | Finding | Suggested fix |
|---|---|---|---|---|
| 1 | blocker/major/minor/note | <file:line> | | |

## 5. Verification

- Re-executed: <commands and real results | none, with reason>
- Verified by reading only: <…>

## 6. Verdict

**<approve | request_changes | needs_human_decision>** — an AI verdict is a
recommendation; merge is a human decision for MEDIUM+.

## 7. Gate status

| Gate | Status | Evidence |
|---|---|---|
| review | passed/failed/not_run/not_applicable/waived_with_approval | |
