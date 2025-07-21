# Global Agent Guidelines

This guide provides comprehensive instructions for agents working with team members on development projects. It synthesizes best practices, workflows, and critical guidelines to ensure effective and safe code contributions.

## Directory Structure and Purpose

Your projects directory contains various git repositories for reference and development. Each subdirectory is typically an independent git repository used for finding code examples, implementations, and reference material.

**CRITICAL**: Reference repositories are for REFERENCE ONLY. Do not modify git configurations or remotes in these repositories.

## Essential Workflow Rules

### 1. Working Directory Guidelines

- **Read/explore**: Your main projects directory (reference repositories)
- **Modify/experiment**: A dedicated workspace directory for isolated changes

**ALWAYS check if a repository is already cloned locally before attempting to fetch from the web!** Use `ls` or check the directory structure to see if the project you need is already present before cloning it for reference.

### 2. Code Modification Workflow

When working on code changes:

1. **Always work in a dedicated workspace directory**
2. **Use git worktrees** for creating isolated workspaces from existing repos
3. **Only use git clone if the repository doesn't exist locally**
4. **NEVER modify the remotes of existing reference repositories**

#### Git Worktree Workflow (Preferred)

Git worktrees allow multiple working directories from a single repository, perfect for parallel work:

```bash
# First, check if the repo exists in your workspace
cd ~/projects  # or your designated workspace directory
ls -la | grep REPO_NAME

# If repo exists, create a worktree
cd ~/projects/REPO_NAME
git worktree add ../REPO_NAME-FEATURE-PURPOSE -b feature-branch

# If repo doesn't exist, clone it first (check for your fork)
gh repo view YOUR_USERNAME/REPO_NAME --web 2>/dev/null || echo "No fork found"

# Clone from your fork if it exists
git clone git@github.com:YOUR_USERNAME/REPO_NAME.git REPO_NAME
cd REPO_NAME
git remote add upstream git@github.com:ORIGINAL_ORG/REPO_NAME.git

# Or clone from original if no fork
git clone git@github.com:ORIGINAL_ORG/REPO_NAME.git REPO_NAME
```

#### Worktree Management

```bash
# List all worktrees for a repo
git worktree list

# Create a new worktree for a feature
git worktree add ../repo-optimization -b optimize-feature

# Remove a worktree when done
git worktree remove ../repo-optimization

# Clean up worktree references
git worktree prune
```

Use descriptive worktree names that indicate purpose:
- `gitchat-add-message-notification-queue`
- `repo-name-issue-123`
- `project-feature-description`

**Benefits of worktrees**:
- Share the same git history and objects (saves disk space)
- Switch between features instantly without stashing
- Keep multiple experiments running in parallel
- Easier cleanup - just remove the worktree directory

#### Workspace Maintenance

**Clean up build artifacts** when disk space is needed:
```bash
# For Rust projects
cd ~/projects/repo-name
pnpm clean # check package.json for specific clean script
rm -rf dist/ # can delete dist or build output dir directly
```

**When to clean up workspaces**:
- After PR has been merged
- When changes have been abandoned
- Before removing a worktree

```bash
# Clean and remove a worktree
cd ~/projects/repo-name
git worktree remove ../repo-name-issue-123
```

### 3. Git Workflow

When working on code:

1. Create feature branches for your work
2. Commit changes with clear messages
3. Use descriptive branch names: `name/fix-something`, `name/add-feature`, `name/make-biome-happy-123456`

### 4. GitHub CLI (gh) Usage

The `gh` CLI tool is available for exploring GitHub repositories and understanding code context.

#### Allowed Operations

```bash
# Repository exploration
gh repo view owner/repo
gh repo clone owner/repo  # For initial clones

# Issues and PRs
gh issue list --repo owner/repo
gh issue view 123 --repo owner/repo
gh pr list --repo owner/repo
gh pr view 456 --repo owner/repo
gh pr diff 456 --repo owner/repo
gh pr checkout 456  # To examine PR branches locally

# API queries
gh api repos/owner/repo/pulls/123/comments
gh api repos/owner/repo/issues/123/comments

# Search operations
gh search issues "query" --repo owner/repo
gh search prs "query" --repo owner/repo

# Status and authentication
gh auth status
gh status

# Releases and workflows (read-only)
gh release list --repo owner/repo
gh release view v1.0.0 --repo owner/repo
gh workflow list --repo owner/repo
gh run list --workflow=ci.yml --repo owner/repo
```
#### Common Use Cases

1. **Examining PR discussions**:
   ```bash
   gh pr view 123 --comments
   gh api repos/wevm/wagmi/pulls/123/comments | jq '.[].body'
   ```

2. **Finding related issues**:
   ```bash
   gh search issues "performance" --repo wevm/wagmi --state open
   ```

3. **Checking PR changes**:
   ```bash
   gh pr diff 456 --repo owner/repo
   ```

## Task-Specific Guidelines

### Writing Code

1. **Follow existing patterns** - Study how the project structures similar code
2. **Check dependencies first** - Never assume a library is available
3. **Maintain consistency** - Use the project's naming conventions and style
4. **Security first** - Never expose secrets or keys in code

### Commit Message Best Practices

Writing excellent commit messages is crucial - they become the permanent record of why changes were made.

#### Commit Title Format

Use semantic commit format with a clear, specific title:
- `feat:` - New features
- `fix:` - Bug fixes  
- `perf:` - Performance improvements
- `chore:` - Maintenance tasks
- `docs:` - Documentation
- `test:` - Test changes
- `refactor:` - Code restructuring
- `ci:` - CI/CD changes

**Title guidelines**:
- Be specific: `perf: add specialized multiplication for 8 limbs` not `perf: optimize mul`
- Use imperative mood: "add" not "adds" or "added"
- Keep under 50 characters when possible
- Don't end with a period

#### Commit Description (Body)

The commit body is where you provide context and details about a specific commit. **This is different from PR descriptions**. Many commits do not have
descriptions.

**When to add a body**:
- Breaking changes (note the impact)
- Non-obvious changes (explain why, not what)
- When a commit is very complex or cannot be split up, and is not the only distinct change in the branch or PR

**Format**:
```
<title line>
<blank line>
<body>
<blank line>
<footer>
```

#### Examples

**Performance improvement** (body required):
```
perf: add specialized multiplication for 8 limbs

Benchmarks show ~2.7x speedup for 512-bit operations:
- Before: ~41ns
- After: ~15ns

This follows the existing pattern of specialized implementations
for sizes 1-4, extending to size 8 which is commonly used.
```

**Bug fix** (explain the issue):
```
fix: correct carry propagation in uint addition

The carry bit was not properly propagated when the first limb
overflowed but subsequent limbs were at MAX-1. This caused
incorrect results for specific input patterns.

Added test case that reproduces the issue.
```

**Simple feature** (title often sufficient):
```
feat: add From<u128> implementation for Uint<256>
```

**Complex change** (needs explanation):
```
refactor: split trie updates into parallel work queues

Previous implementation processed all trie updates sequentially,
creating a bottleneck during state root calculation. This change:

- Partitions updates by key prefix
- Processes non-conflicting updates in parallel
- Falls back to sequential for conflicts
- Maintains deterministic ordering

Reduces state root time from 120ms to 35ms on 16-core machines.
```

#### What NOT to Do

- Don't write generic descriptions: "Update code", "Fix bug"
- Don't use many bullet points unless listing multiple distinct changes
- Don't make up metrics without measurements
- Don't write essays - be concise but complete

#### Key Principles

1. **The title should make sense in a changelog**
2. **The body should explain to a future developer why this change was necessary**
3. **Include concrete measurements for performance claims**
4. **Reference issues when fixing bugs**: `Fixes #12345`
5. **Let improvements stand on their own merit** - don't invent generic justifications
6. **Match detail to complexity** - Simple changes need simple descriptions

## Critical Reminders

### DO NOT

- Start work if git has uncommitted changes
- Make up performance numbers or generic justifications for changes
- Commit secrets, API keys, or sensitive information
- Break existing functionality without proper testing
- Ignore linting or formatting tools when available

### ALWAYS

- Ask before committing code
- Follow project patterns and conventions
- Read relevant documentation before starting tasks
- Test changes thoroughly before committing
- Use version control best practices
- Consider security implications of changes

## Project-Specific Overrides

This file provides universal guidelines. Projects may have their own AGENTS.md file that overrides or extends these guidelines with project-specific requirements.

This file should be updated when major architectural patterns change across multiple projects.
