{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
  home-manager = {
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      packages = with pkgs;
        let
          my-r-packages = rWrapper.override{
            packages = with rPackages;
              [
                tidyverse
                data_table
                pbapply
                tinytex
                quarto
                styler
                lintr
                zip
                fs
                janitor
                zoo
                curl
              ];
          };
        in [
          # terminal
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
          ncdu
          quarto
          micromamba
          direnv
          niv
          lorri
          ranger
          gnupg
          stow
          # programming tools
          micromamba
          cargo
          go
          nodejs
          my-r-packages
          # text editors
          neovim
          emacs
          # apps
          firefox
          chromium
          droidcam
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
          # others
          aspellDicts.en
          aspellDicts.pt_BR
          texlive.combined.scheme-minimal
        ];
      stateVersion = "unstable";
      sessionVariables = {
        EDITOR = "neovim";
        TERMINAL = "alacritty";
      };
    };
    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "Pedro Mendes";
        userEmail = "phrmendes@tuta.io";
      };
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
        };
        shellAbbrs = {
          stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
          mamba = "micromamba";
        };
        shellInit = ''
          fish_add_path "$HOME/.emacs.d/bin"
          set -gx MAMBA_EXE "/home/phrmendes/.nix-profile/bin/micromamba"
          set -gx MAMBA_ROOT_PREFIX "/home/phrmendes/micromamba"
          eval "/home/phrmendes/.nix-profile/bin/micromamba" shell hook --shell fish --prefix "/home/phrmendes/micromamba" | source
        '';
      };
      neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          nvim-web-devicons
          nvim-tree-lua
          plenary-nvim
          vim-nix
          vim-fish
          vim-easymotion
          vim-commentary
          vim-gitgutter
          vim-polyglot
          auto-pairs
          fzf-vim
          {
            plugin = gruvbox;
            config = "colorscheme gruvbox";
          }
          {
            plugin = indent-blankline-nvim;
            config = ''
              lua << EOF
              require("indent_blankline").setup()
              EOF
            '';
          }
          {
            plugin = lualine-nvim;
            config = ''
              lua << EOF
              require("lualine").setup({
                  options = {
                  icons_enabled = true,
                  theme = "gruvbox_dark"
                  }
              })
              EOF
            '';
          }
        ];
        extraConfig = ''
          set background=dark
          set clipboard+=unnamedplus
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
    };
    xdg.enable = true;
    xdg.mime.enable = true;
    targets.genericLinux.enable = true;
  }
}
