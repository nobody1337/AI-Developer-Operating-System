---
name: refactoring
description: Procedure for behaviour-preserving refactoring in small, verified steps behind a test safety net. Use when restructuring code, reducing duplication, or paying down technical debt without changing behaviour.
---

# Skill: Refactoring

## Purpose

Improve structure without changing behaviour, verifiably.

## When to use

A concrete structural problem (duplication, unclear responsibility, coupling)
blocks or slows current work.

## Inputs

- Target code, motivation, existing tests

## Procedure

1. **Name the problem** — what is hard today and why; no refactoring for its own sake.
2. **Safety net** — run existing tests; add characterization tests where coverage is missing.
3. **Plan steps** — small, independent transformations (rename, extract, move, inline).
4. **One step at a time** — apply, build, test; commit-sized increments.
5. **Keep public interfaces** stable unless the plan explicitly changes them.
6. **Remove dead code** created by the refactoring.
7. **Verify** — full relevant test suite; diff shows no behaviour change.

## Outputs

- Refactored code, Implementation Report listing steps and validation

## Quality criteria

- Tests unchanged (except listed mechanical renames) and passing.
- Each step independently reviewable.
- No new abstraction without at least two real uses.

## Pitfalls

- Mixing refactoring with feature or bug changes.
- Big-bang rewrites.
- Reformatting unrelated code (noise in review).
- Introducing generic frameworks "for later".

## Related

Workflow [refactoring](../../orchestration/workflows/refactoring.md) ·
[engineering standards](../../governance/quality/engineering-standards.md)
