{ pkgs, ... }: {
  environment = {
    systemPackages = [
      pkgs.fish
    ];
    variables = {
      NEXT_TELEMETRY_DISABLED = "1";
    };
  };
  fonts.fontDir.enable = true;
  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
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
    finder._FXShowPosixPathInTitle= true;
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
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  users.users.tmm = {
    home = "/Users/tmm";
    shell = pkgs.fish;
  };
}
