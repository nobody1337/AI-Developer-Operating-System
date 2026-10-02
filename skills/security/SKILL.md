---
name: security
description: Procedure for threat analysis and security review of plans and code changes, including AI-specific risks, secrets and supply chain. Use for security reviews, authn/authz changes, input handling, secrets, dependencies and vulnerability fixes.
---

# Skill: Security

## Purpose

Find and explain security risks early, with concrete evidence and remediation.

## When to use

Security reviews, any change touching trust boundaries, authn/authz, crypto,
secrets, dependencies, pipelines; vulnerability fixes.

## Inputs

- Plan, diff, architecture/contract, data sensitivity, dependency changes

## Procedure

1. **Scope** — what changed, which assets and data (sensitivity level) are involved.
2. **Trust boundaries** — list entry points and where untrusted data flows.
3. **Threats** — walk through STRIDE-style categories (spoofing, tampering,
   repudiation, information disclosure, denial of service, elevation of privilege).
4. **Check controls** — authn, authz (server-side, per operation), input
   validation, output encoding, injection (SQL, command, template, path),
   SSRF, deserialization, CSRF/CORS, session handling, rate limiting.
5. **Secrets and data** — no secrets in code/logs/tests; personal data handling.
6. **Dependencies and supply chain** — per [dependency policy](../../governance/policies/dependencies.md).
7. **AI-specific** — injection via content, unsafe command execution, excessive
   permissions ([AI security](../../governance/security/ai-security.md)).
8. **Rate findings** — `blocker` / `major` / `minor` / `note`, with location,
   scenario and remediation.
9. **Report** — [templates/security-report.md](../../templates/security-report.md);
   list what was **not** checked.

## Outputs

- Security Report

## Quality criteria

- Findings are specific (file, line, scenario), not generic advice.
- Residual risk is stated for the human decision.
- Unchecked areas are listed explicitly.

## Pitfalls

- Generic checklists without reading the code.
- Treating an AI review as proof of security.
- Reproducing found secrets in the report.
- Recommending custom crypto or security mechanisms.

## Related

[checklists/security.md](../../checklists/security.md) ·
role [security-reviewer](../../orchestration/roles/security-reviewer.md)
