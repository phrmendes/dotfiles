{ config, ... }:
{
  modules.homeManager.dev.direnv = {
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
          prefix = [ "${config.settings.home}/Projects" ];
        };
      };
    };
  };
}
