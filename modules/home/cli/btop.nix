{
  flake.modules.homeManager.btop = {
    programs.btop = {
      enable = true;
      settings.theme_background = false;
    };
  };
}
