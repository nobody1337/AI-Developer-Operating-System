# /review

Perform an independent code review of the current changes (or the referenced diff/PR). Do not edit the code.

1. Confirm independence: if you authored these changes in this session, say so and recommend a new
   session (and, for HIGH/CRITICAL, a different model). See `governance/quality/code-review.md#independence`.
2. Read the plan and requirement first, then the diff (`git diff`, `git status`).
3. Follow `skills/code-review/SKILL.md` and `checklists/code-review.md`, including `checklists/ai-generated-code.md`.
4. Re-run build/tests where possible; report real results, or why not.
5. Write the result using `templates/code-review.md` with severities and a verdict.
6. Escalate security-relevant findings to `/security-review`.
