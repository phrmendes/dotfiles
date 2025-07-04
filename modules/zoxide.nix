{
  lib,
  config,
  ...
}:
{
  options.zoxide.enable = lib.mkEnableOption "enable zoxide";

  config = lib.mkIf config.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
