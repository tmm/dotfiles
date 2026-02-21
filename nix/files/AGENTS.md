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

## Critical Reminders

- Do not start work with uncommitted changes
- Do not make up performance numbers
- Do not use emojis unless asked
- Test changes before committing
