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
          changeDirWidgetCommand = "${fd} --type d";
          fileWidgetOptions = [ "--preview '${bat} --color=always {}'" ];
        };
    };
}
