{ config, pkgs, ... }:

let
  user = "prochame";
in
{
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/Users/${user}";
      packages = with pkgs;
        [
          bat
          lazygit
          fd
          ripgrep
          sd
          tealdeer
          tere
          stow
          exa
          python310Full
          poetry
          go
          nodejs
          podman
          terraform
          terragrunt
          tflint
          qemu
          git
          gnumake
          tectonic
          gopls
          ispell
          aspell
          aspellDicts.en
          aspellDicts.pt_BR
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
            plugin = nord-nvim;
            config = "colorscheme nord";
          }
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
                      icons_enabled = true,
                      theme = 'nord'
                  }
              }
              EOF
            '';
          }
        ];
        extraLuaConfig = ''
          vim.o.background = 'dark'
          vim.o.clipboard = 'unnamedplus'
          vim.o.completeopt = 'noinsert,menuone,noselect'
          vim.o.cursorline = true
          vim.o.hidden = true
          vim.o.inccommand = 'split'
          vim.o.number = true
          vim.o.relativenumber = true
          vim.o.splitbelow = true
          vim.o.splitright = true
          vim.o.title = true
          vim.o.wildmenu = true
          vim.o.expandtab = true
          vim.o.ttimeoutlen = 0
          vim.o.shiftwidth = 2
          vim.o.tabstop = 2
          vim.o.undofile = true
          vim.o.smartindent = true
          vim.o.tabstop = 4
          vim.o.shiftwidth = 4
          vim.o.shiftround = true
          vim.o.expandtab = true
          vim.o.scrolloff = 3
        '';
        vimAlias = true;
        vimdiffAlias = true;
      };
    };
  };
}
