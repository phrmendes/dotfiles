{
  lib,
  config,
  ...
}: {
  options.direnv.enable = lib.mkEnableOption "enable direnv";

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        global = {
          load_dotenv = true;
          strict_env = true;
        };
      };
    };
  };
}
