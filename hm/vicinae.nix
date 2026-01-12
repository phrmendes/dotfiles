{
  lib,
  config,
  ...
}:
{
  options.vicinae.enable = lib.mkEnableOption "enable vicinae";

  config = lib.mkIf config.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
