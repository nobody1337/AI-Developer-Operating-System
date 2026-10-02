# /plan

Produce an Implementation Plan. Do not implement until the plan is accepted (and, for HIGH/CRITICAL, approved).

1. If the task is not classified yet, run the `/classify-task` procedure first.
2. Inspect the relevant code, config, tests and ADRs (`governance/policies/working-method.md`). Record what you read as `FACT`.
3. Select the workflow from `orchestration/workflows/` and follow its steps.
4. Fill `templates/implementation-plan.md`:
   scope with files marked change/read, steps with validation, architecture impact, security section,
   test analysis (`governance/quality/testing.md`), dependencies, routing recommendation, rollback (CRITICAL).
5. For LOW risk, a short inline plan is enough (files, change, validation).
6. For HIGH/CRITICAL, end with an approval request (`/request-approval`) and stop.
