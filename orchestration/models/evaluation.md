# Model Evaluation

Status: Governance Definition. Evaluations are performed manually (by a human,
or by agents under human supervision). There is no automated benchmark harness
in this version.

## Principles

- **No score is objective truth.** Scores reflect a specific task set, prompt,
  integration (IDE, tools), date and evaluator.
- Every value written to the registry cites evidence (report path or link).
  Without evidence it stays `unknown`.
- Evaluate in the integration you will actually use (e.g. Cursor agent mode
  with tools), because tool support changes results.
- Re-evaluate on new versions and periodically.
- Never copy vendor marketing claims or third-party benchmarks into the
  registry as facts; at most cite them as `untrusted` context in the report.

## Criteria

| Criterion | Registry field | How to assess (examples) |
|---|---|---|
| Reasoning | `capabilities.reasoning` | Root-cause analysis of a seeded bug; trade-off question with known answer |
| Planning | `capabilities.planning` | Produce an Implementation Plan for a reference feature; judge completeness and risk handling |
| Coding | `capabilities.coding` | Implement reference tasks; measure correctness against hidden tests |
| Frontend | `capabilities.frontend` | Component task in the project's framework |
| Backend | `capabilities.backend` | Endpoint with validation, error handling, persistence |
| Testing | `capabilities.testing` | Write tests for given code; check for tautological tests, mutation resistance |
| Security | `capabilities.security` | Find seeded vulnerabilities; check secure-by-default output |
| Review | `capabilities.review` | Review a diff with seeded defects; count true/false positives |
| Instruction Following | `capabilities.instruction_following` | Adherence to scope limits, output formats, governance rules |
| Reliability | `performance.reliability` | Variance across repeated runs of the same task |
| Hallucination Rate | `evaluation.hallucination_rate` | Invented APIs, packages, files or claims of unperformed actions |
| Context Handling | `capabilities.context_handling` | Tasks requiring facts spread across many files |
| Tool Use | `capabilities.tool_use` | Correct use and interpretation of terminal, file edits, search |
| Speed | `performance.speed` | Observed wall-clock time for reference tasks in the real integration |
| Cost | `economics.cost_class` | Observed or contractually documented cost class; never estimated without source |

Ratings use the levels in [capabilities.yaml](capabilities.yaml).

## Procedure

1. Define the task set (reuse a project-specific reference set where possible;
   include at least one injection-resistance and one "unperformed action" honesty check).
2. Fix the conditions: model version, integration, tools, settings, date.
3. Run each task; keep raw outputs.
4. Score each criterion with justification; mark untested criteria `unknown`.
5. Record limitations and failure modes observed.
6. Write the report with [templates/model-evaluation.md](../../templates/model-evaluation.md).
7. Propose registry updates; a human reviews and decides the status change.
