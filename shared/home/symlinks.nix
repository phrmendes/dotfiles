{
  home.file = {
    ".local/share/mc/skins/catppuccin.ini".source = ../dotfiles/mc/catppuccin.ini;
    ".config/mc/ini".source = ../dotfiles/mc/ini;
    ".config/mc/menu".source = ../dotfiles/mc/menu;
    ".wezterm.lua".source = ../dotfiles/wezterm.lua;
    ".config/nvim" = {
      source = ../dotfiles/nvim;
      recursive = true;
    };
  };
}
