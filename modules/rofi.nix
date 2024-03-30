{
  config,
  lib,
  pkgs,
  ...
}: {
  options.rofi.enable = lib.mkEnableOption "enable rofi";

  config = lib.mkIf config.rofi.enable {
    programs.rofi = let
      rofi-calc = pkgs.rofi-calc.override {
        rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
      };
      rofi-emoji = pkgs.rofi-emoji.override {
        rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
      };
    in {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = [rofi-calc rofi-emoji];
      terminal = "${lib.getExe pkgs.kitty}";
      theme = ../dotfiles/rofi/theme.rasi;
      font = "FiraCode Nerd Font Mono 14";
      extraConfig = {
        modi = "drun,window";
        icon-theme = "Pop";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "Apps";
        display-window = "Windows";
        sidebar-mode = true;
      };
    };
  };
}
