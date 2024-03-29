{
  config,
  lib,
  pkgs,
  ...
}: {
  options.rofi.enable = lib.mkEnableOption "enable rofi";

  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
      ];
      terminal = "kitty";
      theme = ../dotfiles/rofi/theme.rasi;
      font = "Fira Sans 14";
      extraConfig = {
        modi = "run,drun,window";
        icon-theme = "Pop";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps  ";
        display-run = "   Run  ";
        display-window = "   Window  ";
        sidebar-mode = true;
      };
    };
  };
}
