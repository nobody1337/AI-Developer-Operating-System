# ADR-001: Embedded Project-Local AI-DOS Integration

- **Status:** Proposed <!-- drafted by an AI agent; only a human sets Accepted -->
- **Date:** 2026-10-02
- **Deciders:** Axel (owner) — binding decisions taken 2026-10-02; acceptance of this ADR pending independent review

## Context

ADR-000 described project integration only briefly (`.cursor/`, `AGENTS.md`,
`templates/project-profile.yaml`) and left open how projects integrate AI-DOS.
The README offered three options (copy into `ai-dos/`, git submodule,
reference only), proposed paths were inconsistent (`ai-dos/`,
`ai-dos.project.yaml`, `.ai-dos/tasks/`, `.ai-dos/runtime/`), there was no
version source, and four links in the governance and orchestration documents
pointed outside these directories, so a copied instance would have broken links.

The owner decided (binding decisions 1–7 in the
[governance README](../README.md#binding-decisions-2026-10-02)):
AI-DOS is a master blueprint; every software project owns an embedded instance
in its own directory and must work in Cursor without access to the master.

## Decision

1. **Embedded integration is the AI-DOS standard** (decision 4). The Central
   AI-DOS is blueprint, source, template repository, governance source and
   update source. A project contains its AI-DOS version, project configuration,
   activated governance components, local rules, local skills and adapters,
   and task and audit artifacts.
2. **Layout** `.ai-dos/` with managed copies that mirror the master
   (`governance/`, `orchestration/`, `skills/`, `templates/`, `checklists/`,
   `integration/`), so relative links stay valid, plus project-owned
   `project-profile.yaml`, `workflows/`, `local/`, `state/`, `artifacts/`, and
   the generated `manifest.yaml` ([integration README](../../integration/README.md#layout-of-an-embedded-instance)).
3. **File classes** `copied`, `template`, `generated`, `project_specific`,
   `project_data`, `master_only`, `master_docs`, each with an explicit
   modification rule ([file classification](../../integration/README.md#file-classification)).
4. **Manifest vs. profile.** `manifest.yaml` holds installation, provenance
   (project AI-DOS version, source AI-DOS version, schema version, integration
   date), compatibility, governance profile and features. Project identity,
   security and model restrictions live only in `project-profile.yaml`.
5. **Generated Cursor files.** Project `.cursor/rules`, commands and skill
   adapters are generated from the master by prefixing AI-DOS paths with
   `.ai-dos/`. The master keeps no pre-generated project copies.
6. **Versioning.** Semantic Versioning with `VERSION` as single source,
   `CHANGELOG.md` for breaking changes, migrations and deprecations; 0.x rule
   for breaking changes ([versioning](../../integration/versioning.md)).
7. **Updates** use a three-way comparison (base, local, target) and never
   overwrite local changes silently ([update](../../integration/update.md#conflict-mechanism)).
8. **Scopes** Global → Project → Task and project override limits are defined
   once in the [governance hierarchy](../principles/governance-hierarchy.md#scopes-global--project--task).
9. **State and artifacts** (decision 3): relevant artifacts are versioned,
   runtime data below `.ai-dos/state/runtime/` is not
   ([state and artifacts](../../integration/state-and-artifacts.md)).
10. **Skill adapters are explicit-only** (decision 5):
    `disable-model-invocation: true`; automatic skill selection is future
    orchestration only.
11. **`08-documentation.mdc` is agent-requested** (decision 6) instead of
    attached to all Markdown files.
12. Links from copied directories to the master root or to `.cursor/` were
    replaced, so copied directories are self-contained.

## Alternatives

| Option | Pros | Cons | Why not chosen |
|---|---|---|---|
| Keep current approach (three options, no version, no manifest) | No work | Inconsistent paths, broken links in copies, no provenance | Contradicts decision 4 |
| Copy into visible `ai-dos/` folder (former README option) | Simple | No manifest, no file classes, path rewriting undefined | Replaced by `.ai-dos/` with provenance |
| Git submodule | Versioned updates | Needs access to the master repository; Cursor still needs copied rules; implicit dependency on another repo | Violates "no external runtime dependency" |
| Reference only (link to a published AI-DOS) | Lightweight | Agents must fetch documents; does not work offline or without the master | Violates "works without the master" |
| Central installation path on the machine | One copy | Absolute paths, rules work only where the master is installed | Violates "no absolute paths" |
| Partial copy (only selected governance files) | Smaller | Broken links, incomplete Security Baseline | Managed copies stay complete; selection affects only adapters and profile |
| Pre-generated project `.cursor/` set in the master | Copy as-is | 33 duplicated files that drift from the master rules | Generation by path prefix instead |

## Consequences

- Positive: each project is self-contained in Cursor; provenance and version
  are traceable; local changes are visible; the master can evolve without
  breaking projects silently.
- Negative: governance is duplicated in every project; initialization and
  updates are manual until tooling exists; path prefixing and drift detection
  are conventions and error-prone; projects must commit and review AI-DOS
  updates as `CRITICAL` changes.
- Follow-up work: optional validators for manifest, profile and links; an
  integrator implementing initialize/update (each with its own ADR).

## Validation

Recorded in [review 0002](../reviews/0002-embedded-integration-self-review.md):
link and anchor check, self-containment check of the copied directories, YAML
parsing, grep checks. Cursor runtime behaviour (rule attachment, explicit-only
skills) requires validation in Cursor. Like ADR-000, this ADR needs an
independent review before a human sets it to `Accepted`.
