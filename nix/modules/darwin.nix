{ pkgs, username, ... }: {
  environment = {
    systemPackages = with pkgs; [
      fish
    ];
    variables = {
      NEXT_TELEMETRY_DISABLED = "1";
      NUXT_TELEMETRY_DISABLED = "1";
    };
  };
  fonts = {
    packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  };
  homebrew = {
    enable = true;
    casks = [
      "1password"
      "1password-cli"
      "betterdisplay"
      "cleanshot"
      "contexts"
      "daisydisk"
      "discord"
      "dropbox"
      "figma"
      "firefox"
      "flux"
      "google-chrome"
      "numi"
      "orbstack"
      "pixelsnap"
      "raycast"
      "remarkable"
      "sublime-text"
      "signal"
      "telegram"
      "thunderbird"
      "vlc"
      "zoom"
    ];
    masApps = {
      BetterSnapTool = 417375580;
      Craft = 1487937127;
      Dato = 1470584107;
      "Day One" = 1055511498;
      "Pure Paste" = 1611378436;
      "reMarkable desktop" = 1276493162;
      Velja = 1607635845;
      Xcode = 497799835;
    };
  };
  ids.gids.nixbld = 30000;
  nix = {
    settings = {
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      trusted-users = [ "root" username ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  programs.fish.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.5;
    dock.mineffect = "scale";
    dock.show-process-indicators = true;
    dock.tilesize = 48;
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
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  system.stateVersion = 6;
  users.users.tmm = {
    home = "/Users/${username}";
    shell = pkgs.fish;
  };
}
