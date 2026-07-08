{ config, ... }:
{
  modules.homeManager.dev.git = {
    programs.difftastic = {
      enable = true;
      git = {
        enable = true;
        mode = "both";
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          inherit (config.settings) email name;
        };
        http.sslVerify = true;
        init.defaultBranch = "main";
        merge.tool = "vimdiff";
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
        "Session.vim"
      ];
    };
  };
}
