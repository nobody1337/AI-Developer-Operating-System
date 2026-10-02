# Testing Governance

Status: Governance Definition.

## Test types

| Type | Purpose |
|---|---|
| Unit | Verify isolated logic, including edge cases and error paths |
| Integration | Verify interaction between components, persistence, external interfaces |
| End-to-end (E2E) | Verify critical user journeys through the running system |
| Regression | Prevent known bugs from returning; every bugfix adds one where feasible |
| Security | Verify authn/authz rules, input validation, injection resistance, secret handling |

Required depth per risk level: [risk classification](../policies/risk-classification.md#required-controls-per-level).

## Test analysis on every change

Before implementing, answer (in the plan or report):

1. Which tests exist for the affected code?
2. Which tests must be adapted, and why (behaviour change vs. test defect)?
3. Which new tests are needed?
4. Which edge cases apply (empty, null, boundaries, concurrency, permissions, errors)?
5. What is the regression risk, and where?

## Rules for AI-generated tests

AI-generated tests are reviewed critically
([checklists/ai-generated-code.md](../../checklists/ai-generated-code.md)):

- No tautological tests (asserting what was just mocked, or `expect(true)`).
- No weakening of assertions, broadening of matchers, or deleting/skipping
  tests to make a change pass. Changing an existing assertion requires a stated
  reason (intended behaviour change). Disabling tests is a
  [protected action](../policies/human-approval.md#protected-actions).
- Tests verify behaviour, not implementation details.
- Mocks only at real boundaries; over-mocking is a finding.
- Tests must fail without the change (where practical, demonstrate it).
- Deterministic: no reliance on time, order or network without control.

## Reporting

Results are documented in a [Test Report](../../templates/test-report.md) or the
Implementation Report, with the exact commands run and their real outcome.
Tests that were not run are reported as `not_run` with the reason — never as
passed ([AI governance](../ai/ai-governance.md)).
