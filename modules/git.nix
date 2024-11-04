{
  config,
  lib,
  parameters,
  pkgs,
  ...
}: {
  options.git.enable = lib.mkEnableOption "enable git";

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      delta.enable = true;
      userEmail = parameters.email;
      userName = parameters.name;
      extraConfig = {
        merge.tool = "nvimdiff";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        http.sslVerify = true;
        diff = {
          tool = "kitty";
          guitool = "kitty.gui";
        };
        difftool = {
          prompt = false;
          trustExitCode = true;
        };
        "difftool \"kitty\"" = {
          cmd = "${pkgs.kitty}/bin/kitten diff $LOCAL $REMOTE";
        };
        "difftool \"kitty.gui\"" = {
          cmd = "${pkgs.kitty}/bin/kitten diff $LOCAL $REMOTE";
        };
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
      ignores = [
        ".env"
        "Session.vim"
      ];
    };
  };
}
