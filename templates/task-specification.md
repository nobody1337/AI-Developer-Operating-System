---
artifact: task_specification
task_id: TASK-YYYYMMDD-slug
version: 1
status: draft
author_role: planner
author_agent: <session id or human:name>
author_model: UNKNOWN
risk: <LOW|MEDIUM|HIGH|CRITICAL>
created: YYYY-MM-DD
inputs: [request]
handoff_to: <role id or human>
---

# Task Specification: <title>

## 1. Request

<Original request, quoted or linked.>

## 2. Goal

<What outcome is wanted and for whom.>

## 3. Acceptance criteria

- [ ] <testable criterion>

## 4. Scope

- In scope: <…>
- Out of scope: <…>

## 5. Classification

```yaml
domain: <frontend|backend|fullstack|database|devops|security|testing|documentation|architecture|release|other>
complexity: <LOW|MEDIUM|HIGH>
risk: <LOW|MEDIUM|HIGH|CRITICAL>
data_sensitivity: <public|internal|confidential|restricted>
required_capabilities: { <capability>: <level> }
context_requirements: <…>
tool_requirements: [<filesystem|terminal|browser|git|network>]
cost_constraints: <none|low_cost_preferred|budget_limit>
latency_requirements: <none|interactive|batch>
workflow: <workflow id>
preferred_role: <role id>
```

## 6. Constraints

<Technical, legal, compatibility, performance constraints.>

## 7. Facts, assumptions, open questions

- FACT: <…>
- ASSUMPTION: <…>
- OPEN QUESTION: <…>
