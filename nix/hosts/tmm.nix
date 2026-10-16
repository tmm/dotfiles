{ ... }:
{
  ids.gids.nixbld = 30000;

  # Keep idle sessions running without changing screen locking.
  system.defaults.CustomSystemPreferences."/Library/Preferences/.GlobalPreferences" = {
    "com.apple.autologout.AutoLogOutDelay" = 0;
  };
}
