{
  flake.modules.homeManager.bash = {
    programs.eza = {
      enable = true;
      enableNushellIntegration = false;
    };
  };
}
