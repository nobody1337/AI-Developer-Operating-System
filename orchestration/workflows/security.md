# Workflow: Security (`security`)

Status: Governance Definition.

## Trigger

Security fix, vulnerability report, hardening task, security-relevant change
(authn, authz, crypto, secrets, security controls), suspected prompt injection.

## Input

- Finding or requirement, affected components, severity estimate.
- Vulnerability details are `restricted` data until disclosed: minimise
  context, prefer models approved for `restricted` (often local), never post
  details externally ([secrets and data](../../governance/security/secrets-and-data.md)).

## Classification

- At least `HIGH`. Secrets, crypto, security boundaries: `CRITICAL`.

## Roles

| Step | Role |
|---|---|
| Analysis, threat model | `security-reviewer` |
| Plan | `planner` (with `security-reviewer` input) |
| Fix | developer role of the domain; `devops-engineer` for infrastructure |
| Security tests | `tester` |
| Independent security review | `security-reviewer` (different session than analysis author where possible) |

## Model Selection

- security ≥ strong, reasoning ≥ strong; data sensitivity filter applies first.

## Steps

1. **Contain** — if active exploitation or exposed secrets: inform the human immediately (rotation is a protected action).
2. **Analyse** — root cause, affected versions, attack scenario ([security skill](../../skills/security/SKILL.md)).
3. **Plan** — fix, security tests, rollout; human approval (`HIGH`+).
4. **Fix** — minimal, using vetted mechanisms; no custom crypto.
5. **Security tests** — prove the vulnerability is closed and no regression.
6. **Independent review** — `security_report` + code review.
7. **Human approval** — before merge/deploy.

## Validation

- Security tests executed; scanners executed if available (report which ones and their real output).

## Review

- Independent security review + human review (always).

## Approval

- Plan approval and completion approval (`HIGH`); explicit approval before execution (`CRITICAL`).

## Output

- Fix, security tests, `security_report`, `approval_record`.
