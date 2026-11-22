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
      base16 = utils.mkBase16Lua config.lib.stylix.colors;

      nix = ''
        return {
          colors = {
            ${base16}
          },
        }
      '';

      neovim = ''
        return {
          bash = "${pkgs.bashInteractive}/bin/bash",
          luvit_meta = "${pkgs.vimPlugins.luvit-meta}/library",
          sqlite = "${pkgs.sqlite.out}/lib/libsqlite3.so",
        }
      '';
    in
    {
      home.file = {
        ".local/share/nvim/site/lua/nix.lua".text = nix;
        ".local/share/nvim/site/lua/nix/neovim.lua".text = neovim;
      };
    };
}
