{
  lib,
  config,
  ...
}: {
  options.swayosd.enable = lib.mkEnableOption "enable swayosd";

  config = lib.mkIf config.swayosd.enable {
    services.swayosd = {
      enable = true;
      display = "DP-1";
    };
  };
}
