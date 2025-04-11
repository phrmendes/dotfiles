{
  lib,
  config,
  ...
}:
{
  options.wezterm.enable = lib.mkEnableOption "enable wezterm";

  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ../dotfiles/wezterm.lua;
    };
  };
}
