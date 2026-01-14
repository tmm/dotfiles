# Ghostty shell integration
# Nushell uses OSC sequences via shell_integration config
# No explicit sourcing needed

# cargo
$env.PATH = ($env.PATH | prepend $"($env.HOME)/.cargo/bin")

# pnpm
$env.PNPM_HOME = $"($env.HOME)/.local/share/pnpm"
$env.PATH = ($env.PATH | prepend $env.PNPM_HOME)

# foundry
$env.FOUNDRY_DIR = $"($env.HOME)/.foundry"
$env.FOUNDRY_DISABLE_NIGHTLY_WARNING = "true"
$env.PATH = ($env.PATH | prepend $"($env.FOUNDRY_DIR)/bin")

# pg_config
$env.PATH = ($env.PATH | prepend "/Applications/Postgres.app/Contents/Versions/latest/bin")

# fnm (Fast Node Manager)
if (which fnm | is-not-empty) {
  ^fnm env --json | from json | load-env
  $env.PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")
}
