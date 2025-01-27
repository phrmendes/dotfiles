{
  config,
  lib,
  ...
}: {
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
        python.symbol = " ";
        conda.symbol = "󱔎 ";
        nix_shell.symbol = " ";
        git_status.deleted = "x";
      };
    };
  };
}
