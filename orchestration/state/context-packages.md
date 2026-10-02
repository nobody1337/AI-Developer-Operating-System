# Context Packages

Status: **Conceptual** format. Today a context package is assembled manually
(e.g. by listing files in the Implementation Plan or by attaching them in the
IDE). Policy: [context management](../../governance/ai/context-management.md).

## Purpose

A context package is the minimum, explicitly chosen context an agent needs for
one step. It replaces "give the agent the whole repository / the whole chat".

```text
Task
 ├─ Requirements       (acceptance criteria, task specification)
 ├─ Relevant files     (to change; to read)
 ├─ Architecture       (relevant ADRs, boundaries, contracts)
 ├─ Relevant rules     (governance docs, project rules in force)
 ├─ Tests              (existing tests, commands to run)
 ├─ Constraints        (scope limits, forbidden areas, performance, compatibility)
 └─ Sensitivity        (data sensitivity level; excluded files)
```

## Rules

- Each entry says *why* it is included.
- Files are marked `change` or `read`; anything not listed is out of scope.
- Secret and `restricted` files are listed under `excluded`, never as content.
- The package's sensitivity is the highest sensitivity of its contents and
  constrains model selection.
- Trust levels are preserved: content from `untrusted` sources is marked.

Schema and example: [context-package.schema.yaml](context-package.schema.yaml).
