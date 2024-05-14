{inputs, ...}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ./apple.nix
    ./home-manager.nix
    ./homebrew.nix
    ./nix-settings.nix
    ./security.nix
    ./services.nix
    ./shells.nix
    ./users.nix
  ];
}
