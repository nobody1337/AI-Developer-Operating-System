# AI Communication Protocol

Status: Governance Definition.

## Labels

| Label | Use for |
|---|---|
| `FACT:` | Something verified in this task (read in a file, observed in output, confirmed by the human) |
| `ASSUMPTION:` | Something believed but not verified; the work depends on it |
| `DECISION:` | A choice that was made, by whom, and why |
| `RECOMMENDATION:` | A proposed choice for the human or the next role |
| `RISK:` | A possible negative consequence, conflict, or security concern |
| `OPEN QUESTION:` | Something that needs a human answer |
| `VALIDATION:` | What was actually executed/checked and its real result — or what was not |

## Example

```text
FACT: The project uses Angular 22.
ASSUMPTION: The existing routing architecture should remain unchanged.
RECOMMENDATION: Reuse the existing service instead of creating another abstraction.
RISK: This change modifies authorization behavior.
OPEN QUESTION: Should administrators be affected by this rule?
VALIDATION: Unit tests and build completed successfully.
```

(The `FACT` line is only a fact if the version was actually read from the
project's manifest in this task.)

## No Hallucination Policy markers

Inline markers for any text, code comment in an artifact, or report:

| Marker | Meaning |
|---|---|
| `UNKNOWN` | The information is not available; no guess is offered |
| `ASSUMPTION` | A guess or inference; must be confirmed before relied upon |
| `REQUIRES VALIDATION` | A claim or result that someone must check (run, read, confirm) |

## When the protocol is required

| Situation | Protocol |
|---|---|
| Risk `MEDIUM` or higher, or complexity `MEDIUM` or higher | Required in plans and final reports |
| Any artifact (plan, ADR, reports, approval requests) | Required |
| Escalations and conflict reports | Required |
| Any statement about validation (tests, builds, checks) | `VALIDATION:` line required |
| `LOW` risk and `LOW` complexity tasks, quick answers | Optional; still no unlabelled guesses and still honest `VALIDATION` |

Keep it proportional: label the statements that matter for decisions, not
every sentence.
