{
  flake.modules.homeManager.zoxide = {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
