# Task State and Artifacts in Projects

Status: Governance Definition (binding decision 3, see
[governance README](../governance/README.md#3-task-state-and-artifacts)).

Project-related state and relevant artifacts may be versioned with the project.
Temporary runtime state is not versioned.

## Versioned (commit with the project)

| Content | Location in the embedded instance |
|---|---|
| Architecture decisions (ADRs) | `architecture.adr_path` (default `.ai-dos/artifacts/decisions/`) |
| Implementation Plans, Risk Assessments, Task Specifications | `.ai-dos/artifacts/tasks/<task-id>/` |
| Review Reports, Security Reports, Test and Implementation Reports | `.ai-dos/artifacts/tasks/<task-id>/` |
| Approval Records | `.ai-dos/artifacts/tasks/<task-id>/` (or the review system, e.g. PR approvals) |
| Relevant task records | `.ai-dos/state/tasks/<task-id>/state.yaml` |
| Update and integration records, conflict reports | `.ai-dos/artifacts/updates/` |
| Permanent AI-DOS configuration | `.ai-dos/manifest.yaml`, `.ai-dos/project-profile.yaml`, `.ai-dos/local/`, `.ai-dos/workflows/`, managed copies, generated `.cursor/` files |

Rules:

- `MEDIUM`+ tasks: plan, reports and state record should be versioned (they form
  the traceability chain). `HIGH`/`CRITICAL`: Approval Records must be kept,
  either versioned here or in the review system.
- `LOW` tasks: versioning artifacts is optional; the final report may suffice.
- A versioned Approval Record documents a past human decision. It never
  authorises a new action, and an agent never writes an Approval Record for an
  approval that was not given ([human approval](../governance/policies/human-approval.md#what-counts-as-approval)).
- Artifacts written by agents are `semi_trusted`
  ([AI security](../governance/security/ai-security.md#instruction-trust-levels)).

## Not versioned automatically

| Content | Location |
|---|---|
| Temporary agent logs | `.ai-dos/state/runtime/logs/` |
| Caches | `.ai-dos/state/runtime/cache/` |
| Temporary context packages | `.ai-dos/state/runtime/context/` |
| Update staging (target files, diffs) | `.ai-dos/state/runtime/update/` |
| Large generated intermediate artifacts, machine runtime data without long-term value | `.ai-dos/state/runtime/` |
| Secrets, tokens, credentials | **Nowhere in the repository** ([secrets and data](../governance/security/secrets-and-data.md)) |

Everything temporary goes below `.ai-dos/state/runtime/`, so one ignore entry
covers it.

## `.gitignore` recommendation

The project's `.gitignore` contains the AI-DOS block from
`templates/project-gitignore.template` (runtime directory plus secret patterns).
It is added at initialization as a marked block; the rest of the project's
`.gitignore` stays project-owned. `.cursorignore` is created manually by the
human from `templates/cursorignore.template` (agents cannot write it; it is
best-effort, not a security boundary).
