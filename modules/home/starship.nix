{
  homeModules.starship = {
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      settings = {
        command_timeout = 1000;
        gcloud.disabled = true;
        jobs.disabled = true;
        nix_shell.disabled = true;
        character = {
          success_symbol = "[󰘧](bold green)";
          error_symbol = "[󰘧](bold red)";
          vimcmd_symbol = "[󰘧](bold purple)";
        };
      };
    };
  };
}
