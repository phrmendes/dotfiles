let
  inherit (import ./parameters.nix) username;
in {
  imports = [
    ./modules/bat.nix
    ./modules/btop.nix
    ./modules/copyq.nix
    ./modules/direnv.nix
    ./modules/flameshot.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/home-manager.nix
    ./modules/lazygit.nix
    ./modules/neovim.nix
    ./modules/packages.nix
    ./modules/starship.nix
    ./modules/symlinks.nix
    ./modules/tmux.nix
    ./modules/zathura.nix
    ./modules/zoxide.nix
    ./modules/zsh.nix
  ];
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      TERM = "wezterm";
      TERMINAL = "flatpak run org.wezfurlong.wezterm";
      VISUAL = "nvim";
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
}
