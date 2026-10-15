# Agent Guidelines for Dotfiles Repository

## Build/Test Commands

- `./bootstrap <host>` - Bootstrap a fresh macOS machine (`tmm` or `tmm-work`)
- `sudo darwin-rebuild switch --flake ~/Developer/dotfiles/nix#<host>` - Apply Nix configuration
- `drs <host>` - Rebuild specific host, or use `DARWIN_HOST` if set
- `drb <host>` - Build specific host, or use `DARWIN_HOST` if set

## Linux Orbs

- `.agents/setup` caches the locked Nix inputs and Linux development shell; `.agents/resume` checks that tools are available without reinstalling them.
- New Bash login shells inside this checkout automatically load the complete cached development environment. After changing the development shell or `nix/flake.lock`, rerun `.agents/setup` and start a new login shell.
- Available tools include Neovim, LuaJIT, Fish, nixfmt, StyLua, ShellCheck, shfmt, tree-sitter, and a C compiler. Outside orbs, enter the same environment with `nix develop ./nix` on x86_64 Linux.
- Useful checks: `bash -n .agents/setup && bash -n .agents/resume`, `shellcheck .agents/setup .agents/resume`, `sh -n bootstrap`, `nixfmt --check nix/flake.nix`, and `stylua --check nvim`.
- Do not run `bootstrap` or apply the Darwin configurations in a Linux orb. Full Darwin builds still require macOS or the existing macOS CI workflow.
- Setup does not activate the personal Neovim configuration or download its plugin-managed language servers and parsers. Use `nvim --headless -u NONE` for isolated Lua checks; full editor tests need the Neovim configuration and its plugins installed separately.
- No application services, databases, or personal credentials are needed for repository validation.

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
