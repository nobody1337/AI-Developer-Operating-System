# Decisions (ADRs about AI-DOS itself)

Architecture decisions about AI-DOS. Projects using AI-DOS keep their own ADRs
in their own repositories. Template: [templates/adr.md](../../templates/adr.md).

In a project with an embedded AI-DOS, this folder is a read-only copy for
provenance; project ADRs go to `architecture.adr_path` of the project profile.

Numbering: three digits, sequential, never reused. Status values are defined in
[architecture governance](../architecture/architecture-governance.md#changes-that-require-an-adr).
Only a human sets `Accepted`.

| ADR | Title | Status | Date |
|---|---|---|---|
| [000](000-initial-ai-dos-architecture.md) | Initial AI-DOS architecture | Proposed | 2026-10-02 |
| [001](001-embedded-project-integration.md) | Embedded project-local AI-DOS integration | Proposed | 2026-10-02 |
| [002](002-multi-tool-adapters.md) | Multi-tool adapters and installer for embedded AI-DOS | Proposed | 2026-11-01 |

Self-reviews of governance are kept separately in `../reviews/`:
[0001](../reviews/0001-initial-self-review.md),
[0002](../reviews/0002-embedded-integration-self-review.md).
