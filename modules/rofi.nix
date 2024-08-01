{
  config,
  lib,
  pkgs,
  ...
}: {
  options.rofi.enable = lib.mkEnableOption "enable rofi";

  config = lib.mkIf config.rofi.enable {
    programs.rofi = let
      inherit (lib) getExe;
      kitty = getExe pkgs.kitty;
    in {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${kitty}";
      font = lib.mkForce "JetBrainsMono Nerd Font 14";
      extraConfig = {
        display-drun = " 󰀻 ";
        display-recursivebrowser = "  ";
        display-run = "  ";
        display-window = " 󱂬 ";
        drun-display-format = " {icon} {name}";
        line-margin = 10;
        modi = "drun,window,recursivebrowser";
        run-command = "{cmd}";
        run-shell-command = "{terminal} -e {cmd}";
        show-icons = true;
        sidebar-mode = true;
      };
    };
  };
}
