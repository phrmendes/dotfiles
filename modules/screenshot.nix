{
  config,
  lib,
  parameters,
  pkgs,
  ...
}:
{
  options.screenshot.enable = lib.mkEnableOption "enable screenshot";

  config = lib.mkIf config.screenshot.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "screenshot" ''
        #!/usr/bin/env bash

        ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" - | ${satty}/bin/satty --filename -
      '')
    ];

    xdg.configFile."satty/config.toml".text = ''
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
}
