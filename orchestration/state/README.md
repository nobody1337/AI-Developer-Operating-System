# State, Audit, Context and Handoffs

Status: **Conceptual.** These documents define formats a future orchestrator
would maintain automatically. Today they can be used manually.

| File | Purpose |
|---|---|
| [state-model.md](state-model.md) | Task states and allowed transitions |
| [task-state.schema.yaml](task-state.schema.yaml) | State record schema |
| [task-state.example.yaml](task-state.example.yaml) | Example state record |
| [audit-model.md](audit-model.md) | What must be traceable |
| [audit-record.schema.yaml](audit-record.schema.yaml) | Audit record schema + example |
| [context-packages.md](context-packages.md) | Minimum-context packages |
| [context-package.schema.yaml](context-package.schema.yaml) | Context package schema + example |
| [handoffs.md](handoffs.md) | Artifact chain and common artifact header |

Runtime data (real task records) must not be committed in the Central AI-DOS:
`orchestration/state/runtime/` is git-ignored and cursor-ignored. In a project
with an embedded AI-DOS, task records and artifacts live in `.ai-dos/state/`
and `.ai-dos/artifacts/`; what is versioned is defined in
[state and artifacts](../../integration/state-and-artifacts.md).
