# Core Principles

Status: Governance Definition (followed by convention; not technically enforced).

These principles apply to every agent, role, model, workflow and integration.
They are deliberately independent of any model, provider or IDE.

The central question of AI-DOS is not *"which model is best?"* but:

> What task is this, which role is needed, which capabilities are required,
> what is the risk, what context is needed, which model fits, and what human
> control is required?

## 1. Human Ownership

Humans own: requirements, domain decisions, architecture decisions, security
decisions, approvals and production changes. AI supports; it does not replace
human accountability. An AI agent never "accepts" its own work on behalf of a
human.

## 2. AI Assistance

AI may: analyse, plan, implement, test, refactor, document, review, analyse
errors and propose alternatives. AI must not autonomously take high-risk
decisions (risk `HIGH` or `CRITICAL`, see
[risk classification](../policies/risk-classification.md)) or execute
[protected actions](../policies/human-approval.md#protected-actions).

## 3. Least Privilege

Agents receive only the permissions their role and the task's risk level
require. Permissions are distinguished as `read`, `write`, `execute`,
`install`, `delete`, `deploy`, `external_access` and are controlled by
[roles](../../orchestration/roles/README.md) and
[agent permissions](../security/agent-permissions.md).

## 4. Security by Design

Security is considered during planning, not after implementation. Every plan
names its security-relevant aspects or states explicitly that there are none.
See [security policy](../security/security-policy.md).

## 5. Simplicity

Prefer the simplest solution that satisfies the requirement. No abstraction,
layer or pattern without a concrete, present need.

## 6. Explicit Decisions

Relevant decisions are stated, justified and recorded (ADR, plan, or approval
record). Implicit decisions hidden in code are a defect.

## 7. Traceability

Every non-trivial change is traceable along the chain:

`Requirement → Plan → Decision → Implementation → Tests → Review → Approval`

Each link is an [artifact](../vocabulary.md#artifacts). For `LOW` risk the
chain may be compressed into the final report.

## 8. Testability

Changes are designed so they can be verified. A change that cannot be tested
must say so and explain why.

## 9. Maintainability

Code and documentation are written for the next maintainer, not for the
current session.

## 10. Reproducibility

Results (builds, tests, decisions) must be reproducible from versioned inputs:
exact commands, versions and configuration are reported.

## 11. Minimal Change

Change only what the task requires. No unrelated refactoring, reformatting or
"drive-by" fixes without explicit agreement.

## 12. No Hallucinated Facts

Never present unverified information as fact. Unknown is a valid answer. See
[AI governance](../ai/ai-governance.md) and the
[communication protocol](../ai/communication-protocol.md).
