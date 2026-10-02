# Review 0002: Self-Review of the Embedded Project Integration

- **Date:** 2026-10-02
- **Reviewer:** the AI agent that authored the change (same session)
- **Scope:** [ADR-001](../decisions/001-embedded-project-integration.md), `integration/`,
  binding decisions 1–7 in the [governance README](../README.md#binding-decisions-2026-10-02)
  and all files changed with them
- **Status:** Completed. Needs independent review and human review.

RISK: This review is **not independent**. The same agent session planned,
wrote and reviewed the change, with the same model and context
([code review governance](../quality/code-review.md#independence)). The change
is `CRITICAL`. Before ADR-001 (and ADR-000) is accepted, an independent review
by a new session, preferably with a different model, plus a human review is
required ([decision 2](../README.md#2-adr-000)).

## Method

What was actually done (read-only checks, nothing installed, no helper files
written to the repository):

- VALIDATION: Relative Markdown links and `#anchors` in all `.md`/`.mdc` files
  were checked with a Node script (piped via stdin) against the file system
  and target headings: 595 links, 0 broken (final run after this file existed).
- VALIDATION: Self-containment: no link in `governance/`, `orchestration/`,
  `skills/`, `templates/`, `checklists/` or `integration/` resolves outside these
  directories (0 escapes), so a managed copy in `.ai-dos/` has no broken links
  to the master root or to `.cursor/`.
- VALIDATION: Backticked AI-DOS-root-relative paths (226) checked for
  existence. 8 do not exist, all intentional: `orchestration/state/runtime/`
  (git-ignored runtime directory, 4× including this file) and
  `governance/workflows/` (documented non-existent deviation, 4× including
  this file).
- VALIDATION: YAML parsed with the `yaml` module bundled with Cursor: 51
  documents parse; 3 fail (`02`, `05`, `06` rule frontmatters, Cursor's unquoted
  glob format, known since review 0001). `08` no longer has globs.
- VALIDATION: Grep: no absolute paths (`X:\`, `/Users/`, `/home/`, `file://`);
  no secret patterns; model names only in `orchestration/models/registry.yaml`;
  old terms (`ai-dos.project.yaml`, `.ai-dos/tasks`, `.ai-dos/runtime`,
  `approved_models`) appear only where the history or deviations are described.
- VALIDATION: All files LF, no BOM. Rule sizes: largest `00-governance.mdc`
  with 41 lines; all below 50.
- VALIDATION: `git status` / `git diff --stat` (read-only): 37 files changed,
  14 files created, nothing else touched.
- Not done: no observation of Cursor runtime behaviour; no real project was
  integrated (initialize and update are conceptual and have no tooling).

## Answers

1. **Is the project-local architecture unambiguous?** Yes, as documented:
   one layout, one integration mode (`embedded`), file classes with an explicit
   modification rule per path ([integration README](../../integration/README.md#file-classification)).
   Residual ambiguity: `.ai-dos/workflows/` sits at the top level while other
   project-owned content is in `.ai-dos/local/`; the README explains why.
2. **Can a project work without the master?** By design yes: managed copies are
   complete and self-contained (0 escaping links), generated Cursor files use
   `.ai-dos/` paths, and the manifest's `source.repository` is informational.
   REQUIRES VALIDATION: not tested with a real project.
3. **Is versioning unambiguous?** Yes: `VERSION` is the single master source;
   manifest separates project AI-DOS version, source AI-DOS version and ref,
   schema version and integration date; change classes and the 0.x rule are
   defined ([versioning](../../integration/versioning.md)).
4. **Are Global/Project/Task cleanly separated?** Yes: defined once in the
   [hierarchy](../principles/governance-hierarchy.md#scopes-global--project--task)
   with ranks; file locations once in the integration README.
5. **Can project overrides bypass security limits?** Not by the rules: the
   project-level override limits, the clarified Security Baseline (approval
   gates by risk level and protected actions), risk overrides that may only
   raise, `allowed_roles` that may not exclude reviewers, and model lists that
   only narrow. Technically nothing enforces this; a project can edit its own
   files. Mitigations: `CRITICAL` classification, review, undeclared-change
   detection in updates, external controls.
6. **Are master and project instance clearly distinguished?** Yes: "Central
   AI-DOS" and "Embedded AI-DOS" are defined in the vocabulary and the
   integration README; the manifest records provenance.
7. **Are the seven decisions implemented and documented?** Yes, in the
   governance README with the required wording for decisions 1 and 7;
   decision 2: ADR-000 stays `Proposed`; decision 5: 11 adapters have
   `disable-model-invocation: true`; decision 6: `08` is agent-requested;
   decision 3: `integration/state-and-artifacts.md` and
   `templates/project-gitignore.template`; no LICENSE file.
8. **Are all terms consistent?** Checked by reading and grep: new identifiers
   (scopes, integration mode, governance profile, file classes, update
   resolutions, approval gates and decisions) are listed in the vocabulary;
   profile uses `data_sensitivity`, role ids, registry ids and risk levels from
   the vocabulary. Known, unchanged: approval gate `plan` vs. quality gate
   `planning` (distinct sets, now both listed); "profile" has three meanings
   (capability profile, project profile, governance profile), disambiguated in
   the vocabulary.
9. **Are all links valid?** Yes: 595 relative links, 0 broken.
10. **Are all YAML files parseable?** All `.yaml` files and all skill/template
    frontmatters: yes (51). Three rule frontmatters use Cursor's glob format
    and are not strict YAML (unchanged, documented).
11. **Are Cursor rules consistent?** Each rule has exactly one activation mode;
    frontmatter uses `description`/`globs`/`alwaysApply`; no `.cursorrules`.
    Rule `00` references the override rule, `11` the profile restrictions.
12. **Any unverified claims about Cursor automation?** None stated as fact.
    REQUIRES VALIDATION in Cursor: that `disable-model-invocation: true` makes
    the adapters explicit-only in the installed version; that `08` is attached
    on request by description; which tools read `AGENTS.md`; that Cursor does
    not load nested rule or `AGENTS.md` files from `templates/` (none exist
    there by design); that agents can find `.ai-dos/` content (dot directory)
    when rules name the paths.
13. **Any new dependencies?** No. Only Markdown, YAML and a plain `VERSION`
    file. Validation used Node and Cursor's bundled `yaml` module, already
    present; nothing was installed.
14. **Any contradictory governance?** None found. Former contradictions were
    resolved: three integration options vs. one standard, inconsistent
    proposed paths, Security Baseline scope of approval gates, skill adapters
    described as auto-discoverable. Minor: ADR-000's consequence about
    adjusting paths in "vendored integrations" is older wording; ADR-001 now
    defines the mechanism. ADR-000's text was left unchanged except open
    questions and acceptance, so the reviewed content stays stable.
15. **Any place where a project would unexpectedly depend on the master?**
    Expected dependencies only: updates need the master, and the three-way
    comparison needs the master at the base tag (without it, every difference
    is a conflict). `integration/versioning.md` and `integration/update.md`
    mention the master files `VERSION` and `CHANGELOG.md` as update inputs,
    not as runtime needs. No link, rule or path in the managed copies needs the
    master.

## Open items for human review

- Independent review of ADR-001 and ADR-000, then a human decision on `Accepted`.
- REQUIRES VALIDATION in Cursor: the items under answer 12.
- A first real project integration (manual, following `integration/initialize.md`)
  would validate the path convention and the integration check.
