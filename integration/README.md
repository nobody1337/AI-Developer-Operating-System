# Project Integration (Central and Embedded AI-DOS)

Status: Governance Definition for structure, file classes and provenance.
Initialization and update are **Conceptual** workflows: nothing executes them
automatically; a human performs them, optionally assisted by an agent.
Rationale: [ADR-001](../governance/decisions/001-embedded-project-integration.md).

## Central AI-DOS and Embedded AI-DOS

| Term | Meaning |
|---|---|
| **Central AI-DOS** (master) | This repository. Blueprint, source of new instances, template repository, governance source and update source. It has its own version cycle ([versioning](versioning.md)). |
| **Embedded AI-DOS** (project instance) | The AI-DOS instance inside a software project, in `.ai-dos/` plus the project's `.cursor/` files and `AGENTS.md`. It is part of the project and is versioned with the project. It may contain local, documented project changes. |

```text
Central AI-DOS ──initialize / update (human action)──▶ Software project
                                                       ├── .ai-dos/      embedded instance
                                                       ├── .cursor/      generated rules, commands, skill adapters + project files
                                                       ├── AGENTS.md     project entry point
                                                       └── src/, tests/, …
```

Integration mode `embedded` is the only supported mode. A project works
**without access to the Central AI-DOS**: no absolute paths, no reference to the
master location, no rule that needs the master open, no external file, no
dependency on another git repository. The master is needed only for new
projects, updates, templates, AI-DOS evolution, migrations and central
architecture changes.

Integration copies files, but an embedded file is never a copy without
provenance: [manifest.yaml](manifest.schema.yaml) records the project AI-DOS
version, the source AI-DOS version, the schema version and the integration
date, and lists which paths are managed, generated or locally modified.

### What the master may do

Publish new governance, define new roles, update skills, update templates,
define new workflows, evolve the model registry, provide migrations — always
as a new AI-DOS version that projects adopt through the
[update workflow](update.md).

### What a project may and may not do

A project may define its project profile, add project rules, restrict allowed
models, activate or deactivate skills, configure workflows and define
additional project governance. It may not weaken the Security Baseline, bypass
human approval, redefine central risk levels, contradictorily redefine global
terms or secretly disable governance. The authoritative rule is
[governance hierarchy – project-level overrides](../governance/principles/governance-hierarchy.md#project-level-overrides).

## Layout of an embedded instance

```text
<project>/
├── AGENTS.md                         project entry point (template: templates/project-agents.md)
├── .gitignore                        project-owned; contains the AI-DOS block (templates/project-gitignore.template)
├── .cursorignore                     created manually by the human (templates/cursorignore.template)
├── .cursor/
│   ├── rules/00-…11-*.mdc            generated from the master rules
│   ├── rules/50-…99-project-*.mdc    project rules (project-owned)
│   ├── commands/*.md                 generated AI-DOS commands + project commands
│   └── skills/aidos-*/SKILL.md       generated adapters for enabled skills + project adapters
└── .ai-dos/
    ├── manifest.yaml                 installation and provenance
    ├── project-profile.yaml          project description and project rules
    ├── governance/                   managed copy
    ├── orchestration/                managed copy (roles, models, routing, global workflows, state schemas)
    ├── skills/                       managed copy
    ├── templates/                    managed copy
    ├── checklists/                   managed copy
    ├── integration/                  managed copy (this document, schemas, versioning, workflows)
    ├── workflows/                    project-owned: workflow configuration and project workflows
    ├── local/
    │   ├── rules/                    project-owned: additional project governance (Markdown)
    │   └── skills/                   project-owned: project procedures (SKILL.md)
    ├── state/
    │   ├── tasks/<task-id>/state.yaml   task state records
    │   └── runtime/                  git-ignored runtime data
    └── artifacts/
        ├── tasks/<task-id>/          task artifacts (plans, reports, approval records)
        ├── decisions/                default location for project ADRs (`architecture.adr_path`)
        └── updates/                  update records and conflict reports
```

The managed directories mirror the master layout exactly, so every relative
link inside them stays valid in the project. Global workflow definitions stay
in `orchestration/workflows/`; `.ai-dos/workflows/` only configures them for the
project and holds additional project workflows.

### Path convention

- Backticked paths beginning with `governance/`, `orchestration/`, `skills/`,
  `templates/`, `checklists/` or `integration/` are **AI-DOS-root-relative**: in
  the Central AI-DOS they resolve against the repository root, in an embedded
  instance against `.ai-dos/`.
- All other paths (`.cursor/…`, `AGENTS.md`, `src/…`) are project-root-relative.
- Generated project files (`.cursor/rules`, `.cursor/commands`,
  `.cursor/skills/aidos-*`, the managed block of `AGENTS.md`) carry the explicit
  prefix `.ai-dos/` so that Cursor and other tools find the files from the
  project root. Paths that already start with `.ai-dos/` are never prefixed again.

## File classification

| Master path | Class | Location in project | Project may modify? |
|---|---|---|---|
| `governance/**` | `copied` (managed) | `.ai-dos/governance/` | No — stricter project rules go to `.ai-dos/local/rules/` |
| `governance/decisions/**`, `governance/reviews/**` | `copied` (managed), master documentation | `.ai-dos/governance/…` | No — read-only provenance; project ADRs go to `architecture.adr_path` |
| `orchestration/**`, `skills/**`, `checklists/**`, `integration/**` | `copied` (managed) | `.ai-dos/…` | No |
| `templates/**` | `template` (copied, managed) | `.ai-dos/templates/` | No (the copies); filled artifacts live in `.ai-dos/artifacts/` |
| `.cursor/rules/00-governance.mdc`, `01-…`, `04-…`, `09-…` (always applied) | `generated` | `.cursor/rules/` | No |
| `.cursor/rules/02-…`, `05-…`, `06-…` (glob rules) | `generated`; globs derived from `technology.languages` | `.cursor/rules/` | Globs only, as a declared local modification |
| `.cursor/rules/03-…`, `07-…`, `08-…`, `10-…`, `11-…` | `generated` | `.cursor/rules/` | No |
| `.cursor/commands/*.md` | `generated` | `.cursor/commands/` | No (add project commands instead) |
| `.cursor/skills/aidos-*/SKILL.md` | `generated` (only enabled skills) | `.cursor/skills/` | No (enable/disable via profile) |
| — | `generated` | `.ai-dos/manifest.yaml` | Only through initialize/update, and `local_modifications` with approval |
| — | `generated` | managed block in `AGENTS.md`, AI-DOS block in `.gitignore` | No (outside the blocks: yes) |
| — | `project_specific` | `.ai-dos/project-profile.yaml`, `.ai-dos/local/**`, `.ai-dos/workflows/**`, `.cursor/rules/50-…99-project-*.mdc`, project commands and adapters, project part of `AGENTS.md` | Yes (governance-relevant parts are `CRITICAL`, see below) |
| — | `project_data` | `.ai-dos/state/**`, `.ai-dos/artifacts/**` | Yes, per [state and artifacts](state-and-artifacts.md) |
| `README.md`, `CHANGELOG.md` | `master_docs` | not copied | — |
| `VERSION`, master `AGENTS.md`, `.gitignore`, `.gitattributes`, `.editorconfig`, `.cursorignore` | `master_only` | not copied (the project keeps its own) | — |

A declared local modification is recorded in `integration.local_modifications`
of the manifest with path, change, reason and approval reference. It may never
weaken the Security Baseline. Undeclared changes to managed or generated files
are treated as conflicts by the [update workflow](update.md) and reported as
`RISK:` (possible tampering).

Risk of changes inside a project: initializing or updating an embedded
instance, editing managed or generated files, `manifest.yaml`, `.ai-dos/local/`
or the `security`, `ai` and `local_rules` sections of the project profile is `CRITICAL`
([risk classification](../governance/policies/risk-classification.md#examples)).

## Configuration files

| File | Holds | Schema | Template |
|---|---|---|---|
| `.ai-dos/manifest.yaml` | Installation: project AI-DOS version, source AI-DOS version, schema version, integration date, integration mode, managed/generated paths, local modifications, compatibility, governance profile, features, applied migrations | [manifest.schema.yaml](manifest.schema.yaml) | `templates/manifest.yaml` |
| `.ai-dos/project-profile.yaml` | Project: identity, technology, architecture, tooling, repository, security (data sensitivity, restrictions, risk overrides), AI restrictions (roles, skills, workflows, models), approvers, local rules | [project-profile.schema.yaml](project-profile.schema.yaml) | `templates/project-profile.yaml` |

Each value has exactly one home. Credentials, API keys, tokens and secrets
never appear in either file.

## Global → Project → Task in an embedded instance

The levels and their priority are defined in
[governance hierarchy – scopes](../governance/principles/governance-hierarchy.md#scopes-global--project--task).
They map to files as follows:

| Level | Where it lives |
|---|---|
| Global | Managed copies in `.ai-dos/governance/`, `orchestration/`, `skills/`, `checklists/`, `templates/`, generated `.cursor/` files |
| Project | `.ai-dos/project-profile.yaml`, `.ai-dos/local/`, `.ai-dos/workflows/`, `.cursor/rules/50-…99-project-*.mdc`, project part of `AGENTS.md` |
| Task | Task Specification and artifacts in `.ai-dos/artifacts/tasks/<task-id>/`, state record in `.ai-dos/state/tasks/<task-id>/state.yaml` |

## What Cursor executes today vs. convention vs. future automation

| Topic | Cursor executes today | AI-DOS convention | Future automation (not implemented) |
|---|---|---|---|
| Project rules | Loads `.cursor/rules/*.mdc` from the opened project (always / glob / agent-requested) | Rules point to `.ai-dos/` documents, which agents read | — |
| `AGENTS.md` | Read where the tool supports it (REQUIRES VALIDATION per version) | Entry point to the embedded instance | — |
| Skill adapters | Offered when invoked explicitly (`disable-model-invocation: true`) | Adapter points to `.ai-dos/skills/…` | Automatic skill selection by task type, role, capabilities, risk, project profile |
| Manifest and profile | Nothing parses them | Agents read them by convention | Schema validation, routing with project restrictions |
| Initialize / update | Nothing | Human follows [initialize](initialize.md) / [update](update.md), optionally with an agent | Integrator with drift detection and three-way comparison |

## Workflows

- [initialize.md](initialize.md) — Initialize AI-DOS in a project (conceptual).
- [update.md](update.md) — Update AI-DOS in a project, including the conflict mechanism and rollback (conceptual).
- [versioning.md](versioning.md) — Versioning, compatibility, breaking changes, migration, deprecation, upgrade, rollback.
- [state-and-artifacts.md](state-and-artifacts.md) — What a project versions and what it ignores.
