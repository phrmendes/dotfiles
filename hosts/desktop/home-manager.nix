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
      dconf-settings.enable = true;
      flameshot.enable = true;
      gnome-keyring.enable = true;
      targets.enable = true;

      xdg.desktopEntries.obsidian = {
        name = "Obsidian";
        exec = "obsidian --disable-gpu";
        icon = "obsidian";
      };
    };
  };
}
