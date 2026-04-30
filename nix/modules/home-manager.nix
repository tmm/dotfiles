{
  config,
  dotfilesDir,
  host,
  hostName,
  lib,
  pkgs,
  ...
}:
let
  colors = import ./colors.nix;
  lightpanda = pkgs.callPackage ../pkgs/lightpanda.nix { };
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
  home.packages =
    with pkgs;
    [
      agent-browser
      amp-cli
      lightpanda
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
      flyctl
      fnm
      fzf
      gh
      git
      htmlq
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
    ]
    ++ lib.optionals (host.profile == "personal") [
      pscale
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
    ".ssh/tom.pub".source = ../files/home/ssh/tom.pub;
    "Documents/Obsidian Vault/.obsidian" = lib.mkIf (host.profile == "personal") {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.DOTFILES_HOME}/obsidian";
      recursive = true;
    };
  };
  home.shell.enableFishIntegration = true;
  home.stateVersion = "23.05";
  home.sessionVariables = {
    AGENT_BROWSER_ENGINE = "lightpanda";
    AGENT_BROWSER_EXECUTABLE_PATH = "${lightpanda}/bin/lightpanda";
    DARWIN_HOST = hostName;
    EDITOR = "nvim";
    DOTFILES_HOME = "${config.home.homeDirectory}/${dotfilesDir}";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };
  imports = [
    ./amp.nix
    ./ghostty.nix
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
  programs.home-manager.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      IdentityAgent "${config.home.sessionVariables.SSH_AUTH_SOCK}"
    '';
    matchBlocks."*" = {
      forwardAgent = false;
      extraOptions = {
        StrictHostKeyChecking = "accept-new";
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
      nvim = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.DOTFILES_HOME}/nvim";
        recursive = true;
      };
    };
  };
}
