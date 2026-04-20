{ ... }:
let
  colors = import ./colors.nix;
in
{
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      copy-on-select = "clipboard";
      cursor-style = "block";
      cursor-style-blink = false;
      font-family = "JetBrains Nerd Font Mono";
      font-feature = "-calt";
      font-size = 14;
      keybind = [
        "global:control+grave_accent=toggle_quick_terminal"
        "ctrl+shift+enter=toggle_split_zoom"
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:bottom"
        "ctrl+shift+k=goto_split:top"
        "ctrl+shift+l=goto_split:right"
        "ctrl+shift+u=scroll_page_up"
        "ctrl+shift+d=scroll_page_down"
        "super+enter=unbind"
        "super+backspace=text:\\x15"
      ];
      macos-non-native-fullscreen = true;
      macos-option-as-alt = "left";
      macos-titlebar-style = "tabs";
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor";
      theme = "dark:_dark,light:_light";
      unfocused-split-opacity = 1;
      window-height = 50;
      window-padding-balance = true;
      window-padding-x = 0;
      window-padding-y = 0;
      auto-update-channel = "tip";
      window-width = 178;
    };
    themes = {
      # TODO: Add light theme
      # https://github.com/mitchellh/ghostty/issues/809
      _dark = {
        background = colors.dark.background;
        cursor-color = colors.dark.cursor;
        foreground = colors.dark.foreground;
        palette = [
          "0=${colors.dark.black}"
          "1=${colors.dark.red}"
          "2=${colors.dark.green}"
          "3=${colors.dark.yellow}"
          "4=${colors.dark.blue}"
          "5=${colors.dark.orange}"
          "6=${colors.dark.cyan}"
          "7=${colors.dark.white}"
          "8=${colors.dark.brightBlack}"
          "9=${colors.dark.red}"
          "10=${colors.dark.green}"
          "11=${colors.dark.yellow}"
          "12=${colors.dark.blue}"
          "13=${colors.dark.orange}"
          "14=${colors.dark.cyan}"
          "15=${colors.dark.white}"
        ];
      };
      _light = {
        background = colors.bright.background;
        cursor-color = colors.bright.cursor;
        foreground = colors.bright.foreground;
        palette = [
          "0=${colors.bright.black}"
          "1=${colors.bright.red}"
          "2=${colors.bright.green}"
          "3=${colors.bright.yellow}"
          "4=${colors.bright.blue}"
          "5=${colors.bright.orange}"
          "6=${colors.bright.cyan}"
          "7=${colors.bright.white}"
          "8=${colors.bright.brightBlack}"
          "9=${colors.bright.red}"
          "10=${colors.bright.green}"
          "11=${colors.bright.yellow}"
          "12=${colors.bright.blue}"
          "13=${colors.bright.orange}"
          "14=${colors.bright.cyan}"
          "15=${colors.bright.white}"
        ];
      };
    };
  };
}
