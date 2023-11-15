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
    for addr in (ls $(echo $TMPDIR)nvim.$(echo $USER)/*/nvim.*.0)
        switch $appearance
            case dark
                nvim --server $addr --remote-send ':set background=dark<CR>'
            case light
                nvim --server $addr --remote-send ':set background=light<CR>'
        end
    end

    # change and reload ghostty appearance
    # https://github.com/mitchellh/ghostty/issues/601

    # change zellij theme
    # zelijj options --theme $appearance
end
