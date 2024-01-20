{ pkgs, ... }:
let
  colors = import ./colors.nix;
in
{
  # https://github.com/mitchellh/ghostty/blob/main/src/config/Config.zig
  # TODO: Colors and config for different color schemes
  # https://github.com/mitchellh/ghostty/issues/601
  xdg.configFile."ghostty/config".text = ''
    copy-on-select = "clipboard"
    font-family = JetBrains Nerd Font Mono
    font-feature = -calt
    font-size = 14
    macos-non-native-fullscreen = true
    macos-option-as-alt = left
    mouse-hide-while-typing = true
    unfocused-split-opacity = 1
    window-padding-x = 0
    window-padding-y = 0
    window-padding-balance = true

    background = ${colors.dark.background}
    foreground = ${colors.dark.foreground}

    palette = 0=${colors.dark.black}
    palette = 1=${colors.dark.red}
    palette = 2=${colors.dark.green}
    palette = 3=${colors.dark.yellow}
    palette = 4=${colors.dark.blue}
    palette = 5=${colors.dark.orange}
    palette = 6=${colors.dark.cyan}
    palette = 7=${colors.dark.white}
  '';
}
