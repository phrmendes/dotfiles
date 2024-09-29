{parameters, ...}: {
  imports = [
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gnome-keyring.nix
    ./gtk.nix
    ./kitty.nix
    ./lazygit.nix
    ./neovim.nix
    ./packages.nix
    ./ripgrep.nix
    ./starship.nix
    ./symlinks.nix
    ./targets.nix
    ./tealdeer.nix
    ./tmux.nix
    ./yazi.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  bat.enable = true;
  btop.enable = true;
  direnv.enable = true;
  eza.enable = true;
  fzf.enable = true;
  gh.enable = true;
  git.enable = true;
  gnome-keyring.enable = true;
  gtk-settings.enable = true;
  kitty.enable = true;
  lazygit.enable = true;
  neovim.enable = true;
  packages.enable = true;
  ripgrep.enable = true;
  starship.enable = true;
  symlinks.enable = true;
  targets.enable = true;
  tealdeer.enable = true;
  tmux.enable = true;
  yazi.enable = true;
  zoxide.enable = true;
  zsh.enable = true;

  home = {
    stateVersion = "24.05";
    username = parameters.user;
    homeDirectory = parameters.home;
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
