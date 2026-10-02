# AI-DOS Vocabulary (Canonical)

This file is the **single source of truth for identifiers** used across AI-DOS.
All governance documents, roles, workflows, templates, schemas and Cursor rules
MUST use exactly these terms. Definitions of behaviour live in the linked
documents; this file only fixes names.

## Risk levels

`LOW` | `MEDIUM` | `HIGH` | `CRITICAL` — defined in
[policies/risk-classification.md](policies/risk-classification.md).
Rule: the highest applicable level wins; when unsure, classify higher.

## Complexity levels

`LOW` | `MEDIUM` | `HIGH` — defined in
[../orchestration/routing/task-classification.md](../orchestration/routing/task-classification.md).

## Data sensitivity levels

`public` | `internal` | `confidential` | `restricted` — defined in
[security/secrets-and-data.md](security/secrets-and-data.md).

## Permissions

`read` | `write` | `execute` | `install` | `delete` | `deploy` | `external_access`

Grant values: `allowed` (within task scope) | `approval_required` | `forbidden`.
Defined in [security/agent-permissions.md](security/agent-permissions.md).

## Instruction trust levels

`trusted_human` | `trusted_governance` | `semi_trusted` | `untrusted` — defined in
[security/ai-security.md](security/ai-security.md).

## Base roles

`planner`, `architect`, `frontend-developer`, `backend-developer`,
`database-engineer`, `devops-engineer`, `tester`, `security-reviewer`,
`code-reviewer`, `release-manager`.

Specialisations use the notation `<base-role>[<domain>]`, e.g.
`planner[frontend]` ("Frontend Planner"), `code-reviewer[accessibility]`
("Accessibility Reviewer"). Defined in
[../orchestration/roles/README.md](../orchestration/roles/README.md).

## Capabilities

Capability ids and levels (`unknown`, `basic`, `good`, `strong`, `excellent`)
are defined only in
[../orchestration/models/capabilities.yaml](../orchestration/models/capabilities.yaml).

## Model lifecycle status

`discovered` → `candidate` → `evaluated` → `approved` → `preferred` →
`deprecated` → `retired`, plus the non-lifecycle marker `example`
(illustrative entry, never selectable). Defined in
[../orchestration/models/lifecycle.md](../orchestration/models/lifecycle.md).

## Task states

`NEW`, `CLASSIFIED`, `PLANNED`, `APPROVED`, `IMPLEMENTING`, `TESTING`, `REVIEW`,
`SECURITY_REVIEW`, `WAITING_FOR_HUMAN`, `COMPLETED`, `BLOCKED`, `FAILED`,
`CANCELLED` — defined in
[../orchestration/state/state-model.md](../orchestration/state/state-model.md).

## Quality gates and gate status

Gates: `planning`, `architecture`, `implementation`, `testing`, `security`,
`review`, `release`.
Status: `passed` | `failed` | `not_run` | `not_applicable` | `waived_with_approval`.
Defined in [quality/quality-gates.md](quality/quality-gates.md).

## Approval gates and decisions

Approval Record `gate`: `plan` | `implementation` | `security` | `release` |
`protected_action` | `waiver` (approval gates are distinct from the quality
gates above). Decision: `approved` | `rejected` | `approved_with_conditions`.
Defined in [policies/human-approval.md](policies/human-approval.md#approval-record).

## Scopes

`global` | `project` | `task` — defined in
[principles/governance-hierarchy.md](principles/governance-hierarchy.md#scopes-global--project--task).

## Project integration

- **Central AI-DOS** (master) and **Embedded AI-DOS** (project instance).
- Integration mode: `embedded` (the only supported mode).
- Governance profile: `standard` (manifest `governance.profile`; not to be
  confused with the project profile file or capability profiles in routing).
- File classes: `copied`, `template`, `generated`, `project_specific`,
  `project_data`, `master_only`, `master_docs`.
- Update resolutions: `update`, `keep_local`, `conflict`, `added`,
  `removed_proposed`, `skip_project_owned`.

Defined in [../integration/README.md](../integration/README.md) and
[../integration/update.md](../integration/update.md#conflict-mechanism).

## Artifacts

| Artifact id | Name | Template |
|---|---|---|
| `task_specification` | Task Specification | [templates/task-specification.md](../templates/task-specification.md) |
| `risk_assessment` | Risk Assessment | [templates/risk-assessment.md](../templates/risk-assessment.md) |
| `implementation_plan` | Implementation Plan | [templates/implementation-plan.md](../templates/implementation-plan.md) |
| `architecture_decision` | Architecture Decision (ADR) | [templates/adr.md](../templates/adr.md) |
| `implementation_report` | Implementation Report | [templates/implementation-report.md](../templates/implementation-report.md) |
| `test_report` | Test Report | [templates/test-report.md](../templates/test-report.md) |
| `review_report` | Review Report | [templates/code-review.md](../templates/code-review.md) |
| `security_report` | Security Report | [templates/security-report.md](../templates/security-report.md) |
| `approval_record` | Approval Record | [templates/approval-record.md](../templates/approval-record.md) |

Common artifact header: [../orchestration/state/handoffs.md](../orchestration/state/handoffs.md).

## Communication protocol labels

`FACT`, `ASSUMPTION`, `DECISION`, `RECOMMENDATION`, `RISK`, `OPEN QUESTION`,
`VALIDATION`; uncertainty markers `UNKNOWN`, `ASSUMPTION`, `REQUIRES VALIDATION`.
Defined in [ai/communication-protocol.md](ai/communication-protocol.md).

## Enforcement labels

- **Governance Definition** — documented rule, followed by agents and humans by
  convention. Not technically enforced.
- **Actual Automated Orchestration** — executed or enforced by tooling. In this
  version of AI-DOS this is limited to what Cursor does natively (loading rules,
  honouring ignore files, offering commands and explicitly invoked skills). See
  [what Cursor can and cannot do today](../orchestration/future-orchestrator.md#what-cursor-can-and-cannot-do-today).
- **Conceptual** — a designed format or component that nothing implements yet
  (state records, audit records, context packages, orchestrator).

## Task id format

`TASK-YYYYMMDD-<short-slug>`, e.g. `TASK-20261002-dashboard-widget`.
