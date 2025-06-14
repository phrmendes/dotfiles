{ parameters, ... }:
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

  atuin.enable = true;
  bat.enable = true;
  blueman-applet.enable = true;
  btop.enable = true;
  cliphist.enable = true;
  direnv.enable = true;
  dunst.enable = true;
  eza.enable = true;
  fd.enable = true;
  fzf.enable = true;
  gh.enable = true;
  ghostty.enable = true;
  git.enable = true;
  gtk-settings.enable = true;
  hypridle.enable = true;
  hyprland.enable = true;
  hyprlock.enable = true;
  hyprpaper.enable = true;
  imv.enable = true;
  jq.enable = true;
  k9s.enable = true;
  keepassxc.enable = true;
  lazydocker.enable = true;
  lazygit.enable = true;
  mpv.enable = true;
  neovim.enable = true;
  nm-applet.enable = true;
  packages.enable = true;
  pasystray.enable = true;
  ripgrep.enable = true;
  screenshot.enable = true;
  starship.enable = true;
  swayosd.enable = true;
  symlinks.enable = true;
  syncthingtray.enable = true;
  targets.enable = true;
  tealdeer.enable = true;
  tmux.enable = true;
  udiskie.enable = true;
  uv.enable = true;
  waybar.enable = true;
  wofi.enable = true;
  yazi.enable = true;
  zathura.enable = true;
  zoxide.enable = true;
  zsh.enable = true;

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
