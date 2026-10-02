# Model Lifecycle

Status: Governance Definition. Status values are stored in
[registry.yaml](registry.yaml) and changed manually by a human.

```text
discovered → candidate → evaluated → approved → preferred → deprecated → retired
                 ↑            │            │          │
                 └── re-evaluate ←─────────┴──────────┘   (any status → deprecated/retired)
```

`example` is not a lifecycle status; it marks illustrative entries that are
never selectable.

## States

| Status | Meaning | Entry criteria | Exit criteria | Selectable by routing? |
|---|---|---|---|---|
| `discovered` | Known to exist | Name, provider and source link recorded | Someone sponsors evaluation | No |
| `candidate` | Worth evaluating | Provider data-handling terms located; intended roles stated | Evaluation completed | Only for evaluation tasks |
| `evaluated` | Evaluated, not yet approved | [Model Evaluation](../../templates/model-evaluation.md) report exists with evidence | Human approval or rejection | Only with explicit human choice |
| `approved` | Allowed for named roles and sensitivity | Human sets `max_data_sensitivity`, `approved_roles`, limitations; `verification` block filled | Superseded, issues found, provider change | Yes, within approved scope |
| `preferred` | Default choice for named roles/profiles | Approved **and** better than alternatives for those roles in a documented comparison | A better model is approved, or issues found | Yes, ranked first |
| `deprecated` | Being phased out | Decision recorded with reason and replacement | Retirement date reached | Only with warning, for continuity |
| `retired` | No longer used | Removed from all routing; kept for audit history | — | No |

## Rules

1. **A model is never preferred automatically** because it is new, popular,
   larger or "more powerful". Promotion requires evidence and a human decision.
2. Status changes are recorded in the entry's `notes` and `verification` block
   (who, when, evidence), and are reviewed like code.
3. A new model version is a new evaluation subject. Previous results do not
   transfer automatically.
4. Provider changes to data handling, pricing class or availability trigger a
   re-check; the model may be moved to `deprecated` or back to `candidate`.
5. Approval is scoped: roles, task types, maximum data sensitivity.

See [evaluation.md](evaluation.md) and [adding-a-model.md](adding-a-model.md).
