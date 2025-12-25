{
  lib,
  config,
  ...
}:
{
  options.symlinks.enable = lib.mkEnableOption "enable symlinks";

  config = lib.mkIf config.symlinks.enable {
    home.file = {
      ".face.icon".source = ../dotfiles/face.png;
      ".config/zsh/functions.sh".source = ../dotfiles/functions.sh;
    };
  };
}
