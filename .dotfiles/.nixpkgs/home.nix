{ config, pkgs, ... }:

let
  user = "prochame";
in
{
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/Users/${user}";
      packages = with pkgs.unstable;
        [
          # CLI apps
          podman
          qemu
          pandoc
          lazygit
          ripgrep
          fd
          sd
          gnupg
          stow
          exa
          sqlite
          jq
          tectonic
          tere
          imagemagick
          ispell
          aspell
          aspellDicts.pt_BR
          aspellDicts.en
          ansible
          gh
          git
          gnumake
          cmake
          gcc
          libgccjit
          zlib
          # terraform
          terraform
          tflint
          terragrunt
          # python
          python311
          python311Packages.ipython
          python311Packages.grip
          python311Packages.black
          python311Packages.pyflakes
          python311Packages.isort
          python311Packages.pytest
          python311Packages.nose
          pipenv
          # go
          go
          gopls
          gotests
          gore
          gotools
          gomodifytags
          delve
          # nix
          rnix-lsp
          nixfmt
          # shell script
          shfmt
          shellcheck
          # latex
          lua53Packages.digestif
          # others
          cargo
          nodejs
        ];
      stateVersion = "22.11";
      sessionVariables = {
        VISUAL = "vim";
      };
    };
    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      bat.enable = true;
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      neovim = {
        enable = true;
        plugins = with pkgs.vimPlugins; [
          nvim-web-devicons
          nvim-tree-lua
          plenary-nvim
          vim-nix
          vim-easymotion
          vim-commentary
          vim-gitgutter
          auto-pairs
          {
            plugin = indent-blankline-nvim;
            config = "lua require('indent_blankline').setup()";
          }
          {
            plugin = nvim-treesitter;
            config = ''
              lua << EOF
              require('nvim-treesitter.configs').setup {
                  highlight = {
                      enable = true,
                      additional_vim_regex_highlighting = false
                  }
              }
              EOF
            '';
          }
          {
            plugin = lualine-nvim;
            config = ''
              lua << EOF
              require('lualine').setup {
                  options = {
                      icons_enabled = true
                  }
              }
              EOF
            '';
          }
        ];
        extraConfig = ''
          set clipboard+=unnamedplus
          set completeopt+=noinsert,menuone,noselect
          set cursorline
          set hidden
          set inccommand=split
          set number
          set relativenumber
          set splitbelow
          set splitright
          set title
          set wildmenu
          set expandtab
          set ttimeoutlen=0
          set shiftwidth=2
          set tabstop=2
          set undofile
          set smartindent
          set tabstop=4
          set shiftwidth=4
          set shiftround
          set expandtab
          set scrolloff=3
        '';
        vimAlias = true;
        vimdiffAlias = true;
      };
    };
  };
}
