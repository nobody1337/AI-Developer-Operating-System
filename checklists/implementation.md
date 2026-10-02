# Implementation Checklist

## Before changing code

- [ ] Task and risk classified; plan exists at the level required by risk
- [ ] Relevant files read (no edits to unread files)
- [ ] Working tree checked (`git status`); pre-existing changes noted and untouched
- [ ] Existing components/services/utilities searched for reuse
- [ ] For `HIGH`/`CRITICAL`: plan approved (Approval Record)

## While changing code

- [ ] Changes limited to the plan's scope (Minimal Change)
- [ ] Follows existing conventions and architecture
- [ ] No new abstraction without a present need
- [ ] Errors handled, not swallowed; no sensitive data in logs or messages
- [ ] Input validated at trust boundaries
- [ ] No secrets, credentials or personal data in code, tests or docs
- [ ] No new dependency without approval ([dependency checklist](dependency.md))
- [ ] No protected action without approval

## After changing code

- [ ] Build / type-check / lint executed — real result recorded
- [ ] Tests created/updated and executed — real result recorded
- [ ] `not_run` checks listed with reason
- [ ] Documentation updated where required
- [ ] Implementation Report written (`MEDIUM`+) or short report (`LOW`)
