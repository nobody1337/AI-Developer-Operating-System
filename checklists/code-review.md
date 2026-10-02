# Code Review Checklist

Independence: reviewer did not author the change in this session (`HIGH`/`CRITICAL`: different model where available).

## Correctness
- [ ] Meets acceptance criteria; edge cases handled
- [ ] Logic verified against the requirement, not only against the tests

## Architecture
- [ ] Fits existing structure and accepted ADRs; no unapproved new patterns/layers

## Security
- [ ] [Security checklist](security.md) items relevant to the diff checked

## Tests
- [ ] Right tests exist at the right level; meaningful assertions
- [ ] Tests were actually executed (evidence), results match the report
- [ ] No weakened/skipped/deleted tests without approval

## Error Handling
- [ ] Failures handled, surfaced and logged appropriately; nothing swallowed

## Performance
- [ ] No obvious inefficiency (N+1, unbounded loops/queries, heavy re-renders)

## Maintainability
- [ ] Readable, cohesive, consistent naming; no unnecessary abstraction

## Dependencies
- [ ] New/changed dependencies verified and approved; lockfile changes expected

## Breaking Changes
- [ ] API, data, config and behaviour changes for consumers identified and approved

## Unexpected Changes
- [ ] Every changed file is explained by the plan; no unrelated edits or reformatting

## AI-generated code
- [ ] [AI-generated code checklist](ai-generated-code.md) applied
