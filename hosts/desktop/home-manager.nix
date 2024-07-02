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

      blueman-applet.enable = true;
      btop.enable = true;
      dunst.enable = true;
      gnome-keyring.enable = true;
      hypridle.enable = true;
      hyprland.enable = true;
      hyprpaper.enable = true;
      nm-applet.enable = true;
      satty.enable = true;
      swaylock.enable = true;
      swayosd.enable = true;
      targets.enable = true;
      udiskie.enable = true;
      walker.enable = true;
      waybar.enable = true;
      wlogout.enable = true;

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
