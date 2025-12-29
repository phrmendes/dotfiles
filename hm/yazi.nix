{
  lib,
  config,
  ...
}:
{
  options.yazi.enable = lib.mkEnableOption "enable yazi";

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
