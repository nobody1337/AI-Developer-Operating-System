# Workflow: Fullstack (`fullstack`)

Status: Governance Definition. Combines [frontend](frontend.md) and
[backend](backend.md); all their gates apply.

## Trigger

A change that requires coordinated frontend and backend work.

## Input

- Feature request; affected UI and API areas

## Classification

- Risk = highest of the frontend and backend parts.

## Roles

| Step | Role (specialisation) |
|---|---|
| System plan, contract | System Planner — `planner[system]`; `architect` |
| Frontend plan / implementation | `planner[frontend]` → `frontend-developer` |
| Backend plan / implementation | `planner[backend]` → `backend-developer` |
| Integration tests | `tester` |
| Review | `code-reviewer` (+ `code-reviewer[api]`, `security-reviewer` per risk) |

## Model Selection

- System planning: planning ≥ strong, architecture ≥ good, context handling ≥ strong.
- Each branch is routed independently by its role's capabilities; different
  models may be used for frontend and backend.

## Steps

```text
Requirement → System Planner → Architecture (contract)
   ├─ Frontend Plan → Frontend Dev ─┐
   └─ Backend Plan  → Backend Dev  ─┴→ Integration → Integration Tests → Review
```

1. **System plan** — split the requirement; identify the interface between FE and BE.
2. **Agree the contract** — API shape, errors, auth, versioning; recorded in the
   plan or an ADR and **approved before parallel work** (human approval if `HIGH`+).
3. **Independent planning** — frontend and backend are planned separately
   against the agreed contract; neither side changes the contract unilaterally.
4. **Parallel implementation** — in separate sessions/branches where practical.
5. **Integration** — connect both sides; contract deviations go back to step 2.
6. **Integration tests** — end-to-end over the real interface (or contract tests).
7. **Review** — per risk; reviewers see both sides and the contract.

## Validation

- Both builds and test suites executed; integration/contract tests executed or `not_run` with reason.

## Review

- As in frontend and backend workflows; plus a check that the contract is honoured on both sides.

## Approval

- Contract approval before parallel work for `HIGH`+; completion per risk level.

## Output

- Contract, both implementations, integration tests, reports.
