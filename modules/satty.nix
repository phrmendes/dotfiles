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

    xdg.configFile = {
      "satty/config.toml".source = builtins.fromTOML ''
        [general]
        fullscreen = true
        early-exit = true
        initial-tool = "brush"
        copy-command = "${pkgs.wl-clipboard}/bin/wl-copy"
        annotation-size-factor = 2
        output-filename = "${parameters.home}/Pictures/screenshot-%Y%m%d%H%M%S.png"
        save-after-copy = false
        default-hide-toolbars = false
      '';
    };
  };
}
