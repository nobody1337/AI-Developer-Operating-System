# Role: <Display Name> (`<role-id>`)

Status: Governance Definition.
<!-- Role ids are kebab-case. Adding a base role is a governance change (ADR). -->

## Purpose

<One or two sentences: why this role exists.>

## Responsibilities

- <responsibility>

## Inputs

- <artifact id or material, e.g. `task_specification`, `implementation_plan`>

## Outputs

- <artifact id, e.g. `implementation_report`>

## Allowed Actions

- <action>

## Forbidden Actions

- <action> — hand off to `<role-id>` or escalate

## Required Capabilities

```yaml
required_capabilities:   # ids and levels from orchestration/models/capabilities.yaml
  <capability>: <basic|good|strong|excellent>
```

## Permissions

| Permission | Grant | Note |
|---|---|---|
| `read` | allowed / approval_required / forbidden | |
| `write` | | |
| `execute` | | |
| `install` | | |
| `delete` | | |
| `deploy` | | |
| `external_access` | | |

Global constraints in `governance/security/agent-permissions.md` always apply.

## Review Requirements

- <who reviews this role's output, per risk level>

## Escalation Conditions

- <condition> → <target role or human>

## Handoff

| Direction | Artifact | From / To |
|---|---|---|
| In | <artifact> | <role> |
| Out | <artifact> | <role> |

## Specialisations

- `<role-id>[<domain>]` — <added focus>

## Skills typically used

- `skills/<skill>/SKILL.md`
