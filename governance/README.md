# Governance

Status: Governance Definition. Governance defines **what must be true**,
independent of any model, provider or IDE. How work is carried out (roles,
workflows, routing) lives in [orchestration/](../orchestration/README.md).

## Index

| Area | Documents |
|---|---|
| Vocabulary | [vocabulary.md](vocabulary.md) — canonical identifiers |
| Principles | [core-principles.md](principles/core-principles.md), [governance-hierarchy.md](principles/governance-hierarchy.md) |
| Policies | [working-method.md](policies/working-method.md), [risk-classification.md](policies/risk-classification.md), [human-approval.md](policies/human-approval.md), [dependencies.md](policies/dependencies.md), [git.md](policies/git.md), [documentation.md](policies/documentation.md) |
| Security | [security-policy.md](security/security-policy.md), [ai-security.md](security/ai-security.md), [secrets-and-data.md](security/secrets-and-data.md), [agent-permissions.md](security/agent-permissions.md) |
| Architecture | [architecture-governance.md](architecture/architecture-governance.md) |
| Quality | [engineering-standards.md](quality/engineering-standards.md), [testing.md](quality/testing.md), [code-review.md](quality/code-review.md), [quality-gates.md](quality/quality-gates.md), [definition-of-done.md](quality/definition-of-done.md) |
| AI | [ai-governance.md](ai/ai-governance.md), [communication-protocol.md](ai/communication-protocol.md), [context-management.md](ai/context-management.md) |
| Decisions | [decisions/](decisions/README.md) — ADRs about AI-DOS itself |
| Reviews | [reviews/](reviews/0001-initial-self-review.md) — governance self-reviews |

## Single source of truth

Each rule is defined in exactly one document. Cursor rules, `AGENTS.md`,
commands and skills summarise and link; they do not redefine. If a summary and
its source disagree, the source wins and the summary is a defect.

## Changing governance

Changing any file in `governance/`, `.cursor/rules/` or `AGENTS.md` is a
`CRITICAL` risk change and a
[protected action](policies/human-approval.md#protected-actions): it needs
explicit human approval. Substantive changes (new or changed rules, levels,
gates, roles, vocabulary) also need an ADR in [decisions/](decisions/README.md);
purely editorial fixes (typos, broken links, formatting) do not.
