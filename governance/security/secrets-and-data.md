# Secrets and Data Policy

Status: Governance Definition. Part of the Security Baseline.

## What counts as sensitive

API keys, tokens, passwords, certificates, private keys, credentials of any
kind, connection strings, environment variables holding any of these,
personal data, and confidential company information.

## Rules

Sensitive values are **never** placed in:

- source code or configuration committed to git
- tests, fixtures or snapshots (use obviously fake values like `example-token`)
- documentation, ADRs, reports or commit messages
- logs or error messages
- prompts or AI context — unless explicitly required for the task, approved by
  the human, and the target model is allowed to receive that sensitivity level

Further:

- Agents do not read secret files (`.env`, key stores, credential files) unless
  the task explicitly requires it and the human approved it.
- If a secret is found in code or context: do not repeat it; report its
  location as `RISK:` and recommend rotation. Rotation itself is a
  [protected action](../policies/human-approval.md#protected-actions).
- Use secret managers or environment injection; reference secrets by name only.

## Data sensitivity levels

| Level | Meaning | Model / context constraint |
|---|---|---|
| `public` | Publicly available or intended for publication | Any approved model |
| `internal` | Normal proprietary source code and docs | Approved models whose data handling is accepted by the owner for `internal` |
| `confidential` | Sensitive business logic, customer-specific code, security-relevant code | Only models explicitly approved for `confidential`; minimise context |
| `restricted` | Secrets, personal data, regulated data, security vulnerabilities before disclosure | Should not enter AI context. If unavoidable: only `local` / `self_hosted` models or a provider explicitly approved for this level; human approval required; risk at least `HIGH` |

The `max_data_sensitivity` of each model is set by a human during approval
([model lifecycle](../../orchestration/models/lifecycle.md)). Unknown means the
model must not receive anything above `public` without the human explicitly
accepting it.

## Ignore files

`.gitignore` prevents committing common secret files. `.cursorignore` asks
Cursor not to index or read listed files. **`.cursorignore` is best-effort, not
a security boundary**: files may still reach the AI through terminal output,
explicit user attachment, or other tools. Secrets must not be in the workspace
in plain text in the first place.
