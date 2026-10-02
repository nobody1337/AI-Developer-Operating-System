# Workflow: Frontend (`frontend`)

Status: Governance Definition. Refines [feature](feature.md); all its gates apply.

## Trigger

UI-focused feature or change.

## Input

- Feature request, designs or UX description, affected screens/components,
  API contract (if data is consumed)

## Classification

- Small isolated UI change: `LOW`. New screens, routes, state management changes:
  `MEDIUM`. Client-side auth handling, new frontend framework/state library: `HIGH`.

## Focus areas

UI architecture · components · state · accessibility · responsive behaviour ·
UX · performance · testing.

## Roles

| Step | Role (specialisation) |
|---|---|
| Plan | Frontend Planner — `planner[frontend]` |
| UI architecture | Frontend Architect — `architect[frontend]` (if architecture affected) |
| Implementation | Frontend Developer — `frontend-developer` |
| UX review | UX Reviewer — `code-reviewer[ux]` |
| Accessibility review | Accessibility Reviewer — `code-reviewer[accessibility]` |
| Tests | Frontend Tester — `tester[frontend]` |

## Model Selection

- Planning: planning ≥ strong, frontend ≥ good.
- Implementation: frontend ≥ good, framework_knowledge ≥ good (for the project's framework), coding ≥ good; profile by complexity.
- Accessibility review: accessibility ≥ strong.

## Steps

1. **Plan** — component breakdown, state ownership, data flow, routes, a11y requirements, responsive breakpoints.
2. **UI architecture** — reuse existing components/services first; ADR for new state/routing patterns.
3. **Implement** — components following project conventions ([frontend skill](../../skills/frontend/SKILL.md)).
4. **Test** — component/unit tests; E2E for critical journeys; accessibility checks where tooling exists.
5. **UX review** — states (loading, empty, error), wording, consistency.
6. **Accessibility review** — keyboard, focus, semantics, labels, contrast.
7. **Code review** — per risk.

## Validation

- Build, lint, unit/component tests executed; E2E/a11y checks executed if available,
  otherwise `not_run` with reason. Manual visual checks are reported as such.

## Review

- `code-reviewer`; plus `code-reviewer[ux]` and `code-reviewer[accessibility]`
  for user-facing changes (may be combined in one review for `LOW` risk).

## Approval

- Per risk level.

## Output

- Components, tests, `implementation_report`, `test_report`, `review_report`(s).
