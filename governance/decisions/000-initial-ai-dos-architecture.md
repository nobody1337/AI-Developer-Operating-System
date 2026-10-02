# ADR-000: Initial AI-DOS Architecture

- **Status:** Proposed <!-- drafted by an AI agent; only a human sets Accepted -->
- **Date:** 2026-10-02
- **Deciders:** Axel (owner) — pending

## Context

AI coding assistants are increasingly capable of producing code quickly. Speed
alone does not produce professional software: without structure, AI-assisted
development tends toward unreviewed changes, invented dependencies and APIs,
unclear decisions, unverified claims of testing, excessive permissions and
exposure to prompt injection through repository and web content.

At the same time, the model landscape changes constantly. Providers, model
names, capabilities and prices change faster than engineering practices.
Tooling (Cursor, other IDEs, CLI agents) differs in what it can enforce.

We need a governance and orchestration system that:

- makes AI-assisted work systematic, traceable, secure and testable;
- keeps humans accountable for requirements, architecture, security, approvals
  and production;
- survives model, provider and IDE changes;
- is honest about what is enforced by tooling and what is convention.

Constraints for this initial version: Markdown/YAML/MDC only; no application
code, no packages, no external orchestrator.

## Decision

Build AI-DOS as a layered, documentation-first system:

```text
Governance | Roles | Skills | Workflows | Model Registry | Model Routing | Orchestration | Project Integration
```

| Layer | Location | Depends on |
|---|---|---|
| Governance (what must be true) | `governance/` | nothing |
| Roles (who is responsible) | `orchestration/roles/` | governance, capability vocabulary |
| Skills (how a procedure is done) | `skills/` | governance |
| Workflows (sequence of roles and gates) | `orchestration/workflows/` | governance, roles, capabilities |
| Model registry + capabilities | `orchestration/models/` | nothing model-specific in other layers |
| Model routing | `orchestration/routing/`, `orchestration/models/selection-policy.md` | registry, roles, risk |
| Orchestration state/audit (conceptual) | `orchestration/state/`, `orchestration/future-orchestrator.md` | all of the above |
| Project integration | `.cursor/`, `AGENTS.md`, `templates/project-profile.yaml` | links to all layers; nothing depends on it |

Key decisions:

1. **Governance is separate from orchestration.** Governance defines rules
   (risk, approval, security, quality) independent of how work is executed.
   Orchestration (roles, workflows, routing) can change — manually today, an
   orchestrator tomorrow — without changing what must be true. Governance
   never references a model, provider or IDE.
2. **Roles are separate from models.** A role defines responsibility,
   capabilities, inputs, outputs, permissions and quality requirements. A model
   provides capabilities. One model can play many roles; one role can be
   played by many models. This lets models be replaced without touching roles
   or workflows.
3. **Roles are separate from skills.** Roles state responsibility; skills
   describe procedures. Several roles reuse one skill (e.g. security).
4. **Domain roles are specialisations** (`<base-role>[<domain>]`) of ten base
   roles rather than separate role files, keeping permissions in one place.
5. **Routing uses capabilities, not model names.** Workflows request
   capability profiles ("planning ≥ strong, large context"). The registry maps
   models to capabilities with evidence; unverified values are `unknown`, and
   `unknown` never satisfies a requirement. Priorities: capability > security/risk
   > context > tools > quality > reliability > cost > latency.
6. **Cursor is only an integration layer.** `.cursor/rules`, commands and
   skills are thin adapters that summarise and link to governance (single
   source of truth). Another IDE or agent can integrate via `AGENTS.md` and the
   same documents.
7. **Human approval is part of the system, not an exception.** Risk levels
   (`LOW`–`CRITICAL`) determine planning depth, review independence, testing
   and approval gates; protected actions always require explicit human
   approval. AI output is unverified until validated, and gates are never
   marked `passed` without the check being performed.
8. **Honest status labelling.** Every document states whether it is a
   *Governance Definition* (convention), *Actual Automated Orchestration*
   (tool-enforced) or *Conceptual*.

## Architecture

```text
            ┌──────────────────────── Project Integration ────────────────────────┐
            │  Cursor (.cursor/rules, commands, skills) · AGENTS.md · other IDEs   │
            └───────────────┬─────────────────────────────────────┬───────────────┘
                            │ links to                            │ links to
┌───────────── Orchestration ──────────────┐        ┌──────── Governance ────────┐
│ workflows → roles → routing → models     │ reads  │ principles · hierarchy     │
│ state · audit · handoffs (conceptual)    │───────▶│ policies · security        │
│ future orchestrator (conceptual)         │        │ quality · AI · decisions   │
└──────────────────────────────────────────┘        └────────────────────────────┘
                 │ uses                                         ▲
                 ▼                                              │ applied by
            skills/ (procedures)  ·  templates/ (artifacts)  ·  checklists/
```

## Alternatives

| Option | Why not chosen |
|---|---|
| One large `.cursorrules` / always-on rule file | Token-heavy, hard to maintain, Cursor-specific, mixes concerns; `.cursorrules` is legacy |
| Workflows naming concrete models ("use model X for planning") | Breaks on every model change; hides the capability requirement; vendor lock-in |
| Roles = models (e.g. "the planning model") | Conflates responsibility with capability; prevents one model playing several roles |
| Build an orchestrator now | Premature; requirements for automation are not validated; out of scope for v1 |
| Governance inside `.cursor/` only | Not portable to other IDEs/agents; Cursor would become the architecture |
| Workflow governance under `governance/workflows/` and executable workflows under `orchestration/workflows/` | Duplication; workflows reference governance instead (single source) |

## Consequences

Positive:

- Models, providers and IDEs can be replaced by editing the registry and adapters only.
- Clear human control points; traceable artifacts; honest reporting rules.
- Small, focused Cursor rules; most guidance loaded only when relevant.

Negative / costs:

- Most controls are conventions; an agent that ignores rules is not technically
  stopped. Real enforcement must come from user settings, repository tooling
  (branch protection, CI, deploy permissions) and, later, an orchestrator.
- Process overhead for `MEDIUM`+ tasks (artifacts, reviews).
- Model routing is a recommendation; the human must select models manually.
- The registry is empty of verified models until evaluations are done.
- Paths in Cursor rules assume AI-DOS is the repository root; vendored
  integrations must adjust paths (see README).

## Future Evolution

- Evaluate and approve real models; fill registry with evidence.
- Validators for artifacts and state files (schema checks) and CI checks per risk label.
- Hooks to require confirmation for protected commands.
- A thin orchestrator for classification and routing recommendations, then a
  full orchestrator with policy engine and approval service
  ([future-orchestrator.md](../../orchestration/future-orchestrator.md)).
- Each step requires its own ADR.

## Open questions

- OPEN QUESTION: Initialise the git repository and make the first commit (not done by the agent).
- OPEN QUESTION: Should consuming projects commit task state/artifacts (`.ai-dos/tasks/`) or keep them local?
- OPEN QUESTION: Preferred integration method for projects (copy, git submodule, or reference)?
- OPEN QUESTION: Should Cursor skill adapters be auto-invocable (current) or explicit-only (`disable-model-invocation: true`)?
- OPEN QUESTION: Licence for AI-DOS.
