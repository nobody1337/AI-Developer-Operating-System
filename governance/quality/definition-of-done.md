# Global Definition of Done

Status: Governance Definition. Projects may add criteria (rank 5); they may not
remove the honesty requirement.

A task is done when every item is either fulfilled or explicitly reported as
not fulfilled with a reason:

- [ ] Requirement fulfilled (acceptance criteria met)
- [ ] Code implemented according to the plan; no unexplained out-of-scope changes
- [ ] Relevant tests created or updated
- [ ] Tests executed — with real results
- [ ] Build validated (compile / type-check / lint, as applicable)
- [ ] Security considered (and security review done where required)
- [ ] Review completed where required by risk level
- [ ] Documentation updated where required
      ([documentation governance](../policies/documentation.md))
- [ ] Required human approvals recorded
- [ ] No unresolved `blocker` findings or critical issues

## Honest reporting

If something could not be executed (no terminal, missing dependencies, no test
setup, no network, no permission), the report says so explicitly:

```text
VALIDATION: Unit tests not run — no test runner configured in this repository.
REQUIRES VALIDATION: Build not executed; please run `npm run build`.
```

A task with `not_run` items can be handed over, but it is not reported as
"fully validated". Checklist form: [checklists/README.md](../../checklists/README.md).
