# Workflow: Update AI-DOS in a Project (`ai-dos-update`)

Status: **Conceptual.** Specification of a future workflow. No CLI, script or
orchestrator implements it. Today a human performs these steps, optionally
assisted by an agent. An update is a `CRITICAL` governance change: it needs
explicit human approval ([human approval](../governance/policies/human-approval.md)).

**An update never silently overwrites local project rules.**

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

Rules:

- Undeclared changes to managed or generated files are always `conflict` and
  reported as `RISK:` (possible tampering).
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
