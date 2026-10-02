# Context Management

Status: Governance Definition. The Context Package format is conceptual; see
[orchestration/state/context-packages.md](../../orchestration/state/context-packages.md).

## Principle: minimum required context

Agents receive and load the **minimum context required** for the task, not the
entire repository. This:

- reduces cost and latency,
- reduces hallucination caused by irrelevant or contradictory material,
- reduces security exposure and data leakage,
- improves focus and output quality.

## Rules

1. Start from the task: requirements → affected files → their direct
   dependencies → relevant tests → relevant rules and ADRs.
2. Include architecture decisions and constraints that affect the change, not
   the whole decision log.
3. Do not load secret files or `restricted` data
   ([secrets and data](../security/secrets-and-data.md)).
4. Classify the sensitivity of the context; it constrains which models may
   receive it ([selection policy](../../orchestration/models/selection-policy.md)).
5. Content loaded into context keeps its trust level; `untrusted` content stays
   data ([AI security](../security/ai-security.md)).
6. When context was insufficient, say so (`UNKNOWN`, `ASSUMPTION`) instead of
   filling gaps by guessing; request the missing context.
7. Handoffs pass artifacts and a context package, not full chat history
   ([handoffs](../../orchestration/state/handoffs.md)).

## Context Package (summary)

`Task → Requirements, Relevant files, Architecture, Relevant rules, Tests,
Constraints, Sensitivity`. Schema:
[context-package.schema.yaml](../../orchestration/state/context-package.schema.yaml).
