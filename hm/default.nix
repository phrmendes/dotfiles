{ parameters, lib, ... }:

{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./blueman-applet.nix
    ./btop.nix
    ./copyq.nix
    ./direnv.nix
    ./dunst.nix
    ./eza.nix
    ./fd.nix
    ./flameshot.nix
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
    ./keychain.nix
    ./kitty.nix
    ./lazydocker.nix
    ./lazygit.nix
    ./mpv.nix
    ./neovim.nix
    ./nm-applet.nix
    ./opencode.nix
    ./packages.nix
    ./pasystray.nix
    ./ripgrep.nix
    ./starship.nix
    ./swayosd.nix
    ./symlinks.nix
    ./syncthingtray.nix
    ./targets.nix
    ./tealdeer.nix
    ./udiskie.nix
    ./waybar.nix
    ./wofi.nix
    ./xdg.nix
    ./yazi.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  qt.platformTheme.name = lib.mkForce "adwaita";

  home = {
    stateVersion = "26.05";
    username = parameters.user;
    homeDirectory = parameters.home;
    sessionVariables = {
      GIT_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
    };
  };
}
