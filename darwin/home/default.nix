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
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
  programs = {
    git.userEmail = lib.mkForce "pedrohrmendes@proton.me";
  };
}
