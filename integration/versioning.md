# Versioning, Compatibility and Migration

Status: Governance Definition.

## Versions

| Version | Single source | Meaning |
|---|---|---|
| AI-DOS version (master) | `VERSION` in the Central AI-DOS root | Release of the Central AI-DOS, [Semantic Versioning](https://semver.org/) `MAJOR.MINOR.PATCH` |
| Release tag | Git tag `v<version>`, set by a human | Exact source of a release; enables three-way comparison during updates |
| Project AI-DOS version | `ai_dos.version` in `.ai-dos/manifest.yaml` | Version the embedded instance is pinned to |
| Source AI-DOS version | `ai_dos.source.version` (+ `ref`) in the manifest | Master version actually copied in the last initialize/update |
| Schema version | `schema_version` in each schema and instance file | Integer, major only, per format (manifest, project profile, state schemas) |

History, breaking changes, migrations and deprecations are recorded per
version in the master `CHANGELOG.md`.

| AI-DOS version | Manifest schema | Project profile schema |
|---|---|---|
| 0.1.0 | 1 | 1 |

## Change classes

| Class | Examples | Version bump (≥ 1.0) |
|---|---|---|
| Breaking | Removed or renamed vocabulary identifier, path or managed file; changed meaning of a risk level, gate, state or approval rule; `.ai-dos/` layout change; schema major bump; new required profile/manifest field; loss of always-applied rule coverage | MAJOR |
| Additive | New role, skill, workflow, template, checklist or optional field; stricter rule that needs no project configuration change | MINOR |
| Editorial | Typos, broken links, clarifications without change in meaning | PATCH |

**0.x rule:** while the major version is `0`, breaking changes may appear in a
MINOR release. They must be marked `BREAKING` in `CHANGELOG.md` with migration
steps. From `1.0.0` on, breaking changes require a MAJOR release.

Schema versions change only on a breaking format change; optional additions
keep the schema version.

## Compatibility

- A project declares `compatibility.minimum_ai_dos_version` and optionally
  `maximum_ai_dos_version` in its manifest.
- An update target outside this range, or across a breaking boundary when no
  maximum is declared, needs an explicit human decision before anything changes.
- A release states the schema versions it supports (table above). A project
  whose schema version is no longer supported must migrate first.

## Migration

- Each breaking release documents its migration steps in `CHANGELOG.md`.
- Updates across several breaking releases apply the migrations in order.
- Applied migrations are recorded in the manifest (`migrations`) with a link to
  the update record.

## Deprecation

- Deprecated items are marked in the defining document and in `CHANGELOG.md`
  with "deprecated since `<version>`" and the replacement.
- Removal happens no earlier than the next MAJOR release (in 0.x: no earlier
  than the next MINOR release).

## Upgrade

Projects upgrade only through the [update workflow](update.md). An update never
silently overwrites local project rules.

## Rollback

- **Project:** an update is applied as a separate, reviewable change in the
  project's version control. Rollback is reverting that change; the manifest
  returns to the previous version with it. Without version control, a human
  backup is required before the update, otherwise the update does not start.
- **Master:** a published release is not changed after tagging. Corrections are
  a new PATCH (or MINOR) release.
