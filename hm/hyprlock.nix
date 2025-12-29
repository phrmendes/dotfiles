{ lib, config, ... }:
{
  options.hyprlock.enable = lib.mkEnableOption "enable hyprlock";
  config = lib.mkIf config.hyprlock.enable {
    programs.hyprlock.enable = true;
  };
}
