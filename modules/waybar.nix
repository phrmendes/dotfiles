{
  config,
  lib,
  ...
}: {
  options.waybar.enable = lib.mkEnableOption "enable waybar";

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      style = builtins.readFile ../dotfiles/waybar/style.css;
      settings = builtins.fromJSON (builtins.readFile ../dotfiles/waybar/config.json);
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
    };
  };
}
