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
    ./gtk.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./lazygit.nix
    ./neovim.nix
    ./nm-applet.nix
    ./packages.nix
    ./pyenv.nix
    ./ripgrep.nix
    ./satty.nix
    ./starship.nix
    ./swaylock.nix
    ./swayosd.nix
    ./symlinks.nix
    ./targets.nix
    ./tealdeer.nix
    ./udiskie.nix
    ./walker.nix
    ./waybar.nix
    ./wezterm.nix
    ./wlogout.nix
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
  lazygit.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  packages.enable = lib.mkDefault true;
  ripgrep.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
  symlinks.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  wezterm.enable = lib.mkDefault true;
  yazi.enable = lib.mkDefault true;
  zoxide.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;

  home = {
    stateVersion = "24.05";
    username = parameters.user;
    homeDirectory = parameters.home;
  };
}
