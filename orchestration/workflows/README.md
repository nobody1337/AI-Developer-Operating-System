# Workflows

Status: Governance Definition (executed manually; see
[orchestration README](../README.md#who-does-what-today)).

Workflows reference **roles and capabilities**, never model names. Step
applicability by risk level: [orchestration flow](../README.md#orchestration-flow).

| Workflow | Use for |
|---|---|
| [feature.md](feature.md) | New functionality (generic) |
| [bugfix.md](bugfix.md) | Defects |
| [refactoring.md](refactoring.md) | Behaviour-preserving structural change |
| [frontend.md](frontend.md) | UI-focused work |
| [backend.md](backend.md) | API / server-side work |
| [fullstack.md](fullstack.md) | Changes spanning frontend and backend |
| [security.md](security.md) | Security fixes, hardening, security-relevant changes |
| [testing.md](testing.md) | Test creation/improvement without feature change |
| [release.md](release.md) | Preparing and executing a release |

Domain workflows (`frontend`, `backend`, `fullstack`) refine the generic
[feature](feature.md) workflow; they do not replace its gates.

Integration workflows for AI-DOS itself (conceptual):
[`ai-dos-initialize`](../../integration/initialize.md) and
[`ai-dos-update`](../../integration/update.md). In a project, `.ai-dos/workflows/`
configures the global workflows and holds project workflows.

## Creating a new workflow

1. Copy [templates/workflow.md](../../templates/workflow.md).
2. Use only role ids/specialisations from [roles](../roles/README.md) and
   capability ids from [capabilities.yaml](../models/capabilities.yaml).
3. Keep all gates required by [risk classification](../../governance/policies/risk-classification.md);
   a workflow may add gates, never remove them.
4. Add it to the table above and, if useful, a Cursor command in `.cursor/commands/`.
5. Workflow changes are governance changes (human approval; ADR if substantive).
