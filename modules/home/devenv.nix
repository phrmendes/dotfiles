{
  flake.modules.homeManager.devenv = {
    programs.devenv = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
