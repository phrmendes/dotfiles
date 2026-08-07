_: {
  modules.homeManager.dev.fzf =
    { pkgs, lib, ... }:
    let
      bat = lib.getExe pkgs.bat;
      fd = lib.getExe pkgs.fd;
    in
    {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
        defaultCommand = "${fd} --type f";
        changeDirWidget.command = "${fd} --type d";
        fileWidget.options = [ "--preview '${bat} --color=always {}'" ];
        historyWidget.command = "";
      };
    };
}
