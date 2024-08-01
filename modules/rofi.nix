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
    };
  };
}
