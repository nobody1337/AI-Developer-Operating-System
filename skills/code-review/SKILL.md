---
name: code-review
description: Procedure for independent code review across correctness, architecture, security, tests, error handling, performance, maintainability, dependencies, breaking and unexpected changes. Use when reviewing diffs, pull requests or AI-generated changes.
---

# Skill: Code Review

## Purpose

Find defects and risks the author missed, and give the human a clear basis
for the merge decision.

## When to use

Any review step; required for `MEDIUM` risk and above.

## Inputs

- Implementation Plan, diff, Implementation Report, Test Report

## Procedure

1. **Check independence** — you did not author this change in this session
   ([code review governance](../../governance/quality/code-review.md#independence)).
2. **Understand intent** — read the plan and requirement before the diff.
3. **Scope check** — every changed file is explained by the plan; flag unexpected changes.
4. **Review by dimension** — [checklists/code-review.md](../../checklists/code-review.md).
5. **Verify claims** — re-run build/tests where possible; compare with reported results.
6. **AI-specific checks** — [checklists/ai-generated-code.md](../../checklists/ai-generated-code.md)
   (hallucinated APIs/packages, tautological tests, silent scope creep).
7. **Rate findings** — `blocker` / `major` / `minor` / `note`, with location and suggested fix.
8. **Verdict** — `approve` / `request_changes` / `needs_human_decision`.
9. **Report** — [templates/code-review.md](../../templates/code-review.md).

## Outputs

- Review Report

## Quality criteria

- Findings are specific and actionable.
- States what was verified by execution vs. by reading.
- No rubber-stamping: "no findings" is justified by what was checked.

## Pitfalls

- Reviewing style while missing logic errors.
- Trusting the Implementation Report without checking.
- Editing the code under review instead of reporting.

## Related

Role [code-reviewer](../../orchestration/roles/code-reviewer.md)
