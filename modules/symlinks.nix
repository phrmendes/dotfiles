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
        ".config/helix".source = ../dotfiles/helix;
        ".config/zellij".source = ../dotfiles/zellij;
      };
      darwin = {
        ".amethyst.yml".source = ../dotfiles/amethyst.yml;
      };
      desktop = {
        ".face".source = ../dotfiles/face.png;
        ".background".source = ../dotfiles/background.png;
      };
    in
      if isDarwin
      then common // darwin
      else common // desktop;
  };
}
