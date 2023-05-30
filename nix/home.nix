{
  config,
  pkgs,
  ...
}: let
  user = "phrmendes";
in {
  imports = [
    ./modules/direnv.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/lazygit.nix
    ./modules/neovim.nix
    ./modules/packages.nix
    ./modules/starship.nix
    ./modules/symlinks.nix
    ./modules/tmux.nix
    ./modules/zoxide.nix
    ./modules/zsh.nix
  ];
  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.11";
    sessionVariables = {
      VISUAL = "${pkgs.neovim}/bin/nvim";
      TERMINAL = "/usr/bin/wezterm";
      SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
}
