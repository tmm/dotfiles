{ ... }:
{
  programs.git = {
    enable = true;
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
    settings = {
      alias = {
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
      user = {
        name = "tmm";
        email = "tmm@tmm.dev";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuIScU+299QwZ5IkK48wS6Fi713aruyZTGE1NILUTJ8";
      };
      branch.sort = "-committerdate";
      color.ui = "auto";
      commit.gpgsign = true;
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore_global";
        pager = "delta";
      };
      credential.helper = "osxkeychain";
      delta = {
        # TODO: nvim support
        # hyperlinks = true;
        navigate = true;
        line-numbers = true;
        side-by-side = false;
        file-added-label = " ";
        file-decoration-style = "#272725 ul";
        file-modified-label = " ";
        file-removed-label = " ";
        file-renamed-label = " ";
        file-style = "#BFBFBF";
        hunk-header-style = "omit";
        line-numbers-left-style = "#272725";
        line-numbers-minus-style = "#F0F6FC #552527";
        line-numbers-plus-style = "#F0F6FC #1F4429";
        line-numbers-right-style = "#272725";
        line-numbers-zero-style = "#4A4945";
        minus-emph-style = "#F0F6FC #7F302F";
        minus-empty-line-marker-style = "syntax #301B1E";
        minus-non-emph-style = "syntax #301B1E";
        minus-style = "syntax #301B1E";
        plus-emph-style = "#F0F6FC #1D572D";
        plus-empty-line-marker-style = "syntax #14261D";
        plus-non-emph-style = "syntax #14261D";
        plus-style = "syntax #14261D";
      };
      github.user = "tmm";
      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      include = {
        path = "~/.config/delta/themes.gitconfig";
      };
      init.defaultBranch = "main";
      interactive = {
        diffFilter = "delta --color-only";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      pull.rebase = false;
      push = {
        autoSetupRemote = true;
        default = "current";
      };
    };
  };
}
