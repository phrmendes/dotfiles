{lib, ...}: {
  programs.git = {
    enable = true;
    userName = "Pedro Mendes";
    userEmail = lib.mkDefault "pedrohrmendes@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      http.sslVerify = true;
      git_protocol = "https";
    };
    aliases = {
      co = "checkout";
      st = "status";
      rc = "rebase --continue";
      lg = "log";
    };
    difftastic = {
      enable = true;
      background = "dark";
      color = "always";
      display = "inline";
    };
  };
}
