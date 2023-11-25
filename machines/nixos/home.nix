{
  imports = [
    ../../modules/bat.nix
    ../../modules/direnv.nix
    ../../modules/fzf.nix
    ../../modules/git.nix
    ../../modules/lazygit.nix
    ../../modules/neovim.nix
    ../../modules/starship.nix
    ../../modules/tmux.nix
    ../../modules/zoxide.nix
    ../../modules/zsh.nix
    ./modules/btop.nix
    ./modules/copyq.nix
    ./modules/dconf.nix
    ./modules/dotfiles.nix
    ./modules/gtk.nix
    ./modules/home-manager.nix
    ./modules/packages.nix
    ./modules/xdg.nix
  ];
  targets.genericLinux.enable = true;
  home = {
    username = "phrmendes";
    homeDirectory = "/home/phrmendes";
    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      TERM = "wezterm";
      VISUAL = "nvim";
    };
  };
}
