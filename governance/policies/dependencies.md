# Dependency Governance

Status: Governance Definition.

## Rules

1. A new dependency is at least `MEDIUM` risk
   ([risk classification](risk-classification.md)). Dependencies touching
   authentication, cryptography or build/deploy pipelines are `HIGH`.
2. **AI-generated dependency names are never used unverified.** Models can
   invent plausible package names; attackers register such names
   (slopsquatting / typosquatting).
3. Installing packages or tools is a [protected action](human-approval.md#protected-actions):
   propose first, install after approval.
4. Prefer: no new dependency > standard library > existing project dependency >
   new dependency.
5. Upgrades of major versions are treated like new dependencies.

## Verification (before proposing)

Use [checklists/dependency.md](../../checklists/dependency.md). The proposal
must state for each item whether it was **verified** (with source) or is
`UNKNOWN`:

- existence in the official registry and **exact** package name
- maintainer / publisher and repository link
- recency of releases and maintenance activity
- known vulnerabilities / security advisories
- licence compatibility
- transitive dependencies (count and notable ones)
- alternatives considered (including "no dependency")
- actual necessity for the task

If the agent has no network access or did not check a registry, it must say
so (e.g. `REQUIRES VALIDATION: package existence not verified`).

## Lockfiles

Lockfile changes are reviewed like code. Unexpected lockfile churn is a review
finding.
