# Release Checklist

## Content
- [ ] All included changes listed
- [ ] Each change has the reviews and approvals required by its risk level
- [ ] Breaking changes identified; version bump matches the version policy
- [ ] Changelog / release notes written and accurate

## Verification (real results)
- [ ] Clean build from the release commit
- [ ] Full test suite executed
- [ ] Packaging / deployment dry run executed
- [ ] Migrations tested (forward and rollback) where included

## Safety
- [ ] Rollback plan documented and, where possible, tested
- [ ] Secrets and configuration for the target environment present (verified by name, not by value)
- [ ] Monitoring/alerts in place for the changed areas

## Approval and execution
- [ ] Human Approval Record for gate `release`
- [ ] Deployment / publish / tag executed only after approval
- [ ] Post-release smoke test executed; result reported
