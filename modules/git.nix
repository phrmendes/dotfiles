{
  lib,
  config,
  parameters,
  ...
}: {
  options.git.enable = lib.mkEnableOption "enable git";

  config = lib.mkIf config.git.enable {
    programs.git = {
      delta.enable = true;
      enable = true;
      userEmail = parameters.email;
      userName = parameters.name;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        http.sslVerify = true;
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
  };
}
