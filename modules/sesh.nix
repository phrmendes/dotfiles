{
  lib,
  config,
  ...
}:
{
  options.sesh.enable = lib.mkEnableOption "enable sesh";

  config = lib.mkIf config.sesh.enable {
    programs.sesh = {
      enable = true;
      enableTmuxIntegration = true;
      icons = true;
      tmuxKey = "s";
    };
  };
}
