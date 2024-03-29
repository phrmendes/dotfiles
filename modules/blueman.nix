{
  lib,
  config,
  ...
}: {
  options.blueman.enable = lib.mkEnableOption "enable blueman applet";

  config = lib.mkIf config.blueman.enable {
    services.blueman-applet.enable = true;
  };
}
