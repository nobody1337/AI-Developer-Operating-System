# AI-Generated Code Checklist

AI output is unverified until validated ([AI governance](../governance/ai/ai-governance.md)).

## Hallucination checks
- [ ] Every imported package exists and is already a project dependency (or approved)
- [ ] Every API/function/option used exists in the **installed** version
- [ ] Referenced files, config keys, env variables and endpoints actually exist
- [ ] Version numbers and framework features verified against manifests

## Honesty checks
- [ ] Claimed test/build runs are backed by real output
- [ ] Claimed "verified" statements cite what was read or executed
- [ ] `not_run` items are reported, not hidden

## Tests written by AI
- [ ] Not tautological (do not just assert mocks or constants)
- [ ] Assertions not weakened to make tests pass
- [ ] Tests fail when the behaviour is broken (demonstrated where practical)
- [ ] No over-mocking; deterministic

## Scope and quality
- [ ] No silent scope creep, no unrelated refactoring or reformatting
- [ ] No duplicated logic where an existing helper exists
- [ ] No placeholder code (`TODO: implement`, fake data) left unflagged
- [ ] No commented-out code or debug output left behind
- [ ] Error handling present, not generic catch-all

## Security
- [ ] No secrets or realistic-looking credentials (use obvious fakes)
- [ ] No unsafe patterns typical of generated code (string-built queries, `eval`, disabled TLS verification, permissive CORS)
