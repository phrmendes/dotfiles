{
  flake.modules.nixos.direnv =
    { config, ... }:
    {
      programs.direnv = {
        enable = true;
        direnvrcExtra = builtins.readFile ../../../files/scripts/direnv-layout-dir.sh;
        settings = {
          global = {
            load_dotenv = true;
            strict_env = true;
            warn_timeout = "1m";
          };
          whitelist.prefix = [ config.environment.sessionVariables.PROJECTS_DIR ];
        };
      };
    };
}
