{pkgs, ...}: {
  imports = [
    ./apple.nix
    ./homebrew.nix
  ];
  environment.systemPackages = [pkgs.home-manager];
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  users.users.prochame = {
    home = "/Users/prochame";
    shell = pkgs.zsh;
  };
}
