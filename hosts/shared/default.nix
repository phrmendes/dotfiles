{
  inputs,
  parameters,
  ...
}:
{
  imports = with inputs; [
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    impermanence.nixosModules.impermanence
    stylix.nixosModules.stylix
    (import ./disko.nix { inherit (parameters) device; })
    ./boot.nix
    ./duplicati.nix
    ./file-systems.nix
    ./hardware.nix
    ./home-manager.nix
    ./i18n.nix
    ./impermanence.nix
    ./networking.nix
    ./nix.nix
    ./nixpkgs.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./session-variables.nix
    ./stylix.nix
    ./syncthing.nix
    ./system-packages.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
    ./xdg.nix
  ];

  console.keyMap = "us";
  system.stateVersion = "25.05";
}
