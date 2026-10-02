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
| Decisions | [decisions/](decisions/README.md) — ADRs about AI-DOS itself; [binding decisions](#binding-decisions-2026-10-02) below |
| Reviews | Governance self-reviews: [0001](reviews/0001-initial-self-review.md), [0002](reviews/0002-embedded-integration-self-review.md) |

Project integration (Central and Embedded AI-DOS, manifest, project profile,
versioning) is described in [integration/](../integration/README.md); its
governance limits are in the [hierarchy](principles/governance-hierarchy.md#project-level-overrides).

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

## Binding decisions (2026-10-02)

Decisions taken by the human owner (Axel) on 2026-10-02. They are binding for
AI-DOS 0.1.x. Architecture rationale: [ADR-001](decisions/001-embedded-project-integration.md).

### 1. Git

```text
Decision: Git repository initialization is required.
Execution: Human action.
```

The Central AI-DOS is a git repository; the first commit is the complete,
reviewed initial state. AI agents do not run `git init` or commit on their own.
No remote is assumed or required, there is no dependency on GitHub, GitLab or
any other host, no automatic publication and no credentials in the repository.
`.gitattributes` (LF normalisation) and `.editorconfig` are part of the repository.

FACT: The human has initialised the repository and made the baseline commit.
A remote exists; AI-DOS does not depend on it.

### 2. ADR-000

ADR-000 is **not yet accepted** and stays `Proposed`.

- Why the existing review is not independent: [review 0001](reviews/0001-initial-self-review.md)
  was written by the agent session that authored ADR-000 and the governance,
  with the same model and the same context, so it shares the author's blind
  spots. [Code review governance](quality/code-review.md#independence) requires
  a separate agent context, a different model where available, and human
  review for `CRITICAL` changes.
- Missing review: an independent review by a new session, preferably with a
  different model, followed by a human review.
- Criteria to check: separation of governance and orchestration, role ≠ model,
  role ≠ skill; one definition per central term (vocabulary); completeness of
  the Security Baseline and protected actions; consistency of risk levels,
  states, gates and approvals; no model, provider or IDE names in governance;
  every statement about Cursor behaviour verified or marked `REQUIRES VALIDATION`;
  valid links and parseable YAML; no secrets and no implicit external
  dependencies.
- After the review, a human sets ADR-000 to `Accepted` (or requests changes).
  The same applies to ADR-001.

### 3. Task State and Artifacts

Project-related states and relevant artifacts may be versioned; temporary
runtime state is not. Versioned: ADRs, plans, risk assessments, architecture
decisions, review reports, security reports, approval records, relevant task
records, permanent AI-DOS configuration. Not versioned automatically:
temporary agent logs, caches, temporary context packages, secrets, tokens,
credentials, large generated intermediate artifacts, machine runtime data
without long-term value. Rules and `.gitignore` recommendation:
[state and artifacts](../integration/state-and-artifacts.md).

### 4. Project Integration

Embedded, project-local integration is a deliberate architecture decision and
the official AI-DOS standard. The Central AI-DOS is blueprint, source, template
repository, governance source and update source. A project contains its AI-DOS
version, project configuration, activated governance components, local rules,
local skills and adapters, and task and audit artifacts.
Details: [integration](../integration/README.md), [ADR-001](decisions/001-embedded-project-integration.md).

### 5. Skill Adapters

Explicit by default, automation later. Cursor skill adapters stay and are
invoked explicitly (`disable-model-invocation: true`). A future orchestration
may select skills automatically by task type, role, capabilities, risk and
project profile; this is conceptual only
([future orchestrator](../orchestration/future-orchestrator.md)). Cursor does
not select AI-DOS skills automatically.

### 6. Documentation Rule

`08-documentation.mdc` no longer attaches to all Markdown files (`globs:
**/*.md, **/docs/**` removed). It is agent-requested by description: it applies
when documentation is written or updated (READMEs, `docs/`, ADRs, runbooks, API
docs, release notes, reports), and does not constrain governance definitions or
templates by file pattern.

### 7. License

```text
License status: Not licensed for redistribution.
```

No open-source license is granted in v0.1. The repository is hosted publicly;
this makes it visible but does not grant a license. Any later publication
under a license is a separate decision.
