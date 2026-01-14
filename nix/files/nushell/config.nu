$env.config = {
  show_banner: false
  edit_mode: "vi"
  shell_integration: {
    osc2: true
    osc7: true
    osc8: true
    osc9_9: false
    osc133: true
    osc633: true
    reset_application_mode: true
  }
  keybindings: [
    {
      name: fzf_history
      modifier: control
      keycode: char_r
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "commandline edit --replace (
          history
          | each { |it| $it.command }
          | uniq
          | reverse
          | str join (char -i 0)
          | fzf --read0 --layout=reverse --height=40% -q (commandline)
          | decode utf-8
          | str trim
        )"
      }
    }
    {
      name: fzf_files
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "commandline edit --insert (
          fd --type f --hidden --follow --exclude .git
          | fzf --layout=reverse --height=40%
          | decode utf-8
          | str trim
        )"
      }
    }
  ]
}

# Carapace completions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

let carapace_completer = {|spans: list<string>|
  carapace $spans.0 nushell ...$spans
  | from json
  | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

$env.config.completions = {
  external: {
    enable: true
    completer: $carapace_completer
  }
}
