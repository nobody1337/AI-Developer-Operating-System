---
name: documentation
description: Procedure for writing concise, accurate technical documentation with long-term value, including ADRs, READMEs, API docs and release notes. Use when creating or updating documentation or reports.
---

# Skill: Documentation

## Purpose

Write documentation that stays true and useful after the current task.

## When to use

ADRs, READMEs, API docs, runbooks, release notes, reports.

## Inputs

- The change, its decisions, its audience

## Procedure

1. **Decide if it is needed** — per [documentation governance](../../governance/policies/documentation.md).
2. **Identify the reader** — maintainer, operator, API consumer, end user.
3. **Find the single source of truth** — update it; link from elsewhere instead of copying.
4. **Write** — purpose first, then how; short sections; concrete examples.
5. **Verify facts** — commands, paths, versions checked against the repository;
   mark unverified items `REQUIRES VALIDATION`.
6. **Remove outdated content** made obsolete by the change.

## Outputs

- Updated documentation

## Quality criteria

- Accurate (verified), concise, findable, no duplicated rules.
- Explains "why" for non-obvious decisions.

## Pitfalls

- Narrating the session instead of documenting the system.
- Copying rule text into multiple places (drift).
- Documenting intended behaviour as if implemented.

## Related

[templates/adr.md](../../templates/adr.md) ·
[templates/README.md](../../templates/README.md)
