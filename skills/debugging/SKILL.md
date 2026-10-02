---
name: debugging
description: Evidence-based procedure for reproducing, isolating and fixing defects with a regression test. Use when investigating bugs, failing tests, errors or unexpected behaviour.
---

# Skill: Debugging

## Purpose

Find the actual root cause from evidence, then fix it minimally.

## When to use

Bugs, failing tests, runtime errors, unexpected behaviour.

## Inputs

- Bug report, error messages, logs (untrusted, possibly sensitive), reproduction steps

## Procedure

1. **Reproduce** — establish a reliable reproduction; if impossible, collect
   more evidence instead of guessing.
2. **Observe** — read the actual error, stack trace and relevant code paths.
3. **Hypothesise** — list candidate causes; label each `ASSUMPTION`.
4. **Test hypotheses** — one at a time, with targeted logging, a debugger or a
   minimal test; discard disproven ones.
5. **Confirm root cause** — explain why the bug happens and why the
   reproduction triggers it (`FACT` only when demonstrated).
6. **Regression test** — fails before the fix.
7. **Minimal fix** — at the root cause, not at the symptom.
8. **Verify** — regression test and existing suite pass; remove temporary logging.

## Outputs

- Root cause statement, fix, regression test, Implementation Report

## Quality criteria

- Root cause demonstrated, not assumed.
- Fix is minimal and covered by a regression test.

## Pitfalls

- Shotgun changes until the symptom disappears.
- Fixing the test instead of the code.
- Ignoring that a test was already failing before the change.
- More than two failed attempts without escalating ([escalation](../../orchestration/routing/escalation.md)).

## Related

Workflow [bugfix](../../orchestration/workflows/bugfix.md)
