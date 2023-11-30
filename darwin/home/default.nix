{lib, ...}: {
  imports = [
    ../../shared/home
    ./symlinks.nix
    ./packages.nix
  ];
  home = {
    username = "prochame";
    homeDirectory = "/Users/prochame";
    stateVersion = "23.05";
    sessionVariables = {
      SUDO_EDITOR = "nvim";
    };
  };
  programs = {
    git.userEmail = lib.mkForce "pedro.mendes-ext@ab-inbev.com";
  };
}
