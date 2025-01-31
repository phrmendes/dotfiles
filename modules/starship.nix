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
      settings = builtins.fromTOML (builtins.readFile ../dotfiles/starship.toml);
    };
  };
}
