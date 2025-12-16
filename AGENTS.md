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

### General Conventions

- No trailing whitespace
- Unix line endings (LF)
- UTF-8 encoding
- Prefer explicit over implicit configurations
