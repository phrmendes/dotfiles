{
  lib,
  config,
  pkgs,
  ...
}: {
  options.satty.enable = lib.mkEnableOption "enable satty";

  config = lib.mkIf config.satty.enable {
    home.packages = with pkgs; [
      grim
      satty
      slurp
    ];

    xdg.configFile = {
      "satty/config.toml".source = ../dotfiles/satty.toml;
    };
  };
}
