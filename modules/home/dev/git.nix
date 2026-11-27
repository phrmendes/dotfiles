{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          inherit (settings) email name;
        };
        gpg.ssh.allowedSignersFile = builtins.toFile "git-allowed-signers" "${settings.email} ${builtins.readFile ../../../files/ssh/signing.txt}";
        http.sslVerify = true;
        init.defaultBranch = "main";
        diff.tool = "codediff";
        difftool.codediff.cmd = ''nvim "$LOCAL" "$REMOTE" +"CodeDiff --exit-on-close file $LOCAL $REMOTE"'';
        merge.tool = "codediff";
        mergetool.codediff.cmd = ''nvim "$MERGED" -c "CodeDiff --exit-on-close merge \"$MERGED\""'';
        pull.rebase = true;
        submodule.recurse = true;
        push = {
          autoSetupRemote = true;
          recurseSubmodules = "on-demand";
        };
        aliases = {
          A = "add .";
          P = "push";
          a = "add";
          c = "clone";
          co = "checkout";
          lg = "log";
          p = "pull";
          r = "restore .";
          ra = "rebase --abort";
          rc = "rebase --continue";
          st = "status";
        };
      };
      ignores = [
        ".env"
        ".envrc"
        "Session.vim"
        ".direnv"
        ".devenv"
      ];
    };
  };
}
