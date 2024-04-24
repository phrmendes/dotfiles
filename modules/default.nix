{
  lib,
  parameters,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./dconf.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./gtk.nix
    ./impermanence.nix
    ./kitty.nix
    ./lazygit.nix
    ./navi.nix
    ./neovim.nix
    ./packages.nix
    ./persistence.nix
    ./pyenv.nix
    ./starship.nix
    ./symlinks.nix
    ./targets.nix
    ./tealdeer.nix
    ./thefuck.nix
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
  git.enable = lib.mkDefault true;
  kitty.enable = lib.mkDefault true;
  lazygit.enable = lib.mkDefault true;
  navi.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  packages.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
  symlinks.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  thefuck.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  yazi.enable = lib.mkDefault true;
  zoxide.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;

  home = {
    stateVersion = "23.11";
    username = parameters.user;
    homeDirectory = parameters.home;
  };

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
    GIT_EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    VISUAL = "nvim";
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
  };
}
