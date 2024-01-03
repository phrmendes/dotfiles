{
  home.file = {
    ".local/share/mc/skins/catppuccin.ini".source = ../dotfiles/mc/catppuccin.ini;
    ".config/mc/ini".source = ../dotfiles/mc/ini;
    ".config/mc/menu".source = ../dotfiles/mc/menu;
    ".config/nvim" = {
      source = ../dotfiles/nvim;
      recursive = true;
    };
  };
}
