# Documentation Governance

Status: Governance Definition.

## Document

- Architecture decisions (as ADRs, [template](../../templates/adr.md))
- Relevant constraints (technical, legal, organisational)
- External APIs and integrations (contracts, versions, limits)
- Security decisions and their rationale
- Complex business logic that is not obvious from the code
- Non-obvious technical decisions ("why", not "what")
- How to build, test, run and release the project

## Do not document

- What the code already says clearly
- Session narratives ("in this chat we did …")
- Temporary notes without long-term value
- Speculative designs that were not decided (use an ADR with status
  `Proposed` if it matters)

## Rules

- Keep one source of truth; link instead of copying.
- Update documentation in the same change that makes it outdated.
- Mark unverified statements (`REQUIRES VALIDATION`) instead of presenting
  them as facts.
- Code comments explain constraints and intent the code cannot express; they
  do not narrate the change.
