{ pkgs, ... }: {
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
    fontDir.enable = true;
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
  };
  homebrew = {
    enable = true;
    brews = [
      "gnu-sed"
    ];
    casks = [
      "1password"
      "1password-cli"
      "betterdisplay"
      "brave-browser"
      "cleanshot"
      "contexts"
      "daisydisk"
      "dropbox"
      "expressvpn"
      "firefox"
      "flux"
      "google-chrome"
      "numi"
      "pixelsnap"
      "raycast"
      "remarkable"
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
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  programs.fish.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
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
  users.users.tmm = {
    home = "/Users/tmm";
    shell = pkgs.fish;
  };
}
