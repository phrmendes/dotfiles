{
  inputs,
  parameters,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./fonts.nix
    ./hardware.nix
    ./home-manager.nix
    ./i18n.nix
    ./networking.nix
    ./nix-settings.nix
    ./packages.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./syncthing.nix
    ./time.nix
    ./users.nix
    ./virtualisation.nix
  ];

  console.keyMap = "us";
  sound.enable = true;
  system.stateVersion = "23.11";
  xdg.portal.enable = true;
}
