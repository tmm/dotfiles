# Global Agent Guidelines

> **Communication Style**: Be brief, concise. Maximize information density, minimize tokens. Incomplete sentences acceptable when clear.

## Git Worktrees

Use worktrees for isolated workspaces. Check if repo exists locally before cloning.

`git worktree add ../REPO-FEATURE -b branch` | `git worktree list` | `git worktree remove`

## GitHub CLI

- Use `gh` cli to access private repositories.
- Use `gh --help` for command discovery.

## Commit Messages

Use conventional commits (`feat:`, `fix:`, `perf:`, `chore:`, `docs:`, `test:`, `refactor:`, `ci:`).

Be specific: `perf: add specialized multiplication for 8 limbs` not `perf: optimize mul`

## Public GitHub Content Policy

When creating or editing anything publicly visible on GitHub (issues, PRs, code, comments):

### DO NOT
- Include direct quotations from Slack messages
- Mention specific partners or companies by name

### ALWAYS
- Ask for user confirmation before mentioning anything that could pose a security risk to the network (vulnerabilities, exploits, attack vectors - even minor ones)
- Paraphrase internal discussions rather than quoting them
- Use generic descriptions instead of partner names (e.g., "a partner" or "an integration partner")

## Critical Reminders

- Do not start work with uncommitted changes
- Do not make up performance numbers
- Do not use emojis unless asked
- Test changes before committing
