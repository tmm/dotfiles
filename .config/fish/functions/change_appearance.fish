function change_appearance --argument appearance_setting
    set -l appearance light # default value
    if test -z $appearance_setting
        set -l val (defaults read -g AppleInterfaceStyle) >/dev/null
        if test $status -eq 0
            set appearance dark
        end
    else
        switch $appearance_setting
            case light
                osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
                set appearance light
            case dark
                osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
                set appearance dark
        end
    end

    # change neovim
    # for addr in (/opt/homebrew/bin/nvr --serverlist)
    #   switch $appearance
    #     case dark
    #       /opt/homebrew/bin/nvr --servername "$addr" -c "set background=dark"
    #     case light
    #       /opt/homebrew/bin/nvr --servername "$addr" -c "set background=light"
    #   end
    # end

    # change tmux
    # switch $appearance
    #   case dark
    #     tmux source-file ~/.tmux/tmux-dark.conf
    #   case light
    #     tmux source-file ~/.tmux/tmux-light.conf
    # end
end
