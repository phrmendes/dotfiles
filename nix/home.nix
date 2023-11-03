let
  inherit (import ./parameters.nix) username;
in
{
  imports = [
    ./modules/bat.nix
    ./modules/btop.nix
    ./modules/copyq.nix
    ./modules/direnv.nix
    ./modules/flameshot.nix
    ./modules/fzf.nix
    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/helix.nix
    ./modules/home-manager.nix
    ./modules/joshuto.nix
    ./modules/lazygit.nix
    ./modules/packages.nix
    ./modules/starship.nix
    ./modules/symlinks.nix
    ./modules/vscode.nix
    ./modules/xdg.nix
    ./modules/zellij.nix
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
      EDITOR = "hx";
      SUDO_EDITOR = "hx";
      VISUAL = "hx";
    };
  };
}
