{ config, pkgs, lib, ... }:

let user = "phrmendes";
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      bitwarden
      btop
      exa
      fragments
      gh
      hugo
      lazygit
      micromamba
      obsidian
      pandoc
      podman
      quarto
      ripgrep
      spotify
      tectonic
      vlc
      vscode
      zotero
    ];
    stateVersion = "22.11";
    sessionVariables = {
      VISUAL = "nvim";
      TERMINAL = "alacritty";
      SUDO_EDITOR = "nvim";
    };
  };
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
        la = "${pkgs.exa}/bin/exa --icons -a";
        lg = "${pkgs.lazygit}/bin/lazygit";
        ll = "${pkgs.exa}/bin/exa --icons -l";
        lla = "${pkgs.exa}/bin/exa --icons -la";
        ls = "${pkgs.exa}/bin/exa --icons";
        lt = "${pkgs.exa}/bin/exa --icons --tree";
        mamba = "micromamba";
        mkdir = "mkdir -p";
        nix_clean = "nix-collect-garbage";
        nix_update = "home-manager switch";
        rcat = "cat";
        stow_dotfiles = ''
          stow --target="/home/${user}" --dir="/home/${user}/Projects/bkps/" --stow .dotfiles'';
      };
      initExtra = ''
        eval "$(micromamba shell hook --shell=zsh)"
        micromamba deactivate
      '';
    };
    neovim = {
      enable = true;
      withPython3 = true;
      package = pkgs.neovim-unwrapped;
      extraLuaConfig =
        builtins.readFile /home/${user}/.config/nvim/settings.lua;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: [
          p.bash
          p.dockerfile
          p.gitignore
          p.json
          p.latex
          p.lua
          p.markdown
          p.markdown-inline
          p.nix
          p.python
          p.hcl
          p.vim
          p.yaml
        ]))
        ReplaceWithRegister
        alpha-nvim
        auto-pairs
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        copilot-vim
        friendly-snippets
        gitsigns-nvim
        gruvbox
        indent-blankline-nvim
        lazygit-nvim
        lspkind-nvim
        lualine-nvim
        luasnip
        markdown-preview-nvim
        mini-nvim
        neoterm
        null-ls-nvim
        nvim-cmp
        nvim-dap
        nvim-lspconfig
        nvim-spectre
        nvim-tree-lua
        nvim-web-devicons
        plenary-nvim
        tagbar
        telescope-dap-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        telescope-ui-select-nvim
        trouble-nvim
        undotree
        vim-commentary
        vim-gitgutter
        vim-illuminate
        vim-nix
        vim-tmux-navigator
        vim-visual-multi
        which-key-nvim
      ];
      extraPackages = (with pkgs; [
        jq
        lua-language-server
        luajitPackages.luacheck
        nixfmt
        rnix-lsp
        shellcheck
        shfmt
        stylua
        terraform-ls
        universal-ctags
      ]) ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        prettier
      ]);
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = (builtins.fromTOML
        (builtins.readFile /home/${user}/.config/starship/config.toml));
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
  targets.genericLinux.enable = true;
}
