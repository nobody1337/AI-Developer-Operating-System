# Workflow: Initialize AI-DOS in a Project (`ai-dos-initialize`)

Status: **Conceptual.** Specification of a future workflow. No CLI, script or
orchestrator implements it. Today a human performs these steps, optionally
assisted by an agent. Writing `.ai-dos/`, `.cursor/rules/` and `AGENTS.md` in a
project is a `CRITICAL` governance change: it needs explicit human approval
([human approval](../governance/policies/human-approval.md)).

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
8. **Create `.ai-dos/`** — copy `governance/`, `orchestration/`, `skills/`,
   `templates/`, `checklists/`, `integration/` unchanged; create `workflows/`,
   `local/rules/`, `local/skills/`, `state/tasks/`, `artifacts/` (empty or with a
   short README).
9. **Create `.cursor/rules/`** — copy the master rules `00`–`11`, prefix every
   AI-DOS-root-relative path with `.ai-dos/`
   ([path convention](README.md#path-convention)); derive the globs of
   `02`/`05`/`06` from `technology.languages`. Existing project rules are kept;
   name collisions are conflicts (see below).
10. **Create `.cursor/skills/`** — adapters `aidos-<skill>` for enabled skills,
    paths prefixed, `disable-model-invocation: true` kept. Copy
    `.cursor/commands/` the same way.
11. **Create or update `AGENTS.md`** — from `templates/project-agents.md`. An
    existing `AGENTS.md` keeps its content; the AI-DOS block is inserted between
    the markers.
12. **Pin the AI-DOS version** — `templates/manifest.yaml` →
    `.ai-dos/manifest.yaml` with `ai_dos.version`, `ai_dos.source`,
    `integrated_at`, managed and generated paths, compatibility. Add the AI-DOS
    block from `templates/project-gitignore.template` to `.gitignore`. Ask the
    human to create `.cursorignore` from `templates/cursorignore.template`.
13. **Integration check** — see below.
14. **Document the result** — Implementation Report and Approval Record in
    `.ai-dos/artifacts/updates/<date>-initialize/`.

## Existing files

Initialization never overwrites existing project files. For an existing
`AGENTS.md`, `.gitignore`, rule or command with the same name, the
[conflict mechanism](update.md#conflict-mechanism) applies: the human decides.

## Integration check

- Every path referenced in generated `.cursor/` files and in `AGENTS.md` exists in the project.
- No absolute path, no reference to the master location, no reference outside the project.
- Relative links inside `.ai-dos/` resolve inside `.ai-dos/`.
- `manifest.yaml` and `project-profile.yaml` parse as YAML and follow their schemas; no secrets.
- Always-applied rules `00`, `01`, `04`, `09` are present and unmodified apart from path prefixes.
- Managed copies equal the source version.
- `features.*` are all `false`.

Results are reported honestly; unchecked items are `not_run`.

## Output

Embedded instance, manifest, profile, generated Cursor files, `AGENTS.md`,
Implementation Report, Approval Record.
