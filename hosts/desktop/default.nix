{
  inputs,
  parameters,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.stylix.nixosModules.stylix
    (import ./disko.nix {inherit (parameters) device;})
    ./boot.nix
    ./file-systems.nix
    ./hardware.nix
    ./home-manager.nix
    ./i18n.nix
    ./impermanence.nix
    ./networking.nix
    ./nix-settings.nix
    ./packages.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./session-variables.nix
    ./syncthing.nix
    ./systemd.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
    ./xdg.nix
    ../shared/stylix.nix
  ];

  console.keyMap = "us";
  system.stateVersion = "24.05";
}
