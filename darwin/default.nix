{
  parameters,
  pkgs,
  ...
}: {
  imports = [
    ./apple.nix
    ./homebrew.nix
  ];
  environment.systemPackages = [pkgs.home-manager];
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  users.users.${parameters.user} = {
    inherit (parameters) home;
    shell = pkgs.zsh;
  };
}
