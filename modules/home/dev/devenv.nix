{
  flake.modules.homeManager.devenv = {
    home.sessionVariables.DEVENV_TUI = "false";

    programs.devenv = {
      enable = true;
      enableNushellIntegration = true;
      settings.tui.statusline.enabled = false;
    };
  };
}
