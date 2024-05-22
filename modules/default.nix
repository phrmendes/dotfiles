{
  inputs,
  lib,
  parameters,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.walker
    ./atuin.nix
    ./bat.nix
    ./blueman-applet.nix
    ./btop.nix
    ./direnv.nix
    ./dunst.nix
    ./eza.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gnome-keyring.nix
    ./hyprland.nix
    ./kitty.nix
    ./lazygit.nix
    ./navi.nix
    ./neovim.nix
    ./nm-applet.nix
    ./packages.nix
    ./pyenv.nix
    ./satty.nix
    ./starship.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swayosd.nix
    ./symlinks.nix
    ./targets.nix
    ./tealdeer.nix
    ./udiskie.nix
    ./walker.nix
    ./waybar.nix
    ./wlogout.nix
    ./yazi.nix
    ./zellij.nix
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
  starship.enable = lib.mkDefault true;
  symlinks.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  yazi.enable = lib.mkDefault true;
  zellij.enable = lib.mkDefault true;
  zoxide.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;

  home = {
    stateVersion = "23.11";
    username = parameters.user;
    homeDirectory = parameters.home;
  };
}
