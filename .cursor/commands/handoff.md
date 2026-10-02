# /handoff

Prepare a handoff so another agent session (possibly with another model) can continue without chat history.

1. Read `orchestration/state/handoffs.md` and `orchestration/state/context-packages.md`.
2. Make sure the current step's output artifact exists and is complete (correct template from `templates/`,
   common artifact header filled, `handoff_to` set).
3. Write a context package (schema: `orchestration/state/context-package.schema.yaml`): requirements,
   files (change/read with reasons), architecture, rules, tests and commands, constraints, sensitivity, excluded files.
4. State the recommended role and capability profile for the next step (`orchestration/routing/routing-policy.md`).
5. List open questions and unverified items explicitly.
6. Tell the human how to start the next session (which artifacts to attach, which command to run).
