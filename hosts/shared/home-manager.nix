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
        inputs.plasma-manager.homeManagerModules.plasma-manager
        ../../modules
      ];
    };
  };
}
