{
  home.file = {
    ".default-python-packages".source = ../cfg/default-python-packages;
    ".profile".source = ../cfg/.profile;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".config/nvim-qt/nvim-qt.conf".source = ../cfg/nvim-qt.conf;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
