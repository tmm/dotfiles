# Agent Guidelines for Dotfiles Repository

Be extremely concise. Sacrifice grammar for the sake of concision.

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
