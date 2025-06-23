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
      enableAlias = true;
      enableTmuxIntegration = true;
      tmuxKey = "C-Space";
    };
  };
}
