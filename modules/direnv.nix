{
  lib,
  config,
  parameters,
  ...
}:
{
  options.direnv.enable = lib.mkEnableOption "enable direnv";

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          load_dotenv = true;
          strict_env = true;
          warn_timeout = 0;
        };
        whitelist = {
          prefix = [ "${parameters.home}/Projects" ];
        };
      };
    };
  };
}
