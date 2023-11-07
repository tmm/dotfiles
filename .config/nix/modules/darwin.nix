{ pkgs, ... }: {
  environment = {
    systemPackages = [
      pkgs.fish
    ];
    variables = {
      NEXT_TELEMETRY_DISABLED = "1";
    };
  };
  fonts = {
    fontDir.enable = true;
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
  };
  homebrew = {
    enable = true;
    masApps = {
      BetterSnapTool = 417375580;
      Craft = 1487937127;
      Dato = 1470584107;
      "Day One" = 1055511498;
      "Pure Paste" = 1611378436;
      Velja = 1607635845;
      Xcode = 497799835;
    };
    casks = [
      "1password"
      "1password-cli"
      "betterdisplay"
      "cleanshot"
      "contexts"
      "daisydisk"
      "dropbox"
      "firefox"
      "flux"
      "google-chrome"
      "numi"
      "pixelsnap"
      "raycast"
      "remarkable"
    ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  programs.fish.enable = true;
  services.nix-daemon.enable = true;
  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.autohide-time-modifier = 0.5;
    dock.mineffect = "scale";
    dock.show-process-indicators = true;
    dock.tilesize = 48;
    finder._FXShowPosixPathInTitle = true;
    finder.AppleShowAllExtensions = true;
    finder.FXEnableExtensionChangeWarning = false;
    finder.FXPreferredViewStyle = "Nlsv";
    finder.ShowPathbar = true;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1.0;
    NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
    NSGlobalDomain._HIHideMenuBar = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleScrollerPagingBehavior = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  users.users.tmm = {
    home = "/Users/tmm";
    shell = pkgs.fish;
  };
}
