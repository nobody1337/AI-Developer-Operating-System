# Changelog

All notable changes to the Central AI-DOS. Versioning policy:
[integration/versioning.md](integration/versioning.md). The current version is
in [VERSION](VERSION). Release tags (`v<version>`) are set by a human.

## Unreleased

Multi-tool support for embedded AI-DOS
([ADR-002](governance/decisions/002-multi-tool-adapters.md)). Requested and
explicitly approved as a `CRITICAL` change by Axel (owner) in chat on
2026-11-01.

### Added

- `install.ps1` (Windows PowerShell 5.1 / PowerShell 7, no dependencies, no
  network): run as `.ai-dos/install.ps1` after copying the master folder to
  `<project>/.ai-dos/`; supports `-WhatIf` and `-Update`; idempotent; never
  overwrites project files; provenance markers with SHA-256 for drift detection.
- Adapters for Claude Code (`CLAUDE.md`, `.claude/rules/`, `.claude/commands/`,
  `.claude/settings.json`), OpenAI Codex (`AGENTS.md`, `.agents/skills/` with
  `agents/openai.yaml`) and GitHub Copilot (`.github/copilot-instructions.md`,
  `.github/instructions/`, `.github/prompts/`), generated from the master
  `.cursor/` sources.
- Entry file templates with project-owned section and generated block:
  `templates/project-claude.md`, `templates/project-copilot-instructions.md`;
  adapter templates in `templates/adapters/`.
- Master `CLAUDE.md` (imports `@AGENTS.md` and the always-applied rules).
- `integration.tools` in the manifest schema and template.

### Changed

- `templates/project-agents.md`: the generated block now embeds the
  always-applied rules and lists conditional rules, skills and commands per
  tool (placeholders filled by `install.ps1`).
- Project skill adapters are generated in `.agents/skills/aidos-*` instead of
  `.cursor/skills/aidos-*` (Cursor, Codex and Copilot read `.agents/skills/`;
  avoids duplicate skills).
- `integration/README.md`, `initialize.md`, `update.md`: installer, tool
  adapter table, per-tool execution table, inactive master copies, file
  classification of `install.ps1`, `VERSION`, carried master files.
- `templates/project-gitignore.template`: ignores `.claude/settings.local.json`
  and `CLAUDE.local.md`; `templates/cursorignore.template`: lists the inactive
  master entry files in `.ai-dos/`.
- Master `AGENTS.md`: installation and multi-tool note; note for its inactive
  copy in `.ai-dos/`.
- `governance/security/ai-security.md`: the "tampered embedded governance"
  threat now also covers the generated adapter paths `CLAUDE.md`, `.claude/`,
  `.agents/skills/`, `.github/copilot-instructions.md`, `.github/instructions/`
  and `.github/prompts/` (and all of `.cursor/`). Approved by Axel in chat on
  2026-11-01; controls unchanged.

### Breaking

- None for projects: no embedded instances were created with tooling before.
  Manually created `.cursor/skills/aidos-*` adapters are reported as
  `removed_proposed` (never deleted).

### Migration

- Existing manual integrations: copy the new master over `.ai-dos/`, run
  `install.ps1 -Update`; blocks without hash line are reported as conflict —
  delete the old block (markers included) and run again.

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
