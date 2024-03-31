{
  lib,
  config,
  ...
}: {
  options.syncthingtray.enable = lib.mkEnableOption "enable syncthingtray";

  config = lib.mkIf config.syncthingtray.enable {
    services.syncthing = {
      enable = true;
      tray = {
        enable = true;
        command = "syncthingtray --wait";
      };
    };
  };
}
