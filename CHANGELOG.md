# Changelog

All notable changes to the Central AI-DOS. Versioning policy:
[integration/versioning.md](integration/versioning.md). The current version is
in [VERSION](VERSION). Release tags (`v<version>`) are set by a human.

## 0.1.0 — unreleased

First versioned blueprint.

### Added

- Embedded, project-local integration as the AI-DOS standard
  ([ADR-001](governance/decisions/001-embedded-project-integration.md)):
  `integration/` with layout, file classification, manifest and project
  profile schemas, versioning policy, state and artifact rules, and the
  conceptual workflows initialize and update.
- `templates/manifest.yaml`, `templates/project-agents.md`,
  `templates/project-gitignore.template`.
- Binding decisions 1–7 in [governance/README.md](governance/README.md#binding-decisions-2026-10-02).
- Scopes Global → Project → Task in the governance hierarchy.

### Changed

- `templates/project-profile.yaml` uses the new profile schema
  (`.ai-dos/project-profile.yaml`).
- `08-documentation.mdc` is agent-requested instead of attached to all Markdown files.
- Cursor skill adapters are explicit-only (`disable-model-invocation: true`).

### Breaking

- None for projects: no embedded instances existed before 0.1.0. The former
  integration options (copy to `ai-dos/`, git submodule, reference only) and
  `ai-dos.project.yaml` are no longer supported.

### Deprecated

- None.

### Migration

- None.
