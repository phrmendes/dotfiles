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
          pandoc
          bat
          lazygit
          sd
          tealdeer
          stow
          exa
          python310Full
          poetry
          cargo
          go
          nodejs
          podman
          terraform
          terragrunt
          tflint
          qemu
          git
          emacs
          gnumake
        ];
      stateVersion = "22.11";
      sessionVariables = {
        EDITOR = "nvim";
      };
    };
    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      bat = {
        enable = true;
        config.theme = "Nord";
      };
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
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
    };
  };
}
