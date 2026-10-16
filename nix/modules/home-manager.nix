{
  config,
  dotfilesDir,
  hostName,
  lib,
  pkgs,
  ...
}:
let
  colors = import ./colors.nix;
  batThemeTemplate = builtins.readFile ../files/templates/bat-theme.tmTheme;
  mkBatTheme =
    { c, name }:
    let
      attrs = {
        inherit name;
      }
      // c;
      keys = builtins.attrNames attrs;
    in
    builtins.replaceStrings (map (k: "@${k}@") keys) (map (k: attrs.${k}) keys) batThemeTemplate;
in
{
  home.packages = with pkgs; [
    babelfish
    bat
    bun
    cachix
    delta
    direnv
    dockutil
    beamPackages.elixir
    beamPackages.erlang
    eza
    fd
    fnm
    fzf
    gh
    git
    htmlq
    htop
    httpie
    jq
    just
    neovim
    nixfmt
    postgresql
    ripgrep
    rustup
    starship
    yt-dlp
    zoxide
  ];
  home.file = {
    ".config/bat/themes/dotfiles_dark.tmTheme".text = mkBatTheme {
      c = colors.dark;
      name = "Dotfiles Dark";
    };
    ".config/bat/themes/dotfiles_light.tmTheme".text = mkBatTheme {
      c = colors.bright;
      name = "Dotfiles Light";
    };
    ".config/git/ignore_global".source = ../files/home/git-ignore-global;
    ".ignore".source = ../files/home/ignore;
    ".local/bin/rex".source =
      config.lib.file.mkOutOfStoreSymlink "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.app/Contents/MacOS/rex";
    ".local/state/skills/.skill-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.DOTFILES_HOME}/nix/agents/.skill-lock.json";
    ".ssh/tom.pub".source = ../files/home/ssh/tom.pub;
  };
  home.shell.enableFishIntegration = true;
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
  home.stateVersion = "23.05";
  home.sessionVariables = {
    DARWIN_HOST = hostName;
    EDITOR = "nvim";
    DOTFILES_HOME = "${config.home.homeDirectory}/${dotfilesDir}";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };
  imports = [
    ./amp.nix
    ./ghostty.nix
    ./git.nix
    ./shell.nix
  ];
  programs.atuin = {
    daemon.enable = true;
    enable = true;
    settings = {
      ai.enabled = true;
      auto_sync = true;
      auto_hide_height = 8;
      daemon.autostart = false;
      inline_height = 8;
      invert = true;
      show_help = false;
      show_numeric_shortcuts = false;
      show_preview = false;
      show_tabs = false;
      style = "compact";
      sync_frequency = "5m";
      search_mode = "daemon-fuzzy";
      theme.name = "dotfiles";
      ui = {
        columns = [
          "time"
          "command"
        ];
        syntax_highlight = true;
      };
    };
    themes.dotfiles = {
      theme = {
        name = "dotfiles";
        parent = "default";
      };
      colors = {
        # Atuin also uses AlertError for the selected history command. It only
        # supports foreground colors, so keep the selection neutral rather than red.
        AlertError = "@ansi_(7)";
        AlertInfo = "@ansi_(2)";
        AlertWarn = "@ansi_(5)";
        Annotation = "@ansi_(8)";
        Guidance = "@ansi_(8)";
        Important = "@ansi_(7)";
        Muted = "@ansi_(8)";
        SyntaxCommand = "@ansi_(4)";
        SyntaxComment = "@ansi_(8)";
        SyntaxFlag = "@ansi_(6)";
        SyntaxOperator = "@ansi_(14)";
        SyntaxString = "@ansi_(3)";
        SyntaxVariable = "@ansi_(14)";
        Title = "@ansi_(6)";
      };
    };
  };
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    config = {
      load_dotenv = true;
    };
  };
  programs.eza.enable = true;
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-poi
    ];
  };
  programs.home-manager.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      IdentityAgent "${config.home.sessionVariables.SSH_AUTH_SOCK}"
    '';
    settings."*" = {
      ForwardAgent = false;
      StrictHostKeyChecking = "accept-new";
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](purple)";
      };
      cmd_duration = {
        format = "[( $duration)]($style)";
        style = "yellow";
      };
      directory = {
        style = "white";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_state = {
        format = lib.concatStrings [
          "\\("
          "[$state( $progress_current/$progress_total)]"
          "($style)"
          "\\) "
        ];
        style = "bright-black";
        merge = "■";
      };
      git_status = {
        format = lib.concatStrings [
          "[("
          "$conflicted"
          "$untracked"
          "$modified"
          "$staged"
          "$stashed"
          "$renamed"
          "$deleted"
          ")](purple)"
          "[( "
          "$ahead_behind"
          ")](cyan)"
        ];
        ahead = "▲";
        behind = "▼";
        conflicted = "";
        deleted = "";
        diverged = "◆";
        modified = "*";
        renamed = "";
        staged = "";
        stashed = "≡";
        untracked = "";
      };
    };
  };
  programs.zoxide.enable = true;
  xdg = {
    enable = true;
    configFile = {
      "rex/init.lua".text = ''
        rex.bind("ctrl+shift+enter", "pane.zoom")
        rex.bind("ctrl+shift+h", "pane.focus", { direction = "left" })
        rex.bind("ctrl+shift+j", "pane.focus", { direction = "down" })
        rex.bind("ctrl+shift+k", "pane.focus", { direction = "up" })
        rex.bind("ctrl+shift+l", "pane.focus", { direction = "right" })
        rex.bind("cmd+backspace", "pane.send_key", { key = "ctrl+u" })
        rex.unbind("cmd+enter")
      '';
      nvim = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.DOTFILES_HOME}/nvim";
        recursive = true;
      };
    };
  };
}
