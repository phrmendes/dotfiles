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
      dconf-settings.enable = true;
      gtk-settings.enable = true;
      impermanence.enable = true;
      targets.enable = true;
    };
  };
}
