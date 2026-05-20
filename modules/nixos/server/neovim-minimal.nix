_: {
  modules.nixos.server.neovim-minimal =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        withRuby = false;
        configure = {
          packages.treesitter.start = pkgs.local.nvim-treesitter;
          packages.sidekick.start = [ pkgs.vimPlugins.sidekick-nvim ];
          packages.mini.start = [ pkgs.vimPlugins.mini-nvim ];
          customLuaRC = builtins.readFile ../../../files/neovim/neovim-minimal.lua; # lua
        };
      };

      environment.sessionVariables.EDITOR = "nvim";
      environment.systemPackages = [ pkgs.fd ];
    };
}
