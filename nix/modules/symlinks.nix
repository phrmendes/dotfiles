{
  home.file = {
    ".profile".source = ../cfg/profile.sh;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".default-python-packages".source = ../cfg/.default-python-packages;
    ".local/bin/preview" = {
      source = ../cfg/joshuto-preview.sh;
      executable = true;
    };
    ".config/joshuto" = {
      source = ../cfg/joshuto;
      recursive = true;
    };
  };
}
