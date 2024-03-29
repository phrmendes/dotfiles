{
  config,
  inputs,
  lib,
  ...
}: {
  options.starship.enable = lib.mkEnableOption "enable starship";

  config = lib.mkIf config.starship.enable {
    programs.starship = let
      flavour = "mocha";
    in {
      enable = true;
      enableZshIntegration = true;
      settings =
        {
          command_timeout = 1000;
          docker_context.disabled = true;
          conda.symbol = "🐍 ";
          nix_shell.symbol = " ";
          scala.symbol = " ";
          palette = "catppuccin_${flavour}";
        }
        // builtins.fromTOML (builtins.readFile "${inputs.catppuccin-starship}/palettes/${flavour}.toml");
    };
  };
}
