{
  inputs,
  parameters,
  ...
}: {
  imports = [
    ../../shared/home
    ./btop.nix
    ./copyq.nix
    ./dconf.nix
    ./flameshot.nix
    ./gtk.nix
    ./home-manager.nix
    ./packages.nix
  ];

  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;

  home = {
    username = parameters.user;
    homeDirectory = parameters.home;
  };
}
