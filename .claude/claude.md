# User Preferences

## Commit Messages

- Do NOT include "Co-Authored-By: Claude <noreply@anthropic.com>" in commit messages
- Do NOT include "Generated with [Claude Code]" or similar attribution lines in commit messages
- Do NOT add inline code comments explaining what the code does unless the logic is non-obvious
    - Code should be self-documenting through clear variable and method names
    - Test descriptions should capture the behavior being tested without relying on code comments

## Work Plans

- Write work plans and session documents to `~/.claude/plans/` instead of the project directory
- Plans should not be committed to project repositories
