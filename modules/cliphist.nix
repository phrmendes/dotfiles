{
  lib,
  config,
  ...
}:
{
  options.cliphist.enable = lib.mkEnableOption "enable cliphist";
  config = lib.mkIf config.cliphist.enable {
    services.cliphist = {
      enable = true;
      allowImages = true;
      systemdTargets = [ "hyprland-session.target" ];
    };
  };
}
