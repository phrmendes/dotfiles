{
  flake.modules.homeManager.devenv = {
    home.sessionVariables.DEVENV_TUI = "false";

    programs = {
      devenv = {
        enable = true;
        enableNushellIntegration = false;
        settings.tui.statusline.enabled = false;
      };

      nushell.extraConfig = "source ${../../../files/scripts/devenv.nu}";
    };
  };
}
