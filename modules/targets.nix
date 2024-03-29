{
  lib,
  config,
  ...
}: {
  options.targets.enable = lib.mkEnableOption "enable targets";

  config = lib.mkIf config.targets.enable {
    targets.genericLinux.enable = true;
  };
}
