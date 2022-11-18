{ config, pkgs, ... }:

let
  user = "phrmendes";
  my-python-packages = python-packages: with python-packages; [
    pandas
    matplotlib
    numpy
    scipy
    scikit-learn
    pyarrow
    sympy
  ];
  python-with-my-packages = python310.withPackages my-python-packages;
  my-r-packages = rWrapper.override{
    packages = with rPackages;
      [
        tidyverse
        data_table
        quarto
        janitor
        pbapply
        styler
        lintr
        fs
        distill
        tinytex
        languageserver
        writexl
        arrow
        duckdb
        devtools
        usethis
        assertthat
        testthat
      ];
    };
  };
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
      quarto
      # FISH
      fish
      fishPlugins.fzf-fish
      fishPlugins.autopair-fish
      # TEXT EDITORS
      neovim
      emacs
      # PACKAGE MANAGERS
      flatpak
      cargo
      go
      nodejs
      # FILE MANAGERS
      filezilla
      # APPS
      droidcam
      keepassxc
      solaar
      stremio
      tutanota-desktop
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
      # R PACKAGES
      my-r-packages
      # PYTHON PACKAGES
      python-with-my-packages
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
    };
    git = {
      enable = true;
      userName = "Pedro Mendes";
      userEmail = "phrmendes@tuta.io";
    };
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-fish
        vim-easymotion
        vim-commentary
        lightline-vim
        nerdcommenter
        ack-vim
        vim-gitgutter
        auto-pairs
        fzf-vim
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
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    home-manager.enable = true;
  };
}
