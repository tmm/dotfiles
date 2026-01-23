{
  config,
  dotfilesDir,
  lib,
  pkgs,
  ...
}:
let
  colors = import ./colors.nix;
  batThemeTemplate = builtins.readFile ../files/bat-theme.tmTheme;
  mkBatTheme =
    { c, name }:
    builtins.replaceStrings
      [
        "@name@"
        "@background@"
        "@foreground@"
        "@cursor@"
        "@black@"
        "@cyan@"
        "@green@"
        "@orange@"
        "@magenta@"
        "@blue@"
        "@yellow@"
        "@red@"
      ]
      [
        name
        c.background
        c.foreground
        c.cursor
        c.black
        c.cyan
        c.green
        c.orange
        c.magenta
        c.blue
        c.yellow
        c.red
      ]
      batThemeTemplate;
in
{
  home.packages = with pkgs; [
    babelfish
    bat
    cachix
    delta
    direnv
    dockutil
    elixir
    erlang
    eza
    fd
    fnm
    fzf
    gh
    git
    httpie
    jq
    just
    neovim
    nixfmt
    ripgrep
    rustup
    starship
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
    ".ignore".source = ../files/ignore;
    ".ssh/tom.pub".source = ../files/tom.pub;
  };
  home.shell.enableFishIntegration = true;
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    DOTFILES_HOME = "${config.home.homeDirectory}/${dotfilesDir}";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };
  imports = [
    ./git.nix
    ./opencode.nix
    ./shell.nix
  ];
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
  programs.ghostty = {
    enable = true;
    package = null; # TODO: Add install
    settings = {
      copy-on-select = "clipboard";
      cursor-style = "block";
      cursor-style-blink = false;
      font-family = "JetBrains Nerd Font Mono";
      font-feature = "-calt";
      font-size = 14;
      keybind = [
        "global:control+grave_accent=toggle_quick_terminal"
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:bottom"
        "ctrl+shift+k=goto_split:top"
        "ctrl+shift+l=goto_split:right"
        "ctrl+shift+enter=toggle_split_zoom"
        "ctrl+shift+u=scroll_page_up"
        "ctrl+shift+d=scroll_page_down"
        "super+enter=unbind"
      ];
      macos-non-native-fullscreen = true;
      macos-option-as-alt = "left";
      macos-titlebar-style = "tabs";
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor";
      theme = "dark:_dark,light:_light";
      unfocused-split-opacity = 1;
      window-height = 50;
      window-padding-balance = true;
      window-padding-x = 0;
      window-padding-y = 0;
      window-width = 178;
    };
    themes = {
      # TODO: Add light theme
      # https://github.com/mitchellh/ghostty/issues/809
      _dark = {
        background = colors.dark.background;
        cursor-color = colors.dark.cursor;
        foreground = colors.dark.foreground;
        palette = [
          "0=${colors.dark.black}"
          "1=${colors.dark.red}"
          "2=${colors.dark.green}"
          "3=${colors.dark.yellow}"
          "4=${colors.dark.blue}"
          "5=${colors.dark.orange}"
          "6=${colors.dark.cyan}"
          "7=${colors.dark.white}"
        ];
      };
      _light = {
        background = colors.bright.background;
        cursor-color = colors.bright.cursor;
        foreground = colors.bright.foreground;
        palette = [
          "0=${colors.bright.black}"
          "1=${colors.bright.red}"
          "2=${colors.bright.green}"
          "3=${colors.bright.yellow}"
          "4=${colors.bright.blue}"
          "5=${colors.bright.orange}"
          "6=${colors.bright.cyan}"
          "7=${colors.bright.white}"
          "8=${colors.bright.black}"
          "9=${colors.bright.black}"
          "10=${colors.bright.black}"
          "11=${colors.bright.black}"
          "12=${colors.bright.black}"
          "13=${colors.bright.black}"
          "14=${colors.bright.black}"
          "15=${colors.bright.black}"
        ];
      };
    };
  };
  programs.home-manager.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      IdentityAgent "${config.home.sessionVariables.SSH_AUTH_SOCK}"
    '';
    matchBlocks."*" = {
      forwardAgent = true;
      extraOptions = {
        StrictHostKeyChecking = "no";
      };
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
          ")](218)"
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
      nvim = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.DOTFILES_HOME}/nvim";
        recursive = true;
      };
      "amp/settings.json".text = builtins.toJSON {
        "amp.experimental.walkthroughs" = true;
        "amp.git.commit.coauthor.enabled" = false;
        "amp.mcpServers" = {
          cloudflare = {
            url = "https://docs.mcp.cloudflare.com/mcp";
          };
          tempo = {
            url = "https://docs.tempo.xyz/api/mcp";
          };
        };
      };
    };
  };
}
