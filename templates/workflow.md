# Workflow: <Name> (`<workflow-id>`)

Status: Governance Definition.
<!-- Reference roles and capabilities only. Never name a model. -->

## Trigger

<What starts this workflow.>

## Input

- <request type, required artifacts>

## Classification

- Typical domain / complexity / risk: <…>
- Risk raisers: <change types that raise risk>

## Roles

| Step | Role |
|---|---|
| <step> | `<role-id>` or `<role-id>[<domain>]` |

## Model Selection

Capability-based, per step, e.g.:
"Select a model capable of: planning ≥ strong, reasoning ≥ strong, large context."
See `orchestration/models/selection-policy.md`.

## Steps

1. <step> → output `<artifact id>`

## Validation

- <commands/checks that must actually run>

## Review

- <review requirements by risk>

## Approval

- <human approval gates by risk>

## Output

- <artifacts and deliverables>
