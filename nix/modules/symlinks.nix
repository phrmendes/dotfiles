{
  home.file = {
    ".profile".source = ../cfg/profile.sh;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".default-python-packages".source = ../cfg/rtx/default-python-packages;
    ".local/bin/preview" = {
      source = ../cfg/joshuto/preview.sh;
      executable = true;
    };
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
