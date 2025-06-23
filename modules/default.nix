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
    ./ghostty.nix
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
    ./sesh.nix
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
    ./wofi.nix
    ./xdg.nix
    ./yazi.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  atuin.enable = lib.mkDefault false;
  bat.enable = lib.mkDefault false;
  blueman-applet.enable = lib.mkDefault false;
  btop.enable = lib.mkDefault false;
  cliphist.enable = lib.mkDefault false;
  direnv.enable = lib.mkDefault false;
  dunst.enable = lib.mkDefault false;
  eza.enable = lib.mkDefault false;
  fd.enable = lib.mkDefault false;
  fzf.enable = lib.mkDefault false;
  gh.enable = lib.mkDefault false;
  ghostty.enable = lib.mkDefault false;
  git.enable = lib.mkDefault false;
  gtk-settings.enable = lib.mkDefault false;
  hypridle.enable = lib.mkDefault false;
  hyprland.enable = lib.mkDefault false;
  hyprlock.enable = lib.mkDefault false;
  hyprpaper.enable = lib.mkDefault false;
  imv.enable = lib.mkDefault false;
  jq.enable = lib.mkDefault false;
  k9s.enable = lib.mkDefault false;
  keepassxc.enable = lib.mkDefault false;
  lazydocker.enable = lib.mkDefault false;
  lazygit.enable = lib.mkDefault false;
  mpv.enable = lib.mkDefault false;
  neovim.enable = lib.mkDefault false;
  nm-applet.enable = lib.mkDefault false;
  packages.enable = lib.mkDefault false;
  pasystray.enable = lib.mkDefault false;
  ripgrep.enable = lib.mkDefault false;
  screenshot.enable = lib.mkDefault false;
  sesh.enable = lib.mkDefault false;
  starship.enable = lib.mkDefault false;
  swayosd.enable = lib.mkDefault false;
  symlinks.enable = lib.mkDefault false;
  syncthingtray.enable = lib.mkDefault false;
  targets.enable = lib.mkDefault false;
  tealdeer.enable = lib.mkDefault false;
  tmux.enable = lib.mkDefault false;
  udiskie.enable = lib.mkDefault false;
  uv.enable = lib.mkDefault false;
  waybar.enable = lib.mkDefault false;
  wofi.enable = lib.mkDefault false;
  yazi.enable = lib.mkDefault false;
  zathura.enable = lib.mkDefault false;
  zoxide.enable = lib.mkDefault false;
  zsh.enable = lib.mkDefault false;

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
