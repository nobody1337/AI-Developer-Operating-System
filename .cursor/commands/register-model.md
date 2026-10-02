# /register-model

Register a new model in the AI-DOS model registry as `discovered`.

1. Read `orchestration/models/adding-a-model.md`, `orchestration/models/lifecycle.md`,
   `orchestration/models/capabilities.yaml` and the field reference at the top of `orchestration/models/registry.yaml`.
2. Ask the human for: provider, exact product name and version, deployment (hosted/local/self_hosted),
   source link. Do not fill these from memory.
3. Check that the `id` is unique and kebab-case; the id describes the entry, not the vendor brand.
4. Add the entry with `status: discovered` and `approved_roles: []`; set every unverified value to `unknown`
   (capabilities, context size, speed, quality, cost class, tools, data policy).
5. Put the source link in `verification.evidence`; leave `verified_by`/`verified_at` empty.
6. Never invent context sizes, prices or benchmark results. Never set status above `discovered`.
7. Explain the next steps (candidate → evaluation with `templates/model-evaluation.md` → human approval).
8. Changing the registry is a reviewed change; present the diff for human approval.
