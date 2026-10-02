# Git Governance

Status: Governance Definition.

## Branches

- Work on a feature branch, never directly on the default branch, unless the
  project explicitly allows it.
- Suggested naming: `<type>/<task-id>-<slug>`, e.g.
  `feat/TASK-20261002-dashboard-widget`. Types: `feat`, `fix`, `refactor`,
  `docs`, `test`, `chore`, `release`.

## Commits

- Small, focused commits with a clear message (Conventional Commits style is
  recommended: `feat(scope): summary`).
- Agents commit only when the human asked for it or the workflow defines it.
- Never commit secrets, generated runtime state or unrelated changes.
- Mention the task id in the commit body when one exists.

## Pull requests

- One PR per task where practical. The PR description links the task
  artifacts (plan, reports) and states what was and was not validated.
- AI-authored PRs are labelled as such if the project supports labels.
- Merging is a human decision for `MEDIUM` risk and above
  ([human approval](human-approval.md)).

## Merge, rebase, revert

- Follow the project's merge strategy. Rebase only local, unshared branches.
- Prefer `git revert` over history rewriting to undo shared changes.

## Destructive commands (never automatic)

Require explicit human approval every time:

`git reset --hard`, `git clean -f/-fd/-fdx`, `git push --force` /
`--force-with-lease`, `git branch -D`, `git checkout -- <path>` /
`git restore` on files with uncommitted changes, `git stash drop` /
`git stash clear`, `git rebase` of shared branches, `git filter-branch` /
`git filter-repo`, deleting tags or remote branches.

## Uncommitted changes

Never overwrite, discard or stash the human's uncommitted changes unasked.
Check `git status` before changing files and report pre-existing changes.
