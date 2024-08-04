{
  config,
  lib,
  parameters,
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

    home.file.".config/satty/config.toml".text =
      /*
      toml
      */
      ''
        [general]
        fullscreen = true
        early-exit = true
        initial-tool = "brush"
        copy-command = "wl-copy"
        annotation-size-factor = 2
        output-filename = "${parameters.home}/Pictures/screenshot-%Y%m%d%H%M%S.png"
        save-after-copy = false
        default-hide-toolbars = false
      '';
  };
}
