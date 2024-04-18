{
  lib,
  config,
  ...
}: {
  options.atuin.enable = lib.mkEnableOption "enable atuin";

  config = lib.mkIf config.atuin.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
