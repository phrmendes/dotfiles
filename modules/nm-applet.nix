{
  lib,
  config,
  ...
}: {
  options.network-manager-applet.enable = lib.mkEnableOption "enable network-manager-applet";

  config = lib.mkIf config.network-manager-applet.enable {
    services.network-manager-applet.enable = true;
  };
}
