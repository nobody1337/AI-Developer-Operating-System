# Routing Policy

Status: Governance Definition. In Cursor today routing is **manual**: the agent
produces a routing recommendation; the human selects the model (or lets
Cursor's own selection decide) and starts the agent. No component in AI-DOS
switches models or dispatches agents automatically.

## Order of decisions

```text
1. Classify task      → task-classification.md
2. Classify risk      → governance/policies/risk-classification.md
3. Select workflow    → workflows/
4. Select role(s)     → roles/
5. Select model(s)    → models/selection-policy.md
6. Define human control → governance/policies/human-approval.md
```

The model is chosen **last**, after the role is known. Never start from "which
model is best".

## Routing priorities

When requirements compete, earlier items win:

1. Required capability
2. Security and risk requirements
3. Context requirements
4. Tool availability
5. Expected quality
6. Reliability
7. Cost
8. Latency

**Cost and speed never override security or quality requirements.**

## Data sensitivity

Data sensitivity is a hard filter, applied before ranking. `confidential`
context may only go to models approved for it; `restricted` context normally
requires a `local` or `self_hosted` model, or must not enter AI context at all
([secrets and data](../../governance/security/secrets-and-data.md)).

## Multi-model workflows

Different steps may use different models: e.g. a strong reasoning model for
planning, a fast implementation model for `LOW` complexity coding, and a
different model for independent review. Each step is routed separately using
its role's capabilities.

## Routing record

The recommendation is stated in the plan or report:

```yaml
routing:
  workflow: feature
  steps:
    - step: planning
      role: planner
      profile: strong_reasoning
      model: UNKNOWN            # selected by human in IDE; registry has no approved entry
      model_selected_by: human
    - step: review
      role: code-reviewer
      profile: independent_review
      independence: "different agent session than author"
```

Agents report the model actually used only if they know it; otherwise
`model: UNKNOWN`.

Related: [escalation.md](escalation.md), [selection policy](../models/selection-policy.md).
