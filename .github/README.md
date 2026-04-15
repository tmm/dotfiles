## Install

```fish
git clone https://github.com/tmm/dotfiles ~/Developer/dotfiles
~/Developer/dotfiles/bootstrap tmm
```

<details>
<summary>Manual steps after bootstrap</summary>

- Sign into 1Password.
- [Enable the 1Password SSH agent](https://developer.1password.com/docs/ssh/agent/).
- Sign into the Mac App Store if you want `masApps` installs to succeed.
- Optionally authenticate GitHub CLI:

  ```fish
  gh auth login
  ```
- Optionally switch the repo remote to SSH once 1Password SSH is working:

  ```fish
  git -C ~/Developer/dotfiles remote set-url origin git@github.com:tmm/dotfiles.git
  ```
- Use `tmm-work` instead of `tmm` for the work laptop.

</details>

## Commands

```fish
drs [host]  # rebuild current host or named host
drb [host]  # build current host or named host
```

## License

MIT. See [LICENSE](../LICENSE).
