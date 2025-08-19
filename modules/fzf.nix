{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.fzf.enable = lib.mkEnableOption "enable fzf";

  config = lib.mkIf config.fzf.enable {
    programs.fzf =
      let
        bat = lib.getExe pkgs.bat;
        fd = lib.getExe pkgs.fd;
      in
      {
        enable = true;
        enableFishIntegration = true;
        defaultCommand = "${fd} --type f";
        changeDirWidgetCommand = "${fd} --type d";
        fileWidgetCommand = "${fd} --type f";
        fileWidgetOptions = [ "--preview '${bat} --color=always {}'" ];
      };
  };
}
