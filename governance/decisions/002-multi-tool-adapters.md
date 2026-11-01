# ADR-002: Multi-Tool Adapters and Installer for Embedded AI-DOS

- **Status:** Proposed <!-- drafted by an AI agent; only a human sets Accepted -->
- **Date:** 2026-11-01
- **Deciders:** Axel (owner) — requirement and explicit approval of this `CRITICAL` change given in chat on 2026-11-01 (edits to `AGENTS.md`, `governance/decisions/`, `governance/security/ai-security.md`, `integration/`, `templates/`, `docs/`, `CHANGELOG.md`); acceptance of this ADR pending independent review
- **Extends:** [ADR-001](001-embedded-project-integration.md) (decision 5 "Generated Cursor files" is widened to all tools; decision 10 "explicit-only skills" is kept)

## Context

ADR-001 made the embedded instance self-contained for Cursor only: generated
`.cursor/rules`, `.cursor/commands`, `.cursor/skills/aidos-*` and an
`AGENTS.md` block. Initialize and update were manual. The owner requires that
AI-DOS works in every project with Cursor, Claude Code, OpenAI Codex and GitHub
Copilot, that installation is "copy the folder to `<project>/.ai-dos/`, run one
script", that all tool adapters are always generated, and that every tool entry
file has a project-owned part plus a generated AI-DOS block.

Verified tool conventions (official documentation, read 2026-11-01):

| Tool | Reads | Explicit-only switch for skills |
|---|---|---|
| Cursor | `.cursor/rules/*.mdc`; `AGENTS.md` in root and subdirectories; skills in `.agents/skills/`, `.cursor/skills/` and, for compatibility, `.claude/skills/`, `.codex/skills/`; nested skill folders anywhere in the repository | `disable-model-invocation: true` |
| Claude Code | `CLAUDE.md` or `.claude/CLAUDE.md` with `@path` imports; `AGENTS.md` only when no `CLAUDE.md` exists; `.claude/rules/*.md` (`paths` frontmatter); `.claude/skills/` and `.claude/commands/*.md` (commands are merged into skills); `.claude/settings.json` (`permissions.deny`/`ask`, `claudeMdExcludes`); subdirectory `CLAUDE.md` files load on demand | `disable-model-invocation: true` |
| OpenAI Codex | `AGENTS.md` from the project root down to the working directory (32 KiB default limit, `project_doc_max_bytes`); `.agents/skills/` from the working directory up to the repository root; project `.codex/config.toml` only for trusted projects | `agents/openai.yaml` → `policy.allow_implicit_invocation: false` |
| GitHub Copilot | `.github/copilot-instructions.md` (all surfaces); `.github/instructions/*.instructions.md` with `applyTo`; `AGENTS.md` (nearest file wins) on agent surfaces; `.github/prompts/*.prompt.md`; skills in `.github/skills/`, `.claude/skills/`, `.agents/skills/` | not documented (`REQUIRES VALIDATION`) |

## Decision

1. **Installation by copy plus installer.** The human copies the Central AI-DOS
   folder without `.git` to `<project>/.ai-dos/` and runs
   `.ai-dos/install.ps1` (PowerShell, no dependencies, Windows PowerShell 5.1
   and PowerShell 7). The script lives in the master root, so it is at
   `.ai-dos/install.ps1` after the copy; it refuses to run unless its folder
   is named `.ai-dos` and refuses a copied `.ai-dos/.git`. Updating is the
   same: copy the new master over `.ai-dos/` (merge, no delete), run
   `install.ps1 -Update`.
2. **Single source.** The master `.cursor/rules`, `.cursor/commands` and
   `.cursor/skills/aidos-*` stay the only source of rule, command and adapter
   text. The installer reads them from `.ai-dos/.cursor/`, prefixes
   AI-DOS-root-relative paths with `.ai-dos/` and renders every tool format
   through the templates in `templates/` and `templates/adapters/`.
3. **`AGENTS.md` is the shared hub.** Its generated block embeds the
   always-applied rules `00`, `01`, `04`, `09` (Codex and Copilot cannot follow
   rule files reliably), lists the conditional rules with their trigger, and
   lists skills and commands per tool. `CLAUDE.md` imports `@AGENTS.md` instead
   of repeating it. `.github/copilot-instructions.md` repeats the same
   generated sections because Copilot cannot import and some Copilot surfaces
   do not read `AGENTS.md`.
4. **Per-tool adapters** (always all, no selection):
   Cursor `.cursor/rules/`, `.cursor/commands/`;
   shared skill adapters `.agents/skills/aidos-*/SKILL.md` (Cursor, Codex,
   Copilot) with `agents/openai.yaml` for Codex;
   Claude Code `CLAUDE.md` block, `.claude/rules/aidos-*.md` (glob rules),
   `.claude/commands/aidos-*.md` (commands and skills), `.claude/settings.json`;
   Copilot `.github/copilot-instructions.md` block,
   `.github/instructions/aidos-*.instructions.md` (glob rules),
   `.github/prompts/aidos-*.prompt.md` (commands).
   No `.codex/` files are generated: nothing required needs project config.
5. **No duplicate skill discovery.** Projects get skill adapters only in
   `.agents/skills/`, not in `.cursor/skills/` or `.claude/skills/`, because
   Cursor and Copilot also read those folders and would list every skill two
   or three times. Claude Code gets skills as `.claude/commands/aidos-*.md`.
   Confirmed by Axel in chat on 2026-11-01: keep `.agents/skills/`, no
   additional `.cursor/skills/` adapters.
   Existing project `.cursor/skills/aidos-*` are reported as
   `removed_proposed`, never deleted.
6. **Entry file templates.** `templates/project-agents.md`,
   `templates/project-claude.md` and `templates/project-copilot-instructions.md`
   each have a project-owned section and a generated block between
   `<!-- ai-dos:begin (generated; do not edit) -->` and `<!-- ai-dos:end -->`.
   The installer creates a missing file from the template or inserts only the
   block into an existing file, and replaces the block only with `-Update`.
7. **Provenance and drift detection without a base.** Whole generated files
   carry a marker line with source path and SHA-256 of their content; blocks
   carry a hash line. A file without marker or with a content/hash mismatch,
   and a block without hash line or with a mismatch, is a `conflict` and is
   not touched. Paths listed in `integration.local_modifications` are
   `keep_local`. Nothing is deleted; orphans are `removed_proposed`.
8. **Inactive master copies.** The copy carries master files that tools could
   discover in `.ai-dos/`: `AGENTS.md`, `CLAUDE.md`, `.cursor/`. They are
   generator sources, not entry points. Mitigation: no master `.claude/` or
   `.agents/` folders exist; the generated `.claude/settings.json` excludes
   `.ai-dos/CLAUDE.md` and `.ai-dos/AGENTS.md` (`claudeMdExcludes`); the master
   `AGENTS.md` and `CLAUDE.md` say they are inactive when read from
   `.ai-dos/`; `templates/cursorignore.template` lists them. Codex reads nested
   `AGENTS.md` only when started inside `.ai-dos/`.
9. **Master `CLAUDE.md`.** The master gets a `CLAUDE.md` that imports
   `@AGENTS.md` and the four always-applied rules, so Claude Code works in the
   master without duplicated rule text.
10. **Security settings only tighten.** `.claude/settings.json` adds `Read`
    deny rules for secret files, `Edit` ask rules for managed AI-DOS files and
    `claudeMdExcludes`; it is created only if missing and is project-owned
    afterwards (JSON cannot carry a marker). `.cursorignore` is never created.

## Alternatives

| Option | Pros | Cons | Why not chosen |
|---|---|---|---|
| Keep current approach (Cursor only, manual initialize) | No work | Claude Code, Codex, Copilot get no or partial rules; manual steps error-prone | Contradicts the owner requirement |
| Symlink tool files to `.ai-dos/` | No generated copies | Symlinks need privileges on Windows, break in archives and on some hosts; Claude Code treats links outside the working directory as external imports | Not portable |
| Separate rule text per tool in the master | Tool-optimal wording | Many copies of the same rules drift | Violates single source of truth |
| Generate skill adapters in `.cursor/skills/`, `.claude/skills/` and `.agents/skills/` | Each tool has "its" folder | Cursor and Copilot read all of them → duplicate skills | Duplicates; `.agents/skills/` is read by Cursor, Codex and Copilot |
| Thin `AGENTS.md` (links only), rules only in tool-specific files | Smaller `AGENTS.md`, no duplication in Cursor | Codex has no rule files; it would see only links | Codex must get the always-applied rules |
| Delete or rename inactive master files inside `.ai-dos/` | No nested discovery | Destructive file operations; reappear on every update copy | Exclusion and labelling instead |
| Installer in another language (Node, Python) | Richer libraries | New dependency on the target machine | PowerShell ships with Windows and runs cross-platform as PowerShell 7 |
| Git submodule | Versioned updates | Needs the master repository; rejected in ADR-001 | Unchanged |

## Consequences

- Positive: one copy step and one command install AI-DOS for four tools; all
  adapters come from one source; project content in entry files is never
  overwritten; local edits to generated files are detected without the master
  history; dry run and update mode exist.
- Negative: in Cursor the always-applied rules arrive twice (`.cursor/rules`
  and the `AGENTS.md` block) and in Copilot surfaces that read both files
  twice as well (identical text); the generated `AGENTS.md` grows to about
  12 KB; managed copies in `.ai-dos/` are still overwritten by the human copy
  step without a three-way comparison; glob derivation from
  `technology.languages` is not automated; `.claude/settings.json` updates
  need a manual merge; several tool behaviours are documented but not
  verified in a running tool (see Validation).
- Follow-up work: verify each tool in a real project; decide whether Copilot
  skills need an explicit-only mechanism; optional validators; three-way
  comparison of managed copies.

## Validation

Performed 2026-11-01 by the authoring agent on Windows PowerShell 5.1
(PowerShell 7 not installed, PSScriptAnalyzer not installed): fresh install,
second run (no file changed), `-Update` without changes, `-WhatIf` (no file
written), existing `AGENTS.md` (CRLF), `CLAUDE.md` and `.gitignore` with user
content (preserved), foreign rule with the same name (conflict, untouched),
edited block and edited generated file (conflict), declared local modification
(`keep_local`), changed source and version bump (`outdated`, then `updated`
with `-Update`, project content outside the block preserved), removed source
(`removed_proposed`, not deleted), refusal in the master and with a copied
`.git`. Generated files contain no absolute paths, and every referenced
`.ai-dos/` path exists.

Not verified (`REQUIRES VALIDATION`): that Cursor, Claude Code, Codex and
Copilot load the generated files as their documentation describes; that
`claudeMdExcludes` with `**/.ai-dos/...` patterns matches on Windows paths;
that Copilot honours `disable-model-invocation`; PowerShell 7 and
macOS/Linux execution. Like ADR-000 and ADR-001, this ADR needs an
independent review before a human sets it to `Accepted`.
