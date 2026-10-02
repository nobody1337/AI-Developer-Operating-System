# Workflow: Backend (`backend`)

Status: Governance Definition. Refines [feature](feature.md); all its gates apply.

## Trigger

API or server-side feature or change.

## Input

- Feature request, API consumers and their needs, data requirements,
  security requirements

## Classification

- New endpoint / API change: `MEDIUM`. Authentication, authorization,
  migrations: `HIGH`. Secrets, crypto, financial logic: `CRITICAL`.

## Focus areas

API design · business logic · persistence · security · authentication ·
authorization · validation · error handling · logging · performance · testing.

## Roles

| Step | Role (specialisation) |
|---|---|
| Plan | Backend Planner — `planner[backend]` |
| Architecture, contract | Backend Architect — `architect[backend]` |
| Implementation | Backend Developer — `backend-developer` (`database-engineer` for schema/migrations) |
| Security review | Security Reviewer — `security-reviewer` |
| API review | API Reviewer — `code-reviewer[api]` |
| Tests | Backend Tester — `tester[backend]` |

## Model Selection

- Planning/architecture: reasoning ≥ strong, architecture ≥ good, api_design ≥ good.
- Implementation: backend ≥ good, security ≥ good, coding ≥ good; profile by complexity.
- Security review: security ≥ strong, review ≥ strong; independent of the author.

## Steps

1. **Plan** — endpoints, business rules, data model impact, authn/authz rules, validation, errors, logging.
2. **Contract** — define/extend the API contract; backward compatibility; ADR if breaking.
3. **Implement** — [backend skill](../../skills/backend/SKILL.md); migrations via `database-engineer`.
4. **Test** — unit (business rules), integration (persistence, API), security tests for authz/validation.
5. **API review** — consistency, versioning, error format.
6. **Security review** — required for authn/authz/input handling at trust boundaries.
7. **Code review** — per risk.

## Validation

- Build, tests (unit + integration) executed with real results; migrations
  tested forward and backward on a local/dev database.

## Review

- `code-reviewer[api]` for contract changes; `security-reviewer` per risk; `code-reviewer`.

## Approval

- Per risk level; authn/authz and migrations need plan approval (`HIGH`).

## Output

- Code, contract, tests, migrations, the reports, updated API documentation.
