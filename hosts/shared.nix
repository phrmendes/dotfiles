{
  inputs,
  ...
}:
{
  imports = with inputs; [
    agenix.nixosModules.default
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    impermanence.nixosModules.impermanence
    stylix.nixosModules.stylix
    (inputs.import-tree ./modules)
  ];

  console.keyMap = "us";
  system.stateVersion = "26.05";
}
