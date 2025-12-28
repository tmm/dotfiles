# Agent Guidelines for Dotfiles Repository

Agent guidance for this repository.

> **Communication Style**: Be brief, concise. Maximize information density, minimize tokens. Incomplete sentences acceptable when clear. Remove filler words. Prioritize clarity over grammar.

## Build/Test Commands

- `drs` - Apply Nix configuration with darwin-rebuild

## Code Style Guidelines

### Nix Files

- Use 2-space indentation
- Follow attribute set formatting with proper alignment
- Use `with pkgs;` for package lists
- Keep imports at top of file

### Lua Files (Neovim)

- Use 2-space indentation (per stylua.toml)
- 120 character line limit
- Sort requires alphabetically (enabled in stylua.toml)
- Use snake_case for variables and functions
- Use PascalCase for modules/classes
- Return module table at end of files

### Upgrading from LazyVim

Config is inspired by LazyVim but does NOT use LazyVim directly.

**Steps to upgrade:**

1. Clone LazyVim repo (if not already present):
   ```sh
   gh repo clone LazyVim/LazyVim
   ```

2. Check diff between commits to identify changes:
   ```sh
   cd LazyVim
   git log --oneline --since="<last-upgrade-date>"
   git diff <old-commit> <new-commit>
   ```

3. Consolidate changes into dotfiles:
   - Copy code EXACTLY line-by-line from LazyVim source
   - Do NOT modify, simplify, or "improve" during migration
   - Any internal LazyVim utilities or APIs must be replicated in util/ directory

4. Test thoroughly after each change - avoid assumptions about compatibility

## Tool-Specific Configuration

### Starship

- For custom modules (`[custom.*]`), always set `shell = ["sh"]` to avoid parsing entire shell config on each prompt (7.7x perf improvement)
- Example:
  ```toml
  [custom.example]
  command = "echo foo"
  shell = ["sh"]
  ```

## General Conventions

- No trailing whitespace
- Unix line endings (LF)
- UTF-8 encoding
- Prefer explicit over implicit configurations
