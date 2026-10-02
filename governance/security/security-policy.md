# Security Policy

Status: Governance Definition. Overview and entry point for security governance.

## Scope

| Topic | Document |
|---|---|
| AI-specific threats, trust levels, untrusted content | [ai-security.md](ai-security.md) |
| Secrets, credentials, personal and confidential data, data sensitivity | [secrets-and-data.md](secrets-and-data.md) |
| Agent permissions and least privilege | [agent-permissions.md](agent-permissions.md) |
| Protected actions and approval gates | [../policies/human-approval.md](../policies/human-approval.md) |
| Dependencies and supply chain | [../policies/dependencies.md](../policies/dependencies.md) |
| Security review checklist | [../../checklists/security.md](../../checklists/security.md) |

## Security by Design

Every Implementation Plan for `MEDIUM` risk and above contains a security
section that names:

- trust boundaries crossed (user input, network, file system, other services)
- authentication and authorization impact
- input validation and output encoding
- data sensitivity of the data handled
- secrets involved (must be none in code)
- logging of security-relevant events without leaking sensitive data
- failure behaviour (fail closed for security decisions)

If none apply, the plan states `Security: no security-relevant aspects identified`
and why.

## Secure coding baseline

- Validate all external input at trust boundaries; prefer allow-lists.
- Use parameterised queries; never build queries or shell commands from
  untrusted strings.
- Encode output for its context (HTML, SQL, shell, URL).
- Use the framework's vetted security mechanisms instead of custom ones;
  never implement custom cryptography.
- Apply least privilege to service accounts, tokens and file permissions.
- Fail closed on authorization errors.
- Do not expose stack traces or internal details to end users.

## Security reviews

Required per [risk classification](../policies/risk-classification.md); performed
by the [security-reviewer](../../orchestration/roles/security-reviewer.md) role and
documented as a [Security Report](../../templates/security-report.md).
A security review performed by an AI is an aid, not a guarantee; `HIGH` and
`CRITICAL` changes additionally need human review.
