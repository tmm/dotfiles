{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false
        edit_mode: "vi"
        shell_integration: {
          osc2: true
          osc7: true
          osc8: true
          osc9_9: false
          osc133: true
          osc633: true
          reset_application_mode: true
        }
      }
    '';
    envFile.text = ''
      # Ghostty shell integration
      if ($env.GHOSTTY_RESOURCES_DIR? | is-not-empty) {
        # Nushell doesn't have native Ghostty integration yet
        # Using OSC sequences via shell_integration config instead
      }

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
    '';
    shellAliases = {
      a = "amp";
      b = "bun";
      d = "docker";
      de = "delta";
      dc = "docker compose";
      g = "git";
      i = "iex";
      lsd = "eza -d .*";
      m = "mix";
      n = "npm";
      o = "opencode";
      p = "pnpm";
      v = "nvim";

      cat = "bat --style=numbers,changes --theme=$(if (defaults read -globalDomain AppleInterfaceStyle | complete).exit_code == 0 { 'tokyonight_night' } else { 'tokyonight_day' })";
      find = "fd";
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
      howto = "gh copilot suggest -t shell";
      ls = "eza";
      reload = "exec $env.SHELL";
      vim = "nvim";
      hide = "defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder";
      show = "defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder";

      drs = "sudo darwin-rebuild switch --flake $env.DOTFILES_HOME/nix";
      dot = "cd $env.DOTFILES_HOME; nvim";

      hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false; killall Finder";
      showdesktop = "defaults write com.apple.finder CreateDesktop -bool true; killall Finder";
    };
  };
}
