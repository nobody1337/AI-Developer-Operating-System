# Workflow: Update AI-DOS in a Project (`ai-dos-update`)

Status: **Partly automated.** `.ai-dos/install.ps1 -Update` implements steps 2
(version range check), 5, 6 and 9 for generated files and blocks, and the
version lines of step 11; the human performs the other steps, optionally
assisted by an agent. Managed copies are replaced by the human copy step, not
by a three-way comparison (see below). An update is a `CRITICAL` governance
change: it needs explicit human approval ([human approval](../governance/policies/human-approval.md)).

**An update never silently overwrites local project rules.**

Quick path (after steps 1–4, on a separate branch):

```text
robocopy <path-to-central-ai-dos> .ai-dos /E /XD .git   # merge copy; never /MIR (would delete project-owned files)
.\.ai-dos\install.ps1 -Update -WhatIf                     # review statuses
.\.ai-dos\install.ps1 -Update
git diff                                                  # review every change before merging
```

## Input

- Current `.ai-dos/manifest.yaml` (project version, source version and ref,
  local modifications, compatibility) and `.ai-dos/project-profile.yaml`
- Target version of the Central AI-DOS and its `CHANGELOG.md`
- Base: the master at the current source ref (tag `v<version>`) for the
  three-way comparison

## Steps

1. **Read** manifest and profile; record current and target version.
2. **Check compatibility** against `compatibility.*` and the supported schema
   versions ([versioning](versioning.md#compatibility)). Outside the range →
   stop and ask the human.
3. **Read the changelog** between current and target: breaking changes,
   migrations, deprecations, changed governance, changed Cursor rules, changed
   skills.
4. **Prepare a separate change** in the project's version control (e.g. a
   branch). Without version control: a human backup is required, otherwise stop.
5. **Compute target files** — managed copies from the target version; generated
   files regenerated with the project profile. Staging lives in
   `.ai-dos/state/runtime/update/` (not versioned).
6. **Classify every managed and generated file** (conflict mechanism below).
7. **Write the update record** with the classification and all conflicts to
   `.ai-dos/artifacts/updates/<from>-to-<to>.md`.
8. **Human decides** every conflict.
9. **Apply** non-conflicting changes and the decided resolutions.
10. **Apply migrations** in order; record them in the manifest.
11. **Update the manifest** — `ai_dos.version`, `ai_dos.source`, `updated_at`,
    `local_modifications`, `migrations`.
12. **Integration check** as in [initialize](initialize.md#integration-check).
13. **Independent review and human approval** — Review Report, Approval Record.
14. **Complete** — the human merges the change.

## Conflict mechanism

Three versions of each file are compared: **base** (master at the current
source ref), **local** (file in the project) and **target** (new master
version, regenerated with the profile).

| Resolution | Condition | Action |
|---|---|---|
| `update` | local = base | Replace with target |
| `keep_local` | target = base, local ≠ base | Keep local; it must be a declared local modification, otherwise also report as `RISK:` |
| `conflict` | local ≠ base and target ≠ base | Never overwrite; show both diffs in the update record; human chooses keep local, take target or manual merge |
| `added` | file only in target | Add |
| `removed_proposed` | file removed in target | Never delete automatically; propose removal; human decides |
| `skip_project_owned` | project-specific or project data | Not touched |

### What install.ps1 implements

For **generated files and blocks**, install.ps1 replaces the base comparison by
a provenance hash stored in the file (marker line) or block (`ai-dos:hash`
line): "local = base" means the content still matches its stored hash.

| Resolution | install.ps1 status |
|---|---|
| `update` | `outdated` without `-Update`; `updated` with `-Update` |
| `keep_local` | `keep_local` for paths listed in `integration.local_modifications` |
| `conflict` | `conflict`: no provenance marker or hash line, or content edited since generation; never written |
| `added` | `created` (file) or `inserted` (block into an existing file) |
| `removed_proposed` | `removed_proposed`: generated file no longer expected (source removed or skill disabled), and legacy `.cursor/skills/aidos-*`; never deleted |
| `skip_project_owned` | not touched (project sections of entry files, profile, `.claude/settings.json` after creation, `.ai-dos/local/**`, state, artifacts) |

For **managed copies** (`.ai-dos/governance/`, `orchestration/`, …) the human
copy step overwrites them with the target version; no three-way comparison
exists. Review them with `git diff` before merging; local edits to managed
copies are not allowed ([file classification](README.md#file-classification)).
Files removed from the master stay in `.ai-dos/` after a merge copy; compare
with the changelog and remove them by human decision.

Rules:

- Undeclared changes to managed or generated files are always `conflict` and
  reported as `RISK:` (possible tampering). For managed copies this is today
  only detectable by the human `git diff` review, because the copy step
  overwrites them.
- If the base is not available (no master tag, no git history), every file
  that differs from the target is a `conflict`.
- A local version that weakens the Security Baseline cannot be kept; the human
  is informed and the target version (or a stricter merge) applies.
- Each decision is recorded in the update record; keeping a local version
  updates `local_modifications` in the manifest.

## Rollback

Revert the update change in version control; the manifest, managed copies and
generated files return to the previous version together. Without version
control, restore the human backup. Rollback is a human action.

## Output

Updated embedded instance, update record with conflict decisions, Review
Report, Approval Record.
