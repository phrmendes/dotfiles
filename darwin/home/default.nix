{
  imports = [
    ../../shared/home
    ./symlinks.nix
    ./packages.nix
    ./git.nix
  ];

  home = {
    username = "prochame";
    homeDirectory = "/Users/prochame";
  };
}
