{ ... }:
let
  colors = import ./colors.nix;
in
{
  # https://ghostty.org/docs/config/reference
  # https://github.com/mitchellh/ghostty/blob/main/src/config/Config.zig

  # TODO: Colors and config for different color schemes
  # https://github.com/mitchellh/ghostty/issues/809
  # TODO: Splits
  # https://github.com/mitchellh/ghostty/issues/601
  xdg.configFile."ghostty/config".text = ''
    copy-on-select = "clipboard"
    font-family = JetBrains Nerd Font Mono
    font-feature = -calt
    font-size = 14
    macos-non-native-fullscreen = true
    macos-option-as-alt = left
    mouse-hide-while-typing = true
    macos-titlebar-style = tabs
    unfocused-split-opacity = 1
    window-height = 50
    window-width = 178
    window-padding-x = 0
    window-padding-y = 0
    window-padding-balance = true

    keybind = global:control+grave_accent=toggle_quick_terminal

    background = ${colors.dark.background}
    foreground = ${colors.dark.foreground}

    cursor-color = ${colors.dark.cursor}

    palette = 0=${colors.dark.black}
    palette = 1=${colors.dark.red}
    palette = 2=${colors.dark.green}
    palette = 3=${colors.dark.yellow}
    palette = 4=${colors.dark.blue}
    palette = 5=${colors.dark.orange}
    palette = 6=${colors.dark.cyan}
    palette = 7=${colors.dark.white}

    keybind = ctrl+shift+h=goto_split:left
    keybind = ctrl+shift+j=goto_split:bottom
    keybind = ctrl+shift+k=goto_split:top
    keybind = ctrl+shift+l=goto_split:right
    keybind = ctrl+shift+enter=toggle_split_zoom
    keybind = ctrl+shift+u=scroll_page_up
    keybind = ctrl+shift+d=scroll_page_down

    cursor-style = block
    cursor-style-blink = false
    shell-integration-features = no-cursor
  '';
}
