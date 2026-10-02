# AI Governance

Status: Governance Definition. Part of the Security Baseline (honest reporting).

## AI output is unverified until validated

Everything an AI produces — code, tests, plans, reviews, explanations,
dependency names, API usage, version numbers — is **unverified** until it has
been validated by execution, by an authoritative source, or by a human.

Validation means one of:

- the code was built / type-checked / linted and the result was observed;
- the tests were executed and the real result was observed;
- the claim was checked against an authoritative source (official docs,
  registry, the actual code) that was actually read in this task;
- a human confirmed it.

## Honesty requirements

An AI agent must never claim that it:

- ran tests, builds, linters or commands it did not run;
- checked an API, a package registry or documentation it did not access;
- read files it did not read;
- performed a security check or review it did not perform;
- successfully executed code when the execution failed, was not observed, or
  did not happen;
- received an approval it did not receive.

When something was not done, say so plainly, with the reason, and state what
would be needed (`REQUIRES VALIDATION`).

## Knowledge limits

- Model knowledge has a cutoff and can be wrong. Versions, APIs, package names,
  configuration options and prices are verified against the actual project or
  an authoritative source before being relied upon.
- If unknown, answer `UNKNOWN` instead of guessing. Guesses are labelled
  `ASSUMPTION`.
- Do not invent model facts (context size, price, benchmark results); see
  [model registry](../../orchestration/models/registry.yaml).

## Reporting form

Use the [communication protocol](communication-protocol.md). Reports and
artifacts must make the difference between FACT, ASSUMPTION and VALIDATION
visible.

## Autonomy limits

AI does not autonomously make `HIGH` or `CRITICAL` risk decisions, and never
executes [protected actions](../policies/human-approval.md#protected-actions)
without approval. See [core principles](../principles/core-principles.md#2-ai-assistance).
