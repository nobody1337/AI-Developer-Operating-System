# /new-adr

Draft a new Architecture Decision Record. The ADR is a proposal; only a human sets it to `Accepted`.

1. Read `governance/architecture/architecture-governance.md` and the existing ADR index
   (`governance/decisions/README.md` for AI-DOS itself, or the project's ADR folder:
   `architecture.adr_path` in `.ai-dos/project-profile.yaml` in a project with an embedded AI-DOS).
2. Determine the next ADR number; check the target file does not exist.
3. Follow `skills/architecture/SKILL.md`: current state (facts), forces, ≥ 2 options incl. "keep current",
   evaluation, recommendation.
4. Fill `templates/adr.md` with status `Proposed` and today's date.
5. Add the ADR to the relevant index.
6. Note: ADRs about AI-DOS governance itself are CRITICAL-risk governance changes and need explicit approval.
