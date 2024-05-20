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
    home.file =
      {}
      // lib.optionalAttrs isDarwin {
        ".amethyst.yml".source = ../dotfiles/amethyst.yml;
      }
      // lib.optionalAttrs isLinux {
        ".face".source = ../dotfiles/face.png;
      };
  };
}
