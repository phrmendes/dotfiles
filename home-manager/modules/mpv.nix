{ lib, config, ... }:
{
  options.mpv.enable = lib.mkEnableOption "enable mpv";

  config = lib.mkIf config.mpv.enable {
    programs.mpv.enable = true;
  };
}
