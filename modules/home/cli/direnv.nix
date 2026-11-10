{
  flake.modules.homeManager.direnv =
    {
      config,
      osConfig,
      ...
    }:
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        config = {
          global = {
            load_dotenv = true;
            strict_env = true;
            warn_timeout = "1m";
          };
          whitelist = {
            prefix = [
              (osConfig.environment.sessionVariables.PROJECTS_DIR or "${config.home.homeDirectory}/Projects")
            ];
          };
        };
      };
    };
}
