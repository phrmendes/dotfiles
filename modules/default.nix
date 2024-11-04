{parameters, ...}: {
  imports = [
    ./bat.nix
    ./blueman-applet.nix
    ./btop.nix
    ./cliphist.nix
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
    ./k9s.nix
    ./kitty.nix
    ./lazygit.nix
    ./neovim.nix
    ./nm-applet.nix
    ./packages.nix
    ./pasystray.nix
    ./ripgrep.nix
    ./starship.nix
    ./swaylock.nix
    ./symlinks.nix
    ./targets.nix
    ./tealdeer.nix
    ./udiskie.nix
    ./waybar.nix
    ./wofi.nix
    ./xdg.nix
    ./xwaylandvideobridge.nix
    ./yazi.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  bat.enable = true;
  blueman-applet.enable = true;
  btop.enable = true;
  cliphist.enable = true;
  direnv.enable = true;
  dunst.enable = true;
  eza.enable = true;
  fzf.enable = true;
  gh.enable = true;
  git.enable = true;
  gnome-keyring.enable = true;
  gtk-settings.enable = true;
  hypridle.enable = true;
  hyprland.enable = true;
  hyprpaper.enable = true;
  k9s.enable = true;
  kitty.enable = true;
  lazygit.enable = true;
  neovim.enable = true;
  nm-applet.enable = true;
  packages.enable = true;
  pasystray.enable = true;
  ripgrep.enable = true;
  starship.enable = true;
  swaylock.enable = true;
  symlinks.enable = true;
  targets.enable = true;
  tealdeer.enable = true;
  udiskie.enable = true;
  waybar.enable = true;
  wofi.enable = true;
  xwaylandvideobridge.enable = true;
  yazi.enable = true;
  zoxide.enable = true;
  zsh.enable = true;

  home = {
    stateVersion = "24.05";
    username = parameters.user;
    homeDirectory = parameters.home;
    sessionVariables = {
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      XDG_CURRENT_DESKTOP = "hyprland";
      XDG_SESSION_DESKTOP = "hyprland";
      XDG_SESSION_TYPE = "wayland";
      TERMINAL = "kitty";
    };
  };
}
