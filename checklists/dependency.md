# Dependency Checklist

Policy: [dependency governance](../governance/policies/dependencies.md). For
each item write the source or `UNKNOWN` / `REQUIRES VALIDATION`.

| Check | Result | Source / evidence |
|---|---|---|
| Actually necessary (no-dependency / stdlib / existing dependency considered) | | |
| Exists in the official registry | | |
| Exact package name (no typo / lookalike) | | |
| Maintainer / publisher and repository | | |
| Recency and maintenance activity | | |
| Known vulnerabilities / advisories | | |
| Licence and compatibility | | |
| Transitive dependencies (count, notable) | | |
| Alternatives considered | | |
| Version pinned / constrained per project policy | | |

- [ ] Risk classified at least `MEDIUM`
- [ ] Human approval obtained before installation
