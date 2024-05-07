{
  lib,
  config,
  ...
}: {
  options.copyq.enable = lib.mkEnableOption "enable copyq";

  config = lib.mkIf config.copyq.enable {
    services.copyq.enable = true;
  };
}
