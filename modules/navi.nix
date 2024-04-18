{
  lib,
  config,
  ...
}: {
  options.navi.enable = lib.mkEnableOption "enable navi";

  config = lib.mkIf config.navi.enable {
    programs.navi = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
