# Workflow: Initialize AI-DOS in a Project (`ai-dos-initialize`)

Status: **Partly automated.** `install.ps1` (copied to `.ai-dos/install.ps1`)
implements steps 8 (project-owned directories), 9–12 and part of 13; the
human performs the copy in step 8 and steps 1–7, 13 and 14, optionally
assisted by an agent. No orchestrator exists. Writing `.ai-dos/`, the tool
adapters (`.cursor/`, `.agents/`, `.claude/`, `.github/`) and the entry files
(`AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`) in a project is a
`CRITICAL` governance change: it needs explicit human approval
([human approval](../governance/policies/human-approval.md)).

Quick path (Windows; `robocopy` ships with Windows, exit codes below 8 mean success):

```text
cd <project>
robocopy <path-to-central-ai-dos> .ai-dos /E /XD .git
.\.ai-dos\install.ps1 -WhatIf      # dry run
.\.ai-dos\install.ps1              # install
```

On macOS/Linux with PowerShell 7: `rsync -a --exclude .git <master>/ .ai-dos/`
then `pwsh ./.ai-dos/install.ps1` (REQUIRES VALIDATION: not tested there).
If PowerShell blocks the script by execution policy, run it once with
`powershell -ExecutionPolicy Bypass -File .\.ai-dos\install.ps1`; this changes
nothing permanently.

## Trigger

A human decides to integrate AI-DOS into a software project.

## Input

- The Central AI-DOS at a released version (`VERSION`, tag `v<version>` where available)
- The target project (opened as its own workspace)

## Roles

| Step | Role |
|---|---|
| Analysis and detection (1–4) | `planner` (read-only) |
| Security and data classification proposal (5) | `security-reviewer` |
| Profile, component selection, generation (6–12) | `planner` / `architect` |
| Integration check (13) | `code-reviewer` (separate session) |
| Decisions and approval | human |

## Steps

1. **Analyse the project** — read-only: structure, existing `AGENTS.md`,
   `.cursor/`, `.gitignore`, documentation, ADRs. Never run project scripts.
2. **Detect language and framework** — from manifests (`package.json`,
   `pyproject.toml`, …) with exact versions; unknown stays `unknown`.
3. **Detect build, test and lint commands** — from manifests and CI files;
   unverified commands are marked `REQUIRES VALIDATION`.
4. **Detect repository structure** — modules, default branch, existing ADR folder.
5. **Determine security and data classification** — propose
   `security.data_sensitivity` and restrictions; the human decides.
6. **Generate the project profile** — `templates/project-profile.yaml` →
   `.ai-dos/project-profile.yaml`.
7. **Select AI-DOS components** — enabled skills, workflows, allowed roles and
   models (recorded in the profile). Managed copies are always complete; the
   selection only affects generated adapters and profile restrictions.
8. **Create `.ai-dos/`** — *human:* copy the whole master folder without
   `.git` to `.ai-dos/` (managed copies stay unchanged). *install.ps1:* creates
   `workflows/`, `local/rules/`, `local/skills/`, `state/tasks/`,
   `artifacts/{tasks,decisions,updates}/` (each with `.gitkeep`) if missing.
9. **Create `.cursor/rules/`** (*install.ps1*) — the master rules `00`–`11`
   with every AI-DOS-root-relative path prefixed with `.ai-dos/`
   ([path convention](README.md#path-convention)) and a provenance marker.
   Glob rules additionally become `.claude/rules/aidos-*.md` and
   `.github/instructions/aidos-*.instructions.md`. Deriving the globs of
   `02`/`05`/`06` from `technology.languages` is **not automated**: narrow them
   by editing the generated files and declaring them in
   `integration.local_modifications` (then `keep_local`). Existing project
   rules are kept; name collisions are conflicts (see below).
10. **Create skill and command adapters** (*install.ps1*) — for enabled skills
    `.agents/skills/aidos-<skill>/SKILL.md` (Cursor, Codex, Copilot) with
    `agents/openai.yaml` and `.claude/commands/aidos-<skill>.md`, paths
    prefixed, explicit-only kept. Commands become `.cursor/commands/<name>.md`,
    `.claude/commands/aidos-<name>.md` and `.github/prompts/aidos-<name>.prompt.md`.
    `.claude/settings.json` is created from `templates/adapters/claude-settings.json`
    if missing ([tool adapters](README.md#tool-adapters)).
11. **Create or update the entry files** (*install.ps1*) — `AGENTS.md`,
    `CLAUDE.md` and `.github/copilot-instructions.md` from
    `templates/project-agents.md`, `templates/project-claude.md` and
    `templates/project-copilot-instructions.md`. An existing file keeps its
    content; only the AI-DOS block is inserted between the markers. The human
    then fills in the project sections.
12. **Pin the AI-DOS version** (*install.ps1*, only if missing) —
    `templates/manifest.yaml` → `.ai-dos/manifest.yaml` with `ai_dos.version`
    and `source.version` from `.ai-dos/VERSION` and `integrated_at` = today;
    the human sets `ai_dos.source.ref` if known.
    `templates/project-profile.yaml` → `.ai-dos/project-profile.yaml` (the
    human fills it in, steps 2–7). Add the AI-DOS block from
    `templates/project-gitignore.template` to `.gitignore`. *Human:* create
    `.cursorignore` from `templates/cursorignore.template` (install.ps1 only
    reminds; it never creates the file).
13. **Integration check** — see below.
14. **Document the result** — Implementation Report and Approval Record in
    `.ai-dos/artifacts/updates/<date>-initialize/`.

## Existing files

Initialization never overwrites existing project files. Into an existing
`AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md` or `.gitignore`
install.ps1 only inserts the AI-DOS block. An existing rule, command or adapter
with the same name but without AI-DOS provenance marker is reported as
`conflict` and skipped; the [conflict mechanism](update.md#conflict-mechanism)
applies: the human decides.

## Integration check

install.ps1 reports conflicts, outdated files and missing `.cursorignore`; the
other items remain manual checks:

- Every path referenced in generated tool adapters and entry-file blocks exists in the project.
- No absolute path, no reference to the master location, no reference outside the project.
- Relative links inside `.ai-dos/` resolve inside `.ai-dos/`.
- `manifest.yaml` and `project-profile.yaml` parse as YAML and follow their schemas; no secrets.
- Always-applied rules `00`, `01`, `04`, `09` are present and unmodified apart from path prefixes and the provenance marker.
- Managed copies equal the source version.
- `features.*` are all `false`.

Results are reported honestly; unchecked items are `not_run`.

## Output

Embedded instance, manifest, profile, generated tool adapters, entry files
(`AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`), Implementation
Report, Approval Record.
