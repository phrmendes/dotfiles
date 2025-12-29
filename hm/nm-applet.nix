{ lib, config, ... }:
{
  options.nm-applet.enable = lib.mkEnableOption "enable nm-applet";
  config = lib.mkIf config.nm-applet.enable {
    services.network-manager-applet.enable = true;
  };
}
