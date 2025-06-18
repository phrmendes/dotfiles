{
  parameters,
  lib,
  ...
}:
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./blueman-applet.nix
    ./btop.nix
    ./cliphist.nix
    ./direnv.nix
    ./dunst.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gtk.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./imv.nix
    ./jq.nix
    ./k9s.nix
    ./keepassxc.nix
    ./lazydocker.nix
    ./lazygit.nix
    ./mpv.nix
    ./neovim.nix
    ./nm-applet.nix
    ./packages.nix
    ./pasystray.nix
    ./ripgrep.nix
    ./screenshot.nix
    ./starship.nix
    ./swayosd.nix
    ./symlinks.nix
    ./syncthingtray.nix
    ./targets.nix
    ./tealdeer.nix
    ./tmux.nix
    ./udiskie.nix
    ./uv.nix
    ./waybar.nix
    ./wezterm.nix
    ./wofi.nix
    ./xdg.nix
    ./yazi.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  atuin.enable = lib.mkDefault true;
  bat.enable = lib.mkDefault true;
  blueman-applet.enable = lib.mkDefault true;
  btop.enable = lib.mkDefault true;
  cliphist.enable = lib.mkDefault true;
  direnv.enable = lib.mkDefault true;
  dunst.enable = lib.mkDefault true;
  eza.enable = lib.mkDefault true;
  fd.enable = lib.mkDefault true;
  fzf.enable = lib.mkDefault true;
  gh.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  gtk-settings.enable = lib.mkDefault true;
  hypridle.enable = lib.mkDefault true;
  hyprland.enable = lib.mkDefault true;
  hyprlock.enable = lib.mkDefault true;
  hyprpaper.enable = lib.mkDefault true;
  imv.enable = lib.mkDefault true;
  jq.enable = lib.mkDefault true;
  k9s.enable = lib.mkDefault true;
  keepassxc.enable = lib.mkDefault true;
  lazydocker.enable = lib.mkDefault true;
  lazygit.enable = lib.mkDefault true;
  mpv.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  nm-applet.enable = lib.mkDefault true;
  packages.enable = lib.mkDefault true;
  pasystray.enable = lib.mkDefault true;
  ripgrep.enable = lib.mkDefault true;
  screenshot.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
  swayosd.enable = lib.mkDefault true;
  symlinks.enable = lib.mkDefault true;
  syncthingtray.enable = lib.mkDefault true;
  targets.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  udiskie.enable = lib.mkDefault true;
  uv.enable = lib.mkDefault true;
  waybar.enable = lib.mkDefault true;
  wezterm.enable = lib.mkDefault true;
  wofi.enable = lib.mkDefault true;
  yazi.enable = lib.mkDefault true;
  zathura.enable = lib.mkDefault true;
  zoxide.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;

  home = {
    stateVersion = "25.05";
    username = parameters.user;
    homeDirectory = parameters.home;
    sessionVariables = {
      GIT_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
