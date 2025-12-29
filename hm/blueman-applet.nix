{ lib, config, ... }:
{
  options.blueman-applet.enable = lib.mkEnableOption "enable blueman-applet";
  config = lib.mkIf config.blueman-applet.enable {
    services.blueman-applet.enable = true;
  };
}
