_: {
  modules.homeManager.workstation.neovide =
    { config, ... }:
    {
      programs.neovide = {
        enable = true;
        settings = {
          neovim-bin = "${config.programs.neovim.finalPackage}/bin/nvim";
          frame = "full";
          idle = true;
          tabs = false;
          vsync = true;
          box-drawing.mode = "native";
        };
      };
    };
}
