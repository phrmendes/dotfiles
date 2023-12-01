{
  imports = [
    ../../shared/home
    ./btop.nix
    ./copyq.nix
    ./dconf.nix
    ./flameshot.nix
    ./home-manager.nix
    ./packages.nix
    ./sioyek.nix
    ./symlinks.nix
    ./xdg.nix
  ];
  targets.genericLinux.enable = true;
  home = {
    username = "phrmendes";
    homeDirectory = "/home/phrmendes";
    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      TERM = "wezterm";
      VISUAL = "nvim";
    };
  };
}
