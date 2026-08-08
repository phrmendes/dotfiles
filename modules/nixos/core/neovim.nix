{
  modules.nixos.core.neovim = {
    programs.neovim = {
      enable = true;
      withRuby = false;
      configure.customLuaRC = builtins.readFile ../../../files/neovim/neovim-minimal.lua;
    };
  };
}
