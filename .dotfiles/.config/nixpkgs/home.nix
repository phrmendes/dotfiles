{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
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
      gh
      lazygit
      ripgrep
      fd
      sd
      tealdeer
      exa
      shellcheck
      alacritty
      ncdu
      starship
      quarto
      micromamba
      # PACKAGE MANAGERS
      flatpak
      cargo
      go
      nodejs
      # APPS
      emacs
      droidcam
      filezilla
      solaar
      bitwarden
      pcloud
      zotero
      spotify
      fragments
      kooha
      podman
      zathura
      cmdstan
      celluloid
      # OTHERS
      texlive.combined.scheme-minimal
    ];
  };

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      dirHashes = { proj = "$HOME/Projects" };
      shellAliases = {
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        mkdir = "mkdir -p";
        ls = "exa --icons";
        cat = "bat";
        stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
        nv = "nvim";
        lg = "lazygit";
      };
     };
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
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
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    home-manager.enable = true;
  };
}
