{ inputs, ... }:
{
  imports = with inputs; [
    agenix.nixosModules.default
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    impermanence.nixosModules.impermanence
    ./age.nix
    ./boot.nix
    ./disko.nix
    ./filesystems.nix
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
    ./system-packages.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
  ];

  console.keyMap = "us";
  system.stateVersion = "25.05";
}
