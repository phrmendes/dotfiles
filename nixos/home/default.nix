{
  imports = [
    ../../shared/home
    ./btop.nix
    ./dconf.nix
    ./symlinks.nix
    ./flameshot.nix
    ./home-manager.nix
    ./packages.nix
    ./xdg.nix
    ./sioyek.nix
  ];
  targets.genericLinux.enable = true;
  home = {
    username = "phrmendes";
    homeDirectory = "/home/phrmendes";
    stateVersion = "23.05";
    sessionVariables = {
      SUDO_EDITOR = "nvim";
    };
  };
}
