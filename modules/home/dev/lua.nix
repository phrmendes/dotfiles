{
  flake.modules.homeManager.lua =
    {
      pkgs,
      config,
      osConfig,
      ...
    }:
    let
      inherit (osConfig) utils;
      inherit (config.lib.file) mkOutOfStoreSymlink;
      base16 = utils.mkBase16Lua config.lib.stylix.colors;

      nix = ''
        ---@type Nix
        return {
          colors = {
            ${base16}
          },
        }
      '';

      neovim = ''
        ---@type NixNeovim
        return {
          codelldb = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb",
          luvit_meta = "${pkgs.vimPlugins.luvit-meta}/library",
          sqlite = "${pkgs.sqlite.out}/lib/libsqlite3.so",
        }
      '';

      annotationSrc = name: mkOutOfStoreSymlink "${osConfig.workstation.dotfilesDir}/files/${name}";
    in
    {
      home.file = {
        ".local/share/nvim/site/lua/nix.lua".text = nix;
        ".local/share/nvim/site/lua/nix/neovim.lua".text = neovim;
        ".local/share/nvim/site/lua/nix.d.lua".source = annotationSrc "nix.d.lua";
        ".local/share/nvim/site/lua/nix/neovim.d.lua".source = annotationSrc "nix.neovim.d.lua";
      };
    };
}
