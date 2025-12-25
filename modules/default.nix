{ parameters, lib, ... }:
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./copyq.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fish.nix
    ./flameshot.nix
    ./fzf.nix
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./gtk.nix
    ./imv.nix
    ./jq.nix
    ./k9s.nix
    ./keepassxc.nix
    ./keychain.nix
    ./lazydocker.nix
    ./lazygit.nix
    ./mpv.nix
    ./neovim.nix
    ./opencode.nix
    ./packages.nix
    ./ripgrep.nix
    ./symlinks.nix
    ./syncthingtray.nix
    ./targets.nix
    ./tealdeer.nix
    ./xdg.nix
    ./yazi.nix
    ./zathura.nix
    ./zellij.nix
    ./zoxide.nix
  ];

  qt.platformTheme.name = lib.mkForce "adwaita";

  home = {
    stateVersion = "25.11";
    username = parameters.user;
    homeDirectory = parameters.home;
    sessionVariables = {
      GIT_EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "ghostty";
    };
  };
}
