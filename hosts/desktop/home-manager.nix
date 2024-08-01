{
  inputs,
  parameters,
  pkgs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {inherit inputs pkgs parameters;};
    users.${parameters.user} = {
      imports = [../../modules];

      btop.enable = true;
      copyq.enable = true;
      dunst.enable = true;
      gnome-keyring.enable = true;
      gtk-settings.enable = true;
      hyprland.enable = true;
      hyprpaper.enable = true;
      rofi.enable = true;
      satty.enable = true;
      swaylock.enable = true;
      swayosd.enable = true;
      targets.enable = true;
      udiskie.enable = true;
      wlogout.enable = true;
      waybar.enable = true;

      xdg.desktopEntries = {
        obsidian = {
          name = "Obsidian";
          exec = "obsidian --disable-gpu";
          icon = "obsidian";
        };
      };
    };
  };
}
