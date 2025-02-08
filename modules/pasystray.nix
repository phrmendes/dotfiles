{
  lib,
  config,
  ...
}:
{
  options.pasystray.enable = lib.mkEnableOption "enable pasystray";
  config = lib.mkIf config.pasystray.enable {
    services.pasystray.enable = true;
  };
}
