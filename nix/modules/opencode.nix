{ ... }:
let
  colors = import ./colors.nix;
in
{
  programs.opencode = {
    enable = true;

    context = ../agents/AGENTS.md;
    skills = ../agents/skills;

    settings = {
      disabled_providers = [
        "gemini"
      ];
      permission = {
        # Keep normal development flows unprompted and only interrupt for
        # commands that can permanently delete data, change remote state, or
        # escalate privileges.
        bash = {
          "*" = "allow";
          "sudo" = "ask";
          "sudo *" = "ask";
          "rm *" = "ask";
          "rm -*" = "ask";
          "find *-delete*" = "ask";
          "git clean" = "ask";
          "git clean *" = "ask";
          "git clean -*" = "ask";
          "git reset --hard" = "ask";
          "git reset --hard *" = "ask";
          "git reset * --hard" = "ask";
          "git reset * --hard *" = "ask";
          "git push" = "ask";
          "git push *" = "ask";
          "dd *of=/dev/*" = "ask";
          "diskutil erase*" = "ask";
          "mkfs*" = "ask";
          "newfs*" = "ask";
        };
      };
    };

    tui = {
      theme = "tmm";
      keybinds = {
        input_newline = "enter";
        input_submit = "super+enter";
        input_delete_to_line_end = "none";
        messages_previous = "ctrl+k";
        messages_next = "ctrl+j";
        messages_page_up = "ctrl+u";
        messages_page_down = "ctrl+d";
      };
    };

    themes.tmm = {
      defs = {
        darkBg = colors.dark.background;
        darkBgMenu = "#272726";
        darkBgSidebar = "#000000";
        darkBlue = colors.dark.blue;
        darkCursor = colors.dark.cursor;
        darkCyan = colors.dark.cyan;
        darkFg = colors.dark.foreground;
        darkFgBase = "#d1d1d1";
        darkGreen = colors.dark.green;
        darkMagenta = colors.dark.magenta;
        darkOrange = colors.dark.orange;
        darkRed = colors.dark.red;
        darkUnimportant = "#757575";
        darkYellow = colors.dark.yellow;

        lightBg = colors.bright.background;
        lightBgMenu = "#e8e8e6";
        lightBgSidebar = "#f5f5f3";
        lightBlue = colors.bright.blue;
        lightCursor = colors.bright.cursor;
        lightCyan = colors.bright.cyan;
        lightFg = colors.bright.foreground;
        lightFgBase = "#333333";
        lightGreen = colors.bright.green;
        lightMagenta = colors.bright.magenta;
        lightOrange = colors.bright.orange;
        lightRed = colors.bright.red;
        lightUnimportant = "#999999";
        lightYellow = colors.bright.yellow;
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
          dark = "darkFgBase";
          light = "lightFgBase";
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
  };
}
