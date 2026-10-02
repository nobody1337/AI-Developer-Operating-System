# Skills

Status: Governance Definition (procedures). Skills are **tool-agnostic**
procedures: *how* a kind of work is done well. They are not roles (*who* is
responsible) and they do not grant permissions.

Each skill lives in `skills/<name>/SKILL.md` with: Purpose, When to use,
Inputs, Procedure, Outputs, Quality criteria, Pitfalls, Related. The YAML front
matter (`name`, `description`) follows the common Agent Skills convention so
other tools can load them directly.

| Skill | Typically used by |
|---|---|
| [architecture](architecture/SKILL.md) | `architect`, `planner` |
| [frontend](frontend/SKILL.md) | `frontend-developer`, `code-reviewer[ux]`, `code-reviewer[accessibility]` |
| [backend](backend/SKILL.md) | `backend-developer`, `code-reviewer[api]` |
| [database](database/SKILL.md) | `database-engineer` |
| [devops](devops/SKILL.md) | `devops-engineer`, `release-manager` |
| [testing](testing/SKILL.md) | `tester`, developer roles |
| [security](security/SKILL.md) | `security-reviewer`, developer roles |
| [debugging](debugging/SKILL.md) | developer roles, `tester` |
| [refactoring](refactoring/SKILL.md) | developer roles |
| [documentation](documentation/SKILL.md) | all roles |
| [code-review](code-review/SKILL.md) | `code-reviewer`, `security-reviewer` |

## Cursor integration

`.cursor/skills/aidos-<name>/SKILL.md` are thin adapters that point to these
files; they contain no procedure content of their own. Template for new
skills: [templates/skill.md](../templates/skill.md).
