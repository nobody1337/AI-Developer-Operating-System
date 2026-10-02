# Task Classification

Status: Governance Definition. Performed by the agent (or human) at the start
of every task. Cursor command: [`/classify-task`](../../.cursor/commands/classify-task.md).

## Dimensions

| Dimension | Values / content |
|---|---|
| Domain | `frontend`, `backend`, `fullstack`, `database`, `devops`, `security`, `testing`, `documentation`, `architecture`, `release`, `other` |
| Complexity | `LOW` (single, well-understood change, few files) · `MEDIUM` (several files or components, some design choices) · `HIGH` (cross-cutting, ambiguous, new architecture, many components) |
| Risk | `LOW` · `MEDIUM` · `HIGH` · `CRITICAL` per [risk classification](../../governance/policies/risk-classification.md) |
| Required Capabilities | Capability ids from [capabilities.yaml](../models/capabilities.yaml) with minimum levels |
| Context Requirements | Which files/areas, estimated size, multi-source? |
| Tool Requirements | filesystem, terminal, browser, git, network |
| Cost Constraints | `none` · `low_cost_preferred` · `budget_limit: <value>` |
| Latency Requirements | `none` · `interactive` (fast feedback) · `batch` |
| Data Sensitivity | `public` · `internal` · `confidential` · `restricted` per [secrets and data](../../governance/security/secrets-and-data.md) |
| Workflow | One of [workflows](../workflows/README.md) |
| Preferred Role | Base role or specialisation per [roles](../roles/README.md) |

## Rules

- Classify before planning; re-classify when new information appears.
- Risk: highest applicable wins; when unsure, classify higher.
- Unknown dimensions are written as `UNKNOWN`, not guessed.

## Output format

```yaml
task: "Implement Angular dashboard component"
domain: frontend
complexity: MEDIUM
risk: LOW
required_capabilities:
  frontend: good
  framework_knowledge: good   # angular
  coding: good
  testing: good
context_requirements: "Dashboard module, shared UI components, existing component tests"
tool_requirements: [filesystem, terminal]
cost_constraints: none
latency_requirements: interactive
data_sensitivity: internal
workflow: frontend
preferred_role: frontend-developer
rationale:
  - "FACT: No API, auth or dependency change requested."
  - "ASSUMPTION: Data is provided by an existing service."
```

## Example (from the requirements)

| Field | Value |
|---|---|
| Task | Implement Angular dashboard component |
| Domain | Frontend |
| Complexity | Medium |
| Risk | Low |
| Required capabilities | frontend, framework_knowledge (Angular), coding, testing |
| Preferred role | Frontend Developer (`frontend-developer`) |
