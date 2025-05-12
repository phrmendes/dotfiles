{
  lib,
  config,
  ...
}:
{
  options.lazydocker.enable = lib.mkEnableOption "enable lazydocker";

  config = lib.mkIf config.lazydocker.enable {
    programs.lazydocker.enable = true;
  };
}
