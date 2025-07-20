{ config, ... }:
let
  colors = import ./colors.nix;
in
{
  xdg.configFile."AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.DOTFILES_HOME}/nix/files/AGENTS.md";

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    theme = "tmm";
  };

  xdg.configFile."opencode/themes/tmm.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/theme.json";
    defs = {
      darkBg = "${colors.dark.background}";
      darkBgMenu = "#272726";
      darkBgSidebar = "#000000";
      darkBlue = "${colors.dark.blue}";
      darkCursor = "${colors.dark.cursor}";
      darkCyan = "${colors.dark.cyan}";
      darkFg = "${colors.dark.foreground}";
      darkFgBase = "#d1d1d1";
      darkGreen = "${colors.dark.green}";
      darkMagenta = "${colors.dark.magenta}";
      darkOrange = "${colors.dark.orange}";
      darkRed = "${colors.dark.red}";
      darkUnimportant = "#757575";
      darkYellow = "${colors.dark.yellow}";

      lightBg = "${colors.bright.background}";
      lightBgMenu = "#272726";
      lightBgSidebar = "#000000";
      lightBlue = "${colors.bright.blue}";
      lightCursor = "${colors.dark.cursor}";
      lightCyan = "${colors.bright.cyan}";
      lightFg = "${colors.bright.foreground}";
      lightFgBase = "#d1d1d1";
      lightGreen = "${colors.bright.green}";
      lightMagenta = "${colors.bright.magenta}";
      lightOrange = "${colors.bright.orange}";
      lightRed = "${colors.bright.red}";
      lightUnimportant = "#757575";
      lightYellow = "${colors.bright.yellow}";
    };
    theme = {
      primary = {
        dark = "darkOrange";
        light = "lightOrange";
      };
      secondary = {
        dark = "darkBlue";
        light = "lightBlue";
      };
      accent = {
        dark = "darkCursor";
        light = "lightCursor";
      };
      error = {
        dark = "darkRed";
        light = "lightRed";
      };
      warning = {
        dark = "darkOrange";
        light = "lightOrange";
      };
      success = {
        dark = "darkGreen";
        light = "lightGreen";
      };
      info = {
        dark = "darkCyan";
        light = "lightCyan";
      };
      text = {
        dark = "darkFgBase";
        light = "lightFgBase";
      };
      textMuted = {
        dark = "darkUnimportant";
        light = "lightUnimportant";
      };
      background = {
        dark = "darkBgSidebar";
        light = "lightBgSidebar";
      };
      backgroundPanel = {
        dark = "darkBg";
        light = "lightBg";
      };
      backgroundElement = {
        dark = "darkBgMenu";
        light = "lightBgMenu";
      };
      border = {
        dark = "darkUnimportant";
        light = "lightUnimportant";
      };
      borderActive = {
        dark = "darkUnimportant";
        light = "lightUnimportant";
      };
      borderSubtle = {
        dark = "darkBg";
        light = "lightBg";
      };
      diffAdded = {
        dark = "darkFg";
        light = "#1e725c";
      };
      diffRemoved = {
        dark = "darkFg";
        light = "#c53b53";
      };
      diffContext = {
        dark = "#828bb8";
        light = "#7086b5";
      };
      diffHunkHeader = {
        dark = "#828bb8";
        light = "#7086b5";
      };
      diffHighlightAdded = {
        dark = "#1d572d";
        light = "#4db380";
      };
      diffHighlightRemoved = {
        dark = "#7f302f";
        light = "#f52a65";
      };
      diffAddedBg = {
        dark = "#14261d";
        light = "#d5e5d5";
      };
      diffRemovedBg = {
        dark = "#301b1e";
        light = "#f7d8db";
      };
      diffContextBg = {
        dark = "darkBg";
        light = "lightBg";
      };
      diffLineNumber = {
        dark = "darkBg";
        light = "lightBg";
      };
      diffAddedLineNumberBg = {
        dark = "#1f4428";
        light = "#c5d5c5";
      };
      diffRemovedLineNumberBg = {
        dark = "#552527";
        light = "#e7c8cb";
      };
      markdownText = {
        dark = "darkFgBase";
        light = "lightFgBase";
      };
      markdownHeading = {
        dark = "darkUnimportant";
        light = "lightUnimportant";
      };
      markdownLink = {
        dark = "darkFg";
        light = "lightFg";
      };
      markdownLinkText = {
        dark = "darkCyan";
        light = "lightCyan";
      };
      markdownCode = {
        dark = "darkGreen";
        light = "lightGreen";
      };
      markdownBlockQuote = {
        dark = "darkYellow";
        light = "lightYellow";
      };
      markdownEmph = {
        dark = "darkYellow";
        light = "lightYellow";
      };
      markdownStrong = {
        dark = "darkOrange";
        light = "lightOrange";
      };
      markdownHorizontalRule = {
        dark = "darkUnimportant";
        light = "lightUnimportant";
      };
      markdownListItem = {
        dark = "darkFg";
        light = "lightFg";
      };
      markdownListEnumeration = {
        dark = "darkCyan";
        light = "lightCyan";
      };
      markdownImage = {
        dark = "darkFg";
        light = "lightFg";
      };
      markdownImageText = {
        dark = "darkCyan";
        light = "lightCyan";
      };
      markdownCodeBlock = {
        dark = "darkFgBase";
        light = "lightFgBase";
      };
      syntaxComment = {
        dark = "darkUnimportant";
        light = "lightUnimportant";
      };
      syntaxKeyword = {
        dark = "darkBlue";
        light = "lightBlue";
      };
      syntaxFunction = {
        dark = "darkFg";
        light = "lightFg";
      };
      syntaxVariable = {
        dark = "darkFgBase";
        light = "lightRed";
      };
      syntaxString = {
        dark = "darkGreen";
        light = "lightGreen";
      };
      syntaxNumber = {
        dark = "darkOrange";
        light = "lightOrange";
      };
      syntaxType = {
        dark = "darkYellow";
        light = "lightYellow";
      };
      syntaxOperator = {
        dark = "darkOrange";
        light = "lightOrange";
      };
      syntaxPunctuation = {
        dark = "darkUnimportant";
        light = "lightUnimportant";
      };
    };
  };
}

