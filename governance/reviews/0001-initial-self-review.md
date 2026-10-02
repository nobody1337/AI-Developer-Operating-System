# Review 0001: Initial Self-Review of AI-DOS v0

- **Date:** 2026-10-02
- **Reviewer:** the AI agent that authored v0 (same session)
- **Status:** Completed. Needs human review.

RISK: This review is **not independent**. The same agent session wrote and
reviewed the files, which AI-DOS itself says is insufficient for `CRITICAL`
governance changes ([code review governance](../quality/code-review.md#independence)).
An independent review (new session, different model where possible) plus human
review is recommended before ADR-000 is accepted.

## Method

What was actually done:

- VALIDATION: Every relative Markdown link and `#anchor` in all `.md`/`.mdc` files
  was checked with a script against the file system and the target headings.
  After the fixes, the only unresolved paths are intentional:
  `orchestration/state/runtime/` (git-ignored, created at runtime) and
  `governance/workflows/` (mentioned only as a documented non-existent deviation).
- VALIDATION: Vocabulary was checked with scripts: capability ids used in roles,
  workflows and the registry against `capabilities.yaml`; role ids and
  specialisations in backticks against the role list; state names, gate statuses
  and risk notation.
- VALIDATION: All 47 YAML documents (`*.yaml` files and frontmatter of skills
  and templates) parse with the YAML 1.2 parser bundled with Cursor (loaded
  read-only, nothing installed). Four glob-scoped `.mdc` frontmatters are not
  strict YAML because they use Cursor's unquoted comma-separated glob format.
- VALIDATION: Rule sizes counted (table below). All are below 50 lines.
- Not done: no tests (nothing executable exists), no check of Cursor's runtime
  behaviour (whether rules attach exactly as configured was not observed),
  no git operations.

## Rule sizes

| Rule | Lines | Activation |
|---|---|---|
| `00-governance.mdc` | 37 | always |
| `01-working-method.mdc` | 30 | always |
| `02-code-quality.mdc` | 30 | globs (source files) |
| `03-architecture.mdc` | 20 | description |
| `04-security.mdc` | 32 | always |
| `05-testing.mdc` | 30 | globs (test files) |
| `06-dependencies.mdc` | 23 | globs (manifests) |
| `07-git.mdc` | 20 | description |
| `08-documentation.mdc` | 22 | globs (Markdown/docs) |
| `09-ai-safety.mdc` | 32 | always |
| `10-review.mdc` | 21 | description |
| `11-orchestration.mdc` | 24 | description |

The four always-on rules total about 131 lines.

## Findings and fixes

| # | Area | Finding | Fix |
|---|---|---|---|
| 1 | Cursor | `03` and `11` combined `globs` with a description. How Cursor treats that combination is not clearly documented, so the agent-requested behaviour could be lost | Each rule now has exactly one activation mode; README documents it |
| 2 | Models | `preferred_roles` was used both as an intent hint and as the approval scope for eligibility | Added `approved_roles` (set by a human); `preferred_roles` is a hint only. Registry, selection policy, lifecycle, adding-a-model and `/register-model` updated |
| 3 | State | No transition from `REVIEW`/`SECURITY_REVIEW` to `COMPLETED` for `LOW` tasks that were reviewed voluntarily | Transition added, restricted to `LOW` |
| 4 | Quality | The planning gate looked as if it was not required for `LOW` | Clarified: an inline plan at every level, human approval for `HIGH`/`CRITICAL` |
| 5 | Consistency | The testing workflow called *raising* CI gates a protected action, which the protected-action list does not say | Aligned: disabling, skipping or weakening tests or CI gates is protected |
| 6 | Governance | "Every governance change needs an ADR" would make typo fixes heavyweight | Substantive changes need an ADR; editorial fixes need approval only |
| 7 | Security | Readers could take "source code is `untrusted`" as a statement about code quality | Clarified that trust level means authority to instruct |
| 8 | Duplication | The permission matrix duplicates the role permission tables | Authority defined: role files for per-role grants, `agent-permissions.md` for types and global constraints. Values cross-checked and identical |
| 9 | Vocabulary | The "Conceptual" status label was used but not defined | Added to `vocabulary.md` |
| 10 | YAML | A flow sequence contained unquoted `planner[frontend]` (invalid YAML) | Quoted |
| 11 | Files | Files were written with CRLF despite the LF policy; one edit produced mixed endings | All files normalised to LF, UTF-8 without BOM |
| 12 | Templates | Relative links in templates break once a template is copied | Templates use repository-root paths in backticks |
| 13 | Cursor | Agents cannot write `.cursorignore` (Cursor blocks it) | Content delivered as `templates/cursorignore.template`; manual step documented |

## Assessment by area

**Architecture.** Governance has no references to models, providers or IDEs.
Grep found no model names outside `registry.yaml` (the only hit was
`composer.json` in a glob list). Roles reference capabilities only. Skills hold
procedures, roles hold responsibilities and permissions, and the two do not
overlap. Cursor files summarise and link and define no rules of their own.
Separation: OK.

**Governance.** The hierarchy has one explicit priority order. The rank-1
tension is resolved as follows: the user decides requirements and can grant
recorded approvals, but cannot authorise illegal actions or silently bypass
the Security Baseline. Each rule has one source document, with
`vocabulary.md` for identifiers. Remaining trade-off: governance edits are
`CRITICAL`, which is heavy for editorial fixes. The documented mechanism is
lowering the risk with justification and human acknowledgement.

**Security.** Covered: prompt injection (direct and indirect), malicious
repository content, typosquatting and hallucinated packages, secrets, context
leakage, excessive permissions, unsafe shell use, destructive operations, and
supply chain. Trust levels are defined. `.cursorignore` is described as
best-effort. Limitation: none of this is technically enforced. Real
enforcement needs Cursor command-approval settings, branch protection, CI and
deployment permissions. This is stated in the README, in `human-approval.md`
and in ADR-000.

**Orchestration.** Models can be replaced and registered through the registry
alone. Workflows route each step separately, so different models per step are
possible. Escalation exists to a stronger profile, to another role, and to the
human. The independent review requirement is explicit. Honest limitation:
model selection in Cursor is manual, and the registry has no approved entries,
so every routing result says "human selects".

**Practicality.** Rules are small and most load only when relevant. Commands
give direct entry points. Templates share one artifact header. Possible
concern: the process overhead for `MEDIUM` tasks may be perceived as heavy.
`LOW` tasks keep a lightweight path (inline plan, one-line classification).

## Open items for human review

- OPEN QUESTION: Accept ADR-000 (currently `Proposed`)?
- OPEN QUESTION: Should Cursor skill adapters be auto-invocable (current setting) or explicit-only?
- OPEN QUESTION: Should `08-documentation.mdc` stay glob-attached to all `*.md` files? In this repository it attaches to almost every file.
- REQUIRES VALIDATION: Confirm in Cursor that each rule attaches as configured (always, glob, description) and that unquoted glob lists work in your Cursor version.
- REQUIRES VALIDATION: Confirm which tools in use read `AGENTS.md`.
