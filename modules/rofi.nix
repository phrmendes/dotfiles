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
      wezterm = getExe pkgs.wezterm;
    in {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${wezterm}";
      font = lib.mkForce "${config.stylix.fonts.monospace.name} 14";
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
