{
  lib,
  config,
  ...
}: {
  options.kdeconnect.enable = lib.mkEnableOption "enable kdeconnect";

  config = lib.mkIf config.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
