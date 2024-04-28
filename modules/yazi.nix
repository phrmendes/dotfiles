{
  lib,
  config,
  ...
}: {
  options.yazi.enable = lib.mkEnableOption "enable yazi";

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    home.file = {
      ".config/yazi/theme.toml".source = ../dotfiles/yazi/theme.toml;
    };
  };
}
