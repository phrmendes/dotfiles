{
  home.file = {
    ".profile".source = ../cfg/profile.sh;
    ".wezterm.lua".source = ../cfg/wezterm.lua;
    ".default-python-packages".source = ../cfg/rtx/default-python-packages;
    ".config/sioyek/prefs_user.config".source = ../cfg/sioyek.config;
    ".config/nvim" = {
      source = ../cfg/nvim;
      recursive = true;
    };
  };
}
