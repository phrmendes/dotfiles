{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  withHashtag = config.lib.stylix.colors.withHashtag;
  base16-palette =
    withHashtag
    |> lib.filterAttrs (n: _: builtins.match "base0[0-9A-F]" n != null)
    |> lib.mapAttrsToList (name: value: ''${name} = "${value}"'')
    |> lib.concatStringsSep ", ";
  local-plugins =
    inputs.vim-plugins
    |> builtins.readDir
    |> lib.filterAttrs (_: type: type == "directory")
    |> lib.mapAttrs' (
      name: _:
      lib.nameValuePair ".local/share/nvim/site/pack/local/opt/${name}" {
        source = "${inputs.vim-plugins}/${name}";
      }
    );
  treesitter-parsers =
    pkgs.vimPlugins.nvim-treesitter-parsers |> lib.attrValues |> lib.filter lib.isDerivation;
  treesitter-queries = pkgs.runCommand "nvim-treesitter-queries" { } ''
    mkdir -p $out
    ln -s ${pkgs.vimPlugins.nvim-treesitter}/runtime/queries $out/queries
  '';
in
{
  options.neovim.enable = lib.mkEnableOption "enable neovim";

  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      extraPython3Packages = p: with p; [ debugpy ];
      plugins = treesitter-parsers ++ [ treesitter-queries ];
      extraPackages =
        with pkgs;
        [
          # lsp servers
          astro-language-server
          basedpyright
          bash-language-server
          copilot-language-server
          docker-language-server
          dot-language-server
          emmet-language-server
          helm-ls
          just-lsp
          ltex-ls-plus
          lua-language-server
          marksman
          nixd
          simple-completion-language-server
          tailwindcss-language-server
          taplo
          terraform-ls
          typescript-language-server
          vscode-langservers-extracted
          yaml-language-server
          # formatters
          djlint
          nixfmt
          prettier
          ruff
          shellharden
          stylua
          # linters
          shellcheck
          tflint
          # debug
          vscode-js-debug
        ]
        ++ (with beamPackages; [
          elixir-ls
        ]);
    };

    xdg.configFile."nvim/init.lua".enable = false;

    home.file = local-plugins // {
      ".config/nvim".source = symlink "${config.home.homeDirectory}/Projects/dotfiles/neovim/config";
      ".local/share/nvim/site/lua/nix.lua".text = ''
        return {
            base16 = { palette = { ${base16-palette} } },
            luvit_meta = "${pkgs.vimPlugins.luvit-meta}/library",
            typescript = "${pkgs.typescript}/lib/node_modules/typescript/lib",
            vscode_js_debug = "${pkgs.vscode-js-debug}/bin/js-debug",
        }
      '';
    };
  };
}
