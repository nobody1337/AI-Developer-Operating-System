# AI Developer Operating System (AI-DOS)

A model-, provider- and IDE-independent operating system **for how AI agents
take part in software development**: governance, roles, skills, workflows,
model registry, capability-based routing, human approval gates and (conceptual)
orchestration. Cursor is the primary integration layer, not the architecture.

> Version 0.1.0 ([VERSION](VERSION), [CHANGELOG](CHANGELOG.md)) — documentation only
> (Markdown, YAML, MDC). No application code, no packages, no orchestrator. See
> [what Cursor executes today](#what-cursor-executes-today-vs-convention-vs-future-automation).
> This repository is the **Central AI-DOS** (master); projects contain an
> **Embedded AI-DOS** ([project integration](#integrating-ai-dos-into-a-software-project)).

## Why AI-DOS exists

AI should not just produce as much code as possible. It should support
software development **systematically, traceably, securely, testably and
professionally**. The central question is not *"which model is best?"* but:

> What task is this, which role is needed, which capabilities are required,
> what is the risk, what context is needed, which model fits, and what human
> control is required?

AI-DOS answers that question with explicit rules, so the answer does not
depend on whichever model or tool is popular this month.

## Architecture

```text
Governance | Roles | Skills | Workflows | Model Registry | Model Routing | Orchestration | Project Integration
```

- **Governance** ([governance/](governance/README.md)) — what must be true: principles, hierarchy, risk, approvals, security, quality, AI honesty. Independent of models, providers and IDEs.
- **Roles** ([orchestration/roles/](orchestration/roles/README.md)) — responsibilities with capabilities, permissions, inputs, outputs. **Role ≠ model, role ≠ skill.**
- **Skills** ([skills/](skills/README.md)) — tool-agnostic procedures (how work is done).
- **Workflows** ([orchestration/workflows/](orchestration/workflows/README.md)) — sequences of roles and gates; reference capabilities, never model names.
- **Model registry and routing** ([orchestration/models/](orchestration/models/README.md), [orchestration/routing/](orchestration/routing/routing-policy.md)) — capabilities with evidence; selection by capability, risk, context, tools, quality, reliability, cost, latency.
- **Orchestration** ([orchestration/](orchestration/README.md)) — the flow, state, audit, handoffs; manual today, automated later.
- **Project integration** ([integration/](integration/README.md)) — Central AI-DOS → Embedded AI-DOS in each project (`.ai-dos/`, generated `.cursor/` files, `AGENTS.md`); manifest, project profile, versioning, initialize and update workflows.

Rationale: [ADR-000](governance/decisions/000-initial-ai-dos-architecture.md).

## Repository structure

```text
/
├── README.md                 this file
├── AGENTS.md                 compact entry point for any AI agent
├── VERSION  CHANGELOG.md     AI-DOS version and change history
├── .gitignore  .gitattributes  .editorconfig  .cursorignore
├── .cursor/
│   ├── rules/                12 small .mdc rules (summaries + links)
│   ├── commands/             slash commands (/classify-task, /plan, /review, …)
│   └── skills/               aidos-* adapters pointing to /skills
├── governance/
│   ├── vocabulary.md         canonical identifiers (risk levels, roles, states, artifacts …)
│   ├── principles/           core principles, governance hierarchy
│   ├── policies/             working method, risk, human approval, dependencies, git, documentation
│   ├── security/             security policy, AI security, secrets & data, agent permissions
│   ├── architecture/         architecture governance
│   ├── quality/              engineering standards, testing, code review, quality gates, Definition of Done
│   ├── ai/                   AI governance, communication protocol, context management
│   ├── decisions/            ADRs about AI-DOS
│   └── reviews/              governance self-reviews
├── orchestration/
│   ├── roles/                10 base roles + specialisation model
│   ├── models/               registry.yaml, capabilities.yaml, selection, lifecycle, evaluation, adding a model
│   ├── routing/              task classification, routing policy, escalation
│   ├── workflows/            feature, bugfix, refactoring, frontend, backend, fullstack, security, testing, release
│   ├── state/                state model, audit model, context packages, handoffs (conceptual schemas)
│   └── future-orchestrator.md
├── integration/              central vs embedded AI-DOS, .ai-dos/ layout, manifest + profile schemas, versioning, initialize/update
├── skills/                   11 tool-agnostic skills (SKILL.md each)
├── templates/                artifact, request, extension and project integration templates
└── checklists/               implementation, architecture, security, code review, AI-generated code, dependency, release
```

## How governance rules work

1. **Hierarchy** — explicit user requirement > legal/compliance > security >
   company rules > project rules > AI-DOS > ADRs > technical standards > best
   practices > model preferences. A user instruction cannot authorise illegal
   actions or silently bypass the Security Baseline; bypassing a gate needs an
   explicit, acknowledged, recorded human decision
   ([hierarchy](governance/principles/governance-hierarchy.md)).
2. **Single source of truth** — each rule lives in one governance document.
   Cursor rules, `AGENTS.md`, commands and skills summarise and link.
3. **Status labels** — every document says whether it is a *Governance
   Definition* (convention), *Actual Automated Orchestration* (tool-enforced)
   or *Conceptual*.
4. **Risk drives control** — `LOW`, `MEDIUM`, `HIGH`, `CRITICAL` determine
   planning, testing, review independence and approval
   ([risk classification](governance/policies/risk-classification.md)).
5. **Honesty** — AI output is unverified until validated; no claims of
   unperformed tests, reads or checks ([AI governance](governance/ai/ai-governance.md)).

## Roles

Ten base roles: `planner`, `architect`, `frontend-developer`,
`backend-developer`, `database-engineer`, `devops-engineer`, `tester`,
`security-reviewer`, `code-reviewer`, `release-manager`. Domain roles are
specialisations, e.g. `planner[frontend]` (Frontend Planner),
`code-reviewer[accessibility]` (Accessibility Reviewer), `code-reviewer[api]`
(API Reviewer). Each role defines purpose, responsibilities, inputs, outputs,
allowed/forbidden actions, required capabilities, permissions (`read`,
`write`, `execute`, `install`, `delete`, `deploy`, `external_access`), review
requirements, escalation conditions and handoffs. → [roles](orchestration/roles/README.md)

## Skills

Eleven procedures: architecture, frontend, backend, database, devops,
testing, security, debugging, refactoring, documentation, code-review. Each
describes purpose, when to use, inputs, procedure, outputs, quality criteria
and pitfalls. Roles *use* skills; skills grant no permissions. → [skills](skills/README.md)

## Model routing

1. Classify the task ([task classification](orchestration/routing/task-classification.md)).
2. Classify the risk.
3. Select workflow and role(s).
4. Derive required capabilities (role minimums + complexity profile + task).
5. Filter the [registry](orchestration/models/registry.yaml) by status, data
   sensitivity, capabilities, tools, independence; rank by quality,
   reliability, cost, latency ([selection policy](orchestration/models/selection-policy.md)).

Cost and speed never override security or quality. Confidential or restricted
data may require local models. Escalation: `LOW` complexity →
`fast_implementation`, `MEDIUM` → `strong_reasoning`, `HIGH` →
`advanced_reasoning` + `independent_review` ([escalation](orchestration/routing/escalation.md)).

**Honest status:** in Cursor the model is selected by the human (or Cursor's
own selection). AI-DOS produces a capability-based *recommendation*. The
registry currently contains only `example` entries, so routing will always
answer "no approved model — please select one that meets this profile".

## Orchestration

```text
Request → Task Classification → Risk Classification → Role Selection → Model Selection
→ Planning → Architecture → Implementation → Testing → Independent Review
→ Security Review → Human Approval → Completion
```

Which steps are mandatory depends on the risk level
([orchestration flow](orchestration/README.md#orchestration-flow)). Agents hand
off **artifacts** (Task Specification, Implementation Plan, ADR, Risk
Assessment, Implementation Report, Test Report, Review Report, Security Report,
Approval Record), not chat history ([handoffs](orchestration/state/handoffs.md)).
Task state, audit records and context packages have conceptual schemas in
[orchestration/state/](orchestration/state/README.md).

## Human approval

| Risk | Gate |
|---|---|
| `LOW` | AI may implement and validate |
| `MEDIUM` | AI may implement; review required before merge |
| `HIGH` | Plan approval; implementation review; security review where required |
| `CRITICAL` | Explicit human approval before execution |

Protected actions — production deployment, data deletion, irreversible
migrations, secrets and credentials, security policy changes, force push and
destructive git/filesystem operations, financial operations, external
communication, installing packages, changing governance, disabling tests or
security checks — always need explicit approval, recorded with the
[Approval Record](templates/approval-record.md) template.
→ [human approval](governance/policies/human-approval.md)

## How to add a new model

Register as `discovered` with everything `unknown` → check data handling
(`candidate`) → evaluate with evidence (`evaluated`) → human approves roles and
maximum data sensitivity (`approved`) → optionally `preferred` after a
documented comparison. Never preferred just because it is new.
Details: [adding-a-model.md](orchestration/models/adding-a-model.md), command `/register-model`.
Roles and workflows do not change when models change.

## How to create a new workflow

Copy [templates/workflow.md](templates/workflow.md), use only role ids and
capability ids from the vocabulary, keep all risk gates (a workflow may add
gates, never remove them), add it to the [workflow index](orchestration/workflows/README.md).
Workflow changes are governance changes.

## Integrating AI-DOS into a software project

Embedded, project-local integration is the AI-DOS standard
([decision 4](governance/README.md#4-project-integration),
[ADR-001](governance/decisions/001-embedded-project-integration.md)). Each
project owns its **Embedded AI-DOS**:

```text
<project>/
├── .ai-dos/      manifest.yaml, project-profile.yaml, governance/, orchestration/, skills/,
│                 templates/, checklists/, integration/ (managed copies), workflows/, local/, state/, artifacts/
├── .cursor/      rules/, commands/, skills/ (generated from this repository + project files)
├── AGENTS.md     project entry point
└── src/, tests/, …
```

Opening the project in Cursor is enough: `.ai-dos/`, `.cursor/` and `AGENTS.md`
work without this repository — no absolute paths, no dependency on the master
location. The Central AI-DOS is needed only for new projects, updates,
templates, AI-DOS evolution and migrations.

- Structure, file classes, path convention, provenance: [integration/README.md](integration/README.md)
- Manifest and project profile: [manifest schema](integration/manifest.schema.yaml), [profile schema](integration/project-profile.schema.yaml)
- Workflows (partly automated by `install.ps1`): [initialize](integration/initialize.md), [update](integration/update.md)
- Multi-tool: copy this folder to `<project>/.ai-dos/` and run `.ai-dos/install.ps1`; it generates adapters for Cursor, Claude Code, OpenAI Codex and GitHub Copilot ([tool adapters](integration/README.md#tool-adapters), [ADR-002](governance/decisions/002-multi-tool-adapters.md))
- Versioning: [integration/versioning.md](integration/versioning.md) · state and artifacts: [integration/state-and-artifacts.md](integration/state-and-artifacts.md)

Project rules rank higher (rank 5) than AI-DOS (rank 6): projects may tighten
rules or raise risk for paths (e.g. `src/billing/** → CRITICAL`), but may not
weaken the Security Baseline
([project-level overrides](governance/principles/governance-hierarchy.md#project-level-overrides)).
Back governance with real controls where available: branch protection,
required reviewers, CI, deployment permissions, Cursor command-approval settings.

## Cursor integration

| Rule | Scope | Purpose |
|---|---|---|
| `00-governance.mdc` | always | Hierarchy, Security Baseline, trust, links |
| `01-working-method.mdc` | always | Inspect → classify → plan → implement → validate → report |
| `02-code-quality.mdc` | globs: source files | Engineering standards |
| `03-architecture.mdc` | agent-requested (description) | Architecture governance |
| `04-security.mdc` | always | Protected actions, secrets, untrusted content |
| `05-testing.mdc` | globs: test files | Testing governance |
| `06-dependencies.mdc` | globs: dependency manifests | Dependency governance |
| `07-git.mdc` | agent-requested | Git governance |
| `08-documentation.mdc` | agent-requested (description) | Documentation governance ([decision 6](governance/README.md#6-documentation-rule)) |
| `09-ai-safety.mdc` | always | Honesty, communication protocol |
| `10-review.mdc` | agent-requested | Review process |
| `11-orchestration.mdc` | agent-requested (description) | Routing, roles, escalation, handoffs |

Each rule uses exactly one activation mode (always, globs, or description) because
the behaviour of combining `globs` and description-based requests is not
documented clearly (REQUIRES VALIDATION). Glob lists use Cursor's unquoted
comma-separated frontmatter format, which is not strict YAML.

Commands (`.cursor/commands/`): `/classify-task`, `/risk-assessment`, `/plan`,
`/review`, `/security-review`, `/new-adr`, `/register-model`,
`/request-approval`, `/handoff`, `/done-check`.

Skills (`.cursor/skills/aidos-*`): thin adapters that point to `skills/*/SKILL.md`.
They are explicit-only (`disable-model-invocation: true`,
[decision 5](governance/README.md#5-skill-adapters)); automatic skill selection
is future orchestration.

In a project, these files are generated with the prefix `.ai-dos/` in every
AI-DOS path ([path convention](integration/README.md#path-convention)).

`.cursorignore`: Cursor does not allow agents to create this file. Copy
[templates/cursorignore.template](templates/cursorignore.template) to
`.cursorignore` manually. It is best-effort, not a security boundary.

## What Cursor executes today vs convention vs future automation

### What Cursor executes today

| Component | Behaviour |
|---|---|
| Cursor rules (`.cursor/rules/*.mdc`) | Loaded natively: always / glob / agent-requested as configured |
| `AGENTS.md` | Read where the tool supports it (REQUIRES VALIDATION per tool/version) |
| `.cursorignore` | Honoured best-effort; not a security boundary |
| Cursor commands (`.cursor/commands`) | Offered when invoked |
| Cursor skill adapters (`.cursor/skills/aidos-*`) | Offered when invoked explicitly (REQUIRES VALIDATION of `disable-model-invocation` in your version) |
| `.gitignore` | Applied natively by git |

### What AI-DOS defines as a convention

| Component | Status |
|---|---|
| Governance, roles, workflows, skills, checklists, templates | Governance Definition — followed by agents and humans; not enforced |
| Risk classification, approval gates, quality gates | Governance Definition — real enforcement only via external tooling (branch protection, CI, permissions) |
| Model registry and routing | Data (examples only) and manual recommendation; the human selects the model in the IDE |
| Embedded AI-DOS: manifest, project profile, file classes, path convention | Governance Definition — agents read the files; no tool parses them |
| Initialize and update AI-DOS in a project | Human copy step + `install.ps1` (adapters, manifest, conflict detection); analysis, decisions, review manual ([initialize](integration/initialize.md) / [update](integration/update.md)) |
| Task state, audit records, context packages | Conceptual schemas; may be used manually |

### What is future automation

| Component | Reference |
|---|---|
| Orchestrator (classification, routing, agent execution, gates, approval service, policy engine) | [future-orchestrator.md](orchestration/future-orchestrator.md) |
| Automatic skill selection by task type, role, capabilities, risk, project profile | [decision 5](governance/README.md#5-skill-adapters) |
| Three-way comparison of managed copies during update | [update](integration/update.md) |
| Validators for manifest, profile, artifacts and state files | [future-orchestrator.md](orchestration/future-orchestrator.md#possible-incremental-path) |

None of this exists as code. The only executable file in this repository is
`install.ps1` (adapter generation with hash-based drift detection for
generated files).

## Deviations from the requested target structure

| Deviation | Reason |
|---|---|
| No `governance/workflows/`; workflows only in `orchestration/workflows/` | Avoid duplication; workflows reference governance policies |
| Added `governance/vocabulary.md` | Single source for identifiers to keep all files consistent |
| Added `governance/reviews/` | Self-review documents are not ADRs |
| Specialised roles (Frontend Planner, UX/Accessibility/API Reviewer, …) are specialisations `<base-role>[<domain>]`, not separate files | Keeps permissions in one place per base role |
| Definition of Done in `governance/quality/definition-of-done.md`, not `checklists/` | It is a governance rule; checklists link to it |
| Added `checklists/dependency.md`, `templates/role.md`, `templates/workflow.md`, `templates/skill.md`, `templates/project-profile.yaml` | Needed for dependency verification, extension and project integration |
| Review Report template is `templates/code-review.md` | As requested; artifact id `review_report` |
| `.cursorignore` delivered as `templates/cursorignore.template` | Cursor blocks agents from writing `.cursorignore` |
| Added `.gitattributes` | Normalises LF line endings despite `core.autocrlf=true` on Windows |
| Cursor skill adapters prefixed `aidos-` | Avoid name collisions with other skills |
| Manifest holds installation, provenance, compatibility and features only; project identity, security and model restrictions live only in `project-profile.yaml` | One home per value (deviation from the original manifest example) |
| Integer `schema_version` (e.g. `1`) instead of `"1.0"` | Consistent with all existing schemas |
| Profile key `security.data_sensitivity` instead of `data_classification` | Matches the vocabulary term "data sensitivity" |
| Project-owned `.ai-dos/workflows/` and `.ai-dos/local/`; global workflows stay in `orchestration/workflows/` | Managed copies mirror the master so links stay valid; ownership per directory keeps updates safe |
| Added `integration/`, `VERSION`, `CHANGELOG.md` | Project integration layer, single version source, change history |
| `governance/decisions/` and `governance/reviews/` are copied read-only into projects | Keeps links in copied governance valid; provenance |

## Self-review

Reviews: [0001 initial self-review](governance/reviews/0001-initial-self-review.md),
[0002 embedded integration self-review](governance/reviews/0002-embedded-integration-self-review.md).
Neither is independent; see [decision 2](governance/README.md#2-adr-000).

## Status and decisions

The repository is a git repository; initialization and the baseline commit
were human actions ([decision 1](governance/README.md#1-git)). AI-DOS does not
depend on any remote. ADR-000 and ADR-001 are `Proposed` until an independent
review. All binding decisions: [governance/README.md](governance/README.md#binding-decisions-2026-10-02).

## License

License status: Not licensed for redistribution.

The repository is hosted publicly; this makes it visible but does not grant a
license ([decision 7](governance/README.md#7-license)).
