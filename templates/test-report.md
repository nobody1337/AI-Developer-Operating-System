---
artifact: test_report
task_id: TASK-YYYYMMDD-slug
version: 1
status: final
author_role: tester
author_agent: <session id>
author_model: UNKNOWN
risk: <LOW|MEDIUM|HIGH|CRITICAL>
created: YYYY-MM-DD
inputs: [implementation_plan, implementation_report]
handoff_to: code-reviewer
---

# Test Report: <title>

## 1. Test analysis

| Question | Answer |
|---|---|
| Existing tests | |
| Tests adapted (why) | |
| New tests | |
| Edge cases covered | |
| Regression risk | |

## 2. Executed tests (real results only)

| Suite / level | Command | Executed | Passed | Failed | Skipped |
|---|---|---|---|---|---|
| unit | `<command>` | yes/no | | | |
| integration | | | | | |
| e2e | | | | | |
| security | | | | | |

Environment: <OS, runtime versions, relevant config>

## 3. Not run

| Test / check | Reason | What is needed |
|---|---|---|
| | | |

## 4. Failures and findings

- <test> — <failure> — <assessment: caused by change / pre-existing / flaky>

## 5. Assertions changed

<None | list with reason (intended behaviour change)>

## 6. Gate status

| Gate | Status | Evidence |
|---|---|---|
| testing | passed/failed/not_run/not_applicable/waived_with_approval | |

VALIDATION: <honest one-line summary>
