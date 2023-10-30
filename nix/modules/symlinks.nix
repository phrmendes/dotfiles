{
  home.file = {
    ".default-python-packages".source = ../cfg/default-python-packages;
    ".profile".source = ../cfg/.profile;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
