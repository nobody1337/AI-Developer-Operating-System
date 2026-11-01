# GitHub Copilot instructions — <project name>

<!-- template: .github/copilot-instructions.md of a project with an embedded
     AI-DOS. `.ai-dos/install.ps1` creates the file from this template if it is
     missing; into an existing file it inserts only the block between the
     ai-dos markers. Everything outside the markers is project-owned and never
     overwritten. Copilot cannot import files, so the block repeats the
     always-applied rules, generated from the same source as AGENTS.md
     (`.ai-dos/.cursor/rules/`). It is replaced only with -Update, and only if
     nobody edited it. This comment is removed in the generated file. -->

## Project

<Copilot-specific project instructions, if any. Instructions shared by all
tools belong in the project part of `AGENTS.md`.>

<!-- ai-dos:begin (generated; do not edit) -->
## AI-DOS

This repository uses an embedded AI-DOS instance in `.ai-dos/`; `AGENTS.md` is
the shared entry point for all AI tools. The rules below are generated from
the same source as `AGENTS.md` and `.cursor/rules/`, so Copilot surfaces that
do not read `AGENTS.md` get the same rule set.

- Path-specific AI-DOS rules: `.github/instructions/aidos-*.instructions.md`
  (`applyTo` globs).
- AI-DOS commands as prompt files: `.github/prompts/aidos-*.prompt.md`.
- Project rules and restrictions: `.ai-dos/project-profile.yaml`,
  `.ai-dos/local/rules/`.

{{AIDOS_ALWAYS_RULES}}

{{AIDOS_CONDITIONAL_RULES}}

{{AIDOS_SKILLS_AND_COMMANDS}}
<!-- ai-dos:end -->
