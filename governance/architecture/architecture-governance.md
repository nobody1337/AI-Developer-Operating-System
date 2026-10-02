# Architecture Governance

Status: Governance Definition.

Architecture decisions are human decisions
([Human Ownership](../principles/core-principles.md#1-human-ownership)). AI
agents analyse, propose alternatives and document; they do not decide alone.

## Changes that require an ADR

| Change | Minimum risk | ADR |
|---|---|---|
| New architectural layer or module boundary | `HIGH` | Required |
| New architectural pattern (e.g. CQRS, event sourcing, state management library) | `HIGH` | Required |
| Framework introduction, replacement or major upgrade | `HIGH` | Required |
| Public or cross-team API change (new version, breaking change) | `MEDIUM` (`HIGH` if breaking) | Required if breaking |
| Data model change affecting multiple components or persistence | `MEDIUM` (`HIGH` with migration) | Required if shared or migrated |
| New external integration (service, SaaS, third-party API) | `MEDIUM` | Required |
| Cross-cutting concerns (auth, logging, error handling strategy) | `HIGH` | Required |

ADR template: [templates/adr.md](../../templates/adr.md)
(Context, Decision, Alternatives, Consequences, Status, Date).
ADR statuses: `Proposed`, `Accepted`, `Rejected`, `Deprecated`, `Superseded by ADR-NNN`.
Only a human sets `Accepted`.

## Rules

1. **Follow existing architecture.** Inspect the current structure and accepted
   ADRs first. Consistency beats theoretical improvement.
2. **No architecture from theory alone.** A pattern is introduced only for a
   present, concrete need, never "because it is best practice".
3. **Alternatives are mandatory.** Every ADR lists at least one alternative,
   including "do nothing / keep current approach" where meaningful.
4. **Consequences are explicit**, including negative ones (cost, complexity,
   migration, lock-in).
5. **Backward compatibility** is the default for APIs and data. Breaking changes
   need a migration and deprecation plan.
6. **Contract first** for integrations and fullstack work: the interface is
   agreed before both sides are implemented
   ([fullstack workflow](../../orchestration/workflows/fullstack.md)).
7. **Reversibility** is preferred: choose options that can be undone.

## Review

Architecture changes pass the `architecture` gate
([quality gates](../quality/quality-gates.md)) using
[checklists/architecture.md](../../checklists/architecture.md).
