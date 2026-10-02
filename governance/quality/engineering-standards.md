# Software Engineering Standards

Status: Governance Definition. Project rules (rank 5) and technical standards of
the language/framework (rank 8) refine these; see the
[hierarchy](../principles/governance-hierarchy.md).

## Clean code and naming

- Names describe intent and domain meaning; avoid abbreviations and generic
  names (`data`, `manager`, `helper`) unless conventional in the project.
- Functions do one thing; keep them short enough to understand at a glance.
- Follow the project's existing style; do not reformat unrelated code.

## Modularity, cohesion, coupling

- High cohesion: things that change together live together.
- Low coupling: depend on stable interfaces, not on internals.
- Respect existing module boundaries; crossing them is an architecture topic
  ([architecture governance](../architecture/architecture-governance.md)).

## No unnecessary abstraction

- Introduce an abstraction only when there are at least two real uses or a
  documented, present need.
- Reuse existing services and utilities before creating new ones.
- Do not add configuration, extension points or generic frameworks "for the future".

## Error handling

- Never swallow errors silently. Handle, translate with context, or propagate.
- Distinguish expected errors (validation, not found) from unexpected ones.
- Fail closed for security decisions.
- User-facing messages contain no internal details or sensitive data.

## Logging

- Log events that help operate and debug the system, at appropriate levels.
- Never log secrets, tokens, credentials or `restricted` data
  ([secrets and data](../security/secrets-and-data.md)).
- Prefer structured logging where the project supports it.

## Performance

- Avoid obvious inefficiencies (N+1 queries, unbounded loops over remote calls,
  unnecessary re-renders, loading large data sets into memory).
- Optimise based on measurement, not assumption; state assumptions as such.

## API design and backward compatibility

- Consistent naming, error format and versioning within a project.
- Additive changes over breaking changes; breaking changes need an ADR and a
  migration path.
- Validate input at the boundary; document contracts.

## Maintainability and technical debt

- Leave code at least as understandable as before.
- Known shortcuts are documented as technical debt (where, why, how to fix)
  in the Implementation Report — not hidden.
- Remove dead code you introduced; do not remove unrelated code without agreement.
