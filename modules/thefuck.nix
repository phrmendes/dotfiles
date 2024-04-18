{
  lib,
  config,
  ...
}: {
  options.thefuck.enable = lib.mkEnableOption "enable thefuck";

  config = lib.mkIf config.thefuck.enable {
    programs.thefuck = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
