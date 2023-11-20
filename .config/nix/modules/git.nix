{ pkgs, ... }: {
  programs.git = {
    enable = true;

    aliases = {
      a = "add";
      aa = "add .";
      au = "add --update";
      b = "branch";
      c = "commit -m";
      cn = "commit --no-verify -m";
      ch = "checkout";
      l = "log";
      p = "push";
      pf = "push --force";
      pl = "pull";
      s = "status";

      amend = "commit --amend --reuse-message=HEAD";
      go = "!go() { git checkout -b $1 2> /dev/null || git checkout $1; }; go";
      hist = "log --pretty=oneline --pretty=format:'%Cred%h%Creset %C(yellow)%an%Creset %s%C(normal dim)%d%Creset %Cgreen(%cr)%Creset' --date=relative --abbrev-commit";
      monkeys = "shortlog --summary --numbered";
      undo = "reset --soft HEAD^";
      unstage = "reset HEAD --";
    };

    ignores = [
      "*.un~"
      ".*.sw[a-z]"
      ".DS_Store"
      ".Spotlight-V100"
      ".Trashes"
      "._*"
      ".env"
      ".envrc"
      "Session.vim"
    ];

    userName = "Tom Meagher";
    userEmail = "tom@meagher.co";

    extraConfig = {
      color.ui = "auto";
      commit.gpgsign = true;
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore_global";
        pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
      credential.helper = "osxkeychain";
      github.user = "tmm";
      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLwl9HCwJ1+kNCbrx3N15oIcNfW7SgZBTFlmQnQEVn4";
    };
  };
}

