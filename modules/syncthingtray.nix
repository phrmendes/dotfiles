{
  lib,
  config,
  pkgs,
  ...
}: {
  options.syncthingtray.enable = lib.mkEnableOption "enable syncthingtray";

  config = lib.mkIf config.syncthingtray.enable {
    services.syncthing = {
      enable = true;
      tray = {
        enable = true;
        command = "${pkgs.coreutils}/bin/sleep 5; syncthingtray";
      };
    };
  };
}
