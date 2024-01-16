{
  home.file = {
    ".config/kitty/get_layouts.py".source = ../dotfiles/kitty/get_layout.py;
    ".config/kitty/pass_keys.py".source = ../dotfiles/kitty/pass_keys.py;
    ".config/mc/ini".source = ../dotfiles/mc/ini;
    ".config/mc/menu".source = ../dotfiles/mc/menu;
    ".config/zellij/config.kdl".source = ../dotfiles/zellij/config.kdl;
    ".local/share/mc/skins/catppuccin.ini".source = ../dotfiles/mc/catppuccin.ini;
    ".config/nvim" = {
      source = ../dotfiles/nvim;
      recursive = true;
    };
  };
}
