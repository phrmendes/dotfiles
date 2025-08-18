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
      ".config/opencode/opencode.json".source = ../dotfiles/opencode.json;
      ".config/wofi-power-menu.toml".source = ../dotfiles/wofi-power-menu.toml;
    };
  };
}
