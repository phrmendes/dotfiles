{
  lib,
  config,
  ...
}:
{
  options.uv.enable = lib.mkEnableOption "enable uv";

  config = lib.mkIf config.uv.enable {
    programs.uv.enable = true;
  };
}
