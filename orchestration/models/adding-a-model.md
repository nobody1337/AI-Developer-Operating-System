# How to Add a New Model

Status: Governance Definition (manual process). Cursor command:
[`/register-model`](../../.cursor/commands/register-model.md).

Adding a model **never** requires changing roles or workflows — they reference
capabilities, not models. Only [registry.yaml](registry.yaml) changes.

## Steps

1. **Register as `discovered`.** Add an entry with a new kebab-case `id`,
   `provider`, `name`, exact `version` (or `unknown`), `deployment`, and a
   source link in `verification.evidence`. Every other value is `unknown`.
2. **Check data handling.** Locate the provider's terms for data retention and
   training on inputs (or confirm local execution). Record what was actually
   read, with link. Move to `candidate`.
3. **Evaluate.** Follow [evaluation.md](evaluation.md); write a report from
   [templates/model-evaluation.md](../../templates/model-evaluation.md).
   Update capability values only where the report provides evidence. Move to
   `evaluated`.
4. **Approve (human).** A human decides: `approved_roles`,
   `max_data_sensitivity`, limitations. Fill `verification.verified_by` and
   `verified_at`. Move to `approved`.
5. **Prefer (optional, human).** Only after a documented comparison with
   alternatives for specific roles. Move to `preferred`.
6. **Review the change** like any governance change (the registry is part of
   orchestration configuration; changes are reviewed in a PR).

## Local and self-hosted models

- Use `provider: local` or `self_hosted` and `deployment: local` / `self_hosted`.
- Record hardware constraints in `limitations` (memory, GPU, throughput).
- `max_data_sensitivity` may be set up to `restricted` only after a human has
  verified that no data leaves the controlled environment (including
  telemetry of the runtime and IDE integration).
- Note whether the IDE can actually use the model with tools; if not, set
  `tools.*: no` and restrict roles accordingly.

## Do not

- Do not invent context sizes, prices or benchmark scores.
- Do not set status above `discovered` without evidence.
- Do not reference the model by name in workflows, roles or rules.
