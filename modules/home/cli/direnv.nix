{
  flake.modules.homeManager.direnv =
    { osConfig, ... }:
    {
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
            prefix = [ osConfig.environment.sessionVariables.PROJECTS_DIR ];
          };
        };
      };
    };
}
