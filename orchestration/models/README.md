# Models

Status: Governance Definition + configuration data. Nothing here switches
models automatically.

| File | Purpose |
|---|---|
| [capabilities.yaml](capabilities.yaml) | Capability vocabulary and qualitative levels (single source of truth) |
| [registry.yaml](registry.yaml) | Model registry (currently **examples only**) |
| [selection-policy.md](selection-policy.md) | How a model is matched to a role and task |
| [lifecycle.md](lifecycle.md) | `discovered` → … → `retired` with entry/exit criteria |
| [evaluation.md](evaluation.md) | Evaluation criteria and procedure |
| [adding-a-model.md](adding-a-model.md) | How to register a new model |

Key rules:

- **Role ≠ model.** Roles define responsibility; models offer capabilities.
- Workflows and roles reference **capabilities**, never model names.
- Unverified values are `unknown`; `unknown` never satisfies a requirement.
- Registry examples are not architecture and not recommendations.
