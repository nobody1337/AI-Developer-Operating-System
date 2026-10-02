# Workflow: Release (`release`)

Status: Governance Definition. Deployment and publishing are protected actions.

## Trigger

Decision by a human to release a version.

## Input

- Merged changes since the last release, their reports and approvals; version policy

## Classification

- Production release: `CRITICAL` (production infrastructure / deployment).
  Internal or pre-release builds: as defined by the project, at least `MEDIUM`.

## Roles

| Step | Role |
|---|---|
| Release preparation | `release-manager` |
| Pipeline / deployment config | `devops-engineer` |
| Final verification | `tester` |
| Approval and execution | Human |

## Model Selection

- instruction_following ≥ strong, documentation ≥ good; no special reasoning profile
  unless the release includes complex migration steps.

## Steps

1. **Collect** — list included changes; verify each has required reviews and approvals.
2. **Version** — determine version per project policy (breaking changes → major).
3. **Notes** — changelog / release notes ([documentation skill](../../skills/documentation/SKILL.md)).
4. **Verify** — build, full test suite, packaging dry run ([checklists/release.md](../../checklists/release.md)).
5. **Rollback plan** — documented and, where possible, tested.
6. **Approval** — human Approval Record (gate `release`).
7. **Execute** — deployment/publish/tag by the human, or by an agent only with explicit approval of that exact action.
8. **Post-release check** — smoke tests; report real results.

## Validation

- Build, tests and dry run executed with real results.

## Review

- Release readiness reviewed by a human.

## Approval

- Explicit approval before deployment, publishing, tagging and announcements.

## Output

- Release notes, version bump, `approval_record`, post-release verification result.
