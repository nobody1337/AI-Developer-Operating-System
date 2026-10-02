---
name: devops
description: Procedure for changing CI/CD pipelines, build configuration, containers and infrastructure as code with dry runs and rollback. Use for pipeline, deployment, IaC and environment configuration work.
---

# Skill: DevOps

## Purpose

Keep builds and deployments reproducible, secure and reversible.

## When to use

CI/CD definitions, build tooling, Dockerfiles, IaC, environment configuration,
observability configuration.

## Inputs

- Plan, current pipeline/IaC, environment overview

## Procedure

1. **Read current setup** — pipeline stages, triggers, permissions, secrets
   usage (by name only), environments.
2. **Change minimally** — one concern per change.
3. **Pin versions** — tools, base images, third-party actions (by digest/SHA where supported).
4. **Least privilege** — pipeline tokens, service accounts, IAM roles.
5. **Secrets** — reference via secret store; never inline; never echo.
6. **Validate** — lint/validate configuration; run `plan` / dry run; capture real output.
7. **Rollback** — document how to revert; prefer reversible changes.
8. **Hand over** — apply/deploy only with explicit approval (protected action).

## Outputs

- Pipeline/IaC changes, dry-run output, rollback steps, Implementation Report

## Quality criteria

- Reproducible (pinned, declarative).
- No new broad permissions without justification.
- Dry run executed, or `not_run` with reason.

## Pitfalls

- Unpinned third-party actions or `latest` images (supply-chain risk).
- Disabling checks to make a pipeline pass (protected action).
- Printing secrets in logs via debug flags.
- Applying to shared environments "just to test".

## Related

Role [devops-engineer](../../orchestration/roles/devops-engineer.md) ·
workflow [release](../../orchestration/workflows/release.md)
