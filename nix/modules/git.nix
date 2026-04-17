{ host, ... }:
{
  programs.git = {
    enable = true;
    signing.format = "ssh";
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
        d = "diff";
        ds = "diff --staged";
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
        name = host.git.name;
        email = host.git.email;
        signingkey = host.git.signingKey;
      };
      branch.sort = "-committerdate";
      color.ui = "auto";
      commit.gpgsign = true;
      core = {
        editor = "nvim";
        excludesfile = "~/.config/git/ignore_global";
        pager = "sh -c 'delta --features \"$(if defaults read -globalDomain AppleInterfaceStyle >/dev/null 2>&1; then echo dark; else echo light; fi)\"'";
      };
      credential.helper = "osxkeychain";
      delta = {
        # TODO: nvim support
        # hyperlinks = true;
        navigate = true;
        line-numbers = true;
        side-by-side = false;
        file-added-label = " ";
        file-modified-label = " ";
        file-removed-label = " ";
        file-renamed-label = " ";
        hunk-header-style = "omit";
        dark = {
          syntax-theme = "dotfiles_dark";
          file-decoration-style = "#272725 ul";
          file-style = "#BFBFBF";
          line-numbers-left-style = "#272725";
          # TODO: delta doesn't support per-line-type coloring of both columns (styles are per-column, not per-line-type)
          line-numbers-minus-style = "#4A4945";
          line-numbers-plus-style = "#4A4945";
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
        light = {
          syntax-theme = "dotfiles_light";
          file-decoration-style = "#d0d0d0 ul";
          file-style = "#444444";
          line-numbers-left-style = "#d0d0d0";
          # TODO: delta doesn't support per-line-type coloring of both columns (styles are per-column, not per-line-type)
          line-numbers-minus-style = "#b0b0b0";
          line-numbers-plus-style = "#b0b0b0";
          line-numbers-right-style = "#d0d0d0";
          line-numbers-zero-style = "#b0b0b0";
          minus-emph-style = "#330000 #f8c0c0";
          minus-empty-line-marker-style = "syntax #fce8e8";
          minus-non-emph-style = "syntax #fce8e8";
          minus-style = "syntax #fce8e8";
          plus-emph-style = "#003300 #b8e8c0";
          plus-empty-line-marker-style = "syntax #e8fce8";
          plus-non-emph-style = "syntax #e8fce8";
          plus-style = "syntax #e8fce8";
        };
      };
      github.user = host.git.githubUser;
      gpg = {
        format = "ssh";
        ssh.program = host.git.signingProgram;
      };
      include = {
        path = "~/.config/delta/themes.gitconfig";
      };
      init.defaultBranch = "main";
      interactive = {
        diffFilter = "sh -c 'delta --color-only --features \"$(if defaults read -globalDomain AppleInterfaceStyle >/dev/null 2>&1; then echo dark; else echo light; fi)\"'";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      pull.rebase = false;
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      submodule.recurse = true;
    };
  };
}
