_: {
  modules.homeManager.dev.fzf =
    { pkgs, lib, ... }:
    {
      programs.fzf =
        let
          bat = lib.getExe pkgs.bat;
          fd = lib.getExe pkgs.fd;
        in
        {
          enable = true;
          enableZshIntegration = true;
          defaultCommand = "${fd} --type f";
          changeDirWidget.command = "${fd} --type d";
          fileWidget.options = [ "--preview '${bat} --color=always {}'" ];
          historyWidget.command = "";
        };
    };
}
