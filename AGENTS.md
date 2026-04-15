# Agent Guidelines for Dotfiles Repository

## Build/Test Commands

- `./bootstrap <host>` - Bootstrap a fresh macOS machine (`tmm` or `tmm-work`)
- `sudo darwin-rebuild switch --flake ~/Developer/dotfiles/nix#<host>` - Apply Nix configuration
- `drs [host]` - Rebuild current host, or a specific host when passed explicitly
- `drb [host]` - Build current host, or a specific host when passed explicitly

## Code Style Guidelines

### Nix Files

- Use 2-space indentation
- Follow attribute set formatting with proper alignment
- Use `with pkgs;` for package lists
- Keep imports at top of file

### Lua Files (Neovim)

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
   - Any internal LazyVim utilities or APIs must be replicated in `nvim/lua/util/`

4. Test thoroughly after each change - avoid assumptions about compatibility

5. Clean up cloned LazyVim/LazyVim

## Tool-Specific Configuration

## Nix Layout

- Shared Darwin behavior belongs in `nix/modules/darwin.nix`
- Shared home-manager behavior belongs in `nix/modules/home-manager.nix`
- Host-specific overrides belong in `nix/hosts/<host>.nix`
- Prefer host/profile data in `nix/flake.nix` over adding extra module layers

### Starship

- For custom modules (`[custom.*]`), always set `shell = ["sh"]` to avoid parsing entire shell config on each prompt (7.7x perf improvement)
- Example:
  ```toml
  [custom.example]
  command = "echo foo"
  shell = ["sh"]
  ```
