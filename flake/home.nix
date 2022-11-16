{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      # TERMINAL
      btop
      pandoc
      bat
      btop
      gh
      lazygit
      ripgrep
      fd
      sd
      tealdeer
      exa
      shellcheck
      automake
      cmake
      alacritty
      ncdu
      gnupg
      starship
      file
      procps
      # TEXT EDITORS
      neovim
      emacs
      # PACKAGE MANAGERS
      flatpak
      cargo
      go
      nodejs
      # FILE MANAGERS
      thunar-archive-plugin
      filezilla
      # APPS
      droidcam
      keepassxc
      solaar
      stremio
      tutanota
      bitwarden
      pcloud
      onlyoffice-bin
      zotero
      spotify
      fragments
      kooha
      podman
      zathura
      # TWM APPS
      sxhkd
      rofi
      compton
      # OTHERS
      aspellDicts.en
      aspellDicts.pt_BR
      texlive.combined.scheme-minimal
    ];
    pointerCursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "neovim";
    };
  };

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        mkdir = "mkdir -p";
        ls = "exa --icons";
        cat = "bat";
      };
      shellAbbrs = {
        nv = "nvim";
        lg = "lazygit";
      };
      shellInit = ''
        set -gx STARSHIP_CONFIG "$HOME"/.config/starship/starship.toml
        starship init fish | source
      '';
      plugins = [
        {
          name = "nix-env";
          src = pkgs.fetchFromGitHub {
            owner = "lilyball";
            repo = "nix-env.fish";
            sha256 = "0000000000000000000000000000000000000000000000000000";
          };
        }

        {
          name = "autopair.fish";
          src = pkgs.fetchFromGithub {
            owner = "jorgebucaran";
            repo = "autopair.fish";
            sha256 = "0000000000000000000000000000000000000000000000000000";
          };
        }

        {
          name = "fzf";
          src = pkgs.fetchFromGithub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            sha256 = "0000000000000000000000000000000000000000000000000000";
          };
        }
      ];
    };
    bat = {
      enable = true;
      config = {
        theme = "GitHub";
        italic-text = "always";
    };
    git = {
      enable = true;
      userName = "Pedro Mendes";
      userEmail = "phrmendes@tuta.io";
    };

    home-manager.enable = true;
  };

  gtk = {
    enable = true;
    font.name = "SauceCodePro Nerd Font";
  };
}
