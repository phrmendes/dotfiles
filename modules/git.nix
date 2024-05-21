{
  config,
  lib,
  parameters,
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
        core.excludeFiles = builtins.toFile "ignore" ''
          .DS_Store
          Session.vim
        '';
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
