{ pkgs, host, ... }:
{
  environment.systemPackages = with pkgs; [
    fish
  ];

  fonts = {
    packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };

  homebrew = {
    enable = true;

    casks = [
      "1password"
      "1password-cli"
      "betterdisplay"
      "figma"
      "firefox"
      "ghostty@tip"
      "google-chrome"
      "orbstack"
      "raycast"
      "slack"
      "sublime-text"
      "thunderbird"
      "zoom"
    ]
    ++ (
      if host.profile == "personal" then
        [
          "alcove"
          "aldente"
          "cleanshot"
          "contexts"
          "daisydisk"
          "discord"
          "dropbox"
          "flux-app"
          "lookaway"
          "numi"
          "obsidian"
          "pixelsnap"
          "remarkable"
          "signal"
          "telegram"
          "vlc"
        ]
      else
        [ ]
    );

    masApps = {
      "1Password for Safari" = 1569813296;
      BetterSnapTool = 417375580;
      Dato = 1470584107;
      Velja = 1607635845;
      Xcode = 497799835;
    }
    // (
      if host.profile == "personal" then
        {
          Craft = 1487937127;
          "Day One" = 1055511498;
          Flighty = 1358823008;
          "Pure Paste" = 1611378436;
          "reMarkable desktop" = 1276493162;
        }
      else
        { }
    );
  };
  nix = {
    settings = {
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      trusted-users = [
        "root"
        host.username
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.hostPlatform = host.system;

  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.5;
    dock.mineffect = "scale";
    dock.persistent-apps = [
      {
        app = "/Applications/Firefox.app";
      }
      {
        app = "/Applications/Ghostty.app";
      }
    ];
    dock.show-process-indicators = true;
    dock.show-recents = false;
    dock.tilesize = 48;
    CustomUserPreferences = {
      "com.apple.finder" = {
        ShowRecentTags = false;
      };
    };
    finder._FXShowPosixPathInTitle = true;
    finder.AppleShowAllExtensions = true;
    finder.AppleShowAllFiles = true;
    finder.FXEnableExtensionChangeWarning = false;
    finder.FXPreferredViewStyle = "Nlsv";
    finder.QuitMenuItem = true;
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1.0;
    NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
    NSGlobalDomain._HIHideMenuBar = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = false;
    NSGlobalDomain.AppleScrollerPagingBehavior = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllFiles = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.primaryUser = host.username;
  system.stateVersion = 6;

  users.users.${host.username} = {
    home = "/Users/${host.username}";
    shell = pkgs.fish;
  };
}
