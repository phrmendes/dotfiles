{
  config,
  lib,
  ...
}:
{
  options.starship.enable = lib.mkEnableOption "enable starship";

  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        command_timeout = 1000;
        docker_context.disabled = true;
        gcloud.disabled = true;
        nix_shell.symbol = " ";
        python.symbol = " ";
        character = {
          success_symbol = "[󰘧](bold green)";
          error_symbol = "[󰘧](bold red)";
          vimcmd_symbol = "[󰘧](bold purple)";
        };
      };
    };
  };
}
