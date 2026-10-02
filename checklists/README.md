# Checklists

Operational checklists. They **apply** governance; they do not define it. Each
item links back to its source policy where useful. Mark items `[x]` only if the
check was actually performed; otherwise write `not_run` or `n/a` with a reason.

| Checklist | Used at gate | Source policy |
|---|---|---|
| [implementation.md](implementation.md) | `implementation` | [working method](../governance/policies/working-method.md), [engineering standards](../governance/quality/engineering-standards.md) |
| [architecture.md](architecture.md) | `architecture` | [architecture governance](../governance/architecture/architecture-governance.md) |
| [security.md](security.md) | `security` | [security policy](../governance/security/security-policy.md) |
| [code-review.md](code-review.md) | `review` | [code review governance](../governance/quality/code-review.md) |
| [ai-generated-code.md](ai-generated-code.md) | `implementation`, `review` | [AI governance](../governance/ai/ai-governance.md), [testing](../governance/quality/testing.md) |
| [dependency.md](dependency.md) | `implementation`, `review` | [dependency governance](../governance/policies/dependencies.md) |
| [release.md](release.md) | `release` | [release workflow](../orchestration/workflows/release.md) |
| Definition of Done | completion | [definition-of-done.md](../governance/quality/definition-of-done.md) (kept in governance as the single source) |
