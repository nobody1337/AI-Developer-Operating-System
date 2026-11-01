# Templates

Copy a template, fill it in, and keep it next to the task (location in a
project with an embedded AI-DOS: `.ai-dos/artifacts/tasks/<task-id>/`, see
[state and artifacts](../integration/state-and-artifacts.md)). Every artifact template
starts with the common artifact header defined in
[orchestration/state/handoffs.md](../orchestration/state/handoffs.md#common-artifact-header).
Paths inside templates are written repository-root-relative in backticks so
they stay valid when the file is copied elsewhere.

## Artifact templates

| Artifact id | Template |
|---|---|
| `task_specification` | [task-specification.md](task-specification.md) |
| `risk_assessment` | [risk-assessment.md](risk-assessment.md) |
| `implementation_plan` | [implementation-plan.md](implementation-plan.md) |
| `architecture_decision` | [adr.md](adr.md) |
| `implementation_report` | [implementation-report.md](implementation-report.md) |
| `test_report` | [test-report.md](test-report.md) |
| `review_report` | [code-review.md](code-review.md) |
| `security_report` | [security-report.md](security-report.md) |
| `approval_record` | [approval-record.md](approval-record.md) |

## Request templates

| Purpose | Template |
|---|---|
| Feature request | [feature.md](feature.md) |
| Bug report | [bugfix.md](bugfix.md) |

## AI-DOS extension templates

| Purpose | Template |
|---|---|
| Model evaluation report | [model-evaluation.md](model-evaluation.md) |
| New role | [role.md](role.md) |
| New workflow | [workflow.md](workflow.md) |
| New skill | [skill.md](skill.md) |

## Project integration templates

Used by [Initialize AI-DOS in a project](../integration/initialize.md) and
rendered by `install.ps1` ([tool adapters](../integration/README.md#tool-adapters)).

### Entry files (project-owned section + generated AI-DOS block)

Each entry file has a project-owned part, which the project extends freely and
which is never overwritten, and a block between
`<!-- ai-dos:begin (generated; do not edit) -->` and `<!-- ai-dos:end -->`,
which only `install.ps1` writes (`-Update` replaces it if nobody edited it).
`{{AIDOS_ALWAYS_RULES}}`, `{{AIDOS_CONDITIONAL_RULES}}` and
`{{AIDOS_SKILLS_AND_COMMANDS}}` are filled from `.ai-dos/.cursor/`.
Comments starting with `<!-- template:` are removed in the generated file.

| Purpose | Template | Target in the project | Read by |
|---|---|---|---|
| Shared entry point | [project-agents.md](project-agents.md) | `AGENTS.md` | Cursor, OpenAI Codex, GitHub Copilot; Claude Code via import |
| Claude Code entry point (imports `@AGENTS.md`) | [project-claude.md](project-claude.md) | `CLAUDE.md` | Claude Code |
| Copilot repository instructions | [project-copilot-instructions.md](project-copilot-instructions.md) | `.github/copilot-instructions.md` | GitHub Copilot |

### Adapter templates (whole generated files)

Rendered per rule, command or skill; each generated file gets a provenance
marker with a SHA-256 after its frontmatter. Cursor rules and commands need no
template: they are the master files with `.ai-dos/` path prefixes.

| Template | Target in the project |
|---|---|
| [adapters/agents-skill.md](adapters/agents-skill.md) | `.agents/skills/aidos-<skill>/SKILL.md` (Cursor, Codex, Copilot) |
| [adapters/codex-skill-policy.yaml](adapters/codex-skill-policy.yaml) | `.agents/skills/aidos-<skill>/agents/openai.yaml` (Codex: explicit-only) |
| [adapters/claude-command.md](adapters/claude-command.md) | `.claude/commands/aidos-<command or skill>.md` |
| [adapters/claude-rule.md](adapters/claude-rule.md) | `.claude/rules/aidos-<glob rule>.md` |
| [adapters/copilot-path-instructions.md](adapters/copilot-path-instructions.md) | `.github/instructions/aidos-<glob rule>.instructions.md` |
| [adapters/copilot-prompt.md](adapters/copilot-prompt.md) | `.github/prompts/aidos-<command>.prompt.md` |
| [adapters/claude-settings.json](adapters/claude-settings.json) | `.claude/settings.json` (created once if missing, then project-owned; only stricter settings) |

### Configuration and ignore files

| Purpose | Template | Target in the project |
|---|---|---|
| Manifest (installation, provenance) | [manifest.yaml](manifest.yaml) | `.ai-dos/manifest.yaml` (created if missing) |
| Project profile | [project-profile.yaml](project-profile.yaml) | `.ai-dos/project-profile.yaml` (created if missing) |
| AI-DOS block for `.gitignore` | [project-gitignore.template](project-gitignore.template) | `.gitignore` |
| `.cursorignore` content (copy manually; agents and `install.ps1` never write `.cursorignore`) | [cursorignore.template](cursorignore.template) | `.cursorignore` |
