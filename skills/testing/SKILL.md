---
name: testing
description: Procedure for test analysis and writing meaningful, deterministic unit, integration, E2E, regression and security tests. Use when adding or changing tests, assessing coverage, or verifying a change.
---

# Skill: Testing

## Purpose

Produce tests that would catch real defects, and report results honestly.

## When to use

Every change (test analysis), test-focused tasks, bug reproduction.

## Inputs

- Acceptance criteria, changed code, existing tests and test commands

## Procedure

1. **Test analysis** — answer the five questions in
   [testing governance](../../governance/quality/testing.md#test-analysis-on-every-change).
2. **Choose levels** — unit for logic, integration for boundaries, E2E only
   for critical journeys.
3. **Design cases** — happy path, boundaries, empty/null, invalid input,
   permissions, error paths, concurrency where relevant.
4. **Write tests** — Arrange/Act/Assert; one behaviour per test; descriptive names.
5. **Mock only at boundaries** — external services, time, randomness.
6. **Prove the test** — where practical, break the behaviour and see the test fail.
7. **Run** — the exact project command; record command and real result.
8. **Report** — [templates/test-report.md](../../templates/test-report.md).

## Outputs

- Tests, Test Report

## Quality criteria

- Tests fail when behaviour breaks; pass deterministically otherwise.
- No weakened assertions, no skipped tests without approval.
- Results are real and reproducible.

## Pitfalls

- Tautological tests (asserting mocks).
- Snapshot tests accepted without review.
- Changing expectations to match buggy behaviour.
- Claiming "tests pass" without running them.

## Related

[checklists/ai-generated-code.md](../../checklists/ai-generated-code.md) ·
role [tester](../../orchestration/roles/tester.md)
