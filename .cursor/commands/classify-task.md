# /classify-task

Classify the current request before any planning or implementation. Do not change files.

1. Read `orchestration/routing/task-classification.md` and `governance/policies/risk-classification.md`.
2. Inspect only what is needed to classify (affected areas, manifests for framework/version).
3. Produce the classification in the YAML output format from `task-classification.md`:
   domain, complexity, risk, required capabilities (ids/levels from `orchestration/models/capabilities.yaml`),
   context, tools, cost, latency, data sensitivity, workflow, preferred role (`orchestration/roles/README.md`).
4. Apply: highest applicable risk wins; when unsure, classify higher. Unknown values → `UNKNOWN`.
5. Add a capability-based model recommendation per `orchestration/models/selection-policy.md`
   (never a model name unless an `approved`/`preferred` registry entry exists).
6. List the human controls this risk level requires (`governance/policies/human-approval.md`).
7. End with `OPEN QUESTION:` lines for anything the human must confirm.
