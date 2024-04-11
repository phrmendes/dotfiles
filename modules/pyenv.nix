{
  lib,
  config,
  ...
}: {
  options.pyenv.enable = lib.mkEnableOption "enable pyenv";

  config = lib.mkIf config.pyenv.enable {
    programs.pyenv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
