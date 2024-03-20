{
  inputs,
  parameters,
  pkgs,
  ...
}: {
  imports = [
    ../../shared/home
    ./blueman.nix
    ./btop.nix
    ./copyq.nix
    ./dunst.nix
    ./gtk.nix
    ./home-manager.nix
    ./hyprland.nix
    ./network-manager.nix
    ./packages.nix
    ./pasystray.nix
    ./rofi.nix
    ./swayidle.nix
    ./swaylock.nix
    ./udiskie.nix
    ./waybar.nix
  ];

  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;

  home = {
    username = parameters.user;
    homeDirectory = parameters.home;
  };
}
