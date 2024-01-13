{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./helix.nix
    ./kitty.nix
    ./lazygit.nix
    ./shells.nix
    ./starship.nix
    ./symlinks.nix
    ./tealdeer.nix
    ./vscode.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  home = {
    stateVersion = "23.11";
    sessionVariables = {
      EDITOR = "${pkgs.helix}/bin/hx";
      GIT_EDITOR = "${pkgs.helix}/bin/hx";
      SUDO_EDITOR = "${pkgs.helix}/bin/hx";
      VISUAL = "${pkgs.helix}/bin/hx";
      TERM = "xterm-kitty";
    };
  };
}
