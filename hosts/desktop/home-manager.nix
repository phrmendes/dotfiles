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
      imports = [
        inputs.walker.homeManagerModules.default
        ../../modules
      ];

      blueman-applet.enable = true;
      btop.enable = true;
      copyq.enable = true;
      dunst.enable = true;
      gnome-keyring.enable = true;
      gtk-settings.enable = true;
      hyprland.enable = true;
      hyprpaper.enable = true;
      network-manager-applet.enable = true;
      pasystray.enable = true;
      satty.enable = true;
      swaylock.enable = true;
      targets.enable = true;
      udiskie.enable = true;
      waybar.enable = true;
      zathura.enable = true;
      walker.enable = true;

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
