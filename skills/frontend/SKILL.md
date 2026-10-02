---
name: frontend
description: Procedure for implementing UI components with state, accessibility, responsive behaviour and tests in the project's existing frontend framework. Use for UI components, screens, client-side state and frontend tests.
---

# Skill: Frontend

## Purpose

Build UI that fits the existing frontend architecture, is accessible, handles
all states, and is tested.

## When to use

Component, screen, routing, client-state or styling work.

## Inputs

- Plan, designs/UX description, API contract, existing components and services

## Procedure

1. **Read conventions** — framework and version (from the manifest, not memory),
   component structure, state management, styling approach, test setup.
2. **Reuse first** — search for existing components, services, utilities and
   design tokens before creating new ones.
3. **Define the component contract** — inputs/outputs (props, events), state
   ownership, data source.
4. **Implement all UI states** — loading, empty, error, success, disabled,
   permission-denied where relevant.
5. **Accessibility** — semantic elements, labels, keyboard operation, visible
   focus, ARIA only when semantics are insufficient, sufficient contrast.
6. **Responsive behaviour** — follow existing breakpoints and layout primitives.
7. **Performance** — avoid unnecessary re-renders/change detection, large
   bundles, unbounded lists without virtualisation where relevant.
8. **Test** — component/unit tests for behaviour; E2E for critical journeys.
9. **Validate** — run build, lint and tests; report real results.

## Outputs

- Components, styles, tests, Implementation Report

## Quality criteria

- Consistent with existing components and conventions.
- No business logic in presentation components unless that is the project's pattern.
- Keyboard-usable; screen-reader labels present.
- No hard-coded secrets, URLs or environment-specific values.

## Pitfalls

- Using framework APIs from the wrong version (verify against the project).
- Adding a UI or state library for a single use case.
- Testing implementation details (internal state) instead of behaviour.
- Only implementing the happy path.

## Related

Workflow [frontend](../../orchestration/workflows/frontend.md) ·
[checklists/implementation.md](../../checklists/implementation.md)
