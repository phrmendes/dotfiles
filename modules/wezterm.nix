{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  options.wezterm.enable = lib.mkEnableOption "enable wezterm";

  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      enableBashIntegration = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ../dotfiles/wezterm.lua;
    };
  };
}
