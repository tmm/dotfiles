{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    configFile.source = ../files/nushell/config.nu;
    envFile.source = ../files/nushell/env.nu;
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
