{ pkgs, ... }: {
  home.packages = with pkgs; [
    amber
    asciinema
    babelfish
    bat
    cachix
    diff-so-fancy
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
    httpie
    jq
    neovim
    ripgrep
    zoxide
  ];
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./ghostty.nix
    ./git.nix
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
      gh-dash
      gh-poi
    ];
  };
  programs.gh-dash = {
    enable = true;
    settings = {
      issuesSections = [
        {
          title = "Issues";
          filters = "is:open author:@me";
        }
        {
          title = "Assigned";
          filters = "is:open assignee:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
        {
          title = "Wevm";
          filters = "is:open org:wevm";
        }
      ];
      prSections = [
        {
          title = "Pull Requests";
          filters = "is:open author:@me";
        }
        {
          title = "Review Requested";
          filters = "is:open review-requested:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
        {
          title = "Wevm";
          filters = "is:open org:wevm";
        }
      ];
    };
  };
  programs.home-manager.enable = true;

  xdg = {
    enable = true;
    configFile = {
      "fish" = {
        source = ../files/fish;
        recursive = true;
      };
    };
  };
}
