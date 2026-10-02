# /security-review

Perform a security review of the current changes or plan in the `security-reviewer` role. Do not edit code.

1. Read `orchestration/roles/security-reviewer.md` and `governance/security/security-policy.md`.
2. Follow `skills/security/SKILL.md` and `checklists/security.md`, including AI-specific threats
   (`governance/security/ai-security.md`) and dependencies (`governance/policies/dependencies.md`).
3. Never reproduce secret values; reference locations only.
4. Report only checks you actually performed; list what was not checked.
5. Write the result using `templates/security-report.md`, stating residual risk for the human decision.
6. Remember: an AI security review is an aid, not a guarantee. HIGH/CRITICAL also need human review.
