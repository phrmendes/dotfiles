{
  lib,
  config,
  ...
}: {
  options.zellij.enable = lib.mkEnableOption "enable zellij";

  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
    };

    xdg.configFile = {
      "zellij/config.kdl".source = ../dotfiles/zellij.kdl;
    };
  };
}
