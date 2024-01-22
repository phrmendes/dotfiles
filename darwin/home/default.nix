{parameters, ...}: {
  imports = [
    ../../shared/home
    ./symlinks.nix
    ./packages.nix
    ./git.nix
  ];

  home = {
    username = parameters.user;
    homeDirectory = parameters.home;
  };
}
