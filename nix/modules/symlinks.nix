{
  home.file = {
    ".profile".source = ../cfg/.profile;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
    ".local/bin/joshuto_preview.sh" = {
      source = ../cfg/joshuto/preview.sh;
      executable = true;
    };
  };
}
