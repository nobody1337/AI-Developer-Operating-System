# Templates

Copy a template, fill it in, and keep it next to the task (proposed location in
a consuming project: `.ai-dos/tasks/<task-id>/`). Every artifact template
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
| Project integration profile | [project-profile.yaml](project-profile.yaml) |
| `.cursorignore` content (copy to repo root manually; agents cannot write `.cursorignore`) | [cursorignore.template](cursorignore.template) |
