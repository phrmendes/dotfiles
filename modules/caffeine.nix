{
  lib,
  config,
  ...
}: {
  options.caffeine.enable = lib.mkEnableOption "enable blueman applet";

  config = lib.mkIf config.blueman.enable {
    services.caffeine.enable = true;
  };
}
