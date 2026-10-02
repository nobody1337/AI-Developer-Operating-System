# Quality Gates

Status: Governance Definition. Gates are evaluated by agents and humans by
convention; no tool enforces them in this version of AI-DOS.

## Gate status

| Status | Meaning |
|---|---|
| `passed` | The required check was **actually performed** and succeeded; evidence exists |
| `failed` | The check was performed and did not succeed |
| `not_run` | The check applies but was not performed (state why) |
| `not_applicable` | The check does not apply to this task (state why) |
| `waived_with_approval` | The check applies, was not performed or failed, and a human waived it via an [Approval Record](../../templates/approval-record.md) |

**A gate must never be marked `passed` if the required check was not actually
performed.** "Should pass", "looks correct" or "would pass" is `not_run`.

## Gates

| Gate | Required checks | Evidence | Required from |
|---|---|---|---|
| `planning` | Task classified; requirements and acceptance criteria clear; plan covers scope, tests, risks, rollback (`CRITICAL`) | Inline plan (`LOW`); Task Specification, Implementation Plan, Risk Assessment (`MEDIUM`+) | All levels; human approval for `HIGH`/`CRITICAL` |
| `architecture` | Fits existing architecture; ADR for decisions listed in [architecture governance](../architecture/architecture-governance.md); alternatives considered | ADR or "no architecture impact" statement | When architecture is affected |
| `implementation` | Code matches plan; build/type-check/lint run; no out-of-scope changes; [implementation checklist](../../checklists/implementation.md) | Implementation Report with commands and results | All levels |
| `testing` | Test analysis done; required tests created/updated and executed | Test Report with commands and real results | All levels (depth per risk) |
| `security` | [Security checklist](../../checklists/security.md); threats considered; secrets check | Security Report | Per risk classification |
| `review` | Independent review per [code review governance](code-review.md) | Review Report | `MEDIUM`+ |
| `release` | [Release checklist](../../checklists/release.md); approvals present; rollback ready | Release notes, Approval Record | Releases |

Gate results are recorded in the reports and, where used, in the task state
record ([state model](../../orchestration/state/state-model.md)).

## Definition of Done

The global completion criteria are in [definition-of-done.md](definition-of-done.md).
