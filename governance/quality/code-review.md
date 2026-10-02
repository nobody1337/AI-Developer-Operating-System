# Code Review Governance

Status: Governance Definition.

## When review is required

Per [risk classification](../policies/risk-classification.md#required-controls-per-level):
optional for `LOW`, required for `MEDIUM` and above.

## Independence

- The reviewer is never the authoring agent session. A review is "independent"
  when it is performed by a separate agent context that did not write the code.
- For `HIGH` and `CRITICAL`: a different model than the author where one is
  available, plus human review. If only one model is available, state this as
  `RISK:` in the Review Report.
- Reviewers do not modify the code under review; they report findings.

## Review dimensions

| Dimension | Key question |
|---|---|
| Correctness | Does it do what the requirement says, including edge cases? |
| Architecture | Does it fit existing structure and accepted ADRs? |
| Security | New attack surface, authn/authz impact, input handling, secrets? |
| Tests | Are the right tests present, meaningful and passing (actually run)? |
| Error Handling | Are failures handled, surfaced and logged correctly? |
| Performance | Any obvious inefficiency or scalability problem? |
| Maintainability | Readable, cohesive, no unnecessary abstraction? |
| Dependencies | New/changed dependencies verified per policy? |
| Breaking Changes | API, data, config or behaviour changes for consumers? |
| Unexpected Changes | Changes outside the plan's scope, unrelated edits, lockfile churn? |

Checklist: [checklists/code-review.md](../../checklists/code-review.md).
Report: [templates/code-review.md](../../templates/code-review.md).

## Finding severity

| Severity | Meaning |
|---|---|
| `blocker` | Must be fixed before merge (incorrect, insecure, data loss, broken build) |
| `major` | Should be fixed before merge; merging requires explicit human acceptance |
| `minor` | Improvement; may be deferred with a note |
| `note` | Observation or question |

## Verdict

`approve` | `request_changes` | `needs_human_decision`. An AI verdict of
`approve` is a recommendation; for `MEDIUM`+ risk the human merges.
