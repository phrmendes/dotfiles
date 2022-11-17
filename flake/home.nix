{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = import (fetchTarball "https://github.com/quarto-dev/quarto-cli/releases/download/v1.2.269/quarto-1.2.269-linux-amd64.tar.gz");
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
      fish
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
      cmdstan
      # BASIC R PACKAGES
      rPackages.tidyverse
      rPackages.data_table
      rPackages.quarto
      rPackages.janitor
      rPackages.pbapply
      rPackages.styler
      rPackages.lintr
      rPackages.fs
      rPackages.distill
      rPackages.tinytex
      rPackages.languageserver
      rPackages.writexl
      rPackages.arrow
      rPackages.duckdb
      rPackages.devtools
      rPackages.usethis
      rPackages.assertthat
      rPackages.testthat
      # BASIC PYTHON PACKAGES
      python310Packages.pandas
      python310Packages.polars
      python310Packages.matplotlib
      python310Packages.numpy
      python310Packages.scipy
      python310Packages.scikit-learn
      python310Packages.pyarrow
      python310Packages.sympy
      # OTHERS
      aspellDicts.en
      aspellDicts.pt_BR
      texlive.combined.scheme-minimal
    ];
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
    git = {
      enable = true;
      userName = "Pedro Mendes";
      userEmail = "phrmendes@tuta.io";
    };
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-easymotion
        vim-commentary
        lightline.vim
        nerdcommenter
        ack.vim
        vim-gitgutter
        auto-pairs
        fzf.vim
        vim-polyglot
      ];
      extraConfig = ''
        set background=dark
        set clipboard=unnamedplus
        set completeopt=noinsert,menuone,noselect
        set cursorline
        set hidden
        set inccommand=split
        set mouse=a
        set number
        set relativenumber
        set splitbelow splitright
        set title
        set ttimeoutlen=0
        set wildmenu
        set expandtab
        set shiftwidth=2
        set tabstop=2
      '';
      vimAlias = true;
      vimdiffAlias = true;
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 15;
            y = 15;
          };
          class = {
            instance = "Alacritty";
            general = "Alacritty";
          };
          opacity = 1;
        };
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        font = {
          normal = {
            family = "SauceCodePro Nerd Font";
            style = "Medium";
          };
          bold = {
            family = "SauceCodePro Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "SauceCodePro Nerd Font";
            style = "MediumItalic";
          };
          bold_italic = {
            family = "SauceCodePro Nerd Font";
            style = "BoldItalic";
          };
          size = 13;
        };
        draw_bold_text_with_bright_colors = true;
        selection.save_to_clipboard = true;
        shell.program = "${pkgs.fish}/bin/fish";
        colors = {
          primary = {
            background = "0x282828";
            foreground = "0xebdbb2";
          };
          normal = {
            black = "0x282828";
            red = "0xcc241d";
            green = "0x98971a";
            yellow = "0xd79921";
            blue = "0x458588";
            magenta = "0xb16286";
            cyan = "0x689d6a";
            white = "0xa89984";
          };
          bright = {
            black = "0x928374";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xebdbb2";
          };
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    home-manager.enable = true;
  };
}
