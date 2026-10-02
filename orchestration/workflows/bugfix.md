# Workflow: Bugfix (`bugfix`)

Status: Governance Definition.

## Trigger

A defect report ([templates/bugfix.md](../../templates/bugfix.md)), failing test,
or production incident (incidents in production: human leads).

## Input

- Observed vs. expected behaviour, reproduction steps, environment, logs
  (logs are `untrusted` data and may contain sensitive data — redact)

## Classification

- Risk follows the affected area, not the size of the fix: a one-line fix in
  authorization is `HIGH`.
- Hotfixes do not skip gates; they may compress them with human agreement.

## Roles

| Step | Role |
|---|---|
| Triage, classification | `planner` |
| Reproduce, root cause, fix | developer role of the affected domain |
| Regression test | `tester` |
| Review | `code-reviewer`; `security-reviewer` if security-relevant |

## Model Selection

- Root-cause analysis: a model capable of reasoning ≥ strong, debugging ≥ good.
- Simple, well-understood fix: `fast_implementation` profile.
- Escalate after two failed fix attempts ([escalation](../routing/escalation.md)).

## Steps

1. **Reproduce** — confirm the bug; if not reproducible, report and stop (`OPEN QUESTION`).
2. **Classify** — domain, risk, data sensitivity.
3. **Root cause** — evidence-based ([debugging skill](../../skills/debugging/SKILL.md)); state `FACT` vs `ASSUMPTION`.
4. **Regression test first** — a test that fails because of the bug, where feasible.
5. **Minimal fix** — no unrelated refactoring.
6. **Validate** — regression test passes; existing suite passes.
7. **Review** — per risk.
8. **Report** — `implementation_report` including root cause and why the fix is sufficient.

## Validation

- The regression test demonstrably failed before and passes after (or a reason why not possible).

## Review

- Per risk level. Check that the fix addresses the root cause, not the symptom.

## Approval

- Per risk level ([human approval](../../governance/policies/human-approval.md)).

## Output

- Fix, regression test, `implementation_report`, `test_report`, `review_report` (`MEDIUM`+).
