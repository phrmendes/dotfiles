{ parameters, ... }:
{
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
    ./hyprlock.nix
    ./hyprpaper.nix
    ./k9s.nix
    ./kitty.nix
    ./lazygit.nix
    ./mpv.nix
    ./neovim.nix
    ./nm-applet.nix
    ./packages.nix
    ./pasystray.nix
    ./ripgrep.nix
    ./starship.nix
    ./swayosd.nix
    ./symlinks.nix
    ./targets.nix
    ./tealdeer.nix
    ./udiskie.nix
    ./waybar.nix
    ./wofi.nix
    ./yazi.nix
    ./zathura.nix
    ./zellij.nix
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
  hyprlock.enable = true;
  hyprpaper.enable = true;
  k9s.enable = true;
  kitty.enable = true;
  lazygit.enable = true;
  mpv.enable = true;
  neovim.enable = true;
  nm-applet.enable = true;
  packages.enable = true;
  pasystray.enable = true;
  ripgrep.enable = true;
  starship.enable = true;
  swayosd.enable = true;
  symlinks.enable = true;
  targets.enable = true;
  tealdeer.enable = true;
  udiskie.enable = true;
  waybar.enable = true;
  wofi.enable = true;
  yazi.enable = true;
  zathura.enable = true;
  zellij.enable = true;
  zoxide.enable = true;
  zsh.enable = true;

  home = {
    stateVersion = "25.05";
    username = parameters.user;
    homeDirectory = parameters.home;
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "application/xhtml+xml" = [ "vivaldi.desktop" ];
        "inode/directory" = [ "org.gnome.gnome-commander.desktop" ];
        "text/html" = [ "vivaldi.desktop" ];
        "x-scheme-handler/http" = [ "vivaldi.desktop" ];
        "x-scheme-handler/https" = [ "vivaldi.desktop" ];
        "audio/*" = [ "mpv.desktop" ];
        "image/*" = [ "nomacs.desktop" ];
        "text/*" = [ "neovide.desktop" ];
        "video/*" = [ "mpv.desktop" ];
      };
    };
  };
}
