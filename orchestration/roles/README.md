# Roles

Status: Governance Definition. Roles are responsibilities that an agent (or a
human) takes on for a step of a workflow.

## Concepts

- **Role ≠ model.** A role defines responsibility, required capabilities,
  inputs, outputs, permissions and quality requirements. A model provides
  capabilities. One model can play many roles; one role can be played by many
  models ([selection policy](../models/selection-policy.md)).
- **Role ≠ skill.** A role is *who is responsible*; a [skill](../../skills/README.md)
  is *how a procedure is done*. Roles use skills.
- **One agent session, one role at a time.** An agent may switch roles between
  steps, but never reviews work it authored in the same session
  ([code review governance](../../governance/quality/code-review.md#independence)).

## Base roles

| Role id | Name | Definition |
|---|---|---|
| `planner` | Planner | [planner.md](planner.md) |
| `architect` | Architect | [architect.md](architect.md) |
| `frontend-developer` | Frontend Developer | [frontend-developer.md](frontend-developer.md) |
| `backend-developer` | Backend Developer | [backend-developer.md](backend-developer.md) |
| `database-engineer` | Database Engineer | [database-engineer.md](database-engineer.md) |
| `devops-engineer` | DevOps Engineer | [devops-engineer.md](devops-engineer.md) |
| `tester` | Tester | [tester.md](tester.md) |
| `security-reviewer` | Security Reviewer | [security-reviewer.md](security-reviewer.md) |
| `code-reviewer` | Code Reviewer | [code-reviewer.md](code-reviewer.md) |
| `release-manager` | Release Manager | [release-manager.md](release-manager.md) |

Template for new roles: [templates/role.md](../../templates/role.md).

## Specialisations (role + domain)

Domain-specific roles are **specialisations of a base role**, written
`<base-role>[<domain>]`. A specialisation inherits everything from the base
role (permissions, forbidden actions, review requirements, handoffs) and only
**adds** focus areas and capability requirements. It can never widen
permissions.

| Specialisation | Display name | Adds |
|---|---|---|
| `planner[system]` | System Planner | Decomposition across frontend/backend/data; contract definition; `architecture` ≥ `good` |
| `planner[frontend]` | Frontend Planner | UI flows, component breakdown, state, accessibility requirements; `frontend` ≥ `good` |
| `planner[backend]` | Backend Planner | API, business logic, persistence, security requirements; `backend` ≥ `good` |
| `architect[frontend]` | Frontend Architect | UI architecture, state management, routing, performance budgets; `frontend` ≥ `strong` |
| `architect[backend]` | Backend Architect | Service boundaries, API contracts, persistence, authn/authz design; `backend` ≥ `strong`, `security` ≥ `good` |
| `tester[frontend]` | Frontend Tester | Component, E2E, visual and accessibility tests; `frontend` ≥ `good` |
| `tester[backend]` | Backend Tester | Unit, integration, contract and API security tests; `backend` ≥ `good` |
| `code-reviewer[ux]` | UX Reviewer | Usability, consistency, wording, interaction states; `ux` ≥ `good`, `frontend` ≥ `good` |
| `code-reviewer[accessibility]` | Accessibility Reviewer | Semantic markup, keyboard, focus, contrast, ARIA, assistive tech; `accessibility` ≥ `strong` |
| `code-reviewer[api]` | API Reviewer | Contract consistency, versioning, backward compatibility, error format; `api_design` ≥ `strong` |

Why specialisations instead of separate roles: it keeps permissions and
responsibilities in one place per base role, avoids a combinatorial explosion
of role files, and lets workflows request "the base role with a domain focus".
A specialisation gets its own file only when it needs permissions or outputs
the base role does not have — which then makes it a new base role (ADR required).

## Required capabilities notation

```yaml
required_capabilities:   # capability id: minimum level (from capabilities.yaml)
  planning: strong
  reasoning: strong
```

The task classification may raise minimums; it never lowers them.
