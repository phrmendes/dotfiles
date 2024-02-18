{parameters, ...}: {
  imports = [
    ./symlinks.nix
  ];

  targets.genericLinux.enable = true;

  home = {
    username = parameters.user;
    homeDirectory = parameters.home;
  };
}
