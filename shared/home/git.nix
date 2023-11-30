{lib, ...}: {
  programs.git = {
    delta.enable = true;
    enable = true;
    userEmail = lib.mkDefault "pedrohrmendes@proton.me";
    userName = "Pedro Mendes";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      http.sslVerify = true;
    };
    aliases = {
      co = "checkout";
      st = "status";
      rc = "rebase --continue";
      lg = "log";
    };
  };
}
