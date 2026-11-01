# Future Orchestrator Architecture

Status: **Conceptual. Not implemented.** This document describes a possible
future component. No code exists, and nothing in this repository executes it.

## Goal

Automate the manual orchestration flow while keeping governance, approvals and
model independence intact.

```text
receive task → classify → determine risk → select workflow → select roles
→ select models → build context → execute agents → validate → review
→ escalate if necessary → request human approval → complete
```

## Components

| Component | Responsibility | Reads | Writes |
|---|---|---|---|
| Intake | Receive requests (IDE, CLI, issue tracker) and create a task | Request | State record (`NEW`) |
| Classifier | Task + risk classification | [task-classification.md](routing/task-classification.md), [risk-classification.md](../governance/policies/risk-classification.md) | Classification |
| Workflow engine | Select workflow, drive the [state model](state/state-model.md) | [workflows/](workflows/README.md) | State transitions |
| Role resolver | Map steps to roles/specialisations | [roles/](roles/README.md) | Step assignments |
| Skill selector | Select skills by task type, role, capabilities, risk and project profile (today skills are invoked explicitly) | [skills/](../skills/README.md), project profile | Skill assignments |
| Model router | Apply [selection policy](models/selection-policy.md) to the [registry](models/registry.yaml) | Registry, capabilities | Routing record |
| Context builder | Assemble minimum [context packages](state/context-packages.md); enforce sensitivity filters | Repository, rules | Context package |
| Agent runner | Execute agents via provider/IDE adapters with role permissions | Context package | Artifacts, changes |
| Validator | Run builds/tests/linters; record real results | Project config | Test/implementation evidence |
| Gate evaluator | Evaluate [quality gates](../governance/quality/quality-gates.md) | Evidence | Gate status |
| Escalation manager | Apply [escalation](routing/escalation.md) triggers | Results | Escalations |
| Approval service | Request and record human approvals with authentication | Approval requests | Approval Records |
| Audit log | Append-only record per [audit model](state/audit-model.md) | All events | Audit records |
| Policy engine | Enforce permissions and protected actions before tool calls | [agent permissions](../governance/security/agent-permissions.md) | Allow/deny decisions |
| Integrator | Initialize and update embedded AI-DOS instances; drift detection; three-way comparison | [integration/](../integration/README.md), manifest, project profile | Embedded instance, update records |

## Interfaces (conceptual)

- **Provider adapter** — `run(role, context_package, permissions) → artifacts`;
  one adapter per provider/runtime (hosted, local, self-hosted). The core never
  depends on a specific provider.
- **IDE adapter** — Cursor, other IDEs, CLI agents. Cursor is one adapter.
- **Tool gateway** — all file/terminal/network actions pass through the policy
  engine; protected actions block until an Approval Record exists.
- **Storage** — state, artifacts and audit as files or a database, schema-compatible
  with [state/](state/README.md).

## Design constraints

1. Governance stays tool-agnostic; the orchestrator **reads** governance, it
   does not redefine it.
2. Model choice stays data-driven (registry), never hard-coded.
3. Human approval is a first-class blocking step, not a notification.
4. Every gate result is evidence-based; "not run" is a valid, visible state.
5. Fail closed: if policy evaluation fails, the action is denied.
6. The orchestrator itself is a `CRITICAL` system (it holds permissions); its
   own changes follow the security workflow.

## What Cursor can and cannot do today

| Capability | Cursor today (as far as known; verify for your version) |
|---|---|
| Load project rules from `.cursor/rules/*.mdc` (always / glob / agent-requested) | Yes, native |
| Read `AGENTS.md` | Supported by Cursor and several other agents (REQUIRES VALIDATION for your version) |
| Honour `.cursorignore` | Yes, best-effort (not a security boundary) |
| Offer project commands (`.cursor/commands`) and skills (`.cursor/skills`) | Yes, when invoked (AI-DOS skill adapters are explicit-only: `disable-model-invocation: true`; REQUIRES VALIDATION for your version) |
| Select AI-DOS skills automatically by task type, role, risk or project profile | **No** — explicit invocation only |
| Initialize or update an embedded AI-DOS in a project | **No** in Cursor itself — the human copies the folder and runs `.ai-dos/install.ps1` ([initialize](../integration/initialize.md), [update](../integration/update.md)) |
| Read `.ai-dos/manifest.yaml` / `project-profile.yaml` | **No** native parsing — agents read them by convention |
| Ask before running terminal commands | Configurable by the user in Cursor settings |
| Select a model per task automatically based on AI-DOS registry | **No** — human or Cursor's own selection |
| Enforce role permissions per agent | **No** — convention only |
| Maintain AI-DOS task state, audit log, quality gates | **No** — manual |
| Block protected actions until an Approval Record exists | **No** — relies on agent behaviour, user settings and external controls (branch protection, deploy permissions) |
| Run independent review with a different model | Manually: start a new chat/agent with a different model |

## Possible incremental path

1. Manual use with commands and templates (current).
2. Scripts that validate artifacts and state files against the schemas (lint-like).
3. CI checks: PR template enforcement, required artifacts per risk label.
4. Hooks (e.g. Cursor hooks) to require confirmation for protected commands.
5. A thin orchestrator for classification + routing recommendations.
6. Full orchestrator with policy engine and approval service.

Each step requires an ADR.
