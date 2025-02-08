{
  lib,
  config,
  parameters,
  pkgs,
  ...
}:
{
  options.symlinks.enable = lib.mkEnableOption "enable symlinks";

  config = lib.mkIf config.symlinks.enable {
    home.file = {
      ".face.icon".source = ../dotfiles/face.png;
      ".config/satty/config.toml".text = ''
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
