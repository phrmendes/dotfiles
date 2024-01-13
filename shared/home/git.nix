{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    delta.enable = true;
    enable = true;
    userEmail = lib.mkDefault "pedrohrmendes@proton.me";
    userName = "Pedro Mendes";
    extraConfig = {
      core.exitor = "${pkgs.helix}/bin/hx";
      http.sslVerify = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    aliases = {
      P = "push";
      a = "add .";
      r = "restore .";
      co = "checkout";
      lg = "log";
      p = "pull";
      ra = "rebase --abort";
      rc = "rebase --continue";
      st = "status";
    };
  };
}
