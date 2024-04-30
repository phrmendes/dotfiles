{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  options.symlinks.enable = lib.mkEnableOption "enable symlinks";

  config = lib.mkIf config.symlinks.enable {
    home.file = let
      common = {
        ".config/yazi/theme.toml".source = ../dotfiles/yazi/theme.toml;
      };
    in
      common
      // lib.optionalAttrs isDarwin {
        ".amethyst.yml".source = ../dotfiles/amethyst.yml;
      }
      // lib.optionalAttrs isLinux {
        ".config/satty".source = ../dotfiles/satty;
        ".face".source = ../dotfiles/face.png;
        ".background".source = ../dotfiles/background.png;
      };
  };
}
