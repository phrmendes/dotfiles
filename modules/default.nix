{
  lib,
  parameters,
  ...
}: {
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./copyq.nix
    ./dconf.nix
    ./direnv.nix
    ./eza.nix
    ./flameshot.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gnome-keyring.nix
    ./kitty.nix
    ./lazygit.nix
    ./navi.nix
    ./neovim.nix
    ./packages.nix
    ./pyenv.nix
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

  atuin.enable = lib.mkDefault true;
  bat.enable = lib.mkDefault true;
  direnv.enable = lib.mkDefault true;
  eza.enable = lib.mkDefault true;
  fzf.enable = lib.mkDefault true;
  gh.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  kitty.enable = lib.mkDefault true;
  lazygit.enable = lib.mkDefault true;
  navi.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  packages.enable = lib.mkDefault true;
  ripgrep.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
  symlinks.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  yazi.enable = lib.mkDefault true;
  zoxide.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;

  home = {
    stateVersion = "24.05";
    username = parameters.user;
    homeDirectory = parameters.home;
  };
}
