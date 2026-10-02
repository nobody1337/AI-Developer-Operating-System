# Model Selection Policy

Status: Governance Definition. Describes how a model is matched to a role and
task **after** the task has been classified and the role selected
([routing policy](../routing/routing-policy.md)).

In Cursor today, the model is selected by the human (or by Cursor's own
automatic selection). This policy produces a **recommendation**; it does not
switch models.

## Inputs

- Required capabilities and minimum levels: from the role definition, raised
  by the task classification.
- Capability profile from complexity ([escalation](../routing/escalation.md#complexity-based-profiles)).
- Risk level and review independence requirements.
- Data sensitivity of the context package.
- Tool requirements (filesystem, terminal, browser, git).
- Context requirements (estimated size, multi-source).
- Cost and latency constraints.

## Step 1 — Eligibility filters (hard constraints)

A model is eligible only if **all** hold:

1. `status` is `approved` or `preferred` (or `deprecated` with a warning).
   `example`, `discovered`, `retired` are never eligible; `candidate` and
   `evaluated` only with explicit human choice.
2. Approved for the role: the role (base role of a specialisation) is listed in
   `approved_roles`, set by a human at approval. `preferred_roles` is only a hint
   and never makes a model eligible.
3. `data_policy.max_data_sensitivity` ≥ the context sensitivity. `restricted`
   context normally requires `deployment: local` or `self_hosted`.
4. Every required capability meets its minimum level. **`unknown` never
   satisfies a minimum.**
5. Required tools are `yes` in the integration used.
6. Verified context size suffices, if the task needs large context.
7. For independent review: not the same model (and not the same agent session)
   that authored the change.
8. In a project with an embedded AI-DOS: allowed by the project profile —
   listed in `ai.allowed_models` if that list is not empty, and not listed in
   `ai.forbidden_models`. Project restrictions only narrow eligibility; they
   never make a model eligible ([project profile schema](../../integration/project-profile.schema.yaml)).

## Step 2 — Ranking (soft criteria, in order)

1. Required capability margin
2. Security / risk fit (e.g. stronger `security` and `review` for `HIGH`)
3. Context handling
4. Tool support quality
5. Expected quality (`performance.quality`)
6. Reliability (`performance.reliability`)
7. Cost (`economics.cost_class`)
8. Latency (`performance.speed`)

`preferred` ranks before `approved` only when the criteria above are equal;
after that, a project's `ai.preferred_models` breaks remaining ties.
**Cost and speed never override security or quality requirements.**

## Step 3 — Result

Output a recommendation in this form:

```text
DECISION: Role = backend-developer; profile = strong_reasoning
RECOMMENDATION: Use a model with backend ≥ good, coding ≥ good, reasoning ≥ strong, tool_use ≥ good, approved for `internal` data.
FACT: Eligible registry entries: none (registry contains only `example` entries).
OPEN QUESTION: Please select a model in your IDE that meets this profile.
```

If no eligible model exists, say so and ask the human. Never pretend a model
was selected or verified.
