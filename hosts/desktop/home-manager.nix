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
      gnome-keyring.enable = true;
      gtk-manager.enable = true;
      hyprland.enable = true;
      nm-applet.enable = true;
      nwg.enable = true;
      swaylock.enable = true;
      swaync.enable = true;
      swayosd.enable = true;
      targets.enable = true;
      udiskie.enable = true;
      walker.enable = true;
    };
  };
}
