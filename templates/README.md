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

Used by [Initialize AI-DOS in a project](../integration/initialize.md).

| Purpose | Template | Target in the project |
|---|---|---|
| Manifest (installation, provenance) | [manifest.yaml](manifest.yaml) | `.ai-dos/manifest.yaml` |
| Project profile | [project-profile.yaml](project-profile.yaml) | `.ai-dos/project-profile.yaml` |
| Project `AGENTS.md` with AI-DOS block | [project-agents.md](project-agents.md) | `AGENTS.md` |
| AI-DOS block for `.gitignore` | [project-gitignore.template](project-gitignore.template) | `.gitignore` |
| `.cursorignore` content (copy manually; agents cannot write `.cursorignore`) | [cursorignore.template](cursorignore.template) | `.cursorignore` |
