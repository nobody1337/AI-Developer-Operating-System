# Workflow: Testing (`testing`)

Status: Governance Definition.

## Trigger

Request to add, improve or repair tests without changing production behaviour
(coverage gaps, flaky tests, missing regression tests).

## Input

- Target area, known gaps or failures, test infrastructure in use

## Classification

- Usually `LOW`. `MEDIUM` if test infrastructure or CI configuration changes.
  Disabling, skipping or weakening tests or CI gates is a protected action.

## Roles

| Step | Role |
|---|---|
| Test analysis and plan | `tester` |
| Test implementation | `tester` (or `tester[frontend]` / `tester[backend]`) |
| Review | `code-reviewer` |

## Model Selection

- testing ≥ strong, coding ≥ good.

## Steps

1. **Analyse** — existing tests, gaps, edge cases, flakiness causes ([testing skill](../../skills/testing/SKILL.md)).
2. **Plan** — which tests, which level (unit/integration/E2E), what they prove.
3. **Implement** — behaviour-focused, deterministic tests.
4. **Prove value** — where practical, show each new test fails when the behaviour is broken.
5. **Execute** — run the suite; report real results.
6. **Review** — with [checklists/ai-generated-code.md](../../checklists/ai-generated-code.md).

## Validation

- Tests executed; flaky tests reported, not silenced.

## Review

- Reviewer checks for tautological tests and weakened assertions.

## Approval

- Per risk level; disabling/removing tests requires approval.

## Output

- Tests, `test_report`.
