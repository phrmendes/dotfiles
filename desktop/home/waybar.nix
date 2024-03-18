{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    style = builtins.readFile ../../dotfiles/waybar/style.css;
    settings = builtins.fromJSON (builtins.readFile ../../dotfiles/waybar/config.json);
    systemd.enable = true;
  };
}
