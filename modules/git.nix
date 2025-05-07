{
  config,
  lib,
  parameters,
  ...
}:
{
  options.git.enable = lib.mkEnableOption "enable git";

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      delta.enable = true;
      userEmail = parameters.email;
      userName = parameters.name;
      extraConfig = {
        credential.helper = "store";
        http.sslVerify = true;
        init.defaultBranch = "main";
        merge.tool = "nvimdiff";
        pull.rebase = true;
        submodules.recurse = true;
        push = {
          autoSetupRemote = true;
          recurseSubmodules = "on-demand";
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
