{
  lib,
  config,
  ...
}: {
  options.symlinks.enable = lib.mkEnableOption "enable symlinks";

  config = lib.mkIf config.symlinks.enable {
    home.file = {
      ".face".source = ../dotfiles/face.png;
    };
  };
}
