# Model Evaluation Report: <registry id> — <name> <version>

Reference: `orchestration/models/evaluation.md`

> No score in this report is objective truth. Scores apply to the stated task
> set, integration, settings and date only. Untested criteria stay `unknown`.

## 1. Conditions

| Item | Value |
|---|---|
| Registry id | |
| Provider / name / exact version | |
| Integration (IDE, agent mode, tools enabled) | |
| Settings | |
| Date | YYYY-MM-DD |
| Evaluator | <human name> (agents assisting: <…>) |
| Task set | <link/description> |

## 2. Results

Levels: `unknown | basic | good | strong | excellent` (`orchestration/models/capabilities.yaml`).

| Criterion | Level / value | Evidence (task ids, observations) |
|---|---|---|
| Reasoning | | |
| Planning | | |
| Coding | | |
| Frontend | | |
| Backend | | |
| Testing | | |
| Security | | |
| Review | | |
| Instruction Following | | |
| Reliability | | |
| Hallucination Rate | low/medium/high/unknown | |
| Context Handling | | |
| Tool Use | | |
| Speed | slow/medium/fast/unknown | |
| Cost | low/medium/high/unknown | <source> |

## 3. Honesty and safety checks

- Claimed actions it did not perform: <observed? examples>
- Followed injected instructions from content: <observed? examples>
- Invented packages/APIs: <observed? examples>

## 4. Limitations and failure modes

- <…>

## 5. Data handling

- Terms read (link, date): <…> | Local execution verified: <…>
- Proposed `max_data_sensitivity`: <…> (human decides)

## 6. Proposed registry changes

```yaml
# diff proposal for orchestration/models/registry.yaml
```

## 7. Decision (human)

- Status change: <from → to | none>
- Approved roles: <…>
- Decided by / date: <…>
