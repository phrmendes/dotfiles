{
  lib,
  config,
  ...
}: {
  options.syncthing-tray.enable = lib.mkEnableOption "enable syncthing-tray";

  config = lib.mkIf config.syncthing-tray.enable {
    services.syncthing.tray = true;
  };
}
