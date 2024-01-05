{
  imports = [
    ../../shared/home
    ./btop.nix
    ./copyq.nix
    ./dconf.nix
    ./flameshot.nix
    ./gtk.nix
    ./home-manager.nix
    ./packages.nix
    ./sioyek.nix
    ./symlinks.nix
  ];

  targets.genericLinux.enable = true;

  home = {
    username = "phrmendes";
    homeDirectory = "/home/phrmendes";
  };
}
