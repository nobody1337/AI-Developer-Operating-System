---
name: backend
description: Procedure for implementing APIs and server-side logic with validation, authorization, error handling, logging and tests. Use for endpoints, services, business logic and backend integrations.
---

# Skill: Backend

## Purpose

Implement server-side behaviour that is correct, secure at trust boundaries,
observable and backward compatible.

## When to use

Endpoints, services, business rules, background jobs, integrations.

## Inputs

- Plan, API contract, data model, security requirements, existing services

## Procedure

1. **Read conventions** — framework/version from manifests, layering, error
   format, logging, configuration, test setup.
2. **Contract** — confirm request/response shapes, status codes, error format,
   versioning; do not change the contract unilaterally.
3. **Validate input** at the boundary (types, ranges, allow-lists).
4. **Authorize** every operation on the server side; fail closed.
5. **Business logic** — keep it in the layer the project uses; make rules explicit.
6. **Persistence** — parameterised queries / ORM; transactions where
   consistency requires; no schema changes without the database skill.
7. **Errors** — map expected errors to defined responses; no internal details
   to clients; log unexpected errors with context, without sensitive data.
8. **Performance** — avoid N+1, unbounded queries, blocking calls in hot paths.
9. **Test** — unit (rules), integration (persistence, API), authz and
   validation tests.
10. **Validate** — build, tests; report real results.

## Outputs

- Code, tests, contract updates, Implementation Report

## Quality criteria

- Every endpoint has explicit authz and input validation.
- Backward compatible, or breaking change documented with ADR.
- Errors and logs consistent with project conventions.

## Pitfalls

- Trusting client-side validation or client-provided identity/role fields.
- Logging tokens, passwords or personal data.
- Catch-all error handlers that hide failures.
- Inventing library APIs — verify against the installed version.

## Related

Workflow [backend](../../orchestration/workflows/backend.md) ·
[security skill](../security/SKILL.md) · [database skill](../database/SKILL.md)
