{ config, pkgs, ... }:

let
  user = "phrmendes";
in
{
  home = {
    stateVersion = "22.05";
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      # TERMINAL PROGRAMS
      btop
      pandoc
      bat
      btop
      lazygit
      ripgrep
      fd
      sd
      tealdeer
      exa
      shellcheck
      ncdu
      starship
      micromamba
      neovim
      direnv
      terraform
      terragrunt
      gh
      ranger
      # PACKAGE MANAGERS
      cargo
      go
      nodejs
      # APPS
      podman
      # OTHERS
      texlive.combined.scheme-minimal
    ];
  };

  programs = {
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    fish = {
      enable = true;
      shellAliases = {
        mkdir = "mkdir -p";
        ls = "exa --icons";
        cat = "bat";
        nv = "nvim";
        lg = "lazygit";
        lv = "lvim";
      };
      shellAbbrs = {
        stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
        mamba = "micromamba";
      };
      shellInit = ''
        fish_add_path "$HOME/.emacs.d/bin"
        set -gx MAMBA_EXE "/home/phrmendes/.nix-profile/bin/micromamba"
        set -gx MAMBA_ROOT_PREFIX "/home/phrmendes/micromamba"
        set -gx EDITOR "lvim"
        eval "/home/phrmendes/.nix-profile/bin/micromamba" shell hook --shell fish --prefix "/home/phrmendes/micromamba" | source
      '';
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    home-manager.enable = true;
  };

  xdg.enable = true;
  xdg.mime.enable = true;
  targets.genericLinux.enable = true;
}
