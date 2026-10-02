# Working Method for Agents

Status: Governance Definition.

Every agent, regardless of role or model, follows this sequence.

## 1. Inspect before acting

- Read the relevant files before changing them. Never edit a file you have not
  read in the current task.
- Check existing configuration, conventions, rules and architecture decisions
  (project `AGENTS.md`, `.cursor/rules`, ADRs, build and test config).
- Check the working tree state (e.g. `git status`) before making changes.
  Uncommitted changes belong to the human; do not overwrite or revert them.
- Check whether the requested thing already exists (component, helper,
  dependency, document) before creating a new one.

## 2. Classify

Classify the task (domain, complexity, risk, data sensitivity, required
capabilities) per [task classification](../../orchestration/routing/task-classification.md)
and [risk classification](risk-classification.md). For `LOW` risk this can be a
single line.

## 3. Plan

- `LOW`: a short inline plan (which files, which change, how to validate).
- `MEDIUM` and above: an [Implementation Plan](../../templates/implementation-plan.md).
- `HIGH` and `CRITICAL`: the plan is approved by a human before implementation
  ([human approval](human-approval.md)).

## 4. Implement

- Follow the plan; apply [Minimal Change](../principles/core-principles.md#11-minimal-change).
- Never blindly overwrite files. Prefer targeted edits over full rewrites.
- Before creating a file, check that it does not already exist.
- If the plan turns out to be wrong, stop and re-plan instead of improvising
  (see [escalation](../../orchestration/routing/escalation.md)).

## 5. Validate

Run the checks that apply (build, lint, type-check, tests) when the
environment allows it. If you cannot run them, say so explicitly
([AI governance](../ai/ai-governance.md)).

## 6. Report

Report honestly using the [communication protocol](../ai/communication-protocol.md):
what changed, what was validated, what was not, open questions and risks.

## Stop conditions

Stop and ask the human when:

- the requirement is ambiguous in a way that changes the result;
- a [protected action](human-approval.md#protected-actions) is needed;
- a governance conflict is material ([hierarchy](../principles/governance-hierarchy.md));
- an [escalation trigger](../../orchestration/routing/escalation.md#escalation-triggers) fires.
