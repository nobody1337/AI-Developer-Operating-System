# Risk Classification

Status: Governance Definition. This is the single source of truth for risk
levels; other documents reference it.

## Rules

1. **Highest applicable risk wins.** A task touching docs and authentication is `HIGH`.
2. **When unsure, classify higher.**
3. Risk may be **raised** at any time by any agent. Lowering a `HIGH` or
   `CRITICAL` classification requires a stated justification and human
   acknowledgement.
4. Risk is independent of complexity: a one-line change to an authorization
   check is `HIGH` risk and `LOW` complexity.
5. Data sensitivity (see [secrets and data](../security/secrets-and-data.md))
   is classified separately; `restricted` data raises the risk to at least `HIGH`.

## Levels

| Level | Typical changes |
|---|---|
| `LOW` | Documentation, formatting, small UI changes, local refactoring without behaviour change |
| `MEDIUM` | New feature, API changes, data model changes, new dependency, changes to build/test configuration |
| `HIGH` | Authentication, authorization, database migrations, infrastructure, security controls, major architecture changes, handling of `restricted` data |
| `CRITICAL` | Production infrastructure, destructive operations, secrets, cryptography, financial transactions, irreversible data operations, security boundary changes, changes to governance or rules themselves |

## Required controls per level

| Control | `LOW` | `MEDIUM` | `HIGH` | `CRITICAL` |
|---|---|---|---|---|
| Planning | Short inline plan | Implementation Plan | Implementation Plan + Risk Assessment; ADR if architecture is affected | Implementation Plan + Risk Assessment + rollback plan |
| Plan approval | Not required | Not required | **Human approval required** | **Human approval required** |
| Testing | Existing tests and build pass (where applicable) | New/updated unit tests; integration tests where interfaces change | Unit, integration and regression tests; security tests where applicable | As `HIGH`, plus dry run / staging verification and tested rollback where possible |
| Independent review | Optional | Required before merge (separate agent context or human) | Required: different agent **and** different model where available, plus human review | Required: independent AI review + human review |
| Security review | If security-relevant aspects appear | If security-relevant aspects appear | Required for authn, authz, security controls, infrastructure, `restricted` data; otherwise if relevant | Required |
| Human approval before merge/completion | Per project merge rules | **Required** (review passed, human merges) | **Required** | **Required** |
| Human approval before execution | Not required | Not required | Required for protected actions | **Explicit approval before any execution** of the change |
| Allowed AI autonomy | Implement and validate within scope | Implement and validate; no merge | Implement only after plan approval; no protected actions | Prepare only (plan, scripts, dry runs); execution only after explicit approval |

Approval mechanics and the Approval Record format: [human approval](human-approval.md).
Gate definitions: [quality gates](../quality/quality-gates.md).

## Examples

| Task | Risk | Reason |
|---|---|---|
| Fix typo in README | `LOW` | Documentation |
| Implement Angular dashboard component | `LOW` | Small, isolated UI change (raise to `MEDIUM` if it adds a new route, API call or dependency) |
| Add a REST endpoint | `MEDIUM` | API change |
| Add npm package | `MEDIUM` (minimum) | New dependency |
| Change role-based access check | `HIGH` | Authorization |
| Write DB migration that drops a column | `CRITICAL` | Irreversible data operation |
| Rotate API keys | `CRITICAL` | Secrets |
| Edit `.cursor/rules` or `governance/` | `CRITICAL` | Changes to governance itself |
