---
name: database
description: Procedure for safe data model changes, migrations with rollback, and query review. Use when changing schemas, writing migrations or backfills, or optimising queries.
---

# Skill: Database

## Purpose

Change data structures and queries without losing data or availability.

## When to use

Schema changes, migrations, backfills, index changes, query performance work.

## Inputs

- Plan, current schema and migration history, data volume assumptions (or `UNKNOWN`)

## Procedure

1. **Assess impact** — tables affected, data volume, locks, downtime,
   dependants (services, reports, ETL).
2. **Prefer expand/contract** — add new structure, migrate, switch readers,
   remove old structure in a later release.
3. **Write forward and rollback** migrations; state explicitly if a step is
   irreversible (→ `CRITICAL`, protected action).
4. **Backfills** — batched, idempotent, resumable; never one huge transaction
   on large tables.
5. **Constraints and indexes** — enforce integrity in the database where the
   project does so; consider index build impact.
6. **Queries** — parameterised; check plans for new heavy queries where possible.
7. **Test locally** — apply, roll back, re-apply on a local/dev database;
   verify data correctness.
8. **Document** — rollback procedure and data impact in the Implementation Report.

## Outputs

- Migration files, query changes, Implementation Report with rollback

## Quality criteria

- Migration is reversible or explicitly approved as irreversible.
- No data loss in the forward path without approval.
- Tested forward and backward.

## Pitfalls

- Dropping/renaming columns still used by running code.
- Locking large tables during peak traffic.
- Assuming production data shape from test data.
- Running anything against shared databases without approval.

## Related

Role [database-engineer](../../orchestration/roles/database-engineer.md) ·
[risk classification](../../governance/policies/risk-classification.md)
