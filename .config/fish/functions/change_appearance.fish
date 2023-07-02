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
    switch $appearance
        case dark
            nvim --server $NVIM_ADDR --remote-send ':set background=dark<CR>'
        case light
            nvim --server $NVIM_ADDR --remote-send ':set background=light<CR>'
    end

    # change tmux
    # switch $appearance
    #   case dark
    #     tmux source-file ~/.tmux/tmux-dark.conf
    #   case light
    #     tmux source-file ~/.tmux/tmux-light.conf
    # end
end
