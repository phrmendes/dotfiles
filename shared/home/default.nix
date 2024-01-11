{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./kitty.nix
    ./lazygit.nix
    ./neovim.nix
    ./shells.nix
    ./starship.nix
    ./symlinks.nix
    ./tealdeer.nix
    ./zoxide.nix
  ];

  home = {
    stateVersion = "23.11";
    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "kitty";
    };
  };
}
