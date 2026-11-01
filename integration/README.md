# Project Integration (Central and Embedded AI-DOS)

Status: Governance Definition for structure, file classes and provenance.
Initialization and update are **partly automated**: the human copies the master
folder and runs `.ai-dos/install.ps1`, which generates all tool adapters,
the manifest and the profile skeleton and detects conflicts; analysis, profile
content, conflict decisions, review and approval stay human steps
([initialize](initialize.md), [update](update.md)).
Rationale: [ADR-001](../governance/decisions/001-embedded-project-integration.md),
[ADR-002](../governance/decisions/002-multi-tool-adapters.md).

## Central AI-DOS and Embedded AI-DOS

| Term | Meaning |
|---|---|
| **Central AI-DOS** (master) | This repository. Blueprint, source of new instances, template repository, governance source and update source. It has its own version cycle ([versioning](versioning.md)). |
| **Embedded AI-DOS** (project instance) | The AI-DOS instance inside a software project, in `.ai-dos/` plus the project's generated tool adapters (`AGENTS.md`, `.cursor/`, `.agents/`, `CLAUDE.md`, `.claude/`, `.github/`). It is part of the project and is versioned with the project. It may contain local, documented project changes. |

```text
Central AI-DOS ──copy folder + .ai-dos/install.ps1 (human action)──▶ Software project
                                                       ├── .ai-dos/      embedded instance (+ install.ps1)
                                                       ├── AGENTS.md     shared entry point (Cursor, Codex, Copilot; Claude via import)
                                                       ├── CLAUDE.md, .claude/   Claude Code adapters
                                                       ├── .cursor/      Cursor rules and commands + project files
                                                       ├── .agents/      shared skill adapters (Cursor, Codex, Copilot)
                                                       ├── .github/      Copilot instructions and prompts
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
├── AGENTS.md                         shared entry point; project section + AI-DOS block (templates/project-agents.md)
├── CLAUDE.md                         Claude Code entry point; project section + block importing @AGENTS.md (templates/project-claude.md)
├── .gitignore                        project-owned; contains the AI-DOS block (templates/project-gitignore.template)
├── .cursorignore                     created manually by the human (templates/cursorignore.template)
├── .cursor/
│   ├── rules/00-…11-*.mdc            generated from the master rules
│   ├── rules/50-…99-project-*.mdc    project rules (project-owned)
│   ├── commands/*.md                 generated AI-DOS commands + project commands
│   └── skills/                       project skill adapters only (AI-DOS adapters are in .agents/skills/)
├── .agents/skills/aidos-*/           generated shared skill adapters: SKILL.md + agents/openai.yaml (Codex)
├── .claude/
│   ├── rules/aidos-*.md              generated path-scoped rules (glob rules 02, 05, 06)
│   ├── commands/aidos-*.md           generated commands and skill adapters
│   └── settings.json                 created once (stricter permissions, claudeMdExcludes), then project-owned
├── .github/
│   ├── copilot-instructions.md       project section + AI-DOS block (templates/project-copilot-instructions.md)
│   ├── instructions/aidos-*.instructions.md   generated path-specific rules (glob rules)
│   └── prompts/aidos-*.prompt.md     generated commands as prompt files
└── .ai-dos/
    ├── install.ps1                   installer (copied from the master)
    ├── VERSION                       source version read by install.ps1
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
    (also present because the whole folder is copied, inactive:
     AGENTS.md, CLAUDE.md, .cursor/ = generator sources; README.md, CHANGELOG.md,
     docs/ = master documentation; .gitignore, .gitattributes, .editorconfig,
     .cursorignore = master files that only affect paths inside .ai-dos/)
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
- Generated project files (all tool adapters listed under
  [tool adapters](#tool-adapters) and the AI-DOS blocks of the entry files)
  carry the explicit prefix `.ai-dos/` so that every tool finds the files from
  the project root. Paths that already start with `.ai-dos/` are never prefixed again.

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
| `.cursor/commands/*.md` | `generated` | `.cursor/commands/`; also `.claude/commands/aidos-*.md`, `.github/prompts/aidos-*.prompt.md` | No (add project commands instead) |
| `.cursor/skills/aidos-*/SKILL.md` | `generated` (only enabled skills) | `.agents/skills/aidos-*/` (+ `agents/openai.yaml`), `.claude/commands/aidos-*.md` — not `.cursor/skills/` (ADR-002) | No (enable/disable via profile) |
| `.cursor/rules/02-…`, `05-…`, `06-…` (glob rules) | `generated` | also `.claude/rules/aidos-*.md`, `.github/instructions/aidos-*.instructions.md` | Globs only, as a declared local modification |
| `install.ps1`, `VERSION` | `copied` (managed) | `.ai-dos/install.ps1`, `.ai-dos/VERSION` | No |
| `templates/adapters/claude-settings.json` | `template` | `.claude/settings.json`, created once if missing | Yes, afterwards `project_specific`; only stricter, never weaker |
| — | `generated` | `.ai-dos/manifest.yaml` | Only through initialize/update, and `local_modifications` with approval |
| — | `generated` | AI-DOS blocks in `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `.gitignore` | No (outside the blocks: yes) |
| — | `project_specific` | `.ai-dos/project-profile.yaml`, `.ai-dos/local/**`, `.ai-dos/workflows/**`, `.cursor/rules/50-…99-project-*.mdc`, project commands and adapters, project parts of `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` | Yes (governance-relevant parts are `CRITICAL`, see below) |
| — | `project_data` | `.ai-dos/state/**`, `.ai-dos/artifacts/**` | Yes, per [state and artifacts](state-and-artifacts.md) |
| `README.md`, `CHANGELOG.md`, `docs/**` | `master_docs` | carried in `.ai-dos/` by the folder copy; inactive reference | — |
| master `AGENTS.md`, master `CLAUDE.md`, `.cursor/**` | `master_only` | carried in `.ai-dos/`; generator sources for `install.ps1`, not entry points (see [inactive master copies](#inactive-master-copies)) | No |
| `.gitignore`, `.gitattributes`, `.editorconfig`, `.cursorignore` | `master_only` | carried in `.ai-dos/`; affect only paths inside `.ai-dos/`; the project keeps its own root files | — |

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
| Global | Managed copies in `.ai-dos/governance/`, `orchestration/`, `skills/`, `checklists/`, `templates/`, generated tool adapters and AI-DOS blocks |
| Project | `.ai-dos/project-profile.yaml`, `.ai-dos/local/`, `.ai-dos/workflows/`, `.cursor/rules/50-…99-project-*.mdc`, project parts of `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` |
| Task | Task Specification and artifacts in `.ai-dos/artifacts/tasks/<task-id>/`, state record in `.ai-dos/state/tasks/<task-id>/state.yaml` |

## Tool adapters

`.ai-dos/install.ps1` generates the adapters for all supported tools every
time (no selection) from one source: the master `.cursor/rules`,
`.cursor/commands` and `.cursor/skills/aidos-*` carried in `.ai-dos/.cursor/`,
rendered through `templates/` and `templates/adapters/`
([ADR-002](../governance/decisions/002-multi-tool-adapters.md)).

| Tool | Entry point it reads | How it reaches the AI-DOS rules | Skills / commands |
|---|---|---|---|
| Cursor | `.cursor/rules/*.mdc`, `AGENTS.md` | Rules natively (always / glob / agent-requested); `AGENTS.md` block | `.agents/skills/aidos-*` (`/aidos-<skill>`), `.cursor/commands/` (`/<command>`) |
| Claude Code | `CLAUDE.md` | Block imports `@AGENTS.md` (always-applied rules, conditional rule index); glob rules as `.claude/rules/aidos-*.md` (`paths`) | `.claude/commands/aidos-*.md` (`/aidos-<name>`, `disable-model-invocation: true`) |
| OpenAI Codex | `AGENTS.md` (root to working directory) | `AGENTS.md` block embeds the always-applied rules and lists the conditional rule files | `.agents/skills/aidos-*` (`$aidos-<skill>`, `allow_implicit_invocation: false`); commands: ask Codex to follow `.cursor/commands/<command>.md` |
| GitHub Copilot | `.github/copilot-instructions.md`; `AGENTS.md` on agent surfaces | Block repeats the generated rule sections (Copilot cannot import); glob rules as `.github/instructions/aidos-*.instructions.md` (`applyTo`) | `.agents/skills/aidos-*`; `.github/prompts/aidos-*.prompt.md` (`/aidos-<command>`) |

Rules of the installer: existing project files are never overwritten; only the
marked AI-DOS block of an entry file is inserted or replaced. Whole generated
files carry a provenance marker
`ai-dos:generated (…) source=<.ai-dos/… path> sha256=<hash>` after their
frontmatter, blocks carry an `ai-dos:hash` line. Statuses: `created`,
`inserted` (block added to an existing file), `unchanged`, `outdated` (run
`-Update`), `updated`, `keep_local` (declared local modification), `conflict`
(no marker, or edited since generation: not touched), `removed_proposed`
(no longer expected: never deleted), `action` (human step, e.g.
`.cursorignore`), `info`. `-WhatIf` writes nothing. Exit code 1 if conflicts
exist, 2 on a failed preflight.

To regenerate a file or block reported as `conflict`, a human decides: keep it
(declare it in `integration.local_modifications` if it is a generated file),
or delete the file or the block (markers included) and run `install.ps1`
again.

### Inactive master copies

Copying the whole folder brings the master entry files into `.ai-dos/`. Tools
that discover nested files could pick them up:

| File in `.ai-dos/` | Possible discovery | Handling |
|---|---|---|
| `AGENTS.md` | Codex only when started inside `.ai-dos/`; Cursor and Copilot when working on files inside `.ai-dos/` (nested `AGENTS.md`) | File states that it is an inactive copy and points to the root `AGENTS.md`; content is the same governance with `.ai-dos/`-relative paths; `templates/cursorignore.template` lists it |
| `CLAUDE.md` | Claude Code loads subdirectory `CLAUDE.md` on demand | Excluded by `claudeMdExcludes` in the generated `.claude/settings.json`; file states that it is inactive |
| `.cursor/rules`, `.cursor/skills` | Cursor discovers nested `.cursor/skills/` scoped to `.ai-dos/` files; nested `.cursor/rules` REQUIRES VALIDATION | Listed in `templates/cursorignore.template`; skills are explicit-only |
| `.claude/`, `.agents/`, `.github/` | — | The master has none of these folders, so nothing is carried |

## What each tool executes today vs. convention vs. future automation

| Topic | Executed by a tool today | AI-DOS convention | Future automation (not implemented) |
|---|---|---|---|
| Rules | Cursor loads `.cursor/rules/*.mdc`; Claude Code loads `CLAUDE.md`, its `@` imports and `.claude/rules/`; Codex loads `AGENTS.md`; Copilot loads `.github/copilot-instructions.md`, `.github/instructions/` and, on agent surfaces, `AGENTS.md` (per official documentation; REQUIRES VALIDATION per tool version) | Rules point to `.ai-dos/` documents, which agents read | — |
| Skill adapters | Offered when invoked explicitly (`disable-model-invocation: true` in Cursor and Claude Code, `allow_implicit_invocation: false` in Codex); Copilot may select them by description (REQUIRES VALIDATION) | Adapter points to `.ai-dos/skills/…` | Automatic skill selection by task type, role, capabilities, risk, project profile |
| Claude Code permissions | `.claude/settings.json` deny/ask rules are enforced by Claude Code | Only stricter than the default | — |
| Manifest and profile | `install.ps1` reads `VERSION`, compatibility, `local_modifications` and `ai.enabled_skills`; no tool validates the schemas | Agents read them by convention | Schema validation, routing with project restrictions |
| Initialize / update | `install.ps1` generates adapters, manifest and profile skeleton, detects conflicts by hash; the human copies the folder and decides | Human follows [initialize](initialize.md) / [update](update.md), optionally with an agent | Three-way comparison of managed copies, glob derivation from `technology.languages`, validators |

## Workflows

- [initialize.md](initialize.md) — Initialize AI-DOS in a project (partly automated by `install.ps1`).
- [update.md](update.md) — Update AI-DOS in a project, including the conflict mechanism and rollback (partly automated by `install.ps1 -Update`).
- [versioning.md](versioning.md) — Versioning, compatibility, breaking changes, migration, deprecation, upgrade, rollback.
- [state-and-artifacts.md](state-and-artifacts.md) — What a project versions and what it ignores.
