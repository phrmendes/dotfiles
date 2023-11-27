{lib, ...}: {
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
    ./modules/dotfiles.nix
    ./modules/packages.nix
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
