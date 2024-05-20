{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lazygit.enable = lib.mkEnableOption "enable lazygit";

  config = lib.mkIf config.lazygit.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        disableStartupPopups = true;
        gui.nerdFontsVersion = "3";
        git.paging = {
          colorArg = "always";
          pager = "${lib.getExe pkgs.delta} --dark --paging=never";
        };
      };
    };
  };
}
