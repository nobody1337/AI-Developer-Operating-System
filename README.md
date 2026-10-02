# AI Developer Operating System (AI-DOS)

A model-, provider- and IDE-independent operating system **for how AI agents
take part in software development**: governance, roles, skills, workflows,
model registry, capability-based routing, human approval gates and (conceptual)
orchestration. Cursor is the primary integration layer, not the architecture.

> Version 0 — documentation only (Markdown, YAML, MDC). No application code,
> no packages, no orchestrator. See [what is active today](#what-is-active-today-vs-conceptual).

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
- **Project integration** — `.cursor/` (rules, commands, skill adapters), [AGENTS.md](AGENTS.md), [project profile](templates/project-profile.yaml).

Rationale: [ADR-000](governance/decisions/000-initial-ai-dos-architecture.md).

## Repository structure

```text
/
├── README.md                 this file
├── AGENTS.md                 compact entry point for any AI agent
├── .gitignore  .gitattributes  .editorconfig
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
├── skills/                   11 tool-agnostic skills (SKILL.md each)
├── templates/                artifact, request and extension templates
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

| Option | How | Trade-off |
|---|---|---|
| **Copy (vendoring)** | Copy `governance/`, `orchestration/`, `skills/`, `templates/`, `checklists/` into `ai-dos/` in the project; copy `.cursor/` and `AGENTS.md` to the project root | Simple; updates are manual |
| **Git submodule** | Add AI-DOS as submodule at `ai-dos/`; copy `.cursor/rules`, `.cursor/commands`, `.cursor/skills` to the project root (Cursor loads them from the workspace `.cursor/`) | Versioned updates; rule copies still needed |
| **Reference only** | Project `AGENTS.md` links to a published AI-DOS location | Lightweight; agents must fetch the documents |

Steps:

1. Add `ai-dos.project.yaml` from [templates/project-profile.yaml](templates/project-profile.yaml)
   (owner, default data sensitivity, risk overrides, approved models, real build/test commands).
2. **Adjust paths.** Rules and commands reference AI-DOS files repository-root-relative
   (e.g. `governance/policies/risk-classification.md`). When AI-DOS lives under
   `ai-dos/`, prefix these paths (`ai-dos/governance/…`) in the copied `.cursor/` files and `AGENTS.md`.
3. Write a short project `AGENTS.md` that states project rules and links to AI-DOS.
4. **Project overrides rank higher** (rank 5) than AI-DOS (rank 6): projects may
   tighten rules or raise risk for paths (e.g. `src/billing/** → CRITICAL`), but
   may not weaken the [Security Baseline](governance/principles/governance-hierarchy.md#security-baseline-cannot-be-lowered-by-project-or-company-rules).
5. Back governance with real controls where available: branch protection,
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
| `08-documentation.mdc` | globs: Markdown/docs | Documentation governance |
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
They are auto-discoverable by description (no `disable-model-invocation`).

`.cursorignore`: Cursor does not allow agents to create this file. Copy
[templates/cursorignore.template](templates/cursorignore.template) to
`.cursorignore` manually. It is best-effort, not a security boundary.

## What is active today vs conceptual

| Component | Status | Notes |
|---|---|---|
| Cursor rules loading (`.cursor/rules/*.mdc`) | **Active — native Cursor** | always / glob / agent-requested as configured |
| `AGENTS.md` | **Active where the tool supports it** | Cursor and several agents read it (REQUIRES VALIDATION per tool/version) |
| `.gitignore` | **Active — native git** | Once the repository is initialised |
| `.cursorignore` | **Active, best-effort** — after manual creation | Not a security boundary |
| Cursor commands (`.cursor/commands`) | **Active when invoked** | The agent follows the linked documents by convention |
| Cursor skills (`.cursor/skills`) | **Active when invoked/discovered** | Adapters only |
| Governance, roles, workflows, checklists, templates | Governance Definition | Followed by convention; not enforced |
| Risk classification, approval gates, quality gates | Governance Definition | Real enforcement only via external tooling (branch protection, CI, permissions) |
| Model registry | Data, examples only | No verified entries |
| Model routing / selection | **Manual** | Agent recommends; human selects model in the IDE |
| Task state, audit records, context packages | **Conceptual** | Schemas only; may be used manually |
| Orchestrator | **Conceptual** | [future-orchestrator.md](orchestration/future-orchestrator.md) |

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

## Self-review

The initial consistency and quality review is documented in
[governance/reviews/0001-initial-self-review.md](governance/reviews/0001-initial-self-review.md).

## Status and open questions

This repository is not yet a git repository. Open questions (git
initialisation, integration method, committing task state, licence, skill
invocation mode) are listed in [ADR-000](governance/decisions/000-initial-ai-dos-architecture.md#open-questions).
