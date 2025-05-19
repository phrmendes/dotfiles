{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.bat.enable = lib.mkEnableOption "enable bat";

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
      extraPackages = with pkgs.bat-extras; [ core ];
    };
  };
}
