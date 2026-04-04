{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.pasystray.enable = lib.mkEnableOption "enable pasystray";

  config = lib.mkIf config.pasystray.enable {
    home.packages = with pkgs; [ pasystray ];
    services.pasystray = {
      enable = true;
    };
  };
}
