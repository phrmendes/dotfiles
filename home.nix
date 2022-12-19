{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
  home-manager.users.${user} = {
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
          gh
          lazygit
          ripgrep
          fd
          sd
          tealdeer
          shellcheck
          ncdu
          quarto
          micromamba
          niv
          lorri
          ranger
          stow
          ispell
          # programming tools
          micromamba
          python3Full
          cargo
          go
          nodejs
          my-r-packages
          # apps
          firefox
          chromium
          bitwarden
          pcloud
          zotero
          spotify
          fragments
          podman
          zathura
          cmdstan
          kooha
          emacs
          exa
          # others
          aspellDicts.en
          aspellDicts.pt_BR
          texlive.combined.scheme-minimal
        ];
      stateVersion = "22.11";
      sessionVariables = {
        EDITOR = "neovim";
        VISUAL = "neovim";
        TERMINAL = "alacritty";
      };
    };
    programs = {
      home-manager.enable = true;
      bat = {
        enable = true;
        config.theme = "Nord";
      };
      fzf = {
        enable = true;
        enableFishIntegration = true;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        nix-direnv.enable = true;
      };
      fish = {
        enable = true;
        shellAliases = {
          mkdir = "mkdir -p";
          cat = "${pkgs.bat}/bin/bat";
          nv = "${pkgs.nvim}/bin/nvim";
          lg = "${pkgs.lazygit}/bin/lazygit";
          ls = "${pkgs.exa}/bin/exa --icons";
          ll = "${pkgs.exa}/bin/exa --icons -l";
          la = "${pkgs.exa}/bin/exa --icons -a";
          lt = "${pkgs.exa}/bin/exa --icons --tree";
          lla = "${pkgs.exa}/bin/exa --icons -la";
        };
        shellAbbrs = {
          stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
          mamba = "${pkgs.micromamba}/bin/micromamba";
        };
        shellInit = ''
          fish_add_path "$HOME/.emacs.d/bin"
          set -gx MAMBA_EXE "${pkgs.micromamba}/bin/micromamba"
          set -gx MAMBA_ROOT_PREFIX "$HOME/micromamba"
          eval "${pkgs.micromamba}/bin/micromamba" shell hook --shell fish --prefix "$HOME/micromamba" | source
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
            plugin = nord-nvim;
            config = "colorscheme nord";
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
                    theme = "nord"
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
            size = 11;
          };
          draw_bold_text_with_bright_colors = true;
          selection.save_to_clipboard = true;
          shell.program = "${pkgs.fish}/bin/fish";
          colors = {
            primary = {
              background = "#2e3440";
              foreground = "#d8dee9";
              dim_foreground = "#a5abb6";
              footer_bar = {
                background = "#434c5e";
                foreground = "#d8dee9";
              };
            };
            cursor = {
              text = "#2e3440";
              cursor = "#d8dee9";
            };
            vi_mode_cursor = {
              text = "#2e3440";
              cursor = "#d8dee9";
            };
            selection = {
              text = "CellForeground";
              background = "#4c566a";
            };
            search = {
              matches = {
                foreground = "CellBackground";
                background = "#88c0d0";
              };
            };
            normal = {
              black = "#3b4252";
              red = "#bf616a";
              green = "#a3be8c";
              yellow = "#ebcb8b";
              blue = "#81a1c1";
              magenta = "#b48ead";
              cyan = "#88c0d0";
              white = "#e5e9f0";
            };
            bright = {
              black = "#4c566a";
              red = "#bf616a";
              green = "#a3be8c";
              yellow = "#ebcb8b";
              blue = "#81a1c1";
              magenta = "#b48ead";
              cyan = "#8fbcbb";
              white = "#eceff4";
            };
            dim = {
              black = "#373e4d";
              red = "#94545d";
              green = "#809575";
              yellow = "#b29e75";
              blue = "#68809a";
              magenta = "#8c738c";
              cyan = "#6d96a5";
              white = "#aeb3bb";
            };
          };
        };
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
    };
    xdg.enable = true;
    xdg.mime.enable = true;
    targets.genericLinux.enable = true;
  };
}
